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

-- A prerequisite step counts as "collected" when its quest is flagged complete
-- or its token item is in your bags. Steps without either (vendors, altars w/o a
-- quest, etc.) are never auto-tracked. Defined here so both the route and the
-- live toast checklist can use it.
local function PrereqDone(p)
	if p.quest and C_QuestLog and C_QuestLog.IsQuestFlaggedCompleted then
		local ok, d = pcall(C_QuestLog.IsQuestFlaggedCompleted, p.quest)
		if ok and d then
			return true
		end
	end
	if p.item then
		local getCount = (C_Item and C_Item.GetItemCount) or _G.GetItemCount
		if getCount then
			local ok, c = pcall(getCount, p.item)
			if ok and type(c) == "number" and c > 0 then
				return true
			end
		end
	end
	return false
end

--------------------------------------------------------------------------------
-- Hint toast: a small dismissable popup for the treasure you're routed to, with
-- what to do first and a waypoint button per missing prerequisite. Stays until
-- you close it (no auto-fade); replaced when the route advances.
--------------------------------------------------------------------------------
local toast

-- Live checklist styling: a collected step (urn/orb/node) gets a green check and
-- is dimmed; everything else keeps the blue "->" route marker.
local READY_CHECK_ICON = "|TInterface\\RaidFrame\\ReadyCheck-Ready:14:14|t "
local function StyleToastButton(b)
	local p = b._mhTarget
	if not p then
		return
	end
	if b._mhIsStep and (p.quest or p.item) and PrereqDone(p) then
		b:SetText(READY_CHECK_ICON .. "|cff808080" .. (p.name or "?") .. "|r")
	else
		b:SetText("|cffaaccff->|r " .. (p.name or "?"))
	end
end

-- Live progress line for a "collect N of an item" treasure (e.g. 150x Crystalized
-- Resin Fragment for the Peculiar Cauldron). Returns nil for normal treasures.
local function CounterLine(node)
	if not (node and node.counterItem) then
		return nil
	end
	local getCount = (C_Item and C_Item.GetItemCount) or _G.GetItemCount
	local have = (getCount and getCount(node.counterItem)) or 0
	local need = node.counterNeed or 0
	local col = (need > 0 and have >= need) and "ff66dd66" or "ffffcc00"
	return ("|cffffd200%s:|r |c%s%d/%d|r"):format(node.counterName or "Items", col, have, need)
end

local function RefreshToastSteps()
	if not (toast and toast:IsShown() and toast.btns) then
		return
	end
	for _, b in ipairs(toast.btns) do
		if b:IsShown() then
			StyleToastButton(b)
		end
	end
	local node = toast._node
	if node and node.counterItem then
		local cl = CounterLine(node)
		toast.body:SetText((node.note or "") .. (cl and ("\n\n" .. cl) or ""))
	end
end

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
	f:SetScript("OnDragStop", function(self)
		self:StopMovingOrSizing()
		local p, _, rp, x, y = self:GetPoint()
		if p and ns.db and ns.db.ui then
			ns.db.ui.treasureToastPos = { p, rp, x, y } -- remembered across reloads
		end
	end)
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
	-- Restore the last dragged position so it stops re-appearing mid-screen.
	local pos = ns.db and ns.db.ui and ns.db.ui.treasureToastPos
	if type(pos) == "table" and pos[1] then
		f:ClearAllPoints()
		f:SetPoint(pos[1], UIParent, pos[2] or pos[1], pos[3] or 0, pos[4] or 0)
	end
	-- Auto-close once its treasure is completed, independent of any active route
	-- (so it also works when opened by hand from the tab's Waypoint button).
	f:RegisterEvent("CRITERIA_UPDATE")
	f:RegisterEvent("QUEST_LOG_UPDATE")
	f:RegisterEvent("QUEST_TURNED_IN")
	f:RegisterEvent("ACHIEVEMENT_EARNED")
	f:RegisterEvent("BAG_UPDATE") -- collecting an urn token recolors its checklist row
	f:SetScript("OnEvent", function()
		RefreshToastSteps() -- tick off collected steps live
		if ns.MaybeCloseTreasureToast then
			ns.MaybeCloseTreasureToast()
		end
	end)
	f:Hide()
	toast = f
	return f
end

function ns.ShowTreasureToast(node)
	if not node or (not node.note and not node.counterItem and not (node.prereqs and #node.prereqs > 0)) then
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
	local cl = CounterLine(node)
	f.body:SetText((node.note or "") .. (cl and ("\n\n" .. cl) or ""))

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
		b._mhTarget = p
		b._mhIsStep = (i > 1) -- targets[1] is the chest itself, not a trackable step
		StyleToastButton(b)
		b:SetScript("OnClick", function()
			if ns.AddSmartTomTomWay then
				ns.AddSmartTomTomWay(p.mapID, p.x, p.y, p.name)
			end
		end)
		b:Show()
		prev = b
	end

	local bodyH = ((node.note or node.counterItem) and (f.body:GetStringHeight() or 24)) or 0
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

-- Proximity-gated toast: instead of popping the hint the moment you start the
-- route (often mid-screen and far from where you need it), arm it and only show
-- it once you're within ~250 yds of the treasure. Shows immediately if you're
-- already close or distance can't be measured.
local TOAST_NEAR_YARDS = 250
local pendingToastNode, toastProxTicker

local function StopToastProx()
	if toastProxTicker then
		toastProxTicker:Cancel()
		toastProxTicker = nil
	end
end

local function ToastNodeNear(node)
	-- Farming treasures with a live counter (e.g. the Peculiar Cauldron) show as
	-- soon as you're in the zone, so the progress tracker stays up while you roam
	-- the whole river — not just within 250 yds of the cauldron.
	if node.counterItem then
		local pm = C_Map and C_Map.GetBestMapForUnit and C_Map.GetBestMapForUnit("player")
		if pm and node.mapID and (pm == node.mapID
			or (ns.MHSameZoneOrSub and ns.MHSameZoneOrSub(pm, node.mapID))) then
			return true
		end
	end
	local pwx, pwy = PlayerWorld()
	if not pwx then
		return true -- can't measure: don't keep it hidden forever
	end
	-- Pop only when you're actually close to the chest OR one of its steps
	-- (urns/orbs/altars) — whichever you reach first brings up the full toast.
	local function within(mapID, x, y)
		local wx, wy = MapPosToWorld(mapID, (x or 0) / 100, (y or 0) / 100)
		if not wx then
			return false
		end
		local dx, dy = pwx - wx, pwy - wy
		return math.sqrt(dx * dx + dy * dy) <= TOAST_NEAR_YARDS
	end
	if within(node.mapID, node.x, node.y) then
		return true
	end
	for _, p in ipairs(node.prereqs or {}) do
		if within(p.mapID, p.x, p.y) then
			return true
		end
	end
	return false
end

local function ArmTreasureToast(node)
	pendingToastNode = nil
	StopToastProx()
	if not node or (not node.note and not node.counterItem and not (node.prereqs and #node.prereqs > 0)) then
		ns.ShowTreasureToast(nil) -- nothing to hint: make sure any old toast is gone
		return
	end
	if ToastNodeNear(node) then
		ns.ShowTreasureToast(node)
		return
	end
	-- Not there yet: hide any stale toast and watch our distance.
	ns.ShowTreasureToast(nil)
	pendingToastNode = node
	if C_Timer and C_Timer.NewTicker then
		toastProxTicker = C_Timer.NewTicker(2, function()
			if not pendingToastNode then
				StopToastProx()
				return
			end
			if ToastNodeNear(pendingToastNode) then
				ns.ShowTreasureToast(pendingToastNode)
				pendingToastNode = nil
				StopToastProx()
			end
		end)
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

-- Trackable, still-missing prerequisite steps of a treasure (nearest first), so
-- the arrow can guide you step-by-step before pointing at the chest.
local function PendingTrackedPrereqs(node)
	local pending = {}
	for _, p in ipairs(node.prereqs or {}) do
		if (p.quest or p.item) and not PrereqDone(p) then
			pending[#pending + 1] = p
		end
	end
	-- Most treasures: nearest-first. Some (e.g. the Malignant Chest) must be done
	-- in a fixed sequence, so keep the data order for those.
	if #pending > 1 and not node.orderedPrereqs then
		pending = OrderNearest(pending)
	end
	return pending
end

-- Route fingerprint: which treasures are still missing AND which tracked steps
-- are still uncollected. Position-independent, so it only changes when you
-- actually loot a treasure or collect a step (not merely by moving around).
local function RouteFingerprint(entry)
	local _, _, incomplete = ns.GetTreasureProgress(entry)
	local t = {}
	for _, n in ipairs(incomplete) do
		t[#t + 1] = "c" .. tostring(n.criteria or n.quest or "?")
		for _, p in ipairs(n.prereqs or {}) do
			if (p.quest or p.item) and not PrereqDone(p) then
				t[#t + 1] = "p" .. tostring(p.quest or p.item)
			end
		end
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
		ArmTreasureToast(nil)
		print(("%s %s — all %d treasures done."):format(Prefix(), title, total))
		return
	end
	incomplete = OrderNearest(incomplete)
	ns._mhRouteOwner = "achievement" -- claim the shared arrow (others stand down)
	if ns.CancelResetRoute then
		ns.CancelResetRoute()
	end
	-- Waypoint order: for the nearest treasure, walk its still-missing steps
	-- (urns/orbs) first so the arrow guides you step-by-step, then the chest, then
	-- the other still-missing treasures. The crazy arrow rides pin 1 only.
	local first = incomplete[1]
	local pending = PendingTrackedPrereqs(first)
	local waypoints = {}
	for _, p in ipairs(pending) do
		waypoints[#waypoints + 1] = p
	end
	waypoints[#waypoints + 1] = first -- the chest itself (always shown)
	for i = 2, #incomplete do
		waypoints[#waypoints + 1] = incomplete[i]
	end

	for i, node in ipairs(waypoints) do
		-- Signature: AddSmartTomTomWay(map, x, y, name, skipTravelUI, skipCrazyArrow).
		-- Crazy arrow only on pin 1 (the nearest step/treasure). The travel assistant
		-- (portal / HS popup) fires only on the FIRST route's pin 1 — advancing, or a
		-- silent zone re-assert, must never nag a portal. This also avoids a false
		-- "go to <zone>" suggestion from sub-maps where "are you in the zone?" reads
		-- false against the main map.
		local isLead = (i == 1)
		local skipCrazyArrow = not isLead
		local skipTravelUI = (not isLead) or (not firstTime)
		-- Use TomTom's default cleardistance (like the Rares route): a custom
		-- cleardistance of 0 suppressed TomTom's big floating Crazy Arrow. TomTom's
		-- "auto-set to next closest waypoint" advances the arrow as you reach pins.
		ns.AddSmartTomTomWay(node.mapID, node.x, node.y, node.name, skipTravelUI, skipCrazyArrow)
	end
	local lead = waypoints[1]
	ns.lastTarget = { mapID = lead.mapID, x = lead.x, y = lead.y, name = lead.name }
	routeSig = RouteFingerprint(entry)
	-- NOTE: we deliberately do NOT force a Blizzard SuperTrack waypoint here.
	-- Taking over SuperTracking fights TomTom's crazy arrow and makes it drop at
	-- zone transitions (the Rares route never does this, which is why its arrow
	-- survives). AddSmartTomTomWay already adds a Blizzard backup for genuine
	-- cross-continent targets, and TomTom's own arrow persists across zones.
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
		ArmTreasureToast(first)
	end
	-- On an advance you're usually standing on the treasure you just looted, so
	-- TomTom's crazy arrow can stay in its "arrived" state; re-arm it shortly after
	-- on the new target so the big arrow re-points without waiting for you to move.
	if not firstTime and not silent and C_Timer and C_Timer.After and ns.ReassertCrazyArrow then
		C_Timer.After(0.35, ns.ReassertCrazyArrow)
	end
end

local function Advance()
	if not activeEntry then
		return
	end
	local owner = ns._mhRouteOwner
	if owner == nil then
		-- The shared arrow was freed (e.g. a rare hunt just finished) — reclaim it
		-- for our still-active treasure route. We keep activeEntry across the detour
		-- so the route resumes on its own instead of being forgotten.
		IssueRoute(activeEntry, false)
		return
	end
	if owner ~= "achievement" then
		return -- another route holds the arrow right now; wait without forgetting ours
	end
	if RouteFingerprint(activeEntry) ~= routeSig then
		IssueRoute(activeEntry, false) -- a treasure looted or a step collected: advance
	end
end

local function ScheduleAdvance()
	if not activeEntry or advancePending then
		return
	end
	advancePending = true
	if C_Timer and C_Timer.After then
		C_Timer.After(0.3, function() -- short debounce: coalesce event bursts but
			advancePending = false -- keep the arrow snappy when a step/treasure is done
			Advance()
		end)
	else
		advancePending = false
		Advance()
	end
end

-- On a zone change, refresh ONLY the travel assistant (next-leg portal/HS advice)
-- via AddSmartTomTomWay's travelOnly mode — this never touches the waypoints, so
-- TomTom's arrow keeps persisting. Without it you'd have to re-click the route
-- after each portal/hearth to get the next leg's advice (e.g. arriving in SMC and
-- needing the Portal to Voidstorm).
local travelRefreshPending
local function ScheduleTravelRefresh()
	if not activeEntry or travelRefreshPending then
		return
	end
	if ns._mhRouteOwner and ns._mhRouteOwner ~= "achievement" then
		return
	end
	travelRefreshPending = true
	local function go()
		travelRefreshPending = false
		local t = ns.lastTarget
		if activeEntry and ns._mhRouteOwner == "achievement" and t and ns.AddSmartTomTomWay then
			ns.AddSmartTomTomWay(t.mapID, t.x, t.y, t.name, false, false, true) -- travelOnly
		end
	end
	if C_Timer and C_Timer.After then
		C_Timer.After(0.7, go) -- let the map settle after the load screen
	else
		go()
	end
end

-- True if the live arrow target (ns.lastTarget) is one of this achievement's
-- still-missing treasures or tracked steps. Lets us tell "arrow is on our route"
-- from "a rare detour took the arrow" without relying on quest-flag timing.
local function ArrowIsOnOurRoute(entry, lt)
	if not (entry and lt) then
		return false
	end
	local function same(a)
		return a and a.mapID == lt.mapID
			and math.abs((a.x or 0) - (lt.x or 0)) < 0.05
			and math.abs((a.y or 0) - (lt.y or 0)) < 0.05
	end
	local _, _, incomplete = ns.GetTreasureProgress(entry)
	for _, n in ipairs(incomplete) do
		if same(n) then
			return true
		end
		for _, p in ipairs(n.prereqs or {}) do
			if same(p) then
				return true
			end
		end
	end
	return false
end

local function EnsureAdvanceFrame()
	if advanceFrame then
		return
	end
	advanceFrame = CreateFrame("Frame")
	-- Loot/criteria events advance the arrow to the next treasure as you collect
	-- them. Zone-change events only refresh the travel assistant (next-leg portal
	-- advice) WITHOUT re-issuing waypoints, so TomTom's arrow persists across zones.
	advanceFrame:RegisterEvent("QUEST_LOG_UPDATE")
	advanceFrame:RegisterEvent("QUEST_TURNED_IN")
	advanceFrame:RegisterEvent("QUEST_REMOVED")
	advanceFrame:RegisterEvent("CRITERIA_UPDATE")
	advanceFrame:RegisterEvent("ACHIEVEMENT_EARNED")
	advanceFrame:RegisterEvent("BAG_UPDATE") -- collecting a token item (urns) advances the step
	advanceFrame:RegisterEvent("PLAYER_REGEN_ENABLED") -- left combat (e.g. killed a detour rare)
	advanceFrame:RegisterEvent("ZONE_CHANGED_NEW_AREA")
	advanceFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
	advanceFrame:SetScript("OnEvent", function(_, event)
		if event == "ZONE_CHANGED_NEW_AREA" or event == "PLAYER_ENTERING_WORLD" then
			ScheduleTravelRefresh()
		else
			if event == "PLAYER_REGEN_ENABLED" and activeEntry
				and ns._mhRouteOwner ~= "reset" and ns._mhRouteOwner ~= "treasure"
				and not ArrowIsOnOurRoute(activeEntry, ns.lastTarget) then
				-- Left combat (likely killed a detour rare) and the arrow drifted off
				-- our route — reclaim it, regardless of quest-flag timing. Only fires
				-- when the arrow actually isn't ours, so random mob kills don't flicker.
				ns._mhRouteOwner = nil
			end
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
		local nm = AchievementName(card.entry)
		if complete then
			-- Green check + dimmed title so a finished achievement reads as "done"
			-- even when the card is collapsed.
			card.title:SetText("|TInterface\\RaidFrame\\ReadyCheck-Ready:14:14|t |cff9aa0a6" .. nm .. "|r")
		else
			card.title:SetText(nm)
		end
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
	local card = { entry = entry, rows = {}, expanded = false } -- collapsed until clicked

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
