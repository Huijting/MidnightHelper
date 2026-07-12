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
