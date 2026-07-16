--[[
	Auras — the single door through which Midnight Helper reads buffs and debuffs.

	WHY THIS EXISTS. Patch 12.1 ("Curse of Ula'tek") changes how addons may read auras.
	Blizzard's own words: the game will stop auras "whether on the player, enemies, or
	party and raid members" from leaking combat information, and "addons that currently
	display auras will need to be updated to support these new APIs". As of this writing
	they have published no function names — there is nothing to migrate TO yet. So the
	preparation is to make the migration small: every aura read in this addon goes
	through this file, and when the new API lands, only this file changes.

	TWO DIFFERENT QUESTIONS. Keep them apart, because conflating them breaks things:

	  "Could I read?"     — the API exists and answered. A read returns nil when it did
	                        not: nil means UNKNOWN, never "absent". Callers that would
	                        otherwise announce a missing buff must branch on `== false`.

	  "Can I trust it?"   — Trusted(). In restricted content (delves, ritual sites, M+)
	                        the API answers, but not with the truth: a buff you are
	                        holding can read as absent. That is how Missing Buff came to
	                        nag Cisca about a shield she already had (5 July).

	A scan still runs in restricted content — the debuff spy and the accessibility
	alerts depend on it and match by spell ID, skipping secret values rather than
	comparing against them. Only a caller about to conclude "you are MISSING this"
	needs Trusted(). Gating every read on Trusted() would silence those two modules in
	exactly the content they exist for.
]]

local _, ns = ...

ns.Aura = ns.Aura or {}
local Aura = ns.Aura

local MAX_SCAN = 60 -- Blizzard's own aura frames stop here; 40 truncates long buff lists

local function Secret(v)
	return issecretvalue and issecretvalue(v)
end

--------------------------------------------------------------------------------
-- Can we believe what we read?
--------------------------------------------------------------------------------

--- Blizzard's own aura-specific flag is authoritative — when it exists, trust it and do
--- not second-guess it.
---
--- The health fallback exists only for clients without that flag, and is deliberately
--- NOT consulted otherwise: player HEALTH is already secret in open-world Midnight zones
--- (Harandar) while auras read perfectly well there. Stacking the health check on top of
--- the aura flag once suppressed the missing-buff reminder across the entire open world.
--- @return boolean true when an aura read can be believed
function Aura.Trusted()
	if not (C_UnitAuras and C_UnitAuras.GetPlayerAuraBySpellID) then
		return false
	end
	if C_Secrets and C_Secrets.ShouldAurasBeSecret then
		local ok, secret = pcall(C_Secrets.ShouldAurasBeSecret)
		if ok then
			return not secret
		end
	end
	if issecretvalue and UnitHealth then
		local ok, hp = pcall(UnitHealth, "player")
		if ok and hp ~= nil and Secret(hp) then
			return false
		end
	end
	return true
end

--------------------------------------------------------------------------------
-- Reads. nil = could not read. false = read fine, it is not there.
--------------------------------------------------------------------------------

--- The player's own aura by spell ID, as a data table (nil when absent or unreadable).
---
--- Both lookups take a spell ID, so neither compares a possibly-secret `aura.spellId`
--- addon-side. GetAuraDataBySpellID is tried first because it also finds auras the
--- player-specific call misses; it does not exist on every client, hence the fallback.
--- @return table|nil auraData, boolean readable
function Aura.GetPlayerAura(spellID)
	if not (spellID and C_UnitAuras) then
		return nil, false
	end
	local readable = false
	if C_UnitAuras.GetAuraDataBySpellID then
		local ok, data = pcall(C_UnitAuras.GetAuraDataBySpellID, "player", spellID)
		if ok then
			readable = true
			if data then
				return data, true
			end
		end
	end
	if C_UnitAuras.GetPlayerAuraBySpellID then
		local ok, data = pcall(C_UnitAuras.GetPlayerAuraBySpellID, spellID)
		if ok then
			return data, true
		end
	end
	return nil, readable
end

--- @return true|false|nil — nil means "could not read", NOT "absent"
function Aura.HasPlayerAura(spellID)
	local data, readable = Aura.GetPlayerAura(spellID)
	if not readable then
		return nil
	end
	return data ~= nil
end

--- Does `unit` carry the helpful aura `spellID`?
---
--- The player has a direct, secret-safe lookup. For anyone else we scan their helpful
--- auras and match the spell ID, skipping secret values rather than comparing against
--- them. This is exactly the read 12.1 restricts for party and raid members, so expect
--- it to be the first that starts returning nil.
--- @return true|false|nil
function Aura.HasUnitBuff(unit, spellID)
	if not (unit and spellID) then
		return nil
	end
	if unit == "player" then
		return Aura.HasPlayerAura(spellID)
	end
	if not (C_UnitAuras and C_UnitAuras.GetAuraDataByIndex) then
		return nil
	end
	for i = 1, MAX_SCAN do
		local ok, aura = pcall(C_UnitAuras.GetAuraDataByIndex, unit, i, "HELPFUL")
		if not ok then
			return nil -- the API refused: unknown, not absent
		end
		if not aura then
			return false -- ran off the end of the list: genuinely absent
		end
		local sid = aura.spellId
		if sid and not Secret(sid) and sid == spellID then
			return true
		end
	end
	return false
end

--- Shared index scan. ForEachAura would be tidier, but it hides the difference between
--- "no auras" and "not allowed to look", and that difference is the whole contract.
--- `fn(auraData)` may return true to stop early.
--- @return boolean true when the scan actually ran to completion
local function Scan(unit, filter, fn)
	if type(fn) ~= "function" or not C_UnitAuras then
		return false
	end
	-- Prefer the same call the callers used before this file existed, rather than
	-- assuming GetAuraDataByIndex(unit, i, "HARMFUL") behaves identically.
	local get, arg = C_UnitAuras.GetAuraDataByIndex, filter
	if filter == "HARMFUL" and C_UnitAuras.GetDebuffDataByIndex then
		get, arg = C_UnitAuras.GetDebuffDataByIndex, nil
	end
	if not get then
		return false
	end
	for i = 1, MAX_SCAN do
		local ok, aura = pcall(get, unit, i, arg)
		if not ok then
			return false
		end
		if not aura then
			return true -- end of the list; the scan was valid
		end
		local stop = false
		local okFn, err = pcall(function()
			stop = fn(aura) and true or false
		end)
		if not okFn then
			geterrorhandler()(err)
			return false
		end
		if stop then
			return true
		end
	end
	return true
end

--- Walk the player's helpful auras. @return boolean scan happened
function Aura.ForEachPlayerBuff(fn)
	return Scan("player", "HELPFUL", fn)
end

--- Walk the player's harmful auras. @return boolean scan happened
function Aura.ForEachPlayerDebuff(fn)
	return Scan("player", "HARMFUL", fn)
end

--- Walk any unit's harmful auras (party/raid members included). This is exactly
--- the read 12.1 restricts for other players — the scan still runs, but fields
--- may come back SECRET; callers must guard with issecretvalue and never compare
--- a possibly-secret field. Used by the dispel-readability probe (and, if that
--- probe shows fields are readable, a future live dispel heads-up).
--- @return boolean scan happened
function Aura.ForEachUnitDebuff(unit, fn)
	return Scan(unit, "HARMFUL", fn)
end

--------------------------------------------------------------------------------
-- Diagnostics: `/mh auras` — the first thing to run when 12.1 hits the PTR.
--------------------------------------------------------------------------------

function ns.PrintAuraDiagnostics()
	local p = "|cffffff78Midnight Helper:|r "
	local secret = "n/a"
	if C_Secrets and C_Secrets.ShouldAurasBeSecret then
		local ok, v = pcall(C_Secrets.ShouldAurasBeSecret)
		secret = ok and tostring(v) or "error"
	end
	print(p .. "aura readability")
	print(("  Trusted()              = %s"):format(tostring(Aura.Trusted())))
	print(("  ShouldAurasBeSecret    = %s"):format(secret))
	print(("  GetPlayerAuraBySpellID = %s"):format(tostring(C_UnitAuras and C_UnitAuras.GetPlayerAuraBySpellID ~= nil)))
	print(("  GetAuraDataByIndex     = %s"):format(tostring(C_UnitAuras and C_UnitAuras.GetAuraDataByIndex ~= nil)))
	local buffs, debuffs = 0, 0
	local okBuff = Aura.ForEachPlayerBuff(function()
		buffs = buffs + 1
	end)
	local okDebuff = Aura.ForEachPlayerDebuff(function()
		debuffs = debuffs + 1
	end)
	print(("  helpful auras on you   = %s"):format(okBuff and tostring(buffs) or "could not scan"))
	print(("  harmful auras on you   = %s"):format(okDebuff and tostring(debuffs) or "could not scan"))
end

-- /mh dispelprobe — decides whether a LIVE "dispellable debuff on ally X" alert
-- is even possible on this client. It scans party/raid members' harmful auras
-- and reports whether the fields a dispel alert needs (dispelName = the school,
-- spellId, name) come back readable or SECRET. Run it inside a dungeon while
-- allies are debuffed. never-lie: it never compares a secret, only checks
-- issecretvalue and tostring's the readable ones.
function ns.PrintDispelProbe()
	local p = "|cffffff78Midnight Helper:|r "
	local function isSecret(v)
		return issecretvalue and v ~= nil and issecretvalue(v) == true
	end

	local inInst, kind = false, "none"
	if IsInInstance then
		inInst, kind = IsInInstance()
	end
	local diff = (inInst and GetInstanceInfo) and select(3, GetInstanceInfo()) or 0
	print(p .. "dispel readability probe")
	print(("  in instance: %s (%s, diff %s)   auras trusted: %s"):format(
		tostring(inInst), tostring(kind), tostring(diff), tostring(Aura.Trusted())))

	-- Group unit list (skip yourself).
	local units = {}
	if IsInRaid and IsInRaid() then
		for i = 1, 40 do
			local u = "raid" .. i
			if UnitExists(u) and not UnitIsUnit(u, "player") then
				units[#units + 1] = u
			end
		end
	elseif IsInGroup and IsInGroup() then
		for i = 1, 4 do
			local u = "party" .. i
			if UnitExists(u) then
				units[#units + 1] = u
			end
		end
	end
	if #units == 0 then
		print("  no party/raid members found — join a group in a dungeon and rerun.")
		return
	end

	local nUnits, nDebuffs, idOK, typeOK, nameOK = 0, 0, 0, 0, 0
	local sample
	for _, u in ipairs(units) do
		nUnits = nUnits + 1
		Aura.ForEachUnitDebuff(u, function(aura)
			nDebuffs = nDebuffs + 1
			local idR = aura.spellId ~= nil and not isSecret(aura.spellId)
			local typeR = aura.dispelName ~= nil and not isSecret(aura.dispelName)
			local nameR = aura.name ~= nil and not isSecret(aura.name)
			if idR then idOK = idOK + 1 end
			if typeR then typeOK = typeOK + 1 end
			if nameR then nameOK = nameOK + 1 end
			if not sample then
				sample = ("%s spellId=%s dispelName=%s name=%s"):format(
					u,
					idR and tostring(aura.spellId) or (isSecret(aura.spellId) and "<secret>" or "nil"),
					typeR and tostring(aura.dispelName) or (isSecret(aura.dispelName) and "<secret>" or "nil"),
					nameR and ('"' .. tostring(aura.name) .. '"') or (isSecret(aura.name) and "<secret>" or "nil")
				)
			end
		end)
	end
	print(("  units checked: %d   debuffs seen: %d"):format(nUnits, nDebuffs))
	print(("  spellId readable: %d/%d   dispelName readable: %d/%d   name readable: %d/%d"):format(
		idOK, nDebuffs, typeOK, nDebuffs, nameOK, nDebuffs))
	if sample then
		print("  sample: " .. sample)
	end
	local verdict
	if nDebuffs == 0 then
		verdict = "no debuffs to sample — rerun while allies are actually debuffed (try /mh dispelprobe watch)."
	elseif typeOK > 0 then
		verdict = "|cff40c040FEASIBLE|r — the debuff school reads through, a live alert can identify dispels."
	else
		verdict = "|cffff5040NOT possible here|r — the debuff school is secret, so a live alert can't tell what to dispel."
	end
	print("  => live dispel alert: " .. verdict)
end

-- Does any group member (NOT you) currently carry at least one debuff? Drives the
-- auto-watch below so you don't have to time /mh dispelprobe by hand — the probe
-- reads OTHER units' auras, so the debuff must land on an ally, not yourself.
local function AnyAllyDebuffed()
	local units = {}
	if IsInRaid and IsInRaid() then
		for i = 1, 40 do
			local u = "raid" .. i
			if UnitExists(u) and not UnitIsUnit(u, "player") then
				units[#units + 1] = u
			end
		end
	elseif IsInGroup and IsInGroup() then
		for i = 1, 4 do
			local u = "party" .. i
			if UnitExists(u) then
				units[#units + 1] = u
			end
		end
	end
	for _, u in ipairs(units) do
		local found = false
		Aura.ForEachUnitDebuff(u, function()
			found = true
		end)
		if found then
			return true
		end
	end
	return false
end

-- /mh dispelprobe watch — arm the probe so it fires AUTOMATICALLY the moment an
-- ally is debuffed, instead of you having to catch the split-second by hand.
-- Polls twice a second for up to 30s, then stands down.
local probeArmed = false
function ns.ArmDispelProbe()
	local p = "|cffffff78Midnight Helper:|r "
	if probeArmed then
		print(p .. "dispel probe watch is already armed — pull and it fires on the first ally debuff.")
		return
	end
	if not (C_Timer and C_Timer.After) then
		ns.PrintDispelProbe() -- no timer support → just snapshot now
		return
	end
	if AnyAllyDebuffed() then
		ns.PrintDispelProbe() -- already a debuff up → probe immediately
		return
	end
	probeArmed = true
	print(p .. "dispel probe |cff40c040ARMED|r — pull now; it fires the moment a GROUP MEMBER (not you) is debuffed. Times out in 90s.")
	local ticks = 180 -- 180 x 0.5s = 90s
	local function tick()
		if not probeArmed then
			return
		end
		if AnyAllyDebuffed() then
			probeArmed = false
			ns.PrintDispelProbe()
			return
		end
		ticks = ticks - 1
		if ticks <= 0 then
			probeArmed = false
			print(p .. "dispel probe watch timed out — no ally debuff in 90s. Re-arm and pull a caster pack (they apply the debuffs).")
			return
		end
		C_Timer.After(0.5, tick)
	end
	C_Timer.After(0.5, tick)
end
