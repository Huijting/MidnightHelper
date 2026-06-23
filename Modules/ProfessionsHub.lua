--[[
	Professions Hub — one Toolbox sub-tab bundling all profession tools
	behind inner tabs: Overview (dashboard) | Treasures & Books
	(Profession.lua) | Course (ProfessionAcademy.lua).

	The treasures inner frame registers under the LEGACY panel id
	(ns.panels.professions) so Profession.lua's EnsureMainUI hook builds into
	it unchanged. The course frame is handed to BuildProfessionAcademyPanel
	directly. SelectTab("professions"/"profacademy") routes here via the
	alias in UI.lua (search, ProfessionsGuide button, saved tabs).
]]

local _, ns = ...

local NAV_H = 34
local BTN_W = 130
local BTN_H = 24

local TAB_TEX_ACTIVE = { 0.98, 0.94, 0.82 }
local TAB_TEX_INACTIVE = { 0.78, 0.72, 0.62 }
local SEP_COLOR = { 0.78, 0.62, 0.32, 0.55 }

local hub

local function SL(key)
	if ns.SafeL then
		return ns:SafeL(key)
	end
	return ns:L(key)
end

local INNER_DEFS = {
	{ id = "overview", labelKey = "PROFHUB_TAB_OVERVIEW" },
	{ id = "treasures", labelKey = "PROFHUB_TAB_TREASURES" },
	{ id = "course", labelKey = "PROFHUB_TAB_COURSE" },
}

local function TintButtonTextures(btn, r, g, b)
	if not btn or not btn.GetRegions then
		return
	end
	for _, region in ipairs({ btn:GetRegions() }) do
		if region.GetObjectType and region:IsObjectType("Texture") and region.SetVertexColor then
			region:SetVertexColor(r, g, b)
		end
	end
end

local function RefreshChrome()
	if not hub then
		return
	end
	local active = ns.uiSelectedProfHubInner or "overview"
	for id, btn in pairs(hub._phButtons) do
		if id == active then
			btn:SetAlpha(1)
			TintButtonTextures(btn, TAB_TEX_ACTIVE[1], TAB_TEX_ACTIVE[2], TAB_TEX_ACTIVE[3])
		else
			btn:SetAlpha(0.88)
			TintButtonTextures(btn, TAB_TEX_INACTIVE[1], TAB_TEX_INACTIVE[2], TAB_TEX_INACTIVE[3])
		end
	end
end

local ICON_DONE = "|TInterface\\RaidFrame\\ReadyCheck-Ready:12:12:0:0|t"
local ICON_OPEN = "|TInterface\\RaidFrame\\ReadyCheck-Waiting:12:12:0:0|t"

--- Weekly KP block (concept B): only rows with in-game verified IDs show —
--- trainer weeklies via quest flag, Enchanting disenchant mats via bag count.
local function BuildWeeklyText()
	local d = ns.PROF_ACADEMY
	local weekly = d and d.weekly
	if not weekly or type(GetProfessions) ~= "function" then
		return ""
	end
	local lines = {}
	local p1, p2 = GetProfessions()
	for _, prof in next, { p1, p2 } do
		local name, _, _, _, _, _, skillLine = GetProfessionInfo(prof)
		if name and skillLine then
			local questIDs = weekly.trainerQuests and weekly.trainerQuests[skillLine]
			if type(questIDs) == "number" then
				questIDs = { questIDs } -- backward compat with the old single-ID form
			end
			if questIDs and #questIDs > 0 then
				-- Some professions rotate between weekly variants — one flagged
				-- ID means this week's variant is done ("any" semantics).
				local isDone = false
				for _, qid in ipairs(questIDs) do
					local okFlag, done = pcall(C_QuestLog.IsQuestFlaggedCompleted, qid)
					if okFlag and done then
						isDone = true
						break
					end
				end
				local icon = isDone and ICON_DONE or ICON_OPEN
				local line = ("%s %s: %s"):format(icon, name, SL("PROFHUB_WEEKLY_TRAINER"))
				if not isDone then
					-- Leek-hint: why isn't the trainer offering it yet?
					line = line .. " |cff8a8f98" .. SL("PROFHUB_WEEKLY_TRAINER_REQ") .. "|r"
				end
				lines[#lines + 1] = line
			end
			if skillLine == 333 and weekly.enchantingEssences then
				local parts = {}
				for _, e in ipairs(weekly.enchantingEssences) do
					local count = 0
					if C_Item and C_Item.GetItemCount then
						local okC, c = pcall(C_Item.GetItemCount, e.itemID)
						count = okC and tonumber(c) or 0
					end
					local itemName = (C_Item and C_Item.GetItemInfo and C_Item.GetItemInfo(e.itemID))
						or e.fallbackName
					parts[#parts + 1] = ("%s %d/%d"):format(itemName, count, e.need)
				end
				lines[#lines + 1] = ("%s: %s"):format(SL("PROFHUB_WEEKLY_ESSENCES"), table.concat(parts, " · "))
			end
		end
	end
	if #lines == 0 then
		return ""
	end
	return "\n\n|cffffd966" .. SL("PROFHUB_WEEKLY_HEADER") .. "|r\n" .. table.concat(lines, "\n")
end

local GOAL_DEFS = {
	{ id = "allround", labelKey = "PROFHUB_GOAL_ALLROUND", ttKey = "PROFHUB_GOAL_TT_ALLROUND" },
	{ id = "gold", labelKey = "PROFHUB_GOAL_GOLD", ttKey = "PROFHUB_GOAL_TT_GOLD" },
	{ id = "self", labelKey = "PROFHUB_GOAL_SELF", ttKey = "PROFHUB_GOAL_TT_SELF" },
}

local function RefreshGoalChrome()
	if not (hub and hub._phGoalButtons) then
		return
	end
	local active = (ns.MH_GetProfAdvisorGoal and ns.MH_GetProfAdvisorGoal()) or "allround"
	for id, btn in pairs(hub._phGoalButtons) do
		if id == active then
			btn:SetAlpha(1)
			TintButtonTextures(btn, TAB_TEX_ACTIVE[1], TAB_TEX_ACTIVE[2], TAB_TEX_ACTIVE[3])
		else
			btn:SetAlpha(0.85)
			TintButtonTextures(btn, TAB_TEX_INACTIVE[1], TAB_TEX_INACTIVE[2], TAB_TEX_INACTIVE[3])
		end
	end
end

--- Accessory hint: profession gear slots 21/22 (prof 1) and 24/25 (prof 2).
--- Accessories are optional for starters — the gearup chapter only requires
--- a tool — so this is a gray tip, never a requirement. Wrong slot numbers
--- fail harmless (hint shows; equipping one is the live verification).
local function BuildAccessoryHint()
	if type(GetProfessions) ~= "function" or type(GetInventoryItemID) ~= "function" then
		return ""
	end
	local p1, p2 = GetProfessions()
	local empty = 0
	if p1 then
		for _, slot in next, { 21, 22 } do
			if not GetInventoryItemID("player", slot) then
				empty = empty + 1
			end
		end
	end
	if p2 then
		for _, slot in next, { 24, 25 } do
			if not GetInventoryItemID("player", slot) then
				empty = empty + 1
			end
		end
	end
	if empty == 0 then
		return ""
	end
	return "\n\n|cff8a8f98" .. SL("PROFHUB_ACCESSORY_HINT_FMT"):format(empty) .. "|r"
end

local function RefreshOverview()
	if not (hub and hub._phOverview and hub._phOverview:IsShown()) then
		return
	end
	if hub._phOverviewHeader then
		hub._phOverviewHeader:SetText(SL("TAB_PROFESSIONS"))
	end
	if hub._phGoalLabel then
		hub._phGoalLabel:SetText(SL("PROFHUB_GOAL_LABEL"))
	end
	if hub._phGoalButtons then
		for _, def in ipairs(GOAL_DEFS) do
			local btn = hub._phGoalButtons[def.id]
			if btn then
				btn:SetText(SL(def.labelKey))
			end
		end
		RefreshGoalChrome()
	end
	if hub._phOverviewText then
		local text = ns.MH_GetProfessionsOverviewText and ns.MH_GetProfessionsOverviewText() or ""
		hub._phOverviewText:SetText(text .. BuildWeeklyText() .. BuildAccessoryHint())
	end
	if hub._phOverviewHint then
		hub._phOverviewHint:SetText(SL("PROFHUB_OVERVIEW_HINT"))
	end
end

function ns.MH_SelectProfessionsInnerTab(which)
	local valid = false
	for _, d in ipairs(INNER_DEFS) do
		if d.id == which then
			valid = true
			break
		end
	end
	if not valid then
		which = "overview"
	end
	ns.uiSelectedProfHubInner = which
	if not hub then
		return
	end
	for id, frame in pairs(hub._phFrames) do
		frame:SetShown(id == which)
	end
	RefreshChrome()
	if which == "overview" then
		RefreshOverview()
	end
	-- Help drawer text follows the active inner tab.
	if ns._mhRefreshSidePanel and ns.uiSelectedTab == "toolbox" then
		ns:_mhRefreshSidePanel("toolbox")
	end
end

function ns.BuildProfessionsHubPanel(panel)
	if not panel or panel._phBuilt then
		return
	end
	panel._phBuilt = true
	hub = panel

	if panel._body then
		panel._body:Hide()
	end
	if panel._header then
		panel._header:Hide()
	end

	local nav = CreateFrame("Frame", nil, panel)
	nav:SetHeight(NAV_H)
	nav:SetPoint("TOPLEFT", panel, "TOPLEFT", 0, -2)
	nav:SetPoint("TOPRIGHT", panel, "TOPRIGHT", -12, -2)

	panel._phButtons = {}
	local x = 0
	for _, def in ipairs(INNER_DEFS) do
		local btn = CreateFrame("Button", "MidnightHelperProfHubTab_" .. def.id, nav, "UIPanelButtonTemplate")
		btn:SetSize(BTN_W, BTN_H)
		btn:SetPoint("TOPLEFT", nav, "TOPLEFT", x, -4)
		btn:SetText(SL(def.labelKey))
		local id = def.id
		btn:SetScript("OnClick", function()
			ns.MH_SelectProfessionsInnerTab(id)
		end)
		panel._phButtons[def.id] = btn
		x = x + BTN_W + 6
	end

	local sep = panel:CreateTexture(nil, "ARTWORK")
	sep:SetHeight(1)
	sep:SetPoint("TOPLEFT", nav, "BOTTOMLEFT", 0, -2)
	sep:SetPoint("TOPRIGHT", nav, "BOTTOMRIGHT", 0, -2)
	sep:SetColorTexture(SEP_COLOR[1], SEP_COLOR[2], SEP_COLOR[3], SEP_COLOR[4])

	panel._phFrames = {}
	local function MakeInner(id)
		local f = CreateFrame("Frame", nil, panel)
		f:SetPoint("TOPLEFT", sep, "BOTTOMLEFT", 0, -4)
		f:SetPoint("BOTTOMRIGHT", panel, "BOTTOMRIGHT", 0, 0)
		f:Hide()
		panel._phFrames[id] = f
		return f
	end

	-- Overview: profession dashboard (detection, KP, live tree advice).
	local overview = MakeInner("overview")
	panel._phOverview = overview
	local oh = overview:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
	oh:SetPoint("TOPLEFT", overview, "TOPLEFT", 12, -10)
	oh:SetJustifyH("LEFT")
	panel._phOverviewHeader = oh

	-- Tree Advisor goal picker: changes which curated route the advice
	-- lines follow (per character; Allround = the v1 default routes).
	local goalLabel = overview:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	goalLabel:SetPoint("TOPLEFT", oh, "BOTTOMLEFT", 0, -8)
	goalLabel:SetJustifyH("LEFT")
	goalLabel:SetTextColor(0.78, 0.74, 0.68)
	panel._phGoalLabel = goalLabel

	panel._phGoalButtons = {}
	local prevBtn
	for _, def in ipairs(GOAL_DEFS) do
		local btn = CreateFrame("Button", "MidnightHelperProfGoal_" .. def.id, overview, "UIPanelButtonTemplate")
		btn:SetSize(110, 20)
		if prevBtn then
			btn:SetPoint("LEFT", prevBtn, "RIGHT", 4, 0)
		else
			btn:SetPoint("LEFT", goalLabel, "RIGHT", 8, 0)
		end
		local id = def.id
		btn:SetScript("OnClick", function()
			if ns.MH_SetProfAdvisorGoal then
				ns.MH_SetProfAdvisorGoal(id)
			end
			RefreshOverview()
		end)
		-- What does this goal actually choose, and why?
		local labelKey, ttKey = def.labelKey, def.ttKey
		btn:SetScript("OnEnter", function(self)
			if not GameTooltip then
				return
			end
			GameTooltip:SetOwner(self, "ANCHOR_TOP")
			GameTooltip:SetText(SL(labelKey), 1, 0.88, 0.45)
			GameTooltip:AddLine(SL(ttKey), 0.85, 0.85, 0.85, true)
			GameTooltip:Show()
		end)
		btn:SetScript("OnLeave", function()
			if GameTooltip then
				GameTooltip:Hide()
			end
		end)
		panel._phGoalButtons[def.id] = btn
		prevBtn = btn
	end

	local ot = overview:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	ot:SetFontObject(ns.MHScalableFont("GameFontHighlightSmall"))
	ot:SetPoint("TOPLEFT", goalLabel, "BOTTOMLEFT", 0, -10)
	ot:SetPoint("RIGHT", overview, "RIGHT", -16, 0)
	ot:SetJustifyH("LEFT")
	ot:SetWordWrap(true)
	ot:SetSpacing(3)
	panel._phOverviewText = ot
	local hint = overview:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
	hint:SetPoint("BOTTOMLEFT", overview, "BOTTOMLEFT", 12, 12)
	hint:SetPoint("RIGHT", overview, "RIGHT", -16, 0)
	hint:SetJustifyH("LEFT")
	hint:SetWordWrap(true)
	panel._phOverviewHint = hint

	-- Treasures & Books: Profession.lua finds ns.panels.professions via its
	-- EnsureMainUI hook (runs after the main UI build) and builds into it.
	local treasures = MakeInner("treasures")
	treasures._header = treasures:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
	treasures._header:SetPoint("TOPLEFT", treasures, "TOPLEFT", 12, -10)
	ns.panels = ns.panels or {}
	ns.panels.professions = treasures

	-- Course: Professions 101 builds directly into its inner frame.
	local course = MakeInner("course")
	course._header = course:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
	course._header:SetPoint("TOPLEFT", course, "TOPLEFT", 12, -10)
	course._header:SetJustifyH("LEFT")
	if ns.BuildProfessionAcademyPanel then
		ns.BuildProfessionAcademyPanel(course)
	end

	-- Live overview refresh (profession learned/dropped, KP committed,
	-- weekly turned in, essences looted). Quest/bag events fire in bursts —
	-- coalesce to one refresh per 0.3s (timer-handle pattern).
	local pendingTimer
	local ev = CreateFrame("Frame", nil, panel)
	ev:RegisterEvent("SKILL_LINES_CHANGED")
	ev:RegisterEvent("TRAIT_CONFIG_UPDATED")
	ev:RegisterEvent("TRADE_SKILL_SHOW")
	ev:RegisterEvent("QUEST_LOG_UPDATE")
	ev:RegisterEvent("BAG_UPDATE")
	ev:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")
	ev:SetScript("OnEvent", function()
		if not (hub and hub._phOverview and hub._phOverview:IsShown()) then
			return
		end
		if pendingTimer then
			return
		end
		pendingTimer = C_Timer.NewTimer(0.3, function()
			pendingTimer = nil
			RefreshOverview()
		end)
	end)

	panel:SetScript("OnShow", function()
		ns.MH_SelectProfessionsInnerTab(ns.uiSelectedProfHubInner or "overview")
	end)

	do
		local orig = ns.RefreshLocaleUI
		function ns:RefreshLocaleUI()
			if orig then
				orig(self)
			end
			if hub and hub._phBuilt then
				for _, def in ipairs(INNER_DEFS) do
					local btn = hub._phButtons[def.id]
					if btn then
						btn:SetText(SL(def.labelKey))
					end
				end
				RefreshOverview()
			end
		end
	end

	ns.MH_SelectProfessionsInnerTab(ns.uiSelectedProfHubInner or "overview")
end
