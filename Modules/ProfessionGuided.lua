--[[
	Profession Guided mode ("take you by the hand").

	Shows ONE step at a time (instead of the whole Course at once) with Back/Next,
	a manual Done for steps we cannot read, an optional waypoint, and LIVE
	auto-advance where the game state is readable (skill rank, profession learned,
	tool equipped) so steps tick themselves. Never-lie: only readable things
	auto-complete; the rest is a manual Done tap.

	Per-profession step DATA (skill-milestone middle steps + metadata) lives in
	ProfessionGuidedData.lua (ns.PROF_GUIDES, inline en/nl). The shared generic
	steps (learn / open / tool / spec / weekly / done) are templated here and
	filled with each profession's name, trainer and tool. Facts reuse the already-
	verified routes (PROFGUIDE_LVL_*) + trainer pins (ResetRoutine TRAINER_PINS).
]]

local _, ns = ...

local WORKORDER = { mapID = 2393, x = 45.0, y = 55.6 } -- Work Order station (Flaresworn/Mar'nah)

local function SL(key)
	if ns.SafeL then
		return ns:SafeL(key)
	end
	return ns:L(key)
end

--- Pick localized text: a plain string, or a { en=, nl= } table by active locale.
local function T(v)
	if type(v) ~= "table" then
		return v or ""
	end
	local code = ns.GetEffectiveLocaleCode and ns:GetEffectiveLocaleCode()
	if code == "nlNL" and v.nl and v.nl ~= "" then
		return v.nl
	end
	return v.en or v.nl or ""
end

--- Substitute {prof}/{trainer}/{tool} tokens from a guide's metadata.
local function Fill(s, guide)
	if type(s) ~= "string" then
		return s
	end
	s = s:gsub("{prof}", T(guide.profName) or "")
	s = s:gsub("{trainer}", guide.trainerName or "")
	s = s:gsub("{tool}", T(guide.toolName) or "")
	return s
end

--------------------------------------------------------------------------------
-- Live signals (pcall-guarded, never guess)
--------------------------------------------------------------------------------

--- Current skill rank for a profession skillLine on THIS character, or nil.
local function SkillFor(skillLine)
	if type(GetProfessions) ~= "function" or type(GetProfessionInfo) ~= "function" then
		return nil
	end
	local p1, p2 = GetProfessions()
	for _, idx in next, { p1, p2 } do
		local _, _, rank, _, _, _, sl = GetProfessionInfo(idx)
		if sl == skillLine then
			return tonumber(rank) or 0
		end
	end
	return nil
end

local function HasProf(skillLine)
	return SkillFor(skillLine) ~= nil
end

local function ToolEquipped()
	if type(GetInventoryItemID) ~= "function" then
		return false
	end
	return GetInventoryItemID("player", 20) ~= nil or GetInventoryItemID("player", 23) ~= nil
end

local profWindowOpened = false
local function ProfWindowOpened()
	return profWindowOpened
end

--------------------------------------------------------------------------------
-- Generic step templates (shared across professions; tokens filled per guide)
--------------------------------------------------------------------------------

local GENERIC_PRE = {
	{ key = "learn", waypoint = "trainer",
		title = { en = "Learn {prof}", nl = "Leer {prof}" },
		body = {
			en = "Go to the {prof} trainer {trainer} in Silvermoon City (use the waypoint) and learn {prof}.",
			nl = "Ga naar de {prof}-trainer {trainer} in Silvermoon City (gebruik de waypoint) en leer {prof}.",
		},
		detectKind = "hasprof" },
	{ key = "open",
		title = { en = "Open your profession window", nl = "Open je beroepsvenster" },
		body = {
			en = "Open your {prof} window (default key: P, or click it in your spellbook). This is your home base for this profession.",
			nl = "Open je {prof}-venster (standaardtoets: P, of klik het aan in je spellbook). Dit is je thuisbasis voor dit beroep.",
		},
		detectKind = "window" },
	{ key = "tool",
		title = { en = "Equip your tool", nl = "Rust je gereedschap uit" },
		body = {
			en = "Equip your {prof} tool in the profession tool slot — it boosts your stats. The starter one is fine.",
			nl = "Doe je {prof}-gereedschap in de beroeps-toolslot — dat verhoogt je stats. Het starter-exemplaar is prima.",
		},
		detectKind = "tool" },
}

local STEP_SPEC = {
	key = "spec",
	title = { en = "Spend your Knowledge (spec trees)", nl = "Geef je Knowledge uit (spec-bomen)" },
	body = {
		en = "As you skill up you earn Knowledge points. Open the spec trees and spend them — the Course tab's advisor shows a safe next pick. Tap Done once you've spent some.",
		nl = "Naarmate je skill stijgt verdien je Knowledge-punten. Open de spec-bomen en geef ze uit — de adviseur in de Course-tab wijst een veilige keuze aan. Tik op Klaar zodra je wat hebt uitgegeven.",
	},
}

local STEP_WEEKLY_STATION = {
	key = "weekly", waypoint = "station",
	title = { en = "Your weekly Knowledge", nl = "Je wekelijkse Knowledge" },
	body = {
		en = "Each week, pick up your {prof} service quest at the Work Order station (use the waypoint) for extra Knowledge — the main way to grow long-term. Tap Done for this week.",
		nl = "Haal elke week je {prof}-service-quest op bij het Work Order-station (gebruik de waypoint) voor extra Knowledge — dé manier om op lange termijn te groeien. Tik op Klaar voor deze week.",
	},
}

local STEP_WEEKLY_TRAINER = {
	key = "weekly", waypoint = "trainer",
	title = { en = "Your weekly Knowledge", nl = "Je wekelijkse Knowledge" },
	body = {
		en = "Each week, pick up your {prof} weekly quest at the trainer (use the waypoint) for extra Knowledge — the main way to grow long-term. Tap Done for this week.",
		nl = "Haal elke week je {prof}-weekly op bij de trainer (gebruik de waypoint) voor extra Knowledge — dé manier om op lange termijn te groeien. Tik op Klaar voor deze week.",
	},
}

local STEP_DONE = {
	key = "done",
	title = { en = "You're set!", nl = "Je bent klaar om te groeien!" },
	body = {
		en = "That's the core loop for {prof}. Keep spending weekly Knowledge and skilling up. The full detailed route lives in the Course tab.",
		nl = "Dat is de kern voor {prof}. Blijf wekelijkse Knowledge uitgeven en skill omhoog. De volledige route staat in de Course-tab.",
	},
}

--- Build the full ordered step list for a guide (generic + its middle steps).
local function AssembleSteps(guide)
	local steps = {}
	for _, g in ipairs(GENERIC_PRE) do
		steps[#steps + 1] = g
	end
	if type(guide.middleSteps) == "table" then
		for _, m in ipairs(guide.middleSteps) do
			steps[#steps + 1] = m
		end
	end
	steps[#steps + 1] = STEP_SPEC
	steps[#steps + 1] = guide.weeklyAtStation and STEP_WEEKLY_STATION or STEP_WEEKLY_TRAINER
	steps[#steps + 1] = STEP_DONE
	return steps
end

--- Resolve a step's waypoint (string tag) to actual coords for the guide.
local function StepWaypoint(step, guide)
	if step.waypoint == "trainer" then
		return guide.trainer
	elseif step.waypoint == "station" then
		return WORKORDER
	elseif type(step.waypoint) == "table" then
		return step.waypoint
	end
	return nil
end

--- Auto-complete detection for a step in the current guide (nil = manual).
local function StepAutoDone(step, guide)
	local k = step.detectKind
	if k == "hasprof" then
		return HasProf(guide.skillLine)
	elseif k == "window" then
		return ProfWindowOpened()
	elseif k == "tool" then
		return ToolEquipped()
	end
	if type(step.gate) == "number" then
		local s = SkillFor(guide.skillLine)
		return s ~= nil and s >= step.gate
	end
	return nil -- manual
end

--------------------------------------------------------------------------------
-- Per-character progress (manual-Done flags; auto steps re-derived live)
--------------------------------------------------------------------------------

local function ProgressBag(skillLine)
	if not ns.db then
		return nil
	end
	if type(ns.db.profGuided) ~= "table" then
		ns.db.profGuided = {}
	end
	local guid = UnitGUID("player")
	if type(guid) ~= "string" or guid == "" then
		return nil
	end
	if type(ns.db.profGuided[guid]) ~= "table" then
		ns.db.profGuided[guid] = {}
	end
	local key = "s" .. tostring(skillLine)
	if type(ns.db.profGuided[guid][key]) ~= "table" then
		ns.db.profGuided[guid][key] = {}
	end
	return ns.db.profGuided[guid][key]
end

--------------------------------------------------------------------------------
-- Wizard frame + state
--------------------------------------------------------------------------------

local frame
local activeGuide     -- current guide table (from ns.PROF_GUIDES)
local activeSteps      -- assembled step list for activeGuide
local viewIndex

local function StepDone(step)
	local auto = StepAutoDone(step, activeGuide)
	if auto then
		return true
	end
	if step.detectKind or type(step.gate) == "number" then
		return false -- an auto step that isn't satisfied yet
	end
	local bag = ProgressBag(activeGuide.skillLine)
	return (bag and bag[step.key] == true) or false
end

local function SetManualDone(step, done)
	local bag = ProgressBag(activeGuide.skillLine)
	if bag then
		bag[step.key] = done and true or nil
	end
end

local function CurrentStepIndex()
	for i = 1, #activeSteps do
		if not StepDone(activeSteps[i]) then
			return i
		end
	end
	return #activeSteps
end

local function DoneCount()
	local n = 0
	for i = 1, #activeSteps do
		if StepDone(activeSteps[i]) then
			n = n + 1
		end
	end
	return n
end

local function RouteWaypoint(wp)
	if not (wp and ns.AddSmartTomTomWay) then
		return
	end
	if ns.MH_TomTomClearAll then
		ns.MH_TomTomClearAll()
	end
	ns.AddSmartTomTomWay(wp.mapID, wp.x, wp.y, SL("PGUIDE_WAYPOINT_LABEL"))
end

local function Refresh()
	if not frame or not frame:IsShown() or not activeGuide then
		return
	end
	local total = #activeSteps
	viewIndex = math.max(1, math.min(total, viewIndex or 1))
	local step = activeSteps[viewIndex]
	local done = StepDone(step)

	frame._title:SetText(SL("PGUIDE_HEADER_TAG_FMT"):format(T(activeGuide.profName)))
	frame._counter:SetText(SL("PGUIDE_STEP_FMT"):format(viewIndex, total, DoneCount()))
	frame._stepTitle:SetText(Fill(T(step.title), activeGuide))
	frame._body:SetText(Fill(T(step.body), activeGuide))

	if done then
		frame._status:SetText("|cff8ee6a1" .. SL("PGUIDE_STATUS_DONE") .. "|r")
	elseif step.detectKind or type(step.gate) == "number" then
		frame._status:SetText("|cffc7b36a" .. SL("PGUIDE_STATUS_WAITING") .. "|r")
	else
		frame._status:SetText("|cff9aa0a8" .. SL("PGUIDE_STATUS_MANUAL") .. "|r")
	end

	local wp = StepWaypoint(step, activeGuide)
	if wp then
		frame._wpBtn:SetText(SL("PGUIDE_BTN_WAYPOINT"))
		frame._wpBtn._wp = wp
		frame._wpBtn:Show()
	else
		frame._wpBtn:Hide()
	end

	frame._prev:SetEnabled(viewIndex > 1)
	frame._next:SetShown(viewIndex < total)

	if (not done) and (not step.detectKind) and (type(step.gate) ~= "number") and viewIndex < total then
		frame._action:SetText(SL("PGUIDE_BTN_DONE"))
		frame._action._mode = "done"
		frame._action:Show()
	elseif viewIndex < total then
		frame._action:SetText(SL("PGUIDE_BTN_NEXT"))
		frame._action._mode = "next"
		frame._action:Show()
	else
		frame._action:Hide()
	end
end

local function AdvanceToCurrent()
	viewIndex = CurrentStepIndex()
	Refresh()
end

-- Profession picker (dropdown in the header).
local function InitProfMenu(_, level)
	if level ~= 1 or not (ns.PROF_GUIDES and UIDropDownMenu_CreateInfo and UIDropDownMenu_AddButton) then
		return
	end
	local order = ns.PROF_GUIDE_ORDER or {}
	for _, sl in ipairs(order) do
		local g = ns.PROF_GUIDES[sl]
		if g then
			local info = UIDropDownMenu_CreateInfo()
			local owned = HasProf(sl)
			info.text = T(g.profName) .. (owned and "  |cff8ee6a1*|r" or "")
			info.notCheckable = true
			info.func = function()
				if ns.MH_OpenProfessionGuide then
					ns.MH_OpenProfessionGuide(sl)
				end
				if CloseDropDownMenus then
					CloseDropDownMenus()
				end
			end
			UIDropDownMenu_AddButton(info, level)
		end
	end
end

local function EnsureFrame()
	if frame then
		return frame
	end
	local f = CreateFrame("Frame", "MidnightHelperProfGuide", UIParent, "BackdropTemplate")
	f:SetSize(390, 310)
	f:SetPoint("CENTER", UIParent, "CENTER", 0, 60)
	f:SetFrameStrata("DIALOG")
	f:SetClampedToScreen(true)
	f:EnableMouse(true)
	f:SetMovable(true)
	f:RegisterForDrag("LeftButton")
	f:SetScript("OnDragStart", f.StartMoving)
	f:SetScript("OnDragStop", f.StopMovingOrSizing)
	f:SetBackdrop({
		bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
		edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Gold-Border",
		tile = true, tileSize = 32, edgeSize = 32,
		insets = { left = 11, right = 12, top = 12, bottom = 11 },
	})
	f:SetBackdropColor(0.05, 0.05, 0.08, 0.95)
	tinsert(UISpecialFrames, f:GetName())

	local title = f:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
	title:SetPoint("TOPLEFT", f, "TOPLEFT", 16, -16)
	title:SetPoint("TOPRIGHT", f, "TOPRIGHT", -40, -16)
	title:SetJustifyH("LEFT")
	title:SetWordWrap(true)
	title:SetTextColor(1, 0.85, 0.4)
	f._title = title

	local counter = f:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
	counter:SetPoint("TOPRIGHT", f, "TOPRIGHT", -40, -18)
	f._counter = counter

	local close = CreateFrame("Button", nil, f, "UIPanelCloseButton")
	close:SetPoint("TOPRIGHT", f, "TOPRIGHT", -8, -8)
	close:SetScript("OnClick", function() f:Hide() end)

	-- Profession switcher
	local drop = CreateFrame("Frame", "MidnightHelperProfGuideDrop", f, "UIDropDownMenuTemplate")
	drop:SetPoint("TOPLEFT", title, "BOTTOMLEFT", -16, -2)
	if UIDropDownMenu_SetWidth then
		UIDropDownMenu_SetWidth(drop, 150)
	end
	f._drop = drop
	local dropBtn = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
	dropBtn:SetSize(150, 22)
	dropBtn:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -2)
	dropBtn:SetScript("OnClick", function()
		if UIDropDownMenu_Initialize and ToggleDropDownMenu then
			UIDropDownMenu_Initialize(drop, InitProfMenu, "MENU")
			ToggleDropDownMenu(1, nil, drop, dropBtn, 0, 0)
		end
	end)
	f._dropBtn = dropBtn

	local body = f:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
	body:SetPoint("TOPLEFT", dropBtn, "BOTTOMLEFT", 0, -10)
	body:SetPoint("TOPRIGHT", f, "TOPRIGHT", -16, -70)
	body:SetJustifyH("LEFT")
	body:SetJustifyV("TOP")
	body:SetWordWrap(true)
	body:SetSpacing(3)
	body:SetHeight(120)
	f._body = body

	-- The step's own title (bold, above the body). Anchored under the dropdown.
	local stepTitle = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	stepTitle:SetPoint("BOTTOMLEFT", body, "TOPLEFT", 0, 2)
	stepTitle:SetTextColor(1, 0.95, 0.7)
	f._stepTitle = stepTitle

	local status = f:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	status:SetPoint("BOTTOMLEFT", f, "BOTTOMLEFT", 16, 84)
	status:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -16, 84)
	status:SetJustifyH("LEFT")
	f._status = status

	local wpBtn = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
	wpBtn:SetSize(200, 24)
	wpBtn:SetPoint("BOTTOMLEFT", f, "BOTTOMLEFT", 16, 52)
	wpBtn:SetScript("OnClick", function(self) RouteWaypoint(self._wp) end)
	f._wpBtn = wpBtn

	local prev = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
	prev:SetSize(90, 26)
	prev:SetPoint("BOTTOMLEFT", f, "BOTTOMLEFT", 16, 16)
	prev:SetText(SL("PGUIDE_BTN_PREV"))
	prev:SetScript("OnClick", function()
		viewIndex = math.max(1, (viewIndex or 1) - 1)
		Refresh()
	end)
	f._prev = prev

	local nextBtn = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
	nextBtn:SetSize(90, 26)
	nextBtn:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -16, 16)
	nextBtn:SetText(SL("PGUIDE_BTN_NEXT"))
	nextBtn:SetScript("OnClick", function()
		viewIndex = math.min(#activeSteps, (viewIndex or 1) + 1)
		Refresh()
	end)
	f._next = nextBtn

	local action = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
	action:SetSize(150, 26)
	action:SetPoint("BOTTOM", f, "BOTTOM", 0, 16)
	action:SetScript("OnClick", function(self)
		local step = activeSteps[viewIndex]
		if self._mode == "done" and step then
			SetManualDone(step, true)
			viewIndex = CurrentStepIndex()
		else
			viewIndex = math.min(#activeSteps, (viewIndex or 1) + 1)
		end
		Refresh()
	end)
	f._action = action

	f:SetScript("OnShow", function() AdvanceToCurrent() end)
	frame = f
	return f
end

--- Default profession: player's first owned guided prof, else the first in order.
local function DefaultGuideSkillLine()
	if ns.PROF_GUIDE_ORDER then
		for _, sl in ipairs(ns.PROF_GUIDE_ORDER) do
			if HasProf(sl) then
				return sl
			end
		end
		return ns.PROF_GUIDE_ORDER[1]
	end
	return nil
end

--- Public: open the guided wizard for a profession skillLine (or a sensible default).
function ns.MH_OpenProfessionGuide(skillLine)
	if not ns.PROF_GUIDES then
		return
	end
	skillLine = skillLine or DefaultGuideSkillLine()
	local guide = skillLine and ns.PROF_GUIDES[skillLine]
	if not guide then
		return
	end
	guide.skillLine = skillLine -- ensure present for detection
	activeGuide = guide
	activeSteps = AssembleSteps(guide)
	local f = EnsureFrame()
	f:Show()
	AdvanceToCurrent()
end

--------------------------------------------------------------------------------
-- Live refresh
--------------------------------------------------------------------------------

local ev = CreateFrame("Frame")
ev:RegisterEvent("TRADE_SKILL_SHOW")
ev:RegisterEvent("TRADE_SKILL_LIST_UPDATE")
ev:RegisterEvent("SKILL_LINES_CHANGED")
ev:RegisterEvent("TRAIT_CONFIG_UPDATED")
ev:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")
ev:SetScript("OnEvent", function(_, event)
	if event == "TRADE_SKILL_SHOW" then
		profWindowOpened = true
	end
	if frame and frame:IsShown() and activeSteps then
		local shown = activeSteps[viewIndex or 1]
		if shown and StepAutoDone(shown, activeGuide) then
			viewIndex = CurrentStepIndex()
		end
		Refresh()
	end
end)

do
	local orig = ns.RefreshLocaleUI
	function ns:RefreshLocaleUI()
		if orig then
			orig(self)
		end
		if frame and frame:IsShown() then
			Refresh()
		end
	end
end
