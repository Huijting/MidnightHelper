--[[
	Midnight Helper — Delve Coach: floating in-delve tips panel + preview picker.
]]

local _, ns = ...

local C_Map = C_Map
local C_PartyInfo = C_PartyInfo

local coachFrame
local pickerFrame
local wasInDelve = false
local currentEntryId

local COACH_DEFAULT_W = 320
local COACH_DEFAULT_H = 480
local COACH_MIN_W = 260
local COACH_MIN_H = 340
local COACH_MAX_W = 580
local COACH_MAX_H = 800
local COACH_TITLE_H = 36
local BOSS_PANEL_H = 156
local BOSS_NAME_BAR_H = 22
local BOSS_MODEL_INSET_TOP = 22
local BOSS_MODEL_INSET_SIDE = 32
local RESIZE_GRIP = 22
local RESIZE_EDGE_H = 8
local SCROLL_WHEEL_STEP = 42
local COACH_SCALE_MIN = 0.65
local COACH_SCALE_MAX = 1.75
local COACH_SCALE_WHEEL_STEP = 0.05
local COACH_FRAME_STRATA = "FULLSCREEN_DIALOG"
local COACH_FRAME_LEVEL = 500
local COLOR_SECTION = "|cffffcc00"
local COLOR_BODY = "|cffffffff"

local function BringCoachFrameToFront(f)
	if not f then
		return
	end
	if f.SetFrameStrata then
		f:SetFrameStrata(COACH_FRAME_STRATA)
	end
	if f.SetFrameLevel then
		f:SetFrameLevel(COACH_FRAME_LEVEL)
	end
	if f.Raise then
		f:Raise()
	end
end

local function GetSettings()
	local ui = ns.db and ns.db.ui
	if type(ui) ~= "table" then
		return {
			enabled = true,
			autoShow = true,
			minimized = false,
			scale = 1,
			width = COACH_DEFAULT_W,
			height = COACH_DEFAULT_H,
			bossIndex = {},
			bossCam = {},
			point = "RIGHT",
			relPoint = "RIGHT",
			x = -36,
			y = 0,
		}
	end
	if type(ui.delveCoach) ~= "table" then
		ui.delveCoach = {
			enabled = true,
			autoShow = true,
			minimized = false,
			scale = 1,
			width = COACH_DEFAULT_W,
			height = COACH_DEFAULT_H,
			bossIndex = {},
			bossCam = {},
			point = "RIGHT",
			relPoint = "RIGHT",
			x = -36,
			y = 0,
		}
	end
	local s = ui.delveCoach
	if s.scale == nil then
		s.scale = 1
	end
	if s.width == nil then
		s.width = COACH_DEFAULT_W
	end
	if s.height == nil then
		s.height = COACH_DEFAULT_H
	end
	if type(s.bossIndex) ~= "table" then
		s.bossIndex = {}
	end
	if type(s.bossCam) ~= "table" then
		s.bossCam = {}
	end
	return s
end

local function ClampCoachSize(w, h)
	w = math.max(COACH_MIN_W, math.min(COACH_MAX_W, tonumber(w) or COACH_DEFAULT_W))
	h = math.max(COACH_MIN_H, math.min(COACH_MAX_H, tonumber(h) or COACH_DEFAULT_H))
	return w, h
end

local function ClampCoachScale(scale)
	scale = tonumber(scale) or 1
	return math.max(COACH_SCALE_MIN, math.min(COACH_SCALE_MAX, scale))
end

local function ApplyCoachScale(f)
	if not f or not f.SetScale then
		return 1
	end
	local s = GetSettings()
	local scale = ClampCoachScale(s.scale)
	s.scale = scale
	f:SetScale(scale)
	return scale
end

local function AdjustCoachScale(f, wheelDelta)
	if not f or not wheelDelta or wheelDelta == 0 then
		return
	end
	local s = GetSettings()
	s.scale = ClampCoachScale((s.scale or 1) + (wheelDelta * COACH_SCALE_WHEEL_STEP))
	ApplyCoachScale(f)
end

local function ApplyCoachSize(f)
	local s = GetSettings()
	local w, h = ClampCoachSize(s.width, s.height)
	if f._minimized then
		f:SetSize(w, COACH_TITLE_H)
	else
		f:SetSize(w, h)
	end
	ApplyCoachScale(f)
end

local function SaveCoachSize(f)
	if f._minimized then
		return
	end
	local s = GetSettings()
	s.width, s.height = ClampCoachSize(f:GetWidth(), f:GetHeight())
end

local function normalizeDelveName(s)
	if type(s) ~= "string" then
		return ""
	end
	s = s:lower():gsub("^%s+", ""):gsub("%s+$", "")
	s = s:gsub("^bountiful%s+delve%s*:%s*", "")
	s = s:gsub("^delve%s*:%s*", "")
	return s
end

local function namesMatch(a, b)
	local na = normalizeDelveName(a)
	local nb = normalizeDelveName(b)
	if na == "" or nb == "" then
		return false
	end
	if na == nb or na:find(nb, 1, true) or nb:find(na, 1, true) then
		return true
	end
	return false
end

local function IsDelveInProgress()
	if C_PartyInfo and C_PartyInfo.IsDelveInProgress then
		local ok, active = pcall(C_PartyInfo.IsDelveInProgress)
		if ok and active then
			return true
		end
	end
	return false
end

local function CollectZoneStrings()
	local out = {}
	local function add(s)
		if type(s) == "string" and s ~= "" then
			out[#out + 1] = s
		end
	end
	add(GetSubZoneText and GetSubZoneText() or nil)
	add(GetZoneText and GetZoneText() or nil)
	add(GetRealZoneText and GetRealZoneText() or nil)
	if C_Map and C_Map.GetBestMapForUnit then
		local mapID = C_Map.GetBestMapForUnit("player")
		for _ = 1, 14 do
			if not mapID then
				break
			end
			local info = C_Map.GetMapInfo(mapID)
			if info and info.name then
				add(info.name)
			end
			if not info or not info.parentMapID or info.parentMapID == 0 then
				break
			end
			mapID = info.parentMapID
		end
	end
	return out
end

local function ResolveActiveDelveEntry()
	if ns.GetActiveDelveTipEntryForPlayer then
		return ns.GetActiveDelveTipEntryForPlayer()
	end
	return nil
end

local MULTI_BOSS_TIP_SECTIONS = {
	DELVE_COACH_SEC_BOSS = true,
	DELVE_COACH_SEC_ROUTE = true,
	DELVE_COACH_SEC_TRASH = true,
}

local function BuildCoachBody(entry, opts)
	if not entry or type(entry.sections) ~= "table" then
		return ns:SafeL("DELVE_COACH_UNKNOWN")
	end
	opts = opts or {}
	local blocks = {}
	local storyName, bossEntry, storyIdx
	if entry.id and ns.ResolveDelveStoryBoss then
		storyName, bossEntry, storyIdx = ns.ResolveDelveStoryBoss(entry.id)
	end
	local bossIndex = opts.bossIndex
	if opts.bossManualOverride and bossIndex then
		-- manual boss cycle wins
	elseif storyIdx then
		bossIndex = storyIdx
	end
	local function multiBossDelve(entryId)
		local bosses = ns.DELVE_BOSS_SHOWCASE and ns.DELVE_BOSS_SHOWCASE[entryId]
		return type(bosses) == "table" and #bosses > 1
	end
	if opts.live and entry.id then
		if not bossEntry and ns.TryResolveDelveBossFromUnits then
			bossEntry = select(1, ns.TryResolveDelveBossFromUnits(entry.id))
		end
		if bossEntry and bossEntry.label and storyName then
			blocks[#blocks + 1] = COLOR_SECTION
				.. ns:SafeL("DELVE_COACH_ACTIVE_STORY_FMT"):format(storyName, bossEntry.label)
				.. "|r"
		elseif bossEntry and bossEntry.label then
			blocks[#blocks + 1] = COLOR_SECTION
				.. ns:SafeL("DELVE_COACH_ACTIVE_BOSS_FMT"):format(bossEntry.label)
				.. "|r"
		elseif storyName and entry.id == "sunkiller_sanctum" then
			blocks[#blocks + 1] = COLOR_SECTION
				.. ns:SafeL("DELVE_COACH_ACTIVE_STORY_NO_BOSS_FMT"):format(storyName)
				.. "|r"
		elseif multiBossDelve(entry.id) and not bossEntry then
			if storyName then
				blocks[#blocks + 1] = COLOR_SECTION
					.. ns:SafeL("DELVE_COACH_ACTIVE_STORY_UNKNOWN_BOSS_FMT"):format(storyName)
					.. "|r"
			else
				blocks[#blocks + 1] = COLOR_SECTION .. ns:SafeL("DELVE_COACH_BOSS_PENDING") .. "|r"
			end
		end
	end
	for i = 1, #entry.sections do
		local sec = entry.sections[i]
		local title = ns:SafeL(sec.titleKey or "DELVE_COACH_SEC_OVERVIEW")
		local body = ns:SafeL(sec.bodyKey or "")
		if bossIndex and ns.FilterDelveTipBodyForBoss and MULTI_BOSS_TIP_SECTIONS[sec.titleKey] then
			body = ns.FilterDelveTipBodyForBoss(body, entry.id, bossIndex)
		end
		if ns.ExpandDelveTipMarkup then
			body = ns:ExpandDelveTipMarkup(body)
		end
		blocks[#blocks + 1] = COLOR_SECTION .. title .. ":|r|n" .. COLOR_BODY .. body .. "|r"
	end
	return table.concat(blocks, "|n|n")
end

local function ApplySavedPoint(f)
	local s = GetSettings()
	f:ClearAllPoints()
	f:SetPoint(s.point or "RIGHT", UIParent, s.relPoint or "RIGHT", tonumber(s.x) or -36, tonumber(s.y) or 0)
end

local function SavePoint(f)
	local s = GetSettings()
	local point, _, relPoint, x, y = f:GetPoint(1)
	if point then
		s.point = point
		s.relPoint = relPoint or point
		s.x = x or -36
		s.y = y or 0
	end
end

local function UpdateBossShowcase(f, entryId)
	local panel = f._bossPanel
	local model = f._bossModel
	local nameFs = f._bossName
	local counter = f._bossCounter
	if not panel or not entryId then
		return
	end

	local bosses = ns.GetDelveBossShowcase and ns:GetDelveBossShowcase(entryId)
	if not bosses or #bosses == 0 then
		panel:Hide()
		return
	end

	-- If we re-enter a delve run, clear the previous manual carousel choice so
	-- auto-detection can take over once the active boss is known.
	local inDelve = (ns.IsDelveInstanceInProgress and ns.IsDelveInstanceInProgress()) and true or false
	if not f._previewMode and inDelve and not f._bossWasInDelve then
		f._bossManualOverride = false
		f._bossBrowseIndex = nil
	end
	f._bossWasInDelve = inDelve

	local preferAuto = not f._bossManualOverride
	local prevIdx = f._bossShowcaseIndex
	local prevEntryId = f._bossEntryId
	local idx
	local autoResolved = false
	if f._bossManualOverride then
		idx = f._bossBrowseIndex or f._bossShowcaseIndex
			or (ns.GetDelveBossShowcaseIndex and ns:GetDelveBossShowcaseIndex(entryId))
			or 1
		autoResolved = false
	elseif ns.ResolveDelveBossShowcaseIndex then
		idx, autoResolved = ns.ResolveDelveBossShowcaseIndex(entryId, preferAuto)
	end
	if idx == nil and not preferAuto then
		idx = (ns.GetDelveBossShowcaseIndex and ns:GetDelveBossShowcaseIndex(entryId)) or 1
	end
	if not idx then
		idx = (ns.GetDelveBossShowcaseIndex and ns:GetDelveBossShowcaseIndex(entryId)) or 1
	end
	panel:Show()
	idx = math.max(1, math.min(#bosses, idx))
	-- Persist auto-pick only until the player uses ◀ ▶ (then _bossManualOverride sticks).
	if autoResolved and not f._previewMode and not f._bossManualOverride then
		if ns.SetDelveBossShowcaseIndex then
			ns:SetDelveBossShowcaseIndex(entryId, idx)
		end
	end
	local boss = bosses[idx]
	if nameFs then
		nameFs:SetText(boss.label or "")
	end
	if counter then
		if #bosses > 1 then
			counter:SetText(("%d / %d"):format(idx, #bosses))
			counter:Show()
		else
			counter:Hide()
		end
	end
	if f._bossAutoHint then
		-- Only show the hint when we *want* auto selection, but do not yet have a
		-- confirmed active boss (we're showing the saved/last index as fallback).
		if preferAuto and not autoResolved and not f._previewMode then
			f._bossAutoHint:SetText(ns:SafeL("DELVE_COACH_BOSS_PENDING"))
			f._bossAutoHint:Show()
		else
			f._bossAutoHint:Hide()
		end
	end
	if f._bossPrev then
		f._bossPrev:SetShown(#bosses > 1)
	end
	if f._bossNext then
		f._bossNext:SetShown(#bosses > 1)
	end
	if entryId ~= f._bossEntryId then
		f._bossManualOverride = false
		f._bossBrowseIndex = nil
		if model and ns.ClearDelveBossCreatureModel then
			ns:ClearDelveBossCreatureModel(model)
		end
	elseif prevIdx and idx ~= prevIdx and model and ns.ClearDelveBossCreatureModel then
		ns:ClearDelveBossCreatureModel(model)
	end
	if f._bossLoading then
		f._bossLoading:SetText(ns:L("DELVE_COACH_BOSS_LOADING"))
		f._bossLoading:Show()
	end
	if model then
		model._mhLoadingFs = f._bossLoading
	end
	if f._bossPortraitTex then
		f._bossPortraitTex:Hide()
	end
	if ns.ApplyDelveBossCreatureModel and model then
		ns:ApplyDelveBossCreatureModel(model, boss.creatureId, boss)
	end
	if model and model._mhLoadedCreatureId == boss.creatureId and f._bossLoading then
		f._bossLoading:Hide()
	elseif model and not model._mhLoadedCreatureId and f._bossLoading then
		f._bossLoading:SetText(ns:L("DELVE_COACH_BOSS_LOADING"))
		f._bossLoading:Show()
	end
	if C_Timer and C_Timer.After then
		local creatureId = boss.creatureId
		C_Timer.After(0.4, function()
			if not f or f._bossEntryId ~= entryId then
				return
			end
			local m = f._bossModel
			if m and m._mhLoadedCreatureId == creatureId then
				if f._bossPortraitTex then
					f._bossPortraitTex:Hide()
				end
				return
			end
			if ns.ApplyDelveBossPortraitFallback and f._bossPortraitTex then
				if ns.ApplyDelveBossPortraitFallback(f._bossPortraitTex, boss) and f._bossLoading then
					f._bossLoading:Hide()
				end
			end
		end)
		C_Timer.After(2.5, function()
			if not f or f._bossEntryId ~= entryId then
				return
			end
			local m = f._bossModel
			if m and m._mhLoadedCreatureId == creatureId then
				return
			end
			if ns.ApplyDelveBossPortraitFallback and f._bossPortraitTex and not f._bossPortraitTex:IsShown() then
				if ns.ApplyDelveBossPortraitFallback(f._bossPortraitTex, boss) and f._bossLoading then
					f._bossLoading:Hide()
				end
			end
		end)
	end
	if (ns.IsDelveInstanceInProgress and ns.IsDelveInstanceInProgress()) and model and C_Timer and C_Timer.After then
		local creatureId = boss.creatureId
		for _, delay in ipairs({ 0.35, 0.75, 1.5, 3.0 }) do
			C_Timer.After(delay, function()
				if not f or not f:IsShown() or f._bossEntryId ~= entryId or not f._bossModel then
					return
				end
				local m = f._bossModel
				if m._mhLoadedCreatureId then
					return
				end
				if ns.ApplyDelveBossCreatureModel then
					ns:ApplyDelveBossCreatureModel(m, creatureId, boss)
				end
			end)
		end
	end
	f._bossEntryId = entryId
	f._bossShowcaseIndex = idx
end

local function ScrollCoachByDelta(scroll, delta)
	if not scroll or not delta or delta == 0 then
		return
	end
	if not scroll.GetVerticalScroll or not scroll.SetVerticalScroll then
		return
	end
	local cur = scroll:GetVerticalScroll() or 0
	local maxRange = scroll.GetVerticalScrollRange and scroll:GetVerticalScrollRange() or 0
	local nextScroll = math.max(0, math.min(maxRange, cur - (delta * SCROLL_WHEEL_STEP)))
	scroll:SetVerticalScroll(nextScroll)
end

local function LayoutCoachScroll(f, resetScroll)
	local scroll = f._scroll
	local content = f._content
	local body = f._body
	if not scroll or not content or not body then
		return
	end
	local scrollW = scroll:GetWidth() or 260
	local textW = math.max(200, scrollW - 20)
	content:SetWidth(textW)
	if f._bodyHost then
		f._bodyHost:SetWidth(textW)
	end
	body:SetWidth(textW - 8)
	body:SetText(f._bodyText or "")

	local function applyHeights()
		local lineH = body.GetLineHeight and body:GetLineHeight() or 14
		local numLines = body.GetNumLines and body:GetNumLines() or 1
		local bodyH = math.max((numLines * lineH) + 12, 40)
		local totalH = math.max(bodyH + 16, 48)
		content:SetHeight(totalH)
		if f._bodyHost then
			f._bodyHost:SetHeight(totalH)
		end
		if scroll.UpdateScrollChildRect then
			scroll:UpdateScrollChildRect()
		end
	end

	applyHeights()
	if C_Timer and C_Timer.After then
		C_Timer.After(0, applyHeights)
		C_Timer.After(0.05, applyHeights)
	end
	if resetScroll and scroll.SetVerticalScroll then
		scroll:SetVerticalScroll(0)
	end
end

local function RefreshCoachBody(f, entry, live, resetScroll)
	if not f or not entry then
		return
	end
	f._bodyText = BuildCoachBody(entry, {
		live = live,
		bossIndex = f._bossShowcaseIndex,
		bossManualOverride = f._bossManualOverride,
	})
	LayoutCoachScroll(f, resetScroll == true)
end

local function CycleBossShowcase(f, delta)
	local entryId = f._bossEntryId
	if not entryId then
		return
	end
	local bosses = ns.GetDelveBossShowcase and ns:GetDelveBossShowcase(entryId)
	if not bosses or #bosses < 2 then
		return
	end
	local idx = f._bossBrowseIndex or f._bossShowcaseIndex
		or (ns.GetDelveBossShowcaseIndex and ns:GetDelveBossShowcaseIndex(entryId))
		or 1
	idx = idx + (delta or 1)
	if idx > #bosses then
		idx = 1
	elseif idx < 1 then
		idx = #bosses
	end
	-- Session-only browse; do not write to SavedVariables (preview uses auto/story).
	f._bossBrowseIndex = idx
	f._bossManualOverride = true
	UpdateBossShowcase(f, entryId)
	local entry = ns.GetDelveTipEntryById and ns.GetDelveTipEntryById(entryId)
	if entry then
		RefreshCoachBody(f, entry, not f._previewMode)
	end
end

local function RelayoutCoachFrame(f)
	if not f or f._minimized then
		return
	end
	if f._scroll and f._bossPanel then
		f._scroll:Show()
	end
	LayoutCoachScroll(f, false)
end

local function HandleCoachMouseWheel(f, delta)
	if not f or f._minimized or not delta or delta == 0 then
		return
	end
	if IsShiftKeyDown and IsShiftKeyDown() then
		AdjustCoachScale(f, delta)
		return
	end
	local focus = GetMouseFocus and GetMouseFocus()
	if focus and (focus == f._bossModelHost or focus == f._bossModel) then
		return
	end
	if f._scroll and f._scroll:IsShown() then
		ScrollCoachByDelta(f._scroll, delta)
	end
end

local function BindCoachMouseWheel(frame, f)
	if not frame then
		return
	end
	frame:EnableMouseWheel(true)
	frame:SetScript("OnMouseWheel", function(_, delta)
		HandleCoachMouseWheel(f, delta)
	end)
end

local function ScheduleRelayoutCoachFrame(f)
	if not f or not C_Timer or not C_Timer.After then
		RelayoutCoachFrame(f)
		return
	end
	f._mhRelayoutToken = (f._mhRelayoutToken or 0) + 1
	local token = f._mhRelayoutToken
	C_Timer.After(0, function()
		if f._mhRelayoutToken ~= token then
			return
		end
		RelayoutCoachFrame(f)
	end)
end

local function SetMinimized(f, minimized)
	local s = GetSettings()
	s.minimized = minimized and true or false
	f._minimized = minimized and true or false
	if minimized then
		if f._scroll then
			f._scroll:Hide()
		end
		if f._hint then
			f._hint:Hide()
		end
		if f._shareBar then
			f._shareBar:Hide()
		end
		if f._bossPanel then
			f._bossPanel:Hide()
		end
		if f._resizeGrip then
			f._resizeGrip:Hide()
		end
		if f._resizeBar then
			f._resizeBar:Hide()
		end
		if f._resizeRight then
			f._resizeRight:Hide()
		end
		f:SetHeight(COACH_TITLE_H)
	else
		if f._scroll then
			f._scroll:Show()
		end
		if f._hint then
			f._hint:Show()
		end
		if f._shareBar then
			f._shareBar:Show()
		end
		if f._resizeGrip then
			f._resizeGrip:Show()
		end
		if f._resizeBar then
			f._resizeBar:Show()
		end
		if f._resizeRight then
			f._resizeRight:Show()
		end
		ApplyCoachSize(f)
		if currentEntryId then
			UpdateBossShowcase(f, currentEntryId)
		end
		LayoutCoachScroll(f, true)
	end
	if f._minBtn and f._minBtn.SetText then
		f._minBtn:SetText(minimized and "+" or "-")
	end
end

local function EnsureCoachFrame()
	if coachFrame then
		if coachFrame._resizeGrip then
			coachFrame._resizeGrip:SetSize(RESIZE_GRIP, RESIZE_GRIP)
		end
		if coachFrame._bossLoading and coachFrame._bossLoading.SetFontObject then
			if not coachFrame._bossLoading:GetFont() then
				coachFrame._bossLoading:SetFontObject(GameFontDisable or GameFontHighlightSmall)
			end
		end
		ApplyCoachSize(coachFrame)
		ApplyCoachScale(coachFrame)
		RelayoutCoachFrame(coachFrame)
		return coachFrame
	end

	local f = CreateFrame("Frame", "MidnightHelperDelveCoach", UIParent, "BackdropTemplate")
	f:SetSize(COACH_DEFAULT_W, COACH_DEFAULT_H)
	BringCoachFrameToFront(f)

	-- World map tooltips contain "Story Variant: ..." even when the POI API does
	-- not expose it. Hook once so hovering the delve icon teaches the coach.
	if ns.HookDelveStoryTooltip then
		ns.HookDelveStoryTooltip()
	end

	f:SetClampedToScreen(true)
	f:EnableMouse(true)
	f:SetMovable(true)
	if f.SetResizable then
		f:SetResizable(true)
	end
	if f.SetResizeBounds then
		f:SetResizeBounds(COACH_MIN_W, COACH_MIN_H, COACH_MAX_W, COACH_MAX_H)
	end
	f:SetBackdrop({
		bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
		edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Gold-Border",
		tile = true,
		tileSize = 32,
		edgeSize = 32,
		insets = { left = 11, right = 12, top = 12, bottom = 11 },
	})
	f:SetBackdropColor(0.05, 0.05, 0.08, 0.92)
	f:Hide()

	tinsert(UISpecialFrames, f:GetName())

	local titleBar = CreateFrame("Frame", nil, f)
	titleBar:SetHeight(28)
	titleBar:SetPoint("TOPLEFT", f, "TOPLEFT", 12, -8)
	titleBar:SetPoint("TOPRIGHT", f, "TOPRIGHT", -12, -8)
	titleBar:EnableMouse(true)
	titleBar:RegisterForDrag("LeftButton")
	titleBar:SetScript("OnDragStart", function()
		f:StartMoving()
	end)
	titleBar:SetScript("OnDragStop", function()
		f:StopMovingOrSizing()
		SavePoint(f)
	end)
	f._titleBar = titleBar
	BindCoachMouseWheel(titleBar, f)

	local title = titleBar:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	title:SetPoint("LEFT", titleBar, "LEFT", 0, 0)
	title:SetPoint("RIGHT", titleBar, "RIGHT", -52, 0)
	title:SetJustifyH("LEFT")
	title:SetWordWrap(false)
	f._title = title

	local minBtn = CreateFrame("Button", nil, titleBar, "UIPanelButtonTemplate")
	minBtn:SetSize(22, 22)
	minBtn:SetPoint("RIGHT", titleBar, "RIGHT", -26, 0)
	minBtn:SetText("-")
	f._minBtn = minBtn
	minBtn:SetScript("OnClick", function()
		local s = GetSettings()
		SetMinimized(f, not s.minimized)
	end)

	local closeBtn = CreateFrame("Button", nil, titleBar, "UIPanelCloseButton")
	closeBtn:SetSize(22, 22)
	closeBtn:SetPoint("RIGHT", titleBar, "RIGHT", 0, 0)
	closeBtn:SetScript("OnClick", function()
		ns:HideDelveCoach(true)
	end)

	local hint = f:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
	hint:SetPoint("TOPLEFT", titleBar, "BOTTOMLEFT", 0, -2)
	hint:SetPoint("TOPRIGHT", titleBar, "BOTTOMRIGHT", 0, -2)
	hint:SetJustifyH("LEFT")
	hint:SetWordWrap(true)
	hint:SetText(ns:L("DELVE_COACH_DRAG_HINT"))
	f._hint = hint

	local shareBar = CreateFrame("Frame", nil, f)
	shareBar:SetPoint("TOPLEFT", hint, "BOTTOMLEFT", 0, -4)
	shareBar:SetPoint("TOPRIGHT", hint, "BOTTOMRIGHT", 0, -4)
	shareBar:SetHeight(52)
	f._shareBar = shareBar
	BindCoachMouseWheel(shareBar, f)

	local shareHint = shareBar:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
	shareHint:SetPoint("TOPLEFT", shareBar, "TOPLEFT", 0, 0)
	shareHint:SetPoint("TOPRIGHT", shareBar, "TOPRIGHT", -108, 0)
	shareHint:SetJustifyH("LEFT")
	shareHint:SetWordWrap(true)
	shareHint:SetText(ns:L("DELVE_SHARE_BAR_HINT"))
	f._shareHint = shareHint

	local testChk = CreateFrame("CheckButton", nil, shareBar, "UICheckButtonTemplate")
	testChk:SetSize(22, 22)
	testChk:SetPoint("TOPRIGHT", shareBar, "TOPRIGHT", 0, 0)
	local testLbl = shareBar:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
	testLbl:SetPoint("RIGHT", testChk, "LEFT", 0, 0)
	testLbl:SetText(ns:L("DELVE_SHARE_TEST_MODE"))
	f._shareTestChk = testChk
	f._shareTestLabel = testLbl
	testChk:SetScript("OnClick", function(self)
		if ns.SetDelvePartyShareTestMode then
			ns.SetDelvePartyShareTestMode(self:GetChecked())
		end
	end)
	if ns.GetDelvePartyShareTestMode then
		testChk:SetChecked(ns.GetDelvePartyShareTestMode())
	end

	local btnRow = CreateFrame("Frame", nil, shareBar)
	btnRow:SetPoint("TOPLEFT", shareHint, "BOTTOMLEFT", 0, -2)
	btnRow:SetPoint("RIGHT", shareBar, "RIGHT", 0, 0)
	btnRow:SetHeight(24)
	f._shareBtnRow = btnRow

	local shareBtnList = {}

	local function FitCoachShareButton(btn, minWidth)
		if not btn or not btn.GetFontString then
			return
		end
		local fs = btn:GetFontString()
		if not fs or not fs.GetStringWidth then
			return
		end
		local w = (fs:GetStringWidth() or 0) + 18
		btn:SetWidth(math.max(minWidth or 44, w))
	end

	local function ReflowShareButtons()
		local prev
		for i = 1, #shareBtnList do
			local b = shareBtnList[i]
			if b and b._mhLabelKey then
				b:SetText(ns:L(b._mhLabelKey))
				FitCoachShareButton(b, i == 1 and 52 or 40)
				b:ClearAllPoints()
				if not prev then
					b:SetPoint("LEFT", btnRow, "LEFT", 0, 0)
				else
					b:SetPoint("LEFT", prev, "RIGHT", 4, 0)
				end
				prev = b
			end
		end
	end

	local function MakeShareBtn(parent, labelKey, minWidth)
		local b = CreateFrame("Button", nil, parent, "UIPanelButtonTemplate")
		b:SetHeight(22)
		b._mhLabelKey = labelKey
		b._mhMinWidth = minWidth or 44
		b:SetText(ns:L(labelKey))
		FitCoachShareButton(b, b._mhMinWidth)
		shareBtnList[#shareBtnList + 1] = b
		return b
	end

	f._reflowShareButtons = ReflowShareButtons

	local btnBrief = MakeShareBtn(btnRow, "DELVE_SHARE_BTN_BRIEF", 52)
	btnBrief:SetScript("OnClick", function()
		if currentEntryId and ns.SendDelvePartyShare then
			ns.SendDelvePartyShare(currentEntryId, "brief")
		end
	end)
	f._shareBtnBrief = btnBrief

	local btnBoss = MakeShareBtn(btnRow, "DELVE_SHARE_BTN_BOSS", 40)
	btnBoss:SetScript("OnClick", function()
		if currentEntryId and ns.SendDelvePartyShare then
			ns.SendDelvePartyShare(currentEntryId, "boss")
		end
	end)
	f._shareBtnBoss = btnBoss

	local btnMore = MakeShareBtn(btnRow, "DELVE_SHARE_BTN_MORE", 40)
	f._shareBtnMore = btnMore

	local btnCopy = MakeShareBtn(btnRow, "DELVE_SHARE_BTN_COPY", 44)
	btnCopy:SetScript("OnClick", function()
		if currentEntryId and ns.ToggleDelvePartyShareCopy then
			ns.ToggleDelvePartyShareCopy(currentEntryId, "brief")
		end
	end)
	f._shareBtnCopy = btnCopy
	ReflowShareButtons()

	local MORE_SHARE_MENU = {
		{ mode = "overview", labelKey = "DELVE_SHARE_MENU_OVERVIEW" },
		{ mode = "route", labelKey = "DELVE_SHARE_MENU_ROUTE" },
		{ mode = "trash", labelKey = "DELVE_SHARE_MENU_TRASH" },
		{ separator = true },
		{ mode = "all", labelKey = "DELVE_SHARE_MENU_ALL" },
	}

	local function CloseShareDropDown()
		if CloseDropDownMenus then
			CloseDropDownMenus()
		end
	end

	local function InitDelveShareMoreMenu(dropdown, level)
		if level ~= 1 then
			return
		end
		local entryId = dropdown._mhEntryId
		if not entryId or not UIDropDownMenu_CreateInfo or not UIDropDownMenu_AddButton then
			return
		end
		for _, item in ipairs(MORE_SHARE_MENU) do
			local info = UIDropDownMenu_CreateInfo()
			if item.separator then
				info.text = ""
				info.isTitle = true
				info.notCheckable = true
				info.disabled = true
			else
				info.text = ns:L(item.labelKey)
				info.notCheckable = true
				info.func = function()
					CloseShareDropDown()
					if ns.SendDelvePartyShare then
						ns.SendDelvePartyShare(entryId, item.mode)
					end
				end
			end
			UIDropDownMenu_AddButton(info, level)
		end
	end

	btnMore:SetScript("OnClick", function(self)
		if not currentEntryId then
			return
		end
		if not UIDropDownMenu_Initialize or not ToggleDropDownMenu then
			print(
				("|cffffcc00%s|r %s"):format(
					ns:L("PRINT_PREFIX"),
					ns:L("DELVE_SHARE_MENU_UNAVAILABLE") or "Share menu unavailable."
				)
			)
			return
		end
		if not f._moreMenuFrame then
			f._moreMenuFrame = CreateFrame("Frame", "MidnightHelperDelveShareMenu", UIParent, "UIDropDownMenuTemplate")
		end
		local menu = f._moreMenuFrame
		menu._mhEntryId = currentEntryId
		UIDropDownMenu_Initialize(menu, InitDelveShareMoreMenu, "MENU")
		ToggleDropDownMenu(1, nil, menu, self, 0, 0)
	end)

	local bossPanel = CreateFrame("Frame", nil, f, "BackdropTemplate")
	bossPanel:SetPoint("TOPLEFT", shareBar, "BOTTOMLEFT", 4, -4)
	bossPanel:SetPoint("TOPRIGHT", shareBar, "BOTTOMRIGHT", -4, -4)
	bossPanel:SetHeight(BOSS_PANEL_H)
	if bossPanel.SetBackdrop then
		bossPanel:SetBackdrop({
			bgFile = "Interface\\Buttons\\WHITE8X8",
			edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
			tile = false,
			edgeSize = 12,
			insets = { left = 3, right = 3, top = 3, bottom = 3 },
		})
		bossPanel:SetBackdropColor(0.04, 0.06, 0.1, 0.88)
		bossPanel:SetBackdropBorderColor(0.45, 0.38, 0.22, 0.9)
	end
	f._bossPanel = bossPanel
	BindCoachMouseWheel(bossPanel, f)

	local bossTitle = bossPanel:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	bossTitle:SetPoint("TOPLEFT", bossPanel, "TOPLEFT", 8, -6)
	bossTitle:SetText(ns:L("DELVE_COACH_BOSS_SHOWCASE"))
	f._bossTitle = bossTitle

	local bossNameBg = CreateFrame("Frame", nil, bossPanel, "BackdropTemplate")
	bossNameBg:SetPoint("LEFT", bossPanel, "LEFT", BOSS_MODEL_INSET_SIDE, 0)
	bossNameBg:SetPoint("RIGHT", bossPanel, "RIGHT", -BOSS_MODEL_INSET_SIDE, 0)
	bossNameBg:SetPoint("BOTTOM", bossPanel, "BOTTOM", 0, 6)
	bossNameBg:SetHeight(BOSS_NAME_BAR_H)
	bossNameBg:SetFrameLevel(bossPanel:GetFrameLevel() + 12)
	if bossNameBg.SetBackdrop then
		bossNameBg:SetBackdrop({
			bgFile = "Interface\\Buttons\\WHITE8X8",
			edgeFile = nil,
		})
		bossNameBg:SetBackdropColor(0.02, 0.03, 0.06, 0.82)
	end
	f._bossNameBg = bossNameBg

	local bossName = bossNameBg:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	bossName:SetPoint("CENTER", bossNameBg, "CENTER", 0, 0)
	bossName:SetJustifyH("CENTER")
	bossName:SetTextColor(1, 0.9, 0.55)
	f._bossName = bossName

	local bossCounter = bossPanel:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
	bossCounter:SetPoint("TOPRIGHT", bossPanel, "TOPRIGHT", -8, -6)
	f._bossCounter = bossCounter

	local bossAutoHint = bossPanel:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
	bossAutoHint:SetPoint("TOPLEFT", bossTitle, "BOTTOMLEFT", 0, -2)
	bossAutoHint:SetPoint("RIGHT", bossPanel, "RIGHT", -10, 0)
	bossAutoHint:SetJustifyH("LEFT")
	bossAutoHint:SetTextColor(0.7, 0.72, 0.78)
	bossAutoHint:Hide()
	f._bossAutoHint = bossAutoHint

	local bossPrev = CreateFrame("Button", nil, bossPanel, "UIPanelButtonTemplate")
	bossPrev:SetSize(22, 22)
	bossPrev:SetPoint("LEFT", bossPanel, "LEFT", 6, -8)
	bossPrev:SetText("<")
	bossPrev:SetScript("OnClick", function()
		CycleBossShowcase(f, -1)
	end)
	f._bossPrev = bossPrev

	local bossNext = CreateFrame("Button", nil, bossPanel, "UIPanelButtonTemplate")
	bossNext:SetSize(22, 22)
	bossNext:SetPoint("RIGHT", bossPanel, "RIGHT", -6, -8)
	bossNext:SetText(">")
	bossNext:SetScript("OnClick", function()
		CycleBossShowcase(f, 1)
	end)
	f._bossNext = bossNext

	local modelHost = CreateFrame("Frame", nil, bossPanel)
	modelHost:SetPoint("TOPLEFT", bossPanel, "TOPLEFT", BOSS_MODEL_INSET_SIDE, -BOSS_MODEL_INSET_TOP)
	modelHost:SetPoint("BOTTOMRIGHT", bossPanel, "BOTTOMRIGHT", -BOSS_MODEL_INSET_SIDE, BOSS_NAME_BAR_H + 10)
	if modelHost.SetClipsChildren then
		modelHost:SetClipsChildren(true)
	end
	modelHost:EnableMouse(true)
	modelHost:EnableMouseWheel(true)
	modelHost:SetScript("OnMouseWheel", function(_, delta)
		if not delta or delta == 0 then
			return
		end
		local m = f._bossModel
		local creatureId = m and m._mhLoadedCreatureId
		if not creatureId or not ns.AdjustDelveBossCam then
			return
		end
		ns:AdjustDelveBossCam(m, creatureId, m._mhBossEntry, delta)
	end)
	if GameTooltip then
		modelHost:SetScript("OnEnter", function()
			GameTooltip:SetOwner(modelHost, "ANCHOR_CURSOR")
			GameTooltip:SetText(ns:L("DELVE_COACH_BOSS_ZOOM_HINT"), 1, 1, 1, 1, true)
			GameTooltip:Show()
		end)
		modelHost:SetScript("OnLeave", function()
			GameTooltip:Hide()
		end)
	end
	f._bossModelHost = modelHost

	local portraitTex = modelHost:CreateTexture(nil, "ARTWORK")
	portraitTex:SetAllPoints(modelHost)
	portraitTex:SetTexCoord(0.08, 0.92, 0.08, 0.92)
	portraitTex:Hide()
	f._bossPortraitTex = portraitTex

	local bossModel
	if CreateFrame then
		local modelOk, modelFrame = pcall(CreateFrame, "PlayerModel", nil, modelHost)
		if modelOk and modelFrame then
			bossModel = modelFrame
		end
	end
	if bossModel then
		bossModel:SetAllPoints(modelHost)
		bossModel:SetFrameLevel(modelHost:GetFrameLevel() + 2)
		bossModel:EnableMouse(false)
	end
	f._bossModel = bossModel

	local bossLoading = bossPanel:CreateFontString(nil, "ARTWORK", "GameFontDisable")
	bossLoading:SetPoint("CENTER", modelHost, "CENTER", 0, 0)
	if not bossLoading:GetFont() and bossLoading.SetFontObject then
		bossLoading:SetFontObject(GameFontHighlightSmall)
	end
	bossLoading:SetTextColor(0.75, 0.78, 0.85)
	bossLoading:SetText(ns:L("DELVE_COACH_BOSS_LOADING"))
	bossLoading:Hide()
	if bossLoading.SetDrawLayer then
		bossLoading:SetDrawLayer("ARTWORK", -1)
	end
	if modelHost and bossLoading.SetFrameLevel then
		bossLoading:SetFrameLevel(modelHost:GetFrameLevel())
	end
	f._bossLoading = bossLoading
	if bossModel then
		bossModel._mhLoadingFs = bossLoading
	end

	local scroll = CreateFrame("ScrollFrame", nil, f, "UIPanelScrollFrameTemplate")
	scroll:SetPoint("TOPLEFT", bossPanel, "BOTTOMLEFT", 0, -6)
	scroll:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -26, RESIZE_EDGE_H + 8)
	scroll:EnableMouse(true)
	scroll:EnableMouseWheel(true)
	if scroll.SetClipsChildren then
		scroll:SetClipsChildren(true)
	end
	scroll:SetScript("OnMouseWheel", function(_, delta)
		HandleCoachMouseWheel(f, delta)
	end)
	f._scroll = scroll

	local content = CreateFrame("Frame", nil, scroll)
	content:SetSize(260, 40)
	content:EnableMouse(true)
	scroll:SetScrollChild(content)
	f._content = content

	local bodyHost = CreateFrame("Frame", nil, content)
	bodyHost:SetPoint("TOPLEFT", content, "TOPLEFT", 0, 0)
	bodyHost:SetPoint("RIGHT", content, "RIGHT", 0, 0)
	bodyHost:EnableMouse(true)
	f._bodyHost = bodyHost

	local body = CreateFrame("EditBox", nil, bodyHost)
	body:SetPoint("TOPLEFT", bodyHost, "TOPLEFT", 0, 0)
	body:SetPoint("BOTTOMRIGHT", bodyHost, "BOTTOMRIGHT", 0, 0)
	body:SetMultiLine(true)
	body:SetFontObject("GameFontHighlight")
	body:SetJustifyH("LEFT")
	body:SetJustifyV("TOP")
	body:SetAutoFocus(false)
	body:EnableMouse(true)
	if body.SetMaxLetters then
		body:SetMaxLetters(0)
	end
	if ns.AttachDelveTipHyperlinksToEditBox then
		ns:AttachDelveTipHyperlinksToEditBox(body)
	end
	f._body = body

	local resizeRight = CreateFrame("Frame", nil, f)
	resizeRight:SetWidth(RESIZE_EDGE_H)
	resizeRight:SetPoint("TOPRIGHT", f, "TOPRIGHT", -4, -36)
	resizeRight:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -4, RESIZE_GRIP + 8)
	resizeRight:EnableMouse(true)
	resizeRight:RegisterForDrag("LeftButton")
	resizeRight:SetScript("OnDragStart", function()
		f:StartSizing("RIGHT")
	end)
	resizeRight:SetScript("OnDragStop", function()
		f:StopMovingOrSizing()
		SaveCoachSize(f)
		ScheduleRelayoutCoachFrame(f)
	end)
	f._resizeRight = resizeRight

	local resizeBar = CreateFrame("Frame", nil, f)
	resizeBar:SetHeight(RESIZE_EDGE_H)
	resizeBar:SetPoint("BOTTOMLEFT", f, "BOTTOMLEFT", 10, 4)
	resizeBar:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -(RESIZE_GRIP + 10), 4)
	resizeBar:EnableMouse(true)
	resizeBar:RegisterForDrag("LeftButton")
	resizeBar:SetScript("OnDragStart", function()
		f:StartSizing("BOTTOM")
	end)
	resizeBar:SetScript("OnDragStop", function()
		f:StopMovingOrSizing()
		SaveCoachSize(f)
		ScheduleRelayoutCoachFrame(f)
	end)
	if resizeBar.SetScript then
		resizeBar:SetScript("OnEnter", function()
			if GameTooltip then
				GameTooltip:SetOwner(resizeBar, "ANCHOR_TOP")
				GameTooltip:SetText(ns:L("DELVE_COACH_RESIZE_HINT"), 1, 1, 1, 1, true)
				GameTooltip:Show()
			end
		end)
		resizeBar:SetScript("OnLeave", function()
			if GameTooltip then
				GameTooltip:Hide()
			end
		end)
	end
	f._resizeBar = resizeBar

	local grip = CreateFrame("Button", nil, f)
	grip:SetSize(RESIZE_GRIP, RESIZE_GRIP)
	grip:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -4, 4)
	grip:SetFrameLevel(f:GetFrameLevel() + 20)
	grip:RegisterForDrag("LeftButton")
	grip:SetNormalTexture("Interface\\Buttons\\UI-ResizeButton-Up")
	grip:SetPushedTexture("Interface\\Buttons\\UI-ResizeButton-Down")
	grip:SetHighlightTexture("Interface\\Buttons\\UI-Common-MouseHilight", "ADD")
	grip:SetScript("OnDragStart", function()
		f:StartSizing("BOTTOMRIGHT")
	end)
	grip:SetScript("OnDragStop", function()
		f:StopMovingOrSizing()
		SaveCoachSize(f)
		ScheduleRelayoutCoachFrame(f)
	end)
	if grip.SetScript then
		grip:SetScript("OnEnter", function()
			if GameTooltip then
				GameTooltip:SetOwner(grip, "ANCHOR_TOPLEFT")
				GameTooltip:SetText(ns:L("DELVE_COACH_RESIZE_HINT"), 1, 1, 1, 1, true)
				GameTooltip:Show()
			end
		end)
		grip:SetScript("OnLeave", function()
			if GameTooltip then
				GameTooltip:Hide()
			end
		end)
	end
	f._resizeGrip = grip

	BindCoachMouseWheel(f, f)

	f:SetScript("OnSizeChanged", function()
		if f._minimized then
			return
		end
		SaveCoachSize(f)
		ScheduleRelayoutCoachFrame(f)
	end)

	f:SetScript("OnShow", function()
		if currentEntryId then
			UpdateBossShowcase(f, currentEntryId)
			if C_Timer and C_Timer.After then
				for _, delay in ipairs({ 0.5, 1.5, 3.0 }) do
					C_Timer.After(delay, function()
						if f:IsShown() and currentEntryId then
							UpdateBossShowcase(f, currentEntryId)
						end
					end)
				end
			end
		end
	end)

	ApplySavedPoint(f)
	ApplyCoachSize(f)
	coachFrame = f
	return f
end

local function RefreshDelveCoachLiveContent()
	if not coachFrame or not currentEntryId then
		return
	end
	local entry = ns.GetDelveTipEntryById and ns.GetDelveTipEntryById(currentEntryId)
	if not entry then
		return
	end
	if coachFrame._previewMode then
		return
	end
	if ns.RefreshDelveStorySnapshot then
		if ns.PrimeDelveStoryPoiCache then
			ns.PrimeDelveStoryPoiCache(currentEntryId)
		end
		ns.RefreshDelveStorySnapshot(currentEntryId)
	end
	UpdateBossShowcase(coachFrame, currentEntryId)
	RefreshCoachBody(coachFrame, entry, true)
end

function ns.RefreshDelveCoachLiveContent()
	RefreshDelveCoachLiveContent()
end

function ns:RefreshDelveCoachLocale()
	if not coachFrame then
		return
	end
	if coachFrame._hint then
		coachFrame._hint:SetText(self:L("DELVE_COACH_DRAG_HINT"))
	end
	if ns.UpdateDelveShareBarUI then
		ns:UpdateDelveShareBarUI()
	end
	if coachFrame._reflowShareButtons then
		coachFrame._reflowShareButtons()
	end
	if coachFrame._bossTitle then
		coachFrame._bossTitle:SetText(self:L("DELVE_COACH_BOSS_SHOWCASE"))
	end
	if ns.RefreshDelvePartyShareLocale then
		ns:RefreshDelvePartyShareLocale()
	end
	if currentEntryId then
		self:ShowDelveCoach(currentEntryId, { preview = coachFrame._previewMode })
	end
end

function ns:ShowDelveCoach(entryId, options)
	options = options or {}
	local entry = ns.GetDelveTipEntryById and ns.GetDelveTipEntryById(entryId)
	if not entry then
		return false, "no_entry"
	end
	local s = GetSettings()
	local isPreview = options.preview and true or false
	if not s.enabled and not isPreview then
		return false, "disabled"
	end

	local ok, err = pcall(function()
		local f = EnsureCoachFrame()
		if isPreview or entryId ~= f._bossEntryId then
			f._bossManualOverride = false
			f._bossBrowseIndex = nil
		end
		currentEntryId = entryId
		f._previewMode = isPreview
		f._userDismissed = false

		if ns.PrimeDelveStoryPoiCache then
			ns.PrimeDelveStoryPoiCache(entryId)
		end
		local tag = isPreview and (" " .. self:L("DELVE_COACH_PREVIEW_TAG")) or ""
		local delveLabel = (ns.GetDelveTipDisplayName and ns:GetDelveTipDisplayName(entry)) or entry.rosterName or ""
		f._title:SetText(self:L("DELVE_COACH_TITLE") .. " — " .. delveLabel .. tag)
		UpdateBossShowcase(f, entryId)
		RefreshCoachBody(f, entry, not isPreview, true)
		ApplyCoachSize(f)

		ApplySavedPoint(f)
		if isPreview then
			SetMinimized(f, false)
		else
			SetMinimized(f, s.minimized)
		end
		BringCoachFrameToFront(f)
		f:Show()
		if ns.UpdateDelveShareBarUI then
			ns:UpdateDelveShareBarUI()
		end
		if ns.RefreshDelveItemsPopup then
			ns:RefreshDelveItemsPopup()
		end
		if not isPreview and ns.MaybeAutoShowDelveItemsPopup then
			ns:MaybeAutoShowDelveItemsPopup()
		end
	end)

	if not ok then
		local msg = tostring(err)
		print(("|cffffcc00%s|r %s (%s)"):format(self:L("PRINT_PREFIX"), self:L("DELVE_COACH_OPEN_FAILED"), msg))
		return false, msg
	end
	return true
end

function ns:HideDelveCoach(userClose)
	if not coachFrame then
		return
	end
	if userClose and not coachFrame._previewMode then
		coachFrame._userDismissed = true
	end
	coachFrame:Hide()
end

function ns:ToggleDelveCoach()
	local f = EnsureCoachFrame()
	if f:IsShown() then
		self:HideDelveCoach(true)
		return false
	end
	local active = ResolveActiveDelveEntry()
	if active then
		-- In een delve: meteen de juiste coach, geen picker nodig.
		self:ShowDelveCoach(active.id, { preview = false })
		return true
	end
	-- Niet in een delve: toon de laatst-bekeken coach (indien bekend) ÉN de
	-- picker, zodat je makkelijk een andere delve kunt kiezen (Rob, 24 jun).
	if currentEntryId then
		self:ShowDelveCoach(currentEntryId, { preview = true })
	end
	self:OpenDelveCoachPicker()
	return true
end

local function EnsurePickerFrame()
	if pickerFrame then
		return pickerFrame
	end

	local f = CreateFrame("Frame", "MidnightHelperDelveCoachPicker", UIParent, "BackdropTemplate")
	f:SetSize(280, 380)
	BringCoachFrameToFront(f)
	f:SetClampedToScreen(true)
	f:EnableMouse(true)
	f:SetMovable(true)
	f:RegisterForDrag("LeftButton")
	f:SetScript("OnDragStart", f.StartMoving)
	f:SetScript("OnDragStop", f.StopMovingOrSizing)
	f:SetBackdrop({
		bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
		edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Gold-Border",
		tile = true,
		tileSize = 32,
		edgeSize = 32,
		insets = { left = 11, right = 12, top = 12, bottom = 11 },
	})
	f:Hide()
	tinsert(UISpecialFrames, f:GetName())

	local title = f:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
	title:SetPoint("TOP", f, "TOP", 0, -14)
	f._title = title

	local close = CreateFrame("Button", nil, f, "UIPanelCloseButton")
	close:SetPoint("TOPRIGHT", f, "TOPRIGHT", -4, -4)
	close:SetScript("OnClick", function()
		f:Hide()
	end)

	-- Plain list host (11 delves fit without scroll; keeps buttons centered in the frame).
	local listHost = CreateFrame("Frame", nil, f)
	listHost:SetPoint("TOPLEFT", f, "TOPLEFT", 12, -36)
	listHost:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -12, 12)
	listHost:EnableMouse(true)
	f._listHost = listHost

	local content = CreateFrame("Frame", nil, listHost)
	content:SetAllPoints(listHost)
	content:EnableMouse(true)
	f._content = content
	f._buttons = {}

	pickerFrame = f
	return f
end

function ns:OpenDelveCoachPicker(anchor)
	local f = EnsurePickerFrame()
	f._title:SetText(self:L("DELVE_COACH_PICKER_TITLE"))

	-- ⚠️ 15 aug 2026: het frame stond hard op 380 hoog, gebouwd toen er elf delves
	-- waren ("11 delves fit without scroll", zie de comment bij listHost). Met de twee
	-- 12.1-delves erbij stak The Ring of Glory buiten het kader — Rob zag het meteen.
	-- Hoogte volgt nu de lijst, zodat de veertiende delve dit niet opnieuw doet.
	local n = #(ns.DELVE_TIP_ENTRIES or {})
	f:SetHeight(36 + (n * 28) + 16)

	local content = f._content
	local listW = math.max(200, (f:GetWidth() or 280) - 24)
	local btnW = math.min(248, listW - 16)

	local y = -4
	local entries = ns.DELVE_TIP_ENTRIES or {}
	for i, entry in ipairs(entries) do
		local btn = f._buttons[i]
		if not btn then
			btn = CreateFrame("Button", nil, content, "UIPanelButtonTemplate")
			btn:SetHeight(24)
			f._buttons[i] = btn
		end
		btn:Show()
		btn:EnableMouse(true)
		btn:SetWidth(btnW)
		btn:SetText((ns.GetDelveTipDisplayName and ns:GetDelveTipDisplayName(entry)) or entry.rosterName or entry.id)
		btn:ClearAllPoints()
		btn:SetPoint("TOP", content, "TOP", 0, y)
		y = y - 28
		local entryId = entry.id
		btn:SetScript("OnClick", function()
			local shown, reason = ns:ShowDelveCoach(entryId, { preview = true })
			if shown then
				f:Hide()
			elseif reason == "disabled" then
				print(("|cffffcc00%s|r %s"):format(ns:L("PRINT_PREFIX"), ns:L("DELVE_COACH_PREVIEW_DISABLED")))
			end
		end)
	end
	for j = #entries + 1, #(f._buttons or {}) do
		if f._buttons[j] then
			f._buttons[j]:Hide()
		end
	end
	content:SetHeight(math.max(40, (#entries * 28) + 8))

	f:ClearAllPoints()
	f:SetPoint("CENTER", UIParent, "CENTER", 0, 40)
	BringCoachFrameToFront(f)
	f:Show()
end

--------------------------------------------------------------------------------
-- "Eindbaas — open coach?" prompt (Rob 21 jun): als je de coach in een delve hebt
-- weggeklikt en er begint een boss-encounter, een klein knopje tonen om 'm alsnog
-- voor de baas te openen. Respecteert je close voor de trash; verschijnt alleen
-- als de coach echt door jou gedismissed is.
--------------------------------------------------------------------------------
local bossPrompt

local function HideBossCoachPrompt()
	if bossPrompt then
		bossPrompt:Hide()
	end
end

-- Toon de "open coach?"-prompt-knop (tenzij de coach al open is). Gedeeld door de
-- ENCOUNTER_START- en de target-trigger.
local function ShowBossPromptButton()
	if coachFrame and coachFrame:IsShown() then
		return -- coach al open → geen prompt nodig
	end
	if not bossPrompt then
		local b = CreateFrame("Button", nil, UIParent, "UIPanelButtonTemplate")
		b:SetSize(230, 26)
		b:SetPoint("TOP", UIParent, "TOP", 0, -170)
		b:SetFrameStrata("HIGH")
		b:SetScript("OnClick", function()
			local entry = ResolveActiveDelveEntry()
			if entry and ns.ShowDelveCoach then
				ns:ShowDelveCoach(entry.id, { preview = false })
			end
			HideBossCoachPrompt()
		end)
		bossPrompt = b
	end
	bossPrompt:SetText(ns:SafeL("DELVE_COACH_BOSS_PROMPT"))
	bossPrompt:Show()
end

-- Boss-prompt trigger (herzien 9 jul, na research). De oude "eerste vijandige target"-gok
-- vuurde op trash/critters en verbruikte het 1x-budget voor de echte eindbaas. Delve-bazen
-- zijn niet betrouwbaar van trash te scheiden (elite-classificatie, secret GUID/npcID in 12.x),
-- dus gebruiken we het SCENARIO: een delve is een scenario en de LAATSTE stage is de baaskamer.
-- currentStage == numStages (pre-pull) is de betrouwbare trigger; ENCOUNTER_START bevestigt bij
-- de pull. Bron: warcraft.wiki C_ScenarioInfo.GetScenarioInfo + LittleWigs/RitualBossCoach.
local finalStagePromptShown = false -- prompt max. 1x/delve; reset bij zone-entry
local function IsInFinalDelveStage()
	if not (C_ScenarioInfo and C_ScenarioInfo.GetScenarioInfo) then
		return false
	end
	local ok, info = pcall(C_ScenarioInfo.GetScenarioInfo)
	if not ok or type(info) ~= "table" then
		return false
	end
	local cur, num = info.currentStage, info.numStages
	-- numStages > 1 zodat een single-stage-delve niet meteen bij binnenkomst triggert
	-- (die valt terug op ENCOUNTER_START).
	return type(cur) == "number" and type(num) == "number" and num > 1 and cur == num
end

local function MaybeShowBossPromptForFinalStage()
	local s = GetSettings()
	if not s or not s.enabled or not s.autoShow then
		return
	end
	local inDelve = (ns.IsDelveInstanceInProgress and ns:IsDelveInstanceInProgress()) or IsDelveInProgress()
	if not inDelve or finalStagePromptShown then
		return
	end
	if not IsInFinalDelveStage() then
		return
	end
	finalStagePromptShown = true
	ShowBossPromptButton() -- verbergt zichzelf als de coach al open is
end

-- ENCOUNTER_START: prompt als je de coach zelf had weggeklikt.
local function MaybeShowBossCoachPrompt()
	local s = GetSettings()
	if not s or not s.enabled or not s.autoShow then
		return
	end
	local inDelve = (ns.IsDelveInstanceInProgress and ns:IsDelveInstanceInProgress()) or IsDelveInProgress()
	if not inDelve then
		return
	end
	if not (coachFrame and coachFrame._userDismissed) then
		return -- coach niet door speler weggeklikt → niets te heropenen
	end
	ShowBossPromptButton()
end

-- Target-reopen (Rob 5 jul): in een Delve een VIJANDELIJK doelwit hebben toont de "open coach?"-
-- prompt (als de coach dicht is) — spiegel van het dungeon-boss-venster. Bewust NIET op "is dit
-- een baas?" gefilterd: Delve-bazen hebben een echt level en zijn vaak als "elite" geclassificeerd
-- (net als trash), en hun GUID/npcID kan in 12.x secret zijn — dus dat is niet betrouwbaar te
-- bepalen. De coach is toch delve-breed; het prompt-knopje is passief (verschijnt één keer).
local targetPromptShownThisZone = false -- prompt max. 1x/delve; reset bij zone-entry
local function MaybeShowBossPromptOnTarget() -- DEPRECATED 9 jul: vervangen door MaybeShowBossPromptForFinalStage; niet meer aangeroepen
	do return end
	local s = GetSettings()
	if not s or not s.enabled or not s.autoShow then
		return
	end
	local inDelve = (ns.IsDelveInstanceInProgress and ns:IsDelveInstanceInProgress()) or IsDelveInProgress()
	if not inDelve or not UnitExists("target") then
		return
	end
	if InCombatLockdown() then
		return -- alleen pre-pull; in gevecht niet aanbieden (PLAYER_REGEN_DISABLED verbergt 'm)
	end
	-- (Bewust GÉÉN _userDismissed-blokkade: heb je de coach weggeklikt en target je de baas
	--  opnieuw buiten combat, dan mag de prompt terugkomen — vooral aan het begin van de delve.
	--  Het pre-pull-only + combat-verbergen + critter-filter houden het al netjes tegen naggen.)
	-- Alleen bij een ACTIEF vijandig (rood) doelwit. UnitCanAttack is te ruim: een
	-- neutrale (gele) quest-NPC is óók "aanvalbaar", waardoor het aannemen van een
	-- quest in een delve (bv. Grudge Pit) de baas-prompt onterecht triggerde.
	if UnitIsEnemy then
		if not UnitIsEnemy("player", "target") then
			return -- neutrale/vriendelijke NPC (quest-gever) → geen baas
		end
	elseif UnitCanAttack and not UnitCanAttack("player", "target") then
		return
	end
	if UnitIsTrivial and UnitIsTrivial("target") then
		return -- triviaal (veel lager level: ambient critters/motjes) → geen prompt
	end
	-- Een baas is in 12.x niet betrouwbaar van trash te onderscheiden (secret
	-- GUID/npcID), dus bieden we de coach hooguit ÉÉN keer per delve aan (bij het
	-- eerste vijandige doelwit) i.p.v. bij elke random vijand die je aanklikt.
	if targetPromptShownThisZone then
		return
	end
	targetPromptShownThisZone = true
	ShowBossPromptButton()
end

local function OnDelveStateTick()
	local inDelve = ns.IsDelveInstanceInProgress and ns:IsDelveInstanceInProgress() or IsDelveInProgress()
	if inDelve and not wasInDelve then
		if coachFrame then
			coachFrame._userDismissed = false
		end
		if ns.ClearDelveItemsAutoShowSuppress then
			ns:ClearDelveItemsAutoShowSuppress()
		end
		if ns.ScheduleDelveItemsAutoShowRetries then
			ns:ScheduleDelveItemsAutoShowRetries()
		elseif ns.MaybeAutoShowDelveItemsPopup then
			ns:MaybeAutoShowDelveItemsPopup()
		end
		local entry = ResolveActiveDelveEntry()
		if not entry and ns.GetActiveDelveTipEntryForPlayer then
			entry = ns:GetActiveDelveTipEntryForPlayer()
		end
		if entry and entry.id and ns.RefreshDelveStorySnapshot then
			if ns.PrimeDelveStoryPoiCache then
				ns.PrimeDelveStoryPoiCache(entry.id)
			end
			ns.RefreshDelveStorySnapshot(entry.id)
			if C_Timer and C_Timer.After then
				local entryId = entry.id
				C_Timer.After(0.5, function()
					if ns.RefreshDelveStorySnapshot then
						ns.RefreshDelveStorySnapshot(entryId)
					end
					if coachFrame and coachFrame.IsShown and coachFrame:IsShown() and currentEntryId == entryId and not coachFrame._previewMode and not coachFrame._bossManualOverride then
						local e = ns.GetDelveTipEntryById and ns.GetDelveTipEntryById(entryId)
						if e then
							UpdateBossShowcase(coachFrame, entryId)
							RefreshCoachBody(coachFrame, e, true)
						end
					end
				end)
				C_Timer.After(2, function()
					if ns.RefreshDelveStorySnapshot then
						ns.RefreshDelveStorySnapshot(entryId)
					end
					if coachFrame and coachFrame.IsShown and coachFrame:IsShown() and currentEntryId == entryId and not coachFrame._previewMode and not coachFrame._bossManualOverride then
						local e = ns.GetDelveTipEntryById and ns.GetDelveTipEntryById(entryId)
						if e then
							UpdateBossShowcase(coachFrame, entryId)
							RefreshCoachBody(coachFrame, e, true)
						end
					end
				end)
				-- Some delves only expose story/boss signals after a few objectives.
				for _, delay in ipairs({ 5, 10 }) do
					C_Timer.After(delay, function()
						if ns.RefreshDelveStorySnapshot then
							ns.RefreshDelveStorySnapshot(entryId)
						end
						if coachFrame and coachFrame.IsShown and coachFrame:IsShown() and currentEntryId == entryId and not coachFrame._previewMode and not coachFrame._bossManualOverride then
							local e = ns.GetDelveTipEntryById and ns.GetDelveTipEntryById(entryId)
							if e then
								UpdateBossShowcase(coachFrame, entryId)
								RefreshCoachBody(coachFrame, e, true)
							end
						end
					end)
				end
			end
		end
	end
	if not inDelve and wasInDelve then
		ns:HideDelveCoach(false)
		currentEntryId = nil
		if ns.ClearDelveStoryPoiCache then
			ns.ClearDelveStoryPoiCache()
		end
		if coachFrame then
			coachFrame._previewMode = false
			-- Allow next delve entry to reset manual boss selection.
			coachFrame._bossWasInDelve = false
		end
		if ns.HideDelveItemsUiLeavingDelve then
			ns:HideDelveItemsUiLeavingDelve()
		elseif ns.HideDelveItemsPopup then
			ns:HideDelveItemsPopup()
			if ns.RefreshDelveItemBrokers then
				ns:RefreshDelveItemBrokers()
			end
		end
	end
	if inDelve and not wasInDelve then
		if ns.RefreshDelveItemBrokers then
			ns:RefreshDelveItemBrokers()
		end
	end
	wasInDelve = inDelve

	local s = GetSettings()
	if not s.enabled or not s.autoShow then
		return
	end
	if not inDelve then
		return
	end
	MaybeShowBossPromptForFinalStage() -- pre-pull baaskamer-prompt (safety-net naast SCENARIO_UPDATE)
	if coachFrame and coachFrame._mhOpenFailUntil then
		local now = GetTime and GetTime() or 0
		if now < coachFrame._mhOpenFailUntil then
			return
		end
		coachFrame._mhOpenFailUntil = nil
	end
	if coachFrame and coachFrame._userDismissed and not coachFrame._previewMode then
		return
	end

	local entry = ResolveActiveDelveEntry()
	if entry then
		local needOpen = currentEntryId ~= entry.id or not (coachFrame and coachFrame:IsShown())
		if needOpen then
			local ok = ns:ShowDelveCoach(entry.id, { preview = false })
			if not ok and coachFrame then
				coachFrame._mhOpenFailUntil = (GetTime and GetTime() or 0) + 8
			end
		end
	elseif coachFrame and coachFrame._mhOpenFailUntil then
		coachFrame._mhOpenFailUntil = nil
	end
end

local ev = CreateFrame("Frame", nil, UIParent)
ev:RegisterEvent("PLAYER_ENTERING_WORLD")
ev:RegisterEvent("ZONE_CHANGED")
ev:RegisterEvent("ZONE_CHANGED_INDOORS")
ev:RegisterEvent("ZONE_CHANGED_NEW_AREA")
ev:RegisterEvent("SCENARIO_UPDATE")
ev:RegisterEvent("SCENARIO_CRITERIA_UPDATE")
ev:RegisterEvent("UNIT_TARGET")
ev:RegisterEvent("PLAYER_TARGET_CHANGED") -- Delve-baas targeten → "open coach?"-prompt (Rob 5 jul)
ev:RegisterEvent("PLAYER_REGEN_DISABLED") -- combat-start → pre-pull-prompt verbergen (Rob 5 jul)
ev:RegisterEvent("ENCOUNTER_START")
ev:RegisterEvent("ENCOUNTER_END")
local function PrimeDelveStoriesIfIdle()
	if ns.IsDelveInstanceInProgress and ns.IsDelveInstanceInProgress() then
		return
	end
	if ns.PrimeAllDelveStoryPoiCaches then
		ns.PrimeAllDelveStoryPoiCaches()
	end
end
ev:SetScript("OnEvent", function(_, event, unit)
	if event == "PLAYER_REGEN_DISABLED" then
		HideBossCoachPrompt() -- in gevecht: pre-pull-prompt weg
		return
	elseif event == "ENCOUNTER_START" then
		MaybeShowBossCoachPrompt() -- boss begint → "open coach?" als je 'm wegklikte
		return
	elseif event == "ENCOUNTER_END" then
		HideBossCoachPrompt()
		return
	end
	if event == "PLAYER_ENTERING_WORLD" or event == "ZONE_CHANGED" or event == "ZONE_CHANGED_NEW_AREA" then
		if event ~= "ZONE_CHANGED" then
			targetPromptShownThisZone = false
			finalStagePromptShown = false -- nieuwe zone/delve → coach mag weer 1x aangeboden
		end
		HideBossCoachPrompt() -- bij zone-wissel/verlaten weg
		if C_Timer and C_Timer.After then
			C_Timer.After(1, PrimeDelveStoriesIfIdle)
		else
			PrimeDelveStoriesIfIdle()
		end
	end
	OnDelveStateTick()
	if event == "SCENARIO_UPDATE" or event == "SCENARIO_CRITERIA_UPDATE" then
		RefreshDelveCoachLiveContent()
		MaybeShowBossPromptForFinalStage() -- laatste scenario-stage = baaskamer
	elseif event == "UNIT_TARGET" and (not unit or unit == "player") then
		RefreshDelveCoachLiveContent()
	elseif event == "PLAYER_TARGET_CHANGED" then
		RefreshDelveCoachLiveContent()
	end
end)
ev:SetScript("OnUpdate", function(self, elapsed)
	-- Avoid a permanent 1s tick when the coach is disabled/hidden.
	local u = ns.db and ns.db.ui and ns.db.ui.delveCoach
	local enabled = u and u.enabled ~= false
	local autoShow = u and u.autoShow ~= false
	if (not enabled) or (not autoShow) then
		return
	end
	-- Also skip ticking unless we are in a delve (or the coach is open in preview).
	local inDelve = ns.IsDelveInstanceInProgress and ns:IsDelveInstanceInProgress() or IsDelveInProgress()
	local previewOpen = coachFrame and coachFrame._previewMode and coachFrame:IsShown()
	if (not inDelve) and (not previewOpen) then
		return
	end
	self._elapsed = (self._elapsed or 0) + elapsed
	if self._elapsed >= 1.0 then
		self._elapsed = 0
		OnDelveStateTick()
	end
end)

do
	local orig = ns.RefreshLocaleUI
	function ns:RefreshLocaleUI()
		if orig then
			orig(self)
		end
		if self.RefreshDelveCoachLocale then
			self:RefreshDelveCoachLocale()
		end
	end
end
