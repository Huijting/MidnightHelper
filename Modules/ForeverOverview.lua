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
-- The tabs of the product plan (docs/forever/OVERZICHT_PRODUCT_PLAN_2026-11-17.md): Now, Your class, Find, Professions,
-- Dungeons & group, Keys & macros, Characters. A tab with `page` opens that page; a tab with `group` opens the page
-- of that group you saw last, and the group's pages get a small switch row on top (SUB_ROWS below).
-- Step 4 (17 Nov 2026): How you play, Class quests and Camping became one tab "Your class" (the plan's "Je class"),
-- so seven tabs fit; Legacy keeps its own tab until step 8 moves it to Characters.
local TABS = {
	{ key = "FOV_TAB_NOW", tip = "FOV_TIP_TAB_NOW", page = "now" },
	{ key = "FOV_TAB_CLASS", tip = "FOV_TIP_TAB_CLASS", group = "class" },
	{ key = "FOV_TAB_FIND", tip = "FOV_TIP_TAB_FIND", page = "find" },
	{ key = "FOV_TAB_PROFS", tip = "FOV_TIP_TAB_PROFS", page = "profs" },
	{ key = "FOV_TAB_DUNG", tip = "FOV_TIP_TAB_DUNG", page = "dungeons" },
	{ key = "FOV_TAB_KEYS", tip = "FOV_TIP_TAB_KEYS", page = "keys" },
	-- Step 8: Legacy moved under Characters (with "This week").
	{ key = "FOV_TAB_CHARS", tip = "FOV_TIP_TAB_CHARS", group = "chars" },
}
local GROUPS = {
	class = {
		{ page = "play", key = "FOV_TAB_PLAY", tip = "FOV_TIP_TAB_PLAY" },
		{ page = "cq", key = "FOV_TAB_CQ", tip = "FOV_TIP_TAB_CQ" },
		{ page = "camp", key = "FOV_TAB_CAMP", tip = "FOV_TIP_TAB_CAMP" },
	},
	chars = {
		{ page = "chars", key = "FCHARS_TITLE", tip = "FOV_TIP_SUB_CHARS" },
		{ page = "legacy", key = "FOV_TAB_LEGACY", tip = "FOV_TIP_TAB_LEGACY" },
		{ page = "week", key = "FOV_SUB_WEEK", tip = "FOV_TIP_CARD_WEEK" },
	},
}
local PAGE_GROUP = {}
for g, list in pairs(GROUPS) do
	for _, p in ipairs(list) do
		PAGE_GROUP[p.page] = g
	end
end
-- Pages in a group start lower: their switch row sits at TOP_Y.
local SUB_TOP = TOP_Y - 30

local PATH_NODES = 4
local CQP_ROW_H = 74

--- Class quests page (step 2 of the house style, 17 Nov 2026): one card, a scrolling list of every class quest of
--- this character with level, spell icon, state chip, the next step, the place and its own "Show the way" button.
--- Built with the window (not on first click): DialogPopup wraps the scroll frame's wheel on show, so Shift+wheel
--- keeps resizing the window over the list.
local function BuildClassQuestPage(f, x0, rightW)
	local page = f.pages.cq
	local card = Card(page)
	card:SetPoint("TOPLEFT", f, "TOPLEFT", x0, SUB_TOP)
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
	st:SetPoint("TOPLEFT", f, "TOPLEFT", x0, PAGE_GROUP[key] and SUB_TOP or TOP_Y)
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

local TR_ROW_H = 34

--- Trainer page (product plan step 3): what your class trainer teaches you now, with its price and the key it gets on
--- MH's key block; then what needs an earlier spell first, and the next level. Data: ns.ForeverTrainerPageData
--- (ForeverTrainer.lua, the same as the trainer window). Opened from the Now card's "Details" and on a level-up.
local function BuildTrainerPage(f, x0, rightW)
	local page = f.pages.trainer
	local card = Card(page)
	card:SetPoint("TOPLEFT", f, "TOPLEFT", x0, TOP_Y)
	card:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -16, 16)
	card.label = Label(card, ns:L("FOV_LABEL_TRAINER"), "FOV_TIP_CARD_TRAINER")
	card.go = Button(card, 130)
	card.go:SetHeight(22)
	card.go:SetPoint("TOPRIGHT", -12, -8)
	card.go:SetLabel(ns:L("FOV_GO"))
	Tip(card.go, ns:L("FOV_GO"), ns:L("FOV_TIP_GO"))
	card.go:SetScript("OnClick", function()
		if ns.ForeverTrainerGo then
			ns.ForeverTrainerGo()
		end
	end)
	-- Step 4: every trainer of your class (and the profession trainers) is one click away on the Find tab.
	card.find = Button(card, 120)
	card.find:SetHeight(22)
	card.find:SetPoint("RIGHT", card.go, "LEFT", -6, 0)
	card.find:SetLabel(ns:L("FOV_TR_FIND_BTN"))
	Tip(card.find, ns:L("FOV_TR_FIND_BTN"), ns:L("FOV_TIP_TR_FIND"))
	card.find:SetScript("OnClick", function()
		ns.ShowForeverFind("class")
	end)
	card.money = Text(card, "head2", 15, A.text)
	card.money:SetPoint("TOPLEFT", 14, -32)
	card.money:SetPoint("RIGHT", card.go, "LEFT", -10, 0)
	card.where = Text(card, "text", 12, A.dim)
	card.where:SetPoint("TOPLEFT", card.money, "BOTTOMLEFT", 0, -3)
	card.where:SetPoint("RIGHT", -14, 0)
	card.where:SetWordWrap(false)
	card.sf, card.child = S.Scroll(card, 74, 8, TR_ROW_H * 2)
	card.rows = {}
	page.card = card
end

--- One row of the trainer page: a heading, a spell (icon, name, rank, price, key) or a plain line.
local function TrainerRow(card, i)
	local row = card.rows[i]
	if row then
		return row
	end
	row = CreateFrame("Frame", nil, card.child)
	row:SetHeight(TR_ROW_H - 2)
	row:SetPoint("TOPLEFT", 6, -(i - 1) * TR_ROW_H)
	row:SetPoint("RIGHT", card.child, "RIGHT", -2, 0)
	row.icon = SpellButton(row, 26)
	row.icon:SetPoint("LEFT", 0, 0)
	row.chip = Tip(S.Chip(row, "", nil, 96))
	row.chip:SetPoint("RIGHT", -4, 0)
	row.cost = Text(row, "text", 13, A.dim)
	row.cost:SetPoint("RIGHT", row.chip, "LEFT", -12, 0)
	row.cost:SetJustifyH("RIGHT")
	row.cost:SetWidth(110)
	row.name = Text(row, "textB", 15)
	row.name:SetPoint("LEFT", row.icon, "RIGHT", 10, 0)
	row.name:SetPoint("RIGHT", row.cost, "LEFT", -8, 0)
	row.name:SetWordWrap(false)
	row.head = Text(row, "head2", 14, A.label)
	row.head:SetPoint("LEFT", 0, -2)
	row.head:SetPoint("RIGHT", 0, 0)
	row.line = Text(row, "text", 13, A.text)
	row.line:SetPoint("LEFT", 0, 0)
	row.line:SetPoint("RIGHT", 0, 0)
	if row.line.SetMaxLines then
		row.line:SetMaxLines(2)
	end
	row.hover = HoverOver(row, row.name)
	card.rows[i] = row
	return row
end

local FIND_ITEM_H = 20

--- Find page (product plan step 4, 17 Nov 2026; Rob: "ja ga maar door met 4 tot en met 9"): one place for every
--- "where is …" — your class trainer, the profession trainers, the weapon masters and the shops (tools, General Goods,
--- Trade Supplies). It replaces four windows (ForeverProfTrainers, ForeverVendors, ForeverWeapons and the trainer
--- finder of /mh trainer); their open functions land here. Left: what you can look for (scrolling). Right: the places,
--- nearest first, each with the way there (ForeverTravel.lua) and its own "Show the way" button. Nothing new is
--- measured: the lists are those windows' own (ForeverTrainer/ForeverVendors/ForeverWeapons.lua).
local function BuildFindPage(f, x0, rightW)
	local page = f.pages.find
	local catW = math.floor(rightW * 0.31)
	local cat = Card(page)
	cat:SetPoint("TOPLEFT", f, "TOPLEFT", x0, TOP_Y)
	cat:SetPoint("BOTTOMLEFT", f, "BOTTOMLEFT", x0, 16)
	cat:SetWidth(catW)
	cat.label = Label(cat, ns:L("FOV_LABEL_FIND"), "FOV_TIP_CARD_FIND")
	cat.sf, cat.child = S.Scroll(cat, 34, 8, FIND_ITEM_H * 3)
	cat.child:SetWidth(catW - 22)
	cat.items = {}
	local list = Card(page)
	list:SetPoint("TOPLEFT", cat, "TOPRIGHT", 12, 0)
	list:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -16, 16)
	list.label = Label(list, "", "FOV_TIP_CARD_FIND_LIST")
	list.act = Button(list, 130)
	list.act:SetHeight(22)
	list.act:SetPoint("TOPRIGHT", -12, -8)
	Tip(list.act)
	list.head = Text(list, "head2", 15, A.text)
	list.head:SetPoint("TOPLEFT", 14, -34)
	list.head:SetPoint("RIGHT", -14, 0)
	list.head:SetWordWrap(false)
	list.sub = Text(list, "text", 12, A.dim)
	list.sub:SetPoint("TOPLEFT", list.head, "BOTTOMLEFT", 0, -3)
	list.sub:SetPoint("RIGHT", -14, 0)
	if list.sub.SetMaxLines then
		list.sub:SetMaxLines(3)
	end
	list.hint = Text(list, "text", 11, A.later)
	list.hint:SetPoint("BOTTOMLEFT", 14, 10)
	list.hint:SetPoint("RIGHT", -14, 0)
	if list.hint.SetMaxLines then
		list.hint:SetMaxLines(2)
	end
	-- The scrolling list starts under the head and up to three sub lines; the hint keeps the bottom 40 px.
	list.sf, list.child = S.Scroll(list, 102, 40, 60)
	list.rowW = (rightW - catW - 12) - 22 - 8
	list.child:SetWidth(list.rowW)
	list.rows = {}
	page.cat, page.list = cat, list
end

--- One entry of the "what are you looking for" list: a heading or a clickable line.
local function FindItem(cat, i)
	local b = cat.items[i]
	if b then
		return b
	end
	b = CreateFrame("Button", nil, cat.child)
	b:SetHeight(FIND_ITEM_H - 1)
	b:SetPoint("TOPLEFT", 4, -(i - 1) * FIND_ITEM_H)
	b:SetPoint("RIGHT", cat.child, "RIGHT", -2, 0)
	b.bg = b:CreateTexture(nil, "BACKGROUND")
	b.bg:SetAllPoints()
	b.t = Text(b, "textB", 13)
	b.t:SetPoint("LEFT", 4, 0)
	b.t:SetPoint("RIGHT", -2, 0)
	b.t:SetWordWrap(false)
	b:SetScript("OnEnter", function(self)
		if self.sel then
			local r, g, bl = Accent()
			self.t:SetTextColor(r, g, bl)
		end
		if self.tipBody then
			GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
			GameTooltip:SetText(self.tipTitle or "", 1, 0.82, 0, 1, true)
			GameTooltip:AddLine(self.tipBody, 1, 1, 1, true)
			GameTooltip:Show()
		end
	end)
	b:SetScript("OnLeave", function(self)
		self.t:SetTextColor(self.col[1], self.col[2], self.col[3])
		GameTooltip:Hide()
	end)
	b.col = A.text
	cat.items[i] = b
	return b
end

--- One place on the Find page: name (+ the NPC's subtitle), zone · distance, the way there, and a button.
local function FindRow(list, i)
	local r = list.rows[i]
	if r then
		return r
	end
	r = CreateFrame("Frame", nil, list.child)
	r:SetWidth(list.rowW)
	local sep = r:CreateTexture(nil, "ARTWORK")
	sep:SetColorTexture(A.edge[1], A.edge[2], A.edge[3], 0.35)
	sep:SetHeight(1)
	sep:SetPoint("BOTTOMLEFT", 0, 0)
	sep:SetPoint("BOTTOMRIGHT", 0, 0)
	r.go = Button(r, 124)
	r.go:SetHeight(22)
	r.go:SetPoint("TOPRIGHT", -2, -4)
	r.go:SetLabel(ns:L("FOV_GO"))
	Tip(r.go, ns:L("FOV_GO"), ns:L("FOV_TIP_GO"))
	r.name = Text(r, "textB", 15)
	r.name:SetPoint("TOPLEFT", 4, -4)
	r.name:SetPoint("RIGHT", r.go, "LEFT", -10, 0)
	r.name:SetWordWrap(false)
	r.info = Text(r, "text", 12, A.dim)
	r.info:SetPoint("TOPLEFT", r.name, "BOTTOMLEFT", 0, -2)
	r.info:SetPoint("RIGHT", r.go, "LEFT", -10, 0)
	r.info:SetWordWrap(false)
	r.route = Text(r, "text", 12, A.gold)
	r.route:SetPoint("TOPLEFT", r.info, "BOTTOMLEFT", 0, -3)
	r.route:SetWidth(list.rowW - 8)
	r.hover = HoverOver(r, r.name)
	list.rows[i] = r
	return r
end

--- Keys & macros page (product plan step 5, 17 Nov 2026): left the three doors of "Your keys" (KeysHub.lua: key block,
--- which spells you press, your keyboard) and three switches (mouseover on the key block, the orange edge on an old
--- rank, offering the MH bar layout on a new character); right the handy macros (ForeverMacros.lua) with Make / Update
--- and Free key, the same rows as that window. The key block itself stays a window of its own (plan).
local KEY_DOORS = {
	{ btn = "KEYSHUB_BLOCK_BTN", desc = "KEYSHUB_BLOCK_DESC", fn = function()
		if ns.ShowKeyBlock then
			ns.ShowKeyBlock()
		end
	end },
	{ btn = "KEYSHUB_PRESSES_BTN", desc = "KEYSHUB_PRESSES_DESC", presses = true, fn = function()
		if ns.KeyPressesCommand then
			ns.KeyPressesCommand(nil)
		end
	end },
	{ btn = "KEYSHUB_KEYBOARD_BTN", desc = "KEYSHUB_KEYBOARD_DESC", fn = function()
		if ns.ShowKeysKeyboard then
			ns.ShowKeysKeyboard(nil)
		end
	end },
}
local KEY_SWITCHES = {
	{ title = "FOV_KEYS_SW_MO", tip = "FOV_TIP_KEYS_SW_MO",
		get = function() return ns.IsForeverMouseoverOn and ns.IsForeverMouseoverOn() end,
		set = function(on)
			if ns.ForeverMouseoverSlash then
				ns.ForeverMouseoverSlash(on and "on" or "off")
			end
		end },
	{ title = "SET_FOREVER_RANKGLOW_TITLE", tip = "SET_FOREVER_RANKGLOW_DESC",
		get = function() return ns.IsForeverRankGlowOn and ns.IsForeverRankGlowOn() end,
		set = function(on)
			if ns.SetForeverRankGlow then
				ns.SetForeverRankGlow(on)
			end
		end },
	{ title = "SET_FOREVER_BARLAYOUT_TITLE", tip = "SET_FOREVER_BARLAYOUT_DESC",
		get = function() return ns.IsForeverBarLayoutAskOn and ns.IsForeverBarLayoutAskOn() end,
		set = function(on)
			if ns.SetForeverBarLayoutAsk then
				ns.SetForeverBarLayoutAsk(on)
			end
		end },
}

--- A switch row: the setting's name (hover = what it does) and an ON/OFF chip; a click on the chip flips it.
--- def = { title, tip, get, set }. Used on the Keys and Professions tabs (and the gear page later).
local function MakeSwitch(parent, def, w)
	local t = Text(parent, "textB", 13)
	t:SetWidth(w - 60)
	t:SetText(ns:L(def.title))
	local hover = HoverOver(parent, t, ns:L(def.title), ns:L(def.tip))
	local chip = Tip(S.Chip(parent, "", nil, 52), ns:L(def.title), ns:L("FOV_TIP_SWITCH"))
	chip:SetScript("OnMouseUp", function()
		def.set(not def.get())
		ns.ForeverOverviewFill(true)
	end)
	return { text = t, chip = chip, hover = hover, def = def }
end

--- Show the switch's state on its chip; returns the row height its text needs.
local function FillSwitch(s)
	local on = s.def.get() and true or false
	s.chip.t:SetText(ns:L(on and "FOV_SWITCH_ON" or "FOV_SWITCH_OFF"))
	if on then
		local r, g, b = Accent()
		s.chip:SetColor(r, g, b)
	else
		s.chip:SetColor(A.later[1], A.later[2], A.later[3])
	end
	return math.max(22, (s.text:GetStringHeight() or 16) + 8)
end

local function BuildKeysPage(f, x0, rightW)
	local page = f.pages.keys
	local leftW = math.floor(rightW * 0.38)
	local left = Card(page)
	left:SetPoint("TOPLEFT", f, "TOPLEFT", x0, TOP_Y)
	left:SetPoint("BOTTOMLEFT", f, "BOTTOMLEFT", x0, 16)
	left:SetWidth(leftW)
	left.label = Label(left, ns:L("KEYSHUB_TITLE"):upper(), "FOV_TIP_CARD_KEYS")
	left.sf, left.child = S.Scroll(left, 34, 8, 40)
	local innerW = leftW - 22 - 12
	left.child:SetWidth(innerW + 8)
	left.doors = {}
	for i, d in ipairs(KEY_DOORS) do
		local b = Button(left.child, innerW)
		b:SetLabel(ns:L(d.btn))
		Tip(b, ns:L(d.btn), ns:L(d.desc))
		b:SetScript("OnClick", d.fn)
		local t = Text(left.child, "text", 12, A.dim)
		t:SetWidth(innerW)
		left.doors[i] = { btn = b, desc = t, def = d }
	end
	left.swHead = Text(left.child, "head2", 12, A.label)
	left.swHead:SetText(ns:L("FOV_KEYS_SWITCHES"):upper())
	left.switches = {}
	for i, s in ipairs(KEY_SWITCHES) do
		left.switches[i] = MakeSwitch(left.child, s, innerW)
	end
	local list = Card(page)
	list:SetPoint("TOPLEFT", left, "TOPRIGHT", 12, 0)
	list:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -16, 16)
	list.label = Label(list, ns:L("FMAC_TITLE"):upper(), "FOV_TIP_CARD_MACROS")
	list.sub = Text(list, "text", 12, A.dim)
	list.sub:SetPoint("TOPLEFT", 14, -32)
	list.sub:SetPoint("RIGHT", -14, 0)
	list.sub:SetText(ns:L("FMAC_SUB"))
	list.hint = Text(list, "text", 11, A.later)
	list.hint:SetPoint("BOTTOMLEFT", 14, 12)
	list.hint:SetPoint("RIGHT", -140, 0)
	list.hint:SetText(ns:L("FMAC_HINT"))
	list.undo = Button(list, 120)
	list.undo:SetHeight(22)
	list.undo:SetPoint("BOTTOMRIGHT", -12, 8)
	list.undo:SetLabel(ns:L("FMAC_BTN_UNDO_KEYS"))
	Tip(list.undo, ns:L("FMAC_BTN_UNDO_KEYS"), ns:L("FOV_TIP_UNDO_KEYS"))
	list.undo:SetScript("OnClick", function()
		if ns.ForeverMacroUndoFreedKeys then
			ns.ForeverMacroUndoFreedKeys()
		end
		ns.ForeverOverviewFill(true)
	end)
	list.sf, list.child = S.Scroll(list, 62, 40, 50)
	list.rowW = (rightW - leftW - 12) - 22 - 8
	list.child:SetWidth(list.rowW)
	list.rows = {}
	page.left, page.list = left, list
end

--- One macro row on the Keys page: title, the line under it, Make / Update and Free key.
local function MacroRow(list, i)
	local r = list.rows[i]
	if r then
		return r
	end
	r = CreateFrame("Frame", nil, list.child)
	r:SetWidth(list.rowW)
	local sep = r:CreateTexture(nil, "ARTWORK")
	sep:SetColorTexture(A.edge[1], A.edge[2], A.edge[3], 0.35)
	sep:SetHeight(1)
	sep:SetPoint("BOTTOMLEFT", 0, 0)
	sep:SetPoint("BOTTOMRIGHT", 0, 0)
	r.go = Button(r, 96)
	r.go:SetHeight(22)
	r.go:SetPoint("TOPRIGHT", -2, -4)
	Tip(r.go)
	r.free = Button(r, 96)
	r.free:SetHeight(20)
	r.free:SetPoint("TOP", r.go, "BOTTOM", 0, -4)
	r.free:SetLabel(ns:L("FMAC_BTN_FREE"))
	Tip(r.free, ns:L("FMAC_BTN_FREE"), ns:L("FOV_TIP_FREE_KEY"))
	r.title = Text(r, "textB", 14)
	r.title:SetPoint("TOPLEFT", 4, -4)
	r.title:SetWidth(list.rowW - 112)
	r.title:SetWordWrap(false)
	r.info = Text(r, "text", 12, A.dim)
	r.info:SetPoint("TOPLEFT", r.title, "BOTTOMLEFT", 0, -2)
	r.info:SetWidth(list.rowW - 112)
	list.rows[i] = r
	return r
end

--- Professions page (product plan step 6, 17 Nov 2026): left every profession (yours first, gold, with your skill),
--- right the card of the chosen one (ForeverProfGuide.lua: what it does, main/secondary, tool, pairs, caps, your next
--- rank) with your skill bar, buttons to its trainers and its tool's sellers (Find tab), whether you carry the tool, and
--- at the bottom the three quiet helpers around professions, each with a switch: the "Used for" / "your class can never
--- use" / "needed for a quest" tooltip lines (ReagentUse.lua + ForeverItemTips.lua), the last-tool warnings
--- (ForeverToolGuard.lua) and "where to buy the missing tool" (ForeverVendors.lua).
local PROF_SWITCHES = {
	{ title = "FOV_PROF_SW_USEDFOR", tip = "FOV_TIP_PROF_SW_USEDFOR",
		get = function() return not (ns.db and ns.db.usedForTip == false) end,
		set = function(on)
			if ns.db then
				ns.db.usedForTip = on and true or false
			end
		end },
	{ title = "FOV_PROF_SW_TOOLGUARD", tip = "FOV_TIP_PROF_SW_TOOLGUARD",
		get = function() return ns.IsForeverToolGuardOn and ns.IsForeverToolGuardOn() end,
		set = function(on)
			if ns.SetForeverToolGuard then
				ns.SetForeverToolGuard(on)
			end
		end },
	{ title = "SET_FOREVER_TOOLNEED_TITLE", tip = "SET_FOREVER_TOOLNEED_DESC",
		get = function() return ns.IsForeverToolNeedTipOn and ns.IsForeverToolNeedTipOn() end,
		set = function(on)
			if ns.SetForeverToolNeedTipOn then
				ns.SetForeverToolNeedTipOn(on)
			end
		end },
}
local PROF_ROW_H = 24

local function BuildProfsPage(f, x0, rightW)
	local page = f.pages.profs
	local leftW = math.floor(rightW * 0.32)
	local left = Card(page)
	left:SetPoint("TOPLEFT", f, "TOPLEFT", x0, TOP_Y)
	left:SetPoint("BOTTOMLEFT", f, "BOTTOMLEFT", x0, 16)
	left:SetWidth(leftW)
	left.label = Label(left, ns:L("FOV_LABEL_PROFS"), "FOV_TIP_CARD_PROFS")
	left.rows = {}
	for i = 1, 12 do
		local b = CreateFrame("Button", nil, left)
		b:SetHeight(PROF_ROW_H - 2)
		b:SetPoint("TOPLEFT", 10, -32 - (i - 1) * PROF_ROW_H)
		b:SetPoint("RIGHT", -10, 0)
		b.bg = b:CreateTexture(nil, "BACKGROUND")
		b.bg:SetAllPoints()
		b.t = Text(b, "textB", 14)
		b.t:SetPoint("LEFT", 4, 0)
		b.t:SetPoint("RIGHT", -60, 0)
		b.t:SetWordWrap(false)
		b.skill = Text(b, "text", 12, A.dim)
		b.skill:SetPoint("RIGHT", -4, 0)
		b.skill:SetJustifyH("RIGHT")
		b:SetScript("OnEnter", function(self)
			local r, g, bl = Accent()
			self.t:SetTextColor(r, g, bl)
		end)
		b:SetScript("OnLeave", function(self)
			self.t:SetTextColor(self.col[1], self.col[2], self.col[3])
		end)
		b.col = A.text
		left.rows[i] = b
	end
	local card = Card(page)
	card:SetPoint("TOPLEFT", left, "TOPRIGHT", 12, 0)
	card:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -16, 16)
	card.label = Label(card, "", "FOV_TIP_CARD_PROF")
	card.trainers = Button(card, 120)
	card.trainers:SetHeight(22)
	card.trainers:SetPoint("TOPRIGHT", -12, -8)
	card.trainers:SetLabel(ns:L("FOV_PROF_TRAINERS"))
	Tip(card.trainers, ns:L("FOV_PROF_TRAINERS"), ns:L("FOV_TIP_PROF_TRAINERS"))
	card.buy = Button(card, 120)
	card.buy:SetHeight(22)
	card.buy:SetPoint("RIGHT", card.trainers, "LEFT", -6, 0)
	card.buy:SetLabel(ns:L("FPROFG_BUY"))
	Tip(card.buy, ns:L("FPROFG_BUY"), ns:L("FOV_TIP_FIND_BUY"))
	-- Skill bar (yours only).
	card.skill = Text(card, "head2", 14, A.text)
	card.skill:SetPoint("TOPLEFT", 14, -34)
	card.barBg = card:CreateTexture(nil, "ARTWORK")
	card.barBg:SetColorTexture(0, 0, 0, 0.5)
	card.barBg:SetHeight(8)
	card.barBg:SetPoint("LEFT", card.skill, "RIGHT", 12, 0)
	card.barBg:SetPoint("RIGHT", card, "RIGHT", -14, 0)
	card.barFill = card:CreateTexture(nil, "ARTWORK", nil, 1)
	card.barFill:SetPoint("TOPLEFT", card.barBg)
	card.barFill:SetHeight(8)
	card.tool = Text(card, "text", 13, A.text)
	card.tool:SetPoint("TOPLEFT", 14, -56)
	card.tool:SetPoint("RIGHT", -14, 0)
	card.tool:SetWordWrap(false)
	-- The quiet helpers, fixed at the bottom.
	local innerW = (rightW - leftW - 12) - 28
	card.sw = {}
	for i, s in ipairs(PROF_SWITCHES) do
		card.sw[i] = MakeSwitch(card, s, innerW)
	end
	card.swHead = Text(card, "head2", 12, A.label)
	card.swHead:SetText(ns:L("FOV_PROF_SWITCHES"):upper())
	HoverOver(card, card.swHead, ns:L("FOV_PROF_SWITCHES"), ns:L("FOV_TIP_PROF_SWITCHES"))
	card.sf, card.child = S.Scroll(card, 78, 120, 40)
	card.text = Text(card.child, "text", 14)
	card.text:SetPoint("TOPLEFT", 6, 0)
	card.text:SetPoint("RIGHT", card.child, "RIGHT", -6, 0)
	if card.text.SetSpacing then
		card.text:SetSpacing(3)
	end
	card.innerW = innerW
	page.left, page.card = left, card
end

--- Dungeons & group page (product plan step 7, 17 Nov 2026): left every dungeon for your level (or all, a switch) with
--- its levels, entrance zone, the way there and a Way button (ForeverDungeons.lua, the same states as that window);
--- right your raid lockouts (ForeverWeek.lua) and the group card: the no-XP rule for your group now, and switches for
--- the small group panel and the marker bar.
local GROUP_SWITCHES = {
	{ title = "SET_FOREVER_PARTY_TITLE", tip = "SET_FOREVER_PARTY_DESC",
		get = function() return ns.IsForeverPartyPanelOn and ns.IsForeverPartyPanelOn() end,
		set = function(on)
			if ns.SetForeverPartyPanel then
				ns.SetForeverPartyPanel(on)
			end
		end },
	{ title = "SET_MARK_TOGGLE_TITLE", tip = "SET_MARK_TOGGLE_DESC",
		get = function() return ns.IsFastMarkEnabled and ns.IsFastMarkEnabled() end,
		set = function(on)
			if InCombatLockdown and InCombatLockdown() then
				print("|cffffcc00Midnight Helper:|r " .. ns:L("FOV_ST_COMBAT"))
				return
			end
			if ns.SetFastMarkEnabled then
				ns.SetFastMarkEnabled(on)
			end
		end },
}
local DUNG_ONLYMINE = { title = "FOV_DUNG_ONLYMINE", tip = "FOV_TIP_DUNG_ONLYMINE",
	get = function() return not (ns.IsForeverDungeonsAll and ns.IsForeverDungeonsAll()) end,
	set = function(on)
		if ns.SetForeverDungeonsAll then
			ns.SetForeverDungeonsAll(not on)
		end
	end }

local function BuildDungeonsPage(f, x0, rightW)
	local page = f.pages.dungeons
	local listW = math.floor(rightW * 0.60)
	local list = Card(page)
	list:SetPoint("TOPLEFT", f, "TOPLEFT", x0, TOP_Y)
	list:SetPoint("BOTTOMLEFT", f, "BOTTOMLEFT", x0, 16)
	list:SetWidth(listW)
	list.label = Label(list, ns:L("FOV_LABEL_DUNG"), "FOV_TIP_CARD_DUNG")
	list.only = MakeSwitch(list, DUNG_ONLYMINE, 240)
	list.only.text:SetPoint("TOPRIGHT", list, "TOPRIGHT", -72, -12)
	list.only.text:SetJustifyH("RIGHT")
	list.only.chip:SetPoint("TOPRIGHT", list, "TOPRIGHT", -12, -10)
	list.sf, list.child = S.Scroll(list, 36, 8, 50)
	list.rowW = listW - 22 - 8
	list.child:SetWidth(list.rowW)
	list.rows = {}
	list.empty = Text(list.child, "text", 13, A.dim)
	list.empty:SetPoint("TOPLEFT", 6, -4)
	list.empty:SetWidth(list.rowW - 12)
	local sideW = rightW - listW - 12
	local raids = Card(page)
	raids:SetPoint("TOPLEFT", list, "TOPRIGHT", 12, 0)
	raids:SetSize(sideW, 150)
	raids.label = Label(raids, ns:L("FOV_LABEL_RAIDS"), "FOV_TIP_CARD_RAIDS")
	raids.text = Text(raids, "text", 13)
	raids.text:SetPoint("TOPLEFT", 14, -34)
	raids.text:SetPoint("RIGHT", -14, 0)
	if raids.text.SetSpacing then
		raids.text:SetSpacing(4)
	end
	local grp = Card(page)
	grp:SetPoint("TOPLEFT", raids, "BOTTOMLEFT", 0, -12)
	grp:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -16, 16)
	grp.label = Label(grp, ns:L("FOV_LABEL_GROUP"), "FOV_TIP_CARD_GROUP")
	grp.top = Text(grp, "textB", 13)
	grp.top:SetPoint("TOPLEFT", 14, -34)
	grp.top:SetPoint("RIGHT", -14, 0)
	grp.xp = Text(grp, "text", 12, A.dim)
	grp.xp:SetPoint("TOPLEFT", grp.top, "BOTTOMLEFT", 0, -4)
	grp.xp:SetPoint("RIGHT", -14, 0)
	grp.sw = {}
	for i, s in ipairs(GROUP_SWITCHES) do
		grp.sw[i] = MakeSwitch(grp, s, sideW - 28)
	end
	page.list, page.raids, page.grp = list, raids, grp
end

local function DungeonRow(list, i)
	local r = list.rows[i]
	if r then
		return r
	end
	r = CreateFrame("Frame", nil, list.child)
	r:SetWidth(list.rowW)
	local sep = r:CreateTexture(nil, "ARTWORK")
	sep:SetColorTexture(A.edge[1], A.edge[2], A.edge[3], 0.35)
	sep:SetHeight(1)
	sep:SetPoint("BOTTOMLEFT", 0, 0)
	sep:SetPoint("BOTTOMRIGHT", 0, 0)
	r.chip = Tip(S.Chip(r, "", nil, 58))
	r.chip:SetPoint("TOPLEFT", 2, -6)
	r.go = Button(r, 70)
	r.go:SetHeight(20)
	r.go:SetPoint("TOPRIGHT", -2, -5)
	r.go:SetLabel(ns:L("FOV_GO_SHORT"))
	Tip(r.go, ns:L("FOV_GO"), ns:L("FOV_TIP_GO"))
	r.name = Text(r, "textB", 14)
	r.name:SetPoint("TOPLEFT", r.chip, "TOPRIGHT", 10, 1)
	r.name:SetPoint("RIGHT", r.go, "LEFT", -8, 0)
	r.name:SetWordWrap(false)
	r.info = Text(r, "text", 12, A.dim)
	r.info:SetPoint("TOPLEFT", r.name, "BOTTOMLEFT", 0, -2)
	r.info:SetPoint("RIGHT", r.go, "LEFT", -8, 0)
	r.info:SetWordWrap(false)
	r.route = Text(r, "text", 12, A.gold)
	r.route:SetPoint("TOPLEFT", r.info, "BOTTOMLEFT", 0, -2)
	r.route:SetWidth(list.rowW - 80)
	r.hover = HoverOver(r, r.name)
	list.rows[i] = r
	return r
end

--- Characters page (product plan step 8, 17 Nov 2026): every character of this account (ForeverChars.lua, the same
--- snapshot and texts as that window): side, name, level, gold, direction, last played, spells ready at the trainer,
--- professions; "x" forgets one. The total gold at the top.
local CHAR_ROW_H = 60

local function BuildCharsPage(f, x0, rightW)
	local page = f.pages.chars
	local card = Card(page)
	card:SetPoint("TOPLEFT", f, "TOPLEFT", x0, SUB_TOP)
	card:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -16, 16)
	card.label = Label(card, ns:L("FCHARS_TITLE"):upper(), "FOV_TIP_SUB_CHARS")
	card.total = Text(card, "head2", 14, A.gold)
	card.total:SetPoint("TOPRIGHT", -16, -12)
	card.total:SetJustifyH("RIGHT")
	card.note = Text(card, "text", 11, A.later)
	card.note:SetPoint("BOTTOMLEFT", 14, 10)
	card.note:SetPoint("RIGHT", -14, 0)
	if card.note.SetMaxLines then
		card.note:SetMaxLines(2)
	end
	card.sf, card.child = S.Scroll(card, 34, 40, CHAR_ROW_H)
	card.rowW = rightW - 22 - 8
	card.child:SetWidth(card.rowW)
	card.rows = {}
	page.card = card
end

local function CharRow(card, i)
	local r = card.rows[i]
	if r then
		return r
	end
	r = CreateFrame("Frame", nil, card.child)
	r:SetSize(card.rowW, CHAR_ROW_H - 4)
	r:SetPoint("TOPLEFT", 0, -(i - 1) * CHAR_ROW_H)
	local sep = r:CreateTexture(nil, "ARTWORK")
	sep:SetColorTexture(A.edge[1], A.edge[2], A.edge[3], 0.35)
	sep:SetHeight(1)
	sep:SetPoint("BOTTOMLEFT", 0, -2)
	sep:SetPoint("BOTTOMRIGHT", 0, -2)
	r.forget = Button(r, 22)
	r.forget:SetHeight(20)
	r.forget:SetPoint("TOPRIGHT", -2, -4)
	r.forget:SetLabel("x")
	Tip(r.forget, ns:L("FCHARS_FORGET_TIP"))
	r.gold = Text(r, "textB", 14)
	r.gold:SetPoint("TOPRIGHT", r.forget, "TOPLEFT", -12, -2)
	r.gold:SetJustifyH("RIGHT")
	r.who = Text(r, "head2", 15)
	r.who:SetPoint("TOPLEFT", 4, -4)
	r.who:SetPoint("RIGHT", r.gold, "LEFT", -12, 0)
	r.who:SetWordWrap(false)
	r.line = Text(r, "text", 12, A.text)
	r.line:SetPoint("TOPLEFT", r.who, "BOTTOMLEFT", 0, -3)
	r.line:SetPoint("RIGHT", -8, 0)
	r.line:SetWordWrap(false)
	r.profs = Text(r, "text", 12, A.dim)
	r.profs:SetPoint("TOPLEFT", r.line, "BOTTOMLEFT", 0, -2)
	r.profs:SetPoint("RIGHT", -8, 0)
	r.profs:SetWordWrap(false)
	r.hover = HoverOver(r, r.profs)
	card.rows[i] = r
	return r
end

--- "This week" page (step 8): the whole list of ForeverWeek.lua (resets, today's events, raids, PvP, writs) in one card.
local function BuildWeekPage(f, x0, rightW)
	local page = f.pages.week
	local card = Card(page)
	card:SetPoint("TOPLEFT", f, "TOPLEFT", x0, SUB_TOP)
	card:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -16, 16)
	card.label = Label(card, ns:L("FOV_LABEL_WEEK"), "FOV_TIP_CARD_WEEK")
	card.sf, card.child = S.Scroll(card, 36, 10, 40)
	card.text = Text(card.child, "text", 15)
	card.text:SetPoint("TOPLEFT", 6, 0)
	card.text:SetPoint("RIGHT", card.child, "RIGHT", -6, 0)
	if card.text.SetSpacing then
		card.text:SetSpacing(6)
	end
	page.card = card
end

--- Gear page "What MH does quietly for you" (product plan step 9, 17 Nov 2026): every tooltip line, warning and button
--- MH adds to Blizzard's windows in Forever, one sentence each and a switch; the full settings stay in Blizzard's panel
--- (button at the bottom). A switch writes the same saved value as its slash command / settings entry.
local function DbSub(key, defaults)
	if not ns.db then
		return defaults or {}
	end
	ns.db[key] = ns.db[key] or defaults or {}
	return ns.db[key]
end
local function DbFlag(key, defaultOn)
	return {
		get = function()
			local v = ns.db and ns.db[key]
			if defaultOn then
				return v ~= false
			end
			return v == true
		end,
		set = function(on)
			if ns.db then
				if defaultOn then
					ns.db[key] = (not on) and false or nil
				else
					ns.db[key] = on and true or nil
				end
			end
		end,
	}
end
local function Q(title, tip, gs)
	return { title = title, tip = tip, get = gs.get, set = gs.set }
end
local function Warn(field)
	return {
		get = function() return DbSub("foreverWarn")[field] ~= false end,
		set = function(on) DbSub("foreverWarn")[field] = on and true or false end,
	}
end
local QUIET = {
	{ head = "FOV_Q_HEAD_WINDOWS" },
	Q("FOV_Q_TRAINALL", "FOV_Q_TRAINALL_DESC", {
		get = function() return DbSub("foreverTrainer", { auto = true }).trainAll ~= "off" end,
		set = function(on) DbSub("foreverTrainer", { auto = true }).trainAll = (not on) and "off" or nil end }),
	Q("FOV_Q_TRAINERAUTO", "FOV_Q_TRAINERAUTO_DESC", {
		get = function() return DbSub("foreverTrainer", { auto = true }).auto ~= false end,
		set = function(on) DbSub("foreverTrainer", { auto = true }).auto = on and true or false end }),
	Q("FOV_Q_QUESTHINT", "FOV_Q_QUESTHINT_DESC", DbFlag("foreverQuestHint", true)),
	Q("SET_FOREVER_DIRECTION_TITLE", "SET_FOREVER_DIRECTION_DESC", {
		get = function() return ns.IsForeverDirectionAskOn and ns.IsForeverDirectionAskOn() end,
		set = function(on) if ns.SetForeverDirectionAsk then ns.SetForeverDirectionAsk(on) end end }),
	KEY_SWITCHES[3], -- offer the MH bar layout
	{ head = "FOV_Q_HEAD_TOOLTIPS" },
	PROF_SWITCHES[1], -- Used for / never usable / quest item
	Q("FOV_Q_GEARTIP", "FOV_Q_GEARTIP_DESC", DbFlag("foreverGearTip", true)),
	Q("SET_BLESSTIP_TITLE", "SET_BLESSTIP_DESC", DbFlag("foreverBlessTip", false)),
	{ head = "FOV_Q_HEAD_WARN" },
	Q("FOV_Q_BAGS", "FOV_Q_BAGS_DESC", Warn("bags")),
	Q("FOV_Q_REST", "FOV_Q_REST_DESC", Warn("rest")),
	Q("FOV_Q_POLE", "FOV_Q_POLE_DESC", Warn("pole")),
	PROF_SWITCHES[2], -- last tool
	PROF_SWITCHES[3], -- missing tool: where to buy
	{ head = "FOV_Q_HEAD_SCREEN" },
	KEY_SWITCHES[2], -- old-rank edge
	KEY_SWITCHES[1], -- mouseover on the key block
	GROUP_SWITCHES[1], -- group panel
	GROUP_SWITCHES[2], -- marker bar
	Q("SET_FIREWORKS_TITLE", "SET_FIREWORKS_DESC", {
		get = function() return ns.IsLevelUpFireworksOn and ns.IsLevelUpFireworksOn() end,
		set = function(on) if ns.SetLevelUpFireworks then ns.SetLevelUpFireworks(on) end end }),
	Q("SET_CAMERAFAR_TITLE", "SET_CAMERAFAR_DESC", {
		get = function() return ns.IsCameraFarOn and ns.IsCameraFarOn() end,
		set = function(on) if ns.SetCameraFar then ns.SetCameraFar(on, true) end end }),
}

local function BuildQuietPage(f, x0, rightW)
	local page = f.pages.quiet
	local card = Card(page)
	card:SetPoint("TOPLEFT", f, "TOPLEFT", x0, TOP_Y)
	card:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -16, 16)
	card.label = Label(card, ns:L("FOV_LABEL_QUIET"), "FOV_TIP_CARD_QUIET")
	card.all = Button(card, 150)
	card.all:SetHeight(22)
	card.all:SetPoint("TOPRIGHT", -12, -8)
	card.all:SetLabel(ns:L("FOV_Q_ALLSETTINGS"))
	Tip(card.all, ns:L("FOV_Q_ALLSETTINGS"), ns:L("FOV_TIP_Q_ALLSETTINGS"))
	card.all:SetScript("OnClick", function()
		if ns.OpenNativeSettings then
			ns.OpenNativeSettings()
		end
	end)
	card.intro = Text(card, "text", 12, A.dim)
	card.intro:SetPoint("TOPLEFT", 14, -32)
	card.intro:SetPoint("RIGHT", -14, 0)
	card.intro:SetText(ns:L("FOV_Q_INTRO"))
	card.sf, card.child = S.Scroll(card, 52, 8, 50)
	local w = rightW - 22 - 12
	card.child:SetWidth(w + 8)
	card.items = {}
	for i, q in ipairs(QUIET) do
		if q.head then
			local h = Text(card.child, "head2", 13, A.label)
			h:SetText(ns:L(q.head):upper())
			card.items[i] = { head = h }
		else
			local s = MakeSwitch(card.child, q, w)
			s.desc = Text(card.child, "text", 12, A.dim)
			s.desc:SetWidth(w - 70)
			s.desc:SetText(ns:L(q.tip))
			card.items[i] = s
		end
	end
	page.card = card
end

-- Step 4: the page starts 30 px lower (switch row of "Your class"), so the rows are 19 px apart instead of 21.
local TOC_ROWS, TOC_STEP = 14, 19

--- How you play page (step 4, 17 Nov 2026): left a "contents" card (one line per section, click = jump there; the
--- direction button and the other-roles switch), right the whole text with real headings, scrolling.
local function BuildPlayPage(f, x0, rightW)
	local page = f.pages.play
	local tocW = math.floor(rightW * 0.28)
	local toc = Card(page)
	toc:SetPoint("TOPLEFT", f, "TOPLEFT", x0, SUB_TOP)
	toc:SetPoint("BOTTOMLEFT", f, "BOTTOMLEFT", x0, 16)
	toc:SetWidth(tocW)
	toc.label = Label(toc, ns:L("FOV_LABEL_TOC"), "FOV_TIP_CARD_TOC")
	toc.rows = {}
	for i = 1, TOC_ROWS do
		local b = CreateFrame("Button", nil, toc)
		b:SetHeight(TOC_STEP - 1)
		b:SetPoint("TOPLEFT", 14, -32 - (i - 1) * TOC_STEP)
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
	-- The gear (product plan step 9): the page "What MH does quietly for you", with a door to Blizzard's settings panel.
	-- Again = back to Now. A game icon, not a glyph: our fonts have no gear sign (and lint [14] forbids emoji).
	local gear = Button(f, 26)
	gear:SetHeight(20)
	gear:SetPoint("RIGHT", old, "LEFT", -6, 0)
	gear.icon = gear:CreateTexture(nil, "OVERLAY")
	gear.icon:SetSize(16, 16)
	gear.icon:SetPoint("CENTER")
	gear.icon:SetTexture("Interface\\Icons\\INV_Misc_Gear_01")
	gear.icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
	gear:SetScript("OnClick", function()
		f.page = (f.page == "quiet") and "now" or "quiet"
		ns.ForeverOverviewFill()
	end)
	Tip(gear, ns:L("FOV_LABEL_QUIET"), ns:L("FOV_TIP_GEAR"))
	f.gear = gear
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
			if t.group then
				f.page = f.lastInGroup[t.group] or GROUPS[t.group][1].page
				ns.ForeverOverviewFill()
			elseif t.page then
				f.page = t.page
				ns.ForeverOverviewFill()
			elseif t.fn then
				t.fn()
			end
		end)
		b.page, b.group = t.page, t.group
		Tip(b, ns:L(t.key), ns:L(t.tip))
		f.tabs[i] = b
	end
	-- Pages: the left column (portrait, level) stays, the right part switches.
	f.page = "now"
	f.lastInGroup = {}
	f.pages = {}
	for _, key in ipairs({ "now", "play", "cq", "camp", "legacy", "trainer", "find", "keys", "profs", "dungeons", "chars", "week", "quiet" }) do
		local p = CreateFrame("Frame", nil, f)
		p:SetAllPoints(f)
		p:Hide()
		f.pages[key] = p
	end
	-- The switch row of a tab with several pages ("Your class": How you play · Class quests · Camping), at TOP_Y.
	local x0s = 16 + LEFT_W + 12
	f.subRows = {}
	for g, list in pairs(GROUPS) do
		local row = CreateFrame("Frame", nil, f)
		row:SetSize(W - x0s - 16, 24)
		row:SetPoint("TOPLEFT", x0s, TOP_Y)
		row.btns = {}
		for i, p in ipairs(list) do
			local b = Button(row, 160)
			b:SetHeight(22)
			b:SetPoint("TOPLEFT", (i - 1) * 166, 0)
			b:SetLabel(ns:L(p.key))
			Tip(b, ns:L(p.key), ns:L(p.tip))
			b:SetScript("OnClick", function()
				f.page = p.page
				ns.ForeverOverviewFill()
			end)
			b.page = p.page
			row.btns[i] = b
		end
		row:Hide()
		f.subRows[g] = row
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
	BuildTrainerPage(f, x0, rightW)
	BuildFindPage(f, x0, rightW)
	BuildKeysPage(f, x0, rightW)
	BuildProfsPage(f, x0, rightW)
	BuildDungeonsPage(f, x0, rightW)
	BuildCharsPage(f, x0, rightW)
	BuildWeekPage(f, x0, rightW)
	BuildQuietPage(f, x0, rightW)
	-- Find and Professions: distances, names, skills and the tool in your bags change when you change zone, the client
	-- loads an item name, a skill goes up or your bags change; fill again then (not every 2 s: the order of the list
	-- must not jump under your mouse).
	f:RegisterEvent("ZONE_CHANGED_NEW_AREA")
	f:RegisterEvent("GET_ITEM_INFO_RECEIVED")
	f:RegisterEvent("SKILL_LINES_CHANGED")
	f:RegisterEvent("BAG_UPDATE_DELAYED")
	-- Dungeons & group: your group, your target (the no-XP line) and the raid info that arrives late.
	f:RegisterEvent("GROUP_ROSTER_UPDATE")
	f:RegisterEvent("PLAYER_TARGET_CHANGED")
	f:RegisterEvent("UPDATE_INSTANCE_INFO")
	local LIVE = { find = true, profs = true, dungeons = true }
	f:SetScript("OnEvent", function(self)
		if self:IsShown() and LIVE[self.page] and not self.findPending and C_Timer and C_Timer.After then
			self.findPending = true
			C_Timer.After(0.3, function()
				self.findPending = nil
				if self:IsShown() and LIVE[self.page] then
					ns.ForeverOverviewFill(true)
				end
			end)
		end
	end)
	BuildInfoPage(f, "camp", x0, rightW, "FOV_LABEL_CAMP", "FOV_TIP_CARD_CAMP", "FOV_LABEL_CAMP_HOW")
	BuildInfoPage(f, "legacy", x0, rightW, "FOV_LABEL_LEGACY", "FOV_TIP_CARD_LEGACY", "FOV_LABEL_LEGACY_HOW")
	-- Camping and Legacy read live state (an aura, points): refresh every 2 s while one of them is open.
	local acc = 0
	f:HookScript("OnUpdate", function(_, el)
		if f.page ~= "camp" and f.page ~= "legacy" and f.page ~= "trainer" then
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
--- `toggle`: when the overview is already open on that page, close it (the old windows closed on a second /mh trainer).
function ns.ShowForeverOverviewPage(page, toggle)
	local f = Build()
	page = (page and f.pages[page]) and page or "now"
	if toggle and f:IsShown() and f.page == page then
		f:Hide()
		return
	end
	f.page = page
	if f:IsShown() then
		ns.ForeverOverviewFill()
	else
		f:Show()
	end
end

local function FillTrainerPage(f, level, refresh)
	local card = f.pages.trainer.card
	local d
	if ns.ForeverTrainerPageData then
		local ok, r = pcall(ns.ForeverTrainerPageData, level)
		d = ok and type(r) == "table" and r or nil
	end
	d = d or { now = {}, needs = {}, next = {}, totems = {} }
	-- Money on top; red with what is missing (the trainer window's rule, Rob 7 Nov 2026).
	local money = d.haveText and ns:L("FOV_TR_MONEY_FMT"):format(d.haveText, d.totalText or "") or ""
	if d.short then
		money = money .. "  |cffff5555" .. ns:L("FTRAIN_SHORT_FMT"):format(d.short) .. "|r"
	end
	card.money:SetText(#d.now > 0 and money or ns:L("FTRAIN_NOTHING"))
	card.where:SetText(ns.ForeverTrainerNearestText and ns.ForeverTrainerNearestText() or "")
	local list = {}
	local function head(t)
		list[#list + 1] = { head = t }
	end
	if #d.totems > 0 then
		head(ns:L("FTRAIN_TOTEM_HEAD"))
		for _, t in ipairs(d.totems) do
			list[#list + 1] = { line = "|cffff8040" .. t .. "|r" }
		end
	end
	if #d.now > 0 then
		head(ns:L("FTRAIN_NOW_FMT"):format(#d.now))
		for _, e in ipairs(d.now) do
			list[#list + 1] = { spell = e }
			if e.note then
				list[#list + 1] = { line = "|cffff8040" .. e.note .. "|r" }
			end
		end
	end
	if #d.needs > 0 then
		head(ns:L("FTRAIN_NEEDS_HEAD"))
		for _, n in ipairs(d.needs) do
			list[#list + 1] = { line = n.text }
		end
	end
	if d.nextLevel and #d.next > 0 then
		head(ns:L("FTRAIN_NEXT_FMT"):format(d.nextLevel))
		for _, e in ipairs(d.next) do
			list[#list + 1] = { spell = e, later = true }
		end
	end
	local r, g, b = Accent()
	for i, it in ipairs(list) do
		local row = TrainerRow(card, i)
		local e = it.spell
		row.head:SetShown(it.head ~= nil)
		row.line:SetShown(it.line ~= nil)
		for _, part in ipairs({ row.icon, row.chip, row.cost, row.name }) do
			part:SetShown(e ~= nil)
		end
		if it.head then
			row.head:SetText(it.head)
		elseif it.line then
			row.line:SetText(it.line)
		else
			row.icon.tex:SetTexture(SpellIcon(e.id))
			row.icon.tipSpell = e.id
			row.name:SetText(e.name .. (e.rank and (" |cff9d9d9d(" .. e.rank .. ")|r") or ""))
			row.name:SetTextColor(it.later and A.dim[1] or A.text[1], it.later and A.dim[2] or A.text[2], it.later and A.dim[3] or A.text[3])
			row.cost:SetText(e.cost or "")
			row.hover.tipTitle = e.name
			row.hover.tipBody = e.key and ns:L("FOV_TIP_TR_KEY_FMT"):format(e.key) or e.where
			if e.key then
				row.chip.t:SetText(e.key)
				row.chip:SetColor(r, g, b)
				row.chip.tipTitle, row.chip.tipBody = e.key, ns:L("FOV_TIP_TR_KEY_FMT"):format(e.key)
			else
				row.chip.t:SetText(e.where or "")
				row.chip:SetColor(A.later[1], A.later[2], A.later[3])
				row.chip.tipTitle, row.chip.tipBody = e.where, ns:L("FTRAIN_KEY_HINT")
			end
		end
		row:Show()
	end
	for i = #list + 1, #card.rows do
		card.rows[i]:Hide()
	end
	card.child:SetHeight(math.max(10, #list * TR_ROW_H))
	if refresh then
		card.sf.UpdateThumb() -- the 2-second refresh (money at the trainer) keeps your place in the list
	else
		card.sf.Reset()
	end
end

--------------------------------------------------------------------------------
-- Find (product plan step 4)
--------------------------------------------------------------------------------

--- Everything you can look for, in list order: headings and items { kind, key, name, … }; second value = the
--- weapon line for your direction (ForeverWeapons.lua), or nil.
local function FindCatalog()
	local items = {}
	local function head(t)
		items[#items + 1] = { head = t }
	end
	local cname, token = UnitClass and UnitClass("player")
	if ns.ForeverClassName and token then
		cname = ns.ForeverClassName(token) or cname
	end
	head(ns:L("FOV_FIND_SEC_CLASS"))
	items[#items + 1] = { kind = "class", name = ns:L("FOV_FIND_CLASS_FMT"):format(cname or "?") }
	head(ns:L("FOV_FIND_SEC_PROF"))
	local mine = ns.ForeverMyProfessions and ns.ForeverMyProfessions() or {}
	for pass = 1, 2 do
		for _, p in ipairs(ns.FOREVER_PROFS or {}) do
			local m = mine[p[1]]
			if (pass == 1) == (m ~= nil) then
				items[#items + 1] = { kind = "prof", key = p[1], english = p[3],
					name = ns.ForeverProfName and ns.ForeverProfName(p[1], mine) or p[3], mine = m ~= nil,
					skill = m and m.rank and m.maxRank and ("%d/%d"):format(m.rank, m.maxRank) or nil }
			end
		end
	end
	local weap, dirText = {}, nil
	if ns.ForeverWeaponFindList then
		local ok, w, d = pcall(ns.ForeverWeaponFindList)
		if ok and type(w) == "table" then
			weap, dirText = w, d
		end
	end
	if #weap > 0 then
		head(ns:L("FOV_FIND_SEC_WEAP"))
		for _, w in ipairs(weap) do
			items[#items + 1] = { kind = "weapon", key = w.spell, name = w.name, known = w.known, tooLow = w.tooLow,
				level = w.level, fit = w.fit }
		end
	end
	local shops = {}
	if ns.ForeverVendorFindCats then
		local ok, c = pcall(ns.ForeverVendorFindCats)
		shops = ok and type(c) == "table" and c or {}
	end
	if #shops > 0 then
		head(ns:L("FOV_FIND_SEC_SHOP"))
		for _, c in ipairs(shops) do
			items[#items + 1] = { kind = "shop", key = c.key, name = c.name, goods = c.goods }
		end
	end
	return items, dirText
end

--- Which item to show for `kind` (+ optional key): the asked one, else the one you had open of that kind, else the
--- first that makes sense (your first profession, the first weapon you can learn now).
local function PickFind(f, items, kind, key)
	local cur = f.find
	local first, best
	for _, it in ipairs(items) do
		if it.kind == kind then
			if key ~= nil and it.key == key then
				return it
			end
			if cur and cur.kind == kind and cur.key == it.key and key == nil then
				return it
			end
			first = first or it
			if not best and ((kind == "prof" and it.mine) or (kind == "weapon" and not it.known and not it.tooLow)) then
				best = it
			end
		end
	end
	return best or first
end

local function FindDistance(dist)
	if dist then
		dist = math.floor(dist + 0.5) -- whole yards: the texts use %d
		return ns.ForeverTrainerDistance and ns.ForeverTrainerDistance(dist) or ("%d yd"):format(dist)
	end
	return ns:L("FVEND_OTHER_CONT")
end

--- The places for the chosen item: rows { name, info, dim, route (string / false = walk / nil = ask ForeverTravel),
--- map, x, y, go }, the sub line, the hint, and the action button { label, tip, fn } or nil.
local function FindPlaces(it, dirText)
	local rows, sub, hint, act = {}, "", "", nil
	local posOk = true
	if it.kind == "class" or it.kind == "prof" then
		local prof = it.kind == "prof" and it.key or nil
		local list, need = {}, nil
		if ns.ForeverProfTrainerList then
			local ok, l, n, p = pcall(ns.ForeverProfTrainerList, prof)
			if ok and type(l) == "table" then
				list, need, posOk = l, n, p
			end
		end
		for _, e in ipairs(list) do
			local c = e.c
			local name = c.name or "?"
			if c.max then
				name = name .. "  |cff999999" .. ns:L("FPROF_ROW_MAX_FMT"):format(c.max) .. "|r"
			end
			if c.src == "yours" then
				name = name .. "  |cff66ccff" .. ns:L("FTRAIN_SRC_YOURS") .. "|r"
			end
			local info = (e.zone or "?") .. " · " .. FindDistance(e.dist)
			if c.low then
				info = info .. "  |cffff7f7f" .. ns:L("FPROF_ROW_LOW") .. "|r"
			end
			rows[#rows + 1] = { name = name, info = info, dim = c.low, map = c.map, x = c.x, y = c.y,
				go = function()
					return ns.ForeverTrainerGoTo and ns.ForeverTrainerGoTo(c, e.dist, nil, prof)
				end }
		end
		if prof then
			sub = (not it.mine and ns:L("FPROF_NEW")) or (need and ns:L("FPROF_NEED_FMT"):format(need))
				or ns:L("FPROF_ANY")
			hint = ns:L("FPROF_HINT_FMT"):format((it.english or ""):lower())
			local toolKey
			if ns.ForeverProfCard then
				local ok, _, k = pcall(ns.ForeverProfCard, prof)
				toolKey = ok and k or nil
			end
			if toolKey then
				act = { label = ns:L("FPROFG_BUY"), tip = ns:L("FOV_TIP_FIND_BUY"), fn = function()
					ns.ShowForeverFind("shop", toolKey)
				end }
			end
		else
			sub = ns:L("FOV_FIND_CLASS_SUB")
			hint = ns:L("FOV_FIND_CLASS_HINT")
			act = { label = ns:L("FOV_FIND_TEACHES"), tip = ns:L("FOV_TIP_DETAILS"), fn = function()
				ns.ShowForeverOverviewPage("trainer")
			end }
		end
		if #rows == 0 then
			sub = sub .. "  " .. ns:L("FPROF_EMPTY")
		end
	elseif it.kind == "weapon" then
		if ns.ForeverWeaponFindRows then
			local ok, l, p, s = pcall(ns.ForeverWeaponFindRows, it.key)
			if ok and type(l) == "table" then
				posOk, sub = p, s or ""
				for _, e in ipairs(l) do
					rows[#rows + 1] = { name = e.name, info = (e.zone or "?") .. " · " .. FindDistance(e.dist),
						route = e.route, go = e.go }
				end
			end
		end
		if #rows == 0 then
			sub = sub .. "  " .. ns:L("FWEAP_EMPTY")
		end
		hint = dirText or ns:L("FWEAP_HINT")
	elseif it.kind == "shop" then
		if ns.ForeverVendorFindRows then
			local ok, l, p = pcall(ns.ForeverVendorFindRows, it.key)
			if ok and type(l) == "table" then
				posOk = p
				for _, e in ipairs(l) do
					rows[#rows + 1] = { name = e.name .. (e.tag and ("  |cff999999<" .. e.tag .. ">|r") or ""),
						info = (e.zone or "?") .. " · " .. FindDistance(e.dist), map = e.map, x = e.x, y = e.y, go = e.go }
				end
			end
		end
		sub = ns:L(it.goods and "FVEND_SUB_GOODS" or "FOV_FIND_SUB_TOOL")
		if #rows == 0 then
			sub = sub .. "  " .. ns:L("FVEND_EMPTY")
		end
		hint = ns:L("FVEND_HINT")
	end
	if not posOk then
		sub = sub .. "  " .. ns:L("FVEND_NOPOS")
	end
	return rows, sub, hint, act
end

local FIND_ROUTES = 8 -- the way there is worked out for the nearest few places only (ForeverTravel plans a route each)

local function FillFindPage(f, refresh)
	local page = f.pages.find
	local cat, list = page.cat, page.list
	local items, dirText = FindCatalog()
	local it = PickFind(f, items, (f.find and f.find.kind) or "class", f.find and f.find.key)
	f.find = it and { kind = it.kind, key = it.key } or nil
	-- Left: the catalogue.
	local r, g, b = Accent()
	for i, e in ipairs(items) do
		local btn = FindItem(cat, i)
		btn.sel = (it ~= nil and e == it)
		btn.tipTitle, btn.tipBody = nil, nil
		if e.head then
			btn.t:SetText(e.head:upper())
			S.Font(btn.t, A.fonts.head2, 12, A.fallback.head2)
			btn.col = A.label
			btn:SetScript("OnClick", nil)
			btn.bg:SetColorTexture(0, 0, 0, 0)
		else
			S.Font(btn.t, A.fonts.textB, 13, A.fallback.textB)
			local text = e.name or "?"
			btn.col = A.text
			if e.kind == "prof" and e.mine then
				btn.col = A.gold
				text = text .. (e.skill and ("  |cffa89a85" .. e.skill .. "|r") or "")
			elseif e.kind == "weapon" then
				if e.known then
					btn.col = A.later
					text = text .. "  " .. ns:L("FWEAP_KNOWN_TAG")
				elseif e.tooLow then
					btn.col = A.later
					text = text .. "  " .. ns:L("FWEAP_LEVEL_TAG_FMT"):format(e.level or 0)
				end
				if e.fit then
					text = "|cff40ff40+|r " .. text
					btn.tipTitle, btn.tipBody = e.name, dirText
				end
			end
			btn.t:SetText(text)
			btn:SetScript("OnClick", function()
				f.find = { kind = e.kind, key = e.key }
				ns.ForeverOverviewFill()
			end)
			btn.bg:SetColorTexture(r, g, b, btn.sel and 0.22 or 0)
		end
		btn.t:SetTextColor(btn.col[1], btn.col[2], btn.col[3])
		btn:Show()
	end
	for i = #items + 1, #cat.items do
		cat.items[i]:Hide()
	end
	cat.child:SetHeight(math.max(10, #items * FIND_ITEM_H))
	if refresh then
		cat.sf.UpdateThumb()
	elseif not f.findScrolled then
		cat.sf.Reset()
		f.findScrolled = true
	end
	if not it then
		list.label:SetText("")
		list.head:SetText("")
		list.sub:SetText("")
		list.act:Hide()
		return
	end
	-- Right: the places.
	local rows, sub, hint, act = FindPlaces(it, dirText)
	list.label:SetText((it.name or ""):upper())
	list.head:SetText(ns:L("FOV_FIND_COUNT_FMT"):format(it.name or "?", #rows))
	list.sub:SetText(sub)
	list.hint:SetText(hint)
	if act then
		list.act:SetLabel(act.label)
		list.act.tipTitle, list.act.tipBody = act.label, act.tip
		list.act:SetScript("OnClick", act.fn)
		list.act:Show()
	else
		list.act:Hide()
	end
	local y = 0
	for i, e in ipairs(rows) do
		local row = FindRow(list, i)
		row:ClearAllPoints()
		row:SetPoint("TOPLEFT", list.child, "TOPLEFT", 0, -y)
		row.name:SetText(e.name)
		row.info:SetText(e.info or "")
		row.hover.tipTitle = e.name
		row.hover.tipBody = e.info
		local route = e.route
		if route == nil and i <= FIND_ROUTES and e.map and e.x and e.y and ns.ForeverTravelSentence then
			local ok, s = pcall(ns.ForeverTravelSentence, e.map, e.x, e.y)
			route = ok and s or nil
		end
		if type(route) == "string" and route ~= "" then
			row.route:SetText(ns:L("FWEAP_ROUTE_LABEL") .. " " .. route)
			row.route:Show()
		else
			row.route:SetText("")
			row.route:Hide()
		end
		local h = 44 + (row.route:IsShown() and ((row.route:GetStringHeight() or 12) + 4) or 0)
		row:SetHeight(h)
		row:SetAlpha(e.dim and 0.55 or 1)
		SetGo(row.go, e.go)
		row:Show()
		y = y + h + 4
	end
	for i = #rows + 1, #list.rows do
		list.rows[i]:Hide()
	end
	list.child:SetHeight(math.max(10, y))
	if refresh then
		list.sf.UpdateThumb()
	else
		list.sf.Reset()
	end
end

--- The Keys & macros page: doors and switches left (laid out top to bottom, the texts may wrap), macro rows right.
local function FillKeysPage(f, refresh)
	local page = f.pages.keys
	local left, list = page.left, page.list
	local y = 4
	for _, d in ipairs(left.doors) do
		d.btn:ClearAllPoints()
		d.btn:SetPoint("TOPLEFT", left.child, "TOPLEFT", 4, -y)
		y = y + 26
		local text = ns:L(d.def.desc)
		-- Counting is off by default: say so beside the door, before the click (KeysHub.lua does the same).
		if d.def.presses and ns.IsKeyPressesEnabled and not ns.IsKeyPressesEnabled() then
			text = text .. "\n|cffeeb055" .. ns:L("KEYSHUB_PRESSES_OFF") .. "|r"
		end
		d.desc:SetText(text)
		d.desc:ClearAllPoints()
		d.desc:SetPoint("TOPLEFT", left.child, "TOPLEFT", 6, -y)
		y = y + (d.desc:GetStringHeight() or 24) + 12
	end
	y = y + 4
	left.swHead:ClearAllPoints()
	left.swHead:SetPoint("TOPLEFT", left.child, "TOPLEFT", 4, -y)
	y = y + 20
	for _, s in ipairs(left.switches) do
		s.text:ClearAllPoints()
		s.text:SetPoint("TOPLEFT", left.child, "TOPLEFT", 4, -y)
		s.chip:ClearAllPoints()
		s.chip:SetPoint("TOPRIGHT", left.child, "TOPRIGHT", -6, -y)
		y = y + FillSwitch(s)
	end
	left.child:SetHeight(math.max(10, y))
	if refresh then
		left.sf.UpdateThumb()
	else
		left.sf.Reset()
	end
	-- Right: the handy macros.
	local views, canUndo = {}, false
	if ns.ForeverMacroViews then
		local ok, v, u = pcall(ns.ForeverMacroViews)
		if ok and type(v) == "table" then
			views, canUndo = v, u
		end
	end
	list.undo:SetShown(canUndo and true or false)
	local yy = 0
	for i, v in ipairs(views) do
		local row = MacroRow(list, i)
		row:ClearAllPoints()
		row:SetPoint("TOPLEFT", list.child, "TOPLEFT", 0, -yy)
		row.title:SetText(v.title or "")
		row.info:SetText(v.info or "")
		local col = v.header and A.label or A.text
		row.title:SetTextColor(col[1], col[2], col[3])
		if v.header then
			row.go:Hide()
			row.free:Hide()
		else
			local label = ns:L(v.made and "FMAC_BTN_UPDATE" or "FMAC_BTN_MAKE")
			row.go:SetLabel(label)
			row.go.tipTitle, row.go.tipBody = label, ns:L("FOV_TIP_MAKE")
			row.go:SetScript("OnClick", function()
				v.make()
				ns.ForeverOverviewFill(true)
			end)
			row.go:Show()
			row.go:SetAlpha(v.canMake and 1 or 0.4)
			row.go:SetEnabled(v.canMake and true or false)
			if v.free then
				row.free:SetScript("OnClick", function()
					v.free()
					ns.ForeverOverviewFill(true)
				end)
				row.free:Show()
			else
				row.free:Hide()
			end
		end
		local h = 8 + (row.title:GetStringHeight() or 16) + 2 + (row.info:GetStringHeight() or 14)
		h = math.max(h, v.free and 60 or 34)
		row:SetHeight(h)
		row:Show()
		yy = yy + h + 4
	end
	for i = #views + 1, #list.rows do
		list.rows[i]:Hide()
	end
	list.child:SetHeight(math.max(10, yy))
	if refresh then
		list.sf.UpdateThumb()
	else
		list.sf.Reset()
	end
end

--- The Professions page: the list (yours first), the chosen profession's card, its tool, and the three switches.
local function FillProfsPage(f, refresh)
	local page = f.pages.profs
	local left, card = page.left, page.card
	local mine = ns.ForeverMyProfessions and ns.ForeverMyProfessions() or {}
	local order = {}
	for pass = 1, 2 do
		for _, p in ipairs(ns.FOREVER_PROFS or {}) do
			if (pass == 1) == (mine[p[1]] ~= nil) then
				order[#order + 1] = p
			end
		end
	end
	local sel = f.prof
	if not sel or not (function()
		for _, p in ipairs(order) do
			if p[1] == sel then
				return true
			end
		end
	end)() then
		sel = order[1] and order[1][1] or nil
	end
	f.prof = sel
	local r, g, b = Accent()
	for i, row in ipairs(left.rows) do
		local p = order[i]
		if p then
			local m = mine[p[1]]
			row.t:SetText(ns.ForeverProfName and ns.ForeverProfName(p[1], mine) or p[3])
			row.col = m and A.gold or A.text
			row.t:SetTextColor(row.col[1], row.col[2], row.col[3])
			row.skill:SetText(m and m.rank and m.maxRank and ("%d/%d"):format(m.rank, m.maxRank) or "")
			row.bg:SetColorTexture(r, g, b, p[1] == sel and 0.22 or 0)
			row:SetScript("OnClick", function()
				f.prof = p[1]
				ns.ForeverOverviewFill()
			end)
			row:Show()
		else
			row:Hide()
		end
	end
	if not sel then
		return
	end
	local m = mine[sel]
	local name = ns.ForeverProfName and ns.ForeverProfName(sel, mine) or sel
	card.label:SetText(name:upper())
	card.trainers:SetScript("OnClick", function()
		ns.ShowForeverFind("prof", sel)
	end)
	-- Your skill and its bar; a profession you do not have says so.
	if m and m.rank and m.maxRank and m.maxRank > 0 then
		card.skill:SetText(ns:L("FOV_PROF_SKILL_FMT"):format(m.rank, m.maxRank))
		card.barFill:SetColorTexture(r, g, b, 0.9)
		card.barFill:SetWidth(math.max(1, ((card.barBg:GetWidth() or 0) > 0 and card.barBg:GetWidth() or 300)
			* math.min(1, m.rank / m.maxRank)))
		card.barBg:Show()
		card.barFill:Show()
	else
		card.skill:SetText(ns:L(m and "FOV_PROF_SKILL_UNKNOWN" or "FOV_PROF_NOT_YOURS"))
		card.barBg:Hide()
		card.barFill:Hide()
	end
	-- The card (ForeverProfGuide.lua) and its tool.
	local text, toolKey
	if ns.ForeverProfCard then
		local ok, t, k = pcall(ns.ForeverProfCard, sel)
		if ok then
			text, toolKey = t, k
		end
	end
	card.text:SetText(text and S.Format(text) or "")
	card.child:SetHeight(math.max(10, (card.text:GetStringHeight() or 0) + 12))
	if refresh then
		card.sf.UpdateThumb()
	else
		card.sf.Reset()
	end
	if toolKey then
		card.buy:SetScript("OnClick", function()
			ns.ShowForeverFind("shop", toolKey)
		end)
		card.buy:Show()
		-- Do you carry it? The same check as "Do this now" (ns.ForeverMissingTools: your professions without their tool).
		local missing = false
		if m and ns.ForeverMissingTools then
			local ok, list = pcall(ns.ForeverMissingTools)
			for _, t in ipairs(ok and list or {}) do
				if t.key == toolKey then
					missing = true
				end
			end
		end
		local toolName = ns.ForeverVendorItemName and ns.ForeverVendorItemName(toolKey) or toolKey
		if not m then
			card.tool:SetText(ns:L("FOV_PROF_TOOL_NEED_FMT"):format(toolName))
		elseif missing then
			card.tool:SetText("|cffff7f7f" .. ns:L("FOV_PROF_TOOL_MISSING_FMT"):format(toolName) .. "|r")
		else
			card.tool:SetText("|cff8fd47a" .. ns:L("FOV_PROF_TOOL_HAVE_FMT"):format(toolName) .. "|r")
		end
	else
		card.buy:Hide()
		card.tool:SetText("")
	end
	-- The switches at the bottom, from below upwards.
	local y = 12
	for i = #card.sw, 1, -1 do
		local s = card.sw[i]
		local h = FillSwitch(s)
		s.text:ClearAllPoints()
		s.text:SetPoint("BOTTOMLEFT", card, "BOTTOMLEFT", 14, y + (h - 22) + 4)
		s.chip:ClearAllPoints()
		s.chip:SetPoint("BOTTOMRIGHT", card, "BOTTOMRIGHT", -14, y + (h - 22) + 2)
		y = y + h
	end
	card.swHead:ClearAllPoints()
	card.swHead:SetPoint("BOTTOMLEFT", card, "BOTTOMLEFT", 14, y + 4)
end

local DUNG_CHIP = { fit = "FOV_DUNG_ST_FIT", near = "FOV_DUNG_ST_NEAR", low = "FOV_DUNG_ST_LOW", high = "FOV_DUNG_ST_HIGH" }
local DUNG_TIP = { fit = "FOV_TIP_DUNG_ST_FIT", near = "FOV_TIP_DUNG_ST_NEAR", low = "FOV_TIP_DUNG_ST_LOW",
	high = "FOV_TIP_DUNG_ST_HIGH" }
local DUNG_ROUTES = 8

local function FillDungeonsPage(f, refresh)
	local page = f.pages.dungeons
	local list, raids, grp = page.list, page.raids, page.grp
	FillSwitch(list.only)
	local all = ns.IsForeverDungeonsAll and ns.IsForeverDungeonsAll()
	local dl = {}
	if ns.ForeverDungeonList then
		local ok, l = pcall(ns.ForeverDungeonList)
		dl = ok and type(l) == "table" and l or {}
	end
	local shown = {}
	for _, d in ipairs(dl) do
		if all or d.state == "fit" or d.state == "near" then
			shown[#shown + 1] = d
		end
	end
	local level = UnitLevel and UnitLevel("player") or 1
	local lowest
	for _, d in ipairs(dl) do
		lowest = lowest and math.min(lowest, d.min) or d.min
	end
	list.empty:SetText(#shown == 0 and ns:L("FOV_DUNG_NONE_FMT"):format(level, lowest or 0) or "")
	local r, g, b = Accent()
	local y, routes = (#shown == 0) and 40 or 0, 0
	for i, d in ipairs(shown) do
		local row = DungeonRow(list, i)
		row:ClearAllPoints()
		row:SetPoint("TOPLEFT", list.child, "TOPLEFT", 0, -y)
		row.chip.t:SetText(("%d-%d"):format(d.min, d.max))
		local col = (d.state == "fit" and { r, g, b }) or (d.state == "near" and { 0.93, 0.69, 0.33 }) or A.later
		row.chip:SetColor(col[1], col[2], col[3])
		row.chip.tipTitle = ns:L(DUNG_CHIP[d.state] or "FOV_DUNG_ST_HIGH")
		row.chip.tipBody = d.state == "near" and ns:L("FOV_TIP_DUNG_ST_NEAR_FMT"):format(d.min - level)
			or ns:L(DUNG_TIP[d.state] or "FOV_TIP_DUNG_ST_HIGH")
		row.name:SetText(d.name)
		local nameCol = (d.state == "low" or d.state == "high") and A.dim or A.text
		row.name:SetTextColor(nameCol[1], nameCol[2], nameCol[3])
		local info = d.zone
		if d.sideLocked then
			info = info .. "  |cffff7f7f" .. ns:L("FOV_DUNG_SIDE") .. "|r"
		elseif d.other then
			info = info .. "  |cffeeb055" .. ns:L("FOV_DUNG_ENEMY_FMT"):format(d.other) .. "|r"
		end
		row.info:SetText(info)
		row.hover.tipTitle, row.hover.tipBody = d.name, ns:L("FOV_TIP_DUNG_ROW_FMT"):format(d.min, d.max, d.zone)
		-- The way there for the dungeons you can do now (ForeverTravel plans one route each, so only the first few).
		local route
		if (d.state == "fit" or d.state == "near") and routes < DUNG_ROUTES and ns.ForeverTravelSentence then
			routes = routes + 1
			local ok, s = pcall(ns.ForeverTravelSentence, d.map, d.x, d.y)
			route = ok and s or nil
		end
		if type(route) == "string" and route ~= "" then
			row.route:SetText(ns:L("FWEAP_ROUTE_LABEL") .. " " .. route)
			row.route:Show()
		else
			row.route:SetText("")
			row.route:Hide()
		end
		local h = 40 + (row.route:IsShown() and ((row.route:GetStringHeight() or 12) + 2) or 0)
		row:SetHeight(h)
		SetGo(row.go, (not d.sideLocked) and d.go or nil)
		row:Show()
		y = y + h + 4
	end
	for i = #shown + 1, #list.rows do
		list.rows[i]:Hide()
	end
	list.child:SetHeight(math.max(10, y))
	if refresh then
		list.sf.UpdateThumb()
	else
		list.sf.Reset()
	end
	-- Raids (the same lines as "This week").
	local lines = {}
	if ns.ForeverRaidRows then
		local ok, rr = pcall(ns.ForeverRaidRows)
		for _, row in ipairs(ok and rr or {}) do
			lines[#lines + 1] = "|c" .. (WEEK_TONE[row.tone] or WEEK_TONE.soft) .. tostring(row.text or "") .. "|r"
		end
	end
	raids.text:SetText(#lines > 0 and table.concat(lines, "\n") or ns:L("FOV_ST_UNREADABLE"))
	-- Group: who is highest, and the no-XP rule (ForeverDungeons.lua: more than 12 levels above an enemy = no XP).
	local inGroup = IsInGroup and IsInGroup()
	if inGroup and ns.ForeverGroupTop then
		local top, who = ns.ForeverGroupTop()
		grp.top:SetText(ns:L("FOV_GROUP_TOP_FMT"):format(top or 0, who or "?"))
	else
		grp.top:SetText(ns:L("FOV_GROUP_SOLO"))
	end
	local warn
	if ns.ForeverNoXpLine then
		local ok, line = pcall(ns.ForeverNoXpLine)
		warn = ok and line or nil
	end
	grp.xp:SetText(warn and ("|cffff7f7f" .. warn .. "|r") or ns:L("FOV_GROUP_XP_RULE"))
	-- Switches at the bottom of the group card.
	local yy = 12
	for i = #grp.sw, 1, -1 do
		local s = grp.sw[i]
		local h = FillSwitch(s)
		s.text:ClearAllPoints()
		s.text:SetPoint("BOTTOMLEFT", grp, "BOTTOMLEFT", 14, yy + (h - 22) + 4)
		s.chip:ClearAllPoints()
		s.chip:SetPoint("BOTTOMRIGHT", grp, "BOTTOMRIGHT", -14, yy + (h - 22) + 2)
		yy = yy + h
	end
end

local function FillCharsPage(f, refresh)
	local card = f.pages.chars.card
	local views, total, side = {}, "", nil
	if ns.ForeverCharsViews then
		local ok, v, t, s = pcall(ns.ForeverCharsViews)
		if ok and type(v) == "table" then
			views, total, side = v, t or "", s
		end
	end
	card.total:SetText(total)
	card.note:SetText(ns:L("FCHARS_NOTE") .. (side and ("  " .. side) or ""))
	for i, v in ipairs(views) do
		local row = CharRow(card, i)
		row.who:SetText(v.who)
		row.gold:SetText(v.gold)
		row.line:SetText(("%s  ·  %s  ·  %s"):format(v.dir, v.seen, v.trainer))
		row.profs:SetText(v.profs)
		row.hover.tipTitle, row.hover.tipBody = ns:L("FOV_CHARS_PROFS"), v.profs
		if v.forget then
			row.forget:SetScript("OnClick", function()
				v.forget()
				ns.ForeverOverviewFill(true)
			end)
			row.forget:Show()
		else
			row.forget:Hide()
		end
		row:Show()
	end
	for i = #views + 1, #card.rows do
		card.rows[i]:Hide()
	end
	card.child:SetHeight(math.max(10, #views * CHAR_ROW_H))
	if refresh then
		card.sf.UpdateThumb()
	else
		card.sf.Reset()
	end
end

local function FillWeekPage(f, refresh)
	local card = f.pages.week.card
	local rows = {}
	if ns.ForeverWeekRows then
		local ok, r = pcall(ns.ForeverWeekRows)
		rows = ok and type(r) == "table" and r or {}
	end
	local lines = {}
	for _, r in ipairs(rows) do
		lines[#lines + 1] = "|c" .. (WEEK_TONE[r.tone] or WEEK_TONE.soft) .. tostring(r.text or "") .. "|r"
	end
	card.text:SetText(#lines > 0 and table.concat(lines, "\n") or ns:L("FOV_ST_UNREADABLE"))
	card.child:SetHeight(math.max(10, (card.text:GetStringHeight() or 0) + 12))
	if refresh then
		card.sf.UpdateThumb()
	else
		card.sf.Reset()
	end
end

local function FillQuietPage(f, refresh)
	local card = f.pages.quiet.card
	local y = 2
	for _, it in ipairs(card.items) do
		if it.head then
			it.head:ClearAllPoints()
			it.head:SetPoint("TOPLEFT", card.child, "TOPLEFT", 4, -(y + 6))
			y = y + 28
		else
			local h = FillSwitch(it)
			it.text:ClearAllPoints()
			it.text:SetPoint("TOPLEFT", card.child, "TOPLEFT", 4, -y)
			it.chip:ClearAllPoints()
			it.chip:SetPoint("TOPRIGHT", card.child, "TOPRIGHT", -6, -y)
			it.desc:ClearAllPoints()
			it.desc:SetPoint("TOPLEFT", it.text, "BOTTOMLEFT", 0, -2)
			y = y + math.max(h, (it.text:GetStringHeight() or 16) + 4 + (it.desc:GetStringHeight() or 14) + 10)
		end
	end
	card.child:SetHeight(math.max(10, y))
	if refresh then
		card.sf.UpdateThumb()
	else
		card.sf.Reset()
	end
end

--- Refill when the overview shows `page` (ForeverMacros.lua calls this when your bags or spells change).
function ns.ForeverOverviewRefreshPage(page)
	if win and win:IsShown() and win.page == page then
		ns.ForeverOverviewFill(true)
	end
end

--- Open the overview's Find tab on one kind of place: "class", "prof", "weapon" or "shop", with an optional key
--- (a profession key, a weapon skill spell id, a shop key). The four old windows' open functions call this.
--- Called again for the same kind without a key while it is open = close (as those windows did).
function ns.ShowForeverFind(kind, key)
	local f = Build()
	if f:IsShown() and f.page == "find" and key == nil and f.find and f.find.kind == kind then
		f:Hide()
		return
	end
	if kind then
		local items = FindCatalog()
		local it = PickFind(f, items, kind, key)
		f.find = it and { kind = it.kind, key = it.key } or f.find
	end
	ns.ShowForeverOverviewPage("find")
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
	local group = PAGE_GROUP[f.page]
	if group then
		f.lastInGroup[group] = f.page
	end
	for _, b in ipairs(f.tabs) do
		if b.page or b.group then
			b:SetActive(b.page == f.page or (b.group ~= nil and b.group == group))
		end
	end
	for g, row in pairs(f.subRows) do
		row:SetShown(g == group)
		for _, b in ipairs(row.btns) do
			b:SetActive(b.page == f.page)
		end
	end
	f.gear:SetActive(f.page == "quiet")
	if f.page == "find" then
		FillFindPage(f, refresh)
		return f
	elseif f.page == "keys" then
		FillKeysPage(f, refresh)
		return f
	elseif f.page == "profs" then
		FillProfsPage(f, refresh)
		return f
	elseif f.page == "dungeons" then
		FillDungeonsPage(f, refresh)
		return f
	elseif f.page == "chars" then
		FillCharsPage(f, refresh)
		return f
	elseif f.page == "week" then
		FillWeekPage(f, refresh)
		return f
	elseif f.page == "quiet" then
		FillQuietPage(f, refresh)
		return f
	elseif f.page == "cq" then
		FillClassQuestPage(f, level)
		return f
	elseif f.page == "play" then
		FillPlayPage(f)
		return f
	elseif f.page == "trainer" then
		FillTrainerPage(f, level, refresh)
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
