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
