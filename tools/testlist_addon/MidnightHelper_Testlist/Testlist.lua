--[[
	MH Testlist — Rob's test list for Midnight Helper, inside the game. NOT part of Midnight Helper: this folder lives in
	the repo under tools/ (never in the release zip, .pkgmeta ignores tools/) and tools/testlist_ingame.py copies it to
	the retail and Forever AddOns folders.

	Rob, 20 Nov 2026 (via sparring), verbatim: "Kunnen wij niet een soort zijstapje maken in onze add-on die alleen voor
	mij is? Die dus niet mee gepusht wordt naar de users. Waarbij we het afvinklijstje als één mooi opdrachtenlijst kunnen
	krijgen met een leuke layout in World of Warcraft zelf. Waarbij ik daar vinkjes kan zetten. Waarbij ik eventueel
	opmerkingen kan toevoegen. Waarbij eventueel commando's die ik moet gebruiken daar alvast te kopiëren zijn. … En dat
	ik aan het einde reload kan doen. Dat jij hem kan uitlezen …"

	/mhtest opens and closes the window. Per point: Goed / Fout / Overslaan, a note, and a button per command that puts
	it in your chat line (WoW has no clipboard for addons). Everything is saved in MHTestlistDB; after a /reload
	`run testlist_ingame read` reads it back into docs/TESTLIJST.md (Goed = ticked, Fout = stays open with the note).
	Shift + mouse wheel resizes the window; Escape closes it; drag the title to move it.
]]

local ADDON = ...
local DATA = MHTL_DATA or { sections = {}, built = "?" }
local db

local W, H, LEFT_W = 860, 580, 250
local STATES = {
	ok = { label = "Goed", icon = "Interface\\RaidFrame\\ReadyCheck-Ready", col = { 0.25, 0.85, 0.3 } },
	bad = { label = "Fout", icon = "Interface\\RaidFrame\\ReadyCheck-NotReady", col = { 0.95, 0.3, 0.25 } },
	skip = { label = "Overslaan", icon = "Interface\\RaidFrame\\ReadyCheck-Waiting", col = { 0.75, 0.75, 0.75 } },
}
local ORDER = { "ok", "bad", "skip" }

local win, Refresh, FillItems
local selected, filterNew = nil, true

--------------------------------------------------------------------------------
-- Saved results
--------------------------------------------------------------------------------
local function Result(id)
	return db and db.results and db.results[id]
end

local function SetResult(item, sectionTitle, state, note)
	db.results = db.results or {}
	local r = db.results[item.id] or {}
	if state ~= nil then
		r.s = (state ~= "" and state) or nil
	end
	if note ~= nil then
		r.n = (note ~= "" and note) or nil
	end
	if not r.s and not r.n then
		db.results[item.id] = nil
		return
	end
	r.t = time()
	r.sec = sectionTitle
	r.text = item.text:sub(1, 160)
	db.results[item.id] = r
end

local function Counts(items)
	local done, ok, bad, skip = 0, 0, 0, 0
	for _, it in ipairs(items) do
		local r = Result(it.id)
		if r and r.s then
			done = done + 1
			if r.s == "ok" then
				ok = ok + 1
			elseif r.s == "bad" then
				bad = bad + 1
			else
				skip = skip + 1
			end
		end
	end
	return done, ok, bad, skip
end

local function VisibleSections()
	local out = {}
	for _, s in ipairs(DATA.sections) do
		if not filterNew or s.new then
			out[#out + 1] = s
		end
	end
	return out
end

--------------------------------------------------------------------------------
-- Small helpers
--------------------------------------------------------------------------------
local function ToChat(text)
	if ChatFrameUtil and ChatFrameUtil.OpenChat then
		if pcall(ChatFrameUtil.OpenChat, text) then
			return
		end
	end
	if ChatFrame_OpenChat then
		if pcall(ChatFrame_OpenChat, text) then
			return
		end
	end
	print("|cffffcc00MH Testlist:|r " .. text)
end

local function Backdrop(f, a)
	f:SetBackdrop({ bgFile = "Interface\\Buttons\\WHITE8X8", edgeFile = "Interface\\Buttons\\WHITE8X8", edgeSize = 1 })
	f:SetBackdropColor(0.07, 0.06, 0.05, a or 0.96)
	f:SetBackdropBorderColor(0.55, 0.43, 0.22, 0.9)
end

local function SmallButton(parent, w, h, text)
	local b = CreateFrame("Button", nil, parent, "BackdropTemplate")
	b:SetSize(w, h)
	Backdrop(b, 0.9)
	b.t = b:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	b.t:SetPoint("CENTER")
	b.t:SetText(text or "")
	b:SetScript("OnEnter", function(self)
		self:SetBackdropBorderColor(1, 0.82, 0.3, 1)
		if self.tip then
			GameTooltip:SetOwner(self, "ANCHOR_TOP")
			GameTooltip:SetText(self.tip, 1, 1, 1, 1, true)
			GameTooltip:Show()
		end
	end)
	b:SetScript("OnLeave", function(self)
		self:SetBackdropBorderColor(0.55, 0.43, 0.22, 0.9)
		GameTooltip:Hide()
	end)
	return b
end

-- Shift + wheel anywhere on the window scales it; without Shift the scroll frames scroll as usual.
local function WheelScale(delta)
	local s = (db.scale or 1) + (delta > 0 and 0.05 or -0.05)
	s = math.max(0.6, math.min(1.6, s))
	db.scale = s
	win:SetScale(s)
end

local function MakeScroll(parent)
	local sf = CreateFrame("ScrollFrame", nil, parent, "UIPanelScrollFrameTemplate")
	local child = CreateFrame("Frame", nil, sf)
	child:SetSize(10, 10)
	sf:SetScrollChild(child)
	sf:EnableMouseWheel(true)
	sf:SetScript("OnMouseWheel", function(self, delta)
		if IsShiftKeyDown() then
			WheelScale(delta)
			return
		end
		local max = self:GetVerticalScrollRange()
		local v = math.max(0, math.min(max, self:GetVerticalScroll() - delta * 40))
		self:SetVerticalScroll(v)
	end)
	return sf, child
end

--------------------------------------------------------------------------------
-- Window
--------------------------------------------------------------------------------
local function Build()
	if win then
		return win
	end
	local f = CreateFrame("Frame", "MHTestlistFrame", UIParent, "BackdropTemplate")
	f:SetSize(W, H)
	f:SetFrameStrata("HIGH")
	Backdrop(f, 0.97)
	f:SetMovable(true)
	f:EnableMouse(true)
	f:SetClampedToScreen(true)
	if db.point then
		f:SetPoint(db.point[1], UIParent, db.point[1], db.point[2], db.point[3])
	else
		f:SetPoint("CENTER")
	end
	f:SetScale(db.scale or 1)
	f:EnableMouseWheel(true)
	f:SetScript("OnMouseWheel", function(_, delta)
		if IsShiftKeyDown() then
			WheelScale(delta)
		end
	end)
	tinsert(UISpecialFrames, "MHTestlistFrame")

	local top = CreateFrame("Frame", nil, f)
	top:SetPoint("TOPLEFT", 1, -1)
	top:SetPoint("TOPRIGHT", -1, -1)
	top:SetHeight(54)
	top:EnableMouse(true)
	top:RegisterForDrag("LeftButton")
	top:SetScript("OnDragStart", function()
		f:StartMoving()
	end)
	top:SetScript("OnDragStop", function()
		f:StopMovingOrSizing()
		local p, _, _, x, y = f:GetPoint()
		db.point = { p, x, y }
	end)
	local band = top:CreateTexture(nil, "BACKGROUND")
	band:SetAllPoints()
	band:SetColorTexture(0.16, 0.11, 0.06, 1)
	f.title = top:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
	f.title:SetPoint("TOPLEFT", 14, -9)
	f.title:SetText("MH Testlist  |cff9d9d9d(alleen voor Rob)|r")
	f.sub = top:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	f.sub:SetPoint("TOPLEFT", f.title, "BOTTOMLEFT", 0, -4)
	local close = CreateFrame("Button", nil, top, "UIPanelCloseButton")
	close:SetPoint("TOPRIGHT", 0, 0)
	f.reload = SmallButton(top, 86, 22, "Reload")
	f.reload:SetPoint("RIGHT", close, "LEFT", -6, 0)
	f.reload.tip = "Klaar met testen? /reload bewaart je vinkjes en opmerkingen, zodat Claude ze kan lezen."
	f.reload:SetScript("OnClick", function()
		ReloadUI()
	end)
	f.fAll = SmallButton(top, 70, 22, "Alles")
	f.fAll:SetPoint("RIGHT", f.reload, "LEFT", -14, 0)
	f.fNew = SmallButton(top, 80, 22, "Nieuwste")
	f.fNew:SetPoint("RIGHT", f.fAll, "LEFT", -4, 0)
	f.fNew.tip = "Alleen de testrondes van de twee nieuwste datums."
	f.fNew:SetScript("OnClick", function()
		filterNew = true
		selected = nil
		Refresh()
	end)
	f.fAll:SetScript("OnClick", function()
		filterNew = false
		selected = nil
		Refresh()
	end)

	-- Left: sections
	local left = CreateFrame("Frame", nil, f, "BackdropTemplate")
	left:SetPoint("TOPLEFT", 10, -64)
	left:SetPoint("BOTTOMLEFT", 10, 10)
	left:SetWidth(LEFT_W)
	Backdrop(left, 0.6)
	f.lsf, f.lchild = MakeScroll(left)
	f.lsf:SetPoint("TOPLEFT", 4, -4)
	f.lsf:SetPoint("BOTTOMRIGHT", -26, 4)
	f.lchild:SetWidth(LEFT_W - 32)
	f.secBtns = {}

	-- Right: items
	local right = CreateFrame("Frame", nil, f, "BackdropTemplate")
	right:SetPoint("TOPLEFT", left, "TOPRIGHT", 10, 0)
	right:SetPoint("BOTTOMRIGHT", -10, 10)
	Backdrop(right, 0.6)
	f.head = right:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	f.head:SetPoint("TOPLEFT", 12, -10)
	f.head:SetPoint("RIGHT", -12, 0)
	f.head:SetJustifyH("LEFT")
	f.rsf, f.rchild = MakeScroll(right)
	f.rsf:SetPoint("TOPLEFT", 6, -34)
	f.rsf:SetPoint("BOTTOMRIGHT", -26, 6)
	f.rchild:SetWidth(W - LEFT_W - 70)
	f.cards = {}
	f:Hide()
	win = f
	return f
end

local function SectionButton(i)
	local b = win.secBtns[i]
	if b then
		return b
	end
	b = CreateFrame("Button", nil, win.lchild)
	b:SetWidth(LEFT_W - 34)
	b.bg = b:CreateTexture(nil, "BACKGROUND")
	b.bg:SetAllPoints()
	b.t = b:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	b.t:SetPoint("TOPLEFT", 6, -4)
	b.t:SetPoint("RIGHT", -40, 0)
	b.t:SetJustifyH("LEFT")
	b.t:SetMaxLines(2)
	b.n = b:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	b.n:SetPoint("TOPRIGHT", -4, -4)
	b:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		GameTooltip:SetText(self.title or "", 1, 0.82, 0, 1, true)
		GameTooltip:Show()
	end)
	b:SetScript("OnLeave", function()
		GameTooltip:Hide()
	end)
	win.secBtns[i] = b
	return b
end

local function Card(i)
	local c = win.cards[i]
	if c then
		return c
	end
	local cw = W - LEFT_W - 74
	c = CreateFrame("Frame", nil, win.rchild, "BackdropTemplate")
	c:SetWidth(cw)
	Backdrop(c, 0.85)
	c.state = c:CreateTexture(nil, "ARTWORK")
	c.state:SetSize(18, 18)
	c.state:SetPoint("TOPLEFT", 8, -8)
	c.text = c:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
	c.text:SetPoint("TOPLEFT", 32, -8)
	c.text:SetWidth(cw - 44)
	c.text:SetJustifyH("LEFT")
	c.text:SetSpacing(2)
	c.btns = {}
	for k, key in ipairs(ORDER) do
		local st = STATES[key]
		local b = SmallButton(c, 82, 20, st.label)
		b.key = key
		if k == 1 then
			b:SetPoint("TOPLEFT", c.text, "BOTTOMLEFT", 0, -8)
		else
			b:SetPoint("LEFT", c.btns[k - 1], "RIGHT", 4, 0)
		end
		c.btns[k] = b
	end
	c.note = CreateFrame("EditBox", nil, c, "InputBoxTemplate")
	c.note:SetHeight(20)
	c.note:SetPoint("LEFT", c.btns[3], "RIGHT", 14, 0)
	c.note:SetPoint("RIGHT", c, "RIGHT", -12, 0)
	c.note:SetAutoFocus(false)
	c.note:SetMaxLetters(400)
	c.note.ph = c.note:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
	c.note.ph:SetPoint("LEFT", 2, 0)
	c.note.ph:SetText("opmerking...")
	c.note:SetScript("OnEscapePressed", function(self)
		self:ClearFocus()
	end)
	c.note:SetScript("OnEnterPressed", function(self)
		self:ClearFocus()
	end)
	c.note:SetScript("OnEditFocusGained", function(self)
		self.ph:Hide()
	end)
	c.note:SetScript("OnEditFocusLost", function(self)
		local t = self:GetText() or ""
		self.ph:SetShown(t == "")
		if c.item then
			SetResult(c.item, c.section, nil, t)
			Refresh(true)
		end
	end)
	c.cmds = {}
	win.cards[i] = c
	return c
end

local function CmdButton(c, k)
	local b = c.cmds[k]
	if b then
		return b
	end
	b = SmallButton(c, 10, 20, "")
	b.t:SetFontObject("GameFontNormalSmall")
	b.tip = "Zet dit commando in je chatregel. Druk dan op Enter."
	b:SetScript("OnClick", function(self)
		if self.cmd then
			ToChat(self.cmd)
		end
	end)
	c.cmds[k] = b
	return b
end

FillItems = function(sec, keepScroll)
	local f = win
	local done, ok, bad, skip = Counts(sec.items)
	f.head:SetText(("%s   |cff9d9d9d%d/%d  ·  |cff40d840%d goed|r  |cffff5040%d fout|r  |cffbfbfbf%d overgeslagen|r"):format(
		sec.title, done, #sec.items, ok, bad, skip))
	local y = 0
	for i, it in ipairs(sec.items) do
		local c = Card(i)
		c.item, c.section = it, sec.title
		c:ClearAllPoints()
		c:SetPoint("TOPLEFT", f.rchild, "TOPLEFT", (it.indent or 0) * 18, -y)
		c.text:SetText(it.text)
		local r = Result(it.id)
		local s = r and r.s
		if s then
			c.state:SetTexture(STATES[s].icon)
			c.state:Show()
			local col = STATES[s].col
			c:SetBackdropBorderColor(col[1], col[2], col[3], 0.9)
		else
			c.state:Hide()
			c:SetBackdropBorderColor(0.35, 0.3, 0.22, 0.9)
		end
		for _, b in ipairs(c.btns) do
			local st = STATES[b.key]
			if s == b.key then
				b:SetBackdropColor(st.col[1] * 0.45, st.col[2] * 0.45, st.col[3] * 0.45, 1)
				b.t:SetTextColor(1, 1, 1)
			else
				b:SetBackdropColor(0.07, 0.06, 0.05, 0.9)
				b.t:SetTextColor(st.col[1], st.col[2], st.col[3])
			end
			b:SetScript("OnClick", function()
				SetResult(it, sec.title, (s == b.key) and "" or b.key, nil)
				Refresh(true)
			end)
		end
		local note = r and r.n or ""
		if not c.note:HasFocus() then
			c.note:SetText(note)
		end
		c.note.ph:SetShown(note == "" and not c.note:HasFocus())
		-- Commands: one button each, in a row (wrapping) under the buttons.
		local cx, cy = 0, 0
		local maxW = c:GetWidth() - 44
		for k, cmd in ipairs(it.cmds or {}) do
			local b = CmdButton(c, k)
			b.cmd = cmd
			b.t:SetText(cmd)
			local bw = math.min(maxW, (b.t:GetStringWidth() or 60) + 18)
			b:SetWidth(bw)
			if cx > 0 and cx + bw > maxW then
				cx, cy = 0, cy + 24
			end
			b:ClearAllPoints()
			b:SetPoint("TOPLEFT", c.btns[1], "BOTTOMLEFT", cx, -6 - cy)
			b:Show()
			cx = cx + bw + 6
		end
		for k = #(it.cmds or {}) + 1, #c.cmds do
			c.cmds[k]:Hide()
		end
		local cmdH = (#(it.cmds or {}) > 0) and (cy + 26) or 0
		local h = 8 + (c.text:GetStringHeight() or 14) + 8 + 20 + cmdH + 10
		c:SetHeight(h)
		c:Show()
		y = y + h + 6
	end
	for i = #sec.items + 1, #f.cards do
		f.cards[i]:Hide()
	end
	f.rchild:SetHeight(math.max(10, y))
	if not keepScroll then
		f.rsf:SetVerticalScroll(0)
	end
end

Refresh = function(keepScroll)
	if not win or not win:IsShown() then
		return
	end
	local f = win
	local secs = VisibleSections()
	local total, done, ok, bad = 0, 0, 0, 0
	for _, s in ipairs(DATA.sections) do
		local d, o, b = Counts(s.items)
		total, done, ok, bad = total + #s.items, done + d, ok + o, bad + b
	end
	f.sub:SetText(("Gebouwd %s  ·  %d punten open in de lijst  ·  |cff40d840%d goed|r  |cffff5040%d fout|r  ·  %d nog te doen"):format(
		DATA.built or "?", total, ok, bad, total - done))
	f.fNew:SetBackdropColor(filterNew and 0.35 or 0.07, filterNew and 0.25 or 0.06, filterNew and 0.1 or 0.05, 0.95)
	f.fAll:SetBackdropColor(filterNew and 0.07 or 0.35, filterNew and 0.06 or 0.25, filterNew and 0.05 or 0.1, 0.95)
	local found = false
	for _, s in ipairs(secs) do
		if s == selected then
			found = true
		end
	end
	if not found then
		selected = secs[1]
	end
	local y = 0
	for i, s in ipairs(secs) do
		local b = SectionButton(i)
		b.title = s.title
		b.t:SetText(s.title)
		local d = Counts(s.items)
		b.n:SetText(("%d/%d"):format(d, #s.items))
		if d == #s.items then
			b.n:SetTextColor(0.25, 0.85, 0.3)
		else
			b.n:SetTextColor(0.8, 0.8, 0.8)
		end
		local h = math.max(22, (b.t:GetStringHeight() or 12) + 10)
		b:SetHeight(h)
		b:ClearAllPoints()
		b:SetPoint("TOPLEFT", f.lchild, "TOPLEFT", 0, -y)
		b.bg:SetColorTexture(0.55, 0.43, 0.22, s == selected and 0.35 or 0)
		b:SetScript("OnClick", function()
			selected = s
			Refresh()
		end)
		b:Show()
		y = y + h + 2
	end
	for i = #secs + 1, #f.secBtns do
		f.secBtns[i]:Hide()
	end
	f.lchild:SetHeight(math.max(10, y))
	if selected then
		FillItems(selected, keepScroll)
	else
		f.head:SetText("Geen open punten.")
		for _, c in ipairs(f.cards) do
			c:Hide()
		end
	end
end

local function Toggle()
	local f = Build()
	if f:IsShown() then
		f:Hide()
	else
		f:Show()
		Refresh()
	end
end

SLASH_MHTESTLIST1 = "/mhtest"
SlashCmdList.MHTESTLIST = Toggle

local ev = CreateFrame("Frame")
ev:RegisterEvent("ADDON_LOADED")
ev:SetScript("OnEvent", function(self, _, name)
	if name ~= ADDON then
		return
	end
	MHTestlistDB = type(MHTestlistDB) == "table" and MHTestlistDB or {}
	db = MHTestlistDB
	db.results = type(db.results) == "table" and db.results or {}
	db.dataBuilt = DATA.built
	self:UnregisterEvent("ADDON_LOADED")
	local n = 0
	for _, s in ipairs(DATA.sections) do
		n = n + #s.items
	end
	print(("|cffffcc00MH Testlist:|r %d testpunten (gebouwd %s). Typ |cff66ccff/mhtest|r om de lijst te openen."):format(
		n, tostring(DATA.built)))
end)
