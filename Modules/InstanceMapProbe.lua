--[[
	/mh mapprobe           -- can MH show a raid's or dungeon's floor plan without shipping images?
	/mh mapprobe show <id> -- draw one floor (uiMapID) in a test window, with the bosses on it

	Rob, 27 sep 2026: "kunnen we niet eenvoudige plaatjes krijgen in MH met hoe de layout van een
	raid bv is? zonder dat we vele mb's groter worden?" The client already carries every
	instance's floor art (the world map shows it inside) and the Encounter Journal knows where
	each boss stands per floor. Whether an addon can ask for that from OUTSIDE the instance is
	the open question (INFERRED yes, not measured) -- this measures it before anything is built.

	Per instance of the current Encounter Journal tier: the first floor from EJ_GetInstanceInfo
	(dungeonAreaMapID), every floor of its map group, the art layer size and tile count, and the
	bosses GetEncountersOnMap places on it. Printed short, saved in full to ns.db.mapProbe.
	Reads only. The journal tier is restored afterwards.
]]

local _, ns = ...

local function Prefix()
	return ("|cffffcc00%s|r"):format(ns:L("PRINT_PREFIX"))
end

local function Floors(firstMap)
	local out = {}
	local okG, groupID = pcall(C_Map.GetMapGroupID, firstMap)
	if okG and groupID then
		local okF, list = pcall(C_Map.GetMapGroupMembersInfo, groupID)
		if okF and type(list) == "table" then
			for _, f in ipairs(list) do
				out[#out + 1] = { mapID = f.mapID, name = f.name }
			end
		end
	end
	if #out == 0 then
		local okI, info = pcall(C_Map.GetMapInfo, firstMap)
		out[1] = { mapID = firstMap, name = okI and info and info.name or "?" }
	end
	return out
end

local function FloorDetail(mapID)
	local d = { mapID = mapID }
	local okL, layers = pcall(C_Map.GetMapArtLayers, mapID)
	local l1 = okL and type(layers) == "table" and layers[1] or nil
	if l1 then
		d.w, d.h, d.tw, d.th = l1.layerWidth, l1.layerHeight, l1.tileWidth, l1.tileHeight
	end
	local okT, tex = pcall(C_Map.GetMapArtLayerTextures, mapID, 1)
	d.tiles = okT and type(tex) == "table" and #tex or 0
	d.bosses = {}
	if C_EncounterJournal and C_EncounterJournal.GetEncountersOnMap then
		local okE, list = pcall(C_EncounterJournal.GetEncountersOnMap, mapID)
		for _, e in ipairs(okE and list or {}) do
			local name = EJ_GetEncounterInfo and select(1, EJ_GetEncounterInfo(e.encounterID)) or nil
			d.bosses[#d.bosses + 1] = { id = e.encounterID, name = name, x = e.mapX, y = e.mapY }
		end
	end
	return d
end

local function Measure()
	local results = {}
	if not (EJ_GetNumTiers and EJ_SelectTier and EJ_GetInstanceByIndex and EJ_GetInstanceInfo) then
		print(Prefix() .. " mapprobe: the Encounter Journal functions are missing.")
		return results
	end
	local before = EJ_GetCurrentTier and EJ_GetCurrentTier() or nil
	pcall(EJ_SelectTier, EJ_GetNumTiers())
	for _, isRaid in ipairs({ true, false }) do
		for i = 1, 40 do
			local okI, jid, name = pcall(EJ_GetInstanceByIndex, i, isRaid)
			if not okI or not jid then
				break
			end
			local okD, _, _, _, _, _, _, areaMap = pcall(EJ_GetInstanceInfo, jid)
			local inst = { jid = jid, name = name, raid = isRaid, areaMap = okD and areaMap or nil, floors = {} }
			if inst.areaMap and inst.areaMap > 0 then
				for _, f in ipairs(Floors(inst.areaMap)) do
					local d = FloorDetail(f.mapID)
					d.name = f.name
					inst.floors[#inst.floors + 1] = d
				end
			end
			results[#results + 1] = inst
		end
	end
	if before then
		pcall(EJ_SelectTier, before)
	end
	return results
end

local function Print(results)
	print(("%s mapprobe: %d instances in the current journal tier"):format(Prefix(), #results))
	for _, inst in ipairs(results) do
		local floors, tiles, bosses = #inst.floors, 0, 0
		for _, f in ipairs(inst.floors) do
			tiles = tiles + (f.tiles or 0)
			bosses = bosses + #f.bosses
		end
		local ids = {}
		for _, f in ipairs(inst.floors) do
			ids[#ids + 1] = tostring(f.mapID)
		end
		print(("   %s %-26s map %s · %d floor(s) [%s] · %d tiles · %d bosses placed"):format(
			inst.raid and "R" or "D", tostring(inst.name):sub(1, 26), tostring(inst.areaMap),
			floors, table.concat(ids, " "), tiles, bosses))
	end
	print("   Draw one: /mh mapprobe show <mapID>  (a number from the [...] list)")
end

--------------------------------------------------------------------------------
-- The test drawing: one floor, its tiles, a skull per boss.
--------------------------------------------------------------------------------

local win
local SIZE = 560

local function Draw(mapID)
	if not win then
		win = CreateFrame("Frame", "MidnightHelperMapProbe", UIParent, "BackdropTemplate")
		win:SetPoint("CENTER")
		win:SetFrameStrata("HIGH")
		win:SetMovable(true)
		win:EnableMouse(true)
		win:RegisterForDrag("LeftButton")
		win:SetScript("OnDragStart", win.StartMoving)
		win:SetScript("OnDragStop", win.StopMovingOrSizing)
		if win.SetBackdrop then
			win:SetBackdrop({ bgFile = "Interface\\Buttons\\WHITE8x8", edgeFile = "Interface\\Buttons\\WHITE8x8", edgeSize = 1 })
			win:SetBackdropColor(0, 0, 0, 0.85)
			win:SetBackdropBorderColor(1, 0.82, 0.2, 0.8)
		end
		win.title = win:CreateFontString(nil, "OVERLAY", "GameFontNormal")
		win.title:SetPoint("TOPLEFT", 8, -6)
		local close = CreateFrame("Button", nil, win, "UIPanelCloseButton")
		close:SetPoint("TOPRIGHT", 2, 2)
		win.canvas = CreateFrame("Frame", nil, win)
		win.canvas:SetPoint("TOPLEFT", 8, -26)
		win.tiles, win.pins = {}, {}
	end
	for _, t in ipairs(win.tiles) do
		t:Hide()
	end
	for _, p in ipairs(win.pins) do
		p:Hide()
	end
	local d = FloorDetail(mapID)
	local okI, info = pcall(C_Map.GetMapInfo, mapID)
	win.title:SetText(("%s  (map %d)"):format(okI and info and info.name or "?", mapID))
	if not (d.w and d.tw and d.tiles > 0) then
		win:SetSize(SIZE + 16, 60)
		win.title:SetText(win.title:GetText() .. " -- no art returned")
		win:Show()
		return
	end
	local scale = SIZE / d.w
	local W, H = SIZE, d.h * scale
	win.canvas:SetSize(W, H)
	win:SetSize(W + 16, H + 34)
	local okT, tex = pcall(C_Map.GetMapArtLayerTextures, mapID, 1)
	local cols = math.ceil(d.w / d.tw)
	for i, fileID in ipairs(okT and tex or {}) do
		local t = win.tiles[i] or win.canvas:CreateTexture(nil, "ARTWORK")
		win.tiles[i] = t
		local col, row = (i - 1) % cols, math.floor((i - 1) / cols)
		t:ClearAllPoints()
		t:SetSize(d.tw * scale, d.th * scale)
		t:SetPoint("TOPLEFT", win.canvas, "TOPLEFT", col * d.tw * scale, -row * d.th * scale)
		t:SetTexture(fileID)
		t:Show()
	end
	for i, b in ipairs(d.bosses) do
		local p = win.pins[i]
		if not p then
			p = CreateFrame("Frame", nil, win.canvas)
			p:SetSize(18, 18)
			p.tex = p:CreateTexture(nil, "OVERLAY")
			p.tex:SetAllPoints()
			p.tex:SetTexture("Interface\\TargetingFrame\\UI-RaidTargetingIcon_8")
			p.fs = p:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmallOutline")
			p.fs:SetPoint("TOP", p, "BOTTOM", 0, -1)
			win.pins[i] = p
		end
		p:ClearAllPoints()
		p:SetPoint("CENTER", win.canvas, "TOPLEFT", (b.x or 0) * W, -(b.y or 0) * H)
		p.fs:SetText(b.name or ("#" .. tostring(b.id)))
		p:Show()
	end
	win:Show()
end

function ns.MapProbeCommand(arg)
	local id = arg and tonumber(arg:match("^show%s+(%d+)$"))
	if id then
		Draw(id)
		return
	end
	local results = Measure()
	Print(results)
	if ns.db then
		ns.db.mapProbe = { at = date and date("%Y-%m-%d %H:%M") or "?", instances = results }
	end
end
