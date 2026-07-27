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

-- 14 = Normal, the same default DBM's dev dump uses. Mythic (23) can list extra
-- bosses, so /mh ej takes a difficulty argument for a second pass.
local EJ_DEFAULT_DIFF = 14

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
		if EJ_GetCreatureInfo and encounterID then
			for c = 1, 10 do
				local okC, creatureID, creatureName = pcall(EJ_GetCreatureInfo, c, encounterID)
				if not okC or not creatureID then
					break
				end
				print(("        creatureID=%-8s %s"):format(tostring(creatureID), tostring(creatureName)))
			end
		end
	end
	if found == 0 then
		print("   no encounters listed. Wrong id, or nothing at this difficulty --")
		print("   try mythic:  /mh ej " .. tostring(instanceID) .. " 23")
	end
end

--- /mh ej [instanceID] [difficulty] — list this tier's instances, or dump one.
function ns.PrintEncounterJournalDump(arg, diffArg)
	local prefix = ejPrefix()
	if not (EJ_GetEncounterInfoByIndex and EJ_GetInstanceByIndex) then
		print(prefix .. " Encounter Journal API not available.")
		return
	end

	local diff = tonumber(diffArg) or EJ_DEFAULT_DIFF
	local restore = BorrowDifficulty(diff)

	local one = tonumber(arg)
	if one then
		DumpInstance(one, "instance", diff)
		ReturnDifficulty(restore)
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
	print(("%s Encounter Journal, tier %s (%s), read at difficulty %s"):format(
		prefix, tostring(tier), tostring(tierName or "?"), tostring(diff)))
	if restore == nil then
		print("   |cffff8080Could not set the difficulty|r -- boss counts may read 0.")
	end

	for _, isRaid in ipairs({ false, true }) do
		print(("   -- %s --"):format(isRaid and "raids" or "dungeons"))
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
	end
	print("   Then: /mh ej <id> for every encounterID + creatureID of one instance.")
	print("   Mythic-only bosses: add a difficulty, e.g. /mh ej 1322 23")
	ReturnDifficulty(restore)
end
