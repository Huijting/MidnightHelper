--[[
	MidnightHelper — Profession module (Midnight expansion Knowledge Points + optional TomTom).

	Resolves learned professions to Midnight trade skill line IDs where known, then reads
	unspent KP from C_ProfSpecs + C_Traits (no hardcoded expansion currency IDs).
]]

local addonName, ns = ...

local C_TradeSkillUI = C_TradeSkillUI
local C_ProfSpecs = C_ProfSpecs
local C_Traits = C_Traits
local C_QuestLog = C_QuestLog
local C_AddOns = C_AddOns
local C_Map = C_Map
local C_CurrencyInfo = C_CurrencyInfo

local GameTooltip = GameTooltip

local GetProfessions = GetProfessions
local GetProfessionInfo = GetProfessionInfo

local E = Enum and Enum.Profession

local Config = ns.Config or {}

--------------------------------------------------------------------------------
-- Midnight expansion: TradeSkillLineIDs (Retail Midnight; see TradeSkillLineID wiki).
-- C_ProfSpecs / C_Traits KP must use these lines, not legacy Khaz Algar scan IDs.
--------------------------------------------------------------------------------
local MIDNIGHT_SKILL_LINE_BY_PROFESSION_ENUM = {}
if E then
	-- https://warcraft.wiki.gg/wiki/TradeSkillLineID (Midnight block 2906–2918)
	if E.Alchemy then
		MIDNIGHT_SKILL_LINE_BY_PROFESSION_ENUM[E.Alchemy] = 2906
	end
	if E.Blacksmithing then
		MIDNIGHT_SKILL_LINE_BY_PROFESSION_ENUM[E.Blacksmithing] = 2907
	end
	if E.Cooking then
		MIDNIGHT_SKILL_LINE_BY_PROFESSION_ENUM[E.Cooking] = 2908
	end
	if E.Enchanting then
		MIDNIGHT_SKILL_LINE_BY_PROFESSION_ENUM[E.Enchanting] = 2909
	end
	if E.Engineering then
		MIDNIGHT_SKILL_LINE_BY_PROFESSION_ENUM[E.Engineering] = 2910
	end
	if E.Fishing then
		MIDNIGHT_SKILL_LINE_BY_PROFESSION_ENUM[E.Fishing] = 2911
	end
	if E.Herbalism then
		MIDNIGHT_SKILL_LINE_BY_PROFESSION_ENUM[E.Herbalism] = 2912
	end
	if E.Inscription then
		MIDNIGHT_SKILL_LINE_BY_PROFESSION_ENUM[E.Inscription] = 2913
	end
	if E.Jewelcrafting then
		MIDNIGHT_SKILL_LINE_BY_PROFESSION_ENUM[E.Jewelcrafting] = 2914
	end
	if E.Leatherworking then
		MIDNIGHT_SKILL_LINE_BY_PROFESSION_ENUM[E.Leatherworking] = 2915
	end
	if E.Mining then
		MIDNIGHT_SKILL_LINE_BY_PROFESSION_ENUM[E.Mining] = 2916
	end
	if E.Skinning then
		MIDNIGHT_SKILL_LINE_BY_PROFESSION_ENUM[E.Skinning] = 2917
	end
	if E.Tailoring then
		MIDNIGHT_SKILL_LINE_BY_PROFESSION_ENUM[E.Tailoring] = 2918
	end
end

local function ResolveMidnightSkillLineID(scannedSkillLineID, professionEnum)
	if professionEnum and MIDNIGHT_SKILL_LINE_BY_PROFESSION_ENUM[professionEnum] then
		return MIDNIGHT_SKILL_LINE_BY_PROFESSION_ENUM[professionEnum]
	end
	return scannedSkillLineID
end

--------------------------------------------------------------------------------
-- Combined Midnight treasures + profession books (TomTom targets)
-- Format: { questID, mapID, x, y, name, profession [, bookCost] }
-- bookCost (books only): { abundanceAmount, "Abundance", moxieAmount, "Moxie" }
--------------------------------------------------------------------------------
local BOOK_ABUNDANCE_MOXIE_COST = { 1600, "Abundance", 75, "Moxie" }

local MIDNIGHT_DATA = {
	-- Alchemy
	{ 89115, 2393, 49.1, 75.6, "Freshly Plucked Peacebloom", "Alchemy" },
	{ 89117, 2393, 47.8, 51.6, "Pristine Potion", "Alchemy" },
	{ 89114, 2437, 40.4, 51.0, "Vial of Zul'Aman Oddities", "Alchemy" },
	{ 89116, 2536, 49.1, 23.1, "Measured Ladle", "Alchemy" },
	{ 89113, 2413, 34.7, 24.7, "Vial of Rootlands Oddities", "Alchemy" },
	{ 89112, 2444, 41.8, 40.5, "Vial of Voidstorm Oddities", "Alchemy" },
	{ 89111, 2393, 45.12, 44.77, "Vial of Eversong Oddities", "Alchemy" },
	{ 89118, 2405, 32.8, 43.3, "Failed Experiment", "Alchemy" },

	-- Blacksmithing
	{ 89183, 2393, 49.3, 61.3, "Sin'dorei Master's Forgemace", "Blacksmithing" },
	{ 89184, 2393, 48.5, 74.8, "Silvermoon Blacksmith's Hammer", "Blacksmithing" },
	{ 89177, 2393, 26.9, 60.3, "Deconstructed Forge Techniques", "Blacksmithing" },
	{ 89180, 2395, 56.8, 40.7, "Metalworking Cheat Sheet", "Blacksmithing" },
	{ 89178, 2395, 48.3, 75.7, "Silvermoon Smithing Kit", "Blacksmithing" },
	{ 89179, 2536, 33.2, 65.8, "Carefully Racked Spear", "Blacksmithing" },
	{ 89182, 2413, 66.3, 50.8, "Rutaani Floratender's Sword", "Blacksmithing" },
	{ 89181, 2444, 30.6, 68.9, "Voidstorm Defense Spear", "Blacksmithing" },

	-- Enchanting
	{ 89107, 2395, 63.4, 32.6, "Sin'dorei Enchanting Rod", "Enchanting" },
	{ 89106, 2437, 40.4, 51.2, "Loa-Blessed Dust", "Enchanting" },
	{ 89104, 2413, 37.7, 65.3, "Entropic Shard", "Enchanting" },
	{ 89102, 2405, 35.5, 58.8, "Pure Void Crystal", "Enchanting" },
	{ 89100, 2536, 49.1, 22.7, "Enchanted Amani Mask", "Enchanting" },
	{ 89105, 2413, 65.8, 50.2, "Primal Essence Orb", "Enchanting" },
	{ 89103, 2395, 60.8, 53.1, "Everblazing Sunmote", "Enchanting" },
	{ 89101, 2395, 40.20, 61.23, "Enchanted Sunfire Silk", "Enchanting" },

	-- Engineering
	{ 89139, 2393, 51.2, 57.1, "What To Do When Nothing Works", "Engineering" },
	{ 89133, 2393, 51.4, 74.6, "One Engineer's Junk", "Engineering" },
	{ 89135, 2395, 39.5, 45.8, "Manual of Mistakes and Mishaps", "Engineering" },
	{ 89138, 2536, 65.1, 34.5, "Offline Helper Bot", "Engineering" },
	{ 89140, 2437, 34.2, 87.9, "Handy Wrench", "Engineering" },
	{ 89136, 2413, 67.9, 49.8, "Expeditious Pylon", "Engineering" },
	{ 89137, 2444, 54.0, 51.0, "Ethereal Stormwrench", "Engineering" },
	{ 89134, 2444, 29.0, 39.2, "Miniaturized Transport Skiff", "Engineering" },

	-- Herbalism
	{ 89160, 2393, 49.0, 75.8, "Simple Leaf Pruners", "Herbalism" },
	{ 89158, 2395, 64.2, 30.4, "A Spade", "Herbalism" },
	{ 89161, 2437, 41.8, 45.9, "Sweeping Harvester's Scythe", "Herbalism" },
	{ 89157, 2413, 76.1, 51.1, "Harvester's Sickle", "Herbalism" },
	{ 89162, 2413, 38.1, 66.9, "Bloomed Bud", "Herbalism" },
	{ 89159, 2413, 36.6, 25.0, "Lightbloom Root", "Herbalism" },
	{ 89155, 2413, 51.1, 55.7, "Planting Shovel", "Herbalism" },
	{ 89156, 2405, 34.6, 57.0, "Peculiar Lotus", "Herbalism" },

	-- Inscription
	{ 89073, 2393, 47.7, 50.3, "Songwriter's Pen", "Inscription" },
	{ 89074, 2395, 40.4, 61.3, "Songwriter's Quill", "Inscription" },
	{ 89069, 2395, 48.3, 75.6, "Spare Ink", "Inscription" },
	{ 89068, 2437, 40.5, 49.4, "Leather-Bound Techniques", "Inscription" },
	{ 89070, 2413, 52.7, 50.0, "Leftover Sanguithorn Pigment", "Inscription" },
	{ 89071, 2413, 52.4, 52.6, "Intrepid Explorer's Marker", "Inscription" },
	{ 89067, 2444, 60.7, 84.1, "Void-Touched Quill", "Inscription" },
	{ 89072, 2395, 39.3, 45.4, "Half-Baked Techniques", "Inscription" },

	-- Jewelcrafting
	{ 89122, 2393, 50.6, 56.5, "Sin'dorei Masterwork Chisel", "Jewelcrafting" },
	{ 89127, 2393, 55.5, 48.0, "Vintage Soul Gem", "Jewelcrafting" },
	{ 89125, 2395, 56.7, 40.9, "Poorly Rounded Vial", "Jewelcrafting" },
	{ 89129, 2395, 39.7, 38.8, "Sin'dorei Gem Faceters", "Jewelcrafting" },
	{ 89123, 2444, 30.6, 69.0, "Speculative Voidstorm Crystal", "Jewelcrafting" },
	{ 89128, 2444, 54.2, 51.2, "Ethereal Gem Pliers", "Jewelcrafting" },
	{ 89126, 2444, 62.9, 53.5, "Shattered Glass", "Jewelcrafting" },
	{ 89124, 2393, 28.61, 46.47, "Dual-Function Magnifiers", "Jewelcrafting" },

	-- Leatherworking
	{ 89096, 2393, 44.8, 56.2, "Artisan's Considered Order", "Leatherworking" },
	{ 89092, 2536, 45.2, 45.3, "Bundle of Tanner's Trinkets", "Leatherworking" },
	{ 89089, 2437, 33.1, 78.9, "Amani Leatherworker's Tool", "Leatherworking" },
	{ 89095, 2413, 36.1, 25.2, "Haranir Leatherworking Knife", "Leatherworking" },
	{ 89090, 2405, 34.8, 56.9, "Ethereal Leatherworking Knife", "Leatherworking" },
	{ 89091, 2437, 30.8, 84.1, "Prestigiously Racked Hide", "Leatherworking" },
	{ 89094, 2413, 51.8, 51.3, "Haranir Leatherworking Mallet", "Leatherworking" },
	{ 89093, 2444, 53.8, 51.6, "Patterns: Beyond the Void", "Leatherworking" },

	-- Mining
	{ 89147, 2395, 38.0, 45.3, "Solid Ore Punchers", "Mining" },
	{ 89145, 2437, 41.9, 46.3, "Spelunker's Lucky Charm", "Mining" },
	{ 89151, 2413, 38.8, 65.9, "Spare Expedition Torch", "Mining" },
	{ 89149, 2536, 33.6, 66.0, "Amani Expert's Chisel", "Mining" },
	{ 89150, 2405, 41.8, 38.2, "Star Metal Deposit", "Mining" },
	{ 89148, 2444, 28.73, 38.56, "Glimmering Void Pearl", "Mining" },
	{ 89146, 2444, 54.24, 51.59, "Lost Voidstorm Satchel", "Mining" },
	{ 89144, 2444, 30.0, 69.0, "Miner's Guide to Voidstorm", "Mining" },

	-- Skinning
	{ 89171, 2393, 43.2, 55.7, "Sin'dorei Tanning Oil", "Skinning" },
	{ 89173, 2395, 48.5, 76.2, "Thalassian Skinning Knife", "Skinning" },
	{ 89170, 2437, 40.4, 36.0, "Amani Tanning Oil", "Skinning" },
	{ 89172, 2437, 33.1, 79.0, "Amani Skinning Knife", "Skinning" },
	{ 89167, 2536, 45.0, 44.7, "Cadre Skinning Knife", "Skinning" },
	{ 89168, 2413, 69.5, 49.2, "Primal Hide", "Skinning" },
	{ 89166, 2413, 76.0, 51.0, "Lightbloom Afflicted Hide", "Skinning" },
	{ 89169, 2444, 45.5, 42.4, "Voidstorm Leather Sample", "Skinning" },

	-- Tailoring
	{ 89079, 2393, 35.8, 61.2, "A Really Nice Curtain", "Tailoring" },
	{ 89084, 2393, 31.7, 68.2, "Particularly Enchanting Tablecloth", "Tailoring" },
	{ 89085, 2437, 40.4, 49.4, "Artisan's Cover Comb", "Tailoring" },
	{ 89080, 2395, 46.3, 34.8, "Sin'dorei Outfitter's Ruler", "Tailoring" },
	{ 89078, 2413, 70.5, 50.8, "A Child's Stuffy", "Tailoring" },
	{ 89081, 2413, 69.8, 51.0, "Wooden Weaving Sword", "Tailoring" },
	{ 89082, 2444, 61.9, 83.7, "Book of Sin'dorei Stitches", "Tailoring" },
	{ 89083, 2444, 61.4, 85.0, "Satin Throw Pillow", "Tailoring" },

	-- Profession books (Abundance + Artisan's Moxie costs; IDs from ns.Config / Config.lua)
	{ 93794, 2405, 52.4, 72.8, "Book: Alchemy (Anomander)", "Alchemy", BOOK_ABUNDANCE_MOXIE_COST },
	{ 93795, 2405, 52.4, 72.8, "Book: Blacksmithing (Anomander)", "Blacksmithing", BOOK_ABUNDANCE_MOXIE_COST },
	{ 92374, 2395, 43.4, 47.4, "Book: Enchanting (Caeris)", "Enchanting", BOOK_ABUNDANCE_MOXIE_COST },
	-- Echo of Abundance (Chel) — Abundance world event books (replaces legacy Chel pins)
	{ 95101, 2395, 56.78, 65.79, "Echo of Abundance: Enchanting (Chel)", "Enchanting", BOOK_ABUNDANCE_MOXIE_COST },
	{ 95102, 2437, 31.62, 26.14, "Echo of Abundance: Skinning (Chel)", "Skinning", BOOK_ABUNDANCE_MOXIE_COST },
	{ 95103, 2413, 66.14, 61.69, "Echo of Abundance: Herbalism (Chel)", "Herbalism", BOOK_ABUNDANCE_MOXIE_COST },
	{ 95104, 2405, 38.82, 53.31, "Echo of Abundance: Mining (Chel)", "Mining", BOOK_ABUNDANCE_MOXIE_COST },
	{ 93796, 2405, 52.4, 72.8, "Book: Engineering (Anomander)", "Engineering", BOOK_ABUNDANCE_MOXIE_COST },
	{ 93222, 2395, 43.4, 47.4, "Book: Jewelcrafting (Caeris)", "Jewelcrafting", BOOK_ABUNDANCE_MOXIE_COST },
	{ 92371, 2437, 45.8, 65.8, "Book: Leatherworking (Magovu)", "Leatherworking", BOOK_ABUNDANCE_MOXIE_COST },
	{ 92372, 2437, 45.8, 65.8, "Book: Mining (Magovu)", "Mining", BOOK_ABUNDANCE_MOXIE_COST },
	{ 92373, 2437, 45.8, 65.8, "Book: Skinning (Magovu)", "Skinning", BOOK_ABUNDANCE_MOXIE_COST },
	{ 93201, 2395, 43.4, 47.4, "Book: Tailoring (Caeris)", "Tailoring", BOOK_ABUNDANCE_MOXIE_COST },
}

--------------------------------------------------------------------------------
-- Profession labels: strip expansion prefixes so UI/API names match MIDNIGHT_DATA
--------------------------------------------------------------------------------
local function NormalizeProfessionLabel(s)
	if not s then
		return ""
	end
	local t = string.gsub(tostring(s), "^%s+", "")
	t = string.gsub(t, "%s+$", "")
	t = string.gsub(t, "^[Mm]idnight%s+", "")
	t = string.gsub(t, "^[Kk]haz%s+[Aa]lgar%s+", "")
	return string.lower(t)
end

local function PrimaryProfessionMatchesDataColumn(dataProfessionName, primaryEntries)
	if not dataProfessionName or dataProfessionName == "" then
		return false
	end
	local want = NormalizeProfessionLabel(dataProfessionName)
	for _, L in ipairs(primaryEntries) do
		if NormalizeProfessionLabel(L.name) == want then
			return true
		end
	end
	return false
end

local function ProfessionLabelToEnum(dataProfessionName)
	local k = NormalizeProfessionLabel(dataProfessionName or "")
	local map = {
		alchemy = E and E.Alchemy,
		blacksmithing = E and E.Blacksmithing,
		cooking = E and E.Cooking,
		enchanting = E and E.Enchanting,
		engineering = E and E.Engineering,
		fishing = E and E.Fishing,
		herbalism = E and E.Herbalism,
		inscription = E and E.Inscription,
		jewelcrafting = E and E.Jewelcrafting,
		leatherworking = E and E.Leatherworking,
		mining = E and E.Mining,
		skinning = E and E.Skinning,
		tailoring = E and E.Tailoring,
	}
	return map[k]
end

local function GetCurrencyQuantity(currencyID)
	if not currencyID or not C_CurrencyInfo or not C_CurrencyInfo.GetCurrencyInfo then
		return 0
	end
	local ok, info = pcall(C_CurrencyInfo.GetCurrencyInfo, currencyID)
	if ok and info and info.quantity ~= nil then
		return tonumber(info.quantity) or 0
	end
	return 0
end

local function GetCurrencyDisplayName(currencyID)
	if not currencyID or not C_CurrencyInfo or not C_CurrencyInfo.GetCurrencyInfo then
		return nil
	end
	local ok, info = pcall(C_CurrencyInfo.GetCurrencyInfo, currencyID)
	if ok and info and type(info.name) == "string" then
		return info.name
	end
	return nil
end

local function GetItemQuantityByID(itemID)
	local id = tonumber(itemID)
	if not id then
		return 0
	end
	if C_Item and C_Item.GetItemCount then
		local ok, n = pcall(function()
			return C_Item.GetItemCount(id)
		end)
		if ok and n ~= nil then
			return tonumber(n) or 0
		end
	end
	if type(GetItemCount) == "function" then
		local ok2, n2 = pcall(GetItemCount, id)
		if ok2 and n2 ~= nil then
			return tonumber(n2) or 0
		end
	end
	return 0
end

--------------------------------------------------------------------------------
-- Map GetProfessions() slot → current UI skill line + name + Enum.Profession
--------------------------------------------------------------------------------
local function MapProfessionSlotToSkillLine(prof)
	if not prof then
		return nil
	end

	if not C_TradeSkillUI or not C_TradeSkillUI.GetAllProfessionTradeSkillLines then
		return nil
	end

	local subName = select(11, GetProfessionInfo(prof))
	if not subName or subName == "" then
		return nil
	end

	local skillLines = C_TradeSkillUI.GetAllProfessionTradeSkillLines()
	for _, skillLineID in ipairs(skillLines) do
		local info = C_TradeSkillUI.GetProfessionInfoBySkillLineID(skillLineID)
		if
			info
			and info.professionName
			and (
				info.professionName == subName
				or NormalizeProfessionLabel(info.professionName) == NormalizeProfessionLabel(subName)
			)
		then
			local profEnum = info.profession
			local midnightLine = ResolveMidnightSkillLineID(skillLineID, profEnum)
			return skillLineID, midnightLine, info.professionName, profEnum
		end
	end

	return nil
end

-- Primary / secondary / archaeology / fishing / cooking / first aid (non-nil slots only).
local function GetLearnedProfessionEntries()
	local out = {}
	local p1, p2, archaeology, fishing, cooking, firstAid = GetProfessions()
	for _, prof in ipairs({ p1, p2, archaeology, fishing, cooking, firstAid }) do
		if prof then
			local scannedID, midnightLineID, name, profEnum = MapProfessionSlotToSkillLine(prof)
			if midnightLineID and name then
				table.insert(out, {
					scannedSkillLineID = scannedID,
					midnightSkillLineID = midnightLineID,
					name = name,
					professionEnum = profEnum,
				})
			end
		end
	end
	return out
end

-- First two values from GetProfessions() are the character's primary crafting professions.
local function GetPrimaryProfessionEntries()
	local out = {}
	local p1, p2 = GetProfessions()
	for _, prof in ipairs({ p1, p2 }) do
		if prof then
			local _, midnightLineID, name = MapProfessionSlotToSkillLine(prof)
			if name then
				table.insert(out, { name = name, midnightSkillLineID = midnightLineID })
			end
		end
	end
	return out
end

-- Primary profession tabs in UI order (deduped), for grouped tracker headers.
local function GetPrimaryProfessionDisplayOrder()
	local list = GetPrimaryProfessionEntries()
	local out = {}
	local seen = {}
	for _, L in ipairs(list) do
		local k = NormalizeProfessionLabel(L.name)
		if not seen[k] then
			seen[k] = true
			table.insert(out, { displayName = L.name, key = k })
		end
	end
	return out
end

--------------------------------------------------------------------------------
-- Dynamic unspent KP: C_ProfSpecs + C_Traits (no fixed currency ID table)
--------------------------------------------------------------------------------
local function ProfSpecsAPIReady()
	return C_ProfSpecs
		and C_ProfSpecs.GetConfigIDForSkillLine
		and C_ProfSpecs.GetSpecTabIDsForSkillLine
		and C_Traits
		and C_Traits.GetTreeCurrencyInfo
end

-- Unspent KP from C_Traits.GetTreeCurrencyInfo on the first spec tree for the Midnight skill line.
-- Returns: quantity, hasSpec (true when config + at least one tree exist).
local function GetMidnightUnspentKnowledge(midnightSkillLineID)
	if not midnightSkillLineID or not ProfSpecsAPIReady() then
		return 0, false
	end

	local configID = C_ProfSpecs.GetConfigIDForSkillLine(midnightSkillLineID)
	local treeIDs = C_ProfSpecs.GetSpecTabIDsForSkillLine(midnightSkillLineID)
	if not configID or not treeIDs or #treeIDs == 0 then
		return 0, false
	end

	local treeID = treeIDs[1]
	local unspentKP = 0

	-- Third argument varies by client; try both and prefer a positive quantity when ambiguous.
	for _, includeFlag in ipairs({ true, false }) do
		local currencyInfo = C_Traits.GetTreeCurrencyInfo(configID, treeID, includeFlag)
		if currencyInfo and currencyInfo[1] and currencyInfo[1].quantity then
			local q = currencyInfo[1].quantity
			if q > unspentKP then
				unspentKP = q
			end
		end
	end

	return unspentKP, true
end

--------------------------------------------------------------------------------
-- Tracker row icons: quest completion is the only source of truth for the glyph
--------------------------------------------------------------------------------
local ICON_COMPLETED = "|TInterface\\RaidFrame\\ReadyCheck-Ready:12:12:0:0|t "
local ICON_MISSING = "|TInterface\\RaidFrame\\ReadyCheck-NotReady:12:12:0:0|t "

local function ReleaseTrackerRowFrames(host)
	while true do
		local child = select(1, host:GetChildren())
		if not child then
			break
		end
		child:SetParent(nil)
		child:Hide()
	end
end

-- Clear all TomTom pins then set one (uses Delves Travel Assistant when cross-zone).
local function ClearTomTomAndAddSingleWaypoint(row)
	if not row or C_QuestLog.IsQuestFlaggedCompleted(row[1]) then
		return
	end
	if not _G.TomTom or type(_G.TomTom.ClearAllWaypoints) ~= "function" then
		print("Midnight Helper: TomTom not found!")
		return
	end
	pcall(function()
		_G.TomTom:ClearAllWaypoints()
	end)
	if not ns.AddSmartTomTomWay then
		print("|cffff5555Midnight Helper:|r Travel Assistant unavailable (Delves module not loaded).")
		return
	end
	ns.AddSmartTomTomWay(row[2], row[3], row[4], row[5])
end

-- TomTom bulk generate: sort by distance when player map position is available.
local FAR_CROSSMAP_SORT = 1e9

local function GetPlayerMapPositionForWaypoints()
	if not C_Map or not C_Map.GetBestMapForUnit or not C_Map.GetPlayerMapPosition then
		return nil, nil, nil
	end
	local okMap, mapID = pcall(C_Map.GetBestMapForUnit, "player")
	if not okMap or not mapID or mapID == 0 then
		return nil, nil, nil
	end
	local okPos, pos = pcall(C_Map.GetPlayerMapPosition, mapID)
	if not okPos or not pos then
		return nil, nil, nil
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
		return nil, nil, nil
	end
	return mapID, px, py
end

--------------------------------------------------------------------------------
local frame
local kpSummary
local trackerScroll
local trackerContent
local leftColumn
local rightColumn

local TRACKER_ROW_HEIGHT = 22
local TRACKER_HEADER_BLOCK = 24
local TRACKER_SECTION_HEADER_HEIGHT = 26
local TRACKER_INTER_COL_GAP = 12
local COLOR_HDR_MPT = "|cff00ff00" -- single-line "=== Profession (x/y) ==="
local COLOR_KP_NAME = "|cffccffcc"
local COLOR_KP_NEUTRAL = "|cffaaaaaa"
local COLOR_KP_HIGHLIGHT = "|cffffcc00"

local function UpdateKnowledgeSummary()
	if not kpSummary then
		return
	end

	local lines = {}
	if ProfSpecsAPIReady() then
		local p1, p2 = GetProfessions()
		for _, prof in ipairs({ p1, p2 }) do
			if prof then
				local _, mid, name, profEnum = MapProfessionSlotToSkillLine(prof)
				local lineID = mid
				if profEnum and MIDNIGHT_SKILL_LINE_BY_PROFESSION_ENUM[profEnum] then
					lineID = MIDNIGHT_SKILL_LINE_BY_PROFESSION_ENUM[profEnum]
				end
				if name and lineID then
					local u, ok = GetMidnightUnspentKnowledge(lineID)
					if ok then
						local numColor = (u and u > 0) and COLOR_KP_HIGHLIGHT or COLOR_KP_NEUTRAL
						table.insert(
							lines,
							string.format(
								"%s%s|r  %s%d|r  unspent",
								COLOR_KP_NAME,
								name,
								numColor,
								u or 0
							)
						)
					else
						table.insert(lines, string.format("%s%s|r  |cff888888--|r", COLOR_KP_NAME, name))
					end
				end
			end
		end
		if #lines == 0 then
			table.insert(lines, "|cffff8888No primary professions.|r")
		end
	else
		table.insert(lines, "|cffff8888Unspent KP: C_ProfSpecs / C_Traits unavailable.|r")
	end

	local currencyLines = {}
	local abundID = Config.UNALLOYED_ABUNDANCE_CURRENCY_CODE
	if abundID and C_CurrencyInfo and C_CurrencyInfo.GetCurrencyInfo then
		local q = GetCurrencyQuantity(abundID)
		local nm = GetCurrencyDisplayName(abundID) or "Unalloyed Abundance"
		table.insert(currencyLines, string.format("|cffccffcc%s|r  |cffffffff%d|r", nm, q))
	end
	local moxTable = Config.ARTISANS_MOXIE_CURRENCY_CODES
	if moxTable and C_CurrencyInfo and C_CurrencyInfo.GetCurrencyInfo then
		local p1, p2 = GetProfessions()
		for _, prof in ipairs({ p1, p2 }) do
			if prof then
				local _, _, name, profEnum = MapProfessionSlotToSkillLine(prof)
				if profEnum and moxTable[profEnum] then
					local mid = moxTable[profEnum]
					local mq = GetCurrencyQuantity(mid)
					local mm = GetCurrencyDisplayName(mid) or ("Artisan's Moxie (" .. tostring(name or "?") .. ")")
					table.insert(currencyLines, string.format("|cffccffcc%s|r  |cffffffff%d|r", mm, mq))
				end
			end
		end
	end

	local shardItemId = Config.SHARD_OF_DUNDUN_ITEM_ID
	if shardItemId then
		local dq = GetItemQuantityByID(shardItemId)
		table.insert(
			currencyLines,
			string.format("|cffccffccShards of Dundun:|r  %d / 8 earned this week.", dq)
		)
	end

	local blocks = {}
	if #lines > 0 then
		table.insert(blocks, table.concat(lines, "\n"))
	end
	if #currencyLines > 0 then
		table.insert(blocks, table.concat(currencyLines, "\n"))
	end
	if #blocks == 0 then
		kpSummary:SetText("|cffff8888No profession data.|r")
	else
		kpSummary:SetText(table.concat(blocks, "\n\n"))
	end

end

-- Same grouping as TomTom "Books" filter (Book pins + Echo of Abundance).
local function ProfessionTrackerRowIsBook(titleStr)
	local n = tostring(titleStr or "")
	return n:find("Book", 1, true) ~= nil or n:find("Echo of Abundance", 1, true) ~= nil
end

-- One profession column: green header at top, then treasure rows (right-click = TomTom).
local function PopulateProfessionColumn(host, cat, primary, colW)
	if not host or not cat then
		return 0
	end

	local rows = {}
	for _, row in ipairs(MIDNIGHT_DATA) do
		if NormalizeProfessionLabel(row[6]) == cat.key and PrimaryProfessionMatchesDataColumn(row[6], primary) then
			table.insert(rows, row)
		end
	end

	local total = #rows
	local doneCt = 0
	for _, r in ipairs(rows) do
		if C_QuestLog.IsQuestFlaggedCompleted(r[1]) then
			doneCt = doneCt + 1
		end
	end

	local y = 0
	local hf = CreateFrame("Frame", nil, host)
	hf:SetSize(colW, TRACKER_HEADER_BLOCK)
	hf:SetPoint("TOPLEFT", host, "TOPLEFT", 0, -y)

	local h1 = hf:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	h1:SetPoint("TOPLEFT", 2, -2)
	h1:SetWidth(colW - 4)
	h1:SetJustifyH("LEFT")
	h1:SetWordWrap(false)
	h1:SetText(string.format("%s=== %s (%d/%d) ===|r", COLOR_HDR_MPT, cat.displayName, doneCt, total))

	y = y + TRACKER_HEADER_BLOCK

	local treasureRows, bookRows = {}, {}
	for _, row in ipairs(rows) do
		if ProfessionTrackerRowIsBook(row[5]) then
			table.insert(bookRows, row)
		else
			table.insert(treasureRows, row)
		end
	end

	local stripeIndex = 0

	local function MountSectionHeader(titleText)
		local hdr = CreateFrame("Frame", nil, host)
		hdr:SetSize(colW, TRACKER_SECTION_HEADER_HEIGHT)
		hdr:SetPoint("TOPLEFT", host, "TOPLEFT", 0, -y)
		local lbl = hdr:CreateFontString(nil, "OVERLAY", "GameFontHighlightMedium")
		lbl:SetPoint("TOP", hdr, "TOP", 0, -4)
		lbl:SetWidth(colW - 8)
		lbl:SetJustifyH("CENTER")
		lbl:SetText(titleText)
		lbl:SetTextColor(0.95, 0.88, 0.65)
		local line = hdr:CreateTexture(nil, "ARTWORK")
		line:SetHeight(1)
		line:SetPoint("BOTTOMLEFT", hdr, "BOTTOMLEFT", 6, 5)
		line:SetPoint("BOTTOMRIGHT", hdr, "BOTTOMRIGHT", -6, 5)
		line:SetColorTexture(0.55, 0.48, 0.28, 0.85)
		y = y + TRACKER_SECTION_HEADER_HEIGHT
	end

	local function AddTrackerDataRow(row)
		stripeIndex = stripeIndex + 1
		local questID, _, px, py, title = row[1], row[2], row[3], row[4], row[5]
		local done = C_QuestLog.IsQuestFlaggedCompleted(questID)
		local icon = done and ICON_COMPLETED or ICON_MISSING
		local coordStr = string.format("%.1f, %.1f", tonumber(px) or 0, tonumber(py) or 0)

		local btn = CreateFrame("Button", nil, host)
		btn:SetSize(colW, TRACKER_ROW_HEIGHT)
		btn:SetPoint("TOPLEFT", host, "TOPLEFT", 0, -y)
		btn:EnableMouse(true)
		btn:RegisterForClicks("LeftButtonUp", "RightButtonDown")
		btn:SetHighlightTexture("Interface/QuestFrame/UI-QuestTitleHighlight", "ADD")
		btn.mhRowData = row

		local zebra = btn:CreateTexture(nil, "BACKGROUND")
		zebra:SetAllPoints()
		if stripeIndex % 2 == 0 then
			zebra:SetColorTexture(0.10, 0.10, 0.13, 0.55)
		else
			zebra:SetColorTexture(0.045, 0.045, 0.06, 0.28)
		end

		btn:SetScript("OnEnter", function(self)
			local rd = self.mhRowData
			if not rd then
				return
			end
			GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
			GameTooltip:ClearLines()
			local rowTitle = rd[5] or "Treasure"
			GameTooltip:AddLine(rowTitle, 1, 0.82, 0, true)
			local cost = rd[7]
			if
				type(rowTitle) == "string"
				and rowTitle:find("Echo", 1, true)
				and not (cost and type(cost) == "table" and #cost >= 4)
			then
				GameTooltip:AddLine(
					"Requires: 1600 Unalloyed Abundance + 75 Artisan's Moxie (Echo pin)",
					0.82,
					0.82,
					0.78,
					true
				)
			end
			if cost and type(cost) == "table" and #cost >= 4 then
				local needA, _, needM = tonumber(cost[1]) or 0, cost[2], tonumber(cost[3]) or 0
				local abundID = Config.UNALLOYED_ABUNDANCE_CURRENCY_CODE
				local profEnum = ProfessionLabelToEnum(rd[6])
				local moxieID = profEnum and Config.ARTISANS_MOXIE_CURRENCY_CODES and Config.ARTISANS_MOXIE_CURRENCY_CODES[profEnum]
				local haveA = GetCurrencyQuantity(abundID)
				local nameA = GetCurrencyDisplayName(abundID) or "Unalloyed Abundance"
				local okA = haveA >= needA
				GameTooltip:AddLine(
					string.format("%s: %d / %d", nameA, haveA, needA),
					okA and 0 or 1,
					okA and 1 or 0.12,
					okA and 0 or 0.12,
					false
				)
				if moxieID then
					local haveM = GetCurrencyQuantity(moxieID)
					local nameM = GetCurrencyDisplayName(moxieID) or "Artisan's Moxie"
					local okM = haveM >= needM
					GameTooltip:AddLine(
						string.format("%s: %d / %d", nameM, haveM, needM),
						okM and 0 or 1,
						okM and 1 or 0.12,
						okM and 0 or 0.12,
						false
					)
				else
					GameTooltip:AddLine("Artisan's Moxie: unknown currency for this profession.", 0.53, 0.53, 0.53, true)
				end
			else
				GameTooltip:AddLine(
					"|cffaaaaaaClick row: TomTom this pin only (clears other waypoints).|r",
					0.75,
					0.75,
					0.75,
					true
				)
			end
			GameTooltip:Show()
		end)
		btn:SetScript("OnLeave", function()
			GameTooltip:Hide()
		end)

		btn:SetScript("OnMouseDown", function(self, button)
			if button ~= "RightButton" then
				return
			end
			ClearTomTomAndAddSingleWaypoint(self.mhRowData)
		end)

		btn:SetScript("OnClick", function(self, button)
			if button == "LeftButton" then
				ClearTomTomAndAddSingleWaypoint(self.mhRowData)
			end
		end)

		local nameFs = btn:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
		nameFs:SetPoint("TOPLEFT", 6, -4)
		nameFs:SetPoint("TOPRIGHT", btn, "TOPRIGHT", -78, -4)
		nameFs:SetJustifyH("LEFT")
		nameFs:SetWordWrap(false)
		nameFs:SetText(icon .. (title or "?"))

		local coordFs = btn:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
		coordFs:SetPoint("TOPRIGHT", btn, "TOPRIGHT", -6, -4)
		coordFs:SetWidth(72)
		coordFs:SetJustifyH("RIGHT")
		coordFs:SetWordWrap(false)
		coordFs:SetText(coordStr)

		if done then
			nameFs:SetTextColor(0.5, 0.5, 0.5)
			coordFs:SetTextColor(0.5, 0.5, 0.5)
		else
			nameFs:SetTextColor(1, 1, 1)
			coordFs:SetTextColor(1, 0.82, 0)
		end

		y = y + TRACKER_ROW_HEIGHT
	end

	if #treasureRows > 0 then
		MountSectionHeader("Treasures")
		for _, row in ipairs(treasureRows) do
			AddTrackerDataRow(row)
		end
	end
	if #bookRows > 0 then
		MountSectionHeader("Books")
		for _, row in ipairs(bookRows) do
			AddTrackerDataRow(row)
		end
	end

	return y + 8
end

-- Builds the treasure list from MIDNIGHT_DATA into two columns (primary #1 left, #2 right).
local function UpdateProfessionTracker()
	if not trackerContent or not trackerScroll or not leftColumn or not rightColumn then
		return
	end

	ReleaseTrackerRowFrames(leftColumn)
	ReleaseTrackerRowFrames(rightColumn)

	local primary = GetPrimaryProfessionEntries()
	local scrollW = trackerScroll:GetWidth()
	if not scrollW or scrollW < 60 then
		local fw = frame and frame:GetWidth() or 800
		scrollW = math.max(240, fw - 36)
	end
	-- ScrollFrame inner width minus vertical scrollbar (~18–24px) from UIPanelScrollFrameTemplate.
	local w = math.max(240, scrollW - 24)
	local gap = TRACKER_INTER_COL_GAP
	local colW = (w - gap) / 2

	trackerContent:SetWidth(w)
	leftColumn:ClearAllPoints()
	rightColumn:ClearAllPoints()
	leftColumn:SetWidth(colW)
	rightColumn:SetWidth(colW)
	leftColumn:SetPoint("TOPLEFT", trackerContent, "TOPLEFT", 0, 0)
	rightColumn:SetPoint("TOPLEFT", leftColumn, "TOPRIGHT", gap, 0)
	leftColumn:EnableMouse(false)
	rightColumn:EnableMouse(false)

	local orderList = GetPrimaryProfessionDisplayOrder()
	local hL = 0
	local hR = 0
	if orderList[1] then
		hL = PopulateProfessionColumn(leftColumn, orderList[1], primary, colW)
	end
	if orderList[2] then
		hR = PopulateProfessionColumn(rightColumn, orderList[2], primary, colW)
	end

	leftColumn:SetHeight(math.max(hL, 1))
	rightColumn:SetHeight(math.max(hR, 1))
	leftColumn:Show()
	rightColumn:Show()
	trackerContent:SetHeight(math.max(24, hL, hR))

	-- Debug: no MIDNIGHT_DATA rows matched the player's primaries
	local matchedRows = 0
	for _, row in ipairs(MIDNIGHT_DATA) do
		if PrimaryProfessionMatchesDataColumn(row[6], primary) then
			matchedRows = matchedRows + 1
		end
	end
	if matchedRows == 0 then
		for _, L in ipairs(primary) do
			print("Debug: Found profession " .. tostring(L.name))
		end
		if #primary == 0 then
			print("Debug: Found profession (none)")
		end
	end
end

local function RefreshProfessionPanel()
	UpdateKnowledgeSummary()
	UpdateProfessionTracker()
end

--------------------------------------------------------------------------------
local eventFrame

local function CreateOrUpdateEventBridge()
	if eventFrame then
		return
	end

	eventFrame = CreateFrame("Frame", nil, UIParent)
	eventFrame:Hide()

	eventFrame:RegisterEvent("TRADE_SKILL_SHOW")
	eventFrame:RegisterEvent("TRADE_SKILL_LIST_UPDATE")
	eventFrame:RegisterEvent("TRAIT_TREE_CURRENCY_INFO_UPDATED")
	eventFrame:RegisterEvent("TRAIT_CONFIG_UPDATED")
	eventFrame:RegisterEvent("CURRENCY_DISPLAY_UPDATE")
	eventFrame:RegisterEvent("SKILL_LINES_CHANGED")
	eventFrame:RegisterEvent("QUEST_LOG_UPDATE")
	eventFrame:RegisterEvent("QUEST_WATCH_UPDATE")
	eventFrame:RegisterEvent("BAG_UPDATE")

	eventFrame:SetScript("OnEvent", function()
		if frame and frame:IsVisible() then
			RefreshProfessionPanel()
		end
	end)
end

--------------------------------------------------------------------------------
local function SetupProfessionModule()
	if frame then
		return
	end

	local panel = ns.panels and ns.panels.professions
	if not panel then
		return
	end

	if panel._body then
		panel._body:Hide()
	end
	-- Tab already reads "Professions"; hide shell header so it does not stack above this frame.
	if panel._header then
		panel._header:Hide()
	end

	frame = CreateFrame("Frame", "MidnightHelperProfessionFrame", panel)
	frame:SetAllPoints(panel)

	local title = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlightLarge")
	title:SetPoint("TOPLEFT", 16, -14)
	title:SetText("Profession Treasures and Books")

	kpSummary = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	kpSummary:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -8)
	kpSummary:SetPoint("RIGHT", frame, "RIGHT", -20, 0)
	kpSummary:SetJustifyH("LEFT")
	kpSummary:SetWordWrap(true)
	kpSummary:SetSpacing(2)
	kpSummary:SetText("Loading...")

	trackerScroll = CreateFrame("ScrollFrame", "MidnightHelperProfessionTrackerScroll", frame, "UIPanelScrollFrameTemplate")
	trackerScroll:SetFrameLevel((frame:GetFrameLevel() or 0) + 1)

	local function RowNameIsTreasurePin(nameStr)
		local n = tostring(nameStr or "")
		if n:find("Book", 1, true) then
			return false
		end
		if n:find("Echo of Abundance", 1, true) then
			return false
		end
		return true
	end

	local function RowNameIsBookPin(nameStr)
		local n = tostring(nameStr or "")
		return n:find("Book", 1, true) ~= nil or n:find("Echo of Abundance", 1, true) ~= nil
	end

	local function RunTomTomGenerate(nameFilter, kindLabel)
		if not _G.TomTom or type(_G.TomTom.ClearAllWaypoints) ~= "function" then
			print("Midnight Helper: TomTom not found!")
			return
		end
		if not ns.AddSmartTomTomWay then
			print("|cffff5555Midnight Helper:|r Travel Assistant unavailable (Delves module not loaded).")
			return
		end

		pcall(function()
			_G.TomTom:ClearAllWaypoints()
		end)

		local primaryProfessions = GetPrimaryProfessionEntries()
		local pMap, pX, pY = GetPlayerMapPositionForWaypoints()
		local nearestFirst = pMap ~= nil and pX ~= nil and pY ~= nil

		local toAdd = {}
		for idx, row in ipairs(MIDNIGHT_DATA) do
			local questID, mapID, x, yCoord, name, profession = row[1], row[2], row[3], row[4], row[5], row[6]
			if
				nameFilter(name)
				and not C_QuestLog.IsQuestFlaggedCompleted(questID)
				and PrimaryProfessionMatchesDataColumn(profession, primaryProfessions)
			then
				local sortDist = idx
				if nearestFirst then
					local tMap = tonumber(mapID)
					if tMap and tMap == pMap then
						local tx = (tonumber(x) or 0) / 100
						local ty = (tonumber(yCoord) or 0) / 100
						local dx = tx - pX
						local dy = ty - pY
						sortDist = math.sqrt(dx * dx + dy * dy)
					else
						sortDist = FAR_CROSSMAP_SORT + idx
					end
				end
				table.insert(toAdd, { row = row, sortDist = sortDist, idx = idx })
			end
		end

		if nearestFirst and #toAdd > 1 then
			table.sort(toAdd, function(a, b)
				if a.sortDist ~= b.sortDist then
					return a.sortDist < b.sortDist
				end
				return a.idx < b.idx
			end)
		end

		local added = 0
		local eligible = #toAdd
		local nPins = #toAdd
		for i, entry in ipairs(toAdd) do
			local row = entry.row
			local mapID, x, yCoord, name = row[2], row[3], row[4], row[5]
			local skipTravelUI = i < nPins
			if ns.AddSmartTomTomWay(mapID, x, yCoord, name, skipTravelUI) then
				added = added + 1
			end
		end

		local orderHint = nearestFirst and "Order: Nearest First." or "Order: default table order (player position unavailable)."
		print(
			string.format(
				"|cffffff78Midnight Helper:|r Generate %s: %d waypoint(s) added to TomTom (%d eligible incomplete pins). %s",
				kindLabel,
				added,
				eligible,
				orderHint
			)
		)
	end

	local WAYPOINT_BTN_HEIGHT = 26
	local WAYPOINT_BTN_BOTTOM_INSET = 14
	local SCROLL_GAP_ABOVE_WAYPOINT_BTNS = 10

	local waypointBtn = CreateFrame("Button", "MidnightHelperProfessionTreasuresWaypointBtn", frame, "UIPanelButtonTemplate")
	waypointBtn:SetSize(180, WAYPOINT_BTN_HEIGHT)
	waypointBtn:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", 16, WAYPOINT_BTN_BOTTOM_INSET)
	waypointBtn:SetText("Generate Treasures")
	waypointBtn:SetFrameLevel((frame:GetFrameLevel() or 0) + 50)
	waypointBtn:RegisterForClicks("LeftButtonUp")

	local booksBtn = CreateFrame("Button", "MidnightHelperProfessionBooksWaypointBtn", frame, "UIPanelButtonTemplate")
	booksBtn:SetSize(180, WAYPOINT_BTN_HEIGHT)
	booksBtn:SetPoint("LEFT", waypointBtn, "RIGHT", 8, 0)
	booksBtn:SetPoint("BOTTOM", frame, "BOTTOM", 0, WAYPOINT_BTN_BOTTOM_INSET)
	booksBtn:SetText("Generate Books")
	booksBtn:SetFrameLevel((frame:GetFrameLevel() or 0) + 50)
	booksBtn:RegisterForClicks("LeftButtonUp")

	trackerScroll:SetPoint("TOPLEFT", kpSummary, "BOTTOMLEFT", -8, -14)
	trackerScroll:SetPoint("TOPRIGHT", kpSummary, "BOTTOMRIGHT", 8, -14)
	trackerScroll:SetPoint("BOTTOMLEFT", waypointBtn, "TOPLEFT", -8, SCROLL_GAP_ABOVE_WAYPOINT_BTNS)

	trackerContent = CreateFrame("Frame", nil, trackerScroll)
	trackerContent:SetSize(100, 100)
	trackerScroll:SetScrollChild(trackerContent)

	leftColumn = CreateFrame("Frame", "MidnightHelperLeftColumn", trackerContent)
	rightColumn = CreateFrame("Frame", "MidnightHelperRightColumn", trackerContent)
	leftColumn:EnableMouse(false)
	rightColumn:EnableMouse(false)

	waypointBtn:SetScript("OnClick", function()
		RunTomTomGenerate(RowNameIsTreasurePin, "Treasures")
	end)

	booksBtn:SetScript("OnClick", function()
		RunTomTomGenerate(RowNameIsBookPin, "Books")
	end)

	frame:SetScript("OnShow", function()
		RefreshProfessionPanel()
	end)

	trackerScroll:SetScript("OnSizeChanged", function()
		if frame:IsVisible() then
			UpdateProfessionTracker()
		end
	end)

	CreateOrUpdateEventBridge()

	ns.ProfessionFrame = frame

	RefreshProfessionPanel()
end

local function HookEnsureMainUI()
	if ns._mhProfessionEnsureHooked then
		return
	end
	ns._mhProfessionEnsureHooked = true

	local orig = ns.EnsureMainUI
	function ns:EnsureMainUI(...)
		local main = orig(self, ...)
		SetupProfessionModule()
		return main
	end
end

HookEnsureMainUI()
