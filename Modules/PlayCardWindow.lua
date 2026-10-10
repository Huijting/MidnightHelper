--[[
	Midnight Helper — the "How you play" card in its own window.

	Rob, 25 Sep 2026, after reading the Prot card inside the Academy: "ze zijn nu veelste verstopt en
	lastig te lezen ... in die lange lap met tekst". He chose a small movable window of its own (so it
	can stay open beside a target dummy) with the spell's icon in front of every step.

	The card data comes from Modules/PlayCards.lua (ns.GetPlayCard); this file only draws it.
	Opened with /mh play, and from a button in the Academy.

	Layout, top to bottom: one icon button per spec of the player's class (the active one lit),
	the idea, the numbered steps with icons, "More enemies", "Biggest mistake", the hero lines,
	and the dated source. The height follows the content; nothing scrolls.
]]

local _, ns = ...

local WIN_NAME = "MidnightHelperPlayCardWindow"
local WIDTH = 500 -- 460 until 26 Sep 2026; four tabs did not fit
local PAD = 16
local ICON = 30
local SPEC_ICON = 26

local win
local chosenSpec -- nil = follow the active spec

local function L(key)
	if ns.SafeL then
		return ns:SafeL(key)
	end
	return ns:L(key)
end

local function Font(fs, base)
	if ns.MHScalableFont then
		pcall(function() fs:SetFontObject(ns.MHScalableFont(base)) end)
	else
		fs:SetFontObject(base)
	end
end

local function ActiveSpecID()
	if not (ns.GetSpecialization and ns.GetSpecializationInfo) then
		return nil
	end
	local idx = ns.GetSpecialization()
	if not idx then
		return nil
	end
	return (ns.GetSpecializationInfo(idx))
end

--- The specs of the player's own class: { {id, name, icon}, ... }.
local function ClassSpecs()
	local out = {}
	if not (GetNumSpecializations and ns.GetSpecializationInfo) then
		return out
	end
	for i = 1, (GetNumSpecializations() or 0) do
		local id, name, _, icon = ns.GetSpecializationInfo(i)
		if id then
			out[#out + 1] = { id = id, name = name or "", icon = icon }
		end
	end
	return out
end

local function SpecName(specID)
	if GetSpecializationInfoByID then
		local ok, _, name = pcall(GetSpecializationInfoByID, specID)
		if ok and name and name ~= "" then
			return name
		end
	end
	return ""
end

local function SpellIcon(spellID)
	if not spellID then
		return nil
	end
	if C_Spell and C_Spell.GetSpellTexture then
		local ok, tex = pcall(C_Spell.GetSpellTexture, spellID)
		if ok and tex then
			return tex
		end
	end
	return nil
end

--- Spell names on the card are |Hspell:id|h links (PlayCards.lua). A frame with hyperlinks enabled
--- fires OnHyperlinkEnter for links in its own font strings, so each name gets its own tooltip.
--- (DelveTipMarkup.lua uses an EditBox because links fail inside ScrollFrames; this window has none.)
local function HookLinks(frame)
	if frame._mhLinks or not frame.SetHyperlinksEnabled then
		return
	end
	frame._mhLinks = true
	frame:SetHyperlinksEnabled(true)
	frame:SetScript("OnHyperlinkEnter", function(self, link)
		if not (GameTooltip and link) then
			return
		end
		GameTooltip:SetOwner(self, "ANCHOR_CURSOR")
		pcall(GameTooltip.SetHyperlink, GameTooltip, link)
		GameTooltip:Show()
	end)
	frame:SetScript("OnHyperlinkLeave", function()
		if GameTooltip then
			GameTooltip:Hide()
		end
	end)
end

--- A frame that takes the mouse (for its links) would otherwise swallow the drag, and Rob had just
--- reported "ik kan het scherm niet verslepen". Pass the drag on to the window.
local function ForwardDrag(frame)
	frame:RegisterForDrag("LeftButton")
	frame:SetScript("OnDragStart", function()
		if ns.IsMidnightDialogDocked and ns.IsMidnightDialogDocked(win) and ns.SetMidnightDialogDocked then
			ns.SetMidnightDialogDocked(win, false)
		end
		win:StartMoving()
	end)
	frame:SetScript("OnDragStop", function()
		local stop = win:GetScript("OnDragStop")
		if stop then
			stop(win)
		else
			win:StopMovingOrSizing()
		end
	end)
end

--------------------------------------------------------------------------------
-- Pooled widgets. Everything lives on `win.body` and is reused on every redraw.
--------------------------------------------------------------------------------

local function Text(i, base)
	win._texts[i] = win._texts[i] or win.body:CreateFontString(nil, "OVERLAY", base)
	local fs = win._texts[i]
	Font(fs, base)
	fs:SetJustifyH("LEFT")
	fs:SetWordWrap(true)
	fs:SetSpacing(2)
	fs:ClearAllPoints()
	fs:Show()
	return fs
end

--- One step row: a number, the spell's icon, and the text. Hover shows the spell's tooltip.
local function StepRow(i)
	local row = win._rows[i]
	if not row then
		row = CreateFrame("Frame", nil, win.body)
		row.num = row:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
		row.num:SetPoint("TOPLEFT", row, "TOPLEFT", 0, -6)
		row.num:SetWidth(18)
		row.num:SetJustifyH("LEFT")
		row.num:SetTextColor(1, 0.8, 0)
		row.icon = row:CreateTexture(nil, "ARTWORK")
		row.icon:SetSize(ICON, ICON)
		row.icon:SetPoint("TOPLEFT", row, "TOPLEFT", 20, 0)
		row.icon:SetTexCoord(0.07, 0.93, 0.07, 0.93)
		-- The key this spell is on right now, on the icon like an action button's hotkey
		-- (Rob, 27 Sep 2026). Filled by StepIcon; hidden where there is no live key to show.
		row.key = row:CreateFontString(nil, "OVERLAY", "NumberFontNormal")
		row.key:SetPoint("TOPRIGHT", row.icon, "TOPRIGHT", 1, -1)
		row.key:SetJustifyH("RIGHT")
		row.key:Hide()
		row.fs = row:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
		row.fs:SetJustifyH("LEFT")
		row.fs:SetWordWrap(true)
		row.fs:SetSpacing(2)
		-- The icon has its own hover spot (the step's first spell); the names in the text are links
		-- with their own tooltips. Two tooltips for one row fought each other when both sat on the row.
		row.iconHit = CreateFrame("Frame", nil, row)
		row.iconHit:SetAllPoints(row.icon)
		row.iconHit:EnableMouse(true)
		row.iconHit:SetScript("OnEnter", function(self)
			if not GameTooltip then
				return
			end
			if row.itemID and GameTooltip.SetItemByID then
				GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
				GameTooltip:SetItemByID(row.itemID)
				GameTooltip:Show()
				return
			end
			local id = row.spellID
			if not (id and GameTooltip.SetSpellByID) then
				return
			end
			GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
			GameTooltip:SetSpellByID(id)
			if row.liveKey ~= nil then
				GameTooltip:AddLine(" ")
				if row.liveKey then
					GameTooltip:AddLine((L("PLAYCARD_KEY_FMT")):format(row.liveKey), 1, 0.82, 0.2)
				else
					GameTooltip:AddLine(L("PLAYCARD_KEY_NONE"), 0.62, 0.62, 0.62, true)
				end
			end
			GameTooltip:Show()
		end)
		row.iconHit:SetScript("OnLeave", function()
			if GameTooltip then
				GameTooltip:Hide()
			end
		end)
		row:EnableMouse(true)
		HookLinks(row)
		ForwardDrag(row)
		win._rows[i] = row
	end
	-- Row 10+ in the large font is wider than the 18 px number column and showed as "..."
	-- (Rob's Prot Paladin Stay alive, 4 Oct 2026: 11 rows). Two digits get the normal font.
	Font(row.num, i >= 10 and "GameFontNormal" or "GameFontNormalLarge")
	Font(row.fs, "GameFontHighlight")
	row:ClearAllPoints()
	row:Show()
	return row
end

local function SpecButton(i)
	local b = win._specBtns[i]
	if not b then
		b = CreateFrame("Button", nil, win.body)
		b:SetSize(SPEC_ICON, SPEC_ICON)
		b.tex = b:CreateTexture(nil, "ARTWORK")
		b.tex:SetAllPoints()
		b.tex:SetTexCoord(0.07, 0.93, 0.07, 0.93)
		b.ring = b:CreateTexture(nil, "OVERLAY")
		b.ring:SetPoint("TOPLEFT", -3, 3)
		b.ring:SetPoint("BOTTOMRIGHT", 3, -3)
		b.ring:SetColorTexture(1, 0.82, 0.2, 0.9)
		b.ring:SetDrawLayer("BACKGROUND")
		b:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Square", "ADD")
		b:SetScript("OnEnter", function(self)
			if GameTooltip then
				GameTooltip:SetOwner(self, "ANCHOR_TOP")
				GameTooltip:SetText(self.specName or "")
				GameTooltip:Show()
			end
		end)
		b:SetScript("OnLeave", function()
			if GameTooltip then
				GameTooltip:Hide()
			end
		end)
		win._specBtns[i] = b
	end
	b:Show()
	return b
end

--- Which tab is open, remembered per account so the window reopens where you left it.
local function CurrentTab()
	local ui = ns.db and ns.db.ui
	local t = ui and ui.playCardTab
	return (t == "alive" or t == "cons" or t == "dispel" or t == "group") and t or "play"
end

local function SetTab(id)
	if ns.db then
		ns.db.ui = ns.db.ui or {}
		ns.db.ui.playCardTab = id
	end
end

local function TabButton(i)
	win._tabBtns = win._tabBtns or {}
	local b = win._tabBtns[i]
	if not b then
		b = CreateFrame("Button", nil, win.body)
		b:SetHeight(26)
		b.fs = b:CreateFontString(nil, "OVERLAY", "GameFontNormal")
		b.fs:SetPoint("CENTER", b, "CENTER", 0, 1)
		b.line = b:CreateTexture(nil, "ARTWORK")
		b.line:SetColorTexture(1, 0.82, 0.2, 0.9)
		b.line:SetHeight(2)
		b.line:SetPoint("BOTTOMLEFT", b, "BOTTOMLEFT", 4, 0)
		b.line:SetPoint("BOTTOMRIGHT", b, "BOTTOMRIGHT", -4, 0)
		b:SetHighlightTexture("Interface\\Buttons\\UI-Listbox-Highlight2", "ADD")
		win._tabBtns[i] = b
	end
	Font(b.fs, "GameFontNormalSmall")
	b:Show()
	return b
end

--- Below max level the cards advise spells the character may not have yet (Rob, 25 Sep 2026, on a
--- level 26 Druid). Then: a line saying the card is written for max level, and on your OWN active spec
--- the spells you do not have yet go grey. Only there: for another spec, "known" answers for the spec
--- you are in, so greying would lie. At max level nothing greys, because some card buttons only exist
--- while a proc has turned another button into them, and those would read as missing.
local function Greying(specID)
	local max = ns.PlayCardMaxLevel and ns.PlayCardMaxLevel() or 90
	local low = (UnitLevel and UnitLevel("player") or max) < max
	local grey = low and specID ~= nil and specID == ActiveSpecID() and ns.PlayCardKnowsSpell or nil
	return low, grey, max
end

--- The "written for level 90" line. Returns the new y and the text-pool index it used.
local function LevelBanner(y, t, inner, low, grey, max)
	if not low then
		return y, t
	end
	t = t + 1
	local fs = Text(t, "GameFontHighlight")
	fs:SetWidth(inner)
	fs:SetPoint("TOPLEFT", win.body, "TOPLEFT", 0, y)
	fs:SetTextColor(0.55, 0.78, 1)
	fs:SetText((L("PLAYCARD_LEVEL_FMT")):format(max) .. (grey and (" " .. L("PLAYCARD_GREY_HINT")) or ""))
	return y - fs:GetStringHeight() - 10, t
end

--- "s-3" -> "Shift 3": the short key the icon badge uses, written out for a sentence.
local function ReadableKey(short)
	if type(short) ~= "string" then
		return nil
	end
	local mod, base = short:match("^(%a)%-(.+)$")
	local word = mod and ({ s = "Shift", c = "Ctrl", a = "Alt" })[mod:lower()]
	return word and (word .. " " .. base) or short
end

--- Every spell name the card colours (|cffffd100Name|r) gets the key it is really on, right behind it.
--- Rob, 5 Oct 2026, first time on a healer: the card named Divine Toll, Holy Shock, Word of Glory … but
--- only the first icon of a line carried a key ("s-3", "a-R"), so "with my buttons I understand nothing".
--- Only names the client resolves to a spell this character has, and only keys found on its bars.
local function WithKeys(text)
	if type(text) ~= "string" or not ns.LiveKeyForSpell or not (C_Spell and C_Spell.GetSpellInfo) then
		return text
	end
	return (text:gsub("(|c[fF][fF][fF][fF][dD]100)(.-)(|r)", function(open, name, close)
		local ok, info = pcall(C_Spell.GetSpellInfo, name)
		local id = ok and type(info) == "table" and info.spellID
		local key = id and ReadableKey((ns.LiveKeyForSpell(id)))
		if key then
			return open .. name .. close .. " |cffffffff[" .. key .. "]|r"
		end
		return open .. name .. close
	end))
end

--- A step's icon, greyed like its name when the character does not have that spell yet.
--- `live`: show the key the spell is really on (only for your active spec; another spec's
--- spells are not on your bars, so a "not on your bars" there would be noise).
local function StepIcon(row, id, grey, live)
	local tex = SpellIcon(id)
	row.icon:SetTexture(tex)
	row.icon:SetShown(tex ~= nil)
	local missing = grey and id and not grey(id)
	row.icon:SetDesaturated(missing and true or false)
	row.icon:SetAlpha(missing and 0.55 or 1)
	row.num:SetTextColor(missing and 0.55 or 1, missing and 0.55 or 0.8, missing and 0.55 or 0)
	row.spellID = id
	row.itemID = nil
	row.liveKey = nil
	row.key:Hide()
	if live and id and tex and ns.LiveKeyForSpell then
		local key = ns.LiveKeyForSpell(id)
		row.liveKey = key or false
		if key then
			row.key:SetText(key)
			row.key:SetTextColor(1, 1, 1)
		else
			-- Not on a bound button: a grey dash, the tooltip says why.
			row.key:SetText("-")
			row.key:SetTextColor(0.62, 0.62, 0.62)
		end
		row.key:Show()
	end
	return missing
end

--------------------------------------------------------------------------------
-- The Consumables tab (Rob, 26 Sep 2026: "het tabbladje voor onze consumables ... zodat we die
-- makkelijk en snel terug kunnen vinden, zonder in een lange lijst te moeten zoeken"). Same data as
-- the Consumables page (ns.ConsumablesWowheadByClassSpec via ns.MH_GetConsumablesWowheadForSpec):
-- per category the recommended item, its icon, how many you carry, and the alternatives.
--------------------------------------------------------------------------------

local CONS_CATEGORIES = {
	{ key = "flask", labelKey = "GUIDE_CONS_TYPE_FLASK" },
	{ key = "combatPotion", labelKey = "GUIDE_CONS_TYPE_COMBAT" },
	{ key = "healingPotion", labelKey = "GUIDE_CONS_TYPE_HEALING" },
	{ key = "weaponOil", labelKey = "GUIDE_CONS_TYPE_WEAPON" },
	{ key = "augmentRune", labelKey = "GUIDE_CONS_TYPE_RUNE" },
	{ key = "personalFood", labelKey = "GUIDE_CONS_TYPE_FOOD" },
	{ key = "feast", labelKey = "GUIDE_CONS_TYPE_FEAST" },
}

--- The consumables table is keyed by class token + spec INDEX; the window works in spec ids.
local function SpecIndexOf(specID)
	if not (specID and GetNumSpecializations and ns.GetSpecializationInfo) then
		return nil
	end
	for i = 1, (GetNumSpecializations() or 0) do
		if ns.GetSpecializationInfo(i) == specID then
			return i
		end
	end
	return nil
end

--- Name of an item, or nil while the client has not loaded it yet (then it is asked for, and the
--- window redraws on GET_ITEM_INFO_RECEIVED).
local function ItemName(id)
	local n = C_Item and C_Item.GetItemNameByID and C_Item.GetItemNameByID(id)
	if (not n or n == "") and GetItemInfo then
		n = GetItemInfo(id)
	end
	if n and n ~= "" then
		return n
	end
	if C_Item and C_Item.RequestLoadItemDataByID then
		pcall(C_Item.RequestLoadItemDataByID, id)
	end
	return nil
end

--- The item as a link in its quality colour, so hovering the name shows its tooltip.
local function ItemLink(id)
	local name = ItemName(id) or "..."
	local hex = "ffffffff"
	local q = C_Item and C_Item.GetItemQualityByID and C_Item.GetItemQualityByID(id)
	if q and GetItemQualityColor then
		local ok, _, _, _, h = pcall(GetItemQualityColor, q)
		if ok and type(h) == "string" and #h == 8 then
			hex = h
		end
	end
	return ("|c%s|Hitem:%d|h%s|h|r"):format(hex, id, name)
end

local function BagCount(ids)
	local count = (C_Item and C_Item.GetItemCount) or GetItemCount
	local n = 0
	for _, id in ipairs(ids or {}) do
		local ok, c = pcall(count, id)
		if ok and type(c) == "number" then
			n = n + c
		end
	end
	return n
end

--------------------------------------------------------------------------------
-- The Dispel tab (Rob, 26 Sep 2026: "Ik weet nooit wat ik kan dispellen of weghalen bij vijanden, maar
-- ook bij de friendlies"). Three parts: what you remove from your group, what you take off enemies, and
-- the debuffs in Midnight's dungeons and raid that are removable, marked where YOU can do it.
-- ⚠️ Static knowledge only. Since 12.0 an addon cannot read auras on other players or enemies, so this
-- tab never claims something is on someone right now; it says what you COULD remove, and where.
--------------------------------------------------------------------------------

--- Taking a buff off an ENEMY. Ids from Modules/DispelHelper.lua (ns.OFFENSIVE_PURGES, each with two
--- sources) plus Soothe. Demon Hunter's Consume Magic has two candidate ids in our own data (278326 in
--- DispelHelper, 1277738 in KeybindRoles_DemonHunter); whichever this character knows is shown.
local ENEMY_DISPELS = {
	PRIEST = { { ids = { 528 }, what = "PLAYCARD_PURGE_MAGIC" } },
	MAGE = { { ids = { 30449 }, what = "PLAYCARD_PURGE_STEAL" } },
	SHAMAN = { { ids = { 370, 378773 }, what = "PLAYCARD_PURGE_MAGIC" } }, -- Purge or Greater Purge (one choice node, spec audit 10 Oct 2026)
	HUNTER = { { ids = { 19801 }, what = "PLAYCARD_PURGE_BOTH" } },
	DRUID = { { ids = { 2908 }, what = "PLAYCARD_PURGE_ENRAGE" } },
	DEMONHUNTER = { { ids = { 278326, 1277738 }, what = "PLAYCARD_PURGE_MAGIC" } },
}

--- Removable debuffs (and one boss buff) in Midnight's dungeons and raid, from the installed DBM boss
--- mods: only entries where DBM names the TYPE (Remove<Type> / MagicDispeller). Instance and boss names
--- come from the client (GetRealZoneText / EJ_GetEncounterInfo), so they read in the player's language.
--- Untyped DBM "helpdispel" entries (Glacial Torment 1235548, Icebound Flames 1286922) are left out on
--- purpose: guessing their type is the mistake BOSS_HEAL_LENS already refused to make.
local SEASON_DISPELS = {
	{ zone = 3004, ej = 2883, id = 1282281, type = "poison" }, -- The Coiled Altar, Venomfang (TheCoiledAltar.lua:35)
	{ zone = 3004, ej = 2895, id = 1301800, type = "poison" }, -- Ula'tek, Acidic Burst from Blightscale Vipers (Ulatek.lua:58)
	{ zone = 2993, id = 1307571, type = "poison" }, -- Altar of Fangs trash, Envenom (AltarofFangsTrash.lua:16)
	{ zone = 2859, id = 1250937, type = "poison" }, -- The Blinding Vale trash, Toxic Spew (TheBlindingValeTrash.lua:16)
	{ zone = 2874, ej = 2810, id = 1246666, type = "disease" }, -- Muro'jin and Nekraxx, Infected Pinions (MurojinandNekraxx.lua:20)
	{ zone = 2811, ej = 2661, id = 1248689, purge = "magic" }, -- Seranel Sunlash, Hastening Ward on the boss (SeranelSunlash.lua:17)
}

local function ClassToken()
	return UnitClass and select(2, UnitClass("player")) or nil
end

--- Friendly dispels for a spec: the healer's own, else the class list (only what you know, on your own
--- active spec; the whole class list when looking at another spec, since "known" answers for this one).
local function FriendlyDispels(specID)
	local healer = ns.GetHealerDispel and ns.GetHealerDispel(specID)
	if healer then
		return { healer }
	end
	if specID == ActiveSpecID() and ns.GetKnownClassDispels then
		return ns.GetKnownClassDispels()
	end
	return (ns.NONHEALER_DISPELS and ns.NONHEALER_DISPELS[ClassToken() or ""]) or {}
end

local function EnemyDispels(specID)
	local out = {}
	local own = specID == ActiveSpecID()
	for _, e in ipairs(ENEMY_DISPELS[ClassToken() or ""] or {}) do
		local pick
		for _, id in ipairs(e.ids) do
			if not own or (ns.PlayCardKnowsSpell and ns.PlayCardKnowsSpell(id)) then
				pick = id
				break
			end
		end
		if pick then
			out[#out + 1] = { id = pick, what = e.what }
		end
	end
	return out
end

local function SpellLink(id)
	return ns.ExpandPlayCardText and (ns.ExpandPlayCardText("{SPELL:" .. id .. "}")) or tostring(id)
end

local function DrawDispel(specID, y, inner)
	local t = 0
	local function Head(key)
		t = t + 1
		local fs = Text(t, "GameFontNormal")
		fs:SetWidth(inner)
		fs:SetPoint("TOPLEFT", win.body, "TOPLEFT", 0, y)
		fs:SetTextColor(1, 0.82, 0.4)
		fs:SetText(L(key))
		y = y - fs:GetStringHeight() - 8
	end
	local function Line(text, dim)
		t = t + 1
		local fs = Text(t, "GameFontHighlight")
		fs:SetWidth(inner)
		fs:SetPoint("TOPLEFT", win.body, "TOPLEFT", 0, y)
		if dim then
			fs:SetTextColor(0.62, 0.6, 0.56)
		else
			fs:SetTextColor(0.9, 0.88, 0.82)
		end
		fs:SetText(text)
		y = y - fs:GetStringHeight() - 8
	end
	local r = 0
	local function Row(id, second)
		r = r + 1
		local row = StepRow(r)
		row:SetPoint("TOPLEFT", win.body, "TOPLEFT", 0, y)
		row:SetWidth(inner)
		row.num:SetText("")
		StepIcon(row, id, nil)
		row.fs:ClearAllPoints()
		row.fs:SetPoint("TOPLEFT", row, "TOPLEFT", 20 + ICON + 10, -2)
		row.fs:SetWidth(inner - (20 + ICON + 10))
		row.fs:SetTextColor(0.9, 0.88, 0.82)
		row.fs:SetText(SpellLink(id) .. "|n" .. second)
		local h = math.max(ICON, row.fs:GetStringHeight() + 4)
		row:SetHeight(h)
		y = y - h - 10
	end

	-- 1. From your group.
	Head("PLAYCARD_DISPEL_FRIENDS")
	local friendly = FriendlyDispels(specID)
	local canTypes = {}
	for _, d in ipairs(friendly) do
		Row(d.id, ns.FormatDispelTypes and ns.FormatDispelTypes(d.types) or "")
		for _, ty in ipairs(d.types or {}) do
			canTypes[ty] = true
		end
	end
	if #friendly == 0 then
		Line(L("PLAYCARD_DISPEL_NONE_FRIENDS"), true)
	end

	-- 2. From enemies.
	y = y - 4
	Head("PLAYCARD_DISPEL_ENEMIES")
	local enemy = EnemyDispels(specID)
	for _, e in ipairs(enemy) do
		Row(e.id, L(e.what))
	end
	if #enemy == 0 then
		Line(L("PLAYCARD_DISPEL_NONE_ENEMIES"), true)
	end
	local canPurgeMagic = false
	for _, e in ipairs(enemy) do
		if e.what ~= "PLAYCARD_PURGE_ENRAGE" then
			canPurgeMagic = true
		end
	end

	-- 3. Where it matters in Midnight's dungeons and raid.
	y = y - 4
	Head("PLAYCARD_DISPEL_SEASON")
	for _, s in ipairs(SEASON_DISPELS) do
		local zone = GetRealZoneText and GetRealZoneText(s.zone)
		if not zone or zone == "" then
			zone = "?"
		end
		local where = zone
		if s.ej and EJ_GetEncounterInfo then
			local ok, bossName = pcall(EJ_GetEncounterInfo, s.ej)
			if ok and bossName and bossName ~= "" then
				where = zone .. " - " .. bossName
			end
		else
			where = zone .. " (" .. L("PLAYCARD_DISPEL_TRASH") .. ")"
		end
		local you, what
		if s.purge then
			you = canPurgeMagic
			what = L("PLAYCARD_DISPEL_BOSSBUFF")
		else
			you = canTypes[s.type] and true or false
			what = ns.FormatDispelTypes and ns.FormatDispelTypes({ s.type }) or s.type
		end
		local mark = you and ("  |cff8cd98c" .. L("PLAYCARD_DISPEL_YOU") .. "|r") or ""
		Line(("|cff%s%s|r|n%s (%s)%s"):format(you and "ffffff" or "9d9d9d", where, SpellLink(s.id), what, mark), not you)
	end

	-- 4. What MH cannot do, and where the game shows it instead. Labels and paths measured in
	-- Blizzard's own 12.1.0 UI code (build 69933: Blizzard_SettingsDefinitions_Frame, NamePlateAuras,
	-- TargetFrameAuraContainer) and the 12.1.0 GlobalStrings, 26 Sep 2026.
	y = y - 4
	Line(L("PLAYCARD_DISPEL_LIVE_NOTE"), true)
	Line(L("PLAYCARD_DISPEL_TIP_FRIENDS"), false)
	Line(L("PLAYCARD_DISPEL_TIP_ENEMIES"), false)
	return y
end

local function DrawConsumables(specID, y, inner)
	local classToken = UnitClass and select(2, UnitClass("player"))
	local data = ns.MH_GetConsumablesWowheadForSpec and ns.MH_GetConsumablesWowheadForSpec(classToken, SpecIndexOf(specID))
	local t = 1
	local intro = Text(t, "GameFontHighlight")
	intro:SetWidth(inner)
	intro:SetPoint("TOPLEFT", win.body, "TOPLEFT", 0, y)
	intro:SetTextColor(0.62, 0.6, 0.56)
	if not data then
		intro:SetText(L("MACROS_CONS_NO_DATA"))
		return y - intro:GetStringHeight() - 8
	end
	intro:SetText(L("PLAYCARD_CONS_INTRO"))
	y = y - intro:GetStringHeight() - 12
	local i = 0
	for _, def in ipairs(CONS_CATEGORIES) do
		local cat = data[def.key]
		local best = cat and cat.best and cat.best[1]
		if best and not (def.key == "weaponOil" and data.omitWeaponOil) then
			i = i + 1
			local row = StepRow(i)
			row:SetPoint("TOPLEFT", win.body, "TOPLEFT", 0, y)
			row:SetWidth(inner)
			row.num:SetText("")
			local tex = C_Item and C_Item.GetItemIconByID and C_Item.GetItemIconByID(best)
			row.icon:SetTexture(tex or 134400)
			row.icon:SetShown(true)
			row.icon:SetDesaturated(false)
			row.icon:SetAlpha(1)
			row.spellID, row.itemID = nil, best
			row.liveKey = nil
			row.key:Hide()
			-- How many you carry, counting the alternatives too: any of them does the job.
			local all = {}
			for _, list in ipairs({ cat.best or {}, cat.alternates or {} }) do
				for _, id in ipairs(list) do
					all[#all + 1] = id
				end
			end
			local have = BagCount(all)
			local haveText = have > 0 and ("  |cff8cd98c×%d|r"):format(have)
				or ("  |cff9d9d9d(" .. L("CONSREADY_NOT_IN_BAG") .. ")|r")
			local alts = {}
			-- One line per NAME: two quality ranks of one potion share a name, and the card read
			-- "Silvermoon Health Potion / Silvermoon Health Potion" (Rob, 5 Oct 2026). Only a known
			-- name is folded; an uncached item still shows, so nothing silently disappears.
			local seenName = {}
			local bestName = ItemName(best)
			if bestName then
				seenName[bestName] = true
			end
			for _, id in ipairs(cat.alternates or {}) do
				local nm = ItemName(id)
				if not (nm and seenName[nm]) then
					if nm then
						seenName[nm] = true
					end
					alts[#alts + 1] = ItemLink(id)
				end
			end
			local altText = #alts > 0 and ("|n|cff9d9d9d" .. (L("GUIDE_CONS_ALSO_FMT")):format(table.concat(alts, " / ")) .. "|r") or ""
			row.fs:ClearAllPoints()
			row.fs:SetPoint("TOPLEFT", row, "TOPLEFT", 20 + ICON + 10, -2)
			row.fs:SetWidth(inner - (20 + ICON + 10))
			row.fs:SetTextColor(0.9, 0.88, 0.82)
			row.fs:SetText(("|cffffd100%s|r|n%s%s%s"):format(L(def.labelKey), ItemLink(best), haveText, altText))
			local h = math.max(ICON, row.fs:GetStringHeight() + 4)
			row:SetHeight(h)
			y = y - h - 10
		end
	end
	return y
end

--- The "Stay alive" tab: the same list the Academy shows (Modules/SurvivalPlan.lua), with an icon per
--- button and your own key. Returns the new y.
local function DrawStayAlive(specID, y, inner)
	local t = 0
	local low, grey, max = Greying(specID)
	y, t = LevelBanner(y, t, inner, low, grey, max)
	t = t + 1
	local intro = Text(t, "GameFontHighlight")
	intro:SetWidth(inner)
	intro:SetPoint("TOPLEFT", win.body, "TOPLEFT", 0, y)
	intro:SetTextColor(0.62, 0.6, 0.56)
	local steps = ns.GetSurvivalPlan and ns.GetSurvivalPlan(specID)
	intro:SetText(L(steps and "SURVIVAL_INTRO" or "PLAYCARD_ALIVE_NONE"))
	y = y - intro:GetStringHeight() - 12
	for i, s in ipairs(steps or {}) do
		local row = StepRow(i)
		row:SetPoint("TOPLEFT", win.body, "TOPLEFT", 0, y)
		row:SetWidth(inner)
		row.num:SetText(i)
		local missing = StepIcon(row, s.spellID, grey, specID == ActiveSpecID())
		row.fs:ClearAllPoints()
		row.fs:SetPoint("TOPLEFT", row, "TOPLEFT", 20 + ICON + 10, -2)
		row.fs:SetWidth(inner - (20 + ICON + 10))
		row.fs:SetTextColor(0.9, 0.88, 0.82)
		-- No [key] from our keybind scheme here any more: the icon now carries the key the spell
		-- is really on (Rob, 27 Sep 2026: "niet waar we ze zouden moeten zetten volgens ons systeem").
		row.fs:SetText(("|cff%s%s|r|n%s%s"):format(
			missing and "8a8a8a" or "ffd100",
			s.text or "",
			L(s.whenKey),
			s.noteKey and (" |cff9d9d9d(" .. L(s.noteKey) .. ")|r") or ""))
		local h = math.max(ICON, row.fs:GetStringHeight() + 4)
		row:SetHeight(h)
		y = y - h - 10
	end
	return y
end

--- The "Group" tab (3 Oct 2026, Modules/GroupPlan.lua): buttons for someone else, drawn like Stay alive
--- plus the dated source line. Only reached for a spec that has rows (the tab is hidden otherwise).
local function DrawGroup(specID, y, inner)
	local t = 0
	local low, grey, max = Greying(specID)
	y, t = LevelBanner(y, t, inner, low, grey, max)
	t = t + 1
	local intro = Text(t, "GameFontHighlight")
	intro:SetWidth(inner)
	intro:SetPoint("TOPLEFT", win.body, "TOPLEFT", 0, y)
	intro:SetTextColor(0.62, 0.6, 0.56)
	local steps = ns.GetGroupPlan and ns.GetGroupPlan(specID)
	intro:SetText(L(steps and "GROUP_INTRO" or "GROUP_NONE"))
	y = y - intro:GetStringHeight() - 12
	for i, s in ipairs(steps or {}) do
		local row = StepRow(i)
		row:SetPoint("TOPLEFT", win.body, "TOPLEFT", 0, y)
		row:SetWidth(inner)
		row.num:SetText(i)
		local missing = StepIcon(row, s.spellID, grey, specID == ActiveSpecID())
		row.fs:ClearAllPoints()
		row.fs:SetPoint("TOPLEFT", row, "TOPLEFT", 20 + ICON + 10, -2)
		row.fs:SetWidth(inner - (20 + ICON + 10))
		row.fs:SetTextColor(0.9, 0.88, 0.82)
		row.fs:SetText(("|cff%s%s|r|n%s%s"):format(
			missing and "8a8a8a" or "ffd100",
			s.text or "",
			L(s.whenKey),
			s.noteKey and (" |cff9d9d9d(" .. L(s.noteKey) .. ")|r") or ""))
		local h = math.max(ICON, row.fs:GetStringHeight() + 4)
		row:SetHeight(h)
		y = y - h - 10
	end
	local source = ns.GetGroupPlanSource and ns.GetGroupPlanSource(specID)
	if source then
		t = t + 1
		local src = Text(t, "GameFontHighlightSmall")
		src:SetWidth(inner)
		src:SetPoint("TOPLEFT", win.body, "TOPLEFT", 0, y - 2)
		src:SetTextColor(0.55, 0.53, 0.5)
		src:SetText((L("PLAYCARD_SOURCE_FMT")):format(source))
		y = y - src:GetStringHeight() - 8
	end
	return y
end

--------------------------------------------------------------------------------
-- Drawing
--------------------------------------------------------------------------------

-- Tab id -> the anchor of the same tab on midnighthelper.com/play/<slug>/ (site chat, 5 Oct 2026).
local SITE_ANCHOR = { alive = "alive", cons = "cons", dispel = "dispel", group = "group" }

--- The same card on midnighthelper.com (Rob, 4 Oct 2026: "do the link to the site"), under the
--- current tab. @return y below the link (unchanged when there is no page for this spec)
local function SiteLink(specID, y, inner, tab)
	local url = ns.PlayCardSiteURL and ns.PlayCardSiteURL(specID)
	if not url then
		return y
	end
	if tab and SITE_ANCHOR[tab] then
		url = url .. "#" .. SITE_ANCHOR[tab]
	end
	local b = win._siteBtn
	if not b then
		b = CreateFrame("Button", nil, win.body)
		b.fs = b:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
		b.fs:SetPoint("TOPLEFT")
		b.fs:SetJustifyH("LEFT")
		b:SetScript("OnEnter", function(self)
			self.fs:SetTextColor(1, 1, 1)
		end)
		b:SetScript("OnLeave", function(self)
			self.fs:SetTextColor(0.45, 0.75, 1)
		end)
		win._siteBtn = b
	end
	-- Rob, 4 Oct 2026: "het staat wel heel erg klein" — the raw small font skipped MH's own
	-- font; Font() gives it the size the card's own lines have.
	Font(b.fs, "GameFontHighlight")
	b.fs:SetWidth(inner)
	b.fs:SetTextColor(0.45, 0.75, 1)
	b.fs:SetText(L("PLAYCARD_SITE_LINK"))
	b:SetSize(inner, b.fs:GetStringHeight() + 2)
	b:ClearAllPoints()
	b:SetPoint("TOPLEFT", win.body, "TOPLEFT", 0, y - 6)
	b:SetScript("OnClick", function()
		if ns.ShowShareCopyDialog then
			ns.ShowShareCopyDialog({
				id = "playcard-site",
				text = url,
				titleKey = "PLAYCARD_SITE_TITLE",
				hintKey = "PLAYCARD_SITE_HINT",
				closeKey = "DELVE_SHARE_COPY_CLOSE",
				width = 460, height = 170,
			})
		end
	end)
	b:Show()
	return y - 6 - b:GetHeight()
end

local function Redraw()
	if not win then
		return
	end
	for _, fs in ipairs(win._texts) do
		fs:Hide()
	end
	for _, r in ipairs(win._rows) do
		r:Hide()
	end
	for _, b in ipairs(win._specBtns) do
		b:Hide()
	end
	if win._siteBtn then
		win._siteBtn:Hide()
	end
	-- Read the bars afresh for every draw: the keys are whatever they are right now.
	if ns.LiveKeysInvalidate then
		ns.LiveKeysInvalidate()
	end

	local specID = chosenSpec or ActiveSpecID()
	local inner = WIDTH - PAD * 2
	local y = 0
	local t = 0

	win._title:SetText((L("PLAYCARD_HEAD_FMT")):format(specID and SpecName(specID) or ""))

	-- Spec row: every spec of your class, so a Holy Paladin can peek at Protection.
	local specs = ClassSpecs()
	if #specs > 1 then
		for i, s in ipairs(specs) do
			local b = SpecButton(i)
			b:ClearAllPoints()
			b:SetPoint("TOPLEFT", win.body, "TOPLEFT", (i - 1) * (SPEC_ICON + 10) + 3, y - 3)
			b.tex:SetTexture(s.icon)
			b.tex:SetDesaturated(s.id ~= specID)
			b.ring:SetShown(s.id == specID)
			b.specName = s.name
			b:SetScript("OnClick", function()
				chosenSpec = (s.id ~= ActiveSpecID()) and s.id or nil
				Redraw()
			end)
		end
		y = y - SPEC_ICON - 12
	end

	-- Two tabs: the card, and "Stay alive". Rob, 25 Sep 2026, on his Elemental Shaman: "ik mis
	-- eigenlijk de defense dingen". He chose a second tab so the window stays as short as it was.
	local tab = CurrentTab()
	-- Third tab, Consumables: Rob, 26 Sep 2026.
	local tabs = {
		{ id = "play", key = "PLAYCARD_TAB_PLAY" },
		{ id = "alive", key = "SURVIVAL_HEAD" },
		{ id = "cons", key = "TAB_CONSUMABLES" },
		{ id = "dispel", key = "PLAYCARD_TAB_DISPEL" },
	}
	-- Fifth tab, Group (3 Oct 2026): only for a spec that has group rows; a spec without them gets
	-- no tab rather than an empty one. Viewing such a spec while on "group" falls back to the card.
	local hasGroup = ns.HasGroupPlan and ns.HasGroupPlan(specID)
	if hasGroup then
		tabs[#tabs + 1] = { id = "group", key = "PLAYCARD_TAB_GROUP" }
	elseif tab == "group" then
		tab = "play"
	end
	local tx = 0
	for i, def in ipairs(tabs) do
		local b = TabButton(i)
		b:ClearAllPoints()
		b:SetPoint("TOPLEFT", win.body, "TOPLEFT", tx, y)
		b.fs:SetText(L(def.key))
		b:SetWidth(b.fs:GetStringWidth() + 18)
		local on = def.id == tab
		b.fs:SetTextColor(on and 1 or 0.62, on and 0.82 or 0.6, on and 0.2 or 0.56)
		b.line:SetShown(on)
		b:SetScript("OnClick", function()
			SetTab(def.id)
			Redraw()
		end)
		tx = tx + b:GetWidth() + 4
	end
	-- The tab count changes per spec now (Group only where there are rows): hide leftovers.
	for i = #tabs + 1, #(win._tabBtns or {}) do
		win._tabBtns[i]:Hide()
	end
	y = y - 26 - 10

	if tab == "alive" or tab == "cons" or tab == "dispel" or tab == "group" then
		local draw = (tab == "alive" and DrawStayAlive) or (tab == "cons" and DrawConsumables)
			or (tab == "group" and DrawGroup) or DrawDispel
		y = draw(specID, y, inner)
		-- 5 Oct 2026: the site's /play/ pages have the same tabs, each with an anchor (site chat), so
		-- every tab links to its own part of the page.
		y = SiteLink(specID, y, inner, tab)
		win:SetHeight(32 + 32 - y + 16 + 8)
		return
	end

	local low, grey, max = Greying(specID)
	local card = specID and ns.GetPlayCard and ns.GetPlayCard(specID, grey)
	if card then
		y, t = LevelBanner(y, t, inner, low, grey, max)
	end
	-- Keys only for the spec you are playing: another spec's spells are not on your bars.
	local live = specID ~= nil and specID == ActiveSpecID()
	local isHealer = false
	if specID and GetSpecializationRoleByID then
		local okR, role = pcall(GetSpecializationRoleByID, specID)
		isHealer = okR and role == "HEALER"
	end
	if not card then
		t = t + 1
		local fs = Text(t, "GameFontHighlight")
		fs:SetWidth(inner)
		fs:SetPoint("TOPLEFT", win.body, "TOPLEFT", 0, y)
		fs:SetTextColor(0.62, 0.6, 0.56)
		fs:SetText(L("PLAYCARD_NONE"))
		y = y - fs:GetStringHeight() - 8
	else
		-- The idea: one sentence, a little larger, set apart from the steps.
		t = t + 1
		local idea = Text(t, "GameFontHighlightLarge")
		idea:SetWidth(inner)
		idea:SetPoint("TOPLEFT", win.body, "TOPLEFT", 0, y)
		idea:SetTextColor(1, 1, 1)
		idea:SetText(live and WithKeys(card.idea) or card.idea)
		y = y - idea:GetStringHeight() - 12

		-- A healer has never been told HOW healing picks its target (Rob, 5 Oct 2026: "nog nooit van
		-- mijn leven geheald"). One line, healer specs only.
		if isHealer then
			t = t + 1
			local how = Text(t, "GameFontHighlight")
			how:SetWidth(inner)
			how:SetPoint("TOPLEFT", win.body, "TOPLEFT", 0, y)
			how:SetTextColor(0.9, 0.88, 0.82)
			how:SetText("|cff66ddaa" .. L("PLAYCARD_HEAL_HOW_HEAD") .. "|r " .. L("PLAYCARD_HEAL_HOW"))
			y = y - how:GetStringHeight() - 10
		end

		-- "How to heal as <spec>, in 3 steps" — plain words, right under "how you heal" so the healing reads as one
		-- block (Rob's screenshot, 7 Oct evening: "fight alone" sat between them). PlayCards.lua out.easy.
		if card.easy then
			t = t + 1
			local easy = Text(t, "GameFontHighlight")
			easy:SetWidth(inner)
			easy:SetPoint("TOPLEFT", win.body, "TOPLEFT", 0, y)
			easy:SetTextColor(1, 1, 1)
			easy:SetText("|cff66ddaa" .. L("PLAYCARD_EASY_HEAD") .. "|r\n" .. (live and WithKeys(card.easy) or card.easy))
			y = y - easy:GetStringHeight() - 12
		end

		-- And how a healer fights ALONE (Rob, 6 Oct 2026, Resto Druid in the open world: "hoe weet ik welke knop ik moet
		-- gebruiken?"). Names from the client (the player's language), keys from the bars; HealerSolo.lua has the order.
		local solo = ns.HealerSoloSteps and ns.HealerSoloSteps(specID, live)
		if solo and #solo > 0 then
			t = t + 1
			local fight = Text(t, "GameFontHighlight")
			fight:SetWidth(inner)
			fight:SetPoint("TOPLEFT", win.body, "TOPLEFT", 0, y)
			fight:SetTextColor(0.9, 0.88, 0.82)
			local lines = { "|cffff7766" .. L("CARD_SOLO_HEAD") .. "|r " .. L("CARD_SOLO_INTRO") }
			for i, s in ipairs(solo) do
				local name = C_Spell and C_Spell.GetSpellName and C_Spell.GetSpellName(s.id) or ("#" .. s.id)
				local key = live and ns.LiveKeyForSpell and ReadableKey((ns.LiveKeyForSpell(s.id)))
				local keyTxt = key and (" |cffffffff[" .. key .. "]|r")
					or (live and (" |cff9a9a9a" .. L("CARD_SOLO_NOKEY") .. "|r") or "")
				lines[#lines + 1] = ("%d. |cffffd100%s|r%s - %s"):format(i, name, keyTxt, L(s.note))
			end
			fight:SetText(table.concat(lines, "\n"))
			y = y - fight:GetStringHeight() - 10
		end

		t = t + 1
		local stepsHead = Text(t, "GameFontNormal")
		stepsHead:SetWidth(inner)
		stepsHead:SetPoint("TOPLEFT", win.body, "TOPLEFT", 0, y)
		stepsHead:SetTextColor(1, 0.82, 0.4)
		stepsHead:SetText(L("PLAYCARD_STEPS"))
		y = y - stepsHead:GetStringHeight() - 8

		for i, s in ipairs(card.steps) do
			local row = StepRow(i)
			row:SetPoint("TOPLEFT", win.body, "TOPLEFT", 0, y)
			row:SetWidth(inner)
			row.num:SetText(i)
			-- A step written as plain text (no confirmed spell id) gets no icon rather than a
			-- question mark: a "?" would read as "MH does not know this", which is not the case.
			StepIcon(row, s.spellID, grey, specID == ActiveSpecID())
			row.fs:ClearAllPoints()
			row.fs:SetPoint("TOPLEFT", row, "TOPLEFT", 20 + ICON + 10, -2)
			row.fs:SetWidth(inner - (20 + ICON + 10))
			row.fs:SetTextColor(0.9, 0.88, 0.82)
			row.fs:SetText(live and WithKeys(s.text) or s.text)
			local h = math.max(ICON, row.fs:GetStringHeight() + 4)
			row:SetHeight(h)
			y = y - h - 10
		end

		local function Block(label, body, r, g, b)
			if not body or body == "" then
				return
			end
			t = t + 1
			local fs = Text(t, "GameFontHighlight")
			fs:SetWidth(inner)
			fs:SetPoint("TOPLEFT", win.body, "TOPLEFT", 0, y)
			fs:SetTextColor(0.9, 0.88, 0.82)
			fs:SetText(("|cff%02x%02x%02x%s|r %s"):format(
				math.floor(r * 255), math.floor(g * 255), math.floor(b * 255), label, live and WithKeys(body) or body))
			y = y - fs:GetStringHeight() - 8
		end

		y = y - 4
		-- A healer's "aoe" line is about many HURT friends, not more enemies (newcomer review, 7 Oct 2026) — and every
		-- healer line already opens with its own situation ("Hele groep geraakt: …"), so a heading doubled it (Rob's
		-- screenshot, same evening). Healers get a plain bullet; PLAYCARD_AOE_HEAL stays defined but unused.
		if isHealer then
			Block("•", card.aoe, 1, 1, 1)
		else
			Block(L("PLAYCARD_AOE"), card.aoe, 1, 1, 1)
		end
		Block(L("PLAYCARD_MISTAKE"), card.mistake, 1, 0.38, 0.38)
		-- The hero-talent lines are for later (Rob, same evening): say so, so a beginner can stop reading here.
		if #card.hero > 0 and card.easy then
			Block(L("PLAYCARD_LATER_HEAD"), " ", 0.62, 0.62, 1) -- Block skips an empty body
		end
		for _, h in ipairs(card.hero) do
			Block("•", h.text, 0.62, 0.62, 1)
		end

		t = t + 1
		local src = Text(t, "GameFontHighlightSmall")
		src:SetWidth(inner)
		src:SetPoint("TOPLEFT", win.body, "TOPLEFT", 0, y - 4)
		src:SetTextColor(0.62, 0.6, 0.56)
		src:SetText((L("PLAYCARD_SOURCE_FMT")):format(card.source))
		y = y - 4 - src:GetStringHeight()

		y = SiteLink(specID, y, inner, nil)
	end

	-- Frame = content inset (32, DialogPopup.lua) + body offset under the title (32) + the rows
	-- + bottom inset (16) + a little air.
	win:SetHeight(32 + 32 - y + 16 + 8)
end

local function Build()
	if win then
		return win
	end
	local f = CreateFrame("Frame", WIN_NAME, UIParent, "BackdropTemplate")
	f:SetSize(WIDTH, 300)
	f:SetFrameStrata("HIGH")
	local saved = ns.db and ns.db.ui and ns.db.ui.playCardPos
	if type(saved) == "table" and saved[1] then
		f:SetPoint(saved[1], UIParent, saved[2] or saved[1], tonumber(saved[3]) or 0, tonumber(saved[4]) or 0)
	else
		f:SetPoint("CENTER", UIParent, "CENTER", 320, 60)
	end
	f:Hide()
	if ns.ApplyMidnightDialogBackdrop then
		ns.ApplyMidnightDialogBackdrop(f)
	end
	-- Drag by the whole window, not only the title strip. Rob, 25 Sep 2026: "ik kan alleen het scherm
	-- niet verslepen" -- the title-bar drag from EnsureMidnightDialogTitleBar did not take. Set BEFORE
	-- RegisterMidnightDialogPopup: its dock button hooks an existing OnDragStart to undock on drag.
	-- The step rows take the mouse for their tooltips, so drag from the title, the tabs or an empty spot.
	f:SetMovable(true)
	f:EnableMouse(true)
	f:RegisterForDrag("LeftButton")
	f:SetScript("OnDragStart", function(self)
		self:StartMoving()
	end)
	f:SetScript("OnDragStop", function(self)
		self:StopMovingOrSizing()
		local p, _, rp, x, y = self:GetPoint(1)
		if p and ns.db then
			ns.db.ui = ns.db.ui or {}
			ns.db.ui.playCardPos = { p, rp, x, y }
		end
	end)
	if ns.RegisterMidnightDialogPopup then
		ns.RegisterMidnightDialogPopup(f) -- drag, Shift+scroll to resize, dock button, Escape closes
	end
	local titleBar, content
	if ns.EnsureMidnightDialogTitleBar then
		titleBar, content = ns.EnsureMidnightDialogTitleBar(f)
	end
	if titleBar then
		-- Let a drag on the title fall through to the frame, so there is ONE drag path: it saves the
		-- position and runs the dock button's undock hook, which a handler of our own would skip.
		titleBar:EnableMouse(false)
	end
	if ns.AttachMidnightDialogCloseButton then
		ns.AttachMidnightDialogCloseButton(f)
	end
	content = content or f

	local title = (titleBar or f):CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
	Font(title, "GameFontNormalLarge")
	title:SetPoint("LEFT", titleBar or f, "LEFT", 0, 0)
	title:SetJustifyH("LEFT")
	-- Stops short of the Dock button that RegisterMidnightDialogPopup puts top right.
	title:SetWidth(WIDTH - 150)
	title:SetWordWrap(false)
	title:SetTextColor(1, 0.9, 0.55)
	f._title = title

	local body = CreateFrame("Frame", nil, content)
	body:SetPoint("TOPLEFT", content, "TOPLEFT", 0, -32)
	body:SetPoint("BOTTOMRIGHT", content, "BOTTOMRIGHT", 0, 0)
	f.body = body
	-- The idea, "more enemies", mistake and hero lines are font strings on the body: links there too.
	body:EnableMouse(true)
	HookLinks(body)
	ForwardDrag(body)

	f._texts, f._rows, f._specBtns = {}, {}, {}

	-- Follow a spec change while open, unless the player picked another spec to look at.
	f:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED")
	-- A new level or a new talent can turn a grey spell gold: redraw, but keep the spec being looked at.
	f:RegisterEvent("PLAYER_LEVEL_UP")
	f:RegisterEvent("SPELLS_CHANGED")
	-- Consumables tab: item names arrive later than the first draw, and bag counts change.
	f:RegisterEvent("GET_ITEM_INFO_RECEIVED")
	f:RegisterEvent("BAG_UPDATE_DELAYED")
	-- Live keys: a spell moved, a key rebound, the main bar paged or a form changed the bar.
	f:RegisterEvent("ACTIONBAR_SLOT_CHANGED")
	f:RegisterEvent("UPDATE_BINDINGS")
	f:RegisterEvent("ACTIONBAR_PAGE_CHANGED")
	f:RegisterEvent("UPDATE_BONUS_ACTIONBAR")
	local pending = false
	local keysPending = false
	f:SetScript("OnEvent", function(self, event, unit)
		if not self:IsShown() then
			return
		end
		if event == "PLAYER_SPECIALIZATION_CHANGED" then
			if unit == nil or unit == "player" then
				chosenSpec = nil
				Redraw()
			end
		elseif event == "ACTIONBAR_SLOT_CHANGED" or event == "UPDATE_BINDINGS"
			or event == "ACTIONBAR_PAGE_CHANGED" or event == "UPDATE_BONUS_ACTIONBAR" then
			-- Dragging a spell fires several of these at once: one redraw, on the tabs that show keys.
			local tab = CurrentTab()
			if (tab == "play" or tab == "alive") and not keysPending and C_Timer and C_Timer.After then
				keysPending = true
				C_Timer.After(0.2, function()
					keysPending = false
					if self:IsShown() then
						Redraw()
					end
				end)
			end
		elseif event == "GET_ITEM_INFO_RECEIVED" or event == "BAG_UPDATE_DELAYED" then
			-- Many at once while names load: one redraw a moment later, and only on that tab.
			if CurrentTab() == "cons" and not pending and C_Timer and C_Timer.After then
				pending = true
				C_Timer.After(0.2, function()
					pending = false
					if self:IsShown() then
						Redraw()
					end
				end)
			end
		else
			Redraw()
		end
	end)
	f:SetScript("OnShow", Redraw)

	win = f
	return f
end

--- Open (or close) the card window. specID is optional: nil shows your active spec.
function ns.TogglePlayCardWindow(specID)
	local f = Build()
	if f:IsShown() and not specID then
		f:Hide()
		return
	end
	chosenSpec = specID
	if f:IsShown() then
		Redraw()
	else
		f:Show()
	end
end

--- The gold "How you play" button in MH's search bar, on every tab (4.1.0). Rob, 25 Sep 2026: "misschien
--- moeten we een extra opvallende knop daarvoor maken in de MH". Its own gold fill rather than either
--- look's button style, so it stands out in both; it pulses until the first click, then stays still.
function ns.CreatePlayCardButton(parent)
	local b = CreateFrame("Button", "MidnightHelperPlayCardButton", parent)
	b:SetHeight(22)
	local glow = b:CreateTexture(nil, "BACKGROUND", nil, -2)
	glow:SetPoint("TOPLEFT", -3, 3)
	glow:SetPoint("BOTTOMRIGHT", 3, -3)
	glow:SetColorTexture(1, 0.85, 0.35, 1)
	local fill = b:CreateTexture(nil, "BACKGROUND")
	fill:SetAllPoints()
	fill:SetColorTexture(0.80, 0.58, 0.16, 1)
	local hi = b:CreateTexture(nil, "HIGHLIGHT")
	hi:SetAllPoints()
	hi:SetColorTexture(1, 1, 1, 0.2)
	local icon = b:CreateTexture(nil, "ARTWORK")
	icon:SetSize(18, 18)
	icon:SetPoint("LEFT", b, "LEFT", 3, 0)
	icon:SetTexCoord(0.07, 0.93, 0.07, 0.93)
	local fs = b:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	fs:SetPoint("LEFT", icon, "RIGHT", 5, 0)
	fs:SetTextColor(0.12, 0.07, 0.02)

	local pulse = glow:CreateAnimationGroup()
	pulse:SetLooping("BOUNCE")
	local a = pulse:CreateAnimation("Alpha")
	a:SetFromAlpha(0.15)
	a:SetToAlpha(1)
	a:SetDuration(0.9)

	local function Seen()
		return ns.db and ns.db.ui and ns.db.ui.playCardSeen
	end

	function b:Refresh()
		fs:SetText(L("PLAYCARD_BTN"))
		local specID = ActiveSpecID()
		local tex
		if specID and GetSpecializationInfoByID then
			local ok, _, _, _, t = pcall(GetSpecializationInfoByID, specID)
			tex = ok and t or nil
		end
		icon:SetTexture(tex or "Interface\\Icons\\INV_Misc_Book_09")
		self:SetWidth(3 + 18 + 5 + fs:GetStringWidth() + 10)
		if Seen() then
			pulse:Stop()
			glow:Hide()
		else
			glow:Show()
			if not pulse:IsPlaying() then
				pulse:Play()
			end
		end
	end

	b:SetScript("OnClick", function(self)
		if ns.db then
			ns.db.ui = ns.db.ui or {}
			ns.db.ui.playCardSeen = true
		end
		self:Refresh()
		ns.TogglePlayCardWindow()
	end)
	b:SetScript("OnEnter", function(self)
		if GameTooltip then
			GameTooltip:SetOwner(self, "ANCHOR_BOTTOM")
			GameTooltip:SetText(L("PLAYCARD_BTN"), 1, 0.82, 0.2)
			GameTooltip:AddLine(L("CMDLIST_PLAY"), 0.9, 0.88, 0.82, true)
			GameTooltip:AddLine("/mh play", 0.62, 0.6, 0.56)
			GameTooltip:Show()
		end
	end)
	b:SetScript("OnLeave", function()
		if GameTooltip then
			GameTooltip:Hide()
		end
	end)
	b:SetScript("OnShow", b.Refresh)
	b:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED")
	b:RegisterEvent("PLAYER_ENTERING_WORLD")
	b:SetScript("OnEvent", b.Refresh)
	b:Refresh()
	return b
end

function ns.ShowPlayCardWindow(specID)
	local f = Build()
	chosenSpec = specID
	if f:IsShown() then
		Redraw()
	else
		f:Show()
	end
end
