--[[
	Midnight Helper — Valeera / delve companion curio recommendations by season and role.
	Item names come from the client (GetItemInfo); this file holds item IDs only.
]]

local _, ns = ...

local ITEM_PORCELAIN_BLADE_TIP = 257683
local ITEM_MANDATE_SACRED_DEATH = 249225
local ITEM_OVERFLOWING_VOIDSPIRE = 257866

--- @type table<number, { default: table<string, {combat: number, utility: number}>, nemesis?: table<string, {combat: number, utility: number}> }>
ns.DELVE_CURIOS_BY_SEASON = {
	[1] = {
		default = {
			dps = { combat = ITEM_PORCELAIN_BLADE_TIP, utility = ITEM_MANDATE_SACRED_DEATH },
			heal = { combat = ITEM_PORCELAIN_BLADE_TIP, utility = ITEM_MANDATE_SACRED_DEATH },
			tank = { combat = ITEM_PORCELAIN_BLADE_TIP, utility = ITEM_MANDATE_SACRED_DEATH },
		},
		nemesis = {
			dps = { combat = ITEM_PORCELAIN_BLADE_TIP, utility = ITEM_OVERFLOWING_VOIDSPIRE },
			heal = { combat = ITEM_PORCELAIN_BLADE_TIP, utility = ITEM_OVERFLOWING_VOIDSPIRE },
			tank = { combat = ITEM_PORCELAIN_BLADE_TIP, utility = ITEM_OVERFLOWING_VOIDSPIRE },
		},
	},
}

ns.DELVE_CURIO_ITEM_IDS = {}
do
	local seen = ns.DELVE_CURIO_ITEM_IDS
	for _, pack in pairs(ns.DELVE_CURIOS_BY_SEASON) do
		if type(pack) == "table" then
			for _, bucket in pairs(pack) do
				if type(bucket) == "table" then
					for _, pick in pairs(bucket) do
						if type(pick) == "table" then
							if pick.combat then
								seen[pick.combat] = true
							end
							if pick.utility then
								seen[pick.utility] = true
							end
						end
					end
				end
			end
		end
	end
end

function ns.IsDelveCurioItemID(itemID)
	return ns.DELVE_CURIO_ITEM_IDS[tonumber(itemID)] == true
end

ns.DELVE_CURIO_ROLES = { "dps", "heal", "tank" }

ns.DELVE_CURIO_ROLE_ATLASES = {
	dps = { "roleicon-tiny-dps", "spec-role-dps" },
	heal = { "roleicon-tiny-healer", "spec-role-healer" },
	tank = { "roleicon-tiny-tank", "spec-role-tank" },
}

ns.DELVE_CURIO_ROLE_LABEL_KEYS = {
	dps = "DELVE_CURIO_ROLE_DPS",
	heal = "DELVE_CURIO_ROLE_HEAL",
	tank = "DELVE_CURIO_ROLE_TANK",
}

--- The delve season the client reports, or nil when it will not say.
---
--- ⚠️ IT USED TO `return 1` WHEN THE API WAS ABSENT, and that quietly defeated the
--- no-fallback guarantee twenty lines below. `GetDelveCurioSeasonTable` refuses to serve
--- Season 1 advice for an unknown season — but if the season number itself falls back to
--- 1, the lookup never sees an unknown season and hands over the Season 1 pack anyway.
--- The guard and the hole were in the same file.
---
--- nil now means nil. Every caller in this module treats it as "we have nothing to say",
--- which is the honest answer when the client will not tell us where we are.
function ns.GetDelvesSeasonNumber()
	if C_DelvesUI and C_DelvesUI.GetCurrentDelvesSeasonNumber then
		local ok, sn = pcall(C_DelvesUI.GetCurrentDelvesSeasonNumber)
		if ok and sn ~= nil then
			local n = math.floor(tonumber(sn) or 0)
			if n >= 1 then
				return n
			end
		end
	end
	return nil
end

--- Curio advice for a season, or nil when we have none for it.
--- NO fallback to season 1. This used to `return ns.DELVE_CURIOS_BY_SEASON[1]`
--- for any unknown season, which reads as harmless but is the worst case in
--- practice: on the normal Season 2 path the API correctly reports season 2, we
--- have no pack for it, and the advisor would then confidently recommend Season 1
--- curios — items that may not even exist any more. Every consumer already guards
--- for nil (they hide the line), so nothing is better than something wrong.
function ns.GetDelveCurioSeasonTable(season)
	season = tonumber(season) or ns.GetDelvesSeasonNumber()
	if not season then
		return nil
	end
	return ns.DELVE_CURIOS_BY_SEASON[season]
end

--- Do we have curio advice for the season this client is actually in?
---
--- One place for the question, because three surfaces need it: the embedded panel on the
--- Delves tab, the auto-showing popup, and `/mh curio`. Without it the popup opens with a
--- title, a hint and no rows — a window that looks like an answer and is not one.
--- @return boolean hasAdvice, number|nil season
function ns.HasDelveCurioAdvice()
	local season = ns.GetDelvesSeasonNumber()
	if not season then
		return false, nil
	end
	return ns.GetDelveCurioSeasonTable(season) ~= nil, season
end

--- Recommendations for one role; variant is "default" or "nemesis".
function ns.GetDelveCurioPick(season, role, variant)
	local pack = ns.GetDelveCurioSeasonTable(season)
	if not pack then
		return nil
	end
	variant = variant or "default"
	local bucket = pack[variant] or pack.default
	if not bucket then
		return nil
	end
	return bucket[role] or bucket.dps
end

function ns.RequestDelveCurioItemData(season)
	season = tonumber(season) or (ns.GetDelvesSeasonNumber and ns:GetDelvesSeasonNumber()) or 1
	local pack = ns.GetDelveCurioSeasonTable(season)
	if not pack or not C_Item or not C_Item.RequestLoadItemDataByID then
		return
	end
	local seen, queued = {}, false
	local function req(id)
		id = tonumber(id)
		if id and not seen[id] then
			seen[id] = true
			local cached = C_Item.IsItemDataCachedByID
				and select(2, pcall(C_Item.IsItemDataCachedByID, id))
			if not cached then
				queued = true
			end
			pcall(C_Item.RequestLoadItemDataByID, id)
		end
	end
	for _, bucket in pairs(pack) do
		if type(bucket) == "table" then
			for _, pick in pairs(bucket) do
				if type(pick) == "table" then
					req(pick.combat)
					req(pick.utility)
				end
			end
		end
	end
	return queued
end

function ns.GetDelveCurioItemName(itemID)
	itemID = tonumber(itemID)
	if not itemID then
		return "?"
	end
	if C_Item and C_Item.GetItemInfo then
		local ok, name = pcall(C_Item.GetItemInfo, itemID)
		if ok and name and name ~= "" then
			return name
		end
	end
	if GetItemInfo then
		local name = GetItemInfo(itemID)
		if name and name ~= "" then
			return name
		end
	end
	return ("#%d"):format(itemID)
end

function ns.GetDelveCurioItemIcon(itemID)
	itemID = tonumber(itemID)
	if not itemID then
		return 134400
	end
	if C_Item and C_Item.GetItemIconByID then
		local ok, tex = pcall(C_Item.GetItemIconByID, itemID)
		if ok and tex then
			return tex
		end
	end
	if GetItemIcon then
		local tex = GetItemIcon(itemID)
		if tex then
			return tex
		end
	end
	return 134400
end

function ns.GetDelveCurioItemLink(itemID)
	itemID = tonumber(itemID)
	if not itemID then
		return nil
	end
	if C_Item and C_Item.GetItemLink then
		local ok, link = pcall(C_Item.GetItemLink, itemID)
		if ok and link then
			return link
		end
	end
	if GetItemLink then
		return GetItemLink(itemID)
	end
	return nil
end

function ns.IsPlayerInNemesisDelve()
	if ns.GetActiveDelveTipEntryForPlayer then
		local entry = ns:GetActiveDelveTipEntryForPlayer()
		if entry and entry.rosterName == "Torment's Rise" then
			return true
		end
	end
	return false
end

--------------------------------------------------------------------------------
-- Valeera's Poisons choice node — patch 12.1 / Season 2.
--
-- MEASURED, not datamined. Re-captured 2026-09-02 from the LIVE client via
-- `/mh valeera save`: tree 1223, node 110784, **six** entries. The first capture
-- (PTR build 120100, 2026-07-27) found three; see the note above the ids for what
-- that cost. docs/PTR_VALEERA_TREE.md holds the full tree.
--
-- ⚠️ THE EARLIER IDS ON FILE WERE WRONG. Notes from 12 July carried
-- 1248517 / 1251113 / 1251862 from Wowhead; not one matches the client. Had this
-- shipped on those, the advisor would have named three spells that do not exist,
-- in a feature whose whole job is telling people what to pick.
--
-- ⚠️ NO RECOMMENDATION HERE, DELIBERATELY. Wowhead's effect descriptions came
-- paired with those wrong ids, so the name-to-effect mapping is unproven too. The
-- advisor therefore shows each poison's own description straight from the client
-- and lets the player choose. To add a recommendation later, read the three
-- descriptions in-game and write down what they actually do -- never restore the
-- Wowhead text from memory.
--
-- Poisons are SPELLS, not items: names resolve via C_Spell.GetSpellName, so no
-- name is stored here either.
--------------------------------------------------------------------------------

-- 🔴 THREE OF THESE SIX WERE MISSING UNTIL 2026-09-02, AND THE ADVISOR NEVER SAID SO.
-- The three above were captured on the PTR on 2026-07-27, when the node really did hold
-- three entries. Live build 120100 holds six: the 1305xxx ids below did not exist yet on
-- that PTR build and were added between the capture and the patch going live.
--
-- Two things went wrong at once, and only the first is obvious:
--   1. `GetDelvePoisonRows` walks `choices`, so the panel listed 3 of 6 — an advice screen
--      quietly hiding half the options it exists to compare.
--   2. `GetEquippedDelvePoison` matches the slotted entryID against `choices` and returns
--      nil when nothing matches. A player who had one of the missing three slotted saw NO
--      "equipped" marker at all — indistinguishable from "we cannot read your tree".
--
-- 📌 A hardcoded list of a choice node's options is a claim that the node has exactly
-- those options, and nothing re-checked it. `/mh valeera save` is what re-checks it; run
-- it after any patch that touches the companion, not just when something looks wrong.
local POISON_SOULTHIRST_VENOM = 1250826
local POISON_FORGOTTEN_MASTER = 1249934
local POISON_BLOODCRYPT_TOXIN = 1251120
local POISON_BURSTING_TOAD_TOXIN = 1305904
local POISON_FROSTHEART_VENOM = 1305912
local POISON_PHANTASMAL_SPORE_TOXIN = 1305924

ns.DELVE_POISONS_BY_SEASON = {
	[2] = {
		-- The trait node the choice lives on, kept so the advisor can read which
		-- one is currently slotted rather than asking the player.
		nodeID = 110784,
		-- Listed in the order the client returned them.
		-- MEASURED 2026-09-02 from live build 120100, tree 1223, config 57650559.
		choices = {
			{ spellID = POISON_SOULTHIRST_VENOM, entryID = 137812 },
			{ spellID = POISON_FORGOTTEN_MASTER, entryID = 137801 },
			{ spellID = POISON_BLOODCRYPT_TOXIN, entryID = 137790 },
			{ spellID = POISON_BURSTING_TOAD_TOXIN, entryID = 137779 },
			{ spellID = POISON_FROSTHEART_VENOM, entryID = 137769 },
			{ spellID = POISON_PHANTASMAL_SPORE_TOXIN, entryID = 137758 },
		},
	},
}

--- Poisons for a season, or nil.
--- Same rule as the curios above: NO fallback to another season. Poisons do not
--- exist on 12.0.7, and offering season 2's data to a season 1 client would be
--- advising on something the player cannot see.
--- @param season number|nil
function ns.GetDelvePoisonsForSeason(season)
	season = tonumber(season)
	if not season then
		return nil
	end
	return ns.DELVE_POISONS_BY_SEASON[season]
end
