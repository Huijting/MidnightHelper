local _, ns = ...

--[[
	Midnight Helper — Group buff status.

	Which raid-wide class buffs is your group missing? Reuses the VERIFIED raid buffs
	from ns.MISSING_BUFF_DEFS (MissingBuffData) — no second buff list to maintain, and
	no comms: we just read friendly auras.

	Never-lie, and this is the whole design:
	  • Every aura read goes through ns.Aura (the facade), which returns true / false /
	    nil, where nil means "could not read" — NOT "absent". 12.1 makes auras secret
	    everywhere, so the facade is the single place that has to change.
	  • A unit we cannot read is SKIPPED, never counted as missing.
	  • If we could not read a single buff on anyone (party/raid auras are secret inside
	    instances — confirmed via /mh dispelprobe), we say so. We never report "all buffs
	    are up" while blind: that would be a confident lie.
	  • A buff is only flagged when the group can actually provide it — someone already
	    has it, or a class that casts it is present. No nagging about a Mage buff with no
	    Mage in the group.
	  • Buff names come from the game (C_Spell.GetSpellName), so they are localized.
]]

--- Ask about another unit without ever comparing a secret.
---
--- `pcall` does NOT make this safe: the call succeeds and hands back a secret, and the
--- throw happens on the next line where you test it. That is the crash CastBreaker was
--- printing 145 times on 27 aug, and the one /mh glow made the same morning.
local function Readable(v)
	return v ~= nil and not (issecretvalue and issecretvalue(v))
end

local function Exists(u)
	if not UnitExists then
		return false
	end
	local ok, v = pcall(UnitExists, u)
	-- Unreadable existence is treated as "not here": counting a unit we cannot even
	-- confirm would put a phantom in the denominator.
	return ok and Readable(v) and v == true
end

local function Alive(u)
	if not UnitIsDeadOrGhost then
		return true
	end
	local ok, v = pcall(UnitIsDeadOrGhost, u)
	if not (ok and Readable(v)) then
		-- ⚠️ Cannot tell -> treat as alive. The opposite would silently drop a group
		-- member from the count and turn "3 of 5 buffed" into a confident "3 of 3".
		return true
	end
	return v ~= true
end

local RAID_BUFFS -- array of { buff = <auraID>, spell = <spellID> }
local PROVIDER -- [auraID] = { MAGE = true, ... } — classes that cast it

-- Derive both tables from the verified defs, once. spell ~= buff for some (Evoker's
-- Blessing of the Bronze casts 364342 but applies 381748), so keep them apart:
-- `buff` is what we look for on a unit, `spell` is what we name it by.
local function build()
	if RAID_BUFFS then
		return
	end
	RAID_BUFFS, PROVIDER = {}, {}
	local seen = {}
	for class, defs in pairs(ns.MISSING_BUFF_DEFS or {}) do
		for _, d in ipairs(defs) do
			if d.kind == "raid" and d.buff then
				PROVIDER[d.buff] = PROVIDER[d.buff] or {}
				PROVIDER[d.buff][class] = true
				if not seen[d.buff] then
					seen[d.buff] = true
					RAID_BUFFS[#RAID_BUFFS + 1] = { buff = d.buff, spell = d.spell }
				end
			end
		end
	end
end

local function buffLabel(b)
	if C_Spell and C_Spell.GetSpellName then
		local ok, n = pcall(C_Spell.GetSpellName, b.spell or b.buff)
		if ok and type(n) == "string" and n ~= "" then
			return n
		end
	end
	return "#" .. tostring(b.buff)
end

-- Units in the current group, player included. nil when solo.
local function groupUnits()
	if not (IsInGroup and IsInGroup()) then
		return nil
	end
	local units = {}
	local n = (GetNumGroupMembers and GetNumGroupMembers()) or 0
	if IsInRaid and IsInRaid() then
		for i = 1, n do
			units[#units + 1] = "raid" .. i
		end
	else
		units[#units + 1] = "player"
		for i = 1, n - 1 do
			units[#units + 1] = "party" .. i
		end
	end
	return units
end

-- Is a class that casts this buff actually in the group?
local function providerPresent(units, provider)
	if not provider then
		return false
	end
	for _, u in ipairs(units) do
		local ok, _, classFile = pcall(UnitClass, u)
		if ok and classFile and provider[classFile] then
			return true
		end
	end
	return false
end

--- Raid buffs with a real, providable gap.
--- @return table gaps  { { label, have, total }, ... }
--- @return string|nil reason  "solo" | "unreadable" when there is nothing to report
function ns.GetGroupBuffStatus()
	build()
	local units = groupUnits()
	if not units or #units == 0 then
		return {}, "solo"
	end
	local out, readAny = {}, false
	for _, b in ipairs(RAID_BUFFS) do
		local have, total = 0, 0
		for _, u in ipairs(units) do
			-- 🔴 BOTH OF THESE ASK ABOUT SOMEONE ELSE, AND A SECRET CANNOT BE TESTED.
			-- CastBreaker 2.1.0 threw this at Rob 145 times on 27 aug:
			--   attempt to compare local 'matches' (a secret boolean value)
			-- from `ok, matches = pcall(UnitIsUnit, ...)` followed by `if matches`. The
			-- pcall is no protection: calling is allowed, COMPARING is what throws. I made
			-- the same mistake that morning in /mh glow with IsMouseEnabled.
			--
			-- ⚠️ And an unreadable answer must not become "dead". `Alive()` returns true
			-- when it cannot tell, because skipping a group member here would quietly
			-- shrink the denominator and report "3 of 3 buffed" for a party of five.
			if Exists(u) and Alive(u) then
				-- true / false / nil(=unreadable) — nil is skipped, never "missing".
				local h = ns.Aura and ns.Aura.HasUnitBuff and ns.Aura.HasUnitBuff(u, b.buff)
				if h ~= nil then
					total = total + 1
					if h then
						have = have + 1
					end
				end
			end
		end
		if total > 0 then
			readAny = true
			if have < total and (have > 0 or providerPresent(units, PROVIDER[b.buff])) then
				out[#out + 1] = { label = buffLabel(b), have = have, total = total }
			end
		end
	end
	if not readAny then
		-- We saw nothing on anyone: the game is hiding group auras here (inside
		-- instances it does). Say that — never "all buffs are up" while blind.
		return {}, "unreadable"
	end
	return out, nil
end

--- Home step provider: one line per missing group buff. Silent when solo/unreadable.
function ns.GetGroupBuffSteps()
	local gaps, reason = ns.GetGroupBuffStatus()
	if reason then
		return {}
	end
	local steps = {}
	for _, g in ipairs(gaps) do
		steps[#steps + 1] = {
			text = (ns:L("GROUPBUFF_GAP_FMT")):format(g.label, g.have, g.total),
			color = "warn",
		}
	end
	return steps
end

-- /mh groupbuffs
function ns.PrintGroupBuffs()
	local prefix = ("|cffffcc00%s|r"):format(ns:L("PRINT_PREFIX"))
	local gaps, reason = ns.GetGroupBuffStatus()
	if reason == "solo" then
		print(("%s %s"):format(prefix, ns:L("GROUPBUFF_SOLO")))
		return
	end
	if reason == "unreadable" then
		print(("%s %s"):format(prefix, ns:L("GROUPBUFF_UNREADABLE")))
		return
	end
	if #gaps == 0 then
		print(("%s %s"):format(prefix, ns:L("GROUPBUFF_ALL_OK")))
		return
	end
	print(("%s %s"):format(prefix, ns:L("GROUPBUFF_HEADER")))
	for _, g in ipairs(gaps) do
		print(("   |cffffd100%s|r"):format((ns:L("GROUPBUFF_GAP_FMT")):format(g.label, g.have, g.total)))
	end
end
