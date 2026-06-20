--[[
	Consumable Ready Board — Fase 3 visuele laag (Rob, 20 jun 2026).

	Zwevend bordje dat automatisch verschijnt bij dungeon-entry (zelfde patroon
	als DungeonBossWindow): één rij per groepslid met ready-check-iconen per
	consumable. Sleepbaar, positie opgeslagen in ns.db.ui.consumableBoard.
	Verbergt zichzelf bij de pull (ENCOUNTER_START) of na een korte timer.

	Data komt uit ns.GetConsumableReadyData() — dezelfde bron als de chat-versie,
	dus geen losse logica/never-lie-afwijking. Iconen: Blizzard ReadyCheck-
	texturen (groen = aanwezig/actief, rood = ontbreekt, geel = onbekend; amber-
	getint groen = je hebt een alternate i.p.v. de aanbevolen best).
]]

local _, ns = ...

local READY = "Interface\\RAIDFRAME\\ReadyCheck-Ready"
local NOTREADY = "Interface\\RAIDFRAME\\ReadyCheck-NotReady"
local WAITING = "Interface\\RAIDFRAME\\ReadyCheck-Waiting"

local MAX_ROWS = 5
local ROW_H = 18
local HEADER_Y = -50
local ICON = 13
local W = 410
local AUTO_HIDE_SEC = 25
local MIN_SCALE, MAX_SCALE = 0.7, 1.6

-- Icoon-kolommen (x-offset vanaf links). Flask/rune hebben twee iconen (tas +
-- buff); de rest één. Ruimer uitgelegd zodat de korte koppen niet botsen.
local COLS = {
	flaskBag = 137,
	flaskBuff = 151,
	runeBag = 183,
	runeBuff = 197,
	cpot = 235,
	hpot = 281,
	food = 327,
	hs = 373,
}
-- Kop-labels (korte, gecentreerde abbreviaties boven de kolommen).
local HEADERS = {
	{ key = "CONSREADY_COL_FLASK", x = 144 },
	{ key = "CONSREADY_COL_RUNE", x = 190 },
	{ key = "CONSREADY_COL_CPOT", x = 235 },
	{ key = "CONSREADY_COL_HPOT", x = 281 },
	{ key = "CONSREADY_COL_FOOD", x = 327 },
	{ key = "CONSREADY_COL_HS", x = 373 },
}

local board

local function GetWinSettings()
	if not (ns.db and ns.db.ui) then
		return {}
	end
	if type(ns.db.ui.consumableBoard) ~= "table" then
		ns.db.ui.consumableBoard = {}
	end
	return ns.db.ui.consumableBoard
end

local function CurScale()
	local s = GetWinSettings()
	local sc = tonumber(s.scale) or 1
	if sc < MIN_SCALE then
		sc = MIN_SCALE
	elseif sc > MAX_SCALE then
		sc = MAX_SCALE
	end
	return sc
end

-- Schaal-onafhankelijke positie (toast-/boss-venster-recept): offset t.o.v.
-- UIParent-center in UI-coördinaten; SetPoint-offsets zijn frame-lokaal
-- (geschaald) → delen door de schaal.
local function ApplySavedPosition(f)
	local s = GetWinSettings()
	local scale = f:GetScale() or 1
	f:ClearAllPoints()
	if tonumber(s.x) and tonumber(s.y) and UIParent then
		f:SetPoint("CENTER", UIParent, "CENTER", s.x / scale, s.y / scale)
	else
		f:SetPoint("CENTER", UIParent, "CENTER", 280 / scale, 120 / scale)
	end
end

local function SavePosition(f)
	local s = GetWinSettings()
	local scale = f:GetScale() or 1
	local cx, cy = f:GetCenter()
	if cx and cy and UIParent then
		s.x = cx * scale - (UIParent:GetWidth() / 2)
		s.y = cy * scale - (UIParent:GetHeight() / 2)
	end
end

local function SetStatus(tex, state)
	tex:SetVertexColor(1, 1, 1)
	if state == true or state == "best" then
		tex:SetTexture(READY)
	elseif state == "alt" then
		tex:SetTexture(READY)
		tex:SetVertexColor(1, 0.82, 0.35) -- amber: alternate i.p.v. de best
	elseif state == false then
		tex:SetTexture(NOTREADY)
	else
		tex:SetTexture(WAITING) -- nil = onbekend
	end
	tex:Show()
end

local function NewIcon(parent, x, y, size)
	local t = parent:CreateTexture(nil, "ARTWORK")
	t:SetSize(size or ICON, size or ICON)
	t:SetPoint("CENTER", parent, "TOPLEFT", x, y)
	t:Hide()
	return t
end

local function EnsureBoard()
	if board then
		return board
	end
	local f = CreateFrame("Frame", "MidnightHelperConsumableBoard", UIParent, "BackdropTemplate")
	f:SetSize(W, 120)
	f:SetFrameStrata("MEDIUM")
	f:SetClampedToScreen(true)
	f:EnableMouse(true)
	f:SetMovable(true)
	f:RegisterForDrag("LeftButton")
	f:SetScript("OnDragStart", function()
		f:StartMoving()
	end)
	f:SetScript("OnDragStop", function()
		f:StopMovingOrSizing()
		SavePosition(f)
	end)
	if f.SetBackdrop then
		f:SetBackdrop({
			bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background-Dark",
			edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Gold-Border",
			tile = true,
			tileSize = 32,
			edgeSize = 24,
			insets = { left = 8, right = 8, top = 8, bottom = 8 },
		})
		f:SetBackdropColor(0.05, 0.05, 0.09, 0.95)
	end
	f:SetScale(CurScale())
	f:Hide()
	ApplySavedPosition(f)

	-- SHIFT+scroll = zoomen (zoals het boss-venster). Gewone scroll laten we met
	-- rust. We bewaren de plek in UI-coördinaten, schalen, en zetten 'm terug op
	-- dezelfde schermplek.
	f:EnableMouseWheel(true)
	f:SetScript("OnMouseWheel", function(_, delta)
		if not IsShiftKeyDown() then
			return
		end
		local st = GetWinSettings()
		local sc = CurScale() + (delta > 0 and 0.1 or -0.1)
		if sc < MIN_SCALE then
			sc = MIN_SCALE
		elseif sc > MAX_SCALE then
			sc = MAX_SCALE
		end
		st.scale = sc
		SavePosition(f)
		f:SetScale(sc)
		ApplySavedPosition(f)
	end)

	local title = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	title:SetPoint("TOPLEFT", f, "TOPLEFT", 14, -12)
	title:SetPoint("RIGHT", f, "RIGHT", -28, 0)
	title:SetJustifyH("LEFT")
	title:SetTextColor(1, 0.82, 0.2)
	f._title = title

	local close = CreateFrame("Button", nil, f, "UIPanelCloseButton")
	close:SetPoint("TOPRIGHT", f, "TOPRIGHT", -4, -4)
	close:SetScript("OnClick", function()
		f:Hide()
	end)

	-- Kop-labels.
	for _, h in ipairs(HEADERS) do
		local fs = f:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
		fs:SetPoint("CENTER", f, "TOPLEFT", h.x, -34)
		fs:SetText(ns:L(h.key))
		fs:SetTextColor(0.7, 0.68, 0.62)
		h._fs = fs
	end

	-- Rij-widgets (vooraf aangemaakt, gevuld/verborgen per render).
	f._rows = {}
	for i = 1, MAX_ROWS do
		local y = HEADER_Y - (i - 1) * ROW_H
		local name = f:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
		name:SetPoint("LEFT", f, "TOPLEFT", 14, y)
		name:SetJustifyH("LEFT")
		name:SetWidth(108)
		local row = {
			name = name,
			flaskBag = NewIcon(f, COLS.flaskBag, y),
			flaskBuff = NewIcon(f, COLS.flaskBuff, y, ICON - 2),
			runeBag = NewIcon(f, COLS.runeBag, y),
			runeBuff = NewIcon(f, COLS.runeBuff, y, ICON - 2),
			cpot = NewIcon(f, COLS.cpot, y),
			hpot = NewIcon(f, COLS.hpot, y),
			food = NewIcon(f, COLS.food, y),
			hs = NewIcon(f, COLS.hs, y),
		}
		f._rows[i] = row
	end

	local hint = f:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
	hint:SetPoint("BOTTOMLEFT", f, "BOTTOMLEFT", 14, 10)
	hint:SetText(ns:L("CONSREADY_BOARD_HINT"))
	hint:SetTextColor(0.55, 0.54, 0.5)
	f._hint = hint

	board = f
	return f
end

local function ClassColorName(name, classToken)
	local color = classToken and RAID_CLASS_COLORS and RAID_CLASS_COLORS[classToken]
	if color and color.colorStr then
		return "|c" .. color.colorStr .. (name or "?") .. "|r"
	end
	return name or "?"
end

local function Render()
	local f = EnsureBoard()
	local data = ns.GetConsumableReadyData and ns.GetConsumableReadyData() or { rows = {} }

	if f._title then
		local d = data.dungeon
		f._title:SetText(
			(d and d ~= "") and ns:L("CONSREADY_HEADER_FMT"):format(d) or ns:L("CONSREADY_HEADER")
		)
	end

	local used = 0
	for i = 1, MAX_ROWS do
		local row = f._rows[i]
		local entry = data.rows[i]
		if entry then
			used = used + 1
			row.name:SetText(ClassColorName(entry.name, entry.classToken))
			row.name:Show()
			SetStatus(row.flaskBag, entry.flask and entry.flask.bag)
			SetStatus(row.flaskBuff, entry.flask and entry.flask.buff)
			SetStatus(row.runeBag, entry.rune and entry.rune.bag)
			SetStatus(row.runeBuff, entry.rune and entry.rune.buff)
			SetStatus(row.cpot, entry.cpot and entry.cpot.bag)
			SetStatus(row.hpot, entry.hpot and entry.hpot.bag)
			SetStatus(row.food, entry.food and entry.food.bag)
			SetStatus(row.hs, entry.hs and entry.hs.bag)
		else
			row.name:Hide()
			for _, key in ipairs({ "flaskBag", "flaskBuff", "runeBag", "runeBuff", "cpot", "hpot", "food", "hs" }) do
				row[key]:Hide()
			end
		end
	end

	local h = (-HEADER_Y) + math.max(1, used) * ROW_H + 24
	f:SetHeight(h)
end

local hideTimer

function ns.ShowConsumableBoard()
	local f = EnsureBoard()
	Render()
	f:Show()
	if hideTimer and hideTimer.Cancel then
		pcall(hideTimer.Cancel, hideTimer)
	end
	if C_Timer and C_Timer.NewTimer then
		hideTimer = C_Timer.NewTimer(AUTO_HIDE_SEC, function()
			if board then
				board:Hide()
			end
		end)
	end
end

function ns.HideConsumableBoard()
	if board then
		board:Hide()
	end
end

function ns.RefreshConsumableBoard()
	if board and board:IsShown() then
		Render()
	end
end

-- Verbergen bij de pull; live verversen als auras/comms veranderen terwijl het
-- bord open staat.
local ev = CreateFrame("Frame")
ev:RegisterEvent("ENCOUNTER_START")
ev:RegisterEvent("UNIT_AURA")
ev:SetScript("OnEvent", function(_, event)
	if event == "ENCOUNTER_START" then
		ns.HideConsumableBoard()
	elseif event == "UNIT_AURA" then
		ns.RefreshConsumableBoard()
	end
end)
