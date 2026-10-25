local _, ns = ...

--[[
	Midnight Helper — Hexmask help in the Labyrinth of Kindo'jan.

	Rob, 19 Oct 2026, after a full recorded run: he found two of the three Hexmasks and "kwam eigenlijk te laat achter
	dat ik dat moest gaan zoeken en daarvoor het pijltje konden gebruiken". The videos showed it (docs/
	labyrinth_run_2026-10-19): ~7 minutes in The Cave Towers without going near its spot, the locked door tried three
	times while the Keeper of the Key was passed twice, and a search for "hex" only at 10:30, after the masks mattered.

	What it does:
	  • Walk into one of the five shared rooms (Journey rank 2+) → one line on screen and in chat, once per room per
	    run: this room has the spot, and what can be there.
	  • /mh hexmask → the arrow to this room's spot, or to the nearest of the five; it also prints the decision.
	  • ns.LAB_HEXMASK_SPOTS feeds the search ("hexmask").

	Facts (Codex CODEX_LABJOURNEY_BODY, two research rounds, 19 Oct): the same five spots every run; three get a
	Hexmask, one the locked door, one stays empty, shuffled per run. Rob's run MEASURED the shuffle in part (door in
	Akil'zon's Roost, Fiery in Jan'alai's Refuge, a mask in Nalorakk's Rest).

	Room names: each spot carries its AreaTable ID (wago 12.1.5.70575, measured 25 Oct 2026), and the room is matched
	against the client's own name from C_Map.GetAreaInfo as well as the English one. Until then the hint only worked on
	an English client (it stayed silent elsewhere, and chat showed the English room name).
]]

local LAB_MAP = 2647

ns.LAB_HEXMASK_SPOTS = {
	{ room = "Chamber of Rites", area = 17025, x = 50.30, y = 82.60 },
	{ room = "The Cave Towers", area = 17033, x = 88.50, y = 51.50 },
	{ room = "Akil'zon's Roost", area = 17031, x = 56.80, y = 17.80 },
	{ room = "Jan'alai's Refuge", area = 17030, x = 18.80, y = 18.20 },
	{ room = "Nalorakk's Rest", area = 17032, x = 58.50, y = 21.70 },
}

local hinted = {}
local lastWhy = "nothing yet"

local function L(key)
	return (ns.L and ns:L(key)) or key
end

local function Norm(s)
	return type(s) == "string" and s:gsub("^[Tt]he ", ""):lower() or nil
end

local function DB()
	ns.db = ns.db or {}
	ns.db.labHexmask = ns.db.labHexmask or {}
	return ns.db.labHexmask
end

function ns.IsLabHexmaskHintEnabled()
	return DB().off ~= true
end

function ns.SetLabHexmaskHintEnabled(on)
	DB().off = (not on) and true or nil
end

--- Kindo'jan's platform ("De Empire's Rest", floor 1 of map group 491) is its own map: Rob at the boss on 25 Oct 2026
--- got "you are not in the Labyrinth". mh-research that day: wago UiMap 12.1.5.70575 + Rob's own SavedVariables
--- (questDiff.found, GetBestMapForUnit = 2648 at the boss). 2671 is a second drawing of 2647 and is never returned.
local LAB_BOSS_MAP = 2648

local function PlayerMap()
	if not (C_Map and C_Map.GetBestMapForUnit) then
		return nil
	end
	local ok, m = pcall(C_Map.GetBestMapForUnit, "player")
	return ok and m or nil
end

--- The rooms (the five spots live here). The boss platform is the Labyrinth too, but has no spot: see OnBossPlatform.
local function OnLabyrinthMap()
	return PlayerMap() == LAB_MAP
end

local function OnBossPlatform()
	return PlayerMap() == LAB_BOSS_MAP
end

local function HereRoom()
	if not GetSubZoneText then
		return nil
	end
	local ok, z = pcall(GetSubZoneText)
	if ok and type(z) == "string" and z ~= "" and not (issecretvalue and issecretvalue(z)) then
		return z
	end
	return nil
end

--- The room's name as this client shows it; the English name when the client has none.
local function RoomName(s)
	if s.area and C_Map and C_Map.GetAreaInfo then
		local ok, name = pcall(C_Map.GetAreaInfo, s.area)
		if ok and type(name) == "string" and name ~= "" then
			return name
		end
	end
	return s.room
end

local function SpotForRoom(room)
	local n = Norm(room)
	for _, s in ipairs(ns.LAB_HEXMASK_SPOTS) do
		if n and (Norm(s.room) == n or Norm(RoomName(s)) == n) then
			return s
		end
	end
	return nil
end

--- The three Hexmask companions, as the buff each one puts on you. MEASURED by Rob, 25 Oct 2026, with all three
--- following him: Fiery 1308804, Thundering 1308968, Frozen 1309122 (wago's SpellName 1308967 "Frozen Hexmask Familiar"
--- is NOT the buff: GetPlayerAuraBySpellID(1308967) said nothing while Frozen walked beside him).
local HEXMASK_BUFFS = { 1308804, 1308968, 1309122 }

--- How many Hexmasks are with you: a number, or nil when the auras cannot be read (then we do not claim three).
local function MasksWithYou()
	if not (ns.Aura and ns.Aura.HasPlayerAura) then
		return nil
	end
	local n = 0
	for _, id in ipairs(HEXMASK_BUFFS) do
		local has = ns.Aura.HasPlayerAura(id)
		if has == nil then
			return nil
		end
		if has then
			n = n + 1
		end
	end
	return n
end

--- Journey rank, or nil when unreadable. Rank 1 has no Hexmasks at all.
local function Rank()
	if ns.GetLabyrinthJourneyStatus then
		local st = ns.GetLabyrinthJourneyStatus()
		return st and st.rank or nil
	end
	return nil
end

local function Check()
	if not OnLabyrinthMap() then
		lastWhy = "not on the Labyrinth map"
		return
	end
	if not ns.IsLabHexmaskHintEnabled() then
		lastWhy = "switched off"
		return
	end
	local rank = Rank()
	if rank and rank < 2 then
		lastWhy = "Journey rank " .. rank .. " (Hexmasks come at rank 2)"
		return
	end
	local room = HereRoom()
	local spot = SpotForRoom(room)
	if not spot then
		lastWhy = "room '" .. tostring(room) .. "' has no Hexmask spot"
		return
	end
	-- Rob, 25 Oct 2026: "Ik heb nu alle drie de maskers al gevonden … en dan zegt hij nog steeds … Kunnen wij die maskers
	-- tellen en dan dit soort meldingen uitlaten?" Only three masks exist per run, so with all three there is nothing left.
	local masks = MasksWithYou()
	if masks and masks >= #HEXMASK_BUFFS then
		lastWhy = "all three Hexmasks are with you"
		return
	end
	if hinted[spot.room] then
		lastWhy = "already told for " .. spot.room
		return
	end
	hinted[spot.room] = true
	lastWhy = "told for " .. spot.room
	local msg = (L("LAB_HEXMASK_ROOM_FMT")):format(room or RoomName(spot))
	if ns.ShowBriefNotice then
		ns.ShowBriefNotice(msg, 14) -- 25 Oct 2026 (Rob): the room's big name covers the first seconds; hover to keep it
	end
	print(("%s %s"):format(L("PRINT_PREFIX"), msg))
end

--- `/mh hexmask`: arrow to this room's spot, or to the nearest one, and say why.
function ns.RouteLabHexmask()
	local p = "|cffffcc00Midnight Helper|r hexmask:"
	if not OnLabyrinthMap() then
		print(p .. " " .. L(OnBossPlatform() and "LAB_HEXMASK_BOSS_ROOM" or "LAB_HEXMASK_NOT_HERE"))
		for _, s in ipairs(ns.LAB_HEXMASK_SPOTS) do
			print(("   %s  %.1f/%.1f"):format(RoomName(s), s.x, s.y))
		end
		return false
	end
	local spot = SpotForRoom(HereRoom())
	if not spot and C_Map and C_Map.GetPlayerMapPosition then
		local ok, pos = pcall(C_Map.GetPlayerMapPosition, LAB_MAP, "player")
		if ok and pos and pos.GetXY then
			local px, py = pos:GetXY()
			if px and py then
				px, py = px * 100, py * 100
				local best
				for _, s in ipairs(ns.LAB_HEXMASK_SPOTS) do
					local d = (s.x - px) ^ 2 + (s.y - py) ^ 2
					if not best or d < best then
						best, spot = d, s
					end
				end
			end
		end
	end
	spot = spot or ns.LAB_HEXMASK_SPOTS[1]
	if ns.SetMapWaypoint then
		ns:SetMapWaypoint(LAB_MAP, spot.x, spot.y, RoomName(spot))
	end
	print(("%s %s"):format(p, (L("LAB_HEXMASK_ROUTED_FMT")):format(RoomName(spot))))
	print(("   |cff8a8f98rank %s · here '%s' · masks with you %s/3 · hint: %s|r"):format(tostring(Rank()),
		tostring(HereRoom()), tostring(MasksWithYou()), lastWhy))
	return true
end

local ev = CreateFrame("Frame")
for _, e in ipairs({ "ZONE_CHANGED", "ZONE_CHANGED_INDOORS", "ZONE_CHANGED_NEW_AREA", "PLAYER_ENTERING_WORLD" }) do
	pcall(ev.RegisterEvent, ev, e)
end
ev:SetScript("OnEvent", function(_, event)
	if event == "PLAYER_ENTERING_WORLD" then
		hinted = {} -- every zone-in is a new run, like the chest route's skip list
	end
	-- The subzone text can lag the event by a moment.
	if C_Timer and C_Timer.After then
		C_Timer.After(1, Check)
	else
		Check()
	end
end)
