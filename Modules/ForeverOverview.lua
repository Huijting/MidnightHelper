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
local W, H = 920, 520
-- Header: title row, then a row of tabs (room for 7: plan step 1), then the line and the content.
local TAB_Y, LINE_Y, TOP_Y, TAB_SLOTS = -50, -82, -96, 7
local LEFT_W = 176

local win

--------------------------------------------------------------------------------
-- Data: what the cards say (nothing new is measured here)
--------------------------------------------------------------------------------

--- The "do this now" items, most important first: { title, what, place, go, goLabel, kind, tip }.
--- 17 Nov 2026 (product plan step 2, Rob: "ja doe maar"): the list is ForeverDoNow's own Collect() — the small "Do this
--- now" window and this card say the same, line for line. Only the trainer and the class quest get richer parts here
--- (title, what, place on its own line); every other line is the window's sentence with the window's action.
local function NowItems()
	local items = {}
	local level = UnitLevel and UnitLevel("player") or 1
	local okI, info = false, nil
	if ns.ForeverDoNowCollect then
		okI, info = pcall(ns.ForeverDoNowCollect)
	end
	if not (okI and type(info) == "table" and type(info.items) == "table") then
		return items
	end
	local ACTS = ns.FOREVER_DONOW_ACTS or {}
	local function Act(kind, key)
		if kind == "tool" and key then
			return function()
				if SlashCmdList and SlashCmdList["MIDNIGHTHELPER"] then
					SlashCmdList["MIDNIGHTHELPER"]("vendor " .. key)
				end
			end, "FOV_GO_SHORT"
		end
		local a = ACTS[kind]
		if not a then
			return nil
		end
		if a.page and not a.fn then
			return function()
				ns.ShowForeverOverviewPage(a.page)
			end, a.label
		end
		return a.fn, a.label
	end
	local rich = {}
	local r = ns.ForeverTrainerCompute and ns.ForeverTrainerCompute(level)
	if r and #r.now > 0 then
		local npc
		if ns.ForeverTrainerNearestNpc then
			local _, nm = ns.ForeverTrainerNearestNpc()
			npc = nm
		end
		local money = GetCoinTextureString and GetCoinTextureString(r.total or 0) or tostring(r.total or 0)
		rich.trainer = {
			kind = "trainer",
			title = (#r.now == 1 and ns:L("FOV_TRAINER_ONE_FMT") or ns:L("FOV_TRAINER_MANY_FMT")):format(#r.now,
				npc or ns:L("FOV_YOUR_TRAINER")),
			what = ns:L("FOV_COST_FMT"):format(money),
			place = ns.ForeverTrainerNearestText and ns.ForeverTrainerNearestText() or nil,
			go = ns.ForeverTrainerGo,
			page = "trainer", -- the card's "Details" button (step 3)
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
		rich.classquest = {
			kind = "classquest",
			title = ns:L("FOV_CQ_TITLE_FMT"):format(cq.chain or "?"),
			what = what,
			place = Place(cq.zone, cq.x, cq.y),
			go = cq.zone and ns.ForeverClassQuestGo or nil,
		}
	end
	-- To-dos first (in the window's order), then the tips.
	for pass = 1, 2 do
		for _, it in ipairs(info.items) do
			if (pass == 1) == (not it.tip) then
				if rich[it.kind] then
					items[#items + 1] = rich[it.kind]
					rich[it.kind] = nil
				elseif not (it.kind == "trainer" or it.kind == "classquest") then
					local go, label = Act(it.kind, it.key)
					items[#items + 1] = { kind = it.tip and "tip" or it.kind, title = it.text, go = go, goLabel = label }
				end
			end
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
	{ key = "FOV_TAB_NOW", tip = "FOV_TIP_TAB_NOW", page = "now" },
	{ key = "FOV_TAB_PLAY", tip = "FOV_TIP_TAB_PLAY", page = "play" },
	-- Step 5 of the plan (Rob: every tab in this style): a tab with `page` switches the page inside this window.
	{ key = "FOV_TAB_CQ", tip = "FOV_TIP_TAB_CQ", page = "cq" },
	{ key = "FOV_TAB_CAMP", tip = "FOV_TIP_TAB_CAMP", page = "camp" },
	{ key = "FOV_TAB_LEGACY", tip = "FOV_TIP_TAB_LEGACY", page = "legacy" },
}

local PATH_NODES = 4
local CQP_ROW_H = 74

--- Class quests page (step 2 of the house style, 17 Nov 2026): one card, a scrolling list of every class quest of
--- this character with level, spell icon, state chip, the next step, the place and its own "Show the way" button.
--- Built with the window (not on first click): DialogPopup wraps the scroll frame's wheel on show, so Shift+wheel
--- keeps resizing the window over the list.
local function BuildClassQuestPage(f, x0, rightW)
	local page = f.pages.cq
	local card = Card(page)
	card:SetPoint("TOPLEFT", f, "TOPLEFT", x0, TOP_Y)
	card:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -16, 16)
	card.label = Label(card, ns:L("FOV_LABEL_CQ_LIST"), "FOV_TIP_CARD_CQ")
	card.count = Text(card, "head2", 12, A.dim)
	card.count:SetPoint("TOPRIGHT", -16, -12)
	card.count:SetJustifyH("RIGHT")
	card.intro = Text(card, "text", 13, A.dim)
	card.intro:SetPoint("TOPLEFT", 14, -30)
	card.intro:SetPoint("RIGHT", -14, 0)
	card.intro:SetText(ns:L("FOV_CQP_INTRO"))
	local sf, child = S.Scroll(card, 54, 8, CQP_ROW_H)
	child:SetWidth(rightW - 30)
	card.sf, card.child, card.rows = sf, child, {}
	f.cqPage = card
end

--- One row of the Class quests page (made when needed).
local function ClassQuestRow(card, i)
	local row = card.rows[i]
	if row then
		return row
	end
	local child = card.child
	row = CreateFrame("Frame", nil, child)
	row:SetHeight(CQP_ROW_H - 6)
	row:SetPoint("TOPLEFT", 0, -(i - 1) * CQP_ROW_H)
	row:SetPoint("RIGHT", child, "RIGHT", 0, 0)
	local sep = row:CreateTexture(nil, "ARTWORK")
	sep:SetColorTexture(A.edge[1], A.edge[2], A.edge[3], 0.35)
	sep:SetHeight(1)
	sep:SetPoint("BOTTOMLEFT", 6, -3)
	sep:SetPoint("BOTTOMRIGHT", 0, -3)
	row.ring = Circle(row, nil, 2)
	row.ring:SetSize(34, 34)
	row.ring:SetPoint("TOPLEFT", 8, -4)
	row.dot = Circle(row, nil, 3)
	row.dot:SetSize(30, 30)
	row.dot:SetPoint("CENTER", row.ring)
	row.dot:SetColorTexture(0.10, 0.08, 0.06, 1)
	row.num = Text(row, "head", 15)
	row.num:SetPoint("CENTER", row.ring, "CENTER", 0, 0)
	row.num:SetJustifyH("CENTER")
	row.levelTip = HoverOver(row, row.ring)
	row.icon = SpellButton(row, 26)
	row.icon:SetPoint("TOPLEFT", row.ring, "TOPRIGHT", 10, -4)
	row.go = Button(row, 132)
	row.go:SetPoint("RIGHT", -8, 0)
	row.go:SetLabel(ns:L("FOV_GO"))
	Tip(row.go, ns:L("FOV_GO"), ns:L("FOV_TIP_GO"))
	row.chip = Tip(S.Chip(row, "", nil, 64))
	row.chip:SetPoint("TOPRIGHT", row, "TOPRIGHT", -(8 + 132 + 12), -4)
	row.name = Text(row, "head", 17)
	row.name:SetPoint("TOPLEFT", row.icon, "TOPRIGHT", 10, 2)
	row.name:SetPoint("RIGHT", row.chip, "LEFT", -8, 0)
	row.name:SetWordWrap(false)
	row.what = Text(row, "text", 13)
	row.what:SetPoint("TOPLEFT", row.name, "BOTTOMLEFT", 0, -2)
	row.what:SetPoint("RIGHT", row.go, "LEFT", -12, 0)
	if row.what.SetMaxLines then
		row.what:SetMaxLines(2)
	end
	row.place = Text(row, "text", 12, A.dim)
	row.place:SetPoint("TOPLEFT", row.what, "BOTTOMLEFT", 0, -2)
	row.place:SetPoint("RIGHT", row.go, "LEFT", -12, 0)
	row.place:SetWordWrap(false)
	-- The full name and step on hover (a long chain name is cut to one line).
	row.hover = HoverOver(row, row.name)
	card.rows[i] = row
	return row
end

local INFO_ROWS = 6

--- Camping and Legacy pages (step 3, 17 Nov 2026): left a card with what MH can read now (one row per reading, a chip
--- yes / no / ? or a number) and below it what that means for you; right the explanation card (the same text as in
--- How you play, in the client's language), scrolling.
local function BuildInfoPage(f, key, x0, rightW, labelKey, tipKey, howKey)
	local page = f.pages[key]
	local stW = math.floor(rightW * 0.40)
	local st = Card(page)
	st:SetPoint("TOPLEFT", f, "TOPLEFT", x0, TOP_Y)
	st:SetPoint("BOTTOMLEFT", f, "BOTTOMLEFT", x0, 16)
	st:SetWidth(stW)
	st.label = Label(st, ns:L(labelKey), tipKey)
	st.rows = {}
	for i = 1, INFO_ROWS do
		local row = CreateFrame("Frame", nil, st)
		row:SetHeight(30)
		row:SetPoint("TOPLEFT", 14, -34 - (i - 1) * 32)
		row:SetPoint("RIGHT", -14, 0)
		local sep = row:CreateTexture(nil, "ARTWORK")
		sep:SetColorTexture(A.edge[1], A.edge[2], A.edge[3], 0.35)
		sep:SetHeight(1)
		sep:SetPoint("BOTTOMLEFT")
		sep:SetPoint("BOTTOMRIGHT")
		row.name = Text(row, "textB", 14)
		row.name:SetPoint("LEFT")
		row.name:SetPoint("RIGHT", -78, 0)
		row.name:SetWordWrap(false)
		row.chip = Tip(S.Chip(row, "", nil, 70))
		row.chip:SetPoint("RIGHT")
		row.hover = HoverOver(row, row.name)
		st.rows[i] = row
	end
	st.what = Text(st, "head", 17)
	st.what:SetPoint("TOPLEFT", 14, -34 - INFO_ROWS * 32 - 10)
	st.what:SetPoint("RIGHT", -14, 0)
	st.why = Text(st, "text", 12, A.dim)
	st.why:SetPoint("TOPLEFT", st.what, "BOTTOMLEFT", 0, -6)
	st.why:SetPoint("RIGHT", -14, 0)
	local how = Card(page)
	how:SetPoint("TOPLEFT", st, "TOPRIGHT", 12, 0)
	how:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -16, 16)
	how.label = Label(how, ns:L(howKey), "FOV_TIP_CARD_HOW")
	how.sf, how.child = S.Scroll(how, 34, 10, 40)
	how.text = Text(how.child, "text", 14)
	how.text:SetPoint("TOPLEFT", 6, 0)
	how.text:SetPoint("RIGHT", how.child, "RIGHT", -6, 0)
	if how.text.SetSpacing then
		how.text:SetSpacing(3)
	end
	page.status, page.how = st, how
end

--- Fill one row of an info page: name (with a tooltip), chip text and colour, chip tooltip.
local function InfoRow(row, name, tipBody, chipText, col, chipTip)
	row.name:SetText(name)
	row.hover.tipTitle, row.hover.tipBody = name, tipBody
	row.chip.t:SetText(chipText)
	row.chip:SetColor(col[1], col[2], col[3])
	row.chip.tipTitle, row.chip.tipBody = chipText, chipTip
	row:Show()
end

local NOW_ROW_H = 46

--- One row of the "Do this now" list under the main line (made when needed).
local function NowRow(card, i)
	local row = card.more[i]
	if row then
		return row
	end
	row = CreateFrame("Frame", nil, card.child)
	row:SetHeight(NOW_ROW_H - 4) -- room for a three-line tip
	row:SetPoint("TOPLEFT", 6, -(i - 1) * NOW_ROW_H - 4)
	row:SetPoint("RIGHT", card.child, "RIGHT", -2, 0)
	local sep = row:CreateTexture(nil, "ARTWORK")
	sep:SetColorTexture(A.edge[1], A.edge[2], A.edge[3], 0.35)
	sep:SetHeight(1)
	sep:SetPoint("TOPLEFT", 0, 3)
	sep:SetPoint("TOPRIGHT", 0, 3)
	row.text = Text(row, "textB", 13, A.text)
	row.text:SetPoint("TOPLEFT")
	row.text:SetPoint("RIGHT", -74, 0)
	row.sub = Text(row, "text", 11, A.dim)
	row.sub:SetPoint("TOPLEFT", row.text, "BOTTOMLEFT", 0, -1)
	row.sub:SetPoint("RIGHT", -74, 0)
	row.sub:SetWordWrap(false)
	row.hover = HoverOver(row, row.text)
	row.hover:SetPoint("BOTTOMRIGHT", row.sub, "BOTTOMRIGHT")
	row.go = Button(row, 70)
	row.go:SetHeight(20)
	row.go:SetPoint("RIGHT")
	row.go:SetLabel(ns:L("FOV_GO_SHORT"))
	Tip(row.go)
	card.more[i] = row
	return row
end

local TOC_ROWS = 14

--- How you play page (step 4, 17 Nov 2026): left a "contents" card (one line per section, click = jump there; the
--- direction button and the other-roles switch), right the whole text with real headings, scrolling.
local function BuildPlayPage(f, x0, rightW)
	local page = f.pages.play
	local tocW = math.floor(rightW * 0.28)
	local toc = Card(page)
	toc:SetPoint("TOPLEFT", f, "TOPLEFT", x0, TOP_Y)
	toc:SetPoint("BOTTOMLEFT", f, "BOTTOMLEFT", x0, 16)
	toc:SetWidth(tocW)
	toc.label = Label(toc, ns:L("FOV_LABEL_TOC"), "FOV_TIP_CARD_TOC")
	toc.rows = {}
	for i = 1, TOC_ROWS do
		local b = CreateFrame("Button", nil, toc)
		b:SetHeight(20)
		b:SetPoint("TOPLEFT", 14, -32 - (i - 1) * 21)
		b:SetPoint("RIGHT", -10, 0)
		b.t = Text(b, "textB", 13)
		b.t:SetPoint("LEFT")
		b.t:SetPoint("RIGHT")
		b.t:SetWordWrap(false)
		b:SetScript("OnEnter", function(self)
			local r, g, bl = Accent()
			self.t:SetTextColor(r, g, bl)
		end)
		b:SetScript("OnLeave", function(self)
			self.t:SetTextColor(self.col[1], self.col[2], self.col[3])
		end)
		b.col = A.text
		toc.rows[i] = b
	end
	toc.dir = Button(toc, tocW - 28)
	toc.dir:SetPoint("BOTTOMLEFT", 14, 44)
	toc.dir:SetScript("OnClick", function()
		if ns.ShowForeverDirection then
			ns.ShowForeverDirection()
		end
	end)
	Tip(toc.dir, ns:L("FOV_DIR_BTN"), ns:L("FOV_TIP_DIR_BTN"))
	toc.roles = Button(toc, tocW - 28)
	toc.roles:SetPoint("BOTTOMLEFT", 14, 14)
	toc.roles:SetScript("OnClick", function()
		f.allRoles = not f.allRoles
		ns.ForeverOverviewFill()
	end)
	Tip(toc.roles, ns:L("FOV_ROLES_BTN_TIP_TITLE"), ns:L("FOV_TIP_ROLES_BTN"))
	local body = Card(page)
	body:SetPoint("TOPLEFT", toc, "TOPRIGHT", 12, 0)
	body:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -16, 16)
	body.label = Label(body, "", "FOV_TIP_TAB_PLAY")
	body.sf, body.child = S.Scroll(body, 34, 10, 60)
	body.textW = (rightW - tocW - 12) - 22 - 12
	body.secs = {}
	page.toc, page.body = toc, body
end

--- One heading + text pair on the How you play page (made when needed).
local function PlaySection(body, i)
	local s = body.secs[i]
	if s then
		return s
	end
	s = {}
	s.head = Text(body.child, "head", 19, A.gold)
	s.head:SetWidth(body.textW)
	s.text = Text(body.child, "text", 14)
	s.text:SetWidth(body.textW)
	if s.text.SetSpacing then
		s.text:SetSpacing(3)
	end
	body.secs[i] = s
	return s
end

local function Build()
	if win then
		return win
	end
	A = S.T()
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
	line:SetPoint("TOPLEFT", 1, LINE_Y)
	line:SetPoint("TOPRIGHT", -1, LINE_Y)
	line:SetHeight(1)
	local close = CreateFrame("Button", nil, f, "UIPanelCloseButton")
	close:SetPoint("TOPRIGHT", -2, -2)
	-- "All tools": the classic Midnight Helper window, for everything that has no tab here yet (the front door — /mh,
	-- Alt+M, minimap — opens this overview in Forever since 17 Nov 2026, plan step 1). Rob may drop it once every tab
	-- of the plan exists.
	local old = Button(f, 110)
	old:SetHeight(20)
	old:SetPoint("TOPRIGHT", -34, -16)
	old:SetLabel(ns:L("FOV_OLDWIN_BTN"))
	old:SetScript("OnClick", function()
		if ns.ToggleMainWindow then
			ns:ToggleMainWindow()
		end
	end)
	Tip(old, ns:L("FOV_OLDWIN_BTN"), ns:L("FOV_TIP_OLDWIN"))
	-- Tabs on their own row under the title (plan step 1: 7 tabs and long German words did not fit next to the title).
	-- TAB_SLOTS equal widths, so the row stays put when a tab is added.
	f.tabs = {}
	local tabW = math.floor((W - 32 - (TAB_SLOTS - 1) * 6) / TAB_SLOTS)
	for i = 1, #TABS do
		local t = TABS[i]
		local b = Button(f, tabW)
		b:SetPoint("TOPLEFT", 16 + (i - 1) * (tabW + 6), TAB_Y)
		b:SetLabel(ns:L(t.key))
		b:SetScript("OnClick", function()
			if t.page then
				f.page = t.page
				ns.ForeverOverviewFill()
			elseif t.fn then
				t.fn()
			end
		end)
		b.page = t.page
		Tip(b, ns:L(t.key), ns:L(t.tip))
		f.tabs[i] = b
	end
	-- Pages: the left column (portrait, level) stays, the right part switches.
	f.page = "now"
	f.pages = {}
	for _, key in ipairs({ "now", "play", "cq", "camp", "legacy" }) do
		local p = CreateFrame("Frame", nil, f)
		p:SetAllPoints(f)
		p:Hide()
		f.pages[key] = p
	end

	-- Left: portrait, name, race · class, XP, level seal.
	local left = Card(f)
	left:SetPoint("TOPLEFT", 16, TOP_Y)
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
	f.name:SetWidth(LEFT_W - 16)
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
	-- Gold (product plan step 2: "Deze week + geld").
	f.gold = Text(left, "text", 13, A.text)
	f.gold:SetPoint("TOP", f.xpText, "BOTTOM", 0, -8)
	f.gold:SetJustifyH("CENTER")
	HoverOver(left, f.gold, ns:L("FOV_GOLD_FMT"):format(""), ns:L("FOV_TIP_GOLD"))
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
	f.now = Card(f.pages.now)
	f.now:SetPoint("TOPLEFT", x0, TOP_Y)
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
	if f.now.what.SetMaxLines then
		f.now.what:SetMaxLines(2)
	end
	f.now.place = Text(f.now, "text", 12, A.dim)
	f.now.place:SetPoint("TOPLEFT", f.now.what, "BOTTOMLEFT", 0, -3)
	f.now.place:SetPoint("RIGHT", -14, 0)
	f.now.place:SetWordWrap(false)
	-- Plan step 2: the main line's buttons sit on the label row, so the whole list fits below.
	f.now.go = Button(f.now, 110)
	f.now.go:SetHeight(20)
	f.now.go:SetPoint("TOPRIGHT", -10, -8)
	f.now.go:SetLabel(ns:L("FOV_GO"))
	Tip(f.now.go, ns:L("FOV_GO"), ns:L("FOV_TIP_GO"))
	f.now.detail = Button(f.now, 70)
	f.now.detail:SetHeight(20)
	f.now.detail:SetPoint("RIGHT", f.now.go, "LEFT", -6, 0)
	f.now.detail:SetLabel(ns:L("FOV_DETAILS"))
	Tip(f.now.detail, ns:L("FOV_DETAILS"), ns:L("FOV_TIP_DETAILS"))
	-- Every other line of the "Do this now" list (product plan step 2: the whole list, not two), scrolling, each with
	-- its own button when the small window has one for it.
	f.now.sf, f.now.child = S.Scroll(f.now, 140, 8, 44)
	f.now.more = {}

	f.soon = Card(f.pages.now)
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

	-- "This week" (product plan step 2): resets, today's events, raid lockouts (ForeverWeek.lua, the same rows as the
	-- start page and /mh week). It took the place of the class-quest card: class quests have their own tab now, and
	-- the open step is in "Do this now" (Rob may turn this back).
	f.week = Card(f.pages.now)
	f.week:SetPoint("TOPLEFT", f.soon, "TOPRIGHT", 12, 0)
	f.week:SetSize(cqW, rowH)
	f.week.label = Label(f.week, ns:L("FOV_LABEL_WEEK"), "FOV_TIP_CARD_WEEK")
	f.week.sf, f.week.child = S.Scroll(f.week, 32, 8, 30)
	f.week.text = Text(f.week.child, "text", 13)
	f.week.text:SetPoint("TOPLEFT", 6, 0)
	f.week.text:SetPoint("RIGHT", f.week.child, "RIGHT", -4, 0)
	if f.week.text.SetSpacing then
		f.week.text:SetSpacing(4)
	end

	-- Row 2: your path (level now → +6), in equal columns that stay inside the card (Rob's screenshot: the last ran out).
	f.path = Card(f.pages.now)
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

	BuildClassQuestPage(f, x0, rightW)
	BuildPlayPage(f, x0, rightW)
	BuildInfoPage(f, "camp", x0, rightW, "FOV_LABEL_CAMP", "FOV_TIP_CARD_CAMP", "FOV_LABEL_CAMP_HOW")
	BuildInfoPage(f, "legacy", x0, rightW, "FOV_LABEL_LEGACY", "FOV_TIP_CARD_LEGACY", "FOV_LABEL_LEGACY_HOW")
	-- Camping and Legacy read live state (an aura, points): refresh every 2 s while one of them is open.
	local acc = 0
	f:HookScript("OnUpdate", function(_, el)
		if f.page ~= "camp" and f.page ~= "legacy" then
			return
		end
		acc = acc + el
		if acc >= 2 then
			acc = 0
			ns.ForeverOverviewFill(true)
		end
	end)

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

--- The character's whole name. Rob, 17 Nov 2026 (via Sparring 17-11), verbatim: "kunnen we hier de hele naam neerzetten?
--- Eventueel onder elkaar de voor- en de achternaam, als het te lang wordt." The overview showed only "IMA".
--- GEMETEN: Forever characters have a first and a last name (Rob's WTF folders: Ima-Pallie, Ima-Lockie, Joey-Whatever).
--- NOT measured: which API gives the last name. So every candidate is written to ns.db.foreverNameProbe, and a last
--- name is only shown when the client really gives one: a candidate with a space that starts with the first name, or
--- the second value of UnitFullName when that is not the realm (AFGELEID: the folder looks like "name-realm").
--- Otherwise the first name alone, as before.
local function FullName()
	local first = UnitName and UnitName("player") or ""
	local probe = { unitName = first }
	local function str(v)
		return type(v) == "string" and not (issecretvalue and issecretvalue(v)) and v ~= "" and v or nil
	end
	local best
	if GetUnitName then
		local ok, v = pcall(GetUnitName, "player", true)
		probe.getUnitNameTrue = ok and str(v) or nil
	end
	if UnitPVPName then
		local ok, v = pcall(UnitPVPName, "player")
		probe.unitPVPName = ok and str(v) or nil
	end
	local realm = GetRealmName and GetRealmName() or nil
	local norm = GetNormalizedRealmName and GetNormalizedRealmName() or nil
	probe.realm, probe.normRealm = realm, norm
	if UnitFullName then
		local ok, n, r = pcall(UnitFullName, "player")
		probe.unitFullName, probe.unitFullNameRealm = ok and str(n) or nil, ok and str(r) or nil
		local last = probe.unitFullNameRealm
		if last and last ~= realm and last ~= norm and not last:find("%s") then
			best = first .. " " .. last
		end
	end
	for _, k in ipairs({ "getUnitNameTrue", "unitPVPName" }) do
		local v = probe[k]
		if not best and v and v:find(" ", 1, true) and v:sub(1, #first + 1) == first .. " " then
			best = v
		end
	end
	probe.shown = best or first
	if ns.db then
		ns.db.foreverNameProbe = probe
	end
	return probe.shown
end

local function FillLeft(f, level)
	local r, g, b = Accent()
	if SetPortraitTexture then
		pcall(SetPortraitTexture, f.portrait, "player")
	end
	local name = FullName()
	-- One line when it fits (shrink to 16), else first and last name under each other; never cut off.
	local first, rest = name:match("^(%S+)%s+(.+)$")
	local size = 22
	S.Font(f.name, A.fonts.head, size, A.fallback.head)
	f.name:SetText(name)
	while size > 16 and f.name:GetStringWidth() > LEFT_W - 16 do
		size = size - 1
		S.Font(f.name, A.fonts.head, size, A.fallback.head)
		f.name:SetText(name)
	end
	if f.name:GetStringWidth() > LEFT_W - 16 and first then
		S.Font(f.name, A.fonts.head, 20, A.fallback.head)
		f.name:SetText(first .. "\n" .. rest)
	end
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
	local money = GetMoney and GetMoney() or 0
	f.gold:SetText(ns:L("FOV_GOLD_FMT"):format(GetCoinTextureString and GetCoinTextureString(money) or tostring(money)))
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
		f.now.go:SetLabel(ns:L(main.goLabel or "FOV_GO"))
		f.now.go.tipTitle = ns:L(main.goLabel or "FOV_GO")
		SetGo(f.now.go, main.go)
		-- A detail page for this line (the trainer, plan step 3), when the overview has one.
		SetGo(f.now.detail, main.page and f.pages[main.page] and function()
			ns.ShowForeverOverviewPage(main.page)
		end or nil)
	else
		f.now.title:SetText(ns:L("FOV_ALL_DONE"))
		local nxt = up and up[1]
		f.now.what:SetText(nxt and ns:L("FOV_NEXT_SPELL_FMT"):format(nxt.name, nxt.l) or ns:L("FOV_ALL_DONE_SUB"))
		f.now.place:SetText("")
		SetGo(f.now.go, nil)
		SetGo(f.now.detail, nil)
	end
	local rest = {}
	for _, it in ipairs(items) do
		if it ~= main then
			rest[#rest + 1] = it
		end
	end
	-- The whole rest of the list (plan step 2), scrolling; each line with the window's own button for it.
	for i, it in ipairs(rest) do
		local row = NowRow(f.now, i)
		-- A line without a place or second line (a tip) may use three lines (sparring: "Dungeons for your level… Ragefir…").
		local sub = it.place or it.what
		row.text:SetWordWrap(sub == nil)
		if row.text.SetMaxLines then
			row.text:SetMaxLines(sub == nil and 3 or 1)
		end
		row.text:SetTextColor(it.kind == "tip" and A.dim[1] or A.text[1], it.kind == "tip" and A.dim[2] or A.text[2],
			it.kind == "tip" and A.dim[3] or A.text[3])
		row.text:SetText(it.title or "")
		row.sub:SetText(sub or "")
		row.hover.tipTitle = it.title
		row.hover.tipBody = it.what and it.place and (it.what .. "\n" .. it.place) or it.what or it.place
		local label = ns:L(it.goLabel or "FOV_GO_SHORT")
		row.go:SetLabel(label)
		row.go.tipTitle = label
		row.go.tipBody = (it.go == ns.ForeverTrainerGo or it.go == ns.ForeverClassQuestGo) and ns:L("FOV_TIP_GO") or nil
		SetGo(row.go, it.go)
		row:Show()
	end
	for i = #rest + 1, #f.now.more do
		f.now.more[i]:Hide()
	end
	f.now.child:SetHeight(math.max(10, #rest * NOW_ROW_H))
	f.now.sf.Reset()
end

--- "This week" card: the rows ForeverWeek.lua gives the start page (resets, events, raids), coloured by tone.
local WEEK_TONE = { soft = "ffe6dcc8", dim = "ffa89a85", warn = "ffeeb055", good = "ff8fd47a" }
local function FillWeek(f)
	local rows = {}
	if ns.ForeverWeekRows then
		local ok, r = pcall(ns.ForeverWeekRows)
		rows = ok and type(r) == "table" and r or {}
	end
	local lines = {}
	for _, r in ipairs(rows) do
		lines[#lines + 1] = "|c" .. (WEEK_TONE[r.tone] or WEEK_TONE.soft) .. tostring(r.text or "") .. "|r"
	end
	f.week.text:SetText(table.concat(lines, "\n"))
	f.week.child:SetHeight(math.max(10, (f.week.text:GetStringHeight() or 0) + 8))
	f.week.sf.UpdateThumb()
end

--- The step of a class quest list entry as one sentence without the place (the place has its own line).
local function StepLine(e)
	if e.what then
		return e.what
	end
	if e.npc then
		return (e.kind == "turn" and ns:L("FOV_CQ_TURN_FMT") or ns:L("FOV_CQ_GET_FMT")):format(e.npc)
	end
	return nil
end

--- The Class quests page: every chain in level order, with the next step and an arrow button per row.
local function FillClassQuestPage(f, level)
	local card = f.cqPage
	local list = {}
	if ns.ForeverClassQuestList then
		local ok, l = pcall(ns.ForeverClassQuestList)
		list = ok and type(l) == "table" and l or {}
	end
	-- Level order; at the same level the table order stays (sort with the index as tie-break: table.sort is not stable).
	for i, e in ipairs(list) do
		e._i = i
	end
	table.sort(list, function(a, b)
		if (a.level or 0) ~= (b.level or 0) then
			return (a.level or 0) < (b.level or 0)
		end
		return a._i < b._i
	end)
	local done = 0
	for _, e in ipairs(list) do
		if e.state == "done" then
			done = done + 1
		end
	end
	card.count:SetText(#list > 0 and ns:L("FOV_CQP_COUNT_FMT"):format(done, #list) or "")
	card.intro:SetText(#list > 0 and ns:L("FOV_CQP_INTRO") or ns:L("FOV_CQP_NONE"))
	local r, g, b = Accent()
	for i, e in ipairs(list) do
		local row = ClassQuestRow(card, i)
		row.num:SetText(tostring(e.level or ""))
		row.levelTip.tipTitle = ns:L("FOV_LEVEL_FMT"):format(e.level or 0)
		row.name:SetText(e.chain or "")
		if e.spell then
			row.icon.tex:SetTexture(SpellIcon(e.spell))
			row.icon.tipSpell = e.spell
			row.icon:Show()
		else
			row.icon.tipSpell = nil
			row.icon:Hide()
		end
		if e.state == "done" then
			row.ring:SetColorTexture(A.done[1], A.done[2], A.done[3], 1)
			row.num:SetTextColor(A.done[1], A.done[2], A.done[3])
			row.chip.t:SetText(ns:L("FOV_CHIP_DONE"))
			row.chip:SetColor(A.done[1], A.done[2], A.done[3])
			row.chip.tipTitle, row.chip.tipBody = ns:L("FOV_CHIP_DONE"), ns:L("FOV_TIP_CHIP_DONE")
			row.what:SetText(ns:L("FOV_CQ_ST_DONE"))
			row.what:SetTextColor(A.dim[1], A.dim[2], A.dim[3])
		elseif e.state == "now" then
			row.ring:SetColorTexture(r, g, b, 1)
			row.num:SetTextColor(r, g, b)
			row.chip.t:SetText(ns:L("FOV_CHIP_NOW"))
			row.chip:SetColor(r, g, b)
			row.chip.tipTitle, row.chip.tipBody = ns:L("FOV_CHIP_NOW"), ns:L("FOV_TIP_CQP_NOW")
			row.what:SetText(StepLine(e) or "")
			row.what:SetTextColor(A.text[1], A.text[2], A.text[3])
		else
			row.ring:SetColorTexture(A.later[1], A.later[2], A.later[3], 1)
			row.num:SetTextColor(A.text[1], A.text[2], A.text[3])
			row.chip.t:SetText(ns:L("FOV_CHIP_LATER"))
			row.chip:SetColor(A.later[1], A.later[2], A.later[3])
			row.chip.tipTitle, row.chip.tipBody = ns:L("FOV_CHIP_LATER"), ns:L("FOV_TIP_CQP_LATER_FMT"):format(e.level or 0)
			local from = ns:L("FOV_FROM_LEVEL_FMT"):format(e.level or 0)
			local step = StepLine(e)
			row.what:SetText(step and (step .. " · " .. from) or from)
			row.what:SetTextColor(A.dim[1], A.dim[2], A.dim[3])
		end
		row.place:SetText(e.state ~= "done" and Place(e.zone, e.x, e.y) or "")
		row.hover.tipTitle = e.chain
		row.hover.tipBody = row.what:GetText()
		SetGo(row.go, e.state ~= "done" and e.zone and e.go or nil)
		row:Show()
	end
	for i = #list + 1, #card.rows do
		card.rows[i]:Hide()
	end
	card.child:SetHeight(math.max(10, #list * CQP_ROW_H))
	card.sf.Reset()
end

local GREEN, RED = { 0.45, 0.85, 0.40 }, { 0.95, 0.45, 0.40 }

--- yes / no / ? chip for an aura reading (nil = the client did not let us read it: never shown as "no").
local function YesNo(v)
	if v == nil then
		return "?", A.later, ns:L("FOV_TIP_UNREADABLE")
	end
	if v then
		return ns:L("FOV_YES"), GREEN, nil
	end
	return ns:L("FOV_NO"), A.dim, nil
end

--- The explanation card: the shared How you play section by its English title, in this client's language.
local function FillHow(how, englishTitle, refresh)
	if not refresh then
		local _, body = nil, nil
		if ns.ForeverHowToCommon then
			_, body = ns.ForeverHowToCommon(englishTitle)
		end
		how.text:SetText(body and S.Format(body) or "")
	end
	-- Again on every refresh: right after the page is shown the width may not be laid out yet.
	how.child:SetHeight(math.max(10, (how.text:GetStringHeight() or 0) + 12))
	if refresh then
		how.sf.UpdateThumb()
	else
		how.sf.Reset()
	end
end

local function FillCampPage(f, refresh)
	local page = f.pages.camp
	local st = page.status
	local ids = ns.FOREVER_CAMP_AURAS or {}
	local s = ns.ForeverCampState and ns.ForeverCampState() or {}
	local function welcoming()
		if s.welcoming or s.welcoming2 then
			return true
		end
		if s.welcoming == nil and s.welcoming2 == nil then
			return nil
		end
		return false
	end
	local rows = {
		{ ids.nearby, s.nearby, "FOV_TIP_CAMP_NEARBY" },
		{ ids.welcoming, welcoming(), "FOV_TIP_CAMP_WELCOMING" },
		{ ids.benefits, s.benefits, "FOV_TIP_CAMP_BENEFITS" },
		{ ids.rest, s.rest, "FOV_TIP_CAMP_REST" },
		{ ids.camping, s.camping, "FOV_TIP_CAMP_COOLDOWN" },
	}
	for i, row in ipairs(st.rows) do
		local d = rows[i]
		if d and d[1] then
			local chip, col, chipTip = YesNo(d[2])
			InfoRow(row, SpellName(d[1]) or ("#" .. d[1]), ns:L(d[3]), chip, col, chipTip)
		else
			row:Hide()
		end
	end
	-- What it means for you, from the same readings as "Do this now" (ForeverCampNow); unreadable = say so, never guess.
	local line = ns.ForeverCampNow and ns.ForeverCampNow() or nil
	local what, why
	if InCombatLockdown and InCombatLockdown() then
		what = ns:L("FOV_ST_COMBAT")
	elseif line then
		what = line
	elseif s.benefits then
		what = ns:L("FOV_CAMP_ST_HAVE")
	elseif welcoming() then
		what = ns:L("FOV_CAMP_ST_SITTING")
	elseif s.nearby == false then
		what = ns:L("FOV_CAMP_ST_NOFIRE")
	else
		what, why = ns:L("FOV_ST_UNREADABLE"), ns:L("FOV_TIP_UNREADABLE")
	end
	st.what:SetText(what)
	st.why:SetText(why or ns:L("FOV_CAMP_ST_HINT"))
	FillHow(page.how, "Camping", refresh)
end

local function FillLegacyPage(f, refresh)
	local page = f.pages.legacy
	local st = page.status
	local s = ns.ForeverLegacyState and ns.ForeverLegacyState() or {}
	local rank = ns.ForeverTalentedRank and ns.ForeverTalentedRank() or nil
	local function num(v)
		if v == nil then
			return "?", A.later, ns:L("FOV_TIP_UNREADABLE")
		end
		return tostring(v), A.gold, nil
	end
	local rows = {
		{ "FOV_LEG_EARNED", s.earned, "FOV_TIP_LEG_EARNED" },
		{ "FOV_LEG_AVAIL", s.available, "FOV_TIP_LEG_AVAIL" },
		{ "FOV_LEG_SPENT", s.spent, "FOV_TIP_LEG_SPENT" },
		{ "FOV_LEG_CAP", s.cap, "FOV_TIP_LEG_CAP" },
		{ "FOV_LEG_TALENTED", rank, "FOV_TIP_LEG_TALENTED" },
	}
	for i, row in ipairs(st.rows) do
		local d = rows[i]
		if d then
			local chip, col, chipTip = num(d[2])
			-- A positive unused count is the thing to act on: in the class colour.
			if d[1] == "FOV_LEG_AVAIL" and type(d[2]) == "number" and d[2] > 0 then
				local r, g, b = Accent()
				col = { r, g, b }
			end
			InfoRow(row, ns:L(d[1]), ns:L(d[3]), chip, col, chipTip)
		else
			row:Hide()
		end
	end
	local line = ns.ForeverLegacyNow and ns.ForeverLegacyNow() or nil
	local what, why
	if InCombatLockdown and InCombatLockdown() then
		what = ns:L("FOV_ST_COMBAT")
	elseif line then
		what = line
	elseif s.earned == 0 then
		what = ns:L("FOV_LEG_ST_LOCKED")
	elseif type(s.available) == "number" then
		what = ns:L("FOV_LEG_ST_NONE")
	else
		what, why = ns:L("FOV_ST_UNREADABLE"), ns:L("FOV_TIP_UNREADABLE")
	end
	st.what:SetText(what)
	st.why:SetText(why or ns:L("FOV_LEG_ST_HINT"))
	FillHow(page.how, "Legacy Points", refresh)
end

local function FillPlayPage(f)
	local page = f.pages.play
	local toc, body = page.toc, page.body
	local _, token = UnitClass("player")
	token = token or "WARRIOR"
	local secs, folded, hasMine = {}, false, false
	if ns.ForeverHowToSections then
		local ok, s, fo, mi = pcall(ns.ForeverHowToSections, token, f.allRoles)
		if ok and type(s) == "table" then
			secs, folded, hasMine = s, fo, mi
		end
	end
	local cname = ns.ForeverClassName and ns.ForeverClassName(token) or token
	body.label:SetText(ns:L("FOV_LABEL_PLAY_FMT"):format(cname:upper()))
	-- Lay the sections out one under the other; widths are fixed, so the heights are right at once.
	local y = 4
	local tocItems = {}
	for i, sec in ipairs(secs) do
		local s = PlaySection(body, i)
		s.head:ClearAllPoints()
		s.text:ClearAllPoints()
		if sec.title then
			s.head:SetPoint("TOPLEFT", body.child, "TOPLEFT", 6, -y)
			s.head:SetText(sec.title)
			s.head:Show()
			tocItems[#tocItems + 1] = { title = sec.title, y = y, kind = sec.kind }
			y = y + (s.head:GetStringHeight() or 20) + 4
		else
			s.head:Hide()
		end
		s.text:SetPoint("TOPLEFT", body.child, "TOPLEFT", 6, -y)
		local col = (sec.kind == "note" or sec.kind == "folded") and A.dim or A.text
		s.text:SetTextColor(col[1], col[2], col[3])
		s.text:SetText(S.Format(sec.body or ""))
		s.text:Show()
		y = y + (s.text:GetStringHeight() or 0) + 18
	end
	for i = #secs + 1, #body.secs do
		body.secs[i].head:Hide()
		body.secs[i].text:Hide()
	end
	body.child:SetHeight(math.max(10, y))
	body.sf.Reset()
	-- Contents: one line per heading; your direction's role in the class colour.
	local r, g, b = Accent()
	for i, row in ipairs(toc.rows) do
		local it = tocItems[i]
		if it then
			row.t:SetText(it.title)
			row.col = (it.kind == "dir" or it.kind == "role") and { r, g, b } or (it.kind == "folded" and A.dim or A.text)
			row.t:SetTextColor(row.col[1], row.col[2], row.col[3])
			row:SetScript("OnClick", function()
				local max = body.sf:GetVerticalScrollRange() or 0
				body.sf:SetVerticalScroll(math.min(max, it.y))
				body.sf.UpdateThumb()
			end)
			row:Show()
		else
			row:Hide()
		end
	end
	-- Direction button (ForeverDirection.lua) and the other-roles switch (only when there are other roles).
	local band, dname
	if ns.GetForeverDirection then
		band, dname = ns.GetForeverDirection()
	end
	toc.dir:SetLabel(band and ns:L("FDIR_HOWTO_BTN_FMT"):format(dname) or ns:L("FDIR_HOWTO_BTN_NONE"))
	toc.dir:SetShown(ns.ShowForeverDirection ~= nil)
	toc.roles:SetLabel(ns:L(not f.allRoles and "FHOWTO_ROLES_SHOW" or (hasMine and "FHOWTO_ROLES_HIDE" or "FHOWTO_ROLES_FOLD")))
	toc.roles:SetShown(folded)
end

--- Open the overview on a page ("now", "play", "cq", "camp", "legacy", "trainer"); used by the "Do this now" window,
--- the cards' detail buttons and the old commands (plan rule: every old way in lands on the right page).
function ns.ShowForeverOverviewPage(page)
	local f = Build()
	f.page = (page and f.pages[page]) and page or "now"
	if f:IsShown() then
		ns.ForeverOverviewFill()
	else
		f:Show()
	end
end

--- When the direction changes (ForeverHowToPlay.lua calls this): refill if the overview is open.
function ns.ForeverOverviewRefresh()
	if win and win:IsShown() then
		ns.ForeverOverviewFill()
	end
end

function ns.ForeverOverviewFill(refresh)
	local f = Build()
	local r, g, b = Accent()
	f.nowAccent:SetColorTexture(r, g, b, 0.9)
	local level = UnitLevel and UnitLevel("player") or 1
	FillLeft(f, level)

	-- Show the open page and mark its tab.
	for key, p in pairs(f.pages) do
		p:SetShown(key == f.page)
	end
	for _, b in ipairs(f.tabs) do
		if b.page then
			b:SetActive(b.page == f.page)
		end
	end
	if f.page == "cq" then
		FillClassQuestPage(f, level)
		return f
	elseif f.page == "play" then
		FillPlayPage(f)
		return f
	elseif f.page == "camp" then
		FillCampPage(f, refresh)
		return f
	elseif f.page == "legacy" then
		FillLegacyPage(f, refresh)
		return f
	end

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

	FillWeek(f)

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
