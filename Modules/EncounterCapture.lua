--[[
	Midnight Helper — encounter/instance ID capture (dev tool, opt-in).
	For grabbing the data Spec 01 needs on the PTR: per-boss encounterIDs (from the
	ENCOUNTER_START event when you pull a boss) and the current instance's Encounter
	Journal id. Prints to chat; nothing is stored or shipped. Off by default.

	/mh encounters — toggle ENCOUNTER_START/END logging.
	/mh instance   — one-shot: print this instance's journalInstanceID + name.
]]

local _, ns = ...

local function on()
	return ns.db and ns.db.encounterCapture == true
end

local f = CreateFrame("Frame")
f:RegisterEvent("ENCOUNTER_START")
f:RegisterEvent("ENCOUNTER_END")
f:SetScript("OnEvent", function(_, ev, encounterID, encounterName, difficultyID, groupSize, success)
	if not on() then
		return
	end
	local prefix = ("|cffffcc00%s|r"):format(ns:L("PRINT_PREFIX"))
	if ev == "ENCOUNTER_START" then
		print(("%s ENCOUNTER_START  encounterID=|cffffffff%s|r  '%s'  diff=%s  size=%s"):format(
			prefix, tostring(encounterID), tostring(encounterName), tostring(difficultyID), tostring(groupSize)
		))
	else
		print(("%s ENCOUNTER_END    encounterID=%s  '%s'  success=%s"):format(
			prefix, tostring(encounterID), tostring(encounterName), tostring(success)
		))
	end

	-- KEEP IT TOO. Printing alone means the numbers have to be copied out of chat
	-- mid-run, which is the one thing Rob cannot do while playing — the same reason
	-- the vignette recorder and /mh capture write to SavedVariables. A dungeon's three
	-- bosses are three chat lines that scroll away behind loot spam.
	if not ns.db then
		return
	end
	if type(ns.db.encounterLog) ~= "table" then
		ns.db.encounterLog = {}
	end
	local log = ns.db.encounterLog
	if #log >= 200 then
		return
	end
	local mapID
	if C_Map and C_Map.GetBestMapForUnit then
		local okM, m = pcall(C_Map.GetBestMapForUnit, "player")
		mapID = okM and m or nil
	end
	local journalID
	if EJ_GetInstanceForMap and mapID then
		local okJ, jid = pcall(EJ_GetInstanceForMap, mapID)
		if okJ then
			journalID = jid
		end
	end
	local instName, instType, instMapID
	if GetInstanceInfo then
		local okI, n, ty = pcall(GetInstanceInfo, nil)
		if okI then
			instName, instType = n, ty
		end
		instMapID = select(8, GetInstanceInfo())
	end
	log[#log + 1] = {
		event = ev,
		encounterID = encounterID,
		encounterName = (type(encounterName) == "string"
			and not (issecretvalue and issecretvalue(encounterName))) and encounterName or nil,
		difficultyID = difficultyID,
		groupSize = groupSize,
		success = success,
		mapID = mapID,
		journalInstanceID = journalID,
		instanceName = instName,
		instanceType = instType,
		instanceMapID = instMapID,
	}
end)

function ns.ToggleEncounterCapture()
	ns.db = ns.db or {}
	ns.db.encounterCapture = not (ns.db.encounterCapture == true)
	return ns.db.encounterCapture == true
end

-- /mh instance — print the current instance's Encounter Journal id + name, plus a
-- GetInstanceInfo fallback, so Spec 01's journalInstanceID can be captured in-game.
function ns.PrintInstanceCapture()
	local prefix = ("|cffffcc00%s|r"):format(ns:L("PRINT_PREFIX"))
	local mapID = C_Map and C_Map.GetBestMapForUnit and C_Map.GetBestMapForUnit("player")
	local jid, jname
	if EJ_GetInstanceForMap and mapID then
		local ok, id, name = pcall(EJ_GetInstanceForMap, mapID)
		if ok then
			jid, jname = id, name
		end
	end
	local iName, iType, _, diffName, _, _, _, iMapID = GetInstanceInfo()
	print(("%s Instance capture"):format(prefix))
	print(("   journalInstanceID=|cffffffff%s|r  '%s'  (uiMapID %s)"):format(tostring(jid), tostring(jname), tostring(mapID)))
	print(("   GetInstanceInfo: '%s'  type=%s  diff=%s  instanceMapID=%s"):format(
		tostring(iName), tostring(iType), tostring(diffName), tostring(iMapID)
	))
	print("   Pull each boss with /mh encounters ON to capture per-boss encounterIDs.")
end

--------------------------------------------------------------------------------
-- /mh ej  — read the whole roster straight out of the Encounter Journal.
--
-- Written 2026-07-27, the day the Season 2 dungeon test window closes on the PTR.
-- The two commands above need you to PULL a boss to learn its encounterID, which
-- is fine over a season and useless on the last afternoon of a test window. The
-- journal already knows every boss in every dungeon, so this walks it instead: no
-- group, no pulls, no wipes.
--
-- API verified against installed addons rather than assumed:
--   EJ_GetEncounterInfoByIndex(i, instanceID) -> name, _, encounterID
--       (DBM-Core/modules/DevTools.lua:545)
--   EJ_GetCreatureInfo(index, encounterID)    -> id, name, ... (2nd is the name,
--       DBM-Core/modules/objects/BossMod.lua:120; 5th is the icon, BossHelper:375)
--
-- ⚠️ DIFFICULTY IS NOT OPTIONAL. The first version refused to call EJ_SetDifficulty
-- on the grounds that it changes what the player's own journal is showing. Correct
-- in principle and useless in practice: Rob's journal sat at difficulty 0 and every
-- single instance reported "0 bosses" (2026-07-27). DBM says why, at
-- DBM-Core/modules/DevTools.lua:542 -- "Make sure it's set to right difficulty or
-- it'll ignore mobs" -- and defaults to 14 (Normal).
--
-- So it now sets a difficulty, reads, and puts the previous one back. Borrowing a
-- setting and returning it is a different thing from silently repointing someone's
-- UI. EJ_SelectTier is still never called: the tier is the one thing you can see at
-- a glance in the journal, and it is reported in the header.
--------------------------------------------------------------------------------

local function ejPrefix()
	return ("|cffffcc00%s|r"):format(ns:L("PRINT_PREFIX"))
end

-- DIFFICULTY IS PER INSTANCE TYPE, which the first fix missed. 14 is Normal RAID:
-- with it the raids listed correctly (Tidebound Grotto 1 boss, Venomous Abyss 8)
-- and every dungeon still read 0. Dungeons need a dungeon difficulty -- 23, Mythic,
-- lists the most. Measured on the PTR 2026-07-27: `/mh ej 1322 23` returned Altar
-- of Fangs' three bosses, matching the 3 the patch notes describe.
local EJ_DIFF_RAID = 14
local EJ_DIFF_DUNGEON = 23

--- Borrow the journal's difficulty for the length of one read.
--- @return number|nil previous  what to hand back, or nil if we changed nothing
local function BorrowDifficulty(diff)
	if not (EJ_SetDifficulty and EJ_GetDifficulty) then
		return nil
	end
	local okGet, prev = pcall(EJ_GetDifficulty)
	if not okGet then
		return nil
	end
	local okSet = pcall(EJ_SetDifficulty, diff)
	if not okSet then
		return nil
	end
	return prev
end

local function ReturnDifficulty(prev)
	-- Only ever hand back a real difficulty. Rob's journal was sitting at 0, which
	-- is what caused the empty listing in the first place; restoring that would put
	-- the broken state back and make the next run fail the same way.
	if type(prev) == "number" and prev > 0 and EJ_SetDifficulty then
		pcall(EJ_SetDifficulty, prev)
	end
end

--- What one boss drops, straight from the Adventure Guide.
---
--- ⚠️ WHY THIS EXISTS. The tier-set guide tells players which raid bosses drop their
--- class token. That text was written for Season 1 and still names The Voidspire and
--- The Dreamrift, while Season 2 runs on The Venomous Abyss — so as of 12.1 it sends
--- people to last season's raid. Rather than retype it from a website, ask the client
--- which bosses actually drop the tokens now.
---
--- ⚠️ THE FIRST VERSION ASKED FOR ALL FOUR AT ONCE AND GOT NOTHING, 43 TIMES.
---
--- It required EJ_SelectEncounter, EJ_GetNumLoot and EJ_GetLootInfoByIndex together
--- and bailed on the whole set. Rob's run wrote "EJ loot API missing on this client"
--- for every boss, which was true and useless: it never said WHICH one was missing.
---
--- The answer is that the loot reader moved namespace while the rest did not. Details
--- calls `EJ_GetNumLoot()` bare and `C_EncounterJournal.GetLootInfoByIndex(i)`
--- namespaced, in adjacent lines (Libs/DF/ejournal.lua:379-382) -- a split nobody
--- invents. Candidate, not proof, which is exactly why each name is resolved
--- separately below and the outcome recorded: one more run now settles all four
--- instead of me guessing which combination the client actually has.
local LootApi
local function ResolveLootApi()
	if LootApi then
		return LootApi
	end
	local CEJ = C_EncounterJournal
	local function pick(bare, field)
		if type(bare) == "function" then
			return bare, "bare"
		end
		if CEJ and type(CEJ[field]) == "function" then
			return CEJ[field], "C_EncounterJournal"
		end
		return nil, "missing"
	end
	local api, where = {}, {}
	api.selectInstance, where.selectInstance = pick(EJ_SelectInstance, "SelectInstance")
	api.selectEncounter, where.selectEncounter = pick(EJ_SelectEncounter, "SelectEncounter")
	api.numLoot, where.numLoot = pick(EJ_GetNumLoot, "GetNumLoot")
	api.lootByIndex, where.lootByIndex = pick(EJ_GetLootInfoByIndex, "GetLootInfoByIndex")
	api.where = where
	LootApi = api
	return api
end

--- Point the journal at one instance. The loot list belongs to whatever the journal
--- currently has selected, so this has to happen before the encounter loop.
local function SelectLootInstance(instanceID)
	local api = ResolveLootApi()
	if api.selectInstance and instanceID then
		pcall(api.selectInstance, instanceID)
	end
end

--- 🔴 THE JOURNAL FILTERS ITS LOOT, AND THE FIRST CAPTURE INHERITED THAT.
---
--- Rob's run returned 5 to 9 items per raid boss and exactly two head pieces across
--- all eight bosses of The Venomous Abyss -- no shoulder, chest, hands or legs token
--- anywhere. A tier set needs five slots, so that was not the raid's loot table; it
--- was the raid's loot table as seen through his own class filter, which the journal
--- keeps between sessions and applies to every read.
---
--- Left alone this would have produced a confident, specific, wrong answer about
--- which bosses drop tier -- the exact failure this capture exists to prevent.
---
--- Two filters, both cleared and both restored: EJ_SetLootFilter(classID, specID) and
--- C_EncounterJournal.SetSlotFilter. Restoring matters because these are the player's
--- own Adventure Guide settings, not ours to leave changed.
local function WithLootFiltersCleared(fn)
	local prevClass, prevSpec, prevSlot
	local note = {}
	if type(EJ_GetLootFilter) == "function" then
		local ok, c, s = pcall(EJ_GetLootFilter)
		if ok then
			prevClass, prevSpec = c, s
			note.hadClassFilter = (tonumber(c) or 0) ~= 0
		end
	end
	if type(EJ_SetLootFilter) == "function" then
		note.clearedClass = pcall(EJ_SetLootFilter, 0, 0) or nil
		-- ⚠️ pcall succeeding says the CALL worked, not that the list rebuilt. Pass one
		-- reported clearedClass=true and still returned nothing but Leather, which is
		-- Rob's druid. Record what the journal says the filter is NOW, so the next
		-- capture proves the clear instead of asserting it.
		if type(EJ_GetLootFilter) == "function" then
			local okAfter, c, s = pcall(EJ_GetLootFilter)
			if okAfter then
				note.classAfterClear = c
				note.specAfterClear = s
			end
		end
	else
		note.clearedClass = false
	end
	local CEJ = C_EncounterJournal
	if CEJ and type(CEJ.GetSlotFilter) == "function" then
		local ok, v = pcall(CEJ.GetSlotFilter)
		if ok then
			prevSlot = v
		end
	end
	if CEJ and type(CEJ.SetSlotFilter) == "function" and Enum and Enum.ItemSlotFilterType then
		note.clearedSlot = pcall(CEJ.SetSlotFilter, Enum.ItemSlotFilterType.NoFilter) or nil
	else
		note.clearedSlot = false
	end

	local ok, err = pcall(fn, note)

	if prevClass ~= nil and type(EJ_SetLootFilter) == "function" then
		pcall(EJ_SetLootFilter, prevClass, prevSpec or 0)
	end
	if prevSlot ~= nil and CEJ and type(CEJ.SetSlotFilter) == "function" then
		pcall(CEJ.SetSlotFilter, prevSlot)
	end
	if not ok then
		error(err, 0)
	end
	return note
end

--- Is this loot item part of a set, in the game's own words?
---
--- ⚠️ NOT a guess from the item's name or its filterType. TierSet.lua already knows
--- the authoritative marker and has used it for months: a set piece carries a
--- "(n/5)" line in its own tooltip, and that is how the equipped-piece counter works
--- (TierSet.lua:49). The same test applied to a journal item answers "is this tier"
--- without inventing a rule.
---
--- Why it is needed at all: The Venomous Abyss turned out to contain no class tokens.
--- Every armour piece has a real armour type, and no armour type gets all five tier
--- slots -- cloth has no chest, mail no hands, plate no shoulder. So either tier is
--- not a token this season, or these items are the tier and it drops as ordinary
--- gear. The names cannot tell those apart. The tooltip can.
---
--- 🔴 IT DOES NOT WORK, AND THE ONLY REASON WE KNOW IS THE POSITIVE CONTROL.
---
--- Measured 25 aug 2026. Across the whole capture there are 115 tier-slot drops. All
--- 115 tooltips read cleanly -- zero unreadable, so this was not a cold cache -- and
--- every single one came back with NO set line. Including The Voidspire, a Season 1
--- raid that certainly had tier sets.
---
--- A test that answers "no" for a raid we know says "yes" is not measuring anything.
--- The reason is that a set line counts YOUR equipped pieces ("(2/5)"), so an item
--- the player does not own has no set context to render and the line never appears.
--- TierSet.lua:49 works because it reads gear off the player's own body.
---
--- ⚠️ THIS WAS ONE STEP FROM SHIPPING. The Venomous Abyss had already come back with
--- no class tokens, and this test agreeing would have made "Season 2 has no tier set"
--- look confirmed from two directions. It is a large claim about the game and it was
--- about to rest on an instrument that returns the same answer for everything.
---
--- So it no longer returns false, because false reads as "not a set piece" and that is
--- a conclusion this cannot support. It records that the question was asked and cannot
--- be answered from outside the player's own inventory. Left in place rather than
--- deleted so the next person does not rebuild it.
local TIER_SLOT_NAMES = {
	Head = true, Shoulder = true, Chest = true, Hands = true, Legs = true,
}
local function ReadItemSetLine(itemID, slot)
	if not itemID or not slot or not TIER_SLOT_NAMES[slot] then
		return nil
	end
	if not (C_TooltipInfo and C_TooltipInfo.GetItemByID) then
		return "no C_TooltipInfo.GetItemByID"
	end
	local ok, data = pcall(C_TooltipInfo.GetItemByID, itemID)
	if not ok or type(data) ~= "table" or type(data.lines) ~= "table" then
		return "tooltip unreadable"
	end
	for _, line in ipairs(data.lines) do
		local t = line and line.leftText
		if type(t) == "string" and t:match("%((%d+)/%d+%)") then
			-- Kept because a future patch may start rendering it. If this ever fires,
			-- the comment above is out of date and the finding is real.
			return t
		end
	end
	return "no set line — but this test cannot see one on unowned items (see comment)"
end

local function CaptureBossLoot(encounterID)
	if not encounterID then
		return nil
	end
	local api = ResolveLootApi()
	if not api.numLoot or not api.lootByIndex then
		-- Say which names were tried and how each one resolved, so a second run is not
		-- needed to learn what this one already knew.
		return { unavailable = "loot reader missing", resolved = api.where }
	end
	if api.selectEncounter and not pcall(api.selectEncounter, encounterID) then
		return { unavailable = "SelectEncounter failed", resolved = api.where }
	end
	local okN, n = pcall(api.numLoot)
	if not okN or type(n) ~= "number" then
		return { unavailable = "GetNumLoot gave nothing", resolved = api.where }
	end
	local out = { count = n, resolved = api.where, items = {} }
	for i = 1, n do
		local okL, info = pcall(api.lootByIndex, i)
		if okL and type(info) == "table" then
			local row = {
				itemID = info.itemID,
				name = info.name,
				slot = info.slot,
				armorType = info.armorType,
				filterType = info.filterType,
				encounterID = info.encounterID,
			}
			row.setLine = ReadItemSetLine(info.itemID, info.slot)
			out.items[#out.items + 1] = row
		end
	end
	return out
end

--- Every boss of one instance: encounterID + the creature ids behind it.
local function DumpInstance(instanceID, label, diff)
	local prefix = ejPrefix()
	print(("%s %s  journalInstanceID=|cffffffff%s|r  (difficulty %s)"):format(
		prefix, label or "instance", tostring(instanceID), tostring(diff)))
	local found = 0
	for i = 1, 25 do
		local ok, name, _, encounterID = pcall(EJ_GetEncounterInfoByIndex, i, instanceID)
		if not ok or not name then
			break
		end
		found = found + 1
		print(("   %d. |cffffffff%s|r  encounterID=|cff40c040%s|r"):format(i, tostring(name), tostring(encounterID)))
		-- ⚠️ The first return is the JOURNAL's own creature entry id, not the NPC id.
		-- Altar of Fangs came back as 6210/6230/6218 -- far too low for Midnight NPCs,
		-- which sit in the hundreds of thousands. This was labelled "creatureID" for
		-- one run on 2026-07-27; do not relabel it back. For a real NPC id, pull the
		-- boss with /mh encounters on, or read it from the combat log.
		--- ⚠️ THE FOURTH RETURN IS THE MODEL, AND IT IS THE ONE WE ACTUALLY NEEDED.
		---
		--- The boss window shows no 3D model for any Altar of Fangs boss, because our
		--- CREATURES table is built from DBM's `SetCreatureID` and DBM has that line
		--- commented out for all three of them — with the same number in each,
		--- `231631`, which is Kroluk from Windrunner Spire. A copied template with the
		--- placeholder left in. Taking DBM's word there would have rendered Kroluk for
		--- three different bosses.
		---
		--- Rob's instinct was to look the ids up online. Fair, and Wowhead is an allowed
		--- source for candidates — but this project's record with looked-up ids is poor
		--- (all three Valeera poison ids wrong, Theremis's coordinates off), and a
		--- looked-up id still has to be checked here afterwards.
		---
		--- So ask the client instead. `EJ_GetCreatureInfo`'s 4th return is the display
		--- id, and DBM-Core uses exactly that for its own boss models
		--- (`modules/objects/BossMod.lua:130`: `obj.modelId = select(4, ...)`). It comes
		--- from the Adventure Guide, so it needs no dungeon run and no website, and it
		--- works for bosses DBM has nothing for at all.
		if EJ_GetCreatureInfo and encounterID then
			for c = 1, 10 do
				local okC, ejCreature, creatureName, _, displayID = pcall(EJ_GetCreatureInfo, c, encounterID)
				if not okC or not ejCreature then
					break
				end
				print(("        ejCreature=%-8s displayID=|cff40c040%-8s|r %s"):format(
					tostring(ejCreature), tostring(displayID), tostring(creatureName)))
			end
		end
	end
	if found == 0 then
		print("   no encounters listed. Wrong id, or nothing at this difficulty --")
		print("   try mythic:  /mh ej " .. tostring(instanceID) .. " 23")
	end
end

--- Collect one instance into a plain table instead of printing it.
--- Same reads as DumpInstance; kept separate so the printing path stays readable.
local function CollectInstance(instanceID, name, isRaid, diff)
	local entry = {
		id = instanceID,
		name = name,
		isRaid = isRaid and true or false,
		difficulty = diff,
		bosses = {},
	}
	-- Before the loop: the journal's loot list follows the SELECTED instance, and its
	-- class/slot filters are the player's own and would otherwise hide most of it.
	entry.lootFilters = WithLootFiltersCleared(function()
	SelectLootInstance(instanceID)
	for i = 1, 25 do
		local ok, bossName, _, encounterID = pcall(EJ_GetEncounterInfoByIndex, i, instanceID)
		if not ok or not bossName then
			break
		end
		local boss = { index = i, name = bossName, encounterID = encounterID, creatures = {} }
		boss.loot = CaptureBossLoot(encounterID)
		if EJ_GetCreatureInfo and encounterID then
			for c = 1, 10 do
				local okC, ejCreature, creatureName, _, displayID = pcall(EJ_GetCreatureInfo, c, encounterID)
				if not okC or not ejCreature then
					break
				end
				-- ejCreature is the JOURNAL's creature entry id, not the NPC id.
				-- displayID (4th return) is what a model frame wants — see DumpInstance.
				boss.creatures[#boss.creatures + 1] = {
					ejCreature = ejCreature,
					name = creatureName,
					displayID = displayID,
				}
			end
		end
		entry.bosses[#entry.bosses + 1] = boss
	end
	end)
	return entry
end

--- /mh ej save — write the whole tier into SavedVariables instead of chat.
---
--- A full listing is eleven instances of scrollback, which is unreadable in chat
--- and worse in a screenshot. An addon cannot write files, but SavedVariables IS a
--- file, so this parks the capture in ns.db.ejCapture and the .lua on disk can be
--- read directly. Same trick as ns.db.probeNodes.
---
--- ⚠️ SavedVariables are only flushed on /reload or logout. Without that step the
--- file on disk still holds the previous session and looks like the capture failed.
--- 🔴 TWO PASSES, AND THE FIRST ONE IS THROWN AWAY ON PURPOSE.
---
--- Three captures in a row came back wrong in three different ways, and all three had
--- the same shape: ask and read in the same breath.
---
---   1. loot API "missing"  -- one bare name had moved namespace
---   2. 5-9 items a boss    -- the journal's slot filter was still on
---   3. every piece Leather -- the CLASS filter reported cleared and was not, because
---                             EJ_SetLootFilter does not rebuild the list synchronously
---
--- On top of that roughly half the items came back with no name at all: item data is a
--- cache, and an id nobody has looked at is cold. Reading it once returns "?" and
--- writing that down would have meant a token list with holes exactly where the
--- unlooked-at items are -- which is to say, exactly where the tokens are.
---
--- So the first pass exists only to warm things up: it clears the filters, walks every
--- boss, and requests item data for every id it sees. The second pass, a beat later,
--- is the one that gets saved. Rob asked for this to be done properly rather than
--- quickly, which is the only reason it now is.
local function RequestAllLootItemData(cap)
	if not (C_Item and C_Item.RequestLoadItemDataByID) then
		return 0
	end
	local n, seen = 0, {}
	for _, inst in ipairs(cap.instances or {}) do
		for _, boss in ipairs(inst.bosses or {}) do
			local loot = boss.loot
			for _, it in ipairs((loot and loot.items) or {}) do
				local id = tonumber(it.itemID)
				if id and not seen[id] then
					seen[id] = true
					n = n + 1
					pcall(C_Item.RequestLoadItemDataByID, id)
				end
			end
		end
	end
	return n
end

function ns.SaveEncounterJournalCapture(isSecondPass)
	local prefix = ejPrefix()
	if not (EJ_GetInstanceByIndex and EJ_GetEncounterInfoByIndex) then
		print(prefix .. " Encounter Journal API not available.")
		return
	end
	ns.db = ns.db or {}

	local tier
	if EJ_GetCurrentTier then
		local okC, t = pcall(EJ_GetCurrentTier)
		tier = okC and t or nil
	end
	local tierName
	if EJ_GetTierInfo and tier then
		local okT, n = pcall(EJ_GetTierInfo, tier)
		tierName = okT and n or nil
	end

	local cap = {
		captured = (time and time()) or 0,
		build = select(4, GetBuildInfo()),
		tier = tier,
		tierName = tierName,
		instances = {},
	}

	local totalBosses = 0
	for _, isRaid in ipairs({ false, true }) do
		local diff = isRaid and EJ_DIFF_RAID or EJ_DIFF_DUNGEON
		local restore = BorrowDifficulty(diff)
		for i = 1, 40 do
			local ok, instanceID, name = pcall(EJ_GetInstanceByIndex, i, isRaid)
			if not ok or not instanceID then
				break
			end
			local entry = CollectInstance(instanceID, name, isRaid, diff)
			totalBosses = totalBosses + #entry.bosses
			cap.instances[#cap.instances + 1] = entry
		end
		ReturnDifficulty(restore)
	end

	if not isSecondPass then
		-- Pass one is the warm-up: it is NOT saved. Ask for everything, then read it
		-- back a beat later, because none of this answers in the same frame.
		local asked = RequestAllLootItemData(cap)
		print(("%s pass 1: asked the server for %d items and cleared the journal's filters."):format(
			prefix, asked))
		print("   |cff8a8f98Reading again in a moment -- the first read is thrown away on purpose.|r")
		if C_Timer and C_Timer.After then
			C_Timer.After(3, function()
				ns.SaveEncounterJournalCapture(true)
			end)
			return
		end
		-- No timer available: save what we have rather than nothing, and say so.
		cap.warning = "single pass only (no C_Timer); names and filters may be stale"
	end

	ns.db.ejCapture = cap
	local named, total = 0, 0
	for _, inst in ipairs(cap.instances) do
		for _, boss in ipairs(inst.bosses or {}) do
			for _, it in ipairs((boss.loot and boss.loot.items) or {}) do
				total = total + 1
				if it.name and it.name ~= "" then
					named = named + 1
				end
			end
		end
	end
	print(("%s captured %d instances, %d bosses, tier %s (%s)."):format(
		prefix, #cap.instances, totalBosses, tostring(tier), tostring(tierName or "?")))
	-- The named/total ratio is the honest health check: a low one means the cache was
	-- still cold and the capture should not be trusted for anything item-shaped.
	print(("   loot: %d items, %d with a readable name (%d%%)."):format(
		total, named, total > 0 and math.floor(named / total * 100) or 0))
	print("   |cffffff78Now type /reload|r -- SavedVariables only reach disk on reload or logout.")
end

--- /mh ej [instanceID] [difficulty] — list this tier's instances, or dump one.
function ns.PrintEncounterJournalDump(arg, diffArg)
	local prefix = ejPrefix()
	if not (EJ_GetEncounterInfoByIndex and EJ_GetInstanceByIndex) then
		print(prefix .. " Encounter Journal API not available.")
		return
	end

	local one = tonumber(arg)
	if one then
		local diff = tonumber(diffArg) or EJ_DIFF_DUNGEON
		local restore = BorrowDifficulty(diff)
		DumpInstance(one, "instance", diff)
		ReturnDifficulty(restore)
		return
	end

	-- /mh ej all [difficulty] — every instance of this tier, in full, in one go.
	-- Built for a PTR test window that closes the same day: seven dungeons is seven
	-- commands and seven screenshots otherwise.
	if type(arg) == "string" and arg:lower() == "all" then
		local askedDiff = tonumber(diffArg)
		for _, isRaid in ipairs({ false, true }) do
			local diff = askedDiff or (isRaid and EJ_DIFF_RAID or EJ_DIFF_DUNGEON)
			local restore = BorrowDifficulty(diff)
			for i = 1, 40 do
				local ok, instanceID, name = pcall(EJ_GetInstanceByIndex, i, isRaid)
				if not ok or not instanceID then
					break
				end
				DumpInstance(instanceID, tostring(name), diff)
			end
			ReturnDifficulty(restore)
		end
		return
	end

	local tier
	if EJ_GetCurrentTier then
		local okC, t = pcall(EJ_GetCurrentTier)
		tier = okC and t or nil
	end
	local tierName
	if EJ_GetTierInfo and tier then
		local okT, n = pcall(EJ_GetTierInfo, tier)
		tierName = okT and n or nil
	end
	print(("%s Encounter Journal, tier %s (%s)"):format(
		prefix, tostring(tier), tostring(tierName or "?")))

	for _, isRaid in ipairs({ false, true }) do
		-- Count at the difficulty that type actually uses, or the count is a lie:
		-- at raid difficulty 14 every dungeon reported 0 bosses (PTR, 2026-07-27).
		local diff = tonumber(diffArg) or (isRaid and EJ_DIFF_RAID or EJ_DIFF_DUNGEON)
		local restore = BorrowDifficulty(diff)
		print(("   -- %s (difficulty %d) --"):format(isRaid and "raids" or "dungeons", diff))
		local n = 0
		for i = 1, 40 do
			local ok, instanceID, name = pcall(EJ_GetInstanceByIndex, i, isRaid)
			if not ok or not instanceID then
				break
			end
			n = n + 1
			local bosses = 0
			for b = 1, 25 do
				local okB, bn = pcall(EJ_GetEncounterInfoByIndex, b, instanceID)
				if not okB or not bn then
					break
				end
				bosses = bosses + 1
			end
			print(("   id |cffffffff%-6s|r %-34s %d bosses"):format(
				tostring(instanceID), tostring(name), bosses))
		end
		if n == 0 then
			print("     none listed for this tier.")
		end
		ReturnDifficulty(restore)
	end
	print("   Then: /mh ej <id> for one instance, or /mh ej all for every one of them.")
end

--------------------------------------------------------------------------------
-- /mh delvescan [save] — which delves does the client actually offer today?
--
-- Written 2026-07-27 to answer "are there new delves in 12.1" with a measurement
-- instead of a datamine. Wowhead named three (The Ring of Glory, Gnarldor Isle,
-- Venomfall Deeps) back in June; that is the same class of source that produced
-- three wrong achievement names in a row the day before.
--
-- ⚠️ READ THE RESULT CORRECTLY. C_AreaPoiInfo.GetDelvesForMap returns the delves
-- the map is OFFERING, not a catalogue. A name that shows up is proof it exists;
-- a name that does not show up proves nothing at all -- it may simply not be in
-- today's rotation. Never write "delve X does not exist in 12.1" off this.
--
-- The zone list is MH's own (DelveBossShowcase's STORY_ZONE_MAPS). Broker_Midnight-
-- Events scans the same API, but it is GPL v2 and MH is MIT, so nothing is copied
-- from it -- calling the same Blizzard function is not borrowing.
--------------------------------------------------------------------------------

local DELVE_SCAN_MAPS = { 2393, 2437, 2395, 2424, 2444, 2413, 2405, 2576 }

--- Walk every Midnight zone and collect whatever delves it lists.
--- @return table rows, number total
local function CollectDelves()
	local rows, total = {}, 0
	if not (C_AreaPoiInfo and C_AreaPoiInfo.GetDelvesForMap and C_AreaPoiInfo.GetAreaPOIInfo) then
		return rows, 0
	end
	for _, mapID in ipairs(DELVE_SCAN_MAPS) do
		local zoneName
		if C_Map and C_Map.GetMapInfo then
			local okM, mi = pcall(C_Map.GetMapInfo, mapID)
			zoneName = (okM and type(mi) == "table") and mi.name or nil
		end
		local okList, poiIDs = pcall(C_AreaPoiInfo.GetDelvesForMap, mapID)
		if okList and type(poiIDs) == "table" then
			for _, poiID in ipairs(poiIDs) do
				local okInfo, info = pcall(C_AreaPoiInfo.GetAreaPOIInfo, mapID, poiID)
				if okInfo and type(info) == "table" then
					local x, y
					if info.position and info.position.GetXY then
						local okXY, px, py = pcall(info.position.GetXY, info.position)
						if okXY and px then
							x, y = px * 100, (py or 0) * 100
						end
					end
					total = total + 1
					rows[#rows + 1] = {
						mapID = mapID,
						zone = zoneName,
						poiID = poiID,
						name = info.name,
						description = info.description,
						atlas = info.atlasName,
						textureKit = info.uiTextureKit,
						x = x,
						y = y,
					}
				end
			end
		end
	end
	return rows, total
end

--- /mh delvescan — print what is on offer right now.
function ns.PrintDelveScan()
	local prefix = ejPrefix()
	local rows, total = CollectDelves()
	if total == 0 then
		print(prefix .. " no delves listed by C_AreaPoiInfo in any Midnight zone.")
		print("   Either the API is unavailable, or nothing is on offer on this map right now.")
		return
	end
	print(("%s %d delves on offer (this is today's rotation, not a catalogue):"):format(prefix, total))
	local lastMap
	for _, r in ipairs(rows) do
		if r.mapID ~= lastMap then
			print(("   -- %s (map %s) --"):format(tostring(r.zone or "?"), tostring(r.mapID)))
			lastMap = r.mapID
		end
		print(("     |cffffffff%s|r  poi=%s  at %.1f, %.1f"):format(
			tostring(r.name), tostring(r.poiID), r.x or 0, r.y or 0))
	end
end

--- /mh delvescan save — park it in SavedVariables (then /reload).
function ns.SaveDelveScan()
	local prefix = ejPrefix()
	ns.db = ns.db or {}
	local rows, total = CollectDelves()
	ns.db.delveScan = {
		captured = (time and time()) or 0,
		build = select(4, GetBuildInfo()),
		rows = rows,
	}
	print(("%s captured %d delves into SavedVariables."):format(prefix, total))
	print("   |cffffff78Now type /reload|r -- SavedVariables only reach disk on reload or logout.")
end

--------------------------------------------------------------------------------
-- /mh zone — what does Midnight Helper know about where you are standing?
--
-- Written 2026-07-27 as the honest half of "block 12: Coiled Isle scaffold".
--
-- The scaffold itself cannot be built. Patch 12.1 adds the Coiled Isle, and its
-- map id has not been datamined -- only that the zone exists, with a raid entrance
-- and gathering nodes. Inventing a map id to scaffold against is exactly the kind
-- of guess this addon does not ship, and a scaffold pinned to a wrong id is worse
-- than none: it would look finished.
--
-- So this is the precondition instead. Walk into a new zone on patch day, run one
-- command, and every number needed to build the scaffold is measured rather than
-- datamined -- the same move that turned the Season 2 roster from a guess into
-- data on 27 July.
--
-- It also answers the question the empty-zone guard is really about: "is there
-- nothing here, or do we simply not know?" Those are different statements and
-- only one of them is ours to make.
--------------------------------------------------------------------------------

--- /mh zone — report the current zone and MH's coverage of it.
function ns.PrintZoneReport()
	local prefix = ejPrefix()
	if not (C_Map and C_Map.GetBestMapForUnit) then
		print(prefix .. " C_Map not available.")
		return
	end
	local okMap, mapID = pcall(C_Map.GetBestMapForUnit, "player")
	mapID = okMap and mapID or nil
	if not mapID then
		print(prefix .. " no map for the player right now (loading screen?).")
		return
	end

	local info
	if C_Map.GetMapInfo then
		local ok, mi = pcall(C_Map.GetMapInfo, mapID)
		info = ok and mi or nil
	end

	print(("%s Zone report"):format(prefix))
	print(("   uiMapID     = |cffffffff%s|r"):format(tostring(mapID)))
	if type(info) == "table" then
		print(("   name        = %s"):format(tostring(info.name)))
		print(("   mapType     = %s   parent = %s"):format(
			tostring(info.mapType), tostring(info.parentMapID)))
	end

	-- Player position, in the form our data tables use.
	if C_Map.GetPlayerMapPosition then
		local okPos, pos = pcall(C_Map.GetPlayerMapPosition, mapID, "player")
		if okPos and pos and pos.GetXY then
			local okXY, x, y = pcall(pos.GetXY, pos)
			if okXY and x then
				print(("   you are at  = %.2f, %.2f"):format(x * 100, (y or 0) * 100))
			end
		end
	end

	-- ⚠️ Can a route even exist HERE? Rob, 16 aug: "in de delves kunnen we ook een route
	-- inbouwen voor de treasures". HandyNotes already has the chest coordinates on real
	-- delve-interior maps (2535, 2502, 2633, 2635, …), so the data is not the question.
	-- Whether navigation works inside an instance is, and these three lines answer it
	-- without designing anything first.
	--
	-- The two are NOT the same test. Blizzard's user waypoint is often refused inside
	-- instances; our own arrow only needs GetWorldPosFromMapPos to return a position.
	-- If the waypoint is refused but world coords work, MH can still draw a direction —
	-- and the feature is buildable by a route the outdoor code never uses.
	--
	-- ⚠️ And here the usual fallback is WRONG. MHResolveWaypointMap walks up to a parent
	-- map that accepts a waypoint; for a chest inside a delve that parent is the world
	-- outside, so it would happily point you out of the cave. Whatever gets built for
	-- delves must not silently inherit that.
	if C_Map.CanSetUserWaypointOnMap then
		local okW, canWay = pcall(C_Map.CanSetUserWaypointOnMap, mapID)
		print(("   waypoint    = %s"):format(
			(okW and canWay) and "|cff40c040this map accepts one|r"
			or "|cffffd100refused here — Blizzard's pin cannot be placed|r"))
	end
	if C_Map.GetWorldPosFromMapPos and CreateVector2D then
		local okC, cont, world = pcall(C_Map.GetWorldPosFromMapPos, mapID, CreateVector2D(0.5, 0.5))
		local wx, wy
		if okC and world and world.GetXY then
			local okXY, a, b = pcall(world.GetXY, world)
			if okXY then
				wx, wy = a, b
			end
		end
		if wx then
			print(("   world pos   = |cff40c040yes|r  continent %s  (%.0f, %.0f) — our own arrow can work here"):format(
				tostring(cont), wx, wy))
		else
			print("   world pos   = |cffff5040none — no direction or distance can be computed on this map|r")
		end
	end
	if IsInInstance then
		local okI, inInst, instType = pcall(IsInInstance)
		if okI then
			print(("   instance    = %s%s"):format(tostring(inInst),
				instType and ("  type " .. tostring(instType)) or ""))
		end
	end

	-- ⚠️ TESTING AN ASSUMPTION THAT COST A FEATURE. DelveCoach turned off its
	-- target-based prompt on 9 jul with the reason that a delve boss cannot be told
	-- from trash because "GUID/npcID kan in 12.x secret zijn". That was never measured;
	-- it is written in the code as a fact and it is the only reason clicking a boss
	-- does nothing. Rob asked about exactly that today.
	--
	-- If a target GUID reads normally here, the reason is void and the feature can come
	-- back. If it really is secret, we will have measured it once instead of inheriting
	-- it forever. Either answer is worth more than the sentence in the comment.
	if UnitExists and UnitExists("target") then
		local okG, guid = pcall(UnitGUID, "target")
		local secret = false
		if okG and issecretvalue then
			local okS, v = pcall(issecretvalue, guid)
			secret = okS and v or false
		end
		-- ⚠️ `type(guid) == "string"` IS TRUE FOR A SECRET STRING. The first version
		-- checked whether the value was secret, stored the answer, and then called
		-- guid:match() anyway — a probe written to find out whether something may be
		-- touched, touching it. Rob's client threw "attempt to index local 'guid' (a
		-- secret string value)" on the delve's final boss, 16 aug.
		--
		-- The secret flag must GATE the read, not merely be reported next to it.
		local npcID
		if okG and not secret and type(guid) == "string" then
			npcID = tonumber(guid:match("^%a+%-%d+%-%d+%-%d+%-%d+%-(%d+)"))
		end
		print(("   target      = %s"):format(
			secret and "|cffffd100secret value|r"
			or ((okG and type(guid) == "string") and guid or "|cffff5040unreadable|r")))
		print(("      secret   = %s   npcID = %s"):format(
			tostring(secret), tostring(npcID or "-")))
		if secret then
			print("      |cffff5040Measured: the 9 jul reason HOLDS. A delve boss cannot be identified by npcID.|r")
		elseif npcID then
			print("      |cff40c040Readable here — the 9 jul reason does not hold on this target.|r")
		end
	else
		print("   target      = |cff8a8f98nothing targeted — target a boss and run this again|r")
	end

	-- Coverage. The whole point: an empty list and an unknown zone must not look
	-- the same.
	local covered, zoneKey = false, nil
	if ns.IsZoneCovered then
		covered, zoneKey = ns.IsZoneCovered(mapID)
	end
	if covered then
		local n = ns.GetZoneRareCount and ns.GetZoneRareCount(zoneKey)
		print(("   coverage    = |cff40c040known|r as '%s'%s"):format(
			tostring(zoneKey), n and (", %d rares listed"):format(n) or ""))
	else
		print("   coverage    = |cffe8c36aNOT KNOWN to Midnight Helper|r")
		print("      Nothing is broken. Zone features will say they have no list for")
		print("      here, which is true, rather than showing an empty one.")
	end

	-- Anything the client itself offers here, whether or not we cover the zone.
	if C_AreaPoiInfo and C_AreaPoiInfo.GetDelvesForMap then
		local okD, ids = pcall(C_AreaPoiInfo.GetDelvesForMap, mapID)
		local n = (okD and type(ids) == "table") and #ids or 0
		print(("   delves here = %d (from the client, not from our data)"):format(n))
	end
	if EJ_GetInstanceForMap then
		local okE, instanceID, instanceName = pcall(EJ_GetInstanceForMap, mapID)
		if okE and instanceID and instanceID ~= 0 then
			print(("   journal     = instance %s '%s'"):format(
				tostring(instanceID), tostring(instanceName)))
		end
	end

	print("   To add a rare from where you stand: /mh capture")
end
