--[[
	Midnight Helper — Great Vault Advisor (phase 1).
	Scores vault item choices via C_WeeklyRewards + item links (no internet).
]]

local _, ns = ...

local function VL(key, ...)
	local fmt = (ns.SafeL and ns:SafeL(key)) or ns:L(key)
	if select("#", ...) > 0 then
		return string.format(fmt, ...)
	end
	return fmt
end

local REWARD_ITEM_TYPE = (Enum and Enum.CachedRewardType and Enum.CachedRewardType.Item) or 1
local ILVL_WEIGHT = (ns.VAULT_ADVISOR_ILVL_WEIGHT or 8)
local MIN_GEAR_ILVL = 200
local PAWN_ILVL_WEIGHT = 2

local function GetVaultAdvisorSettings()
	local ui = ns.db and ns.db.ui
	if type(ui) ~= "table" then
		return { usePawn = true, profileMode = "auto" }
	end
	if type(ui.vaultAdvisor) ~= "table" then
		ui.vaultAdvisor = { usePawn = true, profileMode = "auto" }
	end
	return ui.vaultAdvisor
end

function ns.GetVaultAdvisorSettings()
	return GetVaultAdvisorSettings()
end

function ns.SetVaultAdvisorOption(key, value)
	local s = GetVaultAdvisorSettings()
	if key == "usePawn" then
		s.usePawn = value and true or false
	elseif key == "profileMode" then
		if value == "raid" or value == "mplus" or value == "auto" then
			s.profileMode = value
		end
	end
end

local function IsPawnAvailable()
	return PawnGetItemData ~= nil and PawnGetSingleValueFromItem ~= nil
end

local function ShouldUsePawn()
	local s = GetVaultAdvisorSettings()
	if s.usePawn == false then
		return false
	end
	return IsPawnAvailable()
end

local function GetPawnScaleName()
	if PawnUICurrentScale and PawnCommon and PawnCommon.Scales and PawnCommon.Scales[PawnUICurrentScale] then
		return PawnUICurrentScale
	end
	if PawnGetAllScalesEx then
		for _, scaleData in pairs(PawnGetAllScalesEx()) do
			if scaleData and scaleData.IsVisible and scaleData.Name then
				return scaleData.Name
			end
		end
	end
	return nil
end

local function GetPawnItemScore(link)
	if not ShouldUsePawn() or not link then
		return nil
	end
	local scaleName = GetPawnScaleName()
	if not scaleName then
		return nil
	end
	local item = PawnGetItemData(link)
	if not item then
		return nil
	end
	if PawnRecalculateItemValuesIfNecessary then
		PawnRecalculateItemValuesIfNecessary(item, true)
	end
	local value = PawnGetSingleValueFromItem(item, scaleName)
	if value == nil then
		return nil
	end
	return tonumber(value) or 0, scaleName
end

local advisorPanel
local choiceRows = {}
local blizzardVaultBanner
local lastScanKey
local pendingRescan = false

local function ScheduleRescan()
	if pendingRescan then
		return
	end
	pendingRescan = true
	if C_Timer and C_Timer.After then
		C_Timer.After(0.35, function()
			pendingRescan = false
			if ns.RefreshDelvesPanel then
				ns.RefreshDelvesPanel()
			end
			if ns.RefreshReferenceGuidePanel then
				ns.RefreshReferenceGuidePanel()
			end
			if ns.RefreshBlizzardVaultBanner then
				ns.RefreshBlizzardVaultBanner()
			end
		end)
	else
		pendingRescan = false
	end
end

local EQUIP_LOC_SLOTS = {
	INVTYPE_HEAD = { 1 },
	INVTYPE_NECK = { 2 },
	INVTYPE_SHOULDER = { 3 },
	INVTYPE_BODY = { 4 },
	INVTYPE_CHEST = { 5 },
	INVTYPE_ROBE = { 5 },
	INVTYPE_WAIST = { 6 },
	INVTYPE_LEGS = { 7 },
	INVTYPE_FEET = { 8 },
	INVTYPE_WRIST = { 9 },
	INVTYPE_HAND = { 10 },
	INVTYPE_FINGER = { 11, 12 },
	INVTYPE_TRINKET = { 13, 14 },
	INVTYPE_CLOAK = { 15 },
	INVTYPE_WEAPON = { 16, 17 },
	INVTYPE_2HWEAPON = { 16 },
	INVTYPE_WEAPONMAINHAND = { 16 },
	INVTYPE_WEAPONOFFHAND = { 17 },
	INVTYPE_HOLDABLE = { 17 },
	INVTYPE_SHIELD = { 17 },
	INVTYPE_RANGED = { 16 },
	INVTYPE_RANGEDRIGHT = { 16 },
}

local function ResolveContentProfile(activityHints)
	local s = GetVaultAdvisorSettings()
	local mode = s.profileMode or "auto"
	if mode == "raid" then
		return "raid"
	end
	if mode == "mplus" then
		return "mplus"
	end
	if activityHints and activityHints.dungeon and not activityHints.raid then
		return "mplus"
	end
	if activityHints and activityHints.dungeon then
		return "mplus"
	end
	return "raid"
end

local function ApplyProfileSuffix(base, profile)
	if profile == "mplus" then
		local mplusKey = base .. "_MPLUS"
		if ns.VAULT_ADVISOR_SPEC_WEIGHTS and ns.VAULT_ADVISOR_SPEC_WEIGHTS[mplusKey] then
			return mplusKey
		end
	end
	return base
end

local function GetActivityCategoryKey(activityType)
	local t = tonumber(activityType)
	if ns.VAULT_ADVISOR_ACTIVITY_TYPES and t then
		return ns.VAULT_ADVISOR_ACTIVITY_TYPES[t] or "other"
	end
	return "other"
end

local function CollectActivityProfileHints()
	local hints = { dungeon = false, raid = false, world = false }
	if not C_WeeklyRewards or not C_WeeklyRewards.GetActivities then
		return hints
	end
	local ok, activities = pcall(C_WeeklyRewards.GetActivities)
	if not ok or type(activities) ~= "table" then
		return hints
	end
	for a = 1, #activities do
		local activity = activities[a]
		local rewards = activity and activity.rewards
		if type(rewards) == "table" and #rewards > 0 then
			local cat = GetActivityCategoryKey(activity.type)
			if cat == "dungeon" then
				hints.dungeon = true
			elseif cat == "raid" then
				hints.raid = true
			elseif cat == "world" then
				hints.world = true
			end
		end
	end
	return hints
end

local function GetSpecWeightKey(activityHints)
	local classID = select(3, UnitClass("player"))
	local specIndex = GetSpecialization and GetSpecialization()
	if not classID or not specIndex then
		return nil
	end
	local specID = GetSpecializationInfo(specIndex)
	if not specID then
		return nil
	end
	local classFile = select(2, UnitClass("player"))
	if not classFile then
		return nil
	end
	local base = ApplyProfileSuffix(("%s_%d"):format(classFile, specID), ResolveContentProfile(activityHints))

	-- Hero talent overrides when we have a matching entry (e.g. Enhancement Totemic vs Stormbringer).
	if C_ClassTalents and C_ClassTalents.GetActiveHeroTalentSpec then
		local ok, heroID = pcall(C_ClassTalents.GetActiveHeroTalentSpec)
		heroID = ok and tonumber(heroID) or nil
		if heroID then
			local heroKey = ("%s_HERO_%d"):format(base:gsub("_MPLUS$", ""), heroID)
			if ns.VAULT_ADVISOR_SPEC_WEIGHTS and ns.VAULT_ADVISOR_SPEC_WEIGHTS[heroKey] then
				return heroKey
			end
			-- Elemental/Enhancement base keys without profile suffix for hero trees.
			local plainBase = ("%s_%d"):format(classFile, specID)
			heroKey = ("%s_HERO_%d"):format(plainBase, heroID)
			if ns.VAULT_ADVISOR_SPEC_WEIGHTS and ns.VAULT_ADVISOR_SPEC_WEIGHTS[heroKey] then
				return heroKey
			end
		end
	end

	return base
end

local function GetSpecWeights(activityHints)
	local key = GetSpecWeightKey(activityHints or CollectActivityProfileHints())
	if not key then
		return nil, nil
	end
	local weights = ns.VAULT_ADVISOR_SPEC_WEIGHTS and ns.VAULT_ADVISOR_SPEC_WEIGHTS[key]
	if not weights and key:match("_HERO_%d+$") then
		local base = key:gsub("_HERO_%d+$", "")
		weights = ns.VAULT_ADVISOR_SPEC_WEIGHTS and ns.VAULT_ADVISOR_SPEC_WEIGHTS[base]
		if weights then
			key = base
		end
	end
	return weights, key
end

local function GetSpecWeightMeta(weightKey)
	if not weightKey or not ns.VAULT_ADVISOR_SPEC_META then
		return nil
	end
	return ns.VAULT_ADVISOR_SPEC_META[weightKey]
end

local function GetGuideStatHint(weightKey, pawnScaleName)
	local meta = GetSpecWeightMeta(weightKey)
	local parts = {}
	if pawnScaleName and ShouldUsePawn() then
		parts[#parts + 1] = VL("VAULT_ADVISOR_PAWN_FMT", pawnScaleName)
	elseif meta then
		if meta.priorityText and meta.priorityText ~= "" then
			parts[#parts + 1] = meta.priorityText
		end
		if meta.sources and meta.sources ~= "" then
			parts[#parts + 1] = VL("VAULT_ADVISOR_SOURCE_FMT", meta.sources, meta.patch or "?")
		end
	end
	if weightKey and weightKey:find("_MPLUS$") and #parts > 0 then
		parts[#parts + 1] = VL("VAULT_ADVISOR_PROFILE_MPLUS")
	end
	if #parts == 0 then
		return nil
	end
	return table.concat(parts, " — ")
end

local function GetGenericRoleWeights()
	-- Generic fallback when we do not have curated per-spec weights yet.
	-- These are intentionally conservative and only influence secondary stats;
	-- ilvl still dominates via ILVL_WEIGHT.
	local role = GetSpecializationRole and GetSpecializationRole(GetSpecialization and GetSpecialization() or 0)
	if role == "HEALER" then
		return { haste = 1.0, crit = 0.9, mastery = 0.85, vers = 0.75 }, "GENERIC_HEALER"
	elseif role == "TANK" then
		return { mastery = 1.0, vers = 0.95, haste = 0.85, crit = 0.75 }, "GENERIC_TANK"
	end
	return { haste = 1.0, crit = 0.95, mastery = 0.9, vers = 0.75 }, "GENERIC_DPS"
end

local function GetActiveHeroTalentLabel()
	if not C_ClassTalents or not C_ClassTalents.GetActiveHeroTalentSpec then
		return nil, nil
	end
	local ok, heroID = pcall(C_ClassTalents.GetActiveHeroTalentSpec)
	heroID = ok and tonumber(heroID) or nil
	if not heroID then
		return nil, nil
	end
	local names = ns.VAULT_ADVISOR_HERO_NAMES
	if names and names[heroID] then
		return names[heroID], heroID
	end
	return nil, heroID
end

local function MakeDeltaTag(c)
	if not c or c.ilvlDelta == nil then
		return ""
	end
	if c.ilvlDelta > 0 then
		return " " .. VL("VAULT_ADVISOR_TAG_ILVL_FMT", c.ilvlDelta)
	elseif c.ilvlDelta < 0 then
		return " " .. VL("VAULT_ADVISOR_TAG_ILVL_DOWN_FMT", c.ilvlDelta)
	end
	return ""
end

local function LoadWeeklyRewardsUI()
	pcall(function()
		if C_AddOns and C_AddOns.LoadAddOn then
			if not (C_AddOns.IsAddOnLoaded and C_AddOns.IsAddOnLoaded("Blizzard_WeeklyRewards")) then
				C_AddOns.LoadAddOn("Blizzard_WeeklyRewards")
			end
		end
		if WeeklyRewardsFrame and not WeeklyRewardsFrame._mhVaultAdvisorHook then
			WeeklyRewardsFrame._mhVaultAdvisorHook = true
			WeeklyRewardsFrame:HookScript("OnShow", function()
				if C_Timer and C_Timer.After then
					C_Timer.After(0.05, function()
						if ns.RefreshBlizzardVaultBanner then
							pcall(ns.RefreshBlizzardVaultBanner)
						end
					end)
				else
					if ns.RefreshBlizzardVaultBanner then
						pcall(ns.RefreshBlizzardVaultBanner)
					end
				end
				ScheduleRescan()
			end)
			WeeklyRewardsFrame:HookScript("OnHide", function()
				if blizzardVaultBanner then
					blizzardVaultBanner:Hide()
				end
			end)
		end
	end)
end

local function EnsureBlizzardVaultBanner()
	LoadWeeklyRewardsUI()
	if not WeeklyRewardsFrame then
		return nil
	end
	if blizzardVaultBanner and blizzardVaultBanner:GetParent() == WeeklyRewardsFrame then
		return blizzardVaultBanner
	end

	local f = CreateFrame("Frame", "MidnightHelperVaultAdvisorBanner", WeeklyRewardsFrame, "BackdropTemplate")
	f:SetFrameStrata("DIALOG")
	f:SetFrameLevel((WeeklyRewardsFrame:GetFrameLevel() or 0) + 20)
	if ns.ApplyMidnightDialogBackdrop then
		ns.ApplyMidnightDialogBackdrop(f)
	end
	f:SetPoint("TOPLEFT", WeeklyRewardsFrame, "TOPLEFT", 20, -54)
	f:SetPoint("TOPRIGHT", WeeklyRewardsFrame, "TOPRIGHT", -20, -54)

	f._title = f:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
	f._title:SetPoint("TOPLEFT", f, "TOPLEFT", 10, -8)
	f._title:SetPoint("TOPRIGHT", f, "TOPRIGHT", -10, -8)
	f._title:SetJustifyH("LEFT")
	f._title:SetWordWrap(true)
	f._title:SetTextColor(1, 0.9, 0.55)

	f._hint = f:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	f._hint:SetPoint("TOPLEFT", f._title, "BOTTOMLEFT", 0, -3)
	f._hint:SetPoint("TOPRIGHT", f._title, "BOTTOMRIGHT", 0, -3)
	f._hint:SetJustifyH("LEFT")
	f._hint:SetWordWrap(true)
	f._hint:SetTextColor(0.78, 0.76, 0.72)

	f._best = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	f._best:SetPoint("TOPLEFT", f._hint, "BOTTOMLEFT", 0, -4)
	f._best:SetPoint("TOPRIGHT", f._hint, "BOTTOMRIGHT", 0, -4)
	f._best:SetJustifyH("LEFT")
	f._best:SetWordWrap(true)
	f._best:SetTextColor(0.35, 1, 0.45)

	f._alt = f:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	f._alt:SetPoint("TOPLEFT", f._best, "BOTTOMLEFT", 0, -3)
	f._alt:SetPoint("TOPRIGHT", f._best, "BOTTOMRIGHT", 0, -3)
	f._alt:SetJustifyH("LEFT")
	f._alt:SetWordWrap(true)
	f._alt:SetTextColor(0.88, 0.86, 0.82)

	f._tier = f:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
	f._tier:SetPoint("TOPLEFT", f._alt, "BOTTOMLEFT", 0, -3)
	f._tier:SetPoint("TOPRIGHT", f._alt, "BOTTOMRIGHT", 0, -3)
	f._tier:SetJustifyH("LEFT")
	f._tier:SetWordWrap(true)
	f._tier:SetTextColor(1, 0.85, 0.2)

	f._token = f:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	f._token:SetPoint("TOPLEFT", f._tier, "BOTTOMLEFT", 0, -3)
	f._token:SetPoint("TOPRIGHT", f._tier, "BOTTOMRIGHT", 0, -3)
	f._token:SetJustifyH("LEFT")
	f._token:SetWordWrap(true)
	f._token:SetTextColor(0.75, 0.72, 0.65)

	blizzardVaultBanner = f
	return f
end

local function LayoutBlizzardVaultBanner(banner)
	local padTop, padBottom, padX = 8, 8, 10
	local h = padTop
		+ (banner._title:GetStringHeight() or 12)
		+ 3
		+ (banner._hint:GetStringHeight() or 0)
		+ 4
		+ (banner._best:GetStringHeight() or 14)
	if banner._alt:IsShown() then
		h = h + 3 + (banner._alt:GetStringHeight() or 0)
	end
	if banner._tier:IsShown() then
		h = h + 3 + (banner._tier:GetStringHeight() or 0)
	end
	if banner._token:IsShown() then
		h = h + 3 + (banner._token:GetStringHeight() or 0)
	end
	h = h + padBottom
	banner:SetHeight(math.max(48, h))
	return h
end

function ns.RefreshBlizzardVaultBanner()
	local banner = EnsureBlizzardVaultBanner()
	if not banner or not WeeklyRewardsFrame or not WeeklyRewardsFrame:IsShown() then
		if banner then
			banner:Hide()
		end
		return
	end

	local weights, weightKey = GetSpecWeights()
	if not weights then
		weights, weightKey = GetGenericRoleWeights()
	end
	local gear, token, status = ns.ScanVaultAdvisorChoices(weights, weightKey)

	local specIndex = GetSpecialization and GetSpecialization()
	local _, specName = GetSpecializationInfo(specIndex)
	local heroLabel = GetActiveHeroTalentLabel()
	local displaySpec = specName or "?"
	if heroLabel then
		displaySpec = ("%s (%s)"):format(displaySpec, heroLabel)
	end
	banner._title:SetText(VL("VAULT_ADVISOR_TITLE_FMT", displaySpec))

	if status == "loading" then
		banner._hint:SetText("")
		banner._best:SetText(VL("VAULT_ADVISOR_HINT_LOADING"))
		banner._best:SetTextColor(0.9, 0.85, 0.7)
		banner._alt:Hide()
		banner._tier:Hide()
		banner._token:Hide()
		banner:Show()
		LayoutBlizzardVaultBanner(banner)
		ScheduleRescan()
		return
	end

	if status == "empty" or not gear or #gear == 0 then
		banner:Hide()
		return
	end

	local pawnScale = ShouldUsePawn() and GetPawnScaleName() or nil
	local guideHint = GetGuideStatHint(weightKey, pawnScale)
	if guideHint then
		banner._hint:SetText(guideHint)
		banner._hint:Show()
	else
		banner._hint:SetText("")
		banner._hint:Hide()
	end

	local best = gear[1]
	local tags = {}
	if best.ownedDuplicate then
		tags[#tags + 1] = VL("VAULT_ADVISOR_TAG_UNIQUE_WARN")
	end
	tags[#tags + 1] = MakeDeltaTag(best)
	if best.ilvlDelta and best.ilvlDelta < 0 then
		tags[#tags + 1] = VL("VAULT_ADVISOR_TAG_DOWNGRADE")
	end
	local tagStr = (#tags > 0) and ("  " .. table.concat(tags, " ")) or ""
	banner._best:SetText(VL("VAULT_ADVISOR_BEST_FMT", best.name or "?", best.ilvl or 0, tagStr))
	banner._best:SetTextColor(0.35, 1, 0.45)

	local altLines = {}
	for i = 2, math.min(#gear, 4) do
		local c = gear[i]
		local cat = CategoryLabel(c.categoryKey)
		local warn = c.ownedDuplicate and (" " .. VL("VAULT_ADVISOR_TAG_UNIQUE_SHORT")) or ""
		local statBits = FormatStatLine(c.stats)
		local line = ("%d. %s (%s, ilvl %d)%s%s"):format(i, c.name or "?", cat, c.ilvl or 0, MakeDeltaTag(c), warn)
		if statBits ~= "" then
			line = line .. " — " .. statBits
		end
		altLines[#altLines + 1] = line
	end
	if #altLines > 0 then
		banner._alt:SetText(table.concat(altLines, "\n"))
		banner._alt:Show()
	else
		banner._alt:SetText("")
		banner._alt:Hide()
	end

	local tierAlt = FindTierSetWarningCandidate(gear)
	if tierAlt then
		banner._tier:SetText(BuildTierWarningText(tierAlt))
		banner._tier:Show()
	else
		banner._tier:SetText("")
		banner._tier:Hide()
	end

	if token then
		banner._token:SetText(VL("VAULT_ADVISOR_TOKEN_NOTE_FMT", token.name or "?"))
		banner._token:Show()
	else
		banner._token:SetText("")
		banner._token:Hide()
	end

	banner:Show()
	LayoutBlizzardVaultBanner(banner)
end

local function RequestItemDataForLink(link, itemID)
	itemID = itemID or GetItemIDFromLink(link)
	if not itemID or not C_Item or not C_Item.RequestLoadItemDataByID then
		return
	end
	pcall(C_Item.RequestLoadItemDataByID, itemID)
end

local function IsItemDataCached(itemID)
	if not itemID or not C_Item or not C_Item.IsItemDataCachedByID then
		return true
	end
	local ok, cached = pcall(C_Item.IsItemDataCachedByID, itemID)
	return ok and cached == true
end

local function ResolveItemLink(reward)
	if not reward then
		return nil
	end
	if reward.itemDBID and C_WeeklyRewards and C_WeeklyRewards.GetItemHyperlink then
		local ok, link = pcall(C_WeeklyRewards.GetItemHyperlink, reward.itemDBID)
		if ok and type(link) == "string" and link ~= "" then
			return link
		end
	end
	local id = tonumber(reward.id)
	if id and C_Item and C_Item.GetItemLinkByID then
		local ok, link = pcall(C_Item.GetItemLinkByID, id)
		if ok and type(link) == "string" and link ~= "" then
			return link
		end
	end
	return nil
end

local function GetItemIDFromLink(link)
	if not link then
		return nil
	end
	local id = link:match("item:(%d+)")
	return id and tonumber(id) or nil
end

local function GetItemStatsFromLink(link)
	if not link or not C_Item or not C_Item.GetItemStats then
		return {}
	end
	local ok, stats = pcall(C_Item.GetItemStats, link)
	if not ok or type(stats) ~= "table" then
		return {}
	end
	return {
		mastery = stats.ITEM_MOD_MASTERY_RATING_SHORT or 0,
		crit = stats.ITEM_MOD_CRIT_RATING_SHORT or 0,
		haste = stats.ITEM_MOD_HASTE_RATING_SHORT or 0,
		vers = stats.ITEM_MOD_VERSATILITY or stats.ITEM_MOD_VERSATILITY_SHORT or 0,
		intellect = stats.ITEM_MOD_INTELLECT_SHORT or 0,
	}
end

local function GetItemLevelFromLink(link)
	if not link then
		return 0, false
	end
	if Item and Item.CreateFromItemLink then
		local ok, item = pcall(Item.CreateFromItemLink, link)
		if ok and item then
			if item.IsItemEmpty and item:IsItemEmpty() then
				return 0, false
			end
			if item.GetCurrentItemLevel then
				local okIlvl, ilvl = pcall(item.GetCurrentItemLevel, item)
				if okIlvl and ilvl and ilvl > 0 then
					return tonumber(ilvl) or 0, true
				end
			end
		end
	end
	if C_Item and C_Item.GetDetailedItemLevelInfo then
		local ok, ilvl = pcall(C_Item.GetDetailedItemLevelInfo, link, true)
		if ok and ilvl and ilvl > 0 then
			return tonumber(ilvl) or 0, true
		end
		ok, ilvl = pcall(C_Item.GetDetailedItemLevelInfo, link)
		if ok and ilvl and ilvl > 0 then
			return tonumber(ilvl) or 0, true
		end
	end
	return 0, false
end

local function IsVaultItemDataReady(link, itemID)
	itemID = itemID or GetItemIDFromLink(link)
	if itemID and not IsItemDataCached(itemID) then
		RequestItemDataForLink(link, itemID)
		return false
	end
	local ilvl, resolved = GetItemLevelFromLink(link)
	if not resolved or ilvl < MIN_GEAR_ILVL then
		RequestItemDataForLink(link, itemID)
		return false
	end
	return true
end

local function InferTierSetFromItemName(name)
	if not name or name == "" then
		return nil
	end
	if name:find("Voidbreaker", 1, true) then
		return "Voidbreaker's Accord"
	end
	return nil
end

local function GetEquipLoc(link)
	if not link or not C_Item or not C_Item.GetItemInfoInstant then
		return nil
	end
	local ok, _, _, _, equipLoc = pcall(C_Item.GetItemInfoInstant, link)
	if ok and equipLoc and equipLoc ~= "" then
		return equipLoc
	end
	return nil
end

local function GetItemName(link)
	if not link then
		return "?"
	end
	if C_Item and C_Item.GetItemInfo then
		local ok, name = pcall(C_Item.GetItemInfo, link)
		if ok and name and name ~= "" then
			return name
		end
	end
	return link:match("%[(.-)%]") or "?"
end

local function ScanTooltipLines(link, visitor)
	if not link or not C_TooltipInfo or not C_TooltipInfo.GetHyperlink or not visitor then
		return
	end
	local ok, data = pcall(C_TooltipInfo.GetHyperlink, link)
	if not ok or type(data) ~= "table" or type(data.lines) ~= "table" then
		return
	end
	for i = 1, #data.lines do
		local line = data.lines[i]
		local text = line and (line.leftText or line.rightText)
		if type(text) == "string" and text ~= "" then
			if visitor(text, line) then
				return
			end
		end
	end
end

local function ScanTooltipSetProgress(link)
	local setName, cur, total
	ScanTooltipLines(link, function(text)
		local name, have, need = text:match("^(.-)%s*%((%d+)/(%d)%)$")
		if name and have and need then
			local nNeed = tonumber(need) or 0
			if nNeed >= 2 and nNeed <= 8 then
				setName = name:match("^%s*(.-)%s*$")
				cur = tonumber(have) or 0
				total = nNeed
				return true
			end
		end
	end)
	return setName, cur, total
end

local function GetItemSetIDFromLink(link)
	if not link or not C_Item or not C_Item.GetItemInfo then
		return 0
	end
	local ok, _, _, _, _, _, _, _, _, _, _, _, _, _, _, setID = pcall(C_Item.GetItemInfo, link)
	if ok and setID then
		return tonumber(setID) or 0
	end
	return 0
end

local function GetItemSetMeta(link)
	local setID = GetItemSetIDFromLink(link)
	local setName, setEquipped, setTotal

	if setID > 0 and C_Item.GetItemSetInfo then
		local ok, name, _, _, numSlots, _, _, numEquipped = pcall(C_Item.GetItemSetInfo, setID)
		if ok and type(name) == "string" and name ~= "" then
			setName = name
			setTotal = tonumber(numSlots) or 0
			setEquipped = tonumber(numEquipped) or 0
		end
	end

	local tipName, tipCur, tipTotal = ScanTooltipSetProgress(link)
	if tipName and tipName ~= "" then
		setName = setName or tipName
		if tipCur and tipTotal then
			setEquipped = tipCur
			setTotal = tipTotal
		end
	end

	return setID, setName, setEquipped or 0, setTotal or 0
end

local function IsAdventureGear(link, name)
	name = name or GetItemName(link)
	if name and (name:find("Adventurer", 1, true) or name:find("Adventuring", 1, true)) then
		return true
	end
	local found = false
	ScanTooltipLines(link, function(text)
		if text:find("Adventurer", 1, true) then
			found = true
			return true
		end
	end)
	return found
end

local function IsTierSetGear(setID, setName, itemName)
	if itemName and InferTierSetFromItemName(itemName) then
		return true
	end
	if (setID or 0) > 0 then
		return true
	end
	return type(setName) == "string" and setName ~= ""
end

--- Raid/tier vault pieces we can name-match (ignore incidental setID on world gear).
local function IsObviousTierSetChoice(choice)
	if not choice or choice.isAdventureGear then
		return false
	end
	if choice.name and InferTierSetFromItemName(choice.name) then
		return true
	end
	if choice.link then
		local tipName = ScanTooltipSetProgress(choice.link)
		if tipName and tipName ~= "" then
			return true
		end
	end
	return false
end

local function FindTierSetWarningCandidate(gear)
	if not gear or #gear < 2 then
		return nil
	end
	local best = gear[1]
	if not best or best.isAdventureGear or IsObviousTierSetChoice(best) then
		return nil
	end
	for i = 2, #gear do
		local alt = gear[i]
		if alt and not alt.isAdventureGear and IsObviousTierSetChoice(alt) then
			if not alt.setName or alt.setName == "" then
				alt.setName = InferTierSetFromItemName(alt.name) or select(1, ScanTooltipSetProgress(alt.link))
			end
			return alt
		end
	end
	return nil
end

local function BuildTierWarningText(tierAlt)
	if not tierAlt then
		return ""
	end
	local setLabel = tierAlt.setName or "?"
	if (tierAlt.setTotal or 0) > 0 then
		setLabel = ("%s, %s"):format(setLabel, VL("VAULT_ADVISOR_TIER_WARN_COUNT_FMT", tierAlt.setEquipped or 0, tierAlt.setTotal))
	end
	local msg = VL("VAULT_ADVISOR_TIER_WARN_FMT", tierAlt.name or "?", setLabel)
	if (tierAlt.setEquipped or 0) < 2 then
		msg = msg .. " " .. VL("VAULT_ADVISOR_TIER_WARN_NO_BONUS")
	end
	return msg
end

local function TooltipMentionsUnique(link)
	if not link or not C_TooltipInfo or not C_TooltipInfo.GetHyperlink then
		return false
	end
	local ok, data = pcall(C_TooltipInfo.GetHyperlink, link)
	if not ok or type(data) ~= "table" or type(data.lines) ~= "table" then
		return false
	end
	for i = 1, #data.lines do
		local line = data.lines[i]
		local text = line and (line.leftText or line.rightText)
		if type(text) == "string" then
			if ITEM_UNIQUE and text:find(ITEM_UNIQUE, 1, true) then
				return true
			end
			if ITEM_UNIQUE_EQUIPPED and text:find(ITEM_UNIQUE_EQUIPPED, 1, true) then
				return true
			end
			if text:lower():find("unique", 1, true) then
				return true
			end
		end
	end
	return false
end

local function PlayerOwnsItemID(itemID)
	if not itemID then
		return false
	end
	if C_Item and C_Item.GetItemCount then
		local ok, count = pcall(C_Item.GetItemCount, itemID, false, true, false)
		if ok and (tonumber(count) or 0) > 0 then
			return true
		end
	end
	for slot = 0, 17 do
		if GetInventoryItemID("player", slot) == itemID then
			return true
		end
	end
	return false
end

local function GetEquippedLinksForEquipLoc(equipLoc)
	local slots = equipLoc and EQUIP_LOC_SLOTS[equipLoc]
	if not slots then
		return {}
	end
	local out = {}
	for i = 1, #slots do
		local link = GetInventoryItemLink("player", slots[i])
		if link then
			out[#out + 1] = link
		end
	end
	return out
end

local function ScoreStats(stats, weights)
	local total = 0
	total = total + (stats.mastery or 0) * (weights.mastery or 0)
	total = total + (stats.crit or 0) * (weights.crit or 0)
	total = total + (stats.haste or 0) * (weights.haste or 0)
	total = total + (stats.vers or 0) * (weights.vers or 0)
	return total
end

local function ScoreItem(link, weights)
	local stats = GetItemStatsFromLink(link)
	local ilvl = select(1, GetItemLevelFromLink(link))
	local pawnValue, scaleName = GetPawnItemScore(link)
	if pawnValue then
		local score = pawnValue + (ilvl or 0) * PAWN_ILVL_WEIGHT
		return score, stats, ilvl, scaleName
	end
	local score = ilvl * ILVL_WEIGHT + ScoreStats(stats, weights)
	return score, stats, ilvl, nil
end

local function CompareToEquipped(link, weights)
	local equipLoc = GetEquipLoc(link)
	local equipped = GetEquippedLinksForEquipLoc(equipLoc)
	if #equipped == 0 then
		return nil, nil, nil
	end
	local newScore, _, newIlvl = ScoreItem(link, weights)
	local bestOld, bestIlvl, bestName = 0, 0, nil
	for i = 1, #equipped do
		local s = ScoreItem(equipped[i], weights)
		local ilvl = select(1, GetItemLevelFromLink(equipped[i]))
		if s > bestOld then
			bestOld = s
			bestIlvl = ilvl
			bestName = GetItemName(equipped[i])
		end
	end
	local ilvlDelta = newIlvl - bestIlvl
	local scoreDelta = newScore - bestOld
	return scoreDelta, ilvlDelta, bestName
end

local function IsVaultFallbackToken(name, equipLoc, ilvl)
	if equipLoc and equipLoc ~= "" and (ilvl or 0) >= 200 then
		return false
	end
	name = name or ""
	if name:find("Token", 1, true) or name:find("Merit", 1, true) then
		return true
	end
	if not equipLoc or equipLoc == "" then
		return true
	end
	if (ilvl or 0) > 0 and (ilvl or 0) < 100 then
		return true
	end
	return false
end

local function IsClaimableGearChoice(record)
	if not record then
		return false
	end
	if not record.equipLoc or record.equipLoc == "" then
		return false
	end
	if (record.ilvl or 0) < 200 then
		return false
	end
	if record.name == "?" or record.name == "" then
		return false
	end
	if IsVaultFallbackToken(record.name, record.equipLoc, record.ilvl) then
		return false
	end
	return true
end

local function ComputeUpgradeScore(record)
	local upgrade = record.scoreDelta
	if upgrade == nil then
		upgrade = (record.rawScore or 0) - (record.penalties or 0)
	else
		upgrade = upgrade - (record.penalties or 0)
		local ilvlDelta = record.ilvlDelta
		if ilvlDelta and ilvlDelta < 0 then
			upgrade = upgrade + ilvlDelta * ILVL_WEIGHT * 4
		elseif ilvlDelta and ilvlDelta > 0 then
			upgrade = upgrade + ilvlDelta * 3
		end
	end
	return upgrade
end

local function BuildChoiceRecord(activity, reward, link, weights, weightKey)
	local itemID = GetItemIDFromLink(link)
	local equipLoc = GetEquipLoc(link)
	local name = GetItemName(link)
	local dataReady = IsVaultItemDataReady(link, itemID)
	local ilvl = select(1, GetItemLevelFromLink(link))
	if dataReady and (ilvl or 0) < MIN_GEAR_ILVL then
		dataReady = false
		RequestItemDataForLink(link, itemID)
	end
	local score, stats, _, pawnScale = ScoreItem(link, weights)
	if dataReady and ilvl > 0 and not pawnScale then
		score = ilvl * ILVL_WEIGHT + ScoreStats(stats, weights)
	end
	local scoreDelta, ilvlDelta, equippedName = CompareToEquipped(link, weights)
	local unique = TooltipMentionsUnique(link)
	local owned = unique and PlayerOwnsItemID(itemID)
	local isToken = IsVaultFallbackToken(name, equipLoc, ilvl)
	local setID, setName, setEquipped, setTotal = GetItemSetMeta(link)
	if not setName or setName == "" then
		setName = InferTierSetFromItemName(name)
	end
	local isTierSet = IsTierSetGear(setID, setName, name)
	local isAdventureGear = IsAdventureGear(link, name)
	local penalties = 0
	if owned then
		penalties = penalties + 5000
	end
	if isToken then
		penalties = penalties + 10000
	end
	local record = {
		link = link,
		itemID = itemID,
		name = name,
		ilvl = ilvl,
		stats = stats,
		rawScore = score,
		equipLoc = equipLoc,
		activityType = activity and activity.type,
		categoryKey = activity and GetActivityCategoryKey(activity.type),
		threshold = activity and activity.threshold,
		progress = activity and activity.progress,
		unique = unique,
		ownedDuplicate = owned,
		scoreDelta = scoreDelta,
		ilvlDelta = ilvlDelta,
		equippedName = equippedName,
		isToken = isToken,
		setID = setID,
		setName = setName,
		setEquipped = setEquipped,
		setTotal = setTotal,
		isTierSet = isTierSet,
		isAdventureGear = isAdventureGear,
		dataReady = dataReady,
		penalties = penalties,
		weightKey = weightKey,
	}
	record.upgradeScore = ComputeUpgradeScore(record)
	record.score = record.upgradeScore
	return record
end

local function PartitionVaultChoices(allChoices)
	local gear, token, pending = {}, nil, 0
	for i = 1, #allChoices do
		local c = allChoices[i]
		if c.isToken then
			if not token then
				token = c
			end
		elseif IsClaimableGearChoice(c) then
			if c.dataReady then
				gear[#gear + 1] = c
			else
				pending = pending + 1
			end
		end
	end
	table.sort(gear, function(a, b)
		return (a.upgradeScore or 0) > (b.upgradeScore or 0)
	end)
	return gear, token, pending
end

function ns.ScanVaultAdvisorChoices(weightsOverride, weightKeyOverride)
	LoadWeeklyRewardsUI()
	local choices = {}
	if not C_WeeklyRewards or not C_WeeklyRewards.GetActivities then
		return choices, nil, "no_api"
	end
	local weights, weightKey = weightsOverride, weightKeyOverride
	if not weights then
		weights, weightKey = GetSpecWeights()
	end
	if not weights then
		return choices, nil, "no_weights"
	end

	local ok, activities = pcall(C_WeeklyRewards.GetActivities)
	if not ok or type(activities) ~= "table" then
		return choices, nil, "scan_failed"
	end

	for a = 1, #activities do
		local activity = activities[a]
		local rewards = activity and activity.rewards
		if type(rewards) == "table" and #rewards > 0 then
			for r = 1, #rewards do
				local reward = rewards[r]
				if reward and reward.type == REWARD_ITEM_TYPE then
					local link = ResolveItemLink(reward)
					if link then
						choices[#choices + 1] = BuildChoiceRecord(activity, reward, link, weights, weightKey)
					elseif reward.id and C_Item and C_Item.RequestLoadItemDataByID then
						pcall(C_Item.RequestLoadItemDataByID, reward.id)
					end
				end
			end
		end
	end

	local gear, token, pending = PartitionVaultChoices(choices)
	local status = "empty"
	if #gear > 0 then
		status = "ok"
	elseif pending > 0 then
		status = "loading"
	end
	return gear, token, status
end

function ns.GetVaultAdvisorRecommendation()
	local weights, weightKey = GetSpecWeights()
	if not weights then
		weights, weightKey = GetGenericRoleWeights()
	end
	local gear, token, status = ns.ScanVaultAdvisorChoices(weights, weightKey)
	if not gear or #gear == 0 then
		return nil, gear, token, status
	end
	return gear[1], gear, token, status
end

local function ChoicesScanKey(choices)
	if #choices == 0 then
		return ""
	end
	local parts = {}
	for i = 1, math.min(#choices, 12) do
		local c = choices[i]
		parts[i] = ("%s:%s:%d"):format(tostring(c.itemID), tostring(c.ilvl), math.floor(c.score or 0))
	end
	return table.concat(parts, "|")
end

local function FormatStatLine(stats)
	if not stats then
		return ""
	end
	local bits = {}
	if (stats.mastery or 0) > 0 then
		bits[#bits + 1] = ("Mastery %d"):format(stats.mastery)
	end
	if (stats.crit or 0) > 0 then
		bits[#bits + 1] = ("Crit %d"):format(stats.crit)
	end
	if (stats.haste or 0) > 0 then
		bits[#bits + 1] = ("Haste %d"):format(stats.haste)
	end
	if (stats.vers or 0) > 0 then
		bits[#bits + 1] = ("Vers %d"):format(stats.vers)
	end
	return table.concat(bits, ", ")
end

local function CategoryLabel(key)
	if key == "raid" then
		return VL("VAULT_ADVISOR_CAT_RAID")
	elseif key == "dungeon" then
		return VL("VAULT_ADVISOR_CAT_DUNGEON")
	elseif key == "world" then
		return VL("VAULT_ADVISOR_CAT_WORLD")
	end
	return VL("VAULT_ADVISOR_CAT_OTHER")
end

local function ApplyAdvisorPanelLayout(panel)
	if not panel or not panel._best then
		return
	end
	if not panel._tierWarn then
		panel._tierWarn = panel:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
		panel._tierWarn:SetJustifyH("LEFT")
		panel._tierWarn:SetWordWrap(true)
	end
	panel._tierWarn:SetTextColor(1, 0.85, 0.2)
	panel._tierWarn:ClearAllPoints()
	panel._tierWarn:SetPoint("TOPLEFT", panel._best, "BOTTOMLEFT", 0, -4)
	panel._tierWarn:SetPoint("RIGHT", panel, "RIGHT", 0, 0)
	if panel._rowHost then
		panel._rowHost:ClearAllPoints()
		panel._rowHost:SetPoint("TOPLEFT", panel._tierWarn, "BOTTOMLEFT", 0, -4)
		panel._rowHost:SetPoint("RIGHT", panel, "RIGHT", 0, 0)
	end
	if panel._tokenNote then
		panel._tokenNote:ClearAllPoints()
		panel._tokenNote:SetPoint("TOPLEFT", panel._rowHost, "BOTTOMLEFT", 0, -6)
		panel._tokenNote:SetPoint("RIGHT", panel, "RIGHT", 0, 0)
	end
end

local function EnsureAdvisorPanel(parent)
	if advisorPanel and advisorPanel:GetParent() == parent then
		ApplyAdvisorPanelLayout(advisorPanel)
		return advisorPanel
	end
	if not parent then
		return nil
	end

	advisorPanel = CreateFrame("Frame", nil, parent)
	advisorPanel:SetPoint("TOPLEFT", parent, "TOPLEFT", 0, 0)
	advisorPanel:SetPoint("RIGHT", parent, "RIGHT", 0, 0)

	advisorPanel._title = advisorPanel:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
	advisorPanel._title:SetPoint("TOPLEFT", advisorPanel, "TOPLEFT", 0, 0)
	advisorPanel._title:SetJustifyH("LEFT")
	advisorPanel._title:SetTextColor(1, 0.9, 0.55)

	advisorPanel._hint = advisorPanel:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	advisorPanel._hint:SetPoint("TOPLEFT", advisorPanel._title, "BOTTOMLEFT", 0, -4)
	advisorPanel._hint:SetPoint("RIGHT", advisorPanel, "RIGHT", 0, 0)
	advisorPanel._hint:SetJustifyH("LEFT")
	advisorPanel._hint:SetWordWrap(true)
	advisorPanel._hint:SetTextColor(0.78, 0.76, 0.72)

	advisorPanel._best = advisorPanel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	advisorPanel._best:SetPoint("TOPLEFT", advisorPanel._hint, "BOTTOMLEFT", 0, -6)
	advisorPanel._best:SetPoint("RIGHT", advisorPanel, "RIGHT", 0, 0)
	advisorPanel._best:SetJustifyH("LEFT")
	advisorPanel._best:SetWordWrap(true)
	advisorPanel._best:SetTextColor(0.4, 1, 0.45)

	advisorPanel._tierWarn = advisorPanel:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
	advisorPanel._tierWarn:SetJustifyH("LEFT")
	advisorPanel._tierWarn:SetWordWrap(true)

	advisorPanel._tokenNote = advisorPanel:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
	advisorPanel._tokenNote:SetJustifyH("LEFT")
	advisorPanel._tokenNote:SetWordWrap(true)
	advisorPanel._tokenNote:SetTextColor(0.65, 0.62, 0.58)

	local rowHost = CreateFrame("Frame", nil, advisorPanel)
	advisorPanel._rowHost = rowHost
	ApplyAdvisorPanelLayout(advisorPanel)

	for i = 1, 8 do
		local row = CreateFrame("Frame", nil, rowHost)
		row:SetHeight(16)
		row._text = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
		row._text:SetPoint("LEFT", row, "LEFT", 0, 0)
		row._text:SetPoint("RIGHT", row, "RIGHT", 0, 0)
		row._text:SetJustifyH("LEFT")
		row:EnableMouse(true)
		row:SetScript("OnEnter", function(self)
			local c = self._choice
			if not c or not c.link then
				return
			end
			GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
			if GameTooltip.SetHyperlink then
				pcall(GameTooltip.SetHyperlink, GameTooltip, c.link)
			end
			GameTooltip:AddLine(" ")
			GameTooltip:AddLine(VL("VAULT_ADVISOR_TT_SCORE_FMT", math.floor(c.score or 0)), 0.9, 0.9, 0.9)
			local statLine = FormatStatLine(c.stats)
			if statLine ~= "" then
				GameTooltip:AddLine(statLine, 1, 1, 1)
			end
			if c.ownedDuplicate then
				GameTooltip:AddLine(VL("VAULT_ADVISOR_WARN_UNIQUE"), 1, 0.4, 0.4)
			end
			if c.equippedName then
				GameTooltip:AddLine(VL("VAULT_ADVISOR_TT_VS_FMT", c.equippedName), 0.75, 0.75, 0.75)
			end
			if c.ilvlDelta and c.ilvlDelta ~= 0 then
				local col = (c.ilvlDelta > 0) and { 1, 0.82, 0.45 } or { 1, 0.45, 0.45 }
				GameTooltip:AddLine(VL("VAULT_ADVISOR_TT_ILVL_DELTA_FMT", c.ilvlDelta), col[1], col[2], col[3])
			end
			if c.scoreDelta and c.scoreDelta < 0 then
				GameTooltip:AddLine(VL("VAULT_ADVISOR_TT_DOWNGRADE"), 1, 0.5, 0.5)
			end
			if c.isTierSet and c.setName then
				GameTooltip:AddLine(VL("VAULT_ADVISOR_TT_TIER_FMT", c.setName, c.setEquipped or 0, c.setTotal or 0), 0.6, 0.85, 1)
			end
			GameTooltip:Show()
		end)
		row:SetScript("OnLeave", function()
			GameTooltip:Hide()
		end)
		choiceRows[i] = row
	end

	ApplyAdvisorPanelLayout(advisorPanel)
	return advisorPanel
end

function ns.GetVaultAdvisorPanelHeight(width)
	if not advisorPanel or not advisorPanel:IsShown() then
		return 0
	end
	local h = advisorPanel._layoutH
	return tonumber(h) or 0
end

function ns.RefreshVaultAdvisorPanel(parent, innerWidth, claimReady)
	local panel = EnsureAdvisorPanel(parent)
	if not panel then
		return 0
	end

	local w = math.max(200, innerWidth or 260)
	panel:SetWidth(w)
	ApplyAdvisorPanelLayout(panel)
	panel._title:SetWidth(w)
	panel._hint:SetWidth(w)
	panel._best:SetWidth(w)
	if panel._tierWarn then
		panel._tierWarn:SetWidth(w)
	end
	if panel._tokenNote then
		panel._tokenNote:SetWidth(w)
	end

	local weights, weightKey = GetSpecWeights()
	if not weights then
		local g, gKey = GetGenericRoleWeights()
		weights = g
		weightKey = gKey
		panel._title:SetText(VL("VAULT_ADVISOR_TITLE"))
		panel._hint:SetText(VL("VAULT_ADVISOR_GENERIC_NOTE"))
		panel._best:SetText("")
		if panel._tokenNote then
			panel._tokenNote:SetText("")
			panel._tokenNote:Hide()
		end
		if panel._tierWarn then
			panel._tierWarn:SetText("")
			panel._tierWarn:Hide()
		end
		for i = 1, #choiceRows do
			choiceRows[i]:Hide()
		end
		panel._layoutH = panel._title:GetStringHeight() + panel._hint:GetStringHeight() + 12
		panel:Show()
		-- Continue using generic weights below (do not early-return).
	end

	local gear, token, status = ns.ScanVaultAdvisorChoices()
	local scanKey = ChoicesScanKey(gear)
	if scanKey ~= lastScanKey then
		lastScanKey = scanKey
	end

	local specIndex = GetSpecialization and GetSpecialization()
	local _, specName = GetSpecializationInfo(specIndex)
	local heroLabel = GetActiveHeroTalentLabel()
	local displaySpec = specName or "?"
	if heroLabel then
		displaySpec = ("%s (%s)"):format(displaySpec, heroLabel)
	end
	panel._title:SetText(VL("VAULT_ADVISOR_TITLE_FMT", displaySpec))

	if status == "loading" then
		panel._hint:SetText(VL("VAULT_ADVISOR_HINT_LOADING"))
		panel._best:SetText("")
		panel._tokenNote:SetText("")
		panel._tokenNote:Hide()
		if panel._tierWarn then
			panel._tierWarn:SetText("")
			panel._tierWarn:Hide()
		end
		for i = 1, #choiceRows do
			choiceRows[i]:Hide()
		end
		panel._layoutH = (panel._title:GetStringHeight() or 14) + 4 + (panel._hint:GetStringHeight() or 28) + 8
		panel:Show()
		ScheduleRescan()
		return panel._layoutH
	end

	if status == "empty" then
		if claimReady then
			panel._hint:SetText(VL("VAULT_ADVISOR_HINT_OPEN_VAULT"))
		else
			panel._hint:SetText(VL("VAULT_ADVISOR_HINT_NO_ITEMS"))
		end
		panel._best:SetText("")
		panel._tokenNote:SetText("")
		panel._tokenNote:Hide()
		if panel._tierWarn then
			panel._tierWarn:SetText("")
			panel._tierWarn:Hide()
		end
		for i = 1, #choiceRows do
			choiceRows[i]:Hide()
		end
		panel._layoutH = (panel._title:GetStringHeight() or 14) + 4 + (panel._hint:GetStringHeight() or 28) + 8
		panel:Show()
		return panel._layoutH
	end

	do
		local pawnScale = ShouldUsePawn() and GetPawnScaleName() or nil
		local guideHint = GetGuideStatHint(weightKey, pawnScale)
		if guideHint then
			panel._hint:SetText(guideHint .. "\n" .. VL("VAULT_ADVISOR_HINT_PICK_ONE"))
		elseif weightKey and weightKey:find("^GENERIC_") then
			panel._hint:SetText(VL("VAULT_ADVISOR_GENERIC_NOTE") .. "\n" .. VL("VAULT_ADVISOR_HINT_PICK_ONE"))
		else
			panel._hint:SetText(VL("VAULT_ADVISOR_HINT_PICK_ONE"))
		end
	end

	local function DeltaTag(c)
		return MakeDeltaTag(c)
	end

	local best = gear[1]
	if best then
		local tags = {}
		if best.ownedDuplicate then
			tags[#tags + 1] = VL("VAULT_ADVISOR_TAG_UNIQUE_WARN")
		end
		tags[#tags + 1] = DeltaTag(best)
		if best.ilvlDelta and best.ilvlDelta < 0 then
			tags[#tags + 1] = VL("VAULT_ADVISOR_TAG_DOWNGRADE")
		end
		local tagStr = (#tags > 0) and ("  " .. table.concat(tags, " ")) or ""
		panel._best:SetText(VL("VAULT_ADVISOR_BEST_FMT", best.name or "?", best.ilvl or 0, tagStr))
	else
		panel._best:SetText("")
	end

	local rowH = 16
	local rowGap = 2
	local shown = 0
	for i = 2, #gear do
		if shown >= #choiceRows then
			break
		end
		local c = gear[i]
		local row = choiceRows[shown + 1]
		local prefix = ("%d."):format(i)
		local cat = CategoryLabel(c.categoryKey)
		local warn = c.ownedDuplicate and (" " .. VL("VAULT_ADVISOR_TAG_UNIQUE_SHORT")) or ""
		local statBits = FormatStatLine(c.stats)
		local line = ("%s %s (%s, ilvl %d)%s%s"):format(prefix, c.name or "?", cat, c.ilvl or 0, DeltaTag(c), warn)
		if statBits ~= "" then
			line = line .. " — " .. statBits
		end
		row._text:SetText(line)
		row._text:SetTextColor(0.88, 0.86, 0.82)
		row._choice = c
		row:ClearAllPoints()
		row:SetPoint("TOPLEFT", panel._rowHost, "TOPLEFT", 0, -(shown * (rowH + rowGap)))
		row:SetPoint("RIGHT", panel._rowHost, "RIGHT", 0, 0)
		row:Show()
		shown = shown + 1
	end
	for i = shown + 1, #choiceRows do
		choiceRows[i]:Hide()
	end

	local rowsH = (shown > 0) and (shown * rowH + math.max(0, shown - 1) * rowGap) or 0
	panel._rowHost:SetHeight(rowsH)

	local tierAlt = FindTierSetWarningCandidate(gear)
	if tierAlt and panel._tierWarn then
		panel._tierWarn:SetText(BuildTierWarningText(tierAlt))
		panel._tierWarn:Show()
	else
		if panel._tierWarn then
			panel._tierWarn:SetText("")
			panel._tierWarn:Hide()
		end
	end

	if token then
		panel._tokenNote:SetText(VL("VAULT_ADVISOR_TOKEN_NOTE_FMT", token.name or "?"))
		panel._tokenNote:Show()
	else
		panel._tokenNote:SetText("")
		panel._tokenNote:Hide()
	end

	local tierText = tierAlt and (panel._tierWarn:GetStringHeight() or 0) or 0
	local tierH = (tierText > 4) and (tierText + 4) or 0
	local tokenH = panel._tokenNote:IsShown() and (panel._tokenNote:GetStringHeight() or 0) + 6 or 0
	panel._layoutH = (panel._title:GetStringHeight() or 14)
		+ 4
		+ (panel._hint:GetStringHeight() or 14)
		+ 6
		+ (panel._best:GetStringHeight() or 14)
		+ tierH
		+ 4
		+ rowsH
		+ tokenH
		+ 6
	panel:Show()
	return panel._layoutH
end

local ev = CreateFrame("Frame", nil, UIParent)
ev:RegisterEvent("WEEKLY_REWARDS_UPDATE")
ev:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED")
ev:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")
ev:RegisterEvent("ITEM_DATA_LOAD_RESULT")
ev:SetScript("OnEvent", function(_, event)
	if event == "ITEM_DATA_LOAD_RESULT" then
		ScheduleRescan()
	elseif event == "WEEKLY_REWARDS_UPDATE" or event == "PLAYER_SPECIALIZATION_CHANGED" or event == "PLAYER_EQUIPMENT_CHANGED" then
		lastScanKey = nil
		ScheduleRescan()
		if WeeklyRewardsFrame and WeeklyRewardsFrame:IsShown() and ns.RefreshBlizzardVaultBanner then
			ns.RefreshBlizzardVaultBanner()
		end
	end
end)

if not ns._mhVaultAdvisorLocaleHooked then
	ns._mhVaultAdvisorLocaleHooked = true
	local orig = ns.RefreshLocaleUI
	function ns:RefreshLocaleUI()
		if orig then
			orig(self)
		end
		lastScanKey = nil
		if ns.RefreshDelvesPanel then
			ns.RefreshDelvesPanel()
		end
		if WeeklyRewardsFrame and WeeklyRewardsFrame:IsShown() and ns.RefreshBlizzardVaultBanner then
			ns.RefreshBlizzardVaultBanner()
		end
	end
end
