--[[
	Tank pull-summary (Rob 2026-07-15, after seeing TankTraining's "Pull Summary";
	pairs with the tank toolkit — "here are your buttons" → "here's how you used
	them"). On each meaningful pull it prints one gentle line: how many times you
	pressed your active mitigation, which defensive cooldowns you used (or none),
	and a soft tip.

	NEVER-LIE — factual only. It counts YOUR OWN casts via UNIT_SPELLCAST_SUCCEEDED
	(readable for the player, unlike others' secret combat info) against the
	verified TANK_MITIGATION + TANK_COOLDOWNS spell lists (Modules/TankToolkit.lua).
	No invented "ideal uptime %" — we don't guess benchmarks. Names resolve live.
	(Active-mitigation UPTIME % is a planned v2 once the buff IDs are verified.)

	Opt-in (default off; per-pull chat is easy to over-do). /mh pullsummary toggles.
	Only tank specs, only in instances, only pulls >= MIN_PULL seconds.
]]

local _, ns = ...

local MIN_PULL = 12 -- seconds; skip trivial trash so it isn't spammy

local inCombat, pullStart, specID, tracked
local castCount = {}
local mitId, upTime, sampleAccum

local function enabled()
	return ns.db and ns.db.tankPullSummary == true
end

local function InInstance()
	if not IsInInstance then
		return false
	end
	local inInst, kind = IsInInstance()
	return inInst and (kind == "party" or kind == "raid" or kind == "scenario") or false
end

-- spellID -> "mit" | "cd" for the current tank spec (from the toolkit data).
local function BuildTracked(id)
	local set = {}
	for _, m in ipairs((ns.GetTankMitigation and ns.GetTankMitigation(id)) or {}) do
		set[m.id] = "mit"
	end
	for _, c in ipairs((ns.GetTankCooldowns and ns.GetTankCooldowns(id)) or {}) do
		set[c.id] = "cd"
	end
	return set
end

local function fmtDur(sec)
	sec = math.floor(sec or 0)
	if sec < 60 then
		return sec .. "s"
	end
	return string.format("%dm %02ds", math.floor(sec / 60), sec % 60)
end

local function SpellName(id)
	if ns.HealerCooldownSpellName then
		return ns.HealerCooldownSpellName(id)
	end
	return "spell " .. tostring(id)
end

-- Active-mitigation BUFF to measure uptime on, per tank spec. IDs verified from
-- the installed TankTraining (which measures exactly this): cast==buff for most
-- (Shield Block 2565, Ironfur 192081, Demon Spikes 203720); Bone Shield is the
-- BUFF 195181 (cast is Marrowrend 195182). Shield of the Righteous has internal
-- talent variants (the buff id 132403 ≠ cast 53600), so it's matched by NAME
-- below (robust, no unverified id). Brewmaster is Stagger-based (no simple buff
-- uptime) → omitted. never-lie: we only report the measured %, no invented ideal.
local MITIGATION_UPTIME = {
	[66] = 53600, -- Prot Paladin: Shield of the Righteous (name-matched)
	[73] = 2565, -- Prot Warrior: Shield Block
	[104] = 192081, -- Guardian Druid: Ironfur
	[250] = 195181, -- Blood DK: Bone Shield (buff)
	[581] = 203720, -- Vengeance DH: Demon Spikes
}

-- Is the mitigation buff `id` up right now? id-match first (cast==buff for most),
-- then a NAME fallback (Shield of the Righteous: buff id differs from the cast
-- but shares the name). Secret aura fields are skipped.
local function IsMitUp(id)
	if ns.Aura and ns.Aura.HasPlayerAura and ns.Aura.HasPlayerAura(id) then
		return true
	end
	local nm = C_Spell and C_Spell.GetSpellName and C_Spell.GetSpellName(id)
	if nm and nm ~= "" and ns.Aura and ns.Aura.ForEachPlayerBuff then
		local found = false
		ns.Aura.ForEachPlayerBuff(function(aura)
			local an = aura.name
			if an ~= nil and not (issecretvalue and issecretvalue(an)) and an == nm then
				found = true
				return true
			end
		end)
		return found
	end
	return false
end

local function ShowSummary(dur)
	local prefix = ("|cffffcc00%s|r"):format(ns:L("PRINT_PREFIX"))
	-- Active-mitigation presses (sum across the spec's mitigation buttons).
	local mitParts, cdParts = {}, {}
	for id, kind in pairs(tracked or {}) do
		local n = castCount[id]
		if n and n > 0 then
			if kind == "mit" then
				mitParts[#mitParts + 1] = ("%s |cff9d9d9d×%d|r"):format(SpellName(id), n)
			else
				cdParts[#cdParts + 1] = SpellName(id)
			end
		end
	end
	local mitStr = (#mitParts > 0) and table.concat(mitParts, ", ") or ns:L("PULLSUM_NO_MIT")
	-- Measured active-mitigation uptime % (factual — no ideal-benchmark comparison).
	if mitId and dur > 0 then
		local pct = math.floor(((upTime or 0) / dur) * 100 + 0.5)
		if pct > 100 then
			pct = 100
		end
		mitStr = mitStr .. (" |cff9d9d9d(%s)|r"):format((ns:L("PULLSUM_UPTIME_FMT")):format(pct))
	end
	local cdStr = (#cdParts > 0) and (ns:L("PULLSUM_DEF_FMT")):format(table.concat(cdParts, ", ")) or ns:L("PULLSUM_NO_DEF")
	print(("%s |cff8fd3ff%s|r (%s): %s · %s"):format(prefix, ns:L("PULLSUM_HEAD"), fmtDur(dur), mitStr, cdStr))
	-- Soft tip only when no defensive cooldown was pressed — never an absolute judgment.
	if #cdParts == 0 then
		print(("   |cff9d9d9d%s|r"):format(ns:L("PULLSUM_TIP_NODEF")))
	end
end

local f = CreateFrame("Frame")

-- Sample the mitigation buff ~5×/sec during combat and accumulate its up-time.
local function Sampler(_, elapsed)
	if not (inCombat and mitId) then
		return
	end
	sampleAccum = (sampleAccum or 0) + elapsed
	if sampleAccum < 0.2 then
		return
	end
	if IsMitUp(mitId) then
		upTime = (upTime or 0) + sampleAccum
	end
	sampleAccum = 0
end

f:RegisterEvent("PLAYER_REGEN_DISABLED")
f:RegisterEvent("PLAYER_REGEN_ENABLED")
f:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", "player")
f:SetScript("OnEvent", function(_, event, unit, _, spellID)
	if event == "PLAYER_REGEN_DISABLED" then
		specID = enabled() and InInstance() and ns.GetPlayerTankSpecID and ns.GetPlayerTankSpecID() or nil
		if specID then
			inCombat = true
			pullStart = GetTime and GetTime() or 0
			tracked = BuildTracked(specID)
			wipe(castCount)
			mitId = MITIGATION_UPTIME[specID]
			upTime, sampleAccum = 0, 0
			f:SetScript("OnUpdate", Sampler)
		end
	elseif event == "PLAYER_REGEN_ENABLED" then
		if inCombat then
			inCombat = false
			f:SetScript("OnUpdate", nil)
			local dur = (GetTime and GetTime() or 0) - (pullStart or 0)
			if dur >= MIN_PULL then
				pcall(ShowSummary, dur)
			end
		end
	elseif event == "UNIT_SPELLCAST_SUCCEEDED" then
		-- args: unit, castGUID, spellID. RegisterUnitEvent already filters to player.
		if inCombat and tracked and spellID and tracked[spellID] then
			castCount[spellID] = (castCount[spellID] or 0) + 1
		end
	end
end)

--- /mh pullsummary — toggle the per-pull tank summary.
function ns.ToggleTankPullSummary()
	ns.db = ns.db or {}
	ns.db.tankPullSummary = not (ns.db.tankPullSummary == true)
	local prefix = ("|cffffcc00%s|r"):format(ns:L("PRINT_PREFIX"))
	print(("%s %s"):format(prefix, ns:L(ns.db.tankPullSummary and "PULLSUM_ON" or "PULLSUM_OFF")))
	return ns.db.tankPullSummary == true
end
