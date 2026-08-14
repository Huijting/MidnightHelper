--[[
	Currency Guide (Rob-wens 15 jun, uitgebreid 15 jun #2). Een "waar geef ik welke
	currency uit"-cheatsheet: per Midnight-currency waar je 'm verdient en bij welke
	vendor je 'm uitgeeft. Read-only paneel met klikbare currency-links die je live
	saldo tonen, plus een waypoint-knop per Renown Quartermaster.

	Bron-posture (never-lie): currency-IDs + vendors + QM-coords uit Wowhead/Method-
	research (15 jun, zie SESSION_NOTES). Currency-NAMEN renderen via de game-link en
	zijn dus automatisch gelokaliseerd; de uitleg-tekst staat per taal in de Locales.
	Vendor-eigennamen en coords blijven "bevestig in-game".

	Taint-veilig: alleen read-only tekst + waypoint-API; geen beschermde calls.
]]

local _, ns = ...

local ui

-- Renown Quartermasters (Voidlight Marl). UiMapID + coords uit Wowhead (15 jun) —
-- in-game te bevestigen.
local QMS = {
	{ key = "court", labelKey = "CURRENCY_QM_COURT", map = 2395, x = 43.46, y = 47.42, who = "Caeris Fairdawn" },
	{ key = "amani", labelKey = "CURRENCY_QM_AMANI", map = 2437, x = 45.95, y = 65.92, who = "Magovu" },
	{ key = "harati", labelKey = "CURRENCY_QM_HARATI", map = 2413, x = 50.99, y = 50.75, who = "Naynar" },
	{ key = "singularity", labelKey = "CURRENCY_QM_SINGULARITY", map = 2405, x = 52.57, y = 72.89, who = "Void Researcher Anomander" },
}

-- Saldo van een currency, of nil.
local function CurrencyQty(id)
	if C_CurrencyInfo and C_CurrencyInfo.GetCurrencyInfo then
		local ok, info = pcall(C_CurrencyInfo.GetCurrencyInfo, id)
		if ok and info and info.quantity then
			return info.quantity
		end
	end
	return nil
end

-- {CURRENCY:id} → game-link + |cff..(saldo)|r. (Het body bevat geen {SPELL}/{ITEM}.)
--- {CRESTS} → the five crest currencies of the CURRENT season, in tier order.
---
--- The body used to list the five Season 1 ids literally, in all seven languages.
--- Season 2 renames and renumbers them (Dawncrest -> Mistcrest), so after the flip
--- that paragraph would have shown five frozen balances for a currency nobody earns
--- any more -- in the panel whose entire job is telling you what to spend.
---
--- One token instead of five ids means the season logic lives here, and the seven
--- translations never have to be touched again when a season turns. The ids come
--- from DAWNCREST_TIERS, which is also what the Crests tab reads, so the two panels
--- cannot disagree.
--- ⚠️ ASKS THE SHARED DECISION, NOT THE SEASON GATE. Fixed 14 Aug 2026.
---
--- This used to read `IsSeason2Live()` itself, and on 14 Aug that produced five Dawncrest
--- zeroes on a page whose subtitle promises "a quick map of every Midnight currency" —
--- while Blizzard's own tab showed the player 100 / 20 / 10 Mistcrest. The gate is right
--- about the SEASON and wrong about the CURRENCY: you earn the new crests before the
--- season opens.
---
--- `ns.MH_TierUsesSeason2` lives in DawncrestGuide beside `TierCurrencyIds`, so the Crests
--- tab and this page cannot disagree about which season a tier is in. They already did
--- once, on 31 July, when a row's number came from one season and its icon from the other.
local function CrestTokens()
	local tiers = ns.DAWNCREST_TIERS
	if type(tiers) ~= "table" then
		return ""
	end
	local out = {}
	for i = 1, #tiers do
		local t = tiers[i]
		local s2 = ns.MH_TierUsesSeason2 and ns.MH_TierUsesSeason2(t)
		local id = t and ((s2 and t.season2CurrencyId) or t.currencyId)
		if id then
			out[#out + 1] = ("{CURRENCY:%d}"):format(id)
		end
	end
	return table.concat(out, " ")
end

local function BodyText()
	local raw = ns:L("CURRENCY_GUIDE_BODY")
	-- Expanded BEFORE the currency pass below, so the ids it produces get the same
	-- link-and-balance treatment as any hand-written one.
	raw = raw:gsub("{CRESTS}", CrestTokens)
	local text = raw:gsub("{CURRENCY:(%d+)}", function(id)
		local nid = tonumber(id)
		local link = (ns.GetCurrencyLinkMarkup and ns:GetCurrencyLinkMarkup(nid)) or ("currency " .. id)
		local qty = CurrencyQty(nid)
		if qty then
			return link .. (" |cff8fce8f(%d)|r"):format(qty)
		end
		return link
	end)
	-- Bekende vendor-namen klikbaar maken (Maren, Triam, QM's, Cuzoth/Vaskarn, PvP).
	if ns.LinkifyVendors then
		text = ns:LinkifyVendors(text)
	end
	if ns.SanitizeUIFontText then
		text = ns.SanitizeUIFontText(text)
	end
	return text
end

--- Every currency id this page will actually render, the seasonal ones included.
---
--- ⚠️ PARSED FROM THE STRING THE PANEL DRAWS, never kept as a second list. A probe
--- with its own copy of the ids is worse than no probe: it reports cheerfully on
--- currencies the page stopped using, which is exactly the reassurance you do not
--- want on patch day. {CRESTS} is expanded first, so the answer follows the season
--- the same way the panel does.
---
--- Written 11 Aug 2026 for `/mh crestscan`: that sweep only recognised names with
--- "crest" in them, so Voidlight Marl and Field Accolade — the two hand-written ids
--- on this page — were the one thing it could not tell you about.
--- @return table ids  ordered, de-duplicated
function ns.MH_CurrencyGuideIds()
	local raw = ns:L("CURRENCY_GUIDE_BODY") or ""
	raw = raw:gsub("{CRESTS}", CrestTokens)
	local out, seen = {}, {}
	for id in raw:gmatch("{CURRENCY:(%d+)}") do
		local n = tonumber(id)
		if n and not seen[n] then
			seen[n] = true
			out[#out + 1] = n
		end
	end
	return out
end

-- Zet een waypoint naar een Quartermaster (TomTom indien aanwezig, anders native).
local function SetQMWaypoint(qm)
	if not qm then
		return
	end
	if C_AddOns and C_AddOns.LoadAddOn and C_AddOns.IsAddOnLoaded and not C_AddOns.IsAddOnLoaded("TomTom") then
		pcall(C_AddOns.LoadAddOn, "TomTom")
	end
	local slashWay = SlashCmdList and SlashCmdList["TOMTOM_WAY"]
	if type(slashWay) == "function" then
		pcall(slashWay, ("#%d %.2f %.2f %s"):format(qm.map, qm.x, qm.y, qm.who or "Quartermaster"))
		return
	end
	if C_Map and C_Map.SetUserWaypoint and UiMapPoint and UiMapPoint.CreateFromCoordinates then
		local p = UiMapPoint.CreateFromCoordinates(qm.map, qm.x / 100, qm.y / 100)
		local ok = pcall(C_Map.SetUserWaypoint, p)
		if ok and C_SuperTrack and C_SuperTrack.SetSuperTrackedUserWaypoint then
			pcall(C_SuperTrack.SetSuperTrackedUserWaypoint, true)
		end
		if ok then
			print(("|cffffcc00%s|r %s (%.1f, %.1f)"):format(ns:L("PRINT_PREFIX"), qm.who or "", qm.x, qm.y))
		end
	end
end

function ns.RefreshCurrencyGuidePanel()
	if not (ui and ui.body) then
		return
	end
	ui.body:SetText(BodyText())
end

function ns.BuildCurrencyGuidePanel(panel)
	if not panel or panel._mhCurrencyBuilt then
		return
	end
	panel._mhCurrencyBuilt = true
	if panel._body then
		panel._body:Hide()
	end
	if panel._header then
		panel._header:Hide()
	end

	local title = panel:CreateFontString(nil, "OVERLAY", "GameFontHighlightLarge")
	title:SetFontObject(ns.MHScalableFont("GameFontHighlightLarge"))
	title:SetPoint("TOPLEFT", panel, "TOPLEFT", 14, -12)
	title:SetText(ns:L("TAB_CURRENCY"))

	local subtitle = panel:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	subtitle:SetFontObject(ns.MHScalableFont("GameFontHighlightSmall"))
	subtitle:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -4)
	subtitle:SetPoint("RIGHT", panel, "RIGHT", -14, 0)
	subtitle:SetJustifyH("LEFT")
	subtitle:SetWordWrap(true)
	subtitle:SetTextColor(0.75, 0.78, 0.82)
	subtitle:SetText(ns:L("CURRENCY_SUBTITLE"))

	-- Onderaan: waypoint-knoppen per Renown Quartermaster.
	local qmLabel = panel:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
	qmLabel:SetFontObject(ns.MHScalableFont("GameFontDisableSmall"))
	qmLabel:SetPoint("BOTTOMLEFT", panel, "BOTTOMLEFT", 14, 16)
	qmLabel:SetJustifyH("LEFT")
	qmLabel:SetText(ns:L("CURRENCY_QM_LABEL"))
	qmLabel:SetTextColor(0.62, 0.60, 0.55)

	local qmButtons = {}
	local prev
	for _, qm in ipairs(QMS) do
		local b = CreateFrame("Button", nil, panel, "UIPanelButtonTemplate")
		b:SetHeight(20)
		b:SetText(ns:L(qm.labelKey))
		local w = (b:GetFontString() and b:GetFontString():GetStringWidth() or 60) + 18
		b:SetWidth(math.max(54, w))
		if prev then
			b:SetPoint("LEFT", prev, "RIGHT", 6, 0)
		else
			b:SetPoint("LEFT", qmLabel, "RIGHT", 10, 0)
		end
		b:SetScript("OnClick", function()
			SetQMWaypoint(qm)
		end)
		b._mhQM = qm
		qmButtons[#qmButtons + 1] = b
		prev = b
	end

	-- Scrollbaar leesvenster (de cheatsheet is langer dan het paneel).
	local scroll = CreateFrame("ScrollFrame", nil, panel, "UIPanelScrollFrameTemplate")
	scroll:SetPoint("TOPLEFT", subtitle, "BOTTOMLEFT", 0, -12)
	scroll:SetPoint("BOTTOMRIGHT", panel, "BOTTOMRIGHT", -30, 44)

	-- Read-only EditBox → klikbare/hoverbare currency-links.
	local body = CreateFrame("EditBox", nil, scroll)
	body:SetMultiLine(true)
	body:SetFontObject(ns.MHScalableFont("GameFontHighlightSmall"))
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
	scroll:SetScrollChild(body)

	scroll:SetScript("OnSizeChanged", function(self, w)
		if w and w > 40 then
			body:SetWidth(w - 8)
		end
	end)

	ui = { panel = panel, title = title, subtitle = subtitle, body = body, qmLabel = qmLabel, qmButtons = qmButtons }

	panel:SetScript("OnShow", function()
		ns.RefreshCurrencyGuidePanel()
	end)

	-- Saldo's verversen wanneer currency-bedragen wijzigen terwijl de tab open is.
	local ev = CreateFrame("Frame")
	ev:RegisterEvent("CURRENCY_DISPLAY_UPDATE")
	ev:SetScript("OnEvent", function()
		if ui and ui.panel and ui.panel:IsShown() then
			ns.RefreshCurrencyGuidePanel()
		end
	end)

	ns.RefreshCurrencyGuidePanel()
end

-- Titel/subtitel/knoppen/inhoud meeverversen bij taalwissel.
do
	local orig = ns.RefreshLocaleUI
	function ns:RefreshLocaleUI()
		if orig then
			orig(self)
		end
		if ui and ui.title then
			ui.title:SetText(ns:L("TAB_CURRENCY"))
			ui.subtitle:SetText(ns:L("CURRENCY_SUBTITLE"))
			if ui.qmLabel then
				ui.qmLabel:SetText(ns:L("CURRENCY_QM_LABEL"))
			end
			if ui.qmButtons then
				for _, b in ipairs(ui.qmButtons) do
					if b._mhQM then
						b:SetText(ns:L(b._mhQM.labelKey))
					end
				end
			end
			if ui.panel and ui.panel:IsShown() then
				ns.RefreshCurrencyGuidePanel()
			end
		end
	end
end
