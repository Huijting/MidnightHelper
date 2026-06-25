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
	f:Hide()
	toast = f
	return f
end

function ns.ShowTreasureToast(node)
	if not node or (not node.note and not (node.prereqs and #node.prereqs > 0)) then
		if toast then
			toast:Hide()
		end
		return
	end
	local f = EnsureToast()
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

local function IssueRoute(entry, firstTime)
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
		-- Only pin 1 gets the crazy arrow + travel UI (Rares pattern).
		ns.AddSmartTomTomWay(node.mapID, node.x, node.y, node.name, i > 1, i > 1)
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
	advanceFrame:SetScript("OnEvent", function()
		ScheduleAdvance()
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

-- Slash hook (Core.lua calls this early, like the delve-items handler).
function ns:RunAchievementSlashCommand(msg)
	if msg == "treasures" or msg == "treasure" then
		local entry = ns.ACHIEVEMENT_TREASURES and ns.ACHIEVEMENT_TREASURES[1]
		if not entry then
			print(("%s no treasure achievement data loaded."):format(Prefix()))
			return true
		end
		ns.RouteAchievementTreasures(entry)
		return true
	end
	return false
end
