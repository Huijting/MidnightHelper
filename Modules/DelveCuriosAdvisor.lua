--[[
	Midnight Helper — Valeera curio advisor (Delves tab panel + popup at repair / gossip).
]]

local addonName, ns = ...

local C_Timer = C_Timer
local C_GossipInfo = C_GossipInfo

local ROLE_ORDER = ns.DELVE_CURIO_ROLES or { "dps", "heal", "tank" }
local ROLE_ATLASES = ns.DELVE_CURIO_ROLE_ATLASES or {}
local ROLE_LABEL_KEYS = ns.DELVE_CURIO_ROLE_LABEL_KEYS or {}

local ROLE_ROW_H = 30
local ROLE_ICON = 22
local ITEM_ICON = 20
local PANEL_PAD = 4
local PANEL_HEADER_H = 16
local PANEL_FOOTER_H = 0

local embeddedPanel
local popupFrame
local eventFrame
local popupAutoSuppressed = false
local popupShownByGossip = false
local curioItemRefreshPending = false

local COMBAT_R, COMBAT_G, COMBAT_B = 1, 0.82, 0
local UTIL_R, UTIL_G, UTIL_B = 0.35, 0.92, 1

local function TrySetAtlas(tex, candidates)
	if not tex or not tex.SetAtlas or type(candidates) ~= "table" then
		return false
	end
	for _, name in ipairs(candidates) do
		pcall(tex.SetAtlas, tex, nil)
		local ok = select(1, pcall(tex.SetAtlas, tex, name))
		local tid = tex.GetTexture and tex:GetTexture()
		if ok and tid and tid ~= 0 then
			return true
		end
	end
	return false
end

local function GetPopupSettings()
	local ui = ns.db and ns.db.ui
	if type(ui) ~= "table" then
		return nil
	end
	if type(ui.delveCuriosPopup) ~= "table" then
		ui.delveCuriosPopup = {
			enabled = true,
			autoShowAtValeera = true,
			point = "CENTER",
			relPoint = "CENTER",
			x = 0,
			y = 40,
			userPositioned = false,
		}
	end
	return ui.delveCuriosPopup
end

local function IsDelveCurioUiAllowed()
	return ns.IsPlayerInActiveDelve and ns.IsPlayerInActiveDelve()
end

local function IsSecretValue(value)
	return issecretvalue ~= nil and value ~= nil and issecretvalue(value) == true
end

--- String ops on gossip/NPC text fail on 12.x secret values; never compare those directly.
local function SafeTextContains(text, needle)
	if text == nil or text == "" or needle == nil or needle == "" then
		return false
	end
	if IsSecretValue(text) then
		return false
	end
	if canaccessvalue and not canaccessvalue(text) then
		return false
	end
	local ok, found = pcall(function()
		return string.find(string.lower(text), needle, 1, true) ~= nil
	end)
	return ok and found == true
end

local GOSSIP_COMPANION_KEYWORDS = {
	"valeera",
	"curio",
	"companion",
	"supplies",
	"supply",
	"delver",
	"explorer",
	"repair",
	"league",
}

local function GossipMentionsDelveCompanion(text)
	if text == nil or text == "" or IsSecretValue(text) then
		return false
	end
	for i = 1, #GOSSIP_COMPANION_KEYWORDS do
		if SafeTextContains(text, GOSSIP_COMPANION_KEYWORDS[i]) then
			return true
		end
	end
	return false
end

local function IsValeeraUnit(unit)
	if not unit or not UnitExists(unit) then
		return false
	end
	local ok, name = pcall(UnitName, unit)
	if not ok or not name or name == "" or IsSecretValue(name) then
		return false
	end
	return SafeTextContains(name, "valeera")
end

local function HasDelveCompanionGossipOptions()
	if not C_GossipInfo or not C_GossipInfo.GetOptions then
		return false
	end
	local ok, options = pcall(C_GossipInfo.GetOptions)
	return ok and type(options) == "table" and #options > 0
end

local function IsValeeraGossipContext()
	if not IsDelveCurioUiAllowed() then
		return false
	end
	if IsValeeraUnit("npc") or IsValeeraUnit("target") then
		return true
	end
	if C_GossipInfo and C_GossipInfo.GetText then
		local ok, text = pcall(C_GossipInfo.GetText)
		if ok and GossipMentionsDelveCompanion(text) then
			return true
		end
	end
	if C_GossipInfo and C_GossipInfo.GetOptions then
		local ok, options = pcall(C_GossipInfo.GetOptions)
		if ok and type(options) == "table" then
			for _, opt in ipairs(options) do
				local label = (opt and (opt.name or opt.text or opt.label)) or ""
				if GossipMentionsDelveCompanion(label) then
					return true
				end
			end
		end
	end
	-- In delves, NPC names and gossip strings are often secret — still show at repair/supplies NPCs.
	if UnitExists("npc") and HasDelveCompanionGossipOptions() then
		return true
	end
	return false
end

local function BuildRoleRows(host, isPopup)
	if host._roleRows then
		return host._roleRows
	end
	local rows = {}
	host._roleRows = rows
	for i, role in ipairs(ROLE_ORDER) do
		local row = CreateFrame("Frame", nil, host)
		row:SetHeight(ROLE_ROW_H)
		row.role = role

		local roleIcon = row:CreateTexture(nil, "ARTWORK")
		roleIcon:SetSize(ROLE_ICON, ROLE_ICON)
		roleIcon:SetPoint("TOPLEFT", row, "TOPLEFT", 0, -4)
		row.roleIcon = roleIcon

		local function makeCurioLine(kind, r, g, b, yOff)
			local line = CreateFrame("Button", nil, row)
			line:SetHeight(16)
			line:SetPoint("TOPLEFT", roleIcon, "TOPRIGHT", 8, yOff)
			line:SetPoint("RIGHT", row, "RIGHT", 0, 0)
			line:EnableMouse(true)

			local icon = line:CreateTexture(nil, "ARTWORK")
			icon:SetSize(ITEM_ICON, ITEM_ICON)
			icon:SetPoint("LEFT", line, "LEFT", 0, 0)
			line.itemIcon = icon

			local label = line:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
			label:SetPoint("LEFT", icon, "RIGHT", 4, 0)
			label:SetPoint("RIGHT", line, "RIGHT", -2, 0)
			label:SetJustifyH("LEFT")
			label:SetWordWrap(false)
			line.label = label
			line.kind = kind
			line.textR, line.textG, line.textB = r, g, b

			line:SetScript("OnEnter", function(self)
				local itemID = self.itemID
				if not itemID or not GameTooltip then
					return
				end
				GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
				local link = ns.GetDelveCurioItemLink and ns:GetDelveCurioItemLink(itemID)
				if link then
					GameTooltip:SetHyperlink(link)
				else
					GameTooltip:SetItemByID(itemID)
				end
				GameTooltip:Show()
			end)
			line:SetScript("OnLeave", function()
				if GameTooltip then
					GameTooltip:Hide()
				end
			end)

			return line
		end

		row.combatLine = makeCurioLine("combat", COMBAT_R, COMBAT_G, COMBAT_B, -2)
		row.utilityLine = makeCurioLine("utility", UTIL_R, UTIL_G, UTIL_B, -18)

		if isPopup then
			row:SetPoint("TOPLEFT", host, "TOPLEFT", 8, -((i - 1) * ROLE_ROW_H + 4))
			row:SetPoint("RIGHT", host, "RIGHT", -8, 0)
		else
			row:SetPoint("TOPLEFT", host, "TOPLEFT", PANEL_PAD, -((i - 1) * ROLE_ROW_H + 2))
			row:SetPoint("RIGHT", host, "RIGHT", -PANEL_PAD, 0)
		end

		rows[i] = row
	end
	return rows
end

local function RefreshRoleRows(host, season, variant)
	local rows = BuildRoleRows(host, host._isPopup)
	for _, row in ipairs(rows) do
		local role = row.role
		local pick = ns.GetDelveCurioPick and ns:GetDelveCurioPick(season, role, variant)
		if pick then
			TrySetAtlas(row.roleIcon, ROLE_ATLASES[role])
			local function paint(line, itemID, labelKey)
				line.itemID = itemID
				line.itemIcon:SetTexture(ns.GetDelveCurioItemIcon(itemID))
				local itemName = ns.GetDelveCurioItemName(itemID)
				line.label:SetText(ns:L(labelKey) .. " " .. itemName)
				line.label:SetTextColor(line.textR, line.textG, line.textB)
				line:Show()
			end
			paint(row.combatLine, pick.combat, "DELVE_CURIO_COMBAT")
			paint(row.utilityLine, pick.utility, "DELVE_CURIO_UTILITY")
			row:Show()
		else
			row:Hide()
		end
	end
end

local function NemesisFootnoteHeight(season)
	local pack = ns.GetDelveCurioSeasonTable and ns:GetDelveCurioSeasonTable(season)
	if pack and pack.nemesis and pack.nemesis.dps and pack.nemesis.dps.utility then
		return 30
	end
	return 0
end

local function PanelContentHeight(season)
	return PANEL_HEADER_H + (#ROLE_ORDER * ROLE_ROW_H) + NemesisFootnoteHeight(season) + PANEL_PAD
end

local function RefreshNemesisFootnote(panel, season)
	local foot = panel._nemesisFoot
	local body = panel._body
	if not foot or not body then
		return
	end
	local pack = ns.GetDelveCurioSeasonTable and ns:GetDelveCurioSeasonTable(season)
	local nem = pack and pack.nemesis and pack.nemesis.dps
	if nem and nem.utility then
		local utilName = ns.GetDelveCurioItemName(nem.utility)
		foot:SetText(string.format(ns:L("DELVE_CURIO_NEMESIS_NOTE"), utilName))
		foot:ClearAllPoints()
		foot:SetPoint("TOPLEFT", body, "BOTTOMLEFT", PANEL_PAD, -4)
		foot:SetPoint("RIGHT", panel, "RIGHT", -PANEL_PAD, 0)
		foot:Show()
	else
		foot:Hide()
	end
end

local function ShouldLoadCurioItemData()
	if popupFrame and popupFrame:IsShown() then
		return true
	end
	if embeddedPanel and embeddedPanel:IsShown() then
		return true
	end
	return false
end

local function ScheduleCurioAdvisorRefresh()
	if curioItemRefreshPending then
		return
	end
	curioItemRefreshPending = true
	if C_Timer and C_Timer.After then
		C_Timer.After(0.15, function()
			curioItemRefreshPending = false
			if ns.RefreshDelveCurioAdvisor then
				ns.RefreshDelveCurioAdvisor()
			end
		end)
	else
		curioItemRefreshPending = false
	end
end

function ns.RefreshDelveCurioAdvisor()
	local season = ns.GetDelvesSeasonNumber and ns:GetDelvesSeasonNumber() or 1
	if ShouldLoadCurioItemData() and ns.RequestDelveCurioItemData then
		ns.RequestDelveCurioItemData(season)
	end
	local variant = (ns.IsPlayerInNemesisDelve and ns:IsPlayerInNemesisDelve()) and "nemesis" or "default"

	if embeddedPanel then
		if embeddedPanel._title then
			embeddedPanel._title:SetText(string.format(ns:L("DELVE_CURIO_PANEL_TITLE"), season))
		end
		if embeddedPanel._body then
			embeddedPanel._body:SetHeight((#ROLE_ORDER * ROLE_ROW_H) + 4)
			RefreshRoleRows(embeddedPanel._body, season, "default")
		end
		RefreshNemesisFootnote(embeddedPanel, season)
		embeddedPanel:SetHeight(PanelContentHeight(season))
	end

	if popupFrame and popupFrame:IsShown() then
		if popupFrame._title then
			popupFrame._title:SetText(ns:L("DELVE_CURIO_POPUP_TITLE"))
		end
		if popupFrame._hint then
			popupFrame._hint:SetText(ns:L("DELVE_CURIO_POPUP_HINT"))
		end
		if popupFrame._body then
			popupFrame._body:SetHeight((#ROLE_ORDER * ROLE_ROW_H) + 4)
			RefreshRoleRows(popupFrame._body, season, variant)
		end
		local w = 340
		popupFrame:SetSize(w, 58 + (#ROLE_ORDER * ROLE_ROW_H) + NemesisFootnoteHeight(season))
	end
end

function ns.EnsureDelveCurioPanel(parent)
	if embeddedPanel then
		return embeddedPanel
	end
	if not parent then
		return nil
	end

	local panel = CreateFrame("Frame", nil, parent)
	panel:SetHeight(PanelContentHeight(ns.GetDelvesSeasonNumber and ns:GetDelvesSeasonNumber() or 1))

	local title = panel:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	title:SetPoint("TOPLEFT", panel, "TOPLEFT", PANEL_PAD, -2)
	title:SetPoint("RIGHT", panel, "RIGHT", -PANEL_PAD, 0)
	title:SetJustifyH("LEFT")
	title:SetTextColor(0.92, 0.88, 0.75)
	panel._title = title

	local body = CreateFrame("Frame", nil, panel)
	body:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -4)
	body:SetPoint("RIGHT", panel, "RIGHT", 0, 0)
	body._isPopup = false
	panel._body = body

	local foot = panel:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
	foot:SetJustifyH("LEFT")
	foot:SetWordWrap(true)
	foot:SetTextColor(0.72, 0.7, 0.65)
	panel._nemesisFoot = foot

	BuildRoleRows(body, false)
	embeddedPanel = panel
	ns.DelveCurioPanel = panel
	ns.RefreshDelveCurioAdvisor()
	return panel
end

local function ApplyPopupPoint(f)
	local s = GetPopupSettings()
	if not s or not s.userPositioned then
		f:ClearAllPoints()
		f:SetPoint("CENTER", UIParent, "CENTER", 0, 40)
		return
	end
	f:ClearAllPoints()
	f:SetPoint(s.point or "CENTER", UIParent, s.relPoint or "CENTER", tonumber(s.x) or 0, tonumber(s.y) or 40)
end

local function SavePopupPoint(f, userMoved)
	local s = GetPopupSettings()
	if not s then
		return
	end
	if userMoved then
		s.userPositioned = true
	end
	local point, _, relPoint, x, y = f:GetPoint(1)
	if point then
		s.point = point
		s.relPoint = relPoint or point
		s.x = x or s.x
		s.y = y or s.y
	end
end

local function EnsurePopup()
	if popupFrame then
		return popupFrame
	end

	local f = CreateFrame("Frame", "MidnightHelperDelveCuriosPopup", UIParent, "BackdropTemplate")
	f:SetSize(340, 200)
	f:SetFrameStrata("HIGH")
	f:SetFrameLevel(210)
	f:SetClampedToScreen(true)
	f:EnableMouse(false)
	f:SetMovable(true)
	if f.SetBackdrop then
		f:SetBackdrop({
			bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
			edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Gold-Border",
			tile = true,
			tileSize = 32,
			edgeSize = 32,
			insets = { left = 11, right = 12, top = 12, bottom = 11 },
		})
		f:SetBackdropColor(0.06, 0.06, 0.1, 0.94)
	end
	tinsert(UISpecialFrames, f:GetName())

	local titleBar = CreateFrame("Frame", nil, f)
	titleBar:SetHeight(22)
	titleBar:SetPoint("TOPLEFT", f, "TOPLEFT", 12, -10)
	titleBar:SetPoint("TOPRIGHT", f, "TOPRIGHT", -28, -10)
	titleBar:EnableMouse(true)
	titleBar:RegisterForDrag("LeftButton")
	titleBar:SetScript("OnDragStart", function()
		f:StartMoving()
	end)
	titleBar:SetScript("OnDragStop", function()
		f:StopMovingOrSizing()
		SavePopupPoint(f, true)
	end)

	local title = titleBar:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	title:SetPoint("CENTER", titleBar, "CENTER", -6, 0)
	title:SetTextColor(1, 0.9, 0.55)
	f._title = title

	local closeBtn = CreateFrame("Button", nil, f, "UIPanelCloseButton")
	closeBtn:SetPoint("TOPRIGHT", f, "TOPRIGHT", 2, 2)
	closeBtn:SetScript("OnClick", function()
		popupAutoSuppressed = true
		popupShownByGossip = false
		f:Hide()
	end)

	local hint = f:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	hint:SetPoint("TOP", titleBar, "BOTTOM", 0, -4)
	hint:SetPoint("LEFT", f, "LEFT", 14, 0)
	hint:SetPoint("RIGHT", f, "RIGHT", -14, 0)
	hint:SetJustifyH("CENTER")
	hint:SetWordWrap(true)
	hint:SetTextColor(0.82, 0.8, 0.74)
	f._hint = hint

	local body = CreateFrame("Frame", nil, f)
	body:SetPoint("TOP", hint, "BOTTOM", 0, -6)
	body:SetPoint("LEFT", f, "LEFT", 10, 0)
	body:SetPoint("RIGHT", f, "RIGHT", -10, 0)
	body._isPopup = true
	body._nemesisFoot = nil
	f._body = body

	BuildRoleRows(body, true)
	popupFrame = f
	ApplyPopupPoint(f)
	return f
end

function ns.ShowDelveCuriosPopup()
	local s = GetPopupSettings()
	if s and s.enabled == false then
		return
	end
	if not IsDelveCurioUiAllowed() then
		return
	end
	local f = EnsurePopup()
	f:Show()
	ns.RefreshDelveCurioAdvisor()
	ApplyPopupPoint(f)
end

function ns.HideDelveCuriosPopup()
	if popupFrame then
		popupFrame:Hide()
	end
	popupShownByGossip = false
end

function ns.MaybeAutoShowDelveCuriosPopup()
	if popupAutoSuppressed then
		return
	end
	local s = GetPopupSettings()
	if not s or s.enabled == false or s.autoShowAtValeera == false then
		return
	end
	if not IsDelveCurioUiAllowed() then
		return
	end
	ns:ShowDelveCuriosPopup()
	popupShownByGossip = true
end

local function SafeIsValeeraGossipContext()
	local ok, result = pcall(IsValeeraGossipContext)
	return ok and result == true
end

local function OnGossipShow()
	if not IsDelveCurioUiAllowed() then
		return
	end
	if not SafeIsValeeraGossipContext() then
		return
	end
	if C_Timer and C_Timer.After then
		C_Timer.After(0.05, function()
			if IsDelveCurioUiAllowed() and SafeIsValeeraGossipContext() then
				ns:MaybeAutoShowDelveCuriosPopup()
			end
		end)
	else
		ns:MaybeAutoShowDelveCuriosPopup()
	end
end

local function OnGossipClosed()
	if popupShownByGossip then
		ns:HideDelveCuriosPopup()
	end
end

local function EnsureEventBridge()
	if eventFrame then
		return
	end
	eventFrame = CreateFrame("Frame")
	eventFrame:RegisterEvent("GOSSIP_SHOW")
	eventFrame:RegisterEvent("GOSSIP_CLOSED")
	eventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
	eventFrame:RegisterEvent("ITEM_DATA_LOAD_RESULT")
	eventFrame:SetScript("OnEvent", function(_, event, arg1)
		if event == "ITEM_DATA_LOAD_RESULT" then
			if arg1 and ns.IsDelveCurioItemID and ns:IsDelveCurioItemID(arg1) and ShouldLoadCurioItemData() then
				ScheduleCurioAdvisorRefresh()
			end
			return
		end
		if event == "GOSSIP_SHOW" then
			OnGossipShow()
		elseif event == "GOSSIP_CLOSED" then
			OnGossipClosed()
		elseif event == "PLAYER_ENTERING_WORLD" then
			if not IsDelveCurioUiAllowed() then
				popupAutoSuppressed = false
				ns:HideDelveCuriosPopup()
			end
		end
	end)
end

EnsureEventBridge()

do
	local orig = ns.RefreshLocaleUI
	function ns:RefreshLocaleUI()
		if orig then
			orig(self)
		end
		if ns.RefreshDelveCurioAdvisor then
			ns:RefreshDelveCurioAdvisor()
		end
	end
end
