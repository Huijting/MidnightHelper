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
local popupShownByCompanion = false
local companionHooked = false
local curioItemRefreshPending = false

local COMBAT_R, COMBAT_G, COMBAT_B = 1, 0.82, 0
local UTIL_R, UTIL_G, UTIL_B = 0.35, 0.92, 1

-- Single-role popup layout (roomier than the embedded 3-role reference panel).
local P_ROLE_ICON = 30
local P_ITEM_ICON = 26
local P_LINE_H = 26
local P_LINE_GAP = 8
local POPUP_WIDTH = 340

--- ⚠️ `UnitGroupRolesAssigned` CAN RETURN A SECRET VALUE ON 12.1.
---
--- From Blizzard's own 12.1.0 API notes (watcher, 14 Aug): "A number of Unit APIs have
--- been changed to return secret values when the unit's identity is secret" — and the
--- list names `UnitGroupRolesAssigned` alongside `UnitClass`, `UnitSex`, `UnitPhaseReason`
--- and `UnitIsRaidOfficer`.
---
--- A secret string survives `pcall` and `type()` intact and only bites at the comparison
--- below: `role == "TANK"` on a secret is the trap this addon already knows from four
--- GUID reads in July, two of which shipped and threw mid-fight against a boss whose GUID
--- the client hides.
---
--- "player" is the least likely unit to be secret, which is exactly why this would sit
--- here for months and then fire once, in restricted content, in front of somebody. The
--- guard costs a function call and the fallback below is spec-based — it does not ask
--- about a unit at all, so it stays readable when this does not.
local function GetPlayerRoleKey()
	local role
	if UnitGroupRolesAssigned then
		local ok, r = pcall(UnitGroupRolesAssigned, "player")
		if ok and not (issecretvalue and r ~= nil and issecretvalue(r)) then
			role = r
		end
	end
	if (not role or role == "NONE") and GetSpecialization and GetSpecializationRole then
		local spec = GetSpecialization()
		if spec then
			local ok, r = pcall(GetSpecializationRole, spec)
			if ok then
				role = r
			end
		end
	end
	if role == "TANK" then
		return "tank"
	elseif role == "HEALER" then
		return "heal"
	elseif role == "DAMAGER" then
		return "dps"
	end
	return nil
end

--- Shared, because the enchant advisor needs the same answer and the careful part of this
--- is the guarding, not the mapping. Copying it would mean two places to forget the
--- secret-value check in — and this project has spent a week finding pairs of copies that
--- had drifted apart.
ns.GetPlayerRoleKey = GetPlayerRoleKey

--- Map a role subtree's name/icon to our role key. The subtree name is the
--- same localized string the companion frame shows (e.g. "Tank"), so we match
--- it against WoW's own role globals; the icon atlas is a locale-free backup.
local function SubTreeInfoToRoleKey(subInfo)
	if type(subInfo) ~= "table" then
		return nil
	end
	local name = subInfo.name
	if type(name) == "string" and name ~= "" then
		local lname = name:lower()
		local function eqGlobal(globalName)
			local g = _G[globalName]
			return type(g) == "string" and g ~= "" and lname == g:lower()
		end
		if eqGlobal("TANK") then
			return "tank"
		elseif eqGlobal("HEALER") then
			return "heal"
		elseif eqGlobal("DAMAGER") or eqGlobal("DAMAGE") then
			return "dps"
		end
		if lname:find("tank", 1, true) then
			return "tank"
		elseif lname:find("heal", 1, true) then
			return "heal"
		elseif lname:find("dam", 1, true) or lname:find("dps", 1, true) then
			return "dps"
		end
	end
	local atlas = subInfo.iconElementID
	if type(atlas) == "string" and atlas ~= "" then
		local la = atlas:lower()
		if la:find("tank", 1, true) then
			return "tank"
		elseif la:find("heal", 1, true) then
			return "heal"
		elseif la:find("dps", 1, true) or la:find("damage", 1, true) then
			return "dps"
		end
	end
	return nil
end

--- Valeera's currently selected combat role. We resolve the active role
--- subtree (GetRoleNode -> active entry -> subTreeID) and translate it via the
--- subtree's name/icon, because GetRoleSubtreeForCompanion returns nil on the
--- live client. Returns "dps"/"heal"/"tank" or nil.
local function GetCompanionActiveRoleKey()
	if not C_DelvesUI or not C_Traits then
		return nil
	end
	if not C_DelvesUI.GetTraitTreeForCompanion or not C_DelvesUI.GetRoleNodeForCompanion then
		return nil
	end
	if not C_Traits.GetConfigIDByTreeID or not C_Traits.GetNodeInfo or not C_Traits.GetEntryInfo or not C_Traits.GetSubTreeInfo then
		return nil
	end

	local companionID
	if DelvesCompanionConfigurationFrame then
		companionID = DelvesCompanionConfigurationFrame.playerCompanionID
	end

	local okTree, treeID = pcall(C_DelvesUI.GetTraitTreeForCompanion, companionID)
	if not okTree or not treeID then
		return nil
	end
	local okCfg, configID = pcall(C_Traits.GetConfigIDByTreeID, treeID)
	if not okCfg or not configID then
		return nil
	end

	local okNode, roleNodeID = pcall(C_DelvesUI.GetRoleNodeForCompanion, companionID)
	if not okNode or not roleNodeID then
		return nil
	end
	local okInfo, nodeInfo = pcall(C_Traits.GetNodeInfo, configID, roleNodeID)
	if not okInfo or type(nodeInfo) ~= "table" then
		return nil
	end
	local activeEntry = nodeInfo.activeEntry
	local activeEntryID = activeEntry and activeEntry.entryID
	if not activeEntryID then
		return nil
	end
	local okEntry, entryInfo = pcall(C_Traits.GetEntryInfo, configID, activeEntryID)
	if not okEntry or type(entryInfo) ~= "table" or not entryInfo.subTreeID then
		return nil
	end
	local activeSubTreeID = entryInfo.subTreeID

	local okSub, subInfo = pcall(C_Traits.GetSubTreeInfo, configID, activeSubTreeID)
	if not okSub then
		return nil
	end
	return SubTreeInfoToRoleKey(subInfo)
end

--- Diagnostic: prints every step of companion-role detection so we can see
--- exactly where it returns nil on the live client. Invoke via /mh curiodebug.
function ns.DebugCompanionRole()
	local function out(...)
		print("|cff7fd5ffMH curio|r", ...)
	end
	out("C_DelvesUI=", tostring(C_DelvesUI ~= nil), " C_Traits=", tostring(C_Traits ~= nil))
	if not C_DelvesUI or not C_Traits then
		return
	end
	out("fns: GetTraitTreeForCompanion=", tostring(C_DelvesUI.GetTraitTreeForCompanion ~= nil),
		" GetRoleNodeForCompanion=", tostring(C_DelvesUI.GetRoleNodeForCompanion ~= nil),
		" GetRoleSubtreeForCompanion=", tostring(C_DelvesUI.GetRoleSubtreeForCompanion ~= nil))
	out("fns: GetConfigIDByTreeID=", tostring(C_Traits.GetConfigIDByTreeID ~= nil),
		" GetNodeInfo=", tostring(C_Traits.GetNodeInfo ~= nil),
		" GetEntryInfo=", tostring(C_Traits.GetEntryInfo ~= nil))

	local companionID = DelvesCompanionConfigurationFrame and DelvesCompanionConfigurationFrame.playerCompanionID
	out("companionID(frame)=", tostring(companionID))
	if C_DelvesUI.GetPlayerCompanionPDEID then
		out("GetPlayerCompanionPDEID=", tostring(select(2, pcall(C_DelvesUI.GetPlayerCompanionPDEID))))
	end

	local okTree, treeID = pcall(C_DelvesUI.GetTraitTreeForCompanion, companionID)
	out("treeID=", tostring(okTree and treeID))
	if not okTree or not treeID then
		return
	end
	local okCfg, configID = pcall(C_Traits.GetConfigIDByTreeID, treeID)
	out("configID=", tostring(okCfg and configID))
	if not okCfg or not configID then
		return
	end
	local okNode, roleNodeID = pcall(C_DelvesUI.GetRoleNodeForCompanion, companionID)
	out("roleNodeID=", tostring(okNode and roleNodeID))
	if not okNode or not roleNodeID then
		return
	end
	local okInfo, nodeInfo = pcall(C_Traits.GetNodeInfo, configID, roleNodeID)
	local entryID = okInfo and type(nodeInfo) == "table" and nodeInfo.activeEntry and nodeInfo.activeEntry.entryID
	out("nodeInfo=", tostring(okInfo and type(nodeInfo) == "table"), " activeEntryID=", tostring(entryID),
		" nodeType=", tostring(okInfo and type(nodeInfo) == "table" and nodeInfo.type))
	if okInfo and type(nodeInfo) == "table" and type(nodeInfo.entryIDs) == "table" then
		out("entryIDs#=", tostring(#nodeInfo.entryIDs))
	end
	if not entryID then
		return
	end
	local okEntry, entryInfo = pcall(C_Traits.GetEntryInfo, configID, entryID)
	local subID = okEntry and type(entryInfo) == "table" and entryInfo.subTreeID
	out("entryInfo=", tostring(okEntry and type(entryInfo) == "table"), " activeSubTreeID=", tostring(subID))
	if subID and C_Traits.GetSubTreeInfo then
		local okSub, subInfo = pcall(C_Traits.GetSubTreeInfo, configID, subID)
		if okSub and type(subInfo) == "table" then
			out("subtree name=", tostring(subInfo.name), " icon=", tostring(subInfo.iconElementID))
		else
			out("GetSubTreeInfo failed/empty")
		end
	end
	out("globals TANK/HEALER/DAMAGER=", tostring(_G.TANK), "/", tostring(_G.HEALER), "/", tostring(_G.DAMAGER))
	out("=> resolved role:", tostring(GetCompanionActiveRoleKey()))
end

--- Role to display in the popup: Valeera's selected role first, then the
--- player's own role as a sensible fallback, then DPS.
local function ResolvePopupRoleKey()
	local ok, role = pcall(GetCompanionActiveRoleKey)
	if ok and role then
		return role
	end
	return GetPlayerRoleKey() or "dps"
end

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

--- ⚠️ "In a delve" is no longer enough. Season 2 opens on 18 Aug 2026 and there is no
--- Season 2 curio pack, so every surface here had to learn to say nothing rather than
--- show an empty frame with a confident title. See ns.HasDelveCurioAdvice.
local function HaveAdvice()
	if ns.HasDelveCurioAdvice then
		return (ns.HasDelveCurioAdvice()) and true or false
	end
	return false
end

local function IsDelveCurioUiAllowed()
	if not HaveAdvice() then
		return false
	end
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

		local hl = row:CreateTexture(nil, "BACKGROUND")
		hl:SetPoint("TOPLEFT", row, "TOPLEFT", -2, 2)
		hl:SetPoint("BOTTOMRIGHT", row, "BOTTOMRIGHT", 2, -2)
		hl:SetColorTexture(1, 0.82, 0, 0.10)
		hl:Hide()
		row.highlight = hl

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

			local count = line:CreateFontString(nil, "OVERLAY", "NumberFontNormalSmall")
			count:SetPoint("BOTTOMRIGHT", icon, "BOTTOMRIGHT", 1, 0)
			count:SetJustifyH("RIGHT")
			line.itemCount = count

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
				GameTooltip:SetOwner(self, "ANCHOR_CURSOR")
				local link = ns.GetDelveCurioItemLink and ns.GetDelveCurioItemLink(itemID)
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
	local playerRole = GetPlayerRoleKey()
	for _, row in ipairs(rows) do
		local role = row.role
		local pick = ns.GetDelveCurioPick and ns.GetDelveCurioPick(season, role, variant)
		if pick then
			TrySetAtlas(row.roleIcon, ROLE_ATLASES[role])
			local function paint(line, itemID, labelKey)
				line.itemID = itemID
				line.itemIcon:SetTexture(ns.GetDelveCurioItemIcon(itemID))
				local itemName = ns.GetDelveCurioItemName(itemID)
				line.label:SetText(ns:L(labelKey) .. " " .. itemName)
				line.label:SetTextColor(line.textR, line.textG, line.textB)
				if line.itemCount then
					line.itemCount:Hide()
				end
				line:Show()
			end
			paint(row.combatLine, pick.combat, "DELVE_CURIO_COMBAT")
			paint(row.utilityLine, pick.utility, "DELVE_CURIO_UTILITY")
			if row.highlight then
				if host._isPopup and playerRole and role == playerRole then
					row.highlight:Show()
				else
					row.highlight:Hide()
				end
			end
			row:Show()
		else
			row:Hide()
		end
	end
end

local function NemesisFootnoteHeight(season)
	local pack = ns.GetDelveCurioSeasonTable and ns.GetDelveCurioSeasonTable(season)
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
	local pack = ns.GetDelveCurioSeasonTable and ns.GetDelveCurioSeasonTable(season)
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

--- Single active-role layout used inside the popup (one role group, roomy).
local function BuildPopupBody(host)
	if host._popupBuilt then
		return
	end
	host._popupBuilt = true

	local roleIcon = host:CreateTexture(nil, "ARTWORK")
	roleIcon:SetSize(P_ROLE_ICON, P_ROLE_ICON)
	roleIcon:SetPoint("LEFT", host, "LEFT", 4, 0)
	host._roleIcon = roleIcon

	local function makeLine(kind, r, g, b)
		local line = CreateFrame("Button", nil, host)
		line:SetHeight(P_LINE_H)
		line:EnableMouse(true)

		local icon = line:CreateTexture(nil, "ARTWORK")
		icon:SetSize(P_ITEM_ICON, P_ITEM_ICON)
		icon:SetPoint("LEFT", line, "LEFT", 0, 0)
		line.itemIcon = icon

		local label = line:CreateFontString(nil, "OVERLAY", "GameFontNormal")
		label:SetPoint("LEFT", icon, "RIGHT", 8, 0)
		label:SetPoint("RIGHT", line, "RIGHT", -6, 0)
		label:SetJustifyH("LEFT")
		label:SetWordWrap(false)
		line.label = label

		line.kind, line.textR, line.textG, line.textB = kind, r, g, b

		line:SetScript("OnEnter", function(self)
			local itemID = self.itemID
			if not itemID or not GameTooltip then
				return
			end
			GameTooltip:SetOwner(self, "ANCHOR_CURSOR")
			local link = ns.GetDelveCurioItemLink and ns.GetDelveCurioItemLink(itemID)
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

	host._combatLine = makeLine("combat", COMBAT_R, COMBAT_G, COMBAT_B)
	host._utilityLine = makeLine("utility", UTIL_R, UTIL_G, UTIL_B)

	host._combatLine:SetPoint("TOPLEFT", host, "TOPLEFT", P_ROLE_ICON + 14, -3)
	host._combatLine:SetPoint("RIGHT", host, "RIGHT", -6, 0)
	host._utilityLine:SetPoint("TOPLEFT", host._combatLine, "BOTTOMLEFT", 0, -P_LINE_GAP)
	host._utilityLine:SetPoint("RIGHT", host, "RIGHT", -6, 0)
end

local function RefreshPopupBody(host, season, variant, roleKey)
	BuildPopupBody(host)
	TrySetAtlas(host._roleIcon, ROLE_ATLASES[roleKey] or ROLE_ATLASES.dps)

	local pick = ns.GetDelveCurioPick and ns.GetDelveCurioPick(season, roleKey, variant)
	if not pick then
		host._combatLine:Hide()
		host._utilityLine:Hide()
		return
	end

	local function paint(line, itemID, labelKey)
		line.itemID = itemID
		line.itemIcon:SetTexture(ns.GetDelveCurioItemIcon(itemID))
		line.label:SetText(ns:L(labelKey) .. " " .. ns.GetDelveCurioItemName(itemID))
		line.label:SetTextColor(line.textR, line.textG, line.textB)
		line:Show()
	end

	paint(host._combatLine, pick.combat, "DELVE_CURIO_COMBAT")
	paint(host._utilityLine, pick.utility, "DELVE_CURIO_UTILITY")
end

function ns.RefreshDelveCurioAdvisor()
	-- No curio pack for the season we are in (Season 2 has none): collapse the embedded
	-- panel to one honest line and close the popup. The panel frame stays — the Delves
	-- tab anchors its left column underneath it — but it stops claiming anything.
	if not HaveAdvice() then
		if embeddedPanel then
			if embeddedPanel._title then
				embeddedPanel._title:SetText(ns:L("DELVE_CURIO_NO_SEASON_DATA"))
			end
			if embeddedPanel._body then
				embeddedPanel._body:SetHeight(1)
				RefreshRoleRows(embeddedPanel._body, nil, "default")
			end
			if embeddedPanel._nemesisFoot then
				embeddedPanel._nemesisFoot:Hide()
			end
			embeddedPanel:SetHeight(PANEL_HEADER_H + PANEL_PAD)
		end
		if popupFrame and popupFrame:IsShown() then
			popupFrame:Hide()
		end
		return
	end

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
		local roleKey = ResolvePopupRoleKey()
		local roleLabel = ROLE_LABEL_KEYS[roleKey] and ns:L(ROLE_LABEL_KEYS[roleKey]) or ""
		if popupFrame._title then
			if roleLabel ~= "" then
				popupFrame._title:SetText(string.format(ns:L("DELVE_CURIO_POPUP_TITLE_ROLE"), roleLabel))
			else
				popupFrame._title:SetText(ns:L("DELVE_CURIO_POPUP_TITLE"))
			end
		end
		if popupFrame._hint then
			popupFrame._hint:SetText(ns:L("DELVE_CURIO_POPUP_HINT"))
		end
		if popupFrame._body then
			popupFrame._body:SetHeight((P_LINE_H * 2) + P_LINE_GAP)
			RefreshPopupBody(popupFrame._body, season, variant, roleKey)
		end
		if popupFrame._reason then
			if variant == "nemesis" then
				local pack = ns.GetDelveCurioSeasonTable and ns.GetDelveCurioSeasonTable(season)
				local nem = pack and pack.nemesis and pack.nemesis.dps
				if nem and nem.utility then
					popupFrame._reason:SetText(string.format(ns:L("DELVE_CURIO_NEMESIS_NOTE"), ns.GetDelveCurioItemName(nem.utility)))
				else
					popupFrame._reason:SetText(ns:L("DELVE_CURIO_POPUP_WHY"))
				end
			else
				popupFrame._reason:SetText(ns:L("DELVE_CURIO_POPUP_WHY"))
			end
		end
		popupFrame:SetSize(POPUP_WIDTH, 180)
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
	-- Height is set for real by RefreshDelveCurioAdvisor at the end of this function,
	-- which also handles the "no pack for this season" case. Start at the header height
	-- so a season we know nothing about never reserves room for rows that never come.
	panel:SetHeight(PANEL_HEADER_H + PANEL_PAD)

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

	local reason = f:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
	reason:SetPoint("BOTTOMLEFT", f, "BOTTOMLEFT", 14, 12)
	reason:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -14, 12)
	reason:SetJustifyH("CENTER")
	reason:SetWordWrap(true)
	reason:SetTextColor(0.72, 0.7, 0.65)
	f._reason = reason

	BuildPopupBody(body)
	popupFrame = f
	ApplyPopupPoint(f)
	return f
end

function ns:ShowDelveCuriosPopup(bypassGate)
	local s = GetPopupSettings()
	if s and s.enabled == false then
		return
	end
	-- No pack for this season: the manual command says so out loud (a command that
	-- silently does nothing reads as broken), the automatic paths simply stay away.
	if not HaveAdvice() then
		if bypassGate then
			print(("|cffffcc00%s|r %s"):format(ns:L("PRINT_PREFIX"), ns:L("DELVE_CURIO_NO_SEASON_DATA")))
		end
		return
	end
	if not bypassGate and not IsDelveCurioUiAllowed() then
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
	popupShownByCompanion = false
end

--- Manual toggle (slash command): always allowed, ignores in-delve gate.
function ns:ToggleDelveCuriosPopup()
	if popupFrame and popupFrame:IsShown() then
		popupAutoSuppressed = true
		ns.HideDelveCuriosPopup()
		return false
	end
	popupAutoSuppressed = false
	ns:ShowDelveCuriosPopup(true)
	return true
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

--- Reliable, locale-independent trigger: the Blizzard delve companion / curio
--- config window. This is exactly the moment the player goes to equip curios.
local function HookCompanionConfigFrame()
	if companionHooked then
		return
	end
	local frame = DelvesCompanionConfigurationFrame
	if not frame or not frame.HookScript then
		return
	end
	companionHooked = true

	frame:HookScript("OnShow", function()
		popupAutoSuppressed = false
		ns:ShowDelveCuriosPopup(true)
		popupShownByCompanion = true
	end)
	frame:HookScript("OnHide", function()
		if popupShownByCompanion then
			ns.HideDelveCuriosPopup()
		end
	end)

	if frame:IsShown() then
		ns:ShowDelveCuriosPopup(true)
		popupShownByCompanion = true
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
	eventFrame:RegisterEvent("ADDON_LOADED")
	eventFrame:RegisterEvent("TRAIT_CONFIG_UPDATED")
	eventFrame:SetScript("OnEvent", function(_, event, arg1)
		if event == "ITEM_DATA_LOAD_RESULT" then
			if arg1 and ns.IsDelveCurioItemID and ns.IsDelveCurioItemID(arg1) and ShouldLoadCurioItemData() then
				ScheduleCurioAdvisorRefresh()
			end
			return
		end
		if event == "TRAIT_CONFIG_UPDATED" then
			-- Fires when Valeera's role/curio is committed, so the popup tracks
			-- her active role in real time.
			if ShouldLoadCurioItemData() then
				ScheduleCurioAdvisorRefresh()
			end
			return
		end
		if event == "ADDON_LOADED" then
			if arg1 == "Blizzard_DelvesCompanionConfiguration" then
				HookCompanionConfigFrame()
			end
			return
		end
		if event == "GOSSIP_SHOW" then
			OnGossipShow()
		elseif event == "GOSSIP_CLOSED" then
			OnGossipClosed()
		elseif event == "PLAYER_ENTERING_WORLD" then
			HookCompanionConfigFrame()
			if not IsDelveCurioUiAllowed() then
				popupAutoSuppressed = false
				if not popupShownByCompanion then
					ns:HideDelveCuriosPopup()
				end
			end
		end
	end)
end

EnsureEventBridge()
HookCompanionConfigFrame()

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

--- /mh valeera — name every node in the delve companion's trait tree.
---
--- Curio item ids cannot be swept the way currency ids can (GetItemInfo returns nil
--- for anything not cached), and `/mh finditem` only finds what you already own —
--- Rob's Season 2 curio slots were empty on the PTR, so there was nothing to read.
--- But the companion's POISONS and CURIOS are offered from her trait tree, and a
--- tree can be enumerated whether or not you own anything.
---
--- Reuses ns.ResolveTraitNodeName (built for the profession advisor): the same
--- entryIDs -> GetEntryInfo -> definitionID -> GetDefinitionInfo -> spell-name chain,
--- verified against AskMrRobot. Names therefore come from the client, already
--- localised, and cannot be a guess.
---
--- Confirmed in game 2026-07-24 (12.1 PTR): the poison IS a player choice in
--- Season 2 — Valeera's panel showed "Poisons: Poison of the Forgotten Master" with
--- Bloodcrypt Toxin and Soulthirst Venom alongside it, where Season 1 tied the
--- poison to her role. This probe is how we get the ids behind those names.
function ns.PrintCompanionTreeProbe()
	local prefix = ("|cffffcc00%s|r"):format(ns.L and ns:L("PRINT_PREFIX") or "MH")
	if not (C_DelvesUI and C_Traits and C_Traits.GetTreeNodes) then
		print(prefix .. " C_DelvesUI / C_Traits not available")
		return
	end
	local companionID = DelvesCompanionConfigurationFrame
		and DelvesCompanionConfigurationFrame.playerCompanionID
	if not companionID and C_DelvesUI.GetPlayerCompanionPDEID then
		local okP, pde = pcall(C_DelvesUI.GetPlayerCompanionPDEID)
		companionID = okP and pde or nil
	end
	if not companionID then
		print(prefix .. " no companion id — open Valeera's window once, then retry")
		return
	end
	local okTree, treeID = pcall(C_DelvesUI.GetTraitTreeForCompanion, companionID)
	-- 0 is TRUTHY in Lua, so "not treeID" let a missing tree through and the probe
	-- went on to ask for a config id for tree 0 (Rob, PTR 2026-07-24). Treat 0 as
	-- "no tree" and say what to do about it.
	if not okTree or not treeID or treeID == 0 then
		print(prefix .. " no trait tree for companion " .. tostring(companionID) .. " - open Valeera's window (the delve companion panel) and run this again")
		return
	end
	local okCfg, configID = pcall(C_Traits.GetConfigIDByTreeID, treeID)
	if not okCfg or not configID then
		print(prefix .. " no config id for tree " .. tostring(treeID))
		return
	end
	local okNodes, nodes = pcall(C_Traits.GetTreeNodes, treeID)
	if not okNodes or type(nodes) ~= "table" then
		print(prefix .. " could not read the tree's nodes")
		return
	end
	print(("%s Companion %s — tree %s, config %s, %d node(s):"):format(
		prefix, tostring(companionID), tostring(treeID), tostring(configID), #nodes))
	local named = 0
	for _, nodeID in ipairs(nodes) do
		local okI, node = pcall(C_Traits.GetNodeInfo, configID, nodeID)
		if okI and type(node) == "table" then
			-- A choice node offers several entries; print each so poisons and curios
			-- show up individually instead of only the one currently selected.
			local shown = false
			if type(node.entryIDs) == "table" and #node.entryIDs > 0 then
				for _, entryID in ipairs(node.entryIDs) do
					local okE, entry = pcall(C_Traits.GetEntryInfo, configID, entryID)
					if okE and type(entry) == "table" and entry.definitionID then
						local okD, defn = pcall(C_Traits.GetDefinitionInfo, entry.definitionID)
						if okD and type(defn) == "table" then
							local nm = defn.overrideName
							if (type(nm) ~= "string" or nm == "") and defn.spellID and C_Spell and C_Spell.GetSpellName then
								local okN, sn = pcall(C_Spell.GetSpellName, defn.spellID)
								nm = okN and sn or nil
							end
							if type(nm) == "string" and nm ~= "" then
								named = named + 1
								shown = true
								print(("   |cff40c040%-34s|r node %-7s entry %-7s spell %s"):format(
									nm, tostring(nodeID), tostring(entryID), tostring(defn.spellID)))
							end
						end
					end
				end
			end
			if not shown and (node.maxRanks or 0) > 0 then
				print(("   |cff888888(unnamed)|r node %-7s ranks %s/%s"):format(
					tostring(nodeID), tostring(node.ranksPurchased or 0), tostring(node.maxRanks)))
			end
		end
	end
	if named == 0 then
		print("   |cffff8080nothing could be named — open Valeera's window and retry|r")
	end
	print("   " .. prefix .. " |cff8a8f98names come from your client. Match them to the poisons/curios on her panel.|r")
end

--- /mh valeera save — same walk, into SavedVariables instead of chat.
---
--- Added 2026-07-27 the moment Rob pointed out the obvious: the companion tree is a
--- long listing, and the day before we agreed long listings go to SavedVariables so
--- nobody has to screenshot or retype them. Chat output stays for the short probes.
---
--- Structure mirrors what PrintCompanionTreeProbe prints, so anything readable there
--- is readable here: per node the ranks, per entry the resolved name and spellID.
--- ⚠️ SavedVariables reach disk only on /reload or logout.
function ns.SaveCompanionTreeProbe()
	local prefix = ("|cffffcc00%s|r"):format(ns.L and ns:L("PRINT_PREFIX") or "MH")

	-- A probe that gives up quietly is worse than no probe: twice on 2026-07-27 this
	-- wrote nothing at all and there was no way to tell from the saved file WHY. So
	-- every exit now records itself. An empty capture and a failed capture look
	-- identical from outside; they must not look identical from inside.
	ns.db = ns.db or {}
	local function bail(why, extra)
		ns.db.companionProbe = {
			captured = (time and time()) or 0,
			build = select(4, GetBuildInfo()),
			failed = why,
			detail = extra,
			hasFrame = DelvesCompanionConfigurationFrame ~= nil,
			frameShown = (DelvesCompanionConfigurationFrame
				and DelvesCompanionConfigurationFrame.IsShown
				and DelvesCompanionConfigurationFrame:IsShown()) or false,
			hasDelvesUI = C_DelvesUI ~= nil,
			hasTraits = C_Traits ~= nil,
		}
		print(("%s probe stopped: %s"):format(prefix, tostring(why)))
		print("   |cffffff78Reload anyway|r -- the reason is saved and can be read from disk.")
	end

	if not (C_DelvesUI and C_Traits and C_Traits.GetTreeNodes) then
		bail("C_DelvesUI / C_Traits not available")
		return
	end
	local companionID = DelvesCompanionConfigurationFrame
		and DelvesCompanionConfigurationFrame.playerCompanionID
	if not companionID and C_DelvesUI.GetPlayerCompanionPDEID then
		local okP, pde = pcall(C_DelvesUI.GetPlayerCompanionPDEID)
		companionID = okP and pde or nil
	end
	if not companionID then
		bail("no companion id", "open Valeera's window once, then retry")
		return
	end
	local okTree, treeID = pcall(C_DelvesUI.GetTraitTreeForCompanion, companionID)
	-- 0 is truthy in Lua; treat it as "no tree" (the bug that bit us 2026-07-24).
	if not okTree or not treeID or treeID == 0 then
		bail("no trait tree", ("companion=%s treeID=%s"):format(
			tostring(companionID), tostring(treeID)))
		return
	end
	local okCfg, configID = pcall(C_Traits.GetConfigIDByTreeID, treeID)
	local okNodes, nodes = pcall(C_Traits.GetTreeNodes, treeID)
	if not okCfg or not configID or not okNodes or type(nodes) ~= "table" then
		bail("config or nodes missing", ("tree=%s config=%s nodes=%s"):format(
			tostring(treeID), tostring(configID), type(nodes)))
		return
	end

	local cap = {
		captured = (time and time()) or 0,
		build = select(4, GetBuildInfo()),
		companionID = companionID,
		treeID = treeID,
		configID = configID,
		nodes = {},
	}
	local named = 0
	for _, nodeID in ipairs(nodes) do
		local okI, node = pcall(C_Traits.GetNodeInfo, configID, nodeID)
		if okI and type(node) == "table" then
			local row = {
				nodeID = nodeID,
				ranksPurchased = node.ranksPurchased,
				maxRanks = node.maxRanks,
				entries = {},
			}
			for _, entryID in ipairs(type(node.entryIDs) == "table" and node.entryIDs or {}) do
				local okE, entry = pcall(C_Traits.GetEntryInfo, configID, entryID)
				if okE and type(entry) == "table" and entry.definitionID then
					local okD, defn = pcall(C_Traits.GetDefinitionInfo, entry.definitionID)
					if okD and type(defn) == "table" then
						local nm = defn.overrideName
						if (type(nm) ~= "string" or nm == "") and defn.spellID
							and C_Spell and C_Spell.GetSpellName then
							local okN, sn = pcall(C_Spell.GetSpellName, defn.spellID)
							nm = okN and sn or nil
						end
						if type(nm) == "string" and nm ~= "" then
							named = named + 1
						end
						row.entries[#row.entries + 1] = {
							entryID = entryID,
							name = nm,
							spellID = defn.spellID,
						}
					end
				end
			end
			cap.nodes[#cap.nodes + 1] = row
		end
	end

	ns.db = ns.db or {}
	ns.db.companionProbe = cap
	print(("%s captured companion %s: tree %s, %d nodes, %d named entries."):format(
		prefix, tostring(companionID), tostring(treeID), #cap.nodes, named))
	print("   |cffffff78Now type /reload|r — SavedVariables only reach disk on reload or logout.")
end

--------------------------------------------------------------------------------
-- Valeera's Poisons (12.1 / Season 2).
--
-- The advisor recommends a Combat and a Utility curio but says nothing about the
-- Poisons slot, which is the one 12.1 added. Rob's screenshot of 27 July showed
-- the result: a panel headed "Recommended curios for Valeera this Delve season"
-- with almost nothing under it.
--
-- What this adds is information rather than a verdict: the three poisons the
-- client offers, each with the game's own description, and a mark on the one that
-- is currently slotted. No "best" is claimed -- see DelveCuriosData for why.
--------------------------------------------------------------------------------

--- Name and description for one poison, read from the client.
--- @return string|nil name, string|nil description
function ns.GetDelvePoisonInfo(spellID)
	spellID = tonumber(spellID)
	if not spellID or not C_Spell then
		return nil, nil
	end
	local name, desc
	if C_Spell.GetSpellName then
		local ok, n = pcall(C_Spell.GetSpellName, spellID)
		name = ok and n or nil
	end
	if C_Spell.GetSpellDescription then
		local ok, d = pcall(C_Spell.GetSpellDescription, spellID)
		-- An empty string is not a description. Blizzard returns "" while spell
		-- data is still loading, and showing that reads as "this does nothing".
		if ok and type(d) == "string" and d ~= "" then
			desc = d
		end
	end
	return name, desc
end

--- Which poison is currently slotted, as a spellID.
--- @return number|nil spellID  nil when it cannot be read -- never a guess
function ns.GetEquippedDelvePoison()
	local pack = ns.GetDelvePoisonsForSeason(
		ns.GetDelvesSeasonNumber and ns.GetDelvesSeasonNumber() or nil)
	if not pack or not pack.nodeID or not (C_DelvesUI and C_Traits) then
		return nil
	end
	local companionID = DelvesCompanionConfigurationFrame
		and DelvesCompanionConfigurationFrame.playerCompanionID
	if not companionID and C_DelvesUI.GetPlayerCompanionPDEID then
		local okP, pde = pcall(C_DelvesUI.GetPlayerCompanionPDEID)
		companionID = okP and pde or nil
	end
	if not companionID then
		return nil
	end
	local okTree, treeID = pcall(C_DelvesUI.GetTraitTreeForCompanion, companionID)
	-- 0 is truthy in Lua, and a 0 tree means "not readable yet" (2026-07-24).
	if not okTree or not treeID or treeID == 0 then
		return nil
	end
	local okCfg, configID = pcall(C_Traits.GetConfigIDByTreeID, treeID)
	if not okCfg or not configID then
		return nil
	end
	local okNode, node = pcall(C_Traits.GetNodeInfo, configID, pack.nodeID)
	if not okNode or type(node) ~= "table" then
		return nil
	end
	-- node.activeEntry.entryID is how a choice node reports its pick
	-- (AskMrRobot/Core.lua:660 reads it the same way).
	local activeID = type(node.activeEntry) == "table" and node.activeEntry.entryID or nil
	if not activeID then
		return nil
	end
	for _, choice in ipairs(pack.choices) do
		if choice.entryID == activeID then
			return choice.spellID
		end
	end
	return nil
end

--- The poison lines for the current season, ready to render.
--- @return table|nil rows  { { spellID, name, description, equipped } }, nil if none
function ns.GetDelvePoisonRows()
	local pack = ns.GetDelvePoisonsForSeason(
		ns.GetDelvesSeasonNumber and ns.GetDelvesSeasonNumber() or nil)
	if not pack or type(pack.choices) ~= "table" then
		return nil
	end
	local equipped = ns.GetEquippedDelvePoison()
	local rows = {}
	for _, choice in ipairs(pack.choices) do
		local name, desc = ns.GetDelvePoisonInfo(choice.spellID)
		-- No name means the client has not loaded this spell. Skip it rather than
		-- print a bare id at someone.
		if name then
			rows[#rows + 1] = {
				spellID = choice.spellID,
				name = name,
				description = desc,
				equipped = (equipped ~= nil and equipped == choice.spellID),
			}
		end
	end
	if #rows == 0 then
		return nil
	end
	return rows
end

--- /mh poisons — list them in chat, with whatever the client says they do.
function ns.PrintDelvePoisons()
	local prefix = ("|cffffcc00%s|r"):format(ns.L and ns:L("PRINT_PREFIX") or "MH")
	local rows = ns.GetDelvePoisonRows()
	if not rows then
		print(prefix .. " " .. ns:L("POISON_NONE"))
		return
	end
	print(prefix .. " " .. ns:L("POISON_HEADER"))
	for _, r in ipairs(rows) do
		print(("   %s|cffffffff%s|r"):format(r.equipped and "|cff40c040> |r" or "  ", r.name))
		if r.description then
			print("      |cff8a8f98" .. r.description .. "|r")
		end
	end
end
