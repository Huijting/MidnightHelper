--[[
	Tools-launchpad (1.9.0 Phase 4) — alle zwevende helper-vensters op één
	vindbare plek in de Tools-kamer, i.p.v. verstopt achter slash-commando's.
	Elke kaart: icoon, naam, korte uitleg, het /mh-commando en een Open-knop.

	Bouwt op bestaande toggles (geen nieuwe vensterlogica): Delve Coach,
	Consumables-bord, Dungeon boss-venster, Curios-adviseur, Ritueel-boss-coach.
]]

local _, ns = ...

local function L(key)
	return (ns.L and ns:L(key)) or key
end
local function SF(name)
	return (ns.MHScalableFont and ns.MHScalableFont(name)) or name
end

-- nameKey hergebruikt bestaande 7-talen-labels; descKey = en+nl (rest valt terug
-- op enUS via ns:L). Slash-teksten zijn commando's, niet vertaald.
local TOOLS = {
	{
		nameKey = "DELVE_COACH_TITLE", descKey = "TOOLLP_COACH_DESC",
		icon = "Interface\\Icons\\INV_Misc_Map_01", slash = "/mh coach",
		open = function() if ns.ToggleDelveCoach then ns:ToggleDelveCoach() end end,
	},
	{
		nameKey = "NAV_TOOL_BOARD", descKey = "TOOLLP_BOARD_DESC",
		icon = "Interface\\Icons\\INV_Potion_27", slash = "/mh board",
		open = function() if ns.ShowConsumableBoard then ns.ShowConsumableBoard() end end,
	},
	{
		nameKey = "NAV_TOOL_BOSSWIN", descKey = "TOOLLP_BOSSWIN_DESC",
		icon = "Interface\\Icons\\INV_Misc_Head_Dragon_01", slash = "/mh bosswin",
		open = function() if ns.ToggleDungeonBossWindow then ns.ToggleDungeonBossWindow() end end,
	},
	{
		nameKey = "NAV_TOOL_CURIOS", descKey = "TOOLLP_CURIOS_DESC",
		icon = "Interface\\Icons\\INV_Misc_Gem_Diamond_03", slash = "/mh curio",
		open = function() if ns.ToggleDelveCuriosPopup then ns:ToggleDelveCuriosPopup() end end,
	},
	{
		nameKey = "NAV_TOOL_RITUALBOSS", descKey = "TOOLLP_RITUALBOSS_DESC",
		icon = "Interface\\Icons\\Spell_Arcane_PortalSilvermoon", slash = "/mh ritualboss",
		open = function() if ns.ToggleRitualBossWindow then ns.ToggleRitualBossWindow() end end,
	},
}

function ns.BuildToolsLaunchpad(panel)
	if not panel or panel._mhLaunchpadBuilt then
		return
	end
	panel._mhLaunchpadBuilt = true

	-- Placeholder van CreateModulePanel verbergen.
	if panel._header then panel._header:Hide() end
	if panel._body then panel._body:Hide() end

	local title = panel:CreateFontString(nil, "OVERLAY", "GameFontHighlightLarge")
	title:SetFontObject(SF("GameFontHighlightLarge"))
	title:SetPoint("TOPLEFT", panel, "TOPLEFT", 14, -14)
	title:SetText(L("TAB_TOOLSLAUNCH"))

	local intro = panel:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	intro:SetFontObject(SF("GameFontHighlightSmall"))
	intro:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -4)
	intro:SetPoint("RIGHT", panel, "RIGHT", -14, 0)
	intro:SetJustifyH("LEFT")
	intro:SetWordWrap(true)
	intro:SetTextColor(0.78, 0.8, 0.85)
	intro:SetText(L("TOOLLP_INTRO"))

	local prev = intro
	for _, tool in ipairs(TOOLS) do
		local card = CreateFrame("Button", nil, panel)
		card:SetHeight(50)
		card:SetPoint("TOPLEFT", prev, "BOTTOMLEFT", 0, -10)
		card:SetPoint("RIGHT", panel, "RIGHT", -14, 0)

		local bg = card:CreateTexture(nil, "BACKGROUND")
		bg:SetAllPoints()
		bg:SetColorTexture(0.16, 0.15, 0.18, 0.6)
		local hl = card:CreateTexture(nil, "HIGHLIGHT")
		hl:SetAllPoints()
		hl:SetColorTexture(1, 0.82, 0.2, 0.10)

		local icon = card:CreateTexture(nil, "ARTWORK")
		icon:SetSize(34, 34)
		icon:SetPoint("LEFT", card, "LEFT", 8, 0)
		icon:SetTexture(tool.icon)
		icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)

		local openBtn = CreateFrame("Button", nil, card, "UIPanelButtonTemplate")
		openBtn:SetSize(74, 22)
		openBtn:SetPoint("RIGHT", card, "RIGHT", -8, 0)
		openBtn:SetText(L("SET_BTN_OPEN"))
		openBtn:SetScript("OnClick", tool.open)

		local slash = card:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
		slash:SetFontObject(SF("GameFontDisableSmall"))
		slash:SetPoint("RIGHT", openBtn, "LEFT", -10, 0)
		slash:SetText(tool.slash)

		local name = card:CreateFontString(nil, "OVERLAY", "GameFontNormal")
		name:SetFontObject(SF("GameFontNormal"))
		name:SetPoint("TOPLEFT", icon, "TOPRIGHT", 10, -2)
		name:SetText(L(tool.nameKey))

		local desc = card:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
		desc:SetFontObject(SF("GameFontHighlightSmall"))
		desc:SetPoint("TOPLEFT", name, "BOTTOMLEFT", 0, -2)
		desc:SetPoint("RIGHT", slash, "LEFT", -10, 0)
		desc:SetJustifyH("LEFT")
		desc:SetWordWrap(false)
		desc:SetTextColor(0.75, 0.77, 0.82)
		desc:SetText(L(tool.descKey))

		prev = card
	end
end
