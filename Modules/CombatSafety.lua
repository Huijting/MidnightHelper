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

	Twee weergaves (stijl-schakelaar in Settings): "Icoon" = één versleepbaar icoon (laatste
	relevante cast); "Balken" = een verticale stapel castbalken (icoon + spellnaam + aflopende
	progressbar) uit een frame-pool, meerdere gelijktijdige casts-op-jou tegelijk. Detectie +
	TTS zijn gedeeld. Optionele TTS spreekt de cast-naam uit (secret-safe sink).

	Bewuste beperkingen (secret-value-veilig): geen MOVE!/INTERRUPT!-onderscheid en geen exacte
	geluid-gating op "op mij" (vergt vertakken op secret waarden). In de balken-modus krijgen
	niet-relevante casts alpha 0 (engine beslist), wat kleine gaten in de stapel kan geven.
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
-- Weergave "Balken" (stijl-schakelaar): meerdere inkomende casts-op-jou als een
-- verticale stapel balkjes (icoon + spellnaam + aflopende progressbar). Zelfde
-- secret-safe patronen als het icoon: naam via SetText (toegestane sink), aftel via
-- duration-object (SetTimerDuration), zichtbaarheid via SetAlphaFromBoolean. Elk
-- balkje = één nameplate-unit; niet-relevante casts krijgen alpha 0 (engine beslist).
--------------------------------------------------------------------------------

local function BarsMode()
	local uiDb = ns.db and ns.db.ui
	return type(uiDb) == "table" and uiDb.combatSafetyBars == true
end

function ns.IsCombatSafetyBarsEnabled()
	return BarsMode()
end

local BAR_W, BAR_H, BAR_GAP = 220, 24, 3
local barHost, barPool, barsByUnit, barOrder = nil, {}, {}, {}

local function EnsureBarHost()
	if barHost then
		return barHost
	end
	local h = CreateFrame("Frame", "MidnightHelperCombatSafetyBars", UIParent)
	h:SetSize(BAR_W, BAR_H)
	h:SetFrameStrata("HIGH")
	h:SetClampedToScreen(true)
	h:SetMovable(true)
	local pos = ns.db and ns.db.ui and ns.db.ui.combatSafetyBarsPos
	if type(pos) == "table" and pos[1] then
		h:SetPoint(pos[1], UIParent, pos[2] or pos[1], pos[3] or 0, pos[4] or 0)
	else
		h:SetPoint("CENTER", UIParent, "CENTER", 0, 180)
	end
	if ns.db and ns.db.ui and ns.db.ui.combatSafetyBarsScale then
		h:SetScale(ns.db.ui.combatSafetyBarsScale)
	end
	h:Hide()
	barHost = h
	return h
end

local function SaveBarPos()
	local h = barHost
	if not h then
		return
	end
	local p, _, rp, x, y = h:GetPoint()
	if p and ns.db and ns.db.ui then
		ns.db.ui.combatSafetyBarsPos = { p, rp, x, y }
	end
end

local function AcquireBar()
	for i = 1, #barPool do
		if not barPool[i]._inUse then
			barPool[i]._inUse = true
			return barPool[i]
		end
	end
	local host = EnsureBarHost()
	local b = CreateFrame("Button", nil, host)
	b:SetSize(BAR_W, BAR_H)
	-- Echte balken zijn display-only (geen muis) zodat onzichtbare (alpha 0) balken nooit
	-- klikken opvangen. Alleen de preview-balken krijgen muis (voor slepen/positioneren).
	b:EnableMouse(false)
	b:RegisterForDrag("LeftButton")
	local bg = b:CreateTexture(nil, "BACKGROUND")
	bg:SetAllPoints(b)
	bg:SetColorTexture(0, 0, 0, 0.5)
	local pb = CreateFrame("StatusBar", nil, b)
	pb:SetPoint("TOPLEFT", b, "TOPLEFT", BAR_H + 1, -1)
	pb:SetPoint("BOTTOMRIGHT", b, "BOTTOMRIGHT", -1, 1)
	pb:SetStatusBarTexture("Interface\\TargetingFrame\\UI-StatusBar")
	pb:SetStatusBarColor(0.7, 0.15, 0.15)
	pb:SetMinMaxValues(0, 1)
	pb:SetValue(1)
	b._pb = pb
	local icon = b:CreateTexture(nil, "ARTWORK")
	icon:SetPoint("LEFT", b, "LEFT", 0, 0)
	icon:SetSize(BAR_H, BAR_H)
	icon:SetTexCoord(0.07, 0.93, 0.07, 0.93)
	icon:SetTexture(STATIC_ICON)
	b._icon = icon
	local nm = pb:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	nm:SetPoint("LEFT", pb, "LEFT", 4, 0)
	nm:SetPoint("RIGHT", pb, "RIGHT", -4, 0)
	nm:SetJustifyH("LEFT")
	nm:SetWordWrap(false)
	b._name = nm
	b:SetScript("OnDragStart", function()
		EnsureBarHost():StartMoving()
	end)
	b:SetScript("OnDragStop", function()
		EnsureBarHost():StopMovingOrSizing()
		SaveBarPos()
	end)
	b:EnableMouseWheel(true)
	b:SetScript("OnMouseWheel", function(_, delta)
		if not IsShiftKeyDown() then
			return
		end
		local h = EnsureBarHost()
		local s = math.max(0.5, math.min(2.5, (h:GetScale() or 1) + (delta > 0 and 0.1 or -0.1)))
		h:SetScale(s)
		if ns.db and ns.db.ui then
			ns.db.ui.combatSafetyBarsScale = s
		end
	end)
	barPool[#barPool + 1] = b
	b._inUse = true
	return b
end

local function LayoutBars()
	local host = EnsureBarHost()
	local y, shown = 0, 0
	for _, unit in ipairs(barOrder) do
		local b = barsByUnit[unit]
		if b then
			b:ClearAllPoints()
			b:SetPoint("TOPLEFT", host, "TOPLEFT", 0, -y)
			b:Show()
			y = y + BAR_H + BAR_GAP
			shown = shown + 1
			if shown >= 8 then
				break
			end
		end
	end
	host:SetSize(BAR_W, math.max(BAR_H, y - BAR_GAP))
	if shown > 0 then
		host:Show()
	else
		host:Hide()
	end
end

local function ReleaseBar(unit)
	local b = barsByUnit[unit]
	if not b then
		return
	end
	barsByUnit[unit] = nil
	b._inUse = false
	b:EnableMouse(false) -- reset: preview kan 'm hebben aangezet
	b:Hide()
	for i = #barOrder, 1, -1 do
		if barOrder[i] == unit then
			table.remove(barOrder, i)
		end
	end
	LayoutBars()
end

-- Vul een balk uit de live cast van een nameplate-unit. Return false = niet tonen.
local function SetupBar(b, unit)
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
		return false
	end
	local important = C_Spell and C_Spell.IsSpellImportant and C_Spell.IsSpellImportant(spellId)
	local targetsPlayer = PlayerIsSpellTarget and PlayerIsSpellTarget(unit, "player")
	if important == nil or targetsPlayer == nil then
		return false
	end
	if not pcall(function()
		b._icon:SetTexture(icon)
	end) then
		b._icon:SetTexture(STATIC_ICON)
	end
	-- Spell-naam (secret string; SetText is een toegestane sink — mag getoond worden).
	if C_Spell and C_Spell.GetSpellName then
		local nm = C_Spell.GetSpellName(spellId)
		if nm ~= nil then
			pcall(function()
				b._name:SetText(nm)
			end)
		else
			b._name:SetText("")
		end
	end
	-- Aflopende progressbar via duration-OBJECT (nooit zelf de resterende tijd berekenen).
	local duration = (isChannel and UnitChannelDuration and UnitChannelDuration(unit))
		or (UnitCastingDuration and UnitCastingDuration(unit))
		or nil
	if duration and b._pb.SetTimerDuration then
		pcall(function()
			b._pb:SetTimerDuration(duration)
		end)
	end
	-- Zichtbaarheid: alpha 1 alleen als (op mij EN belangrijk), anders 0 — puur engine.
	if b.SetAlphaFromBoolean and C_CurveUtil and C_CurveUtil.EvaluateColorValueFromBoolean then
		local ta = C_CurveUtil.EvaluateColorValueFromBoolean(important, 0, 1)
		b:SetAlphaFromBoolean(targetsPlayer, ta, 0)
		return true
	end
	return false
end

local function BarsShowCast(unit)
	-- Géén pre-filter: maak (net als de icoon-modus) een balk voor élke vijandelijke cast en
	-- laat de engine via SetAlphaFromBoolean beslissen of 'ie zichtbaar is (op mij + belangrijk).
	-- Niet-relevante casts blijven alpha 0 (kunnen kleine gaten geven; display-only dus geen
	-- klik-onderschepping). Zo verschijnen balken exact wanneer het icoon zou verschijnen.
	local b = barsByUnit[unit]
	if not b then
		b = AcquireBar()
		barsByUnit[unit] = b
		barOrder[#barOrder + 1] = unit
	end
	if not SetupBar(b, unit) then
		ReleaseBar(unit)
		return
	end
	LayoutBars()
end

local function HideAllBars()
	wipe(barsByUnit)
	wipe(barOrder)
	for i = 1, #barPool do
		barPool[i]._inUse = false
		barPool[i]:Hide()
	end
	if barHost then
		barHost:Hide()
	end
end

function ns.SetCombatSafetyBarsEnabled(v)
	local uiDb = ns.db and ns.db.ui
	if type(uiDb) == "table" then
		uiDb.combatSafetyBars = v and true or false
	end
	-- Stijl-wissel: verberg beide weergaves; nieuwe casts vullen de gekozen modus.
	shownUnit = nil
	if frame then
		frame:Hide()
	end
	HideAllBars()
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
		if BarsMode() then
			ReleaseBar(unit)
		else
			HideFor(unit)
		end
		return
	end
	if BarsMode() then
		if not pcall(BarsShowCast, unit) then
			ReleaseBar(unit) -- secret-taint/API-verschil: veilig verbergen
		end
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
		HideAllBars()
	end
end

--------------------------------------------------------------------------------
-- Test (Settings-knop): aan/uit-schakelaar voor een blijvende, SLEEPBARE preview
-- (geen secret waarden). Zo kun je het icoon vooraf op z'n plek zetten.
--------------------------------------------------------------------------------

local function TestSpeakSample()
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

function ns.TestCombatSafety()
	-- Balken-modus: toggle een paar SLEEPBARE sample-balkjes (statisch, geen secret waarden).
	if BarsMode() then
		if barsByUnit["_test1"] then
			ReleaseBar("_test1")
			ReleaseBar("_test2")
			ReleaseBar("_test3")
			return
		end
		local samples = { ns:L("CS_TEST_NAME"), ns:L("CS_WARN"), ns:L("CS_ONYOU") }
		local keys = { "_test1", "_test2", "_test3" }
		for i = 1, #keys do
			local b = AcquireBar()
			barsByUnit[keys[i]] = b
			barOrder[#barOrder + 1] = keys[i]
			b._icon:SetTexture(STATIC_ICON)
			b._name:SetText(samples[i])
			if b._pb.SetValue then
				b._pb:SetValue(1 - (i - 1) * 0.3)
			end
			b:EnableMouse(true) -- preview: sleepbaar om de stapel te plaatsen
			b:SetAlpha(1)
		end
		LayoutBars()
		TestSpeakSample()
		return
	end

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
	TestSpeakSample()
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
		HideAllBars()
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
		if BarsMode() then
			ReleaseBar(unit)
		else
			HideFor(unit)
		end
	end
end)
