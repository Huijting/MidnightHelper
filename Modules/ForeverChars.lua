local _, ns = ...

--[[
	ForeverChars.lua — WoW Forever: "Your characters", every character of this account on one row.

	Rob, 12 Nov 2026, via sparring, verbatim: "De vijf van het advies, bouwen (Recommended)". Option text he saw: "Per
	character: level en class, goud (met een totaal onderaan), beroepen met skill, je gekozen richting, wanneer je er het
	laatst op speelde, en of er spells klaarliggen bij de trainer. Later, na een meting: vrije tasplekken, rust-XP en
	raid-locks." So NOT here: bag space, rested XP, raid locks, played time.

	How: a snapshot per character in ns.db.foreverChars[guid] (account-wide SavedVariables), taken a moment after login
	and after a level, money, skill or spell change, and once more at logout. A character shows up only after one login
	with this version: the game tells an addon nothing about characters you are not playing.
	Every field comes from something MH already reads:
	  level/class ............ UnitLevel / UnitClass
	  gold ................... GetMoney
	  professions + skill .... ns.ForeverMyProfessions (ForeverTrainer.lua; client names)
	  direction .............. ns.GetForeverDirection (ForeverDirection.lua)
	  ready at the trainer ... ns.ForeverTrainerCompute(level).now (ForeverTrainer.lua), as it was when you last played
	/mh alts = the window · /mh alts check = what was saved for this character and when · "x" on a row = forget it.
]]

if not ns.IS_FOREVER then
	return
end

local PREFIX = "|cffffcc00Midnight Helper:|r "
local GREY = "|cff9d9d9d"
local W = 780
local ROW_H = 36
local MAX_VISIBLE = 12

local function Readable(v)
	return v ~= nil and not (issecretvalue and issecretvalue(v))
end

local function Store()
	if not ns.db then
		return nil
	end
	ns.db.foreverChars = ns.db.foreverChars or {}
	return ns.db.foreverChars
end

local function MyGUID()
	local g = UnitGUID and UnitGUID("player")
	return Readable(g) and g or nil
end

local function Money(c)
	if C_CurrencyInfo and C_CurrencyInfo.GetCoinTextureString then
		local ok, s = pcall(C_CurrencyInfo.GetCoinTextureString, c)
		if ok and s then
			return s
		end
	end
	if GetCoinTextureString then
		local ok, s = pcall(GetCoinTextureString, c)
		if ok and s then
			return s
		end
	end
	return tostring(c)
end

--------------------------------------------------------------------------------
-- The snapshot
--------------------------------------------------------------------------------
local lastSnap, lastWhy = nil, "not taken yet"

local function Snap(why)
	local store, guid = Store(), MyGUID()
	if not (store and guid) then
		lastWhy = "no saved data or no character id yet"
		return
	end
	local rec = store[guid] or {}
	-- At logout only the time: MEASURED in Rob's SavedVariables, 12 Nov 2026, the logout snapshot saved money 0 and an
	-- empty profession list for all three characters (the game has emptied them by then), over the real values.
	if why == "logout" then
		rec.seen = time and time() or rec.seen
		store[guid] = rec
		lastSnap, lastWhy = rec.seen, why
		return
	end
	-- Forever names have a surname: UnitName gives it as the 2nd value ("Ima", "Pallie"). Measured 7 Nov 2026 for the
	-- layout names (NEXT_SESSION_ARCHIVE), and again 12 Nov: three rows all read "Ima".
	local name, surname = nil, nil
	if UnitName then
		name, surname = UnitName("player")
	end
	if Readable(name) and name ~= "" and name ~= UNKNOWNOBJECT then
		if Readable(surname) and type(surname) == "string" and surname ~= "" then
			name = name .. " " .. surname
		end
		rec.name = name
	end
	local realm = GetRealmName and GetRealmName()
	if Readable(realm) and realm ~= "" then
		rec.realm = realm
	end
	local className, classToken = UnitClass("player")
	if Readable(classToken) then
		rec.class, rec.className = classToken, className
	end
	local level = UnitLevel and UnitLevel("player")
	if Readable(level) and level > 0 then
		rec.level = level
	end
	local money = GetMoney and GetMoney()
	if Readable(money) then
		rec.money = money
	end
	if ns.ForeverMyProfessions then
		local ok, mine = pcall(ns.ForeverMyProfessions)
		if ok and type(mine) == "table" then
			local list = {}
			for key, p in pairs(mine) do
				list[#list + 1] = { key = key, name = p.name, rank = p.rank, max = p.maxRank }
			end
			table.sort(list, function(a, b)
				return (a.rank or 0) > (b.rank or 0)
			end)
			-- An empty reading does not wipe a known list (right after login the client may not have them yet), unless the
			-- game just said the skill lines changed (you really dropped a profession).
			if #list > 0 or not (type(rec.profs) == "table" and #rec.profs > 0) or why == "SKILL_LINES_CHANGED" then
				rec.profs = list
			end
		end
	end
	if ns.GetForeverDirection then
		local ok, band, tree = pcall(ns.GetForeverDirection)
		if ok then
			rec.dir = band and tree or nil
		end
	end
	if ns.ForeverTrainerCompute and rec.level then
		local ok, r = pcall(ns.ForeverTrainerCompute, rec.level)
		if ok and type(r) == "table" and type(r.now) == "table" then
			rec.trainerN, rec.trainerCost = #r.now, r.total
		end
	end
	rec.seen = time and time() or rec.seen
	store[guid] = rec
	lastSnap, lastWhy = rec.seen, why
end

local pending = false
local function SnapSoon(why)
	if pending then
		return
	end
	pending = true
	if C_Timer and C_Timer.After then
		C_Timer.After(2, function()
			pending = false
			Snap(why)
		end)
	else
		pending = false
		Snap(why)
	end
end

local ev = CreateFrame("Frame")
ev:RegisterEvent("PLAYER_ENTERING_WORLD")
ev:RegisterEvent("PLAYER_LEVEL_UP")
ev:RegisterEvent("PLAYER_MONEY")
ev:RegisterEvent("SKILL_LINES_CHANGED")
ev:RegisterEvent("SPELLS_CHANGED")
ev:RegisterEvent("PLAYER_LOGOUT")
ev:SetScript("OnEvent", function(_, event)
	if event == "PLAYER_LOGOUT" then
		pcall(Snap, "logout") -- no timers at logout: now or never
	else
		SnapSoon(event)
	end
end)

--------------------------------------------------------------------------------
-- The window
--------------------------------------------------------------------------------
local win
local rows = {}
local Refresh

local function ClassColor(token)
	local c = token and RAID_CLASS_COLORS and RAID_CLASS_COLORS[token]
	if c and c.r then
		local function b(v)
			return math.floor(math.max(0, math.min(1, v)) * 255 + 0.5)
		end
		return ("|cff%02x%02x%02x"):format(b(c.r), b(c.g), b(c.b))
	end
	return "|cffffffff"
end

local function SeenText(t)
	if not t or not time then
		return "-"
	end
	local now = time()
	-- "now" only for the character you are on (the caller does that); every other one says at least "1 min ago".
	-- 12 Nov: first "now" under 5 minutes (three characters all "now"), then under 2 (29.png: the Shaman "now" while Rob
	-- was on the Warrior). Rob, via sparring: "Ja, zonder toets", on the proposal that tied this line to the key.
	if now - t < 3600 then
		return ns:L("FCHARS_SEEN_MIN_FMT"):format(math.max(1, math.floor((now - t) / 60)))
	end
	local today = date and date("*t", now)
	local then_ = date and date("*t", t)
	if today and then_ then
		local d0 = time({ year = today.year, month = today.month, day = today.day, hour = 12 })
		local d1 = time({ year = then_.year, month = then_.month, day = then_.day, hour = 12 })
		local days = math.floor((d0 - d1) / 86400 + 0.5)
		if days <= 0 then
			return ns:L("FCHARS_SEEN_TODAY")
		elseif days == 1 then
			return ns:L("FCHARS_SEEN_YDAY")
		end
		return ns:L("FCHARS_SEEN_DAYS_FMT"):format(days)
	end
	return "-"
end

local function ProfText(rec)
	if type(rec.profs) ~= "table" then
		return "-"
	end
	if #rec.profs == 0 then
		return ns:L("FCHARS_NO_PROFS")
	end
	local parts = {}
	for _, p in ipairs(rec.profs) do
		local nm = p.name or p.key or "?"
		if p.rank and p.max then
			parts[#parts + 1] = ("%s %d/%d"):format(nm, p.rank, p.max)
		elseif p.rank then
			parts[#parts + 1] = ("%s %d"):format(nm, p.rank)
		else
			parts[#parts + 1] = nm
		end
	end
	return table.concat(parts, ", ")
end

--- Sorted list of { guid, rec }: this character first, then by last played.
local function Sorted()
	local store, me = Store() or {}, MyGUID()
	local list = {}
	for guid, rec in pairs(store) do
		if type(rec) == "table" then
			list[#list + 1] = { guid = guid, rec = rec }
		end
	end
	table.sort(list, function(a, b)
		if a.guid == me then
			return true
		elseif b.guid == me then
			return false
		end
		return (a.rec.seen or 0) > (b.rec.seen or 0)
	end)
	return list
end

-- Column x positions inside a row (line 1). Line 2 = professions, across the whole row.
-- 12 Nov (Rob's 24-26.png): "level 7..." was cut off; the character column got 30 px more, gold 20 less.
local COLS = { char = 8, gold = 280, dir = 400, seen = 525, trainer = 630 }
local CHAR_W, GOLD_W, DIR_W, SEEN_W = 266, 110, 120, 100

local function Cell(parent, x, w, font, justify)
	local fs = parent:CreateFontString(nil, "OVERLAY", font or "GameFontHighlightSmall")
	fs:SetPoint("TOPLEFT", x, -4)
	fs:SetWidth(w)
	fs:SetJustifyH(justify or "LEFT")
	fs:SetWordWrap(false)
	return fs
end

local function Row(i)
	if rows[i] then
		return rows[i]
	end
	local r = CreateFrame("Frame", nil, win.content)
	r:SetHeight(ROW_H)
	r.bg = r:CreateTexture(nil, "BACKGROUND")
	r.bg:SetAllPoints()
	r.bg:SetColorTexture(1, 1, 1, (i % 2 == 0) and 0.04 or 0)
	r.char = Cell(r, COLS.char, CHAR_W, "GameFontNormalSmall")
	r.gold = Cell(r, COLS.gold, GOLD_W, nil, "RIGHT")
	r.dir = Cell(r, COLS.dir, DIR_W)
	r.seen = Cell(r, COLS.seen, SEEN_W)
	r.trainer = Cell(r, COLS.trainer, 70) -- ends before the forget button (row 726 px, button 22 px at the right)
	r.profs = r:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
	r.profs:SetPoint("TOPLEFT", COLS.char, -20)
	r.profs:SetWidth(W - 90)
	r.profs:SetJustifyH("LEFT")
	r.profs:SetWordWrap(false)
	r.forget = CreateFrame("Button", nil, r, "UIPanelCloseButton")
	r.forget:SetSize(22, 22)
	r.forget:SetPoint("TOPRIGHT", -2, -2)
	r.forget:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(self, "ANCHOR_LEFT")
		GameTooltip:SetText(ns:L("FCHARS_FORGET_TIP"), 1, 1, 1, 1, true)
		GameTooltip:Show()
	end)
	r.forget:SetScript("OnLeave", function()
		GameTooltip:Hide()
	end)
	r.forget:SetScript("OnClick", function(self)
		local store = Store()
		if store and self.guid then
			local nm = store[self.guid] and store[self.guid].name or "?"
			store[self.guid] = nil
			print(PREFIX .. ns:L("FCHARS_FORGOT_FMT"):format(nm))
		end
		Refresh()
	end)
	rows[i] = r
	return r
end

local function Build()
	if win then
		return win
	end
	local f = CreateFrame("Frame", "MidnightHelperForeverChars", UIParent, "BackdropTemplate")
	f:SetSize(W, 200)
	f:SetPoint("CENTER")
	f:SetFrameStrata("DIALOG")
	f:SetClampedToScreen(true)
	f:SetMovable(true)
	f:EnableMouse(true)
	f:RegisterForDrag("LeftButton")
	f:SetScript("OnDragStart", f.StartMoving)
	f:SetScript("OnDragStop", f.StopMovingOrSizing)
	f:SetBackdrop({
		bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
		edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Gold-Border",
		tile = true,
		tileSize = 32,
		edgeSize = 32,
		insets = { left = 11, right = 12, top = 12, bottom = 11 },
	})
	f:SetBackdropColor(1, 1, 1, 0.95)

	f.title = f:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
	f.title:SetPoint("TOP", 0, -18)
	local x = CreateFrame("Button", nil, f, "UIPanelCloseButton")
	x:SetPoint("TOPRIGHT", -6, -6)

	-- Column heads
	f.heads = {}
	local function Head(key, col, w, justify)
		local fs = f:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
		fs:SetPoint("TOPLEFT", 18 + col, -46)
		fs:SetWidth(w)
		fs:SetJustifyH(justify or "LEFT")
		fs:SetWordWrap(false)
		fs.key = key
		f.heads[#f.heads + 1] = fs
	end
	Head("FCHARS_COL_CHAR", COLS.char, CHAR_W)
	Head("FCHARS_COL_GOLD", COLS.gold, GOLD_W, "RIGHT")
	Head("FCHARS_COL_DIR", COLS.dir, DIR_W)
	Head("FCHARS_COL_SEEN", COLS.seen, SEEN_W)
	Head("FCHARS_COL_TRAINER", COLS.trainer, 100)

	local scroll = CreateFrame("ScrollFrame", nil, f, "UIPanelScrollFrameTemplate")
	scroll:SetPoint("TOPLEFT", 18, -64)
	scroll:SetPoint("BOTTOMRIGHT", -36, 58)
	local content = CreateFrame("Frame", nil, scroll)
	content:SetSize(W - 54, 10)
	scroll:SetScrollChild(content)
	f.scroll, f.content = scroll, content

	f.total = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	f.total:SetPoint("BOTTOMLEFT", 22, 34)
	f.note = f:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
	f.note:SetPoint("BOTTOMLEFT", 22, 18)
	f.note:SetWidth(W - 44)
	f.note:SetJustifyH("LEFT")

	f:Hide()
	win = f
	tinsert(UISpecialFrames, "MidnightHelperForeverChars")
	if ns.RegisterMidnightDialogPopup then
		ns.RegisterMidnightDialogPopup(f)
	end
	return f
end

Refresh = function()
	local f = Build()
	f.title:SetText(ns:L("FCHARS_TITLE"))
	for _, h in ipairs(f.heads) do
		h:SetText(ns:L(h.key))
	end
	local list, me = Sorted(), MyGUID()
	local total = 0
	-- The server name only when your characters are on more than one (Rob's realm name is 22 characters long and pushed
	-- the level out of the column, 24-26.png). Then it goes on the second line, in front of the professions.
	local realms, nRealms = {}, 0
	for _, e in ipairs(list) do
		if e.rec.realm and not realms[e.rec.realm] then
			realms[e.rec.realm] = true
			nRealms = nRealms + 1
		end
	end
	for i, e in ipairs(list) do
		local rec, r = e.rec, Row(i)
		r:ClearAllPoints()
		r:SetPoint("TOPLEFT", 0, -(i - 1) * ROW_H)
		r:SetWidth(W - 54)
		local who = ClassColor(rec.class) .. (rec.name or "?") .. "|r"
		local lvl = rec.level and ns:L("FCHARS_LEVEL_FMT"):format(rec.level, rec.className or rec.class or "") or ""
		r.char:SetText(who .. "  " .. lvl)
		r.gold:SetText(rec.money and Money(rec.money) or "-")
		total = total + (rec.money or 0)
		r.dir:SetText(rec.dir or "-")
		r.seen:SetText(e.guid == me and ns:L("FCHARS_SEEN_NOW") or SeenText(rec.seen))
		if rec.trainerN == nil then
			r.trainer:SetText("-")
		elseif rec.trainerN > 0 then
			r.trainer:SetText("|cff7fff7f" .. ns:L("FCHARS_TRAINER_FMT"):format(rec.trainerN) .. "|r")
		else
			r.trainer:SetText(GREY .. ns:L("FCHARS_TRAINER_NONE") .. "|r")
		end
		local p = ProfText(rec)
		if nRealms > 1 and rec.realm then
			p = rec.realm .. "  ·  " .. p
		end
		r.profs:SetText(p)
		r.forget.guid = e.guid
		r.forget:SetShown(e.guid ~= me) -- this character comes straight back anyway
		r:Show()
	end
	for i = #list + 1, #rows do
		rows[i]:Hide()
	end
	f.content:SetHeight(math.max(10, #list * ROW_H))
	f.total:SetText(ns:L("FCHARS_TOTAL_FMT"):format(Money(total)))
	f.note:SetText(ns:L("FCHARS_NOTE"))
	local visible = math.min(math.max(#list, 1), MAX_VISIBLE)
	f:SetHeight(64 + visible * ROW_H + 64)
end

function ns.ShowForeverChars()
	Snap("opened the window")
	Refresh()
	win:Show()
end

--- /mh alts · /mh alts check
function ns.ForeverCharsSlash(arg)
	arg = (arg or ""):lower()
	if arg == "check" or arg == "why" then
		local store, guid = Store() or {}, MyGUID()
		local n = 0
		for _ in pairs(store) do
			n = n + 1
		end
		print(PREFIX .. ("characters: %d saved; this one %s; last snapshot: %s (%s)"):format(n,
			(guid and store[guid]) and "saved" or "NOT saved", lastSnap and date and date("%H:%M:%S", lastSnap) or "none",
			lastWhy))
		local rec = guid and store[guid]
		if rec then
			print(("  level %s %s, gold %s, %d profession(s), direction %s, trainer %s"):format(tostring(rec.level),
				tostring(rec.class), tostring(rec.money), type(rec.profs) == "table" and #rec.profs or -1,
				tostring(rec.dir), tostring(rec.trainerN)))
		end
		return
	end
	if win and win:IsShown() then
		win:Hide()
		return
	end
	ns.ShowForeverChars()
end
