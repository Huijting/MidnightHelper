local _, ns = ...

--[[
	Midnight Helper — Mount run: old raids you can solo for a mount (`/mh mountrun`).

	Rob, 15 Oct 2026: "we doen 2" (old raids for mounts), then "doe optie 2 maar": a window that says, per raid,
	which of its mounts you still miss and whether you can still try it THIS WEEK, plus how to get there and an arrow
	to the entrance. Both live answers come from the client, so they cannot go stale:
	  - collected or not: C_MountJournal.GetMountInfoByID (11th return, isCollected);
	  - this week's lockout: GetSavedInstanceInfo (instanceId + difficultyId) and, per boss,
	    GetSavedInstanceEncounterInfo (bossName, isKilled) — the same data /raidinfo shows.
	What CAN go stale is the hand-written part: drop chances, the route lines, which difficulty drops what. That is
	why the window says where the numbers come from, and why it does not try to plan a trip across the world
	(the Mount Route Planner addon does that; MH stays an explainer). The entrance arrow only works once you are in
	the right zone, which the "how to get there" line gets you to.

	Data: RAIDS below (mh-research 15 Oct 2026: Wowhead drop data, wago DB2, Zygor). Per raid: the instance map id
	that GetSavedInstanceInfo returns, the difficulties that can drop the mount, the boss name as the lockout lists
	it (English; on another client language the boss match falls back to "x/y bosses killed"), the zone uiMap +
	entrance x/y, and the mounts (mountID for the journal, chance text).
]]

local ui

--------------------------------------------------------------------------------
-- Live reads from the client
--------------------------------------------------------------------------------

--- name, collected (true/false/nil when the journal cannot say)
local function MountState(mountID)
	if not (mountID and C_MountJournal and C_MountJournal.GetMountInfoByID) then
		return nil, nil
	end
	local r = { pcall(C_MountJournal.GetMountInfoByID, mountID) }
	if not r[1] then
		return nil, nil
	end
	local name, collected = r[2], r[12]
	if issecretvalue and (issecretvalue(name) or issecretvalue(collected)) then
		return nil, nil
	end
	return type(name) == "string" and name or nil, collected and true or false
end

--- All current lockouts, keyed "instanceId:difficultyId" -> { reset, killed = { [bosslower] = true }, done, total }
local function ReadLockouts()
	local out = {}
	if not (GetNumSavedInstances and GetSavedInstanceInfo) then
		return out
	end
	local okN, n = pcall(GetNumSavedInstances)
	if not okN or type(n) ~= "number" then
		return out
	end
	for i = 1, n do
		local r = { pcall(GetSavedInstanceInfo, i) }
		if r[1] then
			-- name, lockoutId, reset, difficultyId, locked, extended, instanceIDMostSig, isRaid, maxPlayers,
			-- difficultyName, numEncounters, encounterProgress, extendDisabled, instanceId
			local reset, diff, locked, numEnc, progress, instanceId = r[4], r[5], r[6], r[12], r[13], r[15]
			if locked and type(instanceId) == "number" and type(diff) == "number" then
				local e = { reset = reset, killed = {}, done = progress, total = numEnc }
				if GetSavedInstanceEncounterInfo and type(numEnc) == "number" then
					for j = 1, numEnc do
						local okE, bossName, _, isKilled = pcall(GetSavedInstanceEncounterInfo, i, j)
						if okE and isKilled and type(bossName) == "string" and not (issecretvalue and issecretvalue(bossName)) then
							e.killed[bossName:lower()] = true
						end
					end
				end
				out[instanceId .. ":" .. diff] = e
			end
		end
	end
	return out
end

local function FormatReset(sec)
	if type(sec) ~= "number" or sec <= 0 then
		return ""
	end
	local d = math.floor(sec / 86400)
	local h = math.floor((sec % 86400) / 3600)
	if d > 0 then
		return (ns:L("MOUNTRUN_RESET_DAYS_FMT")):format(d, h)
	end
	return (ns:L("MOUNTRUN_RESET_HOURS_FMT")):format(math.max(h, 1))
end

local DIFF_LABEL = {
	[1] = "MOUNTRUN_DIFF_DUNGEON_N", [2] = "MOUNTRUN_DIFF_DUNGEON_H", [23] = "MOUNTRUN_DIFF_DUNGEON_M",
	[3] = "MOUNTRUN_DIFF_10", [4] = "MOUNTRUN_DIFF_25", [5] = "MOUNTRUN_DIFF_10H", [6] = "MOUNTRUN_DIFF_25H",
	[14] = "MOUNTRUN_DIFF_N", [15] = "MOUNTRUN_DIFF_H", [16] = "MOUNTRUN_DIFF_M", [17] = "MOUNTRUN_DIFF_LFR",
}

--- One status line for a raid: per difficulty "open" or "done this week (resets in ...)".
--- The mount boss counts as done when the lockout lists it killed; without a boss match (another client language)
--- a full clear counts as done and a partial one shows "x/y".
local function RaidStatus(raid, lockouts)
	local parts, anyOpen = {}, false
	for _, diff in ipairs(raid.diffs or {}) do
		local label = ns:L(DIFF_LABEL[diff] or "MOUNTRUN_DIFF_N")
		local e = lockouts[(raid.instanceID or 0) .. ":" .. diff]
		local done = false
		if e then
			if raid.boss and next(e.killed) then
				-- boss may be a list: the lockout can use the DungeonEncounter name or the journal's (Mekkatorque).
				local names = type(raid.boss) == "table" and raid.boss or { raid.boss }
				for _, bn in ipairs(names) do
					if e.killed[bn:lower()] then
						done = true
					end
				end
			elseif type(e.done) == "number" and type(e.total) == "number" and e.total > 0 then
				done = e.done >= e.total
			end
		end
		if done then
			parts[#parts + 1] = ("|cff999999%s: %s %s|r"):format(label, ns:L("MOUNTRUN_DONE"), FormatReset(e.reset))
		else
			anyOpen = true
			local extra = (e and type(e.done) == "number") and (" (%d/%d)"):format(e.done, e.total or 0) or ""
			parts[#parts + 1] = ("|cff66ff66%s: %s%s|r"):format(label, ns:L("MOUNTRUN_OPEN"), extra)
		end
	end
	return table.concat(parts, "  ·  "), anyOpen
end

--- Entrance position: the client's own dungeon-entrance pin when it has one for this journal instance (measured,
--- no guess), else the coordinate from our data.
local function EntrancePoint(raid)
	local zone, x, y = raid.zoneMap, raid.x, raid.y
	-- Battle of Dazar'alor: Alliance enters in Boralus, Horde in Dazar'alor.
	if raid.zoneMapA and UnitFactionGroup and UnitFactionGroup("player") == "Alliance" then
		zone, x, y = raid.zoneMapA, raid.xA, raid.yA
	end
	if raid.journalID and zone and C_EncounterJournal and C_EncounterJournal.GetDungeonEntrancesForMap then
		local ok, list = pcall(C_EncounterJournal.GetDungeonEntrancesForMap, zone)
		if ok and type(list) == "table" then
			for _, ent in ipairs(list) do
				if ent.journalInstanceID == raid.journalID and ent.position and ent.position.GetXY then
					local okXY, px, py = pcall(ent.position.GetXY, ent.position)
					if okXY and px and py and not (issecretvalue and issecretvalue(px)) then
						return zone, px * 100, py * 100, true
					end
				end
			end
		end
	end
	return zone, x, y, false
end

--------------------------------------------------------------------------------
-- Route in steps (Rob, 16 Oct 2026): capital portal → hub → entrance, one arrow at a time
--------------------------------------------------------------------------------

-- Map knowledge now lives in Modules/Travel/TravelGeo.lua (travel design phase 1, 16 Oct 2026); these were its
-- first versions, moved there unchanged.
local InMap = ns.Travel.InMap
local ContinentOf = ns.Travel.Continent

local function ArrivedVia(pm, to)
	if type(to) == "table" then
		for _, m in ipairs(to) do
			if InMap(pm, m) then
				return true
			end
		end
		return false
	end
	return to ~= nil and InMap(pm, to)
end

local STEP_KEY = {
	portal = "MOUNTRUN_STEP_PORTAL", zeppelin = "MOUNTRUN_STEP_ZEPPELIN", boat = "MOUNTRUN_STEP_BOAT",
	tram = "MOUNTRUN_STEP_TRAM", exit = "MOUNTRUN_STEP_EXIT", tunnel = "MOUNTRUN_STEP_TUNNEL",
	hole = "MOUNTRUN_STEP_HOLE", ring = "MOUNTRUN_STEP_RING", jump = "MOUNTRUN_STEP_JUMP",
	teleport = "MOUNTRUN_STEP_TELEPORT", beacon = "MOUNTRUN_STEP_BEACON",
}

--- The steps for this character's faction. Destination names come from the client (C_Map), so they are in the
--- player's own language without a translation of ours.
local function BuildSteps(raid)
	local fac = (UnitFactionGroup and UnitFactionGroup("player") == "Horde") and "H" or "A"
	local steps = {}
	for _, key in ipairs(raid.route or {}) do
		local hub = ns.MOUNTRUN_HUBS and ns.MOUNTRUN_HUBS[key]
		local p = hub and (hub[fac] or hub.both)
		-- A portal that only exists after a quest (Isle of Thunder, 16 Oct 2026): not done yet → the quest giver is the
		-- step, and arriving where the hop leads counts the same. "Done" must be READ as done; unreadable = not done,
		-- because sending someone to a quest giver they no longer need costs a walk, a missing portal costs the route.
		local lock = hub and hub.unlock and hub.unlock[fac]
		if p and lock then
			local done = false
			if C_QuestLog and C_QuestLog.IsQuestFlaggedCompleted then
				local okQ, v = pcall(C_QuestLog.IsQuestFlaggedCompleted, lock.quest)
				done = okQ and v == true
			end
			if not done then
				local qName = lock.questName
				if C_QuestLog and C_QuestLog.GetTitleForQuestID then
					local okT, t = pcall(C_QuestLog.GetTitleForQuestID, lock.quest)
					if okT and type(t) == "string" and t ~= "" then
						qName = t
					end
				end
				local info = C_Map and C_Map.GetMapInfo and C_Map.GetMapInfo(hub.to)
				steps[#steps + 1] = { map = lock[1], x = lock[2], y = lock[3], to = hub.to,
					text = (ns:L("MOUNTRUN_STEP_UNLOCK")):format(lock.npc, qName, info and info.name or "?") }
				p = nil -- the portal itself is not a step yet
			end
		end
		if p then
			local to = p.to or hub.to
			local info = C_Map and C_Map.GetMapInfo and C_Map.GetMapInfo(type(to) == "table" and to[1] or to)
			local text = (ns:L(STEP_KEY[hub.kind] or "MOUNTRUN_STEP_PORTAL")):format(info and info.name or "?")
			if p.lower then
				text = text .. " " .. ns:L("MOUNTRUN_STEP_LOWER")
			end
			steps[#steps + 1] = { map = p[1], x = p[2], y = p[3], to = to, text = text, via = hub.via }
		end
	end
	local zone, x, y = EntrancePoint(raid)
	steps[#steps + 1] = { map = zone, x = x, y = y, text = (ns:L("MOUNTRUN_STEP_ENTRANCE")):format(ns:L(raid.nameKey)) }
	return steps
end

--- Which step the player is at now: the furthest step whose map they stand on, or whose previous step they have
--- just come through. One shortcut: already on the right continent but outside the capital (a Horde player in
--- Durotar going to the Caverns of Time) skips the capital portal — only for step 2, because deeper hubs
--- (Dornogal's tunnel to Azj-Kahet) share a continent with their destination and must not be skipped.
local function CurrentStep(steps, start)
	start = start or 1
	local pm = C_Map and C_Map.GetBestMapForUnit and C_Map.GetBestMapForUnit("player")
	if not pm then
		return 1
	end
	local inStart = InMap(pm, steps[start].map)
	for k = #steps, 2, -1 do
		local s = steps[k]
		if InMap(pm, s.map) or ArrivedVia(pm, steps[k - 1].to) then
			return k
		end
		if k == start + 1 and not inStart then
			local pc = ContinentOf(pm)
			if pc and pc == ContinentOf(s.map) then
				return k
			end
		end
	end
	return 1
end

local route -- { raid, steps, idx }

local function Say(msg)
	if ns.PrintChat then
		ns:PrintChat(msg)
	else
		print(("|cffffcc00%s|r %s"):format(ns:L("PRINT_PREFIX"), msg))
	end
end

local function PointAt(map, x, y, text)
	if ns.MH_TomTomClearAll then
		ns.MH_TomTomClearAll()
	end
	-- skipTravelUI: the steps ARE the travel advice; Midnight's planner does not know the old world.
	ns.AddSmartTomTomWay(map, x, y, text, true)
	if ns.lastTarget then
		ns.lastTarget.noTravelAdvice = true -- NativeArrow's "not on this continent, head for …" stays quiet
		ns.lastTarget.via = "mount run"
	end
	ns._mhRouteOwner = "mountrun"
end

--- A step with `via` (Silvermoon's portal-room door, Rob measured 16 Oct 2026) points at the door first. Once you
--- stand within ~0.3 map-percent of it (about 7 m in Silvermoon: door to Horde portal is 1.43 % ≈ 34 m, measured by
--- Rob's arrow) the arrow moves to the portal itself — no chat line, it is the same step.
local viaTicker
local function WatchVia(s)
	if viaTicker then
		viaTicker:Cancel()
		viaTicker = nil
	end
	if not (s.via and C_Map and C_Map.GetPlayerMapPosition and C_Timer and C_Timer.NewTicker) then
		return false
	end
	-- Already inside (closer to the portal than the door is): no door.
	local here = C_Map.GetPlayerMapPosition(s.map, "player")
	if here then
		local hx, hy = here:GetXY()
		if hx and hy then
			local function d(ax, ay, bx, by)
				return math.sqrt((ax - bx) ^ 2 + (ay - by) ^ 2)
			end
			if d(hx * 100, hy * 100, s.x, s.y) < d(s.via[1], s.via[2], s.x, s.y) then
				return false
			end
		end
	end
	viaTicker = C_Timer.NewTicker(0.5, function()
		if not route or route.steps[route.idx] ~= s or ns._mhRouteOwner ~= "mountrun" then
			viaTicker:Cancel()
			viaTicker = nil
			return
		end
		local pos = C_Map.GetPlayerMapPosition(s.map, "player")
		if not pos then
			return
		end
		local px, py = pos:GetXY()
		if px and py and math.abs(px * 100 - s.via[1]) < 0.3 and math.abs(py * 100 - s.via[2]) < 0.3 then
			viaTicker:Cancel()
			viaTicker = nil
			PointAt(s.map, s.x, s.y, s.text)
		end
	end)
	return true
end

--- A button to click for the Hearthstone step (Rob, 16 Oct 2026: the chat line was right, "maar ik mis de knop").
--- Same mechanism as the Travel Assistant's Hearthstone button (Delves.lua, MidnightHelperHSClick): a secure action
--- button, so it can only be shown, hidden or changed out of combat — in combat the change waits for
--- PLAYER_REGEN_ENABLED. The item uses "/use item:6948" like that button; a toy uses the secure "toy" type.
local hearthFrame, pendingHearth, pendingHide
local function HearthFrame()
	if hearthFrame then
		return hearthFrame
	end
	local f = CreateFrame("Frame", "MidnightHelperMountRunHearth", UIParent, "BackdropTemplate")
	f:SetSize(300, 66)
	f:SetPoint("TOP", UIParent, "TOP", 0, -170)
	f:SetFrameStrata("DIALOG")
	f:SetClampedToScreen(true)
	f:EnableMouse(true)
	f:SetMovable(true)
	f:RegisterForDrag("LeftButton")
	f:SetScript("OnDragStart", f.StartMoving)
	f:SetScript("OnDragStop", f.StopMovingOrSizing)
	f:Hide()
	if ns.ApplyMidnightDialogBackdrop then
		ns.ApplyMidnightDialogBackdrop(f)
	end
	if ns.RegisterMidnightDialogPopup then
		ns.RegisterMidnightDialogPopup(f)
	end
	local b = CreateFrame("Button", "MidnightHelperMountRunHearthBtn", f, "SecureActionButtonTemplate")
	b:SetSize(40, 40)
	b:SetPoint("LEFT", f, "LEFT", 14, 0)
	b.icon = b:CreateTexture(nil, "ARTWORK")
	b.icon:SetAllPoints()
	b.icon:SetTexture(134414) -- Hearthstone icon, replaced by the toy's own below
	b:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Square", "ADD")
	b:RegisterForClicks("AnyUp", "AnyDown")
	f.btn = b
	f.text = f:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
	f.text:SetPoint("LEFT", b, "RIGHT", 10, 0)
	f.text:SetPoint("RIGHT", f, "RIGHT", -26, 0)
	f.text:SetJustifyH("LEFT")
	f.text:SetWordWrap(true)
	if ns.AttachMidnightDialogCloseButton then
		ns.AttachMidnightDialogCloseButton(f, function()
			if not (InCombatLockdown and InCombatLockdown()) then
				f:Hide()
			end
		end)
	end
	hearthFrame = f
	return f
end

local function HideHearthButton()
	pendingHearth = nil
	if hearthFrame and hearthFrame:IsShown() then
		if InCombatLockdown and InCombatLockdown() then
			pendingHide = true
		else
			hearthFrame:Hide()
		end
	end
end

local function ShowHearthButton(s)
	if InCombatLockdown and InCombatLockdown() then
		pendingHearth, pendingHide = s, nil
		return
	end
	local f = HearthFrame()
	local b = f.btn
	local icon
	if s.mage and s.spellID then
		-- Travel phase 2: a mage teleport home is a step too, cast through the secure "spell" type.
		b:SetAttribute("type", "spell")
		b:SetAttribute("spell", s.spellID)
		b:SetAttribute("toy", nil)
		b:SetAttribute("macrotext", nil)
		icon = C_Spell and C_Spell.GetSpellTexture and C_Spell.GetSpellTexture(s.spellID)
	elseif s.isToy then
		b:SetAttribute("type", "toy")
		b:SetAttribute("toy", s.useID)
		b:SetAttribute("macrotext", nil)
		b:SetAttribute("spell", nil)
	else
		b:SetAttribute("type", "macro")
		b:SetAttribute("macrotext", "/use item:" .. tostring(s.useID))
		b:SetAttribute("toy", nil)
		b:SetAttribute("spell", nil)
	end
	icon = icon or (s.useID and C_Item and C_Item.GetItemIconByID and C_Item.GetItemIconByID(s.useID))
	b.icon:SetTexture(icon or 134414)
	f.text:SetText(s.text)
	f:Show()
end

do
	local ev = CreateFrame("Frame")
	ev:RegisterEvent("PLAYER_REGEN_ENABLED")
	ev:SetScript("OnEvent", function()
		if pendingHide then
			pendingHide = nil
			if hearthFrame then
				hearthFrame:Hide()
			end
		end
		local s = pendingHearth
		pendingHearth = nil
		if s and route and route.steps[route.idx] == s then
			ShowHearthButton(s)
		end
	end)
end

local function ShowStep(i)
	local s = route.steps[i]
	route.idx = i
	local text = s.text
	if (s.hearth and s.useID) or (s.mage and s.spellID) then
		ShowHearthButton(s)
	else
		HideHearthButton()
	end
	if s.hearth or s.mage or not (s.x and s.y) then
		-- Nothing to point at (the Hearthstone): no arrow, but the route keeps the arrow so the old travel helpers
		-- stay quiet, and the next zone change moves it on.
		WatchVia({})
		if ns.MH_TomTomClearAll then
			ns.MH_TomTomClearAll()
		end
		ns.lastTarget = nil
		ns._mhRouteOwner = "mountrun"
	else
		-- A capital step seen from elsewhere says which city it is in (Rob, in Uldum: "Take the portal to The Jade
		-- Forest", 12 km away, without saying it stands in Orgrimmar).
		local pm = C_Map and C_Map.GetBestMapForUnit and C_Map.GetBestMapForUnit("player")
		if (s.map == 84 or s.map == 85) and pm and not InMap(pm, s.map) then
			local city = C_Map.GetMapInfo and C_Map.GetMapInfo(s.map)
			text = (ns:L("MOUNTRUN_STEP_IN_CITY")):format(city and city.name or "?", s.text)
		end
		if WatchVia(s) then
			PointAt(s.map, s.via[1], s.via[2], text)
		else
			PointAt(s.map, s.x, s.y, text)
		end
	end
	Say((ns:L("MOUNTRUN_STEP_FMT")):format(i, #route.steps, text))
end

--- The way home first (Rob, 16 Oct 2026, in Silvermoon: "kunnen we geen pijlen ook naar de portals hier
--- toevoegen?"). Since travel phase 2 (same day) this is Travel.WayHome (Modules/Travel/TravelPlanner.lua), shared
--- with the travel plan of every other route: portal home here → mage teleport → Hearthstone/toy → Midnight side
--- zones via Silvermoon → nearest hub on this continent.
local function HomeSteps(steps)
	local capital = steps[1].map
	if capital ~= 84 and capital ~= 85 then
		return {}
	end
	return ns.Travel.WayHome(capital)
end

function ns.MountRunStartRoute(raid)
	local steps = BuildSteps(raid)
	local start = 1
	if CurrentStep(steps) == 1 then
		local pre = HomeSteps(steps)
		if #pre > 0 then
			for i = #pre, 1, -1 do
				table.insert(steps, 1, pre[i])
			end
			start = #pre + 1
		end
	end
	route = { raid = raid, steps = steps, start = start }
	ShowStep(CurrentStep(steps, start))
end

do
	-- Advance on every zone change while the route is ours. Inside the instance it is done; another route
	-- taking the arrow (a delve, a rare) ends ours without a word.
	local ev = CreateFrame("Frame")
	ev:RegisterEvent("ZONE_CHANGED_NEW_AREA")
	ev:RegisterEvent("ZONE_CHANGED")
	ev:RegisterEvent("ZONE_CHANGED_INDOORS")
	ev:RegisterEvent("PLAYER_ENTERING_WORLD")
	ev:SetScript("OnEvent", function()
		if not route then
			return
		end
		if ns._mhRouteOwner ~= "mountrun" then
			route = nil
			HideHearthButton()
			return
		end
		if IsInInstance and select(1, IsInInstance()) then
			route = nil
			HideHearthButton()
			ns._mhRouteOwner = nil
			if ns.MH_TomTomClearAll then
				ns.MH_TomTomClearAll()
			end
			return
		end
		-- After a loading screen the map can still be nil for a moment; ask again shortly.
		C_Timer.After(1, function()
			if not route or ns._mhRouteOwner ~= "mountrun" then
				return
			end
			local k = CurrentStep(route.steps, route.start)
			if k ~= route.idx then
				ShowStep(k)
			end
		end)
	end)
end

--------------------------------------------------------------------------------
-- Window
--------------------------------------------------------------------------------

local W, H = 560, 560

local function Build()
	if ui then
		return ui
	end
	local f = CreateFrame("Frame", "MidnightHelperMountRun", UIParent, "BackdropTemplate")
	f:SetSize(W, H)
	f:SetPoint("CENTER")
	f:SetFrameStrata("DIALOG")
	f:EnableMouse(true)
	f:SetMovable(true)
	f:RegisterForDrag("LeftButton")
	f:SetScript("OnDragStart", f.StartMoving)
	f:SetScript("OnDragStop", f.StopMovingOrSizing)
	f:SetClampedToScreen(true)
	f:Hide()
	if ns.ApplyMidnightDialogBackdrop then
		ns.ApplyMidnightDialogBackdrop(f)
	end
	if ns.RegisterMidnightDialogPopup then
		ns.RegisterMidnightDialogPopup(f)
	end
	f.title = f:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
	f.title:SetPoint("TOPLEFT", 16, -14)
	f.title:SetText(ns:L("MOUNTRUN_TITLE"))
	if ns.AttachMidnightDialogCloseButton then
		ns.AttachMidnightDialogCloseButton(f, function()
			f:Hide()
		end)
	end

	-- Tabs: one per block of MOUNTRUN_RAIDS (Rob, 16 Oct 2026: "rij bovenaan", no "all" tab). They wrap onto a second
	-- row when the labels do not fit, so the scroll area is placed under them in RefreshMountRun.
	f.tabs = {}
	local scroll = CreateFrame("ScrollFrame", nil, f, "UIPanelScrollFrameTemplate")
	scroll:SetPoint("TOPLEFT", 16, -42)
	scroll:SetPoint("BOTTOMRIGHT", -34, 14)
	local child = CreateFrame("Frame", nil, scroll)
	child:SetSize(W - 56, 10)
	scroll:SetScrollChild(child)
	f.scroll = scroll
	f.child = child
	f.lines, f.btns = {}, {}
	f:SetScript("OnShow", function()
		if ns.RefreshMountRun then
			ns.RefreshMountRun()
		end
	end)
	ui = f
	return f
end

local function Line(i)
	local fs = ui.lines[i]
	if not fs then
		fs = ui.child:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
		fs:SetJustifyH("LEFT")
		fs:SetWordWrap(true)
		ui.lines[i] = fs
	end
	return fs
end

local function Btn(i)
	local b = ui.btns[i]
	if not b then
		b = CreateFrame("Button", nil, ui.child, "UIPanelButtonTemplate")
		b:SetHeight(20)
		ui.btns[i] = b
	end
	return b
end

--- The last tab is remembered per character (Rob: "per speler"), in the account-wide db under "Name-Realm".
local function CharKey()
	return ((UnitName and UnitName("player")) or "?") .. "-" .. ((GetRealmName and GetRealmName()) or "?")
end

local function SavedTab()
	local t = ns.db and ns.db.mountRunTab
	return t and t[CharKey()]
end

local function SaveTab(i)
	ns.db = ns.db or {}
	ns.db.mountRunTab = ns.db.mountRunTab or {}
	ns.db.mountRunTab[CharKey()] = i
end

--- Per raid: the mount lines and how many of them you still miss. The other faction's twin is left out.
local function MountLines(raid)
	local lines, missing = {}, 0
	local myFaction = UnitFactionGroup and UnitFactionGroup("player")
	for _, m in ipairs(raid.mounts) do
		if not (m.faction and myFaction and m.faction ~= myFaction) then
			local name, have = MountState(m.mountID)
			name = name or m.name
			if not m.mountID then
				-- A token that opens into a random mount (Quantum Courser): nothing to tick, so no tick or cross.
				lines[#lines + 1] = ("|cffdddddd• %s|r |cffbbbbbb(%s, %s)|r"):format(name, m.boss or "?", m.chance or "?")
			elseif have then
				lines[#lines + 1] = ("|TInterface\\RaidFrame\\ReadyCheck-Ready:0|t |cff999999%s|r"):format(name)
			else
				missing = missing + 1
				lines[#lines + 1] = ("|TInterface\\RaidFrame\\ReadyCheck-NotReady:0|t %s |cffbbbbbb(%s, %s)|r"):format(
					name, m.boss or raid.boss or "?", m.chance or "?")
			end
		end
	end
	return lines, missing
end

local function Tab(i)
	local b = ui.tabs[i]
	if not b then
		b = CreateFrame("Button", nil, ui, "UIPanelButtonTemplate")
		b:SetHeight(22)
		b:SetScript("OnClick", function()
			SaveTab(i)
			ui.scroll:SetVerticalScroll(0)
			ns.RefreshMountRun()
		end)
		ui.tabs[i] = b
	end
	return b
end

--- Lays the tabs out left to right, wrapping to a new row; returns the y offset below the last row.
local function LayoutTabs(groups, missingPer, sel)
	local x, y, maxX = 16, -40, W - 16
	for i, group in ipairs(groups) do
		local b = Tab(i)
		local label = ns:L(group.tabKey or group.headKey)
		if missingPer[i] > 0 then
			label = ("%s (%d)"):format(label, missingPer[i])
		end
		b:SetText(i == sel and ("|cffffd200" .. label .. "|r") or label)
		local w = (b.GetTextWidth and b:GetTextWidth() or 80) + 22
		b:SetWidth(w)
		if x + w > maxX and x > 16 then
			x, y = 16, y - 24
		end
		b:ClearAllPoints()
		b:SetPoint("TOPLEFT", ui, "TOPLEFT", x, y)
		if i == sel then
			b:LockHighlight()
		else
			b:UnlockHighlight()
		end
		b:Show()
		x = x + w + 2
	end
	for i = #groups + 1, #ui.tabs do
		ui.tabs[i]:Hide()
	end
	return y - 26
end

function ns.RefreshMountRun()
	if not (ui and ui:IsShown()) then
		return
	end
	local width = ui.child:GetWidth()
	local lockouts = ReadLockouts()
	local groups = ns.MOUNTRUN_RAIDS or {}
	local missingPer, missingTotal = {}, 0
	for i, group in ipairs(groups) do
		local n = 0
		for _, raid in ipairs(group.raids) do
			local _, missing = MountLines(raid)
			n = n + missing
		end
		missingPer[i], missingTotal = n, missingTotal + n
	end
	-- First visit: the first block that still has a mount to get, else the first.
	local sel = SavedTab()
	if type(sel) ~= "number" or not groups[sel] then
		sel = 1
		for i = 1, #groups do
			if missingPer[i] > 0 then
				sel = i
				break
			end
		end
	end
	local top = LayoutTabs(groups, missingPer, sel)
	ui.scroll:SetPoint("TOPLEFT", 16, top)
	local li, bi, y = 0, 0, 0
	local function put(text, font, indent, gap)
		li = li + 1
		local fs = Line(li)
		fs:SetFontObject(font or "GameFontHighlightSmall")
		fs:ClearAllPoints()
		fs:SetPoint("TOPLEFT", ui.child, "TOPLEFT", indent or 0, -y)
		fs:SetWidth(width - (indent or 0))
		fs:SetText(text)
		fs:Show()
		y = y + (fs:GetStringHeight() or 14) + (gap or 3)
	end
	put(ns:L("MOUNTRUN_INTRO"), "GameFontHighlightSmall", 0, 8)
	local group = groups[sel]
	if group then
		put("|cffffd200" .. ns:L(group.headKey) .. "|r", "GameFontNormal", 0, 4)
		for _, raid in ipairs(group.raids) do
			local mountsText = MountLines(raid)
			local status = RaidStatus(raid, lockouts)
			-- group = true: current raids whose mount cannot be soloed at max level (Rob, 15 Oct: "ook diegene die een
			-- groep benodigen"). Same row, with a label, so a solo player sees it at a glance.
			local groupTag = raid.group and ("  |cffff9933" .. ns:L("MOUNTRUN_GROUP") .. "|r") or ""
			put(("|cffffffff%s|r%s  %s"):format(ns:L(raid.nameKey), groupTag, status), "GameFontHighlight", 8, 2)
			put(table.concat(mountsText, "|n"), "GameFontHighlightSmall", 18, 2)
			if raid.howKey then
				put("|cffaaaaaa" .. ns:L(raid.howKey) .. "|r", "GameFontHighlightSmall", 18, 2)
			end
			if raid.zoneMap and ns.AddSmartTomTomWay then
				bi = bi + 1
				local b = Btn(bi)
				b:ClearAllPoints()
				b:SetPoint("TOPLEFT", ui.child, "TOPLEFT", 18, -y)
				b:SetText(ns:L("MOUNTRUN_ROUTE_BTN"))
				b:SetWidth((b.GetTextWidth and b:GetTextWidth() or 120) + 28)
				b:SetScript("OnClick", function()
					-- In steps (16 Oct 2026): the arrow goes to the first step you still need — the capital's portal,
					-- the hub, then the entrance — and moves on by itself at every zone change. Chat says each step.
					ns.MountRunStartRoute(raid)
				end)
				b:Show()
				y = y + 24
			end
			y = y + 6
		end
		y = y + 4
	end
	put(ns:L("MOUNTRUN_FOOTER"), "GameFontDisableSmall", 0, 4)
	for i = li + 1, #ui.lines do
		ui.lines[i]:Hide()
	end
	for i = bi + 1, #ui.btns do
		ui.btns[i]:Hide()
	end
	ui.child:SetHeight(math.max(y + 8, 1))
	ui.title:SetText((ns:L("MOUNTRUN_TITLE_FMT")):format(missingTotal))
end

--- `/mh mountrun`
function ns.MH_ShowMountRun()
	local f = Build()
	if f:IsShown() then
		f:Hide()
		return
	end
	f:Show()
	-- Lockouts arrive from the server: ask once, redraw when they land.
	if RequestRaidInfo then
		pcall(RequestRaidInfo)
	end
end

do
	local ev = CreateFrame("Frame")
	ev:RegisterEvent("UPDATE_INSTANCE_INFO")
	ev:RegisterEvent("NEW_MOUNT_ADDED")
	ev:SetScript("OnEvent", function()
		if ns.RefreshMountRun then
			ns.RefreshMountRun()
		end
	end)
end
