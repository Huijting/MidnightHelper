local _, ns = ...

--[[
	ForeverOverview.lua — WoW Forever: the new overview window, ROUGH version of style A ("sfeervol boek").
	Rob, 17 Nov 2026 (via Sparring 17-11), on the plan docs/forever/HUISSTIJL_PLAN_2026-11-17.md, verbatim: "ja, met de
	mooie letters meteen erin, en eerst een ruwe versie van A om te bekijken". Mockup: C:\Users\RobHu\Desktop\mh_ontwerp.png.
	His demand for "Do this now", verbatim: "Bij een nieuwe layout moet dat beter. En dan moet er ook een [pijl] naartoe gaan
	om te kijken welke kant je op gaat" → every line with a place has its own "Show the way" button, the coordinates sit
	on a small line of their own, and the main line is a card with a title.
	His verdict on the first rough version (17 Nov, Undead Paladin 14), verbatim: "Ja, ik ben onder de indruk. … Zoals
	rechtsbovenin, een doc en doc. Dat knopje zit natuurlijk weer er doorheen. Ik wil graag … de tooltips overal bij. Maar
	verder, dit is de weg waar ik graag heen wil." → round 2: the dock button next to the title, a tooltip on every part,
	the path columns inside the frame, no class quest twice, XP in the empty left column, chips that match the nodes.

	Nothing here is new data: trainer spells (ns.ForeverTrainerCompute, ForeverTrainer.lua), the class quest step and
	list (ns.ForeverClassQuestNowParts / ns.ForeverClassQuestList, ForeverClassQuests.lua), camp, Legacy, dungeon and
	profession lines (ForeverCamp/ForeverLegacy/ForeverDungeons.lua, ns.ForeverPrimaryCount).
	Fonts: OFL, from github.com/google/fonts (Media/Fonts, OFL-*.txt beside them): Cormorant SC for headings, Alegreya
	Sans for text, both with Cyrillic. If SetFont fails the game's own fonts take over. Not from the Forever Leveling
	Guide (All Rights Reserved): no code, text, data or textures of it.
	/mh overview opens and closes it.
]]

if not ns.IS_FOREVER then
	return
end

local FONT_DIR = "Interface\\AddOns\\MidnightHelper\\Media\\Fonts\\"
local FONT_HEAD = FONT_DIR .. "CormorantSC-Bold.ttf"
local FONT_HEAD2 = FONT_DIR .. "CormorantSC-SemiBold.ttf"
local FONT_TEXT = FONT_DIR .. "AlegreyaSans-Regular.ttf"
local FONT_TEXT_B = FONT_DIR .. "AlegreyaSans-Medium.ttf"
local FALLBACK_HEAD, FALLBACK_TEXT = "Fonts\\MORPHEUS.TTF", "Fonts\\FRIZQT__.TTF"
local MASK = "Interface\\CharacterFrame\\TempPortraitAlphaMask"

-- Style A colours (own values, after the mockup).
local A = {
	bgTop = { 0.16, 0.11, 0.07, 0.97 }, bgBottom = { 0.07, 0.05, 0.04, 0.97 },
	card = { 0.11, 0.08, 0.06, 0.88 }, edge = { 0.55, 0.42, 0.22, 0.55 },
	gold = { 0.86, 0.71, 0.42 }, label = { 0.93, 0.55, 0.22 }, text = { 0.92, 0.88, 0.80 }, dim = { 0.66, 0.60, 0.52 },
	seal = { 0.55, 0.10, 0.08 }, later = { 0.55, 0.52, 0.48 },
}
local W, H = 920, 486
local LEFT_W = 176

local win

local function Accent()
	local _, token = UnitClass("player")
	local c = token and (C_ClassColor and C_ClassColor.GetClassColor and C_ClassColor.GetClassColor(token))
		or (RAID_CLASS_COLORS and token and RAID_CLASS_COLORS[token])
	if c then
		return c.r, c.g, c.b
	end
	return 0.4, 0.7, 1
end

--- Set a font, falling back to the game's own when the file cannot be used.
local function Font(fs, file, size, fallback, flags)
	local ok = fs:SetFont(file, size, flags or "")
	if not ok then
		fs:SetFont(fallback, size, flags or "")
	end
end

local function Text(parent, file, size, color, fallback)
	local fs = parent:CreateFontString(nil, "OVERLAY")
	Font(fs, file, size, fallback or FALLBACK_TEXT)
	fs:SetTextColor(color[1], color[2], color[3])
	fs:SetJustifyH("LEFT")
	fs:SetWordWrap(true)
	return fs
end

--- Tooltip on any frame. The text lives on the frame (tipTitle/tipBody/tipSpell), so Fill can change it later.
local function Tip(frame, title, body)
	frame.tipTitle, frame.tipBody = title, body
	frame:EnableMouse(true)
	frame:HookScript("OnEnter", function(self)
		if not (self.tipTitle or self.tipSpell) then
			return
		end
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		if self.tipSpell then
			GameTooltip:SetSpellByID(self.tipSpell)
		else
			GameTooltip:SetText(self.tipTitle, 1, 0.82, 0, 1, true)
			if self.tipBody and self.tipBody ~= "" then
				GameTooltip:AddLine(self.tipBody, 1, 1, 1, true)
			end
		end
		GameTooltip:Show()
	end)
	frame:HookScript("OnLeave", function()
		GameTooltip:Hide()
	end)
	return frame
end

--- An invisible hover area over a region (so the window can still be dragged everywhere else).
local function HoverOver(parent, region, title, body)
	local h = CreateFrame("Frame", nil, parent)
	h:SetAllPoints(region)
	return Tip(h, title, body)
end

local function Card(parent)
	local f = CreateFrame("Frame", nil, parent, "BackdropTemplate")
	f:SetBackdrop({ bgFile = "Interface\\Buttons\\WHITE8X8", edgeFile = "Interface\\Buttons\\WHITE8X8", edgeSize = 1 })
	f:SetBackdropColor(A.card[1], A.card[2], A.card[3], A.card[4])
	f:SetBackdropBorderColor(A.edge[1], A.edge[2], A.edge[3], A.edge[4])
	return f
end

--- Small capital label at the top of a card ("DO THIS NOW"), with a tooltip that says what the card is for.
local function Label(card, text, tipKey)
	local fs = Text(card, FONT_HEAD2, 12, A.label, FALLBACK_TEXT)
	fs:SetPoint("TOPLEFT", 14, -12)
	fs:SetText(text)
	if tipKey then
		HoverOver(card, fs, text, ns:L(tipKey))
	end
	return fs
end

--- A button in style A: dark, accent border, serif text.
local function Button(parent, w)
	local b = CreateFrame("Button", nil, parent, "BackdropTemplate")
	b:SetSize(w or 120, 24)
	b:SetBackdrop({ bgFile = "Interface\\Buttons\\WHITE8X8", edgeFile = "Interface\\Buttons\\WHITE8X8", edgeSize = 1 })
	local r, g, bl = Accent()
	b:SetBackdropColor(r * 0.25, g * 0.25, bl * 0.25, 0.95)
	b:SetBackdropBorderColor(r, g, bl, 0.9)
	b.label = Text(b, FONT_HEAD2, 13, { 0.95, 0.92, 0.85 }, FALLBACK_TEXT)
	b.label:SetPoint("CENTER")
	b.label:SetJustifyH("CENTER")
	b:SetScript("OnEnter", function(self)
		if not self.active then
			self:SetBackdropColor(r * 0.45, g * 0.45, bl * 0.45, 0.95)
		end
	end)
	b:SetScript("OnLeave", function(self)
		if not self.active then
			self:SetBackdropColor(r * 0.25, g * 0.25, bl * 0.25, 0.95)
		end
	end)
	function b:SetLabel(t)
		self.label:SetText(t)
	end
	return b
end

--- A spell icon that shows the spell's own tooltip.
local function SpellButton(parent, size)
	local f = CreateFrame("Frame", nil, parent)
	f:SetSize(size, size)
	f.tex = f:CreateTexture(nil, "ARTWORK")
	f.tex:SetAllPoints()
	f.tex:SetTexCoord(0.08, 0.92, 0.08, 0.92)
	Tip(f)
	return f
end

local function Circle(parent, tex, layerSub)
	local t = parent:CreateTexture(nil, "ARTWORK", nil, layerSub)
	pcall(function()
		local m = parent:CreateMaskTexture()
		m:SetTexture(MASK, "CLAMPTOBLACKADDITIVE", "CLAMPTOBLACKADDITIVE")
		m:SetAllPoints(t)
		t:AddMaskTexture(m)
	end)
	return t
end

local function SpellName(id)
	if C_Spell and C_Spell.GetSpellName then
		local ok, n = pcall(C_Spell.GetSpellName, id)
		if ok and type(n) == "string" and n ~= "" then
			return n
		end
	end
	return nil
end

local function SpellIcon(id)
	if C_Spell and C_Spell.GetSpellTexture then
		local ok, t = pcall(C_Spell.GetSpellTexture, id)
		if ok and t then
			return t
		end
	end
	return 134400 -- question mark
end

local function Place(zone, x, y)
	if not zone then
		return nil
	end
	if x and y then
		return ("%s · %.1f, %.1f"):format(zone, x, y)
	end
	return zone
end

--------------------------------------------------------------------------------
-- Data: what the cards say (nothing new is measured here)
--------------------------------------------------------------------------------

--- The "do this now" items, most important first: { title, what, place, go, kind }.
local function NowItems()
	local items = {}
	local level = UnitLevel and UnitLevel("player") or 1
	local r = ns.ForeverTrainerCompute and ns.ForeverTrainerCompute(level)
	if r and #r.now > 0 then
		local npc
		if ns.ForeverTrainerNearestNpc then
			local _, nm = ns.ForeverTrainerNearestNpc()
			npc = nm
		end
		local money = GetCoinTextureString and GetCoinTextureString(r.total or 0) or tostring(r.total or 0)
		items[#items + 1] = {
			kind = "trainer",
			title = (#r.now == 1 and ns:L("FOV_TRAINER_ONE_FMT") or ns:L("FOV_TRAINER_MANY_FMT")):format(#r.now,
				npc or ns:L("FOV_YOUR_TRAINER")),
			what = ns:L("FOV_COST_FMT"):format(money),
			place = ns.ForeverTrainerNearestText and ns.ForeverTrainerNearestText() or nil,
			go = ns.ForeverTrainerGo,
		}
	end
	local okC, cq = false, nil
	if ns.ForeverClassQuestNowParts then
		okC, cq = pcall(ns.ForeverClassQuestNowParts)
	end
	if okC and type(cq) == "table" then
		local what = cq.what
		if not what and cq.npc then
			what = (cq.kind == "turn" and ns:L("FOV_CQ_TURN_FMT") or ns:L("FOV_CQ_GET_FMT")):format(cq.npc)
		end
		items[#items + 1] = {
			kind = "classquest",
			title = ns:L("FOV_CQ_TITLE_FMT"):format(cq.chain or "?"),
			what = what,
			place = Place(cq.zone, cq.x, cq.y),
			go = cq.zone and ns.ForeverClassQuestGo or nil,
		}
	end
	for _, fn in ipairs({ ns.ForeverCampNow, ns.ForeverLegacyNow }) do
		local ok, line = pcall(fn or function() end)
		if ok and type(line) == "string" then
			items[#items + 1] = { kind = "line", title = line }
		end
	end
	-- Tips that never open "Do this now" by themselves, but fill the card here (Rob: the empty space).
	if ns.ForeverPrimaryCount then
		local ok, n = pcall(ns.ForeverPrimaryCount)
		if ok and type(n) == "number" and n < 2 then
			items[#items + 1] = { kind = "tip", title = (n == 1) and ns:L("FDONOW_PROF_ONE") or ns:L("FDONOW_PROF_TWO") }
		end
	end
	if ns.ForeverDungeonTip then
		local ok, tip = pcall(ns.ForeverDungeonTip)
		if ok and type(tip) == "string" then
			items[#items + 1] = { kind = "tip", title = tip }
		end
	end
	return items
end

--- Trainer spells above your level, up to `ahead` levels on: { { id, l, name }, … } by level, one per name.
local function Upcoming(ahead)
	local level = UnitLevel and UnitLevel("player") or 1
	local r = ns.ForeverTrainerCompute and ns.ForeverTrainerCompute(level + ahead)
	local out, seen = {}, {}
	for _, e in ipairs(r and r.now or {}) do
		if e.l > level then
			local nm = SpellName(e.id)
			-- A spell you already know comes as a stronger rank: say which (the client's own subtext), as "Do this now"
			-- does (ForeverDoNow.lua, 12 Nov 2026). Sparring saw "Seal of Righteousness" at 18 on a paladin who has it.
			-- Round 4: the rank goes on the second line ("level 18 · Rank 3"), the name alone was already cut off.
			local rank
			if nm and ns.ForeverKnownSpell and e.n and ns.ForeverKnownSpell(e.n) and C_Spell and C_Spell.GetSpellSubtext then
				local okR, r = pcall(C_Spell.GetSpellSubtext, e.id)
				if okR and type(r) == "string" and r ~= "" and not (issecretvalue and issecretvalue(r)) then
					rank = r
				end
			end
			local k = nm and (nm .. "|" .. (rank or ""))
			if k and not seen[k] then
				seen[k] = true
				out[#out + 1] = { id = e.id, l = e.l, name = nm, rank = rank }
			end
		end
	end
	table.sort(out, function(a, b)
		if a.l ~= b.l then
			return a.l < b.l
		end
		return a.name < b.name
	end)
	return out
end

--------------------------------------------------------------------------------
-- Window
--------------------------------------------------------------------------------
local TABS = {
	{ key = "FOV_TAB_NOW", tip = "FOV_TIP_TAB_NOW" },
	{ key = "FOV_TAB_PLAY", tip = "FOV_TIP_TAB_PLAY", fn = function() if ns.TogglePlayCardWindow then ns.TogglePlayCardWindow() end end },
	{ key = "FOV_TAB_CQ", tip = "FOV_TIP_TAB_CQ", fn = function() if ns.TogglePlayCardWindow then ns.TogglePlayCardWindow() end end },
	{ key = "FOV_TAB_CAMP", tip = "FOV_TIP_TAB_CAMP", fn = function() if ns.ForeverCampSlash then ns.ForeverCampSlash() end end },
	{ key = "FOV_TAB_LEGACY", tip = "FOV_TIP_TAB_LEGACY", fn = function() if ns.ForeverLegacySlash then ns.ForeverLegacySlash() end end },
}

local PATH_NODES = 4

local function Build()
	if win then
		return win
	end
	local f = CreateFrame("Frame", "MidnightHelperForeverOverview", UIParent, "BackdropTemplate")
	f:SetSize(W, H)
	f:SetPoint("CENTER", 0, 60)
	f:SetFrameStrata("DIALOG")
	-- Shift+scroll resizes, Escape closes (DialogPopup.lua).
	if ns.RegisterMidnightDialogPopup then
		ns.RegisterMidnightDialogPopup(f)
	else
		tinsert(UISpecialFrames, f:GetName())
	end
	f:SetBackdrop({ bgFile = "Interface\\Buttons\\WHITE8X8", edgeFile = "Interface\\Buttons\\WHITE8X8", edgeSize = 1 })
	f:SetBackdropColor(0, 0, 0, 0)
	f:SetBackdropBorderColor(A.gold[1], A.gold[2], A.gold[3], 0.6)
	-- Warm vertical gradient (own WHITE8X8 layer, no textures of anyone else).
	local bg = f:CreateTexture(nil, "BACKGROUND")
	bg:SetPoint("TOPLEFT", 1, -1)
	bg:SetPoint("BOTTOMRIGHT", -1, 1)
	bg:SetTexture("Interface\\Buttons\\WHITE8X8")
	if bg.SetGradient and CreateColor then
		bg:SetGradient("VERTICAL", CreateColor(unpack(A.bgBottom)), CreateColor(unpack(A.bgTop)))
	else
		bg:SetVertexColor(A.bgTop[1], A.bgTop[2], A.bgTop[3], A.bgTop[4])
	end
	f:EnableMouse(true)
	f:SetMovable(true)
	f:SetClampedToScreen(true)
	f:RegisterForDrag("LeftButton")
	f:SetScript("OnDragStart", f.StartMoving)
	f:SetScript("OnDragStop", f.StopMovingOrSizing)

	-- Header: title, tabs, close.
	f.title = Text(f, FONT_HEAD, 22, A.gold, FALLBACK_HEAD)
	f.title:SetPoint("TOPLEFT", 22, -14)
	f.title:SetText("MIDNIGHT HELPER")
	-- Rob, 17 Nov 2026: "Dock to window" ran over the Legacy tab. It lives next to the title here.
	if f._mhDockBtn then
		f._mhDockBtn:ClearAllPoints()
		f._mhDockBtn:SetPoint("LEFT", f.title, "RIGHT", 14, -1)
	end
	local line = f:CreateTexture(nil, "ARTWORK")
	line:SetColorTexture(A.gold[1], A.gold[2], A.gold[3], 0.35)
	line:SetPoint("TOPLEFT", 1, -48)
	line:SetPoint("TOPRIGHT", -1, -48)
	line:SetHeight(1)
	local close = CreateFrame("Button", nil, f, "UIPanelCloseButton")
	close:SetPoint("TOPRIGHT", -2, -2)
	f.tabs = {}
	local x = -40
	for i = #TABS, 1, -1 do
		local t = TABS[i]
		local b = Button(f, 104)
		b:SetPoint("TOPRIGHT", x, -14)
		b:SetLabel(ns:L(t.key))
		b:SetScript("OnClick", function()
			if t.fn then
				t.fn()
			end
		end)
		if i == 1 then
			local r, g, bl = Accent()
			b.active = true
			b:SetBackdropColor(r * 0.5, g * 0.5, bl * 0.5, 0.95)
		end
		Tip(b, ns:L(t.key), ns:L(t.tip))
		f.tabs[i] = b
		x = x - 108
	end

	-- Left: portrait, name, race · class, XP, level seal.
	local left = Card(f)
	left:SetPoint("TOPLEFT", 16, -62)
	left:SetPoint("BOTTOMLEFT", 16, 16)
	left:SetWidth(LEFT_W)
	local ring = Circle(left, nil, 1)
	ring:SetSize(76, 76)
	ring:SetPoint("TOP", 0, -18)
	ring:SetColorTexture(A.gold[1], A.gold[2], A.gold[3], 1)
	local por = Circle(left, nil, 2)
	por:SetSize(70, 70)
	por:SetPoint("CENTER", ring)
	f.portrait = por
	f.portraitTip = HoverOver(left, ring)
	f.name = Text(left, FONT_HEAD, 22, A.text, FALLBACK_HEAD)
	f.name:SetPoint("TOP", ring, "BOTTOM", 0, -8)
	f.name:SetJustifyH("CENTER")
	f.who = Text(left, FONT_TEXT, 13, A.dim)
	f.who:SetPoint("TOP", f.name, "BOTTOM", 0, -2)
	f.who:SetWidth(LEFT_W - 16)
	f.who:SetJustifyH("CENTER")
	-- XP bar and rested (Rob: empty space between name and seal).
	f.xpBg = left:CreateTexture(nil, "ARTWORK")
	f.xpBg:SetColorTexture(0, 0, 0, 0.5)
	f.xpBg:SetSize(LEFT_W - 36, 8)
	f.xpBg:SetPoint("TOP", f.who, "BOTTOM", 0, -14)
	f.xpFill = left:CreateTexture(nil, "ARTWORK", nil, 1)
	f.xpFill:SetPoint("TOPLEFT", f.xpBg)
	f.xpFill:SetHeight(8)
	f.xpText = Text(left, FONT_TEXT, 12, A.dim)
	f.xpText:SetPoint("TOP", f.xpBg, "BOTTOM", 0, -4)
	f.xpText:SetJustifyH("CENTER")
	f.xpTip = HoverOver(left, f.xpBg)
	local sealRing = Circle(left, nil, 1)
	sealRing:SetSize(70, 70)
	sealRing:SetPoint("BOTTOM", 0, 22)
	sealRing:SetColorTexture(A.gold[1], A.gold[2], A.gold[3], 1)
	local seal = Circle(left, nil, 2)
	seal:SetSize(64, 64)
	seal:SetPoint("CENTER", sealRing)
	seal:SetColorTexture(A.seal[1], A.seal[2], A.seal[3], 1)
	f.sealTip = HoverOver(left, sealRing, ns:L("FOV_LEVEL"), ns:L("FOV_TIP_SEAL"))
	f.sealWord = Text(left, FONT_HEAD2, 10, A.gold, FALLBACK_TEXT)
	f.sealWord:SetPoint("TOP", seal, "TOP", 0, -12)
	f.sealWord:SetJustifyH("CENTER")
	f.sealLevel = Text(left, FONT_HEAD, 26, { 1, 0.95, 0.85 }, FALLBACK_HEAD)
	f.sealLevel:SetPoint("CENTER", seal, "CENTER", 0, -6)
	f.sealLevel:SetJustifyH("CENTER")

	local x0 = 16 + LEFT_W + 12
	local rightW = W - x0 - 16
	-- Row 1: Do this now (wide), Coming up, Class quest.
	-- Widths: the class quest card got wider in round 3 (sparring saw "Wolfsbane: the Kor G…" cut off).
	-- Round 4: Coming up wider again (its spell names were cut off), Do this now gives some of its room.
	local nowW = math.floor(rightW * 0.38)
	local soonW = math.floor(rightW * 0.30)
	local cqW = rightW - nowW - soonW - 24
	local rowH = 252
	f.now = Card(f)
	f.now:SetPoint("TOPLEFT", x0, -62)
	f.now:SetSize(nowW, rowH)
	local acc = f.now:CreateTexture(nil, "ARTWORK")
	acc:SetPoint("TOPLEFT", 1, -1)
	acc:SetPoint("TOPRIGHT", -1, -1)
	acc:SetHeight(2)
	f.nowAccent = acc
	f.now.label = Label(f.now, ns:L("FOV_LABEL_NOW"), "FOV_TIP_CARD_NOW")
	f.now.title = Text(f.now, FONT_HEAD, 21, A.text, FALLBACK_HEAD)
	f.now.title:SetPoint("TOPLEFT", 14, -32)
	f.now.title:SetPoint("RIGHT", -14, 0)
	if f.now.title.SetMaxLines then
		f.now.title:SetMaxLines(2) -- room for the lines below it
	end
	f.now.what = Text(f.now, FONT_TEXT, 14, A.text)
	f.now.what:SetPoint("TOPLEFT", f.now.title, "BOTTOMLEFT", 0, -4)
	f.now.what:SetPoint("RIGHT", -14, 0)
	f.now.place = Text(f.now, FONT_TEXT, 12, A.dim)
	f.now.place:SetPoint("TOPLEFT", f.now.what, "BOTTOMLEFT", 0, -3)
	f.now.place:SetPoint("RIGHT", -14, 0)
	f.now.go = Button(f.now, 132)
	f.now.go:SetPoint("TOPLEFT", f.now.place, "BOTTOMLEFT", 0, -8)
	f.now.go:SetLabel(ns:L("FOV_GO"))
	Tip(f.now.go, ns:L("FOV_GO"), ns:L("FOV_TIP_GO"))
	-- Further "now" lines, each with its own arrow button when it has a place.
	f.now.more = {}
	for i = 1, 2 do
		local row = CreateFrame("Frame", nil, f.now)
		row:SetHeight(42) -- room for a three-line tip
		row:SetPoint("LEFT", 14, 0)
		row:SetPoint("RIGHT", -14, 0)
		row:SetPoint("BOTTOM", 0, 8 + (2 - i) * 46)
		local sep = row:CreateTexture(nil, "ARTWORK")
		sep:SetColorTexture(A.edge[1], A.edge[2], A.edge[3], 0.35)
		sep:SetHeight(1)
		sep:SetPoint("TOPLEFT", 0, 3)
		sep:SetPoint("TOPRIGHT", 0, 3)
		row.text = Text(row, FONT_TEXT_B, 13, A.text)
		row.text:SetPoint("TOPLEFT")
		row.text:SetPoint("RIGHT", -70, 0)
		row.text:SetWordWrap(false)
		row.sub = Text(row, FONT_TEXT, 11, A.dim)
		row.sub:SetPoint("TOPLEFT", row.text, "BOTTOMLEFT", 0, -1)
		row.sub:SetPoint("RIGHT", -70, 0)
		row.sub:SetWordWrap(false)
		row.hover = HoverOver(row, row.text)
		row.hover:SetPoint("BOTTOMRIGHT", row.sub, "BOTTOMRIGHT")
		row.go = Button(row, 62)
		row.go:SetHeight(20)
		row.go:SetPoint("RIGHT")
		row.go:SetLabel(ns:L("FOV_GO_SHORT"))
		Tip(row.go, ns:L("FOV_GO"), ns:L("FOV_TIP_GO"))
		f.now.more[i] = row
	end

	f.soon = Card(f)
	f.soon:SetPoint("TOPLEFT", f.now, "TOPRIGHT", 12, 0)
	f.soon:SetSize(soonW, rowH)
	f.soon.label = Label(f.soon, ns:L("FOV_LABEL_SOON"), "FOV_TIP_CARD_SOON")
	f.soon.rows = {}
	for i = 1, 5 do
		local ic = SpellButton(f.soon, 26)
		ic:SetPoint("TOPLEFT", 14, -34 - (i - 1) * 38)
		local nm = Text(f.soon, FONT_TEXT_B, 15, A.text)
		nm:SetPoint("TOPLEFT", ic, "TOPRIGHT", 8, 1)
		nm:SetPoint("RIGHT", f.soon, "RIGHT", -10, 0)
		nm:SetWordWrap(false)
		local lv = Text(f.soon, FONT_TEXT, 12, A.later)
		lv:SetPoint("TOPLEFT", nm, "BOTTOMLEFT", 0, -1)
		f.soon.rows[i] = { icon = ic, name = nm, level = lv }
	end

	f.cq = Card(f)
	f.cq:SetPoint("TOPLEFT", f.soon, "TOPRIGHT", 12, 0)
	f.cq:SetSize(cqW, rowH)
	f.cq.label = Label(f.cq, ns:L("FOV_LABEL_CQ"), "FOV_TIP_CARD_CQ")
	f.cq.title = Text(f.cq, FONT_HEAD, 18, A.text, FALLBACK_HEAD)
	f.cq.title:SetPoint("TOPLEFT", 14, -32)
	f.cq.title:SetPoint("RIGHT", -12, 0)
	f.cq.what = Text(f.cq, FONT_TEXT, 13, A.text)
	f.cq.what:SetPoint("TOPLEFT", f.cq.title, "BOTTOMLEFT", 0, -4)
	f.cq.what:SetPoint("RIGHT", -12, 0)
	f.cq.place = Text(f.cq, FONT_TEXT, 12, A.dim)
	f.cq.place:SetPoint("TOPLEFT", f.cq.what, "BOTTOMLEFT", 0, -3)
	f.cq.place:SetPoint("RIGHT", -12, 0)
	f.cq.go = Button(f.cq, 120)
	f.cq.go:SetPoint("BOTTOMLEFT", 14, 12)
	f.cq.go:SetLabel(ns:L("FOV_GO"))
	Tip(f.cq.go, ns:L("FOV_GO"), ns:L("FOV_TIP_GO"))
	-- List mode (when "Do this now" already shows the open class quest): every class quest with where it stands.
	f.cq.list = {}
	for i = 1, 6 do
		local lv = Text(f.cq, FONT_HEAD2, 13, A.gold, FALLBACK_TEXT)
		lv:SetPoint("TOPLEFT", 14, -34 - (i - 1) * 30)
		lv:SetWidth(24)
		local nm = Text(f.cq, FONT_TEXT_B, 13, A.text)
		nm:SetPoint("TOPLEFT", lv, "TOPRIGHT", 4, 0)
		nm:SetPoint("RIGHT", f.cq, "RIGHT", -10, 0)
		nm:SetWordWrap(false)
		local st = Text(f.cq, FONT_TEXT, 11, A.dim)
		st:SetPoint("TOPLEFT", nm, "BOTTOMLEFT", 0, -1)
		-- The full name on hover (a long chain name is cut to one line).
		local hv = Tip(CreateFrame("Frame", nil, f.cq))
		hv:SetPoint("TOPLEFT", lv, "TOPLEFT")
		hv:SetPoint("BOTTOM", st, "BOTTOM")
		hv:SetPoint("RIGHT", f.cq, "RIGHT", -10, 0)
		f.cq.list[i] = { level = lv, name = nm, state = st, hover = hv }
	end

	-- Row 2: your path (level now → +6), in equal columns that stay inside the card (Rob's screenshot: the last ran out).
	f.path = Card(f)
	f.path:SetPoint("TOPLEFT", f.now, "BOTTOMLEFT", 0, -12)
	f.path:SetPoint("BOTTOMRIGHT", -16, 16)
	f.path.label = Label(f.path, "", "FOV_TIP_CARD_PATH")
	local pathW = rightW
	local colW = math.floor((pathW - 28) / PATH_NODES)
	f.path.track = f.path:CreateTexture(nil, "ARTWORK")
	f.path.track:SetColorTexture(A.later[1], A.later[2], A.later[3], 0.35)
	f.path.track:SetHeight(2)
	f.path.track:SetPoint("TOPLEFT", 14 + 14, -55)
	f.path.track:SetPoint("TOPRIGHT", f.path, "TOPLEFT", 14 + (PATH_NODES - 1) * colW + 14, -55)
	f.path.nodes = {}
	for i = 1, PATH_NODES do
		local n = {}
		local cx = 14 + (i - 1) * colW
		n.ring = Circle(f.path, nil, 2)
		n.ring:SetSize(28, 28)
		n.ring:SetPoint("TOPLEFT", cx, -41)
		n.dot = Circle(f.path, nil, 3)
		n.dot:SetSize(24, 24)
		n.dot:SetPoint("CENTER", n.ring)
		n.dot:SetColorTexture(0.10, 0.08, 0.06, 1)
		n.num = Text(f.path, FONT_HEAD, 14, A.text, FALLBACK_HEAD)
		n.num:SetPoint("CENTER", n.ring, "CENTER", 0, 0)
		n.num:SetJustifyH("CENTER")
		n.hover = HoverOver(f.path, n.ring)
		n.icon = SpellButton(f.path, 24)
		n.icon:SetPoint("TOPLEFT", n.ring, "BOTTOMLEFT", 0, -12)
		n.name = Text(f.path, FONT_TEXT_B, 15, A.text)
		n.name:SetWidth(colW - 44)
		n.name:SetWordWrap(false)
		n.sub = Text(f.path, FONT_TEXT, 12, A.dim)
		n.sub:SetPoint("TOPLEFT", n.name, "BOTTOMLEFT", 0, -1)
		n.sub:SetWidth(colW - 44)
		n.sub:SetWordWrap(false)
		f.path.nodes[i] = n
	end
	-- Legend: the colours the nodes really use (Rob's screenshot: three chips, but the nodes used one colour).
	f.path.chips = {}
	for i, key in ipairs({ "FOV_CHIP_NOW", "FOV_CHIP_LATER" }) do
		local c = CreateFrame("Frame", nil, f.path, "BackdropTemplate")
		c:SetSize(64, 18)
		c:SetPoint("TOPRIGHT", -14 - (2 - i) * 70, -10)
		c:SetBackdrop({ bgFile = "Interface\\Buttons\\WHITE8X8", edgeFile = "Interface\\Buttons\\WHITE8X8", edgeSize = 1 })
		c:SetBackdropColor(0, 0, 0, 0.3)
		c.t = Text(c, FONT_HEAD2, 11, A.text, FALLBACK_TEXT)
		c.t:SetPoint("CENTER")
		c.t:SetJustifyH("CENTER")
		c.t:SetText(ns:L(key))
		Tip(c, ns:L(key), ns:L(i == 1 and "FOV_TIP_CHIP_NOW" or "FOV_TIP_CHIP_LATER"))
		f.path.chips[i] = c
	end

	f:SetScript("OnShow", function()
		ns.ForeverOverviewFill()
	end)
	f:Hide()
	win = f
	return f
end

local function SetGo(btn, fn)
	if fn then
		btn:SetScript("OnClick", function()
			fn()
		end)
		btn:Show()
	else
		btn:SetScript("OnClick", nil)
		btn:Hide()
	end
end

local function FillLeft(f, level)
	local r, g, b = Accent()
	if SetPortraitTexture then
		pcall(SetPortraitTexture, f.portrait, "player")
	end
	local name = UnitName("player") or ""
	f.name:SetText(name)
	local race = UnitRace and UnitRace("player") or ""
	local cls = UnitClass and UnitClass("player") or ""
	local tree
	if ns.GetForeverDirection then
		local _, t = ns.GetForeverDirection()
		tree = t
	end
	local faction = UnitFactionGroup and select(2, UnitFactionGroup("player")) or nil
	f.who:SetText(("%s · %s%s%s"):format(race, cls, tree and (" · " .. tree) or "", faction and ("\n" .. faction) or ""))
	f.portraitTip.tipTitle = name
	f.portraitTip.tipBody = ns:L("FOV_TIP_PORTRAIT_FMT"):format(race, cls, tree or ns:L("FOV_NO_DIRECTION"))
	f.sealWord:SetText(ns:L("FOV_LEVEL"))
	f.sealLevel:SetText(tostring(level))
	-- XP: hidden at max level (no XP to show).
	local cur, max = UnitXP and UnitXP("player") or 0, UnitXPMax and UnitXPMax("player") or 0
	if max and max > 0 and not (IsPlayerAtEffectiveMaxLevel and IsPlayerAtEffectiveMaxLevel()) then
		local pct = math.floor(cur / max * 100 + 0.5)
		f.xpFill:SetColorTexture(r, g, b, 0.9)
		f.xpFill:SetWidth(math.max(1, (LEFT_W - 36) * cur / max))
		local rested = GetXPExhaustion and GetXPExhaustion() or nil
		local restPct = rested and math.floor(rested / max * 100 + 0.5) or 0
		f.xpText:SetText(ns:L("FOV_XP_FMT"):format(pct) .. (restPct > 0 and ("  ·  " .. ns:L("FOV_RESTED_FMT"):format(restPct)) or ""))
		f.xpTip.tipTitle = ns:L("FOV_XP_FMT"):format(pct)
		f.xpTip.tipBody = ns:L("FOV_TIP_XP_FMT"):format(cur, max, max - cur) .. (restPct > 0 and ("\n" .. ns:L("FOV_TIP_RESTED")) or "")
		for _, t in ipairs({ f.xpBg, f.xpFill, f.xpText }) do
			t:Show()
		end
	else
		for _, t in ipairs({ f.xpBg, f.xpFill, f.xpText }) do
			t:Hide()
		end
		f.xpTip.tipTitle = nil
	end
end

local function FillNow(f, items)
	local main = items[1]
	if main then
		f.now.title:SetText(main.title or "")
		f.now.what:SetText(main.what or "")
		f.now.place:SetText(main.place or "")
		SetGo(f.now.go, main.go)
	else
		f.now.title:SetText(ns:L("FOV_ALL_DONE"))
		f.now.what:SetText(ns:L("FOV_ALL_DONE_SUB"))
		f.now.place:SetText("")
		SetGo(f.now.go, nil)
	end
	for i, row in ipairs(f.now.more) do
		local it = items[i + 1]
		if it then
			-- A line without a place or second line (a tip) may use two lines (sparring: "Dungeons for your level… Ragefir…").
			local sub = it.place or it.what
			row.text:SetWordWrap(sub == nil)
			if row.text.SetMaxLines then
				row.text:SetMaxLines(sub == nil and 3 or 1)
			end
			row.text:SetText(it.title or "")
			row.sub:SetText(sub or "")
			row.hover.tipTitle = it.title
			row.hover.tipBody = it.what and it.place and (it.what .. "\n" .. it.place) or it.what or it.place
			SetGo(row.go, it.go)
			row:Show()
		else
			row:Hide()
		end
	end
end

local function FillClassQuest(f, items)
	local showList = items[1] and items[1].kind == "classquest" or (items[2] and items[2].kind == "classquest")
	local okC, cq = false, nil
	if not showList and ns.ForeverClassQuestNowParts then
		okC, cq = pcall(ns.ForeverClassQuestNowParts)
	end
	local list = {}
	if showList and ns.ForeverClassQuestList then
		local ok, l = pcall(ns.ForeverClassQuestList)
		list = ok and type(l) == "table" and l or {}
	end
	for _, row in ipairs(f.cq.list) do
		row.level:SetText("")
		row.name:SetText("")
		row.state:SetText("")
		row.hover.tipTitle = nil
	end
	if showList and #list > 0 then
		f.cq.label:SetText(ns:L("FOV_LABEL_CQ_LIST"))
		f.cq.title:SetText("")
		f.cq.what:SetText("")
		f.cq.place:SetText("")
		SetGo(f.cq.go, nil)
		-- Open ones first, then later, then done; at most six.
		local order = { now = 1, later = 2, done = 3 }
		table.sort(list, function(a, b)
			if order[a.state] ~= order[b.state] then
				return order[a.state] < order[b.state]
			end
			return (a.level or 0) < (b.level or 0)
		end)
		for i, row in ipairs(f.cq.list) do
			local e = list[i]
			if e then
				row.level:SetText(tostring(e.level or ""))
				row.name:SetText(e.chain or "")
				if e.state == "done" then
					row.state:SetText(ns:L("FOV_CQ_ST_DONE"))
					row.state:SetTextColor(0.45, 0.85, 0.40)
				elseif e.state == "now" then
					row.state:SetText(ns:L("FOV_CQ_ST_NOW"))
					local r, g, b = Accent()
					row.state:SetTextColor(r, g, b)
				else
					row.state:SetText(ns:L("FOV_CQ_ST_LATER_FMT"):format(e.level or 0))
					row.state:SetTextColor(A.later[1], A.later[2], A.later[3])
				end
				row.hover.tipTitle = e.chain
				row.hover.tipBody = ns:L("FOV_LEVEL_FMT"):format(e.level or 0) .. " · " .. (row.state:GetText() or "")
			end
		end
		return
	end
	f.cq.label:SetText(ns:L("FOV_LABEL_CQ"))
	if okC and type(cq) == "table" then
		f.cq.title:SetText(cq.chain or "")
		local what = cq.what
		if not what and cq.npc then
			what = (cq.kind == "turn" and ns:L("FOV_CQ_TURN_FMT") or ns:L("FOV_CQ_GET_FMT")):format(cq.npc)
		end
		f.cq.what:SetText((what or "") .. (cq.level and ("\n" .. ns:L("FOV_FROM_LEVEL_FMT"):format(cq.level)) or ""))
		f.cq.place:SetText(Place(cq.zone, cq.x, cq.y) or "")
		SetGo(f.cq.go, cq.zone and ns.ForeverClassQuestGo or nil)
	else
		f.cq.title:SetText(ns:L("FOV_CQ_NONE"))
		f.cq.what:SetText("")
		f.cq.place:SetText("")
		SetGo(f.cq.go, nil)
	end
end

function ns.ForeverOverviewFill()
	local f = Build()
	local r, g, b = Accent()
	f.nowAccent:SetColorTexture(r, g, b, 0.9)
	local level = UnitLevel and UnitLevel("player") or 1
	FillLeft(f, level)

	local items = NowItems()
	FillNow(f, items)

	-- Coming up (the next trainer spells, next 6 levels). Hover an icon: the spell's own tooltip.
	local up = Upcoming(6)
	for i, row in ipairs(f.soon.rows) do
		local e = up[i]
		if e then
			row.icon.tex:SetTexture(SpellIcon(e.id))
			row.icon.tipSpell = e.id
			row.icon:Show()
			row.name:SetText(e.name)
			row.level:SetText(ns:L("FOV_LEVEL_FMT"):format(e.l) .. (e.rank and (" · " .. e.rank) or ""))
		else
			row.icon:Hide()
			row.icon.tipSpell = nil
			row.name:SetText(i == 1 and ns:L("FOV_SOON_NONE") or "")
			row.level:SetText("")
		end
	end

	FillClassQuest(f, items)

	-- Your path: now, then the levels that bring trainer spells (up to 3 more nodes within 6 levels).
	f.path.label:SetText(ns:L("FOV_PATH_FMT"):format(level, level + 6))
	local byLevel, levels = {}, {}
	for _, e in ipairs(up) do
		if not byLevel[e.l] then
			byLevel[e.l] = {}
			levels[#levels + 1] = e.l
		end
		table.insert(byLevel[e.l], e)
	end
	local nodes = { { l = level, now = true } }
	for _, l in ipairs(levels) do
		if #nodes < PATH_NODES then
			nodes[#nodes + 1] = { l = l, list = byLevel[l] }
		end
	end
	for i, n in ipairs(f.path.nodes) do
		local d = nodes[i]
		local parts = { n.ring, n.dot, n.num, n.icon, n.name, n.sub, n.hover }
		if d then
			for _, t in ipairs(parts) do
				t:Show()
			end
			n.num:SetText(tostring(d.l))
			n.name:ClearAllPoints()
			if d.now then
				n.ring:SetColorTexture(r, g, b, 1)
				n.num:SetTextColor(r, g, b)
				n.icon:Hide()
				n.icon.tipSpell = nil
				n.name:SetPoint("TOPLEFT", n.ring, "BOTTOMLEFT", 0, -12)
				n.name:SetText(ns:L("FOV_PATH_NOW"))
				n.sub:SetText(items[1] and items[1].title or ns:L("FOV_ALL_DONE"))
				n.hover.tipTitle = ns:L("FOV_LEVEL_FMT"):format(d.l)
				n.hover.tipBody = ns:L("FOV_TIP_NODE_NOW")
			else
				n.ring:SetColorTexture(A.later[1], A.later[2], A.later[3], 1)
				n.num:SetTextColor(A.text[1], A.text[2], A.text[3])
				n.icon.tex:SetTexture(SpellIcon(d.list[1].id))
				n.icon.tipSpell = d.list[1].id
				n.name:SetPoint("TOPLEFT", n.icon, "TOPRIGHT", 8, 2)
				n.name:SetText(d.list[1].name)
				n.sub:SetText(#d.list > 1 and ns:L("FOV_PATH_MORE_FMT"):format(#d.list - 1) or ns:L("FOV_PATH_NEW"))
				local names = {}
				for _, e in ipairs(d.list) do
					names[#names + 1] = e.rank and (e.name .. " (" .. e.rank .. ")") or e.name
				end
				n.hover.tipTitle = ns:L("FOV_LEVEL_FMT"):format(d.l)
				n.hover.tipBody = ns:L("FOV_TIP_NODE_FMT"):format(table.concat(names, ", "))
			end
		else
			for _, t in ipairs(parts) do
				t:Hide()
			end
		end
	end
	local chipCol = { { r, g, b }, A.later }
	for i, c in ipairs(f.path.chips) do
		local col = chipCol[i]
		c:SetBackdropBorderColor(col[1], col[2], col[3], 0.9)
		c.t:SetTextColor(col[1], col[2], col[3])
	end
	return f
end

function ns.ToggleForeverOverview()
	local f = Build()
	if f:IsShown() then
		f:Hide()
	else
		f:Show()
	end
end
