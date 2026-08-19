--[[
	Midnight Helper — NativeArrow (standalone route guidance).

	Draws our own on-screen direction arrow AND drives Blizzard's native user
	waypoint + SuperTrack toward the active route lead, so routing works WITHOUT
	TomTom and keeps flowing to the next stop on arrival. Retail has no built-in
	rotating arrow of its own, so we ship one.

	Runs in two situations only:
	  1. No TomTom installed  -> we are the only guidance, so we drive it.
	  2. TomTom present but its crazy arrow is DOWN (hidden) -> safety net.
	While TomTom's crazy arrow is actually showing, this module stands down.

	IMPORTANT — zone robustness (the bug that kept coming back):
	The shared lead `ns.lastTarget` is poked/cleared by several modules' zone
	handlers (e.g. Delves nils it when it thinks travel is complete). If the arrow
	depended on `ns.lastTarget` staying alive, it would vanish the moment you fly
	out of a city/zone. So this module leans on the STABLE signal `ns._mhRouteOwner`
	(only cleared when a route genuinely ends) and keeps its OWN cached copy of the
	lead. A transient `ns.lastTarget = nil` can no longer kill the arrow — only the
	owner clearing (route done) does.
]]

local _, ns = ...

local C_Map, C_SuperTrack, C_Timer = C_Map, C_SuperTrack, C_Timer
local atan2 = math.atan2 or function(y, x) return math.atan(y / x) end

-- If the arrow ever points the exact opposite way on your client, set this to
-- math.pi (the world-coordinate axis sign is the only thing that could differ).
local ROTATION_OFFSET = 0

local DEFAULT_SIZE, MIN_SIZE, MAX_SIZE = 64, 28, 160

-- Within this many yards of the current rare lead counts as "arrived" — used to
-- auto-advance past an un-spawned rare (the fly-over behaviour). Sampled in the
-- frequent OnUpdate so fast flights between 1s ticks are still caught.
local RARE_ARRIVAL = 40
local rareReached, rareReachKey = false, nil

-- Seconds parked on a detour rare's spot, out of combat, with the rare not there,
-- before we give the arrow back to the route it interrupted. Someone else may have
-- killed it just before you arrived (no quest credit → the normal resume never
-- fires), or it despawned. The 1s Tick counts these; combat resets them, so a real
-- fight is never abandoned mid-swing.
local LOST_RARE_SECONDS = 10
local lostRareTicks = 0

-- Per-content styling for the arrow: which type of route currently owns the shared
-- arrow (ns._mhRouteOwner) decides the accent colour and the little badge icon that
-- sits next to the target name. Icon paths are plain Interface\Icons textures (always
-- present on every client) so there's no atlas-version risk. r/g/b tints the arrow +
-- label. Any owner not listed falls back to DEFAULT_STYLE (gold, no icon).
local OWNER_STYLE = {
	rare        = { icon = "Interface\\Icons\\Ability_Hunter_MarkedForDeath", r = 1.00, g = 0.32, b = 0.32 }, -- rood: rare
	treasure    = { icon = "Interface\\Icons\\INV_Misc_Coin_01",             r = 1.00, g = 0.82, b = 0.20 }, -- goud: treasure/chest
	achievement = { icon = "Interface\\Icons\\Achievement_Quests_Completed_08", r = 1.00, g = 0.90, b = 0.42 }, -- geel: achievement
	reset       = { icon = "Interface\\Icons\\INV_Misc_Map_01",              r = 0.42, g = 0.78, b = 1.00 }, -- blauw: reset-route
	-- Voorbereid voor toekomstige claimers (schaadt niet als ze nooit gezet worden):
	delve       = { icon = "Interface\\Icons\\INV_Misc_Cave_01",             r = 0.35, g = 0.95, b = 1.00 }, -- fel cyaan: delve (contrast op felle lucht)
	ritual      = { icon = "Interface\\Icons\\Spell_Shadow_DemonicCircleTeleport", r = 0.72, g = 0.45, b = 1.00 }, -- paars: ritual
}
local DEFAULT_STYLE = { icon = nil, r = 1.00, g = 0.82, b = 0.00 }

local function OwnerStyle()
	return OWNER_STYLE[ns._mhRouteOwner] or DEFAULT_STYLE
end

-- Map (0..1) coords -> world (yard) coords. pcall-safe; nil when unavailable.
-- World coords are isotropic and comparable across maps on the same continent.
local function MapToWorld(mapID, x01, y01)
	if not (C_Map and C_Map.GetWorldPosFromMapPos and CreateVector2D and mapID) then
		return nil
	end
	local ok, _, world = pcall(C_Map.GetWorldPosFromMapPos, mapID, CreateVector2D(x01, y01))
	if ok and type(world) == "table" then
		if world.GetXY then
			return world:GetXY()
		end
		return world.x, world.y
	end
	return nil
end

-- Continent/instance id for a map (first return of GetWorldPosFromMapPos). World
-- coords are only comparable within one continent, so a target on another continent
-- (e.g. you portaled to Orgrimmar while routing a Midnight rare) must NOT draw a
-- direction/distance — the numbers would be meaningless.
-- Continent id is stable per mapID, so cache it: the arrow's ~30 Hz loop asked for
-- it twice per tick (player + target), each allocating a Vector2D (review F3.3).
local continentCache = {}
local function MapContinent(mapID)
	if not mapID then
		return nil
	end
	local cached = continentCache[mapID]
	if cached ~= nil then
		return cached
	end
	if not (C_Map and C_Map.GetWorldPosFromMapPos and CreateVector2D) then
		return nil
	end
	local ok, cont = pcall(C_Map.GetWorldPosFromMapPos, mapID, CreateVector2D(0.5, 0.5))
	if ok and cont ~= nil then
		continentCache[mapID] = cont
		return cont
	end
	return nil -- transient failure: don't cache, retry next tick
end

local function PlayerWorld()
	if not (C_Map and C_Map.GetBestMapForUnit) then
		return nil
	end
	local pmap = C_Map.GetBestMapForUnit("player")
	if not pmap then
		return nil
	end
	local pos = C_Map.GetPlayerMapPosition and C_Map.GetPlayerMapPosition(pmap, "player")
	if not pos then
		return nil
	end
	local px, py = pos:GetXY()
	if not (px and py) then
		return nil
	end
	return MapToWorld(pmap, px, py)
end

local function TargetKey(t)
	if not (t and t.mapID) then
		return nil
	end
	return tostring(t.mapID) .. ":" .. tostring(t.x) .. ":" .. tostring(t.y)
end

local function HasNativeWaypoint()
	return (C_Map and C_Map.HasUserWaypoint and C_Map.HasUserWaypoint()) and true or false
end

-- Track when TomTom's crazy arrow was last visible, so a brief clear (it blanks for
-- a moment on each waypoint arrival) doesn't instantly flash our arrow.
local ttArrowLastSeen = 0
local function TomTomArrowShowing()
	local f = _G.TomTomCrazyArrow
	local shown = (f and f.IsShown and f:IsShown()) and true or false
	if shown then
		ttArrowLastSeen = (GetTime and GetTime()) or 0
	end
	return shown
end

-- Stable "a route is live" signal: an owner is claimed only during a real route
-- and cleared only when it genuinely ends (never merely on a zone change).
local function RouteOwned()
	return (ns._mhRouteOwner ~= nil) and true or false
end

-- Grace before we take over from a dropped TomTom arrow: avoids flashing our arrow
-- during the brief blank on each arrival, while still stepping in for a real drop.
local TT_GRACE = 4

-- Should THIS module drive guidance right now?
--   * no TomTom             -> yes (only guidance available)
--   * TomTom arrow down >4s -> yes (safety net for a real drop)
--   * TomTom arrow shown/    -> no  (leave the working crazy arrow alone; don't flash
--     recently shown             on the momentary clear at each waypoint arrival)
local function ShouldDriveNative()
	if ns.IsTomTomReady and ns.IsTomTomReady() then
		if TomTomArrowShowing() then
			return false
		end
		local now = (GetTime and GetTime()) or 0
		return (now - ttArrowLastSeen) >= TT_GRACE
	end
	return true
end

-- Is WaypointUI installed? It renders its own in-world pin from the Blizzard user
-- waypoint we set, which we keep setting either way so it has something to show.
-- Whether we then hide OUR arrow is a per-player choice — see YieldToWaypointUI
-- below; it used to be forced and is now off by default.
local function IsWaypointUIPresent()
	if WaypointUIAPI then
		return true
	end
	if C_AddOns and C_AddOns.IsAddOnLoaded then
		local ok, loaded = pcall(C_AddOns.IsAddOnLoaded, "WaypointUI")
		if ok and loaded then
			return true
		end
	end
	return false
end

--- Do we hide our arrow because WaypointUI is installed? DEFAULT: no.
---
--- ⚠️ The default flipped on 5 Aug, and the reason is Rob's: "dat is wel iets wat
--- wij beloven". Hiding for WaypointUI was a considered choice — one guide on
--- screen — but it quietly cancelled the route arrow for anyone who has that
--- addon, which is most of his testers. `/mh arrow` on his own machine reads
--- "wij sturen: ja / onze pijl getekend: nee", with TomTom switched off. A feature
--- that a release announced and that silently never appears is worse than two
--- indicators.
---
--- The two are not the same thing either, which is what makes the original
--- reasoning wrong rather than merely inconvenient: WaypointUI draws a PIN at a
--- place. Ours is a direction with a distance and the name of the next stop. A
--- player who wanted only the pin can still have it with one command.
---
--- TomTom is untouched. Its crazy arrow IS the same kind of thing as ours, so
--- standing down for it remains right.
local function YieldToWaypointUI()
	return (ns.db and ns.db.arrowYieldWaypointUI) and true or false
end

-- Our own cached lead. Survives transient ns.lastTarget = nil from zone handlers.
local activeLead

-- A snapshot of where the arrow points right now, for a route that wants to hand
-- control to a detour and get it back later. Reads the CACHE, not ns.lastTarget,
-- because zone handlers nil the latter mid-hunt (that is why activeLead exists).
function ns.GetActiveArrowLead()
	if activeLead and activeLead.mapID then
		return { mapID = activeLead.mapID, x = activeLead.x, y = activeLead.y, name = activeLead.name }
	end
	return nil
end

-- Per-lead caches so the ~30 Hz arrow loop doesn't recompute a stationary target
-- every tick (review F3.3). The target's world coords change only when the lead
-- changes; the label string only when the shown distance/name changes.
local leadWorldKey, leadWx, leadWy
local lastLabelName, lastLabelVal, lastLabelUnit, lastLabelHint

--- How close before the arrow adds what it knows about the destination. Deliberately
--- generous: this is "you are in the neighbourhood", not "you have arrived".
local ARRIVAL_HINT_YARDS = 80

--------------------------------------------------------------------------------
-- On-screen direction arrow (our own; retail has no built-in rotating arrow).
--------------------------------------------------------------------------------

local arrowFrame

local function ArrowSize()
	local s = MidnightHelperDB and tonumber(MidnightHelperDB.nativeArrowSize)
	if not s then
		return DEFAULT_SIZE
	end
	if s < MIN_SIZE then
		return MIN_SIZE
	elseif s > MAX_SIZE then
		return MAX_SIZE
	end
	return s
end

local function UpdateArrow()
	local f = arrowFrame
	local t = activeLead
	if not (f and t and t.mapID) then
		return
	end
	-- Different continent (e.g. you portaled to Orgrimmar mid-hunt): coords aren't
	-- comparable, so don't draw a bogus direction/distance — just name the target.
	--- ⚠️ nil IS NOT "ELSEWHERE". Rob, 18 aug: standing in the Vaults with a target on
	--- the Coiled Isle above him, the arrow read "other continent — travel back".
	---
	--- MapContinent returns nil when the lookup fails, and `nil ~= 947` is true, so an
	--- unreadable map was being reported as a different continent with full confidence.
	--- Same shape as the aura contract: unreadable ≠ absent. Both sides must resolve
	--- before this branch may claim anything.
	---
	--- ⚠️ And even when both resolve it can be misleading. The Vaults carry their own
	--- coordinate space, so 2509 and 2512 genuinely differ — while the thing the player
	--- has to do is walk out of a door, not fly across the world. "Travel back" is a
	--- true sentence and useless advice, which is the pairing this addon keeps having
	--- to fix.
	local pmap = C_Map and C_Map.GetBestMapForUnit and C_Map.GetBestMapForUnit("player")
	local pc, tc = MapContinent(pmap), MapContinent(t.mapID)
	local unreachable = pmap and pc and tc and pc ~= tc

	--- ⚠️ POINT AT THE FIRST STEP INSTEAD OF GIVING UP. Rob, 18 aug, standing on the
	--- isle with a target in the Underbelly: "kan hij niet zien dat ik er buiten sta
	--- en niet in de underbelly ben, dat moet anders."
	---
	--- He is right, and the previous fix only got halfway. The label had learned to
	--- name the door — but a name is not an arrow, and the door is standing on HIS
	--- OWN MAP with a real direction and a real distance. Refusing to draw was correct
	--- only about the destination; it was never correct about the next step.
	---
	--- So when the target sits in another coordinate space, ask the travel plan for
	--- the first step that IS on this map and steer to that. The arrow behaves
	--- normally — rotates, counts down the metres, advances when he arrives — and the
	--- black label is left for the case where genuinely nothing here helps.
	local standingOnStep
	if unreachable and ns.BuildTravelPlan then
		local okP, steps = pcall(ns.BuildTravelPlan, t.mapID, t.x, t.y, t.name)
		if okP and type(steps) == "table" then
			--- Where the player is on their own map, so a step they are already
			--- standing on can be told apart from one they still have to walk to.
			local px, py
			if C_Map and C_Map.GetPlayerMapPosition then
				local okQ, pos = pcall(C_Map.GetPlayerMapPosition, pmap, "player")
				if okQ and pos and pos.GetXY then
					local okXY, a, b = pcall(pos.GetXY, pos)
					if okXY and a then
						px, py = a * 100, b * 100
					end
				end
			end
			for _, s in ipairs(steps) do
				if s.kind ~= "arrive" and s.mapID == pmap and s.x and s.y then
					--- ⚠️ DO NOT POINT AT SOMEONE'S OWN FEET. Rob, 18 aug: walking into
					--- the gate corridor, the arrow kept pointing back at the gate. His
					--- `/mh here` explains it — inside the corridor the client still
					--- reports him on 2512 at 43.12/44.19, right on top of the door. He
					--- had not crossed onto 2509 yet, so the step was not "done", and
					--- an arrow to a place you are standing in spins uselessly.
					---
					--- There is nothing further to point at either: the next step is on
					--- a map he is not on. So say the true thing — you are at it, walk
					--- through — instead of drawing a direction to nowhere.
					if px and ((s.x - px) ^ 2 + (s.y - py) ^ 2) < 4 then
						standingOnStep = s.localized and ns:L(s.label) or s.label
						break
					end
					t = {
						mapID = s.mapID,
						x = s.x,
						y = s.y,
						name = s.localized and ns:L(s.label) or (s.label or t.name),
					}
					unreachable = false
					break
				end
			end
		end
	end

	if unreachable then
		f.tex:Hide()
		if f.icon then f.icon:Hide() end
		local other = ns:L("ARROW_OTHER_CONTINENT")
		if not other or other == "ARROW_OTHER_CONTINENT" then
			other = "(other continent)"
		end

		--- ⚠️ Rob, 17 aug: "waarom krijg ik dit en wat moet ik ermee?!? ik zie geen
		--- afstand of niks." Refusing to draw a direction across continents is right —
		--- it would be invented — but naming the target and stopping there tells him
		--- what he is looking for and nothing about what to do, which is the half of
		--- the job this addon exists for.
		---
		--- We already know the answer and were not saying it: the same flight point
		--- this addon prints to chat when the route is first set. Naming it turns a
		--- dead label into one instruction. Still no direction and no distance, because
		--- there honestly is none from here.
		--- Prefer the first step of the actual plan over the destination's flight point.
		--- Standing inside the Vaults, "head for Tokka's Landing" is where you end up;
		--- the door out is what you do NEXT, and that is the difference between a label
		--- and an instruction. Falls back to the flight point when no plan exists.
		local aim
		if ns.BuildTravelPlan then
			local okP, steps = pcall(ns.BuildTravelPlan, t.mapID, t.x, t.y, t.name)
			if okP and type(steps) == "table" then
				for _, s in ipairs(steps) do
					if s.kind ~= "arrive" and s.label then
						aim = s.localized and ns:L(s.label) or s.label
						break
					end
				end
			end
		end
		if not aim and ns.GetNearestFlightPoint then
			local ok, fp = pcall(ns.GetNearestFlightPoint, t.mapID, t.x, t.y)
			if ok and type(fp) == "string" and fp:find("%w") then
				aim = fp
			end
		end
		if standingOnStep then
			-- You are on it. One instruction, no direction, no distance.
			f.label:SetText(("|cffffd100%s|r"):format(
				(ns:L("ARROW_AT_STEP")):format(standingOnStep)))
		elseif aim then
			f.label:SetText(("%s  %s  |cff8fd3ff%s|r"):format(
				t.name or "", other, (ns:L("ARROW_FLY_TO")):format(aim)))
		else
			f.label:SetText((t.name or "") .. "  " .. other)
		end
		lastLabelName, lastLabelVal, lastLabelUnit = nil, nil, nil -- invalidate label cache
		return
	end
	local pwx, pwy = PlayerWorld()
	-- Target is stationary: recompute its world coords only when the lead changes.
	local tkey = TargetKey(t)
	if tkey ~= leadWorldKey then
		leadWorldKey = tkey
		leadWx, leadWy = MapToWorld(t.mapID, (t.x or 0) / 100, (t.y or 0) / 100)
	end
	local twx, twy = leadWx, leadWy
	local facing = GetPlayerFacing and GetPlayerFacing()
	if not (pwx and twx and facing) then
		return
	end
	local dx, dy = twx - pwx, twy - pwy
	local dist = math.sqrt(dx * dx + dy * dy)
	-- Rare hunts: latch "reached the current lead" here (sampled ~30x/s) so a fast
	-- fly-over is caught between the 1s ticks that decide whether to auto-advance.
	if ns._mhRouteOwner == "rare" then
		local k = TargetKey(t)
		if k ~= rareReachKey then
			rareReachKey = k
			rareReached = false
		end
		if dist <= RARE_ARRIVAL then
			rareReached = true
		end
	end
	f.tex:Show()
	-- North-pointing texture, rotated counter-clockwise for positive radians.
	local rot = atan2(dy, dx) - facing + ROTATION_OFFSET
	f.tex:SetRotation(rot)
	if f.texOutline then
		f.texOutline:Show()
		f.texOutline:SetRotation(rot)
	end
	if f.texGlow then
		f.texGlow:Show()
		f.texGlow:SetRotation(rot)
	end
	-- Accent colour follows the content type owning the arrow; the "almost there"
	-- green still wins when you're right on top of the target.
	local style = OwnerStyle()
	if dist < 12 then
		f.tex:SetVertexColor(0.35, 1, 0.35) -- basically there
	else
		f.tex:SetVertexColor(style.r, style.g, style.b)
	end
	-- Per-type badge next to the name (chest/skull/etc.), or hidden for generic routes.
	if f.icon then
		if style.icon then
			f.icon:SetTexture(style.icon)
			f.icon:Show()
		else
			f.icon:Hide()
		end
	end
	if f.label then
		f.label:SetTextColor(style.r, style.g, style.b)
	end
	local shown, unit = dist, "yd"
	if MidnightHelperDB and MidnightHelperDB.nativeArrowMeters then
		shown, unit = dist * 0.9144, "m" -- 1 yard = 0.9144 m
	end
	-- Only rebuild the label string when something visible changed (~30 Hz loop): the
	-- floored distance rarely moves between adjacent ticks, so this skips most allocs.
	--- ⚠️ AN ARRIVAL HINT, SHOWN ONLY ON ARRIVAL. A coordinate is right for the whole
	--- journey; it is at the destination that it can mislead, because the player stands
	--- on the dot, sees nothing, and blames the data. Two measured cases on 19 aug: a
	--- rare that swims (three sources, three points, one line) and a rare that is not
	--- there until you open a chest — where every published coordinate is the chest.
	---
	--- Saying it earlier would undercut a direction that is perfectly good all the way.
	local hint = (t.hintKey and dist <= ARRIVAL_HINT_YARDS) and t.hintKey or nil
	local shownInt = math.floor(shown + 0.5)
	if t.name ~= lastLabelName or shownInt ~= lastLabelVal or unit ~= lastLabelUnit
		or hint ~= lastLabelHint then
		lastLabelName, lastLabelVal, lastLabelUnit = t.name, shownInt, unit
		lastLabelHint = hint
		local text = ("%s  %d %s"):format(t.name or "", shownInt, unit)
		if hint then
			--- ⚠️ THIS LOOKUP IS INVISIBLE TO THE LINTER. Check [1] only resolves locale
			--- keys written as literals, and says so itself — "dynamic refs skipped,
			--- blind spot". The key here arrives in a variable from the rare's own row,
			--- so a typo in the data would put a raw key name on the arrow and nothing
			--- would fail the build. The resolver hands the key back when it cannot
			--- resolve it, so compare against it and drop the hint instead.
			local resolved = ns:L(hint)
			if resolved and resolved ~= hint then
				text = text .. "  " .. resolved
			end
		end
		f.label:SetText(text)
	end
end

local function EnsureArrowFrame()
	if arrowFrame then
		return arrowFrame
	end
	local f = CreateFrame("Frame", "MidnightHelperNativeArrow", UIParent)
	local sz = ArrowSize()
	f:SetSize(sz, sz)
	f:SetFrameStrata("HIGH")
	f:SetPoint("CENTER", UIParent, "CENTER", 0, 170)
	f:SetMovable(true)
	f:EnableMouse(true)
	f:RegisterForDrag("LeftButton")
	f:SetScript("OnDragStart", f.StartMoving)
	f:SetScript("OnDragStop", function(self)
		self:StopMovingOrSizing()
		local point, _, relPoint, x, y = self:GetPoint()
		MidnightHelperDB = MidnightHelperDB or {}
		MidnightHelperDB.nativeArrowPos = { point, relPoint, x, y }
	end)
	-- Right-click the arrow to clear the active route (most intuitive place to do it).
	f:SetScript("OnMouseUp", function(_, button)
		if button == "RightButton" and ns.ClearActiveRoute then
			ns.ClearActiveRoute()
		end
	end)
	f:SetScript("OnEnter", function(self)
		if not GameTooltip then
			return
		end
		GameTooltip:SetOwner(self, "ANCHOR_TOP")
		GameTooltip:AddLine("Midnight Helper", 1, 0.82, 0)
		GameTooltip:AddLine("Drag to move · Right-click to clear the route", 0.9, 0.9, 0.9, true)
		GameTooltip:Show()
	end)
	f:SetScript("OnLeave", function()
		if GameTooltip then
			GameTooltip:Hide()
		end
	end)

	-- TWO halos, because one is only ever right half the time.
	--
	-- There used to be just the dark one, and its own comment named the case it
	-- solves: "bright sky, pale walls". Rob, 5 Aug: against dark ground the blue
	-- arrow on a black halo is nearly invisible — a dark outline adds nothing to a
	-- dark background. The arrow floats over the world, so both cases happen within
	-- one lap of a route.
	--
	-- Outer pale glow first (reads on dark), then the dark edge just inside it
	-- (reads on light), then the coloured arrow. Both are anchored to the frame's
	-- corners with a fixed inset, so they scale and rotate with it.
	local glow = f:CreateTexture(nil, "BACKGROUND")
	glow:SetTexture("Interface\\Minimap\\MinimapArrow")
	glow:SetPoint("TOPLEFT", f, "TOPLEFT", -7, 7)
	glow:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", 7, -7)
	glow:SetVertexColor(1, 1, 1, 0.45)
	f.texGlow = glow

	local outline = f:CreateTexture(nil, "ARTWORK")
	outline:SetTexture("Interface\\Minimap\\MinimapArrow")
	outline:SetPoint("TOPLEFT", f, "TOPLEFT", -3, 3)
	outline:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", 3, -3)
	outline:SetVertexColor(0, 0, 0, 0.85)
	f.texOutline = outline

	local tex = f:CreateTexture(nil, "OVERLAY")
	tex:SetTexture("Interface\\Minimap\\MinimapArrow")
	tex:SetAllPoints(f)
	tex:SetVertexColor(1, 0.82, 0)
	f.tex = tex

	local label = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	label:SetPoint("TOP", f, "BOTTOM", 0, -2)
	label:SetJustifyH("CENTER")
	f.label = label

	-- Small per-type badge, pinned just left of the name text.
	local icon = f:CreateTexture(nil, "OVERLAY")
	icon:SetSize(16, 16)
	icon:SetPoint("RIGHT", label, "LEFT", -4, 0)
	icon:SetTexCoord(0.08, 0.92, 0.08, 0.92) -- trim the built-in icon border
	icon:Hide()
	f.icon = icon

	-- Restore a saved position (SavedVars are loaded by the time we first show).
	local pos = MidnightHelperDB and MidnightHelperDB.nativeArrowPos
	if type(pos) == "table" and pos[1] then
		f:ClearAllPoints()
		f:SetPoint(pos[1], UIParent, pos[2], pos[3], pos[4])
	end

	local acc = 0
	f:SetScript("OnUpdate", function(self, elapsed)
		acc = acc + elapsed
		if acc < 0.03 then
			return
		end
		acc = 0
		UpdateArrow()
	end)

	f:Hide()
	arrowFrame = f
	return f
end

local function ShowArrow()
	local f = EnsureArrowFrame()
	if not f:IsShown() then
		f:Show()
	end
end

local function HideArrow()
	if arrowFrame and arrowFrame:IsShown() then
		arrowFrame:Hide()
	end
end

-- Public: live resize from the Settings slider (or /mh arrowsize). Persists.
function ns.SetNativeArrowSize(px)
	px = tonumber(px)
	if not px then
		return ArrowSize()
	end
	if px < MIN_SIZE then
		px = MIN_SIZE
	elseif px > MAX_SIZE then
		px = MAX_SIZE
	end
	MidnightHelperDB = MidnightHelperDB or {}
	MidnightHelperDB.nativeArrowSize = px
	if arrowFrame then
		arrowFrame:SetSize(px, px)
	end
	return px
end

function ns.GetNativeArrowSize()
	return ArrowSize()
end

ns.NativeArrowSizeBounds = { min = MIN_SIZE, max = MAX_SIZE, default = DEFAULT_SIZE }

-- Distance unit for the arrow label: meters (true) or yards (false, default).
function ns.GetNativeArrowMeters()
	return (MidnightHelperDB and MidnightHelperDB.nativeArrowMeters) and true or false
end

function ns.SetNativeArrowMeters(on)
	MidnightHelperDB = MidnightHelperDB or {}
	MidnightHelperDB.nativeArrowMeters = on and true or false
	return MidnightHelperDB.nativeArrowMeters
end

-- Let players preview/place the arrow even when no route is active.
function ns.PreviewNativeArrow(seconds)
	local f = EnsureArrowFrame()
	f.tex:Show()
	f.tex:SetRotation(0)
	f.tex:SetVertexColor(1, 0.82, 0)
	if f.texOutline then
		f.texOutline:Show()
		f.texOutline:SetRotation(0)
	end
	if f.texGlow then
		f.texGlow:Show()
		f.texGlow:SetRotation(0)
	end
	f.label:SetText("Midnight Helper")
	f._preview = true
	f:Show()
	if C_Timer and C_Timer.After then
		C_Timer.After(tonumber(seconds) or 5, function()
			f._preview = false
			if not (RouteOwned() and ShouldDriveNative()) then
				f:Hide()
			end
		end)
	end
end

--------------------------------------------------------------------------------
-- Keepalive: drive the native user waypoint + show/hide the arrow.
--------------------------------------------------------------------------------

-- The last lead WE pinned the native waypoint to (nil = we don't own one).
local mhOwnedKey

local function Tick()
	-- Route ended (owner cleared): tear everything down. This is the ONLY thing
	-- that stops the arrow — a transient ns.lastTarget = nil does not.
	if not RouteOwned() then
		activeLead = nil
		if not (arrowFrame and arrowFrame._preview) then
			HideArrow()
		end
		if mhOwnedKey then
			if HasNativeWaypoint() and C_Map and C_Map.ClearUserWaypoint then
				pcall(C_Map.ClearUserWaypoint)
			end
			mhOwnedKey = nil
		end
		return
	end

	-- Refresh our cached lead whenever a route publishes one (initial / advance /
	-- skip). If ns.lastTarget was transiently nil'd, we keep the previous lead.
	local lt = ns.lastTarget
	if lt and lt.mapID then
		activeLead = { mapID = lt.mapID, x = lt.x, y = lt.y, name = lt.name }
	end

	-- Rares FULL route only (Generate Route; _mhLastRoutedRareQuest == nil): TomTom
	-- auto-advances to the next rare after a kill AND when you fly over an empty
	-- spawn (cleardistance). The native path does both itself: MHRareTryAutoAdvance
	-- pushes a reached-but-un-spawned rare to the back, and GetNearestIncompleteRareLead
	-- pulls the next open rare. A SINGLE rare route (Find Nearest / a specific rare row)
	-- sets a quest id and is left alone: it stays on that one rare until it's done.
	if ns._mhRouteOwner == "rare" and not ns._mhLastRoutedRareQuest then
		-- Only auto-advance while WE are the guidance (TomTom does its own thing).
		if ShouldDriveNative() and ns.MHRareTryAutoAdvance and ns.MHRareTryAutoAdvance(rareReached) then
			rareReached = false
		end
		if ns.GetNearestIncompleteRareLead then
			local nr = ns.GetNearestIncompleteRareLead()
			if nr and nr.mapID then
				activeLead = nr
			end
		end
	end

	-- Treasures route (owner "treasure"): treasures are always present (no spawn
	-- timer), so just follow the nearest still-incomplete one; looting completes its
	-- quest and the lead advances to the next. Its own module nils ns.lastTarget, so
	-- we pull the lead directly here — same backbone as rares, minus the skip logic.
	if ns._mhRouteOwner == "treasure" and ns.GetNearestIncompleteTreasureLead then
		local nt = ns.GetNearestIncompleteTreasureLead()
		if nt and nt.mapID then
			activeLead = nt
		end
	end

	if not (activeLead and activeLead.mapID) then
		HideArrow()
		return
	end

	if not ShouldDriveNative() then
		HideArrow() -- TomTom's crazy arrow is doing the job; stand down.
		return
	end

	-- No TomTom driving. We now draw our arrow even alongside WaypointUI, because
	-- its pin and our arrow answer different questions (where is it, versus which
	-- way and how far). Switchable with `/mh arrow yield` for anyone who wants the
	-- pin alone.
	if IsWaypointUIPresent() and YieldToWaypointUI() then
		HideArrow()
	else
		ShowArrow()
	end

	local key = TargetKey(activeLead)

	-- Parked ON the lead (within ~20 yd — e.g. an un-spawned rare you walked up to):
	-- don't re-assert every tick, or Blizzard's arrive-clear vs our re-set would churn.
	local atLead = false
	local pwx, pwy = PlayerWorld()
	local twx, twy = MapToWorld(activeLead.mapID, (activeLead.x or 0) / 100, (activeLead.y or 0) / 100)
	if pwx and twx then
		local dx, dy = pwx - twx, pwy - twy
		atLead = (dx * dx + dy * dy) <= (20 * 20)
	end

	-- Lost detour rare: parked on the spot, out of combat, and it is simply not here.
	-- Only for a SINGLE detour (a quest token is set — a full hunt auto-advances) that
	-- has a route to go back to (_mhRarePrevLead). We do not care WHY the rare is gone
	-- (someone else killed it, or it despawned); after LOST_RARE_SECONDS on an empty
	-- spot we hand the arrow back to the interrupted route instead of leaving it stuck.
	-- Combat resets the count, so a rare you are actually fighting is never abandoned.
	if ns._mhRouteOwner == "rare" and ns._mhLastRoutedRareQuest and ns._mhRarePrevLead
		and ns.ResumeInterruptedRareRoute then
		local parkedOnRare = false
		if pwx and twx then
			local dx, dy = pwx - twx, pwy - twy
			parkedOnRare = (dx * dx + dy * dy) <= (RARE_ARRIVAL * RARE_ARRIVAL)
		end
		-- Only count down when the rare is genuinely NOT here: parked on the spot,
		-- out of combat, AND no killable vignette nearby. Without the vignette check
		-- the timer bailed off a rare that was still alive while the player stood
		-- next to it before engaging (Cisca, 2026-07-24).
		local rareStillHere = ns.IsRareVignetteNearWorld
			and ns.IsRareVignetteNearWorld(pwx, pwy, RARE_ARRIVAL)
		if parkedOnRare and not rareStillHere and not (InCombatLockdown and InCombatLockdown()) then
			lostRareTicks = lostRareTicks + 1
			if lostRareTicks >= LOST_RARE_SECONDS then
				lostRareTicks = 0
				ns.ResumeInterruptedRareRoute()
				return
			end
		else
			lostRareTicks = 0
		end
	else
		lostRareTicks = 0
	end

	-- A single-destination route (delve / generic waypoint) has no auto-advance, so
	-- release the arrow once we arrive (within ~20yd). rare/treasure/reset/achievement
	-- manage their own lifecycle.
	if (ns._mhRouteOwner == "delve" or ns._mhRouteOwner == "waypoint") and atLead then
		ns._mhRouteOwner = nil
		activeLead = nil
		HideArrow()
		if mhOwnedKey and HasNativeWaypoint() and C_Map and C_Map.ClearUserWaypoint then
			pcall(C_Map.ClearUserWaypoint)
			mhOwnedKey = nil
		end
		return
	end

	local targetChanged = (key ~= mhOwnedKey)
	local waypointGone = not HasNativeWaypoint()

	-- Re-pin when the lead advanced (new target) or when the native waypoint got
	-- cleared (on arrival, OR by a zone handler) while a stop is still ahead of us.
	if targetChanged or (waypointGone and not atLead) then
		if ns.SetBlizzardUserWaypoint and ns.SetBlizzardUserWaypoint(activeLead.mapID, activeLead.x, activeLead.y) then
			mhOwnedKey = key
		end
	end
end

if C_Timer and C_Timer.NewTicker then
	C_Timer.NewTicker(1.0, Tick)
end

--------------------------------------------------------------------------------
-- `/mh arrow` — why is the arrow not guiding me?
--------------------------------------------------------------------------------

--- Carola's routes show their bottom line and then nothing happens: no arrow, and
--- the stops never move on. The same route works on Rob's machine and on Cisca's.
--- (Rob, 5 Aug.)
---
--- What is already ruled out, by him rather than by me: TomTom is switched OFF on
--- her machine, so the TomTom stand-down is not it. She does get an arrow from
--- Zygor, which this module knows nothing about and never yields to.
---
--- What remains cannot be seen from here, and this module makes it invisible by
--- design — it hides itself for WaypointUI, and it draws nothing when no route
--- ever handed it a lead. From the player's side those are the same thing: broken.
---
--- The distinction to read off the report, rather than reason about:
---   • no lead at all       -> the route never published one; the fault is upstream
---   • WaypointUI present   -> our arrow hides on purpose, stops still advance
---   • TomTom arrow shown   -> we stand down fully, and advancing stops too
--- Rob reports BOTH symptoms, and TomTom is off, so the first line is the one to
--- look at first.
function ns.PrintArrowStatus()
	local p = ("|cffffcc00%s|r"):format((ns.L and ns:L("PRINT_PREFIX")) or "Midnight Helper:")
	local function yn(v)
		if v == nil then
			return "|cff9d9d9d?|r"
		end
		return v and "|cff40c040ja|r" or "|cffff8080nee|r"
	end

	print(("%s Route-pijl status:"):format(p))
	print(("  route-eigenaar: %s"):format(tostring(ns._mhRouteOwner or "geen")))
	if activeLead and activeLead.mapID then
		print(("  doel: %s  (map %s  %.1f, %.1f)"):format(
			tostring(activeLead.name or "?"), tostring(activeLead.mapID),
			tonumber(activeLead.x) or 0, tonumber(activeLead.y) or 0))
	else
		print("  doel: |cffff8080GEEN — geen enkele route heeft een doel doorgegeven|r")
	end

	local tomtom = ns.IsTomTomReady and ns.IsTomTomReady() or false
	print(("  TomTom actief: %s   zijn pijl zichtbaar: %s"):format(
		yn(tomtom), yn(tomtom and TomTomArrowShowing() or false)))
	print(("  WaypointUI aanwezig: %s"):format(yn(IsWaypointUIPresent())))

	-- Zygor is reported only because Carola sees ITS arrow and may reasonably think
	-- it is ours. We do not yield to it and never have.
	local zygor = false
	if C_AddOns and C_AddOns.IsAddOnLoaded then
		local ok, loaded = pcall(C_AddOns.IsAddOnLoaded, "ZygorGuidesViewer")
		zygor = ok and loaded and true or false
	end
	print(("  Zygor geladen: %s |cff9d9d9d(wij wijken hier NIET voor)|r"):format(yn(zygor)))

	local drive = ShouldDriveNative()
	print(("  wij sturen: %s   onze pijl getekend: %s"):format(
		yn(drive), yn(drive and not (IsWaypointUIPresent() and YieldToWaypointUI()))))
	print(("  wijken voor WaypointUI: %s |cff9d9d9d(/mh arrow yield)|r"):format(yn(YieldToWaypointUI())))
	print(("  Blizzard-waypoint gezet: %s"):format(yn(HasNativeWaypoint())))
	print(("  pijl-frame bestaat: %s   zichtbaar: %s"):format(
		yn(arrowFrame ~= nil), yn(arrowFrame ~= nil and arrowFrame:IsShown() or false)))

	-- Say the consequence out loud. Nobody should have to know that "wij sturen:
	-- nee" also silently switches off moving to the next stop.
	if not (activeLead and activeLead.mapID) then
		print("  |cffff8080Er is geen doel. Start een route en draai dit opnieuw —|r")
		print("  |cffff8080komt hier dan nog steeds GEEN, dan ligt het niet aan de pijl.|r")
	elseif not drive then
		print("  |cffff8080Wij staan opzij voor TomTom: geen pijl EN geen doorschuiven.|r")
	elseif IsWaypointUIPresent() and YieldToWaypointUI() then
		print("  |cff9d9d9dJe hebt ingesteld dat WaypointUI stuurt, dus onze pijl blijft weg.|r")
		print("  |cff9d9d9dTerugzetten: |cffffffff/mh arrow yield|r")
	end
end

--- `/mh arrow yield` — give the arrow back to WaypointUI, or take it back.
function ns.ToggleArrowYield()
	ns.db = ns.db or {}
	ns.db.arrowYieldWaypointUI = not ns.db.arrowYieldWaypointUI
	local p = ("|cffffcc00%s|r"):format((ns.L and ns:L("PRINT_PREFIX")) or "Midnight Helper:")
	if ns.db.arrowYieldWaypointUI then
		print(("%s route-pijl: WaypointUI stuurt, onze pijl blijft weg."):format(p))
	else
		print(("%s route-pijl: wij tekenen onze eigen pijl, ook naast WaypointUI."):format(p))
	end
end
