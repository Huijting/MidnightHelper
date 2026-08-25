--[[
	Midnight Helper — floating Delve consumables popup (RAID-R Mini + Trovehunter's Bounty).

	Large, draggable buttons visible only during an active delve when you carry the items.
	Minimap icons (in-delve only) open this popup on left-click; right-click quick-uses the item.
]]

local addonName, ns = ...

local C_Item = C_Item
local Config = ns.Config or {}

local ITEM_RADAR = Config.DELVE_ITEM_RAID_R_MINI or 244193
local ITEM_TREASURE = Config.DELVE_ITEM_TROVEHUNTER_BOUNTY or 252415

local POPUP_MIN_H = 168
local BTN_SIZE = 52
local BTN_W = BTN_SIZE + 10
local BTN_H = BTN_SIZE + 22
local BTN_GAP = 14

--- Popup item slots: SecureActionButton (macro /use) — user must click the button directly.
--- Addon OnClick cannot call UseContainerItem (ADDON_ACTION_FORBIDDEN). SetPoint only once at create.
local POPUP_SLOT_DEFS = {
	Center = { point = "CENTER", relPoint = "CENTER", x = 0, y = -2 },
	Left = { point = "RIGHT", relPoint = "CENTER", x = -BTN_GAP / 2, y = -2 },
	Right = { point = "LEFT", relPoint = "CENTER", x = BTN_GAP / 2, y = -2 },
}

--- Legacy global secure slot names from a previous build — must be destroyed before reuse.
local LEGACY_POPUP_SLOT_GLOBALS = {
	"MidnightHelperDelvePopupSlotCenter",
	"MidnightHelperDelvePopupSlotLeft",
	"MidnightHelperDelvePopupSlotRight",
}

local function DestroyLegacyPopupSlotFrame(name)
	local f = name and _G[name]
	if not f or not f.Hide then
		return
	end
	f:Hide()
	if InCombatLockdown() then
		return
	end
	pcall(function()
		f:ClearAllPoints()
		f:SetParent(nil)
	end)
	if _G[name] == f then
		_G[name] = nil
	end
end

local function DestroyAllLegacyPopupSlotFrames()
	for _, name in ipairs(LEGACY_POPUP_SLOT_GLOBALS) do
		DestroyLegacyPopupSlotFrame(name)
	end
end

local function IsLegacySecurePopupSlot(btn)
	if not btn then
		return false
	end
	local name = btn.GetName and btn:GetName()
	if name then
		for _, legacy in ipairs(LEGACY_POPUP_SLOT_GLOBALS) do
			if name == legacy then
				return true
			end
		end
	end
	return false
end

local ITEM_ROWS = {
	{
		itemID = ITEM_RADAR,
		titleKey = "DELVE_MINIMAP_RADAR_TITLE",
		hintKey = "DELVE_MINIMAP_RADAR_HINT",
		shortKey = "DELVE_ITEMS_POPUP_RADAR_SHORT",
		secureName = "MidnightHelperDelvePopupRadar",
	},
	{
		itemID = ITEM_TREASURE,
		titleKey = "DELVE_MINIMAP_TREASURE_TITLE",
		hintKey = "DELVE_MINIMAP_TREASURE_HINT",
		shortKey = "DELVE_ITEMS_POPUP_TREASURE_SHORT",
		secureName = "MidnightHelperDelvePopupTreasure",
	},
}

local popupFrame
local autoShowSuppressed = false

local BROKER_SECURE_BY_ITEM = {
	[ITEM_RADAR] = "MidnightHelperUseDelveRadar",
	[ITEM_TREASURE] = "MidnightHelperUseDelveTreasure",
}

--- Popup-only secure use buttons (never reparented under the movable popup frame).
local POPUP_SECURE_BY_ITEM = {
	[ITEM_RADAR] = "MHDelvePopupUseRadar",
	[ITEM_TREASURE] = "MHDelvePopupUseTreasure",
}
local autoShowRetryGen = 0
local bountyToastShownThisDelve = false
local delveConsumablesUsed = {}

-- Forward declarations (used before their definitions in this file).
local HasAnyDelveConsumable
local PlayerHasDelveConsumablesInBags
local SavePoint
local eventFrame
local GetItemCount
local GetItemIcon
local PlayerCarriesItem
local EnsureSpellIdMapForItem
local RefreshDelveConsumablesUi
local MarkDelveConsumableActiveFromWorld
local MarkDelveConsumableActiveFromSpell

local TREASURE_ACTIVE_SPELL = Config.DELVE_ITEM_TROVEHUNTER_BOUNTY_SPELL or 1254631
local RADAR_USE_SPELL = Config.DELVE_ITEM_RAID_R_MINI_USE_SPELL or 1236623
local RADAR_ACTIVE_SPELLS = Config.DELVE_ITEM_RAID_R_MINI_SPELLS or { 1236623, 467033, 473679, 1236625 }
local SPELL_IDS_TO_ITEM = {}

local function IsSecretValue(value)
	return issecretvalue ~= nil and value ~= nil and issecretvalue(value) == true
end

local function IsDelveItemsUiAllowed()
	if ns.IsDelveInstanceInProgress then
		return ns:IsDelveInstanceInProgress()
	end
	return ns.IsPlayerInActiveDelve and ns.IsPlayerInActiveDelve()
end

local function IsPopupSecureUseAllowed()
	return IsDelveItemsUiAllowed()
end

local function UpdatePopupHintText(f)
	if not f or not f._hint then
		return
	end
	if IsPopupSecureUseAllowed() then
		if not HasAnyDelveConsumable() and PlayerHasDelveConsumablesInBags() then
			f._hint:SetText(ns:L("DELVE_ITEMS_POPUP_HINT_ALL_ACTIVE"))
		else
			f._hint:SetText(ns:L("DELVE_ITEMS_POPUP_HINT"))
		end
	elseif f._allowOutsideDelve then
		f._hint:SetText(ns:L("DELVE_ITEMS_POPUP_HINT_OUTSIDE"))
	else
		f._hint:SetText(ns:L("DELVE_ITEMS_POPUP_HINT"))
	end
end

function ns:ClearDelveItemsAutoShowSuppress()
	autoShowSuppressed = false
	if popupFrame then
		popupFrame._userClosed = false
	end
end

function ns:SuppressDelveItemsAutoShow()
	autoShowSuppressed = true
	if popupFrame then
		popupFrame._userClosed = true
	end
end

function ns:CancelDelveItemsAutoShowRetries()
	autoShowRetryGen = autoShowRetryGen + 1
end

local function GetDelveSessionKey()
	if not IsDelveItemsUiAllowed() then
		return nil
	end
	local _, _, _, _, _, _, _, instanceID = GetInstanceInfo()
	if instanceID and instanceID > 0 then
		return ("i%d"):format(instanceID)
	end
	if C_Map and C_Map.GetBestMapForUnit then
		local ok, mapID = pcall(C_Map.GetBestMapForUnit, "player")
		if ok and mapID and mapID > 0 then
			return ("m%d"):format(mapID)
		end
	end
	return "delve"
end

local function SyncDelveConsumableSession()
	local ui = ns.db and ns.db.ui
	if not ui then
		return
	end
	local key = GetDelveSessionKey()
	if not key or ui.delveConsumablesSessionKey ~= key then
		return
	end
	local saved = ui.delveConsumablesSessionUsed
	if type(saved) ~= "table" then
		return
	end
	for itemKey, used in pairs(saved) do
		if used then
			delveConsumablesUsed[tonumber(itemKey) or itemKey] = true
		end
	end
end

local function BeginDelveConsumableSession()
	local ui = ns.db and ns.db.ui
	if not ui then
		wipe(delveConsumablesUsed)
		return
	end
	local key = GetDelveSessionKey()
	if not key then
		wipe(delveConsumablesUsed)
		return
	end
	-- Keep per-delve progress across /reload and duplicate enter events for the same instance.
	if ui.delveConsumablesSessionKey == key and type(ui.delveConsumablesSessionUsed) == "table" then
		SyncDelveConsumableSession()
		return
	end
	ui.delveConsumablesSessionKey = key
	ui.delveConsumablesSessionUsed = {}
	wipe(delveConsumablesUsed)
end

local function PersistDelveConsumableUsed(itemID)
	delveConsumablesUsed[itemID] = true
	local ui = ns.db and ns.db.ui
	if not ui then
		return
	end
	local key = GetDelveSessionKey()
	if not key then
		return
	end
	ui.delveConsumablesSessionKey = key
	if type(ui.delveConsumablesSessionUsed) ~= "table" then
		ui.delveConsumablesSessionUsed = {}
	end
	ui.delveConsumablesSessionUsed[tostring(itemID)] = true
end

function ns:MarkDelveConsumableUsed(itemID)
	if not itemID then
		return
	end
	PersistDelveConsumableUsed(itemID)
end

function ns:ResetDelveConsumableAdviceSession()
	BeginDelveConsumableSession()
	if ns.RefreshDelveItemsPopup then
		ns:RefreshDelveItemsPopup()
	end
	if ns.RefreshDelveItemBrokers then
		ns:RefreshDelveItemBrokers()
	end
end

local function GetDelveItemCooldownRemaining(itemID)
	itemID = tonumber(itemID)
	if not itemID then
		return 0
	end
	local start, duration, enabled = GetItemCooldown(itemID)
	if enabled ~= 0 and start and start > 0 and duration and duration > 1.5 then
		local remaining = duration - (GetTime() - start)
		if remaining > 0.5 then
			return remaining
		end
	end
	if C_Container and C_Container.GetContainerNumSlots and C_Container.GetContainerItemInfo and C_Container.GetContainerItemCooldown then
		for bag = 0, 4 do
			local okSlots, numSlots = pcall(C_Container.GetContainerNumSlots, bag)
			if okSlots and type(numSlots) == "number" and numSlots > 0 then
				for slot = 1, numSlots do
					local okInfo, info = pcall(C_Container.GetContainerItemInfo, bag, slot)
					if okInfo and info and info.itemID == itemID then
						local okCd, cdStart, cdDuration, cdEnabled = pcall(C_Container.GetContainerItemCooldown, bag, slot)
						if okCd and cdEnabled ~= 0 and cdStart and cdStart > 0 and cdDuration and cdDuration > 1.5 then
							local remaining = cdDuration - (GetTime() - cdStart)
							if remaining > 0.5 then
								return remaining
							end
						end
					end
				end
			end
		end
	end
	return 0
end

local function PlayerHasDelveConsumableUseLock(itemID)
	if not itemID or not IsDelveItemsUiAllowed() then
		return false
	end
	if GetItemCount(itemID) < 1 and not PlayerCarriesItem(itemID) then
		return false
	end
	return GetDelveItemCooldownRemaining(itemID) > 0
end

local function PlayerCarriesUnusableDelveItem(itemID)
	if not itemID or not IsDelveItemsUiAllowed() then
		return false
	end
	if InCombatLockdown() then
		return false
	end
	if GetItemCount(itemID) < 1 and not PlayerCarriesItem(itemID) then
		return false
	end
	if type(IsUsableItem) ~= "function" then
		return false
	end
	if IsUsableItem(itemID) == true then
		return false
	end
	-- Grayed-out delve consumable in bags: already used this run (often no visible buff left).
	return true
end

MarkDelveConsumableActiveFromWorld = function(itemID, skipUiRefresh)
	if not itemID then
		return false
	end
	SyncDelveConsumableSession()
	if delveConsumablesUsed[itemID] then
		return false
	end
	PersistDelveConsumableUsed(itemID)
	if skipUiRefresh or InCombatLockdown() then
		if eventFrame then
			eventFrame._refreshWhenRegen = true
		end
		return true
	end
	RefreshDelveConsumablesUi()
	return true
end

MarkDelveConsumableActiveFromSpell = function(spellID)
	if not spellID or not IsDelveItemsUiAllowed() then
		return false
	end
	local itemID = SPELL_IDS_TO_ITEM[spellID]
	if not itemID then
		return false
	end
	return MarkDelveConsumableActiveFromWorld(itemID, InCombatLockdown())
end

RefreshDelveConsumablesUi = function()
	if InCombatLockdown() then
		if eventFrame then
			eventFrame._refreshWhenRegen = true
		end
		return
	end
	if popupFrame and popupFrame:IsShown() then
		popupFrame._forceShowInBags = nil
		if not HasAnyDelveConsumable() then
			if ns.HideDelveItemsPopup then
				ns:HideDelveItemsPopup()
			end
		elseif ns.RefreshDelveItemsPopup then
			ns:RefreshDelveItemsPopup()
		end
	else
		if ns.RefreshDelveItemsPopup then
			ns:RefreshDelveItemsPopup()
		end
	end
	if ns.RefreshDelveItemBrokers then
		ns:RefreshDelveItemBrokers()
	end
end

local function ResetDelveConsumableSession()
	wipe(delveConsumablesUsed)
	local ui = ns.db and ns.db.ui
	if ui then
		ui.delveConsumablesSessionKey = nil
		ui.delveConsumablesSessionUsed = nil
	end
end

function ns:HideDelveItemsUiLeavingDelve()
	self:CancelDelveItemsAutoShowRetries()
	bountyToastShownThisDelve = false
	-- Do NOT wipe the "already used" state here. C_PartyInfo.IsDelveInProgress() can briefly
	-- flicker false (e.g. when the final boss dies) while you are still in the same delve;
	-- wiping made the popup re-advise and pop up again after the last boss. The per-instance
	-- session persists (SavedVariables) and is only wiped when a genuinely new delve begins
	-- (BeginDelveConsumableSession, different session key). (Rob 9 jul)
	self:HideDelveItemsPopup()
	if self.HideDelveCoach then
		self:HideDelveCoach(false)
	end
	if self.RefreshDelveItemBrokers then
		self:RefreshDelveItemBrokers()
	end
end

function ns:SyncDelveItemsUiToWorldState()
	if IsDelveItemsUiAllowed() then
		return
	end
	if popupFrame and popupFrame:IsShown() and self.HideDelveItemsPopup then
		self:HideDelveItemsPopup()
	end
	if self.HideDelveCoach then
		self:HideDelveCoach(false)
	end
	if self.RefreshDelveItemBrokers then
		self:RefreshDelveItemBrokers()
	end
end

function ns:MaybeShowDelveBountyToast()
	if bountyToastShownThisDelve then
		return
	end
	if not IsDelveItemsUiAllowed() then
		return
	end
	local ui = ns.db and ns.db.ui
	local toastCfg = ui and ui.toast
	if toastCfg and (toastCfg.enabled == false or toastCfg.delveBounty == false) then
		return
	end
	if GetItemCount(ITEM_TREASURE) < 1 then
		return
	end
	if ns.IsDelveConsumableActive and ns:IsDelveConsumableActive(ITEM_TREASURE) then
		return
	end
	if not ns.QueueMidnightToast then
		return
	end
	bountyToastShownThisDelve = true
	ns.QueueMidnightToast({
		id = "delve_bounty",
		clickHintKey = "TOAST_CLICK_HINT", -- this one really does open delve items
		itemID = ITEM_TREASURE,
		icon = GetItemIcon(ITEM_TREASURE),
		titleKey = "TOAST_BOUNTY_TITLE",
		bodyKey = "TOAST_BOUNTY_BODY",
		onClick = function()
			if ns.ShowDelveItemsPopup then
				ns:ShowDelveItemsPopup()
			end
		end,
	})
end

function ns:PreviewDelveBountyToast()
	if not ns.QueueMidnightToast then
		return
	end
	ns.QueueMidnightToast({
		id = "delve_bounty_preview",
		clickHintKey = "TOAST_CLICK_HINT", -- this one really does open delve items
		itemID = ITEM_TREASURE,
		icon = GetItemIcon(ITEM_TREASURE),
		titleKey = "TOAST_BOUNTY_TITLE",
		bodyKey = "TOAST_BOUNTY_BODY",
		onClick = function()
			if ns.ShowDelveItemsPopup then
				ns:ShowDelveItemsPopup()
			end
		end,
	})
end

function ns:ScheduleDelveItemsAutoShowRetries()
	if not IsDelveItemsUiAllowed() then
		return
	end
	autoShowRetryGen = autoShowRetryGen + 1
	local gen = autoShowRetryGen
	local delays = { 0.35, 1.0, 2.5, 5.0 }
	if not (C_Timer and C_Timer.After) then
		if gen == autoShowRetryGen and IsDelveItemsUiAllowed() and self.MaybeAutoShowDelveItemsPopup then
			self:MaybeAutoShowDelveItemsPopup()
		end
		return
	end
	for _, delay in ipairs(delays) do
		C_Timer.After(delay, function()
			if gen ~= autoShowRetryGen or not IsDelveItemsUiAllowed() then
				return
			end
			if ns.MaybeAutoShowDelveItemsPopup then
				ns:MaybeAutoShowDelveItemsPopup()
			end
		end)
	end
end

local function GetPopupSettings()
	local ui = ns.db and ns.db.ui
	if type(ui) ~= "table" then
		return nil
	end
	if type(ui.delveItemsPopup) ~= "table" then
		ui.delveItemsPopup = {
			enabled = true,
			autoShowInDelve = true,
			point = "CENTER",
			relPoint = "CENTER",
			x = 0,
			y = 80,
			userPositioned = false,
		}
	end
	local s = ui.delveItemsPopup
	-- Migrate old default (far left) to centered layout once.
	if not s.userPositioned and s.point == "LEFT" and (tonumber(s.x) or 0) < -200 then
		s.point = "CENTER"
		s.relPoint = "CENTER"
		s.x = 0
		s.y = 80
	end
	return s
end

local function CountItemInPlayerBags(itemID)
	itemID = tonumber(itemID)
	if not itemID then
		return 0
	end
	local total = 0
	if C_Container and C_Container.GetContainerNumSlots and C_Container.GetContainerItemInfo then
		for bag = 0, 4 do
			local okSlots, numSlots = pcall(C_Container.GetContainerNumSlots, bag)
			if okSlots and type(numSlots) == "number" and numSlots > 0 then
				for slot = 1, numSlots do
					local okInfo, info = pcall(C_Container.GetContainerItemInfo, bag, slot)
					if okInfo and info and info.itemID == itemID then
						local stack = info.stackCount
						if type(stack) == "number" and not IsSecretValue(stack) then
							total = total + stack
						else
							total = total + 1
						end
					end
				end
			end
		end
	end
	return total
end

PlayerCarriesItem = function(itemID)
	return CountItemInPlayerBags(itemID) > 0
end

GetItemCount = function(itemID)
	local bagCount = CountItemInPlayerBags(itemID)
	if bagCount > 0 then
		return bagCount
	end
	if C_Item and C_Item.GetItemCount then
		local ok, n = pcall(C_Item.GetItemCount, itemID, true)
		if ok and n ~= nil and not IsSecretValue(n) then
			return tonumber(n) or 0
		end
	end
	local globalGetItemCount = rawget(_G, "GetItemCount")
	if type(globalGetItemCount) == "function" then
		local ok2, n2 = pcall(globalGetItemCount, itemID)
		if ok2 and n2 ~= nil and not IsSecretValue(n2) then
			return tonumber(n2) or 0
		end
	end
	return bagCount
end

PlayerHasDelveConsumablesInBags = function()
	for _, row in ipairs(ITEM_ROWS) do
		if PlayerCarriesItem(row.itemID) or GetItemCount(row.itemID) > 0 then
			return true
		end
	end
	return false
end

local function CollectConfigSpellIDsForItem(itemID)
	local ids = {}
	local seen = {}
	local function add(id)
		id = tonumber(id)
		if id and not seen[id] then
			seen[id] = true
			ids[#ids + 1] = id
		end
	end
	if itemID == ITEM_TREASURE then
		add(TREASURE_ACTIVE_SPELL)
	elseif itemID == ITEM_RADAR then
		add(RADAR_USE_SPELL)
		for i = 1, #RADAR_ACTIVE_SPELLS do
			add(RADAR_ACTIVE_SPELLS[i])
		end
	end
	return ids
end

--- Config spell IDs plus optional GetItemSpell (aura sync only; not used for UNIT_SPELLCAST matching).
local function CollectActiveSpellIDsForItem(itemID)
	local ids = CollectConfigSpellIDsForItem(itemID)
	local seen = {}
	for i = 1, #ids do
		seen[ids[i]] = true
	end
	local function add(id)
		id = tonumber(id)
		if id and not seen[id] then
			seen[id] = true
			ids[#ids + 1] = id
		end
	end
	if C_Item and C_Item.GetItemSpell then
		local ok, _, spellID = pcall(C_Item.GetItemSpell, itemID)
		if ok then
			add(spellID)
		end
	end
	return ids
end

local function RebuildSpellIdMap()
	wipe(SPELL_IDS_TO_ITEM)
	for _, itemID in ipairs({ ITEM_RADAR, ITEM_TREASURE }) do
		local spellIDs = CollectConfigSpellIDsForItem(itemID)
		for i = 1, #spellIDs do
			SPELL_IDS_TO_ITEM[spellIDs[i]] = itemID
		end
	end
end

EnsureSpellIdMapForItem = function(itemID)
	if not itemID then
		return
	end
	local spellIDs = CollectActiveSpellIDsForItem(itemID)
	for i = 1, #spellIDs do
		SPELL_IDS_TO_ITEM[spellIDs[i]] = itemID
	end
end

-- Spell-ID lookups only (no addon-side comparison of aura.spellId — secret in combat).
-- ns.Aura tries both client APIs; nil (unreadable) is not a buff we may claim to see.
local function PlayerHasBuffSpell(spellID)
	return ns.Aura.HasPlayerAura(spellID) == true
end

--- Is one of the player's helpful auras the buff granted by `itemID`?
---
--- Two ways in, because neither is reliable alone: the aura's spell ID mapped back to
--- its item, or the aura's NAME against a few substrings (the buff's spell ID has
--- changed across builds). Secret values are skipped rather than compared against.
local function PlayerHasItemBuff(itemID, nameNeedles)
	local found = false
	ns.Aura.ForEachPlayerBuff(function(aura)
		local sid = aura.spellId
		if sid and not IsSecretValue(sid) and SPELL_IDS_TO_ITEM[sid] == itemID then
			found = true
			return true -- stop
		end
		local name = aura.name
		if not name and sid and not IsSecretValue(sid) and C_Spell and C_Spell.GetSpellName then
			local nOk, n = pcall(C_Spell.GetSpellName, sid)
			if nOk then
				name = n
			end
		end
		if type(name) == "string" and not IsSecretValue(name) then
			local lower = name:lower()
			for _, needle in ipairs(nameNeedles) do
				if lower:find(needle, 1, true) then
					found = true
					return true -- stop
				end
			end
		end
	end)
	return found
end

-- Needles are matched literally (plain find). Kept verbatim from the original scan.
local RADAR_NEEDLES = { "raid%-r", "l00t", "loot raid", "mislaid", "curio" }
local TROVE_NEEDLES = { "trove", "bounty", "trovehunter" }

local function PlayerHasLootRadarBuff()
	return PlayerHasItemBuff(ITEM_RADAR, RADAR_NEEDLES)
end

local function PlayerHasTroveBountyBuff()
	return PlayerHasItemBuff(ITEM_TREASURE, TROVE_NEEDLES)
end

local function PlayerHasActiveBuffsForItem(itemID)
	EnsureSpellIdMapForItem(itemID)
	if itemID == ITEM_RADAR and PlayerHasLootRadarBuff() then
		return true
	end
	if itemID == ITEM_TREASURE and PlayerHasTroveBountyBuff() then
		return true
	end
	local spellIDs = CollectActiveSpellIDsForItem(itemID)
	for i = 1, #spellIDs do
		if PlayerHasBuffSpell(spellIDs[i]) then
			return true
		end
	end
	return false
end

local function SyncActiveDelveConsumablesFromAuras(skipUiRefresh)
	if not IsDelveItemsUiAllowed() then
		return false
	end
	SyncDelveConsumableSession()
	local changed = false
	for _, itemID in ipairs({ ITEM_RADAR, ITEM_TREASURE }) do
		if PlayerHasActiveBuffsForItem(itemID)
			or PlayerHasDelveConsumableUseLock(itemID)
			or PlayerCarriesUnusableDelveItem(itemID) then
			if not delveConsumablesUsed[itemID] then
				PersistDelveConsumableUsed(itemID)
				changed = true
			end
		end
	end
	if changed and not skipUiRefresh then
		RefreshDelveConsumablesUi()
	end
	return changed
end

RebuildSpellIdMap()

local activeCache, activeCacheAt = {}, 0

function ns:IsDelveConsumableActive(itemID)
	SyncDelveConsumableSession()
	if delveConsumablesUsed[itemID] then
		return true
	end
	local now = GetTime()
	if now - activeCacheAt > 0.5 then
		activeCache, activeCacheAt = {}, now
	end
	local cached = activeCache[itemID]
	if cached ~= nil then
		return cached
	end
	local active = PlayerHasActiveBuffsForItem(itemID)
		or PlayerHasDelveConsumableUseLock(itemID)
		or PlayerCarriesUnusableDelveItem(itemID)
	activeCache[itemID] = active
	return active
end

function ns:ShouldAdviseDelveConsumable(itemID)
	if GetItemCount(itemID) < 1 then
		return false
	end
	return not self:IsDelveConsumableActive(itemID)
end

HasAnyDelveConsumable = function()
	for _, row in ipairs(ITEM_ROWS) do
		if ns:ShouldAdviseDelveConsumable(row.itemID) then
			return true
		end
	end
	return false
end

-- Assigns the forward-declared local (top of file): callers compiled before this
-- point (MaybeShowDelveBountyToast/PreviewDelveBountyToast) would otherwise
-- resolve to the removed global GetItemIcon and crash.
GetItemIcon = function(itemID)
	if C_Item and C_Item.GetItemIconByID then
		local ok, tex = pcall(C_Item.GetItemIconByID, itemID)
		if ok and tex then
			return tex
		end
	end
	return 134414
end

function ns:GetDelveItemIcon(itemID)
	return GetItemIcon(itemID)
end

local function GetItemLink(itemID)
	if C_Item and C_Item.GetItemLinkByID then
		local ok, link = pcall(C_Item.GetItemLinkByID, itemID)
		if ok and link then
			return link
		end
	end
	return ("item:%d"):format(itemID)
end

local function StyleDelveItemHostBackdrop(bg)
	if not bg or not bg.SetBackdrop then
		return
	end
	bg:SetBackdrop({
		bgFile = "Interface\\Buttons\\WHITE8X8",
		edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
		tile = false,
		edgeSize = 10,
		insets = { left = 2, right = 2, top = 2, bottom = 2 },
	})
	bg:SetBackdropColor(0.08, 0.1, 0.14, 0.95)
	bg:SetBackdropBorderColor(0.55, 0.45, 0.22, 0.95)
end

local function SetPopupChromeActiveState(chrome, row)
	if not chrome or not row then
		return
	end
	local isActive = ns.IsDelveConsumableActive and ns:IsDelveConsumableActive(row.itemID)
	chrome._mhConsumableActive = isActive and true or false
	if chrome._icon then
		if isActive and chrome._icon.SetDesaturated then
			chrome._icon:SetDesaturated(true)
			chrome._icon:SetVertexColor(0.55, 0.9, 0.55)
		else
			if chrome._icon.SetDesaturated then
				chrome._icon:SetDesaturated(false)
			end
			chrome._icon:SetVertexColor(1, 1, 1)
		end
	end
	if chrome._labelFs then
		if isActive then
			chrome._labelFs:SetText(ns:L("DELVE_ITEMS_POPUP_ACTIVE"))
			chrome._labelFs:SetTextColor(0.45, 1, 0.55)
		else
			chrome._labelFs:SetText(ns:L(row.shortKey))
			chrome._labelFs:SetTextColor(0.95, 0.9, 0.74)
		end
	end
	if chrome._mhBackdrop and chrome._mhBackdrop.SetBackdropBorderColor then
		if isActive then
			chrome._mhBackdrop:SetBackdropBorderColor(0.35, 0.85, 0.4, 0.95)
		else
			chrome._mhBackdrop:SetBackdropBorderColor(0.55, 0.45, 0.22, 0.95)
		end
	end
end

local function EnsureDelveItemHostDecor(host)
	if not host or host._icon then
		return
	end
	local icon = host:CreateTexture(nil, "OVERLAY")
	icon:SetSize(BTN_SIZE - 4, BTN_SIZE - 4)
	icon:SetPoint("TOP", host, "TOP", 0, -6)
	icon:SetDrawLayer("OVERLAY", 2)
	icon:SetVertexColor(1, 1, 1)
	host._icon = icon
	local countFs = host:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
	countFs:SetPoint("TOPRIGHT", icon, "TOPRIGHT", 4, -2)
	countFs:SetTextColor(0.3, 1, 0.35)
	host._countFs = countFs
	local labelFs = host:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	labelFs:SetPoint("BOTTOM", host, "BOTTOM", 0, 5)
	labelFs:SetPoint("LEFT", host, "LEFT", 2, 0)
	labelFs:SetPoint("RIGHT", host, "RIGHT", -2, 0)
	labelFs:SetJustifyH("CENTER")
	labelFs:SetWordWrap(true)
	labelFs:SetTextColor(0.95, 0.9, 0.74)
	host._labelFs = labelFs
end

local function TryConfirmDelveConsumableUsed(itemID, countBefore)
	if not itemID then
		return false
	end
	SyncDelveConsumableSession()
	if countBefore and GetItemCount(itemID) < countBefore then
		PersistDelveConsumableUsed(itemID)
		RefreshDelveConsumablesUi()
		return true
	end
	if PlayerHasActiveBuffsForItem(itemID) then
		PersistDelveConsumableUsed(itemID)
		RefreshDelveConsumablesUi()
		return true
	end
	if PlayerCarriesUnusableDelveItem(itemID) or PlayerHasDelveConsumableUseLock(itemID) then
		PersistDelveConsumableUsed(itemID)
		RefreshDelveConsumablesUi()
		return true
	end
	return false
end

local function ScheduleDelveConsumableUseConfirm(itemID, countBefore)
	local function check()
		TryConfirmDelveConsumableUsed(itemID, countBefore)
	end
	if C_Timer and C_Timer.After then
		C_Timer.After(0.35, check)
		C_Timer.After(1.0, check)
	else
		check()
	end
end

--- Reparent legacy popup secure buttons onto UIParent (never under the named popup tree).
local function DisableLegacyPopupSecureFrames()
	for _, row in ipairs(ITEM_ROWS) do
		local name = row.secureName
		local f = name and _G[name]
		if f and f.Hide and not InCombatLockdown() then
			local parent = f:GetParent()
			if parent ~= UIParent then
				pcall(function()
					f:SetParent(UIParent)
					f:ClearAllPoints()
					f:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
				end)
			end
			f:Hide()
		end
	end
	DestroyAllLegacyPopupSlotFrames()
end

local function HideAllPopupSecureButtons()
	if InCombatLockdown() then
		return
	end
	for _, row in ipairs(ITEM_ROWS) do
		local popupBtn = row.secureName and _G[row.secureName]
		if popupBtn and popupBtn.Hide then
			popupBtn:Hide()
		end
		local popupName = POPUP_SECURE_BY_ITEM[row.itemID]
		local popupBtn = popupName and _G[popupName]
		if popupBtn and popupBtn.Hide then
			popupBtn:Hide()
			if not InCombatLockdown() then
				pcall(function()
					popupBtn:SetParent(UIParent)
					popupBtn:SetSize(1, 1)
					popupBtn:ClearAllPoints()
					popupBtn:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
				end)
			end
		end
	end
end

local SECURE_OVERLAY_STRATA = "TOOLTIP"
local SECURE_OVERLAY_LEVEL = 200

--- SecureActionButton item click (same pattern as MissingClassBuff).
local function ApplyPopupSlotSecureAction(slot, itemID)
	if not slot or not itemID or InCombatLockdown() then
		return
	end
	slot:SetAttribute("type", "item")
	slot:SetAttribute("item", ("item:%d"):format(itemID))
	slot:SetAttribute("macrotext", nil)
	slot:SetAttribute("spell", nil)
end

local function EnsurePopupSecureHitTexture(btn)
	if not btn or btn._mhHitTex then
		return
	end
	local tex = btn:CreateTexture(nil, "BACKGROUND")
	tex:SetAllPoints(btn)
	tex:SetColorTexture(0, 0, 0, 0)
	btn:SetNormalTexture(tex)
	btn._mhHitTex = tex
end

local function GetPopupSecureForRow(row)
	if not row or not row.itemID or InCombatLockdown() then
		return nil
	end
	local name = POPUP_SECURE_BY_ITEM[row.itemID]
	if not name then
		return nil
	end
	local btn = _G[name]
	if not btn then
		btn = CreateFrame("Button", name, UIParent, "SecureActionButtonTemplate")
		btn:SetSize(BTN_W, BTN_H)
		btn:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
		btn:Hide()
	end
	if btn._mhConfiguredFor == row.itemID then
		btn._row = row
		return btn
	end
	btn:RegisterForClicks("AnyUp", "AnyDown")
	ApplyPopupSlotSecureAction(btn, row.itemID)
	btn._mhConfiguredFor = row.itemID
	EnsurePopupSecureHitTexture(btn)
	btn._row = row
	btn._mhSecureUseSlot = true
	btn:SetFrameStrata(SECURE_OVERLAY_STRATA)
	btn:SetFrameLevel(SECURE_OVERLAY_LEVEL)
	btn:EnableMouse(true)
	if btn.SetHighlightTexture and not btn._mhPopupHighlight then
		btn._mhPopupHighlight = true
		btn:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Square", "ADD")
	end
	if not btn._mhPopupTooltipHooked then
		btn._mhPopupTooltipHooked = true
		btn:SetScript("OnEnter", function(self)
			local r = self._row
			if not r or not GameTooltip then
				return
			end
			GameTooltip:SetOwner(self, "ANCHOR_CURSOR")
			GameTooltip:SetHyperlink(GetItemLink(r.itemID))
			GameTooltip:AddLine(" ")
			GameTooltip:AddLine(ns:L(r.hintKey), 0.86, 0.86, 0.82, true)
			GameTooltip:Show()
		end)
		btn:SetScript("OnLeave", function()
			if GameTooltip then
				GameTooltip:Hide()
			end
		end)
	end
	if not btn._mhUseConfirmHooked then
		btn._mhUseConfirmHooked = true
		btn:HookScript("PreClick", function()
			local r = btn._row
			if r and r.itemID then
				MarkDelveConsumableActiveFromWorld(r.itemID, InCombatLockdown())
				ScheduleDelveConsumableUseConfirm(r.itemID, GetItemCount(r.itemID))
			end
		end)
	end
	return btn
end

local function GetChromeScreenRect(chrome)
	if not chrome or not chrome.GetRect then
		return nil
	end
	local left, bottom, width, height = chrome:GetRect()
	if left and bottom and width and height and width > 0 and height > 0 then
		return left, bottom, width, height
	end
	local cx, cy = chrome:GetCenter()
	width, height = chrome:GetWidth(), chrome:GetHeight()
	if not cx or not cy or not width or width <= 0 or not height or height <= 0 then
		return nil
	end
	return cx - width * 0.5, cy - height * 0.5, width, height
end

local function BeginPopupDrag(f)
	if not f then
		return
	end
	local scale = UIParent:GetEffectiveScale() or 1
	local cx, cy = f:GetCenter()
	local mx, my = GetCursorPosition()
	f._mhDragOffsetX = (cx or 0) - (mx / scale)
	f._mhDragOffsetY = (cy or 0) - (my / scale)
	f._mhDragging = true
end

local function UpdatePopupDrag(f)
	if not f or not f._mhDragging then
		return
	end
	local scale = UIParent:GetEffectiveScale() or 1
	local mx, my = GetCursorPosition()
	f:ClearAllPoints()
	f:SetPoint("CENTER", UIParent, "BOTTOMLEFT", (mx / scale) + (f._mhDragOffsetX or 0), (my / scale) + (f._mhDragOffsetY or 0))
end

local function EndPopupDrag(f)
	if not f then
		return
	end
	f._mhDragging = false
	SavePoint(f, true)
	if ns.RefreshDelvePopupSecurePositions then
		ns:RefreshDelvePopupSecurePositions()
	end
end

--- Position a global secure button on UIParent over chrome (MissingClassBuff pattern).
local function PositionSecureButtonOverChrome(btn, chrome)
	if InCombatLockdown() or not btn or not chrome then
		return false
	end
	local left, bottom, width, height = GetChromeScreenRect(chrome)
	if not left then
		return false
	end
	local ok = pcall(function()
		if btn:GetParent() ~= UIParent then
			btn:SetParent(UIParent)
		end
		btn:ClearAllPoints()
		btn:SetSize(width, height)
		btn:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", left, bottom)
		btn:SetFrameStrata(SECURE_OVERLAY_STRATA)
		btn:SetFrameLevel(SECURE_OVERLAY_LEVEL)
		btn:EnableMouse(true)
		btn:Show()
	end)
	return ok
end

local function AttachBrokerSecureToChrome(chrome, row)
	if not chrome or not row or InCombatLockdown() then
		return nil
	end
	local btn = GetPopupSecureForRow(row)
	if not btn then
		return nil
	end
	if PositionSecureButtonOverChrome(btn, chrome) then
		return btn
	end
	return nil
end

function ns:RefreshDelvePopupSecurePositions()
	if not IsPopupSecureUseAllowed() or InCombatLockdown() or not popupFrame or not popupFrame:IsShown() then
		if not IsPopupSecureUseAllowed() then
			HideAllPopupSecureButtons()
		end
		return
	end
	local slots = popupFrame._itemSlots
	if not slots then
		return
	end
	for _, chrome in pairs(slots) do
		if chrome and chrome._mhPopupChrome and chrome:IsShown() and chrome._row then
			if ns.IsDelveConsumableActive and ns:IsDelveConsumableActive(chrome._row.itemID) then
				local popupName = POPUP_SECURE_BY_ITEM[chrome._row.itemID]
				local btn = popupName and _G[popupName]
				if btn and btn.Hide then
					btn:Hide()
				end
			else
				AttachBrokerSecureToChrome(chrome, chrome._row)
			end
		end
	end
end

local function OnApiDelveRunTransition()
	local apiIn = IsDelveItemsUiAllowed()
	local was = eventFrame and eventFrame._mhApiInDelve == true
	if apiIn == was then
		return
	end
	if eventFrame then
		eventFrame._mhApiInDelve = apiIn and true or false
	end
	if apiIn then
		BeginDelveConsumableSession()
		SyncActiveDelveConsumablesFromAuras(true)
		if ns.ClearDelveItemsAutoShowSuppress then
			ns:ClearDelveItemsAutoShowSuppress()
		end
		bountyToastShownThisDelve = false
		if ns.ScheduleDelveItemsAutoShowRetries then
			ns:ScheduleDelveItemsAutoShowRetries()
		end
	else
		if ns.HideDelveItemsUiLeavingDelve then
			ns:HideDelveItemsUiLeavingDelve()
		end
	end
end

local function ApplyMousePropagation(frame)
	if not frame then
		return
	end
	-- Never call on named/protected roots (MidnightHelperDelveItemsPopup) — ADDON_ACTION_BLOCKED in combat.
	if frame.GetName and frame:GetName() then
		return
	end
	if frame.SetPropagateMouseClicks then
		pcall(frame.SetPropagateMouseClicks, frame, true)
	end
	if frame.SetPropagateMouseMotion then
		pcall(frame.SetPropagateMouseMotion, frame, true)
	end
end

local function PopupHasItemSlots(f)
	local slots = f and f._itemSlots
	if not slots then
		return false
	end
	for _, chrome in pairs(slots) do
		if chrome and chrome._mhPopupChrome then
			return true
		end
	end
	return false
end

local function PopupHasVisibleItemSlot(f)
	local slots = f and f._itemSlots
	if not slots then
		return false
	end
	for _, chrome in pairs(slots) do
		if chrome and chrome._mhPopupChrome and chrome.IsShown and chrome:IsShown() then
			return true
		end
	end
	return false
end

--- Content layer above BackdropTemplate paint so children receive clicks (see MidnightToast).
local function EnsurePopupContent(f)
	if f._content then
		return f._content
	end
	local content = CreateFrame("Frame", nil, f)
	content:SetAllPoints(f)
	content:SetFrameLevel(f:GetFrameLevel() + 10)
	content:EnableMouse(true)
	ApplyMousePropagation(content)
	f._content = content
	return content
end

local function HideLegacyInsecurePopupHosts(f)
	if not f or not f._itemBtns then
		return
	end
	for _, host in ipairs(f._itemBtns) do
		if host then
			host:Hide()
			if not InCombatLockdown() then
				host:SetParent(nil)
			end
		end
	end
	f._itemBtns = nil
end

local function IsLegacyPopupSlot(btn)
	return IsLegacySecurePopupSlot(btn)
end

local function UpdatePopupItemSlot(chrome, row, count)
	if not chrome or not row then
		return
	end
	chrome._row = row
	chrome._itemID = row.itemID
	if chrome._icon then
		chrome._icon:SetTexture(GetItemIcon(row.itemID))
	end
	SetPopupChromeActiveState(chrome, row)
	if chrome._countFs then
		if count > 0 then
			chrome._countFs:SetText("x" .. tostring(count))
			chrome._countFs:Show()
		else
			chrome._countFs:SetText("")
			chrome._countFs:Hide()
		end
	end
	if chrome._row and not chrome._mhConsumableActive then
		AttachBrokerSecureToChrome(chrome, chrome._row)
	else
		local itemID = chrome._itemID or (chrome._row and chrome._row.itemID)
		local popupName = itemID and POPUP_SECURE_BY_ITEM[itemID]
		local btn = popupName and _G[popupName]
		if btn and btn.Hide and not InCombatLockdown() then
			btn:Hide()
		end
	end
end

local function EnsurePopupSlotChrome(slotKey, rowHost, slots)
	local chromeKey = slotKey .. "Chrome"
	local chrome = slots[chromeKey]
	if chrome then
		return chrome
	end
	local def = POPUP_SLOT_DEFS[slotKey]
	if not def or not rowHost then
		return nil
	end
	chrome = CreateFrame("Frame", nil, rowHost, "BackdropTemplate")
	chrome:SetSize(BTN_W, BTN_H)
	chrome:SetPoint(def.point, rowHost, def.relPoint, def.x, def.y)
	chrome:SetFrameLevel(rowHost:GetFrameLevel() + 8)
	chrome:EnableMouse(false)
	chrome._mhPopupChrome = true
	StyleDelveItemHostBackdrop(chrome)
	chrome._mhBackdrop = chrome
	EnsureDelveItemHostDecor(chrome)
	slots[chromeKey] = chrome
	return chrome
end

local function EnsurePopupItemSlot(slotKey, rowHost, slots, row)
	if InCombatLockdown() then
		return slots[slotKey]
	end
	local existing = slots[slotKey]
	if existing then
		if IsLegacyPopupSlot(existing) or not existing._mhPopupChrome then
			existing:Hide()
			existing:SetParent(nil)
			slots[slotKey] = nil
		else
			return existing
		end
	end
	local chrome = EnsurePopupSlotChrome(slotKey, rowHost, slots)
	if not chrome then
		return nil
	end
	slots[slotKey] = chrome
	return chrome
end

local function EnsureAllPopupItemSlots(f)
	if not f or not f._rowHost or InCombatLockdown() then
		return
	end
	DestroyAllLegacyPopupSlotFrames()
	f._itemSlots = f._itemSlots or {}
	for slotKey, slot in pairs(f._itemSlots) do
		if not slot or not slot._mhPopupChrome or IsLegacyPopupSlot(slot) then
			if slot and slot.Hide then
				slot:Hide()
			end
			if slot and not InCombatLockdown() then
				pcall(function()
					slot:SetParent(nil)
				end)
			end
			f._itemSlots[slotKey] = nil
		end
	end
	if f._itemSlotsReady then
		for slotKey in pairs(POPUP_SLOT_DEFS) do
			local slot = f._itemSlots[slotKey]
			if not slot or not slot._mhPopupChrome then
				f._itemSlotsReady = nil
				break
			end
		end
		if f._itemSlotsReady then
			return
		end
	end
	local rowByItem = {}
	for _, row in ipairs(ITEM_ROWS) do
		rowByItem[row.itemID] = row
	end
	for slotKey in pairs(POPUP_SLOT_DEFS) do
		local row = rowByItem[ITEM_RADAR]
		if slotKey == "Right" then
			row = rowByItem[ITEM_TREASURE]
		elseif slotKey == "Left" then
			row = rowByItem[ITEM_RADAR]
		end
		EnsurePopupItemSlot(slotKey, f._rowHost, f._itemSlots, row)
	end
	f._itemSlotsReady = true
end

--- In combat: only reuse existing chrome (never CreateFrame / SetPoint).
local function GetPopupItemSlot(slotKey, rowHost, slots, row)
	local chrome = slots[slotKey]
	if chrome and chrome._mhPopupChrome and not IsLegacyPopupSlot(chrome) then
		return chrome
	end
	if InCombatLockdown() then
		return nil
	end
	return EnsurePopupItemSlot(slotKey, rowHost, slots, row)
end

local function ShowPopupSlot(chrome, row)
	if not chrome then
		return
	end
	chrome:Show()
	if not IsPopupSecureUseAllowed() or not row then
		return
	end
	if ns.IsDelveConsumableActive and ns:IsDelveConsumableActive(row.itemID) then
		local popupName = POPUP_SECURE_BY_ITEM[row.itemID]
		local btn = popupName and _G[popupName]
		if btn and btn.Hide and not InCombatLockdown() then
			btn:Hide()
		end
		return
	end
	if InCombatLockdown() then
		return
	end
	AttachBrokerSecureToChrome(chrome, row)
end

local function HidePopupChromeSlots(slots)
	for _, slot in pairs(slots) do
		if slot and slot._mhPopupChrome and slot.Hide then
			slot:Hide()
		end
	end
end

local function HideAllPopupSlots(slots)
	HidePopupChromeSlots(slots)
	HideAllPopupSecureButtons()
end

local function LayoutPopupSize(f, visibleCount)
	if visibleCount < 1 then
		return
	end
	local totalW = visibleCount * BTN_W + (visibleCount - 1) * BTN_GAP
	f:SetWidth(math.max(180, totalW + 52))
	f:SetHeight(POPUP_MIN_H)
end

local function ApplyVisiblePopupSlots(f, slots, rowHost, visibleRows, visibleCount)
	local inCombat = InCombatLockdown()
	if inCombat then
		HidePopupChromeSlots(slots)
	else
		HideAllPopupSlots(slots)
	end
	if visibleCount < 1 then
		if inCombat then
			f._hideWhenRegen = true
		else
			f:Hide()
		end
		return
	end
	if visibleCount == 1 then
		local chrome = GetPopupItemSlot("Center", rowHost, slots, visibleRows[1].row)
		if chrome then
			UpdatePopupItemSlot(chrome, visibleRows[1].row, visibleRows[1].count)
			ShowPopupSlot(chrome, visibleRows[1].row)
		end
	elseif visibleCount >= 2 then
		local left = GetPopupItemSlot("Left", rowHost, slots, visibleRows[1].row)
		local right = GetPopupItemSlot("Right", rowHost, slots, visibleRows[2].row)
		if left then
			UpdatePopupItemSlot(left, visibleRows[1].row, visibleRows[1].count)
			ShowPopupSlot(left, visibleRows[1].row)
		end
		if right then
			UpdatePopupItemSlot(right, visibleRows[2].row, visibleRows[2].count)
			ShowPopupSlot(right, visibleRows[2].row)
		end
	end
	LayoutPopupSize(f, visibleCount)
	if not inCombat and ns.RefreshDelvePopupSecurePositions then
		ns:RefreshDelvePopupSecurePositions()
	end
end

function ns:UseDelveConsumableItem(itemID)
	-- Items must be used via secure popup buttons (direct click). API use from addon code is forbidden.
	if ns.ShowDelveItemsPopup then
		ns:ShowDelveItemsPopup()
	end
	return false
end

local function ApplyCenterPoint(f)
	f:ClearAllPoints()
	f:SetPoint("CENTER", UIParent, "CENTER", 0, 80)
end

local function ApplySavedPoint(f)
	local s = GetPopupSettings()
	if not s or not s.userPositioned then
		ApplyCenterPoint(f)
		return
	end
	f:ClearAllPoints()
	f:SetPoint(s.point or "CENTER", UIParent, s.relPoint or "CENTER", tonumber(s.x) or 0, tonumber(s.y) or 80)
end

SavePoint = function(f, userMoved)
	local s = GetPopupSettings()
	if not s then
		return
	end
	if userMoved then
		s.userPositioned = true
	end
	local point, _, relPoint, x, y = f:GetPoint(1)
	if point then
		s.point = point
		s.relPoint = relPoint or point
		s.x = x or s.x
		s.y = y or s.y
	end
end

local function ReparentToPopupContent(f, child)
	if child and f._content and child:GetParent() ~= f._content then
		child:SetParent(f._content)
	end
end

local function EnsurePopupFrame()
	if popupFrame then
		DisableLegacyPopupSecureFrames()
		local content = EnsurePopupContent(popupFrame)
		if content then
			content:EnableMouse(false)
		end
		ReparentToPopupContent(popupFrame, popupFrame._titleBar)
		ReparentToPopupContent(popupFrame, popupFrame._closeBtn)
		ReparentToPopupContent(popupFrame, popupFrame._rowHost)
		if popupFrame._rowHost then
			popupFrame._rowHost:EnableMouse(false)
		end
		HideLegacyInsecurePopupHosts(popupFrame)
		popupFrame._itemSlots = popupFrame._itemSlots or {}
		EnsureAllPopupItemSlots(popupFrame)
		popupFrame:SetHeight(POPUP_MIN_H)
		popupFrame:EnableMouse(false)
		popupFrame:SetMovable(true)
		popupFrame:RegisterForDrag()
		popupFrame:SetScript("OnDragStart", nil)
		popupFrame:SetScript("OnDragStop", nil)
		return popupFrame
	end

	DisableLegacyPopupSecureFrames()

	local f = CreateFrame("Frame", "MidnightHelperDelveItemsPopup", UIParent, "BackdropTemplate")
	f:SetSize(200, POPUP_MIN_H)
	f:SetFrameStrata("HIGH")
	f:SetFrameLevel(200)
	f:SetClampedToScreen(true)
	f:EnableMouse(false)
	f:SetMovable(true)
	if f.SetBackdrop then
		f:SetBackdrop({
			bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
			edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Gold-Border",
			tile = true,
			tileSize = 32,
			edgeSize = 32,
			insets = { left = 11, right = 12, top = 12, bottom = 11 },
		})
		f:SetBackdropColor(0.06, 0.06, 0.1, 0.94)
	end
	tinsert(UISpecialFrames, f:GetName())

	local content = EnsurePopupContent(f)
	content:EnableMouse(false)

	local titleBar = CreateFrame("Frame", nil, content)
	titleBar:SetHeight(22)
	titleBar:SetPoint("TOPLEFT", content, "TOPLEFT", 12, -10)
	titleBar:SetPoint("TOPRIGHT", content, "TOPRIGHT", -28, -10)
	titleBar:SetFrameLevel(content:GetFrameLevel() + 2)
	titleBar:EnableMouse(true)
	titleBar:RegisterForDrag("LeftButton")
	titleBar:SetScript("OnDragStart", function()
		BeginPopupDrag(f)
	end)
	titleBar:SetScript("OnDragStop", function()
		EndPopupDrag(f)
	end)
	f._titleBar = titleBar

	local title = titleBar:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	title:SetPoint("CENTER", titleBar, "CENTER", -8, 0)
	title:SetJustifyH("CENTER")
	title:SetTextColor(1, 0.9, 0.55)
	f._title = title

	local closeBtn = CreateFrame("Button", nil, content, "UIPanelCloseButton")
	closeBtn:SetPoint("TOPRIGHT", content, "TOPRIGHT", 2, 2)
	closeBtn:SetFrameLevel(content:GetFrameLevel() + 4)
	closeBtn:SetScript("OnClick", function()
		if ns.SuppressDelveItemsAutoShow then
			ns:SuppressDelveItemsAutoShow()
		else
			f._userClosed = true
		end
		f:Hide()
	end)
	f:SetScript("OnHide", function(self)
		self._forceShowInBags = nil
		self._allowOutsideDelve = nil
		if not InCombatLockdown() then
			HideAllPopupSecureButtons()
		end
	end)
	f:SetScript("OnUpdate", function(self, elapsed)
		if not self:IsShown() then
			return
		end
		if self._mhDragging then
			UpdatePopupDrag(self)
			if ns.RefreshDelvePopupSecurePositions then
				ns:RefreshDelvePopupSecurePositions()
			end
			return
		end
		self._mhTickElapsed = (self._mhTickElapsed or 0) + elapsed
		if self._mhTickElapsed < 0.25 then
			return
		end
		elapsed = self._mhTickElapsed
		self._mhTickElapsed = 0
		if InCombatLockdown() and IsDelveItemsUiAllowed() then
			self._mhCombatStateElapsed = (self._mhCombatStateElapsed or 0) + elapsed
			if self._mhCombatStateElapsed >= 0.5 then
				self._mhCombatStateElapsed = 0
				SyncActiveDelveConsumablesFromAuras(true)
				if self._itemSlots then
					for _, chrome in pairs(self._itemSlots) do
						if chrome and chrome._mhPopupChrome and chrome:IsShown() and chrome._row then
							local row = chrome._row
							local count = GetItemCount(row.itemID)
							if count < 1 and PlayerCarriesItem(row.itemID) then
								count = 1
							end
							UpdatePopupItemSlot(chrome, row, count)
						end
					end
				end
				UpdatePopupHintText(self)
			end
			return
		end
		self._mhSecPosElapsed = (self._mhSecPosElapsed or 0) + elapsed
		if self._mhSecPosElapsed < 0.08 then
			return
		end
		self._mhSecPosElapsed = 0
		if ns.RefreshDelvePopupSecurePositions then
			ns:RefreshDelvePopupSecurePositions()
		end
	end)
	f._closeBtn = closeBtn

	local hint = content:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	hint:SetPoint("TOP", titleBar, "BOTTOM", 0, -6)
	hint:SetPoint("LEFT", content, "LEFT", 14, 0)
	hint:SetPoint("RIGHT", content, "RIGHT", -14, 0)
	hint:SetJustifyH("CENTER")
	hint:SetWordWrap(true)
	hint:SetTextColor(0.82, 0.8, 0.74)
	f._hint = hint

	local rowHost = CreateFrame("Frame", nil, content)
	rowHost:SetPoint("TOP", hint, "BOTTOM", 0, -8)
	rowHost:SetPoint("LEFT", content, "LEFT", 16, 0)
	rowHost:SetPoint("RIGHT", content, "RIGHT", -16, 0)
	rowHost:SetPoint("BOTTOM", content, "BOTTOM", 18, 0)
	rowHost:SetFrameLevel(content:GetFrameLevel() + 4)
	rowHost:EnableMouse(false)
	f._rowHost = rowHost
	f._itemSlots = {}
	if not InCombatLockdown() then
		EnsureAllPopupItemSlots(f)
	end

	function f:RefreshLocale()
		self._title:SetText(ns:L("DELVE_ITEMS_POPUP_TITLE"))
		UpdatePopupHintText(self)
		if not self._itemSlots then
			return
		end
		for _, chrome in pairs(self._itemSlots) do
			local row = chrome and chrome._row
			if row then
				SetPopupChromeActiveState(chrome, row)
			end
		end
	end

	popupFrame = f
	return f
end

function ns:RefreshDelveItemsPopup()
	DestroyAllLegacyPopupSlotFrames()
	local s = GetPopupSettings()
	if not s or s.enabled == false then
		if popupFrame then
			popupFrame:Hide()
		end
		return
	end

	local allowOutsideDelve = popupFrame and popupFrame._allowOutsideDelve
	if not allowOutsideDelve and not IsDelveItemsUiAllowed() then
		if popupFrame then
			popupFrame:Hide()
		end
		if ns.RefreshDelveItemBrokers then
			ns:RefreshDelveItemBrokers()
		end
		return
	end

	if not InCombatLockdown() then
		SyncActiveDelveConsumablesFromAuras(true)
	end

	local forceShowInBags = popupFrame and popupFrame._forceShowInBags
	if not forceShowInBags and not HasAnyDelveConsumable() then
		local anyActive = false
		for _, row in ipairs(ITEM_ROWS) do
			if ns.IsDelveConsumableActive and ns:IsDelveConsumableActive(row.itemID) then
				anyActive = true
				break
			end
		end
		if not anyActive then
			if popupFrame then
				popupFrame:Hide()
			end
			if ns.RefreshDelveItemBrokers then
				ns:RefreshDelveItemBrokers()
			end
			return
		end
	end

	local f = EnsurePopupFrame()
	SyncDelveConsumableSession()
	f:RefreshLocale()
	UpdatePopupHintText(f)

	local slots = f._itemSlots or {}
	local rowHost = f._rowHost
	if not rowHost then
		return
	end

	local visibleRows = {}
	for _, row in ipairs(ITEM_ROWS) do
		local count = GetItemCount(row.itemID)
		if count < 1 and PlayerCarriesItem(row.itemID) then
			count = 1
		end
		local isActive = ns.IsDelveConsumableActive and ns:IsDelveConsumableActive(row.itemID)
		local showRow = false
		if isActive then
			showRow = forceShowInBags and true or false
		elseif count > 0 then
			showRow = forceShowInBags or ns:ShouldAdviseDelveConsumable(row.itemID)
		end
		if showRow then
			visibleRows[#visibleRows + 1] = { row = row, count = count, active = isActive }
		end
	end
	local visibleCount = #visibleRows

	if not forceShowInBags and visibleCount > 0 and not HasAnyDelveConsumable() then
		UpdatePopupHintText(f)
	end

	if InCombatLockdown() then
		if visibleCount > 0 and PopupHasItemSlots(f) then
			ApplyVisiblePopupSlots(f, slots, rowHost, visibleRows, visibleCount)
		else
			f._hideWhenRegen = visibleCount < 1
			f._showWhenRegen = visibleCount > 0
		end
		if ns.RefreshDelveItemBrokers then
			ns:RefreshDelveItemBrokers()
		end
		return
	end

	EnsureAllPopupItemSlots(f)
	slots = f._itemSlots or {}
	ApplyVisiblePopupSlots(f, slots, rowHost, visibleRows, visibleCount)
	f._showWhenRegen = false

	if ns.RefreshDelveItemBrokers then
		ns:RefreshDelveItemBrokers()
	end
end

function ns:ShowDelveItemsPopup(forceWithItemsInBags, allowOutsideDelve)
	if not allowOutsideDelve and not IsDelveItemsUiAllowed() then
		return false
	end
	local s = GetPopupSettings()
	if not s or s.enabled == false then
		return false
	end
	if not forceWithItemsInBags and not HasAnyDelveConsumable() then
		return false
	end
	if forceWithItemsInBags and not PlayerHasDelveConsumablesInBags() then
		return false
	end
	if InCombatLockdown() then
		if eventFrame then
			eventFrame._showWhenRegen = true
		end
		if popupFrame and popupFrame:IsShown() and ns.RefreshDelveItemsPopup then
			ns:RefreshDelveItemsPopup()
			return true
		end
		return false
	end
	self:ClearDelveItemsAutoShowSuppress()
	local f = EnsurePopupFrame()
	f._forceShowInBags = forceWithItemsInBags or nil
	f._allowOutsideDelve = allowOutsideDelve or nil
	if InCombatLockdown() and not PopupHasItemSlots(f) then
		f._showWhenRegen = true
		return false
	end
	if not InCombatLockdown() and not PopupHasItemSlots(f) then
		f._itemSlotsReady = nil
	end
	ns:RefreshDelveItemsPopup()
	if not forceWithItemsInBags and not HasAnyDelveConsumable() then
		f._forceShowInBags = nil
		f._allowOutsideDelve = nil
		return false
	end
	if not PopupHasVisibleItemSlot(f) and not InCombatLockdown() then
		f._itemSlotsReady = nil
		EnsureAllPopupItemSlots(f)
		ns:RefreshDelveItemsPopup()
	end
	if not PopupHasVisibleItemSlot(f) and not forceWithItemsInBags then
		f._forceShowInBags = nil
		f._allowOutsideDelve = nil
		f:Hide()
		if not InCombatLockdown() then
			f._showWhenRegen = true
		end
		return false
	end
	ApplySavedPoint(f)
	f:Show()
	f:Raise()
	if C_Timer and C_Timer.After then
		for _, delay in ipairs({ 0, 0.05, 0.15, 0.35 }) do
			C_Timer.After(delay, function()
				if popupFrame and popupFrame:IsShown() and ns.RefreshDelvePopupSecurePositions then
					ns:RefreshDelvePopupSecurePositions()
				end
			end)
		end
	end
	return true
end

function ns:HideDelveItemsPopup()
	if InCombatLockdown() then
		if popupFrame then
			popupFrame._hideWhenRegen = true
		end
		return
	end
	HideAllPopupSecureButtons()
	if popupFrame then
		popupFrame._forceShowInBags = nil
		popupFrame._allowOutsideDelve = nil
		popupFrame._hideWhenRegen = nil
		popupFrame:Hide()
	end
end

function ns:ToggleDelveItemsPopup()
	if popupFrame and popupFrame:IsShown() then
		self:SuppressDelveItemsAutoShow()
		popupFrame:Hide()
		return false
	end
	return self:ShowDelveItemsPopup()
end

function ns:MaybeAutoShowDelveItemsPopup()
	local s = GetPopupSettings()
	if not s or s.enabled == false or s.autoShowInDelve == false then
		return
	end
	if autoShowSuppressed or (popupFrame and popupFrame._userClosed) then
		return
	end
	if not PlayerHasDelveConsumablesInBags() then
		return
	end
	if InCombatLockdown() then
		if eventFrame then
			eventFrame._showWhenRegen = true
		end
		return
	end
	if IsDelveItemsUiAllowed() then
		self:ShowDelveItemsPopup(false, false)
	end
end

eventFrame = CreateFrame("Frame")

eventFrame:RegisterEvent("ADDON_LOADED")
eventFrame:RegisterEvent("BAG_UPDATE_DELAYED")
eventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
eventFrame:RegisterEvent("ZONE_CHANGED")
eventFrame:RegisterEvent("ZONE_CHANGED_INDOORS")
eventFrame:RegisterEvent("ZONE_CHANGED_NEW_AREA")
eventFrame:RegisterEvent("SCENARIO_UPDATE")
eventFrame:RegisterEvent("SCENARIO_CRITERIA_UPDATE")
eventFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
eventFrame:RegisterUnitEvent("UNIT_AURA", "player")
eventFrame:RegisterUnitEvent("UNIT_SPELLCAST_START", "player")
eventFrame:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", "player")
eventFrame:SetScript("OnEvent", function(_, event, arg1, arg2, arg3)
	if event == "ADDON_LOADED" then
		if arg1 ~= addonName then
			return
		end
		DisableLegacyPopupSecureFrames()
		DestroyAllLegacyPopupSlotFrames()
		for _, row in ipairs(ITEM_ROWS) do
			GetPopupSecureForRow(row)
		end
		if C_Timer and C_Timer.After then
			C_Timer.After(0, function()
				if ns.SyncDelveItemsUiToWorldState then
					ns:SyncDelveItemsUiToWorldState()
				end
			end)
			C_Timer.After(1, function()
				RebuildSpellIdMap()
				if IsDelveItemsUiAllowed() then
					SyncActiveDelveConsumablesFromAuras(true)
					if ns.RefreshDelveItemsPopup then
						ns:RefreshDelveItemsPopup()
					end
				end
			end)
		end
		return
	end

	if event == "BAG_UPDATE_DELAYED" then
		if IsDelveItemsUiAllowed() then
			SyncActiveDelveConsumablesFromAuras(true)
			if InCombatLockdown() then
				eventFrame._refreshWhenRegen = true
			elseif ns.RefreshDelveItemsPopup then
				ns:RefreshDelveItemsPopup()
			end
		end
		return
	end

	if event == "UNIT_AURA" then
		if IsDelveItemsUiAllowed() then
			eventFrame._auraDirty = true
		end
		return
	end

	if event == "PLAYER_REGEN_ENABLED" then
		if popupFrame then
			if popupFrame._hideWhenRegen then
				popupFrame._hideWhenRegen = nil
				if ns.HideDelveItemsPopup then
					ns:HideDelveItemsPopup()
				end
			elseif eventFrame and eventFrame._showWhenRegen and ns.ShowDelveItemsPopup then
				eventFrame._showWhenRegen = false
				ns:ShowDelveItemsPopup()
			elseif eventFrame and eventFrame._refreshWhenRegen and ns.RefreshDelveItemsPopup then
				eventFrame._refreshWhenRegen = nil
				ns:RefreshDelveItemsPopup()
			elseif popupFrame._showWhenRegen and ns.ShowDelveItemsPopup then
				popupFrame._showWhenRegen = false
				ns:ShowDelveItemsPopup()
			elseif popupFrame:IsShown() and ns.RefreshDelveItemsPopup then
				ns:RefreshDelveItemsPopup()
			end
		end
		return
	end

	if event == "UNIT_SPELLCAST_START" or event == "UNIT_SPELLCAST_SUCCEEDED" then
		if arg1 ~= "player" or not IsDelveItemsUiAllowed() then
			return
		end
		MarkDelveConsumableActiveFromSpell(arg3)
		return
	end

	OnApiDelveRunTransition()

	local inDelve = IsDelveItemsUiAllowed()
	if not inDelve then
		if ns.SyncDelveItemsUiToWorldState then
			ns:SyncDelveItemsUiToWorldState()
		end
		eventFrame._mhWasInDelve = false
		return
	end

	if event == "PLAYER_ENTERING_WORLD" then
		SyncDelveConsumableSession()
		SyncActiveDelveConsumablesFromAuras()
		if ns.IsDelveConsumableActive and ns:IsDelveConsumableActive(ITEM_TREASURE) then
			bountyToastShownThisDelve = true
		end
	end

	if event:find("ZONE") or event:find("SCENARIO") then
		if ns.ScheduleDelveItemsAutoShowRetries then
			ns:ScheduleDelveItemsAutoShowRetries()
		end
	end

	eventFrame._mhWasInDelve = inDelve

	SyncActiveDelveConsumablesFromAuras()
	if not InCombatLockdown() and ns.RefreshDelveItemsPopup then
		ns:RefreshDelveItemsPopup()
	end
	if ns.MaybeShowDelveBountyToast then
		ns:MaybeShowDelveBountyToast()
	end
	if ns.MaybeAutoShowDelveItemsPopup then
		ns:MaybeAutoShowDelveItemsPopup()
	end
	if inDelve and ns.ScheduleDelveItemsAutoShowRetries then
		ns:ScheduleDelveItemsAutoShowRetries()
	end
end)

eventFrame:SetScript("OnUpdate", function(self, elapsed)
	-- Do nothing when the delve popup is not relevant.
	local inDelve = IsDelveItemsUiAllowed()
	if (not inDelve) and (not self._mhWasInDelve) and (not (popupFrame and popupFrame:IsShown())) and (not self._auraDirty) then
		return
	end
	if self._auraDirty then
		self._auraElapsed = (self._auraElapsed or 0) + elapsed
		if self._auraElapsed >= 0.25 then
			self._auraElapsed = 0
			self._auraDirty = false
			if IsDelveItemsUiAllowed() then
				SyncActiveDelveConsumablesFromAuras()
			end
		end
	end
	self._elapsed = (self._elapsed or 0) + elapsed
	if self._elapsed < 1.0 then
		return
	end
	self._elapsed = 0
	if inDelve then
		self._auraPoll = (self._auraPoll or 0) + 1
		if self._auraPoll >= 3 then
			self._auraPoll = 0
			SyncActiveDelveConsumablesFromAuras()
		end
	end
	if inDelve and not self._mhWasInDelve then
		if ns.ClearDelveItemsAutoShowSuppress then
			ns:ClearDelveItemsAutoShowSuppress()
		end
		if ns.ScheduleDelveItemsAutoShowRetries then
			ns:ScheduleDelveItemsAutoShowRetries()
		end
	end
	if not inDelve and self._mhWasInDelve then
		if ns.HideDelveItemsUiLeavingDelve then
			ns:HideDelveItemsUiLeavingDelve()
		elseif ns.SyncDelveItemsUiToWorldState then
			ns:SyncDelveItemsUiToWorldState()
		end
	end
	self._mhWasInDelve = inDelve and true or false
end)

do
	local orig = ns.RefreshLocaleUI
	function ns:RefreshLocaleUI()
		if orig then
			orig(self)
		end
		if popupFrame and popupFrame.RefreshLocale then
			popupFrame:RefreshLocale()
		end
	end
end

local function DelveItemsSlashChat(key)
	DEFAULT_CHAT_FRAME:AddMessage(
		("|cffffcc00%s|r %s"):format(ns:L("PRINT_PREFIX"), ns:L(key))
	)
end

function ns:RunDelveItemsSlashCommand(msg)
	local line = (msg or ""):lower()
	line = line:gsub("^%s+", ""):gsub("%s+$", "")
	if line == "items reset" or line == "delveitems reset" or line == "delve items reset" then
		if self.ResetDelveConsumableAdviceSession then
			self:ResetDelveConsumableAdviceSession()
			DelveItemsSlashChat("DELVE_ITEMS_SLASH_RESET")
		else
			DelveItemsSlashChat("UI_LOADING")
		end
		return true
	end
	if line == "items mark" or line == "items mark radar" or line == "items mark bounty" then
		if not IsDelveItemsUiAllowed() then
			DelveItemsSlashChat("DELVE_ITEMS_SLASH_NOT_IN_DELVE")
			return true
		end
		local itemID = ITEM_RADAR
		if line:find("bounty", 1, true) then
			itemID = ITEM_TREASURE
		end
		if MarkDelveConsumableActiveFromWorld(itemID, false) then
			DelveItemsSlashChat("DELVE_ITEMS_SLASH_MARKED")
		else
			DelveItemsSlashChat("DELVE_ITEMS_SLASH_ALREADY_MARKED")
		end
		return true
	end
	if line == "items" or line == "delveitems" or line == "delve items" then
		local inDelve = IsDelveItemsUiAllowed()
		if not inDelve then
			if self.ShowDelveItemsPopup and self:ShowDelveItemsPopup(true, true) then
				DelveItemsSlashChat("DELVE_ITEMS_SLASH_OPENED")
				return true
			end
			DelveItemsSlashChat("DELVE_ITEMS_SLASH_NOT_IN_DELVE")
			return true
		end
		if self.ShowDelveItemsPopup then
			local ok = self:ShowDelveItemsPopup(true, true)
			if ok then
				DelveItemsSlashChat("DELVE_ITEMS_SLASH_OPENED")
			else
				DelveItemsSlashChat("DELVE_ITEMS_SLASH_NO_ITEMS")
			end
		else
			DelveItemsSlashChat("UI_LOADING")
		end
		return true
	end
	return false
end
