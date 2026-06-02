--[[
	Midnight Helper — Delve Coach boss 3D previews (PlayerModel + creature IDs).
	IDs from Wowhead nether tooltip API / Icy Veins–linked NPC pages.
]]

local _, ns = ...

---@class MHDelveBossFrame
---@field cam number|nil
---@field x number|nil
---@field y number|nil
---@field z number|nil
---@field facing number|nil
---@field portraitZoom number|nil

---@class MHDelveBossVisual
---@field creatureId number
---@field label string
---@field displayId number|nil -- CreatureDisplayInfo id when SetCreature is unreliable
---@field storyKeys string[]|nil
---@field storyHints string[]|nil
---@field storySpellIds number[]|nil
---@field storyQuestIds number[]|nil
---@field storyCriteriaIds number[]|nil
---@field tipLineMatch string[]|nil
---@field cam number|nil
---@field x number|nil
---@field y number|nil
---@field z number|nil
---@field facing number|nil
---@field portraitZoom number|nil

-- SetCamDistanceScale: higher = camera further = smaller on screen (more body visible).
-- Tuned from in-game Delve Coach screenshots (May 2026).
local DEFAULT_BOSS_FRAME = {
	cam = 1.0,
	x = 0,
	y = 0,
	z = 0,
	facing = 0.32,
	portraitZoom = 0,
}

local BOSS_CAM_MIN = 0.45
local BOSS_CAM_MAX = 2.0
local BOSS_CAM_WHEEL_STEP = 0.07
local MODEL_RETRY_DELAYS = { 0, 0.12, 0.3, 0.6, 1.0, 1.8, 3.0 }

local function GetDelveCoachSettings()
	local s = ns.db and ns.db.ui and ns.db.ui.delveCoach
	return type(s) == "table" and s or nil
end

function ns:GetDelveBossCamOverride(creatureId)
	local s = GetDelveCoachSettings()
	if not s or type(s.bossCam) ~= "table" then
		return nil
	end
	creatureId = tonumber(creatureId)
	if not creatureId then
		return nil
	end
	local cam = tonumber(s.bossCam[creatureId]) or tonumber(s.bossCam[tostring(creatureId)])
	if not cam then
		return nil
	end
	return math.max(BOSS_CAM_MIN, math.min(BOSS_CAM_MAX, cam))
end

function ns:SetDelveBossCamOverride(creatureId, cam)
	local s = GetDelveCoachSettings()
	if not s then
		return
	end
	creatureId = tonumber(creatureId)
	cam = tonumber(cam)
	if not creatureId or not cam then
		return
	end
	if type(s.bossCam) ~= "table" then
		s.bossCam = {}
	end
	s.bossCam[creatureId] = math.max(BOSS_CAM_MIN, math.min(BOSS_CAM_MAX, cam))
end

--- Scroll up = zoom in (model larger); scroll down = zoom out.
function ns:AdjustDelveBossCam(model, creatureId, bossEntry, wheelDelta)
	if not model or not creatureId or not wheelDelta or wheelDelta == 0 then
		return
	end
	creatureId = tonumber(creatureId)
	if not creatureId then
		return
	end
	local frame = self:GetDelveBossFrame(creatureId, bossEntry)
	local cam = tonumber(frame.cam) or DEFAULT_BOSS_FRAME.cam
	if wheelDelta > 0 then
		cam = cam - BOSS_CAM_WHEEL_STEP
	else
		cam = cam + BOSS_CAM_WHEEL_STEP
	end
	self:SetDelveBossCamOverride(creatureId, cam)
	frame.cam = self:GetDelveBossCamOverride(creatureId) or cam
	self:ApplyDelveBossFrameSettings(model, frame)
	return frame.cam
end

--- Per-creature camera tweaks.
local CREATURE_FRAMES = {
	[246621] = { cam = 1.05 },
	[246680] = { cam = 0.86 }, -- Lumenia: too small
	[247114] = { cam = 1.38, z = -0.04 }, -- Jin'Ma: torso close-up
	[247910] = { cam = 1.22, z = -0.10, y = -0.03 }, -- Gyrospore: dark, cap clipped
	[247397] = { cam = 1.28, z = -0.10 }, -- Brightthorn
	[247526] = { cam = 1.18, z = -0.08 }, -- Mycomight
	[248257] = { cam = 1.18, z = -0.08 }, -- legacy placeholder
	[248320] = { cam = 1.28, z = -0.10 }, -- Unstoppable Thornmaw (event mob)
	[250939] = { cam = 1.42, z = -0.08 }, -- Mul'tha'ul: shoulders only
	[251032] = { cam = 0.86, z = -0.02 }, -- Darza: too small / dark
	[252352] = { cam = 1.05 },
	[254772] = { cam = 1.15, z = -0.06, y = -0.02 }, -- Hydrangea
	[254769] = { cam = 1.32 }, -- Garand: torso close-up
	[254773] = { cam = 1.08 }, -- Voidscorned Vagrant
	[255108] = { cam = 0.98 },
	[256683] = { cam = 0.96 },
	[251600] = { cam = 1.35 }, -- Infiltrator Gulkat: torso close-up
	[256817] = { cam = 1.35 }, -- legacy wrong id; keep cam override if saved
	[248676] = { cam = 0.88 }, -- Patram: too small
}

---@type table<string, MHDelveBossVisual[]>
ns.DELVE_BOSS_SHOWCASE = {
	shadow_enclave = {
		{ creatureId = 252352, label = "Lord Antenorian" },
	},
	collegiate_calamity = {
		{ creatureId = 254773, label = "Voidscorned Vagrant", storyKeys = {
			"Academy Under Siege", "Akademie unter Belagerung", "Académie assiégée",
			"Academia bajo asedio", "Academia sob cerco",
		}, tipLineMatch = { "Voidscorned", "Vagrant", "Under Siege", "unter Belagerung", "assiégée", "asedio", "sob cerco", "Belagerung" },
			storyHints = { "arcane ward", "void portal", "devouring host", "student project" } },
		{ creatureId = 254769, label = "Infiltrator Garand", storyKeys = {
			"Faculty of Fear", "Fakultät der Angst", "Faculté de la Peur",
			"Facultad del Miedo", "Faculdade do Medo",
		}, tipLineMatch = { "Garand", "Faculty of Fear", "Faculty", "Fakultät", "Faculté", "Facultad", "Faculdade", "Peur", "Miedo", "Angst" },
			storyHints = { "eye of revelation", "infiltrator", "disguised", "suspicious student" } },
		{ creatureId = 254772, label = "Hydrangea", storyKeys = {
			"Invasive Glow", "Invasive Growth", "Invasives Leuchten", "Lueur envahissante",
			"Resplandor invasivo", "Brilho Invasivo",
		}, storySpellIds = { 1253664 }, tipLineMatch = { "Hydrangea", "Hortensie", "Hortensia", "Hortênsia", "Invasive Glow", "Invasives Leuchten", "Lueur envahissante", "Resplandor invasivo", "Brilho Invasivo" },
			storyHints = { "deweeder", "luminibulb", "weedling", "glaring glowcap" } },
	},
	the_darkway = {
		-- 256817 = live delve showcase (CF); 251600 = Wowhead NPC fallback.
		{ creatureId = 256817, label = "Infiltrator Gulkat", creatureIdFallback = { 251600 } },
	},
	parhelion_plaza = {
		{ creatureId = 246621, label = "Gladius Slaurna" },
	},
	atal_aman = {
		{ creatureId = 247114, label = "Spiritflayer Jin'Ma" },
	},
	twilight_crypts = {
		{ creatureId = 251032, label = "Blademaster Darza" },
	},
	gulf_of_memory = {
		{ creatureId = 246680, label = "Lumenia", storyKeys = { "Alnmoth Munchies", "Sporasaur Special" }, tipLineMatch = { "Lumenia", "Munchies", "Sporasaur", "Sporasaurier", "Sporassauro", "Larica" } },
		{ creatureId = 250939, label = "Mul'tha'ul", storyKeys = { "Descent of the Haranir" }, tipLineMatch = { "Mul'tha'ul", "Haranir", "Descent", "Abstammung", "Descida", "Descente" } },
	},
	grudge_pit = {
		{ creatureId = 247397, label = "Brightthorn", storyKeys = {
			"Lightbloom Invasion", "Arena-Stil-Invasion", "Invasion de Lightbloom", "Invasión de Lightbloom", "Invasão Lightbloom",
		}, tipLineMatch = { "Brightthorn", "Lightbloom Invasion", "Lightbloom" },
			storyHints = { "lightbloom invasion", "lightbloom attackers", "entangled", "barricade", "thornmaw", "unstoppable thornmaw", "entangled fighter" } },
		{ creatureId = 247910, label = "Gyrospore", storyKeys = {
			"Arena Champion", "Enter the arena", "Arena-Champion", "Champion de l'arène", "Campeón de la arena", "Campeão da Arena",
		}, tipLineMatch = { "Gyrospore", "Gyrospor", "Girospor", "Arena Champion", "Champion" },
			storyHints = { "arena champion", "enter the arena", "gyrospore", "moldrus", "bogdamp", "toxic twins", "sporbit" },
			storyCriteriaIds = { 106002 } },
		{ creatureId = 247526, label = "Mycomight", storyKeys = {
			"Dastardly Rotstalk", "Räudiger Rotstalk", "Rotstalk ignoble", "Retoño pútrido", "Rotstalk vil",
		}, tipLineMatch = { "Mycomight", "Rotstalk", "Dastardly" },
			storyHints = { "dastardly rotstalk", "rotstalk", "heel", "taunt", "fan favorite", "villainous" } },
	},
	sunkiller_sanctum = {
		{ creatureId = 256683, label = "Esuritus", storyKeys = { "Core of the Problem", "Gravitational Effect" } },
	},
	shadowguard_point = {
		{ creatureId = 248676, label = "Chief-Arcanist Patram" },
	},
	torments_rise = {
		{ creatureId = 255108, label = "Nullaeus" },
	},
}

function ns:GetDelveBossShowcase(entryId)
	if not entryId then
		return nil
	end
	return ns.DELVE_BOSS_SHOWCASE[entryId]
end

local function SplitTipLines(body)
	local lines = {}
	if type(body) ~= "string" or body == "" then
		return lines
	end
	local from = 1
	while from <= #body do
		local sepStart, sepEnd = body:find("|n", from, true)
		if not sepStart then
			lines[#lines + 1] = body:sub(from)
			break
		end
		lines[#lines + 1] = body:sub(from, sepStart - 1)
		from = sepEnd + 1
	end
	return lines
end

local function GetBossTipLineMatchers(boss)
	if not boss then
		return nil
	end
	if type(boss.tipLineMatch) == "table" and #boss.tipLineMatch > 0 then
		return boss.tipLineMatch
	end
	if type(boss.label) == "string" and boss.label ~= "" then
		local matchers = { boss.label }
		local short = boss.label:match("([^%s]+)$")
		if short and short ~= boss.label then
			matchers[#matchers + 1] = short
		end
		return matchers
	end
	return nil
end

--- Keep only route/trash/boss bullets that match the selected boss spotlight entry.
function ns.FilterDelveTipBodyForBoss(body, entryId, bossIndex)
	local bosses = ns.DELVE_BOSS_SHOWCASE and ns.DELVE_BOSS_SHOWCASE[entryId]
	if type(body) ~= "string" or type(bosses) ~= "table" or #bosses < 2 then
		return body
	end
	bossIndex = tonumber(bossIndex)
	local boss = bossIndex and bosses[bossIndex]
	if not boss then
		return body
	end
	local matchers = GetBossTipLineMatchers(boss)
	if not matchers then
		return body
	end
	local lines = SplitTipLines(body)
	if #lines == 0 then
		return body
	end
	local matched = {}
	for i = 1, #lines do
		local line = lines[i]
		local lower = line:lower()
		for j = 1, #matchers do
			local needle = matchers[j]
			if type(needle) == "string" and needle ~= "" and lower:find(needle:lower(), 1, true) then
				matched[#matched + 1] = line
				break
			end
		end
	end
	if #matched == 0 then
		return body
	end
	return table.concat(matched, "|n")
end

local function IsSecretValue(value)
	return issecretvalue ~= nil and value ~= nil and issecretvalue(value) == true
end

local function CanAccessText(value)
	if value == nil or IsSecretValue(value) then
		return false
	end
	if canaccessvalue and not canaccessvalue(value) then
		return false
	end
	return type(value) == "string"
end

local function GetUnitCreatureId(unit)
	if not unit or not UnitGUID then
		return nil
	end
	local ok, guid = pcall(UnitGUID, unit)
	if not ok or not CanAccessText(guid) then
		return nil
	end
	local id = select(6, strsplit("-", guid))
	return tonumber(id)
end

local function NormalizeStoryText(s)
	if not CanAccessText(s) then
		return ""
	end
	local ok, out = pcall(function()
		return s:lower():gsub("^%s+", ""):gsub("%s+$", "")
	end)
	return ok and out or ""
end

local function StoryMatches(storyName, keys)
	local story = NormalizeStoryText(storyName)
	if story == "" or type(keys) ~= "table" then
		return false
	end
	local sorted = {}
	for _, key in ipairs(keys) do
		sorted[#sorted + 1] = key
	end
	table.sort(sorted, function(a, b)
		return #a > #b
	end)
	for _, key in ipairs(sorted) do
		local needle = NormalizeStoryText(key)
		if needle ~= "" then
			if story == needle then
				return true
			end
			if #needle >= 10 and (story:find(needle, 1, true) or needle:find(story, 1, true)) then
				return true
			end
		end
	end
	return false
end

local function StripColorCodes(s)
	if not CanAccessText(s) then
		return ""
	end
	local ok, out = pcall(function()
		return s:gsub("|c%x%x%x%x%x%x%x%x", ""):gsub("|r", ""):gsub("|T.-|t", ""):gsub("^%s+", ""):gsub("%s+$", "")
	end)
	return ok and out or ""
end

local GENERIC_STORY_NAMES = {
	delves = true,
	delve = true,
	scenario = true,
	challenges = true,
	campaign = true,
	quests = true,
	collections = true,
	achievements = true,
	profession = true,
	search = true,
	["all objectives"] = true,
	["bonus objectives"] = true,
	["world quests"] = true,
	["traveler's log"] = true,
	endeavors = true,
	["collect your reward!"] = true,
}

local lastStoryDebugKey = ""
local lastStoryDebugAt = 0

local function ShouldDebugDelveStoryAny()
	return (ns.db and ns.db.ui and ns.db.ui.debug) and true or false
end

local function ShouldDebugDelveStory(entryId)
	if not ShouldDebugDelveStoryAny() then
		return false
	end
	if ns.IsDelveInstanceInProgress and not ns.IsDelveInstanceInProgress() then
		return false
	end
	return true
end

local function DebugDelveStoryOnce(entryId, message)
	if not ShouldDebugDelveStoryAny() then
		return
	end
	local key = tostring(entryId or "") .. "\31" .. message
	local now = GetTime and GetTime() or 0
	if key == lastStoryDebugKey and (now - lastStoryDebugAt) < 5 then
		return
	end
	lastStoryDebugKey = key
	lastStoryDebugAt = now
	if ns.PrintChat then
		ns:PrintChat(message)
	else
		print(("[MidnightHelper] %s"):format(message))
	end
end

local function IsGenericStoryName(name)
	local n = NormalizeStoryText(StripColorCodes(name))
	if n == "" or #n < 4 then
		return true
	end
	if GENERIC_STORY_NAMES[n] then
		return true
	end
	if n:find("^tier%s*%d") or n:match("^%d+/%d+") then
		return true
	end
	if n:match("^wave:%s*") or n:match("^%d+%s*%%$") then
		return true
	end
	if n:find("^delver's call:") or n:find("^delver's call") then
		return true
	end
	if n:find("^speak with ") or n:find(" defeated$") then
		return true
	end
	if n == "unknown" then
		return true
	end
	if type(ns.DELVE_TIP_ENTRIES) == "table" then
		for _, entry in ipairs(ns.DELVE_TIP_ENTRIES) do
			if entry.rosterName and NormalizeStoryText(entry.rosterName) == n then
				return true
			end
			if entry.nameKey and ns.L then
				local localized = ns:L(entry.nameKey)
				if type(localized) == "string" and localized ~= entry.nameKey and NormalizeStoryText(localized) == n then
					return true
				end
			end
		end
	end
	if #n > 96 then
		return true
	end
	return false
end

local activeDelveStorySnapshot = {}

local function StoreDelveStorySnapshot(entryId, storyName, bossEntry, bossIndex)
	if not entryId or not bossIndex then
		return
	end
	activeDelveStorySnapshot[entryId] = {
		storyName = storyName,
		bossIndex = bossIndex,
		bossLabel = bossEntry and bossEntry.label or nil,
	}
end

local function MatchBossFromHintText(text, bosses)
	if not CanAccessText(text) or type(bosses) ~= "table" then
		return nil, nil, nil
	end
	local lower = NormalizeStoryText(StripColorCodes(text))
	if lower == "" then
		return nil, nil, nil
	end
	local bestBoss, bestIdx, bestScore = nil, nil, 0
	for i, boss in ipairs(bosses) do
		if type(boss.storyHints) == "table" then
			local score = 0
			for _, hint in ipairs(boss.storyHints) do
				local needle = NormalizeStoryText(hint)
				if needle ~= "" and #needle >= 4 and lower:find(needle, 1, true) then
					score = score + #needle
				end
			end
			if score > bestScore then
				bestScore = score
				bestBoss = boss
				bestIdx = i
			end
		end
	end
	if bestScore >= 6 then
		return text, bestBoss, bestIdx
	end
	return nil, nil, nil
end

local function MatchBossFromNumericSignals(bosses, signals)
	if type(bosses) ~= "table" or type(signals) ~= "table" then
		return nil, nil
	end
	local function hasId(list, id)
		id = tonumber(id)
		if not id then
			return false
		end
		if type(list) ~= "table" then
			return false
		end
		for _, v in ipairs(list) do
			if v == id then
				return true
			end
		end
		return false
	end
	for i, boss in ipairs(bosses) do
		if type(boss.storySpellIds) == "table" then
			for _, sid in ipairs(boss.storySpellIds) do
				if hasId(signals.spellIDs, sid) then
					return boss, i
				end
			end
		end
		if type(boss.storyQuestIds) == "table" then
			for _, qid in ipairs(boss.storyQuestIds) do
				if hasId(signals.rewardQuestIDs, qid) then
					return boss, i
				end
			end
		end
		if type(boss.storyCriteriaIds) == "table" then
			for _, cid in ipairs(boss.storyCriteriaIds) do
				if hasId(signals.criteriaIDs, cid) then
					return boss, i
				end
			end
		end
	end
	return nil, nil
end

local function GetTipEntryPoiContext(entryId)
	local entry = ns.GetDelveTipEntryById and ns.GetDelveTipEntryById(entryId)
	if not entry or not entry.poiId then
		return nil, nil
	end
	local mapIds = {}
	local seenMap = {}
	local function addMap(mapId)
		mapId = tonumber(mapId)
		if mapId and mapId > 0 and not seenMap[mapId] then
			seenMap[mapId] = true
			mapIds[#mapIds + 1] = mapId
		end
	end
	if type(ns.MIDNIGHT_DELVES) == "table" then
		for _, row in ipairs(ns.MIDNIGHT_DELVES) do
			if row[1] == entry.poiId then
				addMap(row[2])
			end
		end
	end
	if C_Map and C_Map.GetBestMapForUnit then
		local ok, playerMap = pcall(C_Map.GetBestMapForUnit, "player")
		if ok then
			local mapId = playerMap
			for _ = 1, 8 do
				if not mapId then
					break
				end
				addMap(mapId)
				if not C_Map.GetMapInfo then
					break
				end
				local info = C_Map.GetMapInfo(mapId)
				if not info or not info.parentMapID or info.parentMapID == 0 then
					break
				end
				mapId = info.parentMapID
			end
		end
	end
	return entry.poiId, mapIds
end

local poiStoryCache = {}

local STORY_ZONE_MAPS = { 2393, 2437, 2395, 2424, 2444, 2413, 2405, 2576 }

local function GetStoryDayKey()
	if date then
		return date("%Y%m%d")
	end
	return "0"
end

local function GetPersistedDelveStory(entryId)
	local s = GetDelveCoachSettings()
	if not s or type(s.storyDaily) ~= "table" then
		return nil
	end
	local row = s.storyDaily[entryId]
	if type(row) == "table" and CanAccessText(row.text) and row.day == GetStoryDayKey() then
		return StripColorCodes(row.text)
	end
	return nil
end

local function SetPersistedDelveStory(entryId, text)
	if not entryId or not CanAccessText(text) then
		return
	end
	text = StripColorCodes(text)
	if text == "" or IsGenericStoryName(text) then
		return
	end
	local s = GetDelveCoachSettings()
	if not s then
		return
	end
	if type(s.storyDaily) ~= "table" then
		s.storyDaily = {}
	end
	s.storyDaily[entryId] = { text = text, day = GetStoryDayKey() }
	poiStoryCache[entryId] = text
end

local function NormalizeDelveTitle(s)
	if not CanAccessText(s) then
		return ""
	end
	return StripColorCodes(s):lower():gsub("^%s+", ""):gsub("%s+$", "")
end

local function ResolveDelveEntryIdFromTitle(title)
	if type(ns.DELVE_TIP_ENTRIES) ~= "table" then
		return nil
	end
	local t = NormalizeDelveTitle(title)
	if t == "" then
		return nil
	end
	for _, entry in ipairs(ns.DELVE_TIP_ENTRIES) do
		if entry and entry.id then
			local roster = NormalizeDelveTitle(entry.rosterName or "")
			if roster ~= "" and roster == t then
				return entry.id
			end
			if ns.GetDelveTipDisplayName then
				local ok, disp = pcall(ns.GetDelveTipDisplayName, ns, entry)
				if ok and NormalizeDelveTitle(disp or "") == t then
					return entry.id
				end
			end
		end
	end
	return nil
end

local function ExtractStoryVariantFromTooltip(tip)
	if not tip or not tip.GetName then
		return nil, nil
	end
	local tipName = tip:GetName()
	if not tipName then
		return nil, nil
	end
	local titleObj = _G[tipName .. "TextLeft1"]
	local title = titleObj and titleObj.GetText and titleObj:GetText()
	if not CanAccessText(title) then
		return nil, nil
	end
	local entryId = ResolveDelveEntryIdFromTitle(title)
	if not entryId then
		return nil, nil
	end
	for i = 2, 12 do
		local lineObj = _G[tipName .. "TextLeft" .. i]
		local text = lineObj and lineObj.GetText and lineObj:GetText()
		if CanAccessText(text) then
			local clean = StripColorCodes(text)
			-- We look for "Story Variant: X" (most clients keep this in English).
			local key = clean:lower()
			if key:find("story", 1, true) and key:find("variant", 1, true) then
				local variant = clean:match(":%s*(.+)$")
				if variant and variant ~= "" then
					return entryId, variant
				end
			end
		end
	end
	return nil, nil
end

function ns.HookDelveStoryTooltip()
	if ns._mhDelveStoryTooltipHooked then
		return
	end
	ns._mhDelveStoryTooltipHooked = true

	local function CacheVariant(entryId, variant, source)
		if not entryId or not variant then
			return
		end
		SetPersistedDelveStory(entryId, variant)
		DebugDelveStoryOnce(entryId, ("Delve story learned (%s): %q"):format(tostring(source or "unknown"), tostring(variant)))
		if ns.RefreshDelveStorySnapshot then
			ns.RefreshDelveStorySnapshot(entryId)
		end
	end

	local function CacheVariantForPoiId(poiId, variant, source)
		poiId = tonumber(poiId)
		if not poiId or not variant or type(ns.DELVE_TIP_ENTRIES) ~= "table" then
			return false
		end
		for _, entry in ipairs(ns.DELVE_TIP_ENTRIES) do
			if entry and entry.poiId == poiId and entry.id then
				CacheVariant(entry.id, variant, source)
				return true
			end
		end
		return false
	end

	local function IsKnownDelvePoiId(poiId)
		poiId = tonumber(poiId)
		if not poiId or type(ns.DELVE_TIP_ENTRIES) ~= "table" then
			return false
		end
		for _, entry in ipairs(ns.DELVE_TIP_ENTRIES) do
			if entry and entry.poiId == poiId then
				return true
			end
		end
		return false
	end

	local function handler(tip)
		local entryId, variant = ExtractStoryVariantFromTooltip(tip)
		if not entryId or not variant then
			return
		end
		CacheVariant(entryId, variant, "tooltip-text")
	end

	local function hookTip(tip)
		if not tip or not tip.HookScript or tip._mhDelveStoryHooked then
			return
		end
		tip._mhDelveStoryHooked = true
		-- Not all tooltip frames support OnTooltipSetText; OnShow is safe.
		pcall(function()
			tip:HookScript("OnShow", function(self)
				handler(self)
			end)
		end)
	end

	-- World map POIs often use WorldMapTooltip instead of GameTooltip.
	hookTip(GameTooltip)
	hookTip(_G.WorldMapTooltip)

	-- WorldMapTooltip sometimes updates in-place without re-showing; poll while visible.
	do
		local wmt = _G.WorldMapTooltip
		if wmt and wmt.HookScript and not wmt._mhDelveStoryUpdateHooked then
			wmt._mhDelveStoryUpdateHooked = true
			local lastAt = 0
			wmt:HookScript("OnUpdate", function(self, elapsed)
				if not self.IsShown or not self:IsShown() then
					return
				end
				local now = (GetTime and GetTime()) or 0
				if (now - lastAt) < 0.2 then
					return
				end
				lastAt = now
				handler(self)
			end)
		end
	end

	-- Preferred: modern tooltip data pipeline (works even when FontString lines are not populated).
	pcall(function()
		if not (TooltipDataProcessor and TooltipDataProcessor.AddTooltipPostCall and Enum and Enum.TooltipDataType) then
			return
		end
		if ns._mhDelveStoryTooltipDataHooked then
			return
		end
		ns._mhDelveStoryTooltipDataHooked = true

		local function postCall(_, tooltipData)
			if not tooltipData or type(tooltipData) ~= "table" then
				return
			end
			local poiId = tooltipData.id or tooltipData.poiID or tooltipData.areaPoiID or tooltipData.areaPOIID
			if not poiId then
				return
			end
			if not IsKnownDelvePoiId(poiId) then
				return
			end
			local lines = tooltipData.lines
			if type(lines) ~= "table" then
				return
			end
			-- (debug) Avoid spamming on unrelated tooltips; only delve POIs reach here.
			if ShouldDebugDelveStoryAny() then
				local sample = {}
				for i = 1, math.min(4, #lines) do
					local line = lines[i]
					local left = line and (line.leftText or line.left or line.text)
					if CanAccessText(left) then
						sample[#sample + 1] = StripColorCodes(left)
					end
				end
				if #sample > 0 then
					DebugDelveStoryOnce("tooltip", ("TooltipData (delve poiId=%s): %s"):format(tostring(poiId), table.concat(sample, " | ")))
				end
			end
			for _, line in ipairs(lines) do
				local left = line and (line.leftText or line.left or line.text)
				if CanAccessText(left) then
					local clean = StripColorCodes(left)
					local key = clean:lower()
					if key:find("story", 1, true) and key:find("variant", 1, true) then
						local variant = clean:match(":%s*(.+)$")
						if variant and variant ~= "" then
							CacheVariantForPoiId(poiId, variant, "tooltip-data")
							return
						end
					end
				end
			end
		end

		-- Different client builds use different tooltip data types for the map POI
		-- hover. Hook all types defensively and filter inside postCall.
		for _, dataType in pairs(Enum.TooltipDataType) do
			pcall(TooltipDataProcessor.AddTooltipPostCall, dataType, postCall)
		end
	end)

	-- Some clients create tooltips later; try again shortly.
	if C_Timer and C_Timer.After then
		C_Timer.After(1.0, function()
			hookTip(GameTooltip)
			hookTip(_G.WorldMapTooltip)
		end)
	end
end

function ns.CacheDelveStoryFromAreaPoi(poiId, pInfo)
	if not poiId or not pInfo or type(ns.DELVE_TIP_ENTRIES) ~= "table" then
		return
	end
	poiId = tonumber(poiId)
	for _, entry in ipairs(ns.DELVE_TIP_ENTRIES) do
		if entry.poiId == poiId and entry.id then
			for _, field in ipairs({ pInfo.description, pInfo.name }) do
				if CanAccessText(field) then
					local clean = StripColorCodes(field)
					if clean ~= "" and not IsGenericStoryName(clean) then
						SetPersistedDelveStory(entry.id, clean)
						return
					end
				end
			end
			return
		end
	end
end

function ns.PrimeDelveStoryPoiCache(entryId)
	if not entryId or not C_AreaPoiInfo or not C_AreaPoiInfo.GetAreaPOIInfo then
		return
	end
	local entry = ns.GetDelveTipEntryById and ns.GetDelveTipEntryById(entryId)
	local poiId = entry and entry.poiId
	if not poiId then
		return
	end
	local _, mapIds = GetTipEntryPoiContext(entryId)
	local seenMap = {}
	local function scanMap(mapId)
		mapId = tonumber(mapId)
		if not mapId or seenMap[mapId] then
			return
		end
		seenMap[mapId] = true
		pcall(function()
			local ok, info = pcall(C_AreaPoiInfo.GetAreaPOIInfo, mapId, poiId)
			if ok and info then
				ns.CacheDelveStoryFromAreaPoi(poiId, info)
			end
		end)
	end
	for _, mapId in ipairs(mapIds or {}) do
		scanMap(mapId)
	end
	for _, mapId in ipairs(STORY_ZONE_MAPS) do
		scanMap(mapId)
	end
end

function ns.PrimeAllDelveStoryPoiCaches()
	if type(ns.DELVE_TIP_ENTRIES) ~= "table" then
		return
	end
	for _, entry in ipairs(ns.DELVE_TIP_ENTRIES) do
		local bosses = ns.DELVE_BOSS_SHOWCASE and ns.DELVE_BOSS_SHOWCASE[entry.id]
		if entry.id and type(bosses) == "table" and #bosses > 1 then
			ns.PrimeDelveStoryPoiCache(entry.id)
		end
	end
end

function ns.ClearDelveStoryPoiCache()
	wipe(activeDelveStorySnapshot)
end

--- World-map delve POI description shows today's story (patch 11.2+); safe outside secret strings.
local function CollectMapPoiStoryCandidates(entryId)
	local poiId, mapIds = GetTipEntryPoiContext(entryId)
	if not poiId or not C_AreaPoiInfo or not C_AreaPoiInfo.GetAreaPOIInfo then
		local persistedOnly = GetPersistedDelveStory(entryId)
		return persistedOnly and { persistedOnly } or {}
	end
	local out = {}
	local seen = {}
	local function push(text)
		if not CanAccessText(text) then
			return
		end
		local clean = StripColorCodes(text)
		if clean == "" or IsGenericStoryName(clean) then
			return
		end
		local key = NormalizeStoryText(clean)
		if seen[key] then
			return
		end
		seen[key] = true
		out[#out + 1] = clean
	end
	local function absorb(info)
		if not info then
			return
		end
		for _, field in ipairs({ info.description, info.name }) do
			push(field)
		end
	end
	local scanMaps = {}
	local scanSeen = {}
	local function addScanMap(mapId)
		mapId = tonumber(mapId)
		if mapId and not scanSeen[mapId] then
			scanSeen[mapId] = true
			scanMaps[#scanMaps + 1] = mapId
		end
	end
	for _, mapId in ipairs(mapIds or {}) do
		addScanMap(mapId)
	end
	for _, mapId in ipairs(STORY_ZONE_MAPS) do
		addScanMap(mapId)
	end
	for _, mapId in ipairs(scanMaps) do
		pcall(function()
			local ok, info = pcall(C_AreaPoiInfo.GetAreaPOIInfo, mapId, poiId)
			if ok then
				absorb(info)
			end
		end)
		if C_AreaPoiInfo.GetDelvesForMap then
			pcall(function()
				local okList, pois = pcall(C_AreaPoiInfo.GetDelvesForMap, mapId)
				if okList and type(pois) == "table" then
					for _, id in ipairs(pois) do
						if id == poiId then
							local okInfo, info = pcall(C_AreaPoiInfo.GetAreaPOIInfo, mapId, poiId)
							if okInfo then
								absorb(info)
							end
						end
					end
				end
			end)
		end
	end
	push(GetPersistedDelveStory(entryId))
	if out[1] then
		SetPersistedDelveStory(entryId, out[1])
	end
	if #out == 0 and poiStoryCache[entryId] then
		return { poiStoryCache[entryId] }
	end
	return out
end

--- Story title from the delve entrance panel (e.g. "Lightbloom Invasion") while a run is active.
local function CollectActiveDelveTierStoryCandidates()
	local out = {}
	if not (ns.IsDelveInstanceInProgress and ns.IsDelveInstanceInProgress()) then
		return out
	end
	pcall(function()
		if not (C_DelvesUI and C_DelvesUI.GetActiveDelveTier) then
			return
		end
		local ok, tierInfo = pcall(C_DelvesUI.GetActiveDelveTier)
		if not ok or type(tierInfo) ~= "table" then
			return
		end
		local function push(raw)
			if not CanAccessText(raw) then
				return
			end
			local clean = StripColorCodes(raw)
			if clean ~= "" and not IsGenericStoryName(clean) then
				out[#out + 1] = clean
			end
		end
		push(tierInfo.tierDescription)
		push(tierInfo.lockedReason)
		for _, v in pairs(tierInfo) do
			if type(v) == "string" then
				push(v)
			end
		end
	end)
	return out
end

local function CollectScenarioNumericSignals()
	local signals = {
		rewardQuestIDs = {},
		criteriaIDs = {},
		spellIDs = {},
		widgetSetIDs = {},
	}
	local function addUnique(list, n)
		n = tonumber(n)
		if not n or n <= 0 or IsSecretValue(n) then
			return
		end
		for _, v in ipairs(list) do
			if v == n then
				return
			end
		end
		list[#list + 1] = n
	end
	pcall(function()
		if C_ScenarioInfo and C_ScenarioInfo.GetScenarioStepInfo then
			local step = C_ScenarioInfo.GetScenarioStepInfo()
			if step then
				addUnique(signals.rewardQuestIDs, step.rewardQuestID)
				addUnique(signals.widgetSetIDs, step.widgetSetID)
				if type(step.spells) == "table" then
					for _, sp in ipairs(step.spells) do
						addUnique(signals.spellIDs, sp and sp.spellID)
					end
				end
			end
		end
	end)
	for i = 1, 16 do
		pcall(function()
			if C_ScenarioInfo and C_ScenarioInfo.GetCriteriaInfo then
				local info = C_ScenarioInfo.GetCriteriaInfo(i)
				if info then
					addUnique(signals.criteriaIDs, info.criteriaID)
				end
			end
		end)
	end
	return signals
end

local function CollectScenarioSpellNameCandidates()
	local out = {}
	local seen = {}
	pcall(function()
		if not (C_ScenarioInfo and C_ScenarioInfo.GetScenarioStepInfo and C_Spell and C_Spell.GetSpellName) then
			return
		end
		local step = C_ScenarioInfo.GetScenarioStepInfo()
		if not step or type(step.spells) ~= "table" then
			return
		end
		for _, sp in ipairs(step.spells) do
			local spellId = sp and sp.spellID
			if spellId and not IsSecretValue(spellId) then
				local ok, spellName = pcall(C_Spell.GetSpellName, spellId)
				if ok and CanAccessText(spellName) then
					local clean = StripColorCodes(spellName)
					if clean ~= "" then
						local key = NormalizeStoryText(clean)
						if not seen[key] then
							seen[key] = true
							out[#out + 1] = clean
						end
					end
				end
			end
		end
	end)
	return out
end

local function TryMatchStoryBoss(entryId, bosses, lists, signals)
	if type(bosses) ~= "table" then
		return nil, nil, nil
	end
	for _, list in ipairs(lists) do
		if type(list) == "table" then
			for _, text in ipairs(list) do
				for i, boss in ipairs(bosses) do
					if StoryMatches(text, boss.storyKeys) then
						return text, boss, i
					end
				end
			end
		end
	end
	for _, list in ipairs(lists) do
		if type(list) == "table" then
			for _, text in ipairs(list) do
				local storyName, bossEntry, idx = MatchBossFromHintText(text, bosses)
				if idx then
					return storyName, bossEntry, idx
				end
			end
		end
	end
	local bossEntry, idx = MatchBossFromNumericSignals(bosses, signals)
	if idx then
		return bossEntry.storyKeys and bossEntry.storyKeys[1] or nil, bossEntry, idx
	end
	return nil, nil, nil
end

local function CollectScenarioStoryCandidates()
	local primary = {}
	local secondary = {}
	local seen = {}
	local function add(list, s)
		if not CanAccessText(s) then
			return
		end
		s = StripColorCodes(s)
		if s == "" or IsGenericStoryName(s) then
			return
		end
		local key = NormalizeStoryText(s)
		if seen[key] then
			return
		end
		seen[key] = true
		list[#list + 1] = s
	end

	pcall(function()
		if C_ScenarioInfo and C_ScenarioInfo.GetScenarioStepInfo then
			local step = C_ScenarioInfo.GetScenarioStepInfo()
			if step then
				add(primary, step.title)
				add(primary, step.description)
			end
		end
	end)

	pcall(function()
		if C_Scenario and C_Scenario.GetStepInfo then
			local title, description = C_Scenario.GetStepInfo()
			add(primary, title)
			add(primary, description)
		end
	end)

	pcall(function()
		if C_ScenarioInfo and C_ScenarioInfo.GetScenarioInfo then
			local info = C_ScenarioInfo.GetScenarioInfo()
			if info then
				add(secondary, info.area)
			end
		end
	end)

	local function WalkTrackerFrame(frame, depth)
		if depth > 12 or not frame or frame:IsForbidden() then
			return
		end
		local nRegs = frame.GetNumRegions and frame:GetNumRegions() or 0
		for i = 1, nRegs do
			local r = select(i, frame:GetRegions())
			if r and r.GetObjectType and r:GetObjectType() == "FontString" and r.IsShown and r:IsShown() then
				add(secondary, r:GetText())
			end
		end
		local nChildren = frame.GetNumChildren and frame:GetNumChildren() or 0
		for i = 1, nChildren do
			WalkTrackerFrame(select(i, frame:GetChildren()), depth + 1)
		end
	end

	if ns.IsDelveInstanceInProgress and ns.IsDelveInstanceInProgress() then
		local root = _G.ScenarioObjectiveTracker
		if root then
			pcall(WalkTrackerFrame, root, 0)
		end
	end

	for i = 1, 16 do
		pcall(function()
			if C_ScenarioInfo and C_ScenarioInfo.GetCriteriaInfo then
				local info = C_ScenarioInfo.GetCriteriaInfo(i)
				if info then
					add(primary, info.description)
					add(primary, info.quantityString)
					add(secondary, info.failedDescription)
				end
			end
		end)
	end

	return primary, secondary
end

function ns.RefreshDelveStorySnapshot(entryId)
	if not entryId then
		return
	end
	local bosses = ns.DELVE_BOSS_SHOWCASE and ns.DELVE_BOSS_SHOWCASE[entryId]
	if type(bosses) ~= "table" or #bosses < 2 then
		return
	end
	local tier = CollectActiveDelveTierStoryCandidates()
	local poi = CollectMapPoiStoryCandidates(entryId)
	local pri, sec = CollectScenarioStoryCandidates()
	local spellNames = CollectScenarioSpellNameCandidates()
	local signals = CollectScenarioNumericSignals()
	local storyName, bossEntry, idx = TryMatchStoryBoss(
		entryId,
		bosses,
		{ tier, poi, pri, sec, spellNames },
		signals
	)
	if idx then
		StoreDelveStorySnapshot(entryId, storyName, bossEntry, idx)
	end
end

--- Active delve story title from the scenario API (daily variant name).
function ns.GetActiveDelveStoryName()
	local entry = ns.GetActiveDelveTipEntryForPlayer and ns.GetActiveDelveTipEntryForPlayer()
	local poi = entry and entry.id and CollectMapPoiStoryCandidates(entry.id) or {}
	local pri, sec = CollectScenarioStoryCandidates()
	return poi[1] or pri[1] or sec[1]
end

--- Returns storyName, bossEntry, bossIndex (or nil boss when this variant has no final boss).
function ns.ResolveDelveStoryBoss(entryId)
	if not entryId then
		return nil, nil, nil
	end
	local bosses = ns.DELVE_BOSS_SHOWCASE[entryId]
	local snap = activeDelveStorySnapshot[entryId]
	if snap and snap.bossIndex and type(bosses) == "table" and bosses[snap.bossIndex] then
		return snap.storyName, bosses[snap.bossIndex], snap.bossIndex
	end
	local tier = CollectActiveDelveTierStoryCandidates()
	local poi = CollectMapPoiStoryCandidates(entryId)
	local pri, sec = CollectScenarioStoryCandidates()
	local spellNames = CollectScenarioSpellNameCandidates()
	local signals = CollectScenarioNumericSignals()

	if ShouldDebugDelveStory(entryId) then
		local bits = {}
		for _, t in ipairs(tier) do
			bits[#bits + 1] = "[tier] " .. t
		end
		for _, t in ipairs(poi) do
			bits[#bits + 1] = "[poi] " .. t
		end
		for _, t in ipairs(pri) do
			bits[#bits + 1] = "[step] " .. t
		end
		for _, t in ipairs(sec) do
			bits[#bits + 1] = "[track] " .. t
		end
		if #signals.spellIDs > 0 then
			bits[#bits + 1] = "[spellIDs] " .. table.concat(signals.spellIDs, ",")
		end
		if #signals.rewardQuestIDs > 0 then
			bits[#bits + 1] = "[questIDs] " .. table.concat(signals.rewardQuestIDs, ",")
		end
		if #signals.criteriaIDs > 0 then
			bits[#bits + 1] = "[criteriaIDs] " .. table.concat(signals.criteriaIDs, ",")
		end
		local cached = GetPersistedDelveStory(entryId)
		if cached then
			bits[#bits + 1] = "[cached] " .. cached
		end
		if #bits > 0 then
			DebugDelveStoryOnce(entryId, ("Delve story signals (%s): %s"):format(entryId, table.concat(bits, " | ")))
		end
	end

	local storyName, bossEntry, idx = TryMatchStoryBoss(
		entryId,
		bosses,
		{ tier, poi, pri, sec, spellNames },
		signals
	)
	if idx then
		StoreDelveStorySnapshot(entryId, storyName, bossEntry, idx)
	end
	if ShouldDebugDelveStory(entryId) then
		if idx then
			DebugDelveStoryOnce(entryId, ("Delve boss resolved: story=%q boss=%s (%d/%d)"):format(tostring(storyName), tostring(bossEntry and bossEntry.label), idx, type(bosses) == "table" and #bosses or 0))
		else
			DebugDelveStoryOnce(entryId, ("Delve boss unresolved (fallback to saved index). story=%q"):format(tostring(storyName)))
		end
	end
	if idx or bossEntry then
		return storyName, bossEntry, idx
	end

	if entryId == "sunkiller_sanctum" then
		for _, list in ipairs({ tier, poi, pri, sec, spellNames }) do
			for _, text in ipairs(list) do
				if StoryMatches(text, { "Not What I Expected", "Nicht das, was ich erwartet habe", "Pas ce à quoi je m'attendais" }) then
					return text, nil, nil
				end
			end
		end
	end
	return nil, nil, nil
end

--- Boss fight fallback: match boss1/target creature ID or name to showcase entries.
function ns.TryResolveDelveBossFromUnits(entryId)
	local bosses = ns.DELVE_BOSS_SHOWCASE[entryId]
	if type(bosses) ~= "table" then
		return nil, nil, nil
	end
	local function checkUnit(unit)
		if not UnitExists or not UnitExists(unit) then
			return nil, nil
		end
		local creatureId = GetUnitCreatureId(unit)
		if creatureId then
			for i, boss in ipairs(bosses) do
				if boss.creatureId == creatureId then
					return boss, i
				end
			end
		end
		local ok, name = pcall(UnitName, unit)
		if not ok or not CanAccessText(name) then
			return nil, nil
		end
		local okMatch, boss, idx = pcall(function()
			local lower = name:lower()
			for i, entry in ipairs(bosses) do
				local label = entry.label
				if type(label) == "string" and label ~= "" then
					local ll = label:lower()
					if lower == ll or lower:find(ll, 1, true) or ll:find(lower, 1, true) then
						return entry, i
					end
				end
			end
			return nil, nil
		end)
		if okMatch then
			return boss, idx
		end
		return nil, nil
	end
	local boss, idx = checkUnit("boss1")
	if idx then
		return boss, idx
	end
	boss, idx = checkUnit("target")
	if idx then
		return boss, idx
	end
	return nil, nil, nil
end

function ns.ResolveDelveBossShowcaseIndex(entryId, preferAuto)
	local bosses = ns.DELVE_BOSS_SHOWCASE[entryId]
	if type(bosses) ~= "table" or #bosses == 0 then
		return nil, false
	end
	if #bosses == 1 then
		return 1, true
	end
	if preferAuto ~= false then
		local storyName, bossEntry, idx = ns.ResolveDelveStoryBoss(entryId)
		if idx then
			return idx, true
		end
		if entryId == "sunkiller_sanctum" and storyName and not bossEntry then
			return nil, true
		end
		local unitBoss, unitIdx = ns.TryResolveDelveBossFromUnits(entryId)
		if unitIdx then
			return unitIdx, true
		end
	end
	return ns.GetDelveBossShowcaseIndex(entryId), false
end

function ns:GetDelveBossShowcaseIndex(entryId)
	local s = ns.db and ns.db.ui and ns.db.ui.delveCoach
	if type(s) ~= "table" then
		return 1
	end
	if type(s.bossIndex) ~= "table" then
		s.bossIndex = {}
	end
	local idx = tonumber(s.bossIndex[entryId]) or 1
	return math.max(1, idx)
end

function ns:GetDelveBossFrame(creatureId, bossEntry)
	local frame = {}
	for k, v in pairs(DEFAULT_BOSS_FRAME) do
		frame[k] = v
	end
	local byCreature = creatureId and CREATURE_FRAMES[creatureId]
	if byCreature then
		for k, v in pairs(byCreature) do
			frame[k] = v
		end
	end
	if bossEntry then
		for k, v in pairs(bossEntry) do
			if k == "cam" or k == "x" or k == "y" or k == "z" or k == "facing" or k == "portraitZoom" then
				frame[k] = v
			end
		end
	end
	local userCam = self:GetDelveBossCamOverride(creatureId)
	if userCam then
		frame.cam = userCam
	end
	return frame
end

function ns:SetDelveBossShowcaseIndex(entryId, index)
	local bosses = self:GetDelveBossShowcase(entryId)
	if not bosses or #bosses == 0 then
		return
	end
	index = math.max(1, math.min(#bosses, tonumber(index) or 1))
	local s = ns.db and ns.db.ui and ns.db.ui.delveCoach
	if type(s) == "table" then
		if type(s.bossIndex) ~= "table" then
			s.bossIndex = {}
		end
		s.bossIndex[entryId] = index
	end
end

local function CancelBossModelRetries(model)
	if not model then
		return
	end
	model._mhRetryGeneration = (model._mhRetryGeneration or 0) + 1
end

local function ModelLooksLoaded(model)
	if not model then
		return false
	end
	if model.GetModelFileID then
		local ok, fileId = pcall(model.GetModelFileID, model)
		if ok and fileId and fileId > 0 then
			return true
		end
	end
	if model.GetCreatureID then
		local ok, id = pcall(model.GetCreatureID, model)
		if ok and id and id > 0 then
			return true
		end
	end
	return false
end

local function ModelApplyLooksValid(model)
	return ModelLooksLoaded(model) or not (model and model.GetModelFileID)
end

local function CollectCreatureIdsToTry(creatureId, bossEntry)
	local ids = {}
	local seen = {}
	local function add(id)
		id = tonumber(id)
		if id and id > 0 and not seen[id] then
			seen[id] = true
			ids[#ids + 1] = id
		end
	end
	add(creatureId)
	if bossEntry and type(bossEntry.creatureIdFallback) == "table" then
		for _, alt in ipairs(bossEntry.creatureIdFallback) do
			add(alt)
		end
	end
	return ids
end

local function TryApplyCreatureToModel(model, creatureId, displayId)
	if not model then
		return false
	end
	creatureId = tonumber(creatureId)
	displayId = tonumber(displayId)

	local function afterLoad()
		if model.Show then
			model:Show()
		end
		if model.SetCamera then
			pcall(model.SetCamera, model, 0)
		end
		if model.RefreshCamera then
			pcall(model.RefreshCamera, model)
		end
	end

	local function tryOk(fn)
		if not fn() then
			return false
		end
		return ModelApplyLooksValid(model)
	end

	-- SetCreatureData first (matches last CF release; works in live delves).
	if creatureId and model.SetCreatureData then
		if tryOk(function()
			return pcall(model.SetCreatureData, model, creatureId)
		end) then
			afterLoad()
			return true
		end
	end
	if creatureId and model.SetCreature then
		if displayId and displayId > 0 then
			if tryOk(function()
				return pcall(model.SetCreature, model, creatureId, displayId)
			end) then
				afterLoad()
				return true
			end
		end
		if tryOk(function()
			return pcall(model.SetCreature, model, creatureId, 0)
		end) then
			afterLoad()
			return true
		end
		if tryOk(function()
			return pcall(model.SetCreature, model, creatureId)
		end) then
			afterLoad()
			return true
		end
	end
	if displayId and displayId > 0 and model.SetDisplayInfo then
		if tryOk(function()
			return pcall(model.SetDisplayInfo, model, displayId)
		end) then
			afterLoad()
			return true
		end
	end
	return false
end

local function UnitMatchesBossCreature(creatureId, bossEntry)
	if not creatureId or not bossEntry then
		return false
	end
	if creatureId == bossEntry.creatureId then
		return true
	end
	if type(bossEntry.creatureIdFallback) == "table" then
		for _, alt in ipairs(bossEntry.creatureIdFallback) do
			if creatureId == alt then
				return true
			end
		end
	end
	return false
end

local function TryApplyUnitBossModel(model, bossEntry)
	if not model or not model.SetUnit or not bossEntry then
		return false
	end
	for _, unit in ipairs({ "boss1", "target", "focus" }) do
		if UnitExists and UnitExists(unit) then
			local creatureId = GetUnitCreatureId(unit)
			if UnitMatchesBossCreature(creatureId, bossEntry) then
				local ok = pcall(model.SetUnit, model, unit)
				if ok and ModelApplyLooksValid(model) then
					return true, creatureId
				end
			end
		end
	end
	return false, nil
end

local function FinishDelveBossCreatureModel(model, creatureId, frame, bossEntry)
	if not model or model._mhPendingCreatureId ~= creatureId then
		return false
	end

	local displayId = bossEntry and bossEntry.displayId
	local ok, loadedId = false, nil
	for _, tryId in ipairs(CollectCreatureIdsToTry(creatureId, bossEntry)) do
		if TryApplyCreatureToModel(model, tryId, displayId) then
			ok = true
			loadedId = tryId
			break
		end
	end
	if not ok and bossEntry then
		ok, loadedId = TryApplyUnitBossModel(model, bossEntry)
	end

	if not ok or model._mhPendingCreatureId ~= creatureId then
		if model._mhLoadingFs and model._mhLoadingFs.Show then
			model._mhLoadingFs:SetText(ns:L("DELVE_COACH_BOSS_LOADING"))
			model._mhLoadingFs:Show()
		end
		return false
	end

	local resolvedId = loadedId or creatureId
	model._mhLoadedCreatureId = resolvedId
	model:Show()
	if model._mhLoadingFs and model._mhLoadingFs.Hide then
		model._mhLoadingFs:Hide()
	end
	frame = ns:GetDelveBossFrame(resolvedId, model._mhBossEntry)
	ns:ApplyDelveBossFrameSettings(model, frame)

	local function refit()
		if not model or model._mhLoadedCreatureId ~= resolvedId then
			return
		end
		local fresh = ns:GetDelveBossFrame(resolvedId, model._mhBossEntry)
		ns:ApplyDelveBossFrameSettings(model, fresh)
	end
	if C_Timer and C_Timer.After then
		C_Timer.After(0.05, refit)
		C_Timer.After(0.12, refit)
		C_Timer.After(0.25, refit)
		C_Timer.After(0.45, refit)
	end
	return true
end

local function ScheduleBossModelRetries(model, creatureId, bossEntry)
	if not model or not creatureId or not C_Timer or not C_Timer.After then
		return
	end
	local frame = ns:GetDelveBossFrame(creatureId, bossEntry)
	CancelBossModelRetries(model)
	local generation = model._mhRetryGeneration or 0
	for _, delay in ipairs(MODEL_RETRY_DELAYS) do
		C_Timer.After(delay, function()
			if not model or model._mhRetryGeneration ~= generation then
				return
			end
			if model._mhLoadedCreatureId == creatureId then
				return
			end
			if model._mhPendingCreatureId ~= creatureId then
				model._mhPendingCreatureId = creatureId
			end
			FinishDelveBossCreatureModel(model, creatureId, frame, bossEntry)
		end)
	end
end

function ns:ClearDelveBossCreatureModel(model)
	if not model then
		return
	end
	CancelBossModelRetries(model)
	model._mhPendingCreatureId = nil
	model._mhLoadedCreatureId = nil
	if model.ClearModel then
		pcall(model.ClearModel, model)
	end
	if model.SetCamDistanceScale then
		pcall(model.SetCamDistanceScale, model, 1)
	end
	if model.SetAnimation then
		pcall(model.SetAnimation, model, 0, 0)
	end
	model:Hide()
end

function ns:ApplyDelveBossFrameSettings(model, frame)
	if not model or not frame then
		return
	end
	local x = tonumber(frame.x) or 0
	local y = tonumber(frame.y) or 0
	local z = tonumber(frame.z) or 0
	local facing = tonumber(frame.facing) or 0.32
	local cam = tonumber(frame.cam) or DEFAULT_BOSS_FRAME.cam
	local portraitZoom = tonumber(frame.portraitZoom)
	if portraitZoom == nil then
		portraitZoom = DEFAULT_BOSS_FRAME.portraitZoom or 0
	end

	if model.SetPosition then
		model:SetPosition(x, y, z)
	end
	if model.SetFacing then
		model:SetFacing(facing)
	end
	if model.SetAnimation then
		-- variation -1 loops idle on PlayerModel (static pose at 0,0 looks "frozen").
		pcall(model.SetAnimation, model, 0, -1)
	end
	if model.SetDoBlend then
		model:SetDoBlend(true)
	end
	if model.SetPaused then
		pcall(model.SetPaused, model, false)
	end
	if model.SetPortraitZoom then
		pcall(model.SetPortraitZoom, model, portraitZoom)
	end
	if model.SetCamDistanceScale then
		model:SetCamDistanceScale(cam)
	end
	if model.RefreshCamera then
		pcall(model.RefreshCamera, model)
	end
end

function ns:ApplyDelveBossCreatureModel(model, creatureId, bossEntry)
	if not model then
		return false
	end
	creatureId = tonumber(creatureId)
	if not creatureId or creatureId <= 0 then
		self:ClearDelveBossCreatureModel(model)
		return false
	end

	local frame = self:GetDelveBossFrame(creatureId, bossEntry)
	model._mhBossEntry = bossEntry

	if model._mhLoadedCreatureId and model.IsShown and model:IsShown() then
		for _, tryId in ipairs(CollectCreatureIdsToTry(creatureId, bossEntry)) do
			if model._mhLoadedCreatureId == tryId then
				self:ApplyDelveBossFrameSettings(model, self:GetDelveBossFrame(tryId, bossEntry))
				return true
			end
		end
	end

	CancelBossModelRetries(model)
	model._mhPendingCreatureId = creatureId
	self:ClearDelveBossCreatureModel(model)
	model._mhPendingCreatureId = creatureId
	if model.Show then
		model:Show()
	end

	if FinishDelveBossCreatureModel(model, creatureId, frame, bossEntry) then
		return true
	end
	ScheduleBossModelRetries(model, creatureId, bossEntry)
	return true
end

function ns.ApplyDelveBossPortraitFallback(portraitTex, bossEntry)
	if not portraitTex then
		return false
	end
	portraitTex:Hide()
	if not bossEntry then
		return false
	end
	if SetPortraitTexture then
		for _, unit in ipairs({ "boss1", "target", "focus" }) do
			if UnitExists and UnitExists(unit) then
				local cid = GetUnitCreatureId(unit)
				if UnitMatchesBossCreature(cid, bossEntry) then
					local ok = pcall(SetPortraitTexture, portraitTex, unit)
					if ok then
						portraitTex:SetAlpha(1)
						portraitTex:Show()
						return true
					end
				end
			end
		end
	end
	return false
end
