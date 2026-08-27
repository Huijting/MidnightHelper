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
	-- This alert must outrank the toast. MidnightHelperToast sits at
	-- FULLSCREEN_DIALOG level 120, and FULLSCREEN_DIALOG draws over HIGH — so this
	-- frame used to lose, silently, to a rare-alert or a tank-pull summary. Those
	-- queue in and around combat: exactly when a dangerous debuff fires. Same strata,
	-- higher level, so this now wins.
	--
	-- Geometry alone could not fix it: the toast is draggable and its position is
	-- saved per player (ui.toast.pos), so no fixed offset here can promise they never
	-- meet. Ordering can, and that is the part that matters — this frame exists for
	-- players who need one calm, readable warning.
	--
	-- Four MH frames still sit at TOOLTIP, which outranks FULLSCREEN_DIALOG: the rare,
	-- mount and Trading Post previews, and the delve travel popup. Left alone on
	-- purpose — all four only appear because the player opened or hovered something in
	-- our own UI, never unbidden mid-fight. Raising this frame to TOOLTIP would put a
	-- 600x110 panel over the game's real tooltips, which is a worse trade.
	f:SetFrameStrata("FULLSCREEN_DIALOG")
	f:SetFrameLevel(200)
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

--- The ONE way an alert reaches the screen, cooldown included.
---
--- 🔴 THE GAP IS NOT OPTIONAL, AND THAT IS THE POINT OF THIS FUNCTION. `/mh dispeltest
--- show` has to travel the same road as a real debuff; a test that quietly skips
--- MIN_GAP would pass on the exact build where a double-alert bug lives. So the test
--- calls this, ScanDebuffs calls this, and there is no third door.
---
--- @return boolean fired
--- @return number|nil secondsLeft  when it did not, how long the caller must wait
function ns.FireAccessibleAlert(msg, withSound)
	local now = (GetTime and GetTime()) or 0
	local waited = now - lastAlertAt
	if waited < MIN_GAP then
		return false, MIN_GAP - waited
	end
	lastAlertAt = now
	Show(msg, withSound)
	return true
end

--- Scope of the ACCESSIBILITY alert: dungeons and scenarios, as the header says and as
--- Rob asked for. Deliberate, unchanged.
local function InInstanceForAlerts()
	if not IsInInstance then
		return false
	end
	local inInst, kind = IsInInstance()
	return inInst and (kind == "party" or kind == "scenario") or false
end

--- 🔴 SCOPE OF THE DISPEL ALERT — ITS OWN, AND RAIDS ARE IN IT.
---
--- The dispel alert was hooked into this scan on 27 jul, and the comment there explains
--- why sharing the scan was right: one UNIT_AURA handler, one cooldown, no doubled work.
--- What nobody separated was the GATE. It silently inherited a scope chosen for a
--- different feature — "dungeons and scenarios", picked for Rob's sister and dangerous
--- debuffs — and so said nothing in a raid, which is where dispelling matters most.
---
--- Found 25 aug because Rob logged onto a druid and saw another addon shout at him about a
--- removable debuff. Ours would have stayed quiet: he was not in a party instance.
---
--- ⚠️ Open world deliberately still excluded, pending Rob's call. A dispellable debuff out
--- there is constant and a flashing warning for every one of them is how a good alert
--- teaches people to ignore it. Raids are not a judgement call; the world is.
local function InInstanceForDispelAlert()
	if not IsInInstance then
		return false
	end
	local inInst, kind = IsInInstance()
	return inInst and (kind == "party" or kind == "scenario" or kind == "raid") or false
end

local function ScanDebuffs()
	local a = Settings()
	-- Two independent features share this scan, so the gate is "either is on", not
	-- "the accessibility one is on". Getting this wrong would have made the dispel
	-- alert's separate setting a lie: switching it on while accessibility alerts
	-- were off would have produced silence with no way to tell why.
	local wantAccessible = (a and a.enabled) and true or false
	local wantDispel = ns.DispelAlertEnabled and ns.DispelAlertEnabled() or false
	if not (wantAccessible or wantDispel) then
		return
	end
	-- Each feature answers to its own scope. Sharing the scan is right; sharing the gate
	-- was not, and it kept the dispel alert silent in raids (see InInstanceForDispelAlert).
	wantAccessible = wantAccessible and InInstanceForAlerts()
	wantDispel = wantDispel and InInstanceForDispelAlert()
	if not (wantAccessible or wantDispel) then
		return
	end
	local now = (GetTime and GetTime()) or 0
	if now - lastAlertAt < MIN_GAP then
		return
	end
	-- Alle aura-reads lopen via ns.Aura (zie Modules/Auras.lua): guards, secret-values
	-- en de 12.1-API-migratie zitten daar op één plek. Kan de scan niet, dan zwijgen we.
	local fired
	ns.Aura.ForEachPlayerDebuff(function(aura)
		local id, nm = aura.spellId, aura.name
		-- 12.1: an aura's spellId can be a SECRET value (e.g. inside instances). A
		-- secret can't be used as a table key AND we can't match it against our list,
		-- so treat it as unreadable and skip (never-lie: unreadable ≠ absent) instead
		-- of erroring on ns.DEBUFF_ALERTS[id].
		if id == nil or (issecretvalue and issecretvalue(id)) then
			return
		end
		-- Second reason to speak up, added 2026-07-27: this debuff is one YOU can
		-- remove. DispelHelper owns that decision and its own opt-in; it is hooked
		-- in here rather than given its own UNIT_AURA handler, so both features
		-- share this scan, this global cooldown and this per-spell cooldown instead
		-- of doubling the work on every aura change.
		if wantDispel and ns.GetDispelAlertFor and (lastBySpell[id] or 0) + PER_SPELL_GAP <= now then
			local msg = ns.GetDispelAlertFor(aura)
			if msg then
				lastBySpell[id] = now
				fired = msg
				return true
			end
		end
		local key = wantAccessible and ns.DEBUFF_ALERTS[id] or nil
		if key and (lastBySpell[id] or 0) + PER_SPELL_GAP <= now then
			lastBySpell[id] = now
			if type(key) == "string" then
				fired = ns:L(key)
			else
				local safeNm = (nm ~= nil and not (issecretvalue and issecretvalue(nm))) and tostring(nm) or "?"
				fired = ns:L("ALERT_DEBUFF_FMT"):format(safeNm)
			end
			return true -- stop scanning
		end
	end)
	if fired then
		-- Through the shared door, so the test above exercises this exact code.
		ns.FireAccessibleAlert(fired, a.sound)
	end
end

local f = CreateFrame("Frame")
f:RegisterUnitEvent("UNIT_AURA", "player") -- engine-filter: alleen eigen auras (F3.4)
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

-- Expliciete setter (voor de native-settings-toggle; getter = AccessibleAlertsEnabled).
function ns.SetAccessibleAlertsEnabled(v)
	local a = Settings()
	if not a then
		return
	end
	a.enabled = v and true or false
end
