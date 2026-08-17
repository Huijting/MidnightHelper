--[[
	MidnightHelper — Delves module (Midnight Season 1): dashboard, currencies,
	Delver's Journey (renown), POI bountiful (character map), TomTom;
	Great Vault World row (same tab, below delve list).
]]

-- Delve list icons: per-delve atlas from C_AreaPoiInfo (map POI); bountiful keeps portal atlas / Media fallbacks.

local addonName, ns = ...

local travelPopup -- Assigned when Travel Assistant UI is built at bottom of file
local hsBtn -- Assigned with travel popup (secure hearth icon)
local travelHidePending

-- Popup contains secure buttons; Hide() is blocked during combat lockdown.
local function SafeHideTravelPopup()
	if not travelPopup or not travelPopup:IsShown() then
		return
	end
	if InCombatLockdown() then
		if not travelHidePending then
			travelHidePending = CreateFrame("Frame")
			travelHidePending:SetScript("OnEvent", function(self, event)
				if event == "PLAYER_REGEN_ENABLED" and not InCombatLockdown() then
					self:UnregisterEvent("PLAYER_REGEN_ENABLED")
					SafeHideTravelPopup()
				end
			end)
		end
		travelHidePending:RegisterEvent("PLAYER_REGEN_ENABLED")
		return
	end
	if travelHidePending then
		travelHidePending:UnregisterEvent("PLAYER_REGEN_ENABLED")
	end
	travelPopup:Hide()
end

ns.SafeHideTravelPopup = SafeHideTravelPopup

local C_Map = C_Map
local C_CurrencyInfo = C_CurrencyInfo
local C_AreaPoiInfo = C_AreaPoiInfo
local C_Minimap = C_Minimap
local C_PartyInfo = C_PartyInfo
local C_DelvesUI = C_DelvesUI
local C_MajorFactions = C_MajorFactions
local C_Traits = C_Traits
local C_Spell = C_Spell
local C_WeeklyRewards = C_WeeklyRewards
local C_Item = C_Item
--------------------------------------------------------------------------------
-- Delve roster: reference id + entrance uiMap + xy (0–100) for TomTom only (names drive POI scan).
--------------------------------------------------------------------------------
local MIDNIGHT_DELVES = {
	{ 93372, 2395, 45.03, 85.34, "The Shadow Enclave" },
	{ 93419, 2393, 40.60, 53.70, "Collegiate Calamity" },
	{ 93420, 2393, 39.31, 32.07, "The Darkway" },
	{ 93421, 2424, 47.82, 41.70, "Parhelion Plaza" },
	{ 93422, 2395, 63.79, 80.16, "Atal'Aman" },
	{ 93423, 2437, 25.38, 83.85, "Twilight Crypts" },
	{ 93424, 2413, 36.10, 49.01, "The Gulf of Memory" },
	{ 93425, 2413, 70.45, 64.92, "The Grudge Pit" }, -- Final Verified Entry
	{ 93426, 2405, 54.89, 46.62, "Sunkiller Sanctum" },
	{ 93428, 2405, 37.18, 49.16, "Shadowguard Point" },
	{ 93427, 2405, 61.18, 71.28, "Torment's Rise" },

	-- ✅ PATCH 12.1, MEASURED 14 Aug 2026 — not datamined.
	--
	-- Rob's Delves panel showed eleven and nothing on the Coiled Isle, which looked
	-- like missing content and was this table being faithfully rendered: the roster is
	-- hardcoded and drives the POI scan by name, so a delve a patch adds can never
	-- appear in it however live it is.
	--
	-- The names had been sitting in the watchers since June from a datamine, and were
	-- deliberately not shipped from there. `/mh atal` asked C_AreaPoiInfo.GetDelvesForMap
	-- instead -- keyed on the map, not on a name, so it can name a delve nobody told it
	-- about -- and the client returned both of these on 2512 with atlas `delves-regular`.
	--
	-- ⚠️ Their first column is the client's REAL poiID, unlike the eleven above. That
	-- column feeds GetDelvePoiState's fast path, which compares it against the ids
	-- GetDelvesForMap returns (8425, 8437, ...); the 93xxx values up there cannot match
	-- those and fall through to the name pass every time. Not fixed here -- eleven
	-- unverified replacements on a working fallback is a separate, riskier change --
	-- but recorded, because the mismatch is invisible and looks deliberate.
	{ 8761, 2512, 64.54, 77.58, "Gnarldor Isle" },
	{ 8764, 2512, 71.35, 56.54, "The Ring of Glory" },

	-- ⏭️ Venomfall Deeps, the S2 Nemesis delve, is NOT here on purpose. The same call
	-- that found the two above returned only those two for 2512, so this is absence
	-- measured with a positive control rather than absence assumed -- and it matches
	-- Blizzard putting the Nemesis and Bountiful behind Season 2 (18 Aug). Re-run
	-- `/mh atal` after the season flips; if it appears, add it the same way.
}

--- Is this one of the eleven we ship?
---
--- Exported 14 Aug 2026 so a probe can tell "the client named a delve we do not carry"
--- apart from "the client named one we do" — which is the only interesting column when
--- you are looking for content a patch added. The roster stays local: a probe that
--- copied these names would drift from them the first time this list changed.
---
--- Returns nil for an unusable name, so "we do not have it" and "you asked me nothing"
--- never look the same to the caller.
---
--- Substring both ways because a POI title can be prefixed ("Bountiful Delve: The
--- Shadow Enclave") — the same reason MatchDelveName in DelveHistory does it.
function ns.IsKnownDelveName(name)
	if type(name) ~= "string" or name == "" then
		return nil
	end
	for _, d in ipairs(MIDNIGHT_DELVES) do
		local rosterName = d[5]
		if rosterName and rosterName ~= "" then
			if rosterName == name
				or name:find(rosterName, 1, true)
				or rosterName:find(name, 1, true) then
				return true
			end
		end
	end
	return false
end

local MIDNIGHT_PORTALS = {
	-- SILVERMOON HUB
	{ name = "Portal to Voidstorm",  mapID = 2393, toID = 2405, x = 35.25, y = 65.85 },
	{ name = "Portal to Harandar",   mapID = 2393, toID = 2413, x = 36.76, y = 68.52 },
	{ name = "Portal to Voidstorm",  mapID = 2576, toID = 2405, x = 35.25, y = 65.85, zone = "Silvermoon" },
	{ name = "Portal to Harandar",   mapID = 2576, toID = 2413, x = 36.76, y = 68.52, zone = "Silvermoon" },

	-- HARANDAR HUB
	{ name = "Portal to Silvermoon", mapID = 2413, toID = 2393, x = 64.15, y = 70.82 },
	{ name = "Portal to Voidstorm",  mapID = 2413, toID = 2405, x = 61.80, y = 72.16 },
	{ name = "Portal to Silvermoon", mapID = 2576, toID = 2393, x = 64.15, y = 70.82, zone = "Harandar" },
	{ name = "Portal to Voidstorm",  mapID = 2576, toID = 2405, x = 61.80, y = 72.16, zone = "Harandar" },

	-- VOIDSTORM HUB
	{ name = "Portal to Silvermoon", mapID = 2405, toID = 2393, x = 51.61, y = 70.22 },
	{ name = "Portal to Harandar",   mapID = 2405, toID = 2413, x = 51.72, y = 70.33 },
	{ name = "Portal to Silvermoon", mapID = 2576, toID = 2393, x = 51.61, y = 70.22, zone = "Voidstorm" },
	{ name = "Portal to Harandar",   mapID = 2576, toID = 2413, x = 51.72, y = 70.33, zone = "Voidstorm" },

	-- COILED ISLE (12.1) — ⚠️ GATED, and that is the whole point of the field.
	--
	-- This portal does not exist until you have unlocked it, so listing it plainly
	-- would send a player to a wall in Astalor's Sanctum and look like our data is
	-- wrong. `requiresQuest` makes it appear only for someone who can use it — the same
	-- discipline as the delve chests, where an unreadable flag keeps the chest in the
	-- route instead of hiding it.
	--
	-- Unlock (method.gg, read in full 16 aug 2026): quest 96004 "Prey: A Slithering
	-- Threat" from Astalor at 2393 56.63/65.61, which asks for one Prey Hunt on
	-- NIGHTMARE difficulty on the Coiled Isle; then 96466 "Prey: Anguish Island".
	--
	-- ⚠️ Nightmare Prey Hunts only open in WEEK TWO of Season 2, so nobody can have this
	-- portal on the Tuesday the season starts. Until then the travel help must keep
	-- pointing at the flight master, which it does on its own because the gate is false.
	--
	-- ✅ 96004 MEASURED 16 aug on Rob's shaman: the client returns "Prey: A Slithering
	-- Threat" exactly, so this gate rests on a real quest.
	--
	-- ✅ 96466 SETTLED 17 aug: it is a wrong id, and this time it was measured rather
	-- than asserted. Method's Prey guide names the same follow-up 96528, which the
	-- client DOES know ("Prey: Anguish from Beyond") — so "Season 2 has not activated
	-- yet" cannot explain 96466's silence, because it would silence 96528 too.
	--
	-- Neither gates anything here. Only 96004 does, and that one is checked.
	{ name = "Portal to The Coiled Isle", mapID = 2393, toID = 2512,
		x = 56.83, y = 67.38, requiresQuest = 96004 },
	{ name = "Portal to The Coiled Isle", mapID = 2576, toID = 2512,
		x = 56.83, y = 67.38, zone = "Silvermoon", requiresQuest = 96004 },
	-- The way back, from Tokka's Landing. Same gate: you only ever see this one after
	-- arriving through the first.
	{ name = "Portal to Silvermoon", mapID = 2512, toID = 2393,
		x = 58.25, y = 48.46, requiresQuest = 96004 },

	-- SHOWDOWN VOID WORLDS
	-- Naigtal had no entry at all, so the travel assistant found nothing there and
	-- told Rob to hearth home while he was standing next to the way back (30 jul).
	--
	-- It is not a portal: it is a "Lightforged Beacon" you click, offering Silvermoon
	-- OR the Voidstorm. Named after the object rather than the destination because
	-- this string is what the popup tells you to look for, and there is no swirl to
	-- spot -- "Portal to Silvermoon" would send you hunting for the wrong thing.
	--
	-- Both destinations listed, same coordinate. That is not duplication: the advice
	-- prefers a portal whose toID IS the target and only falls back to the Silvermoon
	-- hub, so without the Voidstorm row anyone heading for Voidstorm content would be
	-- bounced through Silvermoon for no reason.
	{ name = "Lightforged Beacon (to Silvermoon)", mapID = 2600, toID = 2393, x = 48.67, y = 82.74 },
	{ name = "Lightforged Beacon (to Voidstorm)",  mapID = 2600, toID = 2405, x = 48.67, y = 82.74 },
	-- Val (2599) almost certainly has the same portal, and Val alternates with Naigtal
	-- week by week -- so half the weeks still get the hearth advice until someone
	-- stands on it and reads the coordinate. Not guessed from Naigtal's: these are two
	-- different maps and a wrong waypoint sends you across a zone for nothing.
}

ns.MIDNIGHT_DELVES = MIDNIGHT_DELVES
ns.MIDNIGHT_PORTALS = MIDNIGHT_PORTALS

--- Is this portal usable by THIS character right now?
---
--- ⚠️ An unreadable quest flag counts as NOT usable, which is the opposite of the rule
--- for delve chests — and deliberately so. There, hiding a chest costs you a treasure
--- you never find; here, showing a portal that is not there sends you to a blank wall
--- and makes every other direction we give look untrustworthy. The cheap failure is a
--- portal we forget to offer, not one we invent.
local function PortalUsable(portal)
	if not portal or not portal.requiresQuest then
		return true
	end
	if not (C_QuestLog and C_QuestLog.IsQuestFlaggedCompleted) then
		return false
	end
	local ok, done = pcall(C_QuestLog.IsQuestFlaggedCompleted, portal.requiresQuest)
	return (ok and done) and true or false
end
ns.MHPortalUsable = PortalUsable

-- Verified Midnight currency IDs (Restored Coffer Key, Shards, Undercoin, Untainted Mana-Crystals).
local CURRENCY_COFFER_KEY = 3028
local CURRENCY_COFFER_SHARDS = 3310
local CURRENCY_UNDERCOIN = 2803
local CURRENCY_UNTAINTED_MANA_CRYSTALS = 3356
local Config = ns.Config or {}
local ITEM_TROVEHUNTER_BOUNTY = Config.DELVE_ITEM_TROVEHUNTER_BOUNTY or 252415
local ITEM_RAID_R_MINI = Config.DELVE_ITEM_RAID_R_MINI or 244193

local TRACKER_ROW_HEIGHT = 24
local ICON_SIZE = 22
local ICON_NAME_GAP = 10
local COL_GAP = 12
-- Fallback skull-hourglass when POI atlas unavailable. Bountiful: portal atlas, addon art, fileID.
local ICON_TEX_DELVE_STANDARD = 525134
local ICON_TEX_DELVE_BOUNTIFUL_LAST_RESORT = 5802055
local ATLAS_DELVE_BOUNTIFUL = "Delves-Bountiful-Icon"
local BOUNTIFUL_MEDIA_ICON = "Interface\\AddOns\\MidnightHelper\\Media\\BountifulPortal"
--- Nemesis delve (Torment's Rise): POI often has no atlas, only generic minimap textureIndex.
local DELVE_NEMESIS_NAME = "Torment's Rise"
local ATLAS_DELVE_NEMESIS_CANDIDATES = {
	"Delves-Nemesis-Icon",
	"delves-nemesis-icon",
	"Delves-Nemesis",
}
local ATLAS_DELVE_STANDARD_CANDIDATES = {
	"Delves-Entrance-Icon",
	"delves-entrance-icon",
	"Delves-Default-Icon",
	"ui-delves",
}

local function isAtlasBountiful(atlas)
	if not atlas or atlas == "" then
		return false
	end
	return string.find(string.lower(tostring(atlas)), "bountiful", 1, true) ~= nil
end

local function poiAtlasCandidates(atlas, textureKit)
	if not atlas or atlas == "" then
		return nil
	end
	local out = {}
	local seen = {}
	local function add(name)
		if name and name ~= "" and not seen[name] then
			seen[name] = true
			out[#out + 1] = name
		end
	end
	if textureKit and textureKit ~= "" then
		add(string.format("%s-%s", textureKit, atlas))
	end
	add(atlas)
	return out
end

local function tryAtlasCandidates(icon, candidates)
	if not icon or not icon.SetAtlas or type(candidates) ~= "table" then
		return false
	end
	for _, name in ipairs(candidates) do
		pcall(icon.SetAtlas, icon, nil)
		local atlasOk = select(1, pcall(icon.SetAtlas, icon, name))
		local tid = icon.GetTexture and icon:GetTexture()
		if atlasOk and tid and tid ~= 0 and tid ~= "" then
			return true
		end
	end
	return false
end

local function tryApplyPoiAtlas(icon, atlas, textureKit)
	if not icon or not atlas or atlas == "" or not icon.SetAtlas then
		return false
	end
	local candidates = poiAtlasCandidates(atlas, textureKit)
	if not candidates then
		return false
	end
	for _, name in ipairs(candidates) do
		pcall(icon.SetAtlas, icon, nil)
		local atlasOk = select(1, pcall(icon.SetAtlas, icon, name))
		local tid = icon.GetTexture and icon:GetTexture()
		if atlasOk and tid and tid ~= 0 and tid ~= "" then
			return true
		end
	end
	return false
end

local function tryApplyPoiTextureIndex(icon, textureIndex)
	if not icon or not textureIndex or not C_Minimap or not C_Minimap.GetPOITextureCoords then
		return false
	end
	local ok, x1, x2, y1, y2 = pcall(C_Minimap.GetPOITextureCoords, textureIndex)
	if not ok or not x1 then
		return false
	end
	if icon.SetAtlas then
		pcall(icon.SetAtlas, icon, nil)
	end
	icon:SetTexture("Interface/Minimap/POIIcons")
	icon:SetTexCoord(x1, x2, y1, y2)
	return true
end

local function applyDelveRowIcon(icon, useBountiful, grayVertex)
	if not icon then
		return
	end
	if useBountiful then
		if icon.SetAtlas then
			pcall(icon.SetAtlas, icon, nil)
		end
		local atlasOk = false
		if icon.SetAtlas then
			atlasOk = select(1, pcall(icon.SetAtlas, icon, ATLAS_DELVE_BOUNTIFUL))
		end
		local tid = icon.GetTexture and icon:GetTexture()
		if not atlasOk or not tid or tid == 0 or tid == "" then
			icon:SetTexture(BOUNTIFUL_MEDIA_ICON)
			tid = icon.GetTexture and icon:GetTexture()
		end
		if not tid or tid == 0 or tid == "" then
			icon:SetTexture(ICON_TEX_DELVE_BOUNTIFUL_LAST_RESORT)
		end
	else
		if icon.SetAtlas then
			pcall(icon.SetAtlas, icon, nil)
		end
		icon:SetTexture(ICON_TEX_DELVE_STANDARD)
	end
	if grayVertex then
		icon:SetVertexColor(0.55, 0.55, 0.55)
	else
		icon:SetVertexColor(1, 1, 1)
	end
end

-- Reference ilvls for delve rewards.
--
-- ⚠️ THESE ARE SEASON 1 NUMBERS AND THEY EXPIRE ON 18 AUGUST 2026.
--
-- Rob spotted them himself in the Gnarldor Isle tooltip on 15 Aug: "de ilvls die we
-- krijgen in de nieuwe klopt niet". He was right, and it is worth naming what kind of
-- wrong it is. Everything else this addon shipped that week says plainly when it does
-- not know something — the raid tips carry a pre-release note, the new delves say
-- nobody has walked them, the Ancient Foes say no coordinate exists. This table says
-- "Tier 8: End 246 | Vault 259" in a confident white font to someone who is about to
-- be handed 300-plus. It is the only place left where we would simply lie.
--
-- So the numbers are gated rather than replaced. Season 2's real values are not
-- measured: the watchers carry datamined candidates (docs/PTR_12.1_WATCH.md) and this
-- repo does not ship those as facts. Once the season flips, the tooltip says so and
-- stops quoting figures — the same shape as MPLUS_AFFIX_UNMEASURED, which was written
-- for exactly this situation one panel over.
--
-- To close this properly: run a delve after 18 Aug, read the end-chest and vault
-- ilvls off your own loot, and fill in DELVE_LOOT_TABLE_S2 below. Until then the
-- honest answer is a sentence, not a table.
local DELVE_LOOT_TABLE_S1 = {
	[1] = { endChest = 210, vault = 216 },
	[2] = { endChest = 213, vault = 219 },
	[3] = { endChest = 216, vault = 226 },
	[4] = { endChest = 219, vault = 233 },
	[5] = { endChest = 226, vault = 239 },
	[6] = { endChest = 233, vault = 246 },
	[7] = { endChest = 239, vault = 252 },
	[8] = { endChest = 246, vault = 259 },
	[9] = { endChest = 246, vault = 259 }, -- Gear Cap
	[10] = { endChest = 246, vault = 259 },
	[11] = { endChest = 246, vault = 259 },
}

--- Season 2 values. Empty on purpose: nobody has run a delve in Season 2 yet.
--- Fill from your own loot, not from a datamine — one delve per tier settles a row.
local DELVE_LOOT_TABLE_S2 = {}

--- Which table applies right now, or nil when the season has turned and we have not
--- measured it. nil is a real answer here and the caller prints a sentence for it.
local function CurrentLootTable()
	if ns.IsSeason2Live and ns.IsSeason2Live() then
		if next(DELVE_LOOT_TABLE_S2) ~= nil then
			return DELVE_LOOT_TABLE_S2
		end
		return nil
	end
	return DELVE_LOOT_TABLE_S1
end

--------------------------------------------------------------------------------
-- Great Vault (World row): must be declared before RefreshDelvesPanel() — Lua 5.1
-- resolves forward calls to globals if the local appears later in the chunk.
--------------------------------------------------------------------------------
local function GetVaultProgress()
	if not C_WeeklyRewards or not C_WeeklyRewards.GetActivities then return {} end

	-- Midnight 12.0 Fix: Call without arguments, filter manually
	local allActivities = C_WeeklyRewards.GetActivities()
	local activities = {}

	if allActivities then
		for _, a in ipairs(allActivities) do
			if a.type == 6 then -- 6 is the Enum for World/Delves
				table.insert(activities, a)
			end
		end
	end

	local progressData = {}

	if #activities > 0 then
		-- 1. Sort strictly by threshold (2, 4, 8) to ensure Box 1, 2, 3 are correct
		table.sort(activities, function(a, b)
			return a.threshold < b.threshold
		end)

		-- 2. Find the actual max progress (Workaround for API returning 0 on locked tiers)
		local currentProgress = 0
		for _, activity in ipairs(activities) do
			if activity.progress > currentProgress then
				currentProgress = activity.progress
			end
		end

		-- 3. Build data using the synchronized progress
		for _, activity in ipairs(activities) do
			local ilvl = 0
			if activity.id then
				local itemLink = C_WeeklyRewards.GetExampleRewardItemHyperlinks(activity.id)
				if itemLink then
					ilvl = C_Item.GetDetailedItemLevelInfo(itemLink) or 0
				end
			end

			table.insert(progressData, {
				activityID = activity.id,
				progress = currentProgress, -- Synced max progress
				threshold = activity.threshold,
				unlocked = currentProgress >= activity.threshold,
				level = activity.level,
				ilvl = ilvl
			})
		end
	end
	return progressData
end

ns.GetVaultProgress = GetVaultProgress

local function VaultHasClaimableRewards()
	if not C_WeeklyRewards or not C_WeeklyRewards.HasAvailableRewards then
		return false
	end
	local ok, avail = pcall(C_WeeklyRewards.HasAvailableRewards)
	return ok and avail == true
end

local function RouteToDelveRow(rd)
	if not rd or not rd.mapID then
		return false
	end
	local ok = ns.AddSmartTomTomWay(rd.mapID, rd.x, rd.y, rd.name)
	if ok then
		ns._mhRouteOwner = "delve" -- claim the shared on-screen arrow (draws without TomTom)
	end
	if ok and not ns.IsTomTomReady() then
		print(
			("|cffffcc00%s|r %s"):format(
				ns:L("PRINT_PREFIX"),
				ns:L("BLIZZARD_WAYPOINT_SET"):format(tostring(rd.name or "Delve"))
			)
		)
	end
	return ok and true or false
end

--------------------------------------------------------------------------------
-- TomTom + Travel Assistant (shared as ns.AddSmartTomTomWay for Profession.lua)
--------------------------------------------------------------------------------
function ns.IsTomTomReady()
	return _G.TomTom and type(_G.TomTom.AddWaypoint) == "function"
end

local function GetZoneDisplayName(uiMapID)
	if not uiMapID then
		return "" -- mid-loading-screen: GetBestMapForUnit returns nil for a moment
	end
	local info = C_Map.GetMapInfo(uiMapID)
	if info and info.name then
		return info.name
	end
	return "Map " .. tostring(uiMapID)
end

-- Maps map IDs to base zone names for hub / arrival detection (Phase 49 + 59).
function ns.GetBaseZoneName(mapID)
	local mid = tonumber(mapID)
	if mid == 2393 or mid == 2576 then
		return "Silvermoon"
	end
	if mid == 2413 then
		return "Harandar"
	end
	if mid == 2405 then
		return "Voidstorm"
	end
	if mid == 2424 then
		return "Quel'Danas"
	end
	if mid == 2395 or mid == 2437 then
		return "Zul'Aman"
	end
	return ""
end

-- Quel'Thalas region vs Harandar vs Voidstorm (Phase 60 — same group = no travel nag).
function ns.GetRegionGroupID(mapID)
	local mid = tonumber(mapID)
	--- 2512 = The Coiled Isle (12.1), sitting under Quel'Thalas next to Zul'Aman.
	---
	--- ⚠️ An unknown map falls through to group 0, and the caller's "same region, stay
	--- quiet" check explicitly skips group 0 — so a new zone does not merely miss the
	--- grouping, it actively triggers the travel popup. Rob got "Distance: Very Far" and
	--- a portal suggestion while standing 954 yards from the target. Any zone Blizzard
	--- adds does this until it is listed here.
	if mid == 2393 or mid == 2576 or mid == 2424 or mid == 2395 or mid == 2437
		or mid == 2512 then
		return 1
	end
	if mid == 2413 then
		return 2
	end
	if mid == 2405 then
		return 3
	end
	return 0
end

local MIDNIGHT_OVERWORLD_MAPS = {
	[2576] = true,
	[2393] = true,
	[2413] = true,
	[2405] = true,
	[2395] = true,
	[2437] = true,
	[2424] = true,
	[2512] = true, -- The Coiled Isle (12.1)
}

local TRAVEL_ARRIVAL_YARDS = 400

function ns.ResolveHubOnMap2576(pxPercent)
	local px = tonumber(pxPercent)
	if not px then
		return nil
	end
	if px < 45 then
		return "Silvermoon"
	end
	if px > 58 then
		return "Harandar"
	end
	return "Voidstorm"
end

-- Map 2576 is one canvas; hub slice drives region (fixes Harandar delves while still on 2576).
function ns.GetEffectiveRegionGroupID(mapID, hubName)
	local mid = tonumber(mapID)
	if mid == 2576 and hubName then
		if hubName == "Silvermoon" then
			return 1
		end
		if hubName == "Harandar" then
			return 2
		end
		if hubName == "Voidstorm" then
			return 3
		end
	end
	return ns.GetRegionGroupID(mapID)
end

function ns.GetPlayerHubContext(currentMap)
	local mid = tonumber(currentMap)
	if not mid then
		return nil, nil
	end
	if mid == 2576 then
		local playerPos = C_Map.GetPlayerMapPosition(mid, "player")
		if not playerPos then
			return nil, nil
		end
		local px = select(1, playerPos:GetXY()) * 100
		return ns.ResolveHubOnMap2576(px), px
	end
	local base = ns.GetBaseZoneName(mid)
	if base ~= "" then
		return base, nil
	end
	return nil, nil
end

local function IsMidnightDelveWaypoint(name, mapID)
	if not name or not mapID then
		return false
	end
	for _, row in ipairs(MIDNIGHT_DELVES) do
		if row[2] == tonumber(mapID) and row[5] == name then
			return true
		end
	end
	return false
end

local function MapHasAncestor(mapID, ancestorID)
	local id = tonumber(mapID)
	local anc = tonumber(ancestorID)
	if not id or not anc then
		return false
	end
	for _ = 1, 10 do
		if id == anc then
			return true
		end
		local info = C_Map.GetMapInfo(id)
		if not info or not info.parentMapID or info.parentMapID == 0 then
			break
		end
		id = info.parentMapID
	end
	return false
end

local function MapsLinkedForTravel(currentMap, targetMap)
	local cur, tgt = tonumber(currentMap), tonumber(targetMap)
	if not cur or not tgt then
		return false
	end
	if cur == tgt then
		return true
	end
	if MapHasAncestor(cur, tgt) or MapHasAncestor(tgt, cur) then
		return true
	end
	if MIDNIGHT_OVERWORLD_MAPS[cur] and MIDNIGHT_OVERWORLD_MAPS[tgt] then
		return true
	end
	return false
end

local function WorldPosToXY(worldPos)
	if not worldPos then
		return nil, nil
	end
	if worldPos.GetXY then
		return worldPos:GetXY()
	end
	return worldPos.x, worldPos.y
end

function ns.GetYardsToMapWaypoint(targetMap, xPct, yPct)
	local playerMap = C_Map.GetBestMapForUnit("player")
	targetMap = tonumber(targetMap)
	xPct, yPct = tonumber(xPct), tonumber(yPct)
	if not playerMap or not targetMap or not xPct or not yPct then
		return math.huge
	end
	local playerPos = C_Map.GetPlayerMapPosition(playerMap, "player")
	if not playerPos then
		return math.huge
	end
	local okT, contT, worldT = pcall(C_Map.GetWorldPosFromMapPos, targetMap, CreateVector2D(xPct / 100, yPct / 100))
	local okP, contP, worldP = pcall(C_Map.GetWorldPosFromMapPos, playerMap, playerPos)
	if not okT or not okP or not worldT or not worldP then
		return math.huge
	end
	if contT and contP and contT ~= contP then
		return math.huge
	end
	local tx, ty = WorldPosToXY(worldT)
	local px, py = WorldPosToXY(worldP)
	if not tx or not ty or not px or not py then
		return math.huge
	end
	local dx, dy = px - tx, py - ty
	return math.sqrt(dx * dx + dy * dy)
end

--- True when navigation to the delve waypoint can stop (at entrance or inside delve).
function ns.IsMidnightTravelComplete(currentMap, targetMap, targetX, targetY, targetName)
	currentMap = tonumber(currentMap)
	targetMap = tonumber(targetMap)
	if not currentMap or not targetMap then
		return false
	end

	if ns.IsPlayerInActiveDelve and ns.IsPlayerInActiveDelve() and IsMidnightDelveWaypoint(targetName, targetMap) then
		return true
	end

	if targetX and targetY and ns.GetYardsToMapWaypoint(targetMap, targetX, targetY) <= TRAVEL_ARRIVAL_YARDS then
		return true
	end

	return false
end

--- Hide Travel Assistant popup without clearing TomTom — same zone/region is not "arrived" yet.
function ns.ShouldSuppressTravelPopup(currentMap, targetMap, targetX, targetY, targetName)
	if ns.IsMidnightTravelComplete(currentMap, targetMap, targetX, targetY, targetName) then
		return true
	end

	currentMap = tonumber(currentMap)
	targetMap = tonumber(targetMap)
	if not currentMap or not targetMap then
		return false
	end

	local currentHub = ns.GetPlayerHubContext(currentMap)
	local targetBase = ns.GetBaseZoneName(targetMap)

	if currentHub and targetBase ~= "" and currentHub == targetBase then
		return true
	end

	local currentZoneName = GetZoneDisplayName(currentMap)
	if targetBase ~= "" and currentZoneName:find(targetBase, 1, true) then
		return true
	end

	if MapsLinkedForTravel(currentMap, targetMap) and currentHub and targetBase ~= "" and currentHub == targetBase then
		return true
	end

	return false
end

-- Ligt het doel op een ANDER continent (losgekoppelde wereldkaart) dan de speler?
-- Zo ja, kan TomTom's pijl geen richting tonen tot je daar bent (Rob 24 jun, Rommath
-- op Isle of Quel'Danas → boss in Harandar). We vergelijken de continent-ID's via
-- GetWorldPosFromMapPos. Beide bekend én gelijk = zelfde continent (TomTom werkt) →
-- false. Anders (verschillend, of doel niet op te lossen) → true = backup zetten.
function ns.IsCrossContinentTarget(currentMap, targetMap, xPct, yPct)
	currentMap = tonumber(currentMap)
	targetMap = tonumber(targetMap)
	if not currentMap or not targetMap or currentMap == targetMap then
		return false
	end
	if not (C_Map and C_Map.GetWorldPosFromMapPos and CreateVector2D) then
		return false
	end
	local function continentOf(map, fx, fy)
		local ok, cont = pcall(C_Map.GetWorldPosFromMapPos, map, CreateVector2D(fx, fy))
		return ok and cont or nil
	end
	local pcx, pcy = 0.5, 0.5
	local pos = C_Map.GetPlayerMapPosition and C_Map.GetPlayerMapPosition(currentMap, "player")
	if pos then
		pcx, pcy = pos:GetXY()
	end
	local curCont = continentOf(currentMap, pcx, pcy)
	local tgtCont = continentOf(targetMap, (tonumber(xPct) or 50) / 100, (tonumber(yPct) or 50) / 100)
	if curCont and tgtCont then
		return curCont ~= tgtCont
	end
	return true
end

-- Is the target on another continent than the PLAYER right now? One shared check so
-- every route (rare routes, world boss, profession treasures) uses the same model for
-- "TomTom's crazy arrow can't point there → use a Blizzard SuperTrack backup instead".
function ns.MHIsCrossContinentFromPlayer(targetMapID, x100, y100)
	local cur = C_Map and C_Map.GetBestMapForUnit and C_Map.GetBestMapForUnit("player")
	return (ns.IsCrossContinentTarget and ns.IsCrossContinentTarget(cur, targetMapID, x100, y100)) or false
end

-- True when two maps are the same zone or one is a sub-area of the other (walks
-- the parentMapID chain both ways). Lets the travel assistant treat a sub-zone of
-- the destination as "arrived" instead of suggesting a portal to get there.
function ns.MHSameZoneOrSub(a, b)
	a, b = tonumber(a), tonumber(b)
	if not a or not b then
		return false
	end
	if a == b then
		return true
	end
	if not (C_Map and C_Map.GetMapInfo) then
		return false
	end
	local function isAncestor(child, ancestor)
		local m, guard = child, 0
		while m and guard < 12 do
			local info = C_Map.GetMapInfo(m)
			if not info or not info.parentMapID or info.parentMapID == 0 then
				return false
			end
			m = info.parentMapID
			if m == ancestor then
				return true
			end
			guard = guard + 1
		end
		return false
	end
	return isAncestor(a, b) or isAncestor(b, a)
end

-- Shared TomTom + Travel Assistant (portals/hearth). Optional skipTravelUI / skipCrazyArrow (bulk pins).
-- travelOnly = re-evaluate the travel assistant ONLY (no waypoint side effects),
-- so a zone-change refresh can update the next-leg portal/HS advice without
-- touching TomTom's arrow.
-- Re-engage TomTom's floating Crazy Arrow on the last crazy waypoint. When a
-- route advances while you're standing on the just-looted target, the arrow can
-- stay stuck in its "arrived" state until you move; this nudges it to re-point.
function ns.ReassertCrazyArrow()
	local uid = ns._mhCrazyArrowUid
	if uid and ns.IsTomTomReady and ns.IsTomTomReady() and _G.TomTom and _G.TomTom.SetCrazyArrow then
		pcall(function()
			_G.TomTom:SetCrazyArrow(uid, 15, ns.lastTarget and ns.lastTarget.name or "Waypoint")
		end)
	end
end

-- clearDist (optional): yards at which TomTom auto-clears the waypoint on arrival
-- (default 15). Pass 0 to keep the arrow on the target until something replaces it
-- — used by the treasure route so the arrow stays on an urn while you fight/loot
-- it, instead of vanishing the moment you get close.
function ns.AddSmartTomTomWay(mapID, x, y, name, skipTravelUI, skipCrazyArrow, travelOnly, clearDist)
	if not mapID then
		return false
	end
	local targetMap = tonumber(mapID)
	local xPct, yPct = tonumber(x), tonumber(y)
	if not targetMap or not xPct or not yPct then
		return false
	end

	local currentMap = C_Map.GetBestMapForUnit("player")
	local title = name and tostring(name) or "Waypoint"
	local currentZoneName = GetZoneDisplayName(currentMap)
	local targetZoneName = GetZoneDisplayName(targetMap)

	ns.lastTarget = { mapID = targetMap, x = xPct, y = yPct, name = title }

	-- 1. Waypoint: TomTom arrow when available, else Blizzard user waypoint + SuperTrack.
	-- Skipped entirely for travelOnly refreshes, so the existing arrow is untouched.
	if not travelOnly then
	if ns.IsTomTomReady() then
		-- Bulk route pins (skipCrazyArrow) must NOT request the crazy arrow:
		-- TomTom auto-points the arrow at the most recently added crazy waypoint,
		-- so leaving crazy=true here would steal the arrow onto the last (farthest)
		-- pin instead of keeping it on the first (nearest) one.
		local uid = _G.TomTom:AddWaypoint(targetMap, xPct / 100, yPct / 100, {
			title = title,
			persistent = false,
			minimap = true,
			world = true,
			cleardistance = clearDist or 15,
			crazy = not skipCrazyArrow,
		})
		if uid and _G.TomTom.SetCrazyArrow and not skipCrazyArrow then
			_G.TomTom:SetCrazyArrow(uid, 15, title)
			ns._mhCrazyArrowUid = uid -- remembered so a route advance can re-arm it
		end
		-- Backup: TomTom's crazy arrow can't point at a target it can't resolve - a
		-- different continent (until you're there) OR a sub-area map that doesn't
		-- accept a waypoint (e.g. Slayer's Rise 2444). In those cases add a Blizzard
		-- waypoint + SuperTrack too; SetBlizzardUserWaypoint resolves a sub-area up to
		-- a waypointable parent. Only for the main route (not bulk pins).
		local subArea = C_Map and C_Map.CanSetUserWaypointOnMap
			and not C_Map.CanSetUserWaypointOnMap(targetMap)
		if not skipCrazyArrow and ns.SetBlizzardUserWaypoint
			and (ns.MHIsCrossContinentFromPlayer(targetMap, xPct, yPct) or subArea) then
			ns.SetBlizzardUserWaypoint(targetMap, xPct, yPct)
		end
	elseif ns.SetBlizzardUserWaypoint then
		ns.SetBlizzardUserWaypoint(targetMap, xPct, yPct)
	end
	-- Single-destination route: take generic ownership so NativeArrow guides even
	-- without TomTom. Also RESET a stale single-dest owner (a previous delve/waypoint
	-- route you never arrived at) so a new route shows the right colour instead of the
	-- old one. Managed routes (rare/treasure/reset/achievement) set their own owner and
	-- are left untouched; the delve buttons set "delve" right after this call.
	local o = ns._mhRouteOwner
	if o == nil or o == "waypoint" or o == "delve" then
		ns._mhRouteOwner = "waypoint"
	end
	end -- not travelOnly

	if not currentMap then
		return true -- mid-loading-screen (portal): skip the travel assistant this pass
	end

	if skipTravelUI then
		return true
	end

	-- ⚠️ THE FLIGHT HINT BELONGS HERE, not only on a {WAY:} click. Rob, 16 aug: standing
	-- in Silvermoon he pointed at a delve on the Coiled Isle and got an arrow reading
	-- "8km 320m away" and nothing else, while both ends have flight masters.
	--
	-- The advice already existed — ReportWaypointResult names the nearest flight point —
	-- but only SetMapWaypoint called it, so a text link got help and every route BUTTON
	-- did not. Same destination, two different answers depending on what you clicked.
	--
	-- It runs before the suppression checks below on purpose. Those exist to stop the
	-- portal/hearthstone popup nagging inside one region, and Silvermoon and the Coiled
	-- Isle sit in the same MIDNIGHT_OVERWORLD_MAPS group — so every one of them says
	-- "no travel help needed" for a trip across the sea. The popup staying quiet is
	-- right; saying nothing at all is not.
	if not travelOnly and ns.ReportTravelHintForWaypoint then
		ns.ReportTravelHintForWaypoint(targetMap, title, xPct, yPct, currentMap)
		-- ...and then actually point there. The line above tells you to fly; without
		-- this the arrow kept aiming at the destination across the water, so the two
		-- halves of the same answer disagreed (Rob, 16 aug, standing in Silvermoon).
		if ns.RouteFirstToFlightPoint then
			ns.RouteFirstToFlightPoint(targetMap, xPct, yPct, title, currentMap)
		end
	end

	if ns.ShouldSuppressTravelPopup(currentMap, targetMap, xPct, yPct, title) then
		SafeHideTravelPopup()
		return true
	end

	-- In a sub-area of the target's zone (e.g. flying through a Zul'Aman sub-zone
	-- like the Altar of Malacrass toward an urn on the main map) you've effectively
	-- arrived — don't nag a portal/HS just because the sub-map id differs.
	if ns.MHSameZoneOrSub and ns.MHSameZoneOrSub(currentMap, targetMap) then
		SafeHideTravelPopup()
		return true
	end

	-- Phase 60: Same continent region — silence travel assistant (no portals, no HS nag).
	local currentHub, px = ns.GetPlayerHubContext(currentMap)
	local currentRegion = ns.GetEffectiveRegionGroupID(currentMap, currentHub)
	local targetRegion = ns.GetRegionGroupID(targetMap)
	if currentMap and targetMap and currentRegion == targetRegion and currentRegion ~= 0 then
		SafeHideTravelPopup()
		return true
	end

	-- 2. Travel Assistant (with Hub Centroid Detection on Map 2576)
	if currentMap and targetMap and tonumber(currentMap) ~= targetMap and currentZoneName ~= targetZoneName then
		local playerPos = C_Map.GetPlayerMapPosition(currentMap, "player")
		if not playerPos then
			return true
		end

		if not px then
			px = select(1, playerPos:GetXY()) * 100
		end
		local py = select(2, playerPos:GetXY()) * 100

		-- ARRIVAL CHECK: only when near waypoint — same zone after a portal still needs the arrow.
		if ns.ShouldSuppressTravelPopup(currentMap, targetMap, xPct, yPct, title) then
			SafeHideTravelPopup()
			return true
		end

		travelPopup.portalBtn:Hide()
		local hsStartTime = GetItemCooldown(6948)
		local portalAdvice, bestDist = "", 9999
		local hubMapID = 2393
		local directPortal, hubPortal = nil, nil

		-- A treasure can sit on a sub-area map (e.g. Slayer's Rise 2444) whose
		-- portal actually lands in the parent zone (Voidstorm 2405). Build the
		-- target's ancestor chain so a portal into the parent zone still counts as
		-- "direct" — otherwise sub-area targets get no portal advice at all.
		local targetChain = { [targetMap] = true }
		if C_Map and C_Map.GetMapInfo then
			local m, guard = targetMap, 0
			while m and guard < 10 do
				local info = C_Map.GetMapInfo(m)
				if not info or not info.parentMapID or info.parentMapID == 0 then
					break
				end
				m = info.parentMapID
				targetChain[m] = true
				guard = guard + 1
			end
		end

		for _, portal in ipairs(MIDNIGHT_PORTALS) do
			local mapMatch = (tonumber(portal.mapID) == tonumber(currentMap))
			local hubMatch = (not portal.zone or (currentHub == portal.zone) or currentZoneName:find(portal.zone))

			if mapMatch and hubMatch and PortalUsable(portal) then
				local dist = math.sqrt((portal.x - px) ^ 2 + (portal.y - py) ^ 2)
				local distYards = math.floor(dist * 45)
				if targetChain[tonumber(portal.toID)] then
					if not directPortal or distYards < directPortal.d then
						directPortal = { p = portal, d = distYards }
					end
				elseif tonumber(portal.toID) == hubMapID and targetMap ~= hubMapID then
					if not hubPortal or distYards < hubPortal.d then
						hubPortal = { p = portal, d = distYards }
					end
				end
			end
		end

		local best = directPortal or hubPortal
		if best then
			travelPopup.portalBtn.mapID, travelPopup.portalBtn.x, travelPopup.portalBtn.y, travelPopup.portalBtn.name = best.p.mapID, best.p.x, best.p.y, best.p.name
			travelPopup.portalBtn:Show()
			portalAdvice, bestDist = string.format("\n|cff00ffffUse: %s (%dyd)|r", best.p.name, best.d), best.d
		end

		hsBtn:ClearAllPoints()
		travelPopup.portalBtn:ClearAllPoints()
		local isNearPortal = (bestDist < 300)
		local isHub = (tonumber(currentMap) == 2393 or tonumber(currentMap) == 2576)
		local isHSVisible = (hsStartTime == 0 and not isHub and not isNearPortal)

		if isHSVisible then
			hsBtn:Show()
		else
			hsBtn:Hide()
		end
		if travelPopup.portalBtn:IsShown() and isHSVisible then
			hsBtn:SetPoint("BOTTOM", travelPopup, "BOTTOM", -50, 15)
			travelPopup.portalBtn:SetPoint("BOTTOM", travelPopup, "BOTTOM", 50, 15)
		elseif travelPopup.portalBtn:IsShown() then
			travelPopup.portalBtn:SetPoint("BOTTOM", travelPopup, "BOTTOM", 0, 15)
		elseif isHSVisible then
			hsBtn:SetPoint("BOTTOM", travelPopup, "BOTTOM", 0, 15)
		end

		if travelPopup.portalBtn:IsShown() or isHSVisible then
			local statusText = (hsStartTime == 0) and "" or "\n|cffff0000HS on Cooldown!|r"
			ns:ShowTravelPopup(targetZoneName, "\n|cffaaaaaaDistance: Very Far|r" .. statusText .. portalAdvice)
		else
			SafeHideTravelPopup()
		end
	end
	return true
end

-- Hybride route (Kaliel's-Tracker-techniek): volgt de LIVE next-waypoint van een
-- quest als die in je log staat (Blizzards eigen objectief-coords, zelf-updatend
-- per stap); valt anders terug op de meegegeven vaste coords. questID mag nil
-- zijn (dan altijd fallback). GetNextWaypoint geeft 0-1 coords; AddSmartTomTomWay
-- verwacht 0-100, dus ×100. Alles pcall-guarded — nooit een fout naar buiten.
function ns.AddSmartQuestRoute(questID, fallbackMapID, fallbackX, fallbackY, name)
	if questID and C_QuestLog and C_QuestLog.GetLogIndexForQuestID and C_QuestLog.GetNextWaypoint then
		local okIdx, idx = pcall(C_QuestLog.GetLogIndexForQuestID, questID)
		if okIdx and idx then
			local okWp, mapID, x, y = pcall(C_QuestLog.GetNextWaypoint, questID)
			-- Only follow the live objective when its map can actually take a waypoint. A quest
			-- objective can sit inside a scenario/instance (a ritual site, delve, ...) that
			-- TomTom/Blizzard cannot place a waypoint on -> that gave NO arrow and NO chat at
			-- all. When the map is not waypointable, fall through to the fallback coords. (Rob 9 jul)
			local objectiveOk = okWp and mapID and x and y
			if objectiveOk and C_Map and C_Map.CanSetUserWaypointOnMap then
				local okC, canPlace = pcall(C_Map.CanSetUserWaypointOnMap, mapID)
				objectiveOk = okC and canPlace == true
			end
			if objectiveOk then
				local label = name
				if C_QuestLog.GetNextWaypointText then
					local okT, t2 = pcall(C_QuestLog.GetNextWaypointText, questID)
					if okT and type(t2) == "string" and t2 ~= "" then
						label = t2
					end
				end
				return ns.AddSmartTomTomWay(mapID, x * 100, y * 100, label or name)
			end
		end
	end
	if fallbackMapID and fallbackX and fallbackY then
		return ns.AddSmartTomTomWay(fallbackMapID, fallbackX, fallbackY, name)
	end
	return false
end

-- Reusable Travel Assistant — the same Hearthstone + best in-world portal advice
-- AddSmartTomTomWay shows, but callable on its own. The dynamic treasure arrow
-- (Profession.lua) calls this when it points at a treasure in a far zone, without
-- re-adding a waypoint. Shows the popup for a far target; hides it when near / in
-- the same region (never nags when the target is on your continent).
function ns.ShowTravelAssistFor(targetMap, xPct, yPct, title)
	targetMap = tonumber(targetMap)
	if not targetMap or not (C_Map and C_Map.GetBestMapForUnit) then
		return
	end
	xPct, yPct = tonumber(xPct), tonumber(yPct)
	title = title or "Waypoint"
	local currentMap = C_Map.GetBestMapForUnit("player")
	if not currentMap then
		return -- mid-loading-screen: map not ready yet (avoids GetMapInfo(nil))
	end
	local currentZoneName = GetZoneDisplayName(currentMap) or ""
	local targetZoneName = GetZoneDisplayName(targetMap) or ""

	if ns.ShouldSuppressTravelPopup(currentMap, targetMap, xPct, yPct, title) then
		SafeHideTravelPopup()
		return
	end

	if ns.MHSameZoneOrSub and ns.MHSameZoneOrSub(currentMap, targetMap) then
		SafeHideTravelPopup() -- in a sub-area of the target's zone = arrived
		return
	end

	local currentHub, px = ns.GetPlayerHubContext(currentMap)
	local currentRegion = ns.GetEffectiveRegionGroupID(currentMap, currentHub)
	local targetRegion = ns.GetRegionGroupID(targetMap)
	if currentMap and currentRegion == targetRegion and currentRegion ~= 0 then
		SafeHideTravelPopup()
		return
	end

	if currentMap and tonumber(currentMap) ~= targetMap and currentZoneName ~= targetZoneName then
		local playerPos = C_Map.GetPlayerMapPosition(currentMap, "player")
		if not playerPos then
			return
		end
		if not px then
			px = select(1, playerPos:GetXY()) * 100
		end
		local py = select(2, playerPos:GetXY()) * 100

		travelPopup.portalBtn:Hide()
		local hsStartTime = GetItemCooldown(6948)
		local portalAdvice, bestDist = "", 9999
		local hubMapID = 2393
		local directPortal, hubPortal = nil, nil

		for _, portal in ipairs(MIDNIGHT_PORTALS) do
			local mapMatch = (tonumber(portal.mapID) == tonumber(currentMap))
			local hubMatch = (not portal.zone or (currentHub == portal.zone) or currentZoneName:find(portal.zone))
			-- Second of the two loops over this table; a gate applied in only one of
			-- them would show the portal in half the situations, which is the worst of
			-- both answers.
			if mapMatch and hubMatch and PortalUsable(portal) then
				local dist = math.sqrt((portal.x - px) ^ 2 + (portal.y - py) ^ 2)
				local distYards = math.floor(dist * 45)
				if tonumber(portal.toID) == targetMap then
					if not directPortal or distYards < directPortal.d then
						directPortal = { p = portal, d = distYards }
					end
				elseif tonumber(portal.toID) == hubMapID and targetMap ~= hubMapID then
					if not hubPortal or distYards < hubPortal.d then
						hubPortal = { p = portal, d = distYards }
					end
				end
			end
		end

		local best = directPortal or hubPortal
		if best then
			travelPopup.portalBtn.mapID, travelPopup.portalBtn.x, travelPopup.portalBtn.y, travelPopup.portalBtn.name = best.p.mapID, best.p.x, best.p.y, best.p.name
			travelPopup.portalBtn:Show()
			portalAdvice, bestDist = string.format("\n|cff00ffffUse: %s (%dyd)|r", best.p.name, best.d), best.d
		end

		hsBtn:ClearAllPoints()
		travelPopup.portalBtn:ClearAllPoints()
		local isNearPortal = (bestDist < 300)
		local isHub = (tonumber(currentMap) == 2393 or tonumber(currentMap) == 2576)
		local isHSVisible = (hsStartTime == 0 and not isHub and not isNearPortal)

		if isHSVisible then
			hsBtn:Show()
		else
			hsBtn:Hide()
		end
		if travelPopup.portalBtn:IsShown() and isHSVisible then
			hsBtn:SetPoint("BOTTOM", travelPopup, "BOTTOM", -50, 15)
			travelPopup.portalBtn:SetPoint("BOTTOM", travelPopup, "BOTTOM", 50, 15)
		elseif travelPopup.portalBtn:IsShown() then
			travelPopup.portalBtn:SetPoint("BOTTOM", travelPopup, "BOTTOM", 0, 15)
		elseif isHSVisible then
			hsBtn:SetPoint("BOTTOM", travelPopup, "BOTTOM", 0, 15)
		end

		if travelPopup.portalBtn:IsShown() or isHSVisible then
			local statusText = (hsStartTime == 0) and "" or "\n|cffff0000HS on Cooldown!|r"
			ns:ShowTravelPopup(targetZoneName, "\n|cffaaaaaaDistance: Very Far|r" .. statusText .. portalAdvice)
		else
			SafeHideTravelPopup()
		end
	end
end

--------------------------------------------------------------------------------
-- Delve POI state via GetDelvesForMap: bountiful flag + per-delve atlas (character map).
-- Matches older MH behavior: scan every map/POI, OR results (duplicate POIs may disagree).
--------------------------------------------------------------------------------
-- 2512 (The Coiled Isle) added 15 Aug 2026 with the two 12.1 delves.
--
-- Not a bug that was breaking them: buildBountifulMapScanOrder puts the delve's OWN map
-- first, so 2512 was already scanned whenever one of those two was the subject. The list
-- matters for the other direction -- scanning from wherever the player happens to be --
-- and an island with two delves on it belongs in it.
--
-- ⚠️ Bountiful state is READ FROM THE CLIENT (atlas / isBountiful / textureIndex on the
-- POI), never assumed, which is why MH showed nothing bountiful during the 11-18 Aug gap
-- week and was right to: the 16 delves /mh atal enumerated on 14 Aug all came back
-- `delves-regular`, not one bountiful. Bountiful returns with Season 2 on 18 Aug.
local MAPS_BOUNTIFUL_SCRAPE = { 2393, 2437, 2395, 2424, 2444, 2413, 2405, 2512 }

-- POI title may be prefixed (e.g. "Bountiful Delve: The Shadow Enclave"); roster stores short name.
-- Also match when Blizz omits "The " or uses a different apostrophe in names like Atal'Aman.
local function normalizeDelveCompare(s)
	local t = string.lower(tostring(s or ""))
	t = t:gsub("’", "'"):gsub("`", "'")
	return t
end

local function delveNameMatchesPoi(poiName, rosterName)
	if not poiName or not rosterName then
		return false
	end
	local pn = normalizeDelveCompare(poiName)
	local needle = normalizeDelveCompare(rosterName)
	if needle == "" then
		return false
	end
	if string.find(pn, needle, 1, true) then
		return true
	end
	local needleNoThe = needle:match("^the%s+(.+)$") or needle
	if needleNoThe ~= needle and needleNoThe ~= "" and string.find(pn, needleNoThe, 1, true) then
		return true
	end
	local afterPrefix = pn:match("^bountiful%s+delve%s*:%s*(.+)$")
		or pn:match("^bountiful%s*:%s*(.+)$")
		or pn:match("^delve%s*:%s*(.+)$")
	if afterPrefix and string.find(afterPrefix, needle, 1, true) then
		return true
	end
	if afterPrefix and needleNoThe ~= "" and string.find(afterPrefix, needleNoThe, 1, true) then
		return true
	end
	local compactP = pn:gsub("%s+", " ")
	local compactN = needle:gsub("%s+", " ")
	if string.find(compactP, compactN, 1, true) then
		return true
	end
	return false
end

local function buildBountifulMapScanOrder(preferredMapID)
	local preferred = tonumber(preferredMapID)
	local seen = {}
	local order = {}
	if preferred and preferred > 0 then
		order[#order + 1] = preferred
		seen[preferred] = true
	end
	for _, z in ipairs(MAPS_BOUNTIFUL_SCRAPE) do
		local zt = tonumber(z)
		if zt and not seen[zt] then
			order[#order + 1] = zt
			seen[zt] = true
		end
	end
	return order
end

local function absorbPoiInfo(isBountiful, bountifulAtlas, bountifulTextureKit, delveAtlas, delveTextureKit, delveTextureIndex, pInfo)
	if not pInfo then
		return isBountiful, bountifulAtlas, bountifulTextureKit, delveAtlas, delveTextureKit, delveTextureIndex
	end
	local atlas = pInfo.atlasName
	local textureKit = pInfo.uiTextureKit
	if atlas and isAtlasBountiful(atlas) then
		isBountiful = true
		bountifulAtlas = bountifulAtlas or atlas
		bountifulTextureKit = bountifulTextureKit or textureKit
	elseif pInfo.isBountiful then
		isBountiful = true
		bountifulAtlas = bountifulAtlas or atlas
		bountifulTextureKit = bountifulTextureKit or textureKit
	elseif tonumber(pInfo.textureIndex) == ICON_TEX_DELVE_BOUNTIFUL_LAST_RESORT then
		isBountiful = true
	elseif atlas and not isAtlasBountiful(atlas) then
		delveAtlas = delveAtlas or atlas
		delveTextureKit = delveTextureKit or textureKit
	elseif pInfo.textureIndex and not delveTextureIndex then
		local ti = tonumber(pInfo.textureIndex)
		if ti and ti ~= ICON_TEX_DELVE_STANDARD then
			delveTextureIndex = ti
		end
	end
	return isBountiful, bountifulAtlas, bountifulTextureKit, delveAtlas, delveTextureKit, delveTextureIndex
end

local function GetDelvePoiState(itemName, mapID, poiRefId)
	if not itemName or not C_AreaPoiInfo or not C_AreaPoiInfo.GetAreaPOIInfo then
		return false, nil, nil, nil, nil, nil
	end
	if not C_AreaPoiInfo.GetDelvesForMap then
		return false, nil, nil, nil, nil, nil
	end

	local isBountiful = false
	local bountifulAtlas = nil
	local bountifulTextureKit = nil
	local delveAtlas = nil
	local delveTextureKit = nil
	local delveTextureIndex = nil
	local refId = tonumber(poiRefId)

	for _, zMap in ipairs(buildBountifulMapScanOrder(mapID)) do
		local okList, delvePOIs = pcall(C_AreaPoiInfo.GetDelvesForMap, zMap)
		local list = (okList and type(delvePOIs) == "table") and delvePOIs or {}
		for _, pID in ipairs(list) do
			local okInfo, pInfo = pcall(C_AreaPoiInfo.GetAreaPOIInfo, zMap, pID)
			if okInfo and pInfo and refId and tonumber(pID) == refId then
				if ns.CacheDelveStoryFromAreaPoi then
					ns.CacheDelveStoryFromAreaPoi(refId, pInfo)
				end
				isBountiful, bountifulAtlas, bountifulTextureKit, delveAtlas, delveTextureKit, delveTextureIndex =
					absorbPoiInfo(isBountiful, bountifulAtlas, bountifulTextureKit, delveAtlas, delveTextureKit, delveTextureIndex, pInfo)
				return isBountiful, bountifulAtlas, bountifulTextureKit, delveAtlas, delveTextureKit, delveTextureIndex
			end
		end
	end

	for _, zMap in ipairs(buildBountifulMapScanOrder(mapID)) do
		local okList, delvePOIs = pcall(C_AreaPoiInfo.GetDelvesForMap, zMap)
		local list = (okList and type(delvePOIs) == "table") and delvePOIs or {}
		for _, pID in ipairs(list) do
			local okInfo, pInfo = pcall(C_AreaPoiInfo.GetAreaPOIInfo, zMap, pID)
			if okInfo and pInfo and pInfo.name and delveNameMatchesPoi(pInfo.name, itemName) then
				isBountiful, bountifulAtlas, bountifulTextureKit, delveAtlas, delveTextureKit, delveTextureIndex =
					absorbPoiInfo(isBountiful, bountifulAtlas, bountifulTextureKit, delveAtlas, delveTextureKit, delveTextureIndex, pInfo)
			end
		end
	end
	return isBountiful, bountifulAtlas, bountifulTextureKit, delveAtlas, delveTextureKit, delveTextureIndex
end

-- POI scans are expensive (GetDelvesForMap per zone); cache per zone until it changes.
local _poiCache = {}
local _poiCacheZoneKey = nil

local function ClearDelvePoiCache()
	wipe(_poiCache)
	_poiCacheZoneKey = nil
end

local function GetDelvePoiCacheZoneKey()
	if C_Map and C_Map.GetBestMapForUnit then
		local ok, z = pcall(C_Map.GetBestMapForUnit, "player")
		if ok and z then
			return z
		end
	end
	return 0
end

local function GetDelvePoiStateCached(itemName, mapID, poiRefId)
	local zk = GetDelvePoiCacheZoneKey()
	if zk ~= _poiCacheZoneKey then
		ClearDelvePoiCache()
		_poiCacheZoneKey = zk
	end
	local key = tostring(mapID or 0) .. "\31" .. tostring(itemName or "") .. "\31" .. tostring(poiRefId or "")
	local hit = _poiCache[key]
	if hit then
		return hit[1], hit[2], hit[3], hit[4], hit[5], hit[6]
	end
	local a, b, c, d, e, f = GetDelvePoiState(itemName, mapID, poiRefId)
	_poiCache[key] = { a, b, c, d, e, f }
	return a, b, c, d, e, f
end

local function GetDelveBountifulState(itemName, mapID)
	local isBountiful, bountifulAtlas = GetDelvePoiState(itemName, mapID)
	return isBountiful, bountifulAtlas
end

function ns.IsDelveBountiful(delveName, mapID)
	return (select(1, GetDelvePoiState(delveName, mapID)))
end

-- Ask the server for currency buckets if the API exists.
local function RequestTrackedCurrencyData()
	if not C_CurrencyInfo then
		return
	end
	local ids = {
		CURRENCY_COFFER_KEY,
		CURRENCY_COFFER_SHARDS,
		CURRENCY_UNDERCOIN,
		CURRENCY_UNTAINTED_MANA_CRYSTALS,
	}
	for _, id in ipairs(ids) do
		if C_CurrencyInfo.RequestCurrencyDataFromServer then
			pcall(C_CurrencyInfo.RequestCurrencyDataFromServer, id)
		end
	end
end

-- Current amount: C_CurrencyInfo.GetCurrencyInfo(id).quantity (Retail CurrencyInfo).
local function GetCurrencyQuantity(currencyID)
	local id = tonumber(currencyID)
	if not id then
		return 0
	end
	if C_CurrencyInfo and C_CurrencyInfo.GetCurrencyInfo then
		local info = C_CurrencyInfo.GetCurrencyInfo(id)
		if info and type(info) == "table" and info.quantity ~= nil then
			return math.floor(tonumber(info.quantity) or 0)
		end
	end
	return 0
end

-- Shards: wallet quantity, weekly earned toward cap, and weekly max (fallback 600).
local function GetShardQuantityAndMax()
	if not C_CurrencyInfo or not C_CurrencyInfo.GetCurrencyInfo then
		return 0, 0, 600
	end
	local info = C_CurrencyInfo.GetCurrencyInfo(CURRENCY_COFFER_SHARDS)
	if not info or type(info) ~= "table" then
		return 0, 0, 600
	end
	local qty = math.floor(tonumber(info.quantity) or 0)
	local earned = math.floor(tonumber(info.quantityEarnedThisWeek) or 0)
	local maxQ = tonumber(info.maxQuantity)
	if not maxQ or maxQ <= 0 then
		maxQ = tonumber(info.maxWeeklyQuantity)
	end
	if not maxQ or maxQ <= 0 then
		maxQ = 600
	end
	return qty, earned, math.floor(maxQ)
end

local function GetZoneDisplayName(mapID)
	local mid = tonumber(mapID)
	if not mid or not C_Map or not C_Map.GetMapInfo then
		return "Unknown zone"
	end
	local info = C_Map.GetMapInfo(mid)
	return (info and info.name) or ("Map " .. tostring(mid))
end

--------------------------------------------------------------------------------
-- UI
--------------------------------------------------------------------------------
local frame
local journeyHeader
local delvesTitle
local currencyHeader
local leftColumn
local rightColumn
local bestBtn
local nearestBtn
local coachBtn
local eventFrame
local midnightToggleBar
local midnightToggleChevron
local midnightToggleLabel
local vaultToggleBar
local vaultToggleChevron
local vaultToggleLabel
local midnightScroll
local midnightScrollChild

local FOOTER_BTN_H = 26
local FOOTER_BTN_H_GAP = 8
local FOOTER_BOTTOM_INSET = 18
local FOOTER_RESERVED = FOOTER_BOTTOM_INSET + FOOTER_BTN_H + 18

local function GetDelvesAccordionSection()
	local u = ns.db and ns.db.ui
	return (u and u.delvesAccordionSection) or "midnight"
end

local function DelvesApplyAccordion()
	if not frame then
		return
	end
	local sec = GetDelvesAccordionSection()
	local showMid = sec == "midnight"
	local showVault = sec == "vault"

	if midnightToggleChevron then
		midnightToggleChevron:SetTexture(
			showMid and "Interface\\Buttons\\UI-MinusButton-Up" or "Interface\\Buttons\\UI-PlusButton-Up"
		)
	end
	if vaultToggleChevron then
		vaultToggleChevron:SetTexture(
			showVault and "Interface\\Buttons\\UI-MinusButton-Up" or "Interface\\Buttons\\UI-PlusButton-Up"
		)
	end

	if journeyHeader then
		journeyHeader:SetShown(showMid)
	end
	if currencyHeader then
		currencyHeader:SetShown(showMid)
	end
	if leftColumn then
		leftColumn:SetShown(showMid)
	end
	if rightColumn then
		rightColumn:SetShown(showMid)
	end
	if frame.journeyHint then
		frame.journeyHint:SetShown(showMid)
	end
	if ns.DelveCurioPanel then
		ns.DelveCurioPanel:SetShown(showMid)
	end
	if midnightScroll then
		midnightScroll:SetShown(showMid)
	end
	if delvesTitle then
		delvesTitle:Hide()
	end
	if ns.vaultPanel then
		ns.vaultPanel:SetShown(showVault)
	end
	if ns.vaultHeader then
		ns.vaultHeader:Hide()
	end
	if midnightToggleBar then
		midnightToggleBar:Show()
	end
	if vaultToggleBar then
		vaultToggleBar:Show()
	end
end

-- Reusable row buttons: Blizzard delve atlases (bountiful vs standard).
local function EnsureDelveRowButton(columnFrame, rows, index, colW)
	local s = (ns.GetContentFontScale and ns.GetContentFontScale()) or 1
	local row = rows[index]
	if not row then
		row = CreateFrame("Button", nil, columnFrame)
		row:SetHeight(TRACKER_ROW_HEIGHT * s)
		row:EnableMouse(true)
		row:SetHighlightTexture("Interface/Buttons/White8x8")
		local ht = row:GetHighlightTexture()
		if ht then
			ht:SetBlendMode("ADD")
			ht:SetAlpha(0.12)
		end

		row:RegisterForClicks("LeftButtonUp", "RightButtonUp")
		row:SetScript("OnClick", function(self, button)
			if button == "LeftButton" or button == "RightButton" then
				RouteToDelveRow(self.mhDelveRow)
			end
		end)

		local iconAnchorX = 4 + ICON_SIZE * 0.5

		local icon = row:CreateTexture(nil, "ARTWORK")
		icon:SetSize(ICON_SIZE, ICON_SIZE)
		icon:SetPoint("CENTER", row, "LEFT", iconAnchorX, 0)
		row.icon = icon

		local slotW = ICON_SIZE
		local fs = row:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
		fs:SetFontObject(ns.MHScalableFont("GameFontNormalSmall"))
		fs:SetPoint("LEFT", row, "LEFT", 4 + slotW + ICON_NAME_GAP, 0)
		fs:SetPoint("RIGHT", row, "RIGHT", -6, 0)
		fs:SetJustifyH("LEFT")
		fs:SetWordWrap(false)
		row.name = fs

		row.routeMark = row:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
		row.routeMark:SetFontObject(ns.MHScalableFont("GameFontNormalSmall"))
		row.routeMark:SetPoint("RIGHT", row, "RIGHT", -4, 0)
		row.routeMark:SetText("|cffffcc00>|r")
		row.routeMark:Hide()

		rows[index] = row
	end
	row:SetWidth(colW)
	-- Rijhoogte en Y-stap blijven synchroon met de tekstschaal (geen overlap).
	row:SetHeight(TRACKER_ROW_HEIGHT * s)
	row:SetPoint("TOPLEFT", columnFrame, "TOPLEFT", 0, -(index - 1) * TRACKER_ROW_HEIGHT * s)
	return row
end

local function ApplyDelveRowVisuals(row, item, _colIdx)
	row.name:SetText(item.name)
	row.mhDelveRow = item

	local isBountiful = item.isBountiful and true or false

	row:SetAlpha(1.0)

	if row.routeBtn then
		row.routeBtn:Hide()
		row.routeBtn:EnableMouse(false)
	end
	if row.routeMark then
		if isBountiful then
			row.routeMark:Show()
			row.name:SetPoint("RIGHT", row.routeMark, "LEFT", -2, 0)
		else
			row.routeMark:Hide()
			row.name:SetPoint("RIGHT", row, "RIGHT", -6, 0)
		end
	end

	if isBountiful then
		row.name:SetTextColor(1, 0.82, 0)
		if tryApplyPoiAtlas(row.icon, item.bountifulAtlas, item.bountifulTextureKit) then
			row.icon:SetVertexColor(1, 1, 1)
		else
			applyDelveRowIcon(row.icon, true, false)
		end
	else
		row.name:SetTextColor(1, 1, 1)
		local iconOk = false
		if item.isNemesisDelve and tryAtlasCandidates(row.icon, ATLAS_DELVE_NEMESIS_CANDIDATES) then
			iconOk = true
		elseif tryApplyPoiAtlas(row.icon, item.delveAtlas, item.delveTextureKit) then
			iconOk = true
		elseif item.delveTextureIndex and tryApplyPoiTextureIndex(row.icon, item.delveTextureIndex) then
			iconOk = true
		elseif tryAtlasCandidates(row.icon, ATLAS_DELVE_STANDARD_CANDIDATES) then
			iconOk = true
		end
		if iconOk then
			row.icon:SetVertexColor(1, 1, 1)
		else
			applyDelveRowIcon(row.icon, false, false)
		end
	end

	local zoneName = GetZoneDisplayName(item.mapID)
	row:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(self, "ANCHOR_CURSOR")
		GameTooltip:ClearLines()
		GameTooltip:AddLine(item.name, 1, 1, 1)
		GameTooltip:AddLine("Zone: " .. zoneName, 1, 1, 1)
		if item.isBountiful then
			GameTooltip:AddLine("Bountiful", 1, 0.82, 0)
		end

		-- 1. Reward list (compact tiers 1–8), or an honest blank once the season turns.
		GameTooltip:AddLine(" ")
		GameTooltip:AddLine("--- Rewards (by tier) ---", 1, 0.82, 0)
		local lootTable = CurrentLootTable()
		if lootTable then
			for t = 1, 8 do
				local loot = lootTable[t]
				if loot then
					GameTooltip:AddDoubleLine(
						"Tier " .. t .. ":",
						string.format("End %d | Vault %d", loot.endChest, loot.vault),
						1,
						1,
						1,
						1,
						1,
						1
					)
				end
			end
		else
			-- Season 2 with nothing measured. Say that, rather than quote Season 1's
			-- numbers at someone who will be handed considerably better loot.
			GameTooltip:AddLine(ns:L("DELVE_REWARDS_UNMEASURED"), 1, 0.5, 0.5, true)
		end

		-- 2. Speed grade (MidnightHelper only; placeholder from quest id)
		local qid = tonumber(item.questID) or 0
		local grades = { "S", "A", "A", "B", "B", "C" }
		local myGrade = grades[(qid % #grades) + 1] or "B"

		GameTooltip:AddLine(" ")
		GameTooltip:AddDoubleLine("|cff00ffffMidnightHelper:|r Speed Grade:", "|cffffcc00" .. myGrade .. "|r")
		GameTooltip:AddLine(" ")
		if item.isBountiful then
			GameTooltip:AddLine(ns:L("DELVES_ROW_ROUTE_BTN"), 1, 0.88, 0.45, true)
			GameTooltip:AddLine(ns:L("DELVES_ROW_TT_LEFTCLICK"), 0.75, 0.75, 0.75, true)
		end
		GameTooltip:AddLine(ns:L("DELVES_ROW_TT_RIGHTCLICK"), 0.75, 0.75, 0.75, true)
		GameTooltip:AddLine(ns:L("DELVES_ROW_TT_TOMTOM"), 0.75, 0.75, 0.75, true)
		GameTooltip:AddLine(ns:L("DELVES_ROW_TT_TRAVEL"), 0.75, 0.75, 0.75, true)
		GameTooltip:Show()
	end)

	row:SetScript("OnLeave", function()
		GameTooltip:Hide()
	end)
end

local function LoadWeeklyRewardsUI()
	pcall(function()
		local isLoaded = C_AddOns and C_AddOns.IsAddOnLoaded
			and C_AddOns.IsAddOnLoaded("Blizzard_WeeklyRewards")
		if isLoaded then
			return
		end
		if C_AddOns and C_AddOns.LoadAddOn then
			C_AddOns.LoadAddOn("Blizzard_WeeklyRewards")
		end
	end)
end

local function _checkDelvesFrames()
	local missing = {}
	if not frame then
		missing[#missing + 1] = "frame"
	end
	if not currencyHeader then
		missing[#missing + 1] = "currencyHeader"
	end
	if not leftColumn then
		missing[#missing + 1] = "leftColumn"
	end
	if not rightColumn then
		missing[#missing + 1] = "rightColumn"
	end
	if not journeyHeader then
		missing[#missing + 1] = "journeyHeader"
	end
	if not delvesTitle then
		missing[#missing + 1] = "delvesTitle"
	end
	return missing
end

--- Delver's Journey standing, read live from the game.
--- @return table|nil { rank=, earned=, needed=, readable= } — nil when unreadable
---
--- No faction id is hardcoded: C_DelvesUI hands us the faction for the CURRENT
--- delve season, so this keeps working in Season 2 without an edit. The season
--- number itself is asked for the same way, defaulting to 1 only when the game
--- will not say.
---
--- nil means "we could not read it", never "you have nothing". A caller that
--- turns nil into rank 0 would be inventing a standing — the season-end checklist
--- shows its generic line instead (see SeasonTransition's "unknown" status).
function ns.GetDelverJourneyStatus()
	if not (C_DelvesUI and C_DelvesUI.GetDelvesFactionForSeason) then
		return nil
	end
	local season = 1
	if C_DelvesUI.GetCurrentDelvesSeasonNumber then
		local okS, sn = pcall(C_DelvesUI.GetCurrentDelvesSeasonNumber)
		if okS and sn ~= nil then
			season = math.floor(tonumber(sn) or 1)
		end
	end
	local okF, factionID = pcall(C_DelvesUI.GetDelvesFactionForSeason, season)
	if not okF or not factionID then
		return nil
	end
	if not (C_MajorFactions and C_MajorFactions.GetMajorFactionData) then
		return nil
	end
	local okD, data = pcall(C_MajorFactions.GetMajorFactionData, factionID)
	if not okD or type(data) ~= "table" or data.renownLevel == nil then
		return nil
	end
	-- Is the track finished? Rob hit rank 10 / 4200-4200 on live while the season-end
	-- checklist still nagged him to go and finish it (2026-07-25). The first version
	-- assumed "a track is never done while the season runs" — it can be, and telling
	-- someone to finish what they already finished is exactly the kind of wrong this
	-- addon must not be.
	--
	-- HasMaximumRenown is the game's own answer, used the same way by EllesmereUI and
	-- three HandyNotes modules. Deliberately no fallback of the form
	-- "earned >= needed": at the cap those two are equal, but mid-track they can
	-- momentarily match too, and guessing "done" is worse than not knowing.
	local maxed = false
	if C_MajorFactions.HasMaximumRenown then
		local okM, hasMax = pcall(C_MajorFactions.HasMaximumRenown, factionID)
		maxed = (okM and hasMax) and true or false
	end
	return {
		rank = math.floor(tonumber(data.renownLevel) or 0),
		earned = math.floor(tonumber(data.renownReputationEarned or data.renownReputationYielded) or 0),
		needed = math.floor(tonumber(data.renownLevelThreshold or data.renownRequirement) or 0),
		maxed = maxed,
		readable = true,
	}
end

-- fullRefresh=false: currencies, vault, layout — skip delve POI row rebuild (main stutter source).
local function PaintDelvesPanel(fullRefresh)
	if fullRefresh == nil then
		fullRefresh = true
	end
	do
		local missing = _checkDelvesFrames()
		if #missing > 0 then
			if MidnightHelperDB and MidnightHelperDB.ui and MidnightHelperDB.ui.debug then
				print("|cffff8888[MH Debug]|r RefreshDelvesPanel: missing frames: " .. table.concat(missing, ", "))
			end
			return
		end
	end

	if midnightToggleLabel then
		midnightToggleLabel:SetText(ns:L("DELVES_ACC_MIDNIGHT"))
	end
	if vaultToggleLabel then
		vaultToggleLabel:SetText(ns:L("DELVES_ACC_VAULT"))
	end
	if bestBtn then
		bestBtn:SetText(ns:L("DELVES_BTN_BOUNTIFUL"))
	end
	if nearestBtn then
		nearestBtn:SetText(ns:L("DELVES_BTN_NEAREST"))
	end
	if coachBtn then
		coachBtn:SetText(ns:L("DELVES_BTN_COACH"))
	end
	if frame and frame.journeyHint then
		frame.journeyHint:SetText(ns:L("DELVES_HINT_SHIFT_J"))
	end

	local accSec = GetDelvesAccordionSection()
	local w = frame:GetWidth() or 0
	if w < 80 then
		w = (ns.mainUI and ns.mainUI:GetWidth()) or 820
	end
	local inner = math.max(400, w - 48)
	local colW = (inner - COL_GAP) / 2

	if ns.MH_LayoutWorldBossDelves then
		ns.MH_LayoutWorldBossDelves(frame, vaultToggleBar)
	end
	if ns.MH_RefreshRaresDelvesBlock then
		ns.MH_RefreshRaresDelvesBlock(frame)
	end

	--------------------------------------------------------------------------------
	-- Great Vault (pinned to top of Delves frame so it stays visible above Midnight / account strip)
	--------------------------------------------------------------------------------
	do
		local parent = frame
		-- Schaal rij-/icoonhoogtes mee met de tekst; de afgeleide panelH en
		-- Y-stappen gebruiken dezelfde (geschaalde) constanten → geen overlap.
		local s = (ns.GetContentFontScale and ns.GetContentFontScale()) or 1
		local VAULT_ICON = 22 * s
		local VAULT_ROW_H = 22 * s
		local VAULT_ROW_GAP = 4 * s
		local VAULT_PAD = 8

		if ns.vaultSepLine then
			ns.vaultSepLine:Hide()
		end
		if ns.vaultHeader then
			ns.vaultHeader:Hide()
		end

		if not ns.vaultPanel then
			ns.vaultPanel = CreateFrame("Frame", nil, parent, "BackdropTemplate")
			ns.vaultPanel:SetBackdrop({
				bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
				edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
				tile = true,
				tileSize = 16,
				edgeSize = 10,
				insets = { left = 4, right = 4, top = 4, bottom = 4 },
			})
			ns.vaultPanel:SetBackdropColor(0, 0, 0, 0.22)
			ns.vaultPanel:SetBackdropBorderColor(0.38, 0.38, 0.38, 0.5)
		elseif ns.vaultPanel:GetParent() ~= parent then
			ns.vaultPanel:SetParent(parent)
		end

		ns.vaultPanel:SetWidth(colW)

		ns.vaultPanel:ClearAllPoints()
		if vaultToggleBar then
			ns.vaultPanel:SetPoint("TOPLEFT", vaultToggleBar, "BOTTOMLEFT", 0, -8)
		elseif ns.vaultHeader then
			ns.vaultPanel:SetPoint("TOPLEFT", ns.vaultHeader, "BOTTOMLEFT", 0, -8)
		else
			ns.vaultPanel:SetPoint("TOPLEFT", parent, "TOPLEFT", 16, -200)
		end

		if not ns.vaultBoxes then
			ns.vaultBoxes = {}
		end

		local rowInnerW = math.max(80, colW - VAULT_PAD * 2)

		for i = 1, 3 do
			local f = ns.vaultBoxes[i]
			if not f then
				f = CreateFrame("Frame", nil, ns.vaultPanel)
				f:SetSize(rowInnerW, VAULT_ROW_H)
				f:EnableMouse(true)

				f.icon = f:CreateTexture(nil, "ARTWORK")
				f.icon:SetSize(VAULT_ICON, VAULT_ICON)
				f.icon:SetPoint("LEFT", f, "LEFT", 0, 0)

				f.text = f:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
				f.text:SetFontObject(ns.MHScalableFont("GameFontHighlightSmall"))
				f.text:SetPoint("LEFT", f.icon, "RIGHT", 5, 0)
				f.text:SetJustifyH("LEFT")

				f:SetScript("OnEnter", function(self)
					GameTooltip:SetOwner(self, "ANCHOR_CURSOR")
					GameTooltip:ClearLines()
					LoadWeeklyRewardsUI()
					local aid = self.activityID
					local usedWeekly = false
					if aid and GameTooltip.SetWeeklyReward then
						usedWeekly = select(1, pcall(GameTooltip.SetWeeklyReward, GameTooltip, aid))
					end
					if usedWeekly then
						GameTooltip:Show()
						return
					end
					if aid and C_WeeklyRewards and C_WeeklyRewards.GetExampleRewardItemHyperlinks then
						local okH, first, second = pcall(C_WeeklyRewards.GetExampleRewardItemHyperlinks, aid)
						local link = okH and (type(first) == "string" and first or (type(second) == "string" and second)) or nil
						if link and GameTooltip.SetHyperlink then
							pcall(GameTooltip.SetHyperlink, GameTooltip, link)
							GameTooltip:Show()
							return
						end
					end
					GameTooltip:SetText(ns:L("DELVES_VAULT_TOOLTIP_MORE"))
					GameTooltip:Show()
				end)
				f:SetScript("OnLeave", function()
					GameTooltip:Hide()
				end)

				ns.vaultBoxes[i] = f
			else
				f:SetParent(ns.vaultPanel)
				f:SetSize(rowInnerW, VAULT_ROW_H)
				pcall(function()
					f:SetBackdrop(nil)
				end)
				f.icon:ClearAllPoints()
				f.icon:SetSize(VAULT_ICON, VAULT_ICON)
				f.icon:SetPoint("LEFT", f, "LEFT", 0, 0)
				f.text:ClearAllPoints()
				f.text:SetPoint("LEFT", f.icon, "RIGHT", 5, 0)
				f.text:SetJustifyH("LEFT")
			end
		end

		local vaultClaimReady = VaultHasClaimableRewards()
		if not ns.vaultClaimLine then
			ns.vaultClaimLine = ns.vaultPanel:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
			ns.vaultClaimLine:SetFontObject(ns.MHScalableFont("GameFontHighlightSmall"))
			ns.vaultClaimLine:SetJustifyH("LEFT")
			ns.vaultClaimLine:SetJustifyV("TOP")
			ns.vaultClaimLine:SetWordWrap(true)
		end
		ns.vaultClaimLine:ClearAllPoints()
		ns.vaultClaimLine:SetWidth(rowInnerW)
		ns.vaultClaimLine:SetPoint("TOPLEFT", ns.vaultPanel, "TOPLEFT", VAULT_PAD, -VAULT_PAD)
		if vaultClaimReady then
			ns.vaultClaimLine:SetText(ns:SafeL("DELVES_VAULT_CLAIM_READY"))
			ns.vaultClaimLine:SetTextColor(1, 0.84, 0.18)
			ns.vaultClaimLine:Show()
		else
			ns.vaultClaimLine:SetText("")
			ns.vaultClaimLine:Hide()
		end

		local claimStripH = 0
		if vaultClaimReady then
			local h = ns.vaultClaimLine:GetStringHeight()
			if not h or h < 1 then
				h = 12
			end
			claimStripH = math.max(52, math.floor(h + 10))
		end

		local vaultPanelH = VAULT_PAD
			+ claimStripH
			+ VAULT_ROW_H
			+ VAULT_ROW_GAP
			+ VAULT_ROW_H
			+ VAULT_ROW_GAP
			+ VAULT_ROW_H
			+ VAULT_PAD

		local firstRowY = -(VAULT_PAD + claimStripH)
		ns.vaultBoxes[1]:ClearAllPoints()
		ns.vaultBoxes[1]:SetPoint("TOPLEFT", ns.vaultPanel, "TOPLEFT", VAULT_PAD, firstRowY)
		for i = 2, 3 do
			ns.vaultBoxes[i]:ClearAllPoints()
			ns.vaultBoxes[i]:SetPoint("TOPLEFT", ns.vaultBoxes[i - 1], "BOTTOMLEFT", 0, -VAULT_ROW_GAP)
		end

		ns.vaultPanel:Show()

		local vaultData = GetVaultProgress()
		for i = 1, 3 do
			local data = vaultData and vaultData[i]
			local box = ns.vaultBoxes[i]
			if data and box then
				box.activityID = data.activityID
				box.unlocked = data.unlocked
				box.level = data.level
				box.ilvl = data.ilvl
				box.progress = data.progress
				box.threshold = data.threshold

				if data.unlocked then
					box.icon:SetSize(22 * s, 22 * s)
					box.icon:SetPoint("LEFT", box, "LEFT", 4, 0)
					box.icon:SetTexture(133784)
					box.text:SetPoint("LEFT", box.icon, "RIGHT", 8, 0)
					box.text:SetText(string.format(ns:L("DELVES_VAULT_TIER"), data.level or 0, data.ilvl or 0))
					box.text:SetTextColor(1, 0.82, 0)
				elseif vaultClaimReady then
					box.icon:SetSize(22 * s, 22 * s)
					box.icon:SetPoint("LEFT", box, "LEFT", 4, 0)
					box.icon:SetTexture(133784)
					box.text:SetPoint("LEFT", box.icon, "RIGHT", 8, 0)
					box.text:SetText(string.format(ns:L("DELVES_VAULT_LOCKED"), data.progress or 0, data.threshold or 0))
					box.text:SetTextColor(0.85, 0.85, 0.85)
				else
					box.icon:SetSize(22 * s, 22 * s)
					box.icon:SetPoint("LEFT", box, "LEFT", 4, 0)
					box.icon:SetTexture(134402)
					box.text:SetPoint("LEFT", box.icon, "RIGHT", 8, 0)
					box.text:SetText(string.format(ns:L("DELVES_VAULT_LOCKED"), data.progress or 0, data.threshold or 0))
					box.text:SetTextColor(0.6, 0.6, 0.6)
				end
				box:Show()
			elseif box then
				box:Hide()
			end
		end

		ns.vaultPanel:SetHeight(vaultPanelH)
	end

	if midnightToggleBar then
		midnightToggleBar:ClearAllPoints()
		midnightToggleBar:SetHeight(22)
		if accSec == "vault" and ns.vaultPanel then
			midnightToggleBar:SetPoint("TOPLEFT", ns.vaultPanel, "BOTTOMLEFT", -6, -12)
			midnightToggleBar:SetPoint("TOPRIGHT", ns.vaultPanel, "BOTTOMRIGHT", -6, -12)
		elseif vaultToggleBar then
			midnightToggleBar:SetPoint("TOPLEFT", vaultToggleBar, "BOTTOMLEFT", 0, -8)
			midnightToggleBar:SetPoint("TOPRIGHT", vaultToggleBar, "BOTTOMRIGHT", 0, -8)
		end
	end

	--------------------------------------------------------------------------------
	-- Phase 17: Companion / portrait / XP bar / curios removed — Delver's Journey only at top.
	--------------------------------------------------------------------------------
	-- Reads through ns.GetDelverJourneyStatus (defined above) so this panel and the
	-- season-end checklist can never disagree about the same rank.
	local journey = ns.GetDelverJourneyStatus()
	if journey and journey.readable then
		journeyHeader:SetText(string.format(ns:L("DELVES_JOURNEY_RANK"),
			journey.rank, journey.earned, journey.needed))
		journeyHeader:SetTextColor(1, 0.95, 0.88)
		journeyHeader:Show()
	else
		journeyHeader:Hide()
	end

	journeyHeader:ClearAllPoints()
	if midnightToggleBar then
		journeyHeader:SetPoint("TOPLEFT", midnightToggleBar, "BOTTOMLEFT", 10, -6)
	else
		journeyHeader:SetPoint("TOPLEFT", frame, "TOPLEFT", 16, -10)
	end
	journeyHeader:SetPoint("RIGHT", frame, "RIGHT", -20, 0)
	journeyHeader:SetJustifyH("LEFT")

	if frame.journeyHint then
		local hintAnchor = journeyHeader
		if not journeyHeader:IsShown() then
			hintAnchor = midnightToggleBar or journeyHeader
		end
		frame.journeyHint:ClearAllPoints()
		frame.journeyHint:SetPoint("TOPLEFT", hintAnchor, "BOTTOMLEFT", 0, -4)
		frame.journeyHint:SetPoint("RIGHT", frame, "RIGHT", -16, 0)
		frame.journeyHint:SetJustifyH("LEFT")
		frame.journeyHint:SetWordWrap(true)
		frame.journeyHint:SetText(ns:L("DELVES_HINT_SHIFT_J"))
	end

	if delvesTitle then
		delvesTitle:Hide()
	end

	RequestTrackedCurrencyData()
	local keyQty = GetCurrencyQuantity(CURRENCY_COFFER_KEY)
	local shardQty, shardEarned, shardMax = GetShardQuantityAndMax()
	local underQty = GetCurrencyQuantity(CURRENCY_UNDERCOIN)
	local manaCrystalQty = GetCurrencyQuantity(CURRENCY_UNTAINTED_MANA_CRYSTALS)

	local bountyCount = 0
	local raidCount = 0
	if C_Item and C_Item.GetItemCount then
		bountyCount = C_Item.GetItemCount(ITEM_TROVEHUNTER_BOUNTY) or 0
		raidCount = C_Item.GetItemCount(ITEM_RAID_R_MINI) or 0
	end

	local extraText = ""
	if bountyCount > 0 then
		extraText = extraText .. string.format("\n|cff00ff00" .. ns:L("DELVES_CURRENCY_BOUNTIES") .. "|r", bountyCount)
	end
	if raidCount > 0 then
		extraText = extraText .. string.format("\n|cff00ffff" .. ns:L("DELVES_CURRENCY_RAID_MINIS") .. "|r", raidCount)
	end

	currencyHeader:SetText(
		string.format(
			ns:L("DELVES_CURRENCY_LINE"),
			keyQty,
			shardQty,
			shardEarned,
			shardMax,
			underQty,
			manaCrystalQty,
			extraText
		)
	)

	currencyHeader:ClearAllPoints()
	local currencyAnchor = frame.journeyHint or journeyHeader
	currencyHeader:SetPoint("TOPLEFT", currencyAnchor, "BOTTOMLEFT", 0, -8)
	currencyHeader:SetPoint("RIGHT", frame, "RIGHT", -20, 0)
	currencyHeader:SetJustifyH("LEFT")
	currencyHeader:SetWordWrap(true)

	local scrollHost = midnightScrollChild or frame
	if midnightScroll then
		midnightScroll:ClearAllPoints()
		midnightScroll:SetPoint("TOPLEFT", currencyHeader, "BOTTOMLEFT", 0, -6)
		midnightScroll:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -28, FOOTER_RESERVED)
	end

	local curioAnchor = scrollHost
	if ns.EnsureDelveCurioPanel then
		local curioPanel = ns.EnsureDelveCurioPanel(scrollHost)
		if curioPanel then
			curioPanel:ClearAllPoints()
			curioPanel:SetPoint("TOPLEFT", scrollHost, "TOPLEFT", 0, 0)
			curioPanel:SetPoint("RIGHT", scrollHost, "RIGHT", 0, 0)
			if ns.RefreshDelveCurioAdvisor then
				ns.RefreshDelveCurioAdvisor()
			end
			curioAnchor = curioPanel
		end
	end
	if leftColumn then
		leftColumn:ClearAllPoints()
		leftColumn:SetPoint("TOPLEFT", curioAnchor, "BOTTOMLEFT", 0, -10)
	end
	if rightColumn and leftColumn then
		rightColumn:ClearAllPoints()
		rightColumn:SetPoint("TOPLEFT", leftColumn, "TOPRIGHT", COL_GAP, 0)
	end

	if leftColumn then
		leftColumn:SetWidth(colW)
	end
	if rightColumn then
		rightColumn:SetWidth(colW)
	end

	if fullRefresh then
	local roster = ns.MIDNIGHT_DELVES or MIDNIGHT_DELVES
	leftColumn.rows = leftColumn.rows or {}
	rightColumn.rows = rightColumn.rows or {}

	local mapDelveAtlasFallback = {}
	for _, packed in ipairs(roster) do
		local _, _, _, da, dtk = GetDelvePoiStateCached(packed[5], packed[2], packed[1])
		if da and not mapDelveAtlasFallback[packed[2]] then
			mapDelveAtlasFallback[packed[2]] = { atlas = da, kit = dtk }
		end
	end

	local usedLeft, usedRight = 0, 0
	for i, packed in ipairs(roster) do
		local bountiful, bountifulAtlas, bountifulTextureKit, delveAtlas, delveTextureKit, delveTextureIndex =
			GetDelvePoiStateCached(packed[5], packed[2], packed[1])
		if packed[5] == DELVE_NEMESIS_NAME and not delveAtlas then
			local fb = mapDelveAtlasFallback[packed[2]]
			if fb then
				delveAtlas = fb.atlas
				delveTextureKit = fb.kit
			end
		end
		local tipEntry = ns.GetDelveTipEntryByRosterName and ns.GetDelveTipEntryByRosterName(packed[5])
		local displayName = packed[5]
		if tipEntry and ns.GetDelveTipDisplayName then
			displayName = ns:GetDelveTipDisplayName(tipEntry)
		end
		local item = {
			questID = packed[1],
			mapID = packed[2],
			x = packed[3],
			y = packed[4],
			name = displayName,
			isNemesisDelve = packed[5] == DELVE_NEMESIS_NAME,
			isBountiful = bountiful,
			bountifulAtlas = bountifulAtlas,
			bountifulTextureKit = bountifulTextureKit,
			delveAtlas = delveAtlas,
			delveTextureKit = delveTextureKit,
			delveTextureIndex = delveTextureIndex,
		}
		local col, colIdx
		if i <= 5 then
			col = leftColumn
			colIdx = i
			usedLeft = colIdx
		else
			col = rightColumn
			colIdx = i - 5
			usedRight = colIdx
		end
		local row = EnsureDelveRowButton(col, col.rows, colIdx, colW)
		ApplyDelveRowVisuals(row, item, colIdx)
		row:Show()
	end

	for j = usedLeft + 1, #leftColumn.rows do
		leftColumn.rows[j]:Hide()
	end
	for j = usedRight + 1, #rightColumn.rows do
		rightColumn.rows[j]:Hide()
	end

	-- Kolomhoogte = #rijen × geschaalde rijhoogte (matcht EnsureDelveRowButton).
	local rowScale = (ns.GetContentFontScale and ns.GetContentFontScale()) or 1
	local h = math.max(usedLeft, usedRight, 1) * TRACKER_ROW_HEIGHT * rowScale
	leftColumn:SetHeight(h)
	rightColumn:SetHeight(h)

	if midnightScroll and midnightScrollChild then
		local curioH = 0
		if ns.DelveCurioPanel and ns.DelveCurioPanel:IsShown() then
			curioH = ns.DelveCurioPanel:GetHeight() or 0
		end
		local listGap = curioH > 0 and 10 or 0
		local contentH = math.max(1, curioH + listGap + h + 6)
		local sw = math.max(200, (midnightScroll:GetWidth() or 0) - 4)
		if sw < 200 and frame then
			sw = math.max(200, (frame:GetWidth() or 400) - 40)
		end
		midnightScrollChild:SetWidth(sw)
		midnightScrollChild:SetHeight(contentH)
		if midnightScroll.UpdateScrollChildRect then
			midnightScroll:UpdateScrollChildRect()
		end
		if midnightScroll.SetVerticalScroll then
			midnightScroll:SetVerticalScroll(0)
		end
	end
	end -- fullRefresh (delve POI rows)

	if frame then
		local fw = math.max(200, frame:GetWidth() or 400)
		local inset = 12
		local bw = math.min(340, math.max(160, fw - inset * 2))
		local function MeasureFooterBtn(btn)
			if not btn then
				return 0
			end
			local btnW = bw
			local fs = btn.GetFontString and btn:GetFontString()
			if fs and fs.GetStringWidth then
				btnW = math.min(bw, math.max(140, fs:GetStringWidth() + 28))
			end
			btn:SetSize(btnW, FOOTER_BTN_H)
			return btnW
		end
		if coachBtn and bestBtn and nearestBtn then
			local wCoach = MeasureFooterBtn(coachBtn)
			local wBest = MeasureFooterBtn(bestBtn)
			local wNear = MeasureFooterBtn(nearestBtn)
			local totalW = wCoach + wBest + wNear + FOOTER_BTN_H_GAP * 2
			local left = math.max(inset, (fw - totalW) / 2)
			coachBtn:ClearAllPoints()
			coachBtn:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", left, FOOTER_BOTTOM_INSET)
			bestBtn:ClearAllPoints()
			bestBtn:SetPoint("BOTTOMLEFT", coachBtn, "BOTTOMRIGHT", FOOTER_BTN_H_GAP, 0)
			nearestBtn:ClearAllPoints()
			nearestBtn:SetPoint("BOTTOMLEFT", bestBtn, "BOTTOMRIGHT", FOOTER_BTN_H_GAP, 0)
		elseif coachBtn and bestBtn then
			local wCoach = MeasureFooterBtn(coachBtn)
			local wBest = MeasureFooterBtn(bestBtn)
			local totalW = wCoach + wBest + FOOTER_BTN_H_GAP
			local left = math.max(inset, (fw - totalW) / 2)
			coachBtn:ClearAllPoints()
			coachBtn:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", left, FOOTER_BOTTOM_INSET)
			bestBtn:ClearAllPoints()
			bestBtn:SetPoint("BOTTOMLEFT", coachBtn, "BOTTOMRIGHT", FOOTER_BTN_H_GAP, 0)
		elseif coachBtn then
			local wCoach = MeasureFooterBtn(coachBtn)
			coachBtn:ClearAllPoints()
			coachBtn:SetPoint("BOTTOM", frame, "BOTTOM", 0, FOOTER_BOTTOM_INSET)
			coachBtn:SetPoint("LEFT", frame, "LEFT", (fw - wCoach) / 2, 0)
		elseif bestBtn then
			local wBest = MeasureFooterBtn(bestBtn)
			bestBtn:ClearAllPoints()
			bestBtn:SetPoint("BOTTOM", frame, "BOTTOM", 0, FOOTER_BOTTOM_INSET)
			bestBtn:SetPoint("LEFT", frame, "LEFT", (fw - wBest) / 2, 0)
		end
	end

	DelvesApplyAccordion()

	-- All statusSlots / Grid refresh logic has been removed here.
end

local function DelvesPanelIsActive()
	if ns.uiSelectedTab and ns.uiSelectedTab ~= "delves" then
		return false
	end
	return ns.DelvesFrame and ns.DelvesFrame.IsVisible and ns.DelvesFrame:IsVisible()
end

do
	-- Coalesce refresh requests: many events (currency/map POIs/quest log) can spam in bursts.
	local pending = false
	local lastAt = 0
	local MIN_INTERVAL = 0.8 -- seconds (Delves UI refresh is heavy; keep it smooth)
	local dirty = false
	local wantFull = false
	local lastMoveAt = 0
	local IDLE_DELAY = 3.0 -- seconds standing still before full (POI) refresh while moving
	local moveWatchFrame

	local function EnsureMoveWatch()
		if moveWatchFrame then
			return
		end
		moveWatchFrame = CreateFrame("Frame")
		moveWatchFrame:RegisterEvent("PLAYER_STARTED_MOVING")
		moveWatchFrame:RegisterEvent("PLAYER_STOPPED_MOVING")
		moveWatchFrame:SetScript("OnEvent", function(_, event)
			local now = (GetTime and GetTime()) or 0
			if event == "PLAYER_STARTED_MOVING" then
				lastMoveAt = now
			elseif event == "PLAYER_STOPPED_MOVING" and dirty and not pending then
				ns.RefreshDelvesPanel()
			end
		end)
	end

	function ns.RefreshDelvesPanel(fullRefresh)
		if fullRefresh ~= false then
			wantFull = true
		end
		dirty = true
		if pending then
			return
		end
		if not DelvesPanelIsActive() then
			return
		end
		EnsureMoveWatch()
		local now = (GetTime and GetTime()) or 0
		local wait = MIN_INTERVAL - (now - (lastAt or 0))
		if wait < 0 then
			wait = 0
		end
		pending = true
		local function run()
			if not DelvesPanelIsActive() then
				pending = false
				return
			end
			if not dirty then
				pending = false
				return
			end
			local now2 = (GetTime and GetTime()) or now
			local doFull = wantFull
			-- Full POI rebuild: defer while moving or shortly after (avoids hitch + timer spam).
			if doFull then
				-- GetUnitSpeed("player") is a SECRET value in delves; comparing it taints
				-- (Rob delve-crash 2026-07-07). Guard with issecretvalue; when it is secret
				-- we skip the move-defer and fall back to the event-driven idle timer below.
				local spd = GetUnitSpeed and GetUnitSpeed("player")
				if spd ~= nil and not (issecretvalue and issecretvalue(spd)) and spd > 0 then
					lastMoveAt = now2
					pending = false
					return
				end
				if (now2 - (lastMoveAt or 0)) < IDLE_DELAY then
					pending = false
					return
				end
			end
			pending = false
			lastAt = (GetTime and GetTime()) or now
			local full = wantFull
			wantFull = false
			dirty = false
			PaintDelvesPanel(full)
		end
		if C_Timer and C_Timer.After and wait > 0 then
			C_Timer.After(wait, run)
		else
			run()
		end
	end
end

function ns.SyncDelvesAccordion(section)
	if not ns.db or not ns.db.ui then
		return
	end
	if section ~= "midnight" and section ~= "vault" then
		return
	end
	ns.db.ui.delvesAccordionSection = section
	if ns._mhAltOverviewAccordionSync then
		ns:_mhAltOverviewAccordionSync()
	end
	if ns.RefreshDelvesPanel then
		ns.RefreshDelvesPanel(true)
	end
end

-- Retail does not ship a global ToggleDelvesDashboard(); macros often assume it exists.
function ns.ToggleDelvesDashboard()
	if not DelvesDashboardFrame and C_AddOns and C_AddOns.IsAddOnLoaded and C_AddOns.LoadAddOn then
		for _, addOnName in ipairs({ "Blizzard_DelvesDashboard", "Blizzard_DelvesDashboardUI" }) do
			if not C_AddOns.IsAddOnLoaded(addOnName) then
				pcall(C_AddOns.LoadAddOn, addOnName)
			end
			if DelvesDashboardFrame then
				break
			end
		end
	end
	if not DelvesDashboardFrame then
		print("|cffffcc00Midnight Helper:|r Delver's Journey UI is not available (dashboard add-on did not load).")
		return
	end
	if DelvesDashboardFrame:IsShown() then
		HideUIPanel(DelvesDashboardFrame)
	else
		ShowUIPanel(DelvesDashboardFrame)
	end
end

if rawget(_G, "ToggleDelvesDashboard") == nil then
	_G.ToggleDelvesDashboard = ns.ToggleDelvesDashboard
end

-- Forward-declared so the bountiful button can share the distance scan defined
-- below (after the world-coord helpers).
local RouteNearestDelve

local function OnFindNearestBountifulClick()
	RouteNearestDelve(true)
end

-- Convert a map position (0..1) to continent world coords (yards). Returns
-- continentID + wx,wy so callers can compare distances only between points on
-- the same continent (cross-continent world coords aren't comparable).
local function DelveMapPosToWorld(mapID, xPct, yPct)
	if not (C_Map and C_Map.GetWorldPosFromMapPos and CreateVector2D) then
		return nil
	end
	-- pcall yields (ok, continentID, worldPosition).
	local ok, continentID, world = pcall(C_Map.GetWorldPosFromMapPos, mapID, CreateVector2D(xPct, yPct))
	if ok and type(world) == "table" then
		local wx, wy
		if world.GetXY then
			wx, wy = world:GetXY()
		else
			wx, wy = world.x, world.y
		end
		if type(wx) == "number" and type(wy) == "number" then
			return continentID, wx, wy
		end
	end
	return nil
end

local function GetPlayerContinentWorld()
	if not (C_Map and C_Map.GetBestMapForUnit and C_Map.GetPlayerMapPosition) then
		return nil
	end
	local pmap = C_Map.GetBestMapForUnit("player")
	if not pmap then
		return nil
	end
	local okPos, pos = pcall(C_Map.GetPlayerMapPosition, pmap, "player")
	if not (okPos and type(pos) == "table") then
		return nil
	end
	local px, py
	if pos.GetXY then
		px, py = pos:GetXY()
	else
		px, py = pos.x, pos.y
	end
	if not (px and py) then
		return nil
	end
	return DelveMapPosToWorld(pmap, px, py)
end

-- Route to the closest Midnight delve, measured in world yards on the player's
-- continent. With bountifulOnly, only bountiful delves are considered (fixes the
-- old bug where the bountiful button returned the FIRST bountiful in roster order
-- instead of the nearest). Falls back to the first eligible delve if world coords
-- can't be resolved, so the button always does something.
function RouteNearestDelve(bountifulOnly)
	local pCont, pwx, pwy = GetPlayerContinentWorld()
	local bestData, bestDist, fallback

	for _, row in ipairs(MIDNIGHT_DELVES) do
		local mapID, x, yPct, name = row[2], row[3], row[4], row[5]
		if (not bountifulOnly) or select(1, GetDelveBountifulState(name, mapID)) then
			fallback = fallback or { mapID = mapID, x = x, y = yPct, name = name }
			if pwx and pwy then
				local cont, wx, wy = DelveMapPosToWorld(mapID, (x or 0) / 100, (yPct or 0) / 100)
				if wx and wy and (not pCont or not cont or cont == pCont) then
					local dx, dy = wx - pwx, wy - pwy
					local dist = dx * dx + dy * dy
					if not bestDist or dist < bestDist then
						bestDist = dist
						bestData = { mapID = mapID, x = x, y = yPct, name = name }
					end
				end
			end
		end
	end

	local target = bestData or fallback
	if not target then
		print(
			bountifulOnly and "|cffffff78Midnight Helper:|r No bountiful delve found right now."
				or "|cffffff78Midnight Helper:|r No delve found."
		)
		return
	end
	if ns.AddSmartTomTomWay(target.mapID, target.x, target.y, target.name) then
		ns._mhRouteOwner = "delve" -- claim the shared on-screen arrow
		print(string.format(ns:L(bountifulOnly and "DELVES_BOUNTIFUL_ROUTE" or "DELVES_NEAREST_ROUTE"), tostring(target.name)))
	end
end

local function OnFindNearestDelveClick()
	RouteNearestDelve(false)
end

local function CreateEventBridge()
	if eventFrame then
		return
	end
	eventFrame = CreateFrame("Frame", nil, UIParent)
	eventFrame:Hide()
	eventFrame:RegisterEvent("ADDON_LOADED")
	eventFrame:RegisterEvent("PLAYER_LOGIN")
	eventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
	eventFrame:RegisterEvent("CURRENCY_DISPLAY_UPDATE")
	eventFrame:RegisterEvent("MAJOR_FACTION_RENOWN_LEVEL_CHANGED")
	eventFrame:RegisterEvent("TRAIT_CONFIG_UPDATED")
	eventFrame:RegisterEvent("WEEKLY_REWARDS_UPDATE")
	eventFrame:RegisterEvent("ZONE_CHANGED_NEW_AREA")
	eventFrame:SetScript("OnEvent", function(_, event, ...)
		if event == "ZONE_CHANGED_NEW_AREA" then
			ClearDelvePoiCache()
		end
		if event == "ZONE_CHANGED_NEW_AREA" or event == "PLAYER_ENTERING_WORLD" then
			-- Wait 1 second for the Map API to settle before checking location
			local function runZoneNavCheck()
				local currentMap = C_Map.GetBestMapForUnit("player")
				if ns.lastTarget and currentMap then
					local lt = ns.lastTarget
					if ns.IsMidnightTravelComplete(currentMap, lt.mapID, lt.x, lt.y, lt.name) then
						SafeHideTravelPopup()
						ns.lastTarget = nil
					else
						-- After portal / zone: restore delve arrow (TomTom only, no travel popup).
						local function restoreDelveArrow()
							if not ns.lastTarget then
								return
							end
							local t = ns.lastTarget
							if ns.IsTomTomReady() then
								local uid = _G.TomTom:AddWaypoint(t.mapID, t.x / 100, t.y / 100, {
									title = t.name,
									persistent = false,
									minimap = true,
									world = true,
									cleardistance = 15,
									crazy = true,
								})
								if uid and _G.TomTom.SetCrazyArrow then
									_G.TomTom:SetCrazyArrow(uid, 15, t.name)
								end
							elseif ns.SetBlizzardUserWaypoint then
								ns.SetBlizzardUserWaypoint(t.mapID, t.x, t.y)
							end
						end
						restoreDelveArrow()
						if C_Timer and C_Timer.After then
							C_Timer.After(0.5, restoreDelveArrow)
						end
					end
				end
			end
			if C_Timer and C_Timer.After then
				C_Timer.After(1, runZoneNavCheck)
			else
				runZoneNavCheck()
			end
			RequestTrackedCurrencyData()
		end
		local wantsRefresh = (event == "CURRENCY_DISPLAY_UPDATE")
			or (event == "WEEKLY_REWARDS_UPDATE")
			or (event == "MAJOR_FACTION_RENOWN_LEVEL_CHANGED")
			or (event == "TRAIT_CONFIG_UPDATED")
			or (event == "ZONE_CHANGED_NEW_AREA")
			or (event == "PLAYER_ENTERING_WORLD")
		if (not wantsRefresh) or not DelvesPanelIsActive() then
			return
		end

		local fullRefresh = event ~= "CURRENCY_DISPLAY_UPDATE"
		-- Mana / currency: refresh next frame so GetCurrencyInfo sees server-updated quantities.
		if event == "CURRENCY_DISPLAY_UPDATE" then
			if C_Timer and C_Timer.After then
				C_Timer.After(0, function()
					if DelvesPanelIsActive() and ns.RefreshDelvesPanel then
						ns.RefreshDelvesPanel(false)
					end
				end)
			elseif ns.RefreshDelvesPanel then
				ns.RefreshDelvesPanel(false)
			end
		elseif ns.RefreshDelvesPanel then
			ns.RefreshDelvesPanel(fullRefresh)
		end
	end)
end

local function SetupDelvesModule()
	if frame then
		return
	end

	local panel = ns.panels and ns.panels.delves
	if not panel then
		return
	end

	if panel._body then
		panel._body:Hide()
	end
	-- Redundant with sidebar tab "Delves & Vault" + in-frame "Midnight Delves" title.
	if panel._header then
		panel._header:Hide()
	end

	frame = CreateFrame("Frame", "MidnightHelperDelvesFrame", panel)
	frame:SetAllPoints(panel)

	vaultToggleBar = CreateFrame("Button", nil, frame)
	vaultToggleBar:SetHeight(22)
	if ns.MH_LayoutWorldBossDelves then
		ns.MH_LayoutWorldBossDelves(frame, vaultToggleBar)
	else
		vaultToggleBar:SetPoint("TOPLEFT", frame, "TOPLEFT", 6, -3)
		vaultToggleBar:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -6, -3)
	end

	vaultToggleChevron = vaultToggleBar:CreateTexture(nil, "ARTWORK")
	vaultToggleChevron:SetSize(16, 16)
	vaultToggleChevron:SetPoint("LEFT", vaultToggleBar, "LEFT", 4, 0)

	vaultToggleLabel = vaultToggleBar:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	vaultToggleLabel:SetFontObject(ns.MHScalableFont("GameFontNormal"))
	vaultToggleLabel:SetPoint("LEFT", vaultToggleChevron, "RIGHT", 6, 0)
	vaultToggleLabel:SetPoint("RIGHT", vaultToggleBar, "RIGHT", -8, 0)
	vaultToggleLabel:SetJustifyH("LEFT")
	vaultToggleLabel:SetText(ns:L("DELVES_ACC_VAULT"))

	do
		vaultToggleBar:SetHighlightTexture("Interface\\Buttons\\White8x8")
		local ht = vaultToggleBar:GetHighlightTexture()
		if ht then
			ht:SetBlendMode("ADD")
			ht:SetAlpha(0.08)
		end
	end

	vaultToggleBar:SetScript("OnClick", function()
		ns.SyncDelvesAccordion("vault")
	end)

	midnightToggleBar = CreateFrame("Button", nil, frame)
	midnightToggleBar:SetHeight(22)
	midnightToggleBar:SetPoint("TOPLEFT", vaultToggleBar, "BOTTOMLEFT", 0, -8)
	midnightToggleBar:SetPoint("TOPRIGHT", vaultToggleBar, "BOTTOMRIGHT", 0, -8)

	if ns.MH_RefreshRaresDelvesBlock then
		ns.MH_RefreshRaresDelvesBlock(frame)
	end

	midnightToggleChevron = midnightToggleBar:CreateTexture(nil, "ARTWORK")
	midnightToggleChevron:SetSize(16, 16)
	midnightToggleChevron:SetPoint("LEFT", midnightToggleBar, "LEFT", 4, 0)

	midnightToggleLabel = midnightToggleBar:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	midnightToggleLabel:SetFontObject(ns.MHScalableFont("GameFontNormal"))
	midnightToggleLabel:SetPoint("LEFT", midnightToggleChevron, "RIGHT", 6, 0)
	midnightToggleLabel:SetPoint("RIGHT", midnightToggleBar, "RIGHT", -8, 0)
	midnightToggleLabel:SetJustifyH("LEFT")
	midnightToggleLabel:SetText(ns:L("DELVES_ACC_MIDNIGHT"))

	do
		midnightToggleBar:SetHighlightTexture("Interface\\Buttons\\White8x8")
		local ht = midnightToggleBar:GetHighlightTexture()
		if ht then
			ht:SetBlendMode("ADD")
			ht:SetAlpha(0.08)
		end
	end

	midnightToggleBar:SetScript("OnClick", function()
		ns.SyncDelvesAccordion("midnight")
	end)

	journeyHeader = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
	journeyHeader:SetFontObject(ns.MHScalableFont("GameFontNormalSmall"))
	journeyHeader:SetPoint("TOPLEFT", midnightToggleBar, "BOTTOMLEFT", 10, -6)
	journeyHeader:SetPoint("RIGHT", frame, "RIGHT", -20, 0)
	journeyHeader:SetJustifyH("LEFT")
	journeyHeader:SetWordWrap(true)
	journeyHeader:Hide()

	delvesTitle = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlightLarge")
	delvesTitle:SetFontObject(ns.MHScalableFont("GameFontHighlightLarge"))
	delvesTitle:SetText(ns:L("DELVES_TITLE"))
	delvesTitle:Hide()

	currencyHeader = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	currencyHeader:SetFontObject(ns.MHScalableFont("GameFontNormal"))
	currencyHeader:SetJustifyH("LEFT")
	currencyHeader:SetWordWrap(true)

	midnightScroll = CreateFrame("ScrollFrame", "MH_MidnightDelvesScroll", frame, "UIPanelScrollFrameTemplate")
	midnightScrollChild = CreateFrame("Frame", nil, midnightScroll)
	midnightScroll:SetScrollChild(midnightScrollChild)
	midnightScroll:EnableMouseWheel(true)
	midnightScroll:SetPoint("TOPLEFT", currencyHeader, "BOTTOMLEFT", 0, -6)
	midnightScroll:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -28, FOOTER_RESERVED)

	if ns.EnsureDelveCurioPanel then
		ns.EnsureDelveCurioPanel(midnightScrollChild)
	end

	leftColumn = CreateFrame("Frame", nil, midnightScrollChild)
	rightColumn = CreateFrame("Frame", nil, midnightScrollChild)
	leftColumn:EnableMouse(false)
	rightColumn:EnableMouse(false)
	leftColumn.rows = {}
	rightColumn.rows = {}

	coachBtn = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
	coachBtn:SetSize(340, 26)
	coachBtn:SetText(ns:L("DELVES_BTN_COACH"))
	coachBtn:SetScript("OnClick", function()
		if ns.OpenDelveCoachPicker then
			ns:OpenDelveCoachPicker()
		else
			print(("|cffffcc00%s|r Delve Coach module not loaded."):format(ns:L("PRINT_PREFIX")))
		end
	end)

	bestBtn = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
	bestBtn:SetSize(340, 26)
	bestBtn:SetText(ns:L("DELVES_BTN_BOUNTIFUL"))
	bestBtn:SetScript("OnClick", OnFindNearestBountifulClick)

	nearestBtn = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
	nearestBtn:SetSize(340, 26)
	nearestBtn:SetText(ns:L("DELVES_BTN_NEAREST"))
	nearestBtn:SetScript("OnClick", OnFindNearestDelveClick)

	-- Delver's Journey Hint (Phase 57 / 59)
	if not frame.journeyHint then
		frame.journeyHint = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
		frame.journeyHint:SetFontObject(ns.MHScalableFont("GameFontNormalSmall"))
		frame.journeyHint:SetJustifyH("LEFT")
		frame.journeyHint:SetWordWrap(true)
	end

	if frame.statusGrid then
		frame.statusGrid:Hide()
		frame.statusGrid = nil
	end
	if frame.journeyBtn then
		frame.journeyBtn:Hide()
		frame.journeyBtn = nil
	end

	-- Footer + scroll layout refreshed in RefreshDelvesPanel.

	frame:SetScript("OnShow", function()
		RequestTrackedCurrencyData()
		if ns.RefreshDelvesPanel then
			ns.RefreshDelvesPanel(true)
		else
			PaintDelvesPanel(true)
		end
	end)

	local sizePending = false
	frame:SetScript("OnSizeChanged", function()
		if not DelvesPanelIsActive() then
			return
		end
		if sizePending then
			return
		end
		sizePending = true
		if C_Timer and C_Timer.After then
			C_Timer.After(0.2, function()
				sizePending = false
				if DelvesPanelIsActive() and ns.RefreshDelvesPanel then
					ns.RefreshDelvesPanel(false)
				end
			end)
		else
			sizePending = false
			if ns.RefreshDelvesPanel then
				ns.RefreshDelvesPanel(false)
			end
		end
	end)

	CreateEventBridge()
	ns.DelvesFrame = frame
end

local function RefreshGreatVaultPanel()
	if DelvesPanelIsActive() and ns.RefreshDelvesPanel then
		ns.RefreshDelvesPanel(false)
	end
end

ns.RefreshGreatVaultPanel = RefreshGreatVaultPanel

local function HookEnsureMainUI()
	if ns._mhDelvesEnsureHooked then
		return
	end
	ns._mhDelvesEnsureHooked = true

	local orig = ns.EnsureMainUI
	function ns:EnsureMainUI(...)
		local main = orig(self, ...)
		SetupDelvesModule()
		if ns.RefreshDelvesPanel then
			ns.RefreshDelvesPanel(true)
		end
		return main
	end
end

HookEnsureMainUI()

do
	local orig = ns.RefreshLocaleUI
	function ns:RefreshLocaleUI()
		if orig then
			orig(self)
		end
		if ns.RefreshDelvesPanel then
			ns.RefreshDelvesPanel(true)
		end
	end
end

--------------------------------------------------------------------------------
-- Travel Assistant popup (secure Hearthstone; must be created at load)
--------------------------------------------------------------------------------
travelPopup = CreateFrame("Frame", "MH_TravelPopup", UIParent, "BackdropTemplate")
travelPopup:SetSize(220, 140) -- Increased height from 110 to 140
travelPopup:SetPoint("CENTER")
travelPopup:SetFrameStrata("TOOLTIP")
travelPopup:Hide()

tinsert(UISpecialFrames, travelPopup:GetName())

travelPopup:SetBackdrop({
	bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
	edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
	tile = true,
	tileSize = 32,
	edgeSize = 32,
	insets = { left = 8, right = 8, top = 8, bottom = 8 },
})
travelPopup:SetBackdropColor(0, 0, 0, 0.9)

travelPopup.text = travelPopup:CreateFontString(nil, "OVERLAY", "GameFontNormal")
travelPopup.text:SetFontObject(ns.MHScalableFont("GameFontNormal"))
travelPopup.text:SetPoint("TOP", 0, -15)
travelPopup.text:SetWidth(200)
travelPopup.text:SetText(ns:L("TRAVEL_WRONG_ZONE"))

-- The Secure Hearthstone Icon Button
hsBtn = CreateFrame("Button", "MidnightHelperHSClick", travelPopup, "SecureActionButtonTemplate")
hsBtn:SetSize(40, 40)

local icon = hsBtn:CreateTexture(nil, "ARTWORK")
icon:SetAllPoints()
icon:SetTexture(134414)
hsBtn.icon = icon

hsBtn:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Square", "ADD")

hsBtn:SetAttribute("type", "macro")
-- item:6948 = Hearthstone; item ID works on every client locale, the English
-- item name only matches on enUS/enGB.
hsBtn:SetAttribute("macrotext", "/use item:6948")
hsBtn:RegisterForClicks("AnyUp", "AnyDown")

hsBtn:SetScript("PostClick", function()
	print("|cffffcc00Midnight Helper:|r Hearthstone used!")
	SafeHideTravelPopup()
end)

hsBtn:ClearAllPoints()
hsBtn:SetPoint("BOTTOM", travelPopup, "BOTTOM", 0, 15)

-- The Portal Waypoint Button
local portalBtn = CreateFrame("Button", nil, travelPopup, "UIPanelButtonTemplate")
portalBtn:SetSize(40, 40)
portalBtn:SetPoint("LEFT", hsBtn, "RIGHT", 15, 0)
portalBtn:Hide()

local pIcon = portalBtn:CreateTexture(nil, "ARTWORK")
pIcon:SetAllPoints()
pIcon:SetTexture(132369)
portalBtn.icon = pIcon

portalBtn:SetScript("OnClick", function(self)
	if self.mapID and self.x and self.y then
		if ns.IsTomTomReady() then
			local titleStr = "|cff00ffff[Portal]|r " .. tostring(self.name)

			local uid = _G.TomTom:AddWaypoint(self.mapID, self.x / 100, self.y / 100, {
				title = titleStr,
				persistent = false,
				arrivaldistance = 15,
				crazy = true,
			})

			if uid and _G.TomTom.SetCrazyArrow then
				_G.TomTom:SetCrazyArrow(uid, 15, titleStr)
			end

			print("|cffffcc00Midnight Helper:|r Portal arrow focused. Delve arrow will resume after you zone.")
			SafeHideTravelPopup()
		elseif ns.SetBlizzardUserWaypoint and ns.SetBlizzardUserWaypoint(self.mapID, self.x, self.y) then
			print(
				("|cffffcc00%s|r %s"):format(
					ns:L("PRINT_PREFIX"),
					ns:L("BLIZZARD_WAYPOINT_PORTAL"):format(tostring(self.name or "Portal"))
				)
			)
			SafeHideTravelPopup()
		else
			print(ns:L("TOMTOM_MISSING"))
		end
	end
end)

travelPopup.portalBtn = portalBtn

-- The Mage Teleport button: cast Teleport: Silvermoon City (Midnight hub spell
-- 1259190) straight to the Bazaar. Shown only for mages who know it and aren't
-- already in the Silvermoon region (decided in ShowTravelPopup). macrotext uses
-- the spell's LOCALIZED name, set out of combat in ShowTravelPopup (locale-safe).
local MAGE_TELEPORT_SMC = 1259190
local mageBtn = CreateFrame("Button", "MidnightHelperMageTeleBtn", travelPopup, "SecureActionButtonTemplate")
mageBtn:SetSize(40, 40)
mageBtn:Hide()
local mIcon = mageBtn:CreateTexture(nil, "ARTWORK")
mIcon:SetAllPoints()
mIcon:SetTexture((C_Spell and C_Spell.GetSpellTexture and C_Spell.GetSpellTexture(MAGE_TELEPORT_SMC)) or 132369)
mageBtn.icon = mIcon
mageBtn:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Square", "ADD")
mageBtn:SetAttribute("type", "macro")
mageBtn:RegisterForClicks("AnyUp", "AnyDown")
mageBtn:SetPoint("BOTTOM", travelPopup, "BOTTOM", 0, 60) -- own row above HS/portal
mageBtn:SetScript("PostClick", function()
	print("|cffffcc00Midnight Helper:|r Teleporting to Silvermoon City...")
	SafeHideTravelPopup()
end)
travelPopup.mageBtn = mageBtn

-- Portal: Silvermoon City (group portal, Midnight spell 1259194, lvl 88).
local MAGE_PORTAL_SMC = 1259194
local magePortalBtn = CreateFrame("Button", "MidnightHelperMagePortalBtn", travelPopup, "SecureActionButtonTemplate")
magePortalBtn:SetSize(40, 40)
magePortalBtn:Hide()
local mpIcon = magePortalBtn:CreateTexture(nil, "ARTWORK")
mpIcon:SetAllPoints()
mpIcon:SetTexture((C_Spell and C_Spell.GetSpellTexture and C_Spell.GetSpellTexture(MAGE_PORTAL_SMC)) or 132369)
magePortalBtn.icon = mpIcon
magePortalBtn:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Square", "ADD")
magePortalBtn:SetAttribute("type", "macro")
magePortalBtn:RegisterForClicks("AnyUp", "AnyDown")
magePortalBtn:SetScript("PostClick", function()
	print("|cffffcc00Midnight Helper:|r Opening a portal to Silvermoon City...")
	SafeHideTravelPopup()
end)
travelPopup.magePortalBtn = magePortalBtn

local function MageSpellName(spellID)
	if C_Spell and C_Spell.GetSpellName then
		return C_Spell.GetSpellName(spellID)
	end
	if GetSpellInfo then
		return (GetSpellInfo(spellID))
	end
	return nil
end

function ns:ShowTravelPopup(targetMapName, extraInfo)
	if InCombatLockdown() then
		return
	end

	--- ⚠️ NEVER INSIDE AN INSTANCE. Rob, 17 aug: standing in a delve, he clicked a
	--- waypoint and was offered a Hearthstone and a Mage portal to Silvermoon.
	---
	--- This is the one travel suggestion that can cost something. Every other one
	--- wastes a walk; this one ends the delve he was in the middle of, and the button
	--- sits under the cursor he just clicked with. Travel planning is for deciding
	--- where to go next, which is not a question you have inside a locked instance.
	---
	--- The waypoint itself is still set — it is waiting for him when he comes out.
	--- Only the offer to leave is withheld.
	if IsInInstance then
		local ok, inInstance = pcall(IsInInstance)
		if ok and inInstance then
			return
		end
	end
	local extra = extraInfo or ""
	if not ns.IsTomTomReady() then
		extra = extra .. ns:L("TRAVEL_BLIZZARD_WAYPOINT_HINT")
	end

	-- Mage hub spells to Silvermoon: Teleport (self) and Portal (group). Offer
	-- whichever you know when you're not already in the hub region.
	local showTele, showPortal = false, false
	if select(2, UnitClass("player")) == "MAGE" then
		local cm = C_Map and C_Map.GetBestMapForUnit and C_Map.GetBestMapForUnit("player")
		local reg = (cm and ns.GetRegionGroupID and ns.GetRegionGroupID(cm)) or 0
		if reg ~= 1 and type(IsPlayerSpell) == "function" then
			if IsPlayerSpell(MAGE_TELEPORT_SMC) then
				local n = MageSpellName(MAGE_TELEPORT_SMC)
				if n then
					mageBtn:SetAttribute("macrotext", "/cast " .. n)
					extra = extra .. ("\n|cff69ccf0Mage: %s|r"):format(n)
					showTele = true
				end
			end
			if IsPlayerSpell(MAGE_PORTAL_SMC) then
				local n = MageSpellName(MAGE_PORTAL_SMC)
				if n then
					magePortalBtn:SetAttribute("macrotext", "/cast " .. n)
					extra = extra .. ("\n|cff69ccf0Mage: %s|r"):format(n)
					showPortal = true
				end
			end
		end
	end
	mageBtn:ClearAllPoints()
	magePortalBtn:ClearAllPoints()
	if showTele and showPortal then
		mageBtn:SetPoint("BOTTOM", travelPopup, "BOTTOM", -25, 60)
		magePortalBtn:SetPoint("BOTTOM", travelPopup, "BOTTOM", 25, 60)
	elseif showTele then
		mageBtn:SetPoint("BOTTOM", travelPopup, "BOTTOM", 0, 60)
	elseif showPortal then
		magePortalBtn:SetPoint("BOTTOM", travelPopup, "BOTTOM", 0, 60)
	end
	mageBtn:SetShown(showTele)
	magePortalBtn:SetShown(showPortal)

	-- ⚠️ TEXT FIRST, THEN HEIGHT. The height used to be set here, before the text
	-- existed, from a fixed 140 (or 200 with mage buttons). The text hangs from the
	-- TOP and the buttons from the BOTTOM, so a line too many walks straight into
	-- the portal icon -- which is what Rob saw on 2026-07-28: "(ESC to cancel)" with
	-- a button sitting on top of it, at five lines of text.
	--
	-- Same fault and same fix as MidnightToast on 2026-07-25. A panel whose content
	-- can grow cannot have a constant height; measure what the font string actually
	-- rendered (GetStringHeight is post-wrap) and grow to fit.
	travelPopup.text:SetText(
		string.format(
			"%s\n|cff888888(%s)|r",
			string.format(ns:L("TRAVEL_POPUP_TARGET"), targetMapName, extra),
			ns:L("TRAVEL_POPUP_ESC")
		)
	)

	-- The button rows are anchored to the bottom: one row occupies 15..55, and the
	-- mage row above it 60..100. Reserve that, plus a gap, plus the top padding.
	local TOP_PAD, GAP = 15, 12
	local buttonZone = (showTele or showPortal) and 105 or 60
	local base = (showTele or showPortal) and 200 or 140
	-- Dot to TEST for the method, colon to CALL it. `obj:Method and ...` is a syntax
	-- error, not a nil-check, and luac catches it -- which it just did.
	local textH = 0
	if travelPopup.text.GetStringHeight then
		textH = travelPopup.text:GetStringHeight() or 0
	end
	travelPopup:SetHeight(math.max(base, TOP_PAD + math.ceil(textH) + GAP + buttonZone))

	travelPopup:Show()
end
