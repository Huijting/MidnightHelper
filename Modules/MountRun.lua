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

--- The boss's name in the CLIENT's language, from the Dungeon Journal (16 Oct 2026, Rob: "Repareer de baasnamen en de
--- weekcontrole eerst"). Our data's English names showed as English on every client, and the lockout match compared
--- them with the client's own (localized) names — so on a German client a killed boss never matched.
local function EncName(enc)
	if type(enc) ~= "number" or not EJ_GetEncounterInfo then
		return nil
	end
	local ok, name = pcall(EJ_GetEncounterInfo, enc)
	if ok and type(name) == "string" and name ~= "" and not (issecretvalue and issecretvalue(name)) then
		return name
	end
	return nil
end

--- What to show for "which boss": the journal name (client language) plus the qualifier (a key), else our English text.
local function BossLabel(enc, q, fallback)
	local name = EncName(enc)
	if not name then
		if type(fallback) == "table" then
			return fallback[1] or "?"
		end
		return fallback or "?"
	end
	if q then
		return name .. ", " .. ns:L(q)
	end
	return name
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
			if next(e.killed) then
				-- boss may be a list: the lockout can use the DungeonEncounter name or the journal's (Mekkatorque).
				-- Plus the journal's name in the client's language (raid.enc), so a non-English client matches too.
				local names = {}
				for _, bn in ipairs(type(raid.boss) == "table" and raid.boss or { raid.boss }) do
					names[#names + 1] = bn
				end
				for _, enc in ipairs(type(raid.enc) == "table" and raid.enc or { raid.enc }) do
					names[#names + 1] = EncName(enc)
				end
				-- No journal encounter at all (Nightbane: only a DungeonEncounter): the name as a translated key.
				if raid.bossKey then
					names[#names + 1] = ns:L(raid.bossKey)
				end
				for _, bn in pairs(names) do
					if type(bn) == "string" and e.killed[bn:lower()] then
						done = true
					end
				end
			end
			-- A full clear is done whatever the names say. Before 16 Oct this only ran when NOTHING was killed, so a
			-- name mismatch (another client language) left a cleared raid "open".
			if not done and type(e.done) == "number" and type(e.total) == "number" and e.total > 0 then
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
-- Travel phase 3 (16 Oct 2026): walking the steps (CurrentStep, ShowStep, WatchVia, the Hearthstone button, the
-- boarding watcher and the zone handler) moved to Modules/Travel/TravelRoute.lua, unchanged in what they do, so every
-- route walks the same way. This file only says WHICH steps a raid has.

local STEP_KEY = {
	portal = "MOUNTRUN_STEP_PORTAL", zeppelin = "MOUNTRUN_STEP_ZEPPELIN", boat = "MOUNTRUN_STEP_BOAT",
	tram = "MOUNTRUN_STEP_TRAM", exit = "MOUNTRUN_STEP_EXIT", tunnel = "MOUNTRUN_STEP_TUNNEL",
	hole = "MOUNTRUN_STEP_HOLE", ring = "MOUNTRUN_STEP_RING", jump = "MOUNTRUN_STEP_JUMP",
	teleport = "MOUNTRUN_STEP_TELEPORT", beacon = "MOUNTRUN_STEP_BEACON",
}

--- The steps through hubs `keys` (MOUNTRUN_HUBS) for this character's faction. Destination names come from the client
--- (C_Map), so they are in the player's own language without a translation of ours. Shared with the places in the
--- search bar (Modules/Travel/TravelPlaces.lua, 16 Oct 2026), which walk the same hubs to a city instead of a raid.
function ns.MountRunHubSteps(keys)
	local fac = (UnitFactionGroup and UnitFactionGroup("player") == "Horde") and "H" or "A"
	local steps = {}
	for _, key in ipairs(keys or {}) do
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
				steps[#steps + 1] = { map = lock[1], x = lock[2], y = lock[3], to = hub.to, board = true,
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
			-- `board`: a ride (boat, zeppelin, tram) — getting on ends the step (see the boarding watcher below).
			local ride = hub.kind == "boat" or hub.kind == "zeppelin" or hub.kind == "tram"
			-- `orb`: the Coiled Isle portal is downstairs, behind an orb you click (Rob, 16 Oct 2026). A hub with an orb
			-- has a real door in front of it (Astalor's Sanctum), so it gets the door rule, not the portal-room `via`.
			steps[#steps + 1] = { map = p[1], x = p[2], y = p[3], to = to, text = text, via = hub.via, orb = hub.orb,
				viaNear = hub.orb and "door" or "via", board = ride or nil }
		end
	end
	return steps
end

--- The steps of this raid: its hubs, then the entrance.
local function BuildSteps(raid)
	local steps = ns.MountRunHubSteps(raid.route)
	local zone, x, y = EntrancePoint(raid)
	steps[#steps + 1] = { map = zone, x = x, y = y, final = true,
		text = (ns:L("MOUNTRUN_STEP_ENTRANCE")):format(ns:L(raid.nameKey)) }
	return steps
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
	local out = ns.Travel.WayHome(capital)
	for _, s in ipairs(out) do
		if s.via then
			s.viaNear = "via"
		end
	end
	return out
end

--- Start the route: the steps of this raid, with the way home in front when the player is on none of them. From
--- here on the route runner walks it (Modules/Travel/TravelRoute.lua): one step at a time, on at every zone change,
--- done inside the instance, ended when another route takes the arrow.
function ns.MountRunStartRoute(raid)
	local steps = BuildSteps(raid)
	local start = 1
	if ns.Travel.StepFor(steps) == 1 then
		local pre = HomeSteps(steps)
		if #pre > 0 then
			for i = #pre, 1, -1 do
				table.insert(steps, 1, pre[i])
			end
			start = #pre + 1
		end
	end
	local last = steps[#steps]
	ns.Travel.Start({ map = last.map, x = last.x, y = last.y, name = ns:L(raid.nameKey) }, {
		owner = "mountrun",
		steps = steps,
		start = start,
		stepFmt = "MOUNTRUN_STEP_FMT",
		stopInInstance = true,
		noTravelAdvice = true, -- NativeArrow's "not on this continent, head for …" stays quiet
		clearPins = true,
		via = "mount run",
	})
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
	f.lines, f.btns, f.hovers = {}, {}, {}
	f:HookScript("OnHide", function()
		if ns.MH_MountHoverLeave then
			ns.MH_MountHoverLeave()
		end
	end)
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
	local lines, missing, hover = {}, 0, {}
	local myFaction = UnitFactionGroup and UnitFactionGroup("player")
	for _, m in ipairs(raid.mounts) do
		if not (m.faction and myFaction and m.faction ~= myFaction) then
			local name, have = MountState(m.mountID)
			if not name and m.itemID and C_Item and C_Item.GetItemNameByID then
				-- A token without a mountID (Quantum Courser): its item name, in the client's language when cached.
				local okI, iname = pcall(C_Item.GetItemNameByID, m.itemID)
				if okI and type(iname) == "string" and not (issecretvalue and issecretvalue(iname)) then
					name = iname
				end
			end
			name = name or m.name
			-- m.label: a whole text key instead of a boss ("all 4 bosses"); else the boss in the client's language.
			local who = m.label and ns:L(m.label) or BossLabel(m.enc or (not m.boss and raid.enc) or nil, m.q,
				m.boss or raid.boss)
			if not m.mountID then
				-- A token that opens into a random mount (Quantum Courser): nothing to tick, so no tick or cross.
				lines[#lines + 1] = ("|cffdddddd• %s|r |cffbbbbbb(%s, %s)|r"):format(name, who, m.chance or "?")
			elseif have then
				lines[#lines + 1] = ("|TInterface\\RaidFrame\\ReadyCheck-Ready:0|t |cff999999%s|r"):format(name)
			else
				missing = missing + 1
				lines[#lines + 1] = ("|TInterface\\RaidFrame\\ReadyCheck-NotReady:0|t %s |cffbbbbbb(%s, %s)|r"):format(
					name, who, m.chance or "?")
			end
			-- What the hover needs for this line (same fields as a Mounts tab row).
			hover[#lines] = { mountID = m.mountID, itemID = m.itemID, name = name }
		end
	end
	return lines, missing, hover
end

--- An invisible mouse area over one mount line: tooltip + 3D preview beside this window, the same hover as the
--- Mounts tab (Rob, 16 Oct 2026: "de andere hebben een animatie … is dat lastig en veel werk?").
local function HoverArea(i)
	local h = ui.hovers[i]
	if not h then
		h = CreateFrame("Frame", nil, ui.child)
		h:EnableMouse(true)
		h:SetScript("OnEnter", function(self)
			if ns.MH_MountHoverEnter then
				ns.MH_MountHoverEnter(self, ui)
			end
		end)
		h:SetScript("OnLeave", function()
			if ns.MH_MountHoverLeave then
				ns.MH_MountHoverLeave()
			end
		end)
		ui.hovers[i] = h
	end
	return h
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
	local li, bi, hi, y = 0, 0, 0, 0
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
			local mountsText, _, hover = MountLines(raid)
			local status = RaidStatus(raid, lockouts)
			-- group = true: current raids whose mount cannot be soloed at max level (Rob, 15 Oct: "ook diegene die een
			-- groep benodigen"). Same row, with a label, so a solo player sees it at a glance.
			local groupTag = raid.group and ("  |cffff9933" .. ns:L("MOUNTRUN_GROUP") .. "|r") or ""
			put(("|cffffffff%s|r%s  %s"):format(ns:L(raid.nameKey), groupTag, status), "GameFontHighlight", 8, 2)
			-- One line per mount, each with its own mouse area (was one text block: nothing to hover per mount).
			for k, text in ipairs(mountsText) do
				put(text, "GameFontHighlightSmall", 18, k == #mountsText and 2 or 0)
				local d = hover[k]
				if d then
					local fs = ui.lines[li]
					hi = hi + 1
					local h = HoverArea(hi)
					h._mhMountID, h._mhItemID, h._mhName = d.mountID, d.itemID, d.name
					h:ClearAllPoints()
					h:SetPoint("TOPLEFT", fs, "TOPLEFT", 0, 0)
					h:SetSize(math.max((fs:GetStringWidth() or 100), 20), math.max((fs:GetStringHeight() or 12), 10))
					h:Show()
				end
			end
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
	for i = hi + 1, #ui.hovers do
		ui.hovers[i]:Hide()
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

--- Open the window on one tab (the search bar, Rob 19 Oct 2026: "ik kon niet zomaar Black Drake intikken").
--- Never a toggle: a search hit must not close a window the player already has open.
function ns.MH_ShowMountRunAt(groupIndex)
	local f = Build()
	if groupIndex then
		SaveTab(groupIndex)
	end
	if not f:IsShown() then
		f:Show()
		if RequestRaidInfo then
			pcall(RequestRaidInfo)
		end
	end
	if ui and ui.scroll then
		ui.scroll:SetVerticalScroll(0)
	end
	ns.RefreshMountRun()
end

--- One row per old-raid mount for the search: { name, raid, groupIndex, raidName }. The name is the client's own when
--- the journal knows the mount (so it is found in every language), and the English name is always a keyword.
function ns.GetMountRunSearchIndex()
	local out = {}
	local myFaction = UnitFactionGroup and UnitFactionGroup("player")
	for gi, group in ipairs(ns.MOUNTRUN_RAIDS or {}) do
		for _, raid in ipairs(group.raids or {}) do
			for _, m in ipairs(raid.mounts or {}) do
				if not (m.faction and myFaction and m.faction ~= myFaction) then
					local name = MountState(m.mountID)
					out[#out + 1] = {
						name = name or m.name,
						english = m.name,
						raid = raid,
						groupIndex = gi,
						raidName = ns:L(raid.nameKey),
					}
				end
			end
		end
	end
	return out
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
