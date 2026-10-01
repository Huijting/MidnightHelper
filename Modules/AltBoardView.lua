local _, ns = ...

--[[
	Midnight Helper — the character overview as COLUMNS (1 Oct 2026).

	Rob saw Allemano AltBoard (a WoW Forever addon) and liked its layout: characters side by
	side, the facts as rows under section headings, and a click on a character for its gear.
	Only the idea is taken; no code was seen or used. He chose (1 Oct): this layout, the click
	card with gear, and gold / rested XP / last seen. Searching every bag and bank is parked on
	the ROADMAP on purpose (other addons do it; it would grow the saved file a lot).

	How it fits in: AltOverview.lua still collects, filters and sorts the characters. When the
	player picks "Columns" (toolbar button, remembered in ns.db.altBoardView), its RefreshRows
	hands the same list to ns.MhAltBoardRefresh and hides its own rows. Nothing about the row
	view changes for players who keep it.

	Data: the snapshot records in ns.db.charCurrencies (class, specID, gold, restXP, xp, xpMax,
	seen, gear, profs were added for this view; older records show a dash until that character
	logs in once). Currencies come from CurrencyAccount.lua's own list and reader, so this view
	and the Currencies block cannot disagree.

	Wide accounts do not get a sideways scroll bar: the columns PAGE (◀ ▶), which works the
	same with a mouse wheel, a trackpad and a controller.
]]

local LABEL_W = 150
local COL_W = 112
local ROW_H = 18
local SECTION_H = 22
local HEAD_H = 34
local BAR_H = 22

local board -- the frame, created on first use
local card -- the click card
local bigWin -- the board in a window of its own (Rob, 1 Oct: "in één keer een overzicht")
local placeholder -- text left in the panel while the board lives in that window
local page = 1
local rowPool, rowUsed = {}, 0
local headPool = {}
local lastArgs

local function Scale()
	return (ns.GetContentFontScale and ns.GetContentFontScale()) or 1
end

local function Font(fs, name)
	if ns.MHScalableFont then
		fs:SetFontObject(ns.MHScalableFont(name))
	else
		fs:SetFontObject(name)
	end
end

--------------------------------------------------------------------------------
-- Settings

function ns.MhAltBoardIsActive()
	if not ns.db then
		return false
	end
	-- Columns are the default since Rob asked for this layout; one click goes back to rows.
	return ns.db.altBoardView ~= false
end

function ns.MhAltBoardSetActive(v)
	if ns.db then
		ns.db.altBoardView = v and true or false
	end
	page = 1
end

local function Collapsed()
	if not ns.db then
		return {}
	end
	ns.db.altBoardCollapsed = ns.db.altBoardCollapsed or {}
	return ns.db.altBoardCollapsed
end

--------------------------------------------------------------------------------
-- Formatting

local function ClassColorText(class, text)
	local c = class and RAID_CLASS_COLORS and RAID_CLASS_COLORS[class]
	if c and c.colorStr then
		return "|c" .. c.colorStr .. text .. "|r"
	end
	return text
end

local DASH = "|cff6f6a80—|r"

local function MaxLevel()
	if GetMaxLevelForPlayerExpansion then
		local ok, v = pcall(GetMaxLevelForPlayerExpansion)
		if ok and tonumber(v) then
			return tonumber(v)
		end
	end
	return 90
end

local function Gold(copper)
	copper = tonumber(copper)
	if not copper then
		return DASH
	end
	local g = math.floor(copper / 10000)
	local s = (BreakUpLargeNumbers and BreakUpLargeNumbers(g)) or tostring(g)
	return "|cffffd100" .. s .. "|r g"
end

local function Ago(ts, isYou)
	if isYou then
		return "|cff6cc98f" .. ns:L("ALTBOARD_ONLINE") .. "|r"
	end
	local v = tonumber(ts) or 0
	if v <= 0 then
		return DASH
	end
	local d = math.max(0, math.floor(time() - v))
	if d < 3600 then
		return ns:L("ALT_UPDATED_MINUTES"):format(math.floor(d / 60))
	elseif d < 86400 then
		return ns:L("ALT_UPDATED_HOURS"):format(math.floor(d / 3600))
	end
	return ns:L("ALT_UPDATED_DAYS"):format(math.floor(d / 86400))
end

local function SpecName(specID)
	specID = tonumber(specID)
	if not specID or not GetSpecializationInfoByID then
		return nil
	end
	local ok, _, name = pcall(GetSpecializationInfoByID, specID)
	if ok and type(name) == "string" and name ~= "" then
		return name
	end
	return nil
end

local function Stale(e)
	return ns.MhAccountEntryIsStale and ns:MhAccountEntryIsStale(e)
end

local function Vault(e, kind)
	local u = tonumber(e["vault" .. kind .. "Unlocked"]) or 0
	local t = tonumber(e["vault" .. kind .. "Total"]) or 0
	if t <= 0 then
		return DASH
	end
	if Stale(e) then
		-- Saved before this week's reset: the counts belong to last week.
		return "|cff6f6a80?|r"
	end
	local col = u >= t and "|cff6cc98f" or (u > 0 and "|cffffd100" or "|cffa39cc0")
	return ("%s%d/%d|r"):format(col, u, t)
end

local function CurrencyLabel(c)
	if C_CurrencyInfo and C_CurrencyInfo.GetCurrencyInfo and c.id then
		local ok, info = pcall(C_CurrencyInfo.GetCurrencyInfo, c.id)
		if ok and type(info) == "table" and type(info.name) == "string" and info.name ~= "" then
			return info.name
		end
	end
	if c.labelKey then
		return ns:L(c.labelKey)
	end
	return c.name or tostring(c.id)
end

--------------------------------------------------------------------------------
-- The rows: sections with their lines, built from the characters on screen

local function BuildRows(entries, curGuid)
	local rows = {}
	local function section(key, labelKey)
		rows[#rows + 1] = { section = key, label = ns:L(labelKey) }
	end
	local function line(sec, label, get)
		rows[#rows + 1] = { sec = sec, label = label, get = get }
	end

	section("overview", "ALTBOARD_SEC_OVERVIEW")
	local maxLvl = MaxLevel()
	line("overview", ns:L("ALTBOARD_LEVEL"), function(e)
		local lvl = tonumber(e.level) or 0
		if lvl <= 0 then
			return DASH
		end
		if lvl < maxLvl and tonumber(e.xp) and tonumber(e.xpMax) and e.xpMax > 0 then
			return ("%d |cffa39cc0(%d%%)|r"):format(lvl, math.floor(e.xp / e.xpMax * 100))
		end
		return tostring(lvl)
	end)
	line("overview", ns:L("ALTBOARD_SPEC"), function(e)
		return SpecName(e.specID) or DASH
	end)
	line("overview", ns:L("ALTBOARD_ILVL"), function(e)
		local v = tonumber(e.ilvl) or 0
		return v > 0 and tostring(v) or DASH
	end)
	line("overview", ns:L("ALTBOARD_GOLD"), function(e)
		return Gold(e.gold)
	end)
	line("overview", ns:L("ALTBOARD_RESTED"), function(e)
		local lvl = tonumber(e.level) or 0
		if lvl >= maxLvl then
			return DASH
		end
		local r, m = tonumber(e.restXP), tonumber(e.xpMax)
		if not r or not m or m <= 0 then
			return DASH
		end
		return ("|cff8fb8ff%d%%|r"):format(math.floor(r / m * 100))
	end)
	line("overview", ns:L("ALTBOARD_SEEN"), function(e)
		return Ago(e.seen, e.guid == curGuid)
	end)

	section("week", "ALTBOARD_SEC_WEEK")
	line("week", ns:L("ALTBOARD_VAULT_WORLD"), function(e) return Vault(e, "World") end)
	line("week", ns:L("ALTBOARD_VAULT_DUNGEON"), function(e) return Vault(e, "Dungeon") end)
	line("week", ns:L("ALTBOARD_VAULT_RAID"), function(e) return Vault(e, "Raid") end)
	line("week", ns:L("ALTBOARD_SHARDS_WEEK"), function(e)
		local w = tonumber(e.shardsWeekly) or 0
		if ns.MhGetEffectiveShardsWeekly then
			w = ns:MhGetEffectiveShardsWeekly(e.shardsWeekly, e.ts)
		end
		local m = tonumber(e.shardsWeeklyMax) or 600
		local col = w >= m and "|cff6cc98f" or "|cffece8f7"
		return ("%s%d|r/%d"):format(col, w, m)
	end)

	-- Currencies: the Currencies block's own list. A currency nobody on screen has is left out,
	-- so the section shows what this account actually holds.
	local list = ns.MH_TrackedCurrencies and ns.MH_TrackedCurrencies() or {}
	local curRows = {}
	for _, c in ipairs(list) do
		local any = false
		for _, e in ipairs(entries) do
			local q = ns.MH_RecordCurrencyAmount and ns.MH_RecordCurrencyAmount(e, c)
			if q and q > 0 then
				any = true
				break
			end
		end
		if any then
			curRows[#curRows + 1] = c
		end
	end
	if #curRows > 0 then
		section("currency", "ALTBOARD_SEC_CURRENCY")
		for _, c in ipairs(curRows) do
			line("currency", CurrencyLabel(c), function(e)
				local q, _, _, known = ns.MH_RecordCurrencyAmount(e, c)
				if not known then
					return DASH
				end
				return (BreakUpLargeNumbers and BreakUpLargeNumbers(q)) or tostring(q)
			end)
		end
	end

	-- Professions: one line per profession anyone on screen has, in the order first seen.
	local names, seenName = {}, {}
	for _, e in ipairs(entries) do
		for _, p in ipairs(type(e.profs) == "table" and e.profs or {}) do
			if type(p.n) == "string" and not seenName[p.n] then
				seenName[p.n] = true
				names[#names + 1] = p.n
			end
		end
	end
	if #names > 0 then
		section("prof", "ALTBOARD_SEC_PROF")
		for _, pname in ipairs(names) do
			line("prof", pname, function(e)
				if type(e.profs) ~= "table" then
					return DASH
				end
				for _, p in ipairs(e.profs) do
					if p.n == pname then
						if tonumber(p.r) and tonumber(p.m) and p.m > 0 then
							local col = p.r >= p.m and "|cff6cc98f" or "|cffece8f7"
							return ("%s%d|r/%d"):format(col, p.r, p.m)
						end
						-- Profession known, skill not recorded (record saved before skill was kept).
						-- An ASCII "+" on purpose: the game's font has no check mark glyph.
						return "|cff6cc98f+|r"
					end
				end
				return ""
			end)
		end
	end
	return rows
end

--------------------------------------------------------------------------------
-- The click card: one character's gear and week

local SLOT_NAMES = {
	[1] = "HEADSLOT", [2] = "NECKSLOT", [3] = "SHOULDERSLOT", [15] = "BACKSLOT", [5] = "CHESTSLOT",
	[9] = "WRISTSLOT", [10] = "HANDSSLOT", [6] = "WAISTSLOT", [7] = "LEGSSLOT", [8] = "FEETSLOT",
	[11] = "FINGER0SLOT", [12] = "FINGER1SLOT", [13] = "TRINKET0SLOT", [14] = "TRINKET1SLOT",
	[16] = "MAINHANDSLOT", [17] = "SECONDARYHANDSLOT",
}
local SLOT_ORDER = { 1, 2, 3, 15, 5, 9, 10, 6, 7, 8, 11, 12, 13, 14, 16, 17 }

local function ItemIdFromLink(link)
	return tonumber(type(link) == "string" and link:match("item:(%d+)"))
end

local function EnsureCard()
	if card then
		return card
	end
	local f = CreateFrame("Frame", "MidnightHelperAltBoardCard", UIParent, "BackdropTemplate")
	f:SetSize(440, 560)
	f:SetPoint("CENTER")
	f:SetFrameStrata("DIALOG")
	f:SetBackdrop({
		bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
		edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Gold-Border",
		tile = true, tileSize = 32, edgeSize = 32,
		insets = { left = 11, right = 12, top = 12, bottom = 11 },
	})
	f:SetBackdropColor(0.05, 0.05, 0.08, 0.96)
	f:EnableMouse(true)
	f:SetMovable(true)
	f:RegisterForDrag("LeftButton")
	f:SetScript("OnDragStart", f.StartMoving)
	f:SetScript("OnDragStop", f.StopMovingOrSizing)
	if ns.RegisterMidnightDialogPopup then
		ns.RegisterMidnightDialogPopup(f)
	else
		tinsert(UISpecialFrames, f:GetName())
	end

	local close = CreateFrame("Button", nil, f, "UIPanelCloseButton")
	close:SetPoint("TOPRIGHT", -4, -4)

	f.title = f:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
	f.title:SetPoint("TOPLEFT", 20, -20)
	f.title:SetPoint("RIGHT", -36, 0)
	f.title:SetJustifyH("LEFT")

	f.sub = f:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	f.sub:SetPoint("TOPLEFT", f.title, "BOTTOMLEFT", 0, -4)
	f.sub:SetPoint("RIGHT", -20, 0)
	f.sub:SetJustifyH("LEFT")

	f.gearHead = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	f.gearHead:SetPoint("TOPLEFT", f.sub, "BOTTOMLEFT", 0, -14)

	f.slots = {}
	for i, slot in ipairs(SLOT_ORDER) do
		local b = CreateFrame("Button", nil, f)
		b:SetSize(400, 22)
		b:SetPoint("TOPLEFT", f.gearHead, "BOTTOMLEFT", 0, -6 - (i - 1) * 23)
		b.icon = b:CreateTexture(nil, "ARTWORK")
		b.icon:SetSize(20, 20)
		b.icon:SetPoint("LEFT", 0, 0)
		b.slot = b:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
		b.slot:SetPoint("LEFT", b.icon, "RIGHT", 6, 0)
		b.slot:SetWidth(78)
		b.slot:SetJustifyH("LEFT")
		b.name = b:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
		b.name:SetPoint("LEFT", b.slot, "RIGHT", 4, 0)
		b.name:SetPoint("RIGHT", b, "RIGHT", -40, 0)
		b.name:SetJustifyH("LEFT")
		b.name:SetWordWrap(false)
		b.ilvl = b:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
		b.ilvl:SetPoint("RIGHT", b, "RIGHT", 0, 0)
		b.ilvl:SetJustifyH("RIGHT")
		b:SetScript("OnEnter", function(self)
			if self.link and GameTooltip then
				GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
				pcall(GameTooltip.SetHyperlink, GameTooltip, self.link)
				GameTooltip:Show()
			end
		end)
		b:SetScript("OnLeave", function()
			if GameTooltip then
				GameTooltip:Hide()
			end
		end)
		b.slotId = slot
		f.slots[i] = b
	end

	f.empty = f:CreateFontString(nil, "OVERLAY", "GameFontDisable")
	f.empty:SetPoint("TOPLEFT", f.gearHead, "BOTTOMLEFT", 0, -8)
	f.empty:SetPoint("RIGHT", -20, 0)
	f.empty:SetJustifyH("LEFT")

	f.week = f:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	f.week:SetPoint("BOTTOMLEFT", 20, 18)
	f.week:SetPoint("RIGHT", -20, 0)
	f.week:SetJustifyH("LEFT")
	f.week:SetSpacing(2)

	card = f
	return f
end

local function ShowCard(e, curGuid)
	local f = EnsureCard()
	local isYou = e.guid == curGuid
	local name = tostring(e.name or "?") .. ((e.realm and e.realm ~= "") and ("-" .. e.realm) or "")
	f.title:SetText(ClassColorText(e.class, name))
	local bits = {}
	bits[#bits + 1] = ns:L("ALTBOARD_LEVEL") .. " " .. tostring(tonumber(e.level) or "?")
	local spec = SpecName(e.specID)
	if spec then
		bits[#bits + 1] = spec
	end
	if (tonumber(e.ilvl) or 0) > 0 then
		bits[#bits + 1] = ns:L("ALTBOARD_ILVL") .. " " .. e.ilvl
	end
	bits[#bits + 1] = Gold(e.gold)
	bits[#bits + 1] = Ago(e.seen, isYou)
	f.sub:SetText(table.concat(bits, "  ·  "))

	f.gearHead:SetText(ns:L("ALTBOARD_CARD_GEAR"))
	local gear = type(e.gear) == "table" and e.gear or nil
	for _, b in ipairs(f.slots) do
		local rec = gear and gear[b.slotId]
		local label = _G[SLOT_NAMES[b.slotId]] or ""
		b.slot:SetText(label)
		if rec and type(rec.l) == "string" then
			b.link = rec.l
			b.name:SetText(rec.l)
			b.ilvl:SetText(rec.i and tostring(rec.i) or "")
			local id = ItemIdFromLink(rec.l)
			local icon = id and C_Item and C_Item.GetItemIconByID and C_Item.GetItemIconByID(id)
			b.icon:SetTexture(icon or 134400)
		else
			b.link = nil
			b.name:SetText("|cff6f6a80" .. ns:L("ALTBOARD_CARD_EMPTY_SLOT") .. "|r")
			b.ilvl:SetText("")
			b.icon:SetTexture(nil)
		end
		b:SetShown(gear ~= nil)
	end
	if gear then
		f.empty:Hide()
	else
		f.empty:SetText(ns:L("ALTBOARD_CARD_NO_GEAR"))
		f.empty:Show()
	end

	f.week:SetText(("%s\n%s %s   %s %s   %s %s"):format(
		ns:L("ALTBOARD_SEC_WEEK"),
		ns:L("ALTBOARD_VAULT_WORLD"), Vault(e, "World"),
		ns:L("ALTBOARD_VAULT_DUNGEON"), Vault(e, "Dungeon"),
		ns:L("ALTBOARD_VAULT_RAID"), Vault(e, "Raid")))
	f:Show()
end

--------------------------------------------------------------------------------
-- The board

local function EnsureBoard(parent)
	if board then
		if board:GetParent() ~= parent then
			board:SetParent(parent)
		end
		board:ClearAllPoints()
		board:SetAllPoints(parent)
		return board
	end
	local b = CreateFrame("Frame", "MidnightHelperAltBoard", parent)
	b:SetAllPoints(parent)

	b.hint = b:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
	b.hint:SetPoint("TOPLEFT", 2, -4)
	b.hint:SetJustifyH("LEFT")

	b.next = CreateFrame("Button", nil, b, "UIPanelButtonTemplate")
	b.next:SetSize(26, 20)
	b.next:SetPoint("TOPRIGHT", -2, 0)
	b.next:SetText(">")
	b.prev = CreateFrame("Button", nil, b, "UIPanelButtonTemplate")
	b.prev:SetSize(26, 20)
	b.prev:SetText("<")
	b.pageFs = b:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	b.pageFs:SetPoint("RIGHT", b.next, "LEFT", -6, 0)
	b.prev:SetPoint("RIGHT", b.pageFs, "LEFT", -6, 0)

	-- 1 Oct 2026, after Rob's first look: in the main window the columns got a strip under the
	-- weekly checklist. This opens them in a window of their own, nearly the size of the screen.
	b.big = CreateFrame("Button", nil, b, "UIPanelButtonTemplate")
	b.big:SetHeight(20)
	b.big:SetPoint("RIGHT", b.prev, "LEFT", -10, 0)
	b.big:SetScript("OnClick", function()
		if bigWin and bigWin:IsShown() then
			bigWin:Hide()
		elseif ns.MhAltBoardOpenBig then
			ns.MhAltBoardOpenBig()
		end
	end)
	b.next:SetScript("OnClick", function()
		page = page + 1
		if lastArgs then
			ns.MhAltBoardRefresh(unpack(lastArgs))
		end
	end)
	b.prev:SetScript("OnClick", function()
		page = math.max(1, page - 1)
		if lastArgs then
			ns.MhAltBoardRefresh(unpack(lastArgs))
		end
	end)

	local scroll = CreateFrame("ScrollFrame", nil, b)
	scroll:SetPoint("TOPLEFT", 0, -BAR_H - 4)
	scroll:SetPoint("BOTTOMRIGHT", 0, 0)
	scroll:EnableMouseWheel(true)
	local content = CreateFrame("Frame", nil, scroll)
	content:SetSize(400, 40)
	scroll:SetScrollChild(content)
	scroll:SetScript("OnMouseWheel", function(self, delta)
		local cur = self:GetVerticalScroll() or 0
		local max = self:GetVerticalScrollRange() or 0
		local v = math.min(max, math.max(0, cur - delta * 40))
		self:SetVerticalScroll(v)
	end)
	b.scroll, b.content = scroll, content

	b.emptyFs = content:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	b.emptyFs:SetPoint("TOPLEFT", 4, -6)
	b.emptyFs:SetJustifyH("LEFT")
	board = b
	return b
end

local function GetRow(i)
	local r = rowPool[i]
	if r then
		return r
	end
	r = CreateFrame("Button", nil, board.content)
	r.bg = r:CreateTexture(nil, "BACKGROUND")
	r.bg:SetAllPoints()
	r.label = r:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	r.label:SetPoint("LEFT", 6, 0)
	r.label:SetJustifyH("LEFT")
	r.label:SetWordWrap(false)
	r.cells = {}
	rowPool[i] = r
	return r
end

local function GetCell(r, j)
	local c = r.cells[j]
	if not c then
		c = r:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
		c:SetJustifyH("CENTER")
		c:SetWordWrap(false)
		r.cells[j] = c
	end
	return c
end

local function GetHead(j)
	local h = headPool[j]
	if h then
		return h
	end
	h = CreateFrame("Button", nil, board.content)
	h.bg = h:CreateTexture(nil, "BACKGROUND")
	h.bg:SetAllPoints()
	h.bg:SetColorTexture(0.12, 0.10, 0.21, 0.9)
	h.name = h:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	h.name:SetPoint("TOP", 0, -3)
	h.name:SetWidth(COL_W - 6)
	h.name:SetWordWrap(false)
	h.sub = h:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
	h.sub:SetPoint("TOP", h.name, "BOTTOM", 0, -1)
	h.sub:SetWidth(COL_W - 6)
	h.sub:SetWordWrap(false)
	h.hl = h:CreateTexture(nil, "HIGHLIGHT")
	h.hl:SetAllPoints()
	h.hl:SetColorTexture(0.89, 0.72, 0.35, 0.12)
	h:SetScript("OnLeave", function()
		if GameTooltip then
			GameTooltip:Hide()
		end
	end)
	headPool[j] = h
	return h
end

function ns.MhAltBoardHide()
	if board then
		board:Hide()
	end
	if placeholder then
		placeholder:Hide()
	end
	-- Back to rows while the big window is open: close it too (its OnHide refreshes once more,
	-- finds it hidden and stops there).
	if bigWin and bigWin:IsShown() then
		bigWin:Hide()
	end
end

local function EnsureBig()
	if bigWin then
		return bigWin
	end
	local f = CreateFrame("Frame", "MidnightHelperAltBoardWindow", UIParent, "BackdropTemplate")
	f:SetFrameStrata("DIALOG")
	f:SetBackdrop({
		bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
		edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Gold-Border",
		tile = true, tileSize = 32, edgeSize = 32,
		insets = { left = 11, right = 12, top = 12, bottom = 11 },
	})
	f:SetBackdropColor(0.05, 0.05, 0.08, 0.97)
	f:EnableMouse(true)
	f:SetMovable(true)
	f:RegisterForDrag("LeftButton")
	f:SetScript("OnDragStart", f.StartMoving)
	f:SetScript("OnDragStop", f.StopMovingOrSizing)
	f.title = f:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
	f.title:SetPoint("TOPLEFT", 20, -18)
	local close = CreateFrame("Button", nil, f, "UIPanelCloseButton")
	close:SetPoint("TOPRIGHT", -4, -4)
	f.inner = CreateFrame("Frame", nil, f)
	f.inner:SetPoint("TOPLEFT", 18, -44)
	f.inner:SetPoint("BOTTOMRIGHT", -18, 16)
	-- Closing hands the board back to the panel it came from.
	f:SetScript("OnHide", function()
		if ns._mhAltOverviewRefreshRows then
			ns:_mhAltOverviewRefreshRows()
		end
	end)
	if ns.RegisterMidnightDialogPopup then
		ns.RegisterMidnightDialogPopup(f)
	else
		tinsert(UISpecialFrames, f:GetName())
	end
	bigWin = f
	return f
end

function ns.MhAltBoardOpenBig()
	local f = EnsureBig()
	local w = math.min((UIParent:GetWidth() or 1600) * 0.92, 1700)
	local h = (UIParent:GetHeight() or 900) * 0.86
	f:SetSize(w, h)
	f:ClearAllPoints()
	f:SetPoint("CENTER")
	f.title:SetText(ns:L("ALT_OVERVIEW_TITLE"))
	f:Show()
	page = 1
	if lastArgs then
		ns.MhAltBoardRefresh(unpack(lastArgs))
	end
end

--- Draw the characters as columns.
--- @param parent  Frame   AltOverview's expandPanel
--- @param entries table   already filtered and sorted by AltOverview
--- @param curGuid string  the character you are logged in on
--- @param allCount number how many characters exist before filtering (for the empty text)
function ns.MhAltBoardRefresh(parent, entries, curGuid, allCount)
	lastArgs = { parent, entries, curGuid, allCount }

	-- First time the columns are used: fold the weekly checklist above them once, so they get the
	-- room (Rob's first look, 1 Oct 2026). After that the player's own +/- choice stands.
	if ns.db and not ns.db.altBoardFoldedWeekly and ns.SetAccountWeeklyChecklistCollapsed then
		ns.db.altBoardFoldedWeekly = true
		if not (ns.IsAccountWeeklyChecklistCollapsed and ns.IsAccountWeeklyChecklistCollapsed()) then
			ns.SetAccountWeeklyChecklistCollapsed(true)
		end
	end

	-- While the big window is open the board lives there; the panel shows a short note instead.
	local home = parent
	if bigWin and bigWin:IsShown() then
		parent = bigWin.inner
		if not placeholder then
			placeholder = home:CreateFontString(nil, "OVERLAY", "GameFontDisable")
			placeholder:SetPoint("TOPLEFT", 4, -8)
			placeholder:SetJustifyH("LEFT")
		end
		placeholder:SetText(ns:L("ALTBOARD_IN_WINDOW"))
		placeholder:Show()
	elseif placeholder then
		placeholder:Hide()
	end

	local b = EnsureBoard(parent)
	b:Show()
	b.big:SetText(ns:L((bigWin and bigWin:IsShown()) and "ALTBOARD_BIG_CLOSE" or "ALTBOARD_BIG"))
	b.big:SetWidth(math.max(90, (b.big:GetFontString() and b.big:GetFontString():GetStringWidth() or 80) + 24))
	local s = Scale()
	local rowH, secH, headH = ROW_H * s, SECTION_H * s, HEAD_H * s

	for _, r in ipairs(rowPool) do
		r:Hide()
	end
	for _, h in ipairs(headPool) do
		h:Hide()
	end

	local width = math.max(300, (parent:GetWidth() or 600) - 4)
	b.content:SetWidth(width)

	if #entries == 0 then
		b.emptyFs:SetText(ns:L((allCount or 0) > 0 and "ALT_SNAPSHOT_FILTER_EMPTY" or "ALT_OVERVIEW_EMPTY"))
		b.emptyFs:SetWidth(width - 8)
		b.emptyFs:Show()
		b.hint:SetText("")
		b.prev:Hide()
		b.next:Hide()
		b.pageFs:SetText("")
		b.content:SetHeight(40)
		return
	end
	b.emptyFs:Hide()

	-- Paging: as many columns as fit; ◀ ▶ walk through the rest.
	local perPage = math.max(1, math.floor((width - LABEL_W - 4) / COL_W))
	local pages = math.max(1, math.ceil(#entries / perPage))
	if page > pages then
		page = pages
	end
	local first = (page - 1) * perPage + 1
	local last = math.min(#entries, first + perPage - 1)
	local shown = {}
	for i = first, last do
		shown[#shown + 1] = entries[i]
	end
	b.hint:SetText(ns:L("ALTBOARD_HINT"))
	if pages > 1 then
		b.pageFs:SetText(ns:L("ALTBOARD_PAGE_FMT"):format(first, last, #entries))
		b.prev:Show()
		b.next:Show()
		b.prev:SetEnabled(page > 1)
		b.next:SetEnabled(page < pages)
	else
		b.pageFs:SetText("")
		b.prev:Hide()
		b.next:Hide()
	end

	-- Header: one clickable name per column.
	for j, e in ipairs(shown) do
		local h = GetHead(j)
		h:SetSize(COL_W - 4, headH)
		h:ClearAllPoints()
		h:SetPoint("TOPLEFT", b.content, "TOPLEFT", LABEL_W + (j - 1) * COL_W + 2, 0)
		Font(h.name, "GameFontNormal")
		Font(h.sub, "GameFontDisableSmall")
		local you = e.guid == curGuid and " |cffe3b75a*|r" or ""
		h.name:SetText(ClassColorText(e.class, tostring(e.name or "?")) .. you)
		h.sub:SetText(e.realm or "")
		h:SetScript("OnClick", function()
			ShowCard(e, curGuid)
		end)
		h:SetScript("OnEnter", function(self)
			if not GameTooltip then
				return
			end
			GameTooltip:SetOwner(self, "ANCHOR_BOTTOM")
			GameTooltip:SetText(tostring(e.name or "?") .. ((e.realm and e.realm ~= "") and ("-" .. e.realm) or ""), 1, 1, 1)
			GameTooltip:AddLine(ns:L("ALTBOARD_CLICK_FOR_GEAR"), 0.89, 0.72, 0.35, true)
			GameTooltip:Show()
		end)
		h:Show()
	end

	-- Rows.
	local rows = BuildRows(shown, curGuid)
	local collapsed = Collapsed()
	local y = -headH - 4
	local n, stripe = 0, 0
	for _, def in ipairs(rows) do
		local hidden = def.sec and collapsed[def.sec]
		if not hidden then
			n = n + 1
			local r = GetRow(n)
			r:ClearAllPoints()
			r:SetPoint("TOPLEFT", b.content, "TOPLEFT", 0, y)
			r:SetWidth(LABEL_W + #shown * COL_W)
			Font(r.label, def.section and "GameFontNormal" or "GameFontHighlightSmall")
			if def.section then
				r:SetHeight(secH)
				r.bg:SetColorTexture(0.18, 0.15, 0.31, 0.95)
				local open = not collapsed[def.section]
				r.label:SetText((open and "[-] " or "[+] ") .. def.label)
				r.label:SetWidth(LABEL_W + #shown * COL_W - 12)
				for _, c in ipairs(r.cells) do
					c:Hide()
				end
				local key = def.section
				r:SetScript("OnClick", function()
					collapsed[key] = not collapsed[key] or nil
					if lastArgs then
						ns.MhAltBoardRefresh(unpack(lastArgs))
					end
				end)
				r:EnableMouse(true)
				y = y - secH - 2
				stripe = 0
			else
				r:SetHeight(rowH)
				stripe = stripe + 1
				if stripe % 2 == 0 then
					r.bg:SetColorTexture(1, 1, 1, 0.035)
				else
					r.bg:SetColorTexture(0, 0, 0, 0)
				end
				r.label:SetText("|cffa39cc0" .. def.label .. "|r")
				r.label:SetWidth(LABEL_W - 10)
				for j, e in ipairs(shown) do
					local c = GetCell(r, j)
					Font(c, "GameFontHighlightSmall")
					c:ClearAllPoints()
					c:SetPoint("LEFT", r, "LEFT", LABEL_W + (j - 1) * COL_W, 0)
					c:SetWidth(COL_W - 4)
					local ok, txt = pcall(def.get, e)
					c:SetText(ok and txt or DASH)
					c:Show()
				end
				for j = #shown + 1, #r.cells do
					r.cells[j]:Hide()
				end
				r:SetScript("OnClick", nil)
				r:EnableMouse(false)
				y = y - rowH
			end
			r:Show()
		end
	end
	b.content:SetHeight(-y + 8)
	if b.scroll.UpdateScrollChildRect then
		b.scroll:UpdateScrollChildRect()
	end
end
