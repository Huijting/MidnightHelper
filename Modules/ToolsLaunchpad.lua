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

-- nameKey hergebruikt bestaande 7-talen-labels; descKey staat in Translations2026.
-- Slash-teksten zijn commando's, niet vertaald.
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
		open = function() if ns.ToggleDungeonBossWindow then ns:ToggleDungeonBossWindow() end end,
	},
	{
		nameKey = "NAV_TOOL_CURIOS", descKey = "TOOLLP_CURIOS_DESC",
		icon = "Interface\\Icons\\INV_Misc_Gem_Diamond_03", slash = "/mh curio",
		open = function() if ns.ToggleDelveCuriosPopup then ns:ToggleDelveCuriosPopup() end end,
	},
	{
		nameKey = "NAV_TOOL_RITUALBOSS", descKey = "TOOLLP_RITUALBOSS_DESC",
		icon = "Interface\\Icons\\Spell_Arcane_PortalSilvermoon", slash = "/mh ritualboss",
		open = function() if ns.ToggleRitualBossWindow then ns:ToggleRitualBossWindow() end end,
	},
	{
		nameKey = "TOOLLP_COURSE_NAME", descKey = "TOOLLP_COURSE_DESC",
		icon = "Interface\\Icons\\INV_Misc_Book_09", slash = "/mh course",
		open = function() if ns.ToggleProfessionCourseWindow then ns.ToggleProfessionCourseWindow() end end,
	},
	{
		nameKey = "TOOLLP_VALEERA_NAME", descKey = "TOOLLP_VALEERA_DESC",
		icon = "Interface\\Icons\\INV_Misc_Head_Human_02", slash = "/mh valeera",
		open = function() if ns.ToggleValeeraPopup then ns.ToggleValeeraPopup() end end,
	},
	-- 6 Oct 2026, Rob: "we moeten dit soort dingen ook als handige knop in de MH hebben ipv alleen maar slash mh en dan
	-- een commando". Icons: paths MH already shows elsewhere (Openables, the sidebar), not guessed ones.
	{
		nameKey = "RAIDSHOP_TITLE", descKey = "TOOLLP_READY_DESC",
		icon = "Interface\\Icons\\INV_Misc_Bag_08", slash = "/mh ready",
		open = function() if ns.ShowRaidShoppingList then ns.ShowRaidShoppingList() end end,
	},
	{
		nameKey = "CRAFTSHOP_TITLE", descKey = "CMDLIST_CRAFTSHOP",
		icon = "Interface\\Icons\\INV_Misc_Book_09", slash = "/mh craftshop",
		open = function() if ns.ShowCraftShoppingList then ns.ShowCraftShoppingList() end end,
	},
	{
		nameKey = "KEYBLOCK_TITLE", descKey = "TOOLLP_KEYBLOCK_DESC",
		icon = "Interface\\Icons\\INV_Misc_Gear_01", slash = "/mh block",
		open = function() if ns.ShowKeyBlock then ns.ShowKeyBlock() end end,
	},
	-- Command audit, 6 Oct 2026 (docs/COMMANDS_AUDIT_2026-10-06.md; Rob: all four groups). Names and descriptions
	-- reuse keys the packs already translate (the window's own title, the command list's line).
	{
		nameKey = "STATS_TITLE", descKey = "CMDLIST_STATS",
		icon = "Interface\\Icons\\Achievement_Character_Human_Male", slash = "/mh stats",
		open = function() if ns.ShowStatCoach then ns.ShowStatCoach() end end,
	},
	{
		nameKey = "PAWN_TITLE", descKey = "CMDLIST_PAWN",
		icon = "Interface\\Icons\\INV_Misc_Coin_01", slash = "/mh pawn",
		open = function() if ns.ShowPawnExport then ns.ShowPawnExport() end end,
	},
	{
		nameKey = "KEYBIND_EXPORT_TITLE", descKey = "CMDLIST_BINDS",
		icon = "Interface\\Icons\\Trade_Engineering", slash = "/mh binds",
		open = function() if ns.ShowKeybindExport then ns.ShowKeybindExport() end end,
	},
	{
		nameKey = "CURIO_TITLE", descKey = "CMDLIST_CURIOINFO",
		icon = "Interface\\Icons\\INV_Misc_QuestionMark", slash = "/mh curioinfo",
		open = function() if ns.ShowCurioExplain then ns.ShowCurioExplain() end end,
	},
	{
		nameKey = "FPS_TITLE", descKey = "CMDLIST_FPS",
		icon = "Interface\\Icons\\INV_Misc_PocketWatch_01", slash = "/mh fps",
		open = function() if ns.MH_ShowFpsPanel then ns.MH_ShowFpsPanel() end end,
	},
	-- ✅ 10 Sep 2026 (Spec 33 §2c): this hall named every helper but not the Macros tab, so the
	-- one place that lists what the addon offers skipped a whole page of it.
	{
		nameKey = "TAB_MACROS", descKey = "TOOLLP_MACROS_DESC",
		icon = "Interface\\Icons\\INV_Misc_Note_01", slash = "/mh macros",
		open = function()
			if ns.ShowMainUI then ns:ShowMainUI() end
			if ns.SelectTab then ns.SelectTab("macros") end
		end,
	},
}

-- Re-apply localized text to a built launchpad (called on locale change, and
-- once more after build so a panel built before the locale resolver still ends
-- up in the right language).
local function RelocalizeLaunchpad()
	local panel = ns._mhLaunchpadPanel
	if not panel or not panel._mhI18n then
		return
	end
	for _, e in ipairs(panel._mhI18n) do
		if e.fs and e.fs.SetText then
			e.fs:SetText(L(e.key))
		end
	end
end
ns.RelocalizeToolsLaunchpad = RelocalizeLaunchpad

function ns.BuildToolsLaunchpad(panel)
	if not panel or panel._mhLaunchpadBuilt then
		return
	end
	panel._mhLaunchpadBuilt = true
	ns._mhLaunchpadPanel = panel
	panel._mhI18n = {}

	-- Record each localizable FontString/Button so RelocalizeLaunchpad can
	-- refresh it when the language changes (or is applied after build).
	local function loc(fs, key)
		if not fs then
			return
		end
		panel._mhI18n[#panel._mhI18n + 1] = { fs = fs, key = key }
		fs:SetText(L(key))
	end

	-- Placeholder van CreateModulePanel verbergen.
	if panel._header then panel._header:Hide() end
	if panel._body then panel._body:Hide() end

	local title = panel:CreateFontString(nil, "OVERLAY", "GameFontHighlightLarge")
	title:SetFontObject(SF("GameFontHighlightLarge"))
	title:SetPoint("TOPLEFT", panel, "TOPLEFT", 14, -14)
	loc(title, "TAB_TOOLSLAUNCH")

	local intro = panel:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	intro:SetFontObject(SF("GameFontHighlightSmall"))
	intro:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -4)
	intro:SetPoint("RIGHT", panel, "RIGHT", -14, 0)
	intro:SetJustifyH("LEFT")
	intro:SetWordWrap(true)
	intro:SetTextColor(0.78, 0.8, 0.85)
	loc(intro, "TOOLLP_INTRO")

	-- The whole page scrolls: cards and the command list in one scroll box. Rob, 6 Oct 2026 (screenshot): with ten
	-- cards the command list's own scroll box was squeezed to nothing, "ik kan eronder niets meer lezen of
	-- doorscrollen". One box for the page grows with every card that is added later.
	local scroll = CreateFrame("ScrollFrame", nil, panel, "UIPanelScrollFrameTemplate")
	scroll:SetPoint("TOPLEFT", intro, "BOTTOMLEFT", 0, -4)
	scroll:SetPoint("BOTTOMRIGHT", panel, "BOTTOMRIGHT", -30, 14)
	local page = CreateFrame("Frame", nil, scroll)
	page:SetSize(math.max(300, (panel:GetWidth() or 600) - 58), 1)
	scroll:SetScrollChild(page)
	scroll:SetScript("OnSizeChanged", function(_, w)
		if w and w > 0 then
			page:SetWidth(w)
		end
	end)

	local CARD_H, CARD_GAP = 50, 10
	local prev
	for _, tool in ipairs(TOOLS) do
		local card = CreateFrame("Button", nil, page)
		card:SetHeight(CARD_H)
		if prev then
			card:SetPoint("TOPLEFT", prev, "BOTTOMLEFT", 0, -CARD_GAP)
		else
			card:SetPoint("TOPLEFT", page, "TOPLEFT", 0, -6)
		end
		card:SetPoint("RIGHT", page, "RIGHT", 0, 0)

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
		loc(openBtn, "SET_BTN_OPEN")
		openBtn:SetScript("OnClick", tool.open)

		local slash = card:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
		slash:SetFontObject(SF("GameFontDisableSmall"))
		slash:SetPoint("RIGHT", openBtn, "LEFT", -10, 0)
		slash:SetText(tool.slash)

		local name = card:CreateFontString(nil, "OVERLAY", "GameFontNormal")
		name:SetFontObject(SF("GameFontNormal"))
		name:SetPoint("TOPLEFT", icon, "TOPRIGHT", 10, -2)
		loc(name, tool.nameKey)

		local desc = card:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
		desc:SetFontObject(SF("GameFontHighlightSmall"))
		desc:SetPoint("TOPLEFT", name, "BOTTOMLEFT", 0, -2)
		desc:SetPoint("RIGHT", slash, "LEFT", -10, 0)
		desc:SetJustifyH("LEFT")
		desc:SetWordWrap(false)
		desc:SetTextColor(0.75, 0.77, 0.82)
		loc(desc, tool.descKey)

		prev = card
	end

	-- Every command, under the five cards. The cards are the tools you open; the
	-- list is everything else the addon answers to, which until now lived only in
	-- the source and half of it not even on the store page.
	local cardsH = 6 + #TOOLS * (CARD_H + CARD_GAP)
	page:SetHeight(cardsH + 10)
	if ns.BuildCommandList then
		ns.BuildCommandList(page, prev, {
			flat = true,
			onHeight = function(h)
				page:SetHeight(cardsH + h + 20)
			end,
		})
	end

	-- Build may have run before the locale resolver set the active pack; re-apply
	-- so the launchpad lands in the right language immediately.
	RelocalizeLaunchpad()
end

-- Refresh on language change (/mh lang ...) and on the post-login locale apply,
-- like every other module.
do
	local orig = ns.RefreshLocaleUI
	function ns:RefreshLocaleUI()
		if orig then
			orig(self)
		end
		RelocalizeLaunchpad()
	end
end
