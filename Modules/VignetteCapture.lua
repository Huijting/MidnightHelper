local _, ns = ...

--[[
	Midnight Helper — vignette recorder (`/mh vignettes`).

	Rob is standing on the Coiled Isle on the 12.1 PTR, five days before the zone
	exists on live. `/mh rarescan` found "Looming Mutagenitor", npc 255088, in a zone
	we know nothing about — so the rares ARE there and can be collected now instead
	of after the patch.

	`/mh capture` already prints one pasteable line, but it needs the rare targeted
	and the line copied by hand. For a whole island that is unworkable, and Rob has
	said more than once that copying chat mid-play is exactly what he cannot do.

	So this records instead. Switch it on, fly a lap, `/reload`, and the list can be
	read out of SavedVariables at leisure: name, npcID, mapID and coordinates per
	rare, deduplicated.

	NEVER-LIE. Everything written here is something the client showed, not something
	inferred:
	  • npcID comes from field 6 of the objectGUID, the same extraction Rares.lua
	    and RareScanner use — not from a name lookup.
	  • coordinates come from C_VignetteInfo.GetVignettePosition, which returns a
	    vector on the map you pass it.
	  • a vignette missing either is still recorded, with the field left nil. A gap
	    is information; a filled-in guess is not.

	⚠️ PTR DATA IS NOT LIVE DATA. Content can change until the 11th, so anything
	captured here has to be re-checked on live before it ships. A list to verify is
	still worth far more than starting from nothing.
]]

local CAP = 300 -- plenty for a zone; stops a runaway from bloating SavedVariables

local function Store()
	if not ns.db then
		return nil
	end
	if type(ns.db.vignetteCapture) ~= "table" then
		ns.db.vignetteCapture = {}
	end
	return ns.db.vignetteCapture
end

--- npcID from field 6 of "Creature-0-...-npcID-spawnUID". Same as Rares.lua:396.
local function NpcIdFromObjectGUID(guid)
	-- A secret string passes type() and then throws on strsplit. Vignette GUIDs read
	-- fine on 6 Aug, but the same check written without this guard is what broke
	-- QuestDiff the same evening, so it is not left to luck.
	if type(guid) ~= "string" or (issecretvalue and issecretvalue(guid)) then
		return nil
	end
	return tonumber((select(6, strsplit("-", guid))))
end

--- GetVignettePosition returns one CVector2D normalized on the map, not two numbers.
local function VignettePos(guid, mapID)
	if not (C_VignetteInfo and C_VignetteInfo.GetVignettePosition and mapID) then
		return nil
	end
	local ok, pos = pcall(C_VignetteInfo.GetVignettePosition, guid, mapID)
	if not ok or type(pos) ~= "table" then
		return nil
	end
	if type(pos.GetXY) == "function" then
		local okXY, x, y = pcall(pos.GetXY, pos)
		if okXY and x then
			return x, y
		end
	end
	if type(pos.x) == "number" then
		return pos.x, pos.y
	end
	return nil
end

--- One sweep of everything the client currently shows.
---
--- Keyed on npcID when we have one, else on the name, so flying past the same rare
--- twice does not produce two rows — but a genuinely different rare with the same
--- name (they exist) still gets its own entry via the id.
local function Sweep()
	local store = Store()
	if not store or not (C_VignetteInfo and C_VignetteInfo.GetVignettes) then
		return
	end
	local mapID
	if C_Map and C_Map.GetBestMapForUnit then
		local ok, m = pcall(C_Map.GetBestMapForUnit, "player")
		mapID = ok and m or nil
	end

	local okList, list = pcall(C_VignetteInfo.GetVignettes)
	if not okList or type(list) ~= "table" then
		return
	end
	for _, guid in ipairs(list) do
		local okInfo, info = pcall(C_VignetteInfo.GetVignetteInfo, guid)
		if okInfo and type(info) == "table" then
			local npcID = NpcIdFromObjectGUID(info.objectGUID)
			local key = npcID and ("npc" .. npcID) or ("name" .. tostring(info.name))
			local row = store[key]
			if not row then
				local n = 0
				for _ in pairs(store) do
					n = n + 1
				end
				if n < CAP then
					row = {
						name = info.name,
						npcID = npcID,
						atlas = info.atlasName,
						isKill = info.isDead ~= nil and (info.isDead == false) or nil,
						mapID = mapID,
						seen = 0,
					}
					store[key] = row
				end
			end
			if row then
				row.seen = (row.seen or 0) + 1
				-- Coordinates only when the client gives them. A rare seen from far
				-- away often has none yet; the next pass fills it in.
				local x, y = VignettePos(guid, mapID)
				if x and not row.x then
					row.x, row.y = x, y
					row.mapID = mapID
				end
			end
		end
	end
end

local ticker
local function SetRunning(on)
	if on and not ticker and C_Timer and C_Timer.NewTicker then
		-- Two seconds: a rare stays on screen far longer than that even at flight
		-- speed, and it keeps the cost invisible next to the 30Hz arrow loop.
		ticker = C_Timer.NewTicker(2, function()
			pcall(Sweep)
		end)
	elseif not on and ticker then
		ticker:Cancel()
		ticker = nil
	end
end

--- `/mh vignettes` — toggle. `/mh vignettes clear` — start a fresh sweep.
function ns.HandleVignetteCapture(arg)
	local p = ("|cffffcc00%s|r"):format((ns.L and ns:L("PRINT_PREFIX")) or "Midnight Helper:")
	ns.db = ns.db or {}

	if arg == "clear" then
		ns.db.vignetteCapture = {}
		print(("%s vignette capture cleared."):format(p))
		return
	end

	ns.db.vignetteCaptureOn = not ns.db.vignetteCaptureOn
	SetRunning(ns.db.vignetteCaptureOn)
	if ns.db.vignetteCaptureOn then
		pcall(Sweep) -- catch what is on screen right now, before any flying
		print(("%s vignette capture ON — fly a lap, then |cffffffff/reload|r."):format(p))
	else
		local n = 0
		for _ in pairs(Store() or {}) do
			n = n + 1
		end
		print(("%s vignette capture OFF — %d distinct rare(s) recorded."):format(p, n))
	end
end

-- Resume after a /reload if it was left on, so the lap can span a loading screen.
local ev = CreateFrame("Frame")
ev:RegisterEvent("PLAYER_ENTERING_WORLD")
ev:SetScript("OnEvent", function()
	if ns.db and ns.db.vignetteCaptureOn then
		SetRunning(true)
	end
end)
