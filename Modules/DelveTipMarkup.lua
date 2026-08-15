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
