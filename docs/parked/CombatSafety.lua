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
-- Test (Settings-knop): flits een nep-cue van 3s (geen secret waarden)
--------------------------------------------------------------------------------

function ns.TestCombatSafety()
	local f = EnsureFrame()
	f._icon:SetTexture(STATIC_ICON)
	if f._cd.SetCooldown then
		f._cd:SetCooldown(GetTime(), 3)
	end
	f:SetAlpha(1)
	shownUnit = "_test"
	f:Show()
	if C_Timer and C_Timer.After then
		C_Timer.After(3.1, function()
			if shownUnit == "_test" then
				shownUnit = nil
				f:Hide()
			end
		end)
	end
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
			end)
		else
			EvaluateCast(unit)
		end
	else
		-- STOP / CHANNEL_STOP / INTERRUPTED / nameplate weg → cast voorbij.
		HideFor(unit)
	end
end)
