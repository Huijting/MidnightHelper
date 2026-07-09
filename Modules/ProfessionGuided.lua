--[[
	Profession Guided mode ("take you by the hand") — PROTOTYPE, Alchemy only.

	Shows ONE step at a time (instead of the whole Course at once) with a big
	Next/Done and an optional waypoint, and auto-advances on live game state
	(skill rank, profession learned, tool equipped) so steps tick themselves.
	Never-lie: only things we can actually read auto-complete; the rest is a
	manual "Done" tap. Facts reuse the already-verified Alchemy route
	(PROFGUIDE_LVL_ALCHEMY) + trainer pin (ResetRoutine TRAINER_PINS[171]).

	If Rob likes the feel, the next step is to (a) move the inline step text to
	locale keys for all 7 languages and (b) roll the same step table out to the
	other 10 professions.
]]

local _, ns = ...

local ALCHEMY = 171

local function SL(key)
	if ns.SafeL then
		return ns:SafeL(key)
	end
	return ns:L(key)
end

--------------------------------------------------------------------------------
-- Live signals (all pcall-guarded, never guess)
--------------------------------------------------------------------------------

--- Current Alchemy skill rank for THIS character, or nil when not learned.
local function AlchemySkill()
	if type(GetProfessions) ~= "function" or type(GetProfessionInfo) ~= "function" then
		return nil
	end
	local p1, p2 = GetProfessions()
	for _, idx in next, { p1, p2 } do
		local _, _, rank, _, _, _, skillLine = GetProfessionInfo(idx)
		if skillLine == ALCHEMY then
			return tonumber(rank) or 0
		end
	end
	return nil
end

local function HasAlchemy()
	return AlchemySkill() ~= nil
end

--- Any profession tool equipped (slot 20 = prof 1 tool, 23 = prof 2 tool).
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

local function SkillAtLeast(n)
	local s = AlchemySkill()
	return s ~= nil and s >= n
end

--------------------------------------------------------------------------------
-- Step table (Alchemy). detect() = auto-complete signal (nil = manual Done).
--------------------------------------------------------------------------------

local TRAINER = { mapID = 2393, x = 47.02, y = 51.88 } -- Camberon, Silvermoon City
local WORKORDER = { mapID = 2393, x = 45.0, y = 55.6 }

local STEPS = {
	{ key = "learn", waypoint = TRAINER,
		titleKey = "PGUIDE_AL_LEARN_TITLE", bodyKey = "PGUIDE_AL_LEARN_BODY",
		detect = HasAlchemy },
	{ key = "open",
		titleKey = "PGUIDE_AL_OPEN_TITLE", bodyKey = "PGUIDE_AL_OPEN_BODY",
		detect = ProfWindowOpened },
	{ key = "tool",
		titleKey = "PGUIDE_AL_TOOL_TITLE", bodyKey = "PGUIDE_AL_TOOL_BODY",
		detect = ToolEquipped },
	{ key = "s7",
		titleKey = "PGUIDE_AL_S7_TITLE", bodyKey = "PGUIDE_AL_S7_BODY",
		detect = function() return SkillAtLeast(7) end },
	{ key = "s20",
		titleKey = "PGUIDE_AL_S20_TITLE", bodyKey = "PGUIDE_AL_S20_BODY",
		detect = function() return SkillAtLeast(20) end },
	{ key = "s27", waypoint = TRAINER,
		titleKey = "PGUIDE_AL_S27_TITLE", bodyKey = "PGUIDE_AL_S27_BODY",
		detect = function() return SkillAtLeast(27) end },
	{ key = "spec",
		titleKey = "PGUIDE_AL_SPEC_TITLE", bodyKey = "PGUIDE_AL_SPEC_BODY" }, -- manual
	{ key = "s50",
		titleKey = "PGUIDE_AL_S50_TITLE", bodyKey = "PGUIDE_AL_S50_BODY",
		detect = function() return SkillAtLeast(50) end },
	{ key = "s100",
		titleKey = "PGUIDE_AL_S100_TITLE", bodyKey = "PGUIDE_AL_S100_BODY",
		detect = function() return SkillAtLeast(100) end },
	{ key = "weekly", waypoint = WORKORDER,
		titleKey = "PGUIDE_AL_WEEKLY_TITLE", bodyKey = "PGUIDE_AL_WEEKLY_BODY" }, -- manual
	{ key = "done",
		titleKey = "PGUIDE_AL_DONE_TITLE", bodyKey = "PGUIDE_AL_DONE_BODY" }, -- final
}

--------------------------------------------------------------------------------
-- Per-character progress (manual-Done flags; auto steps are re-derived live)
--------------------------------------------------------------------------------

local function ProgressBag()
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
	if type(ns.db.profGuided[guid].alchemy) ~= "table" then
		ns.db.profGuided[guid].alchemy = {}
	end
	return ns.db.profGuided[guid].alchemy
end

local function StepDone(step)
	if step.detect then
		local ok, res = pcall(step.detect)
		if ok and res then
			return true
		end
	end
	local bag = ProgressBag()
	return (bag and bag[step.key] == true) or false
end

local function SetManualDone(step, done)
	local bag = ProgressBag()
	if bag then
		bag[step.key] = done and true or nil
	end
end

--- Index of the first not-done step (the "current" step). Last step if all done.
local function CurrentStepIndex()
	for i = 1, #STEPS do
		if not StepDone(STEPS[i]) then
			return i
		end
	end
	return #STEPS
end

local function DoneCount()
	local n = 0
	for i = 1, #STEPS do
		if StepDone(STEPS[i]) then
			n = n + 1
		end
	end
	return n
end

--------------------------------------------------------------------------------
-- Wizard frame
--------------------------------------------------------------------------------

local frame
local viewIndex -- the step currently shown (may differ from current while browsing)

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
	if not frame or not frame:IsShown() then
		return
	end
	local total = #STEPS
	if not viewIndex then
		viewIndex = CurrentStepIndex()
	end
	viewIndex = math.max(1, math.min(total, viewIndex))
	local step = STEPS[viewIndex]
	local done = StepDone(step)
	local doneN = DoneCount()

	frame._counter:SetText(SL("PGUIDE_STEP_FMT"):format(viewIndex, total, doneN))
	frame._title:SetText(SL(step.titleKey))
	frame._body:SetText(SL(step.bodyKey))

	-- Status line: auto-detected vs waiting vs manual
	if done then
		frame._status:SetText("|cff8ee6a1" .. SL("PGUIDE_STATUS_DONE") .. "|r")
	elseif step.detect then
		frame._status:SetText("|cffc7b36a" .. SL("PGUIDE_STATUS_WAITING") .. "|r")
	else
		frame._status:SetText("|cff9aa0a8" .. SL("PGUIDE_STATUS_MANUAL") .. "|r")
	end

	-- Waypoint button
	if step.waypoint then
		frame._wpBtn:SetText(SL("PGUIDE_BTN_WAYPOINT"))
		frame._wpBtn:Show()
		frame._wpBtn._wp = step.waypoint
	else
		frame._wpBtn:Hide()
	end

	-- Prev / Next
	frame._prev:SetEnabled(viewIndex > 1)
	frame._next:SetShown(viewIndex < total)

	-- The action button: manual step not done -> "Done"; otherwise "Next"/finish.
	if (not done) and (not step.detect) and viewIndex < total then
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

local function EnsureFrame()
	if frame then
		return frame
	end
	local f = CreateFrame("Frame", "MidnightHelperProfGuide", UIParent, "BackdropTemplate")
	f:SetSize(380, 300)
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

	local hdrTag = f:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
	hdrTag:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -2)
	hdrTag:SetText(SL("PGUIDE_HEADER_TAG"))
	hdrTag:SetTextColor(0.7, 0.66, 0.55)

	local body = f:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
	body:SetPoint("TOPLEFT", hdrTag, "BOTTOMLEFT", 0, -12)
	body:SetPoint("TOPRIGHT", f, "TOPRIGHT", -16, -52)
	body:SetJustifyH("LEFT")
	body:SetJustifyV("TOP")
	body:SetWordWrap(true)
	body:SetSpacing(3)
	body:SetHeight(140)
	f._body = body

	local status = f:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	status:SetPoint("BOTTOMLEFT", f, "BOTTOMLEFT", 16, 84)
	status:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -16, 84)
	status:SetJustifyH("LEFT")
	f._status = status

	local wpBtn = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
	wpBtn:SetSize(200, 24)
	wpBtn:SetPoint("BOTTOMLEFT", f, "BOTTOMLEFT", 16, 52)
	wpBtn:SetScript("OnClick", function(self)
		RouteWaypoint(self._wp)
	end)
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
		viewIndex = math.min(#STEPS, (viewIndex or 1) + 1)
		Refresh()
	end)
	f._next = nextBtn

	-- Central action (Done for manual steps). Sits above Prev/Next row.
	local action = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
	action:SetSize(150, 26)
	action:SetPoint("BOTTOM", f, "BOTTOM", 0, 16)
	action:SetScript("OnClick", function(self)
		local step = STEPS[viewIndex]
		if self._mode == "done" and step then
			SetManualDone(step, true)
			viewIndex = CurrentStepIndex()
		else
			viewIndex = math.min(#STEPS, (viewIndex or 1) + 1)
		end
		Refresh()
	end)
	f._action = action

	f:SetScript("OnShow", function()
		AdvanceToCurrent()
	end)

	frame = f
	return f
end

--- Public: open the guided wizard (prototype: Alchemy).
function ns.MH_OpenProfessionGuide()
	local f = EnsureFrame()
	f:Show()
	AdvanceToCurrent()
end

--------------------------------------------------------------------------------
-- Live refresh: recompute done-states + auto-advance on relevant events
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
	if frame and frame:IsShown() then
		-- Only auto-jump forward when the shown step just auto-completed, so we
		-- don't yank the view while the player is browsing back through steps.
		local shown = STEPS[viewIndex or 1]
		if shown and shown.detect and StepDone(shown) then
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
