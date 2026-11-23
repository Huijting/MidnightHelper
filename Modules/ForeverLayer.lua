local _, ns = ...

--[[
	ForeverLayer.lua — WoW Forever: MEASURE what the game says about layers, before MH tells players anything.
	Rob, 23 Nov 2026 via Sparring 23-11, verbatim: "Ja, 1, 2 en 3, maar juist ook 3. Wat me nu vaak overkomt, dat ik veel
	te druk gebied zit met veel spelers. En die layer swap moet daar de oplossing voor komen." Then, on options A-D of
	docs/forever/LAYER_SWAP_ONDERZOEK_2026-11-23.md: "Ik ga uiteraard weer voor jullie advies." = A + D.

	The layer NUMBER cannot be read in Forever any more (Blizzard scrambles the GUID fields; GEMETEN in Rob's own RFC run
	of 23 Nov 2026). What the game still says, and what this file records without showing anything (step 1 of A):
	  SHARD_TRANSFER / _IMMINENT / _CANCELLED   "you are being moved" — when exactly they fire is the open question
	  PARTY_INVITE_REQUEST, 6th value           true = the invite comes from someone on another layer (isCrossShard)
	  UnitPhaseReason("partyN")                 1 (Sharding) = that group member is on another layer
	  ZONE_CHANGED_NEW_AREA, PLAYER_ENTERING_WORLD   for comparison: does SHARD_TRANSFER also fire on a plain zone change?
	Kept in ns.db.layerProbe.log (last 40, time + zone + values). NEVER another player's name.
	/mh layer = how busy it is around you now (player nameplates, enemies already tagged by someone else), what was
	logged, and which events this client accepted. Notices for players ("you were moved") come only after the
	measurement shows when SHARD_TRANSFER really fires: a notice on every zone change would be noise.
]]

if not ns.IS_FOREVER then
	return
end

local PREFIX = "|cffffcc00Midnight Helper:|r "
local KEEP = 40
local registered = {}

local function DB()
	ns.db = ns.db or {}
	if type(ns.db.layerProbe) ~= "table" then
		ns.db.layerProbe = { log = {} }
	end
	ns.db.layerProbe.log = ns.db.layerProbe.log or {}
	return ns.db.layerProbe
end

local function Readable(v)
	return v ~= nil and not (issecretvalue and issecretvalue(v))
end

local function Zone()
	local map = C_Map and C_Map.GetBestMapForUnit and C_Map.GetBestMapForUnit("player")
	return Readable(map) and map or nil
end

local function Note(event, extra)
	local d = DB()
	local row = { t = time and time() or 0, ev = event, map = Zone(), combat = InCombatLockdown and InCombatLockdown() or nil }
	for k, v in pairs(extra or {}) do
		row[k] = v
	end
	table.insert(d.log, row)
	while #d.log > KEEP do
		table.remove(d.log, 1)
	end
end

--- Group members on another layer, by the game's own phase reason (1 = Sharding). Counts only, no names.
local function PartyPhases()
	local out = {}
	if not UnitPhaseReason then
		return nil
	end
	for i = 1, 4 do
		local u = "party" .. i
		if UnitExists and UnitExists(u) then
			local ok, r = pcall(UnitPhaseReason, u)
			if not ok then
				out[#out + 1] = "error"
			elseif r == nil then
				out[#out + 1] = "same" -- nil = no phase difference
			elseif Readable(r) then
				out[#out + 1] = tostring(r)
			else
				out[#out + 1] = "unreadable"
			end
		end
	end
	return out
end

local ev = CreateFrame("Frame")
for _, e in ipairs({ "SHARD_TRANSFER", "SHARD_TRANSFER_IMMINENT", "SHARD_TRANSFER_CANCELLED", "PARTY_INVITE_REQUEST",
	"ZONE_CHANGED_NEW_AREA", "PLAYER_ENTERING_WORLD", "GROUP_ROSTER_UPDATE" }) do
	registered[e] = pcall(ev.RegisterEvent, ev, e) and true or false
end
local lastPhases
ev:SetScript("OnEvent", function(_, event, ...)
	local ok, err = pcall(function(...)
		if event == "PARTY_INVITE_REQUEST" then
			local cross = select(6, ...)
			Note(event, { crossShard = Readable(cross) and tostring(cross) or "unreadable", args = select("#", ...) })
		elseif event == "GROUP_ROSTER_UPDATE" then
			-- Only when the picture changes, so a busy group does not fill the log.
			local p = PartyPhases()
			local key = p and table.concat(p, ",") or "no api"
			if key ~= lastPhases then
				lastPhases = key
				Note(event, { phases = key })
			end
		elseif event == "PLAYER_ENTERING_WORLD" then
			local login, reload = ...
			Note(event, { login = login and true or nil, reload = reload and true or nil })
		else
			Note(event, { args = select("#", ...) })
		end
	end, ...)
	if not ok then
		DB().lastError = tostring(err)
	end
end)

--- How busy it is around you: player nameplates, enemy NPCs, and how many of those someone else already tagged.
local function Busy()
	local out = { players = 0, npcs = 0, tapped = 0, unreadable = 0 }
	local get = C_NamePlate and C_NamePlate.GetNamePlates
	if not get then
		out.why = "no C_NamePlate.GetNamePlates"
		return out
	end
	local ok, plates = pcall(get)
	if not ok or type(plates) ~= "table" then
		out.why = "nameplates unreadable"
		return out
	end
	for _, pl in ipairs(plates) do
		local u = pl and (pl.namePlateUnitToken or (pl.UnitFrame and pl.UnitFrame.unit))
		if u then
			local okP, isP = pcall(UnitIsPlayer, u)
			if okP and Readable(isP) then
				if isP then
					out.players = out.players + 1
				else
					out.npcs = out.npcs + 1
					local okT, t = pcall(UnitIsTapDenied, u)
					if okT and Readable(t) then
						if t then
							out.tapped = out.tapped + 1
						end
					else
						out.unreadable = out.unreadable + 1
					end
				end
			else
				out.unreadable = out.unreadable + 1
			end
		end
	end
	local cv = (C_CVar and C_CVar.GetCVar) or GetCVar
	if cv then
		local okC, v = pcall(cv, "nameplateShowFriends")
		out.friendPlates = okC and v or nil
	end
	return out
end

--- /mh layer [clear]
function ns.ForeverLayerSlash(arg)
	arg = (arg or ""):lower()
	local d = DB()
	if arg == "clear" then
		d.log = {}
		print(PREFIX .. "layer log cleared.")
		return
	end
	local b = Busy()
	d.lastBusy = { t = time and time() or 0, map = Zone(), players = b.players, npcs = b.npcs, tapped = b.tapped,
		unreadable = b.unreadable, friendPlates = b.friendPlates, why = b.why }
	print(PREFIX .. ("around you: %d players, %d NPCs of which %d already tagged by someone else%s."):format(b.players,
		b.npcs, b.tapped, b.unreadable > 0 and (", " .. b.unreadable .. " unreadable") or ""))
	if b.why then
		print("  " .. b.why)
	end
	if b.friendPlates == "0" then
		print("  Friendly player nameplates are OFF (game option), so only enemy-faction players are counted.")
	end
	local regs = {}
	for e, okR in pairs(registered) do
		regs[#regs + 1] = e .. (okR and "" or " (NOT accepted)")
	end
	table.sort(regs)
	print("  events: " .. table.concat(regs, ", "))
	print(("  logged: %d (last %d kept). Newest:"):format(#d.log, KEEP))
	for i = #d.log, math.max(1, #d.log - 7), -1 do
		local r = d.log[i]
		local extra = {}
		for _, k in ipairs({ "crossShard", "phases", "login", "reload", "args", "combat" }) do
			if r[k] ~= nil then
				extra[#extra + 1] = k .. "=" .. tostring(r[k])
			end
		end
		print(("  %s %s map %s %s"):format(date and date("%H:%M:%S", r.t) or r.t, r.ev, tostring(r.map),
			table.concat(extra, " ")))
	end
	print("  The layer number itself cannot be read in Forever. Switching layer needs another player's invite (layer addons: LayerSwap, Bulo Layer Forever, LayerETA).")
	print("  /reload writes it to MidnightHelperDB.layerProbe.")
end
