local _, ns = ...

--[[
	Midnight Helper — /mh mech: do these mechanic ids name anything on this client?

	GTFO 6.7.2 landed on 17 aug with "Added Midnight spells (delves)". Its list is a
	narrow and useful shape: GTFO only records what damages you AVOIDABLY, which is
	exactly the sentence a delve tip wants to carry. 71 of its ids are ones we have
	never referenced.

	⚠️ They are CANDIDATES. GTFO's Midnight blocks cover content that is not live yet,
	so they were datamined from the same PTR that DBM read — not observed in a combat
	log. That is the same provenance as the six Nymrissa ids we already ship, no better.
	The addon-as-proof mistakes in CLAUDE.md (LEARNED_SPELL_IN_TAB, a Blackwing Mage's
	Arcane Explosion) both started exactly here.

	So this asks the client and nothing else. `{SPELL:id}` renders names client-side, so
	whatever survives goes into a tip without anyone typing a spell name.

	TWO CONTROLS, because a sweep that comes back empty proves nothing on its own
	(silence-is-not-absence, three times in one day on 16 aug):

	  * CONTROL_KNOWN — the six Nymrissa ids we already ship, from DBM. Same unreleased
	    content, same datamined provenance. If these name and GTFO's do not, the
	    difference is real. If NEITHER names, then this client simply cannot name
	    unreleased-lair spells and GTFO's silence means nothing at all.

	  * CONTROL_IMPOSSIBLE — an id that cannot exist. It MUST come back empty. If it
	    returns a name, the read is answering everything and the whole run is worthless.
	    On 16 aug a control was picked that could not fail ("Auto Attack", a spell Rob
	    has); this one can only fail.

	Long output goes to `ns.db.mechProbe` and is read from the SavedVariables file —
	the house rule since 27 jul. Chat gets the counts and the controls.
]]

-- ---------------------------------------------------------------------------
-- The candidates, exactly as GTFO groups them
-- ---------------------------------------------------------------------------

--- GTFO's instance id, and the ids we do not already reference.
---
--- ⚠️ NO ZONE NAMES HERE, on purpose. The first harvest keyed off section headers
--- shaped `--- * Zone (id) *` and therefore skipped every entry filed under a header
--- without an id — which is precisely where the two Season 2 delves live. Rob asking
--- "does this affect Season 2?" is the only reason that was caught. This list comes
--- from the `instance =` field on each entry, and the NAME of each instance is asked
--- of the client below, so a zone label can no longer be something I typed.
---
--- 103 ids over 17 instances. Roughly half come from GTFO's Fail file, which the
--- first pass did not read at all.
local CANDIDATES = {
	{ 1592, { 1221901 } },
	{ 2813, { 1223906, 474740, 474768, 1266241, 1214663, 1217384, 1297691, 1297695, 1294836 } },
	{ 2825, { 1234021, 1235129, 1240280, 1235795, 1235641, 1247030, 1242887, 1297797 } },
	{ 2858, { 1225385, 1226990, 1257514, 1257563 } },
	{ 2859, { 1238638, 1263642, 1237267, 1259365, 1242138, 1242200 } },
	{ 2874, {
		1257160, 1257164, 1258823, 1265832, 1249638, 1249989, 1256247, 1252611,
		1266706, 1259887, 1257895, 1259664, 1259713, 1248980, 1279517, 1254175,
	} },
	{ 2912, { 1258883, 1259186, 1241844, 1264467, 1265152, 1248652, 1243753 } },
	{ 2913, { 1243866 } },
	{ 2923, { 1299145, 1311712, 1234917, 1296963, 1300262, 1233264, 1226031, 1222724, 1310026 } },
	{ 2963, { 1280182 } },
	{ 2987, { 1307062, 1313448 } },
	{ 2993, { 1307915, 1296069, 1300083, 1300044, 1305393, 1295073, 1306856, 1294197 } },
	{ 3004, { 1296439, 1294846 } },
	{ 3038, { 1287680, 1287559 } },
	{ 3077, { 1301863, 1238255, 392013, 1239757, 1296414, 1296441, 1296366 } },
	{ 3079, { 1298887, 1291555, 1309412, 1288126 } },
	-- GTFO files these with no instance at all: Midnight world and Prey content.
	{ nil, {
		1243988, 1270862, 1284716, 1295990, 1270524, 1276517, 1297422, 1253237,
		1256357, 1271755, 1266183, 1258640, 1230634, 1235134, 1285974, 1291560,
	} },
}

--- Ask the client what an instance id is called. Two lookups because GTFO's field is
--- whatever `GetInstanceInfo` reports, which is not always a uiMapID — and a nil here
--- is reported as nil rather than filled in from a guide.
local function InstanceName(instanceID)
	if not instanceID then
		return nil
	end
	if C_Map and C_Map.GetMapInfo then
		local ok, info = pcall(C_Map.GetMapInfo, instanceID)
		if ok and type(info) == "table" and type(info.name) == "string"
			and info.name:find("%w") then
			return info.name, "C_Map"
		end
	end
	if EJ_GetInstanceInfo then
		local ok, name = pcall(EJ_GetInstanceInfo, instanceID)
		if ok and type(name) == "string" and name:find("%w") then
			return name, "EJ"
		end
	end
	return nil
end

--- The six we already ship for Nymrissa, from DBM-Lairs-Midnight. Unreleased lair,
--- datamined — so if the client can name these it can name GTFO's too.
local CONTROL_KNOWN = { 1257717, 1313393, 1258668, 1260837, 1282937, 1268562 }

--- Cannot exist. Any name here means the read is not discriminating.
local CONTROL_IMPOSSIBLE = 999999999

-- ---------------------------------------------------------------------------

local function Prefix()
	return "|cff8fd3ffMidnight Helper|r"
end

--- The client's name for an id, or nil. Never a placeholder: this is the whole
--- measurement, so "Spell 1257654" would be an answer that looks like data.
local function NameOf(spellID)
	if C_Spell and C_Spell.GetSpellName then
		local ok, n = pcall(C_Spell.GetSpellName, spellID)
		if ok and type(n) == "string" and n:find("%w") then
			return n
		end
	end
	if C_Spell and C_Spell.GetSpellInfo then
		local ok, info = pcall(C_Spell.GetSpellInfo, spellID)
		if ok and type(info) == "table" and type(info.name) == "string"
			and info.name:find("%w") then
			return info.name
		end
	end
	return nil
end

local function Ask(spellID)
	if C_Spell and C_Spell.RequestLoadSpellData then
		pcall(C_Spell.RequestLoadSpellData, spellID)
	end
end

--- Ask for everything first, then read after the answers have had time to arrive.
--- The 16 aug lesson, written out: GetSpellName reads a cache, so a first-pass read
--- can only ever see what was already there. Reading twice turns "no answer" into an
--- answer, and reporting BOTH numbers makes a failed fetch visible instead of letting
--- it pass for "these spells do not exist".
function ns.ProbeMechanicNames()
	if not (C_Spell and (C_Spell.GetSpellName or C_Spell.GetSpellInfo)) then
		print(("%s |cffff5040no spell API on this client — nothing measured.|r"):format(Prefix()))
		return
	end

	local out = { zones = {}, controls = {}, askedAt = date and date("%Y-%m-%d %H:%M:%S") or nil }
	ns.db = ns.db or {}

	for _, z in ipairs(CANDIDATES) do
		for _, id in ipairs(z[2]) do
			Ask(id)
		end
	end
	for _, id in ipairs(CONTROL_KNOWN) do
		Ask(id)
	end
	Ask(CONTROL_IMPOSSIBLE)

	local firstNamed, total = 0, 0
	for _, z in ipairs(CANDIDATES) do
		for _, id in ipairs(z[2]) do
			total = total + 1
			if NameOf(id) then
				firstNamed = firstNamed + 1
			end
		end
	end

	local function Finish()
		local named = 0
		for _, z in ipairs(CANDIDATES) do
			local rows = {}
			for _, id in ipairs(z[2]) do
				local n = NameOf(id)
				if n then
					named = named + 1
				end
				rows[#rows + 1] = { id = id, name = n }
			end
			local zoneName, via = InstanceName(z[1])
			out.zones[#out.zones + 1] = {
				instance = z[1],
				zone = zoneName,
				zoneVia = via,
				spells = rows,
			}
		end

		local knownNamed = {}
		for _, id in ipairs(CONTROL_KNOWN) do
			knownNamed[#knownNamed + 1] = { id = id, name = NameOf(id) }
		end
		local knownHits = 0
		for _, r in ipairs(knownNamed) do
			if r.name then
				knownHits = knownHits + 1
			end
		end
		local impossible = NameOf(CONTROL_IMPOSSIBLE)

		out.controls.known = knownNamed
		out.controls.knownHits = knownHits
		out.controls.knownTotal = #CONTROL_KNOWN
		out.controls.impossibleID = CONTROL_IMPOSSIBLE
		out.controls.impossibleName = impossible
		out.namedFirstPass = firstNamed
		out.named = named
		out.total = total
		ns.db.mechProbe = out

		print(("%s |cff8fd3ffmechanic ids|r  %d of %d named (%d before asking the server)."):format(
			Prefix(), named, total, firstNamed))

		-- The controls decide whether the number above is worth anything.
		if impossible then
			print(("   |cffff5040DEAD RUN: the impossible id %d came back as %q. The read names anything, so nothing here counts.|r"):format(
				CONTROL_IMPOSSIBLE, impossible))
		elseif knownHits == 0 then
			print("   |cffff5040DEAD RUN: not one of our own six Nymrissa ids named either.|r")
			print("   |cffffd100This client cannot name unreleased-lair spells, so a nameless candidate proves nothing.|r")
		else
			print(("   |cff40d060controls hold|r — %d/%d of our own DBM ids named, the impossible id stayed empty."):format(
				knownHits, #CONTROL_KNOWN))
			if named == 0 then
				print("   |cffffd100Then GTFO's ids genuinely name nothing here — real evidence, not a cold cache.|r")
			end
		end
		print("   |cff8a8f98/reload writes the full list to the DB.|r")
	end

	if C_Timer and C_Timer.After then
		C_Timer.After(3, Finish)
		print(("%s asked the server about %d ids — reading back in 3s."):format(Prefix(), total + #CONTROL_KNOWN + 1))
	else
		Finish()
	end
end
