--[[
	Instance map: the floor plan of a dungeon or raid, with its bosses on it.

	Rob, 27 sep 2026, after Cisca lost her group in a raid: "kunnen we niet eenvoudige plaatjes
	krijgen in MH met hoe de layout van een raid bv is? zonder dat we vele mb's groter worden?"
	No images are shipped. The client already carries every floor's map art (the world map shows
	it inside), and the Encounter Journal knows where each boss stands per floor. MEASURED that
	day with /mh mapprobe show 2606: The Venomous Abyss drew complete, from outside the instance,
	with Nek'zali in place.

	What it cannot show: where your group is. Positions of anyone inside an instance are hidden
	from addons (MEASURED 27 sep, /mh groupmap: nil for every member and for yourself).

	Open it with the Map button on the Raids and Dungeons pages, or `/mh map` inside an instance
	(opens the floor you are on). A boss on the map is clickable: it opens MH's tips for that boss.
]]

local _, ns = ...

local WIN_NAME = "MidnightHelperInstanceMap"
local ART_W = 620

local function L(key)
	return ns:L(key)
end

local win
local current -- { entry = <raid/dungeon table or nil>, name = string, floors = { {mapID, name} }, floor = index }

--------------------------------------------------------------------------------
-- Finding the map
--------------------------------------------------------------------------------

--- The journal id for one of our raid or dungeon entries. Most carry it; the Season 1 raids do not,
--- so those are looked up by their English name in the current journal tier (cached). On a client in
--- another language that name lookup can miss; then the entry simply has no map.
local nameToJid
local function JournalIdFor(entry)
	if not entry then
		return nil
	end
	if entry.journalInstanceID then
		return entry.journalInstanceID
	end
	if not nameToJid then
		nameToJid = {}
		if EJ_GetNumTiers and EJ_SelectTier and EJ_GetInstanceByIndex then
			local before = EJ_GetCurrentTier and EJ_GetCurrentTier() or nil
			-- ⚠️ NOT ONLY THE NEWEST TIER. MEASURED 27 sep (Rob's /mh mapprobe): the newest tier holds
			-- Season 2 (The Venomous Abyss, The Tidebound Grotto) and NOT The Voidspire, The Dreamrift
			-- or March on Quel'Danas, which then printed "No map found". Newest first, so a name that
			-- exists twice resolves to the current one.
			local top = EJ_GetNumTiers()
			for tier = top, math.max(1, top - 3), -1 do
				pcall(EJ_SelectTier, tier)
				for _, isRaid in ipairs({ true, false }) do
					for i = 1, 40 do
						local ok, jid, name = pcall(EJ_GetInstanceByIndex, i, isRaid)
						if not ok or not jid then
							break
						end
						if name and not nameToJid[name] then
							nameToJid[name] = jid
						end
					end
				end
			end
			if before then
				pcall(EJ_SelectTier, before)
			end
		end
	end
	return entry.name and nameToJid[entry.name] or nil
end

--- journal id -> the first dungeon-type map that belongs to it, from the whole world's map tree.
---
--- ⚠️ MEASURED 27 sep (/mh mapprobe on Rob's client): EJ_GetInstanceInfo's area map is filled for the
--- raids (The Venomous Abyss 2606) but 0 for every dungeon. So the second road: every map of type
--- Dungeon under the cosmic map, each asked which journal instance it is. Language-independent, done
--- once, on the first map that needs it.
local jidToMap
local function MapFromWorld(jid)
	if not jidToMap then
		jidToMap = {}
		local DUNGEON = (Enum and Enum.UIMapType and Enum.UIMapType.Dungeon) or 4
		local ok, list = pcall(C_Map.GetMapChildrenInfo, 946, DUNGEON, true)
		for _, m in ipairs(ok and list or {}) do
			if EJ_GetInstanceForMap then
				local okE, id = pcall(EJ_GetInstanceForMap, m.mapID)
				if okE and id and id > 0 and (not jidToMap[id] or m.mapID < jidToMap[id]) then
					jidToMap[id] = m.mapID
				end
			end
		end
	end
	return jidToMap[jid]
end

local function FirstMapOf(jid)
	if not (jid and EJ_GetInstanceInfo) then
		return nil, nil
	end
	local ok, name, _, _, _, _, _, areaMap = pcall(EJ_GetInstanceInfo, jid)
	if ok and areaMap and areaMap > 0 then
		return areaMap, name
	end
	return MapFromWorld(jid), ok and name or nil
end

--- For /mh mapprobe: the same two roads to a journal instance's first floor as the window takes.
function ns.InstanceMapResolve(jid)
	return (FirstMapOf(jid))
end

local function FloorsOf(mapID)
	local out = {}
	local okG, groupID = pcall(C_Map.GetMapGroupID, mapID)
	if okG and groupID then
		local okF, list = pcall(C_Map.GetMapGroupMembersInfo, groupID)
		for _, f in ipairs(okF and list or {}) do
			out[#out + 1] = { mapID = f.mapID, name = f.name }
		end
	end
	if #out == 0 then
		local okI, info = pcall(C_Map.GetMapInfo, mapID)
		out[1] = { mapID = mapID, name = okI and info and info.name or "" }
	end
	return out
end

--- Every raid and dungeon entry MH knows, to link a map back to its boss tips.
local function AllEntries()
	local list = {}
	for _, r in ipairs((ns.GetRaidPageList and ns.GetRaidPageList()) or (ns.GetRaidCoachRaids and ns.GetRaidCoachRaids()) or {}) do
		list[#list + 1] = r
	end
	for _, d in ipairs(ns.DUNGEON_ROSTER or {}) do
		list[#list + 1] = d
	end
	return list
end

--------------------------------------------------------------------------------
-- Window
--------------------------------------------------------------------------------

local function BossKeyFor(entry, encounterID)
	for _, b in ipairs((entry and entry.bosses) or {}) do
		if b.encounterID == encounterID then
			return b.key
		end
	end
	return nil
end

local function Build()
	if win then
		return win
	end
	local f = CreateFrame("Frame", WIN_NAME, UIParent, "BackdropTemplate")
	f:SetSize(ART_W + 40, 520)
	f:SetFrameStrata("HIGH")
	local saved = ns.db and ns.db.ui and ns.db.ui.instanceMapPos
	if type(saved) == "table" and saved[1] then
		f:SetPoint(saved[1], UIParent, saved[2] or saved[1], tonumber(saved[3]) or 0, tonumber(saved[4]) or 0)
	else
		f:SetPoint("CENTER")
	end
	f:Hide()
	if ns.ApplyMidnightDialogBackdrop then
		ns.ApplyMidnightDialogBackdrop(f)
	end
	f:SetMovable(true)
	f:EnableMouse(true)
	f:RegisterForDrag("LeftButton")
	f:SetScript("OnDragStart", function(self)
		self:StartMoving()
	end)
	f:SetScript("OnDragStop", function(self)
		self:StopMovingOrSizing()
		local p, _, rp, x, y = self:GetPoint(1)
		if p and ns.db then
			ns.db.ui = ns.db.ui or {}
			ns.db.ui.instanceMapPos = { p, rp, x, y }
		end
	end)
	if ns.RegisterMidnightDialogPopup then
		ns.RegisterMidnightDialogPopup(f)
	end
	local titleBar, content
	if ns.EnsureMidnightDialogTitleBar then
		titleBar, content = ns.EnsureMidnightDialogTitleBar(f)
	end
	if titleBar then
		titleBar:EnableMouse(false)
	end
	if ns.AttachMidnightDialogCloseButton then
		ns.AttachMidnightDialogCloseButton(f)
	end
	content = content or f
	local title = (titleBar or f):CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
	title:SetPoint("LEFT", titleBar or f, "LEFT", 0, 0)
	title:SetJustifyH("LEFT")
	title:SetWidth(ART_W - 120)
	title:SetWordWrap(false)
	title:SetTextColor(1, 0.9, 0.55)
	f._title = title

	f._content = content
	f._floorBtns = {}
	f.canvas = CreateFrame("Frame", nil, content)
	f.tiles, f.pins = {}, {}
	f.note = content:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	f.note:SetJustifyH("LEFT")
	f.note:SetTextColor(0.62, 0.6, 0.56)
	win = f
	return f
end

local Draw

local function FloorButton(i)
	local b = win._floorBtns[i]
	if not b then
		b = CreateFrame("Button", nil, win._content)
		b:SetHeight(24)
		b.fs = b:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
		b.fs:SetPoint("CENTER", 0, 1)
		b.line = b:CreateTexture(nil, "ARTWORK")
		b.line:SetColorTexture(1, 0.82, 0.2, 0.9)
		b.line:SetHeight(2)
		b.line:SetPoint("BOTTOMLEFT", 4, 0)
		b.line:SetPoint("BOTTOMRIGHT", -4, 0)
		b:SetHighlightTexture("Interface\\Buttons\\UI-Listbox-Highlight2", "ADD")
		win._floorBtns[i] = b
	end
	b:Show()
	return b
end

local function Pin(i)
	local p = win.pins[i]
	if not p then
		p = CreateFrame("Button", nil, win.canvas)
		p:SetSize(22, 22)
		p.tex = p:CreateTexture(nil, "OVERLAY")
		p.tex:SetAllPoints()
		p.tex:SetTexture("Interface\\TargetingFrame\\UI-RaidTargetingIcon_8")
		p.fs = p:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmallOutline")
		p.fs:SetPoint("TOP", p, "BOTTOM", 0, -1)
		p:SetScript("OnEnter", function(self)
			if GameTooltip then
				GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
				GameTooltip:SetText(self.bossName or "", 1, 0.82, 0.2)
				if self.bossKey then
					GameTooltip:AddLine(L("INSTMAP_BOSS_CLICK"), 0.9, 0.88, 0.82, true)
				end
				GameTooltip:Show()
			end
		end)
		p:SetScript("OnLeave", function()
			if GameTooltip then
				GameTooltip:Hide()
			end
		end)
		p:SetScript("OnClick", function(self)
			if self.bossKey and current and current.entry and ns.OpenBossWindowFor then
				ns.OpenBossWindowFor(current.entry, self.bossKey)
			end
		end)
		win.pins[i] = p
	end
	return p
end

--- A floor transition: Blizzard's own stair/portal atlas, the target floor's name, a click goes there.
--- Rob, 27 Sep 2026: "kunnen wij op die mapjes iets tekenen, zoals de overgang in een raid naar een
--- andere map?" MEASURED the same day with /mh mapprobe: 57 map links over the season's raids and
--- dungeons (The Venomous Abyss 10, Windrunner Spire 17), with positions and target maps.
local function LinkPin(i)
	win.linkPins = win.linkPins or {}
	local k = win.linkPins[i]
	if not k then
		k = CreateFrame("Button", nil, win.canvas)
		k:SetSize(24, 24)
		k.tex = k:CreateTexture(nil, "OVERLAY")
		k.tex:SetAllPoints()
		k.fs = k:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmallOutline")
		k.fs:SetPoint("TOP", k, "BOTTOM", 0, -1)
		k.fs:SetTextColor(0.55, 1, 0.55)
		k:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Square", "ADD")
		k:SetScript("OnEnter", function(self)
			if GameTooltip then
				GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
				GameTooltip:SetText(self.targetName or "", 0.55, 1, 0.55)
				if self.floorIndex then
					GameTooltip:AddLine(L("INSTMAP_LINK_CLICK"), 0.9, 0.88, 0.82, true)
				end
				GameTooltip:Show()
			end
		end)
		k:SetScript("OnLeave", function()
			if GameTooltip then
				GameTooltip:Hide()
			end
		end)
		k:SetScript("OnClick", function(self)
			if self.floorIndex and current then
				current.floor = self.floorIndex
				Draw()
			end
		end)
		win.linkPins[i] = k
	end
	return k
end

function Draw()
	if not (win and current) then
		return
	end
	for _, k in ipairs(win.linkPins or {}) do
		k:Hide()
	end
	for _, t in ipairs(win.tiles) do
		t:Hide()
	end
	for _, p in ipairs(win.pins) do
		p:Hide()
	end
	for _, b in ipairs(win._floorBtns) do
		b:Hide()
	end
	win._title:SetText(current.name or "")
	local y = -32

	-- One button per floor, when there is more than one.
	if #current.floors > 1 then
		local x = 0
		for i, fl in ipairs(current.floors) do
			local b = FloorButton(i)
			b:ClearAllPoints()
			b:SetPoint("TOPLEFT", win._content, "TOPLEFT", x, y)
			b.fs:SetText(fl.name ~= "" and fl.name or ("#" .. i))
			b:SetWidth(b.fs:GetStringWidth() + 18)
			local on = i == current.floor
			b.fs:SetTextColor(on and 1 or 0.62, on and 0.82 or 0.6, on and 0.2 or 0.56)
			b.line:SetShown(on)
			b:SetScript("OnClick", function()
				current.floor = i
				Draw()
			end)
			x = x + b:GetWidth() + 4
			if x > ART_W - 60 then
				x = 0
				y = y - 26
			end
		end
		y = y - 30
	end

	local mapID = current.floors[current.floor].mapID
	local okL, layers = pcall(C_Map.GetMapArtLayers, mapID)
	local l1 = okL and type(layers) == "table" and layers[1] or nil
	local okT, tex = pcall(C_Map.GetMapArtLayerTextures, mapID, 1)
	tex = okT and type(tex) == "table" and tex or {}
	win.canvas:ClearAllPoints()
	win.canvas:SetPoint("TOPLEFT", win._content, "TOPLEFT", 0, y)
	if not (l1 and l1.layerWidth and l1.tileWidth and #tex > 0) then
		win.canvas:SetSize(ART_W, 1)
		win.note:ClearAllPoints()
		win.note:SetPoint("TOPLEFT", win._content, "TOPLEFT", 0, y - 4)
		win.note:SetWidth(ART_W)
		win.note:SetText(L("INSTMAP_NO_ART"))
		win:SetHeight(32 + (-y) + 60)
		return
	end
	local scale = ART_W / l1.layerWidth
	local W, H = ART_W, l1.layerHeight * scale
	win.canvas:SetSize(W, H)
	local cols = math.ceil(l1.layerWidth / l1.tileWidth)
	for i, fileID in ipairs(tex) do
		local t = win.tiles[i] or win.canvas:CreateTexture(nil, "ARTWORK")
		win.tiles[i] = t
		local col, row = (i - 1) % cols, math.floor((i - 1) / cols)
		t:ClearAllPoints()
		t:SetSize(l1.tileWidth * scale, l1.tileHeight * scale)
		t:SetPoint("TOPLEFT", win.canvas, "TOPLEFT", col * l1.tileWidth * scale, -row * l1.tileHeight * scale)
		t:SetTexture(fileID)
		t:Show()
	end

	if C_EncounterJournal and C_EncounterJournal.GetEncountersOnMap then
		local okE, list = pcall(C_EncounterJournal.GetEncountersOnMap, mapID)
		for i, e in ipairs(okE and list or {}) do
			local p = Pin(i)
			local name = EJ_GetEncounterInfo and select(1, EJ_GetEncounterInfo(e.encounterID)) or nil
			p.bossName = name or ""
			p.bossKey = BossKeyFor(current.entry, e.encounterID)
			p.fs:SetText(name or "")
			p:ClearAllPoints()
			p:SetPoint("CENTER", win.canvas, "TOPLEFT", (e.mapX or 0) * W, -(e.mapY or 0) * H)
			p:Show()
		end
	end

	if C_Map.GetMapLinksForMap then
		local okK, links = pcall(C_Map.GetMapLinksForMap, mapID)
		for i, lk in ipairs(okK and type(links) == "table" and links or {}) do
			local x, y
			if lk.position and lk.position.GetXY then
				x, y = lk.position:GetXY()
			end
			if x and y then
				local k = LinkPin(i)
				local okA = lk.atlasName and pcall(k.tex.SetAtlas, k.tex, lk.atlasName)
				if not okA then
					k.tex:SetTexture("Interface\\Minimap\\MiniMap-QuestArrow")
				end
				-- Name the floor it leads to; the link's own name is sometimes just the instance's.
				k.floorIndex = nil
				local target = lk.name
				for fi, fl in ipairs(current.floors) do
					if fl.mapID == lk.linkedUiMapID then
						k.floorIndex = fi
						if fl.name and fl.name ~= "" then
							target = fl.name
						end
					end
				end
				k.targetName = target or ""
				k.fs:SetText(target or "")
				k:ClearAllPoints()
				k:SetPoint("CENTER", win.canvas, "TOPLEFT", x * W, -y * H)
				k:Show()
			end
		end
	end

	win.note:ClearAllPoints()
	win.note:SetPoint("TOPLEFT", win.canvas, "BOTTOMLEFT", 0, -6)
	win.note:SetWidth(ART_W)
	win.note:SetText(L("INSTMAP_NOTE"))
	win:SetHeight(32 + (-y) + H + win.note:GetStringHeight() + 30)
end

--- Open the map of one of our raid or dungeon entries (the Map buttons).
function ns.ShowInstanceMapFor(entry)
	local first, name = FirstMapOf(JournalIdFor(entry))
	Build()
	if not first then
		print(("|cffffcc00%s|r %s"):format(L("PRINT_PREFIX"),
			(L("INSTMAP_NO_MAP_FMT")):format((ns.GetDungeonDisplayName and ns.GetDungeonDisplayName(entry)) or entry.name or "?")))
		return
	end
	local floors = FloorsOf(first)
	current = { entry = entry, name = name or entry.name, floors = floors, floor = 1 }
	win:Show()
	Draw()
end

--- A map found by its name in the world's map tree (Dungeon and Micro types). For delves: they are
--- not in the Encounter Journal, so there is no journal id to go by -- and no bosses to place either.
--- The delve list names come from the client, so the names match on every language.
---
--- ⚠️ MEASURED 27 sep (Rob): six delves printed "No map found" -- The Shadow Enclave, The Gulf of
--- Memory, The Grudge Pit, The Ring of Glory, and both Venomfall Deeps, which our list writes with the
--- zone in brackets to tell them apart. So names are compared loosely (no brackets, no leading article,
--- no punctuation, any case), and Zone and Orphan maps are searched too. A miss still records the
--- nearest map names in ns.db.instanceMapMiss, so the next round is measured instead of guessed.
local allMaps -- { { id, type, name, key } }
local function Norm(s)
	s = tostring(s or ""):lower()
	s = s:gsub("%s*%b()", "")
	s = s:gsub("^the%s+", "")
	s = s:gsub("[%p]", "")
	s = s:gsub("%s+", " ")
	return (s:gsub("^%s+", ""):gsub("%s+$", ""))
end

local function AllMaps()
	if allMaps then
		return allMaps
	end
	allMaps = {}
	local E = Enum and Enum.UIMapType or {}
	local types = { E.Dungeon or 4, E.Micro or 5, E.Zone or 3, E.Orphan or 6 }
	local seen = {}
	for _, t in ipairs(types) do
		local ok, list = pcall(C_Map.GetMapChildrenInfo, 946, t, true)
		for _, m in ipairs(ok and list or {}) do
			if m.name and m.name ~= "" and not seen[m.mapID] then
				seen[m.mapID] = true
				allMaps[#allMaps + 1] = { id = m.mapID, type = t, name = m.name, key = Norm(m.name), parent = m.parentMapID }
			end
		end
	end
	-- Dungeon and Micro maps first: a delve is one of those far more often than a zone.
	table.sort(allMaps, function(a, b)
		local pa = (a.type == (E.Dungeon or 4) or a.type == (E.Micro or 5)) and 0 or 1
		local pb = (b.type == (E.Dungeon or 4) or b.type == (E.Micro or 5)) and 0 or 1
		if pa ~= pb then
			return pa < pb
		end
		return a.id < b.id
	end)
	return allMaps
end

local function MapByName(name)
	if not name then
		return nil
	end
	local want = Norm(name)
	for _, m in ipairs(AllMaps()) do
		if m.name == name then
			return m.id
		end
	end
	-- Two delves can share a name (Venomfall Deeps, in Zul'Aman and on The Coiled Isle); our list then
	-- adds the zone in brackets. With more than one match, take the one whose parent maps name that zone.
	local zone = name:match("%((.-)%)")
	zone = zone and Norm(zone) or nil
	local matches = {}
	for _, m in ipairs(AllMaps()) do
		if m.key == want then
			matches[#matches + 1] = m
		end
	end
	if #matches > 1 and zone then
		for _, m in ipairs(matches) do
			local p, hops = m.parent, 0
			while p and p > 0 and hops < 4 do
				local okI, info = pcall(C_Map.GetMapInfo, p)
				if not (okI and info) then
					break
				end
				if Norm(info.name) == zone then
					return m.id
				end
				p, hops = info.parentMapID, hops + 1
			end
		end
	end
	if matches[1] then
		return matches[1].id
	end
	-- Record what came closest: maps sharing the longest word of the name.
	local longest = ""
	for w in want:gmatch("%S+") do
		if #w > #longest then
			longest = w
		end
	end
	local near = {}
	if #longest >= 4 then
		for _, m in ipairs(AllMaps()) do
			if m.key:find(longest, 1, true) and #near < 12 then
				near[#near + 1] = ("%d:%d:%s"):format(m.id, m.type, m.name)
			end
		end
	end
	if ns.db then
		ns.db.instanceMapMiss = ns.db.instanceMapMiss or {}
		ns.db.instanceMapMiss[name] = near
	end
	return nil
end

--- Open a map by its name (the Map icon on each row of the Delves page).
function ns.ShowInstanceMapByName(name)
	local mapID = MapByName(name)
	Build()
	if not mapID then
		print(("|cffffcc00%s|r %s"):format(L("PRINT_PREFIX"), (L("INSTMAP_NO_MAP_FMT")):format(name or "?")))
		return
	end
	current = { entry = nil, name = name, floors = FloorsOf(mapID), floor = 1 }
	win:Show()
	Draw()
end

--- `/mh map`: inside a dungeon or raid, the floor you are standing on.
function ns.ShowCurrentInstanceMap()
	local inside = IsInInstance and IsInInstance()
	local okM, mapID = pcall(C_Map.GetBestMapForUnit, "player")
	if not (inside and okM and mapID) then
		print(("|cffffcc00%s|r %s"):format(L("PRINT_PREFIX"), L("INSTMAP_NOT_INSIDE")))
		return
	end
	local jid = EJ_GetInstanceForMap and select(1, EJ_GetInstanceForMap(mapID)) or nil
	local entry
	for _, e in ipairs(AllEntries()) do
		if jid and JournalIdFor(e) == jid then
			entry = e
			break
		end
	end
	local floors = FloorsOf(mapID)
	local floor = 1
	for i, fl in ipairs(floors) do
		if fl.mapID == mapID then
			floor = i
		end
	end
	local name = GetInstanceInfo and select(1, GetInstanceInfo()) or ""
	Build()
	current = { entry = entry, name = name, floors = floors, floor = floor }
	win:Show()
	Draw()
end

--- A "Map" button next to a Route button (Raids and Dungeons pages). Parented to the route
--- button so it shows and hides with it.
function ns.AttachInstanceMapButton(routeBtn, entry)
	if not routeBtn then
		return nil
	end
	local b = CreateFrame("Button", nil, routeBtn, "UIPanelButtonTemplate")
	b:SetHeight(routeBtn:GetHeight() > 0 and routeBtn:GetHeight() or 22)
	b:SetPoint("LEFT", routeBtn, "RIGHT", 6, 0)
	local function label()
		b:SetText(L("INSTMAP_BTN"))
		local fs = b:GetFontString()
		b:SetWidth(((fs and fs:GetStringWidth()) or 40) + 28)
	end
	label()
	b:SetScript("OnShow", label)
	b:SetScript("OnClick", function()
		ns.ShowInstanceMapFor(entry)
	end)
	return b
end
