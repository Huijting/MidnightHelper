--[[
	Combat Safety — Feature A: "gevaarlijke cast op JOU" (Rob-wens 4 jul 2026).

	Toont een versleepbaar waarschuwings-icoon met rode gloed + cooldown-swipe zodra een
	vijand een BELANGRIJKE spell cast die de speler als doelwit heeft.

	⚠️ WoW 12.x "secret values": cast-info van vijandelijke units (naam/icoon/tijden/
	spellId/interruptbaar) is SECRET — je mag die waarden TONEN maar er NIET op rekenen of
	met if/vergelijking op vertakken (dat geeft "attempt to perform arithmetic on a secret
	value" + taint). Daarom, exact zoals de addon TargetedSpells het doet:
	  • tijd/aftel: NOOIT zelf rekenen → UnitCastingDuration(unit) geeft een DURATION-OBJECT
	    dat direct in Cooldown:SetCooldownFromDurationObject() gaat.
	  • zichtbaarheid: NOOIT `if important/targetsPlayer` → voed die secret-booleans aan de
	    engine-functies frame:SetAlphaFromBoolean() en C_CurveUtil.EvaluateColorValueFromBoolean().
	    De engine bepaalt de alpha (1 = tonen, 0 = onzichtbaar), niet onze Lua-code.
	Detectie-API's (C_Spell.IsSpellImportant / PlayerIsSpellTarget / UnitCasting(Channel)Info /
	UnitCasting(Channel)Duration / SetAlphaFromBoolean / C_CurveUtil) komen 1-op-1 uit de
	geïnstalleerde TargetedSpells (retail 12.0.7). Alles zit in een pcall-vangnet: wijkt een
	API af, dan toont de feature niks (geen error-spam). Rob's /reload = finale check.

	Bewust GEEN eigen spell-database (de valkuil van GTFO). Bron: docs/COMBAT_SAFETY_PLAN.md.

	v1-beperkingen (bewust, secret-value-veilig): geen spell-naam-tekst en geen MOVE!/
	INTERRUPT!-onderscheid (dat vergt vertakken op secret waarden). Eén icoon tegelijk
	(laatste relevante cast). Kan later uitgebreid met een frame-pool à la TargetedSpells.
]]

local _, ns = ...

local frame
local shownUnit

--------------------------------------------------------------------------------
-- Settings
--------------------------------------------------------------------------------

local function Enabled()
	local uiDb = ns.db and ns.db.ui
	if type(uiDb) ~= "table" then
		return true
	end
	return uiDb.combatSafety ~= false
end

function ns.IsCombatSafetyEnabled()
	return Enabled()
end

function ns.SetCombatSafetyEnabled(v)
	local uiDb = ns.db and ns.db.ui
	if type(uiDb) == "table" then
		uiDb.combatSafety = v and true or false
	end
	ns.RefreshCombatSafety()
end

-- Gesproken cast-naam (TTS) — standaard UIT (opt-in).
local function SpeakEnabled()
	local uiDb = ns.db and ns.db.ui
	return type(uiDb) == "table" and uiDb.combatSafetySpeak == true
end

function ns.IsCombatSafetySpeakEnabled()
	return SpeakEnabled()
end

function ns.SetCombatSafetySpeakEnabled(v)
	local uiDb = ns.db and ns.db.ui
	if type(uiDb) == "table" then
		uiDb.combatSafetySpeak = v and true or false
	end
end

--------------------------------------------------------------------------------
-- Frame (versleepbaar, schaalbaar; niet-secure → geen combat-beperkingen)
--------------------------------------------------------------------------------

local STATIC_ICON = "Interface\\Icons\\Spell_Fire_Incinerate"

local function EnsureFrame()
	if frame then
		return frame
	end
	local f = CreateFrame("Button", "MidnightHelperCombatSafety", UIParent)
	f:SetSize(210, 52)
	f:SetFrameStrata("HIGH")
	f:SetClampedToScreen(true)
	f:EnableMouse(true)
	f:RegisterForDrag("LeftButton")
	f:SetMovable(true)

	local pos = ns.db and ns.db.ui and ns.db.ui.combatSafetyPos
	if type(pos) == "table" and pos[1] then
		f:SetPoint(pos[1], UIParent, pos[2] or pos[1], pos[3] or 0, pos[4] or 0)
	else
		f:SetPoint("CENTER", UIParent, "CENTER", 0, 220)
	end
	if ns.db and ns.db.ui and ns.db.ui.combatSafetyScale then
		f:SetScale(ns.db.ui.combatSafetyScale)
	end

	local icon = f:CreateTexture(nil, "ARTWORK")
	icon:SetPoint("LEFT", f, "LEFT", 2, 0)
	icon:SetSize(46, 46)
	icon:SetTexCoord(0.07, 0.93, 0.07, 0.93)
	icon:SetTexture(STATIC_ICON)
	f._icon = icon

	-- Rode gloed-rand (pulseert; kind-alpha, dus onzichtbaar als het frame alpha 0 is).
	local glow = CreateFrame("Frame", nil, f, "BackdropTemplate")
	glow:SetPoint("TOPLEFT", icon, "TOPLEFT", -4, 4)
	glow:SetPoint("BOTTOMRIGHT", icon, "BOTTOMRIGHT", 4, -4)
	if glow.SetBackdrop then
		glow:SetBackdrop({
			edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
			edgeSize = 14,
		})
		glow:SetBackdropBorderColor(1, 0.18, 0.18, 1)
	end
	f._glow = glow

	-- Cooldown-swipe over het icoon (gevuld via duration-object; secret-safe).
	local cd = CreateFrame("Cooldown", nil, f, "CooldownFrameTemplate")
	cd:SetAllPoints(icon)
	cd:SetDrawEdge(true)
	f._cd = cd

	-- Statische waarschuwingstekst (geen secret-naam tonen in v1).
	local title = f:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
	title:SetPoint("TOPLEFT", icon, "TOPRIGHT", 8, -6)
	title:SetPoint("RIGHT", f, "RIGHT", -4, 0)
	title:SetJustifyH("LEFT")
	title:SetWordWrap(false)
	title:SetTextColor(1, 0.35, 0.35)
	title:SetText(ns:L("CS_WARN"))
	f._title = title

	local who = f:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
	who:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -2)
	who:SetTextColor(0.85, 0.82, 0.3)
	who:SetText(ns:L("CS_ONYOU"))
	f._who = who

	f:SetScript("OnDragStart", function(self)
		self:StartMoving()
	end)
	f:SetScript("OnDragStop", function(self)
		self:StopMovingOrSizing()
		local p, _, rp, x, y = self:GetPoint()
		if p and ns.db and ns.db.ui then
			ns.db.ui.combatSafetyPos = { p, rp, x, y }
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
			ns.db.ui.combatSafetyScale = s
		end
	end)
	f:SetScript("OnEnter", function(self)
		if GameTooltip then
			GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
			GameTooltip:AddLine(ns:L("CS_WARN"), 1, 0.4, 0.4)
			GameTooltip:AddLine(ns:L("CS_TIP_HINT"), 0.7, 0.7, 0.7, true)
			GameTooltip:Show()
		end
	end)
	f:SetScript("OnLeave", function()
		if GameTooltip then
			GameTooltip:Hide()
		end
	end)
	-- Alleen een gloed-puls (non-secret rekenwerk op eigen timer).
	f:SetScript("OnUpdate", function(self, elapsed)
		self._t = (self._t or 0) + elapsed
		local a = 0.5 + 0.5 * (0.5 + 0.5 * math.sin(self._t * 3))
		if self._glow then
			self._glow:SetAlpha(a)
		end
	end)
	f:Hide()
	frame = f
	return f
end

--------------------------------------------------------------------------------
-- Detectie (12.x secret-safe: geen arithmetic/branch op secret waarden)
--------------------------------------------------------------------------------

local function IsHostileNameplate(unit)
	if not unit or not unit:find("^nameplate") then
		return false
	end
	if UnitCanAttack then
		local ok, can = pcall(UnitCanAttack, "player", unit)
		if ok and not can then
			return false
		end
	end
	return true
end

local function HideFor(unit)
	if unit and shownUnit and unit ~= shownUnit then
		return -- een andere unit is getoond; laat staan
	end
	shownUnit = nil
	if frame then
		frame:Hide()
	end
end

-- Toon (via engine-alpha) de cast van deze nameplate-unit. Faalt veilig via de pcall in
-- EvaluateCast. Gooit bij een secret-taint of ontbrekende API → dan verbergt EvaluateCast.
local function ShowCast(unit)
	local icon, spellId, isChannel
	if UnitCastingInfo then
		local _, _, tex, _, _, _, _, _, sid = UnitCastingInfo(unit)
		icon, spellId, isChannel = tex, sid, false
	end
	if not spellId and UnitChannelInfo then
		local _, _, tex, _, _, _, _, sid = UnitChannelInfo(unit)
		icon, spellId, isChannel = tex, sid, true
	end
	if not spellId then
		HideFor(unit)
		return
	end

	-- Secret-booleans (NIET met if op vertakken — alleen aan de engine voeren).
	local important = C_Spell and C_Spell.IsSpellImportant and C_Spell.IsSpellImportant(spellId)
	local targetsPlayer = PlayerIsSpellTarget and PlayerIsSpellTarget(unit, "player")
	if important == nil or targetsPlayer == nil then
		HideFor(unit)
		return
	end

	-- Duration-OBJECT (nooit /1000 doen).
	local duration
	if isChannel and UnitChannelDuration then
		duration = UnitChannelDuration(unit)
	elseif UnitCastingDuration then
		duration = UnitCastingDuration(unit)
	end

	local f = EnsureFrame()

	-- Spell-icoon (secret) tonen; lukt dat niet, statische fallback.
	local okIcon = pcall(function()
		f._icon:SetTexture(icon)
	end)
	if not okIcon then
		f._icon:SetTexture(STATIC_ICON)
	end

	-- Cooldown-swipe via duration-object.
	if duration and f._cd.SetCooldownFromDurationObject then
		pcall(function()
			f._cd:SetCooldownFromDurationObject(duration)
		end)
	end

	shownUnit = unit
	f:Show()

	-- Zichtbaarheid: alpha = 1 alleen als (op mij EN belangrijk), anders 0. Puur engine —
	-- geen enkele Lua-if op een secret waarde. EvaluateColorValueFromBoolean(important,0,1)
	-- = 0 bij niet-belangrijk, 1 bij belangrijk; SetAlphaFromBoolean gate't dat op targetsPlayer.
	if f.SetAlphaFromBoolean and C_CurveUtil and C_CurveUtil.EvaluateColorValueFromBoolean then
		local trueAlpha = C_CurveUtil.EvaluateColorValueFromBoolean(important, 0, 1)
		f:SetAlphaFromBoolean(targetsPlayer, trueAlpha, 0)
	else
		-- Geen secret-veilige gate beschikbaar → niets tonen (anders elke cast tonen).
		f:Hide()
		shownUnit = nil
	end
end

local function EvaluateCast(unit)
	if not Enabled() then
		return
	end
	if not IsHostileNameplate(unit) then
		HideFor(unit)
		return
	end
	local ok = pcall(ShowCast, unit)
	if not ok then
		-- Secret-taint of API-verschil: veilig verbergen, geen error-spam.
		if unit == shownUnit or not shownUnit then
			shownUnit = nil
			if frame then
				frame:SetAlpha(1)
				frame:Hide()
			end
		end
	end
end

function ns.RefreshCombatSafety()
	if not Enabled() then
		shownUnit = nil
		if frame then
			frame:Hide()
		end
	end
end

--------------------------------------------------------------------------------
-- Test (Settings-knop): aan/uit-schakelaar voor een blijvende, SLEEPBARE preview
-- (geen secret waarden). Zo kun je het icoon vooraf op z'n plek zetten.
--------------------------------------------------------------------------------

function ns.TestCombatSafety()
	local f = EnsureFrame()
	-- Toggle: staat de preview al aan → uitzetten.
	if shownUnit == "_test" and f:IsShown() then
		shownUnit = nil
		f:Hide()
		return
	end
	f._icon:SetTexture(STATIC_ICON)
	if f._cd.SetCooldown then
		f._cd:SetCooldown(GetTime(), 8) -- lange swipe, puur cosmetisch voor de preview
	end
	f:SetAlpha(1)
	shownUnit = "_test"
	f:Show()
	-- Blijft staan tot je 'm wegklikt of /reload't → rustig verslepen om te positioneren.
	-- Als TTS aan staat: spreek een voorbeeld-naam zodat je de stem hoort.
	if SpeakEnabled() and C_VoiceChat and C_VoiceChat.SpeakText then
		pcall(function()
			local voiceId = 0
			if C_TTSSettings and C_TTSSettings.GetVoiceOptionID and Enum and Enum.TtsVoiceType then
				voiceId = C_TTSSettings.GetVoiceOptionID(Enum.TtsVoiceType.Standard) or 0
			end
			local vol = (C_TTSSettings and C_TTSSettings.GetSpeechVolume and C_TTSSettings.GetSpeechVolume()) or 100
			C_VoiceChat.SpeakText(voiceId, ns:L("CS_TEST_NAME"), 2, vol, true)
		end)
	end
end

--------------------------------------------------------------------------------
-- Gesproken cast-naam (TTS) — optioneel, secret-safe
--
-- ⚠️ De cast-naam is een secret value; C_VoiceChat.SpeakText mag 'm wél UITSPREKEN
-- (toegestane sink, exact zoals TargetedSpells Driver.lua:861). MAAR "op mij gericht?" en
-- "belangrijk?" zijn secret booleans → daar mogen we NIET op vertakken. Daarom spreekt dit
-- (net als TargetedSpells) voor vijandelijke GERICHTE casts (UnitSpellTargetName ~= nil is een
-- toegestane presence-check) in instances/gevecht, met NPC-filter + anti-spam. In Delves/solo
-- = in de praktijk "op jou". Alles pcall-geguard (wijkt een API af → geen geluid, geen error).
--------------------------------------------------------------------------------

local ttsCache = {}

-- Alleen in instances, of in gevecht met een vechtende bron (geen idle stads-casters).
local function AnnounceContextOK(unit)
	if IsInInstance and select(1, IsInInstance()) then
		return true
	end
	local inCombat = InCombatLockdown and InCombatLockdown()
	local unitFighting = UnitAffectingCombat and UnitAffectingCombat(unit)
	return (inCombat and unitFighting) and true or false
end

-- Sla triviale mobs/minions over (niet-secret classificatie).
local function AnnounceNpcOK(unit)
	if UnitIsMinion and UnitIsMinion(unit) then
		return false
	end
	local c = UnitClassification and UnitClassification(unit)
	if c == "trivial" or c == "minus" then
		return false
	end
	return true
end

local function AnnounceCast(unit)
	if not Enabled() or not SpeakEnabled() then
		return
	end
	if not IsHostileNameplate(unit) then
		return
	end
	if not AnnounceContextOK(unit) or not AnnounceNpcOK(unit) then
		return
	end
	-- Alleen GERICHTE casts (presence-check op de secret doelnaam — toegestaan, geen ==).
	if not (UnitSpellTargetName and UnitSpellTargetName(unit) ~= nil) then
		return
	end
	local now = GetTime()
	if ttsCache[unit] and (now - ttsCache[unit]) < 3 then
		return -- anti-spam: max 1x per unit per 3s
	end
	local spellId
	if UnitCastingInfo then
		spellId = select(9, UnitCastingInfo(unit))
	end
	if spellId == nil and UnitChannelInfo then
		spellId = select(8, UnitChannelInfo(unit))
	end
	if spellId == nil then
		return
	end
	if not (C_VoiceChat and C_VoiceChat.SpeakText and C_Spell and C_Spell.GetSpellName) then
		return
	end
	local name = C_Spell.GetSpellName(spellId) -- secret string; SpeakText mag 'm uitspreken
	if name == nil then
		return
	end
	ttsCache[unit] = now
	local voiceId = 0
	if C_TTSSettings and C_TTSSettings.GetVoiceOptionID and Enum and Enum.TtsVoiceType then
		voiceId = C_TTSSettings.GetVoiceOptionID(Enum.TtsVoiceType.Standard) or 0
	end
	local vol = (C_TTSSettings and C_TTSSettings.GetSpeechVolume and C_TTSSettings.GetSpeechVolume()) or 100
	C_VoiceChat.SpeakText(voiceId, name, 2, vol, true)
end

--------------------------------------------------------------------------------
-- Events
--------------------------------------------------------------------------------

local ev = CreateFrame("Frame")
ev:RegisterEvent("PLAYER_LOGIN")
ev:RegisterEvent("PLAYER_ENTERING_WORLD")
ev:RegisterEvent("UNIT_SPELLCAST_START")
ev:RegisterEvent("UNIT_SPELLCAST_CHANNEL_START")
ev:RegisterEvent("UNIT_SPELLCAST_STOP")
ev:RegisterEvent("UNIT_SPELLCAST_CHANNEL_STOP")
ev:RegisterEvent("UNIT_SPELLCAST_INTERRUPTED")
ev:RegisterEvent("NAME_PLATE_UNIT_REMOVED")

ev:SetScript("OnEvent", function(_, event, unit)
	if event == "PLAYER_LOGIN" or event == "PLAYER_ENTERING_WORLD" then
		shownUnit = nil
		EnsureFrame()
		if frame then
			frame:Hide()
		end
		return
	end
	if not unit or not unit:find("^nameplate") then
		return
	end
	if event == "UNIT_SPELLCAST_START" or event == "UNIT_SPELLCAST_CHANNEL_START" then
		-- Kleine debounce: doelwit-info is soms 1 frame later gevuld (TargetedSpells-truc).
		if C_Timer and C_Timer.After then
			C_Timer.After(0.1, function()
				EvaluateCast(unit)
				pcall(AnnounceCast, unit)
			end)
		else
			EvaluateCast(unit)
			pcall(AnnounceCast, unit)
		end
	else
		-- STOP / CHANNEL_STOP / INTERRUPTED / nameplate weg → cast voorbij.
		HideFor(unit)
	end
end)
