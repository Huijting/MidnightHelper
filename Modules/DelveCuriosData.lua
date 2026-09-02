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
-- What Blizzard calls each choice slot.
--
-- ✅ MEASURED 2026-09-02 from Valeera's own window, which lists four rows:
--     Combat Role    Tank
--     Poisons        Bursting Toad Toxin      -> node 110784
--     Combat Curio   Corrosive Bilespear      -> node 110786
--     Utility Curio  Soul-Cracking Dreamcatcher -> node 110785
-- Matching each name to its node is unambiguous because the slotted pick is
-- printed beside it, and those three spells sit in exactly those three nodes.
--
-- 🔴 THIS REPLACES A CLAIM THAT WAS SIMPLY FALSE. CurioExplain said "the game
-- does not name these slots in a way we can read, so they are numbered rather
-- than guessed at" — and numbering them was the right call while that held. It
-- stopped holding the moment anyone looked at the window. Nobody had.
--
-- ⚠️ Keyed by nodeID, never by order. An unknown node still renders, with the
-- old numbered label; a label can therefore never hide an option.
--
-- ⚠️ AND THE LABELS STAY ENGLISH. These are Blizzard's own UI strings. Dutch has
-- no client, so English is what a Dutch player actually sees. German, French,
-- Spanish, Portuguese and Italian clients DO translate them — but we have not
-- read those windows, and inventing "Kampf-Kuriosität" would name something that
-- may appear on no screen. Read a real client before translating these.
--------------------------------------------------------------------------------

ns.DELVE_CURIO_SLOT_LABEL_KEYS = {
	[110784] = "CURIO_SLOT_POISONS",
	[110785] = "CURIO_SLOT_UTILITY",
	[110786] = "CURIO_SLOT_COMBAT",
}

--- The order Valeera's own window uses, top to bottom.
---
--- ⚠️ NOT THE TREE ORDER. C_Traits.GetTreeNodes returns 110784, 110785, 110786, which
--- renders as Poisons, Utility Curio, Combat Curio — while her window reads Poisons,
--- Combat Curio, Utility Curio. Rob spotted it the minute the panel sat beside her
--- frame on 2 sep: two lists of the same three things in different orders, side by
--- side, and the reader has to do the matching.
---
--- 📌 A node we have no position for is appended in tree order rather than dropped or
--- forced to the top. Unknown slots keep working; they just are not claimed to belong
--- anywhere in particular.
ns.DELVE_CURIO_SLOT_ORDER = { 110784, 110786, 110785 }

--- Sort a list of {nodeID=...} into window order, stable for anything unlisted.
function ns.SortDelveCurioSlots(nodes)
	local rank = {}
	for i, nodeID in ipairs(ns.DELVE_CURIO_SLOT_ORDER) do
		rank[nodeID] = i
	end
	local out = {}
	for i, node in ipairs(nodes) do
		out[i] = node
	end
	local base = #ns.DELVE_CURIO_SLOT_ORDER
	local seen = {}
	for i, node in ipairs(out) do
		seen[node] = rank[node.nodeID] or (base + i)
	end
	table.sort(out, function(a, b)
		return seen[a] < seen[b]
	end)
	return out
end

--------------------------------------------------------------------------------
-- What the guides recommend — the ONE thing /mh curios deliberately would not say.
--
-- Rob asked for this three times, most recently 2 sep 2026: an advice screen that
-- says "wat volgens de meerderheid online het beste is". CurioExplain's header
-- argues the opposite case and the argument is good, so read it before touching
-- this: copying someone's ranking makes us a relay that goes wrong silently.
--
-- 🔴 AND THE GUIDES ARE MEASURABLY UNRELIABLE HERE. The "best Season 2 curios"
-- articles name Sanctum's Edict and Time Lost Edict — Brann curios from The War
-- Within that appear nowhere in Valeera's window. That is not a difference of
-- opinion; it is an article about a thing the reader cannot find.
--
-- 📌 So this ships the recommendation WITH the check the articles skipped. Every
-- id below was read out of Rob's own client on 2 sep 2026 (tree 1223, nodes
-- 110786 and 110785), and the renderer verifies each one is still in the tree it
-- is starring. A pick that is not there is reported, never quietly dropped —
-- because "the star vanished" and "there is no star for this node" look the same.
--
-- ⚠️ NOT MEASURED: that these are the best. We have not tested them. The footer
-- says so in those words, and it must keep saying so.
--------------------------------------------------------------------------------

ns.DELVE_CURIO_GUIDE_PICKS = {
	[2] = {
		-- MEASURED to exist: node 110786 entry 137797, node 110785 entry 137817.
		[1248877] = true, -- Corrosive Bilespear
		[1248896] = true, -- Soul-Cracking Dreamcatcher
	},
}

--- Guide-recommended spellIDs for a season, or nil.
--- Same no-fallback rule as everything else in this file: another season's picks
--- are not a weaker answer, they are a wrong one.
function ns.GetDelveCurioGuidePicks(season)
	season = tonumber(season) or (ns.GetDelvesSeasonNumber and ns.GetDelvesSeasonNumber() or nil)
	if not season then
		return nil
	end
	return ns.DELVE_CURIO_GUIDE_PICKS[season]
end

--- The label for one choice slot, or nil when we have no name for that node.
--- nil means "fall back to the numbered label" — never a guessed name.
function ns.GetDelveCurioSlotLabelKey(nodeID)
	return ns.DELVE_CURIO_SLOT_LABEL_KEYS[tonumber(nodeID) or -1]
end
