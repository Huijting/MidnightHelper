local _, ns = ...

--[[
	ForeverDungeons.lua — WoW Forever: which dungeon fits your level, where its entrance is, and the arrow there.

	Rob, 14 Nov 2026 (via sparring, verbatim): "Maar met de addon wil ik graag het forever deel ook uit breiden met dungeons
	en raids"; direction: "We gaan voor 2 incl de route er naar toe" (MH explains in its own way, does NOT rebuild the
	DungeonJournal addon); plan: "Voor A, beginnen we met stap 1 … C. Ja, dat mag. De ingangen van de handy notes erom
	meeleveren." Step 1 = this file: a line in "Do this now", a list window, a Route button per dungeon.
	Research: docs/forever/DUNGEONS_2026-11-14.md.

	Data, per column:
	  - level min–max ... Blizzard's own GroupFinderActivity (DB2, wago wowf 1.60.1.70938), MEASURED 14 Nov 2026.
	  - map ............. the instance Map id (DB2 Map); the NAME comes from the client (GetRealZoneText), so every
	                      language shows its own client name. The wing words (Graveyard, East, …) stay English: their
	                      client names are NOT measured yet.
	  - zone, x, y ...... the entrance. From HandyNotes_DungeonRaidLocations-Forever v1.02, Data/Entrances.lua (MIT, see
	                      the notice below). 15 Nov 2026: v1.02 added Krol'dok, Alcaz, Blackmaw and Shaper's Terrace
	                      (before that web guides, marked web = true) and moved the Stockade; all rows follow v1.02.
	                      The web = true path (a "*" in the window) stays for a future row only a web guide has;
	                      no row uses it now. The 1.02 levels differ in places from ours; ours (DB2) stay.
	  - side ............ only for the "fits your level" line: DB2 LFGDungeons.Faction is 0 for Ragefire Chasm and 1 for
	                      the Stockade (MEASURED); 0 = Horde, 1 = Alliance is DERIVED. The list shows them for everyone.
	Nothing from ForeverDungeonJournal (no licence found = all rights reserved).

	------------------------------------------------------------------------------------------------------------------
	Entrance coordinates (every row without web = true) come from HandyNotes_DungeonRaidLocations-Forever:

	MIT License

	Copyright (c) 2025-2026 Pirson

	Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
	documentation files (the "Software"), to deal in the Software without restriction, including without limitation the
	rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to
	permit persons to whom the Software is furnished to do so, subject to the following conditions:

	The above copyright notice and this permission notice shall be included in all copies or substantial portions of the
	Software.

	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
	WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS
	OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
	OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
	------------------------------------------------------------------------------------------------------------------

	/mh dungeons = the window · /mh dungeons check = your level, side, what fits and why.
]]

if not ns.IS_FOREVER then
	return
end

local PREFIX = "|cffffcc00Midnight Helper:|r "
local GOOD, GREY, WARN = "|cff7fff7f", "|cff9d9d9d", "|cffffaa33"

-- Sorted by the lowest level. name = English fallback when the client gives no name for the map.
local DUNGEONS = {
	{ key = "RFC", name = "Ragefire Chasm", map = 389, min = 13, max = 18, zone = 1454, x = 53.2, y = 48.7, side = "Horde" },
	{ key = "THANES", name = "The Hall of Thanes", map = 3065, min = 13, max = 20, zone = 1455, x = 43.5, y = 52.0 },
	{ key = "LORDAERON", name = "Ruins of Lordaeron", map = 2999, min = 15, max = 22, zone = 1420, x = 64.4, y = 67.5 },
	{ key = "WC", name = "Wailing Caverns", map = 43, min = 15, max = 24, zone = 1413, x = 46.0, y = 36.4 },
	{ key = "DM", name = "The Deadmines", map = 36, min = 17, max = 26, zone = 1436, x = 42.5, y = 71.7 },
	{ key = "SFK", name = "Shadowfang Keep", map = 33, min = 20, max = 30, zone = 1421, x = 44.6, y = 67.7 },
	{ key = "STOCKS", name = "The Stockade", map = 34, min = 24, max = 32, zone = 1453, x = 50.3, y = 66.1, side = "Alliance" },
	{ key = "BFD", name = "Blackfathom Deeps", map = 48, min = 24, max = 32, zone = 1440, x = 14.5, y = 14.2 },
	{ key = "EXCAVATION", name = "Excavation Site", map = 2998, min = 26, max = 33, zone = 1437, x = 47.8, y = 56.3 },
	{ key = "DALARAN", name = "City of Dalaran", map = 2959, min = 28, max = 35, zone = 1416, x = 8.0, y = 61.2 },
	{ key = "GNOMER", name = "Gnomeregan", map = 90, min = 29, max = 38, zone = 1426, x = 24.3, y = 39.8 },
	{ key = "RFK", name = "Razorfen Kraul", map = 47, min = 29, max = 38, zone = 1413, x = 42.2, y = 89.8 },
	{ key = "SM_GY", name = "Scarlet Monastery", part = "Graveyard", map = 189, min = 30, max = 38, zone = 1420, x = 84.8, y = 30.3 },
	{ key = "SM_LIB", name = "Scarlet Monastery", part = "Library", map = 189, min = 33, max = 41, zone = 1420, x = 85.4, y = 32.5 },
	{ key = "DROWNED", name = "The Drowned City", map = 2970, min = 35, max = 42, zone = 1434, x = 21.4, y = 27.9 },
	{ key = "SM_ARM", name = "Scarlet Monastery", part = "Armory", map = 189, min = 36, max = 44, zone = 1420, x = 85.7, y = 31.9 },
	{ key = "RFD", name = "Razorfen Downs", map = 129, min = 37, max = 46, zone = 1413, x = 50.9, y = 92.9 },
	{ key = "SM_CATH", name = "Scarlet Monastery", part = "Cathedral", map = 189, min = 38, max = 46, zone = 1420, x = 85.3, y = 30.3 },
	{ key = "KROLDOK", name = "Krol'dok Stronghold", map = 3039, min = 40, max = 47, zone = 2548, x = 37.5, y = 37.3 },
	{ key = "ULDA", name = "Uldaman", map = 70, min = 41, max = 51, zone = 1418, x = 44.6, y = 12.1 },
	{ key = "ZF", name = "Zul'Farrak", map = 209, min = 44, max = 54, zone = 1446, x = 38.7, y = 19.5 },
	{ key = "MARA", name = "Maraudon", map = 349, min = 46, max = 55, zone = 1443, x = 29.1, y = 62.5 },
	{ key = "ALCAZ", name = "Alcaz Prison", map = 2994, min = 48, max = 55, zone = 1445, x = 75.3, y = 14.1 },
	{ key = "ST", name = "Sunken Temple", map = 109, min = 50, max = 60, zone = 1435, x = 69.9, y = 53.6 },
	{ key = "BRD", name = "Blackrock Depths", map = 230, min = 52, max = 60, zone = 1428, x = 29.4, y = 38.3 },
	{ key = "DM_E", name = "Dire Maul", part = "East", map = 429, min = 54, max = 60, zone = 1444, x = 64.8, y = 30.2 },
	{ key = "LBRS", name = "Blackrock Spire", part = "Lower", map = 229, min = 55, max = 60, zone = 1428, x = 29.4, y = 38.3 },
	{ key = "BLACKMAW", name = "Blackmaw Hold", map = 2974, min = 55, max = 60, zone = 1447, x = 38.6, y = 33.2 },
	{ key = "DM_N", name = "Dire Maul", part = "North", map = 429, min = 56, max = 60, zone = 1444, x = 62.9, y = 24.9 },
	{ key = "DM_W", name = "Dire Maul", part = "West", map = 429, min = 56, max = 60, zone = 1444, x = 60.3, y = 30.2 },
	{ key = "SHAPERS", name = "The Shaper's Terrace", map = 3001, min = 58, max = 60, zone = 1449, x = 48.1, y = 6.1 },
	{ key = "SCHOLO", name = "Scholomance", map = 289, min = 58, max = 60, zone = 1422, x = 69.0, y = 72.7 },
	{ key = "STRAT_LIVE", name = "Stratholme", part = "Main Gate", map = 329, min = 58, max = 60, zone = 1423, x = 27.8, y = 11.6 },
	{ key = "STRAT_UD", name = "Stratholme", part = "Service Gate", map = 329, min = 58, max = 60, zone = 1423, x = 43.6, y = 19.5 },
	{ key = "UBRS", name = "Blackrock Spire", part = "Upper", map = 229, min = 59, max = 60, zone = 1428, x = 29.4, y = 38.3, ten = true },
}
ns.FOREVER_DUNGEONS = DUNGEONS

local FIT_MAX = 3 -- how many the "Do this now" line names

local function Name(d)
	local n
	if GetRealZoneText then
		local ok, v = pcall(GetRealZoneText, d.map)
		if ok and type(v) == "string" and v ~= "" then
			n = v
		end
	end
	n = n or d.name
	return d.part and (n .. " (" .. d.part .. ")") or n
end

local function ZoneName(id)
	if C_Map and C_Map.GetMapInfo then
		local ok, info = pcall(C_Map.GetMapInfo, id)
		if ok and info and info.name then
			return info.name
		end
	end
	return "#" .. tostring(id)
end

local function MySide()
	local f = UnitFactionGroup and UnitFactionGroup("player")
	return f
end

--- Dungeons that fit this level (and side), the ones you outgrow first at the top.
local function Fits(level)
	local side, out = MySide(), {}
	for _, d in ipairs(DUNGEONS) do
		if level >= d.min and level <= d.max and (not d.side or d.side == side) then
			out[#out + 1] = d
		end
	end
	table.sort(out, function(a, b)
		if a.max ~= b.max then
			return a.max < b.max
		end
		return a.min < b.min
	end)
	return out
end

--- For "Do this now": one tip line, or nil below the first dungeon level.
function ns.ForeverDungeonTip()
	local level = UnitLevel and UnitLevel("player") or 1
	local fits = Fits(level)
	if #fits == 0 then
		return nil
	end
	local parts = {}
	for i = 1, math.min(#fits, FIT_MAX) do
		parts[i] = ns:L("FDUNG_IN_FMT"):format(Name(fits[i]), ZoneName(fits[i].zone))
	end
	local s = table.concat(parts, ", ")
	if #fits > FIT_MAX then
		s = s .. ", " .. ns:L("FRANK_HOME_MORE_FMT"):format(#fits - FIT_MAX)
	end
	return ns:L("FDUNG_FITS_FMT"):format(level, s)
end

local function GoTo(d)
	if not (ns.SetBlizzardUserWaypoint and ns.SetBlizzardUserWaypoint(d.zone, d.x, d.y)) then
		print(PREFIX .. ns:L("FVEND_NO_WAYPOINT"))
		return false
	end
	ns.lastTarget = { mapID = d.zone, x = d.x, y = d.y, name = Name(d), via = "/mh dungeons", arriveYards = 15 }
	ns._mhRouteOwner = "waypoint"
	print(PREFIX .. ns:L("FDUNG_ARROW_SET_FMT"):format(Name(d), ZoneName(d.zone))
		.. (d.web and (" " .. ns:L("FDUNG_WEB_NOTE")) or ""))
	return true
end

--------------------------------------------------------------------------------
-- No XP when someone is far above the enemies (15 Nov 2026; Rob via sparring: "Ja, op 12 levels, waarschuwing achterin.")
-- Blizzard (Kaivax, us.forums 2416343, posted 15 Nov 01:18 UTC; GEMETEN by mh-research): in a dungeon, nobody in the
-- group gets XP for an enemy when a group member is MORE THAN 12 levels above that enemy (12 still gives XP). Per enemy.
-- Before 14 Nov the rule was "grey for anyone". The game shows no text for it (GlobalStrings 1.60.1.70938, GEMETEN),
-- so MH says it. UnitLevel has no secret flag in Forever (Blizzard UI source); <= 0 = skull, unknown, skipped.
--------------------------------------------------------------------------------
local XP_GAP = 12

local GROUP_UNITS = { "player", "party1", "party2", "party3", "party4" }

--- The highest level in your group and who has it (you alone when not grouped).
function ns.ForeverGroupTop()
	local top, who = 0, nil
	for _, u in ipairs(GROUP_UNITS) do
		local okE, ex = pcall(UnitExists, u)
		if okE and ex then
			local okL, lv = pcall(UnitLevel, u)
			if okL and type(lv) == "number" and not (issecretvalue and issecretvalue(lv)) and lv > top then
				local okN, nm = pcall(UnitName, u)
				top, who = lv, (okN and type(nm) == "string" and not (issecretvalue and issecretvalue(nm))) and nm or "?"
			end
		end
	end
	return top, who
end

--- The dungeon you are in now, from the instance id (DUNGEONS' `map`), or nil.
local function CurrentDungeon()
	if not (IsInInstance and GetInstanceInfo) then
		return nil
	end
	local inInst, kind = IsInInstance()
	if not inInst or kind ~= "party" then
		return nil
	end
	local id = select(8, GetInstanceInfo())
	for _, d in ipairs(DUNGEONS) do
		if d.map == id then
			return d
		end
	end
	return nil
end

--- The warning line for the group panel, or nil; plus the reason (for /mh dungeons check).
function ns.ForeverNoXpLine()
	if not (IsInGroup and IsInGroup()) then
		return nil, "not in a group (the rule is about groups)"
	end
	local top, who = ns.ForeverGroupTop()
	local okE, hasTarget = pcall(UnitExists, "target")
	if okE and hasTarget and UnitCanAttack and UnitCanAttack("player", "target") then
		local okL, lv = pcall(UnitLevel, "target")
		if okL and type(lv) == "number" and lv > 0 then
			if top - lv > XP_GAP then
				return ns:L("FXP_TARGET_FMT"):format(who, top, lv), ("target level %d, top %d (%s): gap %d > %d")
					:format(lv, top, who, top - lv, XP_GAP)
			end
			return nil, ("target level %d, top %d: gap %d, XP still given"):format(lv, top, top - lv)
		end
	end
	local d = CurrentDungeon()
	if d and top > d.max + XP_GAP then
		return ns:L("FXP_DUNGEON_FMT"):format(who, top, Name(d)), ("in %s (max %d), top %d (%s)"):format(Name(d),
			d.max, top, who)
	end
	return nil, d and ("in %s (max %d), top %d: no warning"):format(Name(d), d.max, top)
		or ("no enemy target and not in a known dungeon; top %d"):format(top)
end

--------------------------------------------------------------------------------
-- Window (same look as "Your characters"; Shift+scroll and Escape via RegisterMidnightDialogPopup)
--------------------------------------------------------------------------------
-- 15 Nov 2026, Rob (via sparring, verbatim): "Kunnen we dat, die lijst aanpassen of zo updaten dat het per zone is? …
-- dat we een optie geven of we alles willen zien. Of alleen maar beschikbaar voor je level." and "Ja, we beginnen met
-- deel 1 en inderdaad net iets te hoog mag er ook bij." So: one header per zone (click = open/close), zones sorted by
-- their lowest dungeon level, only the zones with something for you open by themselves; a tick box "only for my
-- level" (account-wide, ns.db.foreverDungeonsAll = true means "show all"); "for my level" also counts a dungeon up to
-- NEAR levels above you (shown orange with "+N").
local NEAR = 2
local W, ROW_H, MAX_VISIBLE = 600, 22, 16
local COL_NAME, COL_LEVEL, COL_ZONE = 0, 270, 340
local INDENT = 16
local win, rows, heads, Refresh = nil, {}, {}, nil
local openZones, openLevel = {}, nil -- clicks this session; reset when your level changes

local function ShowAll()
	return ns.db and ns.db.foreverDungeonsAll == true
end

--- "fit" = in range now, "near" = up to NEAR levels too low, "low" = you outgrew it, "high" = further away.
local function State(d, level, side)
	if d.side and d.side ~= side then
		return "high"
	end
	if level > d.max then
		return "low"
	end
	if level >= d.min then
		return "fit"
	end
	if level >= d.min - NEAR then
		return "near"
	end
	return "high"
end

local function HeadRow(i)
	if heads[i] then
		return heads[i]
	end
	local h = CreateFrame("Button", nil, win.content)
	h:SetHeight(ROW_H)
	h:RegisterForClicks("LeftButtonUp")
	h.text = h:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	h.text:SetPoint("LEFT", 2, 0)
	h.text:SetJustifyH("LEFT")
	h.text:SetWidth(W - 60)
	h.text:SetWordWrap(false)
	h:SetHighlightTexture("Interface\\QuestFrame\\UI-QuestTitleHighlight", "ADD")
	h:SetScript("OnClick", function(self)
		if self.zone then
			openZones[self.zone] = not self.open
			Refresh()
		end
	end)
	heads[i] = h
	return h
end

local function Row(i)
	if rows[i] then
		return rows[i]
	end
	local r = CreateFrame("Frame", nil, win.content)
	r:SetHeight(ROW_H)
	r.name = r:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	r.name:SetPoint("LEFT", COL_NAME + INDENT, 0)
	r.name:SetWidth(COL_LEVEL - INDENT - 6)
	r.name:SetJustifyH("LEFT")
	r.name:SetWordWrap(false)
	r.level = r:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	r.level:SetPoint("LEFT", COL_LEVEL, 0)
	r.level:SetWidth(COL_ZONE - COL_LEVEL - 6)
	r.level:SetJustifyH("LEFT")
	r.zone = r:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	r.zone:SetPoint("LEFT", COL_ZONE, 0)
	r.zone:SetJustifyH("LEFT")
	r.zone:SetWordWrap(false)
	r.route = CreateFrame("Button", nil, r, "UIPanelButtonTemplate")
	r.route:SetHeight(18)
	r.route:SetPoint("RIGHT", -2, 0)
	r.route:SetScript("OnClick", function(self)
		if self.d then
			GoTo(self.d)
		end
	end)
	r.route:SetScript("OnEnter", function(self)
		if not (self.d and GameTooltip) then
			return
		end
		GameTooltip:SetOwner(self, "ANCHOR_LEFT")
		GameTooltip:SetText(Name(self.d))
		GameTooltip:AddLine(ns:L("FDUNG_IN_FMT"):format(ZoneName(self.d.zone), ("%.1f, %.1f"):format(self.d.x, self.d.y)),
			1, 1, 1)
		if ns.ForeverTravelSentence then
			local s = ns.ForeverTravelSentence(self.d.zone, self.d.x, self.d.y)
			if s then
				GameTooltip:AddLine(s, 0.8, 0.8, 0.8, true)
			end
		end
		if self.d.web then
			GameTooltip:AddLine(ns:L("FDUNG_WEB_NOTE"), 1, 0.67, 0.2, true)
		end
		GameTooltip:Show()
	end)
	r.route:SetScript("OnLeave", function()
		if GameTooltip then
			GameTooltip:Hide()
		end
	end)
	rows[i] = r
	return r
end

local function Build()
	if win then
		return win
	end
	local f = CreateFrame("Frame", "MidnightHelperForeverDungeons", UIParent, "BackdropTemplate")
	f:SetSize(W, 200)
	f:SetPoint("CENTER")
	f:SetFrameStrata("DIALOG")
	f:SetClampedToScreen(true)
	f:SetMovable(true)
	f:EnableMouse(true)
	f:RegisterForDrag("LeftButton")
	f:SetScript("OnDragStart", f.StartMoving)
	f:SetScript("OnDragStop", f.StopMovingOrSizing)
	f:SetBackdrop({
		bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
		edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Gold-Border",
		tile = true,
		tileSize = 32,
		edgeSize = 32,
		insets = { left = 11, right = 12, top = 12, bottom = 11 },
	})
	f:SetBackdropColor(1, 1, 1, 0.95)
	f.title = f:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
	f.title:SetPoint("TOP", 0, -18)
	local x = CreateFrame("Button", nil, f, "UIPanelCloseButton")
	x:SetPoint("TOPRIGHT", -6, -6)

	-- The tick box: ticked = only what fits your level (and up to NEAR levels higher). Remembered for the account.
	local cb = CreateFrame("CheckButton", nil, f, "UICheckButtonTemplate")
	cb:SetSize(24, 24)
	cb:SetPoint("TOPLEFT", 16, -40)
	cb.label = f:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	cb.label:SetPoint("LEFT", cb, "RIGHT", 2, 0)
	cb.label:SetWidth(W - 80)
	cb.label:SetJustifyH("LEFT")
	cb:SetScript("OnClick", function(self)
		if ns.db then
			ns.db.foreverDungeonsAll = (not self:GetChecked()) or nil
		end
		Refresh()
	end)
	f.mine = cb

	f.heads = {}
	for _, h in ipairs({ { "FDUNG_COL_NAME", COL_NAME }, { "FDUNG_COL_LEVEL", COL_LEVEL }, { "FDUNG_COL_WHERE", COL_ZONE } }) do
		local fs = f:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
		fs:SetPoint("TOPLEFT", 20 + h[2], -68)
		fs.key = h[1]
		f.heads[#f.heads + 1] = fs
	end

	local scroll = CreateFrame("ScrollFrame", nil, f, "UIPanelScrollFrameTemplate")
	scroll:SetPoint("TOPLEFT", 18, -86)
	scroll:SetPoint("BOTTOMRIGHT", -36, 50)
	local content = CreateFrame("Frame", nil, scroll)
	content:SetSize(W - 54, 10)
	scroll:SetScrollChild(content)
	f.scroll, f.content = scroll, content

	f.note = f:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
	f.note:SetPoint("BOTTOMLEFT", 22, 18)
	f.note:SetWidth(W - 44)
	f.note:SetJustifyH("LEFT")

	f:Hide()
	win = f
	tinsert(UISpecialFrames, "MidnightHelperForeverDungeons")
	if ns.RegisterMidnightDialogPopup then
		ns.RegisterMidnightDialogPopup(f)
	end
	return f
end

Refresh = function()
	local f = Build()
	f.title:SetText(ns:L("FDUNG_TITLE"))
	for _, h in ipairs(f.heads) do
		h:SetText(ns:L(h.key))
	end
	local level = UnitLevel and UnitLevel("player") or 1
	local side = MySide()
	local all = ShowAll()
	f.mine:SetChecked(not all)
	f.mine.label:SetText(ns:L("FDUNG_ONLY_MINE_FMT"):format(NEAR))
	if openLevel ~= level then
		openZones, openLevel = {}, level
	end

	-- Group by zone; a zone sorts by its lowest dungeon level (over ALL its dungeons, so the order never jumps).
	local groups, byZone = {}, {}
	for _, d in ipairs(DUNGEONS) do
		local g = byZone[d.zone]
		if not g then
			g = { zone = d.zone, name = ZoneName(d.zone), low = d.min, list = {}, mine = false }
			byZone[d.zone] = g
			groups[#groups + 1] = g
		end
		g.low = math.min(g.low, d.min)
		local st = State(d, level, side)
		if all or st == "fit" or st == "near" then
			g.list[#g.list + 1] = { d = d, st = st }
		end
		if st == "fit" or st == "near" then
			g.mine = true
		end
	end
	table.sort(groups, function(a, b)
		if a.low ~= b.low then
			return a.low < b.low
		end
		return a.name < b.name
	end)

	local routeText = ns:L("FDUNG_ROUTE")
	-- No-XP marker: only in a group (the rule is about groups); the highest member against the dungeon's top level.
	local gtop, gwho = 0, nil
	if IsInGroup and IsInGroup() then
		gtop, gwho = ns.ForeverGroupTop()
	end
	local anyNoXp = false
	local y, nh, nr = 0, 0, 0
	for _, g in ipairs(groups) do
		if #g.list > 0 then
			local open = openZones[g.zone]
			if open == nil then
				open = g.mine
			end
			nh = nh + 1
			local h = HeadRow(nh)
			h:ClearAllPoints()
			h:SetPoint("TOPLEFT", 0, -y)
			h:SetWidth(W - 54)
			h.zone, h.open = g.zone, open
			h.text:SetText((open and "[-] " or "[+] ") .. ns:L("FDUNG_ZONE_FMT"):format(g.name, #g.list))
			h:Show()
			y = y + ROW_H
			if open then
				for _, e in ipairs(g.list) do
					local d, st = e.d, e.st
					nr = nr + 1
					local r = Row(nr)
					r:ClearAllPoints()
					r:SetPoint("TOPLEFT", 0, -y)
					r:SetWidth(W - 54)
					local col = (st == "fit" and GOOD) or (st == "near" and WARN) or (st == "low" and GREY) or ""
					local noXp = gwho and gtop > d.max + XP_GAP
					anyNoXp = anyNoXp or noXp
					r.name:SetText(col .. Name(d) .. (col ~= "" and "|r" or "") .. (noXp and " |cffff5555*|r" or ""))
					local lv = ("%d-%d"):format(d.min, d.max)
					if st == "near" then
						lv = lv .. " (+" .. (d.min - level) .. ")"
					end
					if d.ten then
						lv = lv .. " " .. ns:L("FDUNG_TEN")
					end
					r.level:SetText(col .. lv .. (col ~= "" and "|r" or ""))
					-- 15 Nov 2026, Rob: "in de kolom entrance inderdaad de coördinaten, want 2 keer dezelfde zonnenaam
					-- staat nergens op" - the zone is the header now; the Route tooltip still names it.
					r.zone:SetText(("%.1f, %.1f"):format(d.x, d.y) .. (d.web and (" " .. WARN .. "*|r") or ""))
					r.route:SetText(routeText)
					local fs = r.route:GetFontString()
					local bw = math.max(60, math.ceil(((fs and fs:GetStringWidth()) or 40) + 20))
					r.route:SetWidth(bw)
					r.zone:SetWidth(W - 54 - COL_ZONE - bw - 8)
					r.route.d = d
					r:Show()
					y = y + ROW_H
				end
			end
		end
	end
	for i = nh + 1, #heads do
		heads[i]:Hide()
	end
	for i = nr + 1, #rows do
		rows[i]:Hide()
	end
	if nh == 0 then
		-- Nothing for this level (e.g. below 11): say so where the list would be, and how to see everything.
		nh = 1
		local h = HeadRow(1)
		h:ClearAllPoints()
		h:SetPoint("TOPLEFT", 0, 0)
		h:SetWidth(W - 54)
		h.zone = nil
		h.text:SetText(GREY .. ns:L("FDUNG_NONE_MINE") .. "|r")
		h:Show()
		y = ROW_H
	end
	f.content:SetHeight(math.max(y, ROW_H))
	-- The no-XP explanation sits under the list, in the same room as the stars (CLAUDE.md: say it where you look).
	local extra = anyNoXp and 28 or 0
	f.note:SetText(ns:L("FDUNG_NOTE") .. (anyNoXp and ("\n" .. ns:L("FXP_LIST_NOTE_FMT"):format(gwho, gtop)) or ""))
	f.scroll:SetPoint("BOTTOMRIGHT", -36, 50 + extra)
	f:SetHeight(86 + MAX_VISIBLE * ROW_H + 56 + extra)
end

function ns.ShowForeverDungeons()
	Refresh()
	win:Show()
end

--- /mh dungeons · /mh dungeons check
function ns.ForeverDungeonsSlash(arg)
	arg = (arg or ""):lower()
	if arg == "check" or arg == "why" then
		local level = UnitLevel and UnitLevel("player") or 1
		local fits, web = Fits(level), 0
		for _, d in ipairs(DUNGEONS) do
			if d.web then
				web = web + 1
			end
		end
		print(PREFIX .. ("dungeons: %d in the list (%d with an entrance from web guides, not checked in game); level %d, side %s; %d fit now")
			:format(#DUNGEONS, web, level, tostring(MySide()), #fits))
		local near = {}
		for _, d in ipairs(DUNGEONS) do
			if State(d, level, MySide()) == "near" then
				near[#near + 1] = ("%s (+%d)"):format(Name(d), d.min - level)
			end
		end
		print(("  window: %s; up to %d levels higher counts too: %s"):format(
			ShowAll() and "shows ALL dungeons" or "shows only the ones for your level",
			NEAR, #near > 0 and table.concat(near, ", ") or "(none)"))
		for _, d in ipairs(fits) do
			print(("  - %s %d-%d, %s (%.1f, %.1f)%s"):format(Name(d), d.min, d.max, ZoneName(d.zone), d.x, d.y,
				d.web and " [web]" or ""))
		end
		local tip = ns.ForeverDungeonTip()
		print("  Do this now line: " .. (tip or "(none: no dungeon fits this level)"))
		local top, who = ns.ForeverGroupTop()
		local line, why = ns.ForeverNoXpLine()
		print(("  no-XP rule (> %d levels above an enemy, Blizzard 14 Nov 2026): top of group %d (%s); %s"):format(
			XP_GAP, top, tostring(who), why))
		print("  group panel line: " .. (line or "(none)"))
		return
	end
	if win and win:IsShown() then
		win:Hide()
		return
	end
	ns.ShowForeverDungeons()
end
