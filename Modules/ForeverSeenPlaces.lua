local _, ns = ...

--[[
	ForeverSeenPlaces.lua — WoW Forever: remember where an NPC really stands, from the moment you talk to it.

	Rob, 11 Nov 2026: the arrow to the Paladin trainer Aramis Hammerhand pointed 12 m off, through a wall. Cause, measured
	that day: Wowhead gives his spawn as "31, 66.2", and nearly every trainer and vendor place in MH is rounded to one
	decimal (60 class-trainer rows even have a whole-number x or y). Rob: "Alle drie" (fix Aramis, learn from the game,
	say "you're there" up close).

	When a trainer window (TRAINER_SHOW) or a vendor window (MERCHANT_SHOW) opens, you stand within talking range of that
	NPC. We store your position under its NPC id, account-wide in MidnightHelperDB (ns.db.foreverSeenAt), and the trainer,
	weapon-master and vendor arrows use that place instead of the rounded list value, on the same map only.
	It never guesses: no readable NPC id or position = nothing stored. /mh travel prints how many places are known.
]]

if not ns.IS_FOREVER then
	return
end

local function Store()
	local db = ns.db
	if not db then
		return nil
	end
	db.foreverSeenAt = db.foreverSeenAt or {}
	return db.foreverSeenAt
end

local function NpcId(unit)
	local guid = UnitGUID and UnitGUID(unit)
	if type(guid) ~= "string" or (issecretvalue and issecretvalue(guid)) then
		return nil
	end
	-- Fields 2-5 loose: Forever 1.60.1 obfuscates the server and spawn id (same pattern as ForeverTrainer RecordHere).
	return tonumber(guid:match("^Creature%-[^%-]+%-[^%-]+%-[^%-]+%-[^%-]+%-(%d+)"))
end

local function PlayerPlace()
	local map = C_Map and C_Map.GetBestMapForUnit and C_Map.GetBestMapForUnit("player")
	if not map or not C_Map.GetPlayerMapPosition then
		return nil
	end
	local ok, pos = pcall(C_Map.GetPlayerMapPosition, map, "player")
	if not ok or not pos then
		return nil
	end
	local okXY, x, y = pcall(pos.GetXY, pos)
	if not okXY or not x or (issecretvalue and (issecretvalue(x) or issecretvalue(y))) then
		return nil
	end
	return map, x * 100, y * 100
end

local function Record()
	local npc = NpcId("npc")
	local map, x, y = PlayerPlace()
	local s = Store()
	if not (npc and map and s) then
		return
	end
	s[npc] = { map = map, x = math.floor(x * 100 + 0.5) / 100, y = math.floor(y * 100 + 0.5) / 100,
		at = time and time() or nil }
end

--- The place we saw this NPC from, on this map: x, y (0-100), or nil.
function ns.ForeverSeenPlace(npc, map)
	local s = Store()
	local e = s and type(npc) == "number" and s[npc]
	if e and e.map == map and e.x and e.y then
		return e.x, e.y
	end
	return nil
end

--- x, y to point the arrow at: the seen place when we have one for this NPC on this map, else the given values.
function ns.ForeverPlaceFix(npc, map, x, y)
	local sx, sy = ns.ForeverSeenPlace(npc, map)
	if sx then
		return sx, sy, true
	end
	return x, y, false
end

--- For /mh travel: how many places are remembered.
function ns.ForeverSeenCount()
	local n, s = 0, Store()
	for _ in pairs(s or {}) do
		n = n + 1
	end
	return n
end

local f = CreateFrame("Frame")
f:RegisterEvent("TRAINER_SHOW")
f:RegisterEvent("MERCHANT_SHOW")
f:SetScript("OnEvent", function()
	pcall(Record)
end)
