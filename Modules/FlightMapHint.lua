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

local function Refresh(parent)
	local stop, destination = ns.GetPendingFlightStop and ns.GetPendingFlightStop()
	if not stop then
		if banner then
			banner:Hide()
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
		f._text:SetText((ns:L("FLIGHTMAP_TAKE")):format(stop,
			tostring(destination or "?")))
		f._text:SetTextColor(0.5, 1, 0.5)
	end
	f:Show()
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
	end)
	-- Already open when the addon loaded (a /reload at the flight master).
	if frame:IsShown() then
		Refresh(frame)
	end
end)
