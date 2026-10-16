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
					local zone, x, ey = EntrancePoint(raid)
					if ns.MH_TomTomClearAll then
						ns.MH_TomTomClearAll()
					end
					-- skipTravelUI: our travel planner knows Midnight's network, not the old world; the how-to line
					-- gets you to the zone, the arrow does the last part.
					ns.AddSmartTomTomWay(zone, x, ey, ns:L(raid.nameKey), true)
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
