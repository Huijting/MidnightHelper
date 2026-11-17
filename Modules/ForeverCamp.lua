local _, ns = ...

--[[
	ForeverCamp.lua — WoW Forever: camping (campfire + camp objects), step 1.

	Rob, 17 Nov 2026 (via Sparring 17-11): "We hebben tegenwoordig kampvuurs waarbij je allerlei power-ups … tijdelijke
	buffs kan krijgen … Daar hebben we volgens mij ook helemaal niks over." On the research: "Ja, het zal vast mana wel
	zijn. En dat kampvuuridee moeten we ook gaan bouwen."

	Facts: docs/forever/CAMPING_VERIFIED_2026-11-17.md (Fable check of the Opus research against DB2 1.60.1.70938).
	  1283391 Campfire Nearby   passive area aura near a fire (100 yd in the data; not measured in game)
	  1229739 / 1289723 Welcoming Campfire   60 s timer while you sit; then
	  1229741 Camp Benefits     1 hour, one line per camp object
	  1229487 Camp Tent (30 s timer)  → 1229451 Boosted Rest (the 1-hour lock, not the bonus)
	  1308027 Camping           the shared 1-hour object cooldown (as a debuff on you: NOT measured)
	What is NOT measured yet, and why this step is small: whether the client lets an addon READ these auras (Forever has
	secret values; ns.Aura answers nil = unreadable). So:
	  - "Do this now" says "sit down by the fire" ONLY when Campfire Nearby reads as present and Camp Benefits and
	    Welcoming Campfire read as absent, out of combat. Anything unreadable = silent (the ns.Aura rule).
	  - /mh camp prints every reading and the decision with its reason, and stores them in ns.db.foreverCampProbe for
	    Rob's first test ("are 1229741 and 1283391 readable?"). Silence must be visible (CLAUDE.md).
	Buff names come from the client (C_Spell.GetSpellName), so every language shows its own game name.
	Later steps (after Rob's test): the explanation card (ForeverProfGuide "version B"), the profession hint, tooltips.
]]

if not ns.IS_FOREVER then
	return
end

local PREFIX = "|cffffcc00Midnight Helper:|r "
local AURA = {
	nearby = 1283391,
	welcoming = 1229739,
	welcoming2 = 1289723,
	benefits = 1229741,
	tent = 1229487,
	rest = 1229451,
	camping = 1308027,
}
local ORDER = { "nearby", "welcoming", "welcoming2", "benefits", "tent", "rest", "camping" }

--- true / false / nil (nil = the client did not let us read it).
local function Read(id)
	if not (ns.Aura and ns.Aura.HasPlayerAura) then
		return nil
	end
	local ok, v = pcall(ns.Aura.HasPlayerAura, id)
	if ok then
		return v
	end
	return nil
end

local function SpellName(id)
	if C_Spell and C_Spell.GetSpellName then
		local ok, n = pcall(C_Spell.GetSpellName, id)
		if ok and type(n) == "string" and n ~= "" and not (issecretvalue and issecretvalue(n)) then
			return n
		end
	end
	return "#" .. tostring(id)
end

--- Every reading, keyed like AURA.
function ns.ForeverCampState()
	local st = {}
	for _, k in ipairs(ORDER) do
		st[k] = Read(AURA[k])
	end
	return st
end

--- The "Do this now" line, or nil plus the reason it stays silent.
function ns.ForeverCampNow()
	if InCombatLockdown and InCombatLockdown() then
		return nil, "in combat"
	end
	local st = ns.ForeverCampState()
	if st.nearby == nil then
		return nil, "Campfire Nearby unreadable (silent on purpose)"
	end
	if st.nearby == false then
		return nil, "no campfire near you"
	end
	if st.benefits == true then
		return nil, "you already have Camp Benefits"
	end
	if st.welcoming == true or st.welcoming2 == true then
		return nil, "Welcoming Campfire is running: keep sitting"
	end
	if st.benefits == nil or st.welcoming == nil then
		return nil, "Camp Benefits or Welcoming Campfire unreadable (silent on purpose)"
	end
	return ns:L("FCAMP_SIT_FMT"):format(SpellName(AURA.welcoming), SpellName(AURA.benefits)), "near a fire, no camp buff"
end

local function YN(v)
	if v == nil then
		return "|cff9d9d9d? (unreadable)|r"
	end
	return v and "|cff40c040yes|r" or "|cffff8080no|r"
end

--- /mh camp: every aura reading, the decision and why; stored for Rob's test.
function ns.ForeverCampSlash()
	local st = ns.ForeverCampState()
	local line, why = ns.ForeverCampNow()
	local combat = (InCombatLockdown and InCombatLockdown()) and true or false
	print(PREFIX .. "camping — what the client lets us read" .. (combat and " (in combat)" or "") .. ":")
	local probe = { at = time and time() or 0, combat = combat, readings = {} }
	for _, k in ipairs(ORDER) do
		local id = AURA[k]
		print(("  %s %d (%s): %s"):format(k, id, SpellName(id), YN(st[k])))
		probe.readings[k] = (st[k] == nil) and "unreadable" or tostring(st[k])
	end
	print(("  \"Do this now\": %s — %s"):format(line and "|cff40c040shows a line|r" or "silent", tostring(why)))
	probe.decision = line and "line" or "silent"
	probe.why = why
	if type(ns.db) == "table" then
		ns.db.foreverCampProbe = probe
		print("  saved in SavedVariables (foreverCampProbe) — /reload writes it to disk.")
	end
end
