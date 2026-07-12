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

-- Is WaypointUI installed? When it is, it renders its own in-world pin from the
-- Blizzard user waypoint we set, so our own arrow stands down — the user wants a
-- SINGLE guide. Our arrow is the fallback for players with neither TomTom nor
-- WaypointUI. (We still set the Blizzard waypoint so WaypointUI has something to show.)
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

-- Our own cached lead. Survives transient ns.lastTarget = nil from zone handlers.
local activeLead

-- Per-lead caches so the ~30 Hz arrow loop doesn't recompute a stationary target
-- every tick (review F3.3). The target's world coords change only when the lead
-- changes; the label string only when the shown distance/name changes.
local leadWorldKey, leadWx, leadWy
local lastLabelName, lastLabelVal, lastLabelUnit

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
	local pmap = C_Map and C_Map.GetBestMapForUnit and C_Map.GetBestMapForUnit("player")
	if pmap and MapContinent(pmap) ~= MapContinent(t.mapID) then
		f.tex:Hide()
		if f.icon then f.icon:Hide() end
		local other = ns:L("ARROW_OTHER_CONTINENT")
		if not other or other == "ARROW_OTHER_CONTINENT" then
			other = "(other continent)"
		end
		f.label:SetText((t.name or "") .. "  " .. other)
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
	f.tex:SetRotation(atan2(dy, dx) - facing + ROTATION_OFFSET)
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
	local shownInt = math.floor(shown + 0.5)
	if t.name ~= lastLabelName or shownInt ~= lastLabelVal or unit ~= lastLabelUnit then
		lastLabelName, lastLabelVal, lastLabelUnit = t.name, shownInt, unit
		f.label:SetText(("%s  %d %s"):format(t.name or "", shownInt, unit))
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

	-- No TomTom driving. If WaypointUI is installed, let ITS pin be the single guide
	-- (fed by the Blizzard waypoint we still set below) and hide our own arrow. Our
	-- arrow only appears for players who have neither TomTom nor WaypointUI.
	if IsWaypointUIPresent() then
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

	-- A single-destination delve route has no auto-advance, so release the arrow
	-- once we arrive (within ~20yd). rare/treasure/reset manage their own lifecycle.
	if ns._mhRouteOwner == "delve" and atLead then
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
