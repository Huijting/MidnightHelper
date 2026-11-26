local _, ns = ...

--[[
	ForeverRares.lua — WoW Forever: rares in the overview's Find tab (heading "Rares"), the search bar (@rare) and a red
	arrow. Rob, 18 Nov 2026 (via sparring): "en hebben we ook rares in forever ?" → research → "1 eerst a daarna b".
	Step A (this file now): the ~20 that are worth the trip, each with one line why. Step B: all of them, per zone.

	Facts: docs/forever/RARES_2026-11-18.md (mh-research, 18 Nov 2026). Coordinates: the main point of HandyNotes: WoW
	Forever v4 (Kemayo; no licence = All Rights Reserved: facts read, no file or structure copied - the coordinate rule
	Rob > HandyNotes > Zygor > guides; Zygor Forever has no rare data). Levels, Rare/Rare Elite and drop chances:
	Wowhead Forever tooltips, 18 Nov 2026. `kill` = who can attack it (the other side sees it as friendly), from the
	Forever Leveling Guide's faction reactions (read only); Sewer Beast stands in Stormwind, so Alliance in practice
	(AFGELEID). Names are the English ones (other clients: NOT measured; the game shows its own name on the spot).
	There is no rare kill flag in Forever (no tracking quests, and DB2 Vignette has 2 rows): nothing is ticked off.
	Not seen in game yet.
]]

if not ns.IS_FOREVER then
	return
end

local PREFIX = "|cffffcc00Midnight Helper:|r "

-- { npc, name, map, x, y, level, elite, kill ("both"/"Alliance"/"Horde"), why key }
-- Source of every x/y: HandyNotes_WoWForever zones\<Zone>.lua key of that npc (Skarr and The Razza re-read 18 Nov).
-- Levels: the research report; Ghost Howl 12, Blackmoss 13, Silithid Harvester 24 and Mist Howler 22 re-measured by the
-- build chat in the Wowhead Forever tooltip (run gamedata npc, 18 Nov). Lord Condar 15-16 and Scarlet Smith 58-59:
-- the higher value.
ns.FOREVER_RARES_WORTH = {
	{ npc = 2172, name = "Strider Clutchmother", map = 1439, x = 37.6, y = 92.0, level = 20, kill = "both", why = "FRARE_WHY_2172" },
	{ npc = 14268, name = "Lord Condar", map = 1432, x = 77.4, y = 73.4, level = 16, kill = "both", why = "FRARE_WHY_14268" },
	{ npc = 3581, name = "Sewer Beast", map = 1453, x = 64.4, y = 66.8, level = 50, kill = "Alliance", why = "FRARE_WHY_3581" },
	{ npc = 1920, name = "Dalaran Spellscribe", map = 1421, x = 63.0, y = 63.6, level = 21, kill = "Horde", why = "FRARE_WHY_1920" },
	{ npc = 5828, name = "Humar the Pridelord", map = 1413, x = 62.0, y = 33.6, level = 23, elite = true, kill = "both", why = "FRARE_WHY_SET" },
	{ npc = 5831, name = "Swiftmane", map = 1413, x = 60.4, y = 33.0, level = 21, elite = true, kill = "both", why = "FRARE_WHY_SET" },
	{ npc = 5842, name = "Takk the Leaper", map = 1413, x = 60.4, y = 9.4, level = 19, elite = true, kill = "both", why = "FRARE_WHY_SET" },
	{ npc = 263141, name = "Scaldaron", map = 2548, x = 30.7, y = 72.4, level = 43, elite = true, kill = "both", why = "FRARE_WHY_263141" },
	{ npc = 11498, name = "Skarr the Unbreakable", map = 1444, x = 62.4, y = 30.0, level = 58, elite = true, kill = "both", why = "FRARE_WHY_MAUL" },
	{ npc = 11497, name = "The Razza", map = 1444, x = 62.4, y = 30.1, level = 60, elite = true, kill = "both", why = "FRARE_WHY_MAUL" },
	{ npc = 5797, name = "Aean Swiftriver", map = 1413, x = 46.0, y = 69.0, level = 25, elite = true, kill = "Horde", why = "FRARE_WHY_5797" },
	{ npc = 3535, name = "Blackmoss the Fetid", map = 1438, x = 42.8, y = 28.6, level = 13, kill = "both", why = "FRARE_WHY_3535" },
	{ npc = 3056, name = "Ghost Howl", map = 1412, x = 39.5, y = 23.9, level = 12, kill = "both", why = "FRARE_WHY_3056" },
	{ npc = 3253, name = "Silithid Harvester", map = 1413, x = 44.6, y = 69.8, level = 24, kill = "both", why = "FRARE_WHY_3253" },
	{ npc = 1844, name = "Foreman Marcrid", map = 1422, x = 47.0, y = 34.2, level = 58, kill = "both", why = "FRARE_WHY_1844" },
	{ npc = 1885, name = "Scarlet Smith", map = 1422, x = 45.2, y = 13.6, level = 59, kill = "both", why = "FRARE_WHY_1885" },
	{ npc = 276061, name = "Decrepit Harvester", map = 1420, x = 53.2, y = 57.4, level = 8, kill = "both", why = "FRARE_WHY_276061" },
	{ npc = 1106, name = "Lost One Cook", map = 1435, x = 64.4, y = 22.8, level = 37, kill = "both", why = "FRARE_WHY_1106" },
	{ npc = 2447, name = "Narillasanz", map = 1416, x = 74.4, y = 53.4, level = 44, elite = true, kill = "both", why = "FRARE_WHY_2447" },
	{ npc = 8206, name = "Soul of Tanaris", map = 1446, x = 53.0, y = 45.6, level = 51, elite = true, kill = "both", why = "FRARE_WHY_8206" },
	{ npc = 5934, name = "Heartrazor", map = 1441, x = 16.6, y = 41.4, level = 32, elite = true, kill = "both", why = "FRARE_WHY_5934" },
	{ npc = 10644, name = "Mist Howler", map = 1440, x = 22.2, y = 29.4, level = 22, kill = "both", why = "FRARE_WHY_10644" },
	{ npc = 276111, name = "Ghostfang", map = 1426, x = 80.6, y = 47.0, level = 10, kill = "both", why = "FRARE_WHY_TAME" },
	{ npc = 274300, name = "Coldrasp", map = 1420, x = 17.8, y = 68.4, level = 12, kill = "both", why = "FRARE_WHY_TAME" },
}

local function Side()
	local f = UnitFactionGroup and UnitFactionGroup("player")
	return (f == "Alliance" or f == "Horde") and f or nil
end

local function World(map, x, y)
	if not (C_Map and C_Map.GetWorldPosFromMapPos and CreateVector2D) then
		return nil
	end
	local ok, cont, pos = pcall(C_Map.GetWorldPosFromMapPos, map, CreateVector2D(x / 100, y / 100))
	if not ok or not cont or not pos then
		return nil
	end
	local okXY, wx, wy = pcall(pos.GetXY, pos)
	if not okXY then
		return nil
	end
	return cont, wx, wy
end

local function PlayerWorld()
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
	return World(map, x * 100, y * 100)
end

local function ZoneName(map)
	local info = C_Map and C_Map.GetMapInfo and C_Map.GetMapInfo(map)
	return info and info.name or ("map " .. tostring(map))
end

local function GoTo(r, dist)
	if not (ns.SetBlizzardUserWaypoint and ns.SetBlizzardUserWaypoint(r.map, r.x, r.y)) then
		if not ns._mhWaypointYielded then
			print(PREFIX .. ns:L("FVEND_NO_WAYPOINT"))
		end
		return false
	end
	-- Rares stand a little off their point and some walk about: the arrow lets go at 20 yards, not 5.
	ns.lastTarget = { mapID = r.map, x = r.x, y = r.y, name = r.name, via = "/mh rare", arriveYards = 20 }
	ns._mhRouteOwner = "rarespot" -- red, released on arrival (NativeArrow.lua)
	print(PREFIX .. ns:L("FRARE_ARROW_FMT"):format(r.name, ZoneName(r.map),
		dist and (ns.ForeverTrainerDistance and ns.ForeverTrainerDistance(dist) or ("%d yd"):format(dist))
			or ns:L("FVEND_OTHER_CONT")))
	return true
end

-- Step B (18 Nov 2026): ForeverRaresAll.lua (generated, 399 rares). A rare that is also in the list above keeps its
-- "why" line and its side rule there; the others are shown for both sides (who can attack them is not known).
local WORTH_BY_NPC = {}
for _, r in ipairs(ns.FOREVER_RARES_WORTH) do
	WORTH_BY_NPC[r.npc] = r
end

local zoneCats -- { key = "z<map>", map, lo, hi }, sorted by lowest level; built once
local function ZoneCats()
	if zoneCats then
		return zoneCats
	end
	local by = {}
	for _, r in ipairs(ns.FOREVER_RARES_ALL or {}) do
		local c = by[r.map]
		if not c then
			c = { key = "z" .. r.map, map = r.map }
			by[r.map] = c
		end
		if r.level then
			c.lo = math.min(c.lo or r.level, r.level)
			c.hi = math.max(c.hi or r.level, r.level)
		end
	end
	zoneCats = {}
	for _, c in pairs(by) do
		zoneCats[#zoneCats + 1] = c
	end
	table.sort(zoneCats, function(a, b)
		if (a.lo or 99) ~= (b.lo or 99) then
			return (a.lo or 99) < (b.lo or 99)
		end
		return a.map < b.map
	end)
	return zoneCats
end

--- The zone you are in that has rares in our list, or nil. A city, cave or building map has its own map id, so walk up
--- the parents (C_Map.GetMapInfo parentMapID) until a zone of the list is found. Unreadable = nil (old order).
local function HereZone()
	if not (C_Map and C_Map.GetBestMapForUnit) then
		return nil
	end
	local ok, map = pcall(C_Map.GetBestMapForUnit, "player")
	if not ok or type(map) ~= "number" then
		return nil
	end
	local has = {}
	for _, c in ipairs(ZoneCats()) do
		has[c.map] = c
	end
	for _ = 1, 6 do
		if not map or map == 0 then
			return nil
		end
		if has[map] then
			return has[map]
		end
		local info = C_Map.GetMapInfo and C_Map.GetMapInfo(map)
		map = info and info.parentMapID
	end
	return nil
end

--- Find categories for the overview: { key, name }: "Worth the trip", then every zone with rares (level range).
--- 19 Nov 2026 (Rob via sparring: "Kunnen we het zo instellen dat we gewoon waar ik nu ben altijd bovenaan staat?" →
--- "Ja, doe maar."): the zone you are in comes first, with "(you are here)", then "Worth the trip", then the rest as
--- before. Built at every call, so it follows you when you change zone (the overview asks again on every fill).
function ns.ForeverRareFindCats()
	local here = HereZone()
	local out = {}
	local function range(c)
		return (c.lo and c.hi) and ((c.lo == c.hi) and (" (%d)"):format(c.lo) or (" (%d-%d)"):format(c.lo, c.hi)) or ""
	end
	if here then
		out[#out + 1] = { key = here.key, name = ZoneName(here.map) .. range(here) .. "  " .. ns:L("FRARE_HERE"),
			here = true }
	end
	out[#out + 1] = { key = "worth", name = ns:L("FRARE_CAT_WORTH") }
	for _, c in ipairs(ZoneCats()) do
		if c ~= here then
			out[#out + 1] = { key = c.key, name = ZoneName(c.map) .. range(c) }
		end
	end
	return out
end
ns.ForeverRareHereZone = HereZone -- readable from /dump when the zone does not come first (silence rule)

local function Allowed(r, side)
	local w = WORTH_BY_NPC[r.npc]
	local kill = (w and w.kill) or r.kill or "both"
	return kill == "both" or (side and kill == side)
end

--- The rares of a category that your side can attack, nearest first: rows { name, tag, why, zone, dist, map, x, y, go }.
--- Second value: whether your own position could be read.
function ns.ForeverRareFindRows(key)
	local src
	if key == "worth" then
		src = ns.FOREVER_RARES_WORTH
	else
		local map = tonumber(type(key) == "string" and key:match("^z(%d+)$"))
		if not map then
			return {}, true
		end
		src = {}
		for _, r in ipairs(ns.FOREVER_RARES_ALL or {}) do
			if r.map == map then
				src[#src + 1] = r
			end
		end
	end
	local side = Side()
	local pc, px, py = PlayerWorld()
	local list = {}
	for _, r in ipairs(src) do
		if Allowed(r, side) then
			local rc, rx, ry = World(r.map, r.x, r.y)
			local dist
			if pc and rc and pc == rc then
				dist = math.sqrt((rx - px) ^ 2 + (ry - py) ^ 2)
			end
			list[#list + 1] = { r = r, dist = dist }
		end
	end
	table.sort(list, function(a, b)
		if a.dist and b.dist then
			return a.dist < b.dist
		end
		if a.dist or b.dist then
			return a.dist ~= nil
		end
		if (a.r.level or 99) ~= (b.r.level or 99) then
			return (a.r.level or 99) < (b.r.level or 99)
		end
		return a.r.name < b.r.name
	end)
	local rows = {}
	for _, e in ipairs(list) do
		local r = e.r
		local w = WORTH_BY_NPC[r.npc]
		local tag
		if r.level then
			tag = ns:L(r.elite and "FRARE_TAG_ELITE_FMT" or "FRARE_TAG_FMT"):format(r.level)
		else
			tag = ns:L(r.elite and "FRARE_TAG_SKULL_ELITE" or "FRARE_TAG_SKULL") -- Wowhead says "??"
		end
		local whyKey = r.why or (w and w.why)
		local why = whyKey and ns:L(whyKey) or nil
		-- What you looted from it yourself (learned below; a count, not a chance).
		local loot = ns.ForeverRareLootLine and ns.ForeverRareLootLine(r.npc, 3)
		if loot then
			why = why and (why .. "\n" .. loot) or loot
		end
		rows[#rows + 1] = {
			name = r.name,
			tag = tag,
			why = why,
			zone = ZoneName(r.map), dist = e.dist, map = r.map, x = r.x, y = r.y, npc = r.npc,
			go = function()
				return GoTo(r, e.dist)
			end,
		}
	end
	return rows, pc ~= nil
end

--------------------------------------------------------------------------------
-- The rare in 3D (26 Nov 2026). Rob via Sparring: "Toen ging ik kijken bij ons in Find… Een animatie." Mouse on a rare
-- in Find → a small frame beside the window with the rare turning; the rare window has one built in.
-- How: PlayerModel:SetCreature(npc id), the same as the boss guide (ForeverDungeonGuide.lua ShowModel), which Rob saw
-- working in Forever on 19 Nov (Sneed, Captain Greenskin: GEMETEN). Whether it draws an npc you have never been near is
-- NOT measured: when no model loaded after 1.5 s (GetModelFileID 0/nil) the frame hides itself — no black box — and
-- /mh rares why says so (raModelWhy).
--------------------------------------------------------------------------------
local raModelWhy = "no rare model asked for yet"

--- Put npc on model m (a PlayerModel), turning slowly. done(ok) is called after 1.5 s: ok = a model file loaded.
--- isCurrent() says whether this request is still the one on screen (the mouse may have moved on).
local function SetRareModel(m, npc, isCurrent, done)
	if not (m and m.SetCreature and npc) then
		raModelWhy = "SetCreature missing on this client"
		if done then
			done(false)
		end
		return false
	end
	local function apply()
		m:ClearModel()
		m:SetCreature(npc)
		if m.SetPortraitZoom then
			m:SetPortraitZoom(0) -- the whole figure
		end
		if m.SetCamDistanceScale then
			m:SetCamDistanceScale(1.1)
		end
		if m.SetPosition then
			m:SetPosition(0, 0, 0)
		end
	end
	if not pcall(apply) then
		raModelWhy = ("npc %d: SetCreature raised an error"):format(npc)
		if done then
			done(false)
		end
		return false
	end
	if not (C_Timer and C_Timer.After) then
		return true
	end
	-- Models load async (DungeonBossWindow.lua: an empty first draw): once more, then check.
	C_Timer.After(0.2, function()
		if isCurrent() then
			pcall(apply)
		end
	end)
	C_Timer.After(1.5, function()
		if not isCurrent() then
			return
		end
		local fid
		if m.GetModelFileID then
			local ok, v = pcall(m.GetModelFileID, m)
			if ok and not (issecretvalue and issecretvalue(v)) then
				fid = v
			end
		end
		local okModel = fid ~= nil and fid ~= 0
		raModelWhy = okModel and ("npc %d: model loaded (file %s)"):format(npc, tostring(fid))
			or ("npc %d: no model after 1.5 s (file id %s) - hidden"):format(npc, tostring(fid))
		if done then
			done(okModel)
		end
	end)
	return true
end

local function Turn(self, elapsed)
	self._facing = ((self._facing or 0.45) + elapsed * 0.6) % (2 * math.pi)
	if self.SetFacing then
		pcall(self.SetFacing, self, self._facing)
	end
end

local hoverFrame
local hoverToken = 0

local function TopWindow(f)
	local p = f
	while p and p.GetParent and p:GetParent() and p:GetParent() ~= UIParent do
		p = p:GetParent()
	end
	return p
end

--- Mouse on a rare row (ForeverOverview.lua Find page): the rare turning beside the window. nil npc = hide.
function ns.ForeverRareModelHover(owner, npc, name)
	hoverToken = hoverToken + 1
	if not npc then
		if hoverFrame then
			hoverFrame:Hide()
		end
		return
	end
	if not hoverFrame then
		local f = CreateFrame("Frame", nil, UIParent, "BackdropTemplate") -- unnamed: a hover picture, not a window
		f:SetSize(200, 240)
		f:SetFrameStrata("TOOLTIP")
		f:SetClampedToScreen(true)
		f:SetBackdrop({ bgFile = "Interface\\Buttons\\WHITE8X8", edgeFile = "Interface\\Buttons\\WHITE8X8", edgeSize = 1 })
		f:SetBackdropColor(0.04, 0.04, 0.06, 0.95)
		f:SetBackdropBorderColor(0.9, 0.3, 0.3, 0.9)
		f.m = CreateFrame("PlayerModel", nil, f)
		f.m:SetPoint("TOPLEFT", 6, -6)
		f.m:SetPoint("BOTTOMRIGHT", -6, 24)
		f.m:SetScript("OnUpdate", Turn)
		f.name = f:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
		f.name:SetPoint("BOTTOMLEFT", 6, 6)
		f.name:SetPoint("BOTTOMRIGHT", -6, 6)
		f.name:SetJustifyH("CENTER")
		f:Hide()
		hoverFrame = f
	end
	local f = hoverFrame
	local token = hoverToken
	local win = TopWindow(owner) or owner
	f:ClearAllPoints()
	f:SetPoint("TOPLEFT", win, "TOPRIGHT", 6, -40)
	f.name:SetText(name or "")
	if SetRareModel(f.m, npc, function()
		return token == hoverToken and f:IsShown()
	end, function(ok)
		if not ok then
			f:Hide()
		end
	end) then
		f:Show()
	else
		f:Hide()
	end
end

--------------------------------------------------------------------------------
-- A rare in sight: a small window (26 Nov 2026). Rob via Sparring: "Ja, een eigen venstertje voor [rares]. … Niet
-- iedereen zal Polestar gebruiken." → "Ik volg sowieso jouw advies, dus ik zeg ja". The idea (watch nameplates, target
-- and mouseover, a Target button) came from READING Polestar (GPL-3): no code or table taken; our own rare list.
-- Detection, GEMETEN as API names in the client, behaviour not seen in Forever yet:
--   NAME_PLATE_UNIT_ADDED (unit), PLAYER_TARGET_CHANGED ("target"), UPDATE_MOUSEOVER_UNIT ("mouseover"). A unit counts
--   when UnitClassification says "rare"/"rareelite" OR its npc id (from UnitGUID) is in FOREVER_RARES_ALL / _WORTH,
--   it is alive and you can attack it. Once per rare per 10 minutes.
-- Window: name, level, zone, "why" (Worth the trip), and Target / Show in Find / Waypoint. Target is a secure macro
-- button (/targetexact) on UIParent, placed over the window OUT of combat only, never anchored to it (an anchored secure
-- button would make the window protected): in combat the window says "Target: after the fight".
-- On by default (Quiet helpers; it only shows a window). /mh rares [why|test|on|off] says what it saw and decided.
--------------------------------------------------------------------------------
local RA_W = 380
local RA_MODEL = 100 -- the rare in 3D on the left (hidden again when no model loads; the text then takes the width)
local RA_COOLDOWN = 600
local raBy = {} -- npc id -> list row (all rares, the "worth" rows win for their why/side)
for _, r in ipairs(ns.FOREVER_RARES_ALL or {}) do
	raBy[r.npc] = r
end
for _, r in ipairs(ns.FOREVER_RARES_WORTH) do
	raBy[r.npc] = r
end
local raLastSeen = {} -- npc id or name -> GetTime()
local raWhy = "nothing seen yet this session"
local raWin, raTarget

function ns.IsForeverRareAlertOn()
	return not (type(ns.db) == "table" and ns.db.foreverRareAlert == false)
end

function ns.SetForeverRareAlert(on)
	if type(ns.db) ~= "table" then
		return
	end
	if on then
		ns.db.foreverRareAlert = nil
	else
		ns.db.foreverRareAlert = false
		if raWin then
			raWin:Hide()
		end
	end
end

local function Plain(v)
	if v == nil or (issecretvalue and issecretvalue(v)) then
		return nil
	end
	return v
end

local function NpcId(unit)
	local ok, guid = pcall(UnitGUID, unit)
	guid = ok and Plain(guid) or nil
	if type(guid) ~= "string" then
		return nil
	end
	local kind, id = guid:match("^(%a+)%-%d+%-%d+%-%d+%-%d+%-(%d+)")
	if kind ~= "Creature" and kind ~= "Vehicle" then
		return nil
	end
	return tonumber(id)
end

--- Place the secure Target button over the window (out of combat only).
local function PlaceTarget()
	if not (raTarget and raWin) or (InCombatLockdown and InCombatLockdown()) then
		return
	end
	if not (raWin:IsShown() and raWin.targetName) then
		raTarget:Hide()
		return
	end
	local l, b = raWin.targetSpot:GetLeft(), raWin.targetSpot:GetBottom()
	if not (l and b) then
		raTarget:Hide()
		return
	end
	local s = (raWin.targetSpot:GetEffectiveScale() or 1) / (UIParent:GetEffectiveScale() or 1)
	raTarget:SetScale(s)
	raTarget:ClearAllPoints()
	raTarget:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", l, b) -- in the button's own (scaled) coordinates
	raTarget:SetAttribute("type", "macro")
	raTarget:SetAttribute("macrotext", "/targetexact " .. raWin.targetName)
	raTarget:Show()
end

local function BuildAlert()
	if raWin then
		return raWin
	end
	local Style = ns.ForeverStyle
	local f = CreateFrame("Frame", "MidnightHelperForeverRareAlert", UIParent, "BackdropTemplate")
	f:SetSize(RA_W, 120)
	f:SetFrameStrata("HIGH")
	f:SetBackdrop({ bgFile = "Interface\\Buttons\\WHITE8X8", edgeFile = "Interface\\Buttons\\WHITE8X8", edgeSize = 1 })
	local pos = type(ns.db) == "table" and ns.db.foreverRareAlertPos
	if type(pos) == "table" and pos[1] then
		f:SetPoint(pos[1], UIParent, pos[2] or pos[1], pos[3] or 0, pos[4] or 0)
	else
		f:SetPoint("TOP", UIParent, "TOP", 0, -160)
	end
	f:EnableMouse(true)
	f:SetMovable(true)
	f:SetClampedToScreen(true)
	f:RegisterForDrag("LeftButton")
	f:SetScript("OnDragStart", f.StartMoving)
	f:SetScript("OnDragStop", function(self)
		self:StopMovingOrSizing()
		if type(ns.db) == "table" then
			local p, _, rp, x, y = self:GetPoint(1)
			ns.db.foreverRareAlertPos = { p, rp, x, y }
		end
		PlaceTarget()
	end)
	local t = Style and Style.T and Style.T() or { gold = { 1, 0.82, 0 }, text = { 1, 1, 1 }, dim = { 0.7, 0.7, 0.7 } }
	local function line(role, size, color)
		local fs = (Style and Style.Text) and Style.Text(f, role, size, color) or f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
		fs._mhSkinned = true
		fs:SetJustifyH("LEFT")
		fs:SetWidth(RA_W - 24)
		return fs
	end
	f.model = CreateFrame("PlayerModel", nil, f)
	f.model:SetSize(RA_MODEL, RA_MODEL + 10)
	f.model:SetPoint("TOPLEFT", 8, -8)
	f.model:SetScript("OnUpdate", Turn)
	f.head = line("head2", 12, { 1, 0.35, 0.35 })
	f.head:SetPoint("TOPLEFT", 12, -10)
	f.name = line("head2", 18, t.gold)
	f.name:SetPoint("TOPLEFT", f.head, "BOTTOMLEFT", 0, -4)
	f.info = line("text", 13, t.text)
	f.info:SetPoint("TOPLEFT", f.name, "BOTTOMLEFT", 0, -3)
	f.why = line("text", 12, t.dim)
	f.why:SetPoint("TOPLEFT", f.info, "BOTTOMLEFT", 0, -3)
	local close = CreateFrame("Button", nil, f, "UIPanelCloseButton")
	close:SetPoint("TOPRIGHT", 2, 2)
	close:SetScale(0.8)
	-- Left: where the secure Target button goes (a plain frame of the same size; the real button sits over it).
	f.targetSpot = CreateFrame("Frame", nil, f)
	f.targetSpot:SetSize(84, 22)
	f.targetSpot:SetPoint("BOTTOMLEFT", 10, 10)
	f.combat = line("text", 11, t.dim)
	f.combat:SetWidth(84)
	f.combat:SetPoint("CENTER", f.targetSpot, "CENTER")
	f.find = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
	f.find:SetSize(96, 22)
	f.find:SetPoint("LEFT", f.targetSpot, "RIGHT", 6, 0)
	f.find:SetText(ns:L("FRALERT_FIND"))
	f.way = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
	f.way:SetSize(84, 22)
	f.way:SetPoint("LEFT", f.find, "RIGHT", 6, 0)
	f.way:SetText(ns:L("FRALERT_WAY"))
	f:SetScript("OnHide", function()
		if raTarget and not (InCombatLockdown and InCombatLockdown()) then
			raTarget:Hide()
		end
	end)
	if Style and Style.SkinOnShow then
		Style.SkinOnShow(f)
	end
	local r, g, b = 0.9, 0.3, 0.3
	f:HookScript("OnShow", function(self)
		self:SetBackdropBorderColor(r, g, b, 1)
	end)
	if ns.RegisterMidnightDialogPopup then
		ns.RegisterMidnightDialogPopup(f) -- Shift+scroll = size (every MH window), Escape closes
	end
	f:Hide()
	raWin = f
	-- The secure Target button: UIParent's child, never anchored to the window.
	raTarget = CreateFrame("Button", "MidnightHelperForeverRareTarget", UIParent,
		"SecureActionButtonTemplate,UIPanelButtonTemplate")
	raTarget:SetSize(84, 22)
	raTarget:SetFrameStrata("DIALOG")
	raTarget:RegisterForClicks("AnyUp", "AnyDown")
	raTarget:SetText(ns:L("FRALERT_TARGET"))
	raTarget:Hide()
	return f
end

--- Show the window for this rare. r = our list row or nil; name/level from the client when readable.
local function ShowAlert(r, name, level, elite, map, x, y, how, npc)
	if not ns.IsForeverRareAlertOn() then
		raWhy = "saw " .. tostring(name) .. " (" .. how .. "), but the window is switched off"
		return
	end
	local f = BuildAlert()
	f.head:SetText(ns:L("FRALERT_HEAD"):upper())
	f.name:SetText(name or (r and r.name) or "?")
	local tag
	if level and level > 0 then
		tag = ns:L(elite and "FRARE_TAG_ELITE_FMT" or "FRARE_TAG_FMT"):format(level)
	else
		tag = ns:L(elite and "FRARE_TAG_SKULL_ELITE" or "FRARE_TAG_SKULL")
	end
	f.info:SetText(tag .. "  ·  " .. ZoneName(map or (r and r.map) or 0))
	local whyKey = r and (r.why or (WORTH_BY_NPC[r.npc] and WORTH_BY_NPC[r.npc].why))
	local whyText = whyKey and ns:L(whyKey) or ""
	local lootLine = ns.ForeverRareLootLine and ns.ForeverRareLootLine(npc or (r and r.npc), 3)
	if lootLine then
		whyText = (whyText ~= "" and (whyText .. "\n") or "") .. lootLine
	end
	f.why:SetText(whyText)
	-- /targetexact needs the client's own name: the unit's name when readable, the list's English name on English only.
	f.targetName = name or ((GetLocale and GetLocale() == "enUS") and r and r.name) or nil
	f.combat:SetText((InCombatLockdown and InCombatLockdown()) and ns:L("FRALERT_COMBAT") or "")
	f.find:SetScript("OnClick", function()
		if ns.ShowForeverFind then
			ns.ShowForeverFind("rare", r and ("z" .. r.map) or "worth")
		end
	end)
	local wm, wx, wy = (r and r.map) or map, (r and r.x) or x, (r and r.y) or y
	f.way:SetShown(wm and wx and true or false)
	f.way:SetScript("OnClick", function()
		if wm and wx and ns.SetBlizzardUserWaypoint and ns.SetBlizzardUserWaypoint(wm, wx, wy) then
			ns.lastTarget = { mapID = wm, x = wx, y = wy, name = name or (r and r.name), via = "/mh rares", arriveYards = 20 }
			ns._mhRouteOwner = "rarespot"
		end
	end)
	-- Text to the right of the model while it is there; the whole width when it is not (no empty square).
	local function Layout(withModel)
		local left = withModel and (8 + RA_MODEL + 8) or 12
		f.head:ClearAllPoints()
		f.head:SetPoint("TOPLEFT", left, -10)
		for _, fs in ipairs({ f.head, f.name, f.info, f.why }) do
			fs:SetWidth(RA_W - left - 14)
		end
		f.model:SetShown(withModel)
		local textH = 10 + (f.head:GetStringHeight() or 12) + 4 + (f.name:GetStringHeight() or 18) + 3
			+ (f.info:GetStringHeight() or 13) + 3 + ((f.why:GetText() or "") ~= "" and (f.why:GetStringHeight() or 12) or 0)
		if withModel then
			textH = math.max(textH, 8 + RA_MODEL + 10)
		end
		f:SetHeight(textH + 10 + 22 + 10)
		PlaceTarget()
	end
	npc = npc or (r and r.npc)
	f._modelToken = (f._modelToken or 0) + 1
	local token = f._modelToken
	local hasModel = npc and SetRareModel(f.model, npc, function()
		return token == f._modelToken and f:IsShown()
	end, function(ok)
		if not ok then
			Layout(false)
		end
	end) or false
	Layout(hasModel and true or false)
	f.shownAt = GetTime and GetTime() or 0
	f:Show()
	PlaceTarget()
	raWhy = ("shown: %s (%s)"):format(tostring(name or (r and r.name)), how)
	if PlaySound and SOUNDKIT and SOUNDKIT.RAID_WARNING then
		pcall(PlaySound, SOUNDKIT.RAID_WARNING)
	end
	-- Gone by itself after a minute (a rare you walked past is not worth a window that stays).
	C_Timer.After(60, function()
		if f:IsShown() and f.shownAt and (GetTime() - f.shownAt) >= 59 then
			f:Hide()
		end
	end)
end

local function Check(unit, how)
	if not ns.IsForeverRareAlertOn() then
		return
	end
	local okE, exists = pcall(UnitExists, unit)
	if not (okE and Plain(exists)) then
		return
	end
	local okD, dead = pcall(UnitIsDead, unit)
	if okD and Plain(dead) then
		return
	end
	local okA, attack = pcall(UnitCanAttack, "player", unit)
	if not (okA and Plain(attack)) then
		return
	end
	local id = NpcId(unit)
	local r = id and raBy[id]
	local okC, cls = pcall(UnitClassification, unit)
	cls = okC and Plain(cls) or nil
	local isRare = cls == "rare" or cls == "rareelite"
	if not (isRare or r) then
		return
	end
	local okN, name = pcall(UnitName, unit)
	name = okN and Plain(name) or nil
	local key = id or name
	if not key then
		return
	end
	local now = GetTime and GetTime() or 0
	if raLastSeen[key] and now - raLastSeen[key] < RA_COOLDOWN then
		raWhy = ("saw %s again (%s): within 10 minutes of the last window, so no new one"):format(tostring(name), how)
		return
	end
	raLastSeen[key] = now
	local okL, level = pcall(UnitLevel, unit)
	level = okL and Plain(level) or nil
	local map = C_Map and C_Map.GetBestMapForUnit and C_Map.GetBestMapForUnit("player")
	local x, y
	if map and C_Map.GetPlayerMapPosition then
		local okP, pos = pcall(C_Map.GetPlayerMapPosition, map, "player")
		if okP and pos then
			local okXY, px, py = pcall(pos.GetXY, pos)
			if okXY and Plain(px) then
				x, y = px * 100, py * 100
			end
		end
	end
	ShowAlert(r, name, type(level) == "number" and level or (r and r.level), cls == "rareelite" or (r and r.elite), map, x, y, how, id)
end

do
	local ev = CreateFrame("Frame")
	for _, e in ipairs({ "NAME_PLATE_UNIT_ADDED", "PLAYER_TARGET_CHANGED", "UPDATE_MOUSEOVER_UNIT",
		"PLAYER_REGEN_DISABLED", "PLAYER_REGEN_ENABLED" }) do
		pcall(ev.RegisterEvent, ev, e)
	end
	ev:SetScript("OnEvent", function(_, event, unit)
		if event == "NAME_PLATE_UNIT_ADDED" then
			Check(unit, "nameplate")
		elseif event == "PLAYER_TARGET_CHANGED" then
			Check("target", "target")
		elseif event == "UPDATE_MOUSEOVER_UNIT" then
			Check("mouseover", "mouseover")
		elseif event == "PLAYER_REGEN_DISABLED" then
			-- Before the lockdown starts: the secure button goes away; the window says "after the fight".
			if raTarget then
				raTarget:Hide()
			end
			if raWin and raWin:IsShown() then
				raWin.combat:SetText(ns:L("FRALERT_COMBAT"))
			end
		elseif event == "PLAYER_REGEN_ENABLED" then
			if raWin and raWin:IsShown() then
				raWin.combat:SetText("")
				PlaceTarget()
			end
		end
	end)
end

--------------------------------------------------------------------------------
-- What YOU looted from a rare (26 Nov 2026). Rob: "En kunnen we ook zien wat die dropt eigenlijk?" No open source has
-- drop data we may ship (docs/forever/DOOD_EN_RARELOOT_2026-11-26.md), so Sparring chose (a) + "laat MH het ZELF leren":
-- on LOOT_OPENED each slot's source GUID (GetLootSourceInfo: GUID, quantity, GUID, quantity …) that is a rare in our
-- list counts the item for that rare, once per corpse. Account-wide in ns.db.foreverRareLoot[npc] =
-- { kills = n, items = { [itemID] = { n = count, name = , icon = } } }. Shown as "Your loot (N kills): …", never as a
-- chance. GetLootSourceInfo is NOT in Forever's generated API documentation (an old global; LootFrame.lua does not use it)
-- → when it is missing: the dead rare you have targeted or under the mouse. /mh rares why says which way it went.
--------------------------------------------------------------------------------
local lootWhy = "nothing looted from a rare yet"
local lootSeenCorpse = {} -- corpse GUID -> true (this session: re-opening a corpse does not count twice)

local function LootDB()
	if type(ns.db) ~= "table" then
		return nil
	end
	ns.db.foreverRareLoot = type(ns.db.foreverRareLoot) == "table" and ns.db.foreverRareLoot or {}
	return ns.db.foreverRareLoot
end

local function GuidNpc(guid)
	if type(guid) ~= "string" or (issecretvalue and issecretvalue(guid)) then
		return nil
	end
	local kind, id = guid:match("^(%a+)%-%d+%-%d+%-%d+%-%d+%-(%d+)")
	if kind ~= "Creature" and kind ~= "Vehicle" then
		return nil
	end
	return tonumber(id)
end

--- The dead rare you are looting when the client cannot say per slot: your target, else the unit under the mouse.
local function DeadRareGuid()
	for _, u in ipairs({ "target", "mouseover" }) do
		local okD, dead = pcall(UnitIsDead, u)
		if okD and Plain(dead) then
			local ok, guid = pcall(UnitGUID, u)
			guid = ok and Plain(guid) or nil
			local npc = GuidNpc(guid)
			if npc and raBy[npc] then
				return guid, npc
			end
		end
	end
	return nil
end

local function OnLootOpened()
	if not (GetNumLootItems and GetLootSlotLink) then
		lootWhy = "loot API missing (GetNumLootItems/GetLootSlotLink)"
		return
	end
	local okN, n = pcall(GetNumLootItems)
	if not (okN and type(n) == "number" and n > 0) then
		return
	end
	local db = LootDB()
	if not db then
		return
	end
	local perSlot = GetLootSourceInfo ~= nil
	local fallbackGuid, fallbackNpc
	if not perSlot then
		fallbackGuid, fallbackNpc = DeadRareGuid()
		if not fallbackGuid then
			lootWhy = "looted something; GetLootSourceInfo missing and no dead rare targeted or under the mouse"
			return
		end
	end
	local counted, newCorpse = 0, {}
	for slot = 1, n do
		local okL, link = pcall(GetLootSlotLink, slot)
		local item = okL and type(link) == "string" and tonumber(link:match("item:(%d+)")) or nil
		if item then
			local okI, icon, name = pcall(GetLootSlotInfo, slot)
			local sources = {}
			if perSlot then
				local res = { pcall(GetLootSourceInfo, slot) }
				if res[1] then
					for i = 2, #res, 2 do
						local npc = GuidNpc(res[i])
						if npc and raBy[npc] then
							sources[#sources + 1] = { guid = res[i], npc = npc }
						end
					end
				end
			else
				sources[1] = { guid = fallbackGuid, npc = fallbackNpc }
			end
			for _, s in ipairs(sources) do
				if not lootSeenCorpse[s.guid] then
					local rec = db[s.npc] or { kills = 0, items = {} }
					db[s.npc] = rec
					if not newCorpse[s.guid] then
						newCorpse[s.guid] = s.npc
						rec.kills = (rec.kills or 0) + 1
					end
					local it = rec.items[item] or { n = 0 }
					it.n = it.n + 1
					it.name = okI and type(name) == "string" and name or it.name
					it.icon = okI and icon or it.icon
					rec.items[item] = it
					counted = counted + 1
				end
			end
		end
	end
	local names = {}
	for guid, npc in pairs(newCorpse) do
		lootSeenCorpse[guid] = true
		names[#names + 1] = (raBy[npc] and raBy[npc].name) or tostring(npc)
	end
	if #names > 0 then
		lootWhy = ("learned %d item(s) from %s (%s)"):format(counted, table.concat(names, ", "),
			perSlot and "GetLootSourceInfo" or "fallback: the dead rare targeted / under the mouse")
	end
end

do
	local ev = CreateFrame("Frame")
	pcall(ev.RegisterEvent, ev, "LOOT_OPENED")
	ev:SetScript("OnEvent", function()
		pcall(OnLootOpened)
	end)
end

--- "Your loot (N kills): [icon] Name ×n, …" for a rare (most looted first, at most `max`), or nil when nothing learned.
function ns.ForeverRareLootLine(npc, max)
	local db = type(ns.db) == "table" and type(ns.db.foreverRareLoot) == "table" and ns.db.foreverRareLoot
	local rec = db and npc and db[npc]
	if not (rec and type(rec.items) == "table" and (rec.kills or 0) > 0) then
		return nil
	end
	local list = {}
	for id, it in pairs(rec.items) do
		list[#list + 1] = { id = id, n = it.n or 0, name = it.name, icon = it.icon }
	end
	if #list == 0 then
		return nil
	end
	table.sort(list, function(a, b)
		if a.n ~= b.n then
			return a.n > b.n
		end
		return a.id < b.id
	end)
	local parts = {}
	for i = 1, math.min(max or 3, #list) do
		local e = list[i]
		local name = e.name
		if not name and C_Item and C_Item.GetItemNameByID then
			local ok, v = pcall(C_Item.GetItemNameByID, e.id)
			name = ok and v or nil
		end
		local icon = e.icon and ("|T" .. tostring(e.icon) .. ":14:14|t ") or ""
		parts[#parts + 1] = icon .. (name or ("item " .. e.id)) .. ((e.n > 1) and (" ×" .. e.n) or "")
	end
	local k = rec.kills or 1
	return (k == 1 and ns:L("FRARE_LOOT_ONE_FMT"):format(table.concat(parts, ", "))
		or ns:L("FRARE_LOOT_FMT"):format(k, table.concat(parts, ", ")))
end

--- /mh rares [why|test|on|off]
function ns.ForeverRareAlertSlash(arg)
	arg = (arg or ""):lower()
	if arg == "on" then
		ns.SetForeverRareAlert(true)
	elseif arg == "off" then
		ns.SetForeverRareAlert(false)
	elseif arg == "test" then
		-- Through the same door as a real rare (ShowAlert), with the first "worth" rare: nothing is targeted by itself.
		local r = ns.FOREVER_RARES_WORTH[1]
		ShowAlert(r, r.name, r.level, r.elite, r.map, r.x, r.y, "test")
		return
	end
	local n = 0
	for _ in pairs(raLastSeen) do
		n = n + 1
	end
	print(PREFIX .. ("rare window: %s; rares in MH's list: %d; seen this session: %d"):format(
		ns.IsForeverRareAlertOn() and "on" or "off (Quiet helpers)", (function() local c = 0 for _ in pairs(raBy) do c = c + 1 end return c end)(), n))
	print("  last decision: " .. raWhy)
	print("  3D model: " .. raModelWhy)
	local db = type(ns.db) == "table" and type(ns.db.foreverRareLoot) == "table" and ns.db.foreverRareLoot or {}
	local nr = 0
	for _ in pairs(db) do
		nr = nr + 1
	end
	print(("  loot: GetLootSourceInfo %s; rares with learned loot: %d; last: %s"):format(
		GetLootSourceInfo and "yes" or "no (fallback: dead rare targeted / under the mouse)", nr, lootWhy))
	local tid = NpcId("target")
	local tl = tid and ns.ForeverRareLootLine(tid, 6)
	if tl then
		print("  your target: " .. tl)
	end
	local okC, cls = pcall(UnitClassification, "target")
	print(("  your target: classification %s, npc id %s, in MH's list %s"):format(tostring(okC and Plain(cls)),
		tostring(NpcId("target")), tostring(NpcId("target") and raBy[NpcId("target")] ~= nil)))
end