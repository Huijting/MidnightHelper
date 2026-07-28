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
-- SETTLED, same evening. dispelName came back nil in combat on auras whose
-- spellId and name were BOTH secret. If secrecy replaced whole auras, a hidden
-- aura could not still hand back a plain nil -- so secrecy replaces VALUES, and
-- nil survives it untouched. Confirmed from the other side out of combat, where
-- Well-Honed Instincts (382912) reads with dispelName = <nil>: debuffs carrying
-- no dispel school genuinely exist and read as nil.
--
-- Therefore, in combat:
--   dispelName = secret  ->  this debuff HAS a dispel school, hidden from you
--   dispelName = nil     ->  this debuff has none
--
-- So MH can tell "something dispellable is on you" from "nothing is", without
-- the spell, the name or the school. Weaker than naming the debuff, but it is
-- the difference between a cleanse press and a wasted global.
--
-- This is inference from consistent measurement, not a documented guarantee.
-- If Blizzard ever secretizes nil as well, both cases collapse into one and the
-- feature must go quiet rather than guess: treat a nil that used to be reliable
-- as unreadable, never as "nothing there".
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

--------------------------------------------------------------------------------
-- Known-id lookup probe.
--
-- The 12.1 API notes (warcraft.wiki.gg, Patch 12.1.0/API changes) draw a line the
-- enumeration measurement above could not see: APIs reached by INDEX, slot or
-- instance id Lua error for addons while auras are secret, but "APIs accessing
-- via spell ID/name continue working (non-secret spells return non-secrets)".
--
-- Walking the list asks "what is on me", which leaks. Asking "is 1270859 on me"
-- names the spell up front and leaks nothing new. If that distinction holds, the
-- dispel helper does not need enumeration at all: it can ask about the debuff ids
-- dispelCapture has already collected from real play, per instance.
--
-- Whether it holds on TODAY's 12.0.7 is unmeasured, and the wiki describes 12.1
-- rather than live. Note too that AuraData structs are documented as fully secret
-- even when returned, so a lookup may hand back a table whose fields are all
-- secret -- which would still answer "is it on me" while refusing "which school".
-- So this records the outcome per id: found or not, fields readable or secret.
--
-- Runs only in the moment that matters (a debuff was seen but could not be read)
-- and no more than once a second, so it never turns into a per-event loop.
--------------------------------------------------------------------------------

local lastProbe = 0
local lastHarvest = 0
local RECENT_CAP = 30

--- Ids seen on the player while enumeration still worked (out of combat), kept so
--- the probe has something to ask about once it stops working. Without this the
--- probe can only ask about debuffs collected in OTHER instances, which is how it
--- managed 41 runs and 0 hits: nothing it knew about was ever on him.
local function RecentIds()
	if not ns.db then
		return nil
	end
	if type(ns.db.dispelRecentIds) ~= "table" then
		ns.db.dispelRecentIds = {}
	end
	return ns.db.dispelRecentIds
end

local function HarvestRecentIds()
	if (InCombatLockdown and InCombatLockdown()) or not ns.Aura then
		return -- out of combat only: this is where reading still works
	end
	local now = (GetTime and GetTime()) or 0
	if now - lastHarvest < 1 then
		return
	end
	lastHarvest = now
	local recent = RecentIds()
	if not recent then
		return
	end
	local n = 0
	for _ in pairs(recent) do
		n = n + 1
	end
	local function take(aura)
		local id = aura.spellId
		if id == nil or isSecret(id) then
			return
		end
		id = tonumber(id)
		if not id or recent[id] then
			return
		end
		if n >= RECENT_CAP then
			return
		end
		n = n + 1
		recent[id] = (aura.name ~= nil and not isSecret(aura.name)) and tostring(aura.name) or "?"
	end
	-- Buffs as well as debuffs. A long class buff survives the combat edge, which
	-- is exactly the aura you want to ask about: we know it is still on him, so a
	-- lookup that comes back empty is a real answer rather than an absent debuff.
	pcall(ns.Aura.ForEachPlayerBuff, take)
	pcall(ns.Aura.ForEachPlayerDebuff, take)
end

local function LookupLog()
	if not ns.db then
		return nil
	end
	if type(ns.db.dispelLookupLog) ~= "table" then
		ns.db.dispelLookupLog = {}
		ns.db.dispelRecentIds = {}
	end
	return ns.db.dispelLookupLog
end

local function ProbeKnownIDs()
	if not (ns.Aura and ns.Aura.GetPlayerAura and ns.db) then
		return
	end
	local now = (GetTime and GetTime()) or 0
	if now - lastProbe < 1 then
		return
	end
	lastProbe = now

	local known = ns.db.dispelCapture
	local log = LookupLog()
	if type(known) ~= "table" or not log then
		return
	end
	local inCombat = (InCombatLockdown and InCombatLockdown()) and true or false
	local suffix = inCombat and "combat" or "idle"
	local checked, hits, blocked = 0, 0, 0

	-- Ask about every id we have any reason to think could be on him: the dispel
	-- schools collected across instances, plus whatever was actually on him a
	-- moment ago, before combat closed the door.
	local targets = {}
	for _, e in pairs(known) do
		if type(e.spellId) == "number" and e.spellId > 0 then
			targets[e.spellId] = e
		end
	end
	for id, nm in pairs(RecentIds() or {}) do
		if type(id) == "number" and not targets[id] then
			targets[id] = { spellId = id, name = nm, school = "?", recent = true }
		end
	end

	for _, e in pairs(targets) do
		local id = e.spellId
		if type(id) == "number" and id > 0 then
			checked = checked + 1
			local data, readable = ns.Aura.GetPlayerAura(id)
			if not readable then
				blocked = blocked + 1
			elseif data == nil and e.recent and inCombat then
				-- The decisive negative. This aura was on him seconds ago, out of
				-- combat, and the lookup now says nothing. That is the lookup
				-- refusing to answer, not the aura being gone -- which a plain
				-- miss on some other instance's debuff could never tell us apart.
				local key = ("miss/%d"):format(id)
				local row = log[key]
				if not row then
					row = { miss = true, spellId = id, name = e.name, seen = 0 }
					log[key] = row
				end
				row.seen = row.seen + 1
			elseif data ~= nil then
				hits = hits + 1
				local key = ("%d/%s"):format(id, suffix)
				local row = log[key]
				if not row then
					row = { spellId = id, name = e.name, school = e.school,
						inCombat = inCombat, seen = 0 }
					log[key] = row
				end
				row.seen = row.seen + 1
				-- The point of the whole probe: a hit proves the lookup answered
				-- "yes, it is on you". These say whether it also told us anything
				-- about the aura, or handed back a table of secrets.
				row.nameState = FieldState(data.name)
				row.dispelState = FieldState(data.dispelName)
				row.spellIdState = FieldState(data.spellId)
			end
		end
	end

	local mkey = ("probe/%s"):format(suffix)
	local m = log[mkey]
	if not m then
		m = { probe = true, inCombat = inCombat, runs = 0 }
		log[mkey] = m
	end
	m.runs = m.runs + 1
	m.checked = checked
	m.lastHits = hits
	m.lastBlocked = blocked
	if (m.maxHits or 0) < hits then
		m.maxHits = hits
	end
	if blocked > 0 then
		m.everBlocked = true
	end
end

--------------------------------------------------------------------------------
-- Coverage check, out of combat.
--
-- The combat probe found Power Word: Fortitude by id, 155 times, with spellId,
-- name AND dispelName all readable -- while enumeration at the same moment
-- returned nothing but secrets. Asking by id therefore answers in combat, and
-- answers in full. That is the dispel helper's road back.
--
-- But the same run missed a dozen other harvested ids, and a miss is ambiguous:
-- the aura may simply have expired (Dark Pact lasts 20s; Diabolic Ritual is a
-- proc), or the lookup may not cover it. Those two cannot be told apart in
-- combat, because there is no second opinion to check against.
--
-- Out of combat there is. Enumeration works there, so it can say which auras are
-- REALLY on the player, and the lookup can be asked about exactly those. Any id
-- enumeration sees but the lookup denies is a coverage gap with no secrecy
-- involved -- which would mean the combat misses were never about secrecy either.
--------------------------------------------------------------------------------

local lastVerify = 0

local function VerifyLookupCoverage()
	if (InCombatLockdown and InCombatLockdown()) or not (ns.Aura and ns.Aura.GetPlayerAura) then
		return
	end
	local now = (GetTime and GetTime()) or 0
	if now - lastVerify < 2 then
		return
	end
	lastVerify = now
	local log = LookupLog()
	if not log then
		return
	end

	local present = {}
	local function collect(aura)
		local id = aura.spellId
		if id ~= nil and not isSecret(id) then
			id = tonumber(id)
			if id then
				present[id] = (aura.name ~= nil and not isSecret(aura.name)) and tostring(aura.name) or "?"
			end
		end
	end
	pcall(ns.Aura.ForEachPlayerBuff, collect)
	pcall(ns.Aura.ForEachPlayerDebuff, collect)

	local agree, gap = 0, 0
	for id, nm in pairs(present) do
		local data, readable = ns.Aura.GetPlayerAura(id)
		if readable and data ~= nil then
			agree = agree + 1
		elseif readable then
			gap = gap + 1
			local key = ("gap/%d"):format(id)
			local row = log[key]
			if not row then
				row = { gap = true, spellId = id, name = nm, seen = 0 }
				log[key] = row
			end
			row.seen = row.seen + 1
		end
	end

	local m = log["coverage/idle"]
	if not m then
		m = { coverage = true, runs = 0 }
		log["coverage/idle"] = m
	end
	m.runs = m.runs + 1
	m.lastPresent = agree + gap
	m.lastAgree = agree
	m.lastGap = gap
	if (m.worstGap or 0) < gap then
		m.worstGap = gap
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
	pcall(HarvestRecentIds)
	pcall(VerifyLookupCoverage)

	local seen, unreadable = 0, false
	local scanned = ns.Aura.ForEachPlayerDebuff(function(aura)
		seen = seen + 1
		pcall(RecordReadability, aura)
		if isSecret(aura.spellId) or isSecret(aura.dispelName) then
			unreadable = true
		end
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

	-- Enumeration just failed to tell us something. That is exactly the moment
	-- worth asking the other way round, by id.
	if unreadable or not scanned then
		pcall(ProbeKnownIDs)
	end

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

	local lookup = ns.db and ns.db.dispelLookupLog
	if type(lookup) == "table" and next(lookup) then
		print(("%s Lookup by known spell ID (does asking by id still answer?):"):format(prefix))
		for _, r in pairs(lookup) do
			if r.coverage then
				print(("   coverage out of combat — %d run(s), last: %d aura(s) present, %d found by id, |cffff8080%d not found|r (worst %d)"):format(
					r.runs or 0, r.lastPresent or 0, r.lastAgree or 0, r.lastGap or 0, r.worstGap or 0))
			elseif r.gap then
				print(("   |cffff8080GAP|r %s (%d) — enumeration sees it, lookup denies it |cff9d9d9d(%dx)|r"):format(
					r.name or "?", r.spellId or 0, r.seen or 0))
			elseif r.miss then
				print(("   |cffff8080MISS|r %s (%d) — was on you seconds ago, lookup says nothing in combat |cff9d9d9d(%dx)|r"):format(
					r.name or "?", r.spellId or 0, r.seen or 0))
			elseif r.probe then
				print(("   probe %s — %d run(s), %d id(s) checked, best %d hit(s)%s"):format(
					r.inCombat and "IN COMBAT" or "out of combat",
					r.runs or 0, r.checked or 0, r.maxHits or 0,
					r.everBlocked and " |cffff8080(refused at least once)|r" or ""))
			else
				print(("   |cff40c040HIT|r %s (%d) %s — %s — fields: spellId=%s name=%s dispelName=%s |cff9d9d9d(%dx)|r"):format(
					r.name or "?", r.spellId or 0, r.school or "?",
					r.inCombat and "IN COMBAT" or "out of combat",
					r.spellIdState or "?", r.nameState or "?", r.dispelState or "?", r.seen or 0))
			end
		end
	end
end

--- /mh dispellog clear — wipe the capture log.
function ns.ClearDispelCaptureLog()
	if ns.db then
		ns.db.dispelCapture = {}
		ns.db.dispelFieldLog = {}
		ns.db.dispelLookupLog = {}
		ns.db.dispelRecentIds = {}
	end
	local prefix = ("|cffffcc00%s|r"):format(ns:L("PRINT_PREFIX"))
	print(("%s Dispel capture log cleared."):format(prefix))
end
