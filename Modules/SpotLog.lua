local _, ns = ...

--[[
	Midnight Helper — /mh here: write down where you are standing.

	Rob, 18 aug: "welke commando kan ik het beste gebruiken voor de windcaller
	coordinaten?" There was no good answer, which is why he has spent two days
	reading numbers off screenshots and typing them into chat.

	This is the same lesson as the achievement criteria yesterday: the data should
	arrive in the SavedVariables, not through a photograph of a chat frame. He stands
	somewhere, types six characters, and moves on. One /reload at the end hands over
	everything at once.

	⚠️ It APPENDS. A list, never a single slot — the whole point is walking a circuit
	and collecting several places before reloading. Overwriting would mean one
	measurement per reload, which is the shape that made this tedious to begin with.

	Captures the target's name too, because "the Windcaller at 49.99/61.93" is a
	different fact from "49.99/61.93", and the second one is nearly useless a week
	later. Nothing is invented: no target means no name recorded.
]]

local function Prefix()
	return "|cff8fd3ffMidnight Helper|r"
end

--- `/mh quest` — the id and title of the quest window currently open.
---
--- Rob, 19 aug, with "Seasonal Refresher: Midnight" on screen from Valeera: "kenden we
--- de Delves season 2 quest al?" We did not, and there was no way to find out but to
--- search a guide for a name and hope the id matched — which is the shape that produced
--- the wrong 96466 and cost two days.
---
--- The quest is right there in front of him. `GetQuestID()` answers while the offer or
--- detail frame is up, so the client names its own quest and nobody guesses.
---
--- ⚠️ Appends to the same log as `/mh here`, deliberately. A quest and a coordinate are
--- both "something I found while playing", and splitting them into two lists would mean
--- two reloads to collect one afternoon.
function ns.LogQuestHere()
	local id
	if GetQuestID then
		local ok, v = pcall(GetQuestID)
		id = ok and tonumber(v) or nil
	end
	if not id or id == 0 then
		print(("%s |cffff5040No quest window open — open the quest first, then type this.|r")
			:format(Prefix()))
		return
	end

	--- The title from the frame if the client will give it, never typed in from the
	--- screenshot. A secret or missing title is recorded as absent rather than invented.
	local title
	if GetTitleText then
		local ok, v = pcall(GetTitleText)
		if ok and ns.CanAccessText and ns.CanAccessText(v) and v ~= "" then
			title = v
		end
	end
	if not title and C_QuestLog and C_QuestLog.GetTitleForQuestID then
		local ok, v = pcall(C_QuestLog.GetTitleForQuestID, id)
		if ok and ns.CanAccessText and ns.CanAccessText(v) then
			title = v
		end
	end

	ns.db = ns.db or {}
	ns.db.spots = ns.db.spots or {}
	ns.db.spots[#ns.db.spots + 1] = {
		kind = "quest",
		questID = id,
		title = title,
	}
	print(("%s |cff40c040quest %d|r  %s"):format(
		Prefix(), id, title or "|cff8a8f98(no readable title)|r"))
	print(("   |cff8a8f98Written down — /reload saves it. %d entr%s in the log.|r"):format(
		#ns.db.spots, #ns.db.spots == 1 and "y" or "ies"))
end

--- Where the player is, as map id and 0-100 coordinates.
--- @return number|nil mapID, number|nil x, number|nil y, string|nil zoneName
local function Here()
	if not (C_Map and C_Map.GetBestMapForUnit) then
		return nil
	end
	local ok, mapID = pcall(C_Map.GetBestMapForUnit, "player")
	if not ok or not mapID then
		return nil
	end
	local x, y
	if C_Map.GetPlayerMapPosition then
		local okP, pos = pcall(C_Map.GetPlayerMapPosition, mapID, "player")
		if okP and pos and pos.GetXY then
			local okXY, a, b = pcall(pos.GetXY, pos)
			if okXY and type(a) == "number" then
				x, y = a * 100, b * 100
			end
		end
	end
	local zone
	if C_Map.GetMapInfo then
		local okI, info = pcall(C_Map.GetMapInfo, mapID)
		if okI and type(info) == "table" and type(info.name) == "string" then
			zone = info.name
		end
	end
	return mapID, x, y, zone
end

--- The name of whatever is targeted, or nil. Used as the label for the spot.
---
--- ⚠️ `type(x) == "string"` IS TRUE FOR A SECRET STRING. Rob targeted the Timeworn
--- Golem on 18 aug and this threw: "attempt to index local 'name' (a secret string
--- value)". The type check passed, and `name:find` then indexed a value the client
--- will not let us read.
---
--- I made this exact mistake on 16 aug, wrote it down, and made it again two days
--- later — the note said the flag must GATE the read, and here it was not consulted
--- at all. `issecretvalue` first, always, before anything touches the value.
---
--- Returning nil is right: a secret name is unreadable, not absent, and a spot with
--- no label is still a useful measurement.
local function TargetName()
	if not (UnitExists and UnitExists("target") and UnitName) then
		return nil
	end
	local ok, name = pcall(UnitName, "target")
	if not ok or not (ns.CanAccessText and ns.CanAccessText(name)) then
		return nil
	end
	if name:find("%w") then
		return name
	end
	return nil
end

--- `/mh here [note]` — append this spot to ns.db.spots.
function ns.LogSpotHere(note)
	local mapID, x, y, zone = Here()
	if not (mapID and x and y) then
		-- Position is unavailable in a few places (some instances, mid-loading). Say
		-- so rather than writing a row with holes in it that reads like a measurement.
		print(("%s |cffff5040no position right now|r — try again in a moment, or step outside."):format(Prefix()))
		return
	end

	ns.db = ns.db or {}
	ns.db.spots = ns.db.spots or {}

	local row = {
		mapID = mapID,
		x = tonumber(("%.2f"):format(x)),
		y = tonumber(("%.2f"):format(y)),
		zone = zone,
		target = TargetName(),
		note = (type(note) == "string" and note:find("%w")) and note or nil,
		when = date and date("%Y-%m-%d %H:%M:%S") or nil,
	}
	ns.db.spots[#ns.db.spots + 1] = row

	print(("%s |cff40d060%d.|r %s  |cffffd100%.2f / %.2f|r  %s%s"):format(
		Prefix(), #ns.db.spots, zone or ("map " .. mapID), row.x, row.y,
		row.target and ("|cff8fd3ff" .. row.target .. "|r") or "",
		row.note and ("  " .. row.note) or ""))
	print("   |cff8a8f98/reload writes the list to the DB.|r")
end

--- `/mh here clear` — start a fresh circuit.
function ns.ClearSpotLog()
	ns.db = ns.db or {}
	local n = ns.db.spots and #ns.db.spots or 0
	ns.db.spots = nil
	print(("%s cleared %d spot%s."):format(Prefix(), n, n == 1 and "" or "s"))
end
