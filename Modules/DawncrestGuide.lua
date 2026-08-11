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

--- The currency ids this tier uses THIS season, primary first.
---
--- Season 2 renames the crests (Dawncrest -> Mistcrest) and renumbers them, so the
--- Season 1 ids stop being the ones you earn. Ids measured on the 12.1 PTR and
--- confirmed by the game itself on 31 July -- it named 3437/3442 "Adventurer
--- Mistcrest" -- see DawncrestData's header for what about them is still unverified.
---
--- One function because the choice was briefly made in three places and two of them
--- were missed: the row's NUMBER came from the right season while its icon and
--- tooltip stayed bound to the Season 1 id, so the PTR showed a Mistcrest balance
--- under a tooltip reading "Myth Dawncrest ... Midnight Season 1" (Rob, 31 jul).
--- @return table ids, number|nil primary
local function TierCurrencyIds(tier)
	if type(tier) ~= "table" then
		return {}, nil
	end
	local primary, alternates = tier.currencyId, tier.alternateCurrencyIds
	if ns.IsSeason2Live and ns.IsSeason2Live() and tier.season2CurrencyId then
		primary, alternates = tier.season2CurrencyId, tier.season2AlternateCurrencyIds
	end
	local ids = { primary }
	if type(alternates) == "table" then
		for i = 1, #alternates do
			ids[#ids + 1] = alternates[i]
		end
	end
	return ids, primary
end

local function GetTierCurrencyQty(tier)
	if type(tier) ~= "table" then
		return 0, 0, 0
	end
	local ids = TierCurrencyIds(tier)
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
		-- Ask the server for BOTH seasons. This used to request the Season 1 ids only,
		-- so in Season 2 the panel could read a balance the client had never been sent
		-- -- and a currency the server has not pushed reads as zero, which is
		-- indistinguishable from having none.
		local ids = {}
		for _, id in ipairs({
			tier and tier.currencyId,
			tier and tier.season2CurrencyId,
		}) do
			ids[#ids + 1] = id
		end
		for _, list in ipairs({
			(tier and tier.alternateCurrencyIds) or {},
			(tier and tier.season2AlternateCurrencyIds) or {},
		}) do
			for j = 1, #list do
				ids[#ids + 1] = list[j]
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
		-- The "«…of the Dawn» achievements give 50% discount" line is Season 1 only:
		-- those achievements stop being obtainable when the season ends, so in Season 2
		-- it promises a discount nobody can still earn. Same silence as the per-tier
		-- row and GetNextDawnAchievement -- and it was still on screen on the PTR with
		-- the season flipped, which is how Rob found it (31 jul).
		--
		-- Its own key rather than a sentence buried mid-paragraph, because it had to
		-- disappear in seven languages without disturbing the two sentences around it.
		local text = ns:L("DAWNCREST_GUIDE_SUMMARY")
		if not (ns.IsSeason2Live and ns.IsSeason2Live()) then
			local dawn = ns:L("DAWNCREST_GUIDE_DAWN_DISCOUNT")
			if dawn and dawn ~= "" and dawn ~= "DAWNCREST_GUIDE_DAWN_DISCOUNT" then
				text = text .. "|n|n" .. dawn
			end
		end
		summary:SetText(text)
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
				-- Season-aware, or the icon and its tooltip describe a currency the
				-- row is not counting.
				local _, activeId = TierCurrencyIds(tier)
				SetRowIcon(row.icon, activeId)
				BindCrestIconTooltip(row.iconBtn, activeId)
				local rowFrame = row.row
				if row.ach and rowFrame and rowFrame.SetHeight then
					-- Rijhoogtes schalen mee met de tekst (matcht build-layout);
					-- crestBlock-hoogte hieronder leest GetHeight() terug, dus blijft synchroon.
					-- The achievement ids are Season 1 only. In Season 2 they still
					-- resolve -- you keep the achievement -- but naming "Veteran of
					-- the Dawn" as this season's discount would point at a reward
					-- that is no longer the one being earned. Silence until the
					-- Season 2 ids are captured (DawncrestData header).
					local achId = tier.achievementId
					if ns.IsSeason2Live and ns.IsSeason2Live() then
						achId = tier.season2AchievementId
					end
					if IsAchievementComplete(achId) then
						-- Prefer the game's own name: it is already in the player's
						-- language and cannot drift from the client, which is why
						-- GetNextDawnAchievement does the same. Our label is the
						-- fallback for when the achievement API says nothing.
						local shown = ns:L(tier.achLabelKey)
						if GetAchievementInfo then
							local okA, _, achName = pcall(GetAchievementInfo, achId)
							if okA and type(achName) == "string" and achName ~= "" then
								shown = achName
							end
						end
						row.ach:SetText(ns:L("DAWNCREST_ACH_DONE_FMT"):format(shown))
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
--- `/mh crests` prints; `/mh crests save` writes the same rows to
--- ns.db.crestProbe and asks for a /reload so they reach the file.
---
--- The saved form exists because this probe is now long: five tiers times up to
--- four ids each, four lines apiece. Rob does not screenshot eighty chat lines,
--- and the standing agreement since 27 July is that long diagnostics go to
--- SavedVariables and get read from disk.
---
--- @param save boolean|nil  true = collect into ns.db.crestProbe instead of chat
function ns.PrintCrestProbe(save)
	local prefix = ("|cffffcc00%s|r"):format(ns.L and ns:L("PRINT_PREFIX") or "MH")
	if not (C_CurrencyInfo and C_CurrencyInfo.GetCurrencyInfo) then
		print(prefix .. " no currency API")
		return
	end
	local rows = {}
	local function emit(line, row)
		if save then
			if row then
				rows[#rows + 1] = row
			end
		else
			print(line)
		end
	end

	if not save then
		print(prefix .. " Crest tiers — what the game says about each one:")
	end
	for _, tier in ipairs(ns.DAWNCREST_TIERS or {}) do
		-- Season 2 ids included, or this probe cannot answer the question it is
		-- being run for. They were added to the data on 31 July but not here, so on
		-- the PTR it would have walked five Season 1 tiers and never mentioned a
		-- Mistcrest -- and which of Season 2's two id sets is the real one is
		-- precisely what still needs measuring (DawncrestData header).
		local ids, season = {}, {}
		local function add(id, tag)
			if id then
				ids[#ids + 1] = id
				season[id] = tag
			end
		end
		add(tier.currencyId, "S1")
		for _, alt in ipairs(tier.alternateCurrencyIds or {}) do
			add(alt, "S1-alt")
		end
		add(tier.season2CurrencyId, "S2")
		for _, alt in ipairs(tier.season2AlternateCurrencyIds or {}) do
			add(alt, "S2-alt")
		end

		for _, id in ipairs(ids) do
			local ok, info = pcall(C_CurrencyInfo.GetCurrencyInfo, id)
			if ok and type(info) == "table" then
				local row = {
					tier = tier.key,
					season = season[id],
					id = id,
					name = tostring(info.name),
					quantity = info.quantity,
					maxQuantity = info.maxQuantity,
					maxWeeklyQuantity = info.maxWeeklyQuantity,
					earnedThisWeek = info.quantityEarnedThisWeek,
					totalEarned = info.totalEarned,
					description = (type(info.description) == "string" and info.description ~= "")
						and info.description or nil,
					achievementId = tier.achievementId,
				}
				emit(("   |cff40c040%s|r  %s id %d  =  %s   (have %s)"):format(
					tostring(tier.key), season[id], id, tostring(info.name), tostring(info.quantity)), row)
				-- Does this tier actually have a cap? Our summary text claims "a weekly
				-- cap (~100)" per colour, but Blizzard's currency tab shows the crests
				-- as a bare number while genuinely capped currencies render as "x / y".
				-- The tilde says that number was always an estimate. Print the real
				-- fields so the claim can be kept, corrected, or dropped.
				emit(("      maxQuantity=%s  maxWeeklyQuantity=%s  earnedThisWeek=%s  totalEarned=%s"):format(
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
					row.achievementName = (okA and achName) or nil
					row.achievementEarned = (okA and achDone) or nil
					emit(("      achievement %s -> %s%s"):format(
						tostring(tier.achievementId),
						(okA and achName) and ("|cffffffff" .. achName .. "|r") or "|cffff8080NO SUCH ACHIEVEMENT|r",
						(okA and achDone) and "  |cff44ff44(earned)|r" or ""))
				end
				local desc = info.description
				if type(desc) == "string" and desc ~= "" then
					emit("      description: " .. desc)
				else
					emit("      |cffff8080description: EMPTY|r — the game offers no source text")
				end
			else
				emit(("   |cffff8080%s  id %s -> no currency info|r"):format(tostring(tier.key), tostring(id)))
			end
		end
	end
	if save then
		if not ns.db then
			print(prefix .. " |cffff8080cannot save: saved variables are not ready|r")
			return
		end
		ns.db.crestProbe = {
			rows = rows,
			seasonTwoLive = (ns.IsSeason2Live and ns.IsSeason2Live()) or false,
			-- The season state belongs in the file. Reading "Mistcrest, have 0" without
			-- it cannot tell an id that does not exist yet from a season that has not
			-- flipped, and those call for opposite conclusions.
		}
		print(("%s crest probe saved: %d rows -> ns.db.crestProbe. Now |cffffffff/reload|r so it reaches the file."):format(
			prefix, #rows))
		return
	end
	-- ANSWERED 31 jul: they are NOT empty. The game returns item level ranges, the
	-- crafting range, and a full source list per tier -- "Earned from: Repeatable
	-- Outdoor Events, Tier 4 Delves, Prey Hunts (Normal)" -- already in the player's
	-- language. So the source text never has to be hand-maintained or guessed, and
	-- the tooltip on each crest icon (SetCurrencyByID) already shows it.
	--
	-- Still unused anywhere: the ITEM LEVEL RANGE per tier. That is the answer to
	-- "which crest do I actually need", and it is sitting in this field.
	print("   " .. prefix .. " descriptions are populated (verified 31 jul) — never hand-write crest sources.")
end

--- The Currencies page's own ids, one line each — the second half of `/mh crestscan`.
---
--- The sweep below only recognises a currency by having "crest" in its NAME, so the two
--- hand-written ids on that page — Voidlight Marl and Field Accolade — were the one
--- thing it could not report on. Rob asked the right question on 11 Aug 2026, the
--- evening before 12.1: will that page still be correct tomorrow?
---
--- This answers it. `GetCurrencyInfo` works on ANY id, listed or not, so unlike the
--- sweep an empty answer here is real: the client does not know that currency. The ids
--- come from the page itself, not from a copy kept here, so this can never approve an
--- id the panel stopped using.
---
--- ⚠️ Separate from the sweep on purpose. The sweep gives up when the currency list is
--- still empty — a real state, right after a reload — and that must not take this half
--- down with it, because this half does not need the list at all.
local function PrintPageCurrencies(prefix)
	if not (C_CurrencyInfo and C_CurrencyInfo.GetCurrencyInfo) then
		return
	end
	local ids = ns.MH_CurrencyGuideIds and ns.MH_CurrencyGuideIds() or nil
	if type(ids) ~= "table" or #ids == 0 then
		return
	end
	print(("%s Currencies page — the %d ids it renders:"):format(prefix, #ids))
	local unknown = 0
	for _, id in ipairs(ids) do
		local okI, info = pcall(C_CurrencyInfo.GetCurrencyInfo, id)
		local name = okI and type(info) == "table" and info.name or nil
		if name and name ~= "" then
			print(("   |cff40c040%-26s|r id %-6d qty %s"):format(name, id, tostring(info.quantity)))
		else
			unknown = unknown + 1
			print(("   |cffff8080%-26s|r id %-6d |cffff8080the client does not know this currency|r"):format("?", id))
		end
	end
	if unknown > 0 then
		print(("   |cffff8080%d id(s) gone — the Currencies page is showing a dead entry.|r"):format(unknown))
	end
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
		PrintPageCurrencies(prefix)
		return
	end
	local okSize, size = pcall(C_CurrencyInfo.GetCurrencyListSize)
	if not okSize or not size or size == 0 then
		print(prefix .. " currency list is empty (open the Currencies tab once, then retry)")
		PrintPageCurrencies(prefix)
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
	PrintPageCurrencies(prefix)
end

--- /mh crestfind — scan a range of currency ids and name every crest the GAME knows.
---
--- The last resort when a currency is not in your list. `/mh crestscan` walks the
--- player's own currency list, so a currency this character never earned is simply
--- absent (Rob, PTR 2026-07-24: zero crests on that character, so nothing to see).
--- GetCurrencyInfo works on ANY id though, so a numeric sweep finds currencies the
--- character has never touched.
---
--- Why it was written (2026-07-24, BEFORE this function had been run): the handoff
--- called "Mistcrest" confirmed on the strength of datamining sites, but the PTR's
--- own Season 2 header showed "Venomblight Manaflux" while Season 1 uses "Dawnlight
--- Manaflux" and "Dawncrest" — suggesting a Dawn→Venom family rename, not Dawn→Mist.
--- Rather than swap one guess for another, this asks the client and prints whatever
--- it answers.
---
--- ⚠ AND THEN IT ANSWERED, and the Dawn→Venom reading above was WRONG. The crests
--- are Mistcrest; Venomblight is the manaflux family only. The handoff was right all
--- along. See docs/CREST_SOURCES_MEASURED.md §SETTLED for the captured ids, which
--- DawncrestData now ships.
---
--- The reasoning stays because it is honest history and shows what the function is
--- for. This warning exists because without it that history reads as current: a
--- second session took it at face value on 30 jul and reported NavSearch's
--- "mistcrest" keyword as a guess dressed up as fact. NavSearch was right. A
--- superseded hypothesis in the present tense is not a neutral leftover — it argues.
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

--- The next "of the Dawn" achievement still to earn, for the season-end checklist.
--- @return table|nil { name=, id=, allDone=, remaining= } — nil when unreadable
---
--- The five tiers are item-level milestones (Adventurer → Myth) that grant a 50%
--- upgrade discount across the whole Warband, and Blizzard announced on 2026-07-25
--- that they become unobtainable when Season 1 ends. Rob had three of five on live.
---
--- Reports only the FIRST one still open: the list is progressive, so naming the
--- next reachable tier is actionable where five separate lines would just be noise.
---
--- The NAME comes from GetAchievementInfo, not from our own DAWNCREST_ACH_* labels —
--- it is already in the player's language and cannot drift from the game. All five
--- ids were verified in-game 2026-07-25 (see DawncrestData's header).
---
--- nil means the achievement API told us nothing. The caller must not read that as
--- "you have them all".
function ns.GetNextDawnAchievement()
	local tiers = ns.DAWNCREST_TIERS
	if type(tiers) ~= "table" or not GetAchievementInfo then
		return nil
	end
	-- Once Season 2 opens these stop being reachable -- Blizzard said so on
	-- 2026-07-25, and it is written three paragraphs up. The ids keep resolving,
	-- because you keep an achievement you earned, so without this the panel would go
	-- on nominating "the next one to chase" for a reward nobody can earn any more.
	-- nil is the existing "we cannot say" answer and callers already treat it as
	-- such; the Season 2 ids are not captured yet (DawncrestData header).
	if ns.IsSeason2Live and ns.IsSeason2Live() then
		return nil
	end
	local firstOpen, remaining, sawAny = nil, 0, false
	for i = 1, #tiers do
		local id = tiers[i] and tiers[i].achievementId
		if id then
			local ok, _, achName, _, completed = pcall(GetAchievementInfo, id)
			if ok and achName then
				sawAny = true
				if not completed then
					remaining = remaining + 1
					if not firstOpen then
						firstOpen = { id = id, name = achName }
					end
				end
			end
		end
	end
	if not sawAny then
		return nil -- nothing resolved: say nothing rather than claim completion
	end
	return {
		id = firstOpen and firstOpen.id or nil,
		name = firstOpen and firstOpen.name or nil,
		remaining = remaining,
		allDone = (remaining == 0),
	}
end
