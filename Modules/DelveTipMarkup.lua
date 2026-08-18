--[[
	Midnight Helper — {SPELL:id} / {SPELL:@token} / {ITEM:id} markup for Delve Coach text.
]]

local _, ns = ...

-- Tier-1 visuele rust: rustiger link-tinten (de felle item-groen 1eff00 en
-- currency-geel ffd200 waren de luidste pixels). Spell blijft het vertrouwde
-- blauw; item wordt zacht-groen, currency het palet-goud.
local SPELL_LINK_COLOR = "71d5ff"
local ITEM_LINK_COLOR = "9ccf8a"
local CURRENCY_LINK_COLOR = "e8c36a"

function ns:GetSpellLinkMarkup(spellID, fallbackLabel)
	spellID = tonumber(spellID)
	if not spellID then
		return fallbackLabel or "?"
	end
	local name = fallbackLabel
	if C_Spell and C_Spell.GetSpellName then
		local n = C_Spell.GetSpellName(spellID)
		if n and n ~= "" then
			name = n
		end
	end
	if (not name or name == "") and C_Spell and C_Spell.GetSpellInfo then
		local ok, info = pcall(C_Spell.GetSpellInfo, spellID)
		if ok and info and info.name and info.name ~= "" then
			name = info.name
		end
	end
	if not name or name == "" then
		name = "Spell " .. tostring(spellID)
	end
	name = name:gsub("|", "||")
	return ("|cff%s|Hspell:%d|h[%s]|h|r"):format(SPELL_LINK_COLOR, spellID, name)
end

function ns:GetItemLinkMarkup(itemID, fallbackLabel)
	itemID = tonumber(itemID)
	if not itemID then
		return fallbackLabel or "?"
	end
	local name = fallbackLabel
	if C_Item and C_Item.GetItemNameByID then
		local n = C_Item.GetItemNameByID(itemID)
		if n and n ~= "" then
			name = n
		end
	end
	if not name or name == "" then
		name = "Item " .. tostring(itemID)
	end
	name = name:gsub("|", "||")
	return ("|cff%s|Hitem:%d|h[%s]|h|r"):format(ITEM_LINK_COLOR, itemID, name)
end

function ns:GetCurrencyLinkMarkup(currencyID, fallbackLabel)
	currencyID = tonumber(currencyID)
	if not currencyID then
		return fallbackLabel or "?"
	end
	-- Prefer the game's own (localized) currency link.
	if C_CurrencyInfo and C_CurrencyInfo.GetCurrencyLink then
		local ok, link = pcall(C_CurrencyInfo.GetCurrencyLink, currencyID, 0)
		if ok and type(link) == "string" and link ~= "" then
			return link
		end
	end
	local name = fallbackLabel
	if (not name or name == "") and C_CurrencyInfo and C_CurrencyInfo.GetCurrencyInfo then
		local ok, info = pcall(C_CurrencyInfo.GetCurrencyInfo, currencyID)
		if ok and info and info.name and info.name ~= "" then
			name = info.name
		end
	end
	if not name or name == "" then
		name = "Currency " .. tostring(currencyID)
	end
	name = name:gsub("|", "||")
	return ("|cff%s|Hcurrency:%d|h[%s]|h|r"):format(CURRENCY_LINK_COLOR, currencyID, name)
end

function ns:ExpandDelveTipMarkup(text)
	if type(text) ~= "string" or text == "" then
		return text
	end

	text = text:gsub("{SPELL:(%d+)}", function(id)
		return self:GetSpellLinkMarkup(tonumber(id))
	end)

	text = text:gsub("{SPELL:@([%w_]+)}", function(token)
		local key = token:lower()
		local id = self.DELVE_SPELL_IDS and self.DELVE_SPELL_IDS[key]
		if id then
			return self:GetSpellLinkMarkup(id)
		end
		local label = self.DELVE_SPELL_FALLBACK and self.DELVE_SPELL_FALLBACK[key]
		if label then
			return label
		end
		return (token:gsub("_", " "))
	end)

	text = text:gsub("{ITEM:(%d+)}", function(id)
		return self:GetItemLinkMarkup(tonumber(id))
	end)

	text = text:gsub("{CURRENCY:(%d+)}", function(id)
		return self:GetCurrencyLinkMarkup(tonumber(id))
	end)

	-- {WAY:mapID:x:y:Label} → klikbare TomTom-waypoint-link.
	text = text:gsub("{WAY:(%d+):([%d%.]+):([%d%.]+):([^}]+)}", function(m, x, y, label)
		return self:GetWayLinkMarkup(m, x, y, label)
	end)

	-- Bekende vendor-namen automatisch klikbaar maken (addon-breed).
	if self.LinkifyVendors then
		text = self:LinkifyVendors(text)
	end

	if ns.SanitizeUIFontText then
		text = ns.SanitizeUIFontText(text)
	end

	return text
end

--------------------------------------------------------------------------------
-- Waypoint-links (Rob-wens 16 jun): vendor/NPC-namen klikbaar → TomTom-waypoint.
-- Eén centrale registry + auto-linkify, zodat élke tekst die een bekende naam
-- noemt 'm vanzelf klikbaar maakt — geen per-tekst-aanpassing nodig.
--------------------------------------------------------------------------------

local WAY_LINK_COLOR = "8fc9e8"

-- naam → { uiMapID, x, y }. Coords: SMC City Guide + QM-research (16 jun) —
-- "bevestig in-game". PvP-vendors delen het PvP-hub-punt (bij Falconwing Square).
ns.VENDOR_WAYPOINTS = {
	["Maren Silverwing"] = { 2393, 48.11, 49.10 },
	["Triam Dawnsetter"] = { 2393, 48.11, 49.10 },
	-- Ritual Sites renown-vendors, 2e verdieping van The Bazaar (web-bronnen
	-- 20 jun: skycoach/wowcarry; "bevestig in-game"). Rae'ana = decor (rank 3) +
	-- Dark Obelisk (rank 7); Sergeant Vornin = pets (rank 6) + Void-Touched
	-- Hawkstrider-mount (rank 8).
	["Rae'ana"] = { 2393, 47.60, 50.60 },
	["Sergeant Vornin"] = { 2393, 48.60, 50.60 },
	-- Matrix Catalyst-steward (ontgrendelt de catalyst via quest 93687 "Taste
	-- True Power"); Wowhead 9 jun: /way #2393 40.6 64.6 (neutrale catalyst).
	["Eldara Dawnrunner"] = { 2393, 40.60, 64.60 },
	["Cuzoth"] = { 2393, 48.23, 61.75 },
	["Vaskarn"] = { 2393, 48.28, 61.75 },
	["Caeris Fairdawn"] = { 2395, 43.46, 47.42 },
	["Magovu"] = { 2437, 45.95, 65.92 },
	["Naynar"] = { 2413, 50.99, 50.75 },
	["Void Researcher Anomander"] = { 2405, 52.57, 72.89 },
	["Captain Dawnrunner"] = { 2393, 34.66, 81.10 },
	["Irissa Bloodstar"] = { 2393, 34.66, 81.10 },
	["Knight-Lord Bloodvalor"] = { 2393, 34.66, 81.10 },
	["Soryn"] = { 2393, 34.66, 81.10 },
}

function ns:GetWayLinkMarkup(mapID, x, y, label)
	mapID, x, y = tonumber(mapID), tonumber(x), tonumber(y)
	label = tostring(label or "?")
	if not (mapID and x and y) then
		return label
	end
	local safe = label:gsub("|", "||")
	return ("|cff%s|Hmhway:%d:%.2f:%.2f:%s|h[%s]|h|r"):format(WAY_LINK_COLOR, mapID, x, y, safe, safe)
end

--- Zeg wát er gebeurd is na een coördinaat-klik.
---
--- ⚠️ TOEGEVOEGD 15 aug 2026. Rob klikte in Silvermoon op een Vaults-coördinaat en
--- kreeg niets: geen pijl, geen melding, geen fout. Dat is de slechtste uitkomst die
--- er is — een knop die niets doet is niet te onderscheiden van een kapotte knop, en
--- de speler heeft geen enkele aanwijzing wat hij verkeerd deed. Hij deed niets
--- verkeerd; hij stond alleen 300 meter en een zone verderop.
---
--- Deze regel verschijnt daarom ALTIJD na een klik. Drie gevallen:
---   1. je staat op dezelfde kaart  → korte bevestiging
---   2. je staat ergens anders      → plus waar je heen moet
---   3. de kaart accepteert geen Blizzard-pin en je hebt geen TomTom → zeg dat,
---      want dán is er echt geen pijl en dat is niet onze schuld maar wel onze
---      verantwoordelijkheid om te melden.
---
--- Geval 3 is precies wat er in de Vaults speelt: instanced kaarten weigeren vaak
--- `C_Map.SetUserWaypoint`, en die aanroep zit in een pcall — dus hij faalt stil.
function ns.ReportWaypointResult(mapID, label, targetX, targetY)
	mapID = tonumber(mapID)
	if not mapID then
		return
	end
	local prefix = ("|cffffcc00%s|r"):format((ns.L and ns:L("PRINT_PREFIX")) or "MH")
	local name = tostring(label or "?")

	local function zoneName(id)
		if id and C_Map and C_Map.GetMapInfo then
			local ok, info = pcall(C_Map.GetMapInfo, id)
			if ok and type(info) == "table" and info.name and info.name ~= "" then
				return info.name
			end
		end
		return nil
	end

	local here
	if C_Map and C_Map.GetBestMapForUnit then
		local ok, m = pcall(C_Map.GetBestMapForUnit, "player")
		here = ok and m or nil
	end
	local targetZone = zoneName(mapID)
	local hereZone = zoneName(here)

	-- Kan het spel hier überhaupt een pin zetten, als TomTom ontbreekt?
	local tomtom = ns.IsTomTomReady and ns.IsTomTomReady()
	local canPin = true
	if not tomtom and C_Map and C_Map.CanSetUserWaypointOnMap then
		local ok, v = pcall(C_Map.CanSetUserWaypointOnMap, mapID)
		canPin = (not ok) or (v ~= false)
	end

	if not canPin then
		print(("%s %s"):format(prefix, (ns:L("WAY_NO_PIN")):format(name, targetZone or mapID)))
		return
	end

	if here and here ~= mapID and targetZone then
		print(("%s %s"):format(prefix,
			(ns:L("WAY_SET_ELSEWHERE")):format(name, targetZone, hereZone or "?")))
		-- And answer the question that line leaves open: how do I get there?
		-- The nearest flight point ON THE TARGET MAP, from Zygor's fpath data.
		if ns.GetNearestFlightPoint then
			local fp = ns.GetNearestFlightPoint(mapID, targetX, targetY)
			if fp then
				print(("   %s"):format((ns:L("WAY_FLIGHT_HINT")):format(fp)))
			end
		end
	else
		print(("%s %s"):format(prefix, (ns:L("WAY_SET_HERE")):format(name)))
	end
end

--- Just the "how do I get there" half, for callers that set their own waypoint.
---
--- ⚠️ Split out of ReportWaypointResult on 16 aug. That function also prints "waypoint
--- set in X while you are in Y", which is right for a text link you just clicked and
--- noise for a route button that already shows an arrow. A route needs the travel
--- advice without the confirmation, so the two are now separable rather than one being
--- copied into the other.
---
--- Says nothing when you are already on the target map: standing in the zone, the
--- nearest flight point is not the answer to anything.
function ns.ReportTravelHintForWaypoint(mapID, label, x, y, currentMap)
	mapID = tonumber(mapID)
	if not mapID or not ns.GetNearestFlightPoint then
		return
	end
	if currentMap and tonumber(currentMap) == mapID then
		return
	end
	local fp = ns.GetNearestFlightPoint(mapID, x, y)
	if not fp then
		-- No flight point in our data for that zone. Silence is correct here: inventing
		-- travel advice for a place we have not mapped is how someone flies the wrong
		-- way with confidence.
		return
	end

	-- ⚠️ NAME WHERE YOU LEAVE FROM TOO. Rob, 16 aug: "ik sta letterlijk naast Anathos"
	-- while the hint told him about a flight point on the island. Both halves were in
	-- our own data — The Royal Exchange is in FLIGHT_POINTS[2393] — and the message
	-- only ever asked about the destination. Telling someone standing at a flight
	-- master where to land is answering the second half of their question.
	local from
	if currentMap and C_Map and C_Map.GetPlayerMapPosition then
		local okP, pos = pcall(C_Map.GetPlayerMapPosition, tonumber(currentMap), "player")
		if okP and pos and pos.GetXY then
			local okXY, px, py = pcall(pos.GetXY, pos)
			if okXY and px then
				from = ns.GetNearestFlightPoint(tonumber(currentMap), px * 100, py * 100)
			end
		end
		-- No position: still worth asking for the zone's flight point without one, so
		-- a loading screen does not silently drop half the advice.
		from = from or ns.GetNearestFlightPoint(tonumber(currentMap))
	end

	local prefix = ("|cffffcc00%s|r"):format((ns.L and ns:L("PRINT_PREFIX")) or "MH")
	if from and from ~= fp then
		print(("%s %s"):format(prefix, (ns:L("WAY_FLIGHT_FROM_TO")):format(from, fp)))
	else
		print(("%s %s"):format(prefix, (ns:L("WAY_FLIGHT_HINT")):format(fp)))
	end
end

--------------------------------------------------------------------------------
-- Two-leg travel: the flight master first, the destination after
--------------------------------------------------------------------------------

--- ⚠️ SAYING THE ROUTE IS NOT THE SAME AS POINTING AT IT. Rob, 16 aug, still in
--- Silvermoon: the line read "Fly from The Royal Exchange to Tokka's Landing" and the
--- arrow went on pointing 8 km across the sea. Advice and arrow disagreed, and the
--- arrow is the thing you follow.
---
--- So a trip that needs a flight becomes two legs. Leg one is the flight master you can
--- actually walk to; leg two is the real destination, taken up automatically once you
--- land on the target map.
---
--- Deliberately conservative. It only takes over when the destination is on a DIFFERENT
--- map, a usable flight point exists on the map you are standing on, and the two are not
--- the same stop. Anything else keeps the old single-leg behaviour: a player who wants
--- to walk, or has a portal, must not be steered to an airport.
local pendingLeg, legWatcher

--- The stop the player should click on the flight map, or nil when no flight is
--- pending. Read by FlightMapHint.lua.
function ns.GetPendingFlightStop()
	return pendingLeg and pendingLeg.toName or nil, pendingLeg and pendingLeg.name or nil
end

local function ClearLeg()
	pendingLeg = nil
	if legWatcher then
		legWatcher:Cancel()
		legWatcher = nil
	end
end
ns.ClearTravelLeg = ClearLeg

local function ArrivedOnTargetMap()
	if not (pendingLeg and C_Map and C_Map.GetBestMapForUnit) then
		return false
	end
	local ok, here = pcall(C_Map.GetBestMapForUnit, "player")
	if not ok or not here then
		return false
	end
	if here == pendingLeg.mapID then
		return true
	end

	--- ⚠️ THE SAME SUB-ZONE MISTAKE, ONE LAYER DOWN — and I fixed the other one and
	--- left this. Rob, 18 aug: the arrow reached "Flight master: Amani Foothold, 33m
	--- away" and flipped back to the destination about two seconds later. That is this
	--- ticker's 1.5s beat: standing in the Vaults with a leg aimed at the isle,
	--- MHSameZoneOrSub said the Vaults are part of the isle, so the leg counted itself
	--- as arrived before he had taken a step.
	---
	--- Parentage is the wrong question here too. The test that matters is the one now
	--- used to START a leg: if the flight point nearest you is the leg's own
	--- destination flight point, you are in that travel neighbourhood and the leg is
	--- done. If it is a different flight point — Amani Foothold against Tokka's
	--- Landing — you have not arrived, whatever the map tree says.
	---
	--- Same criterion at both ends, which is what stops the two from disagreeing again.
	if pendingLeg.toName and ns.GetNearestFlightPoint then
		local okF, hereFp = pcall(ns.GetNearestFlightPoint, here)
		if okF and type(hereFp) == "string" and hereFp == pendingLeg.toName then
			return true
		end
	end
	return false
end

--- @return boolean true when the arrow was sent to a flight master instead
function ns.RouteFirstToFlightPoint(targetMap, x, y, name, currentMap)
	targetMap, currentMap = tonumber(targetMap), tonumber(currentMap)
	if not (targetMap and currentMap) or targetMap == currentMap then
		return false
	end
	if ns._mhTravelLegBusy or not ns.GetNearestFlightPoint then
		return false -- re-entry: leg one sets its own waypoint through the same call
	end
	--- ⚠️ REMOVED 18 aug: a bail-out on "same zone or sub-zone".
	---
	--- Rob, standing in the Vaults with a delve on the isle above him: "ik wil gewoon
	--- de pijl naar de FP in de vault." He could not have it, because the Vaults are a
	--- child map of The Coiled Isle and this check treated the pair as one place.
	---
	--- The rule was reasonable and wrong: you do not normally fly within a zone, but
	--- these two each have their own flight point and flying between them is the
	--- intended way around. Parentage was never the question.
	---
	--- The real test was already two lines below and still is — `fromName == toName`.
	--- If the flight point nearest you IS the one nearest the target, flying achieves
	--- nothing and we say nothing; if they differ, it helps, whatever the map tree
	--- says about who contains whom. One check, doing the job the other only
	--- approximated.
	--- (`ns.MHSameZoneOrSub` stays — other callers use it for what it actually means.)
	-- Already on a taxi: sending the arrow to the flight master you just left would be
	-- the exact bug this file spent the afternoon fixing.
	if UnitOnTaxi then
		local okT, v = pcall(UnitOnTaxi, "player")
		if okT and v then
			return false
		end
	end

	local px, py
	if C_Map and C_Map.GetPlayerMapPosition then
		local okP, pos = pcall(C_Map.GetPlayerMapPosition, currentMap, "player")
		if okP and pos and pos.GetXY then
			local okXY, a, b = pcall(pos.GetXY, pos)
			if okXY and a then
				px, py = a * 100, b * 100
			end
		end
	end
	--- ⚠️ THE PLAN OUTRANKS THE FLIGHT HEURISTIC. Rob, 18 aug: standing 90 metres from
	--- a Vault gate and asking for the Underbelly, he was sent to Tokka's Landing — a
	--- kilometre away — because this function only knows about flight points and the
	--- gate is not one.
	---
	--- A door on the map you are standing on always beats flying somewhere. So if the
	--- travel plan has a first step here, say nothing and let the plan lead. The
	--- heuristic is for when there is no door to use.
	if ns.BuildTravelPlan then
		local okP, steps = pcall(ns.BuildTravelPlan, targetMap, x, y, name)
		if okP and type(steps) == "table" then
			for _, s in ipairs(steps) do
				if s.kind ~= "arrive" and s.mapID == currentMap and s.x and s.y then
					return false
				end
				-- Only the FIRST step counts. A later step on this map means you come
				-- back through here, which is not a reason to skip the flight.
				if s.kind ~= "arrive" then
					break
				end
			end
		end
	end

	local fromName, fx, fy = ns.GetNearestFlightPoint(currentMap, px, py)
	local toName = ns.GetNearestFlightPoint(targetMap, x, y)
	if not (fromName and fx and fy and toName) or fromName == toName then
		return false
	end

	-- toName is kept so the flight map can name the stop to click. A chat line telling
	-- you which node to take is read by nobody at the moment they are staring at a map
	-- full of dots (Rob, 16 aug).
	pendingLeg = { mapID = targetMap, x = x, y = y, name = name, toName = toName }
	ns._mhTravelLegBusy = true
	ns.AddSmartTomTomWay(currentMap, fx, fy,
		(ns:L("WAY_LEG_TO_FLIGHT")):format(fromName), true, false, false, 0)
	ns._mhTravelLegBusy = nil

	if C_Timer and C_Timer.NewTicker then
		if legWatcher then
			legWatcher:Cancel()
		end
		-- ⚠️ 1.5s, not 3. The interval is how long a stale arrow survives, and the whole
		-- point of leg one is that the arrow tells the truth.
		legWatcher = C_Timer.NewTicker(1.5, function()
			if not pendingLeg then
				ClearLeg()
				return
			end
			-- ⚠️ BOARDING ENDS LEG ONE, not landing. Rob, 16 aug: on the taxi the arrow
			-- kept pointing back at The Royal Exchange, a flight master he was sitting
			-- on top of. Once you are on the bird that leg is finished by definition —
			-- there is nothing left to walk to — so hand the arrow to the destination
			-- now rather than at the far end. It also makes the flight itself useful:
			-- you can see where you are going while you go there.
			local onTaxi = false
			if UnitOnTaxi then
				local okT, v = pcall(UnitOnTaxi, "player")
				onTaxi = okT and v or false
			end
			if not (onTaxi or ArrivedOnTargetMap()) then
				return
			end
			local leg = pendingLeg
			ClearLeg()
			-- Leg two. Busy-flag set so this does not decide it needs a flight again
			-- the moment it lands.
			ns._mhTravelLegBusy = true
			ns.AddSmartTomTomWay(leg.mapID, leg.x, leg.y, leg.name, true, false, false, 0)
			ns._mhTravelLegBusy = nil
			print(("|cffffcc00%s|r %s"):format((ns.L and ns:L("PRINT_PREFIX")) or "MH",
				(ns:L("WAY_LEG_ARRIVED")):format(tostring(leg.name or "?"))))
		end)
	end
	return true
end

function ns:SetMapWaypoint(mapID, x, y, label)
	mapID, x, y = tonumber(mapID), tonumber(x), tonumber(y)
	if not (mapID and x and y) then
		return
	end
	-- ⚠️ 15 aug 2026, Robs vraag vanaf zijn vliegroute: "we hebben toch zelf een
	-- pijl, ook zonder TomTom?" Ja — en deze klik liep eromheen. AddSmartTomTomWay
	-- is wat élke routeknop gebruikt: TomTom als die er is, anders Blizzard-pin met
	-- SuperTrack, plus de Travel Assistant die meteen zegt hoe je er kómt (portal,
	-- hearthstone). De kale fallback hieronder blijft alleen voor het geval de
	-- Delves-module niet geladen is.
	if ns.AddSmartTomTomWay and ns.AddSmartTomTomWay(mapID, x, y, label) ~= false then
		ns.ReportWaypointResult(mapID, label, x, y)
		return
	end
	if C_AddOns and C_AddOns.LoadAddOn and C_AddOns.IsAddOnLoaded and not C_AddOns.IsAddOnLoaded("TomTom") then
		pcall(C_AddOns.LoadAddOn, "TomTom")
	end
	local slashWay = SlashCmdList and SlashCmdList["TOMTOM_WAY"]
	if type(slashWay) == "function" then
		pcall(slashWay, ("#%d %.2f %.2f %s"):format(mapID, x, y, label or "Waypoint"))
		return
	end
	if C_Map and C_Map.SetUserWaypoint and UiMapPoint and UiMapPoint.CreateFromCoordinates then
		local p = UiMapPoint.CreateFromCoordinates(mapID, x / 100, y / 100)
		if pcall(C_Map.SetUserWaypoint, p) and C_SuperTrack and C_SuperTrack.SetSuperTrackedUserWaypoint then
			pcall(C_SuperTrack.SetSuperTrackedUserWaypoint, true)
		end
	end
end

local function EscapeLuaPattern(s)
	return (s:gsub("([%(%)%.%%%+%-%*%?%[%]%^%$])", "%%%1"))
end

-- Wikkel bekende vendor-namen in een klikbare waypoint-link.
function ns:LinkifyVendors(text)
	if type(text) ~= "string" or text == "" or not ns.VENDOR_WAYPOINTS then
		return text
	end
	for name, w in pairs(ns.VENDOR_WAYPOINTS) do
		local link = self:GetWayLinkMarkup(w[1], w[2], w[3], name)
		text = text:gsub(EscapeLuaPattern(name), (link:gsub("%%", "%%%%")))
	end
	return text
end

local function ShowDelveTipHyperlinkTooltip(owner, linkData)
	local gt = _G.GameTooltip
	if not gt or not gt.SetOwner or not linkData then
		return
	end
	gt:SetOwner(owner, "ANCHOR_CURSOR")
	gt:ClearLines()
	local kind, payload = linkData:match("^([^:]+):(.+)$")
	if not kind then
		return
	end
	if kind == "mhway" then
		local label = payload:match(":([^:]+)$") or "Waypoint"
		gt:AddLine(label, 0.91, 0.76, 0.42)
		gt:AddLine("Klik = waypoint (TomTom)", 0.62, 0.64, 0.68)
		gt:Show()
		return
	end
	pcall(function()
		local hyperlink = linkData
		if kind == "spell" or kind == "item" then
			hyperlink = kind .. ":" .. tostring(payload)
		end
		if gt.SetHyperlink and hyperlink then
			gt:SetHyperlink(hyperlink)
		elseif kind == "spell" then
			local spellID = tonumber(payload)
			if spellID and gt.SetSpellByID then
				gt:SetSpellByID(spellID)
			end
		elseif kind == "currency" then
			local currencyID = tonumber((payload:match("^(%d+)")))
			if currencyID and gt.SetCurrencyByID then
				gt:SetCurrencyByID(currencyID)
			end
		end
	end)
	gt:Show()
end

--- Read-only EditBox: spell links respond to hover (FontString hyperlinks fail inside ScrollFrames).
function ns:AttachDelveTipHyperlinksToEditBox(editBox)
	if not editBox or editBox._mhDelveTipHyperlinkHooked then
		return
	end
	editBox._mhDelveTipHyperlinkHooked = true
	editBox:SetAutoFocus(false)
	editBox:EnableMouse(true)
	if editBox.SetTextInsets then
		editBox:SetTextInsets(4, 4, 4, 4)
	end
	if editBox.SetHyperlinksEnabled then
		editBox:SetHyperlinksEnabled(true)
	end

	editBox:SetScript("OnHyperlinkEnter", function(self, linkData)
		ShowDelveTipHyperlinkTooltip(self, linkData)
	end)
	editBox:SetScript("OnHyperlinkLeave", function()
		if _G.GameTooltip and _G.GameTooltip.Hide then
			_G.GameTooltip:Hide()
		end
	end)
	editBox:SetScript("OnHyperlinkClick", function(self, linkData)
		local mapID, x, y, label = linkData:match("^mhway:(%d+):([%d%.]+):([%d%.]+):(.+)$")
		if mapID then
			ns:SetMapWaypoint(mapID, x, y, label)
			return
		end
		ShowDelveTipHyperlinkTooltip(self, linkData)
	end)
	editBox:SetScript("OnEditFocusGained", function(self)
		self:ClearFocus()
	end)
	editBox:SetScript("OnMouseDown", function(self)
		self:ClearFocus()
	end)
end

function ns:AttachDelveTipHyperlinks(hostFrame)
	ns:AttachDelveTipHyperlinksToEditBox(hostFrame)
end
