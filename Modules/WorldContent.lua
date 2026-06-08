--[[
	Void & Rituals — combined Midnight (12.0.5) world-content tab. Ritual Sites
	and Void Assaults are siblings: same two zones (Eversong Woods / Zul'Aman),
	the same Bazaar hub, the same Field Accolades currency and the same renown
	faction. This tab shows them together — a shared header (currency, renown,
	hub) on top, then a focused section for each system.

	The detection / routing / weekly logic lives in RitualSites.lua and
	VoidAssaults.lua; this module only owns the combined panel and pulls data
	through the public ns.* helpers those modules expose.

	The panel is scrollable (like Home) because the combined content can get tall
	on smaller windows. Widgets are created once and re-stacked on refresh so that
	lines which hide (no active site, no currency yet) don't leave gaps.
]]

local _, ns = ...

local SIDE_PAD = 14
local TOP_PAD = 12
local BTN_H = 26

local COLOR_HEADER = { 0.82, 0.68, 0.30 }
local COLOR_DIM = { 0.75, 0.78, 0.82 }
local COLOR_GOOD = { 0.45, 0.95, 0.5 }
local COLOR_SOFT = { 0.9, 0.82, 0.45 }
local COLOR_WARN = { 1, 0.84, 0.18 }
local COLOR_ACCOLADE = { 0.55, 0.78, 1 }
local COLOR_RENOWN = { 0.7, 0.6, 0.95 }

local ui

--------------------------------------------------------------------------------
-- Helpers
--------------------------------------------------------------------------------

local function SiteLabel(site, active)
	local zone = ns.RitualSiteZoneName and ns.RitualSiteZoneName(site) or nil
	local label = zone and (site.name .. " — " .. zone) or site.name
	if active then
		label = label .. "  |cffffcc00[" .. ns:L("RITUAL_ACTIVE_BADGE") .. "]|r"
	end
	return label
end

local function OtherEntry(list, activeKey)
	if not list or not activeKey then
		return nil
	end
	for _, e in ipairs(list) do
		if e.key ~= activeKey then
			return e
		end
	end
	return nil
end

--------------------------------------------------------------------------------
-- Layout
--------------------------------------------------------------------------------

-- Re-stack every visible element top-to-bottom inside the scroll child. Called
-- after each refresh and whenever the scroll width changes.
local function Relayout()
	if not ui or not ui.child then
		return
	end
	local width = ui.child:GetWidth()
	if not width or width <= 0 then
		return
	end
	local y = 4
	for _, el in ipairs(ui.order) do
		local w = el.w
		if w:IsShown() then
			local indent = el.indent or 0
			y = y + (el.gapTop or 0)
			w:ClearAllPoints()
			w:SetPoint("TOPLEFT", ui.child, "TOPLEFT", indent, -y)
			w:SetWidth(math.max(width - indent, 1))
			if el.button then
				y = y + BTN_H
			else
				y = y + math.max(w:GetStringHeight() or 0, 1)
			end
		end
	end
	ui.child:SetHeight(math.max(y + 8, 1))
end

--------------------------------------------------------------------------------
-- Refresh
--------------------------------------------------------------------------------

function ns.RefreshWorldPanel()
	if not ui or not ui.panel or not ui.panel:IsVisible() then
		return
	end

	-- Shared: Field Accolades (live, with weekly cap when present).
	do
		local n, wkThis, wkMax
		if ns.GetRitualAccoladeInfo then
			n, wkThis, wkMax = ns.GetRitualAccoladeInfo()
		end
		if n then
			if wkMax and wkMax > 0 then
				ui.accoladesFs:SetText(ns:L("RITUAL_INFO_ACCOLADES_WEEKLY_FMT"):format(n, wkThis or 0, wkMax))
			else
				ui.accoladesFs:SetText(ns:L("RITUAL_INFO_ACCOLADES_FMT"):format(n))
			end
			ui.accoladesFs:Show()
		else
			ui.accoladesFs:Hide()
		end
	end

	-- Shared: Ritual Sites renown.
	do
		local txt = ns.GetRitualRenownText and ns.GetRitualRenownText()
		if txt and txt ~= "" then
			ui.renownFs:SetText(ns:L("RITUAL_RENOWN_LABEL") .. ": " .. txt)
			ui.renownFs:SetTextColor(COLOR_RENOWN[1], COLOR_RENOWN[2], COLOR_RENOWN[3])
		else
			ui.renownFs:SetText(ns:L("RITUAL_RENOWN_LOCKED"))
			ui.renownFs:SetTextColor(0.6, 0.62, 0.68)
		end
	end

	---------------------------------------------------------------- Ritual Sites
	local activeSite = ns.GetActiveRitualSite and ns.GetActiveRitualSite() or nil
	if activeSite then
		ui.ritualActiveFs:SetText(ns:L("RITUAL_ACTIVE_FMT"):format(SiteLabel(activeSite, false)))
		ui.ritualActiveFs:SetTextColor(1, 0.84, 0.18)
	else
		ui.ritualActiveFs:SetText(ns:L("RITUAL_ACTIVE_UNKNOWN"))
		ui.ritualActiveFs:SetTextColor(COLOR_DIM[1], COLOR_DIM[2], COLOR_DIM[3])
	end

	local nextSite = OtherEntry(ns.GetRitualSites and ns.GetRitualSites(), activeSite and activeSite.key)
	if nextSite then
		ui.ritualNextFs:SetText(ns:L("RITUAL_NEXT_FMT"):format(SiteLabel(nextSite, false)))
		ui.ritualNextFs:Show()
	else
		ui.ritualNextFs:Hide()
	end

	if ns.IsRitualWeeklyDone and ns.IsRitualWeeklyDone() then
		ui.ritualWeeklyFs:SetText(ns:L("RITUAL_WEEKLY_DONE"))
		ui.ritualWeeklyFs:SetTextColor(COLOR_GOOD[1], COLOR_GOOD[2], COLOR_GOOD[3])
	else
		ui.ritualWeeklyFs:SetText(ns:L("RITUAL_WEEKLY_TODO"))
		ui.ritualWeeklyFs:SetTextColor(COLOR_SOFT[1], COLOR_SOFT[2], COLOR_SOFT[3])
	end

	for _, btn in ipairs(ui.siteButtons) do
		local site = btn._mhSite
		local isActive = activeSite and activeSite.key == site.key
		btn:SetText(SiteLabel(site, isActive))
	end

	--------------------------------------------------------------- Void Assaults
	local activeZone = ns.GetActiveVoidAssaultZone and ns.GetActiveVoidAssaultZone() or nil
	if activeZone then
		ui.voidActiveFs:SetText(ns:L("VOID_ACTIVE_FMT"):format(ns.VoidZoneName(activeZone)))
		ui.voidActiveFs:SetTextColor(1, 0.84, 0.18)
	else
		ui.voidActiveFs:SetText(ns:L("VOID_ACTIVE_UNKNOWN"))
		ui.voidActiveFs:SetTextColor(COLOR_DIM[1], COLOR_DIM[2], COLOR_DIM[3])
	end

	local nextZone = OtherEntry(ns.GetVoidZones and ns.GetVoidZones(), activeZone and activeZone.key)
	if nextZone then
		ui.voidNextFs:SetText(ns:L("VOID_NEXT_FMT"):format(ns.VoidZoneName(nextZone)))
		ui.voidNextFs:Show()
	else
		ui.voidNextFs:Hide()
	end

	if ns.IsVoidAssaultWeeklyDone and ns.IsVoidAssaultWeeklyDone() then
		ui.voidWeeklyFs:SetText(ns:L("VOID_WEEKLY_DONE"))
		ui.voidWeeklyFs:SetTextColor(COLOR_GOOD[1], COLOR_GOOD[2], COLOR_GOOD[3])
	else
		ui.voidWeeklyFs:SetText(ns:L("VOID_WEEKLY_TODO"))
		ui.voidWeeklyFs:SetTextColor(COLOR_SOFT[1], COLOR_SOFT[2], COLOR_SOFT[3])
	end

	------------------------------------------------------ Showdowns (12.0.7)
	-- Hidden entirely on pre-12.0.7 clients; data fields for Val are nil until
	-- the next PTR rotation, so every line nil-checks (never lie).
	local sdAvailable = ns.IsShowdownsAvailable and ns.IsShowdownsAvailable()
	for _, w in ipairs(ui.sdWidgets) do
		w:SetShown(sdAvailable and true or false)
	end
	if sdAvailable then
		local activeWorld = ns.GetActiveShowdownZone and ns.GetActiveShowdownZone() or nil
		if activeWorld then
			ui.sdActiveFs:SetText(ns:L("SHOWDOWNS_ACTIVE_FMT"):format(ns.ShowdownZoneName(activeWorld)))
			ui.sdActiveFs:SetTextColor(COLOR_WARN[1], COLOR_WARN[2], COLOR_WARN[3])
		else
			ui.sdActiveFs:SetText(ns:L("SHOWDOWNS_ACTIVE_UNKNOWN"))
			ui.sdActiveFs:SetTextColor(COLOR_DIM[1], COLOR_DIM[2], COLOR_DIM[3])
		end

		local nextWorld = OtherEntry(ns.GetShowdownZones and ns.GetShowdownZones(), activeWorld and activeWorld.key)
		if nextWorld then
			ui.sdNextFs:SetText(ns:L("SHOWDOWNS_NEXT_FMT"):format(ns.ShowdownZoneName(nextWorld)))
		else
			ui.sdNextFs:Hide()
		end

		if ns.IsShowdownWeeklyDone and ns.IsShowdownWeeklyDone() then
			ui.sdWeeklyFs:SetText(ns:L("SHOWDOWNS_WEEKLY_DONE"))
			ui.sdWeeklyFs:SetTextColor(COLOR_GOOD[1], COLOR_GOOD[2], COLOR_GOOD[3])
		else
			local pct = ns.GetShowdownWeeklyProgress and ns.GetShowdownWeeklyProgress()
			if pct then
				ui.sdWeeklyFs:SetText(ns:L("SHOWDOWNS_WEEKLY_PROGRESS_FMT"):format(pct))
			else
				ui.sdWeeklyFs:SetText(ns:L("SHOWDOWNS_WEEKLY_TODO"))
			end
			ui.sdWeeklyFs:SetTextColor(COLOR_SOFT[1], COLOR_SOFT[2], COLOR_SOFT[3])
		end

		local bossName, bossDone = nil, nil
		if ns.GetShowdownWorldBossStatus then
			bossName, bossDone = ns.GetShowdownWorldBossStatus()
		end
		if bossName then
			if bossDone == true then
				ui.sdBossFs:SetText(ns:L("SHOWDOWNS_BOSS_DONE_FMT"):format(bossName))
				ui.sdBossFs:SetTextColor(COLOR_GOOD[1], COLOR_GOOD[2], COLOR_GOOD[3])
			elseif bossDone == false then
				ui.sdBossFs:SetText(ns:L("SHOWDOWNS_BOSS_TODO_FMT"):format(bossName))
				ui.sdBossFs:SetTextColor(COLOR_SOFT[1], COLOR_SOFT[2], COLOR_SOFT[3])
			else
				-- Kill-quest id unknown (Val, until verified): show the boss
				-- without claiming a weekly status.
				ui.sdBossFs:SetText(ns:L("SHOWDOWNS_BOSS_UNKNOWN_FMT"):format(bossName))
				ui.sdBossFs:SetTextColor(COLOR_DIM[1], COLOR_DIM[2], COLOR_DIM[3])
			end
		else
			ui.sdBossFs:Hide()
		end

		local inZone, hasWT = false, false
		if ns.GetShowdownHWTInfo then
			inZone, hasWT = ns.GetShowdownHWTInfo()
		end
		if inZone and hasWT then
			ui.sdHwtFs:SetText(ns:L("SHOWDOWNS_HWT_AVAILABLE"))
			ui.sdHwtFs:SetTextColor(COLOR_ACCOLADE[1], COLOR_ACCOLADE[2], COLOR_ACCOLADE[3])
		else
			ui.sdHwtFs:Hide()
		end

		-- Portal waypoint button only once the Voidstorm uiMapID is verified.
		local portal = ns.SHOWDOWNS and ns.SHOWDOWNS.portalVoidstorm
		if not (portal and portal.mapID) then
			ui.sdPortalBtn:Hide()
		end
	end

	------------------------------------------------------------- Ritual Coach
	if ui.coachHeader then
		local entry = ns.GetRitualCoachActiveSiteEntry and ns.GetRitualCoachActiveSiteEntry() or nil
		if entry then
			ui.coachActiveFs:SetText(ns:L("RITUAL_COACH_ACTIVE_FMT"):format(ns:L(entry.nameKey)))
			ui.coachActiveFs:SetTextColor(COLOR_WARN[1], COLOR_WARN[2], COLOR_WARN[3])
			-- Site sections: [1]=overview (shown in the block above), [2]=phases,
			-- [3]=notes. Show scenario + site notes here (overview is redundant).
			local phasesKey = entry.sections and entry.sections[2] and entry.sections[2].bodyKey
			local notesKey = entry.sections and entry.sections[3] and entry.sections[3].bodyKey
			if phasesKey then
				ui.coachPhasesFs:SetText(ns:L(phasesKey))
				ui.coachPhasesFs:Show()
			else
				ui.coachPhasesFs:Hide()
			end
			if notesKey then
				ui.coachNotesFs:SetText(ns:L(notesKey))
				ui.coachNotesFs:Show()
			else
				ui.coachNotesFs:Hide()
			end
		else
			ui.coachActiveFs:SetText(ns:L("RITUAL_COACH_ACTIVE_UNKNOWN"))
			ui.coachActiveFs:SetTextColor(COLOR_DIM[1], COLOR_DIM[2], COLOR_DIM[3])
			ui.coachPhasesFs:Hide()
			ui.coachNotesFs:Hide()
		end

		for _, row in ipairs(ui.coachChalRows) do
			row.titleFs:SetText(ns.BuildRitualChallengeTitle and ns.BuildRitualChallengeTitle(row.challenge) or "")
			-- "How to unlock" only matters while it is still locked.
			local unlocked = ns.IsRitualChallengeUnlocked and ns.IsRitualChallengeUnlocked(row.challenge)
			row.unlockFs:SetShown(not unlocked)
		end
	end

	Relayout()
end

--------------------------------------------------------------------------------
-- Build
--------------------------------------------------------------------------------

local function MakeFS(parent, font, color)
	local fs = parent:CreateFontString(nil, "OVERLAY", font)
	fs:SetJustifyH("LEFT")
	fs:SetWordWrap(true)
	if color then
		fs:SetTextColor(color[1], color[2], color[3])
	end
	return fs
end

local function MakeButton(parent, onClick)
	local btn = CreateFrame("Button", nil, parent, "UIPanelButtonTemplate")
	btn:SetHeight(BTN_H)
	local fs = btn.GetFontString and btn:GetFontString()
	if fs then
		fs:SetJustifyH("LEFT")
		fs:ClearAllPoints()
		fs:SetPoint("LEFT", btn, "LEFT", 8, 0)
		fs:SetPoint("RIGHT", btn, "RIGHT", -8, 0)
	end
	btn:SetScript("OnClick", onClick)
	return btn
end

function ns.BuildWorldPanel(panel)
	if not panel or panel._mhWorldBuilt then
		return
	end
	panel._mhWorldBuilt = true

	if panel._body then
		panel._body:Hide()
	end
	if panel._header then
		panel._header:Hide()
	end

	local title = panel:CreateFontString(nil, "OVERLAY", "GameFontHighlightLarge")
	title:SetPoint("TOPLEFT", panel, "TOPLEFT", SIDE_PAD, -TOP_PAD)
	title:SetText(ns:L("TAB_WORLD"))

	local subtitle = panel:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	subtitle:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -4)
	subtitle:SetPoint("RIGHT", panel, "RIGHT", -SIDE_PAD, 0)
	subtitle:SetJustifyH("LEFT")
	subtitle:SetWordWrap(true)
	subtitle:SetTextColor(COLOR_DIM[1], COLOR_DIM[2], COLOR_DIM[3])
	subtitle:SetText(ns:L("WORLD_SUBTITLE"))

	local scroll = CreateFrame("ScrollFrame", "MidnightHelperWorldScroll", panel, "UIPanelScrollFrameTemplate")
	scroll:SetPoint("TOPLEFT", subtitle, "BOTTOMLEFT", 0, -12)
	scroll:SetPoint("BOTTOMRIGHT", panel, "BOTTOMRIGHT", -30, 14)

	local child = CreateFrame("Frame", nil, scroll)
	child:SetSize(1, 1)
	scroll:SetScrollChild(child)

	ui = {
		panel = panel,
		title = title,
		subtitle = subtitle,
		scroll = scroll,
		child = child,
		order = {},
		siteButtons = {},
		infoLines = {},
	}

	local function push(w, gapTop, indent, button)
		ui.order[#ui.order + 1] = { w = w, gapTop = gapTop, indent = indent, button = button }
	end

	-- Shared header block.
	ui.accoladesFs = MakeFS(child, "GameFontHighlightSmall", COLOR_ACCOLADE)
	push(ui.accoladesFs, 0, 0)
	ui.renownFs = MakeFS(child, "GameFontHighlightSmall", COLOR_RENOWN)
	push(ui.renownFs, 2, 0)
	ui.hubBtn = MakeButton(child, function()
		if ns.RouteRitualHub then
			ns.RouteRitualHub()
		end
	end)
	ui.hubBtn:SetText(ns:L("RITUAL_BTN_HUB"))
	push(ui.hubBtn, 8, 0, true)

	-- Ritual Sites section.
	ui.ritualHeader = MakeFS(child, "GameFontNormal", COLOR_HEADER)
	ui.ritualHeader:SetText(ns:L("HOME_SECTION_RITUAL"))
	push(ui.ritualHeader, 14, 0)
	ui.ritualActiveFs = MakeFS(child, "GameFontNormal")
	push(ui.ritualActiveFs, 6, 0)
	ui.ritualNextFs = MakeFS(child, "GameFontDisableSmall")
	push(ui.ritualNextFs, 2, 0)
	ui.ritualWeeklyFs = MakeFS(child, "GameFontHighlightSmall")
	push(ui.ritualWeeklyFs, 4, 0)

	local sites = ns.GetRitualSites and ns.GetRitualSites() or {}
	for i = 1, #sites do
		local site = sites[i]
		local btn = MakeButton(child, function(self)
			if ns.RouteRitualSite then
				ns.RouteRitualSite(self._mhSite)
			end
		end)
		btn._mhSite = site
		btn:SetText(SiteLabel(site, false))
		ui.siteButtons[i] = btn
		push(btn, (i == 1) and 6 or 4, 0, true)
	end

	local ritualInfoKeys = { "RITUAL_INFO_VENDOR", "RITUAL_INFO_TIERS", "RITUAL_INFO_RENOWN_REWARDS" }
	for i = 1, #ritualInfoKeys do
		local fs = MakeFS(child, "GameFontHighlightSmall", COLOR_DIM)
		fs._mhKey = ritualInfoKeys[i]
		fs:SetText("• " .. ns:L(ritualInfoKeys[i]))
		ui.infoLines[#ui.infoLines + 1] = fs
		push(fs, (i == 1) and 8 or 5, 0)
	end

	-- Ritual Coach section (fase 2): active-site scenario/notes, a short "how it
	-- works", and the challenge picker with live unlock state + Spoils %. Text is
	-- swapped per active site / unlock state in RefreshWorldPanel.
	ui.coachHeader = MakeFS(child, "GameFontNormal", COLOR_HEADER)
	ui.coachHeader:SetText(ns:L("RITUAL_COACH_HEADER"))
	push(ui.coachHeader, 16, 0)

	ui.coachActiveFs = MakeFS(child, "GameFontHighlightSmall", COLOR_WARN)
	push(ui.coachActiveFs, 6, 0)
	ui.coachPhasesFs = MakeFS(child, "GameFontHighlightSmall", COLOR_DIM)
	push(ui.coachPhasesFs, 4, 8)
	ui.coachNotesFs = MakeFS(child, "GameFontHighlightSmall", COLOR_DIM)
	push(ui.coachNotesFs, 4, 8)

	ui.coachIntroHeader = MakeFS(child, "GameFontHighlightSmall", COLOR_ACCOLADE)
	ui.coachIntroHeader:SetText(ns:L("RITUAL_COACH_INTRO_NAME"))
	push(ui.coachIntroHeader, 8, 0)
	ui.coachStatic = {}
	if ns.RITUAL_COACH_INTRO and ns.RITUAL_COACH_INTRO.sections then
		for _, sec in ipairs(ns.RITUAL_COACH_INTRO.sections) do
			local fs = MakeFS(child, "GameFontHighlightSmall", COLOR_DIM)
			fs._mhBodyKey = sec.bodyKey
			fs:SetText(ns:L(sec.bodyKey))
			ui.coachStatic[#ui.coachStatic + 1] = fs
			push(fs, 4, 8)
		end
	end

	ui.coachChalHeader = MakeFS(child, "GameFontHighlightSmall", COLOR_ACCOLADE)
	ui.coachChalHeader:SetText(ns:L("RITUAL_COACH_CHALLENGES_HEADER"))
	push(ui.coachChalHeader, 10, 0)
	ui.coachChalRows = {}
	local chals = ns.GetRitualChallengesForDisplay and ns.GetRitualChallengesForDisplay() or {}
	for i = 1, #chals do
		local c = chals[i]
		local titleFs = MakeFS(child, "GameFontHighlightSmall")
		push(titleFs, 8, 0)
		local mechKey = c.sections and c.sections[1] and c.sections[1].bodyKey
		local mechFs = MakeFS(child, "GameFontHighlightSmall", COLOR_DIM)
		if mechKey then
			mechFs._mhBodyKey = mechKey
			mechFs:SetText(ns:L(mechKey))
		end
		push(mechFs, 2, 12)
		local unlockKey = c.sections and c.sections[2] and c.sections[2].bodyKey
		local unlockFs = MakeFS(child, "GameFontDisableSmall", COLOR_SOFT)
		if unlockKey then
			unlockFs._mhBodyKey = unlockKey
			unlockFs:SetText(ns:L(unlockKey))
		end
		push(unlockFs, 2, 12)
		ui.coachChalRows[i] = { challenge = c, titleFs = titleFs, mechFs = mechFs, unlockFs = unlockFs }
	end

	-- Void Assaults section.
	ui.voidHeader = MakeFS(child, "GameFontNormal", COLOR_HEADER)
	ui.voidHeader:SetText(ns:L("HOME_SECTION_VOID"))
	push(ui.voidHeader, 14, 0)
	ui.voidActiveFs = MakeFS(child, "GameFontNormal")
	push(ui.voidActiveFs, 6, 0)
	ui.voidNextFs = MakeFS(child, "GameFontDisableSmall")
	push(ui.voidNextFs, 2, 0)
	ui.voidWeeklyFs = MakeFS(child, "GameFontHighlightSmall")
	push(ui.voidWeeklyFs, 4, 0)

	local voidInfoKeys = { "VOID_INFO_LOOP", "VOID_INFO_GATHER", "VOID_INFO_VAULT" }
	for i = 1, #voidInfoKeys do
		local fs = MakeFS(child, "GameFontHighlightSmall", COLOR_DIM)
		fs._mhKey = voidInfoKeys[i]
		fs:SetText("• " .. ns:L(voidInfoKeys[i]))
		ui.infoLines[#ui.infoLines + 1] = fs
		push(fs, (i == 1) and 8 or 5, 0)
	end

	-- Shared currency/particles note.
	local sharedNote = MakeFS(child, "GameFontHighlightSmall", COLOR_DIM)
	sharedNote._mhKey = "VOID_INFO_SHARED"
	sharedNote:SetText("• " .. ns:L("VOID_INFO_SHARED"))
	ui.infoLines[#ui.infoLines + 1] = sharedNote
	push(sharedNote, 5, 0)

	-- Showdowns (12.0.7) section. Built unconditionally, shown/hidden per
	-- refresh via ns.IsShowdownsAvailable() (client >= 120007).
	ui.sdHeader = MakeFS(child, "GameFontNormal", COLOR_HEADER)
	ui.sdHeader:SetText(ns:L("SHOWDOWNS_HEADER"))
	push(ui.sdHeader, 14, 0)
	ui.sdActiveFs = MakeFS(child, "GameFontNormal")
	push(ui.sdActiveFs, 6, 0)
	ui.sdNextFs = MakeFS(child, "GameFontDisableSmall")
	push(ui.sdNextFs, 2, 0)
	ui.sdWeeklyFs = MakeFS(child, "GameFontHighlightSmall")
	push(ui.sdWeeklyFs, 4, 0)
	ui.sdBossFs = MakeFS(child, "GameFontHighlightSmall")
	push(ui.sdBossFs, 2, 0)
	ui.sdHwtFs = MakeFS(child, "GameFontHighlightSmall")
	push(ui.sdHwtFs, 2, 0)

	ui.sdMaellaBtn = MakeButton(child, function()
		if ns.RouteShowdownIntro then
			ns.RouteShowdownIntro()
		end
	end)
	ui.sdMaellaBtn:SetText(ns:L("SHOWDOWNS_BTN_MAELLA"))
	push(ui.sdMaellaBtn, 8, 0, true)

	ui.sdPortalBtn = MakeButton(child, function()
		if ns.RouteShowdownPortal then
			ns.RouteShowdownPortal()
		end
	end)
	ui.sdPortalBtn:SetText(ns:L("SHOWDOWNS_BTN_PORTAL"))
	push(ui.sdPortalBtn, 4, 0, true)

	local sdInfoKeys = { "SHOWDOWNS_PORTAL_NOTE", "SHOWDOWNS_INFO_VAULT", "SHOWDOWNS_INFO_HWT" }
	ui.sdInfoLines = {}
	for i = 1, #sdInfoKeys do
		local fs = MakeFS(child, "GameFontHighlightSmall", COLOR_DIM)
		fs._mhKey = sdInfoKeys[i]
		fs:SetText("• " .. ns:L(sdInfoKeys[i]))
		ui.infoLines[#ui.infoLines + 1] = fs
		ui.sdInfoLines[i] = fs
		push(fs, (i == 1) and 8 or 5, 0)
	end

	-- One handle for show/hide gating in RefreshWorldPanel.
	ui.sdWidgets = {
		ui.sdHeader, ui.sdActiveFs, ui.sdNextFs, ui.sdWeeklyFs, ui.sdBossFs,
		ui.sdHwtFs, ui.sdMaellaBtn, ui.sdPortalBtn,
	}
	for _, fs in ipairs(ui.sdInfoLines) do
		ui.sdWidgets[#ui.sdWidgets + 1] = fs
	end

	local function syncWidth()
		local w = scroll:GetWidth()
		if w and w > 0 then
			child:SetWidth(w)
			Relayout()
		end
	end
	scroll:SetScript("OnSizeChanged", syncWidth)
	syncWidth()

	panel:SetScript("OnShow", function()
		syncWidth()
		ns.RefreshWorldPanel()
	end)

	ns.WorldPanel = panel
	ns.RefreshWorldPanel()
end

do
	local orig = ns.RefreshLocaleUI
	function ns:RefreshLocaleUI()
		if orig then
			orig(self)
		end
		if ui and ui.title then
			ui.title:SetText(ns:L("TAB_WORLD"))
			ui.subtitle:SetText(ns:L("WORLD_SUBTITLE"))
			ui.hubBtn:SetText(ns:L("RITUAL_BTN_HUB"))
			ui.ritualHeader:SetText(ns:L("HOME_SECTION_RITUAL"))
			ui.voidHeader:SetText(ns:L("HOME_SECTION_VOID"))
			ui.sdHeader:SetText(ns:L("SHOWDOWNS_HEADER"))
			ui.sdMaellaBtn:SetText(ns:L("SHOWDOWNS_BTN_MAELLA"))
			ui.sdPortalBtn:SetText(ns:L("SHOWDOWNS_BTN_PORTAL"))
			for _, fs in ipairs(ui.infoLines) do
				fs:SetText("• " .. ns:L(fs._mhKey))
			end
			if ui.coachHeader then
				ui.coachHeader:SetText(ns:L("RITUAL_COACH_HEADER"))
				ui.coachIntroHeader:SetText(ns:L("RITUAL_COACH_INTRO_NAME"))
				ui.coachChalHeader:SetText(ns:L("RITUAL_COACH_CHALLENGES_HEADER"))
				for _, fs in ipairs(ui.coachStatic) do
					if fs._mhBodyKey then
						fs:SetText(ns:L(fs._mhBodyKey))
					end
				end
				for _, row in ipairs(ui.coachChalRows) do
					if row.mechFs._mhBodyKey then
						row.mechFs:SetText(ns:L(row.mechFs._mhBodyKey))
					end
					if row.unlockFs._mhBodyKey then
						row.unlockFs:SetText(ns:L(row.unlockFs._mhBodyKey))
					end
				end
			end
		end
		if ui and ui.panel and ui.panel:IsShown() then
			ns.RefreshWorldPanel()
		end
	end
end

local ev = CreateFrame("Frame")
ev:RegisterEvent("QUEST_LOG_UPDATE")
ev:RegisterEvent("ZONE_CHANGED_NEW_AREA")
ev:RegisterEvent("PLAYER_ENTERING_WORLD")
ev:RegisterEvent("CURRENCY_DISPLAY_UPDATE")
ev:RegisterEvent("UPDATE_FACTION")
ev:SetScript("OnEvent", function()
	if ui and ui.panel and ui.panel:IsShown() then
		ns.RefreshWorldPanel()
	end
end)
