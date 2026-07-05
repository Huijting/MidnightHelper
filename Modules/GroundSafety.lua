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
		-- CLEU-registratie in een SCHONE context (via C_Timer, NIET vanuit deze klik zelf) —
		-- dat "dynamisch registreren vanuit een UI-actie" was vermoedelijk de oude forbidden-oorzaak.
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
-- Detectie — CLEU tick-detector (Rob's keuze B, 2026-07-05), 12.x-VOORZICHTIG
--
-- MH kreeg ooit 8× ADDON_ACTION_FORBIDDEN van CLEU (onafvangbaar) → daarom:
--   1. een EIGEN, schoon niet-secure frame puur voor CLEU (nergens secure/secret);
--   2. CLEU alléén registreren als de feature AAN is (opt-in) en dan geregistreerd LATEN
--      (geen dynamisch her-registreren); de eerste registratie loopt via C_Timer (schone context);
--   3. de handler raakt GEEN protected functies en GEEN secret waarden als key/branch aan:
--      alleen niet-secret CLEU-velden, met issecretvalue-guard; GEEN spell-ID als table-key
--      (puur ticks tellen); destGUID==speler is veilig (player-GUID niet secret; secret
--      destGUID = vijand → skip). Bron: onderzoek + DBM (CLEU werkt technisch in 12.x).
--------------------------------------------------------------------------------

local cleuFrame
local cleuRegistered = false
local tickTimes = {}
local lastTickTime = 0
local lastFlash = 0
local dangerOn = false

local WINDOW = 2.0 -- glijdend venster (s)
local NEED_TICKS = 3 -- ≥ dit aantal ticks in het venster → "je staat ergens in"
local FLASH_THROTTLE = 1.2 -- min. tijd tussen nieuwe alarm-triggers (s)
local CLEAR_AFTER = 1.0 -- geen tick meer voor deze tijd → gevaar voorbij (s)
local HP_PCT_MIN = 0.02 -- tik telt alleen mee als ≥ 2% van max-HP (indien amount leesbaar)

local function OnCLEU()
	if not Enabled() then
		return
	end
	-- 15 velden: 2=subevent, 8=destGUID, 15=amount (voor SPELL_PERIODIC_DAMAGE). Geen spellId gebruikt.
	local _, sub, _, _, _, _, _, destGUID, _, _, _, _, _, _, amount = CombatLogGetCurrentEventInfo()
	if sub ~= "SPELL_PERIODIC_DAMAGE" then
		return
	end
	-- destGUID moet de speler zijn. Secret destGUID = een vijand → skip (player-GUID is niet secret).
	if issecretvalue and issecretvalue(destGUID) then
		return
	end
	if destGUID ~= UnitGUID("player") then
		return
	end
	-- HP%-drempel: verwaarloosbare tikjes negeren (alleen als amount leesbaar + niet-secret is).
	if amount ~= nil and type(amount) == "number" and not (issecretvalue and issecretvalue(amount)) then
		local maxhp = UnitHealthMax and UnitHealthMax("player") or 0
		if maxhp > 0 and (amount / maxhp) < HP_PCT_MIN then
			return
		end
	end
	local now = GetTime()
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
	if n >= NEED_TICKS and not dangerOn and (now - lastFlash) >= FLASH_THROTTLE then
		dangerOn = true
		lastFlash = now
		ns.SetGroundDanger(true)
	end
end

local function EnsureCLEU()
	if cleuRegistered or not Enabled() then
		return
	end
	cleuFrame = CreateFrame("Frame") -- schoon, los frame; raakt nooit een secure/secret waarde
	cleuFrame:SetScript("OnEvent", OnCLEU)
	cleuFrame:SetScript("OnUpdate", function()
		-- Geen tick meer → gevaar voorbij → flits uitzetten.
		if dangerOn and (GetTime() - lastTickTime) > CLEAR_AFTER then
			dangerOn = false
			ns.SetGroundDanger(false)
		end
	end)
	cleuFrame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	cleuRegistered = true
end
ns._mhGroundInitCLEU = EnsureCLEU

-- Bij login: alleen registreren als de feature al AAN stond (schone context, à la DBM).
local initFrame = CreateFrame("Frame")
initFrame:RegisterEvent("PLAYER_LOGIN")
initFrame:SetScript("OnEvent", function()
	if Enabled() then
		EnsureCLEU()
	end
end)
