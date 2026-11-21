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
-- 20 Nov 2026, layout D (Rob via sparring: "Ik ga toch voor d", then "Ja" to the plan with an old/new switch): the tabs
-- as a column of tall buttons on the RIGHT (idea from CharacterScape; no code of it: no licence found), the window
-- 1100x600 so the content keeps its width (708 instead of 700) and gains 80 px. Every page ends RIGHT_PAD from the
-- right edge: 16 in the old layout, 16 + the tab column + 12 in the new one. Set in Build() from the switch, so a
-- change needs a /reload (the window is built once). Mockups: Temp\claude\find_mockups\D_*.png.
local NEW_LAYOUT, RIGHT_PAD = false, 16
local VTAB_W, VTAB_H, VTAB_STEP, VSUB_H, VSUB_STEP, VSUB_IN = 160, 40, 46, 26, 30, 18

--- Layout D on (default) or the old tabs-on-top layout (Quiet helpers; takes effect after /reload).
function ns.IsForeverNewLayout()
	return not (type(ns.db) == "table" and ns.db.foreverOldLayout == true)
end

function ns.SetForeverNewLayout(on)
	if type(ns.db) ~= "table" then
		return
	end
	-- plain branches (lint [29])
	if on then
		ns.db.foreverOldLayout = nil
	else
		ns.db.foreverOldLayout = true
	end
	print("|cffffcc00Midnight Helper:|r " .. ns:L("FOV_LAYOUT_RELOAD"))
end

local win

--- Coins with their icons. 18 Nov 2026 (site chat on Rob's screenshots: "Gold: 314" for 3 silver 14 copper, and
--- "Costs 10"): this file used the global GetCoinTextureString, which Forever does not have (ForeverQuestHint.lua
--- found that on 10 Nov), so the raw copper number was shown. Same order as the other Forever modules.
--- 18 Nov 2026 (later, Rob: "ja laat alle 3 zien"): always gold, silver and copper with their coins (S.Money).
local function Money(c)
	return S.Money(c)
end

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
		local money = Money(r.total or 0)
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
					items[#items + 1] = { kind = it.tip and "tip" or it.kind, title = it.text, go = go, goLabel = label,
						spells = it.spells }
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
		-- 18 Nov 2026 (Rob via sparring: "2 Nu"): reputations and currencies (ForeverLegacy.lua ForeverRepViews).
		{ page = "rep", key = "FOV_SUB_REP", tip = "FOV_TIP_SUB_REP" },
	},
	-- The gear (no tab of its own): quiet helpers, the tools that had only the old window, and every command. Since
	-- 17 Nov 2026 the old window is gone in Forever (Rob: "het oude venster moet dan in principe niet meer terugkomen").
	gear = {
		{ page = "quiet", key = "FOV_SUB_QUIET", tip = "FOV_TIP_CARD_QUIET" },
		{ page = "tools", key = "FOV_SUB_TOOLS", tip = "FOV_TIP_SUB_TOOLS" },
		{ page = "cmds", key = "CMDLIST_TITLE", tip = "FOV_TIP_SUB_CMDS" },
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
	card:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -RIGHT_PAD, 16)
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
	-- 19 Nov 2026: the step line shows the quest's own tooltip (tipLink "quest:<id>"; our text when the client has none).
	row.questHover = HoverOver(row, row.what)
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
	how:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -RIGHT_PAD, 16)
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
	-- A fixed width (not a RIGHT anchor): the row's height is measured from the text right away, before the frame
	-- layout is done (the first opening).
	row.text = Text(row, "textB", 13, A.text)
	row.text:SetPoint("TOPLEFT")
	row.text:SetWidth(card.textW)
	row.sub = Text(row, "text", 11, A.dim)
	row.sub:SetPoint("TOPLEFT", row.text, "BOTTOMLEFT", 0, -1)
	row.sub:SetWidth(card.textW)
	row.sub:SetWordWrap(false)
	row.hover = HoverOver(row, row.text)
	row.hover:SetPoint("BOTTOMRIGHT", row.sub, "BOTTOMRIGHT")
	row.go = Button(row, 92)
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
	card:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -RIGHT_PAD, 16)
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
	-- 20 Nov 2026 (layout D step 3, mockup D_find.png): "What am I looking for? | Which city?" and a search field above
	-- the list. MH remembers the last choice (ns.db.foreverFindMode), so no switch in Quiet helpers.
	local half = math.floor((catW - 28) / 2)
	cat.modeWhat = Button(cat, half)
	cat.modeWhat:SetHeight(22)
	cat.modeWhat:SetPoint("TOPLEFT", 12, -30)
	cat.modeWhat:SetLabel(ns:L("FOV_FIND_MODE_WHAT"))
	Tip(cat.modeWhat, ns:L("FOV_FIND_MODE_WHAT"), ns:L("FOV_TIP_FIND_MODE_WHAT"))
	cat.modeCity = Button(cat, half)
	cat.modeCity:SetHeight(22)
	cat.modeCity:SetPoint("LEFT", cat.modeWhat, "RIGHT", 4, 0)
	cat.modeCity:SetLabel(ns:L("FOV_FIND_MODE_CITY"))
	Tip(cat.modeCity, ns:L("FOV_FIND_MODE_CITY"), ns:L("FOV_TIP_FIND_MODE_CITY"))
	local function SetMode(m)
		ns.db = ns.db or {}
		ns.db.foreverFindMode = m
		f.findScrolled = nil
		ns.ForeverOverviewFill()
	end
	cat.modeWhat:SetScript("OnClick", function()
		SetMode(nil)
	end)
	cat.modeCity:SetScript("OnClick", function()
		SetMode("city")
	end)
	local box = CreateFrame("EditBox", nil, cat, "InputBoxTemplate")
	box:SetHeight(20)
	box:SetPoint("TOPLEFT", 20, -58)
	box:SetPoint("RIGHT", cat, "RIGHT", -14, 0)
	box:SetAutoFocus(false)
	box:SetScript("OnTextChanged", function()
		ns.ForeverOverviewFill(true)
	end)
	box:SetScript("OnEscapePressed", function(self)
		self:ClearFocus()
	end)
	box.ph = Text(box, "text", 12, A.later)
	box.ph:SetPoint("LEFT", 2, 0)
	box.ph:SetText(ns:L("FOV_FIND_SEARCH"))
	box:SetScript("OnEditFocusGained", function(self)
		self.ph:Hide()
	end)
	box:SetScript("OnEditFocusLost", function(self)
		if (self:GetText() or "") == "" then
			self.ph:Show()
		end
	end)
	cat.search = box
	cat.sf, cat.child = S.Scroll(cat, 86, 8, FIND_ITEM_H * 3)
	cat.child:SetWidth(catW - 22)
	cat.items = {}
	local list = Card(page)
	list:SetPoint("TOPLEFT", cat, "TOPRIGHT", 12, 0)
	list:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -RIGHT_PAD, 16)
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
		-- 19 Nov 2026 (tooltips, Rob: "Op beide vragen ja"): a tool or a weapon skill shows the game's own tooltip
		-- (tipLink "item:<id>" / "spell:<id>"), our line under it; nothing readable → our own text as before.
		if self.tipLink then
			GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
			local ok = pcall(GameTooltip.SetHyperlink, GameTooltip, self.tipLink)
			if ok and (GameTooltip:NumLines() or 0) > 0 then
				if self.tipBody then
					GameTooltip:AddLine(" ")
					GameTooltip:AddLine(self.tipBody, 0.6, 0.8, 1, true)
				end
				GameTooltip:Show()
				return
			end
		end
		if self.tipBody then
			GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
			GameTooltip:SetText(self.tipTitle or "", 1, 0.82, 0, 1, true)
			GameTooltip:AddLine(self.tipBody, 1, 1, 1, true)
			GameTooltip:Show()
		else
			GameTooltip:Hide()
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
	-- 19 Nov 2026 (Rob via sparring: "Op beide vragen ja"): the rank choice window, findable beside the old-rank switch.
	{ btn = "FRANK_CHOOSE_TITLE", desc = "FRANK_CHOOSE_DESC", fn = function()
		if ns.ShowForeverRanks then
			ns.ShowForeverRanks()
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
	list:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -RIGHT_PAD, 16)
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
	-- 19 Nov 2026 (the macro rest): Copy = the macro text in a box to copy (Ctrl+C), and a chip with where it stands.
	r.copy = Button(r, 96)
	r.copy:SetHeight(20)
	r.copy:SetLabel(ns:L("FMAC_BTN_COPY"))
	Tip(r.copy, ns:L("FMAC_BTN_COPY"), ns:L("FMAC_TIP_COPY"))
	r.chip = Tip(S.Chip(r, "", nil, 70))
	r.chip:SetPoint("TOPRIGHT", r.go, "TOPLEFT", -8, 0)
	r.title = Text(r, "textB", 14)
	r.title:SetPoint("TOPLEFT", 4, -4)
	r.title:SetWidth(list.rowW - 112 - 80)
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
	-- Every profession plus one: Comprehension for a mage (19 Nov 2026; with a fixed 12 its row was never made, Rob
	-- saw no Comprehension). FillProfsPage places the rows and closes them up when the card is too short.
	for i = 1, math.max(13, #(ns.FOREVER_PROFS or {}) + 1) do
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
	card:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -RIGHT_PAD, 16)
	card.label = Label(card, "", "FOV_TIP_CARD_PROF")
	card.trainers = Button(card, 120)
	card.trainers:SetHeight(22)
	card.trainers:SetPoint("TOPRIGHT", -12, -8)
	card.trainers:SetLabel(ns:L("FOV_PROF_TRAINERS"))
	Tip(card.trainers, ns:L("FOV_PROF_TRAINERS"), ns:L("FOV_TIP_PROF_TRAINERS"))
	-- 20 Nov 2026 (idea 6, Rob: "Ja, begin daar dan mee"): the Skill up window (ForeverSkillup.lua) for this profession.
	card.skillup = Button(card, 100)
	card.skillup:SetHeight(22)
	card.skillup:SetPoint("RIGHT", card.trainers, "LEFT", -6, 0)
	card.skillup:SetLabel(ns:L("FSKILL_BTN"))
	Tip(card.skillup, ns:L("FSKILL_BTN"), ns:L("FSKILL_TIP_BTN"))
	card.buy = Button(card, 120)
	card.buy:SetHeight(22)
	card.buy:SetPoint("RIGHT", card.skillup, "LEFT", -6, 0)
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
	grp:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -RIGHT_PAD, 16)
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
	-- 18 Nov 2026 (dungeon guide step 1, Rob: "Ja bouw maar"): "Bosses" opens the boss guide on this dungeon.
	r.boss = Button(r, 70)
	r.boss:SetHeight(20)
	r.boss:SetPoint("TOPRIGHT", r.go, "BOTTOMRIGHT", 0, -3)
	r.boss:SetLabel(ns:L("FDG_BTN"))
	Tip(r.boss, ns:L("FDG_TITLE"), ns:L("FDG_TIP_BTN"))
	r.boss:Hide()
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
	-- 21 Nov 2026 (Rob's screenshot: "Er loopt tekst door elkaar heen" — the way there ran under "Way ›" and "Bosses"):
	-- the line starts 70 px in (chip 2 + 58, gap 10) and must end 8 px before the button column (70 + 2 from the right).
	-- The old width (row - 80) forgot the 70 px on the left. A fixed width, not an anchor: the row height is measured
	-- with GetStringHeight right after SetText, before any layout pass.
	r.route:SetWidth(list.rowW - 70 - 80)
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
	card:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -RIGHT_PAD, 16)
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
	card:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -RIGHT_PAD, 16)
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

--- "Reputations & currencies" page (18 Nov 2026): one scrolling text, like This week - the five currencies on top,
--- then per group your rank, how far into it, the next reward and how to get there.
local function BuildRepPage(f, x0, rightW)
	local page = f.pages.rep
	local card = Card(page)
	card:SetPoint("TOPLEFT", f, "TOPLEFT", x0, SUB_TOP)
	card:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -RIGHT_PAD, 16)
	card.label = Label(card, ns:L("FOV_SUB_REP"):upper(), "FOV_TIP_SUB_REP")
	card.sf, card.child = S.Scroll(card, 36, 10, 40)
	card.text = Text(card.child, "text", 14)
	card.text:SetPoint("TOPLEFT", 6, 0)
	card.text:SetPoint("RIGHT", card.child, "RIGHT", -6, 0)
	if card.text.SetSpacing then
		card.text:SetSpacing(4)
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
					-- 18 Nov 2026 (Rob: "de knop, Moving Portrait, werkt niet"): this line was
					-- `(not on) and false or nil`, which is ALWAYS nil in Lua (`false or nil` = nil), so a default-on switch
					-- could never be turned off - Moving portrait, the quest reward tip and the gear tip alike.
					-- ForeverRanks.lua:628 had already found the same trap on 12 Nov.
					if on then
						ns.db[key] = nil
					else
						ns.db[key] = false
					end
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
	-- 19 Nov 2026 (Rob: a smaller screen when he targets a boss, "Ja, dat klopt uiteindelijk wel."): the small boss card
	-- (ForeverDungeonGuide.lua). On by default; players choose.
	Q("FDG_CARD_SW", "FDG_CARD_SW_DESC", {
		get = function() return ns.IsForeverBossCardOn and ns.IsForeverBossCardOn() end,
		set = function(on) if ns.SetForeverBossCard then ns.SetForeverBossCard(on) end end }),
	{ head = "FOV_Q_HEAD_TOOLTIPS" },
	PROF_SWITCHES[1], -- Used for / never usable / quest item
	Q("FOV_Q_GEARTIP", "FOV_Q_GEARTIP_DESC", DbFlag("foreverGearTip", true)),
	Q("SET_BLESSTIP_TITLE", "SET_BLESSTIP_DESC", DbFlag("foreverBlessTip", false)),
	-- 19 Nov 2026 (Rob: "Ja, die mogen door"): the smart blessing button (ForeverBlessTip.lua). Off by default; turning it
	-- on also makes the macro to drag onto a bar.
	-- 19 Nov 2026 (Rob: "Doe het nu maar"): the small window with only your class quest step (ForeverClassQuests.lua).
	Q("FCQWIN_SW", "FCQWIN_SW_DESC", {
		get = function() return ns.IsForeverCQWindowOn and ns.IsForeverCQWindowOn() end,
		set = function(on) if ns.SetForeverCQWindow then ns.SetForeverCQWindow(on) end end }),
	-- 19 Nov 2026: thank a stranger for a buff with the game's emote (ThanksBuff.lua). Same setting as /mh thanks.
	Q("SET_THANKS_TITLE", "SET_THANKS_DESC", {
		get = function() return ns.IsThanksBuffOn and ns.IsThanksBuffOn() end,
		set = function(on) if ns.SetThanksBuff then ns.SetThanksBuff(on) end end }),
	-- 20 Nov 2026 (Rob: "en begin met 4, loot sparkles :)"): quest items sparkle instead of an outline
	-- (ForeverLootSparkle.lua). Off by default; switching off puts the old graphics settings back.
	-- 20 Nov 2026 (Rob: "Ja" to layout D with an old/new switch): tabs on the right (new, default) or on top (old).
	Q("FOV_LAYOUT_SW", "FOV_LAYOUT_SW_DESC", {
		get = function() return ns.IsForeverNewLayout and ns.IsForeverNewLayout() end,
		set = function(on) if ns.SetForeverNewLayout then ns.SetForeverNewLayout(on) end end }),
	-- 20 Nov 2026 (Rob: "doorgaan met REST XP"): the window when you log out outside an inn or a city (ForeverRestXP.lua).
	Q("FREST_SW", "FREST_SW_DESC", {
		get = function() return ns.IsForeverRestTipOn and ns.IsForeverRestTipOn() end,
		set = function(on) if ns.SetForeverRestTip then ns.SetForeverRestTip(on) end end }),
	-- 20 Nov 2026 (Rob: "ja doe maar"): worn gear, with the way to the nearest repairer (ForeverDurability.lua).
	Q("FDUR_SW", "FDUR_SW_DESC", {
		get = function() return ns.IsForeverDurabilityOn and ns.IsForeverDurabilityOn() end,
		set = function(on) if ns.SetForeverDurability then ns.SetForeverDurability(on) end end }),
	-- 21 Nov 2026 (Rob: "Ja doe maar"): Waylaid Crates — bundle list, where to deliver, the window (ForeverCrates.lua).
	Q("FCRATE_SW", "FCRATE_SW_DESC", {
		get = function() return ns.IsForeverCratesOn and ns.IsForeverCratesOn() end,
		set = function(on) if ns.SetForeverCrates then ns.SetForeverCrates(on) end end }),
	Q("FLS_SW", "FLS_SW_DESC", {
		get = function() return ns.IsLootSparkleOn and ns.IsLootSparkleOn() end,
		set = function(on) if ns.SetLootSparkle then ns.SetLootSparkle(on) end end }),
	-- 20 Nov 2026 (Rob: "ik wil beide met idd de schakelaars"): ore and herbs, the game's icon (A) and MH's glow (B).
	Q("FNODE_ICON_SW", "FNODE_ICON_SW_DESC", {
		get = function() return ns.IsNodeIconOn and ns.IsNodeIconOn() end,
		set = function(on) if ns.SetNodeIcon then ns.SetNodeIcon(on) end end }),
	Q("FNODE_GLOW_SW", "FNODE_GLOW_SW_DESC", {
		get = function() return ns.IsNodeGlowOn and ns.IsNodeGlowOn() end,
		set = function(on) if ns.SetNodeGlow then ns.SetNodeGlow(on) end end }),
	-- 21 Nov 2026 (Rob via sparring: "Ja, doe dat maar"): Do this now names the next talent (ForeverTalentNext.lua).
	Q("FTALENT_SW", "FTALENT_SW_DESC", {
		get = function() return ns.IsForeverTalentNextOn and ns.IsForeverTalentNextOn() end,
		set = function(on) if ns.SetForeverTalentNext then ns.SetForeverTalentNext(on) end end }),
	-- 21 Nov 2026 (Rob via sparring: "Ja, wou het maar."): Smart Buff for Mage, Priest and Druid (ForeverSmartBuff.lua).
	Q("FSBUFF_SW", "FSBUFF_SW_DESC", {
		get = function() return ns.IsForeverSmartBuffOn and ns.IsForeverSmartBuffOn() end,
		set = function(on) if ns.SetForeverSmartBuff then ns.SetForeverSmartBuff(on) end end }),
	Q("FBLESS_BTN_SW", "FBLESS_BTN_SW_DESC", {
		get = function() return ns.IsForeverSmartBlessOn and ns.IsForeverSmartBlessOn() end,
		set = function(on) if ns.SetForeverSmartBless then ns.SetForeverSmartBless(on) end end }),
	-- 18 Nov 2026 (Rob: disenchant, "ja"): tooltip line + bag icons (on), and the "Disenchant next" button (off).
	Q("FOV_Q_DISENCHANT", "FOV_Q_DISENCHANT_DESC", (function()
		local f = DbFlag("foreverDisenchant", true)
		return { get = f.get, set = function(on)
			f.set(on)
			if ns.ForeverDisenchantRefresh then ns.ForeverDisenchantRefresh() end
		end }
	end)()),
	Q("FOV_Q_DISENCHANTNEXT", "FOV_Q_DISENCHANTNEXT_DESC", (function()
		local f = DbFlag("foreverDisenchantNext", false)
		return { get = f.get, set = function(on)
			f.set(on)
			if ns.ForeverDisenchantRefresh then ns.ForeverDisenchantRefresh() end
		end }
	end)()),
	{ head = "FOV_Q_HEAD_WARN" },
	Q("FOV_Q_BAGS", "FOV_Q_BAGS_DESC", Warn("bags")),
	Q("FOV_Q_REST", "FOV_Q_REST_DESC", Warn("rest")),
	Q("FOV_Q_POLE", "FOV_Q_POLE_DESC", Warn("pole")),
	PROF_SWITCHES[2], -- last tool
	PROF_SWITCHES[3], -- missing tool: where to buy
	{ head = "FOV_Q_HEAD_SCREEN" },
	-- 18 Nov 2026: the open-this-box button (Openables.lua). On by default: it only appears when a bag holds something
	-- you can open, and hides in combat.
	Q("FOV_Q_OPENABLES", "FOV_Q_OPENABLES_DESC", {
		get = function() return ns.IsOpenablesEnabled and ns.IsOpenablesEnabled() end,
		set = function(on) if ns.SetOpenablesEnabled then ns.SetOpenablesEnabled(on) end end }),
	-- 18 Nov 2026: the moving 3D portrait at the top left. OFF by default since the same evening (Rob via sparring:
	-- "Ja, zet hem standaard op uit" - he finds the round picture nicer); on = the 3D model.
	Q("FOV_Q_PORTRAIT3D", "FOV_Q_PORTRAIT3D_DESC", DbFlag("foreverPortrait3D", false)),
	KEY_SWITCHES[2], -- old-rank edge
	-- 19 Nov 2026 (Rob: "volg het maar en doe het maar"): the "just learned" list after the trainer (ForeverRanks.lua).
	Q("FRANK_LIST_SW", "FRANK_LIST_SW_DESC", {
		get = function() return ns.IsForeverLearnListOn and ns.IsForeverLearnListOn() end,
		set = function(on) if ns.SetForeverLearnList then ns.SetForeverLearnList(on) end end }),
	-- 19 Nov 2026 (Rob via sparring: "Op beide vragen ja"): a door to the rank choice window, right under the old-rank
	-- switch. An `action` entry: a button instead of an on/off chip (BuildQuietPage / FillQuietPage), and the search
	-- bar opens the window itself.
	{ action = true, title = "FRANK_CHOOSE_TITLE", tip = "FRANK_CHOOSE_DESC", keys = "FRANK_CHOOSE_KEYS",
		fn = function() if ns.ShowForeverRanks then ns.ShowForeverRanks() end end },
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
-- 21 Nov 2026 (Rob via sparring: "spar"/"ore"/"herb"/"glow" must find the sparkle and the ore and herb switches): extra
-- search words, English like the other search words; the switch's own title and text are searched in every language.
local QUIET_WORDS = {
	FLS_SW = "sparkle sparkles loot quest item glow outline",
	FNODE_ICON_SW = "ore ores herb herbs node nodes vein mining herbalism gather icon sparkle",
	FNODE_GLOW_SW = "ore ores herb herbs node nodes vein mining herbalism gather glow sparkle",
}
for _, q in ipairs(QUIET) do
	if q.title and QUIET_WORDS[q.title] then
		q.words = QUIET_WORDS[q.title]
	end
end

local function BuildQuietPage(f, x0, rightW)
	local page = f.pages.quiet
	local card = Card(page)
	card:SetPoint("TOPLEFT", f, "TOPLEFT", x0, SUB_TOP)
	card:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -RIGHT_PAD, 16)
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
		elseif q.action then
			local t = Text(card.child, "textB", 13)
			t:SetWidth(w - 110)
			t:SetText(ns:L(q.title))
			local b = Button(card.child, 96)
			b:SetHeight(22)
			b:SetLabel(ns:L("FOV_TOOL_OPEN"))
			Tip(b, ns:L(q.title), ns:L(q.tip))
			b:SetScript("OnClick", q.fn)
			local d = Text(card.child, "text", 12, A.dim)
			d:SetWidth(w - 110)
			d:SetText(ns:L(q.tip))
			card.items[i] = { action = true, text = t, btn = b, desc = d }
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

--- Gear → Tools (17 Nov 2026): every tool card the old window had in Forever that has no tab here
--- (ns.ToolsLaunchpadVisible: stat coach, Pawn and key exports, nameplate colours, FPS panel …), plus what only had
--- a command or the old window's menu: move mode, quick bar, "New in this version", changelog, the settings panel.
local TOOLS_ON_TABS = { KEYSHUB_TITLE = true, HOME_FOREVER_BTN_HOWTO = true, HOME_FOREVER_TRAINER_HEADER = true,
	FPROF_TITLE = true, FMAC_TITLE = true, FVEND_TITLE = true, FWEAP_TITLE = true, KEYBLOCK_TITLE = true,
	TAB_MACROS = true }
local TOOL_EXTRAS = {
	{ nameKey = "FOV_TOOL_MOVE", descKey = "CMDLIST_MOVE", icon = "Interface\\Icons\\INV_Misc_Map_01", slash = "/mh move",
		open = function() if ns.MoveModeSlash then ns.MoveModeSlash("") end end },
	{ nameKey = "FOV_TOOL_BAR", descKey = "CMDLIST_BAR", icon = "Interface\\Icons\\INV_Misc_Bag_08", slash = "/mh bar",
		open = function() if ns.MH_ToggleQuickBar then ns.MH_ToggleQuickBar() end end },
	{ nameKey = "FOV_TOOL_NEW", descKey = "CMDLIST_NEW", icon = "Interface\\Icons\\INV_Misc_Note_01", slash = "/mh new",
		open = function() if ns.NewChoicesSlash then ns.NewChoicesSlash("") end end },
	{ nameKey = "FOV_TOOL_CHANGELOG", descKey = "CMDLIST_CHANGELOG", icon = "Interface\\Icons\\INV_Misc_Book_09",
		slash = "/mh changelog", open = function() if ns.ShowChangelogWindow then ns:ShowChangelogWindow(true) end end },
	{ nameKey = "FOV_Q_ALLSETTINGS", descKey = "FOV_TIP_Q_ALLSETTINGS", icon = "Interface\\Icons\\INV_Misc_Gear_01",
		slash = "/mh settings", open = function() if ns.OpenNativeSettings then ns.OpenNativeSettings() end end },
}

local function BuildListPage(f, key, x0, rightW, labelKey, tipKey)
	local page = f.pages[key]
	local card = Card(page)
	card:SetPoint("TOPLEFT", f, "TOPLEFT", x0, SUB_TOP)
	card:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -RIGHT_PAD, 16)
	card.label = Label(card, ns:L(labelKey):upper(), tipKey)
	card.sf, card.child = S.Scroll(card, 36, 8, 50)
	card.rowW = rightW - 22 - 8
	card.child:SetWidth(card.rowW)
	card.rows = {}
	page.card = card
	return card
end

local function ToolRow(card, i)
	local r = card.rows[i]
	if r then
		return r
	end
	r = CreateFrame("Frame", nil, card.child)
	r:SetWidth(card.rowW)
	local sep = r:CreateTexture(nil, "ARTWORK")
	sep:SetColorTexture(A.edge[1], A.edge[2], A.edge[3], 0.35)
	sep:SetHeight(1)
	sep:SetPoint("BOTTOMLEFT")
	sep:SetPoint("BOTTOMRIGHT")
	r.icon = r:CreateTexture(nil, "ARTWORK")
	r.icon:SetSize(28, 28)
	r.icon:SetPoint("TOPLEFT", 4, -6)
	r.icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
	r.go = Button(r, 96)
	r.go:SetHeight(22)
	r.go:SetPoint("TOPRIGHT", -2, -6)
	r.go:SetLabel(ns:L("FOV_TOOL_OPEN"))
	r.name = Text(r, "textB", 14)
	r.name:SetPoint("TOPLEFT", r.icon, "TOPRIGHT", 10, 2)
	r.name:SetWidth(card.rowW - 150)
	r.name:SetWordWrap(false)
	r.desc = Text(r, "text", 12, A.dim)
	r.desc:SetPoint("TOPLEFT", r.name, "BOTTOMLEFT", 0, -2)
	r.desc:SetWidth(card.rowW - 150)
	r.slash = Text(r, "text", 11, A.later)
	r.slash:SetPoint("TOPLEFT", r.desc, "BOTTOMLEFT", 0, -2)
	card.rows[i] = r
	return r
end

--- Gear → Commands: every /mh command with its one line, grouped as the old command list (CommandList.lua, the same
--- table and the same "is it for this player" rule), with a search box. Type them in chat.
local function BuildCmdsPage(f, x0, rightW)
	local card = BuildListPage(f, "cmds", x0, rightW, "CMDLIST_TITLE", "FOV_TIP_SUB_CMDS")
	local box = CreateFrame("EditBox", nil, card, "InputBoxTemplate")
	box:SetSize(200, 20)
	box:SetPoint("TOPRIGHT", -16, -9)
	box:SetAutoFocus(false)
	box:SetScript("OnTextChanged", function()
		ns.ForeverOverviewFill(true)
	end)
	box:SetScript("OnEscapePressed", function(self)
		self:ClearFocus()
	end)
	box.hint = Text(card, "text", 11, A.later)
	box.hint:SetPoint("RIGHT", box, "LEFT", -10, 0)
	box.hint:SetText(ns:L("FOV_CMDS_SEARCH"))
	card.search = box
end

local function CmdRow(card, i)
	local r = card.rows[i]
	if r then
		return r
	end
	r = CreateFrame("Frame", nil, card.child)
	r:SetWidth(card.rowW)
	r.cmd = Text(r, "textB", 13, A.gold)
	r.cmd:SetPoint("TOPLEFT", 4, -2)
	r.cmd:SetWidth(180)
	r.cmd:SetWordWrap(false)
	r.desc = Text(r, "text", 12, A.text)
	r.desc:SetPoint("TOPLEFT", 190, -2)
	r.desc:SetWidth(card.rowW - 196)
	r.head = Text(r, "head2", 13, A.label)
	r.head:SetPoint("TOPLEFT", 4, -6)
	card.rows[i] = r
	return r
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
	body:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -RIGHT_PAD, 16)
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
	-- Layout D (20 Nov 2026): decided once, here, before any page reads W / RIGHT_PAD / SUB_TOP.
	NEW_LAYOUT = ns.IsForeverNewLayout()
	if NEW_LAYOUT then
		W, H = 1100, 600
		RIGHT_PAD = 16 + VTAB_W + 12
		SUB_TOP = TOP_Y -- no switch row on top: the sub-tabs sit in the right column
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
	-- A solid layer under the gradient (Rob, 17 Nov 2026, after the 1.0 gradient: still "bovenin een beetje" showing
	-- through). Two opaque layers: nothing of the world can shine through, whatever the gradient does with alpha.
	f:SetBackdropColor(A.bgBottom[1], A.bgBottom[2], A.bgBottom[3], 1)
	f:SetBackdropBorderColor(A.gold[1], A.gold[2], A.gold[3], 1)
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
	-- Layout D is bigger: a Shift+scroll size saved for the old 920x520 window could push it off a small screen. On every
	-- opening the scale is lowered (never raised) until the whole window fits; clamping keeps it on screen.
	f:HookScript("OnShow", function(self)
		local sw, sh = UIParent:GetWidth(), UIParent:GetHeight()
		local s = self:GetScale() or 1
		if sw and sh and sw > 0 and sh > 0 then
			local fit = math.min((sw - 20) / W, (sh - 20) / H)
			if s > fit and fit > 0.3 then
				self:SetScale(fit)
			end
		end
	end)

	-- Header: title, tabs, close.
	f.title = Text(f, "head", 22, A.gold)
	f.title:SetPoint("TOPLEFT", 22, -14)
	f.title:SetText("MIDNIGHT HELPER")
	-- 21 Nov 2026 (Rob via sparring: "waarom staat er niet onder Forever versie ... Iets dat duidelijk maakt dat het echt
	-- voor Forever is"): "for WoW Forever" under the name, in both layouts (the title row is the same in both).
	f.subtitle = Text(f, "textB", 11, A.dim)
	f.subtitle:SetPoint("TOPLEFT", f.title, "BOTTOMLEFT", 1, -1)
	f.subtitle:SetText(ns:L("FOV_SUBTITLE"))
	-- No Dock button here. Rob, 17 Nov 2026 (via sparring, verbatim): "het knopje dock en undock is eigenlijk nergens
	-- meer nodig. Want waar gaan we het in godsnaam aan vastplakken?" - the overview IS the main window in Forever. A
	-- window that was docked before is undocked once.
	if f._mhDockBtn then
		f._mhDockBtn:Hide()
		f._mhDockBtn:SetScript("OnShow", function(self)
			self:Hide()
		end)
	end
	if ns.IsMidnightDialogDocked and ns.SetMidnightDialogDocked and ns.IsMidnightDialogDocked(f) then
		pcall(ns.SetMidnightDialogDocked, f, false, f:GetName())
	end
	local line = f:CreateTexture(nil, "ARTWORK")
	line:SetColorTexture(A.gold[1], A.gold[2], A.gold[3], 0.35)
	line:SetPoint("TOPLEFT", 1, LINE_Y)
	line:SetPoint("TOPRIGHT", -1, LINE_Y)
	line:SetHeight(1)
	local close = CreateFrame("Button", nil, f, "UIPanelCloseButton")
	close:SetPoint("TOPRIGHT", -2, -2)
	-- "All tools" (the old window) is gone since 17 Nov 2026: everything it had in Forever has a place here (gear →
	-- Tools and Commands), and the old window is not shown in Forever any more (UI.lua ToggleMainWindow/ShowMainUI).
	-- The gear: quiet helpers, tools, commands (a group of pages, see GROUPS.gear); again = back to Now.
	-- A game icon, not a glyph: our fonts have no gear sign (and lint [14] forbids emoji).
	local gear = Button(f, 30)
	gear:SetHeight(22)
	gear:SetPoint("TOPRIGHT", -34, -15)
	gear.icon = gear:CreateTexture(nil, "OVERLAY")
	gear.icon:SetSize(16, 16)
	gear.icon:SetPoint("CENTER")
	gear.icon:SetTexture("Interface\\Icons\\INV_Misc_Gear_01")
	gear.icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
	gear:SetScript("OnClick", function()
		if PAGE_GROUP[f.page] == "gear" then
			f.page = "now"
		else
			f.page = f.lastInGroup.gear or "quiet"
		end
		ns.ForeverOverviewFill()
	end)
	Tip(gear, ns:L("FOV_LABEL_QUIET"), ns:L("FOV_TIP_GEAR"))
	f.gear = gear
	-- The search bar (18 Nov 2026, Rob via sparring: "wat we nog missen in de forever versie is net zo een uitgebreide
	-- zoek functie (bar) als in de midnight versie" … "in principe moet je alles kunnen vinden"; "ik volg jullie
	-- advies"). In the title row between the name and the gear. Midnight's matcher (NavSearch.lua) with the list of
	-- ns.ForeverSearchIndex below; its result list is restyled in style A.
	do
		local WHITE8 = "Interface\\Buttons\\WHITE8X8"
		local sb = CreateFrame("Frame", nil, f, "BackdropTemplate")
		sb:SetPoint("TOPLEFT", 270, -14)
		sb:SetPoint("TOPRIGHT", gear, "TOPLEFT", -10, 1)
		sb:SetHeight(24)
		sb:SetBackdrop({ bgFile = WHITE8, edgeFile = WHITE8, edgeSize = 1 })
		sb:SetBackdropColor(A.card[1], A.card[2], A.card[3], 0.95)
		sb:SetBackdropBorderColor(A.edge[1], A.edge[2], A.edge[3], 0.9)
		local box = CreateFrame("EditBox", "MidnightHelperForeverSearchBox", sb)
		box:SetPoint("TOPLEFT", 8, -2)
		box:SetPoint("BOTTOMRIGHT", -8, 2)
		box:SetAutoFocus(false)
		box:SetMaxLetters(60)
		if not box:SetFont(A.fonts.text, 13, "") then
			box:SetFont(A.fallback.text, 13, "")
		end
		box:SetTextColor(A.text[1], A.text[2], A.text[3])
		local hint = Text(sb, "text", 13, A.dim)
		hint:SetPoint("LEFT", 8, 0)
		hint:SetPoint("RIGHT", -8, 0)
		hint:SetWordWrap(false)
		hint:SetText(ns:L("FOV_SEARCH_HINT"))
		local function ShowHint()
			hint:SetShown(box:GetText() == "" and not box:HasFocus())
		end
		box:SetScript("OnEditFocusGained", ShowHint)
		box:SetScript("OnEditFocusLost", ShowHint)
		box:SetScript("OnTextChanged", ShowHint)
		box:SetScript("OnEscapePressed", function(self)
			self:SetText("")
			self:ClearFocus()
		end)
		box:SetScript("OnEnterPressed", function(self)
			if ns.NavSearchEnter then
				ns.NavSearchEnter(self)
			end
		end)
		Tip(box, (ns:L("FOV_CMDS_SEARCH"):gsub("%s*:%s*$", "")), ns:L("FOV_SEARCH_TIP"))
		box._mhNavParent = f
		box._mhNavName = "MidnightHelperForeverSearchDrop"
		box._mhNoMatchKey = "FOV_SEARCH_NONE"
		box._mhNavOnCreate = function(drop)
			if drop.SetBackdropColor then
				drop:SetBackdropColor(A.bgBottom[1], A.bgBottom[2], A.bgBottom[3], 0.98)
				drop:SetBackdropBorderColor(A.gold[1], A.gold[2], A.gold[3], 0.9)
			end
			for _, r in ipairs(drop.rows or {}) do
				S.Font(r.fs, A.fonts.text, 13, A.fallback.text)
				r.fs:SetTextColor(A.text[1], A.text[2], A.text[3])
			end
			if drop.more then
				S.Font(drop.more, A.fonts.text, 11, A.fallback.text)
			end
		end
		if ns.NavSearchAttach then
			ns.NavSearchAttach(box)
		end
		f:HookScript("OnHide", function()
			box:SetText("")
			box:ClearFocus()
			f._modelSet = nil -- set the moving portrait again on the next opening
		end)
		f.search = box
	end
	-- Tabs on their own row under the title (plan step 1: 7 tabs and long German words did not fit next to the title).
	-- TAB_SLOTS equal widths, so the row stays put when a tab is added.
	-- Layout D: the same buttons as a column on the right (placed in RelayoutTabs, because a group's sub-tabs open
	-- under its tab), and the open page's name centred where the tab row was.
	f.tabs = {}
	local tabW = NEW_LAYOUT and VTAB_W or math.floor((W - 32 - (TAB_SLOTS - 1) * 6) / TAB_SLOTS)
	if NEW_LAYOUT then
		f.pageName = Text(f, "head", 20, A.gold)
		f.pageName:SetPoint("TOP", 0, TAB_Y - 2)
		f.pageName:SetWidth(W - 2 * (16 + LEFT_W))
		f.pageName:SetJustifyH("CENTER")
		f.pageName:SetWordWrap(false)
	end
	for i = 1, #TABS do
		local t = TABS[i]
		local b = Button(f, tabW)
		if NEW_LAYOUT then
			b:SetHeight(VTAB_H)
		else
			b:SetPoint("TOPLEFT", 16 + (i - 1) * (tabW + 6), TAB_Y)
		end
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
		b.page, b.group, b.labelKey = t.page, t.group, t.key
		Tip(b, ns:L(t.key), ns:L(t.tip))
		f.tabs[i] = b
	end
	-- Pages: the left column (portrait, level) stays, the right part switches.
	f.page = "now"
	f.lastInGroup = {}
	f.pages = {}
	for _, key in ipairs({ "now", "play", "cq", "camp", "legacy", "trainer", "find", "keys", "profs", "dungeons", "chars", "week", "rep", "quiet", "tools", "cmds" }) do
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
			-- Layout D: the row's buttons become small indented tabs in the right column (RelayoutTabs places them).
			local b = Button(NEW_LAYOUT and f or row, NEW_LAYOUT and (VTAB_W - VSUB_IN) or 160)
			b:SetHeight(NEW_LAYOUT and VSUB_H or 22)
			if not NEW_LAYOUT then
				b:SetPoint("TOPLEFT", (i - 1) * 166, 0)
			end
			b:SetLabel(ns:L(p.key))
			Tip(b, ns:L(p.key), ns:L(p.tip))
			b:SetScript("OnClick", function()
				f.page = p.page
				ns.ForeverOverviewFill()
			end)
			b.page, b.labelKey = p.page, p.key
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
	f.portraitRing = ring
	-- Moving portrait (18 Nov 2026, Rob via sparring: "is dit te animeren, ?" → "ja doe maar"): a 3D PlayerModel of you,
	-- breathing and blinking (idle animation). Option b of the plan: a square box with a gold edge, because a model
	-- ignores round masks and only a rectangle clip holds it (MidnightToast.lua: "PlayerModels renderen buiten hun
	-- frame-rect"). The flat round picture stays as the fallback (switch off, or the model loads nothing).
	do
		local W8 = "Interface\\Buttons\\WHITE8X8"
		local box = CreateFrame("Frame", nil, left, "BackdropTemplate")
		box:SetSize(76, 76)
		box:SetPoint("CENTER", ring)
		box:SetBackdrop({ bgFile = W8, edgeFile = W8, edgeSize = 2 })
		box:SetBackdropColor(0.07, 0.05, 0.04, 1)
		box:SetBackdropBorderColor(A.gold[1], A.gold[2], A.gold[3], 1)
		local clip = CreateFrame("Frame", nil, box)
		clip:SetPoint("TOPLEFT", 2, -2)
		clip:SetPoint("BOTTOMRIGHT", -2, 2)
		if clip.SetClipsChildren then
			clip:SetClipsChildren(true)
		end
		local m = CreateFrame("PlayerModel", nil, clip)
		m:SetAllPoints(clip)
		if m.EnableMouse then
			m:EnableMouse(false)
		end
		-- Rob's screenshot (Troll, 18 Nov 2026): the model sat off-centre, mostly hair. A portrait zoom set before the
		-- model has loaded is not used (AFGELEID): set the face camera again once it has loaded.
		pcall(m.SetScript, m, "OnModelLoaded", function(self)
			pcall(function()
				if self.SetPortraitZoom then
					self:SetPortraitZoom(1)
				end
				if self.SetCamDistanceScale then
					self:SetCamDistanceScale(1)
				end
				if self.SetPosition then
					self:SetPosition(0, 0, 0)
				end
				if self.RefreshCamera then
					self:RefreshCamera()
				end
			end)
		end)
		box:Hide()
		f.portraitBox, f.portraitModel = box, m
	end
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
	local rightW = W - x0 - RIGHT_PAD
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
	-- 18 Nov 2026 (Rob's screenshot, Ima Magieman: "Class quest: Study (free scrolls from the library, o…" and its line
	-- below cut off, and the place line lying over the list): up to 3 lines each, a fixed width so the height can be
	-- measured right away, the whole text in a tooltip, and the list below starts where this text ends (FillNow).
	local mainW = nowW - 28
	f.now.title = Text(f.now, "head", 21, A.text)
	f.now.title:SetPoint("TOPLEFT", 14, -32)
	f.now.title:SetWidth(mainW)
	if f.now.title.SetMaxLines then
		f.now.title:SetMaxLines(3)
	end
	f.now.what = Text(f.now, "text", 14, A.text)
	f.now.what:SetPoint("TOPLEFT", f.now.title, "BOTTOMLEFT", 0, -4)
	f.now.what:SetWidth(mainW)
	if f.now.what.SetMaxLines then
		f.now.what:SetMaxLines(3)
	end
	f.now.place = Text(f.now, "text", 12, A.dim)
	f.now.place:SetPoint("TOPLEFT", f.now.what, "BOTTOMLEFT", 0, -3)
	f.now.place:SetWidth(mainW)
	f.now.place:SetWordWrap(true)
	if f.now.place.SetMaxLines then
		f.now.place:SetMaxLines(2)
	end
	f.now.mainHover = HoverOver(f.now, f.now.title)
	f.now.mainHover:SetPoint("BOTTOMRIGHT", f.now.place, "BOTTOMRIGHT")
	-- Plan step 2: the main line's buttons sit on the label row, so the whole list fits below.
	-- 18 Nov 2026 (Rob's screenshot: "Details" and "Show the way" lay over "DO THIS NOW"): the card is 266 px wide and
	-- the two buttons took 196 of it. Smaller buttons (their text shrinks to fit, S.Button), and the label now stops
	-- before them ("…" when a language's word is longer) instead of running under them.
	f.now.go = Button(f.now, 86)
	f.now.go:SetHeight(20)
	f.now.go:SetPoint("TOPRIGHT", -10, -8)
	f.now.go:SetLabel(ns:L("FOV_GO"))
	Tip(f.now.go, ns:L("FOV_GO"), ns:L("FOV_TIP_GO"))
	f.now.detail = Button(f.now, 58)
	f.now.detail:SetHeight(20)
	f.now.detail:SetPoint("RIGHT", f.now.go, "LEFT", -4, 0)
	f.now.detail:SetLabel(ns:L("FOV_DETAILS"))
	Tip(f.now.detail, ns:L("FOV_DETAILS"), ns:L("FOV_TIP_DETAILS"))
	f.now.label:SetPoint("RIGHT", f.now.detail, "LEFT", -6, 0)
	f.now.label:SetWordWrap(false)
	-- Every other line of the "Do this now" list (product plan step 2: the whole list, not two), scrolling, each with
	-- its own button when the small window has one for it.
	f.now.sf, f.now.child = S.Scroll(f.now, 140, 8, 44)
	f.now.more = {}
	-- Text width of a row: card − scroll insets (8 + 14) − row insets (6 + 2) − the button column (96; was 74 with a
	-- 70 px button, and "Weapon trai…" / "Profession tr…" were cut off on Rob's screenshot, 18 Nov 2026).
	f.now.textW = nowW - 22 - 8 - 96

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
		-- 19 Nov 2026 (Rob: "overal waar een tooltip bestaat in de game"): the name shows the spell's tooltip too, not only
		-- the icon. tipSpell is set in the fill; without it the hover stays silent.
		local hv = HoverOver(f.soon, nm)
		f.soon.rows[i] = { icon = ic, name = nm, level = lv, hover = hv }
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
	f.path:SetPoint("BOTTOMRIGHT", -RIGHT_PAD, 16)
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
		-- Two lines (Rob's screenshot, 18 Nov 2026: "Aspect of the Mon…"): a column is 168 px, the name 124 px; the card
		-- has room for a second line above the "+1 more" line.
		n.name = Text(f.path, "textB", 14, A.text)
		n.name:SetWidth(colW - 44)
		n.name:SetWordWrap(true)
		if n.name.SetMaxLines then
			n.name:SetMaxLines(2)
		end
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
	BuildRepPage(f, x0, rightW)
	BuildQuietPage(f, x0, rightW)
	BuildListPage(f, "tools", x0, rightW, "FOV_SUB_TOOLS", "FOV_TIP_SUB_TOOLS")
	BuildCmdsPage(f, x0, rightW)
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
		-- Rob's first test (17 Nov 2026): after a full restart the first opening showed empty tabs (font not loaded yet,
		-- AFGELEID). Set every font and text again a moment later, twice, and write what was seen to
		-- ns.db.foreverFontProbe (strings with text, how many drew nothing before and after) so a /reload can show it.
		if C_Timer and C_Timer.After and S.RefreshFonts then
			for _, delay in ipairs({ 0.1, 0.6 }) do
				C_Timer.After(delay, function()
					if not f:IsShown() then
						return
					end
					local n, before = S.FontProbe()
					S.RefreshFonts()
					local _, after = S.FontProbe()
					if ns.db then
						ns.db.foreverFontProbe = ns.db.foreverFontProbe or {}
						local p = ns.db.foreverFontProbe
						p[#p + 1] = { at = time and time() or nil, delay = delay, strings = n, emptyBefore = before,
							emptyAfter = after }
						while #p > 10 do
							table.remove(p, 1)
						end
					end
					-- 18 Nov 2026 (Rob's screenshot: the yellow Self Cast line of "Set focus" ran out of its row): row
					-- heights are measured while filling, and the fonts change size when they are set again just above.
					-- Lay the open page out once more with the final fonts (refresh = keep the scroll position).
					ns.ForeverOverviewFill(true)
				end)
			end
		end
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

--- The portrait: the moving 3D model when the switch is on (default) and the model loads, else the flat picture.
--- Every decision and its reason goes to ns.db.foreverPortraitProbe (an empty model looks like a broken one).
local function UsePortraitFlat(f, why)
	f.portraitBox:Hide()
	f.portraitRing:Show()
	f.portrait:Show()
	if SetPortraitTexture then
		pcall(SetPortraitTexture, f.portrait, "player")
	end
	if ns.db then
		ns.db.foreverPortraitProbe = { at = time and time() or nil, shown = "flat", why = why }
	end
end

local function SetPortrait(f, force)
	-- Off unless switched on (Rob, 18 Nov 2026: "Ja, zet hem standaard op uit").
	local want = ns.db and ns.db.foreverPortrait3D == true
	local m = f.portraitModel
	if not want or not (m and m.SetUnit) then
		f._modelSet = nil
		UsePortraitFlat(f, want and "no PlayerModel:SetUnit" or "switch off")
		return
	end
	if f._modelSet and not force then
		return -- already showing: setting it again would restart the idle animation on every page change
	end
	local ok = pcall(function()
		m:ClearModel()
		m:SetUnit("player")
		if m.SetPortraitZoom then
			m:SetPortraitZoom(1)
		end
		if m.SetPosition then
			m:SetPosition(0, 0, 0)
		end
		-- Without an animation call a PlayerModel holds a frozen pose (MidnightToast.lua, 15 Sep 2026): -1 loops the idle.
		if m.SetAnimation then
			pcall(m.SetAnimation, m, 0, -1)
		end
		if m.SetPaused then
			pcall(m.SetPaused, m, false)
		end
	end)
	if not ok then
		f._modelSet = nil
		UsePortraitFlat(f, "SetUnit failed")
		return
	end
	f._modelSet = true
	f.portraitRing:Hide()
	f.portrait:Hide()
	f.portraitBox:Show()
	-- A PlayerModel sometimes loads nothing (DevShots.lua). Look a moment later: no model file = back to the picture.
	if C_Timer and C_Timer.After then
		C_Timer.After(0.6, function()
			if not f._modelSet then
				return
			end
			local okId, id = true, nil
			if m.GetModelFileID then
				okId, id = pcall(m.GetModelFileID, m)
			end
			if m.GetModelFileID and (not okId or not id or id == 0) then
				f._modelSet = nil
				UsePortraitFlat(f, "model loaded nothing (GetModelFileID " .. tostring(id) .. ")")
			elseif ns.db then
				ns.db.foreverPortraitProbe = { at = time and time() or nil, shown = "3d", fileID = id }
			end
		end)
	end
end

--- Your look changed (gear, shapeshift, appearance): set the model again.
do
	local ev = CreateFrame("Frame")
	for _, e in ipairs({ "UNIT_MODEL_CHANGED", "PLAYER_EQUIPMENT_CHANGED", "UPDATE_SHAPESHIFT_FORM" }) do
		pcall(ev.RegisterEvent, ev, e)
	end
	ev:SetScript("OnEvent", function(_, event, unit)
		if event == "UNIT_MODEL_CHANGED" and unit ~= "player" then
			return
		end
		if win and win:IsShown() and win.portraitModel then
			SetPortrait(win, true)
		elseif win then
			win._modelSet = nil
		end
	end)
end

local function FillLeft(f, level)
	local r, g, b = Accent()
	SetPortrait(f)
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
		-- 20 Nov 2026: resting here or not, and the nearest place to rest (ForeverRestXP.lua).
		local restLine = ns.ForeverRestTipLine and ns.ForeverRestTipLine()
		if restLine then
			f.xpTip.tipBody = f.xpTip.tipBody .. "\n\n" .. restLine
		end
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
	f.gold:SetText(ns:L("FOV_GOLD_FMT"):format(Money(money)))
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

--- Spell icons under a "Do this now" line that names spells (19 Nov 2026, Rob: "ook de do now in het overzicht"): one
--- icon per spell with the game's own tooltip. Links in the text cannot answer the mouse in this scrolling list, so
--- icons, as in "Coming up". Placed at (x, -y) from `holder`'s top left; returns the height used (0 without spells).
local STRIP_MAX, STRIP_SIZE = 8, 20
local function SpellStrip(owner, parent, holder, x, y, spells)
	owner.strip = owner.strip or {}
	local n = 0
	for i, id in ipairs(spells or {}) do
		if i > STRIP_MAX then
			break
		end
		local ic = owner.strip[i]
		if not ic then
			ic = SpellButton(parent, STRIP_SIZE)
			ic:SetFrameLevel(parent:GetFrameLevel() + 5) -- above the line's own hover area (HoverOver)
			owner.strip[i] = ic
		end
		ic:ClearAllPoints()
		ic:SetPoint("TOPLEFT", holder, "TOPLEFT", x + (i - 1) * (STRIP_SIZE + 4), -y)
		ic.tex:SetTexture(SpellIcon(id))
		ic.tipSpell = id
		ic:Show()
		n = i
	end
	for i = n + 1, #owner.strip do
		owner.strip[i]:Hide()
		owner.strip[i].tipSpell = nil
	end
	return n > 0 and (STRIP_SIZE + 4) or 0
end

local function FillNow(f, items, up)
	local main = MainItem(items)
	if main then
		-- Rob's first test (17 Nov 2026): "YOU CAN LEARN 2 NEW WEAPON SKILLS NOW. (FIT…" was cut off in capitals. A long
		-- sentence without its own second line is split after its first sentence (or before a bracket): the rest goes on
		-- the line below. A title that stays long gets smaller letters, so two lines hold it.
		local title, what = main.title or "", main.what
		if not what and #title > 32 then
			local a, b = title:match("^(.-[%.%!%?:])%s+(.+)$")
			if not a then
				a, b = title:match("^(.-)%s+(%(.+)$")
			end
			if a and #a >= 8 then
				title, what = a, b
			end
		end
		S.Font(f.now.title, A.fonts.head, #title > 30 and 17 or 21, A.fallback.head)
		f.now.title:SetText(title)
		f.now.what:SetText(what or "")
		f.now.place:SetText(main.place or "")
		f.now.go:SetLabel(ns:L(main.goLabel or "FOV_GO"))
		f.now.go.tipTitle = ns:L(main.goLabel or "FOV_GO")
		SetGo(f.now.go, main.go)
		-- A detail page for this line (the trainer, plan step 3), when the overview has one.
		SetGo(f.now.detail, main.page and f.pages[main.page] and function()
			ns.ShowForeverOverviewPage(main.page)
		end or nil)
	else
		S.Font(f.now.title, A.fonts.head, 21, A.fallback.head)
		f.now.title:SetText(ns:L("FOV_ALL_DONE"))
		local nxt = up and up[1]
		f.now.what:SetText(nxt and ns:L("FOV_NEXT_SPELL_FMT"):format(nxt.name, nxt.l) or ns:L("FOV_ALL_DONE_SUB"))
		f.now.place:SetText("")
		SetGo(f.now.go, nil)
		SetGo(f.now.detail, nil)
	end
	-- The whole main line in a tooltip (for when 3 lines are not enough), and the list starts below the text.
	local tt, tw, tp = f.now.title:GetText() or "", f.now.what:GetText() or "", f.now.place:GetText() or ""
	f.now.mainHover.tipTitle = tt
	f.now.mainHover.tipBody = (tw ~= "" and tw or "") .. ((tw ~= "" and tp ~= "") and "\n" or "") .. tp
	local function H(fs)
		local t = fs:GetText()
		return (t and t ~= "") and (fs:GetStringHeight() or 0) or 0
	end
	local top = 32 + H(f.now.title) + 4 + H(f.now.what) + 3 + H(f.now.place) + 4
	-- The main line's spells as icons, right under its text (the list starts below them).
	top = top + SpellStrip(f.now, f.now, f.now, 14, top, main and main.spells) + 6
	f.now.listTop = math.max(110, math.ceil(top))
	f.now.sf.SetTop(f.now.listTop)
	local rest = {}
	for _, it in ipairs(items) do
		if it ~= main then
			rest[#rest + 1] = it
		end
	end
	-- The whole rest of the list (plan step 2), scrolling; each line with the window's own button for it.
	-- Rob's first test (17 Nov 2026): a three-line tip ran into the next row ("The Hall of Thanes (entranc…" over "Best
	-- stats for you now:"): every row was NOW_ROW_H tall. Now each row is as tall as its text.
	local y = 4
	for i, it in ipairs(rest) do
		local row = NowRow(f.now, i)
		row:ClearAllPoints()
		row:SetPoint("TOPLEFT", f.now.child, "TOPLEFT", 6, -y)
		row:SetPoint("RIGHT", f.now.child, "RIGHT", -2, 0)
		-- A line without a place or second line (a tip) may use three lines (sparring: "Dungeons for your level… Ragefir…").
		local sub = it.place or it.what
		-- 18 Nov 2026 (Rob's screenshot: "You can learn 8 new weapon skills now. (fitting Beast Mastery, accordin…" stopped
		-- after 3 lines once the button got wider): no line limit any more - the row grows with its text (height below),
		-- the line under it too.
		row.text:SetWordWrap(true)
		if row.text.SetMaxLines then
			row.text:SetMaxLines(0)
		end
		row.sub:SetWordWrap(true)
		if row.sub.SetMaxLines then
			row.sub:SetMaxLines(0)
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
		local h = (row.text:GetStringHeight() or 14) + (sub and ((row.sub:GetStringHeight() or 12) + 1) or 0) + 4
		h = h + SpellStrip(row, row, row, 0, math.ceil(h), it.spells)
		h = math.max(NOW_ROW_H - 4, math.ceil(h))
		row:SetHeight(h)
		row:Show()
		y = y + h + 4
	end
	for i = #rest + 1, #f.now.more do
		f.now.more[i]:Hide()
	end
	f.now.child:SetHeight(math.max(10, y))
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
	local y = 0
	for i, e in ipairs(list) do
		local row = ClassQuestRow(card, i)
		-- 19 Nov 2026 (Rob's screenshot: "dat daar tekst doorheen staat"): rows were a fixed 74 px at a fixed place, so a
		-- two-line step plus its place line ran into the next row. Now each row is placed under the one before it.
		row:ClearAllPoints()
		row:SetPoint("TOPLEFT", card.child, "TOPLEFT", 0, -y)
		row:SetPoint("RIGHT", card.child, "RIGHT", 0, 0)
		row.num:SetText(tostring(e.level or ""))
		row.levelTip.tipTitle = ns:L("FOV_LEVEL_FMT"):format(e.level or 0)
		row.name:SetText(e.chain or "")
		-- A chain with a reward spell has the game's tooltip on its name: link blue (19 Nov 2026).
		local nc = (e.spell and S.LINK) or A.text
		row.name:SetTextColor(nc[1], nc[2], nc[3])
		row.icon.tipLink = nil
		if e.spell then
			row.icon.tex:SetTexture(SpellIcon(e.spell))
			row.icon.tipSpell = e.spell
			row.icon:Show()
		elseif e.item and C_Item and C_Item.GetItemIconByID then
			-- A chain without a spell whose step uses an item (paladin tomes): that item, with its own tooltip.
			local okI, tex = pcall(C_Item.GetItemIconByID, e.item)
			row.icon.tex:SetTexture(okI and tex or nil)
			row.icon.tipSpell = nil
			row.icon.tipLink = "item:" .. e.item
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
		-- The chain's spell: the name shows the game's spell tooltip, the step under it (19 Nov 2026).
		row.hover.tipSpell = e.spell
		row.questHover.tipTitle = e.chain
		row.questHover.tipBody = row.what:GetText()
		row.questHover.tipLink = (e.state ~= "done" and e.quest) and ("quest:" .. e.quest) or nil
		SetGo(row.go, e.state ~= "done" and e.zone and e.go or nil)
		-- Height from the text that is drawn: name, step (up to 2 lines), place (the name starts ~6 px down).
		local function H(fs)
			local t = fs:GetText()
			return (t and t ~= "") and (fs:GetStringHeight() or 0) or 0
		end
		local need = 6 + H(row.name) + 2 + H(row.what) + 2 + H(row.place) + 10
		local h = math.max(CQP_ROW_H - 6, math.ceil(need))
		row:SetHeight(h)
		row:Show()
		y = y + h + 6
	end
	for i = #list + 1, #card.rows do
		card.rows[i]:Hide()
	end
	card.child:SetHeight(math.max(10, y))
	card.sf.Reset()
	-- The step and place lines are anchored left AND right, so their width (and so their wrapped height) is only known
	-- after the layout pass (AFGELEID; the same reason NowRow uses a fixed width). Measure once more a frame later; the
	-- flag makes every outside fill cause exactly one extra fill, never a loop.
	card._cqAgain = not card._cqAgain
	if card._cqAgain and C_Timer and C_Timer.After then
		C_Timer.After(0, function()
			if card:IsVisible() then
				FillClassQuestPage(f, level)
			else
				card._cqAgain = false
			end
		end)
	end
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
		if not e then
			row.hover.tipSpell = nil -- a header or note row: no stale spell from the row's earlier use
		end
		if it.head then
			row.head:SetText(it.head)
		elseif it.line then
			row.line:SetText(it.line)
		else
			row.icon.tex:SetTexture(SpellIcon(e.id))
			row.icon.tipSpell = e.id
			row.name:SetText(e.name .. (e.rank and (" |cff9d9d9d(" .. e.rank .. ")|r") or ""))
			-- Link blue for a spell you can learn now (it has the game's tooltip, 19 Nov 2026); later ones stay dim.
			local lc = S.LINK or A.text
			row.name:SetTextColor(it.later and A.dim[1] or lc[1], it.later and A.dim[2] or lc[2], it.later and A.dim[3] or lc[3])
			row.cost:SetText(e.cost or "")
			row.hover.tipTitle = e.name
			row.hover.tipBody = e.key and ns:L("FOV_TIP_TR_KEY_FMT"):format(e.key) or e.where
			row.hover.tipSpell = e.id -- 19 Nov 2026: the name shows the game's spell tooltip, our key line under it
			-- The icon too (Rob's screenshot, 19 Nov: spell tooltip without the blue line — AFGELEID he hovered the icon,
			-- which had no body). Header rows hide the icon, so no stale body shows there.
			row.icon.tipBody = row.hover.tipBody
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
	-- 18 Nov 2026 (Rob via sparring: "Kunnen we daar inklapbare dingen van maken? … Want dit wordt één hele lange lijst
	-- zo." → "ja"): every heading has an id (`sec`); before returning, every item gets the id of its heading.
	local function head(t, id)
		items[#items + 1] = { head = t, sec = id or t }
	end
	local cname, token = UnitClass and UnitClass("player")
	if ns.ForeverClassName and token then
		cname = ns.ForeverClassName(token) or cname
	end
	head(ns:L("FOV_FIND_SEC_CLASS"), "class")
	items[#items + 1] = { kind = "class", name = ns:L("FOV_FIND_CLASS_FMT"):format(cname or "?") }
	head(ns:L("FOV_FIND_SEC_PROF"), "prof")
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
		head(ns:L("FOV_FIND_SEC_WEAP"), "weapon")
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
	-- 17 Nov 2026: bank, auction house, mailbox and inn get their own heading ("In town"), after the shops.
	-- 18 Nov 2026: and travel (boats, zeppelins, tram, portals, flight masters) a third one ("Travel").
	local SEC = { "FOV_FIND_SEC_SHOP", "FOV_FIND_SEC_CITY", "FOV_FIND_SEC_TRAVEL" }
	local SEC_ID = { "shop", "city", "travel" }
	for pass = 1, 3 do
		local first = true
		for _, c in ipairs(shops) do
			local group = (c.travel and 3) or (c.svc and 2) or 1
			if group == pass then
				if first then
					head(ns:L(SEC[pass]), SEC_ID[pass])
					first = false
				end
				items[#items + 1] = { kind = "shop", key = c.key, name = c.name, goods = c.goods, svc = c.svc, item = c.item }
			end
		end
	end
	-- 18 Nov 2026 (Rob: rares, "eerst a daarna b"): rares (ForeverRares.lua).
	if ns.ForeverRareFindCats then
		local ok, cats = pcall(ns.ForeverRareFindCats)
		if ok and type(cats) == "table" and #cats > 0 then
			head(ns:L("FOV_FIND_SEC_RARE"), "rare")
			for _, c in ipairs(cats) do
				items[#items + 1] = { kind = "rare", key = c.key, name = c.name }
			end
		end
	end
	local sec
	for _, e in ipairs(items) do
		if e.head then
			sec = e.sec
		else
			e.sec = sec
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
					-- `why` = a stop's own line (Travel: "from Orgrimmar: out through the front gate …").
					rows[#rows + 1] = { name = e.name .. (e.tag and ("  |cff999999<" .. e.tag .. ">|r") or ""),
						info = (e.zone or "?") .. " · " .. FindDistance(e.dist), map = e.map, x = e.x, y = e.y, go = e.go,
						why = e.note }
				end
			end
		end
		sub = ns:L((it.svc and ("FCITY_SUB_" .. it.svc:upper())) or (it.goods and "FVEND_SUB_GOODS") or "FOV_FIND_SUB_TOOL")
		-- 21 Nov 2026 (Waylaid Crates): your Merchant's Favor and trade rank on top of "Deliver crates".
		if it.svc == "crates" and ns.ForeverCrateFindSub then
			local ok, extra = pcall(ns.ForeverCrateFindSub)
			if ok and type(extra) == "string" and extra ~= "" then
				sub = sub .. "  " .. extra
			end
		end
		if #rows == 0 then
			sub = sub .. "  " .. ns:L(it.svc and "FCITY_EMPTY" or "FVEND_EMPTY")
		end
		hint = ns:L(it.svc and "FCITY_HINT" or "FVEND_HINT")
	elseif it.kind == "rare" then
		if ns.ForeverRareFindRows then
			local ok, l, p = pcall(ns.ForeverRareFindRows, it.key)
			if ok and type(l) == "table" then
				posOk = p
				for _, e in ipairs(l) do
					rows[#rows + 1] = { name = e.name .. (e.tag and ("  |cff999999" .. e.tag .. "|r") or ""),
						info = (e.zone or "?") .. " · " .. FindDistance(e.dist), map = e.map, x = e.x, y = e.y,
						why = e.why, go = e.go }
				end
			end
		end
		sub = ns:L(it.key == "worth" and "FRARE_SUB" or "FRARE_SUB_ZONE")
		if #rows == 0 then
			sub = sub .. "  " .. ns:L("FRARE_EMPTY")
		end
		hint = ns:L("FRARE_HINT")
	end
	if not posOk then
		sub = sub .. "  " .. ns:L("FVEND_NOPOS")
	end
	return rows, sub, hint, act
end

local FIND_ROUTES = 8 -- the way there is worked out for the nearest few places only (ForeverTravel plans a route each)

--- The two mode buttons and the search field (20 Nov 2026, layout D step 3). Returns the search text, lower case.
local function FindModeHead(cat, city)
	cat.label:SetText(ns:L("FOV_TAB_FIND"):upper())
	cat.modeWhat:SetActive(not city)
	cat.modeCity:SetActive(city)
	local q = (cat.search:GetText() or ""):lower()
	if q == "" and not cat.search:HasFocus() then
		cat.search.ph:Show()
	else
		cat.search.ph:Hide()
	end
	return q
end

--- "Which city?": left your cities and the other towns (ns.ForeverFindCities), right the chosen city's services
--- (ns.ForeverCityServiceRows) with "Route to <city>" and the way there once at the top.
local function FillCityPage(f, refresh)
	local page = f.pages.find
	local cat, list = page.cat, page.list
	local q = FindModeHead(cat, true)
	local cities = {}
	if ns.ForeverFindCities then
		local ok, c = pcall(ns.ForeverFindCities)
		cities = ok and type(c) == "table" and c or {}
	end
	ns.db = ns.db or {}
	local selKey = ns.db.foreverFindCity
	local sel
	for _, c in ipairs(cities) do
		if c.key == selKey then
			sel = c
		end
	end
	-- Nothing chosen yet: the town where your Hearthstone is set, else the first capital.
	if not sel then
		for _, c in ipairs(cities) do
			if c.hearth and not sel then
				sel = c
			end
		end
		sel = sel or cities[1]
	end
	local shown = {}
	local lastCap
	for _, c in ipairs(cities) do
		local hit = q == "" or (c.name or ""):lower():find(q, 1, true) or (c.zone or ""):lower():find(q, 1, true)
		if hit then
			if lastCap ~= c.capital then
				shown[#shown + 1] = { head = ns:L(c.capital and "FOV_FIND_CITY_YOURS" or "FOV_FIND_CITY_TOWNS") }
				lastCap = c.capital
			end
			shown[#shown + 1] = c
		end
	end
	local r, g, b = Accent()
	for i, e in ipairs(shown) do
		local btn = FindItem(cat, i)
		btn.tipLink = nil
		btn:SetScript("OnClick", nil)
		if e.head then
			btn.sel = false
			btn.t:SetText(e.head:upper())
			S.Font(btn.t, A.fonts.head2, 12, A.fallback.head2)
			btn.col = A.label
			btn.tipTitle, btn.tipBody = nil, nil
			btn.bg:SetColorTexture(0, 0, 0, 0)
		else
			btn.sel = (e == sel)
			S.Font(btn.t, A.fonts.textB, 13, A.fallback.textB)
			btn.col = A.text
			local tag = e.hearthName or (e.dist and FindDistance(e.dist)) or nil
			btn.t:SetText((e.name or "?") .. (tag and ("  |cffa89a85" .. tag .. "|r") or ""))
			btn.tipTitle, btn.tipBody = e.name, e.zone
			btn:SetScript("OnClick", function()
				ns.db.foreverFindCity = e.key
				ns.ForeverOverviewFill()
			end)
			btn.bg:SetColorTexture(r, g, b, btn.sel and 0.22 or 0)
		end
		btn.t:SetTextColor(btn.col[1], btn.col[2], btn.col[3])
		btn:Show()
	end
	for i = #shown + 1, #cat.items do
		cat.items[i]:Hide()
	end
	cat.child:SetHeight(math.max(10, #shown * FIND_ITEM_H))
	if refresh then
		cat.sf.UpdateThumb()
	elseif not f.findScrolled then
		cat.sf.Reset()
		f.findScrolled = true
	end
	if not sel then
		list.label:SetText("")
		list.head:SetText("")
		list.sub:SetText(ns:L("FCITY_EMPTY"))
		list.hint:SetText("")
		list.act:Hide()
		for i = 1, #list.rows do
			list.rows[i]:Hide()
		end
		return
	end
	local rows = {}
	if ns.ForeverCityServiceRows then
		local ok, l = pcall(ns.ForeverCityServiceRows, sel.key)
		rows = ok and type(l) == "table" and l or {}
	end
	list.label:SetText((sel.name or ""):upper())
	list.head:SetText(sel.zone and (sel.name .. " · " .. sel.zone) or sel.name)
	-- The way there, once for the whole city (ForeverTravel.lua: Hearthstone / teleports / boats + "(about N min)").
	local sub
	if ns.ForeverTravelSentence then
		local ok, s, walk = pcall(ns.ForeverTravelSentence, sel.map, sel.x, sel.y)
		if ok and type(s) == "string" and s ~= "" then
			sub = "|cff71d5ff" .. ns:L("FWEAP_ROUTE_LABEL") .. " " .. s .. "|r"
		elseif ok and walk then
			sub = ns:L(sel.dist and sel.dist < 250 and "FOV_FIND_CITY_HERE" or "FOV_FIND_CITY_WALK")
		end
	end
	list.sub:SetText(sub or "")
	list.hint:SetText(ns:L("FOV_FIND_CITY_HINT"))
	local label = ns:L("FOV_FIND_CITY_ROUTE_FMT"):format(sel.name or "?")
	list.act:SetLabel(label)
	list.act.tipTitle, list.act.tipBody = label, ns:L("FOV_TIP_FIND_CITY_ROUTE")
	list.act:SetScript("OnClick", function()
		if ns.ForeverCityGo then
			ns.ForeverCityGo(sel.key)
		end
	end)
	list.act:Show()
	local y = 0
	for i, e in ipairs(rows) do
		local row = FindRow(list, i)
		row:ClearAllPoints()
		row:SetPoint("TOPLEFT", list.child, "TOPLEFT", 0, -y)
		row.name:SetText(e.name)
		row.info:SetText(e.info or "")
		row.hover.tipTitle = e.name
		row.hover.tipBody = e.info
		if e.why and e.why ~= "" then
			row.route:SetText(e.why)
			row.route:Show()
		else
			row.route:SetText("")
			row.route:Hide()
		end
		local h = 44 + (row.route:IsShown() and ((row.route:GetStringHeight() or 12) + 4) or 0)
		row:SetHeight(h)
		row:SetAlpha(1)
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

local function FillFindPage(f, refresh)
	local page = f.pages.find
	local cat, list = page.cat, page.list
	if type(ns.db) == "table" and ns.db.foreverFindMode == "city" then
		FillCityPage(f, refresh)
		return
	end
	local q = FindModeHead(cat, false)
	local items, dirText = FindCatalog()
	local it = PickFind(f, items, (f.find and f.find.kind) or "class", f.find and f.find.key)
	f.find = it and { kind = it.kind, key = it.key } or nil
	-- Collapsible headings (18 Nov 2026, Rob: "ja"). ns.db.foreverFindOpen[sec] = true/false once you clicked it;
	-- not clicked yet: only the heading of what you have selected is open. Whatever gets selected from outside (the
	-- search bar, "Show the way", a button elsewhere) opens its own heading, so a hit is never hidden.
	ns.db = ns.db or {}
	ns.db.foreverFindOpen = type(ns.db.foreverFindOpen) == "table" and ns.db.foreverFindOpen or {}
	local open = ns.db.foreverFindOpen
	local selKey = it and (tostring(it.kind) .. ":" .. tostring(it.key)) or nil
	if it and it.sec and selKey ~= f._findSelKey then
		open[it.sec] = true
	end
	f._findSelKey = selKey
	local function IsOpen(sec)
		if open[sec] ~= nil then
			return open[sec] == true
		end
		return it ~= nil and it.sec == sec
	end
	local shown, hiddenIn = {}, {}
	if q ~= "" then
		-- Searching: every hit, under its own heading, whether that heading is open or not.
		local hitIn = {}
		for _, e in ipairs(items) do
			if not e.head and (e.name or ""):lower():find(q, 1, true) then
				hitIn[e.sec] = true
			end
		end
		for _, e in ipairs(items) do
			if (e.head and hitIn[e.sec]) or (not e.head and (e.name or ""):lower():find(q, 1, true)) then
				shown[#shown + 1] = e
			end
		end
		IsOpen = function()
			return true
		end
	end
	for _, e in ipairs(q ~= "" and {} or items) do
		if e.head or IsOpen(e.sec) then
			shown[#shown + 1] = e
		else
			hiddenIn[e.sec] = (hiddenIn[e.sec] or 0) + 1
		end
	end
	-- Left: the catalogue.
	local r, g, b = Accent()
	for i, e in ipairs(shown) do
		local btn = FindItem(cat, i)
		btn.sel = (it ~= nil and e == it)
		btn.tipTitle, btn.tipBody = nil, nil
		btn.tipLink = (e.kind == "shop" and e.item and ("item:" .. e.item))
			or (e.kind == "weapon" and type(e.key) == "number" and ("spell:" .. e.key)) or nil
		if e.head then
			local isOpen = IsOpen(e.sec)
			-- Blizzard's own plus/minus textures (present in every client) rather than a glyph the font may lack.
			local icon = isOpen and "|TInterface\\Buttons\\UI-MinusButton-Up:14:14:0:0|t "
				or "|TInterface\\Buttons\\UI-PlusButton-Up:14:14:0:0|t "
			local n = hiddenIn[e.sec]
			btn.t:SetText(icon .. e.head:upper() .. ((not isOpen and n) and ("  |cff8a7d6b(" .. n .. ")|r") or ""))
			S.Font(btn.t, A.fonts.head2, 12, A.fallback.head2)
			btn.col = A.label
			btn.tipTitle, btn.tipBody = e.head, ns:L(isOpen and "FOV_FIND_TIP_CLOSE" or "FOV_FIND_TIP_OPEN")
			btn:SetScript("OnClick", function()
				open[e.sec] = not isOpen
				ns.ForeverOverviewFill(true)
			end)
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
	for i = #shown + 1, #cat.items do
		cat.items[i]:Hide()
	end
	cat.child:SetHeight(math.max(10, #shown * FIND_ITEM_H))
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
		-- A rare's line is WHY it is worth the trip (ForeverRares.lua), shown where the way there would be.
		if e.why then
			route = false
			row.route:SetText(e.why)
			row.route:Show()
		elseif route == nil and i <= FIND_ROUTES and e.map and e.x and e.y and ns.ForeverTravelSentence then
			local ok, s = pcall(ns.ForeverTravelSentence, e.map, e.x, e.y)
			route = ok and s or nil
		end
		if e.why then
			-- already set above
		elseif type(route) == "string" and route ~= "" then
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
			row.copy:Hide()
			row.chip:Hide()
		else
			-- The chip (19 Nov 2026): Made / Ready / Level N / Trainer, the colours the other chips use.
			local r, g, b = Accent()
			local ct, col, ctip
			if v.made then
				ct, col, ctip = ns:L("FMAC_CHIP_MADE"), A.done, ns:L("FMAC_TIP_CHIP_MADE")
			elseif v.canMake then
				ct, col, ctip = ns:L("FMAC_CHIP_READY"), { r, g, b }, ns:L("FMAC_TIP_CHIP_READY")
			elseif v.why == "FMAC_WHY_LEVEL_FMT" and tonumber(v.whyArg) then
				ct, col, ctip = ns:L("FMAC_CHIP_LEVEL_FMT"):format(tonumber(v.whyArg)), A.later, ns:L("FMAC_TIP_CHIP_LATER")
			elseif v.why == "FMAC_WHY_TRAIN" then
				ct, col, ctip = ns:L("FMAC_CHIP_TRAIN"), A.later, ns:L("FMAC_TIP_CHIP_LATER")
			end
			if ct then
				row.chip.t:SetText(ct)
				row.chip:SetColor(col[1], col[2], col[3])
				row.chip.tipTitle, row.chip.tipBody = ct, ctip
				row.chip:Show()
			else
				row.chip:Hide()
			end
			-- Copy: only when there is a text to copy.
			row.copy:ClearAllPoints()
			row.copy:SetPoint("TOP", v.free and row.free or row.go, "BOTTOM", 0, -4)
			if v.body and ns.ShowShareCopyDialog then
				local body, key = v.body, v.key
				row.copy:SetScript("OnClick", function()
					ns.ShowShareCopyDialog({ id = "fmac:" .. tostring(key), text = body, titleKey = "FMAC_COPY_TITLE" })
				end)
				row.copy:Show()
			else
				row.copy:Hide()
			end
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
		-- Room for the buttons on the right: Make (22), Free key (+24), Copy (+24).
		local btns = 34 + (v.free and 26 or 0) + ((not v.header and v.body) and 26 or 0)
		h = math.max(h, btns)
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
	-- 19 Nov 2026 (Rob: "En dat comprehensive kaartje"): a mage gets Comprehension, the mage-only scroll skill
	-- (SkillLine 3012), as the last row. GetProfessions does not list class skills, so its card says whether you know
	-- Comprehend Scroll instead of a skill bar (ForeverProfGuide.lua CompCard).
	local isMage = select(2, UnitClass("player")) == "MAGE"
	if isMage and ns.ForeverCompName then
		order[#order + 1] = { "COMPREHENSION", 3012, ns.ForeverCompName() }
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
	-- Row step: 24 px, smaller when all rows would not fit in the card (never under 18).
	local step = PROF_ROW_H
	local h = left:GetHeight()
	if h and h > 0 and #order > 0 then
		step = math.max(18, math.min(PROF_ROW_H, math.floor((h - 40) / #order)))
	end
	for i, row in ipairs(left.rows) do
		local p = order[i]
		row:ClearAllPoints()
		row:SetPoint("TOPLEFT", 10, -32 - (i - 1) * step)
		row:SetPoint("RIGHT", -10, 0)
		row:SetHeight(step - 2)
		if p then
			local m = mine[p[1]]
			row.t:SetText((p[1] == "COMPREHENSION" and p[3]) or (ns.ForeverProfName and ns.ForeverProfName(p[1], mine)) or p[3])
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
	local comp = sel == "COMPREHENSION"
	local name = comp and (ns.ForeverCompName and ns.ForeverCompName() or "Comprehension")
		or (ns.ForeverProfName and ns.ForeverProfName(sel, mine) or sel)
	card.label:SetText(name:upper())
	card.trainers:SetScript("OnClick", function()
		-- Comprehend Scroll is taught by your CLASS trainer: the class row of Find.
		if comp then
			ns.ShowForeverFind("class")
		else
			ns.ShowForeverFind("prof", sel)
		end
	end)
	-- Your skill and its bar; a profession you do not have says so.
	if comp then
		-- No skill bar: the client does not give a class skill through GetProfessions. The card says it instead.
		card.skill:SetText(ns:L(ns.ForeverKnowsComprehend and ns.ForeverKnowsComprehend() and "FPROFG_COMP_SKILL_KNOWN"
			or "FPROFG_COMP_SKILL_NOT"))
		card.barBg:Hide()
		card.barFill:Hide()
	elseif m and m.rank and m.maxRank and m.maxRank > 0 then
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
	-- Skill up (20 Nov 2026): the next step on top of the card, and the button, for a crafting profession you have.
	local skillLine
	if not comp and ns.ForeverSkillupSummary then
		local ok, s = pcall(ns.ForeverSkillupSummary, sel)
		skillLine = ok and s or nil
	end
	local canSkill = not comp and m ~= nil and ns.ShowForeverSkillup ~= nil and ns.REAGENT_LINES ~= nil
		and ns.REAGENT_LINES[sel] ~= nil
	if canSkill then
		card.skillup:SetScript("OnClick", function()
			ns.ShowForeverSkillup(sel)
		end)
		card.skillup:Show()
	else
		card.skillup:Hide()
	end
	if skillLine then
		text = "|cff66ccff" .. skillLine .. "|r\n\n" .. (text or "")
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
		local hasGuide = ns.ForeverDungeonHasGuide and ns.ForeverDungeonHasGuide(d.instance)
		if hasGuide then
			local inst = d.instance
			row.boss:SetScript("OnClick", function()
				if ns.ShowForeverDungeonGuide then
					ns.ShowForeverDungeonGuide(inst)
				end
			end)
			row.boss:Show()
			h = math.max(h, 52)
		else
			row.boss:Hide()
		end
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

local function FillRepPage(f, refresh)
	local card = f.pages.rep.card
	local function c(hex, s)
		return "|c" .. hex .. tostring(s or "") .. "|r"
	end
	local GOLD, DIM, LAB, TXT = "ffdbb56b", "ffa89a85", "ffed8c38", "ffebe0cc"
	local lines = {}
	-- Currencies.
	lines[#lines + 1] = c(LAB, ns:L("FREP_HEAD_CUR"))
	local okC, cur = false, nil
	if ns.ForeverCurrencyViews then
		okC, cur = pcall(ns.ForeverCurrencyViews)
	end
	for _, e in ipairs(okC and type(cur) == "table" and cur or {}) do
		if e.unreadable then
			lines[#lines + 1] = c(DIM, ns:L("FREP_CUR_UNREAD_FMT"):format(e.id))
		elseif e.max then
			lines[#lines + 1] = c(TXT, ("%s: %d / %d"):format(e.name, e.qty, e.max))
		else
			lines[#lines + 1] = c(TXT, ("%s: %d"):format(e.name, e.qty))
		end
	end
	if not okC then
		lines[#lines + 1] = c(DIM, ns:L("FOV_ST_UNREADABLE"))
	end
	-- Groups.
	lines[#lines + 1] = " "
	lines[#lines + 1] = c(LAB, ns:L("FREP_HEAD_GROUPS"))
	local okR, groups, unread, others = false, nil, nil, nil
	if ns.ForeverRepViews then
		okR, groups, unread, others = pcall(ns.ForeverRepViews)
	end
	if not okR or type(groups) ~= "table" then
		lines[#lines + 1] = c(DIM, ns:L("FOV_ST_UNREADABLE"))
		groups, unread, others = {}, {}, {}
	end
	for _, g in ipairs(groups) do
		local prog = (g.have and g.need) and ("  %d / %d"):format(g.have, g.need) or ""
		lines[#lines + 1] = c(GOLD, g.name) .. "  " .. c(TXT, (g.rank or "?") .. prog)
		if g.next then
			lines[#lines + 1] = "   " .. c(TXT, ns:L("FREP_NEXT_FMT"):format(g.nextRank or "?", g.next))
				.. (g.measured and "" or (" " .. c(DIM, ns:L("FREP_GUIDE_TAG"))))
		else
			lines[#lines + 1] = "   " .. c(DIM, ns:L("FREP_NEXT_NONE"))
		end
		lines[#lines + 1] = "   " .. c(DIM, ns:L("FREP_HOW_FMT"):format(g.how or ""))
	end
	if type(unread) == "table" and #unread > 0 then
		lines[#lines + 1] = c(DIM, ns:L("FREP_UNREAD_FMT"):format(#unread))
	end
	-- The rest of the character's own reputation list.
	if type(others) == "table" and #others > 0 then
		lines[#lines + 1] = " "
		lines[#lines + 1] = c(LAB, ns:L("FREP_HEAD_OTHERS"))
		for _, o in ipairs(others) do
			lines[#lines + 1] = c(TXT, o.name) .. "  " .. c(DIM, o.rank or "?")
		end
	end
	lines[#lines + 1] = " "
	lines[#lines + 1] = c(DIM, ns:L("FREP_NOTE"))
	card.text:SetText(table.concat(lines, "\n"))
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
		local y0 = y
		if it.head then
			it.head:ClearAllPoints()
			it.head:SetPoint("TOPLEFT", card.child, "TOPLEFT", 4, -(y + 6))
			y = y + 28
		elseif it.action then
			it.text:ClearAllPoints()
			it.text:SetPoint("TOPLEFT", card.child, "TOPLEFT", 4, -y)
			it.btn:ClearAllPoints()
			it.btn:SetPoint("TOPRIGHT", card.child, "TOPRIGHT", -6, -y)
			it.desc:ClearAllPoints()
			it.desc:SetPoint("TOPLEFT", it.text, "BOTTOMLEFT", 0, -2)
			y = y + math.max(26, (it.text:GetStringHeight() or 16) + 4 + (it.desc:GetStringHeight() or 14) + 10)
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
		-- Where this row sits in the list: the search jumps here (FocusQuietRow).
		it._y, it._h = y0, y - y0
	end
	card.child:SetHeight(math.max(10, y))
	if refresh then
		card.sf.UpdateThumb()
	else
		card.sf.Reset()
	end
end

--- 21 Nov 2026 (Rob via sparring: a search hit on a switch opened the long list, "Dan moet ik eerst gaan scrollen naar
--- beneden en kijken waar staat hij ook weer"): open Quiet helpers, scroll row `i` of QUIET into view and let it light
--- up for two seconds. Next frame: the page is filled (and its scroll range known) only after Show.
local FLASH_TIME = 2
local function FlashQuietRow(card, it)
	if not card.flash then
		card.flash = card.child:CreateTexture(nil, "BACKGROUND")
		card.flash:SetColorTexture(A.gold[1], A.gold[2], A.gold[3], 1)
		card.flashEdge = card.child:CreateTexture(nil, "BORDER")
		card.flashEdge:SetColorTexture(A.gold[1], A.gold[2], A.gold[3], 1)
		card.flashEdge:SetWidth(3)
		card.flashTimer = CreateFrame("Frame", nil, card)
		card.flashTimer:Hide()
		card.flashTimer:SetScript("OnUpdate", function(self, elapsed)
			self.left = (self.left or 0) - (elapsed or 0)
			if self.left <= 0 then
				card.flash:Hide()
				card.flashEdge:Hide()
				self:Hide()
				return
			end
			local a = math.min(1, self.left / 0.8) -- full for the first 1.2 s, then fades out
			card.flash:SetAlpha(0.22 * a)
			card.flashEdge:SetAlpha(0.9 * a)
		end)
	end
	for _, t in ipairs({ card.flash, card.flashEdge }) do
		t:ClearAllPoints()
		t:SetPoint("TOPLEFT", card.child, "TOPLEFT", 0, -(it._y - 2))
		t:SetHeight(math.max(20, (it._h or 30) - 4))
	end
	card.flash:SetPoint("RIGHT", card.child, "RIGHT", 0, 0)
	card.flash:SetAlpha(0.22)
	card.flashEdge:SetAlpha(0.9)
	card.flash:Show()
	card.flashEdge:Show()
	card.flashTimer.left = FLASH_TIME
	card.flashTimer:Show()
end

local function FocusQuietRow(i)
	ns.ShowForeverOverviewPage("quiet")
	local tries = 0
	local function go()
		local f = Build()
		local card = f.pages.quiet and f.pages.quiet.card
		local it = card and card.items[i]
		if not (it and it._y and f.page == "quiet") then
			return
		end
		local sf = card.sf
		local max = sf:GetVerticalScrollRange() or 0
		local view = sf:GetHeight() or 0
		-- The scroll range can still read 0 one frame after Show: look once more a moment later.
		if max < 1 and it._y > view / 3 and tries < 1 and C_Timer and C_Timer.After then
			tries = tries + 1
			C_Timer.After(0.05, go)
			return
		end
		-- The row a third from the top, so the heading above it shows too.
		sf:SetVerticalScroll(math.min(max, math.max(0, it._y - math.floor(view / 3))))
		sf.UpdateThumb()
		FlashQuietRow(card, it)
	end
	if C_Timer and C_Timer.After then
		C_Timer.After(0, go)
	else
		go()
	end
end

local function FillToolsPage(f, refresh)
	local card = f.pages.tools.card
	local list = {}
	if ns.ToolsLaunchpadVisible then
		local ok, l = pcall(ns.ToolsLaunchpadVisible, TOOLS_ON_TABS)
		list = ok and type(l) == "table" and l or {}
	end
	for _, t in ipairs(TOOL_EXTRAS) do
		list[#list + 1] = t
	end
	local y = 0
	for i, t in ipairs(list) do
		local r = ToolRow(card, i)
		r:ClearAllPoints()
		r:SetPoint("TOPLEFT", card.child, "TOPLEFT", 0, -y)
		r.icon:SetTexture(t.icon or 134400)
		r.name:SetText(ns:L(t.nameKey))
		r.desc:SetText(ns:L(t.descKey))
		r.slash:SetText(t.slash or "")
		r.go:SetScript("OnClick", function()
			if t.open then
				t.open()
			end
		end)
		local h = math.max(40, 8 + (r.name:GetStringHeight() or 16) + 2 + (r.desc:GetStringHeight() or 14) + 2
			+ (r.slash:GetStringHeight() or 12) + 6)
		r:SetHeight(h)
		r:Show()
		y = y + h + 4
	end
	for i = #list + 1, #card.rows do
		card.rows[i]:Hide()
	end
	card.child:SetHeight(math.max(10, y))
	if refresh then
		card.sf.UpdateThumb()
	else
		card.sf.Reset()
	end
end

local function FillCmdsPage(f, refresh)
	local card = f.pages.cmds.card
	local q = (card.search:GetText() or ""):lower()
	local rows = {}
	for _, grp in ipairs(ns.MH_COMMANDS or {}) do
		local items = {}
		for _, it in ipairs(grp.items or {}) do
			local shown = not ns.CommandItemShown or ns.CommandItemShown(it)
			local desc = it.descKey and ns:L(it.descKey) or ""
			if shown and (q == "" or (it.cmd or ""):lower():find(q, 1, true) or desc:lower():find(q, 1, true)) then
				items[#items + 1] = { cmd = it.cmd, desc = desc }
			end
		end
		if #items > 0 then
			rows[#rows + 1] = { head = grp.headKey and ns:L(grp.headKey) or "" }
			for _, it in ipairs(items) do
				rows[#rows + 1] = it
			end
		end
	end
	local y = 0
	for i, it in ipairs(rows) do
		local r = CmdRow(card, i)
		r:ClearAllPoints()
		r:SetPoint("TOPLEFT", card.child, "TOPLEFT", 0, -y)
		local h
		if it.head then
			r.head:SetText(it.head:upper())
			r.head:Show()
			r.cmd:Hide()
			r.desc:Hide()
			h = 26
		else
			r.head:Hide()
			r.cmd:SetText(it.cmd)
			r.desc:SetText(it.desc)
			r.cmd:Show()
			r.desc:Show()
			h = math.max(18, (r.desc:GetStringHeight() or 14) + 6)
		end
		r:SetHeight(h)
		r:Show()
		y = y + h
	end
	for i = #rows + 1, #card.rows do
		card.rows[i]:Hide()
	end
	card.child:SetHeight(math.max(10, y))
	if refresh then
		card.sf.UpdateThumb()
	else
		card.sf.Reset()
	end
end

function ns.HideForeverOverview()
	if win then
		win:Hide()
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
		-- A button elsewhere asks for one thing: show it in "What am I looking for?" (20 Nov 2026, layout D step 3).
		if type(ns.db) == "table" then
			ns.db.foreverFindMode = nil
		end
		local items = FindCatalog()
		local it = PickFind(f, items, kind, key)
		f.find = it and { kind = it.kind, key = it.key } or f.find
	end
	ns.ShowForeverOverviewPage("find")
end

--------------------------------------------------------------------------------
-- Search (18 Nov 2026, step 1 of the search plan: docs/forever/ZOEKBALK_EN_VALUTA_2026-11-18.md). Everything the
-- overview can show, as rows for NavSearch.lua's matcher: tabs and pages, every Find item (class trainer,
-- professions, weapon skills, shops, In town), class quests, dungeons, macros, quiet helpers, tools and /mh commands.
-- A hit opens the tab or page where that thing is. Step 2 adds the places themselves with "Show the way".
--------------------------------------------------------------------------------
local searchCache, searchAt = nil, -100
-- The short words players type for the In town items (Rob's test, 18 Nov 2026, via sparring: "Wat ik wel niet kon is
-- zoeken op AH, een logische afkorting voor de [auction] house"). Same words as Midnight's Silvermoon pins
-- (NavSearch.lua SMC_WORDS). Only for things in the list (flight masters since 18 Nov 2026, so "fp" is here now).
local CITY_WORDS = {
	auction = "ah auction auctioneer auctionhouse",
	bank = "bank banker vault",
	mail = "mail mailbox post letter",
	inn = "inn innkeeper hearth hearthstone rest",
	-- 18 Nov 2026 (travel): the words players type for a crossing or a flight.
	transport = "travel zeppelin zep boat ship ferry tram portal skycutter dock tower",
	flight = "travel flight master fp taxi gryphon wind rider hippogryph bat fly",
	-- 21 Nov 2026 (Waylaid Crates).
	crates = "crate crates waylaid sealed shipping label favor merchant deliver trade",
}
local SEARCH_TTL = 15 -- seconds: NavSearch asks on every keystroke; the lists change only with level, bags or a zone

local function SearchRows()
	local now = GetTime and GetTime() or 0
	if searchCache and now - searchAt < SEARCH_TTL then
		return searchCache
	end
	local rows = {}
	-- label, keys, go, tier ("action"/"nav"/"content"), context, cat, order (places: rank by distance)
	local function row(label, keys, go, tier, context, cat, order)
		if type(label) == "string" and label ~= "" and go then
			rows[#rows + 1] = { label, keys, go, tier, context, cat, order }
		end
	end
	local function page(p)
		return function()
			ns.ShowForeverOverviewPage(p)
		end
	end
	local tabWord = ns:L("FOV_SEARCH_CTX_TAB")

	-- Tabs and the pages inside them (Your class, Characters, the gear).
	local groupLabel = { gear = ns:L("FOV_LABEL_QUIET") }
	for _, t in ipairs(TABS) do
		local label = ns:L(t.key)
		if t.group then
			groupLabel[t.group] = label
		end
		local first = t.page or (t.group and GROUPS[t.group][1].page)
		row(label, "tab page " .. ns:L(t.tip), first and page(first), "nav", tabWord, "tab")
	end
	for g, list in pairs(GROUPS) do
		for _, p in ipairs(list) do
			row(ns:L(p.key), "tab page " .. ns:L(p.tip), page(p.page), "nav", groupLabel[g], "tab")
		end
	end
	row(ns:L("FOV_FIND_TEACHES"), "trainer train learn spells teaches cost", page("trainer"), "nav",
		ns:L("FOV_FIND_SEC_CLASS"), "tab")

	-- Find: every item of the left list, and (step 2) every place of it with its own "Show the way".
	local ok, items, dirText = pcall(FindCatalog)
	local wayWord = ns:L("FCQ_BTN")
	local head
	for _, it in ipairs(ok and type(items) == "table" and items or {}) do
		if it.head then
			head = it.head
		elseif it.kind then
			local kind, key = it.kind, it.key
			-- `goods` is a flag (true) on some shops, not a word: only strings go into the keywords (offline test, 18 Nov).
			local function w(v)
				return type(v) == "string" and v or ""
			end
			local keys = "find where " .. w(it.english) .. " " .. w(it.goods) .. " " .. w(it.svc) .. " " .. w(it.key)
				.. " " .. (it.svc and CITY_WORDS[it.svc] or "")
			if kind == "class" then
				keys = keys .. " class trainer train spells learn"
			elseif kind == "prof" then
				keys = keys .. " profession trainer"
			elseif kind == "weapon" then
				keys = keys .. " weapon skill master"
			end
			local function openItem()
				local f = Build()
				f.find = { kind = kind, key = key }
				ns.ShowForeverOverviewPage("find")
			end
			row(it.name, keys, openItem, "nav", head, "find")
			-- Step 2 (18 Nov 2026): the places themselves. A hit opens Find on that item (so you see the list and the
			-- way there) and sets the arrow, as the row's "Show the way" button does. Content tier: typing "mining" shows
			-- the Mining item before thirty trainers.
			local okP, places = pcall(FindPlaces, it, dirText)
			-- FindPlaces lists nearest first; that rank goes along, so "bank" shows the nearest banker first.
			-- Rares (18 Nov 2026): their own kind for "@rare", and the "why" line is searchable ("pet", "recipe" …).
			local isRare = kind == "rare"
			for rank, p in ipairs(okP and type(places) == "table" and places or {}) do
				if p.go and type(p.name) == "string" then
					local go = p.go
					local extra = isRare and (" rare elite " .. (type(p.why) == "string" and p.why or "")) or ""
					row(p.name, keys .. " " .. (it.name or "") .. " way route arrow place" .. extra, function()
						openItem()
						go()
					end, "content", (it.name or "") .. " · " .. (p.info or "") .. " · " .. wayWord,
						isRare and "rare" or "place", rank)
				end
			end
		end
	end

	-- Class quests (your class only, as the page shows them).
	if ns.ForeverClassQuestList then
		local okQ, list = pcall(ns.ForeverClassQuestList)
		for _, e in ipairs(okQ and type(list) == "table" and list or {}) do
			local ctx = ns:L("FOV_TAB_CQ") .. (e.level and (" · " .. ns:L("FOV_LEVEL_FMT"):format(e.level)) or "")
			row(e.chain, "class quest " .. (e.npc or "") .. " " .. (e.zone or ""), page("cq"), "content", ctx, "quest")
			-- Step 2: the next step's place, with the arrow (the page's own "Show the way").
			if e.go and e.zone and e.state ~= "done" then -- the page's own rule (FillClassQuestPage)
				local go = e.go
				row(e.chain, "class quest way route arrow place " .. (e.npc or "") .. " " .. (e.zone or ""), function()
					ns.ShowForeverOverviewPage("cq")
					go()
				end, "content", ((e.npc and (e.npc .. ", ") or "") .. (e.zone or "")) .. " · " .. wayWord, "quest")
			end
		end
	end

	-- Dungeons.
	if ns.ForeverDungeonList then
		local okD, list = pcall(ns.ForeverDungeonList)
		for _, d in ipairs(okD and type(list) == "table" and list or {}) do
			local lv = (d.min and d.max) and (" · %d-%d"):format(d.min, d.max) or ""
			row(d.name, "dungeon instance group", page("dungeons"), "content", (d.zone or "") .. lv, "dungeon")
			-- Step 2: the entrance, with the arrow - not for a dungeon only the other side can reach (the page shows no
			-- Way button there either).
			if d.go and not d.sideLocked then
				local go = d.go
				row(d.name, "dungeon instance entrance way route arrow place", function()
					ns.ShowForeverOverviewPage("dungeons")
					go()
				end, "content", (d.zone or "") .. lv .. " · " .. wayWord, "dungeon")
			end
		end
	end

	-- Macros (Keys & macros).
	if ns.ForeverMacroViews then
		local okM, list = pcall(ns.ForeverMacroViews)
		for _, m in ipairs(okM and type(list) == "table" and list or {}) do
			if not m.header then
				row(m.title, "macro key " .. (m.info or ""), page("keys"), "content", ns:L("FOV_TAB_KEYS"), "macro")
			end
		end
	end

	-- Reputations and currencies (18 Nov 2026): each group and coin by the client's own name → the rep page.
	local repLabel = ns:L("FOV_SUB_REP")
	if ns.ForeverRepViews then
		local okG, groups, _, others = pcall(ns.ForeverRepViews)
		if okG then
			for _, list in ipairs({ groups or {}, others or {} }) do
				for _, g in ipairs(list) do
					row(g.name, "reputation rep faction standing " .. (g.rank or ""), page("rep"), "content",
						repLabel .. " · " .. (g.rank or ""), "rep")
				end
			end
		end
	end
	if ns.ForeverCurrencyViews then
		local okC, cur = pcall(ns.ForeverCurrencyViews)
		for _, e in ipairs(okC and type(cur) == "table" and cur or {}) do
			if e.name then
				row(e.name, "currency coin money points", page("rep"), "content", repLabel, "currency")
			end
		end
	end

	-- Quiet helpers (the gear): every switch by its own name.
	for i, q in ipairs(QUIET) do
		if q.action then
			-- A door (the rank choice window): the search opens the window itself. Its search words hold the client's
			-- rank word and "rank" in every language (FRANK_CHOOSE_KEYS).
			row(ns:L(q.title), "setting window open " .. (q.keys and ns:L(q.keys) or "") .. " " .. ns:L(q.tip), q.fn,
				"nav", ns:L("FOV_SUB_QUIET"), "setting")
		elseif q.title then
			-- 21 Nov 2026: a hit scrolls to the switch itself and lights it up (FocusQuietRow).
			row(ns:L(q.title), "setting switch on off " .. (q.words or "") .. " " .. (q.tip and ns:L(q.tip) or ""),
				function()
					FocusQuietRow(i)
				end, "nav", ns:L("FOV_SUB_QUIET"), "setting")
		end
	end

	-- Tools (the gear → Tools): the same list as that page.
	local tools = {}
	if ns.ToolsLaunchpadVisible then
		local okT, l = pcall(ns.ToolsLaunchpadVisible, TOOLS_ON_TABS)
		tools = okT and type(l) == "table" and l or {}
	end
	for _, t in ipairs(TOOL_EXTRAS) do
		tools[#tools + 1] = t
	end
	for _, t in ipairs(tools) do
		if t.nameKey and t.open then
			row(ns:L(t.nameKey), "tool window " .. (t.descKey and ns:L(t.descKey) or "") .. " " .. (t.slash or ""),
				t.open, "nav", ns:L("FOV_SUB_TOOLS"), "tool")
		end
	end

	-- /mh commands (the same "is it for this player" rule as the Commands page).
	for _, group in ipairs(ns.MH_COMMANDS or {}) do
		for _, item in ipairs(group.items or {}) do
			local cmd = item.cmd
			if type(cmd) == "string" and cmd ~= "" and (not ns.CommandItemShown or ns.CommandItemShown(item)) then
				local sub = cmd:match("^/mh%s+(.+)$") or ""
				row(item.descKey and ns:L(item.descKey) or cmd, "command slash " .. cmd, function()
					if SlashCmdList and SlashCmdList["MIDNIGHTHELPER"] then
						SlashCmdList["MIDNIGHTHELPER"](sub)
					end
				end, "content", cmd, "command")
			end
		end
	end

	searchCache, searchAt = rows, now
	return rows
end

--- NavSearch.lua calls this in Forever with its own `add` (label, keys, go, tier, context, cat) and the tier values.
function ns.ForeverSearchIndex(add, tiers)
	for _, r in ipairs(SearchRows()) do
		add(r[1], r[2], r[3], tiers[r[4]] or tiers.nav, r[5], r[6], r[7])
	end
end

--- Forget the cached list (offline test; a level-up or a new profession changes it).
function ns.ForeverSearchReset()
	searchCache = nil
end

--- When the direction changes (ForeverHowToPlay.lua calls this): refill if the overview is open.
function ns.ForeverOverviewRefresh()
	if win and win:IsShown() then
		ns.ForeverOverviewFill()
	end
end

--- Layout D: the tab column on the right. Each tab in order; the open group's sub-tabs indented under its tab; the gear
--- group (Quiet helpers, Tools, Commands) at the bottom of the column while it is open. The centred page name says
--- where you are (the sub-tab's name inside a group).
local function RelayoutTabs(f, group)
	local x = W - 16 - VTAB_W
	local y = TOP_Y
	local name
	local function place(b, inset, h, step)
		b:ClearAllPoints()
		b:SetPoint("TOPLEFT", f, "TOPLEFT", x + inset, y)
		b:Show()
		y = y - step
		return b
	end
	for _, b in ipairs(f.tabs) do
		place(b, 0, VTAB_H, VTAB_STEP)
		local active = b.page == f.page or (b.group ~= nil and b.group == group)
		b:SetActive(active)
		if active then
			name = ns:L(b.labelKey)
		end
		local row = b.group and f.subRows[b.group]
		for _, sb in ipairs(row and row.btns or {}) do
			if b.group == group then
				place(sb, VSUB_IN, VSUB_H, VSUB_STEP)
				sb:SetActive(sb.page == f.page)
				if sb.page == f.page then
					name = ns:L(sb.labelKey)
				end
			else
				sb:Hide()
			end
		end
	end
	local gearRow = f.subRows.gear
	for _, sb in ipairs(gearRow and gearRow.btns or {}) do
		if group == "gear" then
			place(sb, VSUB_IN, VSUB_H, VSUB_STEP)
			sb:SetActive(sb.page == f.page)
			if sb.page == f.page then
				name = ns:L(sb.labelKey)
			end
		else
			sb:Hide()
		end
	end
	if f.pageName then
		f.pageName:SetText(name and name:upper() or "")
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
	if NEW_LAYOUT then
		RelayoutTabs(f, group)
		for _, row in pairs(f.subRows) do
			row:Hide() -- its buttons live in the column now
		end
	else
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
	end
	f.gear:SetActive(group == "gear")
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
	elseif f.page == "rep" then
		FillRepPage(f, refresh)
		return f
	elseif f.page == "quiet" then
		FillQuietPage(f, refresh)
		return f
	elseif f.page == "tools" then
		FillToolsPage(f, refresh)
		return f
	elseif f.page == "cmds" then
		FillCmdsPage(f, refresh)
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
			if row.hover then
				row.hover.tipSpell = e.id
			end
			row.name:SetText(e.name)
			-- A name with the game's tooltip looks like a link (S.LINK, 19 Nov 2026).
			local lc = S.LINK or A.text
			row.name:SetTextColor(lc[1], lc[2], lc[3])
			row.level:SetText(ns:L("FOV_LEVEL_FMT"):format(e.l) .. (e.rank and (" · " .. e.rank) or ""))
		else
			row.icon:Hide()
			row.icon.tipSpell = nil
			if row.hover then
				row.hover.tipSpell = nil
			end
			row.name:SetText(i == 1 and ns:L("FOV_SOON_NONE") or "")
			row.name:SetTextColor(A.text[1], A.text[2], A.text[3])
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
