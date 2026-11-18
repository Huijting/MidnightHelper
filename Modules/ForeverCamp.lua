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
	-- Cozy Sleeping Bag (Rob via sparring: "Oh en 1 t/m 3 mag ook", 18 Nov 2026). Hotfix 17 Nov 2026 (Blizzard News,
	-- GEMETEN): "will now provide a Resting aura indicating when you are within its area of effect" and "Mounted Players
	-- will no longer be permitted to sleep". 1331671 "Resting" (bag icon): GEMETEN in Wowhead Forever + Icy Veins DB
	-- ("added in 1.60.1.70959"); NOT in the build's base DB2 (a hotfix row, AFGELEID). That it is THE bag aura: AFGELEID
	-- (icon, date, hotfix text) — /mh camp shows the reading. 429959 Well-Rested (+1% XP per stack, up to 3): GEMETEN
	-- DB2 SpellName + Wowhead Forever; the bag item 211527 casts 429961 Unroll Bag (GEMETEN DB2 ItemEffect).
	bagRest = 1331671,
	wellRested = 429959,
}
local ORDER = { "nearby", "welcoming", "welcoming2", "benefits", "tent", "rest", "camping", "bagRest", "wellRested" }
local WELL_RESTED_MAX = 3 -- up to 3 stacks (Wowhead Forever guide, 16 Nov 2026; item spell text "stacking up to 3 times")
ns.FOREVER_CAMP_AURAS = AURA -- the overview's Camping page names its rows with these (client spell names)

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

--- Well-Rested stacks: a number, or nil when unreadable (secret / no data). 0 = readable and absent.
local function WellRestedStacks()
	if not (ns.Aura and ns.Aura.GetPlayerAura) then
		return nil
	end
	local ok, data, readable = pcall(ns.Aura.GetPlayerAura, AURA.wellRested)
	if not ok then
		return nil
	end
	if data == nil then
		return readable and 0 or nil
	end
	local n = data.applications
	if type(n) ~= "number" or (issecretvalue and issecretvalue(n)) then
		return nil
	end
	return math.max(n, 1)
end

local function Mounted()
	if IsMounted then
		local ok, m = pcall(IsMounted)
		if ok then
			return m and true or false
		end
	end
	return false
end

--- The sleeping-bag line, or nil plus why not. Only when the bag's Resting aura reads as PRESENT (you are in its area).
local function BagLine(st)
	if st.bagRest ~= true then
		return nil, st.bagRest == nil and "sleeping bag Resting unreadable" or "not in a sleeping bag's area"
	end
	if Mounted() then
		return ns:L("FCAMP_BAG_MOUNTED"), "in the bag's area, but mounted (no sleeping on a mount since 17 Nov)"
	end
	local n = WellRestedStacks()
	if n == nil then
		return nil, "Well-Rested unreadable (silent on purpose)"
	end
	if n >= WELL_RESTED_MAX then
		return nil, "Well-Rested is full (" .. n .. ")"
	end
	return ns:L("FCAMP_BAG_SLEEP_FMT"):format(SpellName(AURA.wellRested), n, WELL_RESTED_MAX), "in the bag's area, stacks " .. n
end

--- The "Do this now" line, or nil plus the reason it stays silent.
function ns.ForeverCampNow()
	if InCombatLockdown and InCombatLockdown() then
		return nil, "in combat"
	end
	local st = ns.ForeverCampState()
	local bag, bagWhy = BagLine(st)
	if bag then
		return bag, bagWhy
	end
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
	local _, bagWhy = BagLine(st)
	print(("  sleeping bag: mounted %s, Well-Rested stacks %s — %s"):format(tostring(Mounted()),
		tostring(WellRestedStacks()), tostring(bagWhy)))
	probe.bag = { mounted = Mounted(), stacks = WellRestedStacks(), why = bagWhy }
	print(("  \"Do this now\": %s — %s"):format(line and "|cff40c040shows a line|r" or "silent", tostring(why)))
	probe.decision = line and "line" or "silent"
	probe.why = why
	if type(ns.db) == "table" then
		ns.db.foreverCampProbe = probe
		print("  saved in SavedVariables (foreverCampProbe) — /reload writes it to disk.")
	end
end
