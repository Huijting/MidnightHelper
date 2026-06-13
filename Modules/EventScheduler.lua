--[[
	Event Scheduler (fase A van het Broker_MidnightEvents-absorptieplan,
	zie docs/BROKER_ABSORPTION_PLAN.md). Taint-veilige lezer voor de
	Midnight wereld-event-timers.

	WAAROM TAINT-VEILIG: het 12.x protected-data-model behandelt
	scheduler-timestamps (start/end/duration) en widget-barwaarden als
	"secret". Rekenen met een secret taint je execution-context; schrijf je
	daarna naar de gedeelde GameTooltip of Blizzard-frame-state, dan
	propageert de taint en breekt onverwante Blizzard-UI
	("attempt to compare a secret number value").

	CONTAINMENT (de ontwerpregel uit het plan):
	  * alle C_EventScheduler / C_AreaPoiInfo-reads + alle rekenwerk op
	    mogelijk-secret waarden gebeuren in een dedicated C_Timer-ticker;
	  * resultaten landen in PLATTE Lua-tabellen (alleen gewone numbers/strings);
	  * getters en de spy lezen ALLEEN die tabellen — nooit zelf
	    widget/timestamp-arithmetic in een render- of click-pad;
	  * elk event wordt in een pcall verwerkt, zodat één secret-veld nooit
	    de hele scan (of een ander addon) kan breken.

	Deze module bouwt nog GEEN UI — fase A1/A2: data verzamelen + een spy
	(`/mh eventspy`) zodat we o.a. de open Val-uiMapID uit
	PTR_12.0.7_DATA.md kunnen oogsten. De "Now / Next 24h"-weergave is
	fase A3.

	Never-lie: we tonen alleen wat de API teruggeeft; onbekend = weglaten.

	/mh eventspy = huidige scheduler-snapshot dumpen + opslaan in SavedVars
]]

local _, ns = ...

local POLL = 5 -- seconden; wereld-events veranderen niet per seconde

-- Platte caches (bevatten NOOIT secret waarden — alleen gelaunderde numbers
-- en strings). Render/spy lezen hieruit.
local ongoing = {}  -- { {name, zoneName, uiMapID, areaPoiID, secondsLeft}, ... }
local upcoming = {} -- { {name, zoneName, uiMapID, areaPoiID, inSeconds},  ... }
local lastScan = nil

-- pcall-wrapper: roept een API veilig aan, geeft nil terug bij een throw
-- (bv. wanneer een secret wordt aangeraakt) of als de functie niet bestaat.
local function safe(fn, ...)
	if type(fn) ~= "function" then
		return nil
	end
	local ok, a, b, c = pcall(fn, ...)
	if ok then
		return a, b, c
	end
	return nil
end

-- "Launder" een waarde naar een gewone number: lukt de rekenkunde binnen de
-- pcall, dan was het geen secret en is het resultaat veilig op te slaan/te
-- vergelijken. Een secret gooit op de `+ 0` → we geven nil terug. De taint
-- van die ene mislukte poging blijft binnen deze call.
local function plainNumber(v)
	local ok, n = pcall(function()
		return v + 0
	end)
	if ok and type(n) == "number" then
		return n
	end
	return nil
end

-- POI-positie → x,y in 0-100 (gewone numbers). info.position is een vector met
-- GetXY() (0-1); we schalen naar 0-100 zodat het direct in ns.AddSmartTomTomWay
-- past. Alles gelaunderd/guarded, dus nooit een throw of secret.
local function posXY(info)
	local pos = info and info.position
	if type(pos) ~= "table" then
		return nil, nil
	end
	local x, y
	if type(pos.GetXY) == "function" then
		local ok, gx, gy = pcall(pos.GetXY, pos)
		if ok then
			x, y = gx, gy
		end
	end
	if x == nil and type(pos.x) == "number" then
		x, y = pos.x, pos.y
	end
	x, y = plainNumber(x), plainNumber(y)
	if x and y then
		return x * 100, y * 100
	end
	return nil, nil
end

-- Persistente caches (gevuld uit succesvol opgeloste LOPENDE events). Geplande
-- events geven zelf vaak geen uiMapID/naam terug; via deze caches vullen we ze
-- alsnog — precies de cache-truc die Broker ook gebruikt. Per-account in
-- SavedVars; sessie-lokale fallback als ns.db nog niet bestaat.
local function nameCache()
	if ns.db then
		ns.db.eventNameCache = ns.db.eventNameCache or {}
		return ns.db.eventNameCache
	end
	ns._eventNameCache = ns._eventNameCache or {}
	return ns._eventNameCache
end

local function zoneMap()
	if ns.db then
		ns.db.eventZoneMap = ns.db.eventZoneMap or {}
		return ns.db.eventZoneMap
	end
	ns._eventZoneMap = ns._eventZoneMap or {}
	return ns._eventZoneMap
end

-- Naam/zone/uiMapID voor een event-POI (de uiMapID is precies wat we voor de
-- PTR-data nodig hebben). Volledig via safe(), dus nooit een throw.
local function resolvePoi(areaPoiID)
	if not areaPoiID then
		return nil, nil, nil
	end

	local uiMapID = plainNumber(safe(C_EventScheduler and C_EventScheduler.GetEventUiMapID, areaPoiID))
	local zone = safe(C_EventScheduler and C_EventScheduler.GetEventZoneName, areaPoiID)
	if zone then
		zone = tostring(zone)
	end

	-- Geen uiMapID van de scheduler? Leen 'm uit de zone-cache (gevuld door
	-- lopende events: Harandar→2413, Voidstorm→2405, …).
	if not uiMapID and zone then
		uiMapID = zoneMap()[zone]
	end

	-- Met (al dan niet geleende) uiMapID proberen we de echte POI-info op te
	-- halen — soms levert dat de echte event-naam op, ook voor geplande events.
	local info
	if uiMapID then
		info = safe(C_AreaPoiInfo and C_AreaPoiInfo.GetAreaPOIInfo, uiMapID, areaPoiID)
	end
	local name = info and info.name
	if not zone and info and info.zoneName then
		zone = tostring(info.zoneName)
	end

	-- Naam-fallback: eerder geziene naam voor deze POI → "Event in <zone>".
	if not name then
		name = nameCache()[areaPoiID]
	end
	if not name and zone then
		name = "Event in " .. zone
	end

	-- Leren van een geslaagde resolutie zodat latere (geplande) events vullen.
	if info and info.name then
		nameCache()[areaPoiID] = info.name
	end
	if uiMapID and zone then
		zoneMap()[zone] = uiMapID
	end

	local px, py = posXY(info)
	return name, zone, uiMapID, px, py
end

-- Resterende tijd van een getimede POI als gewone number (of nil).
local function secondsLeftFor(areaPoiID)
	local timed = safe(C_AreaPoiInfo and C_AreaPoiInfo.IsAreaPOITimed, areaPoiID)
	if not timed then
		return nil
	end
	return plainNumber(safe(C_AreaPoiInfo and C_AreaPoiInfo.GetAreaPOISecondsLeft, areaPoiID))
end

-- De enige plek met rekenwerk op (mogelijk) secret waarden. Draait in de
-- ticker; schrijft uitsluitend platte waarden weg.
local function rescan()
	wipe(ongoing)
	wipe(upcoming)

	local now = (GetServerTime and GetServerTime()) or time()

	-- 1. Lopende events (scheduler-ongoing). Geen endTime; countdown komt van
	--    IsAreaPOITimed/GetAreaPOISecondsLeft als de POI getimed is.
	local rawOngoing = safe(C_EventScheduler and C_EventScheduler.GetOngoingEvents) or {}
	for _, ev in ipairs(rawOngoing) do
		pcall(function()
			local poiID = plainNumber(ev.areaPoiID) or ev.areaPoiID
			local name, zone, uiMapID, px, py = resolvePoi(poiID)
			if name or uiMapID then
				ongoing[#ongoing + 1] = {
					name = name,
					zoneName = zone,
					uiMapID = uiMapID,
					areaPoiID = poiID,
					secondsLeft = secondsLeftFor(poiID),
					posX = px,
					posY = py,
				}
			end
		end)
	end

	-- 2. Geplande events (scheduler-scheduled). endTime is het volgende
	--    fire-moment; filter op toekomst en sorteer oplopend.
	local rawScheduled = safe(C_EventScheduler and C_EventScheduler.GetScheduledEvents) or {}
	for _, ev in ipairs(rawScheduled) do
		pcall(function()
			local endt = plainNumber(ev.endTime)
			if endt and endt > now then
				local poiID = plainNumber(ev.areaPoiID) or ev.areaPoiID
				local name, zone, uiMapID, px, py = resolvePoi(poiID)
				if name or uiMapID then
					upcoming[#upcoming + 1] = {
						name = name,
						zoneName = zone,
						uiMapID = uiMapID,
						areaPoiID = poiID,
						inSeconds = endt - now,
						posX = px,
						posY = py,
					}
				end
			end
		end)
	end

	table.sort(upcoming, function(a, b)
		return (a.inSeconds or math.huge) < (b.inSeconds or math.huge)
	end)

	lastScan = now
end

--------------------------------------------------------------------- Getters
-- Read-only; geven referenties naar de platte caches. Consumenten itereren
-- en lezen alleen gewone numbers/strings — veilig vanuit elk pad.

function ns.GetOngoingWorldEvents()
	return ongoing
end

function ns.GetUpcomingWorldEvents()
	return upcoming
end

function ns.GetWorldEventsLastScan()
	return lastScan
end

----------------------------------------------------------------------- Spy
-- /mh eventspy — forceert een scan, slaat een snapshot op in SavedVars en
-- print een overzicht met naam · zone · uiMapID · resterende tijd. De
-- uiMapID-kolom is bedoeld om o.a. de Val-uiMapID te oogsten.

local function fmtMins(secs)
	if type(secs) ~= "number" then
		return "?"
	end
	secs = math.floor(secs)
	if secs < 60 then
		return ("%ds"):format(secs)
	end
	local m = math.floor(secs / 60)
	if m < 60 then
		return ("%dm"):format(m)
	end
	local h, rm = math.floor(m / 60), m % 60
	if h < 24 then
		return rm > 0 and ("%dh%dm"):format(h, rm) or ("%dh"):format(h)
	end
	local d, rh = math.floor(h / 24), h % 24
	return rh > 0 and ("%dd%dh"):format(d, rh) or ("%dd"):format(d)
end

-- Publieke duur-formatter (hergebruikt door de Void & Rituals-tab, fase A3).
ns.FormatEventDuration = fmtMins

function ns.EventSchedulerSpyDump()
	pcall(rescan)

	-- Snapshot bewaren zodat het na /reload in de SavedVars-file staat.
	if ns.db then
		ns.db.eventSpy = {
			ts = date("%d-%m %H:%M:%S"),
			playerMapID = plainNumber(safe(C_Map and C_Map.GetBestMapForUnit, "player")),
			hasData = safe(C_EventScheduler and C_EventScheduler.HasData) and true or false,
			ongoing = ongoing,
			upcoming = upcoming,
		}
	end

	local prefix = "|cffffcc00MH event-spy:|r"
	print(prefix)
	print(("  scheduler-data aanwezig: %s · speler-map %s")
		:format(
			tostring(ns.db and ns.db.eventSpy and ns.db.eventSpy.hasData),
			tostring(ns.db and ns.db.eventSpy and ns.db.eventSpy.playerMapID)
		))

	if #ongoing == 0 and #upcoming == 0 then
		print("  geen events zichtbaar — sta je in/ bij Midnight-content? Probeer opnieuw na een paar seconden (de scheduler laadt async).")
		return
	end

	if #ongoing > 0 then
		print("  |cff66ff66NU bezig:|r")
		for _, e in ipairs(ongoing) do
			print(("    %s  ·  zone %s  ·  uiMap %s  ·  nog %s")
				:format(
					tostring(e.name or "?"),
					tostring(e.zoneName or "?"),
					tostring(e.uiMapID or "?"),
					e.secondsLeft and fmtMins(e.secondsLeft) or "—"
				))
		end
	end

	if #upcoming > 0 then
		print("  |cffffcc00KOMT eraan (24u):|r")
		for _, e in ipairs(upcoming) do
			print(("    %s  ·  zone %s  ·  uiMap %s  ·  over %s")
				:format(
					tostring(e.name or "?"),
					tostring(e.zoneName or "?"),
					tostring(e.uiMapID or "?"),
					fmtMins(e.inSeconds)
				))
		end
	end

	print("  (snapshot opgeslagen in MidnightHelperDB.eventSpy — blijft na /reload bewaard.)")
end

------------------------------------------------------------------ Lifecycle
-- Ticker starten zodra we in de wereld zijn; eenmalig RequestEvents zodat de
-- scheduler-data binnenkomt. Alles in pcall — nooit een fout naar buiten.
local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:SetScript("OnEvent", function()
	pcall(function()
		if C_EventScheduler and C_EventScheduler.RequestEvents then
			C_EventScheduler.RequestEvents()
		end
	end)
	if not ns._eventSchedulerTicker and C_Timer and C_Timer.NewTicker then
		ns._eventSchedulerTicker = C_Timer.NewTicker(POLL, function()
			pcall(rescan)
		end)
		pcall(rescan)
	end
end)
