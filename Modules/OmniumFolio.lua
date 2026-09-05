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

-- Max level van de huidige expansion (Midnight = 90), rechtstreeks van de game —
-- geen hardcoded getal (never-lie). nil = onbekend → dan géén level-gate tonen
-- (verberg nooit een echte actie op een gok), zelfde patroon als ResetRoutine.
local function MidnightMaxLevel()
	if GetMaxLevelForPlayerExpansion then
		local ok, lvl = pcall(GetMaxLevelForPlayerExpansion)
		if ok and (tonumber(lvl) or 0) > 0 then
			return tonumber(lvl)
		end
	end
	return nil
end

-- Toon een Folio "waarom-opent-ie-niet"-melding via ONZE eigen toast-layout
-- (Rob 15 jul: de kale Blizzard-popup miste onze stijl; een chatregel mis je
-- makkelijk). Valt terug op chat als toasts uitstaan of de toast-API ontbreekt,
-- zodat een klik altijd feedback geeft. bodyText = de al geformatteerde string.
local function FolioNotice(bodyText)
	local toastOff = false
	local ui = ns.db and ns.db.ui
	if type(ui) == "table" and type(ui.toast) == "table" and ui.toast.enabled == false then
		toastOff = true
	end
	if not toastOff and ns.QueueMidnightToast then
		ns.QueueMidnightToast({
			id = "omnium_open_notice",
			titleKey = "OMNIUM_TOAST_TITLE",
			body = bodyText,
			icon = "Interface\\ICONS\\inv_misc_book_11",
		})
	else
		print(("|cffffcc00%s|r %s"):format(ns:L("PRINT_PREFIX"), bodyText))
	end
end

-- Is the Expansion Landing Page minimap button currently the MIDNIGHT one (the Omnium
-- Folio)? That button represents whatever expansion landing page THIS character has active;
-- on a char whose active page is the old Shadowlands covenant, clicking it pops a Kyrian
-- window (Carola + Cisca, both 90 WITH the Folio, 14 jul). This client exposes no way to
-- query the type (C_ExpansionLandingPage is nil; no :GetExpansionLandingPageType), and
-- Enum.ExpansionLandingPageType is only { None=0, Midnight=1 } — so read the button's own
-- labels, which Blizzard sets from the active landing page (Rob's dump: title "Omnium Folio",
-- description "…Midnight features and powers"). English-oriented, like MH's other tooltip-text
-- checks; a mislabel just falls back to the "wrong expansion" hint, never the wrong window.
--- True when the landing page button will open MIDNIGHT's page (the Folio).
---
--- Asks the game first. `/mh folio` (Rob, 19 jul) turned up the real API:
--- Enum.ExpansionLandingPageType.Midnight, ExpansionLandingPage:GetLandingPageType(),
--- and the button's own IsExpansionOverlayMode() / IsInGarrisonMode().
---
--- The old check compared btn.title to the literal English "Omnium Folio", which cannot
--- work on a German or French client -- it would send every non-English player down the
--- wrong-expansion path. The string checks stay as a last resort for a client where the
--- methods are missing, but they are no longer what decides.
local function IsMidnightFolioButton(btn)
	if not btn then
		return false
	end
	-- Garrison mode decides, and it decides FIRST. Cisca's probe (2026-07-20) showed why:
	-- her GetLandingPageType() reads 1 = Midnight while the button is in garrison mode, is
	-- not even shown, and opens her Night Fae Covenant Sanctum. GetLandingPageType
	-- describes the landing-page FRAME's configured type, not what this button will open --
	-- so gating on it let the click through and handed her the covenant window. The button's
	-- own mode is the only thing that answers "what happens when I press this".
	if type(btn.IsInGarrisonMode) == "function" then
		local ok, inGarrison = pcall(btn.IsInGarrisonMode, btn)
		if ok and inGarrison then
			return false
		end
	end
	if type(btn.IsExpansionOverlayMode) == "function" then
		local ok, isExpansion = pcall(btn.IsExpansionOverlayMode, btn)
		-- Positive signal only. An explicit true means the button is on the expansion page.
		-- false/nil is NOT treated as a no: Rob's working character has never run this line,
		-- so what it returns there is unknown, and turning an unknown into a refusal would
		-- break the one setup we know works. Garrison mode above already catches Cisca.
		if ok and isExpansion == true then
			return true
		end
	end
	local midnightType = Enum and Enum.ExpansionLandingPageType and Enum.ExpansionLandingPageType.Midnight
	local lp = _G.ExpansionLandingPage
	if midnightType and type(lp) == "table" and type(lp.GetLandingPageType) == "function" then
		local ok, t = pcall(lp.GetLandingPageType, lp)
		if ok and t ~= nil then
			return t == midnightType
		end
	end
	if type(btn.IsExpansionOverlayMode) == "function" then
		local ok, isExpansion = pcall(btn.IsExpansionOverlayMode, btn)
		if ok and isExpansion ~= nil then
			return isExpansion and true or false
		end
	end
	if type(btn.title) == "string" and btn.title == "Omnium Folio" then
		return true
	end
	if type(btn.description) == "string" and btn.description:find("Midnight", 1, true) then
		return true
	end
	return false
end

--- True when the button is showing a garrison/covenant page instead (Shadowlands Kyrian
--- for Carola and Cisca). Lets the refusal message say what is actually wrong.
local function IsGarrisonModeButton(btn)
	if not btn or type(btn.IsInGarrisonMode) ~= "function" then
		return false
	end
	local ok, inGarrison = pcall(btn.IsInGarrisonMode, btn)
	return ok and inGarrison and true or false
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
	-- ⚠️ Own waypoint, so ns.AddSmartTomTomWay's level warning never sees this one. See
	-- the note in CurrencyGuide: six places bypass that door and each needs the call.
	if ns.WarnZoneLevelIfNeeded then
		local okGate, blocked = pcall(ns.WarnZoneLevelIfNeeded, FOLIO_START.map, FOLIO_START.x, name)
		if okGate and blocked then
			return
		end
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
	title:SetFontObject(ns.MHScalableFont("GameFontHighlightLarge"))
	title:SetPoint("TOPLEFT", panel, "TOPLEFT", 14, -12)
	title:SetText(ns:L("TAB_OMNIUM"))

	local subtitle = panel:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	subtitle:SetFontObject(ns.MHScalableFont("GameFontHighlightSmall"))
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
			FolioNotice(ns:L("OMNIUM_OPEN_COMBAT"))
			return
		end
		-- The Expansion Landing Page button represents whatever expansion landing page THIS
		-- character has active — not necessarily Midnight. Guards before we click it:
		--  0. Still levelling → the Folio is a Midnight max-level feature and isn't reachable
		--     yet on this character. Check this FIRST: unlockQuests are account-wide (warband),
		--     so UnlockedRows() below is >0 on a low-level alt of an account that already has
		--     the Folio — which is exactly why a level-83 alt fell through to the "wrong
		--     expansion" hint instead of a useful message (Rob, 15 jul).
		--  1. Folio not unlocked on the account → nothing to open.
		--  2. The button is currently another expansion's page (the old Shadowlands covenant →
		--     a Kyrian window for Carola/Cisca) → don't click it, explain instead.
		local maxLvl = MidnightMaxLevel()
		local myLvl = (UnitLevel and UnitLevel("player")) or 0
		if maxLvl and myLvl > 0 and myLvl < maxLvl then
			FolioNotice(ns:L("OMNIUM_OPEN_LEVELING"):format(maxLvl, myLvl))
			return
		end
		if UnlockedRows() == 0 then
			FolioNotice(ns:L("OMNIUM_OPEN_LOCKED"))
			return
		end
		local lpb = _G.ExpansionLandingPageMinimapButton
		if not lpb then
			-- Zeldzaam pad met een /run-hint → chat (past niet in een toast).
			print(("|cffffcc00%s|r %s"):format(ns:L("PRINT_PREFIX"), ns:L("OMNIUM_OPEN_FALLBACK")))
			return
		end
		if not IsMidnightFolioButton(lpb) then
			-- Try the game's own repair before giving up. Cisca's button was stuck in
			-- garrison mode after pet hunting in an old zone and had not switched back in
			-- Silvermoon; SetBestLandingPageMode() flipped it (garrison true->false,
			-- expansion false->true, verified via macro 2026-07-20). It is Blizzard's own
			-- "pick the correct mode" call, so this restores the state the game intended
			-- rather than forcing one we prefer.
			--
			-- Only on an explicit button press, never in the background: it changes what her
			-- minimap button does, and that should follow from her asking for the Folio.
			if IsGarrisonModeButton(lpb) and type(lpb.SetBestLandingPageMode) == "function" then
				pcall(lpb.SetBestLandingPageMode, lpb)
			end
			-- Re-ask. Assuming the repair worked is the mistake this whole day was made of.
			if not IsMidnightFolioButton(lpb) then
				FolioNotice(ns:L(IsGarrisonModeButton(lpb) and "OMNIUM_OPEN_GARRISON" or "OMNIUM_OPEN_WRONGEXP"))
				return
			end
		end
		if lpb.Click and pcall(lpb.Click, lpb) then
			-- A click that did not error is NOT a window that opened -- the same trap as a
			-- forbidden RegisterEvent, which silently does nothing while pcall reports
			-- success. Carola and Cisca both got a message and no rune window, so verify
			-- against the actual frame and speak up if nothing appeared, instead of
			-- returning as though it worked. Small delay: the panel opens a frame later.
			if C_Timer and C_Timer.After then
				C_Timer.After(0.3, function()
					local lp = _G.ExpansionLandingPage
					if not (type(lp) == "table" and lp.IsShown and lp:IsShown()) then
						print(("|cffffcc00%s|r %s"):format(ns:L("PRINT_PREFIX"), ns:L("OMNIUM_OPEN_FALLBACK")))
					end
				end)
			end
			return
		end
		print(("|cffffcc00%s|r %s"):format(ns:L("PRINT_PREFIX"), ns:L("OMNIUM_OPEN_FALLBACK")))
	end)

	local scroll = CreateFrame("ScrollFrame", nil, panel, "UIPanelScrollFrameTemplate")
	scroll:SetPoint("TOPLEFT", modeRow, "BOTTOMLEFT", 0, -10)
	scroll:SetPoint("BOTTOMRIGHT", panel, "BOTTOMRIGHT", -30, 14)

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

--------------------------------------------------------------------------------
-- /mh folio — what the "Open rune window" button actually sees.
--
-- Rob, 19 jul: two max-level characters in Midnight press the button, get a
-- message, and no rune window appears. Which message decides everything -- each
-- one comes from a different guard -- and that could not be established from the
-- outside. This prints every input those guards read, plus the click target.
--
-- Note the pcall trap this mirrors: pcall(lpb.Click, lpb) returns true when the
-- call merely did not error. It is NOT evidence that a window opened, the same
-- way a forbidden RegisterEvent silently does nothing. So this also reports
-- whether a landing-page frame exists and is shown, rather than assuming.
--------------------------------------------------------------------------------
function ns.PrintOmniumFolioProbe()
	local prefix = ("|cffffcc00%s|r"):format(ns:L("PRINT_PREFIX"))
	print(("%s Omnium Folio probe"):format(prefix))

	local maxLvl = MidnightMaxLevel()
	local myLvl = (UnitLevel and UnitLevel("player")) or 0
	print(("   level: %s / max %s   ->  %s"):format(
		tostring(myLvl), tostring(maxLvl),
		(maxLvl and myLvl > 0 and myLvl < maxLvl) and "|cffff5040blocked: still levelling|r" or "|cff40c040ok|r"
	))

	local rows = UnlockedRows()
	print(("   unlocked rows: %s  ->  %s"):format(
		tostring(rows), (rows == 0) and "|cffff5040blocked: reads as not unlocked|r" or "|cff40c040ok|r"
	))

	local lpb = _G.ExpansionLandingPageMinimapButton
	if not lpb then
		print("   ExpansionLandingPageMinimapButton: |cffff5040missing|r (button cannot be clicked at all)")
		return
	end
	print(("   button.title:       %s"):format(tostring(rawget(lpb, "title"))))
	print(("   button.description: %s"):format(tostring(rawget(lpb, "description"))))
	-- The authoritative signals, so a report from another player settles it in one command.
	do
		local lpFrame = _G.ExpansionLandingPage
		local pageType
		if type(lpFrame) == "table" and type(lpFrame.GetLandingPageType) == "function" then
			local ok, t = pcall(lpFrame.GetLandingPageType, lpFrame)
			pageType = ok and t or nil
		end
		local midnightType = Enum and Enum.ExpansionLandingPageType and Enum.ExpansionLandingPageType.Midnight
		print(("   GetLandingPageType: %s   (Midnight = %s)  ->  %s"):format(
			tostring(pageType), tostring(midnightType),
			(pageType ~= nil and pageType == midnightType) and "|cff40c040Midnight|r" or "|cffff5040not Midnight|r"
		))
		print(("   button mode: expansion-overlay=%s  garrison=%s"):format(
			tostring(select(2, pcall(function()
				return type(lpb.IsExpansionOverlayMode) == "function" and lpb:IsExpansionOverlayMode() or nil
			end))),
			IsGarrisonModeButton(lpb) and "|cffff5040yes|r" or "no"
		))
	end
	print(("   recognised as Midnight/Folio: %s"):format(
		IsMidnightFolioButton(lpb) and "|cff40c040yes|r" or "|cffff5040no -> shows the wrong-expansion hint|r"
	))
	print(("   button shown: %s   has Click: %s"):format(
		(lpb.IsShown and lpb:IsShown()) and "yes" or "no",
		type(lpb.Click) == "function" and "yes" or "|cffff5040no|r"
	))

	-- What would actually have to appear. Reported, never assumed.
	if ns.LoadBlizzardAddOn then
		ns.LoadBlizzardAddOn("Blizzard_ExpansionLandingPage")
	end
	local lp = _G.ExpansionLandingPage
	print(("   ExpansionLandingPage frame: %s   shown: %s   addon loaded: %s"):format(
		type(lp) == "table" and "|cff40c040exists|r" or "|cffff5040nil|r",
		(type(lp) == "table" and lp.IsShown and lp:IsShown()) and "yes" or "no",
		(C_AddOns and C_AddOns.IsAddOnLoaded and C_AddOns.IsAddOnLoaded("Blizzard_ExpansionLandingPage")) and "yes" or "no"
	))

	-- WHICH frame actually holds the rune tree. Rune/trait trees have historically used
	-- Blizzard's shared GenericTraitFrame rather than the landing page itself. If the Folio
	-- does, there may be a way in that does not depend on the minimap button showing
	-- Midnight's page at all -- which is exactly what blocks Carola and Cisca, whose button
	-- still shows a Shadowlands covenant page.
	--
	-- Measured, not assumed: open the rune window first, THEN run /mh folio, and see which
	-- of these reads "shown: yes".
	if ns.LoadBlizzardAddOn then
		ns.LoadBlizzardAddOn("Blizzard_GenericTraitUI")
	end
	local gt = _G.GenericTraitFrame
	print(("   GenericTraitFrame: %s   shown: %s"):format(
		type(gt) == "table" and "|cff40c040exists|r" or "|cffff5040nil|r",
		(type(gt) == "table" and gt.IsShown and gt:IsShown()) and "|cff40c040yes|r" or "no"
	))
	print("   (open the rune window first, then run this again — whichever says shown: yes is the real frame)")

	-- Answered by Rob's run: the Folio lives in ExpansionLandingPage, GenericTraitFrame is
	-- not involved. So there is no bypass, and the only remaining hope for Carola and Cisca
	-- -- whose button shows a Shadowlands page -- is a method that selects WHICH page.
	-- List what actually exists rather than guessing a name; the enum is reported too,
	-- because a type concept without a setter means the answer is "you cannot".
	local et = _G.Enum and _G.Enum.ExpansionLandingPageType
	if type(et) == "table" then
		local keys = {}
		for k, v in pairs(et) do
			keys[#keys + 1] = ("%s=%s"):format(tostring(k), tostring(v))
		end
		table.sort(keys)
		print(("   Enum.ExpansionLandingPageType: %s"):format(table.concat(keys, ", ")))
	else
		print("   Enum.ExpansionLandingPageType: |cffff5040nil|r")
	end
	print(("   C_ExpansionLandingPage: %s"):format(
		type(_G.C_ExpansionLandingPage) == "table" and "|cff40c040table|r" or "|cffff5040nil|r"
	))
	for _, pair in ipairs({ { "ExpansionLandingPage", lp }, { "minimap button", lpb } }) do
		local label, frame = pair[1], pair[2]
		if type(frame) == "table" then
			-- Lua patterns have no alternation, so match each needle separately (plain find).
			local NEEDLES = { "anding", "verlay", "oggle", "etPage", "ode" }
			local own = {}
			pcall(function()
				for k, v in pairs(frame) do
					if type(v) == "function" then
						local name = tostring(k)
						for _, needle in ipairs(NEEDLES) do
							if name:find(needle, 1, true) then
								own[#own + 1] = name
								break
							end
						end
					end
				end
			end)
			table.sort(own)
			print(("   %s page-related methods: %s"):format(label, #own > 0 and table.concat(own, ", ") or "none"))
		end
	end
end
