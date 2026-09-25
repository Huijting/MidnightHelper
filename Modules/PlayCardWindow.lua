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
local WIDTH = 460
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
	if not (GetSpecialization and GetSpecializationInfo) then
		return nil
	end
	local idx = GetSpecialization()
	if not idx then
		return nil
	end
	return (GetSpecializationInfo(idx))
end

--- The specs of the player's own class: { {id, name, icon}, ... }.
local function ClassSpecs()
	local out = {}
	if not (GetNumSpecializations and GetSpecializationInfo) then
		return out
	end
	for i = 1, (GetNumSpecializations() or 0) do
		local id, name, _, icon = GetSpecializationInfo(i)
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
			local id = row.spellID
			if not (id and GameTooltip and GameTooltip.SetSpellByID) then
				return
			end
			GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
			GameTooltip:SetSpellByID(id)
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
	Font(row.num, "GameFontNormalLarge")
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
	return (ui and ui.playCardTab == "alive") and "alive" or "play"
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
	Font(b.fs, "GameFontNormal")
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

--- A step's icon, greyed like its name when the character does not have that spell yet.
local function StepIcon(row, id, grey)
	local tex = SpellIcon(id)
	row.icon:SetTexture(tex)
	row.icon:SetShown(tex ~= nil)
	local missing = grey and id and not grey(id)
	row.icon:SetDesaturated(missing and true or false)
	row.icon:SetAlpha(missing and 0.55 or 1)
	row.num:SetTextColor(missing and 0.55 or 1, missing and 0.55 or 0.8, missing and 0.55 or 0)
	row.spellID = id
	return missing
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
		local missing = StepIcon(row, s.spellID, grey)
		row.fs:ClearAllPoints()
		row.fs:SetPoint("TOPLEFT", row, "TOPLEFT", 20 + ICON + 10, -2)
		row.fs:SetWidth(inner - (20 + ICON + 10))
		row.fs:SetTextColor(0.9, 0.88, 0.82)
		row.fs:SetText(("|cff%s%s|r%s|n%s%s"):format(
			missing and "8a8a8a" or "ffd100",
			s.text or "",
			s.bindKey and ("  |cff9d9d9d[" .. s.bindKey .. "]|r") or "",
			L(s.whenKey),
			s.noteKey and (" |cff9d9d9d(" .. L(s.noteKey) .. ")|r") or ""))
		local h = math.max(ICON, row.fs:GetStringHeight() + 4)
		row:SetHeight(h)
		y = y - h - 10
	end
	return y
end

--------------------------------------------------------------------------------
-- Drawing
--------------------------------------------------------------------------------

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
	local tabs = { { id = "play", key = "PLAYCARD_TAB_PLAY" }, { id = "alive", key = "SURVIVAL_HEAD" } }
	local tx = 0
	for i, def in ipairs(tabs) do
		local b = TabButton(i)
		b:ClearAllPoints()
		b:SetPoint("TOPLEFT", win.body, "TOPLEFT", tx, y)
		b.fs:SetText(L(def.key))
		b:SetWidth(b.fs:GetStringWidth() + 24)
		local on = def.id == tab
		b.fs:SetTextColor(on and 1 or 0.62, on and 0.82 or 0.6, on and 0.2 or 0.56)
		b.line:SetShown(on)
		b:SetScript("OnClick", function()
			SetTab(def.id)
			Redraw()
		end)
		tx = tx + b:GetWidth() + 8
	end
	y = y - 26 - 10

	if tab == "alive" then
		y = DrawStayAlive(specID, y, inner)
		win:SetHeight(32 + 32 - y + 16 + 8)
		return
	end

	local low, grey, max = Greying(specID)
	local card = specID and ns.GetPlayCard and ns.GetPlayCard(specID, grey)
	if card then
		y, t = LevelBanner(y, t, inner, low, grey, max)
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
		idea:SetText(card.idea)
		y = y - idea:GetStringHeight() - 12

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
			StepIcon(row, s.spellID, grey)
			row.fs:ClearAllPoints()
			row.fs:SetPoint("TOPLEFT", row, "TOPLEFT", 20 + ICON + 10, -2)
			row.fs:SetWidth(inner - (20 + ICON + 10))
			row.fs:SetTextColor(0.9, 0.88, 0.82)
			row.fs:SetText(s.text)
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
				math.floor(r * 255), math.floor(g * 255), math.floor(b * 255), label, body))
			y = y - fs:GetStringHeight() - 8
		end

		y = y - 4
		Block(L("PLAYCARD_AOE"), card.aoe, 1, 1, 1)
		Block(L("PLAYCARD_MISTAKE"), card.mistake, 1, 0.38, 0.38)
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
	f:SetScript("OnEvent", function(self, event, unit)
		if not self:IsShown() then
			return
		end
		if event == "PLAYER_SPECIALIZATION_CHANGED" then
			if unit == nil or unit == "player" then
				chosenSpec = nil
				Redraw()
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
