--[[
	Dispel capture (heal-lens data collector, Rob 2026-07-15). The never-lie way
	to grow the per-boss heal-lens data: instead of guessing debuff schools, we
	record the REAL ones from the game. While you're in an instance, this scans
	YOUR OWN debuffs (own auras are readable even in restricted content, unlike
	party/raid auras which 12.x makes secret) and logs any that carry a real
	dispel school (Magic/Curse/Poison/Disease), tagged with the current boss
	(ENCOUNTER_START encounterID) so it maps straight onto ns.BOSS_HEAL_LENS.

	`/mh dispellog` prints what's been captured (share it, or I read it from
	SavedVariables); `/mh dispellog clear` resets it. Deduped per (encounter,
	spell). Only catches dispels that land on the PLAYER — tank-targeted ones stay
	secret — but that's real, verified data with zero guessing.

	All aura reads go through ns.Aura; secret values are skipped (unreadable ≠
	absent), everything is in pcall.
]]

local _, ns = ...

-- dispelName from the API is the English school string; map to our canonical keys.
local SCHOOL = {
	Magic = "magic",
	Curse = "curse",
	Poison = "poison",
	Disease = "disease",
}

local curEncID, curEncName

local function isSecret(v)
	return issecretvalue and v ~= nil and issecretvalue(v) == true
end

local function InInstanceForCapture()
	if not IsInInstance then
		return false
	end
	local inInst, kind = IsInInstance()
	return inInst and (kind == "party" or kind == "raid" or kind == "scenario") or false
end

local function Store()
	if not ns.db then
		return nil
	end
	if type(ns.db.dispelCapture) ~= "table" then
		ns.db.dispelCapture = {}
	end
	return ns.db.dispelCapture
end

--------------------------------------------------------------------------------
-- Readability recorder (Rob 2026-07-28). Typing a probe mid-fight and copying
-- the output is not something anyone can do while tanking, so this records
-- instead: which FIELDS of your own debuffs come back readable, and in or out
-- of combat. Read it back afterwards, in the quiet, from SavedVariables.
--
-- Deduped by PATTERN, not by debuff: one row per distinct combination of field
-- states + combat state. Ten trash packs of the same debuff collapse into one
-- row with a count, so the log stays a handful of lines however long the run is.
--
-- MEASURED 2026-07-28, The Gulf of Memory, Rob's Prot Paladin, own debuffs:
--   out of combat  spellId=read   name=read   dispelName=read    (Gore 474201)
--   in combat      spellId=secret name=secret dispelName=secret  x331
--   in combat      spellId=secret name=secret dispelName=nil     x109
-- So spellId is secret in combat too: there is no "read the id, look the school
-- up in dispelCapture" path. That hypothesis is dead.
--
-- Note the 1091 in-combat scans that all reported OK while every field was
-- secret. That is exactly why DispelHelper counts hidden auras separately: the
-- scan succeeding says nothing about whether it told you anything.
--
-- OPEN: dispelName came back nil 109 times where the other fields were secret.
-- If the game were blanket-hiding the aura, nil would not appear at all — which
-- suggests nil is a real answer ("no dispel school") and secret means "there is
-- one, but not for you". Then MH could still say *something* dispellable is on
-- you. The rival reading is that secrecy is per-aura, not per-field, and those
-- 109 are simply debuffs whose dispelName is nil everywhere. To separate them
-- the examples below record dispelName's VALUE out of combat: if debuffs with
-- dispelName = <nil> show up there, the first reading holds; if every readable
-- debuff carries a school, it is refuted. Nothing gets built on it until then.
--------------------------------------------------------------------------------

local FIELD_LOG_CAP = 40
local EXAMPLE_CAP = 12

local function FieldState(v)
	if v == nil then
		return "nil"
	elseif isSecret(v) then
		return "secret"
	end
	return "read"
end

local function FieldLog()
	if not ns.db then
		return nil
	end
	if type(ns.db.dispelFieldLog) ~= "table" then
		ns.db.dispelFieldLog = {}
	end
	return ns.db.dispelFieldLog
end

local function RecordReadability(aura)
	local log = FieldLog()
	if not log then
		return
	end
	local sId, sName, sDispel = FieldState(aura.spellId), FieldState(aura.name), FieldState(aura.dispelName)
	local inCombat = (InCombatLockdown and InCombatLockdown()) and true or false
	local key = ("%s/%s/%s/%s"):format(sId, sName, sDispel, inCombat and "combat" or "idle")

	local row = log[key]
	if not row then
		local count = 0
		for _ in pairs(log) do
			count = count + 1
		end
		if count >= FIELD_LOG_CAP then
			return
		end
		local instName = "?"
		if GetInstanceInfo then
			local ok, n1 = pcall(GetInstanceInfo)
			if ok then
				instName = n1 or "?"
			end
		end
		row = {
			spellId = sId,
			name = sName,
			dispelName = sDispel,
			inCombat = inCombat,
			instance = instName,
			encounter = curEncName,
			seen = 0,
			examples = {},
		}
		log[key] = row
	end
	row.seen = row.seen + 1

	-- Keep real examples where the fields were readable. `dispel` records the
	-- VALUE, not just that it was readable, because that is what separates the
	-- two readings of the in-combat data (see the header): if debuffs with no
	-- dispel school exist and read as nil out of combat, then a nil in combat is
	-- a real answer rather than a differently-shaped blank.
	if sId == "read" or sName == "read" then
		local id = (sId == "read") and tonumber(aura.spellId) or nil
		local nm = (sName == "read") and tostring(aura.name) or nil
		local dsp
		if sDispel == "read" then
			dsp = tostring(aura.dispelName)
		elseif sDispel == "nil" then
			dsp = "<nil>"
		end
		local known
		for _, e in ipairs(row.examples) do
			if e.spellId == id and e.name == nm then
				known = e
				break
			end
		end
		if known then
			-- Examples recorded before this measurement existed have no value.
			-- Backfill rather than make Rob wipe the log, which would take the
			-- real dispel schools collected from months of play down with it.
			if known.dispel == nil then
				known.dispel = dsp
			end
		elseif #row.examples < EXAMPLE_CAP then
			row.examples[#row.examples + 1] = { spellId = id, name = nm, dispel = dsp }
		end
	end
end

local function Capture()
	if not (ns.Aura and ns.Aura.ForEachPlayerDebuff) then
		return
	end
	-- The school capture below is instance-only (that is where heal-lens data
	-- lives), but the readability question is about the API, not about where you
	-- are standing. Logging it everywhere answers it out of a normal evening's
	-- play instead of only inside dungeons; it stays cheap because rows are
	-- deduped by pattern and capped.
	local store = InInstanceForCapture() and Store() or nil
	local seen = 0
	local scanned = ns.Aura.ForEachPlayerDebuff(function(aura)
		seen = seen + 1
		pcall(RecordReadability, aura)
		if not store then
			return
		end

		local dn = aura.dispelName
		if dn == nil or isSecret(dn) then
			return
		end
		local school = SCHOOL[dn]
		if not school then
			return -- not a Magic/Curse/Poison/Disease debuff
		end
		local id = aura.spellId
		if id == nil or isSecret(id) then
			return
		end
		local key = tostring(curEncID or 0) .. ":" .. tostring(id)
		if store[key] then
			return -- already logged this debuff on this boss
		end
		local nm = (aura.name ~= nil and not isSecret(aura.name)) and tostring(aura.name) or "?"
		local instName, instID = "?", nil
		if GetInstanceInfo then
			local ok, n1, _, _, _, _, _, _, id8 = pcall(GetInstanceInfo)
			if ok then
				instName = n1 or "?"
				instID = id8
			end
		end
		store[key] = {
			spellId = tonumber(id) or 0,
			name = nm,
			school = school,
			encounterID = curEncID,
			encounter = curEncName,
			instance = instName,
			instanceID = instID,
		}
	end)

	-- A blocked scan and a clean player look identical in the rows above: both
	-- record nothing. Log the scan itself so the difference survives.
	pcall(function()
		local log = FieldLog()
		if not log then
			return
		end
		local inCombat = (InCombatLockdown and InCombatLockdown()) and true or false
		local trusted = (ns.Aura.Trusted and ns.Aura.Trusted()) and true or false
		local key = ("scan/%s/%s/%s"):format(
			scanned and "ok" or "blocked",
			inCombat and "combat" or "idle",
			trusted and "trusted" or "untrusted")
		local row = log[key]
		if not row then
			row = { scan = scanned and "ok" or "blocked", inCombat = inCombat,
				trusted = trusted, seen = 0, maxDebuffs = 0 }
			log[key] = row
		end
		row.seen = row.seen + 1
		if seen > (row.maxDebuffs or 0) then
			row.maxDebuffs = seen
		end
	end)
end

local f = CreateFrame("Frame")
f:RegisterEvent("ENCOUNTER_START")
f:RegisterEvent("ENCOUNTER_END")
f:RegisterUnitEvent("UNIT_AURA", "player")
f:SetScript("OnEvent", function(_, event, a1, a2)
	if event == "ENCOUNTER_START" then
		curEncID, curEncName = a1, a2
	elseif event == "ENCOUNTER_END" then
		curEncID, curEncName = nil, nil
	elseif event == "UNIT_AURA" then
		pcall(Capture)
	end
end)

--- /mh dispellog — print the captured dispellable debuffs (verified heal-lens
--- data, ready to fold into ns.BOSS_HEAL_LENS via the encounterID).
function ns.PrintDispelCaptureLog()
	local prefix = ("|cffffcc00%s|r"):format(ns:L("PRINT_PREFIX"))
	local store = Store()
	print(("%s Captured dispellable debuffs (share these — spell / school / boss):"):format(prefix))
	local n = 0
	for _, e in pairs(store or {}) do
		n = n + 1
		print(("   %s |cff9d9d9d(%d)|r — |cff8fd3ff%s|r — %s |cff9d9d9d[enc %s | %s]|r"):format(
			e.name or "?", e.spellId or 0, e.school or "?",
			e.encounter or "trash/unknown boss", tostring(e.encounterID or "-"), e.instance or "?"
		))
	end
	if n == 0 then
		print("   (nothing captured yet — run an instance; dispellable debuffs that land on you get logged)")
	else
		print(("   %d entries. |cff9d9d9d/mh dispellog clear|r to reset."):format(n))
	end

	local log = ns.db and ns.db.dispelFieldLog
	if type(log) == "table" and next(log) then
		print(("%s Field readability (which parts of your own debuffs you could read):"):format(prefix))
		for _, r in pairs(log) do
			if r.scan then
				print(("   scan |cff8fd3ff%s|r — %s — Trusted()=%s — up to %d debuff(s) |cff9d9d9d(%dx)|r"):format(
					r.scan, r.inCombat and "IN COMBAT" or "out of combat",
					tostring(r.trusted), r.maxDebuffs or 0, r.seen or 0))
			else
				local ex = ""
				if r.examples and #r.examples > 0 then
					local bits = {}
					for _, e in ipairs(r.examples) do
						bits[#bits + 1] = ("%s(%s)=%s"):format(
							e.name or "?", tostring(e.spellId or "?"), e.dispel or "?")
					end
					ex = "  |cff9d9d9d" .. table.concat(bits, ", ") .. "|r"
				end
				print(("   spellId=%s name=%s dispelName=%s — %s |cff9d9d9d(%dx, %s)|r%s"):format(
					r.spellId, r.name, r.dispelName,
					r.inCombat and "IN COMBAT" or "out of combat",
					r.seen or 0, r.instance or "?", ex))
			end
		end
	end
end

--- /mh dispellog clear — wipe the capture log.
function ns.ClearDispelCaptureLog()
	if ns.db then
		ns.db.dispelCapture = {}
		ns.db.dispelFieldLog = {}
	end
	local prefix = ("|cffffcc00%s|r"):format(ns:L("PRINT_PREFIX"))
	print(("%s Dispel capture log cleared."):format(prefix))
end
