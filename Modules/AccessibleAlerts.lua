--[[
	Accessible Alerts — debuff-versie (Rob 15 jun, idee 2, voor zijn zus). Eén
	grote, rustige melding zodra JIJ een gevaarlijke debuff krijgt, met geluid.
	Opt-in (standaard uit).

	Waarom debuffs: in 12.x zijn vijandelijke cast-ID's/namen 'secret' (Rob's live
	test) → een interrupt-alert kan niet. Maar JOUW EIGEN auras zijn WEL leesbaar
	(bevestigd: de logger ving "57724 Sated"). Dus reageren we op je eigen debuffs.

	Werking: bij UNIT_AURA op "player" scannen we je debuffs; staat er één in
	`ns.DEBUFF_ALERTS`, dan flitst de bijbehorende boodschap (of een generieke met
	de debuff-naam). Per debuff ~6s rust + 4s globale pauze (geen spam). Alleen in
	dungeon/scenario (rituals zijn scenario's).

	De lijst groeit zodra de RitualBossCoach-debuff-logger nieuwe ID's vangt
	(/mh ritualspy → "DEBUFF op jou: <id> (<naam>)"). never-lie: alleen ID's die
	we kennen; geen gegokte.

	Taint-veilig: UNIT_AURA is een gewoon event; eigen-aura-reads + een frame tonen
	zijn niet beschermd. Alles wat een aura aanraakt staat alsnog in pcall.
]]

local _, ns = ...

-- Gevaarlijke debuffs op de speler → melding. Waarde = locale-key met een
-- specifieke instructie, of `true` voor een generieke melding met de naam.
-- Vul aan zodra de logger nieuwe ID's bevestigt (Binding Nebula e.d.).
ns.DEBUFF_ALERTS = {
	[440313] = "ALERT_DEBUFF_DEVOURING_RIFT", -- M+ Xal'atath's Bargain: Devour
}

local MIN_GAP = 4.0       -- seconden tussen twee meldingen (rust)
local PER_SPELL_GAP = 6.0 -- dezelfde debuff niet vaker dan dit melden

local lastAlertAt = 0
local lastBySpell = {}
local flash

local function Settings()
	if not ns.db then
		return nil
	end
	ns.db.alerts = ns.db.alerts or {}
	local a = ns.db.alerts
	if a.enabled == nil then
		a.enabled = false
	end
	if a.sound == nil then
		a.sound = true
	end
	return a
end

local function EnsureFlash()
	if flash then
		return flash
	end
	local f = CreateFrame("Frame", "MidnightHelperAlert", UIParent)
	f:SetSize(600, 110)
	f:SetPoint("TOP", UIParent, "TOP", 0, -200)
	f:SetFrameStrata("HIGH")
	-- Contrast-achtergrond (toegankelijkheid: leesbaar boven elk decor).
	local bg = f:CreateTexture(nil, "BACKGROUND")
	bg:SetAllPoints()
	bg:SetColorTexture(0, 0, 0, 0.55)
	f.bg = bg
	local t = f:CreateFontString(nil, "OVERLAY", "GameFontNormalHuge")
	t:SetPoint("CENTER")
	t:SetJustifyH("CENTER")
	t:SetTextColor(1, 0.85, 0.1)
	f.text = t
	f.anim = f:CreateAnimationGroup()
	local a1 = f.anim:CreateAnimation("Alpha")
	a1:SetFromAlpha(0); a1:SetToAlpha(1); a1:SetDuration(0.12); a1:SetOrder(1)
	local a2 = f.anim:CreateAnimation("Alpha")
	a2:SetFromAlpha(1); a2:SetToAlpha(1); a2:SetDuration(2.0); a2:SetOrder(2)
	local a3 = f.anim:CreateAnimation("Alpha")
	a3:SetFromAlpha(1); a3:SetToAlpha(0); a3:SetDuration(0.7); a3:SetOrder(3)
	f.anim:SetScript("OnFinished", function()
		f:Hide()
	end)
	f:Hide()
	flash = f
	return f
end

local function Show(msg, withSound)
	local f = EnsureFlash()
	f.text:SetText(msg or "")
	f:Show()
	f.anim:Stop()
	f.anim:Play()
	if withSound and PlaySound and SOUNDKIT and SOUNDKIT.RAID_WARNING then
		pcall(PlaySound, SOUNDKIT.RAID_WARNING, "Master")
	end
end

-- Testmelding (knop in de beginnersmodus), zodat ze buiten gevecht ziet hoe het
-- eruitziet.
function ns.ShowAccessibleAlertTest()
	local a = Settings()
	Show(ns:L("ALERT_TEST"), a and a.sound)
end

local function InInstanceForAlerts()
	if not IsInInstance then
		return false
	end
	local inInst, kind = IsInInstance()
	return inInst and (kind == "party" or kind == "scenario") or false
end

local function ScanDebuffs()
	local a = Settings()
	if not (a and a.enabled) then
		return
	end
	if not InInstanceForAlerts() then
		return
	end
	local now = (GetTime and GetTime()) or 0
	if now - lastAlertAt < MIN_GAP then
		return
	end
	-- Eigen auras zijn leesbaar; tóch alles in pcall voor de zekerheid.
	local fired
	pcall(function()
		for i = 1, 60 do
			local id, nm
			if C_UnitAuras and C_UnitAuras.GetDebuffDataByIndex then
				local au = C_UnitAuras.GetDebuffDataByIndex("player", i)
				if not au then
					break
				end
				id, nm = au.spellId, au.name
			elseif UnitDebuff then
				local n2, _, _, _, _, _, _, _, _, sid = UnitDebuff("player", i)
				if not n2 then
					break
				end
				id, nm = sid, n2
			else
				break
			end
			local key = id and ns.DEBUFF_ALERTS[id]
			if key and (lastBySpell[id] or 0) + PER_SPELL_GAP <= now then
				lastBySpell[id] = now
				if type(key) == "string" then
					fired = ns:L(key)
				else
					fired = ns:L("ALERT_DEBUFF_FMT"):format(tostring(nm))
				end
				break
			end
		end
	end)
	if fired then
		lastAlertAt = now
		Show(fired, a.sound)
	end
end

local f = CreateFrame("Frame")
f:RegisterEvent("UNIT_AURA")
f:SetScript("OnEvent", function(_, _, unit)
	if unit == "player" then
		ScanDebuffs()
	end
end)

--------------------------------------------------------------------------------
-- Toggle-API voor de UI.
--------------------------------------------------------------------------------

function ns.AccessibleAlertsEnabled()
	local a = Settings()
	return (a and a.enabled) or false
end

function ns.ToggleAccessibleAlerts()
	local a = Settings()
	if not a then
		return false
	end
	a.enabled = not a.enabled
	if print then
		print("|cff66ccff[MH]|r " .. ns:L(a.enabled and "ALERT_ENABLED_MSG" or "ALERT_DISABLED_MSG"))
	end
	return a.enabled
end
