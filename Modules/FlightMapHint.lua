local _, ns = ...

--[[
	Midnight Helper — name the stop to take, ON the flight map.

	⚠️ WHY NOT A CHAT LINE. This is the third time today the same lesson arrived: the
	route already printed "Fly from The Royal Exchange to Tokka's Landing" and Rob's
	verdict was "weer een tekst in de chat die niemand ziet". He is right, and more so
	here than anywhere else — at the moment that line matters you are looking at a map
	covered in identical dots, not at your chat frame.

	His own suggestion is the design: put it where Zygor puts it, on the flight map.

	⚠️ IT ONLY DRAWS. No node is selected, nothing is clicked, no taxi is taken. Taking
	a flight is the player's decision and TakeTaxiNode is not ours to call — this reads
	the node list and puts a label on the frame, which is the whole feature.

	Blizzard_FlightMap loads on demand, so the hook waits for it rather than assuming
	FlightMapFrame exists at login.
]]

local banner

local function EnsureBanner(parent)
	if banner then
		return banner
	end
	local f = CreateFrame("Frame", nil, parent, "BackdropTemplate")
	f:SetPoint("TOP", parent, "TOP", 0, -4)
	f:SetSize(420, 34)
	f:SetFrameStrata("HIGH")
	f:EnableMouse(false) -- never eat a click meant for a node
	f:SetBackdrop({
		bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background-Dark",
		edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
		tile = true, tileSize = 16, edgeSize = 12,
		insets = { left = 3, right = 3, top = 3, bottom = 3 },
	})
	f:SetBackdropColor(0, 0, 0, 0.9)
	f:SetBackdropBorderColor(1, 0.82, 0.3, 1)
	local fs = f:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
	fs:SetPoint("CENTER")
	fs:SetWidth(400)
	fs:SetJustifyH("CENTER")
	f._text = fs
	banner = f
	return f
end

--- Does the taxi map actually offer that stop right now?
---
--- ⚠️ Checked rather than assumed. Our flight-point table says a stop exists in a zone;
--- it cannot know whether this character has discovered it. Naming a node that is not
--- on the map — or is greyed out — would send someone hunting for a dot that is not
--- there, which is worse than saying nothing.
--- @return boolean|nil onMap, boolean|nil reachable
local function NodeState(wanted)
	if not (C_TaxiMap and C_TaxiMap.GetAllTaxiNodes) then
		return nil, nil
	end
	local ok, nodes = pcall(C_TaxiMap.GetAllTaxiNodes)
	if not ok or type(nodes) ~= "table" then
		return nil, nil
	end
	for _, n in ipairs(nodes) do
		if type(n.name) == "string" and n.name == wanted then
			local st = n.state
			-- Enum.FlightPathState: Current = 0, Reachable = 1, Unreachable = 2.
			-- Compared by value because the enum has been renamed before; a nil state
			-- counts as reachable rather than hiding a stop over a missing field.
			return true, (st == nil or st ~= 2)
		end
	end
	return false, false
end

--- ⚠️ HIGHLIGHT THE PIN, not just name it. Rob, 16 aug, looking at a flight map of the
--- whole Eastern Kingdoms: "konden wij niet aanwijzen waar ie naar toe moet vliegen?"
--- Naming a stop and leaving him to find it among a hundred identical dots is half the
--- job — the same half-answer as telling someone to fly and pointing the arrow at the
--- destination instead of the flight master.
---
--- The canvas hands out its own pins, so we borrow the one that is already there rather
--- than drawing a second dot in the wrong place. Everything is guarded: the template
--- name is Blizzard's and could change, and a missing highlight must never break the
--- map itself.
local glow

--- ⚠️ VIA THE DATA PROVIDER, not EnumeratePinsByTemplate. The first attempt guessed the
--- template name "FlightMap_FlightPointPinTemplate" and lit nothing; Rob said plainly
--- that Zygor manages it, so I read how instead of guessing again.
---
--- Their route (LibTaxi-1.0.lua): walk FlightMapFrame.dataProviders for the one that
--- has AddFlightNode, then use its `slotIndexToPin` table. Every pin there carries
--- `taxiNodeData` with name, nodeID and state. That is shipping code in an addon this
--- player already runs, which beats a template name I remembered.
local function FlightPinsByProvider(frame)
	if not (frame and type(frame.dataProviders) == "table") then
		return nil
	end
	for provider in pairs(frame.dataProviders) do
		if type(provider) == "table" and provider.AddFlightNode
			and type(provider.slotIndexToPin) == "table" then
			return provider.slotIndexToPin
		end
	end
	return nil
end

local function HighlightPin(frame, wanted)
	if glow then
		glow:Hide()
	end
	if not wanted then
		return false
	end
	local pins = FlightPinsByProvider(frame)
	if not pins then
		return false
	end
	for _, pin in pairs(pins) do
		local data = pin and pin.taxiNodeData
		if type(data) == "table" and data.name == wanted then
			if not glow then
				glow = UIParent:CreateTexture(nil, "OVERLAY")
				glow:SetTexture("Interface\\Cooldown\\star4")
				glow:SetBlendMode("ADD")
				glow:SetVertexColor(1, 0.85, 0.2, 0.9)
			end
			glow:SetParent(pin)
			glow:ClearAllPoints()
			glow:SetPoint("CENTER", pin, "CENTER", 0, 0)
			glow:SetSize(44, 44)
			glow:Show()
			return true
		end
	end
	return false
end

local function Refresh(parent)
	local stop, destination = ns.GetPendingFlightStop and ns.GetPendingFlightStop()
	if not stop then
		if banner then
			banner:Hide()
		end
		if glow then
			glow:Hide()
		end
		return
	end
	local f = EnsureBanner(parent)
	local onMap, reachable = NodeState(stop)

	if onMap == false then
		-- The stop is in our data but not on this character's map: undiscovered, or our
		-- data is wrong about the zone. Either way, say so instead of pointing at air.
		f._text:SetText((ns:L("FLIGHTMAP_NOT_FOUND")):format(stop))
		f._text:SetTextColor(1, 0.82, 0.3)
	elseif onMap and not reachable then
		f._text:SetText((ns:L("FLIGHTMAP_UNREACHABLE")):format(stop))
		f._text:SetTextColor(1, 0.55, 0.4)
	else
		-- ⚠️ Never print "?" as a destination. Rob's banner read "then on to ?." because
		-- the waypoint carried a name that had not resolved. A question mark tells the
		-- player nothing and looks like a fault in the addon; naming only the stop is
		-- less information and entirely true.
		local dest = destination
		if type(dest) ~= "string" or dest == "" or dest == "?" then
			dest = nil
		end
		-- ⚠️ The wording FOLLOWS the highlight, it does not promise it. The first
		-- version said "it is marked on the map" whether or not anything had been
		-- marked, and Rob's screenshot showed exactly that: a confident sentence over
		-- an unmarked map. A line that describes something the player cannot see is
		-- worse than the plain one.
		local marked = HighlightPin(parent, stop)
		if not marked and C_Timer and C_Timer.After then
			-- Pins exist only once the canvas has laid itself out, so try again a beat
			-- later and upgrade the wording if it works then.
			C_Timer.After(0.3, function()
				if parent and parent:IsShown() and HighlightPin(parent, stop) and dest then
					f._text:SetText((ns:L("FLIGHTMAP_TAKE")):format(stop, dest))
				end
			end)
		end
		if dest and marked then
			f._text:SetText((ns:L("FLIGHTMAP_TAKE")):format(stop, dest))
		elseif dest then
			f._text:SetText((ns:L("FLIGHTMAP_TAKE_UNMARKED")):format(stop, dest))
		elseif marked then
			f._text:SetText((ns:L("FLIGHTMAP_TAKE_ONLY")):format(stop))
		else
			f._text:SetText((ns:L("FLIGHTMAP_TAKE_BARE")):format(stop))
		end
		f._text:SetTextColor(0.5, 1, 0.5)

		-- ⚠️ Diagnostic, because guessing why the pin does not light has failed twice.
		-- Tokka's Landing is on the Coiled Isle while Rob was looking at Eastern
		-- Kingdoms, so the pin may simply not exist on that canvas — a different
		-- problem from a wrong lookup, and only the list of what IS there can tell
		-- them apart. `/mh flightpins` prints it.
		local pins = FlightPinsByProvider(parent)
		local names = {}
		for _, pin in pairs(pins or {}) do
			local d = pin and pin.taxiNodeData
			if type(d) == "table" and type(d.name) == "string" then
				names[#names + 1] = d.name
			end
		end
		ns.db = ns.db or {}
		ns.db.flightPins = { wanted = stop, marked = marked, found = #names, names = names }
	end
	f:Show()
end

--- /mh flightpins — what the flight map actually offered, last time it was open.
function ns.PrintFlightPins()
	local prefix = ("|cffffcc00%s|r"):format((ns.L and ns:L("PRINT_PREFIX")) or "MH")
	local d = ns.db and ns.db.flightPins
	if type(d) ~= "table" then
		print(("%s open a flight master first, then run this."):format(prefix))
		return
	end
	print(("%s flight map: wanted |cffffffff%s|r, marked = %s, %d pins on that canvas"):format(
		prefix, tostring(d.wanted), tostring(d.marked), d.found or 0))
	for i, n in ipairs(d.names or {}) do
		print(("   %2d  %s"):format(i, n))
	end
	if (d.found or 0) == 0 then
		print("   |cffffd100No pins at all — the lookup is wrong, not the map.|r")
	end
end

local loader = CreateFrame("Frame")
loader:RegisterEvent("ADDON_LOADED")
loader:RegisterEvent("PLAYER_LOGIN")
loader:SetScript("OnEvent", function(self, event, arg1)
	if event == "ADDON_LOADED" and arg1 ~= "Blizzard_FlightMap" then
		return
	end
	local frame = _G.FlightMapFrame
	if not frame or frame._mhHooked then
		return
	end
	frame._mhHooked = true
	frame:HookScript("OnShow", function(self2)
		Refresh(self2)
	end)
	frame:HookScript("OnHide", function()
		if banner then
			banner:Hide()
		end
		if glow then
			glow:Hide()
		end
	end)
	-- Already open when the addon loaded (a /reload at the flight master).
	if frame:IsShown() then
		Refresh(frame)
	end
end)
