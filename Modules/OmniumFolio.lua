--[[
	Omnium Folio advisor (Rob-wens 17 jun, 1.8.2). Eigen tab die de 12.0.7
	rune-tree toont: 5 rijen met klikbare {spell}-links (hover = live tooltip),
	een content-type-keuze (M+/Raid/PvP/World) die de aanbevolen pick per rij
	markeert, de unlock-uitleg en een live "x/5 rijen ontgrendeld"-teller uit de
	Folio-questketen.

	never-lie: spell-namen komen live uit de tooltip; aanbevelingen zijn
	ConquestCapped-baselines (geen "BiS"-claim per spec). Account-wide vs
	per-char staat als open vraag in de voet — geen harde bewering. Tab verschijnt
	alleen op clients >= 120007 (12.0.7 live).

	Sjabloon: TierSet.lua (scroll + read-only EditBox + DelveTip-hyperlinks).
]]

local _, ns = ...

local ui

-- RGB-only (de "|cff"-prefix in de body levert de alpha al; geen dubbele "ff").
local GOLD_HEX = "e8c36a"
local BODY_HEX = "dcdde6"
local DIM_HEX = "9aa0a8"

--------------------------------------------------------------------------------
-- Beschikbaarheid + helpers
--------------------------------------------------------------------------------

function ns.IsOmniumFolioAvailable()
	if not ns.OMNIUM_FOLIO then
		return false
	end
	local toc = select(4, GetBuildInfo())
	return (tonumber(toc) or 0) >= 120007
end

local function CurMode()
	local m = ns.db and ns.db.omniumMode
	for _, v in ipairs(ns.OMNIUM_FOLIO.modes) do
		if v == m then
			return m
		end
	end
	return "mplus"
end

function ns.SetOmniumFolioMode(mode)
	if ns.db then
		ns.db.omniumMode = mode
	end
	ns.RefreshOmniumFolioPanel()
end

-- Account-bewuste quest-check: de Folio-unlocks zijn ACCOUNT-BREED (warband).
-- Op een alt die de quest niet zélf deed staat IsQuestFlaggedCompleted op false,
-- terwijl de rij in-game wél open is (Rob bevestigde 20 jun: 96410 per-char=false,
-- account=true). Daarom de OnAccount-API eerst, met de per-character-vlag als
-- fallback, ge-OR'd zodat we nooit ondertellen. Read-only, taint-veilig via pcall.
local function QuestUnlocked(id)
	if C_QuestLog and C_QuestLog.IsQuestFlaggedCompletedOnAccount then
		local ok, done = pcall(C_QuestLog.IsQuestFlaggedCompletedOnAccount, id)
		if ok and done then
			return true
		end
	end
	if C_QuestLog and C_QuestLog.IsQuestFlaggedCompleted then
		local ok, done = pcall(C_QuestLog.IsQuestFlaggedCompleted, id)
		if ok and done then
			return true
		end
	end
	return false
end

-- Hoeveel rijen ontgrendeld: voltooien van unlockQuests[i] ontgrendelt rij i
-- (sequentieel; rij 1 = de intro-quest).
local function UnlockedRows()
	local q = ns.OMNIUM_FOLIO.unlockQuests
	if not (q and C_QuestLog) then
		return 0
	end
	local n = 0
	for i = 1, #q do
		if QuestUnlocked(q[i]) then
			n = i
		else
			break
		end
	end
	return n
end

-- Eerstvolgende wekelijkse reset als timestamp (zelfde voor de hele week).
local function NextWeeklyReset()
	if C_DateAndTime and C_DateAndTime.GetSecondsUntilWeeklyReset then
		local ok, s = pcall(C_DateAndTime.GetSecondsUntilWeeklyReset)
		if ok and type(s) == "number" and s > 0 then
			return time() + s
		end
	end
	return nil
end

-- Account-brede weekly-status voor de checklist: is deze week's Mote nog open?
-- De unlocks zijn account-breed (Icy Veins 16 jun), dus 1 regel voor het hele
-- account. We onthouden de telling + de eerstvolgende reset in ns.db: zodra de
-- telling binnen een week omhoog gaat, is deze week "geclaimd"; na de reset
-- vervalt dat weer. ⚠️ Eerste meting kan "pending" tonen ook al deed je 'm al
-- (geen historische data) — zelfcorrigeert na de eerstvolgende reset.
function ns.GetOmniumFolioWeeklyStatus()
	if not ns.IsOmniumFolioAvailable() then
		return nil
	end
	local unlocked = UnlockedRows()
	if unlocked >= 5 then
		return { unlocked = unlocked, pending = false, done = true }
	end

	-- Objective van de eerstvolgende-te-ontgrendelen rij (= deze week's quest).
	local objKeys = ns.OMNIUM_FOLIO.weeklyObjectiveKeys
	local objectiveKey = objKeys and objKeys[unlocked + 1] or nil

	local db = ns.db
	if type(db) ~= "table" then
		return { unlocked = unlocked, pending = true, objectiveKey = objectiveKey } -- geen state
	end
	local st = db.omniumWeekly
	if type(st) ~= "table" then
		st = {}
		db.omniumWeekly = st
	end

	local nextReset = NextWeeklyReset()
	if st.nextReset and nextReset and nextReset > st.nextReset + 60 then
		st.claimedThisWeek = false -- nieuwe week → claim van vorige week vervalt
	end
	if nextReset then
		st.nextReset = nextReset
	end
	if st.count ~= nil and unlocked > st.count then
		st.claimedThisWeek = true -- telling omhoog → deze week een stap gedaan
	end
	st.count = unlocked

	return { unlocked = unlocked, pending = not st.claimedThisWeek, objectiveKey = objectiveKey }
end

local function RuneLink(rune)
	local fallback = ns:L(rune.nameKey)
	if ns.GetSpellLinkMarkup then
		return ns:GetSpellLinkMarkup(rune.spell, fallback)
	end
	return "[" .. fallback .. "]"
end

-- Start van de unlock-questlijn ("The Magister's Call"), Silvermoon 2393
-- 47.89/51.73 (in-game gemeten door Rob, 17 jun). Klikbare {FOLIOSTART}-link
-- in de intro → TomTom-waypoint (of Blizzard-fallback), zelfde recept als de
-- Creation Catalyst-link in TierSet.
local FOLIO_START = { map = 2393, x = 47.89, y = 51.73 }

local function SetFolioStartWaypoint()
	local name = ns:L("OMNIUM_START_NAME")
	if C_AddOns and C_AddOns.LoadAddOn and C_AddOns.IsAddOnLoaded and not C_AddOns.IsAddOnLoaded("TomTom") then
		pcall(C_AddOns.LoadAddOn, "TomTom")
	end
	local slashWay = SlashCmdList and SlashCmdList["TOMTOM_WAY"]
	if type(slashWay) == "function" then
		pcall(slashWay, ("#%d %.2f %.2f %s"):format(FOLIO_START.map, FOLIO_START.x, FOLIO_START.y, name))
		return
	end
	if C_Map and C_Map.SetUserWaypoint and UiMapPoint and UiMapPoint.CreateFromCoordinates then
		local p = UiMapPoint.CreateFromCoordinates(FOLIO_START.map, FOLIO_START.x / 100, FOLIO_START.y / 100)
		if pcall(C_Map.SetUserWaypoint, p) and C_SuperTrack and C_SuperTrack.SetSuperTrackedUserWaypoint then
			pcall(C_SuperTrack.SetSuperTrackedUserWaypoint, true)
		end
	end
end

--------------------------------------------------------------------------------
-- Body
--------------------------------------------------------------------------------

local function BodyText()
	local fol = ns.OMNIUM_FOLIO
	local mode = CurMode()
	local build = fol.builds[mode]
	local unlocked = UnlockedRows()
	local lines = {}

	local intro = ns:L("OMNIUM_INTRO")
	-- {FOLIOSTART} → klikbare waypoint-link (kleur teruggezet naar body erna).
	intro = intro:gsub("{FOLIOSTART}", function()
		return "|cff71d5ff|Hmhfoliostart|h[" .. ns:L("OMNIUM_START_NAME") .. "]|h|r|cff" .. BODY_HEX
	end)
	lines[#lines + 1] = "|cff" .. BODY_HEX .. intro .. "|r"
	lines[#lines + 1] = " "
	lines[#lines + 1] = "|cff" .. GOLD_HEX .. ns:L("OMNIUM_UNLOCK_LABEL") .. "|r |cff"
		.. BODY_HEX .. ns:L("OMNIUM_UNLOCK_FMT"):format(unlocked) .. "|r"
	lines[#lines + 1] = " "

	for i, row in ipairs(fol.rows) do
		local locked = i > unlocked
		local head = "|cff" .. GOLD_HEX .. ns:L("OMNIUM_WEEK_FMT"):format(row.week)
			.. " - " .. ns:L(row.titleKey) .. "|r"
		if locked then
			head = head .. "  |cff" .. DIM_HEX .. "(" .. ns:L("OMNIUM_LOCKED") .. ")|r"
		end
		lines[#lines + 1] = head

		local rec = build and build[row.key]
		for _, rune in ipairs(row.runes) do
			local mark = ""
			if rune.key == rec then
				mark = "   |cff" .. GOLD_HEX .. ns:L("OMNIUM_RECOMMENDED") .. "|r"
			end
			lines[#lines + 1] = "   - " .. RuneLink(rune)
				.. " |cff" .. BODY_HEX .. ns:L(rune.descKey) .. "|r" .. mark
		end
		-- Stat-rij: geen vaste aanbeveling, volg je spec-stat.
		if row.key == "stat" and rec == "spec" then
			lines[#lines + 1] = "   |cff" .. GOLD_HEX .. ns:L("OMNIUM_STAT_SPEC_HINT") .. "|r"
		end
		lines[#lines + 1] = " "
	end

	lines[#lines + 1] = "|cff" .. DIM_HEX .. ns:L("OMNIUM_FOOTER") .. "|r"
	return table.concat(lines, "|n")
end

--------------------------------------------------------------------------------
-- Paneel (tab "omnium")
--------------------------------------------------------------------------------

local function UpdateModeButtons()
	if not (ui and ui.modeBtns) then
		return
	end
	local mode = CurMode()
	for id, info in pairs(ui.modeBtns) do
		if id == mode then
			info.btn:LockHighlight()
		else
			info.btn:UnlockHighlight()
		end
	end
end

function ns.RefreshOmniumFolioPanel()
	if not (ui and ui.body) then
		return
	end
	ui.body:SetText(BodyText())
	UpdateModeButtons()
end

function ns.BuildOmniumFolioPanel(panel)
	if not panel or panel._mhOmniumBuilt then
		return
	end
	panel._mhOmniumBuilt = true
	if panel._body then
		panel._body:Hide()
	end
	if panel._header then
		panel._header:Hide()
	end

	local title = panel:CreateFontString(nil, "OVERLAY", "GameFontHighlightLarge")
	title:SetPoint("TOPLEFT", panel, "TOPLEFT", 14, -12)
	title:SetText(ns:L("TAB_OMNIUM"))

	local subtitle = panel:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	subtitle:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -4)
	subtitle:SetPoint("RIGHT", panel, "RIGHT", -14, 0)
	subtitle:SetJustifyH("LEFT")
	subtitle:SetWordWrap(true)
	subtitle:SetTextColor(0.75, 0.78, 0.82)
	subtitle:SetText(ns:L("OMNIUM_SUBTITLE"))

	-- Content-type-keuze: M+/Raid/PvP/World (segmented buttons, actief = highlight).
	local modeRow = CreateFrame("Frame", nil, panel)
	modeRow:SetHeight(26)
	modeRow:SetPoint("TOPLEFT", subtitle, "BOTTOMLEFT", 0, -10)
	modeRow:SetPoint("RIGHT", panel, "RIGHT", -14, 0)

	local modeDefs = {
		{ id = "mplus", labelKey = "OMNIUM_MODE_MPLUS" },
		{ id = "raid", labelKey = "OMNIUM_MODE_RAID" },
		{ id = "pvp", labelKey = "OMNIUM_MODE_PVP" },
		{ id = "world", labelKey = "OMNIUM_MODE_WORLD" },
	}
	local modeBtns = {}
	local prev
	for _, def in ipairs(modeDefs) do
		local b = CreateFrame("Button", nil, modeRow, "UIPanelButtonTemplate")
		b:SetSize(98, 22)
		if prev then
			b:SetPoint("LEFT", prev, "RIGHT", 6, 0)
		else
			b:SetPoint("LEFT", modeRow, "LEFT", 0, 0)
		end
		b:SetText(ns:L(def.labelKey))
		b:SetScript("OnClick", function()
			ns.SetOmniumFolioMode(def.id)
		end)
		modeBtns[def.id] = { btn = b, labelKey = def.labelKey }
		prev = b
	end

	-- Knop: open het in-game Folio-rune-venster. Handig bij custom UI's
	-- (Ellesmere) die de minimap-knop verbergen — klikt de Expansion Landing
	-- Page-knop aan (bekende fix). Alleen buiten combat (in combat = protected).
	local openBtn = CreateFrame("Button", nil, modeRow, "UIPanelButtonTemplate")
	openBtn:SetSize(160, 22)
	openBtn:SetPoint("RIGHT", modeRow, "RIGHT", 0, 0)
	openBtn:SetText(ns:L("OMNIUM_OPEN_INGAME"))
	openBtn:SetScript("OnClick", function()
		if InCombatLockdown and InCombatLockdown() then
			print(("|cffffcc00%s|r %s"):format(ns:L("PRINT_PREFIX"), ns:L("OMNIUM_OPEN_COMBAT")))
			return
		end
		local lpb = _G.ExpansionLandingPageMinimapButton
		if lpb and lpb.Click and pcall(lpb.Click, lpb) then
			return
		end
		print(("|cffffcc00%s|r %s"):format(ns:L("PRINT_PREFIX"), ns:L("OMNIUM_OPEN_FALLBACK")))
	end)

	local scroll = CreateFrame("ScrollFrame", nil, panel, "UIPanelScrollFrameTemplate")
	scroll:SetPoint("TOPLEFT", modeRow, "BOTTOMLEFT", 0, -10)
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
	-- Klik op de unlock-start-link → waypoint (spell-links blijven via de attach
	-- hierboven hun hover-tooltip tonen; die lopen via OnHyperlinkEnter/Leave).
	body:SetScript("OnHyperlinkClick", function(_, linkData)
		if linkData == "mhfoliostart" then
			SetFolioStartWaypoint()
		end
	end)
	scroll:SetScrollChild(body)

	scroll:SetScript("OnSizeChanged", function(_, w)
		if w and w > 40 then
			body:SetWidth(w - 8)
		end
	end)

	ui = {
		panel = panel,
		title = title,
		subtitle = subtitle,
		body = body,
		modeBtns = modeBtns,
		openBtn = openBtn,
	}

	panel:SetScript("OnShow", function()
		ns.RefreshOmniumFolioPanel()
	end)

	local ev = CreateFrame("Frame")
	ev:RegisterEvent("QUEST_TURNED_IN")
	ev:RegisterEvent("QUEST_LOG_UPDATE")
	ev:SetScript("OnEvent", function()
		if ui and ui.panel and ui.panel:IsShown() then
			if C_Timer and C_Timer.After then
				C_Timer.After(0.2, ns.RefreshOmniumFolioPanel)
			else
				ns.RefreshOmniumFolioPanel()
			end
		end
	end)

	ns.RefreshOmniumFolioPanel()
end

do
	local orig = ns.RefreshLocaleUI
	function ns:RefreshLocaleUI()
		if orig then
			orig(self)
		end
		if ui and ui.title then
			ui.title:SetText(ns:L("TAB_OMNIUM"))
			ui.subtitle:SetText(ns:L("OMNIUM_SUBTITLE"))
			if ui.modeBtns then
				for _, info in pairs(ui.modeBtns) do
					info.btn:SetText(ns:L(info.labelKey))
				end
			end
			if ui.openBtn then
				ui.openBtn:SetText(ns:L("OMNIUM_OPEN_INGAME"))
			end
			if ui.panel and ui.panel:IsShown() then
				ns.RefreshOmniumFolioPanel()
			end
		end
	end
end
