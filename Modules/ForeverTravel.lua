local _, ns = ...

--[[
	ForeverTravel.lua — WoW Forever: the travel planner behind the route arrow. Boats, zeppelins, the Deeprun Tram and the
	Darnassus portal, so a target on another continent (or on Teldrassil, or in Ironforge seen from Stormwind) gets
	"first: the boat to Stormwind City" instead of "other continent — travel back first".
	Rob, 10 Nov 2026, in Darkshore on his way to the Two-Handed Mace trainer in Ironforge: "waar ga ik naartoe? … Kunnen we
	dat ook in de Forever versie oplossen?" → "uitzoeken en bouwen graag".

	Data: docs/forever/FOREVER_TRAVEL_LINKS_2026-11-10.md (mh-research, 10 Nov 2026). Stops from the Forever DB2
	TaxiPathNode (1.60.1.70888, GEMETEN), converted to zone x,y (AFGELEID) and matched within 1 unit by Wowhead Forever NPC
	spawns and an independent guide. Rob saw the three Auberdine boats himself that day (Teldrassil, Elwynn/Stormwind,
	Wetlands). Left out: the direct Auberdine <> Menethil boat (probably gone, AFGELEID), the Grom'gol <> Undercity zeppelin
	(both ends in the Eastern Kingdoms; this planner only knows "walk" inside a continent), the Skyborne-only portal and the
	Feathermoon ferry.

	It hooks into NativeArrow.lua through the same names the Midnight travel planner uses (ns.BuildTravelPlan, steps with
	kind/mapID/x/y/label), plus two Forever-only additions: ns.ForeverTravelNeedsLink (Teldrassil and the tram are the same
	continent, but you cannot walk there) and step.forever (a dock elsewhere on your continent may be pointed at).
	/mh travel prints what it decides and why (CLAUDE.md: a module that can stay quiet needs that).
]]

if not ns.IS_FOREVER then
	return
end

local MAP = {
	KALIMDOR = 1414, EK = 1415,
	DARKSHORE = 1439, TELDRASSIL = 1438, DARNASSUS = 1457, STORMWIND = 1453, ELWYNN = 1429, IRONFORGE = 1455,
	DUN_MOROGH = 1426, WETLANDS = 1437, HILLSBRAD = 1424, DUSTWALLOW = 1445, DUROTAR = 1411, TIRISFAL = 1420,
	STV = 1434, BARRENS = 1413, TANARIS = 1446, RIVERGLADES = 2548, ZEPHRAS = 2521, ALTERAC = 1416, MULGORE = 1412,
	FERALAS = 1444,
}

-- Rut'theran Village is on the Teldrassil map but on its own island below the portal. Boat stop 54.9,96.8, portal
-- 55.9,89.6 (GEMETEN). Everything from this line south counts as Rut'theran: AFGELEID, /mh travel shows the verdict.
local RUTTHERAN_MIN_Y = 86

-- kind, side (A/H/nil = both), the two ends, oneway. Costs below are in "minutes-ish"; walking is distance / 250 yd.
-- 18 Nov 2026 (Rob via sparring: "ja"): the boat/zeppelin/skycutter ends are now OUR OWN values - the stop (Delay > 0)
-- of each TaxiPathNode path in DB2 Forever 1.60.1.70959 (path id after the line), converted to the zone map (AFGELEID,
-- mh-research; docs/forever/REIZEN_2026-11-18.md). The old values were equal to Zygor's LibRover (All Rights Reserved).
-- A stop is the ship's centre: 10-20 yd off the dock edge is normal (the arrow arrives within 25 yd for these).
-- A5 (portal) and A6 (tram) are not in the taxi tables and keep their own measured values.
local LINKS = {
	{ id = "A1", kind = "boat", side = "A", a = { MAP.STORMWIND, 21.78, 56.86 }, b = { MAP.DARKSHORE, 30.53, 40.88 } }, -- 11616
	{ id = "A2", kind = "boat", side = "A", a = { MAP.DARKSHORE, 33.31, 39.82 }, b = { MAP.TELDRASSIL, 54.81, 97.22 } }, -- 293
	-- The loop: Menethil > Southshore > Auberdine > Menethil, one way only. Menethil > Auberdine means staying on board.
	-- Path 11167; stops Wetlands 4.49,56.66 > Hillsbrad 50.67,70.44 > Darkshore 32.34,44.13.
	{ id = "A3a", kind = "boat", side = "A", oneway = true, a = { MAP.DARKSHORE, 32.34, 44.13 }, b = { MAP.WETLANDS, 4.49, 56.66 } },
	{ id = "A3c", kind = "boat", side = "A", oneway = true, a = { MAP.HILLSBRAD, 50.67, 70.44 }, b = { MAP.DARKSHORE, 32.34, 44.13 } },
	{ id = "A3m", kind = "loop", side = "A", oneway = true, a = { MAP.WETLANDS, 4.49, 56.66 }, b = { MAP.DARKSHORE, 32.34, 44.13 },
		via = MAP.HILLSBRAD },
	{ id = "A4", kind = "boat", side = "A", a = { MAP.WETLANDS, 4.74, 63.76 }, b = { MAP.DUSTWALLOW, 71.73, 56.66 } }, -- 292
	{ id = "A5", kind = "portal", side = "A", a = { MAP.TELDRASSIL, 55.91, 89.64 }, b = { MAP.DARNASSUS, 30.06, 41.44 },
		aName = "FTRAVEL_RUTTHERAN" },
	{ id = "A6", kind = "tram", side = "A", a = { MAP.STORMWIND, 69.31, 30.56 }, b = { MAP.IRONFORGE, 76.58, 51.14 } },
	{ id = "H1", kind = "zeppelin", side = "H", a = { MAP.DUROTAR, 50.98, 13.91 }, b = { MAP.TIRISFAL, 60.64, 58.93 } }, -- 302
	{ id = "H2", kind = "zeppelin", side = "H", a = { MAP.DUROTAR, 50.47, 12.69 }, b = { MAP.STV, 31.17, 30.45 } }, -- 285
	{ id = "N1", kind = "boat", a = { MAP.BARRENS, 63.80, 38.75 }, b = { MAP.STV, 25.67, 73.08 } }, -- 241
	{ id = "N2", kind = "boat", a = { MAP.TANARIS, 68.58, 22.99 }, b = { MAP.RIVERGLADES, 80.60, 54.61 } }, -- 11391
	{ id = "S1", kind = "sky", side = "A", a = { MAP.ZEPHRAS, 65.84, 83.81 }, b = { MAP.ALTERAC, 12.83, 51.17 }, bName = "FTRAVEL_DALARAN" }, -- 11398
	{ id = "S2", kind = "sky", side = "H", a = { MAP.ZEPHRAS, 57.78, 81.01 }, b = { MAP.MULGORE, 34.33, 26.05 } }, -- 11457
}
local COST = { boat = 4, zeppelin = 4, sky = 4, loop = 7, tram = 1, portal = 0.5 }

-- 21 Nov 2026 (Rob at the tower outside Orgrimmar: "Maar er zijn er twee hier. Hoe weet ik nu precies welke ik moet
-- hebben? Kunnen we het nauwkeuriger maken?"). A tower with two zeppelins: the step points at the zeppelin master of
-- THAT platform and names him. Masters, spots and names per client: Wowhead Forever NPC tooltips, 21 Nov 2026
-- (GEMETEN; neither HandyNotes_WoWForever nor Zygor Forever has them, grep with a positive control). Each master stands
-- next to the DB2 stop of his own crossing (H1a 50.98,13.91 ↔ Frezza 50.8,13.5; H2a 50.47,12.69 ↔ Snurk 50.6,12.8; …).
-- [link id .. boarding end] = { npc, x, y, names }. The map is the link's own end.
local MASTERS = {
	-- dir: GEMETEN by Rob in the game, 21 Nov 2026: he took the SOUTH platform of the Orgrimmar tower and arrived in
	-- Tirisfal Glades. The other one is then the north platform (two platforms; the map agrees: Frezza y 13.5 > Snurk 12.8).
	H1a = { npc = 9564, x = 50.8, y = 13.5, en = "Frezza", ruRU = "Фрезза", dir = "SOUTH" },
	H2a = { npc = 12136, x = 50.6, y = 12.8, dir = "NORTH", en = "Snurk Bucksquick", esES = "Esnur Ciervoveloz", esMX = "Snurk Oroveloz",
		ptBR = "Odete Cobrafrete", ruRU = "Снорк Следопутка" },
	H1b = { npc = 9566, x = 60.8, y = 58.8, en = "Zapetta", ruRU = "Запота" },
	X1b = { npc = 3150, x = 61.8, y = 59.0, en = "Hin Denburg", ruRU = "Гин Денбург" },
	H2b = { npc = 3149, x = 31.4, y = 29.8, en = "Nez'raz", ruRU = "Нез'раз" },
	X1a = { npc = 12137, x = 31.5, y = 29.4, en = "Squibby Overspeck", esES = "Petardo Porsiacaso",
		esMX = "Petardo Porsiacaso", ptBR = "Squibby Talotado", ruRU = "Сквибби Сверхпятнист" },
}
local function MasterName(m)
	local loc = GetLocale and GetLocale() or "enUS"
	return m[loc] or m.en
end

--- "(the south platform, with Frezza)" where the side is known, else "(the platform with Frezza)".
local function PlatformText(m)
	if m.dir then
		return ns:L("FTRAVEL_PLATFORM_" .. m.dir .. "_FMT"):format(MasterName(m))
	end
	return ns:L("FTRAVEL_PLATFORM_FMT"):format(MasterName(m))
end

-- No Hearthstone + a route over the water = a long way back (Rob, 11 Nov 2026, on a Paladin who had sold his to make room:
-- "bouw het stukje maar van, je hebt geen hearthstone, zeker in het begin"). Item 6948 "Hearthstone" in the Forever DB2
-- ItemSparse, 1.60.1.70888 (GEMETEN). The tram and the portal are short hops, so only these kinds count.
local HEARTHSTONE = 6948
local CROSSING = { boat = true, zeppelin = true, loop = true, sky = true }

--- How many Hearthstones you carry; nil when the count cannot be read (then we say nothing).
local function HearthCount()
	local fn = (C_Item and C_Item.GetItemCount) or GetItemCount
	if not fn then
		return nil
	end
	local ok, n = pcall(fn, HEARTHSTONE)
	return ok and tonumber(n) or nil
end

--- True when the plan crosses the water and you have no Hearthstone (counted, not guessed).
local function NoHearthForTrip(steps)
	if not steps then
		return false
	end
	local crosses = false
	for _, s in ipairs(steps) do
		if s.linkKind and CROSSING[s.linkKind] then
			crosses = true
		end
	end
	return crosses and HearthCount() == 0
end
--------------------------------------------------------------------------------
-- Teleports as a first step (20 Nov 2026, Rob via sparring: "Ik volg voorlopig eerst je advies. Dus doe inderdaad dan
-- maar je advies, als those teleports."). Idea from Shortest Path Forever (GPL-3): no code taken.
-- Spell ids, cast 10 s, cooldowns, reagent and levels: GEMETEN in the Forever DB2 1.60.1.70959 (SpellMisc, SpellCastTimes,
-- SpellCooldowns, SpellReagents, SkillLineAbility; mh-research, 20 Nov 2026). Hearthstone 8690: 60 min. Astral Recall 556:
-- 15 min, shaman 30. City teleports: no cooldown, 1 Rune of Teleportation (17031), mage 20 (Darnassus/Thunder Bluff 30).
-- Moonglade 18960: no cooldown, druid 10. Dalaran 1297659: Alliance mage 50.
-- WHERE they land is decided by the server (SpellEffect target 17/9), so not in client data. We do NOT use another
-- addon's landing table (Zygor's is All Rights Reserved). Until MH has seen you land, the destination is that city's
-- innkeeper from our own list (ForeverCitySpots, GEMETEN) — AFGELEID as "somewhere in the city", good enough to choose;
-- after the teleport the arrow plans again from where you really are. Every landing is learned: ns.db.foreverLandings.
-- Hearthstone and Astral Recall go to your bind point: learned from your own landing (per character), else the inn or
-- learned rest place whose name is GetBindLocation().
local MapName, Side, PlayerPos -- defined below; declared here so the teleport code can use them (lint [6])
local TELEPORTS = {
	{ id = "hs", item = HEARTHSTONE, spell = 8690, bind = true },
	{ id = "astral", spell = 556, bind = true },
	{ id = "tp_sw", spell = 3561, side = "A", reagent = 17031, dest = { MAP.STORMWIND, 60.38, 75.27 } },
	{ id = "tp_if", spell = 3562, side = "A", reagent = 17031, dest = { MAP.IRONFORGE, 18.15, 51.44 } },
	{ id = "tp_dar", spell = 3565, side = "A", reagent = 17031, dest = { MAP.DARNASSUS, 67.42, 15.64 } },
	{ id = "tp_dal", spell = 1297659, side = "A", reagent = 17031, dest = { MAP.ALTERAC, 12.20, 66.50 } },
	{ id = "tp_org", spell = 3567, side = "H", reagent = 17031, dest = { 1454, 54.09, 68.40 } },
	{ id = "tp_tb", spell = 3566, side = "H", reagent = 17031, dest = { 1456, 45.81, 64.71 } },
	{ id = "tp_uc", spell = 3563, side = "H", reagent = 17031, dest = { 1458, 67.73, 37.89 } },
	-- Moonglade (uiMap 1450) has no inn in our list. 26 Nov 2026 (Rob in Orgrimmar: the trainer arrow pointed 4493 m to
	-- Thunder Bluff): until MH has seen you land, the destination is Loganaar, the Druid trainer of Moonglade (Wowhead
	-- Forever npc 12042, 52.5,40.5, GEMETEN) — AFGELEID as "somewhere in Moonglade", the same rule as the city inns.
	{ id = "moonglade", spell = 18960, dest = { 1450, 52.5, 40.5 } },
}
-- Costs in the planner's own "minutes-ish" units (AFGELEID): 10 s cast + a loading screen ≈ 0.5, plus the cooldown still
-- to wait, plus TP_MIN so a teleport only wins when it clearly saves time (Shortest Path Forever's idea of a floor).
local TP_CAST, TP_MIN = 0.5, 1.5
local tpWhy = {} -- id -> why it was (not) offered, for /mh travel

local function Known(spell)
	if IsPlayerSpell then
		local ok, v = pcall(IsPlayerSpell, spell)
		if ok and v then
			return true
		end
	end
	if IsSpellKnown then
		local ok, v = pcall(IsSpellKnown, spell)
		if ok and v then
			return true
		end
	end
	return false
end

local function ItemCount(item)
	local fn = (C_Item and C_Item.GetItemCount) or GetItemCount
	if not fn then
		return nil
	end
	local ok, n = pcall(fn, item)
	return ok and tonumber(n) or nil
end

--- Minutes still to wait before this can be used (0 = ready), or nil when unreadable.
local function WaitMin(t)
	local start, dur
	if t.item then
		local fn = (C_Container and C_Container.GetItemCooldown) or (C_Item and C_Item.GetItemCooldown) or GetItemCooldown
		if not fn then
			return nil
		end
		local ok, a, b = pcall(fn, t.item)
		if not ok then
			return nil
		end
		start, dur = a, b
	else
		if C_Spell and C_Spell.GetSpellCooldown then
			local ok, info = pcall(C_Spell.GetSpellCooldown, t.spell)
			if ok and type(info) == "table" then
				start, dur = info.startTime, info.duration
			end
		elseif GetSpellCooldown then
			local ok, a, b = pcall(GetSpellCooldown, t.spell)
			if ok then
				start, dur = a, b
			end
		end
	end
	start, dur = tonumber(start) or 0, tonumber(dur) or 0
	if start <= 0 or dur <= 2 then -- 0, or only the global cooldown
		return 0
	end
	local left = start + dur - GetTime()
	return left > 0 and left / 60 or 0
end

-- 21 Nov 2026 (Rob: "A"): the player GUID through ForeverCharKey.lua. whole: a Hearthstone place is never mixed.
local function CharKey(tbl)
	local n, r = UnitName and UnitName("player"), GetRealmName and GetRealmName()
	local legacy = tostring(n) .. "-" .. tostring(r)
	return ns.ForeverCharKey and ns.ForeverCharKey("hearthstone place (bind)", legacy, tbl, { whole = true }) or legacy
end

local function Bind()
	if not GetBindLocation then
		return nil
	end
	local ok, b = pcall(GetBindLocation)
	return (ok and type(b) == "string" and b ~= "") and b or nil
end

--- Where your bind point is: { map, x, y, how } or nil + why.
local function BindDest()
	local bind = Bind()
	if not bind then
		return nil, "bind location unreadable"
	end
	local db = type(ns.db) == "table" and ns.db.foreverLandings
	local own = db and db.bind and db.bind[CharKey(db.bind)]
	if own and own.name == bind and own.map then
		return { own.map, own.x, own.y, "landed here before" }
	end
	-- An inn or a learned rest place with the same name (ForeverCitySpots / ForeverRestXP).
	for _, s in ipairs(ns.FOREVER_CITY_SPOTS or {}) do
		-- 20 Nov 2026: the village inns carry their town (area id + English name), so "bound to Ratchet" finds one too.
		local town = s.town
		if s.area and C_Map and C_Map.GetAreaInfo then
			local okA, n = pcall(C_Map.GetAreaInfo, s.area)
			if okA and type(n) == "string" and n ~= "" and not (issecretvalue and issecretvalue(n)) then
				town = n
			end
		end
		if s.kind == "inn" and s.map and (MapName(s.map) == bind or (town and town == bind)) then
			return { s.map, s.x, s.y, "inn of " .. bind }
		end
	end
	for _, s in pairs((type(ns.db) == "table" and ns.db.foreverRestSpots) or {}) do
		if s.name == bind then
			return { s.map, s.x, s.y, "rested there before" }
		end
	end
	return nil, ("bound to %s, but MH does not know where that is yet (use your Hearthstone once)"):format(bind)
end

--- The teleports you can use right now: { t, dest = {map,x,y}, cost, waitMin, label }.
local function Teleports()
	local side, out = Side(), {}
	for _, t in ipairs(TELEPORTS) do
		local why
		if t.side and t.side ~= side then
			why = "other faction"
		elseif t.item and (ItemCount(t.item) or 0) < 1 then
			why = "not in your bags"
		elseif not t.item and not Known(t.spell) then
			why = "spell not known"
		elseif t.reagent and (ItemCount(t.reagent) or 0) < 1 then
			why = "no Rune of Teleportation"
		end
		local dest, how
		if not why then
			if t.bind then
				local d, w = BindDest()
				if d then
					dest, how = d, d[4]
				else
					why = w
				end
			else
				local db = type(ns.db) == "table" and ns.db.foreverLandings
				local seen = db and db.spell and db.spell[t.spell]
				if seen then
					dest, how = { seen.map, seen.x, seen.y }, "landed here before"
				elseif t.dest then
					dest, how = t.dest, "the city's inn (until MH sees where you land)"
				else
					why = "landing place not known yet (cast it once)"
				end
			end
		end
		local wait = not why and WaitMin(t) or nil
		if not why and wait == nil then
			why = "cooldown unreadable"
		end
		if why then
			tpWhy[t.id] = why
		else
			tpWhy[t.id] = ("offered: %s, wait %d min"):format(how or "?", math.ceil(wait))
			local name
			if t.item then
				local getName = (C_Item and C_Item.GetItemNameByID) or GetItemInfo
				local ok, n = pcall(getName or function() return nil end, t.item)
				name = ok and n or nil
			else
				local getName = (C_Spell and C_Spell.GetSpellName) or GetSpellInfo
				local ok, n = pcall(getName or function() return nil end, t.spell)
				name = ok and n or nil
			end
			name = (type(name) == "string" and name ~= "") and name or ("spell " .. tostring(t.spell))
			out[#out + 1] = { t = t, dest = dest, waitMin = wait, cost = TP_CAST + TP_MIN + wait,
				label = ns:L(t.item and "FTRAVEL_USE_FMT" or "FTRAVEL_CAST_FMT"):format(name) }
		end
	end
	return out
end

-- Learn where a teleport really lands: the spell is cast, the next loading screen ends, we read the position.
local pendingLand
do
	local lev = CreateFrame("Frame")
	pcall(lev.RegisterUnitEvent, lev, "UNIT_SPELLCAST_SUCCEEDED", "player")
	lev:RegisterEvent("PLAYER_ENTERING_WORLD")
	pcall(lev.RegisterEvent, lev, "ZONE_CHANGED_NEW_AREA")
	lev:SetScript("OnEvent", function(_, event, _, _, spellID)
		if event == "UNIT_SPELLCAST_SUCCEEDED" then
			for _, t in ipairs(TELEPORTS) do
				if t.spell == spellID then
					pendingLand = { t = t, at = GetTime(), bind = Bind() }
				end
			end
			return
		end
		if not pendingLand or GetTime() - pendingLand.at > 60 or type(ns.db) ~= "table" then
			return
		end
		local p = pendingLand
		C_Timer.After(1, function()
			local map, x, y = PlayerPos()
			if not (map and x) then
				return
			end
			ns.db.foreverLandings = ns.db.foreverLandings or {}
			local db = ns.db.foreverLandings
			if p.t.bind then
				db.bind = db.bind or {}
				db.bind[CharKey(db.bind)] = { name = p.bind, map = map, x = x, y = y }
			else
				db.spell = db.spell or {}
				db.spell[p.t.spell] = { map = map, x = x, y = y }
			end
		end)
		pendingLand = nil
	end)
end

local LABEL = { boat = "FTRAVEL_BOAT_FMT", zeppelin = "FTRAVEL_ZEPPELIN_FMT", tram = "FTRAVEL_TRAM_FMT",
	portal = "FTRAVEL_PORTAL_FMT", sky = "FTRAVEL_SKY_FMT", loop = "FTRAVEL_LOOP_FMT" }
-- Stormwind and Ironforge are one walk apart on paper, but the walk is long and dangerous: a penalty makes the tram win.
local SUB = { [MAP.STORMWIND] = "SW", [MAP.ELWYNN] = "SW", [MAP.IRONFORGE] = "IF", [MAP.DUN_MOROGH] = "IF" }
local SUB_PENALTY = 8
local ZONE_CHANGE = 2

local function World(map, x, y)
	if not (C_Map and C_Map.GetWorldPosFromMapPos and CreateVector2D) then
		return nil
	end
	local ok, cont, pos = pcall(C_Map.GetWorldPosFromMapPos, map, CreateVector2D(x / 100, y / 100))
	if not ok or not cont or not pos then
		return nil
	end
	local okXY, wx, wy = pcall(pos.GetXY, pos)
	if not okXY or not wx or (issecretvalue and (issecretvalue(wx) or issecretvalue(wy) or issecretvalue(cont))) then
		return nil
	end
	return cont, wx, wy
end

local function ParentMap(map)
	local ok, info = pcall(C_Map.GetMapInfo, map)
	return ok and info and info.parentMapID or nil
end

function MapName(map) -- the local declared above the teleport code
	local ok, info = pcall(C_Map.GetMapInfo, map)
	return ok and info and info.name or ("map " .. tostring(map))
end

--- Which piece of land a point is on: you can walk between two points only when this is the same.
local function Group(map, x, y)
	if map == MAP.DARNASSUS then
		return "TELD"
	elseif map == MAP.TELDRASSIL then
		return (y and y >= RUTTHERAN_MIN_Y) and "RUT" or "TELD"
	elseif map == MAP.ZEPHRAS then
		return "ZEPH"
	end
	local m, hops = map, 0
	while m and hops < 8 do
		if m == MAP.KALIMDOR then
			return "KAL"
		elseif m == MAP.EK then
			return "EK"
		end
		m = ParentMap(m)
		hops = hops + 1
	end
	local cont = World(map, x or 50, y or 50)
	return (cont == 0 and "EK") or (cont == 1 and "KAL") or nil
end

function Side() -- the local declared above the teleport code
	local f = UnitFactionGroup and UnitFactionGroup("player")
	return (f == "Alliance" and "A") or (f == "Horde" and "H") or nil
end

function PlayerPos() -- the local declared above the teleport code
	local map = C_Map and C_Map.GetBestMapForUnit and C_Map.GetBestMapForUnit("player")
	if not map or not C_Map.GetPlayerMapPosition then
		return map
	end
	local ok, pos = pcall(C_Map.GetPlayerMapPosition, map, "player")
	if not ok or not pos then
		return map
	end
	local okXY, x, y = pcall(pos.GetXY, pos)
	if not okXY or not x or (issecretvalue and (issecretvalue(x) or issecretvalue(y))) then
		return map
	end
	return map, x * 100, y * 100
end

--- A graph point: map, x, y, plus its land group and world position (cached on the point).
local function Point(map, x, y)
	local p = { map = map, x = x, y = y, group = Group(map, x, y) }
	p.cont, p.wx, p.wy = World(map, x, y)
	return p
end

local function WalkCost(p, q)
	if not (p.group and p.group == q.group) then
		return nil
	end
	local c = 6 -- unreadable world position: a fixed guess, only used to compare
	if p.wx and q.wx and p.cont == q.cont then
		c = math.sqrt((p.wx - q.wx) ^ 2 + (p.wy - q.wy) ^ 2) / 250
	end
	local sp, sq = SUB[p.map], SUB[q.map]
	if sp and sq and sp ~= sq then
		c = c + SUB_PENALTY
	end
	-- A straight line into another zone is shorter than the road around the mountains: a small price per zone change
	-- (AFGELEID). It is what makes "boat to Stormwind + tram" beat "boat to Menethil + walk through the Wetlands".
	if p.map ~= q.map then
		c = c + ZONE_CHANGE
	end
	return c
end

local function Label(link, toEnd)
	local key = LABEL[link.kind]
	local named
	if toEnd == "b" then
		named = link.bName
	else
		named = link.aName
	end
	local dest = named and ns:L(named) or MapName(link[toEnd][1])
	if link.kind == "loop" then
		return ns:L(key):format(dest, MapName(link.via))
	end
	return ns:L(key):format(dest)
end

--------------------------------------------------------------------------------
-- Flight paths (26 Nov 2026). Rob, at the zeppelin tower outside Orgrimmar with the class quest arrow pointing 4405 m to
-- Thunder Bluff: "waarom zegt hij niet tegen mij nu van, hey, joh, je moet nu de Zeppelin nemen … Waarom alleen maar een
-- pijl die kant op en niet hoe ik kom?" → via sparring "Ja, stuur maar.".
-- Research: docs/forever/VLUCHTEN_2026-11-26.md (mh-research, 26 Nov 2026).
-- - Nodes and paths GEMETEN in the Forever DB2 1.60.1.71139: TaxiNodes (Flags 0x1 = Alliance, 0x2 = Horde; continent 0/1,
--   CharacterBitNumber > 0, at least one TaxiPath), TaxiPath, and the length of each path = 3D sum over TaxiPathNode.
--   Zone x,y AFGELEID from the world position; 64 of 65 within 0.44 map-% of the Wowhead Forever flight master.
-- - Speed 30 yd/s, GEMETEN from 12 of Rob's own flights (yards / 30 within 1 s of each). Frequent Flier (+20%) ignored.
-- - Classic rule (warcraft.wiki.gg patch history: only 6.1.0 allowed flying through unknown points): you fly only INTO
--   points you know, and the point you board at you can learn right there by talking to its master (AFGELEID that you can
--   fly on at once). Whether Forever follows the old or new rule: NOT measured, the old one is the safe one.
-- - Which points you know: learned per character at every flight map (C_TaxiMap.GetAllTaxiNodes, state Current/Reachable;
--   API GEMETEN in Blizzard's forever UI source), plus the world map's list (GetTaxiNodesForMap) only when it shows that
--   it filters (see KnownTaxi). /mh travel prints both.
-- Left out: Nighthaven (druid-only, one way, CharacterBitNumber 0).
-- { id, side, map, x, y, English name }
local FLIGHT_NODES = {
	{ 43, "A", 1425, 11.11, 46.09, "Aerie Peak, The Hinterlands" }, { 18, "H", 1434, 26.82, 77.00, "Booty Bay, Stranglethorn" },
	{ 19, "A", 1434, 27.53, 77.67, "Booty Bay, Stranglethorn" }, { 66, "A", 1422, 42.95, 84.95, "Chillwind Camp, Western Plaguelands" },
	{ 12, "A", 1431, 77.59, 44.38, "Darkshire, Duskwood" }, { 3276, "A", 2548, 60.59, 81.57, "Farholde Keep, Riverglades" },
	{ 70, "H", 1428, 65.58, 24.22, "Flame Crest, Burning Steppes" }, { 20, "H", 1434, 32.51, 29.28, "Grom'gol, Stranglethorn" },
	{ 17, "H", 1417, 73.06, 32.62, "Hammerfall, Arathi" }, { 6, "A", 1455, 55.89, 47.87, "Ironforge, Dun Morogh" },
	{ 21, "H", 1418, 4.06, 44.89, "Kargath, Badlands" }, { 5, "A", 1433, 25.34, 58.99, "Lakeshire, Redridge" },
	{ 67, "A", 1423, 71.70, 49.56, "Light's Hope Chapel, Eastern Plaguelands" },
	{ 68, "H", 1423, 70.45, 47.59, "Light's Hope Chapel, Eastern Plaguelands" },
	{ 7, "A", 1437, 9.52, 59.66, "Menethil Harbor, Wetlands" }, { 71, "A", 1428, 84.38, 68.30, "Morgan's Vigil, Burning Steppes" },
	{ 45, "A", 1419, 65.49, 24.43, "Nethergarde Keep, Blasted Lands" }, { 16, "A", 1417, 45.79, 46.13, "Refuge Pointe, Arathi" },
	{ 76, "H", 1425, 81.70, 81.89, "Revantusk Village, The Hinterlands" }, { 3203, "H", 2548, 59.61, 45.06, "Rog'mar, Riverglades" },
	{ 4, "A", 1436, 56.57, 52.67, "Sentinel Hill, Westfall" }, { 14, "A", 1424, 49.44, 52.10, "Southshore, Hillsbrad" },
	{ 56, "H", 1435, 46.05, 54.68, "Stonard, Swamp of Sorrows" }, { 2, "A", 1453, 71.61, 72.25, "Stormwind, Elwynn" },
	{ 13, "H", 1424, 60.21, 18.75, "Tarren Mill, Hillsbrad" }, { 10, "H", 1421, 45.56, 42.42, "The Sepulcher, Silverpine Forest" },
	{ 8, "A", 1432, 33.94, 50.79, "Thelsamar, Loch Modan" }, { 74, "A", 1427, 37.89, 30.43, "Thorium Point, Searing Gorge" },
	{ 75, "H", 1427, 34.83, 30.58, "Thorium Point, Searing Gorge" }, { 11, "H", 1458, 63.09, 48.32, "Undercity, Tirisfal" },
	{ 28, "A", 1440, 34.50, 48.01, "Astranaar, Ashenvale" }, { 26, "A", 1439, 36.40, 45.62, "Auberdine, Darkshore" },
	{ 48, "H", 1448, 34.42, 53.87, "Bloodvenom Post, Felwood" }, { 55, "H", 1445, 35.57, 31.83, "Brackenwall Village, Dustwallow Marsh" },
	{ 42, "H", 1444, 75.43, 44.31, "Camp Mojache, Feralas" }, { 77, "H", 1413, 44.46, 59.10, "Camp Taurajo, The Barrens" },
	{ 72, "H", 1451, 48.83, 36.72, "Cenarion Hold, Silithus" }, { 73, "A", 1451, 50.68, 34.59, "Cenarion Hold, Silithus" },
	{ 25, "H", 1413, 51.50, 30.41, "Crossroads, The Barrens" }, { 52, "A", 1452, 62.33, 36.64, "Everlook, Winterspring" },
	{ 53, "H", 1452, 60.49, 36.34, "Everlook, Winterspring" }, { 41, "A", 1444, 30.26, 43.32, "Feathermoon, Feralas" },
	{ 30, "H", 1441, 45.02, 49.13, "Freewind Post, Thousand Needles" }, { 39, "A", 1446, 50.95, 29.33, "Gadgetzan, Tanaris" },
	{ 40, "H", 1446, 51.62, 25.52, "Gadgetzan, Tanaris" }, { 79, nil, 1449, 45.30, 5.97, "Marshal's Refuge, Un'Goro Crater" },
	{ 49, "A", 1450, 47.91, 67.11, "Moonglade" }, { 69, "H", 1450, 32.15, 66.33, "Moonglade" },
	{ 37, "A", 1443, 64.67, 10.44, "Nijel's Point, Desolace" }, { 23, "H", 1454, 45.28, 63.75, "Orgrimmar, Durotar" },
	{ 80, nil, 1413, 63.12, 37.11, "Ratchet, The Barrens" }, { 27, "A", 1438, 58.40, 93.93, "Rut'theran Village, Teldrassil" },
	{ 38, "H", 1443, 21.56, 74.04, "Shadowprey Village, Desolace" }, { 61, "H", 1440, 73.26, 61.67, "Splintertree Post, Ashenvale" },
	{ 33, "A", 1442, 36.54, 7.23, "Stonetalon Peak, Stonetalon Mountains" }, { 559, nil, 2482, 68.64, 44.11, "Summit of Eternity, Mount Hyjal" },
	{ 29, "H", 1442, 45.16, 59.89, "Sun Rock Retreat, Stonetalon Mountains" }, { 3242, nil, 2482, 55.10, 82.55, "Tainted Foothills, Mount Hyjal" },
	{ 65, "A", 1448, 62.46, 24.19, "Talonbranch Glade, Felwood" }, { 64, "A", 1447, 11.90, 77.48, "Talrendis Point, Azshara" },
	{ 31, "A", 1444, 89.46, 45.87, "Thalanaar, Feralas" }, { 32, "A", 1445, 67.46, 51.20, "Theramore, Dustwallow Marsh" },
	{ 22, "H", 1456, 46.65, 49.90, "Thunder Bluff, Mulgore" }, { 44, "H", 1447, 21.95, 49.69, "Valormok, Azshara" },
	{ 58, "H", 1440, 12.19, 33.77, "Zoram'gar Outpost, Ashenvale" },
	-- 26 Nov 2026 (Rob in Moonglade: MH sent him to Winterspring, "Polestar die gaf aan … daar is ook een Flightmaster"):
	-- the druid-only Nighthaven masters. DB2 71139 TaxiNodes 62 (A) / 63 (H), CharacterBitNumber 0 (never "discovered":
	-- every druid has them). Zone x,y AFGELEID from their world position, scaled by the two Moonglade nodes 49 and 69;
	-- Wowhead Forever puts Bunthen Plainswind (11798) at 44.4,45.4 and Silva Fil'naveth (11800) at 44.2,45.2 (GEMETEN).
	-- 7th field = the only class that may use it.
	{ 62, "A", 1450, 44.28, 45.22, "Nighthaven, Moonglade", "DRUID" },
	{ 63, "H", 1450, 44.31, 45.61, "Nighthaven, Moonglade", "DRUID" },
}
-- { from, to, yards }: every TaxiPath between those nodes (each pair exists both ways, measured separately).
local FLIGHT_PATHS = {
	{ 2, 4, 2329 }, { 2, 5, 3380 }, { 2, 6, 7757 }, { 2, 12, 3480 }, { 2, 19, 7318 }, { 2, 45, 5282 }, { 2, 71, 4706 },
	{ 4, 2, 2443 }, { 4, 5, 3890 }, { 4, 12, 2897 }, { 4, 19, 5561 },
	{ 5, 2, 3374 }, { 5, 4, 4003 }, { 5, 12, 1812 }, { 5, 71, 1825 }, { 5, 3276, 3962 },
	{ 6, 2, 6310 }, { 6, 7, 3861 }, { 6, 8, 3037 }, { 6, 14, 7938 }, { 6, 16, 7585 }, { 6, 43, 8941 }, { 6, 66, 8816 }, { 6, 67, 10440 }, { 6, 74, 2594 },
	{ 7, 6, 2658 }, { 7, 8, 4877 }, { 7, 14, 3215 }, { 7, 16, 3388 },
	{ 8, 6, 3266 }, { 8, 7, 4564 }, { 8, 16, 4902 }, { 8, 3276, 5531 },
	{ 10, 11, 3345 }, { 10, 13, 2868 },
	{ 11, 10, 3180 }, { 11, 13, 4222 }, { 11, 17, 9014 }, { 11, 21, 14837 }, { 11, 68, 7849 }, { 11, 76, 8530 },
	{ 12, 2, 2629 }, { 12, 4, 2794 }, { 12, 5, 1787 }, { 12, 19, 5135 }, { 12, 45, 2903 },
	{ 13, 10, 2989 }, { 13, 11, 4172 }, { 13, 17, 3532 }, { 13, 76, 5840 },
	{ 14, 6, 6174 }, { 14, 7, 3304 }, { 14, 16, 2214 }, { 14, 43, 2139 }, { 14, 66, 2418 },
	{ 16, 6, 8109 }, { 16, 7, 3776 }, { 16, 8, 5113 }, { 16, 14, 2596 }, { 16, 43, 2152 },
	{ 17, 11, 7763 }, { 17, 13, 3493 }, { 17, 21, 7760 }, { 17, 76, 2705 }, { 17, 3203, 9767 },
	{ 18, 20, 3047 }, { 18, 21, 12190 }, { 18, 56, 7986 },
	{ 19, 2, 6585 }, { 19, 4, 5439 }, { 19, 12, 5242 },
	{ 20, 18, 2422 }, { 20, 21, 9802 }, { 20, 56, 6151 },
	{ 21, 11, 14918 }, { 21, 17, 7881 }, { 21, 18, 12493 }, { 21, 20, 9376 }, { 21, 56, 8424 }, { 21, 70, 2593 }, { 21, 75, 1682 }, { 21, 3203, 3821 },
	{ 22, 23, 6213 }, { 22, 25, 4752 }, { 22, 29, 5439 }, { 22, 30, 6113 }, { 22, 38, 4752 }, { 22, 40, 8693 }, { 22, 42, 7563 }, { 22, 44, 8070 }, { 22, 55, 7149 }, { 22, 77, 2599 },
	{ 23, 22, 6745 }, { 23, 25, 3304 }, { 23, 40, 12500 }, { 23, 44, 2965 }, { 23, 48, 7558 }, { 23, 53, 9582 }, { 23, 55, 6853 }, { 23, 61, 2680 },
	{ 25, 22, 5461 }, { 25, 23, 4252 }, { 25, 29, 4495 }, { 25, 30, 5532 }, { 25, 40, 9093 }, { 25, 42, 7547 }, { 25, 44, 5051 }, { 25, 48, 7603 }, { 25, 55, 4878 }, { 25, 58, 6902 }, { 25, 61, 4871 }, { 25, 77, 2705 }, { 25, 80, 1545 },
	{ 26, 27, 2525 }, { 26, 28, 5270 }, { 26, 32, 20225 }, { 26, 33, 5432 }, { 26, 37, 8723 }, { 26, 41, 14168 }, { 26, 49, 4525 }, { 26, 64, 8981 }, { 26, 65, 5682 },
	{ 27, 26, 2551 },
	{ 28, 26, 4426 }, { 28, 33, 4599 }, { 28, 64, 4428 },
	{ 29, 22, 5227 }, { 29, 25, 4477 }, { 29, 38, 4297 },
	{ 30, 22, 6764 }, { 30, 25, 5810 }, { 30, 40, 2782 }, { 30, 42, 3685 }, { 30, 77, 4111 },
	{ 31, 32, 4780 }, { 31, 39, 5122 }, { 31, 41, 5335 },
	{ 32, 26, 18633 }, { 32, 31, 4887 }, { 32, 37, 10017 }, { 32, 39, 4694 }, { 32, 64, 7052 }, { 32, 80, 3446 },
	{ 33, 26, 5304 }, { 33, 28, 4613 }, { 33, 37, 3803 },
	{ 37, 26, 8458 }, { 37, 32, 9202 }, { 37, 33, 3581 }, { 37, 41, 6949 },
	{ 38, 22, 5331 }, { 38, 29, 5966 }, { 38, 42, 5873 },
	{ 39, 31, 5304 }, { 39, 32, 4606 }, { 39, 73, 5907 }, { 39, 79, 3115 },
	{ 40, 22, 9107 }, { 40, 23, 10495 }, { 40, 25, 9008 }, { 40, 30, 2602 }, { 40, 42, 5973 }, { 40, 55, 6647 }, { 40, 72, 6976 }, { 40, 79, 3218 },
	{ 41, 26, 14014 }, { 41, 31, 4635 }, { 41, 37, 6797 }, { 41, 73, 4774 },
	{ 42, 22, 7777 }, { 42, 25, 7915 }, { 42, 30, 3215 }, { 42, 38, 6016 }, { 42, 40, 6024 }, { 42, 72, 3897 },
	{ 43, 6, 7658 }, { 43, 14, 2039 }, { 43, 16, 2267 }, { 43, 66, 1590 }, { 43, 67, 4922 },
	{ 44, 22, 7700 }, { 44, 23, 3622 }, { 44, 25, 5163 }, { 44, 48, 6955 }, { 44, 53, 3905 }, { 44, 61, 2795 },
	{ 45, 2, 5672 }, { 45, 12, 2748 }, { 45, 71, 6251 },
	{ 48, 23, 7747 }, { 48, 25, 7227 }, { 48, 44, 7221 }, { 48, 53, 5700 }, { 48, 69, 4947 },
	{ 49, 26, 4247 }, { 49, 52, 3900 }, { 49, 65, 1840 },
	{ 52, 49, 3639 }, { 52, 64, 5265 }, { 52, 65, 3670 }, { 52, 3242, 4057 },
	{ 53, 23, 9115 }, { 53, 44, 4078 }, { 53, 48, 5853 }, { 53, 69, 4016 }, { 53, 3242, 4078 },
	{ 55, 22, 6729 }, { 55, 23, 6496 }, { 55, 25, 4848 }, { 55, 40, 6660 },
	{ 56, 18, 7798 }, { 56, 20, 5646 }, { 56, 21, 8555 }, { 56, 70, 5916 }, { 56, 3203, 5085 },
	{ 58, 25, 6827 }, { 58, 61, 5013 },
	{ 61, 23, 2869 }, { 61, 25, 4806 }, { 61, 44, 2870 }, { 61, 58, 4995 },
	{ 64, 26, 9038 }, { 64, 28, 4578 }, { 64, 32, 7242 }, { 64, 52, 5355 }, { 64, 65, 8502 }, { 64, 80, 4062 },
	{ 65, 26, 5622 }, { 65, 49, 2005 }, { 65, 52, 3601 }, { 65, 64, 8465 },
	{ 66, 6, 7782 }, { 66, 14, 2559 }, { 66, 43, 1958 }, { 66, 67, 4390 },
	{ 67, 6, 11024 }, { 67, 43, 4871 }, { 67, 66, 4484 },
	{ 68, 11, 7837 }, { 68, 76, 4232 },
	{ 69, 48, 4713 }, { 69, 53, 4256 },
	{ 70, 21, 2994 }, { 70, 56, 6376 }, { 70, 75, 2154 }, { 70, 3203, 4113 },
	{ 71, 2, 4528 }, { 71, 5, 1884 }, { 71, 45, 6288 }, { 71, 74, 3090 }, { 71, 3276, 3936 },
	{ 72, 40, 7224 }, { 72, 42, 3895 }, { 72, 79, 2896 },
	{ 73, 39, 5652 }, { 73, 41, 5239 }, { 73, 79, 2745 },
	{ 74, 6, 2802 }, { 74, 71, 2865 },
	{ 75, 21, 2090 }, { 75, 70, 2297 },
	{ 76, 11, 8538 }, { 76, 13, 4767 }, { 76, 17, 2785 }, { 76, 68, 4159 },
	{ 77, 22, 3407 }, { 77, 25, 2380 }, { 77, 30, 3750 },
	{ 79, 39, 3100 }, { 79, 40, 3396 }, { 79, 72, 3003 }, { 79, 73, 2823 },
	{ 80, 25, 2041 }, { 80, 32, 3149 }, { 80, 64, 3960 },
	{ 559, 3242, 1866 },
	{ 3203, 17, 9845 }, { 3203, 21, 3607 }, { 3203, 56, 4624 }, { 3203, 70, 3993 },
	{ 3242, 52, 3745 }, { 3242, 53, 3967 }, { 3242, 559, 1849 },
	{ 3276, 5, 3917 }, { 3276, 8, 5193 }, { 3276, 71, 3676 },
	-- Nighthaven, one way (DB2 TaxiPath 315: 62 > 27 Rut'theran; 316: 63 > 22 Thunder Bluff), lengths by mh-research.
	{ 62, 27, 4559 }, { 63, 22, 16313 },
}
local FLY_YD_PER_MIN = 30 * 60 -- GEMETEN 30 yd/s
local FLY_HOP = 0.3 -- landing and taking off again at a point on the way (AFGELEID, small: only to prefer fewer hops)
local NODE_BY_ID = {}
for _, n in ipairs(FLIGHT_NODES) do
	NODE_BY_ID[n[1]] = n
end
local taxiNames = {} -- nodeID -> the client's own (localized) name, read from the world map list
local taxiWhy = "not looked yet" -- for /mh travel

local function TaxiCharKey(tbl)
	local n, r = UnitName and UnitName("player"), GetRealmName and GetRealmName()
	local legacy = tostring(n) .. "-" .. tostring(r)
	return ns.ForeverCharKey and ns.ForeverCharKey("known flight points", legacy, tbl, { whole = true }) or legacy
end

local function LearnedTaxi(create)
	if type(ns.db) ~= "table" then
		return nil
	end
	if create then
		ns.db.foreverTaxiKnown = ns.db.foreverTaxiKnown or {}
	end
	local db = ns.db.foreverTaxiKnown
	if not db then
		return nil
	end
	local k = TaxiCharKey(db)
	if create then
		db[k] = db[k] or {}
	end
	return db[k]
end

--- The world map's flight point list (GetTaxiNodesForMap) for one continent map: { [nodeID] = true } of the points it
--- calls discovered, and whether that list can be trusted. Trusted only when it visibly filters: it marks a point of
--- your side undiscovered, or it gives fewer points of your side than exist on that continent. (A list with every point
--- of your side, all "discovered", could be a filter that does not work on Forever: ForeverDungeonJournal says exactly
--- that, OpenMap trusts it; candidates both, so the list proves itself or is not used.)
local function WorldMapTaxi(contMap, side)
	if not (C_TaxiMap and C_TaxiMap.GetTaxiNodesForMap) then
		return nil, "GetTaxiNodesForMap missing"
	end
	local ok, list = pcall(C_TaxiMap.GetTaxiNodesForMap, contMap)
	if not ok or type(list) ~= "table" then
		return nil, "GetTaxiNodesForMap unreadable"
	end
	-- 26 Nov 2026: NOT used for "known" any more. GEMETEN by Rob (/mh travel): Forever calls every point discovered
	-- (21/21 and 13/13). Only the client's own (localized) names come from here, for the flight map's slot list below.
	local n = 0
	for _, info in ipairs(list) do
		local id = type(info) == "table" and info.nodeID
		if id and NODE_BY_ID[id] and type(info.name) == "string" and info.name ~= ""
			and not (issecretvalue and issecretvalue(info.name)) then
			taxiNames[id] = info.name
			n = n + 1
		end
	end
	return nil, ("%d names read (not used for known: Forever calls every point discovered)"):format(n)
end

--- Which world continent (0 = Eastern Kingdoms, 1 = Kalimdor) a node is on; cached.
local nodeCont = {}
local function NodeCont(id)
	if nodeCont[id] == nil then
		local nd = NODE_BY_ID[id]
		nodeCont[id] = nd and World(nd[3], nd[4], nd[5]) or false
	end
	return nodeCont[id] or nil
end

--- This class may use this node (the druid-only Nighthaven masters).
local function NodeForMe(nd)
	if not nd[7] then
		return true
	end
	local _, cls = UnitClass("player")
	return cls == nd[7]
end

--- { [nodeID] = true } of the flight points this character knows, and how MH knows.
local knownCache = { at = -10, side = nil, set = nil }
local function KnownTaxi(side)
	local now = GetTime and GetTime() or 0
	if knownCache.set and knownCache.side == side and now - knownCache.at < 5 then
		return knownCache.set
	end
	local known, parts = {}, {}
	local learned = LearnedTaxi(false)
	local nl = 0
	for id in pairs(learned or {}) do
		if type(id) == "number" then
			known[id] = true
			nl = nl + 1
		end
	end
	-- Class-only masters (Nighthaven) are known to every character of that class (CharacterBitNumber 0 in DB2).
	for _, nd in ipairs(FLIGHT_NODES) do
		if nd[7] and NodeForMe(nd) then
			known[nd[1]] = true
		end
	end
	local seen = learned and learned.seen or {}
	parts[#parts + 1] = ("learned: %d; flight map seen on Kalimdor: %s, Eastern Kingdoms: %s"):format(nl,
		seen[1] and "yes" or "no (open a flight master there once)", seen[0] and "yes" or "no (open a flight master there once)")
	WorldMapTaxi(MAP.KALIMDOR, side) -- names only
	WorldMapTaxi(MAP.EK, side)
	taxiWhy = table.concat(parts, "; ")
	knownCache.at, knownCache.side, knownCache.set = now, side, known
	return known
end

--- 26 Nov 2026: what MH learned last, for /mh travel (how, when, how many).
local taxiLast = "nothing yet this session"

--- The nearest flight master of your side within `yards`, by world position; nil when none.
local function NearestNode(yards)
	local pmap, px, py = PlayerPos()
	if not (pmap and px) then
		return nil
	end
	local cont, wx, wy = World(pmap, px, py)
	if not wx then
		return nil
	end
	local side, best, bestD = Side(), nil, yards
	for _, nd in ipairs(FLIGHT_NODES) do
		if (not nd[2] or nd[2] == side) and NodeForMe(nd) then
			local c, x, y = World(nd[3], nd[4], nd[5])
			if c == cont and x then
				local d = math.sqrt((x - wx) ^ 2 + (y - wy) ^ 2)
				if d < bestD then
					best, bestD = nd[1], d
				end
			end
		end
	end
	return best
end

--- Name of a flight map slot -> node id of your side (the client's names from the world map list, else English).
local function NodeByName(name)
	if type(name) ~= "string" or name == "" or (issecretvalue and issecretvalue(name)) then
		return nil
	end
	local side = Side()
	for _, nd in ipairs(FLIGHT_NODES) do
		if (not nd[2] or nd[2] == side) and (taxiNames[nd[1]] == name or nd[6] == name) then
			return nd[1]
		end
	end
	return nil
end

-- Learn which flight points you know (26 Nov 2026, Sparring: Rob's SavedVariables had no foreverTaxiKnown at all, because
-- the old code stopped silently when GetTaxiMapID was missing). Method learned by READING Polestar (GPL-3; no code, no
-- table, no number taken): ask every door the client has, and say in /mh travel which one answered.
--  1. At a flight map: C_TaxiMap.GetAllTaxiNodes(GetTaxiMapID()) when both exist (state 0 Current / 1 Reachable), AND the
--     slot list NumTaxiNodes / TaxiNodeGetType / TaxiNodeName (CURRENT, REACHABLE and UNREACHABLE = a point you know;
--     the types are Blizzard's TaxiFrame.lua). A flight map shows every point you know on that continent, so after it
--     the continent counts as "seen" and points that were not on it are forgotten (a reset, a wrong guess).
--  2. "New flight path discovered" (ERR_NEWTAXIPATH): the master within 60 yd.
--  3. Landing after a flight: the master within 60 yd is a point you know.
do
	local function Learn(ids, cont, how)
		local db = LearnedTaxi(true)
		if not db then
			return
		end
		local n = 0
		for id in pairs(ids) do
			if not db[id] then
				n = n + 1
			end
			db[id] = true
		end
		if cont ~= nil then
			db.seen = db.seen or {}
			db.seen[cont] = true
			for id in pairs(db) do
				if type(id) == "number" and NodeCont(id) == cont and not ids[id] then
					db[id] = nil
				end
			end
		end
		taxiLast = ("%s: %d point(s), %d new"):format(how, (function() local c = 0 for _ in pairs(ids) do c = c + 1 end return c end)(), n)
		knownCache.set = nil -- plan again with what you just learned
	end

	local function AtFlightMap()
		local ids, cont, how = {}, nil, {}
		if C_TaxiMap and C_TaxiMap.GetAllTaxiNodes and GetTaxiMapID then
			local okM, map = pcall(GetTaxiMapID)
			if okM and map then
				local ok, list = pcall(C_TaxiMap.GetAllTaxiNodes, map)
				if ok and type(list) == "table" then
					for _, info in ipairs(list) do
						if type(info) == "table" and info.nodeID and NODE_BY_ID[info.nodeID]
							and (info.state == 0 or info.state == 1) then
							ids[info.nodeID] = true
							cont = cont or NodeCont(info.nodeID)
						end
					end
					how[#how + 1] = "GetAllTaxiNodes"
				end
			end
		end
		if NumTaxiNodes and TaxiNodeName and TaxiNodeGetType then
			local okN, num = pcall(NumTaxiNodes)
			if okN and type(num) == "number" then
				local KNOWN = { CURRENT = true, REACHABLE = true, UNREACHABLE = true }
				for i = 1, num do
					local okT, kind = pcall(TaxiNodeGetType, i)
					local okS, name = pcall(TaxiNodeName, i)
					if okT and KNOWN[kind] and okS then
						local id = NodeByName(name)
						if id then
							ids[id] = true
							cont = cont or NodeCont(id)
						end
					end
				end
				how[#how + 1] = "slot list"
			end
		end
		if next(ids) then
			Learn(ids, cont, "flight map (" .. table.concat(how, " + ") .. ")")
		else
			taxiLast = "flight map opened, but no door gave a point (" .. (#how > 0 and table.concat(how, ", ") or "no API") .. ")"
		end
	end

	local tf = CreateFrame("Frame")
	for _, e in ipairs({ "TAXIMAP_OPENED", "UI_INFO_MESSAGE", "PLAYER_CONTROL_LOST", "PLAYER_CONTROL_GAINED" }) do
		pcall(tf.RegisterEvent, tf, e)
	end
	local flying = false
	tf:SetScript("OnEvent", function(_, event, a, b)
		if event == "TAXIMAP_OPENED" then
			C_Timer.After(0.2, AtFlightMap)
		elseif event == "UI_INFO_MESSAGE" then
			local msg = (type(b) == "string" and b) or (type(a) == "string" and a) or nil
			if msg and ERR_NEWTAXIPATH and msg == ERR_NEWTAXIPATH then
				local id = NearestNode(60)
				if id then
					Learn({ [id] = true }, nil, "new flight path")
				end
			end
		elseif event == "PLAYER_CONTROL_LOST" then
			C_Timer.After(1, function()
				flying = UnitOnTaxi and UnitOnTaxi("player") or false
			end)
		elseif event == "PLAYER_CONTROL_GAINED" and flying then
			flying = false
			C_Timer.After(1, function()
				local id = NearestNode(60)
				if id then
					Learn({ [id] = true }, nil, "landed")
				end
			end)
		end
	end)
end

--- /mh travel: which taxi doors this client has (so a silent "no flights" can be told apart from a missing API).
local function TaxiApiLine()
	local function has(f)
		return f and "yes" or "no"
	end
	return ("taxi API: GetTaxiMapID %s, C_TaxiMap.GetAllTaxiNodes %s, NumTaxiNodes %s, TaxiNodeGetType %s, TaxiNodeName %s, GetTaxiNodesForMap %s; last learned: %s"):format(
		has(GetTaxiMapID), has(C_TaxiMap and C_TaxiMap.GetAllTaxiNodes), has(NumTaxiNodes), has(TaxiNodeGetType),
		has(TaxiNodeName), has(C_TaxiMap and C_TaxiMap.GetTaxiNodesForMap), taxiLast)
end

local function TaxiName(id)
	if taxiNames[id] then
		return taxiNames[id]
	end
	local n = NODE_BY_ID[id]
	if not n then
		return "?"
	end
	if (GetLocale and GetLocale() or "enUS") == "enUS" then
		return n[6]
	end
	return MapName(n[3]) -- the zone, in the client's language, rather than an English name
end

--- The link ends and the edges between them never change for one faction: build them once.
local staticBySide = {}
local function StaticGraph(side)
	local _, cls = UnitClass("player")
	local key = (side or "?") .. ":" .. tostring(cls) -- the class decides the druid-only masters
	if staticBySide[key] then
		return staticBySide[key]
	end
	local g = { points = {}, edges = {}, taxiIndex = {} }
	-- 26 Nov 2026: every flight master of your side is a point too (walks to and from it are fixed; which flights you may
	-- take depends on what you know, so those edges are added in Plan).
	for _, n in ipairs(FLIGHT_NODES) do
		if (not n[2] or n[2] == side) and NodeForMe(n) then
			local p = Point(n[3], n[4], n[5])
			p.taxi = n[1]
			g.points[#g.points + 1] = p
			g.taxiIndex[n[1]] = #g.points
		end
	end
	for _, l in ipairs(LINKS) do
		if not l.side or l.side == side then
			g.points[#g.points + 1] = Point(l.a[1], l.a[2], l.a[3])
			local ia = #g.points
			g.points[#g.points + 1] = Point(l.b[1], l.b[2], l.b[3])
			local ib = #g.points
			g.edges[#g.edges + 1] = { from = ia, to = ib, cost = COST[l.kind] or 4, link = l, toEnd = "b" }
			if not l.oneway then
				g.edges[#g.edges + 1] = { from = ib, to = ia, cost = COST[l.kind] or 4, link = l, toEnd = "a" }
			end
		end
	end
	for i = 1, #g.points do
		for j = 1, #g.points do
			if i ~= j then
				local c = WalkCost(g.points[i], g.points[j])
				if c then
					g.edges[#g.edges + 1] = { from = i, to = j, cost = c }
				end
			end
		end
	end
	-- Only keep it when every point could be read; a half-read graph at login is rebuilt on the next call.
	local complete = true
	for _, p in ipairs(g.points) do
		if not (p.group and p.wx) then
			complete = false
		end
	end
	if complete then
		staticBySide[key] = g
	end
	return g
end

--- The plan from the player to (map, x, y): a list of steps, or nil when you can simply walk (or nothing is known).
--- Dijkstra over: the player, every link end on your side, the target. Small (about 30 points), cached for a second.
local cache = { key = nil, at = 0, steps = nil, why = nil }
local pins, SWITCH = {}, 1.5 -- the start each target's plan chose last, and the price of changing it (AFGELEID)
local function Plan(tmap, tx, ty)
	local pmap, px, py = PlayerPos()
	if not (pmap and px and tmap and tx and ty) then
		return nil, "player or target position unreadable"
	end
	-- On a flight (26 Nov 2026): the route is underway; planning again from the air would send you to a master below.
	if UnitOnTaxi and UnitOnTaxi("player") then
		return nil, "on a flight"
	end
	-- The arrow asks ~30 times a second while it waits on a plan: recompute at most once a second for the same target
	-- and map. Moving inside a map does not change which boat is best often enough to matter.
	local key = ("%d>%d:%.1f:%.1f"):format(pmap, tmap, tx, ty)
	local now = GetTime and GetTime() or 0
	if cache.key == key and now - cache.at < 1 then
		return cache.steps, cache.why
	end
	local side = Side()
	local static = StaticGraph(side)
	local nodes = { Point(pmap, px, py) } -- 1 = start, then the link ends (same order as static.points), then the target
	for _, p in ipairs(static.points) do
		nodes[#nodes + 1] = p
	end
	local target = Point(tmap, tx, ty)
	nodes[#nodes + 1] = target
	local it = #nodes
	local edges = {} -- from index -> list of { to, cost, link, toEnd }
	local function add(from, to, cost, link, toEnd, tp)
		edges[from] = edges[from] or {}
		edges[from][#edges[from] + 1] = { to = to, cost = cost, link = link, toEnd = toEnd, tp = tp }
	end
	for _, e in ipairs(static.edges) do -- link rides and walks between link ends: computed once per side
		add(e.from + 1, e.to + 1, e.cost, e.link, e.toEnd)
	end
	-- 26 Nov 2026: flights, only INTO points this character knows (the one you board at you learn there).
	local known = KnownTaxi(side)
	for _, f in ipairs(FLIGHT_PATHS) do
		local ia, ib = static.taxiIndex[f[1]], static.taxiIndex[f[2]]
		if ia and ib and known[f[2]] then
			edges[ia + 1] = edges[ia + 1] or {}
			local list = edges[ia + 1]
			list[#list + 1] = { to = ib + 1, cost = f[3] / FLY_YD_PER_MIN + FLY_HOP, fly = f[2] }
		end
	end
	-- 26 Nov 2026 (Rob in Moonglade: "The way there: the flight master in Winterspring …" and a moment later "Way to The
	-- Barrens: first use your Hearthstone", both "about 22 min"): two routes of almost the same length, and the
	-- Hearthstone's cooldown ticking down made the plan flip between them. Now the first choice for a target sticks for
	-- 10 minutes unless another start is clearly (SWITCH) quicker: one piece of advice, not two.
	local pinKey = ("%d:%.0f:%.0f"):format(tmap, tx, ty)
	local pin = pins[pinKey]
	if pin and now - pin.at > 600 then
		pin = nil
	end
	local function startCost(identity, c)
		if pin and pin.id ~= identity then
			return c + SWITCH
		end
		return c
	end
	for j = 1, it do -- walks from the start, and walks into the target
		if j ~= 1 then
			local c = WalkCost(nodes[1], nodes[j])
			if c then
				add(1, j, startCost("walk", c), nil)
			end
		end
		if j ~= it and j ~= 1 then
			local c = WalkCost(nodes[j], target)
			if c then
				add(j, it, c, nil)
			end
		end
	end
	-- Teleports (20 Nov 2026): from where you stand to their landing place, then walking from there to the target or to
	-- any link end. Added after the target, so `it` stays the target.
	local okT, tps = pcall(Teleports)
	for _, tp in ipairs(okT and tps or {}) do
		local p = Point(tp.dest[1], tp.dest[2], tp.dest[3])
		nodes[#nodes + 1] = p
		local ip = #nodes
		add(1, ip, startCost(tp.t.id, tp.cost), nil, nil, tp)
		local c = WalkCost(p, target)
		if c then
			add(ip, it, c, nil)
		end
		for j = 2, it - 1 do
			local cj = WalkCost(p, nodes[j])
			if cj then
				add(ip, j, cj, nil)
			end
		end
	end
	local dist, prev, done = { [1] = 0 }, {}, {}
	for _ = 1, #nodes do
		local u, best = nil, math.huge
		for i = 1, #nodes do
			if not done[i] and dist[i] and dist[i] < best then
				u, best = i, dist[i]
			end
		end
		if not u or u == it then
			break
		end
		done[u] = true
		for _, e in ipairs(edges[u] or {}) do
			local nd = best + e.cost
			if not dist[e.to] or nd < dist[e.to] then
				dist[e.to], prev[e.to] = nd, { from = u, edge = e }
			end
		end
	end
	local steps, why
	if not dist[it] then
		why = ("no route known from %s to %s"):format(tostring(nodes[1].group), tostring(target.group))
	else
		local chain, i = {}, it
		while prev[i] do
			table.insert(chain, 1, prev[i])
			i = prev[i].from
		end
		-- Time per step (20 Nov 2026): the walk to the step plus the ride, in the planner's own units, which are rough
		-- minutes (AFGELEID: chosen to order routes, not measured). Shown as "about N min".
		local lastAt = 0
		local prevFly -- the flight step a next hop extends: one trip, one step ("fly to Thunder Bluff")
		for _, c in ipairs(chain) do
			if c.edge.fly and prevFly then
				prevFly.flyTo = TaxiName(c.edge.fly)
				prevFly.label = ns:L("FTRAVEL_FLY_FMT"):format(prevFly.flyTo)
				prevFly.min = prevFly.min + c.edge.cost
				prevFly.hops = prevFly.hops + 1
				lastAt = lastAt + c.edge.cost
			elseif c.edge.link or c.edge.tp or c.edge.fly then
				local from = nodes[c.from]
				steps = steps or {}
				local min = (dist[c.from] or 0) - lastAt + c.edge.cost
				lastAt = (dist[c.from] or 0) + c.edge.cost
				prevFly = nil
				if c.edge.fly then
					local dest = TaxiName(c.edge.fly)
					prevFly = { kind = "travel", forever = true, mapID = from.map, x = from.x, y = from.y,
						label = ns:L("FTRAVEL_FLY_FMT"):format(dest), flyTo = dest, link = "fly" .. tostring(from.taxi),
						linkKind = "flight", min = min, hops = 1 }
					prevFly.atRadius = 1
					steps[#steps + 1] = prevFly
				elseif c.edge.tp then
					steps[#steps + 1] = { kind = "travel", forever = true, cast = true, mapID = from.map, x = from.x,
						y = from.y, label = c.edge.tp.label, link = c.edge.tp.t.id, linkKind = "teleport", min = min }
				else
					local st = { kind = "travel", forever = true, mapID = from.map, x = from.x, y = from.y,
						label = Label(c.edge.link, c.edge.toEnd), link = c.edge.link.id, linkKind = c.edge.link.kind,
						min = min }
					-- 21 Nov 2026: the platform's master (two zeppelins at one tower), and how close counts as "you are
					-- at it" (half the way to the nearest other stop on that map, at most 2 map-%).
					local fromEnd = (c.edge.toEnd == "b") and "a" or "b"
					local m = MASTERS[(c.edge.link.id or "") .. fromEnd]
					if m then
						st.x, st.y = m.x, m.y
						st.label = st.label .. " " .. PlatformText(m)
						st.master, st.masterNpc = MasterName(m), m.npc
					end
					st.atRadius = ns.ForeverStopRadius and ns.ForeverStopRadius(st.mapID, st.x, st.y) or nil
					steps[#steps + 1] = st
				end
			else
				prevFly = nil -- a walk in between: a later flight is a new trip
			end
		end
		if steps then
			steps[#steps + 1] = { kind = "arrive", mapID = tmap, x = tx, y = ty, min = dist[it] - lastAt }
			steps.totalMin = dist[it]
		else
			why = "same land: walk"
		end
		-- Remember the start this plan chose; a start that paid the switch price had it added once: take it off again.
		local first = chain[1] and chain[1].edge
		local identity = (first and first.tp and first.tp.t.id) or "walk"
		if pin and pin.id ~= identity then
			if steps then
				steps.totalMin = math.max(0, steps.totalMin - SWITCH)
				if steps[1] and steps[1].min then
					steps[1].min = math.max(0, steps[1].min - SWITCH)
				end
			end
		end
		pins[pinKey] = { id = identity, at = now }
	end
	cache.key, cache.at, cache.steps, cache.why = key, now, steps, why
	return steps, why
end

-- The arrow asks for a plan many times a second; the "no Hearthstone" chat line comes once per target per session.
-- Chat is right here (CLAUDE.md, route arrow): it is an event you might miss, and it stays readable afterwards.
local hearthWarned = {}
if not ns.BuildTravelPlan then
	function ns.BuildTravelPlan(mapID, x, y)
		local ok, steps = pcall(Plan, mapID, x, y)
		steps = ok and steps or nil
		if steps then
			local k = ("%s:%.0f:%.0f"):format(tostring(mapID), x or 0, y or 0)
			if not hearthWarned[k] and NoHearthForTrip(steps) then
				hearthWarned[k] = true
				print("|cffffcc00Midnight Helper:|r " .. ns:L("FTRAVEL_NO_HEARTH_CHAT"))
			end
		end
		return steps
	end
end

--- NativeArrow: true when the target is on the same continent but cannot be walked to (Teldrassil, Rut'theran) or the
--- tram beats the walk (Stormwind <> Ironforge). Then the arrow asks for the plan instead of pointing across the sea.
function ns.ForeverTravelNeedsLink(_, mapID, x, y)
	local ok, steps = pcall(Plan, mapID, x, y)
	return ok and steps ~= nil
end

--- One sentence for a window ("The way there: …"). nil, true = you can walk there; nil = not known.
function ns.ForeverTravelSentence(mapID, x, y)
	local ok, steps, why = pcall(Plan, mapID, x, y)
	if not (ok and steps) then
		return nil, ok and why == "same land: walk"
	end
	local parts = {}
	for _, s in ipairs(steps) do
		if s.kind == "travel" and s.cast then
			parts[#parts + 1] = s.label -- "cast Teleport: Stormwind" happens where you stand: no "in <zone>"
		elseif s.kind == "travel" and s.flyTo then
			parts[#parts + 1] = ns:L("FTRAVEL_FLY_IN_FMT"):format(MapName(s.mapID), s.flyTo)
		elseif s.kind == "travel" then
			parts[#parts + 1] = ns:L("FTRAVEL_IN_FMT"):format(s.label, MapName(s.mapID))
		end
	end
	local sentence = table.concat(parts, ns:L("FTRAVEL_THEN")) .. "."
	if steps.totalMin then
		sentence = sentence .. " " .. ns:L("FTRAVEL_ABOUT_FMT"):format(math.max(1, math.floor(steps.totalMin + 0.5)))
	end
	if NoHearthForTrip(steps) then
		sentence = sentence .. " " .. ns:L("FTRAVEL_NO_HEARTH")
	end
	return sentence
end

--- 26 Nov 2026 (trainer arrow by travel time, not by straight line): the planner's minutes from where you stand to
--- (map, x, y), and how ("plan" = boats/teleports, "walk" = same land). nil when unknown (position unreadable, no route).
--- The minutes are the planner's own rough units (AFGELEID), good for choosing, shown as "about N min".
function ns.ForeverTravelMinutes(mapID, x, y)
	local ok, steps, why = pcall(Plan, mapID, x, y)
	if not ok then
		return nil
	end
	if steps and steps.totalMin then
		return steps.totalMin, "plan"
	end
	if why == "same land: walk" then
		local pmap, px, py = PlayerPos()
		if pmap and px then
			local c = WalkCost(Point(pmap, px, py), Point(mapID, x, y))
			if c then
				return c, "walk"
			end
		end
	end
	return nil
end

--- 26 Nov 2026 (class quest card, Rob: "waarom alleen maar een pijl die kant op en niet hoe ik kom?"): one line for a
--- card or chat, "The way there: the zeppelin … (about N min)." or "The way there: walk (about N min).". nil = unknown.
function ns.ForeverWayLine(mapID, x, y)
	local s, walk = ns.ForeverTravelSentence(mapID, x, y)
	if s then
		return ns:L("FWEAP_ROUTE_LABEL") .. " " .. s
	end
	if walk then
		local min = ns.ForeverTravelMinutes(mapID, x, y)
		if min then
			return ns:L("FWEAP_ROUTE_LABEL") .. " " .. ns:L("FTRAVEL_WALK_FMT"):format(math.max(1, math.floor(min + 0.5)))
		end
	end
	return nil
end

--- /mh travel: where MH thinks you are, and the plan to the arrow's current target.
function ns.ForeverTravelSlash()
	local P = "|cffffcc00Midnight Helper:|r "
	local pmap, px, py = PlayerPos()
	print(P .. ("travel: you are on %s (%s) %s, land %s, side %s"):format(MapName(pmap or 0), tostring(pmap),
		px and ("%.1f,%.1f"):format(px, py) or "?", tostring(pmap and Group(pmap, px, py)), tostring(Side())))
	local hs = HearthCount()
	print(("  hearthstone (item %d): %s; bound to %s"):format(HEARTHSTONE, hs == nil and "count unreadable" or tostring(hs),
		tostring(Bind() or "?")))
	-- Flight points (26 Nov 2026): which ones MH thinks you know, and from where. Compare with your flight map.
	knownCache.set = nil
	local okK, known = pcall(KnownTaxi, Side())
	local names = {}
	for id in pairs(okK and known or {}) do
		names[#names + 1] = ("%s (%d)"):format(TaxiName(id), id)
	end
	table.sort(names)
	print(("  flight points you know: %d — %s"):format(#names, taxiWhy))
	print("  " .. TaxiApiLine())
	if #names > 0 then
		print("    " .. table.concat(names, ", "))
	end
	-- Teleports: which ones the planner may use now, and why the others are left out (20 Nov 2026).
	pcall(Teleports)
	for _, t in ipairs(TELEPORTS) do
		if tpWhy[t.id] and tpWhy[t.id] ~= "other faction" then
			print(("  teleport %s (%s %d): %s"):format(t.id, t.item and "item" or "spell", t.item or t.spell, tpWhy[t.id]))
		end
	end
	if ns.ForeverSeenCount then
		print(("  NPC places learned by talking to them (trainers, vendors): %d"):format(ns.ForeverSeenCount()))
	end
	local lead = ns.GetActiveArrowLead and ns.GetActiveArrowLead()
	if not lead then
		print("  no arrow target. Set one (a trainer, a vendor) and type /mh travel again.")
		return
	end
	local steps, why = Plan(lead.mapID, lead.x, lead.y)
	print(("  target: %s on %s (%s) %.1f,%.1f, land %s"):format(tostring(lead.name), MapName(lead.mapID),
		tostring(lead.mapID), lead.x or 0, lead.y or 0, tostring(Group(lead.mapID, lead.x, lead.y))))
	if not steps then
		print("  no travel step: " .. tostring(why))
		return
	end
	for i, s in ipairs(steps) do
		if s.kind == "travel" then
			print(("  %d. %s — %s %.1f,%.1f (%s), about %.1f min"):format(i, s.label, MapName(s.mapID), s.x, s.y, s.link,
				s.min or 0))
		elseif s.kind == "arrive" then
			print(("  then walk to the target, about %.1f min"):format(s.min or 0))
		end
	end
	print(("  total: about %.1f min (rough: the planner's units are chosen, not measured)"):format(steps.totalMin or 0))
	print("  no-hearthstone warning: " .. (NoHearthForTrip(steps) and "YES (crosses the water, none in your bags)"
		or "no (you have one, the count is unreadable, or the route does not cross the water)"))
end

--------------------------------------------------------------------------------
-- Find → Travel (18 Nov 2026, Rob via sparring: "ik ben nu op zoek naar de zeppelins in ogrimar en heb geen idee hoe ik
-- daar kom … kortom … HELP !!!" → "ja"). Every boat, zeppelin, tram, portal and skycutter stop as a place to walk to,
-- named after where it goes. The planner's LINKS above, plus TRAVEL_EXTRA: crossings the planner leaves out (both ends
-- on one continent) but a player still looks for. Nothing here changes the planner.
--------------------------------------------------------------------------------
-- Research of 18 Nov 2026 (mh-research; docs/forever/REIZEN_2026-11-18.md). Stops = DB2 TaxiPathNode stops (Delay > 0)
-- of build 1.60.1.70959, converted to the zone map (AFGELEID). Whether the server really runs them: NOT measured.
local TRAVEL_EXTRA = {
	-- Grom'gol <> Undercity, path 301. Masters Squibby Overspeck 12137 (STV 31.5,29.4) and Hin Denburg 3150
	-- (Tirisfal 61.8,59.0), Wowhead Forever; object 176495 "Zeppelin - Grom'Gol to Undercity". Same towers as H1/H2.
	{ id = "X1", kind = "zeppelin", side = "H", a = { MAP.STV, 31.48, 29.10 }, b = { MAP.TIRISFAL, 61.92, 58.92 } },
	-- Feathermoon ferry, path 303: mainland dock <> Sardor Isle. Wowhead Forever object 177233 "Feathermoon Ferry".
	-- side A = it lands at the Alliance stronghold (AFGELEID; DB2 has no side for transports).
	{ id = "X2", kind = "boat", side = "A", a = { MAP.FERALAS, 43.13, 42.76 }, b = { MAP.FERALAS, 31.01, 39.51 },
		-- aName (Fable check, 18 Nov 2026): the way back left Feathermoon "to Feralas" while you are in Feralas; it goes to
		-- the Forgotten Coast (games.gg; DB2 AreaTable 1108).
		aName = "FTRAVEL_FORGOTTEN_COAST", bName = "FTRAVEL_FEATHERMOON" },
}

-- A line under a stop that is hard to find from the nearest city. [link id .. "a"/"b"] = locale key. Directions from the
-- Wowhead Classic guide "Flight Points, Zeppelins, and Ships" + Warcraft Wiki; platform sides fit the DB2 stops.
local STOP_NOTE = {
	H1a = "FTRAVEL_NOTE_ORG", H2a = "FTRAVEL_NOTE_ORG",
	H1b = "FTRAVEL_NOTE_UC", X1b = "FTRAVEL_NOTE_UC",
	-- Thunder Bluff has no zeppelin (no zeppelin path touches Mulgore in DB2, GEMETEN); the flight TB <> Orgrimmar exists
	-- (TaxiPath 387/42). The skycutter in Mulgore is the stop a Thunder Bluff player sees first, so the line goes there.
	S2b = "FTRAVEL_NOTE_TB",
}

local function TitleCase(s)
	return (s:gsub("^%l", string.upper))
end

--- 21 Nov 2026: the board point of a stop (the master when the platform has one) and how near counts as "there".
local function BoardPoint(link, endKey)
	local m = MASTERS[(link.id or "") .. endKey]
	local e = link[endKey]
	if m then
		return e[1], m.x, m.y, m
	end
	return e[1], e[2], e[3], nil
end

--- Radius in map-% within which you stand AT a stop: half the way to the nearest other stop on the same map, at most
--- 2 (the old fixed value). At Orgrimmar's tower the two platforms are 1.3 apart (GEMETEN in the DB2 stops), at
--- Grom'gol the masters 0.4; at Auberdine three piers 3.0-4.4 apart.
function ns.ForeverStopRadius(map, x, y)
	local best
	for _, list in ipairs({ LINKS, TRAVEL_EXTRA }) do
		for _, link in ipairs(list) do
			for _, k in ipairs({ "a", "b" }) do
				local m, px, py = BoardPoint(link, k)
				if m == map then
					local d = math.sqrt((px - x) ^ 2 + (py - y) ^ 2)
					if d > 0.05 and (not best or d < best) then
						best = d
					end
				end
			end
		end
	end
	return best and math.min(2, best / 2) or 2
end

--- { kind = "transport", name, side ("A"/"H"/"both"), map, x, y, note } for every stop of every crossing, both ends
--- unless the crossing runs one way.
function ns.ForeverTravelTransportSpots()
	local out = {}
	local function add(link, from, to, toName, endKey)
		local dest = toName and ns:L(toName) or MapName(to[1])
		local label = LABEL[link.kind] or "FTRAVEL_BOAT_FMT"
		local name
		if link.kind == "loop" then
			name = ns:L(label):format(dest, MapName(link.via))
		else
			name = ns:L(label):format(dest)
		end
		local side = (link.side == "A" or link.side == "H") and link.side or "both"
		local noteKey = STOP_NOTE[(link.id or "") .. endKey]
		local map, x, y, m = BoardPoint(link, endKey)
		if m then
			name = name .. " " .. PlatformText(m)
		end
		out[#out + 1] = { kind = "transport", name = TitleCase(name), side = side, map = map, x = x, y = y,
			note = noteKey and ns:L(noteKey) or nil, linkKind = link.kind, master = m and m.npc or nil }
	end
	for _, list in ipairs({ LINKS, TRAVEL_EXTRA }) do
		for _, link in ipairs(list) do
			add(link, link.a, link.b, link.bName, "a")
			if not link.oneway then
				add(link, link.b, link.a, link.aName, "b")
			end
		end
	end
	return out
end
