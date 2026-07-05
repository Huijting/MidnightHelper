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
	if Enabled() then
		-- Detector (UNIT_HEALTH, niet-protected) opstarten in een schone context via C_Timer.
		if C_Timer and C_Timer.After and ns._mhGroundInitCLEU then
			C_Timer.After(0, ns._mhGroundInitCLEU)
		end
	else
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
-- Detectie — health-heuristiek (Plan A, 2026-07-05). CLEU (Plan B) bleek definitief
-- FORBIDDEN voor MH: RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED") geeft onafvangbaar
-- ADDON_ACTION_FORBIDDEN (protected functie, getainte addon). Daarom CLEU-VRIJ:
-- luister op UNIT_HEALTH("player") en detecteer snelle, HERHAALDE HP-daling.
--   • UnitHealth/UnitHealthMax zijn niet-protected, en niet-secret voor de speler; toch
--     guarden we met issecretvalue (in M+/edge-cases kan health secret zijn → dan niet rekenen).
--   • ≥N schade-"ticks" (elk ≥HP%) binnen het venster → "je staat in iets" → MOVE!-flits.
--   • Eerlijk: grover dan CLEU — kan ook afgaan bij melee/sterke DoT (geen manier om
--     grondeffect te onderscheiden zonder de verboden combat log). Drempels afstelbaar.
--------------------------------------------------------------------------------

local hpRegistered = false
local prevHP
local tickTimes = {}
local lastTickTime = 0
local lastFlash = 0
local dangerOn = false

local WINDOW = 3.0 -- glijdend venster (s)
local NEED_TICKS = 2 -- ≥ dit aantal schade-ticks in het venster → alarm
local FLASH_THROTTLE = 1.2 -- min. tijd tussen nieuwe alarm-triggers (s)
local CLEAR_AFTER = 1.5 -- geen schade meer voor deze tijd → gevaar voorbij (s)
local HP_PCT_MIN = 0.01 -- HP-daling telt alleen als ≥ 1% van max-HP

local function GSDebugOn()
	return ns.db and ns.db.ui and ns.db.ui.groundSafetyDebug and true or false
end

local _gsSecretPrinted = false
local function GSDbg(msg)
	print("|cff66ff66MH GS|r " .. msg)
end

local function OnHealth()
	if not Enabled() then
		return
	end
	-- Alleen CURRENT health nodig (geen UnitHealthMax → die is in delves vaak "secret"). We meten
	-- de fractie van je HUIDIGE HP die je per tik verliest, dus max is niet nodig.
	local cur = UnitHealth and UnitHealth("player")
	if not cur then
		return
	end
	if issecretvalue and issecretvalue(cur) then
		if GSDebugOn() and not _gsSecretPrinted then
			_gsSecretPrinted = true
			GSDbg("current player-health is SECRET in deze context → detectie onmogelijk hier.")
		end
		prevHP = nil
		return
	end
	local now = GetTime()
	if prevHP and prevHP > 0 and cur < prevHP then
		local pct = (prevHP - cur) / prevHP -- fractie van je HUIDIGE HP verloren (geen max nodig)
		local counts = pct >= HP_PCT_MIN
		if GSDebugOn() then
			GSDbg(("schade %.2f%% van huidige HP | telt mee=%s (drempel %.0f%%)"):format(
				pct * 100, counts and "JA" or "nee", HP_PCT_MIN * 100))
		end
		if counts then
			tickTimes[#tickTimes + 1] = now
			lastTickTime = now
			-- Venster opschonen + tellen (in-place compacteren).
			local cutoff = now - WINDOW
			local n = 0
			for i = 1, #tickTimes do
				if tickTimes[i] >= cutoff then
					n = n + 1
					tickTimes[n] = tickTimes[i]
				end
			end
			for i = #tickTimes, n + 1, -1 do
				tickTimes[i] = nil
			end
			if GSDebugOn() then
				GSDbg(("  ticks in %.0fs-venster: %d/%d nodig"):format(WINDOW, n, NEED_TICKS))
			end
			if n >= NEED_TICKS and not dangerOn and (now - lastFlash) >= FLASH_THROTTLE then
				dangerOn = true
				lastFlash = now
				ns.SetGroundDanger(true)
				if GSDebugOn() then
					GSDbg("→ OPZIJ! GETRIGGERD")
				end
			end
		end
	end
	prevHP = cur
end

-- CLEU-VRIJ: UNIT_HEALTH is niet-protected, dus RegisterUnitEvent is toegestaan (i.t.t. CLEU).
local function EnsureDetector()
	if hpRegistered or not Enabled() then
		return
	end
	local f = CreateFrame("Frame")
	f:SetScript("OnEvent", OnHealth)
	f:SetScript("OnUpdate", function()
		-- Geen schade meer → gevaar voorbij → flits uitzetten.
		if dangerOn and (GetTime() - lastTickTime) > CLEAR_AFTER then
			dangerOn = false
			ns.SetGroundDanger(false)
		end
	end)
	f:RegisterUnitEvent("UNIT_HEALTH", "player")
	hpRegistered = true
end
ns._mhGroundInitCLEU = EnsureDetector -- (naam behouden voor de enable-hook)

-- Bij login: alleen aanzetten als de feature al AAN stond.
local initFrame = CreateFrame("Frame")
initFrame:RegisterEvent("PLAYER_LOGIN")
initFrame:SetScript("OnEvent", function()
	if Enabled() then
		EnsureDetector()
	end
end)

--------------------------------------------------------------------------------
-- /mhgsdebug — diagnose: print per schade-tik + rapporteer detector-status/drempels
--------------------------------------------------------------------------------

SLASH_MHGSDEBUG1 = "/mhgsdebug"
SlashCmdList["MHGSDEBUG"] = function()
	local uiDb = ns.db and ns.db.ui
	if type(uiDb) ~= "table" then
		print("|cff66ff66MH GS|r db nog niet klaar — log eerst volledig in en probeer opnieuw.")
		return
	end
	uiDb.groundSafetyDebug = not uiDb.groundSafetyDebug and true or false
	_gsSecretPrinted = false
	-- Zorg dat de detector draait (feature aan maar detector nog niet geregistreerd).
	if Enabled() and not hpRegistered then
		EnsureDetector()
	end
	print(("|cff66ff66MH GS|r debug %s. Feature=%s · detector-geregistreerd=%s · drempel: %d ticks / %.0fs, elk ≥%.0f%% huidige HP. Ga in een grondeffect staan; je hoort per schade-tik een regel te zien (of 'health is SECRET')."):format(
		uiDb.groundSafetyDebug and "AAN" or "UIT",
		Enabled() and "aan" or "UIT (zet 'Toon OPZIJ!' eerst aan!)",
		hpRegistered and "ja" or "NEE",
		NEED_TICKS, WINDOW, HP_PCT_MIN * 100))
end
