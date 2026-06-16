--[[
	Tier Set guide (Rob-wens 16 jun, 1.8.1). Twee niveaus:
	  1) algemene uitleg: wat tier sets zijn, hoe je ze krijgt, beginner-pad;
	  2) live: jouw class-set + 2/4-set-bonus als klikbare spell-links, plus een
	     teller "tier x/5 (2-set ✓ / 4-set ✗)" uit je uitgeruste slots.

	never-lie: de bonus-tekst komt uit de live spell-tooltip (hover), niet hard-
	gecodeerd; IDs zijn PTR-bevestigd → "bevestig in-game"-voet. De teller leest
	de set-piece-count uit de item-tooltip ("(n/5)") — taint-veilig, read-only.
]]

local _, ns = ...

local ui

--------------------------------------------------------------------------------
-- Spec-resolutie + live teller
--------------------------------------------------------------------------------

local function PlayerClassFile()
	return select(2, UnitClass("player"))
end

local function PlayerSpecID()
	if not (GetSpecialization and GetSpecializationInfo) then
		return nil
	end
	local idx = GetSpecialization()
	if not idx then
		return nil
	end
	return (GetSpecializationInfo(idx))
end

-- Aantal uitgeruste tier-stukken (0..5) uit de item-tooltip-setregel "(n/5)",
-- of nil als de API niet beschikbaar is / geen tier-stuk gedragen.
local function TierPiecesEquipped()
	if not (C_TooltipInfo and C_TooltipInfo.GetInventoryItem) then
		return nil
	end
	local sawAnyItem = false
	for _, slot in ipairs(ns.TIER_SLOTS or {}) do
		local data = C_TooltipInfo.GetInventoryItem("player", slot)
		if data and data.lines then
			sawAnyItem = true
			for _, line in ipairs(data.lines) do
				local t = line and line.leftText
				if t then
					local n = t:match("%((%d+)/5%)")
					if n then
						return tonumber(n)
					end
				end
			end
		end
	end
	-- Items gezien maar geen set-regel → 0 tier-stukken; anders onbekend.
	if sawAnyItem then
		return 0
	end
	return nil
end

local function SpellLink(id)
	if id and ns.GetSpellLinkMarkup then
		return ns:GetSpellLinkMarkup(id)
	end
	return "spell " .. tostring(id)
end

-- Gekleurd label (groen = actief, grijs = nog niet) — geen glyphs, dus geen
-- font-box-risico.
local function StatusLabel(label, active)
	return (active and "|cff73d873" or "|cff9aa0a8") .. label .. "|r"
end

--------------------------------------------------------------------------------
-- Body
--------------------------------------------------------------------------------

-- Creation Catalyst-locatie (zelfde als de SMC City Guide: Bazaar, Silvermoon 2393).
local CATALYST = { map = 2393, x = 40.31, y = 64.85 }

local function SetCatalystWaypoint()
	local name = ns:L("TIER_CATALYST_NAME")
	if C_AddOns and C_AddOns.LoadAddOn and C_AddOns.IsAddOnLoaded and not C_AddOns.IsAddOnLoaded("TomTom") then
		pcall(C_AddOns.LoadAddOn, "TomTom")
	end
	local slashWay = SlashCmdList and SlashCmdList["TOMTOM_WAY"]
	if type(slashWay) == "function" then
		pcall(slashWay, ("#%d %.2f %.2f %s"):format(CATALYST.map, CATALYST.x, CATALYST.y, name))
		return
	end
	if C_Map and C_Map.SetUserWaypoint and UiMapPoint and UiMapPoint.CreateFromCoordinates then
		local p = UiMapPoint.CreateFromCoordinates(CATALYST.map, CATALYST.x / 100, CATALYST.y / 100)
		if pcall(C_Map.SetUserWaypoint, p) and C_SuperTrack and C_SuperTrack.SetSuperTrackedUserWaypoint then
			pcall(C_SuperTrack.SetSuperTrackedUserWaypoint, true)
		end
	end
end

local function BodyText()
	local lines = {}

	-- Level 1: algemene uitleg (gelokaliseerd). {CATALYST} → klikbare waypoint-link.
	local intro = ns:L("TIER_GUIDE_BODY")
	if ns.ExpandDelveTipMarkup then
		intro = ns:ExpandDelveTipMarkup(intro)
	end
	intro = intro:gsub("{CATALYST}", function()
		return "|cff71d5ff|Hmhcatalyst|h[" .. ns:L("TIER_CATALYST_NAME") .. "]|h|r"
	end)
	lines[#lines + 1] = intro

	-- Level 2: jouw set.
	lines[#lines + 1] = " "
	local classFile = PlayerClassFile()
	local setName = classFile and ns.TIER_SET_BY_CLASS and ns.TIER_SET_BY_CLASS[classFile]
	lines[#lines + 1] = "|cffe8c36a" .. ns:L("TIER_YOUR_SET") .. "|r " .. (setName or ns:L("TIER_SET_UNKNOWN"))

	local specID = PlayerSpecID()
	local bonus = specID and ns.TIER_SPEC_BONUS and ns.TIER_SPEC_BONUS[specID]
	if bonus then
		lines[#lines + 1] = "|cffe8c36a" .. ns:L("TIER_2SET") .. "|r " .. SpellLink(bonus.s2)
		lines[#lines + 1] = "|cffe8c36a" .. ns:L("TIER_4SET") .. "|r " .. SpellLink(bonus.s4)
	else
		lines[#lines + 1] = "|cff9aa0a8" .. ns:L("TIER_SET_UNKNOWN") .. "|r"
	end

	-- Live teller.
	local n = TierPiecesEquipped()
	if n then
		lines[#lines + 1] = ns:L("TIER_COUNT_FMT"):format(n)
			.. "    "
			.. StatusLabel("2-set", n >= 2)
			.. "    "
			.. StatusLabel("4-set", n >= 4)
	else
		lines[#lines + 1] = "|cff9aa0a8" .. ns:L("TIER_COUNT_UNKNOWN") .. "|r"
	end

	lines[#lines + 1] = " "
	lines[#lines + 1] = "|cff9aa0a8" .. ns:L("TIER_FOOTER") .. "|r"

	return table.concat(lines, "|n")
end

--------------------------------------------------------------------------------
-- Paneel (tab "tier", Character-sectie)
--------------------------------------------------------------------------------

function ns.RefreshTierSetPanel()
	if not (ui and ui.body) then
		return
	end
	ui.body:SetText(BodyText())
end

function ns.BuildTierSetPanel(panel)
	if not panel or panel._mhTierBuilt then
		return
	end
	panel._mhTierBuilt = true
	if panel._body then
		panel._body:Hide()
	end
	if panel._header then
		panel._header:Hide()
	end

	local title = panel:CreateFontString(nil, "OVERLAY", "GameFontHighlightLarge")
	title:SetPoint("TOPLEFT", panel, "TOPLEFT", 14, -12)
	title:SetText(ns:L("TAB_TIER"))

	local subtitle = panel:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	subtitle:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -4)
	subtitle:SetPoint("RIGHT", panel, "RIGHT", -14, 0)
	subtitle:SetJustifyH("LEFT")
	subtitle:SetWordWrap(true)
	subtitle:SetTextColor(0.75, 0.78, 0.82)
	subtitle:SetText(ns:L("TIER_SUBTITLE"))

	local scroll = CreateFrame("ScrollFrame", nil, panel, "UIPanelScrollFrameTemplate")
	scroll:SetPoint("TOPLEFT", subtitle, "BOTTOMLEFT", 0, -12)
	scroll:SetPoint("BOTTOMRIGHT", panel, "BOTTOMRIGHT", -30, 14)

	local body = CreateFrame("EditBox", nil, scroll)
	body:SetMultiLine(true)
	body:SetFontObject("GameFontHighlightSmall")
	body:SetJustifyH("LEFT")
	body:SetAutoFocus(false)
	body:EnableMouse(true)
	body:SetSpacing(6)
	if body.SetMaxLetters then
		body:SetMaxLetters(0)
	end
	body:SetWidth(520)
	body:SetScript("OnEscapePressed", body.ClearFocus)
	if ns.AttachDelveTipHyperlinksToEditBox then
		ns:AttachDelveTipHyperlinksToEditBox(body)
	end
	-- Klik op de Creation Catalyst-link → waypoint (spell-links blijven op hover
	-- hun tooltip tonen via de attach hierboven).
	body:SetScript("OnHyperlinkClick", function(_, linkData)
		if linkData == "mhcatalyst" then
			SetCatalystWaypoint()
		end
	end)
	scroll:SetScrollChild(body)

	scroll:SetScript("OnSizeChanged", function(self, w)
		if w and w > 40 then
			body:SetWidth(w - 8)
		end
	end)

	ui = { panel = panel, title = title, subtitle = subtitle, body = body }

	panel:SetScript("OnShow", function()
		ns.RefreshTierSetPanel()
	end)

	local ev = CreateFrame("Frame")
	ev:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")
	ev:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED")
	ev:RegisterEvent("UNIT_INVENTORY_CHANGED")
	ev:SetScript("OnEvent", function(_, event, unit)
		if event == "UNIT_INVENTORY_CHANGED" and unit and unit ~= "player" then
			return
		end
		if ui and ui.panel and ui.panel:IsShown() then
			if C_Timer and C_Timer.After then
				C_Timer.After(0.1, ns.RefreshTierSetPanel)
			else
				ns.RefreshTierSetPanel()
			end
		end
	end)

	ns.RefreshTierSetPanel()
end

do
	local orig = ns.RefreshLocaleUI
	function ns:RefreshLocaleUI()
		if orig then
			orig(self)
		end
		if ui and ui.title then
			ui.title:SetText(ns:L("TAB_TIER"))
			ui.subtitle:SetText(ns:L("TIER_SUBTITLE"))
			if ui.panel and ui.panel:IsShown() then
				ns.RefreshTierSetPanel()
			end
		end
	end
end
