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

--- Zone label, GTFO's uiMapID, and the ids we do not already reference.
--- Order preserved from GTFO_Spells_MN.lua so a re-harvest diffs cleanly.
local CANDIDATES = {
	{ "Magister's Terrace", 2811, { 1214089 } },
	{ "Windrunner Spire", 2805, { 473784, 472118, 468924, 472777 } },
	{ "The Dreamrift", 2939, { 1245919 } },
	{ "Nexus-Point Xenas", 2915, { 1277597 } },
	{ "The Voidspire", 2912, {
		1284786, 1280101, 1251213, 1245592, 1260030, 1244672,
		1245421, 1276982, 1246158, 1272324, 1238206, 1242553,
	} },
	{ "March on Quel'Danas", 2913, { 1241840, 1241841, 1242803, 1242815, 1282470, 1222306 } },
	{ "Altar of Fangs", 2993, { 1306232, 1306669, 1307573, 1307531, 1309416, 1301231 } },
	{ "Maisara Caverns", 2874, {
		1257782, 1243752, 1251833, 1252130, 1257898,
		1259777, 1252816, 1253779, 1254043,
	} },
	{ "Tidebound Grotto", 2987, { 1257654, 1265425, 1281341 } },
	{ "The Venomous Abyss", 3004, { 1285623 } },
	{ "Murder Row", 2813, { 474234, 1216590, 1215985, 1294870, 1215200, 1216955 } },
	{ "Voidscar Arena", 2923, {
		1249712, 1228126, 1299210, 1296967, 1222484, 1282892, 1264188, 1248130,
	} },
	{ "The Blinding Vale", 2859, { 1237858, 1314885, 1234802, 1235828, 1251345, 1239919, 1246751 } },
	{ "Den of Nalorakk", 2825, { 1297701, 1252825, 1235405, 1236289, 1247367 } },
}

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
		for _, id in ipairs(z[3]) do
			Ask(id)
		end
	end
	for _, id in ipairs(CONTROL_KNOWN) do
		Ask(id)
	end
	Ask(CONTROL_IMPOSSIBLE)

	local firstNamed, total = 0, 0
	for _, z in ipairs(CANDIDATES) do
		for _, id in ipairs(z[3]) do
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
			for _, id in ipairs(z[3]) do
				local n = NameOf(id)
				if n then
					named = named + 1
				end
				rows[#rows + 1] = { id = id, name = n }
			end
			out.zones[#out.zones + 1] = { zone = z[1], mapID = z[2], spells = rows }
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
