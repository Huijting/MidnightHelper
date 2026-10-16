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
					-- A portal inside a building (Coiled Isle, Rob 16 Oct 2026): its door first.
					via = type(s.door) == "table" and s.door.x and s.door.y and { s.door.x, s.door.y } or nil,
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
	ns._mhTravelLegBusy = true
	pcall(ns.AddSmartTomTomWay, s.map, x, y, text, true, false, false, s.flight and 0 or nil)
	ns._mhTravelLegBusy = nil
	-- AddSmartTomTomWay turns waypoint/delve/mountrun into "waypoint": give the route its own owner back ("delve"
	-- stays "delve", for the arrow's colour). A managed owner was never touched.
	if r.managed or (owner ~= nil and SameOwner(owner, r.owner)) then
		ns._mhRouteOwner = owner
	else
		ns._mhRouteOwner = r.owner
	end
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
local function Reached(st, kind, mx, my, map)
	local d, how = T.Distance(map, mx, my)
	if not d then
		return false
	end
	local lim = T.NEAR[kind] or T.NEAR.door
	if how == "percent" then
		return d < lim.percent
	end
	if d < lim.yards then
		return true
	end
	if kind ~= "via" then
		st._min = math.min(st._min or d, d)
		local w = T.NEAR.walkedAway
		return st._min < w.near and d > st._min + w.back
	end
	return false
end

local ShowStep

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
			if Reached(s, s.viaNear or "door", s.via[1], s.via[2], s.map) then
				s._viaPending, s._min = nil, nil
				Point(s, s.x, s.y, s._shownText or s.text)
				if s.viaDoneKey then
					Say((ns:L(s.viaDoneKey)):format(s.text or "?"))
				end
				if not s.handoff then
					StopWatch()
				end
			end
			return
		end
		if s.handoff and r.steps[r.idx + 1] and Reached(s, "step", s.x, s.y, s.map) then
			StopWatch()
			ShowStep(r.idx + 1)
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
	s._min, s._viaPending = nil, nil
	StopWatch()
	local text = s.text
	if IsAction(s) then
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
		if s.via then
			-- Already inside (closer to the step than its door is): no door, or the arrow points behind you.
			local dDoor = T.Distance(s.map, s.via[1], s.via[2])
			local dStep = T.Distance(s.map, s.x, s.y)
			s._viaPending = not (dDoor and dStep and dStep <= dDoor)
		end
		if not alreadyPointed then
			if s._viaPending then
				Point(s, s.via[1], s.via[2], text)
			else
				Point(s, s.x, s.y, text)
			end
		end
		StartWatch(s)
	end
	if not quiet and #r.steps > 1 then
		Say((ns:L(r.stepFmt or "TRAVEL_STEP_FMT")):format(i, #r.steps, text))
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
	return SameTarget(p, r.target) or (s and s.x and SameTarget(p, s))
		or (s and s.via and SameTarget(p, { map = s.map, x = s.via[1], y = s.via[2] })) or false
end

--- Stop the route: watcher, button. Pins and the owner are the caller's (`/mh clear` clears those itself).
function T.Stop(reason)
	StopWatch()
	HideHearthButton()
	local had = route ~= nil
	if route then
		T.lastStop = { reason = reason or "?", at = GetTime and GetTime() or 0, target = route.target.name }
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

--- The door the current step waits for, for `/mh arrow` (was TwoStepRoute's own status).
function T.ViaStatus()
	local s = route and route.steps[route.idx]
	if not (s and s._viaPending) then
		return nil
	end
	local d, how = T.Distance(s.map, s.via[1], s.via[2])
	local lim = T.NEAR[s.viaNear or "door"] or T.NEAR.door
	return { mapID = s.map, doorX = s.via[1], doorY = s.via[2], destLabel = s.text, destX = s.x, destY = s.y,
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

--- Off the route (a map no step is on): plan again from here. Same first step as now → keep it, no chat line.
local function Replan()
	local r = route
	local steps = BuildPlainSteps(r.target)
	local old = r.steps[r.idx]
	local new = steps[1]
	r.steps = steps
	if old and new and old.map == new.map and old.x == new.x and old.y == new.y and IsAction(old) == IsAction(new) then
		r.idx = 1
		r.lastMap = T.PlayerMap()
		return
	end
	ShowStep(1)
end

local function OnZone(event, big, retry)
	local r = route
	if r and not SameOwner(ns._mhRouteOwner, r.owner) then
		-- Another route took the arrow: ours ends without a word (the Mount run's rule).
		T.Stop("owner")
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
	-- Never back while riding: a flight crosses subzones of the map you boarded on (16 Oct 2026, Elsia's flight).
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
			OnZone(e, b)
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

--- `/mh travel`, second half: the running route.
function T.PrintRoute()
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
		print(("     %s%d. %s  |cff8a8f98[%s%s%s%s]|r%s"):format(i == r.idx and "|cffffd200>|r " or "  ", i,
			tostring(s.text), where, s.via and " via door" or "", s.handoff and " handoff" or "", s.board and " board" or "",
			d and (" — %.0f %s"):format(d, how) or ""))
	end
end
