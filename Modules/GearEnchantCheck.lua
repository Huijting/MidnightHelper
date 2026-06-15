--[[
	Gear Enchant Check (Rob-wens 15 jun, uitgebreid 15 jun #2). Scant je uitgeruste,
	enchantbare slots, vlagt slots zonder enchant, en stelt per slot een Midnight-
	enchant voor op basis van de top-secundaire-stat van je spec (hergebruikt de
	Vault Advisor-stat-weights, ns.VAULT_ADVISOR_SPEC_WEIGHTS).

	Elke suggestie is een klikbare/hoverbare link (tooltip via spell-/item-link).
	Klik op een suggestie → de naam landt in het kopieerveld onderaan, voorge-
	selecteerd voor Ctrl+C (handig voor een Auction House-zoekopdracht) — net als
	het consumables-paneel.

	Bron-posture (never-lie): enchant-namen/IDs uit Wowhead 12.0.7 (research 15 jun,
	zie SESSION_NOTES). Secundaire-stat-enchants (Haste/Crit/Mastery/Vers) zitten op
	RINGEN + een proc-WAPEN. HEAD en FEET hebben tertiary-keuze-enchants (Speed/
	Leech/Avoidance). CHEST geeft primary. LEGS gebruiken Leatherworking-armor-kits
	(Agi/Str) of Tailoring-spellthreads (Int). SHOULDER heeft optionele utility-
	enchants (effect nog te bevestigen, dus geen stat-claim). Het is een stat-
	gematchte suggestie, geen pure BiS — voor min-maxen een class-guide raadplegen.

	Taint-veilig: alleen read-only inventory + spec; geen beschermde calls.
]]

local _, ns = ...

-- Enchantbare uitrustingsslots in 12.0 (slotID → labelglobal). Blizzard-globals
-- zijn al gelokaliseerd, dus geen eigen slotnaam-vertalingen nodig.
local SLOTS = {
	{ id = 16, label = "WEAPONENCHANT_THROWN" }, -- main hand; fallback hieronder
	{ id = 5, label = "CHESTSLOT" },
	{ id = 1, label = "HEADSLOT" },
	{ id = 3, label = "SHOULDERSLOT" },
	{ id = 11, label = "FINGER0SLOT" },
	{ id = 12, label = "FINGER1SLOT" },
	{ id = 8, label = "FEETSLOT" },
	{ id = 7, label = "LEGSSLOT" },
}

-- Enchant-entries. sid = spell-ID (display + tooltip via GetSpellLinkMarkup); ah =
-- exacte item-naam voor de AH-zoekopdracht. Voor LEGS/SHOULDER gebruiken we iid
-- (item-ID) omdat dat fysieke items zijn (kit/spellthread/scroll).
local RING_BY_STAT = {
	haste = { sid = 1236088, ah = "Enchant Ring - Silvermoon's Alacrity" },
	crit = { sid = 1236074, ah = "Enchant Ring - Nature's Fury" },
	mastery = { sid = 1236060, ah = "Enchant Ring - Zul'jin's Mastery" },
	vers = { sid = 1236089, ah = "Enchant Ring - Silvermoon's Tenacity" },
}
local WEAPON_BY_STAT = {
	haste = { sid = 1236067, ah = "Enchant Weapon - Berserker's Rage" },
	crit = { sid = 1236066, ah = "Enchant Weapon - Jan'alai's Precision" },
	mastery = { sid = 1236097, ah = "Enchant Weapon - Arcane Mastery" },
	vers = { sid = 1236081, ah = "Enchant Weapon - Worldsoul Tenacity" },
}
local CHEST_PRIMARY = { sid = 1236069, ah = "Enchant Chest - Mark of the Worldsoul" }

-- HEAD + FEET tertiary-keuze: Speed / Leech / Avoidance.
local HEAD_TERTIARY = {
	{ sid = 1236070, ah = "Enchant Helm - Blessing of Speed" },
	{ sid = 1236055, ah = "Enchant Helm - Hex of Leeching" },
	{ sid = 1236083, ah = "Enchant Helm - Rune of Avoidance" },
}
local FEET_TERTIARY = {
	{ sid = 1236085, ah = "Enchant Boots - Farstrider's Hunt" },
	{ sid = 1236072, ah = "Enchant Boots - Shaladrassil's Roots" },
	{ sid = 1236057, ah = "Enchant Boots - Lynx's Dexterity" },
}
-- LEGS: top-tier kit (Agi/Str) en spellthread (Int).
local LEG_AGISTR = { iid = 244640, ah = "Forest Hunter's Armor Kit" }
local LEG_INT = { iid = 240154, ah = "Arcanoweave Spellthread" }
-- SHOULDER: optionele utility-enchant (effect onbevestigd — geen stat-claim).
local SHOULDER_OPT = { iid = 243962, ah = "Enchant Shoulder - Akil'zon's Swiftness" }

--------------------------------------------------------------------------------
-- Spec top-secundaire-stat (uit de Vault Advisor-weights)
--------------------------------------------------------------------------------

local function SpecWeightKey()
	if not (GetSpecialization and GetSpecializationInfo and UnitClass) then
		return nil
	end
	local specIndex = GetSpecialization()
	if not specIndex then
		return nil
	end
	local specID = GetSpecializationInfo(specIndex)
	local classFile = select(2, UnitClass("player"))
	if not (specID and classFile) then
		return nil
	end
	return ("%s_%d"):format(classFile, specID)
end

-- Levert "haste"/"crit"/"mastery"/"vers" of nil.
local function TopStat()
	local key = SpecWeightKey()
	local w = key and ns.VAULT_ADVISOR_SPEC_WEIGHTS and ns.VAULT_ADVISOR_SPEC_WEIGHTS[key]
	if not w then
		return nil
	end
	local best, bestStat
	for _, stat in ipairs({ "haste", "crit", "mastery", "vers" }) do
		local v = w[stat]
		if v and (not best or v > best) then
			best, bestStat = v, stat
		end
	end
	return bestStat
end

--------------------------------------------------------------------------------
-- Inventory-scan
--------------------------------------------------------------------------------

-- true(item aanwezig), enchanted(bool) — uit de enchantID in de item-link.
local function SlotState(slotId)
	local link = GetInventoryItemLink and GetInventoryItemLink("player", slotId)
	if not link then
		return false, false
	end
	local enchantID = link:match("item:%d+:(%d*)")
	local has = enchantID and enchantID ~= "" and enchantID ~= "0"
	return true, has and true or false
end

--------------------------------------------------------------------------------
-- Link-rendering + AH-naam-registratie
--------------------------------------------------------------------------------

-- Rendert een enchant-entry als klikbare link en registreert de AH-naam onder
-- de link-key ("spell:ID" / "item:ID") in `map` zodat een klik 'm kan kopiëren.
local function LinkOf(map, e)
	if not e then
		return "?"
	end
	if e.sid then
		if map then
			map["spell:" .. e.sid] = e.ah
		end
		if ns.GetSpellLinkMarkup then
			return ns:GetSpellLinkMarkup(e.sid, e.ah)
		end
		return e.ah or ("spell " .. tostring(e.sid))
	elseif e.iid then
		if map then
			map["item:" .. e.iid] = e.ah
		end
		if ns.GetItemLinkMarkup then
			return ns:GetItemLinkMarkup(e.iid, e.ah)
		end
		return e.ah or ("item " .. tostring(e.iid))
	end
	return e.ah or "?"
end

-- Aanbevolen enchant-tekst (gerenderde links) per slot, of nil = geen suggestie.
local function Recommend(slotId, stat, map)
	if slotId == 16 then
		return stat and WEAPON_BY_STAT[stat] and LinkOf(map, WEAPON_BY_STAT[stat]) or nil
	elseif slotId == 11 or slotId == 12 then
		return stat and RING_BY_STAT[stat] and LinkOf(map, RING_BY_STAT[stat]) or nil
	elseif slotId == 5 then
		return LinkOf(map, CHEST_PRIMARY)
	elseif slotId == 1 then -- head: tertiary keuze
		local parts = {}
		for _, e in ipairs(HEAD_TERTIARY) do
			parts[#parts + 1] = LinkOf(map, e)
		end
		return ns:L("ENCHANT_PICK") .. " " .. table.concat(parts, " / ")
	elseif slotId == 8 then -- feet: tertiary keuze
		local parts = {}
		for _, e in ipairs(FEET_TERTIARY) do
			parts[#parts + 1] = LinkOf(map, e)
		end
		return ns:L("ENCHANT_PICK") .. " " .. table.concat(parts, " / ")
	elseif slotId == 7 then -- legs: kit (Agi/Str) of spellthread (Int)
		return ns:L("ENCHANT_LEGS_AGISTR")
			.. " "
			.. LinkOf(map, LEG_AGISTR)
			.. "   "
			.. ns:L("ENCHANT_LEGS_INT")
			.. " "
			.. LinkOf(map, LEG_INT)
	end
	return nil
end

--------------------------------------------------------------------------------
-- Rapport-regels (gedeeld door paneel + /mh enchants)
--------------------------------------------------------------------------------

-- @param map table|nil  ontvangt link-key → AH-naam (alleen nodig voor 't paneel)
-- @return table lines
local function BuildReportLines(map)
	local lines = {}
	local stat = TopStat()
	local statLabel = stat and ns:L("ENCHANT_STAT_" .. string.upper(stat)) or "?"
	lines[#lines + 1] = "|cffffd100" .. ns:L("ENCHANT_HEADER_FMT"):format(statLabel) .. "|r"
	for _, s in ipairs(SLOTS) do
		local hasItem, enchanted = SlotState(s.id)
		if hasItem then
			local label = (s.id == 16 and (_G.WEAPON or "Weapon")) or _G[s.label] or s.label
			if s.id == 3 then
				-- Shoulder: optioneel. Toon altijd de optionele utility-suggestie,
				-- geen rode MISSING-alarm (effect onbevestigd → geen stat-claim).
				local rec = LinkOf(map, SHOULDER_OPT)
				lines[#lines + 1] = ("|cffc8b88a%s — %s %s|r"):format(label, ns:L("ENCHANT_SHOULDER_OPT"), rec)
			elseif enchanted then
				lines[#lines + 1] = ("|cff73d873%s — %s|r"):format(label, ns:L("ENCHANT_OK"))
			else
				local rec = Recommend(s.id, stat, map)
				local tail = rec and ("  " .. ns:L("ENCHANT_RECOMMEND") .. " " .. rec) or ""
				lines[#lines + 1] = ("|cffff5555%s — %s|r%s"):format(label, ns:L("ENCHANT_MISSING"), tail)
			end
		end
	end
	lines[#lines + 1] = "|cff9aa0a8" .. ns:L("ENCHANT_FOOTER") .. "|r"
	return lines
end

-- /mh enchants (blijft als handig commando; standaard-route is het paneel).
function ns.PrintGearEnchantCheck()
	print(("|cffffcc00%s|r"):format(ns:L("PRINT_PREFIX")))
	for _, line in ipairs(BuildReportLines(nil)) do
		print("  " .. line)
	end
end

--------------------------------------------------------------------------------
-- Paneel (tab "enchants")
--------------------------------------------------------------------------------

local ui

function ns.RefreshGearEnchantPanel()
	if not (ui and ui.body) then
		return
	end
	ui.linkAH = ui.linkAH or {}
	wipe(ui.linkAH)
	ui.body:SetText(table.concat(BuildReportLines(ui.linkAH), "|n"))
end

function ns.BuildGearEnchantPanel(panel)
	if not panel or panel._mhEnchantBuilt then
		return
	end
	panel._mhEnchantBuilt = true
	if panel._body then
		panel._body:Hide()
	end
	if panel._header then
		panel._header:Hide()
	end

	local title = panel:CreateFontString(nil, "OVERLAY", "GameFontHighlightLarge")
	title:SetPoint("TOPLEFT", panel, "TOPLEFT", 14, -12)
	title:SetText(ns:L("TAB_ENCHANTS"))

	local subtitle = panel:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	subtitle:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -4)
	subtitle:SetPoint("RIGHT", panel, "RIGHT", -14, 0)
	subtitle:SetJustifyH("LEFT")
	subtitle:SetWordWrap(true)
	subtitle:SetTextColor(0.75, 0.78, 0.82)
	subtitle:SetText(ns:L("ENCHANT_SUBTITLE"))

	-- Kopieerbalk onderaan (consumables-patroon): klik een suggestie → naam hier,
	-- voorgeselecteerd voor Ctrl+C (AH-zoekopdracht).
	local copyLabel = panel:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
	copyLabel:SetPoint("BOTTOMLEFT", panel, "BOTTOMLEFT", 14, 16)
	copyLabel:SetJustifyH("LEFT")
	copyLabel:SetText(ns:L("ENCHANT_COPY_LABEL"))
	copyLabel:SetTextColor(0.62, 0.60, 0.55)

	local copyBox = CreateFrame("EditBox", "MidnightHelperEnchantCopyBox", panel, "InputBoxTemplate")
	copyBox:SetHeight(20)
	copyBox:SetPoint("LEFT", copyLabel, "RIGHT", 10, 0)
	copyBox:SetPoint("RIGHT", panel, "RIGHT", -18, 0)
	copyBox:SetAutoFocus(false)
	copyBox:SetScript("OnEscapePressed", function(self)
		self:ClearFocus()
	end)
	copyBox:SetScript("OnEditFocusGained", function(self)
		self:HighlightText()
	end)

	-- Read-only EditBox → klikbare/hoverbare enchant-links.
	local body = CreateFrame("EditBox", nil, panel)
	body:SetMultiLine(true)
	body:SetFontObject("GameFontHighlightSmall")
	body:SetJustifyH("LEFT")
	body:SetAutoFocus(false)
	body:EnableMouse(true)
	body:SetSpacing(4)
	if body.SetMaxLetters then
		body:SetMaxLetters(0)
	end
	body:SetPoint("TOPLEFT", subtitle, "BOTTOMLEFT", 0, -12)
	body:SetPoint("BOTTOMRIGHT", panel, "BOTTOMRIGHT", -16, 42)
	body:SetScript("OnEscapePressed", body.ClearFocus)
	if ns.AttachDelveTipHyperlinksToEditBox then
		ns:AttachDelveTipHyperlinksToEditBox(body)
	end

	ui = { panel = panel, title = title, subtitle = subtitle, body = body, copyBox = copyBox, copyLabel = copyLabel, linkAH = {} }

	-- Klik op een enchant-link → AH-naam naar de kopieerbalk (val terug op de
	-- tooltip-handler als we de link niet kennen).
	body:SetScript("OnHyperlinkClick", function(_, linkData)
		local name = ui.linkAH and ui.linkAH[linkData]
		if name and name ~= "" then
			copyBox:SetText(name)
			copyBox:SetFocus()
			copyBox:HighlightText()
		end
	end)

	panel:SetScript("OnShow", function()
		ns.RefreshGearEnchantPanel()
	end)

	local ev = CreateFrame("Frame")
	ev:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")
	ev:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED")
	ev:SetScript("OnEvent", function()
		if ui and ui.panel and ui.panel:IsShown() then
			ns.RefreshGearEnchantPanel()
		end
	end)

	ns.RefreshGearEnchantPanel()
end

-- Titel/subtitel meeverversen bij taalwissel.
do
	local orig = ns.RefreshLocaleUI
	function ns:RefreshLocaleUI()
		if orig then
			orig(self)
		end
		if ui and ui.title then
			ui.title:SetText(ns:L("TAB_ENCHANTS"))
			ui.subtitle:SetText(ns:L("ENCHANT_SUBTITLE"))
			if ui.copyLabel then
				ui.copyLabel:SetText(ns:L("ENCHANT_COPY_LABEL"))
			end
			if ui.panel and ui.panel:IsShown() then
				ns.RefreshGearEnchantPanel()
			end
		end
	end
end
