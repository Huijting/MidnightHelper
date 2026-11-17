local _, ns = ...

--[[
	ForeverOverview.lua — WoW Forever: the new overview window, ROUGH version of style A ("sfeervol boek").
	Rob, 17 Nov 2026 (via Sparring 17-11), on the plan docs/forever/HUISSTIJL_PLAN_2026-11-17.md, verbatim: "ja, met de
	mooie letters meteen erin, en eerst een ruwe versie van A om te bekijken". Mockup: C:\Users\RobHu\Desktop\mh_ontwerp.png.
	His demand for "Do this now", verbatim: "Bij een nieuwe layout moet dat beter. En dan moet er ook een [pijl] naartoe gaan
	om te kijken welke kant je op gaat" → every line with a place has its own "Show the way" button, the coordinates sit
	on a small line of their own, and the main line is a card with a title.

	Nothing here is new data: trainer spells (ns.ForeverTrainerCompute, ForeverTrainer.lua), the class quest step
	(ns.ForeverClassQuestNowParts, ForeverClassQuests.lua), camp and Legacy lines (ForeverCamp/ForeverLegacy.lua).
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

-- Style A colours (own values, after the mockup).
local A = {
	bgTop = { 0.16, 0.11, 0.07, 0.97 }, bgBottom = { 0.07, 0.05, 0.04, 0.97 },
	card = { 0.11, 0.08, 0.06, 0.88 }, edge = { 0.55, 0.42, 0.22, 0.55 },
	gold = { 0.86, 0.71, 0.42 }, label = { 0.93, 0.55, 0.22 }, text = { 0.92, 0.88, 0.80 }, dim = { 0.66, 0.60, 0.52 },
	seal = { 0.55, 0.10, 0.08 },
}
local W, H = 920, 470
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

local function Card(parent)
	local f = CreateFrame("Frame", nil, parent, "BackdropTemplate")
	f:SetBackdrop({ bgFile = "Interface\\Buttons\\WHITE8X8", edgeFile = "Interface\\Buttons\\WHITE8X8", edgeSize = 1 })
	f:SetBackdropColor(A.card[1], A.card[2], A.card[3], A.card[4])
	f:SetBackdropBorderColor(A.edge[1], A.edge[2], A.edge[3], A.edge[4])
	return f
end

--- Small capital label at the top of a card ("DO THIS NOW").
local function Label(card, text)
	local fs = Text(card, FONT_HEAD2, 12, A.label, FALLBACK_TEXT)
	fs:SetPoint("TOPLEFT", 14, -12)
	fs:SetText(text)
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
		self:SetBackdropColor(r * 0.45, g * 0.45, bl * 0.45, 0.95)
	end)
	b:SetScript("OnLeave", function(self)
		self:SetBackdropColor(r * 0.25, g * 0.25, bl * 0.25, 0.95)
	end)
	function b:SetLabel(t)
		self.label:SetText(t)
	end
	return b
end

local function Icon(parent, size)
	local t = parent:CreateTexture(nil, "ARTWORK")
	t:SetSize(size, size)
	t:SetTexCoord(0.08, 0.92, 0.08, 0.92)
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

--- The "do this now" items, most important first: { label, title, what, place, go }.
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
			title = (#r.now == 1 and ns:L("FOV_TRAINER_ONE_FMT") or ns:L("FOV_TRAINER_MANY_FMT")):format(#r.now,
				npc or ns:L("FOV_YOUR_TRAINER")),
			what = ns:L("FOV_COST_FMT"):format(money),
			place = ns.ForeverTrainerNearestText and ns.ForeverTrainerNearestText() or nil,
			go = ns.ForeverTrainerGo,
		}
	end
	local cq = ns.ForeverClassQuestNowParts and select(2, pcall(ns.ForeverClassQuestNowParts))
	if type(cq) == "table" then
		local what = cq.what
		if not what and cq.npc then
			what = (cq.kind == "turn" and ns:L("FOV_CQ_TURN_FMT") or ns:L("FOV_CQ_GET_FMT")):format(cq.npc)
		end
		items[#items + 1] = {
			title = ns:L("FOV_CQ_TITLE_FMT"):format(cq.chain or "?"),
			what = what,
			place = Place(cq.zone, cq.x, cq.y),
			go = cq.zone and ns.ForeverClassQuestGo or nil,
		}
	end
	for _, fn in ipairs({ ns.ForeverCampNow, ns.ForeverLegacyNow }) do
		local ok, line = pcall(fn or function() end)
		if ok and type(line) == "string" then
			items[#items + 1] = { title = line }
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
			if nm and not seen[nm] then
				seen[nm] = true
				out[#out + 1] = { id = e.id, l = e.l, name = nm }
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
	{ key = "FOV_TAB_NOW" },
	{ key = "FOV_TAB_PLAY", fn = function() if ns.TogglePlayCardWindow then ns.TogglePlayCardWindow() end end },
	{ key = "FOV_TAB_CQ", fn = function() if ns.TogglePlayCardWindow then ns.TogglePlayCardWindow() end end },
	{ key = "FOV_TAB_CAMP", fn = function() if ns.ForeverCampSlash then ns.ForeverCampSlash() end end },
	{ key = "FOV_TAB_LEGACY", fn = function() if ns.ForeverLegacySlash then ns.ForeverLegacySlash() end end },
}

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
	-- Warm vertical gradient with a darker rim (own WHITE8X8 layers, no textures of anyone else).
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
			b:SetBackdropColor(r * 0.5, g * 0.5, bl * 0.5, 0.95)
			b:SetScript("OnLeave", nil)
			b:SetScript("OnEnter", nil)
		end
		f.tabs[i] = b
		x = x - 108
	end

	-- Left: portrait, name, race · class, level seal.
	local left = Card(f)
	left:SetPoint("TOPLEFT", 16, -62)
	left:SetPoint("BOTTOMLEFT", 16, 16)
	left:SetWidth(LEFT_W)
	local ring = left:CreateTexture(nil, "ARTWORK", nil, 1)
	ring:SetSize(76, 76)
	ring:SetPoint("TOP", 0, -18)
	ring:SetColorTexture(A.gold[1], A.gold[2], A.gold[3], 1)
	local por = left:CreateTexture(nil, "ARTWORK", nil, 2)
	por:SetSize(70, 70)
	por:SetPoint("CENTER", ring)
	local okMask = pcall(function()
		local m1 = left:CreateMaskTexture()
		m1:SetTexture("Interface\\CharacterFrame\\TempPortraitAlphaMask", "CLAMPTOBLACKADDITIVE", "CLAMPTOBLACKADDITIVE")
		m1:SetAllPoints(ring)
		ring:AddMaskTexture(m1)
		local m2 = left:CreateMaskTexture()
		m2:SetTexture("Interface\\CharacterFrame\\TempPortraitAlphaMask", "CLAMPTOBLACKADDITIVE", "CLAMPTOBLACKADDITIVE")
		m2:SetAllPoints(por)
		por:AddMaskTexture(m2)
	end)
	f.okMask = okMask
	f.portrait = por
	f.name = Text(left, FONT_HEAD, 22, A.text, FALLBACK_HEAD)
	f.name:SetPoint("TOP", ring, "BOTTOM", 0, -8)
	f.name:SetJustifyH("CENTER")
	f.who = Text(left, FONT_TEXT, 13, A.dim)
	f.who:SetPoint("TOP", f.name, "BOTTOM", 0, -2)
	f.who:SetWidth(LEFT_W - 16)
	f.who:SetJustifyH("CENTER")
	local sealRing = left:CreateTexture(nil, "ARTWORK", nil, 1)
	sealRing:SetSize(70, 70)
	sealRing:SetPoint("BOTTOM", 0, 26)
	sealRing:SetColorTexture(A.gold[1], A.gold[2], A.gold[3], 1)
	local seal = left:CreateTexture(nil, "ARTWORK", nil, 2)
	seal:SetSize(64, 64)
	seal:SetPoint("CENTER", sealRing)
	seal:SetColorTexture(A.seal[1], A.seal[2], A.seal[3], 1)
	pcall(function()
		for _, t in ipairs({ sealRing, seal }) do
			local m = left:CreateMaskTexture()
			m:SetTexture("Interface\\CharacterFrame\\TempPortraitAlphaMask", "CLAMPTOBLACKADDITIVE", "CLAMPTOBLACKADDITIVE")
			m:SetAllPoints(t)
			t:AddMaskTexture(m)
		end
	end)
	f.sealWord = Text(left, FONT_HEAD2, 10, A.gold, FALLBACK_TEXT)
	f.sealWord:SetPoint("TOP", seal, "TOP", 0, -12)
	f.sealWord:SetJustifyH("CENTER")
	f.sealLevel = Text(left, FONT_HEAD, 26, { 1, 0.95, 0.85 }, FALLBACK_HEAD)
	f.sealLevel:SetPoint("CENTER", seal, "CENTER", 0, -6)
	f.sealLevel:SetJustifyH("CENTER")

	local x0 = 16 + LEFT_W + 12
	local rightW = W - x0 - 16
	-- Row 1: Do this now (wide), Coming up, Class quest.
	local nowW = math.floor(rightW * 0.44)
	local soonW = math.floor(rightW * 0.27)
	local cqW = rightW - nowW - soonW - 24
	local rowH = 236
	f.now = Card(f)
	f.now:SetPoint("TOPLEFT", x0, -62)
	f.now:SetSize(nowW, rowH)
	-- Accent line on top of the main card.
	local acc = f.now:CreateTexture(nil, "ARTWORK")
	acc:SetPoint("TOPLEFT", 1, -1)
	acc:SetPoint("TOPRIGHT", -1, -1)
	acc:SetHeight(2)
	f.nowAccent = acc
	f.now.label = Label(f.now, ns:L("FOV_LABEL_NOW"))
	f.now.title = Text(f.now, FONT_HEAD, 21, A.text, FALLBACK_HEAD)
	f.now.title:SetPoint("TOPLEFT", 14, -32)
	f.now.title:SetPoint("RIGHT", -14, 0)
	f.now.what = Text(f.now, FONT_TEXT, 14, A.text)
	f.now.what:SetPoint("TOPLEFT", f.now.title, "BOTTOMLEFT", 0, -4)
	f.now.what:SetPoint("RIGHT", -14, 0)
	f.now.place = Text(f.now, FONT_TEXT, 12, A.dim)
	f.now.place:SetPoint("TOPLEFT", f.now.what, "BOTTOMLEFT", 0, -3)
	f.now.place:SetPoint("RIGHT", -14, 0)
	f.now.go = Button(f.now, 132)
	f.now.go:SetPoint("TOPLEFT", f.now.place, "BOTTOMLEFT", 0, -8)
	f.now.go:SetLabel(ns:L("FOV_GO"))
	-- Further "now" lines, each with its own arrow button when it has a place.
	f.now.more = {}
	for i = 1, 2 do
		local row = CreateFrame("Frame", nil, f.now)
		row:SetHeight(30)
		row:SetPoint("LEFT", 14, 0)
		row:SetPoint("RIGHT", -14, 0)
		row:SetPoint("BOTTOM", 0, 10 + (2 - i) * 32)
		row.text = Text(row, FONT_TEXT_B, 13, A.text)
		row.text:SetPoint("TOPLEFT")
		row.text:SetPoint("RIGHT", -70, 0)
		row.text:SetWordWrap(false)
		row.sub = Text(row, FONT_TEXT, 11, A.dim)
		row.sub:SetPoint("TOPLEFT", row.text, "BOTTOMLEFT", 0, -1)
		row.sub:SetPoint("RIGHT", -70, 0)
		row.sub:SetWordWrap(false)
		row.go = Button(row, 62)
		row.go:SetHeight(20)
		row.go:SetPoint("RIGHT")
		row.go:SetLabel(ns:L("FOV_GO_SHORT"))
		f.now.more[i] = row
	end

	f.soon = Card(f)
	f.soon:SetPoint("TOPLEFT", f.now, "TOPRIGHT", 12, 0)
	f.soon:SetSize(soonW, rowH)
	f.soon.label = Label(f.soon, ns:L("FOV_LABEL_SOON"))
	f.soon.rows = {}
	for i = 1, 4 do
		local ic = Icon(f.soon, 26)
		ic:SetPoint("TOPLEFT", 14, -34 - (i - 1) * 38)
		local nm = Text(f.soon, FONT_TEXT_B, 15, A.text)
		nm:SetPoint("TOPLEFT", ic, "TOPRIGHT", 8, 1)
		nm:SetPoint("RIGHT", f.soon, "RIGHT", -10, 0)
		nm:SetWordWrap(false)
		local lv = Text(f.soon, FONT_TEXT, 12, A.dim)
		lv:SetPoint("TOPLEFT", nm, "BOTTOMLEFT", 0, -1)
		f.soon.rows[i] = { icon = ic, name = nm, level = lv }
	end

	f.cq = Card(f)
	f.cq:SetPoint("TOPLEFT", f.soon, "TOPRIGHT", 12, 0)
	f.cq:SetSize(cqW, rowH)
	f.cq.label = Label(f.cq, ns:L("FOV_LABEL_CQ"))
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

	-- Row 2: your path (level now → +6).
	f.path = Card(f)
	f.path:SetPoint("TOPLEFT", f.now, "BOTTOMLEFT", 0, -12)
	f.path:SetPoint("BOTTOMRIGHT", -16, 16)
	f.path.label = Label(f.path, "")
	f.path.track = f.path:CreateTexture(nil, "ARTWORK")
	f.path.track:SetColorTexture(A.dim[1], A.dim[2], A.dim[3], 0.35)
	f.path.track:SetHeight(2)
	f.path.track:SetPoint("TOPLEFT", 30, -54)
	f.path.track:SetPoint("TOPRIGHT", -30, -54)
	f.path.nodes = {}
	for i = 1, 4 do
		local n = {}
		n.ring = f.path:CreateTexture(nil, "ARTWORK", nil, 2)
		n.ring:SetSize(28, 28)
		n.ring:SetColorTexture(A.dim[1], A.dim[2], A.dim[3], 1)
		n.dot = f.path:CreateTexture(nil, "ARTWORK", nil, 3)
		n.dot:SetSize(24, 24)
		n.dot:SetPoint("CENTER", n.ring)
		n.dot:SetColorTexture(0.10, 0.08, 0.06, 1)
		pcall(function()
			for _, t in ipairs({ n.ring, n.dot }) do
				local m = f.path:CreateMaskTexture()
				m:SetTexture("Interface\\CharacterFrame\\TempPortraitAlphaMask", "CLAMPTOBLACKADDITIVE", "CLAMPTOBLACKADDITIVE")
				m:SetAllPoints(t)
				t:AddMaskTexture(m)
			end
		end)
		n.num = Text(f.path, FONT_HEAD, 14, A.text, FALLBACK_HEAD)
		n.num:SetPoint("CENTER", n.ring, "CENTER", 0, 0)
		n.num:SetJustifyH("CENTER")
		n.icon = Icon(f.path, 24)
		n.icon:SetPoint("TOPLEFT", n.ring, "BOTTOMLEFT", 0, -12)
		n.name = Text(f.path, FONT_TEXT_B, 15, A.text)
		n.name:SetPoint("TOPLEFT", n.icon, "TOPRIGHT", 8, 2)
		n.name:SetWidth(150)
		n.name:SetWordWrap(false)
		n.sub = Text(f.path, FONT_TEXT, 12, A.dim)
		n.sub:SetPoint("TOPLEFT", n.name, "BOTTOMLEFT", 0, -1)
		n.sub:SetWidth(150)
		n.sub:SetWordWrap(false)
		f.path.nodes[i] = n
	end
	f.path.chips = {}
	for i, key in ipairs({ "FOV_CHIP_NOW", "FOV_CHIP_CAN", "FOV_CHIP_LATER" }) do
		local c = CreateFrame("Frame", nil, f.path, "BackdropTemplate")
		c:SetSize(64, 18)
		c:SetPoint("TOPRIGHT", -14 - (3 - i) * 70, -10)
		c:SetBackdrop({ bgFile = "Interface\\Buttons\\WHITE8X8", edgeFile = "Interface\\Buttons\\WHITE8X8", edgeSize = 1 })
		c:SetBackdropColor(0, 0, 0, 0.3)
		c.t = Text(c, FONT_HEAD2, 11, A.text, FALLBACK_TEXT)
		c.t:SetPoint("CENTER")
		c.t:SetJustifyH("CENTER")
		c.t:SetText(ns:L(key))
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

function ns.ForeverOverviewFill()
	local f = Build()
	local r, g, b = Accent()
	f.nowAccent:SetColorTexture(r, g, b, 0.9)
	-- Left column.
	if SetPortraitTexture then
		pcall(SetPortraitTexture, f.portrait, "player")
	end
	f.name:SetText(UnitName("player") or "")
	local race = UnitRace and UnitRace("player") or ""
	local cls = UnitClass and UnitClass("player") or ""
	local tree
	if ns.GetForeverDirection then
		local _, t = ns.GetForeverDirection()
		tree = t
	end
	local faction = UnitFactionGroup and select(2, UnitFactionGroup("player")) or nil
	f.who:SetText(("%s · %s%s%s"):format(race, cls, tree and (" · " .. tree) or "", faction and ("\n" .. faction) or ""))
	f.sealWord:SetText(ns:L("FOV_LEVEL"))
	local level = UnitLevel and UnitLevel("player") or 1
	f.sealLevel:SetText(tostring(level))

	-- Do this now.
	local items = NowItems()
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
			row.text:SetText(it.title or "")
			row.sub:SetText(it.place or it.what or "")
			SetGo(row.go, it.go)
			row:Show()
		else
			row:Hide()
		end
	end

	-- Coming up (the next 4 trainer spells, next 6 levels).
	local up = Upcoming(6)
	for i, row in ipairs(f.soon.rows) do
		local e = up[i]
		if e then
			row.icon:SetTexture(SpellIcon(e.id))
			row.icon:Show()
			row.name:SetText(e.name)
			row.level:SetText(ns:L("FOV_LEVEL_FMT"):format(e.l))
		else
			row.icon:Hide()
			row.name:SetText(i == 1 and ns:L("FOV_SOON_NONE") or "")
			row.level:SetText("")
		end
	end

	-- Class quest.
	local okC, cq = false, nil
	if ns.ForeverClassQuestNowParts then
		okC, cq = pcall(ns.ForeverClassQuestNowParts)
	end
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
		if #nodes < 4 then
			nodes[#nodes + 1] = { l = l, list = byLevel[l] }
		end
	end
	local trackW = f.path:GetWidth() - 60
	for i, n in ipairs(f.path.nodes) do
		local d = nodes[i]
		local x = 30 + (i - 1) * (trackW / 3)
		n.ring:ClearAllPoints()
		n.ring:SetPoint("CENTER", f.path, "TOPLEFT", x, -55)
		if d then
			for _, t in ipairs({ n.ring, n.dot, n.num, n.icon, n.name, n.sub }) do
				t:Show()
			end
			n.num:SetText(tostring(d.l))
			if d.now then
				n.ring:SetColorTexture(r, g, b, 1)
				local first = items[1]
				n.icon:SetTexture(134400)
				n.icon:Hide()
				n.name:ClearAllPoints()
				n.name:SetPoint("TOPLEFT", n.ring, "BOTTOMLEFT", 0, -12)
				n.name:SetText(ns:L("FOV_PATH_NOW"))
				n.sub:SetText(first and first.title or ns:L("FOV_ALL_DONE"))
			else
				n.ring:SetColorTexture(A.dim[1], A.dim[2], A.dim[3], 1)
				n.icon:SetTexture(SpellIcon(d.list[1].id))
				n.name:ClearAllPoints()
				n.name:SetPoint("TOPLEFT", n.icon, "TOPRIGHT", 8, 2)
				n.name:SetText(d.list[1].name)
				n.sub:SetText(#d.list > 1 and ns:L("FOV_PATH_MORE_FMT"):format(#d.list - 1) or ns:L("FOV_PATH_NEW"))
			end
		else
			for _, t in ipairs({ n.ring, n.dot, n.num, n.icon, n.name, n.sub }) do
				t:Hide()
			end
		end
	end
	-- Chips: NOW in the accent colour, CAN ALREADY green, LATER grey.
	local chipCol = { { r, g, b }, { 0.45, 0.85, 0.40 }, { 0.6, 0.6, 0.6 } }
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
