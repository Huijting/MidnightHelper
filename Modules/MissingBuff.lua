--[[
	Missing Buff — engine + doorlopend icoon (Rob-wens 3 jul 2026).

	Toont een versleepbaar icoon zodra jij een onderhoudbare class-buff kunt casten
	maar NIET actief hebt (raid-buff/vorm/shield/imbue/poison/stance/pet). Verdwijnt
	zodra alles op orde is. Klikbaar om de buff te casten (secure; attribuut/positie
	worden alleen buiten combat gewijzigd → geen protected-frame-problemen in combat).

	Detectie hergebruikt dezelfde veilige patronen als ConsumableReadyCheck:
	C_SpellBook.IsSpellKnown (geleerd?), C_UnitAuras.GetPlayerAuraBySpellID (actief?),
	GetWeaponEnchantInfo (imbue?), GetShapeshiftForm (vorm/stance), UnitExists/UnitIsDead
	(pet). Alles read-only + pcall-geguard.
]]

local _, ns = ...

--------------------------------------------------------------------------------
-- Detectie-helpers
--------------------------------------------------------------------------------

local function IsKnown(spellID)
	if not spellID then
		return false
	end
	if C_SpellBook and C_SpellBook.IsSpellKnown then
		local ok, known = pcall(C_SpellBook.IsSpellKnown, spellID)
		if ok and known then
			return true
		end
		-- talenten/pet-spells kunnen via IsSpellKnownOrOverridesKnown zichtbaar zijn
		if C_SpellBook.IsSpellKnownOrOverridesKnown then
			local ok2, k2 = pcall(C_SpellBook.IsSpellKnownOrOverridesKnown, spellID)
			if ok2 and k2 then
				return true
			end
		end
		return false
	end
	if IsSpellKnown then
		local ok, known = pcall(IsSpellKnown, spellID)
		return ok and known or false
	end
	return false
end

local function HasBuff(spellID)
	if not (spellID and C_UnitAuras and C_UnitAuras.GetPlayerAuraBySpellID) then
		return false
	end
	local ok, data = pcall(C_UnitAuras.GetPlayerAuraBySpellID, spellID)
	return ok and data ~= nil
end

local function CurrentSpecID()
	local idx = GetSpecialization and GetSpecialization()
	if not idx then
		return nil
	end
	local ok, sid = pcall(GetSpecializationInfo, idx)
	return ok and sid or nil
end

local function SpecMatches(specs, sid)
	if type(specs) ~= "table" then
		return true
	end
	if not sid then
		return false
	end
	for i = 1, #specs do
		if specs[i] == sid then
			return true
		end
	end
	return false
end

local function WeaponEnchant()
	if not GetWeaponEnchantInfo then
		return false, false
	end
	local ok, hasMH, _, _, _, hasOH = pcall(GetWeaponEnchantInfo)
	if not ok then
		return false, false
	end
	return hasMH and true or false, hasOH and true or false
end

local function InAnyForm()
	if not GetShapeshiftForm then
		return false
	end
	local ok, idx = pcall(GetShapeshiftForm)
	return ok and type(idx) == "number" and idx > 0
end

local function SpellName(spellID)
	if C_Spell and C_Spell.GetSpellName then
		local ok, n = pcall(C_Spell.GetSpellName, spellID)
		if ok and n then
			return n
		end
	end
	if GetSpellInfo then
		local ok, n = pcall(GetSpellInfo, spellID)
		if ok and n then
			return n
		end
	end
	return nil
end

local function SpellIcon(spellID)
	if C_Spell and C_Spell.GetSpellTexture then
		local ok, t = pcall(C_Spell.GetSpellTexture, spellID)
		if ok and t then
			return t
		end
	end
	return "Interface\\Icons\\INV_Misc_QuestionMark"
end

local function PlayerMounted()
	if IsMounted and IsMounted() then
		return true
	end
	if UnitOnTaxi and UnitOnTaxi("player") then
		return true
	end
	if UnitInVehicle and UnitInVehicle("player") then
		return true
	end
	return false
end

--------------------------------------------------------------------------------
-- Missende-buff-berekening
--------------------------------------------------------------------------------

local function AddEntry(out, castSpell, textKey, showCombat, macroTarget)
	out[#out + 1] = {
		spell = castSpell,
		name = SpellName(castSpell) or ("#" .. tostring(castSpell)),
		icon = SpellIcon(castSpell),
		textKey = textKey,
		showCombat = showCombat and true or false,
		macroTarget = macroTarget and true or false,
	}
end

-- Groep-helpers voor ally-buffs. Whitelisted buffs (Beacon/Symbiotic/Source of Magic)
-- zijn op andere units leesbaar; secret-values guarden we weg.
local function GroupUnits()
	local t = { "player" }
	local n = (GetNumGroupMembers and GetNumGroupMembers()) or 0
	if IsInRaid and IsInRaid() then
		for i = 1, n do
			t[#t + 1] = "raid" .. i
		end
	else
		for i = 1, math.max(0, n - 1) do
			t[#t + 1] = "party" .. i
		end
	end
	return t
end

local function UnitHasAura(unit, spellID)
	if not (C_UnitAuras and C_UnitAuras.GetAuraDataByIndex) then
		return false
	end
	for i = 1, 40 do
		local ok, a = pcall(C_UnitAuras.GetAuraDataByIndex, unit, i, "HELPFUL")
		if not ok or not a then
			break
		end
		local sidv = a.spellId
		if sidv and not (issecretvalue and issecretvalue(sidv)) and sidv == spellID then
			return true
		end
	end
	return false
end

local function GroupHasBuff(spellID)
	for _, u in ipairs(GroupUnits()) do
		if UnitHasAura(u, spellID) then
			return true
		end
	end
	return false
end

local function InGroup()
	return IsInGroup and IsInGroup() and true or false
end

local function HealerInGroup()
	for _, u in ipairs(GroupUnits()) do
		if u ~= "player" and UnitGroupRolesAssigned and UnitGroupRolesAssigned(u) == "HEALER" then
			return true
		end
	end
	return false
end

-- @return geordende lijst { {spell, name, icon, textKey, showCombat}, ... }
function ns.GetMissingBuffs()
	local out = {}
	local classToken = select(2, UnitClass("player"))
	if not classToken then
		return out
	end
	local sid = CurrentSpecID()

	-- 1) Reguliere defs (raid/self/form/imbue).
	local defs = ns.MISSING_BUFF_DEFS and ns.MISSING_BUFF_DEFS[classToken]
	if type(defs) == "table" then
		for _, d in ipairs(defs) do
			if SpecMatches(d.specs, sid) and IsKnown(d.spell) and (not d.reqSpell or IsKnown(d.reqSpell)) then
				local active, macroTarget
				if d.kind == "imbue_mh" then
					active = (select(1, WeaponEnchant()))
				elseif d.kind == "imbue_oh" then
					active = (select(2, WeaponEnchant()))
				elseif d.kind == "ally" then
					-- Ally-buff: alleen relevant in een groep (je buft een ally). Actief =
					-- iemand in de groep heeft 'm. Source of Magic alleen als er een healer is.
					-- In combat NIET de groep-aura's scannen: ally-buffs tonen daar toch niet
					-- (showCombat=false) en de scan kan 12.x-secret-value-fouten geven.
					macroTarget = true
					if not InGroup() or (InCombatLockdown and InCombatLockdown()) then
						active = true
					elseif d.needHealer and not HealerInGroup() then
						active = true
					else
						active = GroupHasBuff(d.buff or d.spell)
					end
				else
					-- raid / self / form: buff/aura staat op de speler
					active = HasBuff(d.buff or d.spell)
				end
				if not active then
					AddEntry(out, d.spell, d.textKey, d.showCombat, macroTarget)
				end
			end
		end
	end

	-- 2) Warrior-stances (groep): geleerd maar geen stance actief.
	if classToken == "WARRIOR" and type(ns.MISSING_STANCES) == "table" then
		local knowsAny, castSpell = false, nil
		for _, s in ipairs(ns.MISSING_STANCES) do
			if IsKnown(s.spell) then
				knowsAny = true
				castSpell = castSpell or s.spell -- eerste (Defensive default)
			end
		end
		if knowsAny and not InAnyForm() then
			AddEntry(out, castSpell, "MBUFF_TXT_STANCE", true)
		end
	end

	-- 3) Rogue-poisons (groep): 1 lethal + 1 non-lethal.
	if classToken == "ROGUE" and type(ns.MISSING_POISONS) == "table" then
		local function groupMissing(group)
			local knowsAny, castSpell, anyActive = false, nil, false
			for _, p in ipairs(group) do
				if IsKnown(p.spell) then
					knowsAny = true
					castSpell = castSpell or p.spell
					if HasBuff(p.spell) then
						anyActive = true
					end
				end
			end
			return knowsAny and not anyActive, castSpell
		end
		local mL, cL = groupMissing(ns.MISSING_POISONS.lethal)
		if mL then
			AddEntry(out, cL, "MBUFF_TXT_LETHAL", false)
		end
		local mN, cN = groupMissing(ns.MISSING_POISONS.nonlethal)
		if mN then
			AddEntry(out, cN, "MBUFF_TXT_NONLETHAL", false)
		end
	end

	-- 4) Pets (Hunter/Warlock/Unholy DK): hoort een pet te hebben en heeft er geen (of dood).
	if not PlayerMounted() then
		local petDef = ns.MISSING_PET and ns.MISSING_PET[classToken]
		if petDef then
			local shouldHavePet, castSpell, textKey = false, nil, "MBUFF_TXT_PET"
			if classToken == "HUNTER" then
				if sid == petDef.mmSpec then
					shouldHavePet = IsKnown(petDef.mmPetTalent) -- MM alleen met Unbreakable Bond
				else
					shouldHavePet = true
				end
				castSpell = petDef.call
			elseif classToken == "WARLOCK" then
				shouldHavePet = not HasBuff(petDef.sacrificeBuff) -- Grimoire of Sacrifice = geen pet nodig
				castSpell = petDef.summon
			elseif classToken == "DEATHKNIGHT" then
				shouldHavePet = SpecMatches(petDef.specs, sid) and IsKnown(petDef.summon)
				castSpell = petDef.summon
			end
			if shouldHavePet then
				local hasPet = UnitExists and UnitExists("pet")
				local petDead = hasPet and UnitIsDead and UnitIsDead("pet")
				if not hasPet then
					AddEntry(out, castSpell, "MBUFF_TXT_PET", true)
				elseif petDead then
					local revive = (classToken == "HUNTER" and petDef.revive) or castSpell
					AddEntry(out, revive, "MBUFF_TXT_PET_DEAD", true)
				end
			end
		end
	end

	-- 5) Paladin-auras: er hoort altijd één aura actief te zijn. Detectie via de
	-- shapeshift-form-API (aura's zijn "forms" voor Paladins) → nooit vals-positief.
	if classToken == "PALADIN" and IsKnown(465) and not InAnyForm() then
		AddEntry(out, 465, "MBUFF_TXT_AURA", true) -- Devotion Aura (default)
	end

	return out
end

-- Debug: /mh mbuff — toon per buff of hij geleerd/spec-ok/actief is + de missende lijst.
function ns.PrintMissingBuffDebug()
	local classToken = select(2, UnitClass("player"))
	local sid = CurrentSpecID()
	print(("|cffffcc00MH MissingBuff|r class=%s spec=%s inGroup=%s"):format(
		tostring(classToken), tostring(sid), tostring(InGroup())))
	local mh, oh = WeaponEnchant()
	print(("  wapen-enchant: mainhand=%s offhand=%s"):format(tostring(mh), tostring(oh)))
	local defs = ns.MISSING_BUFF_DEFS and ns.MISSING_BUFF_DEFS[classToken]
	if type(defs) == "table" then
		for _, d in ipairs(defs) do
			local pass = SpecMatches(d.specs, sid) and IsKnown(d.spell)
				and ((not d.reqSpell) or IsKnown(d.reqSpell))
			local active
			if d.kind == "imbue_mh" then
				active = (select(1, WeaponEnchant()))
			elseif d.kind == "imbue_oh" then
				active = (select(2, WeaponEnchant()))
			elseif d.kind == "ally" then
				if not InGroup() then
					active = true
				elseif d.needHealer and not HealerInGroup() then
					active = true
				else
					active = GroupHasBuff(d.buff or d.spell)
				end
			else
				active = HasBuff(d.buff or d.spell)
			end
			print(("  %s [%s]: pass=%s active=%s → ADD=%s"):format(
				SpellName(d.spell) or ("#" .. tostring(d.spell)), tostring(d.kind),
				tostring(pass), tostring(active), tostring(pass and not active)))
		end
	end
	local missing = ns.GetMissingBuffs()
	print(("  → missende buffs: %d"):format(#missing))
	for _, m in ipairs(missing) do
		print("     • " .. (m.name or "?"))
	end
end

--------------------------------------------------------------------------------
-- Aan/uit + saved settings
--------------------------------------------------------------------------------

local function Enabled()
	local uiDb = ns.db and ns.db.ui
	if type(uiDb) ~= "table" then
		return true
	end
	return uiDb.missingBuff ~= false
end

function ns.IsMissingBuffEnabled()
	return Enabled()
end

function ns.SetMissingBuffEnabled(v)
	local uiDb = ns.db and ns.db.ui
	if type(uiDb) == "table" then
		uiDb.missingBuff = v and true or false
	end
	if ns.UpdateMissingBuff then
		ns.UpdateMissingBuff()
	end
end

--------------------------------------------------------------------------------
-- Doorlopend icoon (versleepbaar, schaalbaar, klikbaar casten)
--------------------------------------------------------------------------------

local frame

local function EnsureFrame()
	if frame then
		return frame
	end
	-- Niet-secure reminder-frame: mag altijd getoond/verborgen/verplaatst worden, óók
	-- in combat (secure knoppen mogen dat niet — en juist vorm/stance/pet-reminders
	-- moeten in combat kunnen verschijnen). Klik-om-te-casten kan later als losse
	-- out-of-combat-extra bovenop.
	local f = CreateFrame("Button", "MidnightHelperMissingBuff", UIParent)
	f:SetSize(56, 56)
	f:SetFrameStrata("HIGH")
	f:SetClampedToScreen(true)
	f:RegisterForDrag("LeftButton")
	f:SetMovable(true)
	f:EnableMouse(true)
	-- Positie herstellen.
	local pos = ns.db and ns.db.ui and ns.db.ui.missingBuffPos
	if type(pos) == "table" and pos[1] then
		f:SetPoint(pos[1], UIParent, pos[2] or pos[1], pos[3] or 0, pos[4] or 0)
	else
		f:SetPoint("CENTER", UIParent, "CENTER", 0, 160)
	end
	if ns.db and ns.db.ui and ns.db.ui.missingBuffScale then
		f:SetScale(ns.db.ui.missingBuffScale)
	end

	local icon = f:CreateTexture(nil, "ARTWORK")
	icon:SetAllPoints(f)
	icon:SetTexCoord(0.07, 0.93, 0.07, 0.93)
	f._icon = icon

	-- Gouden rand rond het icoon (beveled edge, goud getint, met zachte gloed-puls).
	local border = CreateFrame("Frame", nil, f, "BackdropTemplate")
	border:SetPoint("TOPLEFT", f, "TOPLEFT", -4, 4)
	border:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", 4, -4)
	if border.SetBackdrop then
		border:SetBackdrop({
			edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
			edgeSize = 13,
		})
		border:SetBackdropBorderColor(1, 0.82, 0.2, 1) -- goud
	end
	f._border = border

	local label = f:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
	label:SetPoint("TOP", f, "BOTTOM", 0, -2)
	label:SetTextColor(1, 0.3, 0.3)
	f._label = label

	f:SetScript("OnDragStart", function(self)
		if InCombatLockdown and InCombatLockdown() then
			return
		end
		self:StartMoving()
	end)
	f:SetScript("OnDragStop", function(self)
		self:StopMovingOrSizing()
		local p, _, rp, x, y = self:GetPoint()
		if p and ns.db and ns.db.ui then
			ns.db.ui.missingBuffPos = { p, rp, x, y }
		end
		if ns._mhSyncMissingSecure then
			ns._mhSyncMissingSecure()
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
			ns.db.ui.missingBuffScale = s
		end
		if ns._mhSyncMissingSecure then
			ns._mhSyncMissingSecure()
		end
	end)
	f:SetScript("OnEnter", function(self)
		if self._spellId and GameTooltip then
			GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
			GameTooltip:SetSpellByID(self._spellId)
			GameTooltip:AddLine(ns:L("MBUFF_TIP_HINT"), 0.7, 0.7, 0.7, true)
			GameTooltip:Show()
		end
	end)
	f:SetScript("OnLeave", function()
		if GameTooltip then
			GameTooltip:Hide()
		end
	end)
	-- Zachte rode puls op de rand via OnUpdate (robuust op alle client-versies).
	f:SetScript("OnUpdate", function(self, elapsed)
		self._t = (self._t or 0) + elapsed
		local aVal = 0.55 + 0.45 * (0.5 + 0.5 * math.sin(self._t * 2.5))
		self._border:SetAlpha(aVal)
	end)
	f:Hide()
	frame = f
	return f
end

--------------------------------------------------------------------------------
-- Secure klik-laag (klik = buff casten). De truc (zoals MissingClassBuff): een
-- aparte SecureActionButton bovenop het reminder-frame, met een secure STATE-DRIVER
-- die 'm in combat verbergt. Een state-driver mag protected frames in combat
-- tonen/verbergen — iets wat we zélf niet mogen. Zo werkt klikken buiten combat,
-- terwijl het (niet-secure) reminder-frame in combat gewoon zichtbaar blijft.
--------------------------------------------------------------------------------

local secureBtn
local lastCastSpell

-- Positioneer de secure klik-knop ONAFHANKELIJK op UIParent en sync 'm (alleen buiten
-- combat) met het reminder-frame. Cruciaal: we verankeren b NIET met SetAllPoints(f),
-- want een secure frame dat aan f hangt maakt f "protected" → f:Hide()/Show() wordt in
-- combat geblokkeerd (ADDON_ACTION_BLOCKED op MidnightHelperMissingBuff:Hide()).
local function SyncSecurePos(b)
	b = b or secureBtn
	if not b or not frame then
		return
	end
	if InCombatLockdown and InCombatLockdown() then
		return
	end
	b:ClearAllPoints()
	local p, _, rp, x, y = frame:GetPoint()
	if p then
		b:SetPoint(p, UIParent, rp, x, y)
	else
		b:SetPoint("CENTER", UIParent, "CENTER", 0, 160)
	end
	b:SetSize(frame:GetWidth() or 56, frame:GetHeight() or 56)
	b:SetScale(frame:GetScale() or 1)
end
ns._mhSyncMissingSecure = function()
	SyncSecurePos()
end

local function EnsureSecure()
	if secureBtn then
		return secureBtn
	end
	if InCombatLockdown and InCombatLockdown() then
		return nil -- secure frame + anchor alleen buiten combat opzetten
	end
	local f = EnsureFrame()
	local b = CreateFrame("Button", "MidnightHelperMissingBuffCast", UIParent, "SecureActionButtonTemplate")
	-- Onafhankelijk positioneren (zie SyncSecurePos): NIET aan f verankeren, anders wordt f
	-- protected en breekt f:Hide()/Show() in combat.
	-- Klik-knop moet BOVENOP het reminder-frame liggen, anders vangt het frame (strata
	-- HIGH) de klik af en gebeurt er niets. DIALOG-strata ligt boven HIGH.
	b:SetFrameStrata("DIALOG")
	b:SetFrameLevel(f:GetFrameLevel() + 5)
	-- Beide (up én down): een secure knop cast op down óf up afhankelijk van de
	-- ActionButtonUseKeyDown-cvar. Met alleen "AnyUp" gebeurt er niks als de speler
	-- op "down" staat. Zelfde aanpak als MissingClassBuff.
	b:RegisterForClicks("AnyUp", "AnyDown")
	b:RegisterForDrag("LeftButton")
	b:EnableMouse(true)
	RegisterStateDriver(b, "visibility", "[combat] hide; nil")
	b:SetScript("OnDragStart", function()
		if InCombatLockdown and InCombatLockdown() then
			return
		end
		f:StartMoving()
	end)
	b:SetScript("OnDragStop", function()
		f:StopMovingOrSizing()
		local p, _, rp, x, y = f:GetPoint()
		if p and ns.db and ns.db.ui then
			ns.db.ui.missingBuffPos = { p, rp, x, y }
		end
		SyncSecurePos(b)
	end)
	b:SetScript("OnEnter", function(self)
		if f._spellId and GameTooltip then
			GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
			GameTooltip:SetSpellByID(f._spellId)
			GameTooltip:AddLine(ns:L("MBUFF_TIP_HINT"), 0.7, 0.7, 0.7, true)
			GameTooltip:Show()
		end
	end)
	b:SetScript("OnLeave", function()
		if GameTooltip then
			GameTooltip:Hide()
		end
	end)
	SyncSecurePos(b)
	b:Hide()
	secureBtn = b
	return b
end

-- Zet het cast-attribuut (alleen buiten combat toegestaan op een secure frame).
local function ApplySecureCast(entry)
	local b = secureBtn
	if not b or (InCombatLockdown and InCombatLockdown()) then
		return
	end
	if entry and entry.macroTarget then
		-- Ally-buff: cast op mouseover → target → focus (helpful, niet dood).
		b:SetAttribute("type", "macro")
		b:SetAttribute("macrotext",
			"/cast [@mouseover,help,nodead][@target,help,nodead][@focus,help,nodead] " .. (entry.name or ""))
		b:SetAttribute("spell", nil)
	elseif entry and entry.spell then
		-- Spell-ID direct (niet de naam): hernoemde pets/spells geven een niet-castbare
		-- naam (bv. "Call Balou" i.p.v. "Call Pet 1"). Het ID werkt altijd.
		b:SetAttribute("type", "spell")
		b:SetAttribute("spell", entry.spell)
		b:SetAttribute("macrotext", nil)
	else
		b:SetAttribute("type", nil)
		b:SetAttribute("spell", nil)
		b:SetAttribute("macrotext", nil)
	end
	lastCastSpell = entry and entry.spell or nil
end

local function HideSecure()
	-- Buiten combat verbergen we de klikknop zelf; in combat doet de state-driver dat.
	if secureBtn and not (InCombatLockdown and InCombatLockdown()) then
		secureBtn:Hide()
	end
end

function ns.UpdateMissingBuff()
	if not Enabled() then
		if frame then
			frame:Hide()
		end
		HideSecure()
		return
	end
	-- Afgeschermd: een fout in de detectie (bv. secret-values op groepsleden) mag de
	-- reminder nooit laten vastlopen op een oude stand.
	local ok, missing = pcall(ns.GetMissingBuffs)
	if not ok or type(missing) ~= "table" then
		missing = {}
	end
	local inCombat = InCombatLockdown and InCombatLockdown()
	-- Filter op combat: buiten combat alles; in combat alleen showCombat-items.
	local top
	for _, m in ipairs(missing) do
		if (not inCombat) or m.showCombat then
			top = m
			break
		end
	end
	if not top then
		if frame then
			frame:Hide()
		end
		HideSecure()
		return
	end
	local f = EnsureFrame()
	f._icon:SetTexture(top.icon)
	f._spellId = top.spell
	f._label:SetText(ns:L(top.textKey))
	f:Show()
	-- Klikbaar casten: buiten combat de secure knop bijwerken + tonen. In combat laten
	-- we 'm met rust (state-driver houdt 'm verborgen); de reminder blijft wél zichtbaar.
	if not inCombat then
		local b = EnsureSecure()
		if b then
			if lastCastSpell ~= top.spell then
				ApplySecureCast(top)
			end
			SyncSecurePos(b)
			b:Show()
		end
	end
end

--------------------------------------------------------------------------------
-- Events
--------------------------------------------------------------------------------

local throttle = 0
local ev = CreateFrame("Frame")
ev:RegisterEvent("PLAYER_ENTERING_WORLD")
ev:RegisterEvent("PLAYER_LOGIN")
ev:RegisterEvent("UNIT_AURA")
ev:RegisterEvent("SPELLS_CHANGED")
ev:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED")
ev:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
ev:RegisterEvent("UPDATE_SHAPESHIFT_FORM")
ev:RegisterEvent("UNIT_PET")
ev:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")
ev:RegisterEvent("UNIT_INVENTORY_CHANGED")
ev:RegisterEvent("PLAYER_REGEN_ENABLED")
ev:RegisterEvent("PLAYER_REGEN_DISABLED")
ev:RegisterEvent("PLAYER_MOUNT_DISPLAY_CHANGED")
ev:RegisterEvent("GROUP_ROSTER_UPDATE") -- ally-buffs: groep verandert
ev:RegisterEvent("PLAYER_ROLES_ASSIGNED") -- healer-in-groep-detectie

local function ScheduleUpdate()
	if throttle > 0 then
		return
	end
	throttle = 1
	if C_Timer and C_Timer.After then
		C_Timer.After(0.25, function()
			throttle = 0
			ns.UpdateMissingBuff()
		end)
	else
		throttle = 0
		ns.UpdateMissingBuff()
	end
end

ev:SetScript("OnEvent", function(_, event, unit)
	if event == "UNIT_PET" then
		if unit and unit ~= "player" then
			return
		end
	elseif event == "UNIT_AURA" then
		-- speler + groepsleden (ally-buffs); overige units negeren.
		if unit and unit ~= "player" and not (unit:find("^party") or unit:find("^raid")) then
			return
		end
	end
	if event == "PLAYER_LOGIN" or event == "PLAYER_ENTERING_WORLD" then
		-- Frame + secure klik-laag buiten combat opzetten (anchor/state-driver mogen
		-- niet in combat). Daarna pas de eerste zichtbaarheids-update.
		EnsureFrame()
		EnsureSecure()
	end
	ScheduleUpdate()
end)
