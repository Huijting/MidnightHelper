--[[
	Midnight Helper — {SPELL:id} / {SPELL:@token} / {ITEM:id} markup for Delve Coach text.
]]

local _, ns = ...

local SPELL_LINK_COLOR = "71d5ff"
local ITEM_LINK_COLOR = "1eff00"
local CURRENCY_LINK_COLOR = "ffd200"

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

	if ns.SanitizeUIFontText then
		text = ns.SanitizeUIFontText(text)
	end

	return text
end

local function ShowDelveTipHyperlinkTooltip(owner, linkData)
	local gt = _G.GameTooltip
	if not gt or not gt.SetOwner or not linkData then
		return
	end
	gt:SetOwner(owner, "ANCHOR_RIGHT", 0, 0)
	gt:ClearLines()
	local kind, payload = linkData:match("^([^:]+):(.+)$")
	if not kind then
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
