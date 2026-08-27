--[[
	`/mh kickprobe` — is UNIT_SPELLCAST_INTERRUPTED readable in 12.1?

	🔴 WHY THIS EXISTS. Our own API watch concluded on 18 aug that enemy casts are
	unidentifiable: spell id, npc id, icon and both timestamps all came back secret, and
	only `castBarID` was readable. From that we wrote off a group interrupt helper.

	That measurement was of the LIVE cast — UnitCastingInfo on a hostile unit. It never
	tested the INTERRUPTED event's own payload, which is a different API arriving at a
	different moment.

	CastBreaker 2.1.0 (installed 27 aug, same author as WoWNext) builds its whole
	interrupt history on that event, on nameplate units, guarding every field for
	readability. That is a CANDIDATE, not proof — CLAUDE.md is explicit that another
	addon's code never settles what this client does. So this asks the client.

	⚠️ It records, it never concludes. Each event writes one row saying which fields were
	readable and which came back secret or nil. Run content, then read the rows.

	`/mh kickprobe`        show what has been captured
	`/mh kickprobe clear`  start over
]]

local _, ns = ...

local MAX_ROWS = 40

local function Secret(v)
	return issecretvalue ~= nil and issecretvalue(v)
end

--- "readable", "SECRET" or "nil" — never the value itself unless it is safe to show.
local function State(v)
	if v == nil then
		return "nil", nil
	end
	if Secret(v) then
		return "SECRET", nil
	end
	return "readable", tostring(v)
end

local function Store()
	ns.db = ns.db or {}
	if type(ns.db.kickProbe) ~= "table" then
		ns.db.kickProbe = { rows = {}, events = 0 }
	end
	ns.db.kickProbe.rows = ns.db.kickProbe.rows or {}
	return ns.db.kickProbe
end

--- ⚠️ THE UNIT TOKEN MATTERS AND IS PART OF THE QUESTION. CastBreaker only accepts
--- `nameplate*`, which suggests party/target tokens behave differently — or that they
--- simply never needed them. Recording the token means we find out instead of copying
--- their filter and inheriting a limit we never tested.
local function Capture(event, unit, castGUID, spellID, interruptedBy)
	local s = Store()
	s.events = (s.events or 0) + 1

	local spellState, spellVal = State(spellID)
	local byState, byVal = State(interruptedBy)
	local guidState = State(castGUID)

	-- The spell NAME is the thing a player would actually be shown, so test that too:
	-- a readable id that resolves to nothing is not a usable answer.
	local nameState = "not tried"
	if spellState == "readable" and C_Spell and C_Spell.GetSpellInfo then
		local ok, info = pcall(C_Spell.GetSpellInfo, tonumber(spellVal))
		if ok and type(info) == "table" and info.name and not Secret(info.name) then
			nameState = tostring(info.name)
		else
			nameState = "id readable but no name"
		end
	end

	local row = {
		at = (time and time()) or 0,
		event = event,
		unit = tostring(unit or "?"),
		spell = spellState,
		spellID = spellVal,
		spellName = nameState,
		guid = guidState,
		by = byState,
		byName = byVal,
		inInstance = (IsInInstance and select(2, IsInInstance())) or "?",
		inCombat = (InCombatLockdown and InCombatLockdown()) or false,
	}
	s.rows[#s.rows + 1] = row
	while #s.rows > MAX_ROWS do
		table.remove(s.rows, 1)
	end
end

local f = CreateFrame("Frame")
f:RegisterEvent("UNIT_SPELLCAST_INTERRUPTED")
f:RegisterEvent("UNIT_SPELLCAST_CHANNEL_STOP")
f:SetScript("OnEvent", function(_, event, unit, castGUID, spellID, interruptedBy)
	-- No unit filter on purpose: which tokens deliver anything is the open question.
	local ok, err = pcall(Capture, event, unit, castGUID, spellID, interruptedBy)
	if not ok then
		-- A throw here is itself an answer: it means a field could not even be handled.
		local s = Store()
		s.rows[#s.rows + 1] = { at = (time and time()) or 0, event = event,
			unit = tostring(unit or "?"), spell = "THREW: " .. tostring(err) }
	end
end)

function ns.PrintInterruptEventProbe(arg)
	local prefix = ("|cffffcc00%s|r"):format((ns.L and ns:L("PRINT_PREFIX")) or "MH")
	local s = Store()
	if arg == "clear" then
		ns.db.kickProbe = { rows = {}, events = 0 }
		print(prefix .. " kick probe cleared.")
		return
	end
	print(prefix .. (" interrupt-event probe — %d event(s) seen, %d row(s) kept")
		:format(s.events or 0, #s.rows))
	if #s.rows == 0 then
		-- ⚠️ Nothing captured is not "not readable". It means no interrupt happened
		-- while this was loaded, which is a different sentence entirely.
		print("   |cff8a8f98Nothing captured yet. That means no interrupt fired here — "
			.. "not that the fields are unreadable.|r")
		return
	end
	for i = math.max(1, #s.rows - 9), #s.rows do
		local r = s.rows[i]
		print(("   %-28s unit=%-16s spell=%-8s %s"):format(
			tostring(r.event), tostring(r.unit), tostring(r.spell),
			r.spellName and ("name=" .. tostring(r.spellName)) or ""))
		print(("      by=%-9s %s  guid=%-8s  kind=%s"):format(
			tostring(r.by), r.byName and ("(" .. tostring(r.byName) .. ")") or "",
			tostring(r.guid), tostring(r.inInstance)))
	end
	print("   |cff8a8f98Full rows in SavedVariables (ns.db.kickProbe) after a /reload.|r")
end
