local _, ns = ...

--[[
	Midnight Helper — what your stats do, in plain words (/mh stats).

	Rob, 26 aug: "het uitleggen van stats in jip-en-janneke-taal, en dan in het
	bijzonder voor de spec waar de user in is, zodat zelfs ik het begrijp."

	⚠️ WE HAD THE DATA AND NEVER EXPLAINED IT. `data/vault_stat_priorities.json`
	carries a curated secondary order for every spec and every hero tree, and the
	Vault advisor has been scoring with it since it shipped. The only thing a player
	ever saw of that work was one line of jargon:

	    Strength > Haste > Crit > Mastery > Vers

	That is a priority for someone who already knows what the four words mean. The
	person who needs it most reads it as a password. Eighth instance of the
	discoverability fault this project keeps rediscovering — the knowledge existed,
	the door did not.

	WHAT THIS DOES DIFFERENTLY FROM A GLOSSARY. Three of the four secondaries mean
	the same thing for everyone, so their text is written once and stays general.
	**Mastery does not.** Mastery is a different effect for all 40-odd specs, and it
	is exactly the one no guide can explain to you in the abstract. The game holds
	that sentence, per spec, already translated — so we ask the client for it rather
	than writing 40 descriptions we would then have to maintain. Same rule as
	`/mh curios`: nothing about the effect is hardcoded.

	⚠️ THE HEADLINE IS "YOU PROBABLY DO NOT NEED THIS." A beginner who learns about
	stats usually learns the wrong lesson from it and starts turning down higher-ilvl
	items to chase a colour. So the page opens with the honest ordering — ilvl first,
	stats only as a tie-break — and ends by saying MH already applies this for you in
	the Vault and in the loot tips. Explaining a thing and telling someone to act on
	it are not the same, and only the first is asked for here.

	WHERE THE ORDER COMES FROM. `ns.GetCurrentSpecWeights()` in VaultAdvisor.lua —
	the same call the advisor and the Pawn export use, so the three can never drift.
	It has already resolved the hero talent and the raid/M+ profile; we only sort.

	🔎 VERIFY IN-GAME (Rob): the four percentages should match your character sheet
	exactly. `/mh stats probe` prints every API this file tries, whether it answered,
	and what it said. If a number disagrees with the sheet, or a probe line reads
	MISSING, that branch is wrong and should be deleted rather than guessed at.
]]

local function L(key)
	return (ns.L and ns:L(key)) or key
end
local function LF(key, ...)
	local fmt = L(key)
	if select("#", ...) > 0 and type(fmt) == "string" then
		local ok, out = pcall(string.format, fmt, ...)
		if ok then
			return out
		end
	end
	return fmt
end

--- Ask the client for a number, and treat "could not ask" as unknown rather than 0.
--- A 0 here would read as "you have none of this stat", which is a different claim.
local function Num(fn, ...)
	if type(fn) ~= "function" then
		return nil
	end
	local ok, v = pcall(fn, ...)
	if ok and type(v) == "number" then
		return v
	end
	return nil
end

--- Blizzard's own labels, so the four names match the character sheet in every
--- language without us translating a single one of them.
local function StatName(globalString, fallback)
	local v = _G[globalString]
	if type(v) == "string" and v ~= "" then
		return v
	end
	return fallback
end

-- ⚠️ Order of the table is NOT the order shown. The shown order comes from the
-- spec weights; this is only the lookup.
local SECONDARIES = {
	crit = { nameGS = "STAT_CRITICAL_STRIKE", fallback = "Critical Strike", bodyKey = "STATS_CRIT_BODY" },
	haste = { nameGS = "STAT_HASTE", fallback = "Haste", bodyKey = "STATS_HASTE_BODY" },
	mastery = { nameGS = "STAT_MASTERY", fallback = "Mastery", bodyKey = "STATS_MAST_BODY" },
	vers = { nameGS = "STAT_VERSATILITY", fallback = "Versatility", bodyKey = "STATS_VERS_BODY" },
}

-- LE_UNIT_STAT_* are 1/2/4 for Strength/Agility/Intellect; the names live in the
-- SPELL_STAT<n>_NAME globals the character sheet uses.
local PRIMARY_BY_STAT = {
	[1] = { gs = "SPELL_STAT1_NAME", fallback = "Strength" },
	[2] = { gs = "SPELL_STAT2_NAME", fallback = "Agility" },
	[4] = { gs = "SPELL_STAT4_NAME", fallback = "Intellect" },
}

local function GetSpecBasics()
	if not (GetSpecialization and GetSpecializationInfo) then
		return nil
	end
	local idx = GetSpecialization()
	if not idx or idx < 1 then
		-- Fresh or low-level characters have no spec at all. Say so; do not fall
		-- back to a "generic" order, because that is advice nobody asked for.
		return nil
	end
	local ok, specID, specName, _, _, _, primaryStat = pcall(GetSpecializationInfo, idx)
	if not ok or not specID then
		return nil
	end
	-- The client returns "Blood", not "Blood Death Knight", so the header alone read
	-- as a colour word. Spec and class are joined as "spec (class)" rather than glued
	-- together: word order differs per language and "Sang (Chevalier de la mort)"
	-- survives that, "Sang Chevalier de la mort" does not.
	local className
	if UnitClass then
		local okC, v = pcall(UnitClass, "player")
		className = okC and type(v) == "string" and v ~= "" and v or nil
	end
	return {
		index = idx,
		specID = specID,
		specName = specName,
		className = className,
		primaryStat = type(primaryStat) == "number" and primaryStat or nil,
	}
end

--- The mastery spell for the active spec, with the game's own description.
---
--- ⚠️ MEASURED 27 aug 2026 on Rob's Elemental Shaman, live 12.1:
---     C_SpecializationInfo.GetMasterySpells   MISSING
---     GetSpecializationMasterySpells          OK  -> spell 168534, "Mastery: Elemental Overload"
---
--- This file shipped with BOTH names and asked the client which one exists, because a
--- grep across other addons is not proof — that is how a dead event name shipped on
--- 8 Aug. The client has now answered, so the candidate that does not exist is gone
--- rather than left in "just in case": a fallback nobody can trigger is untested code
--- that reads like a safety net.
--- @return number|nil spellID
local function GetMasterySpellID(specIndex)
	if type(GetSpecializationMasterySpells) ~= "function" then
		return nil
	end
	local ok, a = pcall(GetSpecializationMasterySpells, specIndex)
	if ok and type(a) == "number" then
		return a
	end
	return nil
end

--- Name + description of the mastery, read from the client.
--- Cold spell data comes back empty, so the request goes out first — the /mh curios
--- lesson: a blank after one ask means "not loaded yet", never "has no text".
local function ReadMasterySpell(spellID)
	if not spellID then
		return nil, nil
	end
	if C_Spell and C_Spell.RequestLoadSpellData then
		pcall(C_Spell.RequestLoadSpellData, spellID)
	end
	local name, desc
	if C_Spell and C_Spell.GetSpellName then
		local ok, v = pcall(C_Spell.GetSpellName, spellID)
		name = ok and v or nil
	end
	if C_Spell and C_Spell.GetSpellDescription then
		local ok, v = pcall(C_Spell.GetSpellDescription, spellID)
		-- Positive test: some spells answer with a bare "\r\n", which is empty to a
		-- reader but not to `~= ""`.
		if ok and type(v) == "string" and v:find("%w") then
			-- ⚠️ EXACTLY EIGHT hex digits, never `|c%x+`. A-F are hex digits, so the
			-- greedy form eats the first letter of the coloured word: Blood Shield
			-- came out of the smoke test as "lood Shield". CurioExplain.lua had the
			-- same pattern and the same silent bug — see the handoff.
			desc = v:gsub("|c%x%x%x%x%x%x%x%x", ""):gsub("|r", ""):gsub("|T[^|]*|t", "")
				:gsub("%s+", " "):gsub("^%s+", ""):gsub("%s+$", "")
		end
	end
	return name, desc
end

--- Crit as the character sheet shows it. Casters read the spell value, everyone
--- else the melee one — the same split PaperDollFrame makes. 🔎 VERIFY: if these
--- ever disagree with the sheet, the split is what to look at first.
local function ReadCrit(primaryStat)
	if primaryStat == 4 then
		local v = Num(GetSpellCritChance, 2)
		if v then
			return v
		end
	end
	return Num(GetCritChance)
end

local function ReadVersatility()
	local CR = _G.CR_VERSATILITY_DAMAGE_DONE
	if type(CR) == "number" then
		local v = Num(GetCombatRatingBonus, CR)
		if v then
			return v
		end
	end
	return nil
end

--- Everything the page needs, read once.
--- @return table|nil snapshot, string|nil whyKey
function ns.GetStatSnapshot()
	local basics = GetSpecBasics()
	if not basics then
		return nil, "STATS_NO_SPEC"
	end

	local weights, weightKey
	if ns.GetCurrentSpecWeights then
		weights, weightKey = ns.GetCurrentSpecWeights()
	end

	local values = {
		crit = ReadCrit(basics.primaryStat),
		haste = Num(GetHaste),
		mastery = Num(GetMasteryEffect),
		vers = ReadVersatility(),
	}

	-- Sort by the advisor's own weights. Without them we still explain the four,
	-- just without claiming an order — an invented order would be exactly the kind
	-- of confident wrong answer this addon does not give.
	local order = {}
	for id in pairs(SECONDARIES) do
		order[#order + 1] = id
	end
	local ranked = weights ~= nil
	if ranked then
		table.sort(order, function(a, b)
			local wa, wb = weights[a] or 0, weights[b] or 0
			if wa ~= wb then
				return wa > wb
			end
			return a < b
		end)
	else
		table.sort(order)
	end

	local masterySpellID = GetMasterySpellID(basics.index)
	local masteryName, masteryDesc = ReadMasterySpell(masterySpellID)

	local primary
	if basics.primaryStat and PRIMARY_BY_STAT[basics.primaryStat] then
		local p = PRIMARY_BY_STAT[basics.primaryStat]
		primary = StatName(p.gs, p.fallback)
	end

	local meta = weightKey and ns.VAULT_ADVISOR_SPEC_META and ns.VAULT_ADVISOR_SPEC_META[weightKey] or nil

	local specLabel = basics.specName
	if specLabel and basics.className then
		specLabel = LF("STATS_SPEC_FMT", specLabel, basics.className)
	end

	--- 🔴 EQUAL STATS SHARE A RANK. Found on Rob's Elemental Shaman, 27 aug: haste and
	--- crit both weigh 0.92, the guide line at the bottom of the same window says
	--- "Haste = Crit", and the list above it numbered crit 2 and haste 3. The order came
	--- from the alphabetical tie-break above — stable, but arbitrary, and it contradicted
	--- the sentence directly underneath.
	---
	--- A number implies a claim. Where the data does not make one, neither do we.
	local rank = {}
	if ranked then
		local n = 0
		for i, id in ipairs(order) do
			local prev = order[i - 1]
			if not (prev and (weights[prev] or 0) == (weights[id] or 0)) then
				n = i
			end
			rank[id] = n
		end
	end

	return {
		specName = specLabel,
		primary = primary,
		order = order,
		rank = rank,
		ranked = ranked,
		values = values,
		masterySpellID = masterySpellID,
		masteryName = masteryName,
		masteryDesc = masteryDesc,
		weightKey = weightKey,
		priorityText = meta and meta.priorityText or nil,
		sources = meta and meta.sources or nil,
		patch = meta and meta.patch or nil,
		mplusProfile = weightKey and weightKey:find("_MPLUS$") ~= nil or false,
	}
end

local function FormatPercent(v)
	if type(v) ~= "number" then
		return L("STATS_VALUE_UNKNOWN")
	end
	return LF("STATS_PERCENT_FMT", v)
end

function ns.BuildStatCoachText()
	local snap, why = ns.GetStatSnapshot()
	if not snap then
		return L(why or "STATS_NO_SPEC")
	end

	local lines = {}
	lines[#lines + 1] = LF("STATS_HEADER_FMT", snap.specName or "?")
	lines[#lines + 1] = ""
	lines[#lines + 1] = L("STATS_SHORT")
	lines[#lines + 1] = ""

	if snap.primary then
		lines[#lines + 1] = LF("STATS_PRIMARY_FMT", snap.primary)
		lines[#lines + 1] = L("STATS_PRIMARY_BODY")
		lines[#lines + 1] = ""
	end

	lines[#lines + 1] = snap.ranked and L("STATS_ORDER_HEAD") or L("STATS_ORDER_HEAD_UNRANKED")
	lines[#lines + 1] = ""

	for i, id in ipairs(snap.order) do
		local def = SECONDARIES[id]
		local name = StatName(def.nameGS, def.fallback)
		if id == "mastery" and snap.masteryName then
			-- The spec's own name for it is worth more than the generic word, and it
			-- is the label on their character sheet. Blizzard already prefixes it
			-- ("Mastery: Blood Shield", "Meisterschaft: ..."), so printing both gave
			-- "Mastery (Mastery: Blood Shield)" — use the spell name alone whenever it
			-- already opens with the stat's own word, in whatever language that is.
			if snap.masteryName:sub(1, #name):lower() == name:lower() then
				name = snap.masteryName
			else
				name = LF("STATS_SPEC_FMT", name, snap.masteryName)
			end
		end
		-- Shared rank when the weights tie, so two stats of equal worth read as equal
		-- instead of one silently outranking the other on alphabetical order.
		local shown = (snap.rank and snap.rank[id]) or i
		local tied = false
		for other, r in pairs(snap.rank or {}) do
			if other ~= id and r == shown then
				tied = true
				break
			end
		end
		lines[#lines + 1] = LF("STATS_LINE_FMT", shown, name, FormatPercent(snap.values[id]))
			.. (tied and (" " .. L("STATS_TIED_MARK")) or "")
		if id == "mastery" then
			if snap.masteryDesc then
				lines[#lines + 1] = "   " .. snap.masteryDesc
				-- "the line above is yours alone" only makes sense when there IS a
				-- line above, so it is skipped on the failure path rather than
				-- pointing at an apology.
				lines[#lines + 1] = "   " .. L("STATS_MAST_BODY")
			else
				-- Unreadable, not absent. An empty line here would suggest the spec
				-- has no mastery effect, which is never true.
				lines[#lines + 1] = "   " .. L("STATS_MAST_NO_TEXT")
			end
		else
			lines[#lines + 1] = "   " .. L(def.bodyKey)
		end
		lines[#lines + 1] = ""
	end

	if snap.priorityText then
		lines[#lines + 1] = LF("STATS_ORDER_RAW_FMT", snap.priorityText)
	end
	if snap.sources then
		lines[#lines + 1] = LF("VAULT_ADVISOR_SOURCE_FMT", snap.sources, snap.patch or "?")
	end
	if snap.mplusProfile then
		lines[#lines + 1] = L("VAULT_ADVISOR_PROFILE_MPLUS")
	end
	lines[#lines + 1] = ""
	lines[#lines + 1] = L("STATS_FOOTER")

	return table.concat(lines, "\n")
end

--- /mh stats
--- The spell text may still be cold on the first run, so we ask, wait, and only
--- then draw — the same retry the curio explainer needed.
function ns.ShowStatCoach()
	local basics = GetSpecBasics()
	local spellID = basics and GetMasterySpellID(basics.index) or nil
	if spellID and C_Spell and C_Spell.RequestLoadSpellData and C_Timer and C_Timer.After then
		pcall(C_Spell.RequestLoadSpellData, spellID)
		local tries = 0
		local function attempt()
			tries = tries + 1
			local _, desc = ReadMasterySpell(spellID)
			if desc or tries >= 3 then
				ns.ShowStatCoachNow()
				return
			end
			C_Timer.After(1, attempt)
		end
		C_Timer.After(0.5, attempt)
		return
	end
	ns.ShowStatCoachNow()
end

function ns.ShowStatCoachNow()
	local text = ns.BuildStatCoachText()
	if ns.ShowShareCopyDialog then
		ns.ShowShareCopyDialog({
			id = "stats",
			text = text,
			titleKey = "STATS_TITLE",
			hintKey = "STATS_HINT",
			closeKey = "DELVE_SHARE_COPY_CLOSE",
			width = 620, height = 520,
		})
	else
		print(text)
	end
end

--- /mh stats probe — which API answered, and with what.
--- Exists so the two mastery candidates and the crit split are settled by Rob's
--- client instead of by confidence. Delete the losing branch once it has spoken.
function ns.PrintStatProbe()
	local p = ("|cffffcc00%s|r "):format(L("PRINT_PREFIX"))
	local function say(label, ok, value)
		print(p .. ("%s: %s %s"):format(label, ok and "OK" or "MISSING", value ~= nil and tostring(value) or ""))
	end

	local basics = GetSpecBasics()
	say("GetSpecializationInfo", basics ~= nil, basics and (tostring(basics.specID) .. " / primaryStat=" .. tostring(basics.primaryStat)) or nil)

	-- Still reported, now as a watch rather than a choice: if 12.x ever moves this into
	-- C_SpecializationInfo the probe says so before the mastery line goes quiet.
	say("GetSpecializationMasterySpells", type(GetSpecializationMasterySpells) == "function", nil)
	say("C_SpecializationInfo.GetMasterySpells (expected MISSING)",
		C_SpecializationInfo and type(C_SpecializationInfo.GetMasterySpells) == "function", nil)
	if basics then
		local sid = GetMasterySpellID(basics.index)
		local name, desc = ReadMasterySpell(sid)
		say("mastery spellID", sid ~= nil, sid)
		say("mastery name", name ~= nil, name)
		say("mastery description", desc ~= nil, desc and (desc:sub(1, 60) .. "…") or nil)
	end

	say("GetCritChance", Num(GetCritChance) ~= nil, Num(GetCritChance))
	say("GetSpellCritChance(2)", Num(GetSpellCritChance, 2) ~= nil, Num(GetSpellCritChance, 2))
	say("GetHaste", Num(GetHaste) ~= nil, Num(GetHaste))
	say("GetMasteryEffect", Num(GetMasteryEffect) ~= nil, Num(GetMasteryEffect))
	say("CR_VERSATILITY_DAMAGE_DONE", type(_G.CR_VERSATILITY_DAMAGE_DONE) == "number", _G.CR_VERSATILITY_DAMAGE_DONE)
	say("GetCombatRatingBonus(vers)", ReadVersatility() ~= nil, ReadVersatility())

	local key
	if ns.GetCurrentSpecWeights then
		local _weights
		_weights, key = ns.GetCurrentSpecWeights()
	end
	say("weight key", key ~= nil, key)
end
