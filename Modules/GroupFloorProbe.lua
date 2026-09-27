--[[
	/mh groupmap -- what can an addon still see of the group INSIDE a dungeon or raid?

	Rob, 27 sep 2026: Cisca died in a raid, came back to life inside it, and could not find
	the group again. The minimap shows one floor at a time. Before building anything we need
	to know what 12.1 still lets an addon read in an instance: which map (floor) each group
	member is on, and whether any position comes back at all. Positions of others inside
	instances have been blocked for years (INFERRED, not measured on 12.1), so measure first.

	Prints per unit and also saves the result to ns.db.groupMapProbe, so the SavedVariables
	file holds it after a /reload (docs: savedvariables-diagnostics).
]]

local _, ns = ...

local function Show(v)
	if v == nil then
		return "nil"
	end
	if issecretvalue and issecretvalue(v) then
		return "SECRET"
	end
	return tostring(v)
end

local function Units()
	local out = { "player" }
	if IsInRaid and IsInRaid() then
		local n = GetNumGroupMembers and GetNumGroupMembers() or 0
		for i = 1, math.min(n, 10) do
			out[#out + 1] = "raid" .. i
		end
	else
		for i = 1, 4 do
			if UnitExists("party" .. i) then
				out[#out + 1] = "party" .. i
			end
		end
	end
	return out
end

function ns.PrintGroupMapProbe()
	local prefix = ("|cffffcc00%s|r"):format(ns:L("PRINT_PREFIX"))
	local rows = {}
	local inside, kind = false, nil
	if IsInInstance then
		inside, kind = IsInInstance()
	end
	local iName = GetInstanceInfo and select(1, GetInstanceInfo()) or nil
	print(("%s group map probe -- instance: %s (%s, %s)"):format(prefix, Show(iName), Show(inside), Show(kind)))

	for _, unit in ipairs(Units()) do
		local name = UnitName and UnitName(unit) or unit
		local okM, mapID = pcall(C_Map.GetBestMapForUnit, unit)
		mapID = okM and mapID or nil
		local mapName, mapType
		if mapID and not (issecretvalue and issecretvalue(mapID)) then
			local okI, info = pcall(C_Map.GetMapInfo, mapID)
			if okI and type(info) == "table" then
				mapName, mapType = info.name, info.mapType
			end
		end
		local x, y
		if mapID and not (issecretvalue and issecretvalue(mapID)) then
			local okP, pos = pcall(C_Map.GetPlayerMapPosition, mapID, unit)
			if okP and pos and pos.GetXY then
				x, y = pos:GetXY()
			end
		end
		local okU, ux, uy = pcall(UnitPosition, unit)
		if not okU then
			ux, uy = "error", nil
		end
		rows[#rows + 1] = {
			unit = unit, name = Show(name), mapID = Show(mapID), mapName = Show(mapName),
			mapType = Show(mapType), x = Show(x), y = Show(y), ux = Show(ux), uy = Show(uy),
		}
		print(("   %-7s %-14s map %s '%s' (type %s) · pos %s,%s · UnitPosition %s,%s"):format(
			unit, Show(name), Show(mapID), Show(mapName), Show(mapType), Show(x), Show(y), Show(ux), Show(uy)))
	end

	-- The floors of the map you are on, as Blizzard's own floor dropdown lists them.
	local floors = {}
	local okB, myMap = pcall(C_Map.GetBestMapForUnit, "player")
	if okB and myMap and C_Map.GetMapGroupID then
		local okG, groupID = pcall(C_Map.GetMapGroupID, myMap)
		if okG and groupID and C_Map.GetMapGroupMembersInfo then
			local okF, list = pcall(C_Map.GetMapGroupMembersInfo, groupID)
			if okF and type(list) == "table" then
				for _, f in ipairs(list) do
					floors[#floors + 1] = ("%s '%s'"):format(Show(f.mapID), Show(f.name))
				end
			end
		end
	end
	print("   floors of this map: " .. (#floors > 0 and table.concat(floors, ", ") or "none (single-level map)"))

	if ns.db then
		ns.db.groupMapProbe = {
			at = date and date("%Y-%m-%d %H:%M") or "?",
			instance = Show(iName), inside = Show(inside), kind = Show(kind),
			rows = rows, floors = floors,
		}
	end
end
