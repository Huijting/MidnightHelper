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
-- Window (same look as "Your characters"; Shift+scroll and Escape via RegisterMidnightDialogPopup)
--------------------------------------------------------------------------------
local W, ROW_H, MAX_VISIBLE = 600, 22, 16
local COL_NAME, COL_LEVEL, COL_ZONE = 0, 270, 340
local win, rows, Refresh = nil, {}, nil

local function Row(i)
	if rows[i] then
		return rows[i]
	end
	local r = CreateFrame("Frame", nil, win.content)
	r:SetHeight(ROW_H)
	r.name = r:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	r.name:SetPoint("LEFT", COL_NAME + 2, 0)
	r.name:SetWidth(COL_LEVEL - 8)
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

	f.heads = {}
	for _, h in ipairs({ { "FDUNG_COL_NAME", COL_NAME }, { "FDUNG_COL_LEVEL", COL_LEVEL }, { "FDUNG_COL_WHERE", COL_ZONE } }) do
		local fs = f:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
		fs:SetPoint("TOPLEFT", 20 + h[2], -46)
		fs.key = h[1]
		f.heads[#f.heads + 1] = fs
	end

	local scroll = CreateFrame("ScrollFrame", nil, f, "UIPanelScrollFrameTemplate")
	scroll:SetPoint("TOPLEFT", 18, -64)
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
	local routeText = ns:L("FDUNG_ROUTE")
	for i, d in ipairs(DUNGEONS) do
		local r = Row(i)
		r:ClearAllPoints()
		r:SetPoint("TOPLEFT", 0, -(i - 1) * ROW_H)
		r:SetWidth(W - 54)
		local fits = level >= d.min and level <= d.max and (not d.side or d.side == side)
		local col = fits and GOOD or (level > d.max and GREY or "")
		r.name:SetText(col .. Name(d) .. (col ~= "" and "|r" or ""))
		local lv = ("%d-%d"):format(d.min, d.max)
		if d.ten then
			lv = lv .. " " .. ns:L("FDUNG_TEN")
		end
		r.level:SetText(col .. lv .. (col ~= "" and "|r" or ""))
		r.zone:SetText(ZoneName(d.zone) .. (d.web and (" " .. WARN .. "*|r") or ""))
		r.route:SetText(routeText)
		local fs = r.route:GetFontString()
		local bw = math.max(60, math.ceil(((fs and fs:GetStringWidth()) or 40) + 20))
		r.route:SetWidth(bw)
		r.zone:SetWidth(W - 54 - COL_ZONE - bw - 8)
		r.route.d = d
		r:Show()
	end
	for i = #DUNGEONS + 1, #rows do
		rows[i]:Hide()
	end
	f.content:SetHeight(#DUNGEONS * ROW_H)
	f.note:SetText(ns:L("FDUNG_NOTE"))
	f:SetHeight(64 + MAX_VISIBLE * ROW_H + 56)
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
		for _, d in ipairs(fits) do
			print(("  - %s %d-%d, %s (%.1f, %.1f)%s"):format(Name(d), d.min, d.max, ZoneName(d.zone), d.x, d.y,
				d.web and " [web]" or ""))
		end
		local tip = ns.ForeverDungeonTip()
		print("  Do this now line: " .. (tip or "(none: no dungeon fits this level)"))
		return
	end
	if win and win:IsShown() then
		win:Hide()
		return
	end
	ns.ShowForeverDungeons()
end
