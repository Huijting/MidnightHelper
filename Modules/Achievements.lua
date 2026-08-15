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

-- Per-achievement visibility (account-wide, saved). A hidden achievement stays
-- fully tracked and routable — it's just dropped from the Achievements-tab list.
-- achHidePrompted remembers which ones we've already offered to hide, so the
-- "all done — hide it?" popup never nags twice.
local function AchVisDB()
	if not ns.db then
		return nil
	end
	ns.db.ui = ns.db.ui or {}
	ns.db.ui.achHidden = ns.db.ui.achHidden or {}
	ns.db.ui.achHidePrompted = ns.db.ui.achHidePrompted or {}
	return ns.db.ui
end

function ns.IsAchievementHidden(achievementID)
	local db = AchVisDB()
	return (db and db.achHidden[achievementID]) and true or false
end

function ns.SetAchievementHidden(achievementID, hidden)
	local db = AchVisDB()
	if not db then
		return
	end
	db.achHidden[achievementID] = hidden and true or nil
	if ns.RefreshAchievementsPanel then
		ns.RefreshAchievementsPanel()
	end
end

-- Global "auto-hide completed" toggle: when on, any fully-completed achievement is
-- folded out of the tab automatically (on top of the per-achievement manual hide).
function ns.IsAchAutoHideDoneEnabled()
	local db = AchVisDB()
	return (db and db.achAutoHideDone) and true or false
end

function ns.SetAchAutoHideDoneEnabled(v)
	local db = AchVisDB()
	if not db then
		return
	end
	db.achAutoHideDone = v and true or nil
	if ns.RefreshAchievementsPanel then
		ns.RefreshAchievementsPanel()
	end
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

--- What to call one node on screen.
---
--- ⚠️ ADDED 15 Aug 2026 for the Coiled Isle. Every hunt before it carried a
--- hand-written `name` per node, harvested along with the coordinates. The Coiled
--- Isle's source does not have them: HandyNotes stores its treasure labels as
--- templates like "{npc:263242}" that only mean something inside its own renderer,
--- so fourteen of twenty-two would have shipped as literal braces on screen.
---
--- The client has the real answer and we were throwing it away — NodeDone calls
--- GetAchievementCriteriaInfoByID and discards its FIRST return, which is the
--- criterion's own name, already in the player's language. Better than anything we
--- could have typed: it cannot drift from the game, and it never needs translating.
---
--- `name` in the data still wins where it exists, because a few older nodes say
--- something more useful than the criterion does ("Triple-Locked Safebox" vs a bare
--- object name), and rewriting those was not worth the churn.
function ns.AchievementNodeName(entry, node)
	if node.name and node.name ~= "" then
		return node.name
	end
	local aid = entry and entry.achievementID
	if aid and node.criteria and GetAchievementCriteriaInfoByID then
		local ok, criteriaString = pcall(GetAchievementCriteriaInfoByID, aid, node.criteria)
		if ok and type(criteriaString) == "string" and criteriaString ~= "" then
			return criteriaString
		end
	end
	return ns:L("ACH_TOAST_FALLBACK")
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

-- Public alias so the Settings tab can label its per-achievement toggles with the
-- live (locale-following) achievement name.
ns.AchievementDisplayName = AchievementName

-- Per-card classification, derived from the data (no extra fields needed):
--   kind: treasure / peak / lore / rare (rare-hunter entries carry no nameKey).
--   feeds-meta: treasures and rares roll up into the zone metas -> Light Up the Night
--   (peaks and lore award renown but are not part of that meta path).
local KIND_COLOR = { treasure = "ffcc00", peak = "66ccff", lore = "cc88ff", rare = "ff6060" }

local function EntryKind(entry)
	local nk = entry and entry.nameKey
	if not nk then
		return "rare"
	end
	if nk:find("^ACH_TREASURE") then
		return "treasure"
	elseif nk:find("^ACH_PEAKS") then
		return "peak"
	elseif nk:find("^ACH_LORE") then
		return "lore"
	end
	return "treasure"
end

local function EntryFeedsMeta(entry)
	if entry and entry.feedsMeta ~= nil then
		return entry.feedsMeta -- expliciete override (Showdown-meta's voeden NIET Light Up the Night)
	end
	local k = EntryKind(entry)
	return k == "treasure" or k == "rare"
end

local function NodeIsElite(node)
	return (node and node.criteria and ns.ELITE_RARE_CRITERIA and ns.ELITE_RARE_CRITERIA[node.criteria]) and true or false
end

-- Coloured "[Type]" prefix for a card title.
local function CardTypeTag(entry)
	local k = EntryKind(entry)
	local label = (ns.L and ns:L("ACH_KIND_" .. k:upper())) or k
	return ("|cff%s[%s]|r "):format(KIND_COLOR[k] or "ffffff", label)
end

-- Renown line for a card: which faction this achievement feeds, plus your live
-- renown level. Faction NAMES come from the API (locale-safe); we only store the
-- major-faction ID per entry. entry.factionMulti = spans all four zone factions
-- (Lore Hunter). Returns nil when there's nothing to show.
local function RenownLineText(entry)
	if entry.factionMulti then
		return ns.L and ns:L("ACH_RENOWN_MULTI") or nil
	end
	local fid = entry.faction
	if not fid or not (C_MajorFactions and C_MajorFactions.GetMajorFactionData) then
		return nil
	end
	local ok, d = pcall(C_MajorFactions.GetMajorFactionData, fid)
	if not ok or type(d) ~= "table" then
		return nil
	end
	local name = d.name or "?"
	if d.isUnlocked == false then
		return ((ns.L and ns:L("ACH_RENOWN_LOCKED_FMT")) or "Renown: %s"):format(name)
	end
	local lvl = math.floor(tonumber(d.renownLevel) or 0)
	return ((ns.L and ns:L("ACH_RENOWN_FMT")) or "Renown: %s (%d)"):format(name, lvl)
end

-- Completion-reward collectible for a card: its name + whether you already own it.
-- IDs come from data (Wowhead-verified); the NAME and COLLECTED state come from the
-- live collection APIs (locale-safe). achievementDone is the fallback "owned" signal
-- for a pet whose battle-pet speciesID we haven't captured in-game yet.
local function RewardName(reward)
	if not reward then
		return nil
	end
	if reward.itemID and C_Item and C_Item.GetItemInfo then
		local nm = C_Item.GetItemInfo(reward.itemID)
		if nm and nm ~= "" then
			return nm
		end
	end
	if reward.kind == "pet" and reward.speciesID and C_PetJournal and C_PetJournal.GetPetInfoBySpeciesID then
		local ok, nm = pcall(C_PetJournal.GetPetInfoBySpeciesID, reward.speciesID)
		if ok and nm and nm ~= "" then
			return nm
		end
	end
	return reward.name
end

local function RewardCollected(reward, achievementDone)
	if not reward then
		return nil
	end
	if reward.kind == "toy" and reward.itemID and PlayerHasToy then
		local ok, has = pcall(PlayerHasToy, reward.itemID)
		if ok then
			return has and true or false
		end
	elseif reward.kind == "mount" and reward.itemID and C_MountJournal and C_MountJournal.GetMountFromItem then
		local ok, mountID = pcall(C_MountJournal.GetMountFromItem, reward.itemID)
		if ok and mountID and C_MountJournal.GetMountInfoByID then
			local info = { C_MountJournal.GetMountInfoByID(mountID) }
			return info[11] and true or false -- 11th return = isCollected
		end
	elseif reward.kind == "pet" and reward.speciesID and C_PetJournal and C_PetJournal.GetNumCollectedInfo then
		local ok, n = pcall(C_PetJournal.GetNumCollectedInfo, reward.speciesID)
		if ok then
			return (tonumber(n) or 0) > 0
		end
	end
	-- No reliable ID yet (e.g. pet without speciesID): the collectible IS the
	-- achievement's completion reward, so "achievement done" implies "owned".
	return achievementDone and true or false
end

local function RewardLineText(entry, achievementDone)
	local r = entry and entry.reward
	if not r then
		return nil
	end
	local name = RewardName(r) or "?"
	local line = ((ns.L and ns:L("ACH_REWARD_FMT")) or "Reward: %s"):format(name)
	if RewardCollected(r, achievementDone) then
		local got = (ns.L and ns:L("ACH_REWARD_COLLECTED")) or "collected"
		return "|TInterface\\RaidFrame\\ReadyCheck-Ready:12:12|t " .. line .. " |cff66dd66(" .. got .. ")|r"
	end
	return line
end

-- Open Blizzard's achievement window straight to one achievement (loads the UI
-- addon on demand). Used by Ctrl-click on a card.
function ns.OpenAchievementWindow(achievementID)
	if not achievementID then
		return
	end
	if _G.OpenAchievementFrameToAchievement then
		_G.OpenAchievementFrameToAchievement(achievementID)
		return
	end
	if ns.LoadBlizzardAddOn then
		ns.LoadBlizzardAddOn("Blizzard_AchievementUI")
	end
	if _G.AchievementFrame and _G.ShowUIPanel and not _G.AchievementFrame:IsShown() then
		_G.ShowUIPanel(_G.AchievementFrame)
	end
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

-- Translate map (0..1) coords on fromMap onto toMap, WITHOUT any external library.
-- We go through world (yard) coords via C_Map (isotropic, comparable across maps)
-- and invert onto toMap by sampling two corners (linear within a zone) — the same
-- technique Core's MHResolveWaypointMap uses. This replaces a borrowed HereBeDragons
-- dependency, so the cross-map re-pin no longer breaks when TomTom/HandyNotes ship
-- an old HBD (or aren't installed at all).
local function TranslateToMap(fromMap, x01, y01, toMap)
	local wx, wy = MapPosToWorld(fromMap, x01, y01)
	if not wx then
		return nil
	end
	local ax, ay = MapPosToWorld(toMap, 0, 0)
	local bx, by = MapPosToWorld(toMap, 1, 1)
	if not (ax and bx) or ax == bx or ay == by then
		return nil
	end
	local nx = (wx - ax) / (bx - ax)
	local ny = (wy - ay) / (by - ay)
	if nx < 0 or nx > 1 or ny < 0 or ny > 1 then
		return nil -- world point isn't inside toMap; caller keeps the original node map
	end
	return nx, ny
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
	local label = p.name and ns:L(p.name) or "?"
	if b._mhIsStep and (p.quest or p.item) and PrereqDone(p) then
		b:SetText(READY_CHECK_ICON .. "|cff808080" .. label .. "|r")
	else
		b:SetText("|cffaaccff->|r " .. label)
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
	return ("|cffffd200%s:|r |c%s%d/%d|r"):format(node.counterName or ns:L("ACH_COUNTER_FALLBACK"), col, have, need)
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
	f.title:SetText(ns.AchievementNodeName(activeEntry, node))
	local cl = CounterLine(node)
	f.body:SetText((node.note and ns:L(node.note) or "") .. (cl and ("\n\n" .. cl) or ""))

	-- Button 1 routes back to the treasure itself (so you never lose it when the
	-- TomTom arrow clears on arrival); the rest are its prerequisites.
	local targets = { { name = (ns:L("ACH_TOAST_CHEST_FMT")):format(ns.AchievementNodeName(activeEntry, node)), mapID = node.mapID, x = node.x, y = node.y } }
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
				ns.AddSmartTomTomWay(p.mapID, p.x, p.y, p.name and ns:L(p.name) or p.name)
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
	-- Not there yet: alleen een STALE toast (andere/geen node) opruimen. Een toast die
	-- al voor DEZE node open staat (bv. handmatig geopend vanuit de SMC-lijst) laten we
	-- staan — anders knippert hij weg zodra de route zich her-evalueert terwijl je nog
	-- ver weg bent (Rob 3 jul: toast verdween bij beweging, 3km van de treasure).
	if not (toast and toast:IsShown() and toast._node == node) then
		ns.ShowTreasureToast(nil)
	end
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
-- Skip support: a node you skip (e.g. a rare that wasn't spawned) is pushed to the
-- back of the route so the arrow moves on to the next one; you still get back to it
-- after the rest. currentLead is the node the arrow is on right now (what Skip acts on).
-- Arrow diagnostics. Toggle in-game with /mh arrowdebug. When on, MH prints a line
-- at each arrow decision (route issue, keepalive tick, combat-end, re-point) showing
-- the real state — route owner, whether TomTom still has a crazy-arrow target, which
-- map you're on, the lead's map, and whether a re-point actually found a waypoint.
-- This turns "the arrow vanished" into traceable data instead of guesswork.
local DEBUG_ARROW = false
local function DBG(fmt, ...)
	if not DEBUG_ARROW then
		return
	end
	local ok, msg = pcall(string.format, fmt, ...)
	print("|cffff66aaMH-DBG:|r " .. (ok and msg or tostring(fmt)))
end
local function PlayerMapID()
	return C_Map and C_Map.GetBestMapForUnit and C_Map.GetBestMapForUnit("player")
end

local skippedNodes = {}
local currentLead

local function NodeKey(n)
	return n and (n.criteria or n.quest or (tostring(n.mapID) .. ":" .. tostring(n.x) .. ":" .. tostring(n.y)))
end

local function IssueRoute(entry, firstTime, silent)
	local done, total, incomplete = ns.GetTreasureProgress(entry)
	local title = AchievementName(entry)
	ns.MH_TomTomClearAll()
	if #incomplete == 0 then
		ns.lastTarget = nil
		routeSig, activeEntry = nil, nil
		skippedNodes, currentLead = {}, nil
		if ns._mhRouteOwner == "achievement" then
			ns._mhRouteOwner = nil
		end
		ArmTreasureToast(nil)
		print((ns:L("ACH_MSG_ALLDONE")):format(Prefix(), title, total))
		return
	end
	-- Order nearest-first, but push any skipped nodes (rares that weren't up) to the
	-- back so the arrow moves on. If everything left is skipped, reset and cycle over.
	do
		local act, skip = {}, {}
		for _, n in ipairs(incomplete) do
			if skippedNodes[NodeKey(n)] then
				skip[#skip + 1] = n
			else
				act[#act + 1] = n
			end
		end
		if #act == 0 then
			skippedNodes = {}
			incomplete = OrderNearest(incomplete)
		else
			incomplete = OrderNearest(act)
			for _, n in ipairs(OrderNearest(skip)) do
				incomplete[#incomplete + 1] = n
			end
		end
	end
	ns._mhRouteOwner = "achievement" -- claim the shared arrow (others stand down)
	if ns.CancelResetRoute then
		ns.CancelResetRoute()
	end
	-- Waypoint order: for the nearest treasure, walk its still-missing steps
	-- (urns/orbs) first so the arrow guides you step-by-step, then the chest, then
	-- the other still-missing treasures. The crazy arrow rides pin 1 only.
	local first = incomplete[1]
	currentLead = first -- what Skip will push to the back
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
		ns.AddSmartTomTomWay(node.mapID, node.x, node.y,
			ns.AchievementNodeName(entry, node), skipTravelUI, skipCrazyArrow)
	end
	local lead = waypoints[1]
	ns.lastTarget = { mapID = lead.mapID, x = lead.x, y = lead.y, name = lead.name }
	routeSig = RouteFingerprint(entry)
	DBG(
		"issue: lead=%s leadMap=%s incomplete=%d firstTime=%s playerMap=%s",
		lead.name or "?",
		tostring(lead.mapID),
		#incomplete,
		tostring(firstTime),
		tostring(PlayerMapID())
	)
	-- NOTE: we deliberately do NOT force a Blizzard SuperTrack waypoint here.
	-- Taking over SuperTracking fights TomTom's crazy arrow and makes it drop at
	-- zone transitions (the Rares route never does this, which is why its arrow
	-- survives). AddSmartTomTomWay already adds a Blizzard backup for genuine
	-- cross-continent targets, and TomTom's own arrow persists across zones.
	if not silent then
		if firstTime then
			print((ns:L("ACH_MSG_ROUTE_START")):format(
				Prefix(), title, done, total, #incomplete, first.name))
		else
			print((ns:L("ACH_MSG_ROUTE_NEXT")):format(Prefix(), first.name, done, total))
		end
		if first.note then
			print((ns:L("ACH_MSG_ROUTE_NOTE")):format(Prefix(), ns:L(first.note)))
		end
		ArmTreasureToast(first)
	end
	-- On an advance you're usually standing on the treasure you just looted, so
	-- TomTom's crazy arrow can stay in its "arrived" state; re-arm it shortly after
	-- on the new target so the big arrow re-points without waiting for you to move.
	if not firstTime and not silent and C_Timer and C_Timer.After and ns.ReassertCrazyArrow then
		C_Timer.After(0.35, ns.ReassertCrazyArrow)
	end
	-- Cross-continent advance fix. If you kill a detour rare while still flying to a
	-- portal (the new lead sits on another continent, e.g. a Voidstorm rare while
	-- you're in Silvermoon), TomTom's crazy arrow can't resolve an off-continent
	-- target and goes blank — and this advance already suppressed the travel UI, so
	-- the portal guidance is gone too. Re-run the travel assistant in travelOnly mode
	-- (no waypoint side effects) so the arrow re-focuses on the portal/HS instead of
	-- vanishing. Gated on cross-continent, so same-continent advances stay untouched.
	if not firstTime and not silent and lead and C_Timer and C_Timer.After then
		local lmap, lx, ly, lname = lead.mapID, lead.x, lead.y, lead.name
		C_Timer.After(0.4, function()
			if
				activeEntry
				and ns._mhRouteOwner == "achievement"
				and ns.AddSmartTomTomWay
				and ns.MHIsCrossContinentFromPlayer
				and ns.MHIsCrossContinentFromPlayer(lmap, lx, ly)
			then
				ns.AddSmartTomTomWay(lmap, lx, ly, lname, false, false, true) -- travelOnly
			end
		end)
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

local mhForcedUid
local mhPrevArrowGone
local mhForcedLeadKey
local mhForcedOnMap
local mhPrevAtLead
-- Put TomTom's crazy arrow on the route's CURRENT LEAD (ns.lastTarget). If the lead
-- lives on another map than you're standing on (e.g. a rare on the Slayer's Rise
-- sub-map while you're on the Voidstorm overworld), TomTom hides the arrow — so we
-- translate the lead onto YOUR current map via C_Map world coordinates (no external
-- library) and pin the arrow there. We follow the LEAD, not raw nearest, so Skip is
-- respected; mute announce so TomTom doesn't spam "Added a waypoint"; and use
-- cleardistance=0 so standing on an un-spawned stop never auto-clears the arrow.
local function ForceArrowToLead()
	local tt = _G.TomTom
	if not (activeEntry and tt and tt.AddWaypoint) then
		return false
	end
	local n = ns.lastTarget
	if not (n and n.mapID) and ns.GetTreasureProgress then
		local _, _, incomplete = ns.GetTreasureProgress(activeEntry)
		n = incomplete and OrderNearest(incomplete)[1]
	end
	if not (n and n.mapID) then
		return false
	end
	local mapID, x01, y01 = n.mapID, (n.x or 0) / 100, (n.y or 0) / 100
	local pmap = PlayerMapID()
	if pmap and pmap ~= n.mapID then
		local tx, ty = TranslateToMap(n.mapID, x01, y01, pmap)
		if tx and ty then
			mapID, x01, y01 = pmap, tx, ty
		end
	end
	local gen = tt.profile and tt.profile.general
	local prevAnnounce = gen and gen.announce
	if gen then
		gen.announce = false
	end
	if mhForcedUid and tt.ClearWaypoint then
		pcall(tt.ClearWaypoint, tt, mhForcedUid)
		mhForcedUid = nil
	end
	local okAdd, uid = pcall(tt.AddWaypoint, tt, mapID, x01, y01, {
		title = n.name or "Route",
		persistent = false,
		minimap = true,
		world = true,
		crazy = true,
		cleardistance = 0,
	})
	if okAdd and uid and tt.SetCrazyArrow then
		mhForcedUid = uid
		pcall(tt.SetCrazyArrow, tt, uid, 15, n.name or "Route")
	end
	if gen then
		gen.announce = prevAnnounce
	end
	local good = (okAdd and uid) and true or false
	DBG("force: arrow on %s via map %s (node map %s) ok=%s", n.name or "?", tostring(mapID), tostring(n.mapID), tostring(good))
	return good
end

-- Restore the big arrow when it has dropped. Prefer pinning it to our own lead
-- (authoritative, Skip-aware, cross-map safe); only if we somehow have no lead at all
-- do we fall back to TomTom's own closest-waypoint search.
local function RepointArrowNearest()
	if ForceArrowToLead() then
		return
	end
	local tt = _G.TomTom
	if not (tt and tt.SetClosestWaypoint) then
		return
	end
	local gen = tt.profile and tt.profile.general
	local prevAnnounce = gen and gen.announce
	if gen then
		gen.announce = false
	end
	pcall(tt.SetClosestWaypoint, tt)
	if gen then
		gen.announce = prevAnnounce
	end
end

local rareWatchTicker, rareIdleTicks
local function StopRareWatch()
	if rareWatchTicker then
		rareWatchTicker:Cancel()
		rareWatchTicker = nil
	end
	rareIdleTicks = 0
end
local function StartRareWatch()
	if rareWatchTicker or not (C_Timer and C_Timer.NewTicker) then
		return
	end
	rareIdleTicks = 0
	rareWatchTicker = C_Timer.NewTicker(2, function()
		if not activeEntry then
			StopRareWatch()
			return
		end
		-- Keep the big arrow alive on our route. TomTom clears a waypoint (and its
		-- crazy arrow) the moment you arrive, and only auto-points at the next one if
		-- the user enabled arrow.setclosest — which many players have off, so the arrow
		-- just vanishes on arrival. We don't rely on that setting: while we own the
		-- arrow, re-point it at the nearest still-open waypoint ourselves every tick
		-- (announce muted to avoid chat spam). MH already adds every open stop as a
		-- waypoint, so this makes the arrow flow to the next treasure/rare on arrival.
		if ns._mhRouteOwner == "achievement" then
			local lt = ns.lastTarget
			-- Keep the big arrow on our lead across the constant sub-zone hops here.
			-- TomTom's crazy arrow only renders when the waypoint sits on the map you're
			-- standing on, so whenever your map changes we re-pin the lead onto the new map
			-- (translated via C_Map) BEFORE it can drop. We also restore it if it drops on
			-- the same map, re-pin when the lead changes (Skip), and re-pin when you walk
			-- off a stop you were parked on. We do NOT re-pin while parked on the lead
			-- (<25yd: an un-spawned rare you walked up to) nor when nothing changed — so
			-- there's no waypoint churn or chat spam.
			local arrowFrame = _G.TomTomCrazyArrow
			local arrowGone = (arrowFrame and arrowFrame.IsShown and not arrowFrame:IsShown()) or false
			local pmap = PlayerMapID()
			local atLead = false
			if lt then
				local pwx, pwy = PlayerWorld()
				local twx, twy = NodeWorld(lt)
				if pwx and twx then
					local dx, dy = pwx - twx, pwy - twy
					atLead = (dx * dx + dy * dy) <= (25 * 25)
				end
			end
			local leadKey = lt and lt.mapID and (tostring(lt.mapID) .. ":" .. tostring(lt.x) .. ":" .. tostring(lt.y))
			local mapChanged = (mhForcedOnMap ~= nil and pmap ~= mhForcedOnMap)
			local leadChanged = (leadKey ~= mhForcedLeadKey)
			local justDropped = (arrowGone and not mhPrevArrowGone)
			local walkedOff = (mhPrevAtLead and not atLead) or false
			if lt and not atLead and (mapChanged or leadChanged or justDropped or walkedOff) then
				DBG(
					"tick: re-pin (mapChg=%s leadChg=%s dropped=%s walkedOff=%s) lead=%s leadMap=%s playerMap=%s",
					tostring(mapChanged),
					tostring(leadChanged),
					tostring(justDropped),
					tostring(walkedOff),
					lt.name or "nil",
					tostring(lt.mapID),
					tostring(pmap)
				)
				RepointArrowNearest()
				mhForcedOnMap = pmap
				mhForcedLeadKey = leadKey
			end
			mhPrevArrowGone = arrowGone
			mhPrevAtLead = atLead
		end
		if ns._mhRouteOwner ~= "rare" then
			rareIdleTicks = 0
			return -- arrow is ours (or free) — nothing to reclaim
		end
		if UnitAffectingCombat and UnitAffectingCombat("player") then
			rareIdleTicks = 0 -- still fighting the rare: let combat-end reclaim it
			return
		end
		local lt = ns.lastTarget
		local near = false
		if lt then
			local pwx, pwy = PlayerWorld()
			local rwx, rwy = NodeWorld(lt)
			if pwx and rwx then
				local dx, dy = pwx - rwx, pwy - rwy
				near = (dx * dx + dy * dy) <= (60 * 60) -- within ~60 yd of the rare
			end
		end
		if near then
			rareIdleTicks = (rareIdleTicks or 0) + 1
			if rareIdleTicks >= 2 then
				-- ~4s parked at the rare's location without fighting: the rare is gone.
				-- Reclaim the arrow for our route (Advance() picks it up on owner==nil).
				rareIdleTicks = 0
				ns._mhRouteOwner = nil
				ScheduleAdvance()
			end
		else
			rareIdleTicks = 0 -- still travelling toward the rare: don't reclaim yet
		end
	end)
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
			if event == "PLAYER_REGEN_ENABLED" and activeEntry then
				DBG(
					"combat-end: owner=%s arrowOnRoute=%s lastTarget=%s playerMap=%s",
					tostring(ns._mhRouteOwner),
					tostring(ArrowIsOnOurRoute(activeEntry, ns.lastTarget)),
					ns.lastTarget and ns.lastTarget.name or "nil",
					tostring(PlayerMapID())
				)
			end
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
			-- Combat-end safety net for the big arrow. ArrowIsOnOurRoute only checks
			-- whether lastTarget is still an open node, NOT whether TomTom's floating
			-- arrow is actually showing — so when you kill a detour rare away from the
			-- lead, the lead is still "open", the reclaim above is skipped, yet TomTom
			-- may have dropped the arrow (cleardistance on a pin you flew past). Once
			-- things settle, re-point the arrow at the nearest open waypoint ourselves.
			-- Idempotent, so if the arrow is already correct nothing visibly changes.
			if event == "PLAYER_REGEN_ENABLED" and activeEntry and C_Timer and C_Timer.After then
				C_Timer.After(0.6, function()
					if activeEntry and ns._mhRouteOwner == "achievement" then
						RepointArrowNearest()
					end
				end)
			end
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
	StartRareWatch()
	skippedNodes, currentLead = {}, nil -- fresh route: forget previous skips
	IssueRoute(entry, true)
end

-- Skip the node the arrow is on right now (e.g. a rare that wasn't spawned): push it
-- to the back of the route and re-point the arrow at the next-nearest open one. You
-- still come back to skipped nodes after the rest (or once you've cycled them all).
-- Public: fully stop the achievement/treasure route (used by ns.ClearActiveRoute /
-- /mh clear). Forgets the route so nothing re-issues, and clears the shared arrow.
function ns.StopAchievementRoute()
	activeEntry, routeSig = nil, nil
	skippedNodes, currentLead = {}, nil
	StopRareWatch()
	if ArmTreasureToast then
		ArmTreasureToast(nil)
	end
	if ns._mhRouteOwner == "achievement" then
		ns._mhRouteOwner = nil
	end
	ns.lastTarget = nil
	ns.MH_TomTomClearAll()
end

function ns.SkipCurrentAchievementNode()
	if not activeEntry then
		print((ns:L("ACH_MSG_SKIP_NONE")):format(Prefix()))
		return
	end
	if currentLead then
		skippedNodes[NodeKey(currentLead)] = true
		print((ns:L("ACH_MSG_SKIP_DONE")):format(Prefix(), currentLead.name or "?"))
	end
	IssueRoute(activeEntry, false)
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
	local shown = 0
	-- Display order: open achievements first, completed ones last (stable within
	-- each group). card.complete is cached by RefreshAchPanel.
	local order = {}
	for _, card in ipairs(st.cards) do
		if not card.complete then
			order[#order + 1] = card
		end
	end
	for _, card in ipairs(st.cards) do
		if card.complete then
			order[#order + 1] = card
		end
	end
	local autoHide = ns.IsAchAutoHideDoneEnabled and ns.IsAchAutoHideDoneEnabled()
	for _, card in ipairs(order) do
		local hidden = ns.IsAchievementHidden(card.entry.achievementID)
			or (autoHide and card.complete)
		if hidden then
			-- Hidden (manually in Settings, or auto-hidden because completed).
			card.header:Hide()
			if card.renown then
				card.renown:Hide()
			end
			if card.reward then
				card.reward:Hide()
			end
			for _, row in ipairs(card.rows) do
				row.frame:Hide()
			end
		else
			shown = shown + 1
			card.header:Show()
			card.header:ClearAllPoints()
			card.header:SetPoint("TOPLEFT", st.child, "TOPLEFT", 0, y)
			card.header:SetWidth(headerW)
			card.arrow:SetText(card.expanded and "-" or "+")
			y = y - 28
			if card.expanded then
				-- Renown line first (faction + level), then the treasure checklist.
				if card.renown and card.renownText and card.renownText ~= "" then
					card.renown:ClearAllPoints()
					card.renown:SetPoint("TOPLEFT", st.child, "TOPLEFT", 20, y)
					card.renown:SetWidth((w > 0 and w - 28) or 340)
					card.renown:Show()
					y = y - 18
				elseif card.renown then
					card.renown:Hide()
				end
				if card.reward and card.rewardText and card.rewardText ~= "" then
					card.reward:ClearAllPoints()
					card.reward:SetPoint("TOPLEFT", st.child, "TOPLEFT", 20, y)
					card.reward:SetWidth((w > 0 and w - 28) or 340)
					card.reward:Show()
					y = y - 18
				elseif card.reward then
					card.reward:Hide()
				end
				for _, row in ipairs(card.rows) do
					row.frame:ClearAllPoints()
					row.frame:SetPoint("TOPLEFT", st.child, "TOPLEFT", 20, y)
					row.frame:SetWidth((w > 0 and w - 28) or 340)
					row.frame:Show()
					y = y - 22
				end
				y = y - 8
			else
				if card.renown then
					card.renown:Hide()
				end
				if card.reward then
					card.reward:Hide()
				end
				for _, row in ipairs(card.rows) do
					row.frame:Hide()
				end
				y = y - 4
			end
		end
	end
	-- Friendly hint if the user hid everything (so the tab isn't just blank).
	if st.allHidden then
		if shown == 0 and #st.cards > 0 then
			st.allHidden:ClearAllPoints()
			st.allHidden:SetPoint("TOPLEFT", st.child, "TOPLEFT", 4, -8)
			st.allHidden:Show()
			y = y - 28
		else
			st.allHidden:Hide()
		end
	end
	st.child:SetHeight(math.max(10, -y + 10))
end

-- "Light Up the Night" meta-achievement (62386) -> Brilliant Petalwing mount (item
-- 252011). We read the meta's progress LIVE from the criteria API (no hardcoded
-- sub-list), so it always matches what WoW counts.
local LIGHT_UP_META = 62386
-- Void Showdown zone metas (rotating biweekly): Naigtal "A Trip Through the Stars"
-- (62874) and Val "A Trip Around the Stars" (62873). Separate top-level metas (no
-- umbrella above them), shown as extra expandable rows so you can track their live
-- sub-achievement progress — rares, world quests, storms, questlines — straight from
-- the criteria API. IDs from Wowhead; GetAchievementInfo reads the real name live, so
-- a wrong ID shows a wrong/blank name (never fabricated data) and gets caught in-game.
local SHOWDOWN_METAS = { 62874, 62873 }
local PETALWING_ITEM = 252011

local function MetaProgress(achievementID)
	if not (GetAchievementNumCriteria and GetAchievementCriteriaInfo) then
		return nil, nil
	end
	local total = GetAchievementNumCriteria(achievementID) or 0
	if total == 0 then
		return nil, nil
	end
	local done = 0
	for i = 1, total do
		local _, _, completed = GetAchievementCriteriaInfo(achievementID, i)
		if completed then
			done = done + 1
		end
	end
	return done, total
end

-- One record per criterion of the "Light Up the Night" meta — i.e. the four zone
-- meta-achievements it requires (Forever Song, Making an Amani Out of You, That's Aln
-- Folks!, Yelling into the Voidstorm). Read entirely from the criteria API: the
-- criterion text is the zone-meta name and its assetID is that zone meta's own
-- achievement, whose sub-progress (done/total) we read live. The UI turns each record
-- into a hoverable/clickable row (tooltip = Blizzard's full criteria breakdown).
-- Read one record per criterion of ANY achievement (its criterion text + assetID).
-- Used for the "Light Up the Night" meta (criteria = the four zone metas) AND, when a
-- zone meta is expanded, for that zone meta's own criteria (= its component achievements).
-- Everything comes straight from the criteria API — no hardcoded/guessed data.
local function CriteriaData(achievementID)
	if not (achievementID and GetAchievementNumCriteria and GetAchievementCriteriaInfo) then
		return nil
	end
	local n = GetAchievementNumCriteria(achievementID) or 0
	if n == 0 then
		return nil
	end
	local out = {}
	for i = 1, n do
		local str, _, completed, _, _, _, _, assetID = GetAchievementCriteriaInfo(achievementID, i)
		local id = (assetID and assetID > 0) and assetID or nil
		local name = (str and str ~= "") and str or nil
		local done, total
		if id then
			if GetAchievementInfo then
				local an = select(2, GetAchievementInfo(id))
				if an and an ~= "" then
					name = an
				end
			end
			if not completed then
				done, total = MetaProgress(id)
			end
		end
		out[#out + 1] = {
			name = name or ("#" .. i),
			completed = completed and true or false,
			achievementID = id,
			done = done,
			total = total,
		}
	end
	return out
end

local function MetaDetailData()
	return CriteriaData(LIGHT_UP_META)
end

local function MountOwnedByItem(itemID)
	if not (itemID and C_MountJournal and C_MountJournal.GetMountFromItem) then
		return false
	end
	local ok, mid = pcall(C_MountJournal.GetMountFromItem, itemID)
	if ok and mid and C_MountJournal.GetMountInfoByID then
		local info = { C_MountJournal.GetMountInfoByID(mid) }
		return info[11] and true or false
	end
	return false
end

-- Add one tooltip line per criterion of an achievement, coloured by its REAL status
-- (green = done, red = not). We build this ourselves instead of GameTooltip:Set-
-- AchievementByID, which renders meta sub-achievements as all-green even when they
-- aren't done.
local function AddAchCriteriaLines(tt, achievementID)
	if not (achievementID and GetAchievementNumCriteria and GetAchievementCriteriaInfo) then
		return
	end
	local n = GetAchievementNumCriteria(achievementID) or 0
	for i = 1, n do
		local cs, _, cc, _, _, _, _, ca = GetAchievementCriteriaInfo(achievementID, i)
		local label = (cs and cs ~= "") and cs or nil
		if (not label) and ca and ca > 0 and GetAchievementInfo then
			local an = select(2, GetAchievementInfo(ca))
			if an and an ~= "" then
				label = an
			end
		end
		label = label or ("#" .. i)
		if cc then
			tt:AddLine("|TInterface\\RaidFrame\\ReadyCheck-Ready:0|t " .. label, 0.45, 0.85, 0.45)
		else
			tt:AddLine("|TInterface\\RaidFrame\\ReadyCheck-NotReady:0|t " .. label, 0.95, 0.45, 0.45)
		end
	end
end

-- Shared tooltip for a meta/zone row: name, description, the accurate per-criterion
-- breakdown, and (for the meta header) the mount reward + a preview hint.
local function MetaRowTooltip(self)
	local d = self.data
	if not (GameTooltip and d) then
		return
	end
	GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
	GameTooltip:SetText(d.name, 1, 0.82, 0.2)
	if d.achievementID and GetAchievementInfo then
		local desc = select(8, GetAchievementInfo(d.achievementID))
		if desc and desc ~= "" then
			GameTooltip:AddLine(desc, 0.9, 0.9, 0.9, true)
		end
	end
	GameTooltip:AddLine(" ")
	AddAchCriteriaLines(GameTooltip, d.achievementID)
	if d.isMeta then
		GameTooltip:AddLine(" ")
		local mountName = (C_Item and C_Item.GetItemInfo and C_Item.GetItemInfo(PETALWING_ITEM)) or "Brilliant Petalwing"
		local icon = (C_Item and C_Item.GetItemIconByID and C_Item.GetItemIconByID(PETALWING_ITEM))
			or "Interface\\Icons\\inv_misc_questionmark"
		local owned = MountOwnedByItem(PETALWING_ITEM)
		GameTooltip:AddLine(
			("|T%s:0|t %s%s"):format(icon, mountName, owned and " |cff66dd66(collected)|r" or ""),
			0.78, 0.86, 1.0
		)
		GameTooltip:AddLine(TL("ACH_META_PREVIEW_HINT"), 0.8, 0.8, 0.8)
	end
	GameTooltip:AddLine(" ")
	GameTooltip:AddLine(TL("ACH_TAB_HINT_LINK"), 0.8, 0.8, 0.8)
	GameTooltip:AddLine(TL("ACH_TAB_HINT_OPEN"), 0.8, 0.8, 0.8)
	GameTooltip:Show()
end

-- Lay out the meta breakdown under the summary: a header row for "Light Up the Night"
-- (with its mount reward) followed by one row per zone meta. Every row is hoverable
-- (accurate tooltip), Shift-click links it, Ctrl-click opens the Blizzard panel, and a
-- plain click on the header previews the Brilliant Petalwing mount. Hidden once done.
local function RefreshMetaDetail(st, metaComplete)
	local box = st and st.metaBox
	if not box then
		return
	end
	st.metaRows = st.metaRows or {}
	st.metaExpanded = st.metaExpanded or {}
	for _, r in ipairs(st.metaRows) do
		r:Hide()
	end
	local list = {}
	-- Light Up the Night block (its 4 zone metas, each expandable). Hidden once the
	-- whole meta is complete (a clean "all done" — the mount is yours).
	local zones = (not metaComplete) and MetaDetailData() or nil
	if zones and #zones > 0 then
		local md, mt = MetaProgress(LIGHT_UP_META)
		local metaName = (GetAchievementInfo and select(2, GetAchievementInfo(LIGHT_UP_META))) or "Light Up the Night"
		list[#list + 1] = {
			name = metaName,
			achievementID = LIGHT_UP_META,
			isMeta = true,
			level = 0,
			completed = (md and mt and md >= mt) or false,
			done = md,
			total = mt,
		}
		-- Each zone meta (Forever Song, …) is an expandable row: click to fold out its
		-- component sub-achievements, read live from that meta's own criteria.
		for _, z in ipairs(zones) do
			z.level = 1
			z.expandable = (z.achievementID ~= nil)
			list[#list + 1] = z
			if z.achievementID and st.metaExpanded[z.achievementID] then
				for _, c in ipairs(CriteriaData(z.achievementID) or {}) do
					c.level = 2
					list[#list + 1] = c
				end
			end
		end
	end
	-- Void Showdown zone metas (Naigtal/Val): separate expandable top-level rows,
	-- shown while not complete. Two live drill-down levels (meta → its sub-achievements
	-- → their own criteria), all from the criteria API.
	for _, metaID in ipairs(SHOWDOWN_METAS) do
		local sdDone, sdTotal = MetaProgress(metaID)
		if sdDone and sdTotal and sdTotal > 0 and sdDone < sdTotal then
			local name = (GetAchievementInfo and select(2, GetAchievementInfo(metaID))) or ("#" .. metaID)
			list[#list + 1] = {
				name = name, achievementID = metaID, level = 0,
				expandable = true, showdown = true, done = sdDone, total = sdTotal,
			}
			if st.metaExpanded[metaID] then
				for _, c in ipairs(CriteriaData(metaID) or {}) do
					c.level = 1
					c.expandable = (c.achievementID ~= nil)
					list[#list + 1] = c
					if c.achievementID and st.metaExpanded[c.achievementID] then
						for _, cc in ipairs(CriteriaData(c.achievementID) or {}) do
							cc.level = 2
							list[#list + 1] = cc
						end
					end
				end
			end
		end
	end
	if #list == 0 then
		box:SetHeight(1)
		return
	end

	local y = 0
	for i, d in ipairs(list) do
		local row = st.metaRows[i]
		if not row then
			row = CreateFrame("Button", nil, box)
			row:SetHeight(14)
			row:RegisterForClicks("AnyUp")
			row.text = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
			row.text:SetPoint("LEFT", row, "LEFT", 0, 0)
			row.text:SetJustifyH("LEFT")
			row:SetScript("OnEnter", MetaRowTooltip)
			row:SetScript("OnLeave", function()
				if GameTooltip then
					GameTooltip:Hide()
				end
			end)
			row:SetScript("OnClick", function(self)
				local d2 = self.data
				local aid = d2 and d2.achievementID
				if not aid then
					return
				end
				if IsShiftKeyDown and IsShiftKeyDown() then
					local link = GetAchievementLink and GetAchievementLink(aid)
					if link and not (ChatEdit_InsertLink and ChatEdit_InsertLink(link)) and ChatFrame_OpenChat then
						ChatFrame_OpenChat(link)
					end
					return
				end
				if IsControlKeyDown and IsControlKeyDown() then
					ns.OpenAchievementWindow(aid)
					return
				end
				if d2.isMeta and ns.PreviewItem then
					ns.PreviewItem(PETALWING_ITEM, "Brilliant Petalwing") -- plain click on header: preview the mount
				elseif d2.expandable then
					achPanelState.metaExpanded[aid] = not achPanelState.metaExpanded[aid]
					if ns.RefreshAchievementsPanel then
						ns.RefreshAchievementsPanel()
					end
				else
					ns.OpenAchievementWindow(aid)
				end
			end)
			st.metaRows[i] = row
		end
		row:ClearAllPoints()
		local indent = (d.level == 2 and 30) or (d.level == 1 and 12) or 0
		row:SetPoint("TOPLEFT", box, "TOPLEFT", indent, -y)
		row:SetPoint("RIGHT", box, "RIGHT", 0, 0)
		row.data = d
		local prog = ""
		if d.done and d.total and d.total > 0 then
			prog = (" |c%s%d/%d|r"):format(d.completed and "ff66dd66" or "ffffcc00", d.done, d.total)
		end
		if d.level == 0 then
			if d.showdown then
				local toggle = (st.metaExpanded[d.achievementID] and "|cffffd200-|r " or "|cffffd200+|r ")
				row.text:SetText(("%s|cff9ec7ff%s|r%s"):format(toggle, d.name, prog))
			else
				row.text:SetText(("|cffffd200%s|r%s |cff8a8a8a(reward: Brilliant Petalwing)|r"):format(d.name, prog))
			end
			y = y + 18
		elseif d.level == 1 then
			local mark = d.completed and "Interface\\RaidFrame\\ReadyCheck-Ready"
				or "Interface\\RaidFrame\\ReadyCheck-NotReady"
			local col = d.completed and "ff9aa0a6" or "ffffffff"
			local toggle = ""
			if d.expandable then
				toggle = (st.metaExpanded[d.achievementID] and "|cffffd200-|r " or "|cffffd200+|r ")
			end
			row.text:SetText(("%s|T%s:12:12|t |c%s%s|r%s"):format(toggle, mark, col, d.name, prog))
			y = y + 16
		else
			local mark = d.completed and "Interface\\RaidFrame\\ReadyCheck-Ready"
				or "Interface\\RaidFrame\\ReadyCheck-NotReady"
			local col = d.completed and "ff808080" or "ffc8c8c8"
			row.text:SetText(("|T%s:11:11|t |c%s%s|r%s"):format(mark, col, d.name, prog))
			y = y + 15
		end
		row:Show()
	end
	box:SetHeight(math.max(1, y))
end

-- Top-of-tab summary: tracked-achievement count, collectibles owned, and the
-- "Light Up the Night" meta progress + its mount reward.
local function RefreshAchSummary()
	local st = achPanelState
	if not st or not st.summary then
		return
	end
	local achDone, achTotal, colOwned, colTotal = 0, 0, 0, 0
	for _, entry in ipairs(ns.ACHIEVEMENT_TREASURES or {}) do
		achTotal = achTotal + 1
		local done, total = ns.GetTreasureProgress(entry)
		local complete = (total > 0 and done >= total)
		if complete then
			achDone = achDone + 1
		end
		if entry.reward then
			colTotal = colTotal + 1
			if RewardCollected(entry.reward, complete) then
				colOwned = colOwned + 1
			end
		end
	end
	local parts = { (TL("ACH_SUMMARY_ACH")):format(achDone, achTotal) }
	if colTotal > 0 then
		parts[#parts + 1] = (TL("ACH_SUMMARY_COLL")):format(colOwned, colTotal)
	end
	-- The meta itself ("Light Up the Night") is rendered as the interactive header row
	-- of the breakdown below (with tooltip + mount preview), so it's only added to this
	-- one-line summary once it's fully complete (a clean "all done" marker).
	local md, mt = MetaProgress(LIGHT_UP_META)
	local metaComplete = false
	if md and mt then
		metaComplete = (md >= mt) or MountOwnedByItem(PETALWING_ITEM)
		if metaComplete then
			local metaName = (GetAchievementInfo and select(2, GetAchievementInfo(LIGHT_UP_META))) or "Light Up the Night"
			parts[#parts + 1] = "|TInterface\\RaidFrame\\ReadyCheck-Ready:12:12|t " .. metaName
		end
	end
	st.summary:SetText(table.concat(parts, "  |cff808080-|r  "))

	-- Meta breakdown rows (header + four zones), hoverable/clickable. Hidden when done.
	RefreshMetaDetail(st, metaComplete)
end

local function RefreshAchPanel()
	local st = achPanelState
	if not st then
		return
	end
	RefreshAchSummary()
	for _, card in ipairs(st.cards) do
		local done, total = ns.GetTreasureProgress(card.entry)
		local complete = (total > 0 and done >= total)
		card.complete = complete -- cached for LayoutAchPanel (sorting + auto-hide)
		local nm = AchievementName(card.entry)
		local tag = CardTypeTag(card.entry) -- coloured [Treasure]/[Telescope]/[Lore]/[Rare]
		if complete then
			-- Green check + dimmed title so a finished achievement reads as "done"
			-- even when the card is collapsed.
			card.title:SetText(tag .. "|TInterface\\RaidFrame\\ReadyCheck-Ready:14:14|t |cff9aa0a6" .. nm .. "|r")
		else
			card.title:SetText(tag .. nm)
		end
		local col = complete and "ff66dd66" or "ffffcc00"
		card.progress:SetText(("|c%s%d/%d|r"):format(col, done, total))
		-- Renown line (faction + live level); LayoutAchPanel shows it when expanded.
		card.renownText = RenownLineText(card.entry)
		if card.renown then
			card.renown:SetText(card.renownText or "")
		end
		-- Reward collectible line (name + collected status); shown when expanded.
		card.rewardText = RewardLineText(card.entry, complete)
		if card.reward then
			card.reward:SetText(card.rewardText or "")
		end
		card.routeBtn:SetText(complete and TL("ACH_TAB_DONE") or TL("ACH_TAB_ROUTE"))
		if complete then
			card.routeBtn:Disable()
		else
			card.routeBtn:Enable()
		end
		for _, row in ipairs(card.rows) do
			local nd = NodeDone(card.entry.achievementID, row.node)
			row.check:SetTexture(nd and CHECK_DONE or CHECK_TODO)
			local label = row.node.name or "?"
			if NodeIsElite(row.node) then
				label = label .. " |cffff8800(" .. TL("ACH_ELITE") .. ")|r" -- elite rare
			end
			if nd then
				row.name:SetText("|cff808080" .. label .. "|r")
			else
				row.name:SetText(label)
			end
			row.wp:SetText(TL("ACH_TAB_WAYPOINT"))
		end
	end
	LayoutAchPanel()
end

-- Public refresh so Settings (visibility toggles) can re-render the tab live.
function ns.RefreshAchievementsPanel()
	RefreshAchPanel()
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
	if st.allHidden then
		st.allHidden:SetText(TL("ACH_TAB_ALL_HIDDEN"))
	end
	if st.routeBtn then
		st.routeBtn:SetText(TL("ACH_TAB_ROUTE_NEAREST"))
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
		if IsShiftKeyDown and IsShiftKeyDown() then
			-- Shift-click: drop the achievement link into chat (standard WoW idiom).
			local link = GetAchievementLink and GetAchievementLink(entry.achievementID)
			if link then
				if not (ChatEdit_InsertLink and ChatEdit_InsertLink(link)) and ChatFrame_OpenChat then
					ChatFrame_OpenChat(link)
				end
			end
			return
		end
		if IsControlKeyDown and IsControlKeyDown() then
			ns.OpenAchievementWindow(entry.achievementID) -- Ctrl-click: open the panel
			return
		end
		card.expanded = not card.expanded
		LayoutAchPanel()
	end)
	header:SetScript("OnEnter", function(self)
		if not GameTooltip then
			return
		end
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		GameTooltip:SetText(AchievementName(entry), 1, 0.82, 0.2)
		if EntryFeedsMeta(entry) then
			GameTooltip:AddLine(TL("ACH_META_TIP"), 1, 0.82, 0.2, true)
		end
		GameTooltip:AddLine(TL("ACH_TAB_HINT_LINK"), 0.8, 0.8, 0.8)
		GameTooltip:AddLine(TL("ACH_TAB_HINT_OPEN"), 0.8, 0.8, 0.8)
		GameTooltip:Show()
	end)
	header:SetScript("OnLeave", function()
		if GameTooltip then
			GameTooltip:Hide()
		end
	end)

	-- Renown line (faction + your level) shown at the top of the expanded checklist.
	card.renown = st.child:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	card.renown:SetJustifyH("LEFT")
	card.renown:SetTextColor(0.95, 0.8, 0.35) -- soft gold
	card.renown:Hide()

	-- Reward line (completion collectible + collected status), under the renown line.
	card.reward = st.child:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	card.reward:SetJustifyH("LEFT")
	card.reward:SetTextColor(0.78, 0.86, 1.0) -- soft blue
	card.reward:Hide()

	for i, node in ipairs(entry.nodes or {}) do
		local row = { node = node }
		local rf = CreateFrame("Frame", nil, st.child)
		rf:SetHeight(20)
		row.frame = rf

		-- Zebra band + hover highlight: the Waypoint button sits far to the right, so a
		-- striped background (and a gold band when you hover the row) makes it obvious
		-- which button belongs to which item across the gap.
		local zebra = rf:CreateTexture(nil, "BACKGROUND", nil, 0)
		zebra:SetAllPoints()
		zebra:SetColorTexture(1, 1, 1, (i % 2 == 0) and 0.06 or 0.0)
		row.hl = rf:CreateTexture(nil, "BACKGROUND", nil, 1)
		row.hl:SetAllPoints()
		row.hl:SetColorTexture(1, 0.82, 0.2, 0.18) -- gold band on hover
		row.hl:Hide()

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

		-- Hover tooltip: always the treasure name, plus its how-to note / item counter /
		-- steps when it has them (reuses the rich note data); a short route hint for the
		-- plain "walk to the chest" treasures so every row is consistently hoverable.
		rf:EnableMouse(true)
		rf:SetScript("OnEnter", function(self)
			if row.hl then
				row.hl:Show()
			end
			if not GameTooltip then
				return
			end
			local n = row.node
			GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
			GameTooltip:SetText(n.name or "?", 1, 0.82, 0.2)
			local hasExtra = false
			if NodeIsElite(n) then
				GameTooltip:AddLine(TL("ACH_ELITE_TIP"), 1, 0.5, 0, true)
				hasExtra = true
			end
			if n.note then
				local body = ns:L(n.note); body = (ns.SanitizeUIFontText and ns.SanitizeUIFontText(body)) or body
				GameTooltip:AddLine(body, 0.9, 0.9, 0.9, true)
				hasExtra = true
			end
			if n.counterName and n.counterNeed then
				GameTooltip:AddLine(("%s x%d"):format(n.counterName, n.counterNeed), 0.7, 0.85, 1.0, true)
				hasExtra = true
			end
			if type(n.prereqs) == "table" then
				for _, p in ipairs(n.prereqs) do
					GameTooltip:AddLine("- " .. (p.name and ns:L(p.name) or "?"), 0.7, 0.85, 1.0, true)
				end
				hasExtra = true
			end
			if not hasExtra then
				GameTooltip:AddLine(TL("ACH_TAB_ROW_HINT"), 0.6, 0.6, 0.6, true)
			end
			GameTooltip:Show()
		end)
		rf:SetScript("OnLeave", function()
			if row.hl then
				row.hl:Hide()
			end
			if GameTooltip then
				GameTooltip:Hide()
			end
		end)

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

	-- At-a-glance summary line (achievements done, collectibles owned, meta progress).
	local summary = panel:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	summary:SetPoint("TOPLEFT", intro, "BOTTOMLEFT", 0, -6)
	summary:SetPoint("RIGHT", panel, "RIGHT", -16, 0)
	summary:SetJustifyH("LEFT")

	-- Live breakdown of the four zone metas that feed "Light Up the Night": a column of
	-- hoverable/clickable rows just under the summary. Hidden once the meta is complete.
	local metaBox = CreateFrame("Frame", nil, panel)
	metaBox:SetPoint("TOPLEFT", summary, "BOTTOMLEFT", 8, -4)
	metaBox:SetPoint("RIGHT", panel, "RIGHT", -16, 0)
	metaBox:SetHeight(1)

	-- One-click route to the nearest still-open node across all achievements.
	local routeNearestBtn = CreateFrame("Button", nil, panel, "UIPanelButtonTemplate")
	routeNearestBtn:SetSize(170, 20)
	routeNearestBtn:SetPoint("TOPLEFT", metaBox, "BOTTOMLEFT", -8, -6)
	routeNearestBtn:SetText(TL("ACH_TAB_ROUTE_NEAREST"))
	routeNearestBtn:SetScript("OnClick", function()
		if ns.RouteNearestOpenAchievement then
			ns.RouteNearestOpenAchievement()
		end
	end)

	local scroll = CreateFrame("ScrollFrame", nil, panel, "UIPanelScrollFrameTemplate")
	scroll:SetPoint("TOPLEFT", routeNearestBtn, "BOTTOMLEFT", 0, -8)
	scroll:SetPoint("BOTTOMRIGHT", panel, "BOTTOMRIGHT", -28, 12)
	local child = CreateFrame("Frame", nil, scroll)
	child:SetSize(1, 1)
	scroll:SetScrollChild(child)
	scroll:SetScript("OnSizeChanged", function()
		LayoutAchPanel()
	end)

	achPanelState = { panel = panel, scroll = scroll, child = child, intro = intro, summary = summary, metaBox = metaBox, metaRows = {}, routeBtn = routeNearestBtn, cards = {} }

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
		-- Shown only when every card is hidden via Settings (kept hidden otherwise).
		local allHidden = child:CreateFontString(nil, "OVERLAY", "GameFontDisableLarge")
		allHidden:SetJustifyH("LEFT")
		allHidden:SetText(TL("ACH_TAB_ALL_HIDDEN"))
		allHidden:Hide()
		achPanelState.allHidden = allHidden
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

--------------------------------------------------------------------------------
-- "All done — hide it?" prompt. When you finish a tracked achievement we offer
-- to fold its (now-completed) card away. Always-on (works even if you never
-- opened the tab) and asked at most once per achievement.
--------------------------------------------------------------------------------
-- Add our dialog by INDEXING the table — never reassign the StaticPopupDialogs
-- global (StaticPopupDialogs = ...), as that taints the global and can later block
-- protected calls such as SpellBookFrame:Show() via the AssistedCombat path.
StaticPopupDialogs["MIDNIGHTHELPER_ACH_HIDE"] = {
	text = "%s",
	button1 = "Hide",
	button2 = "Keep showing",
	OnAccept = function(_, data)
		if data and data.id and ns.SetAchievementHidden then
			ns.SetAchievementHidden(data.id, true)
		end
	end,
	timeout = 0,
	whileDead = true,
	hideOnEscape = true,
	preferredIndex = 3, -- avoid UI taint on the default popup slots
}

local function ShowAchHidePrompt(entry)
	if not (entry and StaticPopup_Show) then
		return
	end
	local db = AchVisDB()
	local id = entry.achievementID
	if not db or db.achHidden[id] or db.achHidePrompted[id] then
		return -- already hidden, or we already asked once
	end
	db.achHidePrompted[id] = true
	local dlg = StaticPopupDialogs["MIDNIGHTHELPER_ACH_HIDE"]
	dlg.text = (ns.L and ns:L("ACH_HIDE_PROMPT")) or "%s is complete! Hide it?"
	dlg.button1 = (ns.L and ns:L("ACH_HIDE_BTN_HIDE")) or "Hide"
	dlg.button2 = (ns.L and ns:L("ACH_HIDE_BTN_KEEP")) or "Keep showing"
	StaticPopup_Show("MIDNIGHTHELPER_ACH_HIDE", AchievementName(entry), nil, { id = id })
end

do
	local f = CreateFrame("Frame")
	f:RegisterEvent("ACHIEVEMENT_EARNED")
	f:SetScript("OnEvent", function(_, _, achID)
		if not achID then
			return
		end
		for _, entry in ipairs(ns.ACHIEVEMENT_TREASURES or {}) do
			if entry.achievementID == achID then
				ShowAchHidePrompt(entry)
				return
			end
		end
	end)
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

-- Route to the achievement whose nearest still-open node is closest to you (across
-- all tracked, non-hidden achievements). Prefers one with open nodes in your current
-- zone; otherwise picks by world-distance. Reuses RouteAchievementTreasures, which
-- itself orders nearest-first from where you stand.
function ns.RouteNearestOpenAchievement()
	local list = ns.ACHIEVEMENT_TREASURES or {}
	local pm = C_Map and C_Map.GetBestMapForUnit and C_Map.GetBestMapForUnit("player")
	local pwx, pwy = PlayerWorld()
	local bestEntry, bestDist, sameZoneEntry, anyOpen
	for _, entry in ipairs(list) do
		if not ns.IsAchievementHidden(entry.achievementID) then
			local _, _, incomplete = ns.GetTreasureProgress(entry)
			for _, node in ipairs(incomplete) do
				anyOpen = anyOpen or entry
				if pm and node.mapID == pm and not sameZoneEntry then
					sameZoneEntry = entry
				end
				local nwx, nwy = NodeWorld(node)
				if pwx and nwx then
					local dx, dy = pwx - nwx, pwy - nwy
					local d = dx * dx + dy * dy
					if not bestDist or d < bestDist then
						bestDist, bestEntry = d, entry
					end
				end
			end
		end
	end
	local target = sameZoneEntry or bestEntry or anyOpen
	if target then
		ns.RouteAchievementTreasures(target)
	else
		print(("%s %s"):format(Prefix(), TL("ACH_TAB_ALLDONE")))
	end
end

--- Route een hunt op achievement-id — voor knoppen buiten de Achievements-tab.
---
--- ⚠️ TOEGEVOEGD 15 aug 2026 voor de Codex: het Honored Dead-artikel somt twaalf
--- coördinaten op als tekst, terwijl dezelfde twaalf al een routed hunt zijn in de
--- Achievements-tab. Rob: "ik zie geen route knop om ze in een keer te volgen."
--- Terecht — een lijst die je moet overtypen naast een route die al bestaat is
--- dubbel werk voor de lezer. Dit is bewust een dunne slag om de bestaande
--- machinerie: zelfde route, zelfde pijl, zelfde skip-gedrag.
function ns.RouteAchievementHuntById(achievementID)
	if not achievementID then
		return false
	end
	for _, entry in ipairs(ns.ACHIEVEMENT_TREASURES or {}) do
		if entry.achievementID == achievementID then
			ns.RouteAchievementTreasures(entry)
			return true
		end
	end
	return false
end

-- Slash hook (Core.lua calls this early, like the delve-items handler).
function ns:RunAchievementSlashCommand(msg)
	if msg == "treasures" or msg == "treasure" then
		local entry = ns.PickTreasureEntryForZone()
		if not entry then
			print((TL("ACH_MSG_NODATA")):format(Prefix()))
			return true
		end
		ns.RouteAchievementTreasures(entry)
		return true
	end
	if msg == "skip" or msg == "next" then
		-- During a rare hunt the arrow is a Rares route; skip the current rare instead.
		if ns._mhRouteOwner == "rare" and ns.SkipCurrentRare then
			ns.SkipCurrentRare()
		else
			ns.SkipCurrentAchievementNode()
		end
		return true
	end
	if msg == "arrowdebug" or msg == "debug" then
		DEBUG_ARROW = not DEBUG_ARROW
		print(("|cffffff78Midnight Helper:|r arrow-debug %s"):format(DEBUG_ARROW and "AAN" or "UIT"))
		return true
	end
	return false
end
-- end of Achievements module
