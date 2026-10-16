local _, ns = ...

--[[
	Midnight Helper — Travel, part 4 of 5: the route runner (docs/TRAVEL_DESIGN_2026-10-16.md §2.4). Phase 3, 16 Oct 2026.

	Rob: "werkt dit nu voor alles in MH?" — it did not. The Mount run walked its own steps (shown one by one, on at
	every zone change, getting on = next step, door → portal, a Hearthstone/toy/mage button), and every other route
	had four helpers instead that each woke on a zone change and pushed at the arrow in turn (travel map §5a):
	`legRetry` (0.7 s) and the leg watcher (DelveTipMarkup.lua), `runZoneNavCheck` (Delves.lua, 1.0 s), the
	TwoStepRoute door watcher, and the Mount run's own handler. They knew nothing of each other — that is where the
	Honeydew Village trip of 16 Oct came from.

	Now there is one runner and ONE zone-change handler:
	  Travel.Start(target, opts)  plans (or takes the caller's steps), points at the step you need, owns the walk
	  Travel.Stop(reason)         stops everything it started: watchers, button
	Steps come from the travel plan (TravelPlan.lua, Travel.WayHome) plus the flight leg; the Mount run hands in its
	own (MountRun.lua BuildSteps). A step is
	  { map, x, y, to, text, via, viaNear, handoff, board, flight, final, hearth, useID, isToy, mage, spellID, kind }
	  - no x/y (hearth/mage)  = something to use, not a place: the button shows, the arrow does not;
	  - `to`                  = where the step takes you; arriving there means the step is done;
	  - `via`                 = a door before the step's own point (portal room, Astalor's Sanctum);
	  - `handoff`             = a place on the way (a walked door, a Windcaller): reaching it means the next step;
	  - `board`               = getting on (taxi, boat, zeppelin, the Windcaller's bird) means the next step.

	Managed routes (rare, achievement, treasure, reset, delve chests) still run their own lifecycle — that is phase 4.
	They pass through here only because they use AddSmartTomTomWay: they get the same steps, but the runner never
	declares them finished and never changes their owner. Their old after-portal arrow restore runs unchanged
	(LegacyZoneCheck below, moved from Delves.lua).
]]

ns.Travel = ns.Travel or {}
local T = ns.Travel

local route -- the one running route, or nil

local function InMap(a, b)
	return T.InMap(a, b)
end

local function ArrivedVia(pm, to)
	if type(to) == "table" then
		for _, m in ipairs(to) do
			if InMap(pm, m) then
				return true
			end
		end
		return false
	end
	return to ~= nil and InMap(pm, to)
end

--- Owners that are one route seen from two callers: AddSmartTomTomWay sets "waypoint", the delve buttons then say
--- "delve" for the arrow's colour.
local function Family(o)
	if o == "delve" then
		return "waypoint"
	end
	return o
end

local function SameOwner(a, b)
	return Family(a) == Family(b)
end

local function OnBoard()
	if UnitOnTaxi then
		local ok, v = pcall(UnitOnTaxi, "player")
		if ok and v then
			return true
		end
	end
	if UnitInVehicle then
		local ok, v = pcall(UnitInVehicle, "player")
		if ok and v then
			return true
		end
	end
	return false
end

local function IsAction(s)
	return s and ((s.hearth and s.useID) or (s.mage and s.spellID) or not (s.x and s.y)) and true or false
end

local function Say(msg)
	if ns.PrintChat then
		ns:PrintChat(msg)
	else
		print(("|cffffcc00%s|r %s"):format(ns:L("PRINT_PREFIX"), msg))
	end
end

--- What the runner decided and why, newest last (CLAUDE.md: a module whose normal outcome is silence gets a way to
--- see it). Rob, 16 Oct 2026, at the Coiled Isle portal: "hij stuurde me niet naar de ingang" — and nothing could say
--- whether the door was skipped, reached too early, or never tried. `/mh travel` prints the last lines; after a
--- /reload they are in the SavedVariables as `travelRouteLog`, so they can be read without a screenshot.
local function Log(fmt, ...)
	local ok, line = pcall(string.format, fmt, ...)
	line = ok and line or tostring(fmt)
	local stamp = date and date("%H:%M:%S") or "?"
	if ns.db then
		local log = ns.db.travelRouteLog
		if type(log) ~= "table" then
			log = {}
			ns.db.travelRouteLog = log
		end
		log[#log + 1] = stamp .. " " .. line
		while #log > 40 do
			table.remove(log, 1)
		end
	end
end
T.Log = Log

--- 🔎 WHO CHANGED THE ROUTE OWNER? Rob, 16 Oct 2026, a rare route from Thunder Bluff: right after the teleport the
--- runner stopped with "owner" — something set `ns._mhRouteOwner` to another value, and 30 places in the addon can
--- (grep `_mhRouteOwner =`). Reading the code cannot say which one ran. So every change of the owner goes into
--- travelRouteLog with the file:line that made it. `ns` has no metatable of its own (grep: setmetatable(ns — 0, while
--- the same grep finds setmetatable( in 9 other files), so the key lives in a closure and reads/writes pass through here.
--- The runner's own short hand-overs inside Point are not logged (`ownerQuiet`).
local ownerQuiet = false
do
	local KEY = "_mhRouteOwner"
	local owner = rawget(ns, KEY)
	rawset(ns, KEY, nil)
	setmetatable(ns, {
		__index = function(_, k)
			if k == KEY then
				return owner
			end
		end,
		__newindex = function(t, k, v)
			if k ~= KEY then
				rawset(t, k, v)
				return
			end
			if v ~= owner and not ownerQuiet then
				local where = "?"
				if debugstack then
					local st = debugstack(2, 1, 0) or ""
					where = st:match("([%w_]+%.lua:%d+)") or st:gsub("%s+$", "")
				end
				Log("owner %s → %s (%s)", tostring(owner), tostring(v), tostring(where))
			end
			owner = v
		end,
	})
end

local function Fmt(d, how)
	if not d then
		return "unreadable"
	end
	return ("%.1f %s"):format(d, how == "percent" and "%" or "yd")
end

--- Is the player already through the door `via` of the point (x, y) on map `m`? Through = closer to the point than
--- the door itself is, AND closer to the door than the door is to the point (the second half keeps someone standing
--- outside behind the building from counting as inside). nil distances = not through: the door is the safe answer.
--- @return boolean inside, string why
function T.ViaInside(m, x, y, vx, vy)
	local dDoor, h1 = T.Distance(m, vx, vy)
	local dStep, h2 = T.Distance(m, x, y)
	local span, h3 = T.PointDistance(m, vx, vy, x, y)
	local why = ("door %s, step %s, door→step %s"):format(Fmt(dDoor, h1), Fmt(dStep, h2), Fmt(span, h3))
	if not (dDoor and dStep and span) or h1 ~= h2 or h2 ~= h3 then
		return false, why
	end
	return dStep < span and dDoor < span, why
end

--------------------------------------------------------------------------------
-- The button for a step you use rather than walk to (moved from MountRun.lua)
--------------------------------------------------------------------------------

--- Rob, 16 Oct 2026: the chat line was right, "maar ik mis de knop". Same mechanism as the Travel Assistant's
--- Hearthstone button (Delves.lua, MidnightHelperHSClick): a secure action button, so it can only be shown, hidden or
--- changed out of combat — in combat the change waits for PLAYER_REGEN_ENABLED. The item uses "/use item:6948", a
--- toy the secure "toy" type (AFGELEID, untested), a mage teleport the secure "spell" type.
local hearthFrame, pendingHearth, pendingHide
local function HearthFrame()
	if hearthFrame then
		return hearthFrame
	end
	local f = CreateFrame("Frame", "MidnightHelperTravelHearth", UIParent, "BackdropTemplate")
	f:SetSize(300, 66)
	f:SetPoint("TOP", UIParent, "TOP", 0, -170)
	f:SetFrameStrata("DIALOG")
	f:SetClampedToScreen(true)
	f:EnableMouse(true)
	f:SetMovable(true)
	f:RegisterForDrag("LeftButton")
	f:SetScript("OnDragStart", f.StartMoving)
	f:SetScript("OnDragStop", f.StopMovingOrSizing)
	f:Hide()
	if ns.ApplyMidnightDialogBackdrop then
		ns.ApplyMidnightDialogBackdrop(f)
	end
	if ns.RegisterMidnightDialogPopup then
		ns.RegisterMidnightDialogPopup(f)
	end
	local b = CreateFrame("Button", "MidnightHelperTravelHearthBtn", f, "SecureActionButtonTemplate")
	b:SetSize(40, 40)
	b:SetPoint("LEFT", f, "LEFT", 14, 0)
	b.icon = b:CreateTexture(nil, "ARTWORK")
	b.icon:SetAllPoints()
	b.icon:SetTexture(134414) -- Hearthstone icon, replaced by the toy's or spell's own below
	b:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Square", "ADD")
	b:RegisterForClicks("AnyUp", "AnyDown")
	f.btn = b
	f.text = f:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
	f.text:SetPoint("LEFT", b, "RIGHT", 10, 0)
	f.text:SetPoint("RIGHT", f, "RIGHT", -26, 0)
	f.text:SetJustifyH("LEFT")
	f.text:SetWordWrap(true)
	if ns.AttachMidnightDialogCloseButton then
		ns.AttachMidnightDialogCloseButton(f, function()
			if not (InCombatLockdown and InCombatLockdown()) then
				f:Hide()
			end
		end)
	end
	hearthFrame = f
	return f
end

local function HideHearthButton()
	pendingHearth = nil
	if hearthFrame and hearthFrame:IsShown() then
		if InCombatLockdown and InCombatLockdown() then
			pendingHide = true
		else
			hearthFrame:Hide()
		end
	end
end

local function ShowHearthButton(s)
	if InCombatLockdown and InCombatLockdown() then
		pendingHearth, pendingHide = s, nil
		return
	end
	local f = HearthFrame()
	local b = f.btn
	local icon
	if s.mage and s.spellID then
		b:SetAttribute("type", "spell")
		b:SetAttribute("spell", s.spellID)
		b:SetAttribute("toy", nil)
		b:SetAttribute("macrotext", nil)
		icon = C_Spell and C_Spell.GetSpellTexture and C_Spell.GetSpellTexture(s.spellID)
	elseif s.isToy then
		b:SetAttribute("type", "toy")
		b:SetAttribute("toy", s.useID)
		b:SetAttribute("macrotext", nil)
		b:SetAttribute("spell", nil)
	else
		b:SetAttribute("type", "macro")
		b:SetAttribute("macrotext", "/use item:" .. tostring(s.useID))
		b:SetAttribute("toy", nil)
		b:SetAttribute("spell", nil)
	end
	icon = icon or (s.useID and C_Item and C_Item.GetItemIconByID and C_Item.GetItemIconByID(s.useID))
	b.icon:SetTexture(icon or 134414)
	f.text:SetText(s.text)
	f:Show()
end

do
	local ev = CreateFrame("Frame")
	ev:RegisterEvent("PLAYER_REGEN_ENABLED")
	ev:SetScript("OnEvent", function()
		if pendingHide then
			pendingHide = nil
			if hearthFrame then
				hearthFrame:Hide()
			end
		end
		local s = pendingHearth
		pendingHearth = nil
		if s and route and route.steps[route.idx] == s then
			ShowHearthButton(s)
		end
	end)
end

--------------------------------------------------------------------------------
-- Building the steps of an ordinary route
--------------------------------------------------------------------------------

--- The flight leg: the flight master here, when flying clearly beats walking. Moved unchanged from
--- DelveTipMarkup.lua's RouteFirstToFlightPoint (16 aug – 13 Oct 2026). Its rules, each one a bug Rob met:
---   - only to another map, never while already on a taxi;
---   - the flight point nearest YOU and the one nearest the target must differ;
---   - FlightPathExists == false (two separate taxi networks, Harandar 3 Sep) blocks; nil (unknown) does not;
---   - in world yards, walking to our flight point + from the far one to the target must stay under 75% of going
---     straight there (Atal'Aman → Labyrinth, 13 Oct). Only when every position is readable on one continent.
--- @return table|nil step
function T.FlightLeg(targetMap, x, y, currentMap)
	targetMap, currentMap = tonumber(targetMap), tonumber(currentMap)
	if not (targetMap and currentMap and ns.GetNearestFlightPoint) or targetMap == currentMap or OnBoard() then
		return nil
	end
	local px, py = T.PlayerXY(currentMap)
	local fromName, fx, fy = ns.GetNearestFlightPoint(currentMap, px, py)
	local toName = ns.GetNearestFlightPoint(targetMap, x, y)
	if not (fromName and fx and fy and toName) or fromName == toName then
		return nil
	end
	if ns.FlightPathExists and ns.FlightPathExists(fromName, toName) == false then
		return nil
	end
	if px and py then
		local _, tfx, tfy = ns.GetNearestFlightPoint(targetMap, x, y)
		local cP, pX, pY = T.WorldXY(currentMap, px, py)
		local cT, tX, tY = T.WorldXY(targetMap, x, y)
		local cF, fX, fY = T.WorldXY(currentMap, fx, fy)
		local cG, gX, gY
		if tfx and tfy then
			cG, gX, gY = T.WorldXY(targetMap, tfx, tfy)
		end
		if cP and cT and cF and cG and cP == cT and cP == cF and cP == cG then
			local function d(ax, ay, bx, by)
				return math.sqrt((ax - bx) ^ 2 + (ay - by) ^ 2)
			end
			if d(pX, pY, fX, fY) + d(gX, gY, tX, tY) >= d(pX, pY, tX, tY) * 0.75 then
				return nil
			end
		end
	end
	return { map = currentMap, x = fx, y = fy, flight = toName, board = true, kind = "fly",
		text = (ns:L("WAY_LEG_TO_FLIGHT")):format(fromName) }
end

--- The steps from here to `t` for an ordinary route: the travel plan's steps that are a place or something to use,
--- then the target. A plan step that is only words (a capital's name, "fly to X" without a place) stays in
--- `/mh plan` and is not a step — the arrow cannot point at words. No plan step at all: the flight leg, as before.
local function BuildPlainSteps(t)
	local steps = {}
	local pm = T.PlayerMap()
	local okP, plan = false, nil
	if ns.BuildTravelPlan and pm then
		okP, plan = pcall(ns.BuildTravelPlan, t.map, t.x, t.y, t.name)
	end
	if okP and type(plan) == "table" then
		for _, s in ipairs(plan) do
			if s.kind == "arrive" then
				break
			end
			local text = ns.TravelStepName and ns.TravelStepName(s, t.name) or s.label or t.name
			if s.kind == "hearth" or s.kind == "mage" then
				steps[#steps + 1] = { map = pm, to = s.to, text = text, kind = s.kind, hearth = s.kind == "hearth",
					mage = s.kind == "mage", useID = s.useID, isToy = s.isToy, spellID = s.spellID }
			elseif s.mapID and s.x and s.y then
				steps[#steps + 1] = {
					map = s.mapID, x = s.x, y = s.y, to = s.to, text = text, kind = s.kind,
					-- A portal inside a building (Coiled Isle, Rob 16 Oct 2026): its door first, then the orb down.
					via = type(s.door) == "table" and s.door.x and s.door.y and { s.door.x, s.door.y } or nil,
					orb = type(s.orb) == "table" and s.orb.x and s.orb.y and { s.orb.x, s.orb.y } or nil,
					viaNear = "door",
					-- A walked door or a Windcaller is passed on the way, not gone through (Rob, 14 Oct 2026).
					handoff = (s.kind == "walk" or s.kind == "gossip") or nil,
					board = s.kind == "gossip" or nil,
				}
			end
		end
	end
	if #steps == 0 then
		local leg = T.FlightLeg(t.map, t.x, t.y, pm)
		if leg then
			steps[1] = leg
		end
	end
	steps[#steps + 1] = { map = t.map, x = t.x, y = t.y, text = t.name, final = true }
	return steps
end

--------------------------------------------------------------------------------
-- Pointing
--------------------------------------------------------------------------------

local watcher -- the 0.5 s ticker for a step's door (`via`) or hand-off

local function StopWatch()
	if watcher then
		watcher:Cancel()
		watcher = nil
	end
end

--- Point the arrow at (x, y) of step `s`, through the same door as every route (AddSmartTomTomWay, skipTravelUI,
--- leg-busy so it neither warns about the level again nor plans again).
local function Point(s, x, y, text)
	local r = route
	if r.clearPins and ns.MH_TomTomClearAll then
		ns.MH_TomTomClearAll()
	elseif r.uid and r.uid ~= r.firstUid and _G.TomTom and _G.TomTom.RemoveWaypoint then
		-- The previous step's pin, so steps do not pile up on the map. The route's own first pin (the target, set by
		-- the caller) stays.
		pcall(_G.TomTom.RemoveWaypoint, _G.TomTom, r.uid)
	end
	local owner = ns._mhRouteOwner
	-- A point on the way (a door, the orb, a step that is not the target) gets cleardistance 0: TomTom must not drop it
	-- by itself. Rob, 16 Oct 2026, walking into Astalor's Sanctum: "even onze eigen pijl … tot ik verder de kamer in loop
	-- dan komt de tomtom pijl weer". GEMETEN in travelRouteLog: door and orb handed over at 7.5 yd; TomTom had already
	-- removed them at 15 yd (our default), and between 15 and 8 yd NativeArrow stepped in. The runner removes the
	-- previous pin itself (above).
	local clearDist = (s.final and x == s.x and y == s.y) and nil or 0
	ns._mhTravelLegBusy = true
	ownerQuiet = true
	pcall(ns.AddSmartTomTomWay, s.map, x, y, text, true, false, false, clearDist)
	ns._mhTravelLegBusy = nil
	-- AddSmartTomTomWay turns waypoint/delve/mountrun into "waypoint": give the route its own owner back ("delve"
	-- stays "delve", for the arrow's colour). A managed owner was never touched.
	if r.managed or (owner ~= nil and SameOwner(owner, r.owner)) then
		ns._mhRouteOwner = owner
	else
		ns._mhRouteOwner = r.owner
	end
	ownerQuiet = false
	r.uid = ns._mhCrazyArrowUid
	local lt = ns.lastTarget
	if lt then
		lt.leg = (not s.final) or nil
		lt.noTravelAdvice = r.noTravelAdvice
		lt.via = r.via or "Travel route"
		if s.final then
			lt.arrivesOn = r.target.arrivesOn
		end
	end
	r.lt = lt
	if s.kind == "portal" then
		-- The travel popup reads this so it does not offer to "focus the portal" the arrow already points at.
		ns._mhArrowLedTo = { mapID = s.map, x = s.x, y = s.y, at = GetTime and GetTime() or 0 }
	end
end

--- Has the player reached (mx, my) on `s.map`, by threshold `kind`? Remembers the closest distance on `st` for the
--- walked-away rule (a door coordinate that is a little off, Underbelly 14 Oct 2026). Never for a Mount run `via`.
--- @return boolean reached, string why
local function Reached(st, kind, mx, my, map, nx, ny)
	local d, how = T.Distance(map, mx, my)
	if not d then
		return false
	end
	local lim = T.NEAR[kind] or T.NEAR.door
	if how == "percent" then
		return d < lim.percent, ("within %.2f%%"):format(d)
	end
	if d < lim.yards then
		return true, ("within %.1f yd"):format(d)
	end
	st._min = math.min(st._min or d, d)
	if kind == "door" then
		-- Through the door: was near it, and now closer to the point behind it than the door is (Rob, 16 Oct 2026).
		if st._min < lim.passedNear and nx and ny then
			local inside, why = T.ViaInside(map, nx, ny, mx, my)
			if inside then
				return true, "through the door: " .. why
			end
		end
		return false
	end
	if kind ~= "via" then
		local w = T.NEAR.walkedAway
		if st._min < w.near and d > st._min + w.back then
			return true, ("walked away: nearest %.0f yd, now %.0f yd"):format(st._min, d)
		end
	end
	return false
end

local ShowStep

--- The points a step passes on its own map before its point: its door (`via`) and then, for the Coiled Isle portal,
--- the orb you click to go down to it (`orb`; Rob, 16 Oct 2026: "er staat ook een orb om naar beneden richting de
--- portal te gaan", measured with `/mh here` at 55.80/65.02). Each is { x, y, kind, orb }.
local function Vias(s)
	if s._vias == nil then
		local v = {}
		if s.via then
			v[#v + 1] = { s.via[1], s.via[2], kind = s.viaNear or "door" }
		end
		if s.orb then
			v[#v + 1] = { s.orb[1], s.orb[2], kind = "door", orb = true }
		end
		s._vias = v
	end
	return s._vias
end

--- The point after via k: the next via, or the step itself.
local function NextPoint(s, k)
	local v = Vias(s)[k + 1]
	if v then
		return v[1], v[2]
	end
	return s.x, s.y
end

--- The first via the player still has to pass: checked from the last one back, so someone already downstairs at the
--- portal gets neither the door nor the orb, and someone in the hall gets only the orb.
local function FirstPendingVia(s)
	local v = Vias(s)
	for k = #v, 1, -1 do
		local nx, ny = NextPoint(s, k)
		local inside, why = T.ViaInside(s.map, nx, ny, v[k][1], v[k][2])
		if inside then
			return k + 1, ("through point %d (%s)"):format(k, why)
		end
	end
	return 1, #v > 0 and "outside" or "no door"
end

local function ViaText(s, k, text)
	local v = Vias(s)[k]
	if v and v.orb then
		return (ns:L("TRAVEL_VIA_ORB_FMT")):format(text)
	end
	return text
end

--- Point at the via the player still has to pass, or at the step itself.
local function PointPending(s, text)
	local k = s._viaIdx or 1
	local v = Vias(s)[k]
	if v then
		Point(s, v[1], v[2], ViaText(s, k, text))
	else
		Point(s, s.x, s.y, text)
	end
end

local function StartWatch(s)
	StopWatch()
	if not (s._viaPending or s.handoff) or not (C_Timer and C_Timer.NewTicker) then
		return
	end
	watcher = C_Timer.NewTicker(0.5, function()
		local r = route
		if not r or r.steps[r.idx] ~= s or not SameOwner(ns._mhRouteOwner, r.owner) then
			StopWatch()
			return
		end
		if s._viaPending then
			local k = s._viaIdx
			local v = Vias(s)[k]
			local nx, ny = NextPoint(s, k)
			local ok, why = Reached(s, v.kind, v[1], v[2], s.map, nx, ny)
			if ok then
				Log("step %d: point %d%s passed — %s", r.idx, k, v.orb and " (orb)" or " (door)", tostring(why))
				s._min = nil
				s._viaIdx = k + 1
				s._viaPending = s._viaIdx <= #Vias(s)
				local text = s._shownText or s.text
				PointPending(s, text)
				if s._viaPending and Vias(s)[s._viaIdx].orb then
					Say(ViaText(s, s._viaIdx, text))
				elseif not s._viaPending and s.viaDoneKey then
					Say((ns:L(s.viaDoneKey)):format(s.text or "?"))
				end
				if not s._viaPending and not s.handoff then
					StopWatch()
				end
			end
			return
		end
		if s.handoff and r.steps[r.idx + 1] then
			local ok, why = Reached(s, "step", s.x, s.y, s.map)
			if ok then
				Log("step %d reached (%s)", r.idx, tostring(why))
				StopWatch()
				ShowStep(r.idx + 1)
			end
		end
	end)
end

--- Show step i: button or arrow, its door first when it has one, and one chat line when the route has more than
--- one step. `quiet` re-points without a chat line (after a loading screen, or the same route asked again).
ShowStep = function(i, quiet, alreadyPointed)
	local r = route
	local s = r.steps[i]
	if not s then
		return
	end
	r.idx = i
	r.lastMap = T.PlayerMap()
	s._min, s._viaPending, s._viaIdx = nil, nil, nil
	StopWatch()
	local text = s.text
	if IsAction(s) then
		Log("step %d/%d %s: %s (button, no arrow)", i, #r.steps, tostring(s.kind or "use"), tostring(s.text))
		if (s.hearth and s.useID) or (s.mage and s.spellID) then
			ShowHearthButton(s)
		else
			HideHearthButton()
		end
		-- Nothing to point at: no arrow. The route keeps the arrow (its owner), so nothing else steps in, and the next
		-- zone change moves it on.
		if ns.MH_TomTomClearAll then
			ns.MH_TomTomClearAll()
		end
		ns.lastTarget = nil
		r.lt, r.uid = nil, nil
		if not r.managed then
			ns._mhRouteOwner = r.owner
		end
	else
		HideHearthButton()
		-- A capital step seen from elsewhere says which city it is in (Rob, in Uldum: "Take the portal to The Jade
		-- Forest", 12 km away, without saying it stands in Orgrimmar).
		local pm = r.lastMap
		if (s.map == 84 or s.map == 85) and pm and not InMap(pm, s.map) then
			text = (ns:L("MOUNTRUN_STEP_IN_CITY")):format(T.MapName(s.map) or "?", s.text)
		end
		s._shownText = text
		-- Already through the door (or the orb): skip it, or the arrow points behind you (Rob, 7 Sep 2026).
		local why
		s._viaIdx, why = FirstPendingVia(s)
		s._viaPending = s._viaIdx <= #Vias(s)
		Log("step %d/%d %s: %s%s", i, #r.steps, tostring(s.kind or (s.final and "target" or "step")), tostring(s.text),
			#Vias(s) > 0 and (" — door/orb: start at point %d, %s"):format(s._viaIdx, why) or "")
		if not alreadyPointed then
			PointPending(s, text)
			if not quiet and s._viaPending and Vias(s)[s._viaIdx].orb then
				Say(ViaText(s, s._viaIdx, text))
			end
		end
		-- alreadyPointed: the caller points at what is pending itself (a Silvermoon pin asks T.PendingVia).
		StartWatch(s)
	end
	local base = r.base or 0
	if not quiet and base + #r.steps > 1 then
		Say((ns:L(r.stepFmt or "TRAVEL_STEP_FMT")):format(base + i, base + #r.steps, text))
	end
end

--------------------------------------------------------------------------------
-- Where on the route are we?
--------------------------------------------------------------------------------

--- The step the player is at now: the furthest step whose map they stand on, or whose previous step they have just
--- come through (the Mount run's rule, 16 Oct 2026). Two steps on one map (a Windcaller, then a door, both in the
--- Vaults) are told apart by distance, not by the map: the map alone never moves the route forward to the second.
--- Mount run only: already on the right continent but outside the capital skips the capital portal (step 2).
--- @return number|nil
local function CurrentStep(r)
	local steps, start = r.steps, r.start or 1
	local pm = T.PlayerMap()
	if not pm then
		return nil
	end
	local inStart = steps[start] and InMap(pm, steps[start].map)
	for k = #steps, 2, -1 do
		local s, prev = steps[k], steps[k - 1]
		if ArrivedVia(pm, prev.to) then
			return k
		end
		if InMap(pm, s.map) and (not (prev.map and InMap(pm, prev.map)) or k <= (r.idx or 0)) then
			return k
		end
		if r.fixed and k == start + 1 and not inStart then
			local pc = T.Continent(pm)
			if pc and pc == T.Continent(s.map) then
				return k
			end
		end
	end
	if steps[1] and InMap(pm, steps[1].map) then
		return 1
	end
	return nil
end

--------------------------------------------------------------------------------
-- Start / stop
--------------------------------------------------------------------------------

local function SameTarget(a, b)
	return a and b and tonumber(a.map) == tonumber(b.map)
		and math.abs((tonumber(a.x) or 0) - (tonumber(b.x) or 0)) < 0.01
		and math.abs((tonumber(a.y) or 0) - (tonumber(b.y) or 0)) < 0.01
end

--- Is this `ns.lastTarget` still the route's own (the table it set, or the target / the current step / its door
--- written by the caller, as a Silvermoon pin does after starting its route)?
local function IsOurs(r, lt)
	if lt == r.lt then
		return true
	end
	local p = { map = lt.mapID, x = lt.x, y = lt.y }
	local s = r.steps[r.idx]
	if SameTarget(p, r.target) or (s and s.x and SameTarget(p, s)) then
		return true
	end
	for _, v in ipairs(s and Vias(s) or {}) do
		if SameTarget(p, { map = s.map, x = v[1], y = v[2] }) then
			return true
		end
	end
	return false
end

--- Stop the route: watcher, button. Pins and the owner are the caller's (`/mh clear` clears those itself).
function T.Stop(reason)
	StopWatch()
	HideHearthButton()
	local had = route ~= nil
	if route then
		-- A pin on the way never clears itself (cleardistance 0, see Point): take it with us.
		local cur = route.steps[route.idx]
		if route.uid and route.uid ~= route.firstUid and not (cur and cur.final and not cur._viaPending)
			and _G.TomTom and _G.TomTom.RemoveWaypoint then
			pcall(_G.TomTom.RemoveWaypoint, _G.TomTom, route.uid)
		end
		T.lastStop = { reason = reason or "?", at = GetTime and GetTime() or 0, target = route.target.name }
		Log("stop (%s): %s", tostring(reason), tostring(route.target.name))
	end
	route = nil
	return had
end

--- Start a route to `target` = { map, x, y, name, arrivesOn }.
--- opts: owner, managed (rare & co: never finish them, never touch their owner), steps + start (the caller's own,
--- e.g. the Mount run: no re-planning), stepFmt (locale key for the chat line), stopInInstance, noTravelAdvice,
--- clearPins (clear all TomTom pins per step), via (who set it, for /mh arrow), alreadyPointed (the caller has
--- pointed at what step 1 points at first).
function T.Start(target, opts)
	opts = opts or {}
	if not (target and target.map and target.x and target.y) then
		return nil
	end
	-- The same route asked again (a managed route's ticker, a refresh): keep the step, point it again quietly.
	if route and not opts.steps and SameTarget(route.target, target) and SameOwner(route.owner, opts.owner or ns._mhRouteOwner) then
		if not opts.alreadyPointed then
			ShowStep(route.idx, true)
		elseif not route.steps[route.idx].final then
			ShowStep(route.idx, true)
		end
		return route
	end
	T.Stop("replaced")
	local fixed = opts.steps ~= nil
	route = {
		target = target,
		owner = opts.owner or ns._mhRouteOwner,
		managed = opts.managed,
		fixed = fixed,
		steps = opts.steps or BuildPlainSteps(target),
		start = opts.start or 1,
		idx = 0,
		stepFmt = opts.stepFmt,
		stopInInstance = opts.stopInInstance,
		noTravelAdvice = opts.noTravelAdvice,
		clearPins = opts.clearPins,
		via = opts.via,
	}
	route.firstUid = opts.alreadyPointed and ns._mhCrazyArrowUid or nil
	route.lt = opts.alreadyPointed and ns.lastTarget or nil
	route.finishCheck = (not fixed) or opts.finish
	Log("start → %s (map %s %.2f/%.2f, owner %s%s, %d step(s), player on map %s)", tostring(target.name),
		tostring(target.map), target.x, target.y, tostring(route.owner), route.managed and ", managed" or "",
		#route.steps, tostring(T.PlayerMap()))
	local k = (fixed and CurrentStep(route)) or 1
	local s = route.steps[k]
	-- The caller already pointed at what this step points at first (AddSmartTomTomWay at the target; a Silvermoon pin
	-- at its door): nothing to point again.
	ShowStep(k, false, opts.alreadyPointed and s.final)
	return route
end

--- Where the step list starts, for a caller that builds its own (the Mount run asks "is the player anywhere on these
--- steps?" before it puts the way home in front).
function T.StepFor(steps, start)
	return CurrentStep({ steps = steps, start = start, idx = 0, fixed = true }) or 1
end

function T.Active()
	return route
end

--- true while the arrow points at a step on the way (not the target itself). NativeArrow does not let the route go
--- when you reach such a step: reaching a portal is not arriving.
function T.OnLeg()
	return route ~= nil and route.steps[route.idx] ~= nil and not route.steps[route.idx].final
end

--- true while the current step is something to use (Hearthstone, toy, mage spell): there is no place to point at.
function T.CurrentIsAction()
	return route ~= nil and IsAction(route.steps[route.idx])
end

--- The flight-map stop to click, and the target's name (FlightMapHint.lua), or nil.
function T.PendingFlightStop()
	local s = route and route.steps[route.idx]
	if s and s.flight then
		return s.flight, route.target.name
	end
	return nil
end

--- The door or orb the current step waits for: x, y, label, isOrb — or nil (a Silvermoon pin points there itself).
function T.PendingVia()
	local s = route and route.steps[route.idx]
	if not (s and s._viaPending) then
		return nil
	end
	local v = Vias(s)[s._viaIdx]
	return v[1], v[2], ViaText(s, s._viaIdx, s.text or "?"), v.orb and true or false
end

--- The door the current step waits for, for `/mh arrow` (was TwoStepRoute's own status).
function T.ViaStatus()
	local s = route and route.steps[route.idx]
	if not (s and s._viaPending) then
		return nil
	end
	local v = Vias(s)[s._viaIdx]
	local d, how = T.Distance(s.map, v[1], v[2])
	local lim = T.NEAR[v.kind] or T.NEAR.door
	return { mapID = s.map, doorX = v[1], doorY = v[2], destLabel = s.text, destX = s.x, destY = s.y,
		yards = d, how = how, limit = how == "percent" and lim.percent or lim.yards, elapsed = 0, giveUp = 0 }
end

--------------------------------------------------------------------------------
-- The one zone-change handler
--------------------------------------------------------------------------------

--- The old after-portal check for everything the runner does not walk (moved unchanged from Delves.lua
--- runZoneNavCheck, 5-7 Sep 2026): a route set past AddSmartTomTomWay (a Silvermoon pin, /mh goto) or a managed
--- route between its steps. Rares and treasures nil `ns.lastTarget`, so their lead is asked of their module.
--- Arrived (through the portal, or ≤ 400 yd / in the delve) → say so in chat; otherwise put TomTom's arrow back,
--- which a loading screen loses for routes that keep no `lastTarget`.
local function LegacyZoneCheck()
	local function RouteLead()
		if ns.lastTarget and ns.lastTarget.mapID then
			return ns.lastTarget
		end
		local getter = (ns._mhRouteOwner == "rare" and ns.GetNearestIncompleteRareLead)
			or (ns._mhRouteOwner == "treasure" and ns.GetNearestIncompleteTreasureLead)
			or nil
		if getter then
			local ok, lead = pcall(getter)
			if ok and type(lead) == "table" and lead.mapID then
				return lead
			end
		end
		return nil
	end
	local currentMap = T.PlayerMap()
	local lt = RouteLead()
	if not (lt and currentMap) then
		return
	end
	local throughPortal = lt.arrivesOn and tonumber(lt.arrivesOn) == tonumber(currentMap)
	if throughPortal or (ns.IsMidnightTravelComplete and ns.IsMidnightTravelComplete(currentMap, lt.mapID, lt.x, lt.y, lt.name)) then
		-- Say that the route ended, even when the verdict is wrong (5 Sep 2026: a silent end cost an hour).
		if ns.SafeHideTravelPopup then
			ns.SafeHideTravelPopup()
		end
		print(("|cffffcc00%s|r %s"):format(ns:L("PRINT_PREFIX"), (ns:L("ROUTE_FINISHED_FMT")):format(tostring(lt.name or "?"))))
		ns.lastTarget = nil
		-- Only the two single-destination owners; the others run their own lifecycle (7 Sep 2026).
		if ns._mhRouteOwner == "waypoint" or ns._mhRouteOwner == "delve" then
			ns._mhRouteOwner = nil
		end
		return
	end
	local function restore()
		local t = RouteLead()
		if not t then
			return
		end
		if ns.IsTomTomReady and ns.IsTomTomReady() then
			local uid = _G.TomTom:AddWaypoint(t.mapID, t.x / 100, t.y / 100, {
				title = t.name, persistent = false, minimap = true, world = true, cleardistance = 15, crazy = true,
			})
			if uid and _G.TomTom.SetCrazyArrow then
				_G.TomTom:SetCrazyArrow(uid, 15, t.name)
			end
		elseif ns.SetBlizzardUserWaypoint then
			ns.SetBlizzardUserWaypoint(t.mapID, t.x, t.y)
		end
	end
	restore()
	if C_Timer and C_Timer.After then
		C_Timer.After(0.5, restore)
	end
end

--- The route is over: arrived through its portal, or close enough / inside the delve. Ours to end only for an
--- ordinary route; a managed one is ended by its module.
local function Finished(pm)
	local t = route.target
	if t.arrivesOn and InMap(pm, t.arrivesOn) then
		return true
	end
	return ns.IsMidnightTravelComplete and ns.IsMidnightTravelComplete(pm, t.map, t.x, t.y, t.name) and true or false
end

local function Finish()
	local name = route.target.name
	T.Stop("finished")
	if ns.SafeHideTravelPopup then
		ns.SafeHideTravelPopup()
	end
	print(("|cffffcc00%s|r %s"):format(ns:L("PRINT_PREFIX"), (ns:L("ROUTE_FINISHED_FMT")):format(tostring(name or "?"))))
	ns.lastTarget = nil
	if ns._mhRouteOwner == "waypoint" or ns._mhRouteOwner == "delve" then
		ns._mhRouteOwner = nil
	end
end

--- Plan again from here (a new map, or off the route). Same first step as now → point it again without a chat line:
--- that re-arms TomTom's arrow, which hides itself when it cannot measure (GEMETEN in TomTom_CrazyArrow.lua OnUpdate)
--- and stays hidden until the next SetCrazyArrow or zone event. Rob, 16 Oct 2026, after a mage teleport to Silvermoon:
--- the pin was set while he was still on the arrival map 2537, TomTom hid its arrow, and ours took over.
--- The step count goes on (`base`), so the chat says "step 2 of 2", not a fresh "1 of 1".
local function Replan()
	local r = route
	Log("plan again from map %s", tostring(T.PlayerMap()))
	local steps = BuildPlainSteps(r.target)
	local old = r.steps[r.idx]
	local new = steps[1]
	local same = old and new and old.map == new.map and old.x == new.x and old.y == new.y
		and IsAction(old) == IsAction(new)
	if not same then
		r.base = (r.base or 0) + (r.idx or 0)
	end
	r.steps = steps
	ShowStep(1, same)
end

local function OnZone(event, big, retry)
	local r = route
	if r and not SameOwner(ns._mhRouteOwner, r.owner) then
		-- Another route took the arrow: ours ends without a word (the Mount run's rule).
		T.Stop(("owner is now %s, route had %s"):format(tostring(ns._mhRouteOwner), tostring(r.owner)))
		r = nil
	end
	-- A route set past this runner (a Silvermoon pin, /mh goto, the flight-point button) wrote its own target.
	if r and not r.managed and ns.lastTarget and not IsOurs(r, ns.lastTarget) then
		T.Stop("replaced by " .. tostring(ns.lastTarget.via))
		r = nil
	end
	if not r or (r.managed and r.steps[r.idx] and r.steps[r.idx].final) then
		if big then
			LegacyZoneCheck()
		end
		return
	end
	local pm = T.PlayerMap()
	if not pm then
		-- After a loading screen the map can still be nil for a moment.
		if not retry and C_Timer and C_Timer.After then
			C_Timer.After(1, function()
				OnZone(event, big, true)
			end)
		end
		return
	end
	-- Only after a real zone change, as before: a subzone step inside a city would otherwise read "within 400 yd" and
	-- end a Silvermoon route on its first street corner.
	if big and not r.managed and r.finishCheck and Finished(pm) then
		Finish()
		return
	end
	if IsInInstance and select(1, IsInInstance()) then
		if r.stopInInstance then
			-- The Mount run is done at the raid's door.
			T.Stop("instance")
			ns._mhRouteOwner = nil
			if ns.MH_TomTomClearAll then
				ns.MH_TomTomClearAll()
			end
		end
		-- Others wait: indoors there is nothing to plan with; walking out asks again (19 Aug 2026).
		return
	end
	local riding = OnBoard()
	local k = CurrentStep(r)
	if pm ~= r.lastMap or k ~= r.idx then
		Log("zone change (%s): map %s, at step %d, reads step %s%s", tostring(event), tostring(pm), r.idx, tostring(k),
			riding and ", riding" or "")
	end
	-- Never back while riding: a flight crosses subzones of the map you boarded on (16 Oct 2026, Elsia's flight).
	-- An ordinary route after a real zone change onto another map: plan again from here, always. The plan from where you
	-- stand is the truth (a teleport can land on an in-between map first, 2537 before 2393), and pointing again wakes
	-- TomTom's arrow (Replan above).
	if big and not r.fixed and not riding and pm ~= r.lastMap then
		Replan()
		return
	end
	if k and k ~= r.idx and not (riding and k < r.idx) then
		-- An ordinary route that has come through to its last stretch plans that stretch again from here: in Silvermoon,
		-- after the way from the old world, the flight leg or a door may be the better first step (the old legRetry).
		if not r.fixed and not riding and r.steps[k].final then
			Replan()
		else
			ShowStep(k)
		end
		return
	end
	if not k and not r.fixed and not riding and pm ~= r.lastMap then
		Replan()
		return
	end
	if event == "PLAYER_ENTERING_WORLD" and k == r.idx then
		ShowStep(r.idx, true)
	end
	r.lastMap = pm
end

do
	local ev = CreateFrame("Frame")
	ev:RegisterEvent("ZONE_CHANGED_NEW_AREA")
	ev:RegisterEvent("ZONE_CHANGED")
	ev:RegisterEvent("ZONE_CHANGED_INDOORS")
	ev:RegisterEvent("PLAYER_ENTERING_WORLD")
	local queued, queuedEvent, queuedBig = false, nil, false
	ev:SetScript("OnEvent", function(_, event)
		local big = event == "ZONE_CHANGED_NEW_AREA" or event == "PLAYER_ENTERING_WORLD"
		-- The old legacy check only ran on a real zone change; a subzone step (ZONE_CHANGED) only matters to a route.
		if not big and not route then
			return
		end
		queuedBig = queuedBig or big
		if event == "PLAYER_ENTERING_WORLD" or not queuedEvent then
			queuedEvent = event
		end
		if queued then
			return
		end
		queued = true
		-- One delay for everything, so there is no order between handlers left to get wrong (travel map §8).
		C_Timer.After(0.7, function()
			local e, b = queuedEvent, queuedBig
			queued, queuedEvent, queuedBig = false, nil, false
			local before = T.PlayerMap()
			OnZone(e, b)
			-- 🔴 A loading screen can land on an in-between map first (a mage teleport to Silvermoon: 2537, then 2393 —
			-- GEMETEN in Rob's travelRouteLog, 16 Oct 2026). A pin set there leaves TomTom's arrow hidden (it cannot
			-- measure, GEMETEN in TomTom_CrazyArrow.lua), and when the map then settles no zone event may follow to wake
			-- it — Rob's rare route showed our arrow while HereBeDragons measured the distance fine (his /run: 2393,
			-- 3796 yd). So look once more a moment later; a different map means: the same handler again.
			if b and C_Timer and C_Timer.After then
				C_Timer.After(2.5, function()
					local now = T.PlayerMap()
					if now and now ~= before then
						Log("map settled: %s → %s, look again", tostring(before), tostring(now))
						OnZone("MAP_SETTLED", true)
					end
				end)
			end
		end)
	end)
end

--- Getting on ends a ride step (Rob, 16 Oct 2026, flying with Scout Captain Elsia: the arrow still pointed back at
--- her). Also the flight leg ("boarding ends leg one", 16 Aug) and the Windcaller's bird.
do
	local ev = CreateFrame("Frame")
	ev:RegisterEvent("PLAYER_CONTROL_LOST")
	ev:RegisterUnitEvent("UNIT_ENTERED_VEHICLE", "player")
	ev:SetScript("OnEvent", function()
		C_Timer.After(1, function()
			local r = route
			if not (r and r.idx and SameOwner(ns._mhRouteOwner, r.owner)) then
				return
			end
			local s = r.steps[r.idx]
			if s and s.board and r.steps[r.idx + 1] and OnBoard() then
				ShowStep(r.idx + 1)
			end
		end)
	end)
end

--- `/mh travel`, second half: the running route, then the runner's last decisions.
function T.PrintRoute()
	local log = ns.db and ns.db.travelRouteLog
	if type(log) == "table" and #log > 0 then
		print("   route runner log (newest last; after /reload in SavedVariables as travelRouteLog):")
		for i = math.max(1, #log - 9), #log do
			print("     |cff8a8f98" .. tostring(log[i]) .. "|r")
		end
	end
	local r = route
	if not r then
		local ls = T.lastStop
		print(("   route runner: |cff999999no route|r%s"):format(ls and (" (last: %s, stopped: %s)"):format(
			tostring(ls.target), tostring(ls.reason)) or ""))
		return
	end
	print(("   route runner: |cff80ff80%s|r → %s (owner %s%s), step %d of %d"):format(r.fixed and "fixed steps" or "planned",
		tostring(r.target.name), tostring(r.owner), r.managed and ", managed" or "", r.idx, #r.steps))
	for i, s in ipairs(r.steps) do
		local where = (s.x and s.y) and ("map %s %.2f/%.2f"):format(tostring(s.map), s.x, s.y) or "use"
		local d, how
		if i == r.idx and s.x and s.y then
			d, how = T.Distance(s.map, s.x, s.y)
		end
		print(("     %s%d. %s  |cff8a8f98[%s%s%s%s%s]|r%s"):format(i == r.idx and "|cffffd200>|r " or "  ", i,
			tostring(s.text), where, s.via and " via door" or "", s.orb and " + orb" or "", s.handoff and " handoff" or "", s.board and " board" or "",
			d and (" — %.0f %s"):format(d, how) or ""))
	end
end
