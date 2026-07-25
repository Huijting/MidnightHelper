--[[
	Midnight Helper — Dawncrest section (Guide tab).
]]

local _, ns = ...

local C_CurrencyInfo = C_CurrencyInfo

local ROW_H = 18
local ICON = 16
local BODY_PAD = 6
local MIN_EXPANDED_BODY_H = 300

local embeddedPanel
local crestRows = {}
local layoutPending = false

local function GetGuideSettings()
	local ui = ns.db and ns.db.ui
	if type(ui) ~= "table" then
		return { expanded = true }
	end
	if type(ui.dawncrestGuide) ~= "table" then
		ui.dawncrestGuide = { expanded = true }
	end
	return ui.dawncrestGuide
end

local function GetCurrencyQty(currencyId)
	local id = tonumber(currencyId)
	if not id or not C_CurrencyInfo or not C_CurrencyInfo.GetCurrencyInfo then
		return 0, 0, 0
	end
	local ok, info = pcall(C_CurrencyInfo.GetCurrencyInfo, id)
	if not ok or type(info) ~= "table" then
		return 0, 0, 0, false
	end
	local qty = math.floor(tonumber(info.quantity) or 0)
	local earned = math.floor(tonumber(info.quantityEarnedThisWeek) or 0)
	local maxQ = tonumber(info.maxQuantity) or tonumber(info.maxWeeklyQuantity) or 0
	-- 4th return: does this id exist at all? A real currency with a balance of 0 and
	-- an id the game does not know both read as "0", and the caller has to tell them
	-- apart to pick the right id.
	local exists = type(info.name) == "string" and info.name ~= ""
	return qty, earned, math.floor(maxQ), exists
end

local function GetTierCurrencyQty(tier)
	if type(tier) ~= "table" then
		return 0, 0, 0
	end
	local ids = { tier.currencyId }
	if type(tier.alternateCurrencyIds) == "table" then
		for i = 1, #tier.alternateCurrencyIds do
			ids[#ids + 1] = tier.alternateCurrencyIds[i]
		end
	end
	-- THE PRIMARY ID WINS. This used to take the MAX across primary and alternates,
	-- from back when it was unclear which id was the real one. Measured on Rob's live
	-- client 2026-07-22: Blizzard's own currency tab showed Veteran Dawncrest = 120,
	-- which is id 3341. The "duplicate" 3342 read 220 — so the MAX rule displayed 100
	-- crests the player does not have, in the one panel meant to help them plan
	-- upgrades. Every primary id matched the game exactly (3383=54, 3341=120,
	-- 3343=31, 3347=240); no alternate did.
	--
	-- Alternates stay as a fallback for a future patch that renumbers a currency:
	-- they are used only when the primary id is not a currency the game knows, never
	-- to beat a real balance.
	for i = 1, #ids do
		local q, earned, maxQ, exists = GetCurrencyQty(ids[i])
		if exists then
			return q, earned, maxQ
		end
	end
	return 0, 0, 0
end

local function RequestDawncrestCurrencyData()
	if not C_CurrencyInfo or not C_CurrencyInfo.RequestCurrencyDataFromServer then
		return
	end
	local tiers = ns.DAWNCREST_TIERS
	if type(tiers) ~= "table" then
		return
	end
	local seen = {}
	for i = 1, #tiers do
		local tier = tiers[i]
		local ids = { tier and tier.currencyId }
		if tier and type(tier.alternateCurrencyIds) == "table" then
			for j = 1, #tier.alternateCurrencyIds do
				ids[#ids + 1] = tier.alternateCurrencyIds[j]
			end
		end
		for j = 1, #ids do
			local id = ids[j]
			if id and not seen[id] then
				seen[id] = true
				pcall(C_CurrencyInfo.RequestCurrencyDataFromServer, id)
			end
		end
	end
end

local function IsAchievementComplete(achievementId)
	local id = tonumber(achievementId)
	if not id or not GetAchievementInfo then
		return false
	end
	local ok, _, _, completed = pcall(GetAchievementInfo, id)
	return ok and completed == true
end

local function SetRowIcon(tex, currencyId)
	if not tex then
		return
	end
	local id = tonumber(currencyId)
	if id and C_CurrencyInfo and C_CurrencyInfo.GetCurrencyInfo then
		local ok, info = pcall(C_CurrencyInfo.GetCurrencyInfo, id)
		if ok and info and info.iconFileID then
			tex:SetTexture(info.iconFileID)
			tex:Show()
			return
		end
	end
	if tex.SetAtlas then
		tex:SetAtlas("WarWithin-Icon-Crest")
	end
end

local function ShowCrestCurrencyTooltip(owner, currencyId)
	local id = tonumber(currencyId)
	if not id or not GameTooltip then
		return
	end
	GameTooltip:SetOwner(owner, "ANCHOR_CURSOR")
	if GameTooltip.SetCurrencyByID then
		GameTooltip:SetCurrencyByID(id)
	else
		GameTooltip:ClearLines()
		if C_CurrencyInfo and C_CurrencyInfo.GetCurrencyInfo then
			local ok, info = pcall(C_CurrencyInfo.GetCurrencyInfo, id)
			if ok and type(info) == "table" then
				GameTooltip:AddLine(info.name or "?", 1, 1, 1)
				if info.description and info.description ~= "" then
					GameTooltip:AddLine(info.description, 1, 1, 1, true)
				end
			end
		end
	end
	GameTooltip:Show()
end

local function HideCrestCurrencyTooltip()
	if GameTooltip then
		GameTooltip:Hide()
	end
end

local function BindCrestIconTooltip(iconBtn, currencyId)
	if not iconBtn then
		return
	end
	iconBtn._mhCurrencyId = tonumber(currencyId)
	if iconBtn._mhTooltipBound then
		return
	end
	iconBtn._mhTooltipBound = true
	iconBtn:EnableMouse(true)
	iconBtn:SetScript("OnEnter", function(self)
		ShowCrestCurrencyTooltip(self, self._mhCurrencyId)
	end)
	iconBtn:SetScript("OnLeave", HideCrestCurrencyTooltip)
end

local function LayoutButtons()
	local btnRow = embeddedPanel and embeddedPanel._body and embeddedPanel._body._btnRow
	if not btnRow or not embeddedPanel then
		return
	end
	local w = math.max(200, (embeddedPanel:GetWidth() or 0) - 8)
	local half = math.floor((w - 6) / 2)
	if btnRow._btnV then
		btnRow._btnV:SetSize(half, 22)
	end
	if btnRow._btnC then
		btnRow._btnC:SetSize(half, 22)
	end
	if btnRow._btnS then
		btnRow._btnS:SetSize(w, 22)
	end
end

local function MeasureBodyHeight(expanded)
	if not embeddedPanel or not embeddedPanel._body then
		return 0
	end
	if not expanded then
		return 0
	end
	local body = embeddedPanel._body
	local pw = math.max(280, embeddedPanel:GetWidth() or 400)
	body:SetWidth(pw)
	if body._summary then
		body._summary:SetWidth(pw - 12)
	end
	local h = BODY_PAD
	if body._summary and body._summary:IsShown() then
		h = h + (body._summary:GetStringHeight() or 0) + 8
	end
	if body._crestBlock and body._crestBlock:IsShown() then
		h = h + (body._crestBlock:GetHeight() or 0) + 6
	end
	if body._btnRow and body._btnRow:IsShown() then
		h = h + (body._btnRow:GetHeight() or 0) + BODY_PAD
	end
	return math.max(h, MIN_EXPANDED_BODY_H)
end

local function ApplyPanelHeight()
	if not embeddedPanel then
		return
	end
	local expanded = GetGuideSettings().expanded ~= false
	if not expanded then
		embeddedPanel:SetHeight(18)
		return
	end
	local bodyH = MeasureBodyHeight(true)
	if embeddedPanel._body then
		embeddedPanel._body:SetHeight(bodyH)
	end
	embeddedPanel:SetHeight(18 + bodyH)
end

local function SyncHostScroll()
	if ns.SyncReferenceGuideScroll then
		ns.SyncReferenceGuideScroll()
	end
end

local function ScheduleLayout()
	if layoutPending then
		return
	end
	if not C_Timer or not C_Timer.After then
		ApplyPanelHeight()
		SyncHostScroll()
		return
	end
	layoutPending = true
	C_Timer.After(0.05, function()
		layoutPending = false
		ApplyPanelHeight()
		SyncHostScroll()
	end)
end

function ns.RefreshDawncrestGuide()
	if not embeddedPanel then
		return
	end
	RequestDawncrestCurrencyData()
	local s = GetGuideSettings()
	local expanded = s.expanded ~= false
	if embeddedPanel._collapseBtn then
		embeddedPanel._collapseBtn:SetText(expanded and "−" or "+")
	end
	if embeddedPanel._title then
		embeddedPanel._title:SetText(ns:L("DAWNCREST_GUIDE_TITLE"))
	end
	if embeddedPanel._body then
		embeddedPanel._body:SetShown(expanded)
	end
	local summary = embeddedPanel._body and embeddedPanel._body._summary
	if summary then
		summary:SetText(ns:L("DAWNCREST_GUIDE_SUMMARY"))
	end

	local s = (ns.GetContentFontScale and ns.GetContentFontScale()) or 1
	local tiers = ns.DAWNCREST_TIERS
	if expanded and type(tiers) == "table" then
		for i = 1, #tiers do
			local tier = tiers[i]
			local row = crestRows[i]
			if tier and row and row.label and row.count then
				local qty, earned, maxQ = GetTierCurrencyQty(tier)
				row.label:SetText(ns:L(tier.labelKey))
				if maxQ > 0 then
					row.count:SetText(ns:L("DAWNCREST_ROW_FMT"):format(qty, earned, maxQ))
				else
					row.count:SetText(tostring(qty))
				end
				SetRowIcon(row.icon, tier.currencyId)
				BindCrestIconTooltip(row.iconBtn, tier.currencyId)
				local rowFrame = row.row
				if row.ach and rowFrame and rowFrame.SetHeight then
					-- Rijhoogtes schalen mee met de tekst (matcht build-layout);
					-- crestBlock-hoogte hieronder leest GetHeight() terug, dus blijft synchroon.
					if IsAchievementComplete(tier.achievementId) then
						row.ach:SetText(ns:L("DAWNCREST_ACH_DONE_FMT"):format(ns:L(tier.achLabelKey)))
						row.ach:Show()
						rowFrame:SetHeight((ROW_H + 14) * s)
					else
						row.ach:Hide()
						rowFrame:SetHeight(ROW_H * s)
					end
				end
			end
		end
		if embeddedPanel._body and embeddedPanel._body._crestBlock then
			-- Her-anker elke rij op de geschaalde Y zodat een live tekstschaal-wissel
			-- (geen rebuild) de rijen niet laat overlappen; cy blijft de blokhoogte.
			local cy = 0
			for i = 1, #tiers do
				local rowFrame = crestRows[i] and crestRows[i].row
				if rowFrame then
					rowFrame:ClearAllPoints()
					rowFrame:SetPoint("TOPLEFT", embeddedPanel._body._crestBlock, "TOPLEFT", 0, -cy)
					rowFrame:SetPoint("RIGHT", embeddedPanel._body._crestBlock, "RIGHT", 0, 0)
					cy = cy + rowFrame:GetHeight() + 4
				end
			end
			embeddedPanel._body._crestBlock:SetHeight(math.max(1, cy))
		end
	end

	LayoutButtons()
	ApplyPanelHeight()
	ScheduleLayout()
end

function ns.EnsureDawncrestGuidePanel(parent)
	if not parent then
		return nil
	end
	if embeddedPanel then
		if embeddedPanel:GetParent() ~= parent then
			embeddedPanel:SetParent(parent)
			embeddedPanel:ClearAllPoints()
		end
		ns.RefreshDawncrestGuide()
		return embeddedPanel
	end

	local panel = CreateFrame("Frame", nil, parent)
	panel:SetClipsChildren(false)

	local titleRow = CreateFrame("Frame", nil, panel)
	titleRow:SetHeight(18)
	titleRow:SetPoint("TOPLEFT", panel, "TOPLEFT", 0, 0)
	titleRow:SetPoint("TOPRIGHT", panel, "TOPRIGHT", 0, 0)

	local collapseBtn = CreateFrame("Button", nil, titleRow)
	collapseBtn:SetSize(18, 18)
	collapseBtn:SetPoint("LEFT", titleRow, "LEFT", 0, 0)
	collapseBtn:SetNormalFontObject(GameFontNormal)
	collapseBtn:SetText("−")
	collapseBtn:SetScript("OnClick", function()
		local gs = GetGuideSettings()
		gs.expanded = not (gs.expanded ~= false)
		ns.RefreshDawncrestGuide()
		if ns.RefreshReferenceGuidePanel then
			ns.RefreshReferenceGuidePanel()
		end
	end)
	panel._collapseBtn = collapseBtn

	local titleFs = titleRow:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	titleFs:SetFontObject(ns.MHScalableFont("GameFontNormal"))
	titleFs:SetPoint("LEFT", collapseBtn, "RIGHT", 2, 0)
	titleFs:SetPoint("RIGHT", titleRow, "RIGHT", -2, 0)
	titleFs:SetJustifyH("LEFT")
	titleFs:SetTextColor(0.92, 0.88, 0.75)
	titleFs:SetText(ns:L("DAWNCREST_GUIDE_TITLE"))
	panel._title = titleFs

	local body = CreateFrame("Frame", nil, panel)
	body:SetPoint("TOPLEFT", titleRow, "BOTTOMLEFT", 0, -2)
	body:SetPoint("TOPRIGHT", titleRow, "BOTTOMRIGHT", 0, -2)
	body:SetClipsChildren(false)
	panel._body = body

	local summary = body:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	summary:SetFontObject(ns.MHScalableFont("GameFontHighlightSmall"))
	summary:SetPoint("TOPLEFT", body, "TOPLEFT", 4, -BODY_PAD)
	summary:SetPoint("RIGHT", body, "RIGHT", -4, 0)
	summary:SetJustifyH("LEFT")
	summary:SetWordWrap(true)
	body._summary = summary

	local crestBlock = CreateFrame("Frame", nil, body)
	crestBlock:SetPoint("TOPLEFT", summary, "BOTTOMLEFT", -4, -8)
	crestBlock:SetPoint("RIGHT", body, "RIGHT", 0, 0)
	body._crestBlock = crestBlock

	local s = (ns.GetContentFontScale and ns.GetContentFontScale()) or 1
	local tiers = ns.DAWNCREST_TIERS or {}
	local cy = 0
	for i = 1, #tiers do
		local row = CreateFrame("Frame", nil, crestBlock)
		row:SetHeight(ROW_H * s)
		row:SetPoint("TOPLEFT", crestBlock, "TOPLEFT", 0, -cy)
		row:SetPoint("RIGHT", crestBlock, "RIGHT", 0, 0)

		local iconBtn = CreateFrame("Button", nil, row)
		iconBtn:SetSize(ICON * s, ICON * s)
		iconBtn:SetPoint("LEFT", row, "LEFT", 0, 0)
		local icon = iconBtn:CreateTexture(nil, "ARTWORK")
		icon:SetAllPoints(iconBtn)

		local label = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
		label:SetFontObject(ns.MHScalableFont("GameFontHighlightSmall"))
		label:SetPoint("LEFT", iconBtn, "RIGHT", 4, 0)
		label:SetPoint("RIGHT", row, "RIGHT", -72, 0)
		label:SetJustifyH("LEFT")

		local count = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
		count:SetFontObject(ns.MHScalableFont("GameFontHighlightSmall"))
		count:SetPoint("RIGHT", row, "RIGHT", 0, 0)
		count:SetJustifyH("RIGHT")

		local achFs = row:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
		achFs:SetFontObject(ns.MHScalableFont("GameFontDisableSmall"))
		achFs:SetPoint("TOPLEFT", row, "BOTTOMLEFT", (ICON * s) + 4, -1)
		achFs:SetPoint("RIGHT", row, "RIGHT", 0, 0)
		achFs:SetJustifyH("LEFT")
		achFs:SetTextColor(0.45, 0.95, 0.5)
		achFs:Hide()

		crestRows[i] = { icon = icon, iconBtn = iconBtn, label = label, count = count, ach = achFs, row = row }
		BindCrestIconTooltip(iconBtn, tiers[i] and tiers[i].currencyId)
		-- Y-stap = geschaalde rijhoogte + vaste 4px tussenruimte (matcht refresh).
		cy = cy + ROW_H * s + 4
	end
	crestBlock:SetHeight(math.max(1, cy))

	local btnRow = CreateFrame("Frame", nil, body)
	btnRow:SetHeight(50)
	btnRow:SetPoint("TOPLEFT", crestBlock, "BOTTOMLEFT", 0, -6)
	btnRow:SetPoint("TOPRIGHT", crestBlock, "BOTTOMRIGHT", 0, -6)
	body._btnRow = btnRow

	local pins = ns.DAWNCREST_SMC_PINS or {}
	local btnV = CreateFrame("Button", nil, btnRow, "UIPanelButtonTemplate")
	btnV:SetPoint("TOPLEFT", btnRow, "TOPLEFT", 0, 0)
	btnV:SetText(ns:L("DAWNCREST_BTN_VASKARN"))
	btnV:SetScript("OnClick", function()
		if ns.SetSMCCityWaypoint then
			ns.SetSMCCityWaypoint(pins.vaskarn or "crest_exchange")
		end
	end)
	btnRow._btnV = btnV

	local btnC = CreateFrame("Button", nil, btnRow, "UIPanelButtonTemplate")
	btnC:SetPoint("TOPLEFT", btnV, "TOPRIGHT", 6, 0)
	btnC:SetText(ns:L("DAWNCREST_BTN_CUZOTH"))
	btnC:SetScript("OnClick", function()
		if ns.SetSMCCityWaypoint then
			ns.SetSMCCityWaypoint(pins.cuzoth or "item_upgrades")
		end
	end)
	btnRow._btnC = btnC

	local btnS = CreateFrame("Button", nil, btnRow, "UIPanelButtonTemplate")
	btnS:SetPoint("TOPLEFT", btnV, "BOTTOMLEFT", 0, -4)
	btnS:SetText(ns:L("DAWNCREST_BTN_SMC"))
	btnS:SetScript("OnClick", function()
		if ns.EnsureMainUI then
			ns:EnsureMainUI()
		end
		if ns.SelectTab then
			ns.SelectTab("smcguide")
		end
		if ns.OpenSMCCityGuidePin then
			ns.OpenSMCCityGuidePin(pins.vaskarn or "crest_exchange")
		end
	end)
	btnRow._btnS = btnS

	panel:SetScript("OnSizeChanged", function()
		LayoutButtons()
		ScheduleLayout()
	end)

	embeddedPanel = panel
	ns.DawncrestGuidePanel = panel
	ns.RefreshDawncrestGuide()
	return panel
end

if not ns._mhDawncrestLocaleHooked then
	ns._mhDawncrestLocaleHooked = true
	local orig = ns.RefreshLocaleUI
	function ns:RefreshLocaleUI()
		if orig then
			orig(self)
		end
		if ns.RefreshDawncrestGuide then
			ns.RefreshDawncrestGuide()
		end
	end
end

local ev = CreateFrame("Frame")
ev:RegisterEvent("CURRENCY_DISPLAY_UPDATE")
ev:RegisterEvent("ACHIEVEMENT_EARNED")
ev:SetScript("OnEvent", function()
	if ns.RefreshReferenceGuidePanel then
		ns.RefreshReferenceGuidePanel()
	end
end)

--------------------------------------------------------------------------------
-- /mh crests — let the GAME describe each crest tier
--------------------------------------------------------------------------------

--- Prints, per tier: the id, the name the game uses, and the currency's own
--- description field.
---
--- WHY THIS EXISTS. The handoff proposed hardcoding English source lines
--- ("From: high bountiful delves, ritual sites, high keys and mythic raid"). Those
--- are game facts nobody in this repo has verified, they would be wrong for every
--- non-English player, and they rot the moment Blizzard moves a source. If
--- C_CurrencyInfo hands us a description, that text is authoritative, already
--- translated, and updates itself -- so we show that instead of our own claim.
--- Run this before writing a single source string.
function ns.PrintCrestProbe()
	local prefix = ("|cffffcc00%s|r"):format(ns.L and ns:L("PRINT_PREFIX") or "MH")
	if not (C_CurrencyInfo and C_CurrencyInfo.GetCurrencyInfo) then
		print(prefix .. " no currency API")
		return
	end
	print(prefix .. " Dawncrest tiers — what the game says about each one:")
	for _, tier in ipairs(ns.DAWNCREST_TIERS or {}) do
		local ids = { tier.currencyId }
		for _, alt in ipairs(tier.alternateCurrencyIds or {}) do
			ids[#ids + 1] = alt
		end
		for _, id in ipairs(ids) do
			local ok, info = pcall(C_CurrencyInfo.GetCurrencyInfo, id)
			if ok and type(info) == "table" then
				print(("   |cff40c040%s|r  id %d  =  %s   (have %s)"):format(
					tostring(tier.key), id, tostring(info.name), tostring(info.quantity)))
				-- Does this tier actually have a cap? Our summary text claims "a weekly
				-- cap (~100)" per colour, but Blizzard's currency tab shows the crests
				-- as a bare number while genuinely capped currencies render as "x / y".
				-- The tilde says that number was always an estimate. Print the real
				-- fields so the claim can be kept, corrected, or dropped.
				print(("      maxQuantity=%s  maxWeeklyQuantity=%s  earnedThisWeek=%s  totalEarned=%s"):format(
					tostring(info.maxQuantity), tostring(info.maxWeeklyQuantity),
					tostring(info.quantityEarnedThisWeek), tostring(info.totalEarned)))
				-- Resolve the tier's "of the Dawn" achievement by NAME. Four of the five
				-- stored ids (42767-42770) sit far below every verified Midnight
				-- achievement in this addon (61xxx-63xxx), so they are very likely wrong
				-- -- and a wrong id fails in the worst way: if it happens to name an old
				-- achievement the player did earn, MH would claim a Season 1 reward they
				-- never got. Season 1 is ending, so this matters now. Print what the game
				-- calls each id and compare it with the label on the row.
				if tier.achievementId and GetAchievementInfo then
					local okA, _, achName, _, achDone = pcall(GetAchievementInfo, tier.achievementId)
					print(("      achievement %s -> %s%s"):format(
						tostring(tier.achievementId),
						(okA and achName) and ("|cffffffff" .. achName .. "|r") or "|cffff8080NO SUCH ACHIEVEMENT|r",
						(okA and achDone) and "  |cff44ff44(earned)|r" or ""))
				end
				local desc = info.description
				if type(desc) == "string" and desc ~= "" then
					print("      description: " .. desc)
				else
					print("      |cffff8080description: EMPTY|r — the game offers no source text")
				end
			else
				print(("   |cffff8080%s  id %s -> no currency info|r"):format(tostring(tier.key), tostring(id)))
			end
		end
	end
	print("   " .. prefix .. " if every description is EMPTY we must source the text elsewhere, not invent it.")
end

--- /mh crestscan — walk the player's whole currency list and show every "crest".
---
--- WHY THIS EXISTS. `/mh crests` only iterates the ids we already know
--- (ns.DAWNCREST_TIERS), so it is blind to any currency Blizzard ADDS. On the 12.1
--- PTR with M+ season 18 live, that probe still reported six "Dawncrest" entries
--- describing "Midnight Season 1" — which proves the old ids did not change, but
--- says nothing about whether new Season 2 crests exist under different ids.
--- Datamined sources call them "Mistcrest"; this answers whether the game agrees,
--- before anyone renames 300+ strings on the strength of a guide.
---
--- Walks C_CurrencyInfo.GetCurrencyListSize/GetCurrencyListInfo — the same pair
--- Baganator uses for the currency panel (CurrencyPanel.lua:498), so this is the
--- list the player's own Currencies tab shows.
---
--- Honest limit: a currency the character has never seen may not be listed at all.
--- "Not found" therefore means "not in your list", not "does not exist".
function ns.PrintCrestScan()
	local prefix = ("|cffffcc00%s|r"):format(ns.L and ns:L("PRINT_PREFIX") or "MH")
	if not (C_CurrencyInfo and C_CurrencyInfo.GetCurrencyListSize and C_CurrencyInfo.GetCurrencyListInfo) then
		print(prefix .. " currency list API not available")
		return
	end
	local okSize, size = pcall(C_CurrencyInfo.GetCurrencyListSize)
	if not okSize or not size or size == 0 then
		print(prefix .. " currency list is empty (open the Currencies tab once, then retry)")
		return
	end
	print(("%s Currency list — every entry with \"crest\" in the name (%d rows):"):format(prefix, size))
	local header, hits = "?", 0
	for i = 1, size do
		local okI, info = pcall(C_CurrencyInfo.GetCurrencyListInfo, i)
		if okI and type(info) == "table" and info.name then
			if info.isHeader then
				header = info.name
			elseif info.name:lower():find("crest") then
				hits = hits + 1
				print(("   |cff40c040%-26s|r id %-6s qty %-6s  [%s]"):format(
					info.name, tostring(info.currencyID), tostring(info.quantity), header))
			end
		end
	end
	if hits == 0 then
		print("   |cffff8080no currency with \"crest\" in the name is in your list|r")
	end
	print("   " .. prefix .. " |cff8a8f98a currency you have never seen may not be listed at all - absence is not proof.|r")
end

--- /mh crestfind — scan a range of currency ids and name every crest the GAME knows.
---
--- The last resort when a currency is not in your list. `/mh crestscan` walks the
--- player's own currency list, so a currency this character never earned is simply
--- absent (Rob, PTR 2026-07-24: zero crests on that character, so nothing to see).
--- GetCurrencyInfo works on ANY id though, so a numeric sweep finds currencies the
--- character has never touched.
---
--- Why it matters: the handoff calls "Mistcrest" confirmed on the strength of
--- datamining sites, but the PTR's own Season 2 header showed "Venomblight
--- Manaflux" while Season 1 uses "Dawnlight Manaflux" and "Dawncrest" — a Dawn→Venom
--- family rename, not Dawn→Mist. Rather than swap one guess for another, this asks
--- the client and prints whatever it answers.
---
--- Matches on "crest" and "manaflux" so the season-currency family shows up too.
--- Range is deliberate, not magic: Midnight currencies observed so far sit in
--- 3300-3400 (Dawncrests 3341-3347/3383, Voidlight Marl 3316, Moxie 3402), so a
--- sweep to 3700 covers those plus room for Season 2 additions.
function ns.PrintCrestFind(fromID, toID)
	local prefix = ("|cffffcc00%s|r"):format(ns.L and ns:L("PRINT_PREFIX") or "MH")
	if not (C_CurrencyInfo and C_CurrencyInfo.GetCurrencyInfo) then
		print(prefix .. " currency API not available")
		return
	end
	local a = math.floor(tonumber(fromID) or 3300)
	local b = math.floor(tonumber(toID) or 3700)
	if b < a then
		a, b = b, a
	end
	print(("%s Scanning currency ids %d-%d for \"crest\" / \"manaflux\":"):format(prefix, a, b))
	local hits = 0
	for id = a, b do
		local ok, info = pcall(C_CurrencyInfo.GetCurrencyInfo, id)
		if ok and type(info) == "table" and type(info.name) == "string" and info.name ~= "" then
			local lower = info.name:lower()
			if lower:find("crest") or lower:find("manaflux") then
				hits = hits + 1
				local desc = info.description
				local season = ""
				if type(desc) == "string" and desc ~= "" then
					-- The description names the season it belongs to; that single line is
					-- what tells S1 apart from S2 without us assuming anything.
					season = desc:match("(Season %d)") or ""
				end
				print(("   |cff40c040%-28s|r id %-6s qty %-6s %s"):format(
					info.name, tostring(id), tostring(info.quantity), season))
			end
		end
	end
	if hits == 0 then
		print("   |cffff8080nothing matched in that range|r — try a wider one: /mh crestfind 3000 4200")
	end
	print("   " .. prefix .. " |cff8a8f98names come from your client, not from a guide.|r")
end
