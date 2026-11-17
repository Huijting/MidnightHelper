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

-- The building blocks and theme live in ForeverStyle.lua (style kit, 17 Nov 2026: every page uses the same ones).
local S = ns.ForeverStyle
if not S then
	-- A new file is only loaded after a full restart of the game, not after /reload (Rob hit this on 17 Nov 2026).
	function ns.ToggleForeverOverview()
		print("|cff66ccffMidnight Helper|r: the overview needs a full restart of the game (a new file was added).")
	end
	return
end
local A = S.T()
local Accent, Text, Tip, HoverOver, Card, Label = S.Accent, S.Text, S.Tip, S.HoverOver, S.Card, S.Label
local Button, SpellButton, SpellName, SpellIcon, Place = S.Button, S.SpellButton, S.SpellName, S.SpellIcon, S.Place
local function Circle(parent, _, layerSub)
	return S.Circle(parent, layerSub)
end
local W, H = 920, 486
local LEFT_W = 176

local win

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
	f.title = Text(f, "head", 22, A.gold)
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
			b:SetActive(true)
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
	f.name = Text(left, "head", 22, A.text)
	f.name:SetPoint("TOP", ring, "BOTTOM", 0, -8)
	f.name:SetJustifyH("CENTER")
	f.who = Text(left, "text", 13, A.dim)
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
	f.xpText = Text(left, "text", 12, A.dim)
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
	f.sealWord = Text(left, "head2", 10, A.gold)
	f.sealWord:SetPoint("TOP", seal, "TOP", 0, -12)
	f.sealWord:SetJustifyH("CENTER")
	f.sealLevel = Text(left, "head", 26, { 1, 0.95, 0.85 })
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
	f.now.title = Text(f.now, "head", 21, A.text)
	f.now.title:SetPoint("TOPLEFT", 14, -32)
	f.now.title:SetPoint("RIGHT", -14, 0)
	if f.now.title.SetMaxLines then
		f.now.title:SetMaxLines(2) -- room for the lines below it
	end
	f.now.what = Text(f.now, "text", 14, A.text)
	f.now.what:SetPoint("TOPLEFT", f.now.title, "BOTTOMLEFT", 0, -4)
	f.now.what:SetPoint("RIGHT", -14, 0)
	f.now.place = Text(f.now, "text", 12, A.dim)
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
		row.text = Text(row, "textB", 13, A.text)
		row.text:SetPoint("TOPLEFT")
		row.text:SetPoint("RIGHT", -70, 0)
		row.text:SetWordWrap(false)
		row.sub = Text(row, "text", 11, A.dim)
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
		local nm = Text(f.soon, "textB", 15, A.text)
		nm:SetPoint("TOPLEFT", ic, "TOPRIGHT", 8, 1)
		nm:SetPoint("RIGHT", f.soon, "RIGHT", -10, 0)
		nm:SetWordWrap(false)
		local lv = Text(f.soon, "text", 12, A.later)
		lv:SetPoint("TOPLEFT", nm, "BOTTOMLEFT", 0, -1)
		f.soon.rows[i] = { icon = ic, name = nm, level = lv }
	end

	f.cq = Card(f)
	f.cq:SetPoint("TOPLEFT", f.soon, "TOPRIGHT", 12, 0)
	f.cq:SetSize(cqW, rowH)
	f.cq.label = Label(f.cq, ns:L("FOV_LABEL_CQ"), "FOV_TIP_CARD_CQ")
	f.cq.title = Text(f.cq, "head", 18, A.text)
	f.cq.title:SetPoint("TOPLEFT", 14, -32)
	f.cq.title:SetPoint("RIGHT", -12, 0)
	f.cq.what = Text(f.cq, "text", 13, A.text)
	f.cq.what:SetPoint("TOPLEFT", f.cq.title, "BOTTOMLEFT", 0, -4)
	f.cq.what:SetPoint("RIGHT", -12, 0)
	f.cq.place = Text(f.cq, "text", 12, A.dim)
	f.cq.place:SetPoint("TOPLEFT", f.cq.what, "BOTTOMLEFT", 0, -3)
	f.cq.place:SetPoint("RIGHT", -12, 0)
	f.cq.go = Button(f.cq, 120)
	f.cq.go:SetPoint("BOTTOMLEFT", 14, 12)
	f.cq.go:SetLabel(ns:L("FOV_GO"))
	Tip(f.cq.go, ns:L("FOV_GO"), ns:L("FOV_TIP_GO"))
	-- List mode (when "Do this now" already shows the open class quest): every class quest with where it stands.
	f.cq.list = {}
	for i = 1, 6 do
		local lv = Text(f.cq, "head2", 13, A.gold)
		lv:SetPoint("TOPLEFT", 14, -34 - (i - 1) * 30)
		lv:SetWidth(24)
		local nm = Text(f.cq, "textB", 13, A.text)
		nm:SetPoint("TOPLEFT", lv, "TOPRIGHT", 4, 0)
		nm:SetPoint("RIGHT", f.cq, "RIGHT", -10, 0)
		nm:SetWordWrap(false)
		local st = Text(f.cq, "text", 11, A.dim)
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
		n.num = Text(f.path, "head", 14, A.text)
		n.num:SetPoint("CENTER", n.ring, "CENTER", 0, 0)
		n.num:SetJustifyH("CENTER")
		n.hover = HoverOver(f.path, n.ring)
		n.icon = SpellButton(f.path, 24)
		n.icon:SetPoint("TOPLEFT", n.ring, "BOTTOMLEFT", 0, -12)
		n.name = Text(f.path, "textB", 15, A.text)
		n.name:SetWidth(colW - 44)
		n.name:SetWordWrap(false)
		n.sub = Text(f.path, "text", 12, A.dim)
		n.sub:SetPoint("TOPLEFT", n.name, "BOTTOMLEFT", 0, -1)
		n.sub:SetWidth(colW - 44)
		n.sub:SetWordWrap(false)
		f.path.nodes[i] = n
	end
	-- Legend: the colours the nodes really use (Rob's screenshot: three chips, but the nodes used one colour).
	f.path.chips = {}
	for i, key in ipairs({ "FOV_CHIP_NOW", "FOV_CHIP_LATER" }) do
		local c = S.Chip(f.path, ns:L(key))
		c:SetPoint("TOPRIGHT", -14 - (2 - i) * 70, -10)
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

--- Round 5 (Rob's screenshot, 17 Nov 2026): a tip is never the big title. Only a task (trainer, class quest, camp,
--- Legacy) can be the main line; with none, a calm title plus the next new spell, and every tip in the rows below.
local function MainItem(items)
	for _, it in ipairs(items) do
		if it.kind ~= "tip" then
			return it
		end
	end
	return nil
end

local function FillNow(f, items, up)
	local main = MainItem(items)
	if main then
		f.now.title:SetText(main.title or "")
		f.now.what:SetText(main.what or "")
		f.now.place:SetText(main.place or "")
		SetGo(f.now.go, main.go)
	else
		f.now.title:SetText(ns:L("FOV_ALL_DONE"))
		local nxt = up and up[1]
		f.now.what:SetText(nxt and ns:L("FOV_NEXT_SPELL_FMT"):format(nxt.name, nxt.l) or ns:L("FOV_ALL_DONE_SUB"))
		f.now.place:SetText("")
		SetGo(f.now.go, nil)
	end
	local rest = {}
	for _, it in ipairs(items) do
		if it ~= main then
			rest[#rest + 1] = it
		end
	end
	for i, row in ipairs(f.now.more) do
		local it = rest[i]
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
	-- The list when "Do this now" already shows the open class quest, AND when none is open (Rob's screenshot: "No class
	-- quest open right now" while Wolfsbane 20 and Warhorse 40 were still ahead).
	local inNow = false
	for _, it in ipairs(items) do
		if it.kind == "classquest" then
			inNow = true
		end
	end
	local okC, cq = false, nil
	if not inNow and ns.ForeverClassQuestNowParts then
		okC, cq = pcall(ns.ForeverClassQuestNowParts)
	end
	local showList = inNow or not (okC and type(cq) == "table")
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
	local up = Upcoming(6)
	FillNow(f, items, up)

	-- Coming up (the next trainer spells, next 6 levels). Hover an icon: the spell's own tooltip.
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
				local main = MainItem(items)
				n.sub:SetText(main and main.title or ns:L("FOV_ALL_DONE"))
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
		c:SetColor(col[1], col[2], col[3])
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
