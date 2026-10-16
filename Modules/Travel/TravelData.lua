local _, ns = ...

--[[
	Midnight Helper — Travel, part 1 of 5: the knowledge base (docs/TRAVEL_DESIGN_2026-10-16.md §2.1).

	Phase 1 (16 Oct 2026, Rob: "begin met fase 1"): one INDEX over the travel tables that already exist, plus the
	constants that were copied into ≥ 8 modules. The tables themselves stay where they are until phase 2/3 moves
	their readers over; this file only reads them, so nothing a player sees changes.

	Agreed rule for two values of one place (Rob, 16 Oct 2026): measured by Rob > HandyNotes > Zygor > guide.
	`/mh travel` lists what the index holds and flags any two points of the same kind on the same map that lie
	close together with different numbers — the shape of the five conflicts fixed in phase 1a.
]]

ns.Travel = ns.Travel or {}
local T = ns.Travel

T.CAPITAL = { Alliance = 84, Horde = 85 } -- Stormwind City, Orgrimmar
T.HUB = 2393 -- Silvermoon City (Midnight)

--- The player's capital uiMap (84/85), by faction; Alliance when the faction cannot be read (a neutral Pandaren).
function T.MyCapital()
	local fac = UnitFactionGroup and UnitFactionGroup("player")
	return T.CAPITAL[fac] or T.CAPITAL.Alliance
end

--- Every travel point the addon knows, as one flat list: { map, x, y, to, kind, label, source, table }.
--- Built on demand from the existing tables, so it is always in step with them.
function T.Nodes()
	local out = {}
	local function add(n)
		if n.map and n.x and n.y then
			out[#out + 1] = n
		end
	end
	for _, p in ipairs(ns.MIDNIGHT_PORTALS or {}) do
		add({ map = p.mapID, x = p.x, y = p.y, to = p.toID, kind = "portal", label = p.name, table = "MIDNIGHT_PORTALS" })
		if p.door then
			add({ map = p.mapID, x = p.door.x, y = p.door.y, to = p.mapID, kind = "door", label = p.name,
				table = "MIDNIGHT_PORTALS.door" })
		end
	end
	for key, hub in pairs(ns.MOUNTRUN_HUBS or {}) do
		for _, side in ipairs({ "A", "H", "both" }) do
			local p = hub[side]
			if p then
				add({ map = p[1], x = p[2], y = p[3], to = p.to or hub.to, kind = hub.kind, label = key, side = side,
					table = "MOUNTRUN_HUBS." .. side })
			end
		end
		if hub.via and hub.both then
			add({ map = hub.both[1], x = hub.via[1], y = hub.via[2], kind = "door", label = key, table = "MOUNTRUN_HUBS.via" })
		end
	end
	for m, row in pairs(ns.MOUNTRUN_HOME or {}) do
		for _, side in ipairs({ "A", "H" }) do
			local p = row[side]
			if p then
				add({ map = m, x = p[1], y = p[2], to = side == "H" and 85 or 84, kind = "portal", label = "home", side = side,
					table = "MOUNTRUN_HOME." .. side })
			end
		end
		if row.via then
			add({ map = m, x = row.via[1], y = row.via[2], kind = "door", label = "home", table = "MOUNTRUN_HOME.via" })
		end
	end
	for _, hub in ipairs(ns.AMANI_HUBS or {}) do
		add({ map = 2509, x = hub.npcX, y = hub.npcY, kind = "gossip", label = hub.key, table = "AMANI_HUBS" })
	end
	return out
end

--- Pairs that look like one place stored twice: same map, same kind, same destination, same faction, within `near`
--- map-percent, but not equal. Rob's first `/mh travel` (16 Oct 2026) flagged three pairs that were two different
--- portals side by side (Voidstorm → Silvermoon / → Harandar; Azsuna's Alliance and Horde portals) — so destination
--- and faction now have to match too.
function T.FindConflicts(near)
	near = near or 0.6
	local nodes, found = T.Nodes(), {}
	local function SameTo(a, b)
		return tostring(a.to) == tostring(b.to)
	end
	local function SameSide(a, b)
		return not (a.side and b.side and a.side ~= "both" and b.side ~= "both" and a.side ~= b.side)
	end
	for i = 1, #nodes do
		for j = i + 1, #nodes do
			local a, b = nodes[i], nodes[j]
			if a.map == b.map and a.kind == b.kind and SameTo(a, b) and SameSide(a, b) and (a.x ~= b.x or a.y ~= b.y) then
				local d = math.sqrt((a.x - b.x) ^ 2 + (a.y - b.y) ^ 2)
				if d < near then
					found[#found + 1] = { a = a, b = b, d = d }
				end
			end
		end
	end
	return found
end

--- `/mh travel` — what the knowledge base holds, and any place stored twice with different numbers.
function T.PrintStatus()
	local p = "|cffffcc00Midnight Helper:|r"
	local nodes = T.Nodes()
	local per = {}
	for _, n in ipairs(nodes) do
		per[n.table] = (per[n.table] or 0) + 1
	end
	print(("%s travel knowledge base: %d points"):format(p, #nodes))
	local names = {}
	for k in pairs(per) do
		names[#names + 1] = k
	end
	table.sort(names)
	for _, k in ipairs(names) do
		print(("   %-24s %d"):format(k, per[k]))
	end
	local here = T.PlayerMap and T.PlayerMap()
	print(("   you are on map %s (%s), continent %s, capital %s"):format(tostring(here),
		tostring(T.MapName and T.MapName(here) or "?"), tostring(T.Continent and T.Continent(here) or "?"),
		tostring(T.MyCapital())))
	local conflicts = T.FindConflicts()
	if #conflicts == 0 then
		print("   |cff44ff44no place stored twice with different numbers|r")
	else
		print(("   |cffff8040%d place(s) stored twice with different numbers:|r"):format(#conflicts))
		for _, c in ipairs(conflicts) do
			print(("     map %s %s: %.2f/%.2f (%s) vs %.2f/%.2f (%s)"):format(tostring(c.a.map), tostring(c.a.kind),
				c.a.x, c.a.y, c.a.table, c.b.x, c.b.y, c.b.table))
		end
	end
end
