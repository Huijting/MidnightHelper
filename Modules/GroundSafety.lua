--[[
	Ground Safety — Feature C: "je staat in de stront / MOVE!" (Rob-wens 5 jul 2026).

	Grote, versleegbare "MOVE!"-flits midden op het scherm zodra je herhaald schade neemt uit
	een grondeffect (de dingen op de grond waar je snel uit moet). Dit vult Feature A aan:
	Feature A = "een cast is op JOU gericht", Feature C = "je staat in schade" (geen doelwit-cast).

	⚠️ De DETECTIE (combat-log / aura) is 12.x secret-value-gevoelig en wordt pas ingevuld na het
	onderzoek (agent). Deze module bevat NU alleen het (secret-onafhankelijke) visuele deel +
	settings + preview + de publieke haken die de detectie straks aanroept:
	  ns.SetGroundDanger(active)  → true = gevaar (blijf flitsen), false = veilig (doof uit)
	  ns.FlashGroundWarning(sec)  → eenmalige flits van N seconden (voor preview/test)
	Alles hieronder raakt GEEN secret waarden. Bron/mockup: docs/combatsafety_mockup.html.
]]

local _, ns = ...

local frame
local _active = false -- aanhoudend gevaar (detectie zet dit)
local _flashUntil = 0 -- eenmalige flits tot dit tijdstip

--------------------------------------------------------------------------------
-- Settings
--------------------------------------------------------------------------------

local function Enabled()
	local uiDb = ns.db and ns.db.ui
	if type(uiDb) ~= "table" then
		return false -- Feature C standaard UIT tot 'ie getest is
	end
	return uiDb.groundSafety == true
end

function ns.IsGroundSafetyEnabled()
	return Enabled()
end

function ns.SetGroundSafetyEnabled(v)
	local uiDb = ns.db and ns.db.ui
	if type(uiDb) == "table" then
		uiDb.groundSafety = v and true or false
	end
	if not Enabled() then
		_active = false
		_flashUntil = 0
		if frame then
			frame:Hide()
		end
	end
end

--------------------------------------------------------------------------------
-- Visueel: grote "MOVE!"-flits (versleepbaar, schaalbaar; niet-secure)
--------------------------------------------------------------------------------

local function EnsureFrame()
	if frame then
		return frame
	end
	local f = CreateFrame("Button", "MidnightHelperGroundSafety", UIParent)
	f:SetSize(360, 120)
	f:SetFrameStrata("HIGH")
	f:SetClampedToScreen(true)
	f:EnableMouse(false) -- display-only; verplaatsen gaat via de preview (mouse aan)
	f:RegisterForDrag("LeftButton")
	f:SetMovable(true)

	local pos = ns.db and ns.db.ui and ns.db.ui.groundSafetyPos
	if type(pos) == "table" and pos[1] then
		f:SetPoint(pos[1], UIParent, pos[2] or pos[1], pos[3] or 0, pos[4] or 0)
	else
		f:SetPoint("CENTER", UIParent, "CENTER", 0, 140)
	end
	if ns.db and ns.db.ui and ns.db.ui.groundSafetyScale then
		f:SetScale(ns.db.ui.groundSafetyScale)
	end

	local move = f:CreateFontString(nil, "OVERLAY", "GameFontNormalHuge")
	move:SetPoint("TOP", f, "TOP", 0, -6)
	move:SetTextColor(1, 0.18, 0.18)
	move:SetText(ns:L("GS_MOVE"))
	if move.SetFont then
		local file = move:GetFont()
		pcall(move.SetFont, move, file, 64, "THICKOUTLINE")
	end
	f._move = move

	local sub = f:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
	sub:SetPoint("TOP", move, "BOTTOM", 0, -4)
	sub:SetTextColor(1, 0.82, 0.3)
	sub:SetText(ns:L("GS_SUB"))
	f._sub = sub

	f:SetScript("OnDragStart", function(self)
		self:StartMoving()
	end)
	f:SetScript("OnDragStop", function(self)
		self:StopMovingOrSizing()
		local p, _, rp, x, y = self:GetPoint()
		if p and ns.db and ns.db.ui then
			ns.db.ui.groundSafetyPos = { p, rp, x, y }
		end
	end)
	f:EnableMouseWheel(true)
	f:SetScript("OnMouseWheel", function(self, delta)
		if not IsShiftKeyDown() then
			return
		end
		local s = math.max(0.5, math.min(2.5, (self:GetScale() or 1) + (delta > 0 and 0.1 or -0.1)))
		self:SetScale(s)
		if ns.db and ns.db.ui then
			ns.db.ui.groundSafetyScale = s
		end
	end)

	-- Puls (schaal + alpha) via OnUpdate; verbergt zichzelf als er geen gevaar/flits is.
	f:SetScript("OnUpdate", function(self, elapsed)
		local show = _active or (GetTime() < _flashUntil)
		if not show then
			if self:IsShown() then
				self:Hide()
			end
			return
		end
		self._t = (self._t or 0) + elapsed
		local pulse = 0.5 + 0.5 * (0.5 + 0.5 * math.sin(self._t * 6))
		self._move:SetAlpha(0.55 + 0.45 * pulse)
	end)
	f:Hide()
	frame = f
	return f
end

-- Detectie-haak: aanhoudend gevaar aan/uit.
function ns.SetGroundDanger(active)
	if not Enabled() then
		return
	end
	_active = active and true or false
	local f = EnsureFrame()
	if _active then
		f:Show()
	elseif GetTime() >= _flashUntil then
		f:Hide()
	end
end

-- Eenmalige flits (preview/test), N seconden.
function ns.FlashGroundWarning(sec)
	local f = EnsureFrame()
	_flashUntil = GetTime() + (tonumber(sec) or 2)
	f:Show()
end

--------------------------------------------------------------------------------
-- Preview (Settings-knop): toggle een blijvende, SLEEPBARE MOVE!-flits om te plaatsen
--------------------------------------------------------------------------------

local _previewOn = false

function ns.TestGroundSafety()
	local f = EnsureFrame()
	if _previewOn then
		_previewOn = false
		f:EnableMouse(false)
		_flashUntil = 0
		if not _active then
			f:Hide()
		end
		return
	end
	_previewOn = true
	f:EnableMouse(true) -- sleepbaar in preview
	_flashUntil = GetTime() + 3600 -- blijft staan tot je 'm weer uitklikt
	f:Show()
end

--------------------------------------------------------------------------------
-- Detectie — STUB (wordt ingevuld na het 12.x-onderzoek: combat-log tick-detectie
-- of speler-aura, met HP%-drempel + throttle). Nu bewust nog GEEN detectie, zodat
-- er geen valse alarmen zijn; alleen de preview/test toont de flits.
--------------------------------------------------------------------------------

-- TODO(feature-C): registreer detectie-events en roep ns.SetGroundDanger(true/false) aan.
