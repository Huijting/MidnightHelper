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

--- true when map `pm` is `target` or lies inside it (a city inside its zone, a cave inside its zone).
local function InMap(pm, target)
	local guard = 0
	while pm and pm ~= 0 and guard < 12 do
		if pm == target then
			return true
		end
		local info = C_Map and C_Map.GetMapInfo and C_Map.GetMapInfo(pm)
		pm = info and info.parentMapID
		guard = guard + 1
	end
	return false
end

local function ContinentOf(m)
	local guard = 0
	while m and m ~= 0 and guard < 12 do
		local info = C_Map and C_Map.GetMapInfo and C_Map.GetMapInfo(m)
		if not info then
			return nil
		end
		if Enum and Enum.UIMapType and info.mapType == Enum.UIMapType.Continent then
			return m
		end
		m = info.parentMapID
		guard = guard + 1
	end
	return nil
end

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

local function ShowStep(i)
	local s = route.steps[i]
	route.idx = i
	local text = s.text
	if s.hearth or not (s.x and s.y) then
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
--- toevoegen?"): when the route would start at the capital and you are somewhere with a portal home — Silvermoon's
--- portal room, Dornogal, Oribos, a Midnight zone via Silvermoon — those steps go in front.
local function HomeSteps(steps)
	local pm = C_Map and C_Map.GetBestMapForUnit and C_Map.GetBestMapForUnit("player")
	local capital = steps[1].map
	if not pm or (capital ~= 84 and capital ~= 85) or InMap(pm, capital) then
		return {}
	end
	local fac = capital == 85 and "H" or "A"
	local pre = {}
	local function HomeRow(m)
		local row = ns.MOUNTRUN_HOME and ns.MOUNTRUN_HOME[m]
		local p = row and row[fac]
		if p then
			local info = C_Map and C_Map.GetMapInfo and C_Map.GetMapInfo(capital)
			return { map = m, x = p[1], y = p[2], to = capital, via = row.via,
				text = (ns:L(row.room and "MOUNTRUN_STEP_ROOM" or "MOUNTRUN_STEP_PORTAL")):format(info and info.name or "?") }
		end
	end
	-- A portal home right here wins: no cooldown spent.
	for m in pairs(ns.MOUNTRUN_HOME or {}) do
		if InMap(pm, m) and HomeRow(m) then
			return { HomeRow(m) }
		end
	end
	-- Then the Hearthstone (Rob, 16 Oct 2026, in Uldum: "bv is een hs beschikbaar"), but only when it is off
	-- cooldown AND lands where it helps — ns.MHHearthstoneGoesTo is the conservative bind check of the Travel
	-- Assistant (Delves.lua): a Hearthstone to the wrong inn wastes the cooldown and cannot be walked back.
	local function Ready(itemID)
		return ns.GetItemCooldownSafe and (ns.GetItemCooldownSafe(itemID) or 0) == 0
	end
	-- Which Hearthstone: the item in the bags first, else a Hearthstone toy you own (16 Oct 2026). `toyName` is the
	-- client's own name for the toy, so the sentence says which one to click.
	local hsReady, toyName = false, nil
	if C_Item and C_Item.GetItemCount and (C_Item.GetItemCount(6948) or 0) > 0 and Ready(6948) then
		hsReady = true
	elseif PlayerHasToy then
		for _, id in ipairs(ns.MOUNTRUN_HEARTH_TOYS or {}) do
			local okT, has = pcall(PlayerHasToy, id)
			if okT and has and Ready(id) then
				local okN, _, name = false, nil, nil
				if C_ToyBox and C_ToyBox.GetToyInfo then
					okN, _, name = pcall(C_ToyBox.GetToyInfo, id)
				end
				hsReady, toyName = true, (okN and type(name) == "string" and name ~= "") and name or nil
				break
			end
		end
	end
	if hsReady and ns.MHHearthstoneGoesTo then
		local function HearthText(placeName)
			if toyName then
				return (ns:L("MOUNTRUN_STEP_HEARTH_TOY")):format(toyName, placeName)
			end
			return (ns:L("MOUNTRUN_STEP_HEARTH")):format(placeName)
		end
		local capInfo = C_Map and C_Map.GetMapInfo and C_Map.GetMapInfo(capital)
		local smInfo = C_Map and C_Map.GetMapInfo and C_Map.GetMapInfo(2393)
		if capInfo and capInfo.name and ns.MHHearthstoneGoesTo(capInfo.name) then
			return { { map = pm, to = capital, hearth = true, text = HearthText(capInfo.name) } }
		end
		if smInfo and smInfo.name and ns.MHHearthstoneGoesTo(smInfo.name) and HomeRow(2393) then
			return { { map = pm, to = 2393, hearth = true, text = HearthText(smInfo.name) }, HomeRow(2393) }
		end
	end
	local feeders = ns.MOUNTRUN_TO_SILVERMOON or {}
	for m, list in pairs(feeders) do
		if InMap(pm, m) then
			for _, f in ipairs(list) do
				local info = C_Map and C_Map.GetMapInfo and C_Map.GetMapInfo(f.to)
				local key = f.den and "MOUNTRUN_STEP_DEN" or "MOUNTRUN_STEP_PORTAL"
				pre[#pre + 1] = { map = f[1], x = f[2], y = f[3], to = f.to,
					text = (ns:L(key)):format(info and info.name or "?") }
			end
			pm = 2393 -- from here on: home from Silvermoon
			break
		end
	end
	for m, row in pairs(ns.MOUNTRUN_HOME or {}) do
		local p = row[fac]
		if p and (InMap(pm, m)) then
			local info = C_Map and C_Map.GetMapInfo and C_Map.GetMapInfo(capital)
			local key = row.room and "MOUNTRUN_STEP_ROOM" or "MOUNTRUN_STEP_PORTAL"
			pre[#pre + 1] = { map = m, x = p[1], y = p[2], to = capital, via = row.via,
				text = (ns:L(key)):format(info and info.name or "?") }
			return pre
		end
	end
	-- Not in a hub, but on a continent that has one (Eversong → Silvermoon, Zuldazar → Dazar'alor, Storm Peaks →
	-- Dalaran): fly there first. Never on the capital's own continent — there the capital itself is the way.
	local pc = ContinentOf(pm)
	if pc and pc ~= ContinentOf(capital) then
		-- Several hubs can share a continent (Kalimdor: the Caverns, the Exodar; Broken Isles: Azsuna, Dalaran), so
		-- take the nearest, measured in world coordinates; without a position, the first one found.
		local function World(m, x, y)
			if not (C_Map.GetWorldPosFromMapPos and CreateVector2D) then
				return nil
			end
			local ok, cont, pos = pcall(C_Map.GetWorldPosFromMapPos, m, CreateVector2D(x / 100, y / 100))
			if ok and cont and pos and pos.GetXY then
				local wx, wy = pos:GetXY()
				return cont, wx, wy
			end
		end
		local mine = C_Map.GetPlayerMapPosition and C_Map.GetPlayerMapPosition(pm, "player")
		local pcont, px, py
		if mine and mine.GetXY then
			local mx, my = mine:GetXY()
			if mx and my then
				pcont, px, py = World(pm, mx * 100, my * 100)
			end
		end
		local best, bestD
		for m, row in pairs(ns.MOUNTRUN_HOME or {}) do
			local p = row[fac]
			if p and ContinentOf(m) == pc then
				local d = math.huge - 1
				local hcont, hx, hy = World(m, p[1], p[2])
				if pcont and hcont == pcont then
					d = (hx - px) ^ 2 + (hy - py) ^ 2
				end
				if not bestD or d < bestD then
					best, bestD = m, d
				end
			end
		end
		if best then
			local row, p = ns.MOUNTRUN_HOME[best], ns.MOUNTRUN_HOME[best][fac]
			local hub = C_Map.GetMapInfo and C_Map.GetMapInfo(best)
			local cap = C_Map.GetMapInfo and C_Map.GetMapInfo(capital)
			pre[#pre + 1] = { map = best, x = p[1], y = p[2], to = capital, via = row.via,
				text = (ns:L("MOUNTRUN_STEP_HOME_FAR")):format(hub and hub.name or "?", cap and cap.name or "?") }
			return pre
		end
	end
	return {} -- no portal home known from here: the capital step stays first, as before
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
			return
		end
		if IsInInstance and select(1, IsInInstance()) then
			route = nil
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
