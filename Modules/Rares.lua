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
	[2599] = "val", -- Showdown-zone (12.0.7)
	[2600] = "naigtal", -- Showdown-zone (12.0.7)
}

-- { questId, mapID, x, y, displayName[, npcId] }
-- npcId (optioneel, veld 6): exacte vignette-match via objectGUID — vul in
-- zodra in-game geverifieerd (12.0.7-rares: zie PTR_12.0.7_DATA.md §3).
local ZONES = {
	{
		key = "eversong",
		label = "Eversong Woods",
		shortLabel = "Eversong",
		rares = {
			{ 91280, 2395, 51.60, 74.63, "Warden of Weeds", 246332 },
			{ 92392, 2395, 54.80, 60.23, "Overfester Hydra", 240129 },
			{ 92391, 2395, 62.58, 49.48, "Cre'van", 250719 },
			{ 92393, 2395, 36.66, 77.16, "Lady Liminus", 250754 },
			{ 92404, 2395, 48.94, 87.93, "Bad Zed", 250841 },
			{ 92403, 2395, 56.77, 77.07, "Banuran", 250826 },
			{ 93550, 2395, 42.55, 69.09, "Duskburn", 255302 },
			{ 93561, 2395, 44.99, 38.55, "Dame Bloodshed", 255348 },
			{ 91315, 2395, 45.05, 78.25, "Harried Hawkstrider", 246633 },
			{ 92366, 2395, 37.69, 64.25, "Bloated Snapdragon", 250582 },
			{ 92389, 2395, 36.38, 36.37, "Coralfang", 250683 },
			{ 92409, 2395, 40.35, 85.20, "Terrinor", 250876 },
			{ 92395, 2395, 34.81, 20.98, "Waverly", 250780 },
			{ 92399, 2395, 59.36, 79.25, "Lost Guardian", 250806 },
			{ 93555, 2395, 51.54, 45.85, "Malfunctioning Construct", 255329 },
		},
	},
	{
		key = "zulaman",
		label = "Zul'Aman",
		shortLabel = "Zul'Aman",
		rares = {
			{ 89569, 2437, 34.27, 32.91, "Necrohexxer Raz'ka", 242023 },
			{ 89571, 2437, 51.75, 72.76, "Skullcrusher Harak", 242025 },
			{ 91174, 2437, 50.90, 65.41, "Mrrlokk", 245975 },
			{ 89578, 2437, 30.80, 45.12, "Spinefrill", 242031 },
			{ 89580, 2437, 47.44, 34.35, "Tiny Vermin", 242033 },
			{ 89583, 2437, 39.49, 20.32, "The Devouring Invader", 242035 },
			{ 89573, 2437, 47.73, 20.73, "Depthborn Eelamental", 242027 },
			{ 91073, 2437, 45.34, 41.79, "Ash'an the Empowered", 245692 },
			{ 89570, 2437, 51.61, 18.63, "The Snapping Scourge", 242024 },
			{ 89575, 2437, 28.73, 24.03, "Lightwood Borer", 242028 },
			{ 91634, 2437, 38.99, 50.01, "Poacher Rav'ik", 247976 },
			{ 89579, 2437, 46.45, 51.93, "Oophaga", 242032 },
			{ 89581, 2437, 21.48, 70.69, "Voidtouched Crustacean", 242034 },
			{ 89572, 2437, 33.47, 88.64, "Elder Oaktalon", 242026 },
			{ 91072, 2437, 46.77, 43.85, "The Decaying Diamondback", 245691 },
		},
	},
	{
		key = "harandar",
		label = "Harandar",
		shortLabel = "Harandar",
		rares = {
			{ 91832, 2413, 51.15, 45.33, "Rhazul", 248741 },
			{ 92142, 2413, 70.17, 60.87, "Ha'kalawe", 249849 },
			{ 92154, 2413, 60.16, 47.11, "Queen Lashtongue", 249962 },
			{ 92168, 2413, 65.34, 32.95, "Stumpy", 250086 },
			{ 92172, 2413, 46.11, 32.17, "Mindrot", 250226 },
			{ 92183, 2413, 36.34, 75.35, "Treetop", 250246 },
			{ 92191, 2413, 27.39, 71.39, "Pterrock", 250321 },
			{ 92194, 2413, 43.76, 16.78, "Annulus the Worldshaker", 250358 },
			{ 92137, 2413, 68.70, 40.61, "Chironex", 249844 },
			{ 92148, 2413, 72.62, 69.35, "Tallcap the Truthspreader", 249902 },
			{ 92161, 2413, 64.47, 47.68, "Chlorokyll", 249997 },
			{ 92170, 2413, 55.94, 31.63, "Serrasa", 250180 },
			{ 92176, 2413, 40.53, 43.27, "Dracaena", 250231 },
			{ 92190, 2413, 28.19, 81.81, "Oro'ohna", 250317 },
			{ 92193, 2413, 39.75, 60.21, "Ahl'ua'huhi", 250347 },
		},
	},
	{
		key = "voidstorm",
		label = "Voidstorm",
		shortLabel = "Voidstorm",
		rares = {
			{ 90805, 2405, 29.50, 50.05, "Sundereth the Caller", 244272 },
			{ 91048, 2405, 35.67, 81.11, "Tremora", 241443 },
			{ 93946, 2405, 47.17, 79.82, "Bane of the Vilebloods", 256923 },
			{ 93947, 2405, 37.99, 71.64, "Lotus Darkblossom", 256925 },
			{ 93895, 2405, 48.62, 53.63, "Ravengerus", 256808 },
			{ 93884, 2405, 35.59, 49.36, "Bilemaw the Gluttonous", 256770 },
			{ 91051, 2405, 40.09, 41.36, "Nightbrood", 245044 },
			{ 91050, 2405, 34.12, 82.02, "Territorial Voidscythe", 238498 },
			{ 93966, 2405, 43.92, 51.52, "Screammaxa the Matriarch", 256922 },
			{ 93944, 2405, 39.51, 64.62, "Aeonelle Blackstar", 256924 },
			{ 93934, 2405, 55.72, 79.45, "Queen o' War", 256926 },
			{ 93953, 2444, 46.46, 41.03, "Rakshur the Bonegrinder", 257027 },
			{ 91047, 2405, 39.18, 92.46, "Eruundi", 245182 },
			{ 93896, 2405, 53.89, 62.79, "Far'thana the Mad", 256821 },
		},
	},
	-- Showdown-zones (12.0.7): Naigtal (2600) & Val (2599), roterend via de
	-- Voidstorm-portal. questId = de weekly kill-credit-quest. npcID's, quests én
	-- coords geverifieerd via de HandyNotes_Midnight-plugin (zones/naigtal.lua +
	-- val.lua), gekruist met de Showdown Slugger-achievement-criteria (Val 62881 /
	-- Naigtal 62883). NB: deze coords wijken af van de eerdere Wowhead-gids-waarden;
	-- HandyNotes (onderhouden pin-plugin) is leidend, Rob spot-checkt in-game.
	-- Auredar's Chassis staat in het gebouw The Vacant Vigilant (map 2646); we routen
	-- naar de ingang op 2600 en de npcID skullt 'm binnen.
	{
		key = "val",
		label = "Val",
		shortLabel = "Val",
		rares = {
			{ 95939, 2599, 66.80, 86.40, "Sleet-Rune", 261965 },
			{ 95559, 2599, 67.20, 41.80, "Glacial Broodmother", 261716 }, -- elite, roamt
			{ 96370, 2599, 28.50, 74.50, "Xirah", 264864 },
			{ 96373, 2599, 33.30, 43.00, "Opprimius", 264868 },
			{ 96375, 2599, 33.50, 58.20, "The Horror Below", 264870 },
			{ 95940, 2599, 37.90, 77.25, "Atomus", 262421 },
			{ 96371, 2599, 49.70, 79.20, "Mercilus", 264865 },
			{ 96372, 2599, 42.60, 58.30, "Krilkan", 264866 }, -- roamt
			{ 96374, 2599, 23.20, 41.40, "Nelgothar", 264869 }, -- Forgotten Depths
			{ 96465, 2599, 35.90, 59.80, "Shadowguard Destroyer", 265269 }, -- roamt
		},
	},
	{
		key = "naigtal",
		label = "Naigtal",
		shortLabel = "Naigtal",
		rares = {
			{ 96205, 2600, 37.60, 61.80, "Interminable Uarn", 263947 },
			{ 96207, 2600, 77.70, 38.30, "Swalewing Matriarch", 263954 },
			{ 96316, 2600, 28.00, 50.60, "Auredar's Chassis", 264569 }, -- in gebouw The Vacant Vigilant (map 2646); ingang op 2600
			{ 96317, 2600, 54.60, 42.30, "Indomitable Mk XII", 264571 }, -- elite
			{ 96206, 2600, 45.10, 55.40, "Broxion", 263950 },
			{ 96208, 2600, 68.50, 62.20, "Lomelith", 263955 },
			{ 96319, 2600, 70.30, 76.40, "Warp Agent Xi'grivr", 264574 },
			{ 96320, 2600, 55.20, 62.00, "Slaipaan", 264576 },
			{ 97014, 2600, 29.70, 19.20, "Warbringer Thal'kuur", 267422 }, -- extra rare (niet in Slugger-meta)
			{ 96566, 2600, 48.80, 47.40, "Voidwarped Sporebat", 265698 }, -- extra rare (niet in Slugger-meta)
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

--------------------------------------------------------------------------------
-- Rare-doodshoofd (Rob-wens 16 jun): zet een Skull-raidmarker op een bekende
-- rare zodra z'n nameplate verschijnt → meteen herkenbaar tussen de mobs.
-- Wereld-only, alleen als 't nog niet gemarkeerd is, opt-out via ns.db.rareSkull.
-- SetRaidTarget is niet protected (werkt solo/in combat; in groep alleen met
-- assist → pcall vangt de stille fail). Set groeit mee met geleerde npcID's.
--------------------------------------------------------------------------------
local RARE_NPC_SET
-- npcID's die je actief jaagt (toast-klik/route) → krijgen ook een skull, ook
-- als we hun npcID nog niet statisch kenden.
local PENDING_SKULL = {}

local function BuildRareNpcSet()
	RARE_NPC_SET = {}
	for _, zone in ipairs(ZONES) do
		for _, rare in ipairs(zone.rares or {}) do
			local n = tonumber(rare[6])
			if n then
				RARE_NPC_SET[n] = true
			end
		end
	end
	if ns.db and type(ns.db.rareNpcIds) == "table" then
		for _, n in pairs(ns.db.rareNpcIds) do
			n = tonumber(n)
			if n then
				RARE_NPC_SET[n] = true
			end
		end
	end
end

local function NpcIdFromGUID(guid)
	if type(guid) ~= "string" then
		return nil
	end
	return tonumber((select(6, strsplit("-", guid))))
end

-- SetRaidTarget is PROTECTED (ADDON_ACTION_FORBIDDEN) → we tekenen onze eigen
-- skull-texture op de nameplate (taint-veilig, à la RareScanner).
local SKULL_TEX = "Interface\\TargetingFrame\\UI-RaidTargetingIcon_8"

local function IsRareUnit(unit)
	if not unit then
		return false
	end
	if not RARE_NPC_SET then
		BuildRareNpcSet()
	end
	local npcId = NpcIdFromGUID(UnitGUID and UnitGUID(unit))
	return (npcId and (RARE_NPC_SET[npcId] or PENDING_SKULL[npcId])) and true or false
end

local function ShowSkullOnNameplate(np, show)
	if not np then
		return
	end
	local t = np._mhRareSkull
	if show then
		if not t then
			t = np:CreateTexture(nil, "OVERLAY")
			t:SetTexture(SKULL_TEX)
			t:SetSize(26, 26)
			t:SetPoint("BOTTOM", np, "TOP", 0, 2)
			np._mhRareSkull = t
		end
		t:Show()
	elseif t then
		t:Hide()
	end
end

-- Toon/verberg de skull op de nameplate van deze unit (NAME_PLATE_UNIT_ADDED;
-- nameplates worden hergebruikt, dus altijd herevalueren).
local function RefreshNameplateSkull(unit)
	if not unit or (ns.db and ns.db.rareSkull == false) then
		return
	end
	if (IsInInstance and IsInInstance()) or not (C_NamePlate and C_NamePlate.GetNamePlateForUnit) then
		return
	end
	local np = C_NamePlate.GetNamePlateForUnit(unit)
	if np then
		ShowSkullOnNameplate(np, IsRareUnit(unit))
	end
end

local function HideNameplateSkull(unit)
	if not (unit and C_NamePlate and C_NamePlate.GetNamePlateForUnit) then
		return
	end
	local np = C_NamePlate.GetNamePlateForUnit(unit)
	if np and np._mhRareSkull then
		np._mhRareSkull:Hide()
	end
end

-- Direct skullen als de rare al op het scherm staat (bijv. meteen na toast-klik).
local function MarkVisibleRareByNpc(npcId)
	if not (npcId and C_NamePlate and C_NamePlate.GetNamePlates) then
		return
	end
	if (ns.db and ns.db.rareSkull == false) or (IsInInstance and IsInInstance()) then
		return
	end
	local plates = C_NamePlate.GetNamePlates()
	if type(plates) ~= "table" then
		return
	end
	for _, np in ipairs(plates) do
		local unit = np and (np.namePlateUnitToken or (np.UnitFrame and np.UnitFrame.unit))
		if unit and NpcIdFromGUID(UnitGUID and UnitGUID(unit)) == npcId then
			ShowSkullOnNameplate(np, true)
		end
	end
end

-- Markeer een gejaagde rare (toast-klik/route): onthoud z'n npcID én skull 'm
-- meteen als 'ie al zichtbaar is.
function ns.MH_FlagRareForSkull(npcId)
	npcId = tonumber(npcId)
	if not npcId then
		return
	end
	PENDING_SKULL[npcId] = true
	MarkVisibleRareByNpc(npcId)
end

do
	local marker = CreateFrame("Frame")
	marker:RegisterEvent("NAME_PLATE_UNIT_ADDED")
	marker:RegisterEvent("NAME_PLATE_UNIT_REMOVED")
	marker:SetScript("OnEvent", function(_, ev, unit)
		if ev == "NAME_PLATE_UNIT_ADDED" then
			RefreshNameplateSkull(unit)
		else
			HideNameplateSkull(unit)
		end
	end)
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
-- Match radius in continent world yards between a live vignette and a known
-- rare spawn point (rares roam, so this is generous).
local VIGNETTE_MATCH_YARDS = 130

-- Geleerd van RareScanner (RSConstants.IsNpcAtlas): alleen vignettes met een
-- kill-atlas zijn rares. Treasures ("VignetteLoot*"), events ("VignetteEvent*")
-- en quest-POI's vielen eerder in onze afstandsmatch → false positives.
local RARE_KILL_ATLAS = {
	["VignetteKill"] = true,
	["VignetteKillElite"] = true,
	["vignettekillboss"] = true, -- RareScanner kent deze lowercase-variant
}

-- true = zeker een rare-vignette; nil = atlas onbekend (oude client/edge case:
-- behandel als "misschien", alleen naam-match toestaan); false = zeker géén rare.
local function VignetteKillClass(info)
	local atlas = info and info.atlasName
	if type(atlas) ~= "string" or atlas == "" then
		return nil
	end
	return RARE_KILL_ATLAS[atlas] == true
end

-- npcID zit in veld 6 van objectGUID ("Creature-0-...-npcID-spawnUID"),
-- zelfde extractie als RareScanner (RSButtonHandler).
local function NpcIdFromObjectGUID(guid)
	if type(guid) ~= "string" then
		return nil
	end
	return tonumber((select(6, strsplit("-", guid))))
end

-- Zelflerende npcIDs (Robs idee, 12 jun): elke keer dat een vignette aan
-- een rare gekoppeld wordt, leren we het npcID (ns.db.rareNpcIds[questId])
-- — na één hunt kent de addon de modellen van de zone. Never-lie: alleen
-- live geziene koppelingen, nooit gegokt. Bron voor het hover-voorbeeld,
-- de toast-fallback én steeds sterkere npcID-first-matching.
local function LearnRareNpc(questId, npcID)
	if not (ns.db and questId and npcID) then
		return
	end
	if type(ns.db.rareNpcIds) ~= "table" then
		ns.db.rareNpcIds = {}
	end
	ns.db.rareNpcIds[questId] = npcID
end

-- Bekend npcID voor een rare: statisch dataveld (rare[6]) wint, daarna het
-- geleerde ID uit SavedVariables.
local function KnownRareNpc(rare)
	if not rare then
		return nil
	end
	local static = tonumber(rare[6])
	if static then
		return static
	end
	local m = ns.db and ns.db.rareNpcIds
	return m and m[rare[1]] or nil
end

-- Unieke sleutel per rare voor up/found-tracking. Normaal de kill-quest-ID
-- (veld 1); voor rares zonder bevestigde kill-quest (questId 0, bijv. de
-- Showdown-rares van Val/Naigtal) valt 'ie terug op het npcID (veld 6) zodat
-- ze niet allemaal op sleutel "0" botsen.
local function RareKey(rare)
	local q = tonumber(rare and rare[1])
	if q and q ~= 0 then
		return tostring(q)
	end
	local n = tonumber(rare and rare[6])
	if n then
		return "npc:" .. n
	end
	return tostring(rare and rare[1])
end

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

-- Convert a map position (0..1) to continent world coordinates (yards). World
-- coords are isotropic and comparable across maps in the same world, unlike raw
-- 0..1 map coords whose x/y scales differ on non-square zone maps — which is
-- why plain normalized distance misranks nearby rares.
local function MapPosToWorld(mapID, xPct, yPct)
	if not (C_Map and C_Map.GetWorldPosFromMapPos and CreateVector2D) then
		return nil
	end
	-- GetWorldPosFromMapPos returns (continentID, worldPosition); through pcall
	-- that is (ok, continentID, worldPosition).
	local ok, _, world = pcall(C_Map.GetWorldPosFromMapPos, mapID, CreateVector2D(xPct, yPct))
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

local function GetRareWorldPos(rare)
	local m = tonumber(rare[2])
	if not m then
		return nil
	end
	return MapPosToWorld(m, (tonumber(rare[3]) or 0) / 100, (tonumber(rare[4]) or 0) / 100)
end

local function GetPlayerWorldPos()
	if not (C_Map and C_Map.GetBestMapForUnit) then
		return nil
	end
	local pmap = C_Map.GetBestMapForUnit("player")
	if not pmap then
		return nil
	end
	local px, py = GetPlayerPositionOnMap(pmap)
	if not px then
		return nil
	end
	return MapPosToWorld(pmap, px, py)
end

-- Distance (world yards) from a reference world point to a rare. With no
-- reference, the player's current world position is used. Falls back to
-- normalized same-map distance only when world coordinates are unavailable.
local function RareDistanceFromRef(rare, idx, refWX, refWY)
	local rx, ry = GetRareWorldPos(rare)
	if rx and ry then
		local ax, ay = refWX, refWY
		if not (ax and ay) then
			ax, ay = GetPlayerWorldPos()
		end
		if ax and ay then
			local dx = rx - ax
			local dy = ry - ay
			return math.sqrt(dx * dx + dy * dy)
		end
	end

	local tMap = tonumber(rare[2])
	if tMap and not (refWX and refWY) then
		local px, py = GetPlayerPositionOnMap(tMap)
		if px then
			local dx = (tonumber(rare[3]) or 0) / 100 - px
			local dy = (tonumber(rare[4]) or 0) / 100 - py
			return math.sqrt(dx * dx + dy * dy)
		end
	end

	return FAR_CROSSMAP_SORT + idx
end

local function RareSortDistance(rare, idx, refWX, refWY)
	return RareDistanceFromRef(rare, idx, refWX, refWY)
end

local function FindNearestIncompleteRare(zone)
	if not zone or not zone.rares then
		return nil
	end
	local pwx, pwy = GetPlayerWorldPos()
	local bestRare, bestDist
	for idx, rare in ipairs(zone.rares) do
		if not IsRareDoneThisWeek(rare[1]) then
			local dist = RareDistanceFromRef(rare, idx, pwx, pwy)
			if not bestDist or dist < bestDist then
				bestDist = dist
				bestRare = rare
			end
		end
	end
	return bestRare
end

-- Rares you skipped this hunt (RareKey -> true). A skipped rare is pushed to the
-- back so the arrow moves on when a rare isn't spawned; you still get it once the
-- rest are done (or when everything left is skipped, we cycle back over them).
local skippedRares = {}

-- Nearest still-open rare, honouring skips: a non-skipped rare always wins; only if
-- every remaining rare is skipped do we clear the skip list and cycle over them.
local function NearestOpenRareRespectingSkips(zone)
	if not zone or not zone.rares then
		return nil
	end
	local pwx, pwy = GetPlayerWorldPos()
	local best, bestDist, skippedBest, skippedDist
	for idx, rare in ipairs(zone.rares) do
		if not IsRareDoneThisWeek(rare[1]) then
			local dist = RareDistanceFromRef(rare, idx, pwx, pwy)
			if skippedRares[RareKey(rare)] then
				if not skippedDist or dist < skippedDist then
					skippedDist, skippedBest = dist, rare
				end
			elseif not bestDist or dist < bestDist then
				bestDist, best = dist, rare
			end
		end
	end
	if best then
		return best
	end
	if skippedBest then
		wipe(skippedRares) -- only skipped rares remain: cycle back over them
		return skippedBest
	end
	return nil
end

local function CurrentHuntZone()
	local key = GetCurrentZoneKey() or GetSelectedZoneKey()
	return key and ZONE_BY_KEY[key] or nil
end

-- Public: the nearest still-open rare as a lead {mapID,x,y,name}, or nil. Used by
-- NativeArrow (no-TomTom mode) to keep the standalone arrow advancing to the next
-- rare after you kill one — TomTom does this itself, but the native path needs us
-- to re-point. Prefers the zone you're standing in, else the selected zone.
function ns.GetNearestIncompleteRareLead()
	local zone = CurrentHuntZone()
	local rare = zone and NearestOpenRareRespectingSkips(zone)
	if not rare then
		return nil
	end
	return { mapID = rare[2], x = rare[3], y = rare[4], name = GetRareDisplayName(rare) }
end

-- Public: fully stop the rare hunt (used by ns.ClearActiveRoute / /mh clear). Clears
-- the shared arrow, skip list and TomTom waypoints so nothing re-draws.
function ns.StopRareRoute()
	wipe(skippedRares)
	ns.MH_TomTomClearAll()
	if ns._mhRouteOwner == "rare" then
		ns._mhRouteOwner = nil
	end
	ns._mhLastRoutedRareQuest = nil
	ns.lastTarget = nil
end

-- Public: skip the rare the arrow is on right now (e.g. it isn't spawned). Pushes it
-- to the back so the arrow flows to the next open rare; you return to it later. Only
-- meaningful during a full rare hunt (Generate Route).
function ns.SkipCurrentRare()
	if ns._mhRouteOwner ~= "rare" then
		return false
	end
	-- Skip only advances a FULL hunt (Generate Route). A single Find-Nearest route
	-- deliberately stays on its one rare, so don't pretend it moved on.
	if ns._mhLastRoutedRareQuest then
		local msg = ns:L("RARES_SKIP_SINGLE")
		if not msg or msg == "RARES_SKIP_SINGLE" then
			msg = "Skip works during Generate Route. Use it to chain past un-spawned rares."
		end
		print("|cffffff78Midnight Helper:|r " .. msg)
		return true
	end
	local zone = CurrentHuntZone()
	local cur = zone and NearestOpenRareRespectingSkips(zone)
	if not cur then
		return false
	end
	skippedRares[RareKey(cur)] = true
	local nextRare = NearestOpenRareRespectingSkips(zone)
	if nextRare and RareKey(nextRare) ~= RareKey(cur) then
		local msg = ns:L("RARES_SKIP_DONE_FMT")
		if not msg or msg == "RARES_SKIP_DONE_FMT" then
			msg = "Skipped %s — arrow moved to the next rare."
		end
		print("|cffffff78Midnight Helper:|r " .. msg:format(GetRareDisplayName(cur)))
	else
		local msg = ns:L("RARES_SKIP_LAST")
		if not msg or msg == "RARES_SKIP_LAST" then
			msg = "That's the last open rare — nothing to skip to."
		end
		print("|cffffff78Midnight Helper:|r " .. msg)
	end
	return true
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

	local pwx, pwy = GetPlayerWorldPos()
	if #remaining == 1 then
		return { remaining[1].rare }, RareSortDistance(remaining[1].rare, remaining[1].idx, pwx, pwy) < FAR_CROSSMAP_SORT
	end

	local ordered = {}
	local usedDistance = false
	local refWX, refWY

	local firstRare = FindNearestIncompleteRare(zone)
	if firstRare then
		for i = 1, #remaining do
			if remaining[i].rare == firstRare then
				local firstIdx = remaining[i].idx
				table.remove(remaining, i)
				ordered[#ordered + 1] = firstRare
				refWX, refWY = GetRareWorldPos(firstRare)
				if RareSortDistance(firstRare, firstIdx, pwx, pwy) < FAR_CROSSMAP_SORT then
					usedDistance = true
				end
				break
			end
		end
	end

	while #remaining > 0 do
		local bestI, bestDist, bestIdx
		for i, entry in ipairs(remaining) do
			local dist = RareDistanceFromRef(entry.rare, entry.idx, refWX, refWY)
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
		refWX, refWY = GetRareWorldPos(pick.rare)
	end

	return ordered, usedDistance
end

-- Geroutete-rares-administratie (Rob 11 jun, iteratie 2): persistent in
-- ui.rareAlert.routedIds zodat een /reload de rare-hunt niet "vergeet", en
-- als sét omdat GenerateRaresRoute álle rares van de zone routeert. Week-
-- anker erbij zodat een set van vorige week niet blijft naspoken. Gebruik:
-- (a) alert voor een geroutete rare = "je bent er bijna"-tekst i.p.v.
-- "click to add a waypoint"; (b) instelling "alleen melden tijdens hunt".
local function RareRouteAnchor()
	if ns.MhGetWeeklyResetAnchorTs then
		local ok, ts = pcall(ns.MhGetWeeklyResetAnchorTs)
		if ok and tonumber(ts) and ts > 0 then
			return ts
		end
	end
	return 0
end

local function GetRareRouteStore(create)
	local ui = ns.db and ns.db.ui
	if type(ui) ~= "table" then
		return nil
	end
	if type(ui.rareAlert) ~= "table" then
		if not create then
			return nil
		end
		ui.rareAlert = {}
	end
	return ui.rareAlert
end

-- PER CHARACTER (Robs paladin, 12 jun: logde naast een rare in en kreeg de
-- "je bent er bijna"-tekst door de route van een ándere char — ns.db.ui is
-- account-breed). Hunts zijn van de char die de route startte.
local function GetCharRouteStore(create)
	local ra = GetRareRouteStore(create)
	local guid = UnitGUID and UnitGUID("player")
	if not ra or not guid then
		return nil
	end
	-- Legacy account-brede velden opruimen (pre-12-jun).
	ra.routedIds, ra.routedAnchor = nil, nil
	if type(ra.routedByChar) ~= "table" then
		if not create then
			return nil
		end
		ra.routedByChar = {}
	end
	local s = ra.routedByChar[guid]
	if type(s) ~= "table" then
		if not create then
			return nil
		end
		s = {}
		ra.routedByChar[guid] = s
	end
	return s
end

local function MarkRareRouted(rare, replace)
	local s = rare and GetCharRouteStore(true)
	if not s then
		return
	end
	local anchor = RareRouteAnchor()
	if replace or type(s.ids) ~= "table" or s.anchor ~= anchor then
		s.ids = {}
	end
	s.anchor = anchor
	s.ids[RareKey(rare)] = true
end

local function IsRareRouted(rare)
	local s = rare and GetCharRouteStore(false)
	if not s or type(s.ids) ~= "table" or s.anchor ~= RareRouteAnchor() then
		return false
	end
	return s.ids[RareKey(rare)] == true
end

-- Hunt is actief zolang minstens één geroutete rare nog niet gedaan is —
-- de hunt dooft dus vanzelf zodra de route is afgewerkt (of bij de reset).
local function IsRareHuntActive()
	local s = GetCharRouteStore(false)
	if not s or type(s.ids) ~= "table" or s.anchor ~= RareRouteAnchor() then
		return false
	end
	for id in pairs(s.ids) do
		if not IsRareDoneThisWeek(tonumber(id)) then
			return true
		end
	end
	return false
end

local function RouteRare(rare, clearOthers)
	if not rare or not ns.AddSmartTomTomWay then
		return false
	end
	-- clearOthers=true is een nieuwe route → vervang de set; toast-klik
	-- (false) voegt de rare toe aan de lopende hunt.
	MarkRareRouted(rare, clearOthers)
	-- Claim the shared arrow so an active achievement/treasure route stands down
	-- and reclaims it once this rare is done. We remember THIS rare's quest so the
	-- token releases as soon as it's looted, even if older rares linger in the hunt
	-- store (released in the event handler below).
	ns._mhRouteOwner = "rare"
	ns._mhLastRoutedRareQuest = (rare[1] and rare[1] ~= 0) and rare[1] or nil
	-- Gejaagde rare → skull (nu als 'ie al zichtbaar is, anders zodra z'n
	-- nameplate verschijnt). KnownRareNpc = veld 6 of geleerd npcID.
	local rnpc = KnownRareNpc(rare)
	if rnpc and ns.MH_FlagRareForSkull then
		ns.MH_FlagRareForSkull(rnpc)
	end
	if clearOthers then
		ns.MH_TomTomClearAll()
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

-- Read the world position (yards) of a live vignette. GetVignettePosition
-- returns a single CVector2D (normalized on uiMapID), not two numbers.
local function VignetteWorldPos(vignetteGUID, mapID)
	if not (C_VignetteInfo and C_VignetteInfo.GetVignettePosition) then
		return nil
	end
	local okPos, pos = pcall(C_VignetteInfo.GetVignettePosition, vignetteGUID, mapID)
	if not okPos or type(pos) ~= "table" then
		return nil
	end
	local x, y
	if type(pos.GetXY) == "function" then
		local okXY, px, py = pcall(pos.GetXY, pos)
		if okXY then
			x, y = px, py
		end
	end
	if x == nil and type(pos.x) == "number" then
		x, y = pos.x, pos.y
	end
	x, y = VignetteXY(x, y)
	if not x then
		return nil
	end
	return MapPosToWorld(mapID, x, y)
end

-- Live "is this rare here right now" detection. C_VignetteInfo.GetVignettes()
-- (no args) returns the vignette GUIDs the client currently sees around the
-- player — the same source RareScanner uses. We only trust it while the player
-- is actually in the requested zone, then match each vignette to a rare by
-- name and/or world-coordinate proximity.
local function CollectVignettePointsForZone(zoneKey)
	local points = {}
	if not zoneKey or not (C_VignetteInfo and C_VignetteInfo.GetVignettes) then
		return points
	end

	local playerMap = C_Map and C_Map.GetBestMapForUnit and C_Map.GetBestMapForUnit("player")
	if not playerMap then
		return points
	end

	local mapList = ZONE_MAP_IDS[zoneKey]
	local inZone = false
	if mapList then
		for i = 1, #mapList do
			if mapList[i] == playerMap then
				inZone = true
				break
			end
		end
	end
	if not inZone then
		return points
	end

	local okList, vignettes = pcall(C_VignetteInfo.GetVignettes)
	if not okList or type(vignettes) ~= "table" then
		return points
	end

	for vi = 1, #vignettes do
		local vignetteGUID = vignettes[vi]
		local vname, kill, npcID
		if C_VignetteInfo.GetVignetteInfo then
			local okInfo, info = pcall(C_VignetteInfo.GetVignetteInfo, vignetteGUID)
			if okInfo and info then
				vname = info.name or info.vignetteName
				kill = VignetteKillClass(info)
				npcID = NpcIdFromObjectGUID(info.objectGUID)
			end
		end
		-- kill == false → zeker treasure/event/POI: helemaal overslaan.
		if kill ~= false then
			local wx, wy = VignetteWorldPos(vignetteGUID, playerMap)
			if wx or (vname and vname ~= "") then
				points[#points + 1] = { wx = wx, wy = wy, name = vname or "", kill = kill, npcID = npcID }
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
		local rname = GetRareDisplayName(rare)
		local rwx, rwy = GetRareWorldPos(rare)
		local rnpc = KnownRareNpc(rare) -- statisch veld 6 of geleerd ID
		local up = false
		for pi = 1, #points do
			local p = points[pi]
			-- 1) Hardste bewijs: npcID-match (statisch of geleerd).
			if rnpc and p.npcID and p.npcID == rnpc then
				up = true
				break
			end
			-- 2) Naam-match (kill-atlas of atlas onbekend) — en leer het npcID.
			if p.name ~= "" and RareNamesRoughMatch(p.name, rname) then
				if p.npcID then
					LearnRareNpc(rare[1], p.npcID)
				end
				up = true
				break
			end
			-- 3) Afstand: alléén voor bevestigde kill-vignettes (anti-false-positive;
			-- naamloze treasures/events matchen hier niet meer). Blijft nodig als
			-- vangnet voor gelokaliseerde vignette-namen.
			if p.kill == true and rwx and rwy and p.wx and p.wy then
				local dx = p.wx - rwx
				local dy = p.wy - rwy
				if math.sqrt(dx * dx + dy * dy) <= VIGNETTE_MATCH_YARDS then
					up = true
					break
				end
			end
		end
		vignetteUpLookup[zone.key .. ":" .. RareKey(rare)] = up
	end
end

local function IsRareVignetteUp(rare, zoneKey)
	if not rare or not zoneKey then
		return false
	end
	return vignetteUpLookup[zoneKey .. ":" .. RareKey(rare)] == true
end

-- Auto-advance for the native rare hunt (no-TomTom mode). When you've reached the
-- current lead rare but it isn't up (no vignette) and you're not in combat, push it
-- to the back so the arrow flows to the next open rare — the "fly over an empty
-- spawn, move on" behaviour TomTom gave us via cleardistance, without making users
-- type /mh skip. A skipped rare returns automatically once its vignette appears
-- (it spawned) or once everything else is done. `reached` is NativeArrow's
-- frequently-sampled "within arrival range of the lead" latch (catches fast
-- fly-overs between ticks). Returns true when it skipped one.
function ns.MHRareTryAutoAdvance(reached)
	if ns._mhRouteOwner ~= "rare" or ns._mhLastRoutedRareQuest then
		return false
	end
	local zone = CurrentHuntZone()
	if not zone or not zone.rares then
		return false
	end
	RefreshVignetteUpCache(zone)
	-- A previously-skipped rare that is now up (it spawned) becomes eligible again.
	for _, rare in ipairs(zone.rares) do
		local k = RareKey(rare)
		if skippedRares[k] and IsRareVignetteUp(rare, zone.key) then
			skippedRares[k] = nil
		end
	end
	if not reached then
		return false
	end
	local lead = NearestOpenRareRespectingSkips(zone)
	if not lead then
		return false
	end
	if IsRareVignetteUp(lead, zone.key) then
		return false -- it's here — don't skip, you'll kill it
	end
	if UnitAffectingCombat and UnitAffectingCombat("player") then
		return false -- in combat (likely on it) — don't skip
	end
	-- Skip it, but only if there's actually somewhere else to go (don't strand you
	-- on the last open rare — you'll want to wait it out then).
	local leadKey = RareKey(lead)
	skippedRares[leadKey] = true
	local nextRare = NearestOpenRareRespectingSkips(zone)
	if not nextRare or RareKey(nextRare) == leadKey then
		skippedRares[leadKey] = nil
		return false
	end
	return true
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

-- Model-voorbeeld bij hover (Robs idee, 12 jun): klein zwevend paneel met
-- de rare in vol ornaat, links van de rij. Toont alleen bij een bekend of
-- geleerd npcID — geen gok, geen leeg kader. Async-nalaad-tik zoals het
-- boss-venster.
local rarePreview
local rarePreviewGen = 0

local function EnsureRarePreview()
	if rarePreview then
		return rarePreview
	end
	local f = CreateFrame("Frame", nil, UIParent, "BackdropTemplate")
	f:SetSize(170, 200)
	f:SetFrameStrata("TOOLTIP")
	if f.SetBackdrop then
		f:SetBackdrop({
			bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background-Dark",
			edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Gold-Border",
			tile = true,
			tileSize = 32,
			edgeSize = 20,
			insets = { left = 6, right = 6, top = 6, bottom = 6 },
		})
		f:SetBackdropColor(0.05, 0.05, 0.09, 0.95)
	end
	local model = CreateFrame("PlayerModel", nil, f)
	model:SetPoint("TOPLEFT", f, "TOPLEFT", 9, -9)
	model:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -9, 9)
	model:EnableMouse(false)
	f._model = model
	f:Hide()
	rarePreview = f
	return f
end

local function ShowRarePreview(row, npcID)
	if not npcID then
		if rarePreview then
			rarePreview:Hide()
		end
		return
	end
	local f = EnsureRarePreview()
	f:ClearAllPoints()
	f:SetPoint("RIGHT", row, "LEFT", -10, 0)
	rarePreviewGen = rarePreviewGen + 1
	local gen = rarePreviewGen
	local function apply()
		f._model:ClearModel()
		f._model:SetCreature(npcID)
		if f._model.SetPortraitZoom then
			f._model:SetPortraitZoom(0)
		end
		if f._model.SetPosition then
			f._model:SetPosition(0, 0, 0)
		end
		if f._model.SetFacing then
			f._model:SetFacing(0.45)
		end
	end
	local ok = pcall(apply)
	if not ok then
		f:Hide()
		return
	end
	f:Show()
	if C_Timer and C_Timer.After then
		C_Timer.After(0.2, function()
			if gen == rarePreviewGen and f:IsShown() then
				pcall(apply)
			end
		end)
	end
end

local function HideRarePreview()
	if rarePreview then
		rarePreview:Hide()
	end
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
		GameTooltip:SetOwner(self, "ANCHOR_CURSOR")
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
		ShowRarePreview(self, KnownRareNpc(r))
	end)
	btn:SetScript("OnLeave", function()
		HideRarePreview()
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

	ns.MH_TomTomClearAll()

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
			-- Hele route = hunt: eerste pin vervangt de oude set, rest vult aan
			-- (alerts voor deze rares krijgen de "je bent er bijna"-variant).
			MarkRareRouted(rare, added == 1)
		end
	end

	if added > 0 then
		wipe(skippedRares) -- fresh hunt: forget previous skips
		ns._mhRouteOwner = "rare" -- claim the shared arrow (see RouteRare note)
		ns._mhLastRoutedRareQuest = nil -- a full route: release when the whole hunt is done
		-- AddSmartTomTomWay set ns.lastTarget to the LAST pin added; for the native
		-- arrow the lead must be the FIRST (nearest) rare. (NativeArrow then keeps it
		-- advancing to the nearest still-open rare via ns.GetNearestIncompleteRareLead.)
		local lead = routeRares[1]
		if lead then
			ns.lastTarget = { mapID = lead[2], x = lead[3], y = lead[4], name = GetRareDisplayName(lead) }
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
		fs:SetFontObject(ns.MHScalableFont("GameFontHighlightSmall"))
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
	-- Content-tekstschaal: rij-hoogte + Y-stap schalen mee zodat grotere tekst
	-- de twee kolommen niet laat overlappen. Bij schaal 1.0 identiek aan voorheen.
	local s = (ns.GetContentFontScale and ns.GetContentFontScale()) or 1
	local rowH = ROW_H * s
	local rowStep = rowH + ROW_GAP
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
		btn:SetHeight(rowH)
		btn:ClearAllPoints()

		local col = (i <= rowsPerCol) and 0 or 1
		local rowInCol = (col == 0) and i or (i - rowsPerCol)
		local xOff = col * (colW + LIST_COL_GAP)
		local y = (rowInCol - 1) * rowStep
		btn:SetPoint("TOPLEFT", listHost, "TOPLEFT", xOff, -y)
		btn:Show()
		maxY = math.max(maxY, y + rowH)
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
	titleFs:SetFontObject(ns.MHScalableFont("GameFontHighlightLarge"))
	titleFs:SetPoint("TOPLEFT", frame, "TOPLEFT", 14, -12)
	titleFs:SetText(ns:L("RARES_TITLE"))

	subtitleFs = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	subtitleFs:SetFontObject(ns.MHScalableFont("GameFontHighlightSmall"))
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

--------------------------------------------------------------------------------
-- Live "rare nearby" alert: sound + on-screen toast that works with the main
-- window closed. Uses the same source as RareScanner (C_VignetteInfo.GetVignettes)
-- but only for the rares we track, deduped per spawn (objectGUID) so a persistent
-- vignette only pings once.
--------------------------------------------------------------------------------
local rareAlertSeen = {} -- dedupe key -> GetTime() when last alerted
local RARE_ALERT_TTL = 900 -- don't re-alert the same spawn within 15 min
local rareAlertScanAt = 0
local RARE_ALERT_SCAN_THROTTLE = 1.0
local RARE_ALERT_ICON = "Interface\\Icons\\INV_Misc_Head_Dragon_01"
local RARE_ALERT_DISPLAY_SEC = 14
-- Only alert for rares the player is actually close to. C_VignetteInfo can
-- surface vignettes from across the zone, so without this gate you get pinged
-- for a rare on the far side of the map. ~500 yds ≈ "in the neighbourhood".
local RARE_ALERT_MAX_YARDS = 500

local function GetRareAlertSettings()
	local ui = ns.db and ns.db.ui
	if type(ui) ~= "table" then
		return { enabled = true, sound = true }
	end
	if type(ui.rareAlert) ~= "table" then
		ui.rareAlert = { enabled = true, sound = true }
	end
	local s = ui.rareAlert
	if s.enabled == nil then
		s.enabled = true
	end
	if s.sound == nil then
		s.sound = true
	end
	return s
end
ns.GetRareAlertSettings = GetRareAlertSettings

function ns.SetRareAlertEnabled(enabled)
	GetRareAlertSettings().enabled = enabled and true or false
end

function ns.SetRareAlertOnlyWhileRouting(v)
	GetRareAlertSettings().onlyWhileRouting = v and true or false
end

-- vkill: true = kill-atlas, nil = atlas onbekend, false = zeker geen rare
-- (false wordt door de aanroepers al weggefilterd). Afstandsmatch alleen bij
-- vkill == true — zie RefreshVignetteUpCache voor de redenatie.
local function MatchRareInZone(zone, vname, vwx, vwy, vnpc, vkill)
	if not zone or not zone.rares then
		return nil
	end
	for _, rare in ipairs(zone.rares) do
		if vnpc and KnownRareNpc(rare) == vnpc then
			return rare
		end
		if vname and vname ~= "" and RareNamesRoughMatch(vname, GetRareDisplayName(rare)) then
			if vnpc then
				LearnRareNpc(rare[1], vnpc) -- naam-match → npcID leren
			end
			return rare
		end
		if vkill == true and vwx and vwy then
			local rwx, rwy = GetRareWorldPos(rare)
			if rwx and rwy then
				local dx = vwx - rwx
				local dy = vwy - rwy
				if math.sqrt(dx * dx + dy * dy) <= VIGNETTE_MATCH_YARDS then
					return rare
				end
			end
		end
	end
	return nil
end

-- npcId (optioneel): toont het 3D-model van de rare in de toast i.p.v. het
-- drakenkop-icoon. Komt live uit de vignette-objectGUID, of uit rare[6].
-- onRoute: dit is het actieve route-doel → aankomst-tekst, geen klik-aanbod.
local function FireRareAlert(rare, npcId, onRoute)
	local s = GetRareAlertSettings()
	-- Onthoud het laatste echte npcID zodat /mh raretest het model kan
	-- hertonen — finetune-loop zonder op een nieuwe spawn te wachten.
	if npcId then
		s.lastNpcId = npcId
	end
	local name = GetRareDisplayName(rare)
	if ns.QueueMidnightToast then
		local spec = {
			id = "rare:" .. RareKey(rare),
			title = name,
			body = ns:L(onRoute and "RARE_ALERT_TOAST_ONROUTE_BODY" or "RARE_ALERT_TOAST_BODY"),
			icon = RARE_ALERT_ICON,
			npcId = npcId or KnownRareNpc(rare),
			scale = 2, -- Rob 11 jun: rare-toast 2× zo groot (andere toasts 1×)
			displaySec = RARE_ALERT_DISPLAY_SEC,
		}
		if not onRoute then
			spec.clickHintKey = "RARE_ALERT_CLICK_HINT" -- geen "delve items"-fossiel
			-- clearOthers=false: add this rare as an extra waypoint (arrow points
			-- to it) without wiping a route the player may already be following.
			spec.onClick = function()
				-- Skull de gejaagde rare (live npcID = betrouwbaarst); RouteRare
				-- vlagt 'm ook nog via KnownRareNpc als vangnet.
				if (npcId or KnownRareNpc(rare)) and ns.MH_FlagRareForSkull then
					ns.MH_FlagRareForSkull(npcId or KnownRareNpc(rare))
				end
				RouteRare(rare, false)
			end
		end
		ns.QueueMidnightToast(spec)
	end
	if s.sound ~= false and PlaySound and SOUNDKIT then
		-- Alarm clock is the most attention-grabbing built-in; fall back through
		-- ready-check / raid warning if a client lacks the kit. Master channel so
		-- it is audible even with SFX volume low.
		local kit = SOUNDKIT.ALARM_CLOCK_WARNING_3
			or SOUNDKIT.READY_CHECK
			or SOUNDKIT.RAID_WARNING
			or SOUNDKIT.UI_WORLDQUEST_START
		if kit then
			pcall(PlaySound, kit, "Master")
			if C_Timer and C_Timer.After then
				C_Timer.After(0.7, function()
					pcall(PlaySound, kit, "Master")
				end)
			end
		end
	end
end

local function ScanForRareAlerts()
	local s = GetRareAlertSettings()
	if not s.enabled then
		return
	end
	-- Optioneel: alleen melden tijdens een rare-hunt (route gestart vanuit
	-- het Rares-paneel of een eerdere toast; persistent per week).
	if s.onlyWhileRouting and not IsRareHuntActive() then
		return
	end
	if not (C_VignetteInfo and C_VignetteInfo.GetVignettes) then
		return
	end
	local now = (GetTime and GetTime()) or 0
	if (now - rareAlertScanAt) < RARE_ALERT_SCAN_THROTTLE then
		return
	end
	rareAlertScanAt = now

	local playerMap = C_Map and C_Map.GetBestMapForUnit and C_Map.GetBestMapForUnit("player")
	if not playerMap then
		return
	end
	local zoneKey = MAP_TO_ZONE_KEY[playerMap]
	local zone = zoneKey and ZONE_BY_KEY[zoneKey]
	if not zone then
		return
	end

	local okList, vignettes = pcall(C_VignetteInfo.GetVignettes)
	if not okList or type(vignettes) ~= "table" then
		return
	end

	for guid, t in pairs(rareAlertSeen) do
		if (now - t) > RARE_ALERT_TTL then
			rareAlertSeen[guid] = nil
		end
	end

	local pwx, pwy = GetPlayerWorldPos()

	for vi = 1, #vignettes do
		local vignetteGUID = vignettes[vi]
		local info
		local okInfo, vinfo = pcall(C_VignetteInfo.GetVignetteInfo, vignetteGUID)
		if okInfo then
			info = vinfo
		end
		local vkill = VignetteKillClass(info)
		if info and vkill ~= false then
			local dedupeKey = info.objectGUID or vignetteGUID
			if not rareAlertSeen[dedupeKey] then
				local vwx, vwy = VignetteWorldPos(vignetteGUID, playerMap)
				local rare = MatchRareInZone(zone, info.name, vwx, vwy,
					NpcIdFromObjectGUID(info.objectGUID), vkill)
				if rare and not IsRareDoneThisWeek(rare[1]) then
					-- Distance gate: prefer the vignette's own position, fall
					-- back to the rare's known spot. Skip if we can't tell or
					-- it's farther than the alert radius.
					local tx, ty = vwx, vwy
					if not (tx and ty) then
						tx, ty = GetRareWorldPos(rare)
					end
					local near = true
					if pwx and pwy and tx and ty then
						local dx, dy = tx - pwx, ty - pwy
						near = math.sqrt(dx * dx + dy * dy) <= RARE_ALERT_MAX_YARDS
					end
					if near then
						rareAlertSeen[dedupeKey] = now
						-- "You're nearly there" only when you're ACTUALLY on a rare route
						-- right now (owner == "rare"). Being in the weekly hunt store isn't
						-- enough — otherwise it falsely fires while you're routing a treasure
						-- (or anything else) and just pass a previously-routed rare.
						local onRoute = IsRareRouted(rare) and ns._mhRouteOwner == "rare"
						FireRareAlert(rare, NpcIdFromObjectGUID(info.objectGUID), onRoute)
					end
				end
			end
		end
	end
end
ns.ScanRareAlerts = ScanForRareAlerts

-- /mh raretest — fire the alert output path (toast + sound) on demand.
function ns.TestRareAlert()
	local playerMap = C_Map and C_Map.GetBestMapForUnit and C_Map.GetBestMapForUnit("player")
	local zoneKey = playerMap and MAP_TO_ZONE_KEY[playerMap]
	local zone = zoneKey and ZONE_BY_KEY[zoneKey]
	local rare = (zone and zone.rares and zone.rares[1]) or (ZONES[1] and ZONES[1].rares[1])
	if rare then
		-- Model-fallback: bekend/geleerd npcID, anders het laatst geziene.
		FireRareAlert(rare, KnownRareNpc(rare) or GetRareAlertSettings().lastNpcId)
		print("|cffffcc00MH:|r raretest fired for " .. GetRareDisplayName(rare))
	else
		print("|cffffcc00MH:|r raretest — no rare available")
	end
end

-- /mh rarescan — dump what the live scan currently sees and how it matches.
function ns.DebugRareScan()
	local function p(s)
		print("|cffffcc00MH rarescan:|r " .. s)
	end
	local s = GetRareAlertSettings()
	p(("enabled=%s sound=%s | toast.enabled=%s"):format(
		tostring(s.enabled),
		tostring(s.sound),
		tostring(ns.db and ns.db.ui and ns.db.ui.toast and ns.db.ui.toast.enabled)
	))
	if not (C_VignetteInfo and C_VignetteInfo.GetVignettes) then
		p("C_VignetteInfo.GetVignettes MISSING")
		return
	end
	local playerMap = C_Map and C_Map.GetBestMapForUnit and C_Map.GetBestMapForUnit("player")
	local zoneKey = playerMap and MAP_TO_ZONE_KEY[playerMap]
	local zone = zoneKey and ZONE_BY_KEY[zoneKey]
	p(("playerMap=%s zoneKey=%s zone=%s"):format(tostring(playerMap), tostring(zoneKey), zone and "ok" or "NIL"))
	local okList, vignettes = pcall(C_VignetteInfo.GetVignettes)
	if not okList or type(vignettes) ~= "table" then
		p("GetVignettes failed or returned non-table")
		return
	end
	p(("vignettes nearby = %d"):format(#vignettes))
	for vi = 1, #vignettes do
		local guid = vignettes[vi]
		local okInfo, info = pcall(C_VignetteInfo.GetVignetteInfo, guid)
		if okInfo and type(info) == "table" then
			local vwx, vwy = VignetteWorldPos(guid, playerMap)
			local vkill = VignetteKillClass(info)
			local vnpc = NpcIdFromObjectGUID(info.objectGUID)
			local matched = zone and vkill ~= false
				and MatchRareInZone(zone, info.name, vwx, vwy, vnpc, vkill)
			p(("  [%d] name=%q atlas=%s kill=%s npc=%s onMM=%s onWM=%s worldpos=%s -> match=%s done=%s"):format(
				vi,
				tostring(info.name),
				tostring(info.atlasName),
				tostring(vkill),
				tostring(vnpc),
				tostring(info.onMinimap),
				tostring(info.onWorldMap),
				(vwx and "yes" or "no"),
				matched and GetRareDisplayName(matched) or "NONE",
				matched and tostring(IsRareDoneThisWeek(matched[1])) or "-"
			))
		else
			p(("  [%d] GetVignetteInfo returned nothing"):format(vi))
		end
	end
end

local ev = CreateFrame("Frame")
ev:RegisterEvent("QUEST_LOG_UPDATE")
ev:RegisterEvent("ZONE_CHANGED_NEW_AREA")
ev:RegisterEvent("PLAYER_ENTERING_WORLD")
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
	-- Release the shared arrow once the routed rare is done (or the whole hunt is
	-- finished), so a paused achievement/treasure route can reclaim it (it watches
	-- for owner == nil).
	if ns._mhRouteOwner == "rare" then
		local q = ns._mhLastRoutedRareQuest
		if (q and IsRareDoneThisWeek(q)) or not IsRareHuntActive() then
			ns._mhRouteOwner = nil
			ns._mhLastRoutedRareQuest = nil
		end
	end
	if
		event == "VIGNETTES_UPDATED"
		or event == "VIGNETTE_MINIMAP_UPDATED"
		or event == "ZONE_CHANGED_NEW_AREA"
		or event == "PLAYER_ENTERING_WORLD"
	then
		ScanForRareAlerts()
	end
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
