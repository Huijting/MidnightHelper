--[[
	Midnight Helper — Rares helper (Midnight zones).

	Dedicated sidebar tab: zone list (left) + scrollable named route buttons (right).
	Completion via this character's weekly quest flag (resets Wednesday); click routes via TomTom + Travel Assistant.
]]

local _, ns = ...

local MAP_TO_ZONE_KEY = {
	[2395] = "eversong",
	[2393] = "eversong",
	[2437] = "zulaman",
	[2413] = "harandar",
	[2576] = "harandar",
	[2405] = "voidstorm",
	[2444] = "voidstorm",
}

-- { questId, mapID, x, y, displayName }
local ZONES = {
	{
		key = "eversong",
		label = "Eversong Woods",
		shortLabel = "Eversong",
		rares = {
			{ 91280, 2395, 51.60, 74.63, "Warden of Weeds" },
			{ 92392, 2395, 54.80, 60.23, "Overfester Hydra" },
			{ 92391, 2395, 62.58, 49.48, "Cre'van" },
			{ 92393, 2395, 36.66, 77.16, "Lady Liminus" },
			{ 92404, 2395, 48.94, 87.93, "Bad Zed" },
			{ 92403, 2395, 56.77, 77.07, "Banuran" },
			{ 93550, 2395, 42.55, 69.09, "Duskburn" },
			{ 93561, 2395, 44.99, 38.55, "Dame Bloodshed" },
			{ 91315, 2395, 45.05, 78.25, "Harried Hawkstrider" },
			{ 92366, 2395, 37.69, 64.25, "Bloated Snapdragon" },
			{ 92389, 2395, 36.38, 36.37, "Coralfang" },
			{ 92409, 2395, 40.35, 85.20, "Terrinor" },
			{ 92395, 2395, 34.81, 20.98, "Waverly" },
			{ 92399, 2395, 59.36, 79.25, "Lost Guardian" },
			{ 93555, 2395, 51.54, 45.85, "Malfunctioning Construct" },
		},
	},
	{
		key = "zulaman",
		label = "Zul'Aman",
		shortLabel = "Zul'Aman",
		rares = {
			{ 89569, 2437, 34.27, 32.91, "Necrohexxer Raz'ka" },
			{ 89571, 2437, 51.75, 72.76, "Skullcrusher Harak" },
			{ 91174, 2437, 50.90, 65.41, "Mrrlokk" },
			{ 89578, 2437, 30.80, 45.12, "Spinefrill" },
			{ 89580, 2437, 47.44, 34.35, "Tiny Vermin" },
			{ 89583, 2437, 39.49, 20.32, "The Devouring Invader" },
			{ 89573, 2437, 47.73, 20.73, "Depthborn Eelamental" },
			{ 91073, 2437, 45.34, 41.79, "Ash'an the Empowered" },
			{ 89570, 2437, 51.61, 18.63, "The Snapping Scourge" },
			{ 89575, 2437, 28.73, 24.03, "Lightwood Borer" },
			{ 91634, 2437, 38.99, 50.01, "Poacher Rav'ik" },
			{ 89579, 2437, 46.45, 51.93, "Oophaga" },
			{ 89581, 2437, 21.48, 70.69, "Voidtouched Crustacean" },
			{ 89572, 2437, 33.47, 88.64, "Elder Oaktalon" },
			{ 91072, 2437, 46.77, 43.85, "The Decaying Diamondback" },
		},
	},
	{
		key = "harandar",
		label = "Harandar",
		shortLabel = "Harandar",
		rares = {
			{ 91832, 2413, 51.15, 45.33, "Rhazul" },
			{ 92142, 2413, 70.17, 60.87, "Ha'kalawe" },
			{ 92154, 2413, 60.16, 47.11, "Queen Lashtongue" },
			{ 92168, 2413, 65.34, 32.95, "Stumpy" },
			{ 92172, 2413, 46.11, 32.17, "Mindrot" },
			{ 92183, 2413, 36.34, 75.35, "Treetop" },
			{ 92191, 2413, 27.39, 71.39, "Pterrock" },
			{ 92194, 2413, 43.76, 16.78, "Annulus the Worldshaker" },
			{ 92137, 2413, 68.70, 40.61, "Chironex" },
			{ 92148, 2413, 72.62, 69.35, "Tallcap the Truthspreader" },
			{ 92161, 2413, 64.47, 47.68, "Chlorokyll" },
			{ 92170, 2413, 55.94, 31.63, "Serrasa" },
			{ 92176, 2413, 40.53, 43.27, "Dracaena" },
			{ 92190, 2413, 28.19, 81.81, "Oro'ohna" },
			{ 92193, 2413, 39.75, 60.21, "Ahl'ua'huhi" },
		},
	},
	{
		key = "voidstorm",
		label = "Voidstorm",
		shortLabel = "Voidstorm",
		rares = {
			{ 90805, 2405, 29.50, 50.05, "Sundereth the Caller" },
			{ 91048, 2405, 35.67, 81.11, "Tremora" },
			{ 93946, 2405, 47.17, 79.82, "Bane of the Vilebloods" },
			{ 93947, 2405, 37.99, 71.64, "Lotus Darkblossom" },
			{ 93895, 2405, 48.62, 53.63, "Ravengerus" },
			{ 93884, 2405, 35.59, 49.36, "Bilemaw the Gluttonous" },
			{ 91051, 2405, 40.09, 41.36, "Nightbrood" },
			{ 91050, 2405, 34.12, 82.02, "Territorial Voidscythe" },
			{ 93966, 2405, 43.92, 51.52, "Screammaxa the Matriarch" },
			{ 93944, 2405, 39.51, 64.62, "Aeonelle Blackstar" },
			{ 93934, 2405, 55.72, 79.45, "Queen o' War" },
			{ 93953, 2444, 46.46, 41.03, "Rakshur the Bonegrinder" },
			{ 91047, 2405, 39.18, 92.46, "Eruundi" },
			{ 93896, 2405, 53.89, 62.79, "Far'thana the Mad" },
		},
	},
}

local ZONE_BY_KEY = {}
local ZONE_MAP_IDS = {}
for i = 1, #ZONES do
	ZONE_BY_KEY[ZONES[i].key] = ZONES[i]
	ZONE_MAP_IDS[ZONES[i].key] = ZONE_MAP_IDS[ZONES[i].key] or {}
end
for mapID, zoneKey in pairs(MAP_TO_ZONE_KEY) do
	local list = ZONE_MAP_IDS[zoneKey]
	list[#list + 1] = mapID
end

local ZONE_RAIL_W = 148
local ROW_H = 20
local ROW_GAP = 2
local LIST_COL_GAP = 8
local ZONE_BTN_H = 30
local ZONE_BTN_GAP = 6
local FOOTER_BTN_H = 24
local FOOTER_BOTTOM_INSET = 10
local FOOTER_GAP_ABOVE = 8
local FAR_CROSSMAP_SORT = 1e9

local frame
local titleFs
local subtitleFs
local zoneRail
local zoneBtns = {}
local listHost
local nearestBtn
local routeBtn
local rowBtns = {}
local selectedZoneKey

local vignetteCacheZoneKey = nil
local vignetteCacheAt = 0
local vignetteUpLookup = {}
local VIGNETTE_CACHE_SEC = 2.5
local VIGNETTE_MATCH_DIST = 0.03

local function GetCurrentZoneKey()
	if not C_Map or not C_Map.GetBestMapForUnit then
		return nil
	end
	local mapID = C_Map.GetBestMapForUnit("player")
	return mapID and MAP_TO_ZONE_KEY[mapID] or nil
end

local function GetSelectedZoneKey()
	if selectedZoneKey and ZONE_BY_KEY[selectedZoneKey] then
		return selectedZoneKey
	end
	local u = ns.db and ns.db.ui
	local saved = u and u.raresSelectedZone
	if saved and ZONE_BY_KEY[saved] then
		return saved
	end
	return GetCurrentZoneKey() or ZONES[1].key
end

local function SetSelectedZoneKey(key)
	if not key or not ZONE_BY_KEY[key] then
		return
	end
	selectedZoneKey = key
	if ns.db then
		ns.db.ui = ns.db.ui or {}
		ns.db.ui.raresSelectedZone = key
	end
end

local function GetRareDisplayName(rare)
	if rare[5] and rare[5] ~= "" then
		return rare[5]
	end
	local questId = rare[1]
	if not questId then
		return "?"
	end
	ns._mhRaresQuestTitleCache = ns._mhRaresQuestTitleCache or {}
	local cached = ns._mhRaresQuestTitleCache[questId]
	if cached ~= nil then
		return cached or ("Rare " .. tostring(questId))
	end
	if C_TaskQuest and C_TaskQuest.GetQuestInfoByQuestID then
		local ok, title = pcall(C_TaskQuest.GetQuestInfoByQuestID, questId)
		if ok and type(title) == "string" and title ~= "" then
			ns._mhRaresQuestTitleCache[questId] = title
			return title
		end
	end
	if C_QuestLog and C_QuestLog.GetTitleForQuestID then
		local ok, title = pcall(C_QuestLog.GetTitleForQuestID, questId)
		if ok and type(title) == "string" and title ~= "" then
			ns._mhRaresQuestTitleCache[questId] = title
			return title
		end
	end
	ns._mhRaresQuestTitleCache[questId] = false
	return "Rare " .. tostring(questId)
end

local function IsRareDoneThisWeek(questId)
	if not questId or not C_QuestLog or not C_QuestLog.IsQuestFlaggedCompleted then
		return false
	end
	return C_QuestLog.IsQuestFlaggedCompleted(questId) and true or false
end

local function GetPlayerPositionOnMap(mapID)
	if not mapID or not C_Map or not C_Map.GetPlayerMapPosition then
		return nil, nil
	end
	local okPos, pos = pcall(C_Map.GetPlayerMapPosition, mapID, "player")
	if not okPos or not pos then
		okPos, pos = pcall(C_Map.GetPlayerMapPosition, mapID)
	end
	if not okPos or not pos then
		return nil, nil
	end
	local px, py
	if type(pos.GetXY) == "function" then
		local okXY, x, y = pcall(pos.GetXY, pos)
		if okXY and type(x) == "number" and type(y) == "number" then
			px, py = x, y
		end
	end
	if px == nil and type(pos.x) == "number" and type(pos.y) == "number" then
		px, py = pos.x, pos.y
	end
	if type(px) ~= "number" or type(py) ~= "number" then
		return nil, nil
	end
	return px, py
end

local function RareDistanceFromRef(rare, idx, refMap, refX, refY)
	local tMap = tonumber(rare[2])
	if not tMap then
		return FAR_CROSSMAP_SORT + idx
	end
	local tx = (tonumber(rare[3]) or 0) / 100
	local ty = (tonumber(rare[4]) or 0) / 100

	if refMap and refX and refY and tMap == refMap then
		local dx = tx - refX
		local dy = ty - refY
		return math.sqrt(dx * dx + dy * dy)
	end

	if not refMap then
		local px, py = GetPlayerPositionOnMap(tMap)
		if px then
			local dx = tx - px
			local dy = ty - py
			return math.sqrt(dx * dx + dy * dy)
		end
	end

	return FAR_CROSSMAP_SORT + idx
end

local function RareSortDistance(rare, idx)
	return RareDistanceFromRef(rare, idx, nil, nil, nil)
end

local function FindNearestIncompleteRare(zone)
	if not zone or not zone.rares then
		return nil
	end
	local bestRare, bestDist
	for idx, rare in ipairs(zone.rares) do
		if not IsRareDoneThisWeek(rare[1]) then
			local dist = RareSortDistance(rare, idx)
			if not bestDist or dist < bestDist then
				bestDist = dist
				bestRare = rare
			end
		end
	end
	return bestRare
end

-- Same first stop as Find Nearest Rare, then greedy nearest-neighbor for the rest.
local function BuildGreedyRareRoute(zone)
	local remaining = {}
	for idx, rare in ipairs(zone.rares) do
		if not IsRareDoneThisWeek(rare[1]) then
			remaining[#remaining + 1] = { rare = rare, idx = idx }
		end
	end
	if #remaining == 0 then
		return {}, false
	end
	if #remaining == 1 then
		return { remaining[1].rare }, RareSortDistance(remaining[1].rare, remaining[1].idx) < FAR_CROSSMAP_SORT
	end

	local ordered = {}
	local usedDistance = false
	local refMap, refX, refY

	local firstRare = FindNearestIncompleteRare(zone)
	if firstRare then
		for i = 1, #remaining do
			if remaining[i].rare == firstRare then
				local firstIdx = remaining[i].idx
				table.remove(remaining, i)
				ordered[#ordered + 1] = firstRare
				refMap = tonumber(firstRare[2])
				refX = (tonumber(firstRare[3]) or 0) / 100
				refY = (tonumber(firstRare[4]) or 0) / 100
				if RareSortDistance(firstRare, firstIdx) < FAR_CROSSMAP_SORT then
					usedDistance = true
				end
				break
			end
		end
	end

	while #remaining > 0 do
		local bestI, bestDist, bestIdx
		for i, entry in ipairs(remaining) do
			local dist = RareDistanceFromRef(entry.rare, entry.idx, refMap, refX, refY)
			if dist < FAR_CROSSMAP_SORT then
				usedDistance = true
			end
			if not bestDist or dist < bestDist or (dist == bestDist and entry.idx < bestIdx) then
				bestDist = dist
				bestI = i
				bestIdx = entry.idx
			end
		end
		local pick = table.remove(remaining, bestI)
		ordered[#ordered + 1] = pick.rare
		refMap = tonumber(pick.rare[2])
		refX = (tonumber(pick.rare[3]) or 0) / 100
		refY = (tonumber(pick.rare[4]) or 0) / 100
	end

	return ordered, usedDistance
end

local function RouteRare(rare, clearOthers)
	if not rare or not ns.AddSmartTomTomWay then
		return false
	end
	if clearOthers and ns.IsTomTomReady and ns.IsTomTomReady() then
		pcall(function()
			_G.TomTom:ClearAllWaypoints()
		end)
	end
	local mapID, x, yPct = rare[2], rare[3], rare[4]
	local name = GetRareDisplayName(rare)
	return ns.AddSmartTomTomWay(mapID, x, yPct, name) and true or false
end

local function NormalizeRareNameKey(name)
	local s = tostring(name or ""):lower()
	s = s:gsub("|c%x%x%x%x%x%x%x%x", "")
	s = s:gsub("|r", "")
	s = s:gsub("[^%w]", "")
	return s
end

local function RareNamesRoughMatch(a, b)
	local na, nb = NormalizeRareNameKey(a), NormalizeRareNameKey(b)
	if na == "" or nb == "" then
		return false
	end
	return na:find(nb, 1, true) or nb:find(na, 1, true)
end

local function VignetteXY(vx, vy)
	local x = tonumber(vx)
	local y = tonumber(vy)
	if not x or not y then
		return nil, nil
	end
	if x > 1 or y > 1 then
		x, y = x / 100, y / 100
	end
	return x, y
end

local function CollectVignettePointsForZone(zoneKey)
	local points = {}
	if not zoneKey or not C_Map or not C_Map.GetVignettes then
		return points
	end
	local mapList = ZONE_MAP_IDS[zoneKey]
	if not mapList then
		return points
	end
	for mi = 1, #mapList do
		local mapID = mapList[mi]
		local okList, vignettes = pcall(C_Map.GetVignettes, mapID)
		if okList and type(vignettes) == "table" then
			for vi = 1, #vignettes do
				local vignetteGUID = vignettes[vi]
				local vx, vy, vname
				if C_VignetteInfo and C_VignetteInfo.GetVignettePosition then
					local okPos, posX, posY = pcall(C_VignetteInfo.GetVignettePosition, vignetteGUID, mapID)
					if okPos then
						vx, vy = posX, posY
					end
				end
				if C_VignetteInfo and C_VignetteInfo.GetVignetteInfo then
					local okInfo, info = pcall(C_VignetteInfo.GetVignetteInfo, vignetteGUID)
					if okInfo and info then
						vname = info.name or info.vignetteName
						if not vx and info.position and type(info.position.GetXY) == "function" then
							local okXY, px, py = pcall(info.position.GetXY, info.position)
							if okXY then
								vx, vy = px, py
							end
						end
						if not vx and type(info.x) == "number" and type(info.y) == "number" then
							vx, vy = info.x, info.y
						end
					end
				end
				vx, vy = VignetteXY(vx, vy)
				if vx and vy then
					points[#points + 1] = { x = vx, y = vy, name = vname or "" }
				end
			end
		end
	end
	return points
end

local function RefreshVignetteUpCache(zone)
	if not zone or not zone.key then
		return
	end
	local now = (GetTime and GetTime()) or 0
	if vignetteCacheZoneKey == zone.key and (now - vignetteCacheAt) < VIGNETTE_CACHE_SEC then
		return
	end
	vignetteCacheZoneKey = zone.key
	vignetteCacheAt = now
	wipe(vignetteUpLookup)

	local points = CollectVignettePointsForZone(zone.key)
	for _, rare in ipairs(zone.rares) do
		local rx = (tonumber(rare[3]) or 0) / 100
		local ry = (tonumber(rare[4]) or 0) / 100
		local rname = GetRareDisplayName(rare)
		local up = false
		for pi = 1, #points do
			local p = points[pi]
			local dx = p.x - rx
			local dy = p.y - ry
			local dist = math.sqrt(dx * dx + dy * dy)
			if dist <= VIGNETTE_MATCH_DIST or (dist <= VIGNETTE_MATCH_DIST * 2.2 and RareNamesRoughMatch(p.name, rname)) then
				up = true
				break
			end
		end
		vignetteUpLookup[zone.key .. ":" .. tostring(rare[1])] = up
	end
end

local function IsRareVignetteUp(rare, zoneKey)
	if not rare or not zoneKey then
		return false
	end
	return vignetteUpLookup[zoneKey .. ":" .. tostring(rare[1])] == true
end

local function FormatRareRowLabel(rare, zoneKey)
	local name = GetRareDisplayName(rare)
	if IsRareDoneThisWeek(rare[1]) then
		return "|cff55ee88" .. name .. "|r"
	end
	if IsRareVignetteUp(rare, zoneKey) then
		return "|cff33ff33" .. ns:L("RARES_TAG_UP") .. "|r |cffffe9b3" .. name .. "|r"
	end
	return "|cff999999" .. ns:L("RARES_TAG_DOWN") .. "|r |cffffe9b3" .. name .. "|r"
end

local function AttachRareRowTooltip(btn)
	if btn._mhRareTooltipHooked then
		return
	end
	btn._mhRareTooltipHooked = true
	btn:SetScript("OnEnter", function(self)
		local r = self._mhRare
		if not r then
			return
		end
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		GameTooltip:ClearLines()
		GameTooltip:AddLine(GetRareDisplayName(r), 1, 0.9, 0.55)
		if IsRareDoneThisWeek(r[1]) then
			GameTooltip:AddLine(ns:L("RARES_TIP_DONE"), 0.35, 0.95, 0.45)
		elseif IsRareVignetteUp(r, self._mhZoneKey) then
			GameTooltip:AddLine(ns:L("RARES_TIP_UP"), 0.25, 1, 0.35)
		else
			GameTooltip:AddLine(ns:L("RARES_TIP_DOWN"), 0.7, 0.7, 0.7)
		end
		GameTooltip:AddLine(ns:L("RARES_TIP_VIGNETTE_NOTE"), 0.65, 0.68, 0.72, true)
		GameTooltip:Show()
	end)
	btn:SetScript("OnLeave", function()
		GameTooltip:Hide()
	end)
end

function ns.GenerateRaresRoute(zoneKey)
	if not ns.AddSmartTomTomWay then
		print("|cffff5555Midnight Helper:|r " .. ns:L("RARES_NEAREST_NO_TRAVEL"))
		return false
	end
	local key = zoneKey or GetSelectedZoneKey()
	local zone = key and ZONE_BY_KEY[key]
	if not zone then
		print("|cffff5555Midnight Helper:|r " .. ns:L("RARES_EMPTY_ZONE"))
		return false
	end

	if ns.IsTomTomReady and ns.IsTomTomReady() then
		pcall(function()
			_G.TomTom:ClearAllWaypoints()
		end)
	end

	local routeRares, nearestFirst = BuildGreedyRareRoute(zone)
	if #routeRares == 0 then
		print("|cffffff78Midnight Helper:|r " .. ns:L("RARES_NEAREST_NONE"))
		return false
	end

	local added = 0
	for i, rare in ipairs(routeRares) do
		-- First pin matches Find Nearest Rare; only it gets the arrow + travel assistant.
		local skipTravelUI = i > 1
		local skipCrazyArrow = i > 1
		if ns.AddSmartTomTomWay(rare[2], rare[3], rare[4], GetRareDisplayName(rare), skipTravelUI, skipCrazyArrow) then
			added = added + 1
		end
	end

	local orderHint = nearestFirst and ns:L("RARES_ROUTE_ORDER_NEAR") or ns:L("RARES_ROUTE_ORDER_LIST")
	print(
		string.format(
			"|cffffff78Midnight Helper:|r " .. ns:L("RARES_ROUTE_DONE_FMT"),
			added,
			#routeRares,
			orderHint
		)
	)
	return added > 0
end

function ns.RouteToNearestRare(zoneKey)
	if not ns.AddSmartTomTomWay then
		print("|cffff5555Midnight Helper:|r " .. ns:L("RARES_NEAREST_NO_TRAVEL"))
		return false
	end
	local key = zoneKey or GetSelectedZoneKey()
	local zone = key and ZONE_BY_KEY[key]
	if not zone then
		print("|cffff5555Midnight Helper:|r " .. ns:L("RARES_EMPTY_ZONE"))
		return false
	end
	local rare = FindNearestIncompleteRare(zone)
	if not rare then
		print("|cffffff78Midnight Helper:|r " .. ns:L("RARES_NEAREST_NONE"))
		return false
	end
	if RouteRare(rare, true) then
		print(string.format(ns:L("RARES_NEAREST_ROUTE"), GetRareDisplayName(rare)))
		return true
	end
	return false
end

local function EnsureRowButton(index)
	local btn = rowBtns[index]
	if btn then
		return btn
	end
	btn = CreateFrame("Button", nil, listHost, "UIPanelButtonTemplate")
	btn:SetHeight(ROW_H)
	local fs = btn.GetFontString and btn:GetFontString()
	if fs and fs.SetFontObject then
		fs:SetFontObject(GameFontHighlightSmall)
	end
	btn:SetScript("OnClick", function(self)
		if self._mhRare then
			RouteRare(self._mhRare, true)
		end
	end)
	AttachRareRowTooltip(btn)
	rowBtns[index] = btn
	return btn
end

local function RefreshZoneRail(zoneKey)
	for _, z in ipairs(ZONES) do
		local zb = zoneBtns[z.key]
		if zb then
			local active = z.key == zoneKey
			local prefix = active and "|cffffcc00> |r" or ""
			zb:SetText(prefix .. (z.shortLabel or z.label))
			if active then
				zb:Disable()
			else
				zb:Enable()
			end
		end
	end
end

local function LayoutRareRows(zone, innerW)
	local total = zone and #zone.rares or 0
	local colW = math.max(120, math.floor((innerW - LIST_COL_GAP) / 2))
	local rowsPerCol = math.ceil(math.max(total, 1) / 2)
	local maxY = 0

	for i = 1, total do
		local btn = EnsureRowButton(i)
		local rare = zone.rares[i]
		btn._mhRare = rare
		btn._mhZoneKey = zone.key
		btn:SetText(FormatRareRowLabel(rare, zone.key))
		btn:SetWidth(colW)
		btn:ClearAllPoints()

		local col = (i <= rowsPerCol) and 0 or 1
		local rowInCol = (col == 0) and i or (i - rowsPerCol)
		local xOff = col * (colW + LIST_COL_GAP)
		local y = (rowInCol - 1) * (ROW_H + ROW_GAP)
		btn:SetPoint("TOPLEFT", listHost, "TOPLEFT", xOff, -y)
		btn:Show()
		maxY = math.max(maxY, y + ROW_H)
	end

	for i = total + 1, #rowBtns do
		if rowBtns[i] then
			rowBtns[i]:Hide()
		end
	end

	listHost:SetSize(innerW, math.max(1, maxY + ROW_GAP))
end

function ns.RefreshRaresPanel()
	if not frame or not frame:IsVisible() then
		return
	end

	local zoneKey = GetSelectedZoneKey()
	local zone = ZONE_BY_KEY[zoneKey]
	if not zone then
		if titleFs then
			titleFs:SetText(ns:L("RARES_TITLE"))
		end
		if subtitleFs then
			subtitleFs:SetText(ns:L("RARES_EMPTY_ZONE"))
		end
		return
	end

	if titleFs then
		titleFs:SetText(zone.label)
	end

	RefreshVignetteUpCache(zone)

	local doneCount, upCount = 0, 0
	for i = 1, #zone.rares do
		local rare = zone.rares[i]
		if IsRareDoneThisWeek(rare[1]) then
			doneCount = doneCount + 1
		elseif IsRareVignetteUp(rare, zone.key) then
			upCount = upCount + 1
		end
	end
	if subtitleFs then
		subtitleFs:SetText(ns:L("RARES_SUBTITLE_FMT"):format(doneCount, #zone.rares, upCount))
	end

	RefreshZoneRail(zoneKey)

	local innerW = listHost:GetWidth() or 0
	if innerW < 120 and frame then
		innerW = math.max(260, (frame:GetWidth() or 500) - ZONE_RAIL_W - 40)
	end
	innerW = math.max(260, innerW)
	LayoutRareRows(zone, innerW)
end

function ns.BuildRaresPanel(panel)
	if not panel or panel._mhRaresBuilt then
		return
	end
	panel._mhRaresBuilt = true

	if panel._body then
		panel._body:Hide()
	end
	if panel._header then
		panel._header:Hide()
	end

	frame = CreateFrame("Frame", "MidnightHelperRaresFrame", panel)
	frame:SetAllPoints(panel)

	titleFs = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlightLarge")
	titleFs:SetPoint("TOPLEFT", frame, "TOPLEFT", 14, -12)
	titleFs:SetText(ns:L("RARES_TITLE"))

	subtitleFs = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	subtitleFs:SetPoint("TOPLEFT", titleFs, "BOTTOMLEFT", 0, -4)
	subtitleFs:SetPoint("RIGHT", frame, "RIGHT", -16, 0)
	subtitleFs:SetJustifyH("LEFT")
	subtitleFs:SetWordWrap(true)
	subtitleFs:SetTextColor(0.75, 0.78, 0.82)

	zoneRail = CreateFrame("Frame", nil, frame)
	zoneRail:SetWidth(ZONE_RAIL_W)
	zoneRail:SetPoint("TOPLEFT", subtitleFs, "BOTTOMLEFT", 0, -14)
	zoneRail:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", 12, FOOTER_BOTTOM_INSET + FOOTER_BTN_H + FOOTER_GAP_ABOVE)

	nearestBtn = CreateFrame("Button", "MidnightHelperRaresNearestBtn", frame, "UIPanelButtonTemplate")
	nearestBtn:SetHeight(FOOTER_BTN_H)
	nearestBtn:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", 14, FOOTER_BOTTOM_INSET)
	nearestBtn:SetPoint("RIGHT", frame, "CENTER", -6, 0)
	nearestBtn:SetText(ns:L("RARES_BTN_NEAREST"))
	nearestBtn:SetFrameLevel((frame:GetFrameLevel() or 0) + 20)
	nearestBtn:SetScript("OnClick", function()
		ns.RouteToNearestRare(GetSelectedZoneKey())
	end)

	routeBtn = CreateFrame("Button", "MidnightHelperRaresRouteBtn", frame, "UIPanelButtonTemplate")
	routeBtn:SetHeight(FOOTER_BTN_H)
	routeBtn:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -14, FOOTER_BOTTOM_INSET)
	routeBtn:SetPoint("LEFT", frame, "CENTER", 6, 0)
	routeBtn:SetText(ns:L("RARES_BTN_ROUTE"))
	routeBtn:SetFrameLevel((frame:GetFrameLevel() or 0) + 20)
	routeBtn:SetScript("OnClick", function()
		ns.GenerateRaresRoute(GetSelectedZoneKey())
	end)

	local prevZoneBtn
	for i, z in ipairs(ZONES) do
		local zb = CreateFrame("Button", nil, zoneRail, "UIPanelButtonTemplate")
		zb:SetSize(ZONE_RAIL_W - 4, ZONE_BTN_H)
		zb:SetText(z.shortLabel or z.label)
		if i == 1 then
			zb:SetPoint("TOPLEFT", zoneRail, "TOPLEFT", 0, 0)
		else
			zb:SetPoint("TOPLEFT", prevZoneBtn, "BOTTOMLEFT", 0, -ZONE_BTN_GAP)
		end
		zb:SetScript("OnClick", function()
			SetSelectedZoneKey(z.key)
			ns.RefreshRaresPanel()
		end)
		zoneBtns[z.key] = zb
		prevZoneBtn = zb
	end

	listHost = CreateFrame("Frame", nil, frame)
	listHost:SetPoint("TOPLEFT", zoneRail, "TOPRIGHT", 14, 0)
	listHost:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -12, FOOTER_BOTTOM_INSET + FOOTER_BTN_H + FOOTER_GAP_ABOVE)

	frame:SetScript("OnShow", function()
		local here = GetCurrentZoneKey()
		if here then
			SetSelectedZoneKey(here)
		end
		ns.RefreshRaresPanel()
	end)

	frame:SetScript("OnSizeChanged", function()
		if frame:IsVisible() then
			ns.RefreshRaresPanel()
		end
	end)

	panel:SetScript("OnShow", function()
		local here = GetCurrentZoneKey()
		if here then
			SetSelectedZoneKey(here)
		end
		ns.RefreshRaresPanel()
	end)

	ns.RaresFrame = frame
end

do
	local orig = ns.RefreshLocaleUI
	function ns:RefreshLocaleUI()
		if orig then
			orig(self)
		end
		if nearestBtn then
			nearestBtn:SetText(ns:L("RARES_BTN_NEAREST"))
		end
		if routeBtn then
			routeBtn:SetText(ns:L("RARES_BTN_ROUTE"))
		end
	end
end

function ns.MH_RefreshRaresDelvesBlock(delvesFrame)
	if delvesFrame and delvesFrame._mhRaresHost then
		delvesFrame._mhRaresHost:Hide()
	end
	return 0, nil
end

local ev = CreateFrame("Frame")
ev:RegisterEvent("QUEST_LOG_UPDATE")
ev:RegisterEvent("ZONE_CHANGED_NEW_AREA")
if C_EventUtils and C_EventUtils.IsEventValid then
	if C_EventUtils.IsEventValid("VIGNETTES_UPDATED") then
		ev:RegisterEvent("VIGNETTES_UPDATED")
	end
	if C_EventUtils.IsEventValid("VIGNETTE_MINIMAP_UPDATED") then
		ev:RegisterEvent("VIGNETTE_MINIMAP_UPDATED")
	end
else
	pcall(function()
		ev:RegisterEvent("VIGNETTES_UPDATED")
	end)
	pcall(function()
		ev:RegisterEvent("VIGNETTE_MINIMAP_UPDATED")
	end)
end
ev:SetScript("OnEvent", function(_, event)
	if frame and frame:IsVisible() then
		if event == "ZONE_CHANGED_NEW_AREA" then
			local here = GetCurrentZoneKey()
			if here then
				SetSelectedZoneKey(here)
			end
			vignetteCacheAt = 0
		elseif event == "VIGNETTES_UPDATED" or event == "VIGNETTE_MINIMAP_UPDATED" then
			vignetteCacheAt = 0
		end
		ns.RefreshRaresPanel()
	end
end)
