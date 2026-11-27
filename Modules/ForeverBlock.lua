local _, ns = ...

--[[
	ForeverBlock.lua — the key block in WoW Forever: one macro per key, for every class that has an APPROVED table.

	History: built for Rob's Night Elf Druid on 5 Nov 2026 (ForeverDruidBlock.lua, "Macro per toets", table "ja goedzo"),
	made class-independent the same night (Rob: "ga helemaal los" on the overnight plan) so each class only adds a table.
	Plan and rules: docs/PLAN_FOREVER_DRUID_BLOK_2026-11-05.md. The other classes' tables are PROPOSALS in docs/ until
	Rob approves them; only an approved table is registered in ns.FOREVER_BLOCK_CLASSES (ForeverBlock_<Class>.lua).

	A class table:
	  states   = ordered list of { name = "bear", cond = "[bonusbar:3]", guards = true } — a key's spell for that state
	             gets that macro condition. guards = the base spell must not fire in this state (Druid: Wrath in Bear).
	  baseGuard = the condition put before the base spell when a guarding state has a spell on that key.
	  keys     = [blockKey] = { base = spell(s), <state name> = spell(s), all = spell(s), open = true, pair = {...} }
	             A spell may be a list: the first one this character knows wins (Dire Bear Form over Bear Form).
	             all  = one spell in every state (no conditions).
	             open = never guard the base spell on this key (Druid R: Travel Form also from Bear).
	             bang = put "!" before the names, so pressing again never switches the spell off (Hunter Auto Shot).
	             pair = { cond = "[combat]", first = "Rebirth", second = "Revive" }: first when cond, else second.
	             cmd  = { text = "/petattack", needs = spell(s), label, icon }: a plain macro line (pet commands).
	  toBlockD = spells that go on the player's own block D instead.
	  listed   = extra names that count as handled for the "not in MH's list" line (e.g. "Attack").

	Spells by NAME so the game casts the highest rank (MEASURED 5 Nov 2026: C_Spell.GetSpellInfo("Wrath") = 5177, Rank 2).
	A spell this character does not have is left out; a key with nothing gets no macro and stays an empty place.
	Macros are rewritten out of combat when a spell or rank is learned. Macro name: "MH <key>".
	KeyBlock.lua asks ns.ForeverKeyBlockBuild() first; anywhere else it returns nil and nothing changes.
]]

if not ns.IS_FOREVER then
	return
end

ns.FOREVER_BLOCK_CLASSES = ns.FOREVER_BLOCK_CLASSES or {}

local MACRO_PREFIX = "MH "
local MACRO_ICON = "INV_MISC_QUESTIONMARK"

--- 24 Nov 2026: with the "12 x 4" block chosen (KeyBlock.lua, /mh block style 12x4) a class table's keys12 is used
--- instead of its keys; everything else (states, baseGuard, toBlockD, listed) stays the class's own. A class without
--- keys12 keeps its old keys (the switch refuses 12x4 for it, so this is only a safety net).
--- Every spell name a keys table names, in a stable order (fields that are not spells are skipped).
local SKIP_FIELD = { open = true, bang = true, why = true, cmd = true, pair = true }
local function KeyNames(keys)
	local list, seen = {}, {}
	local function add(v)
		if type(v) == "table" then
			for _, n in ipairs(v) do
				add(n)
			end
		elseif type(v) == "string" and not seen[v] then
			seen[v] = true
			list[#list + 1] = v
		end
	end
	local order = {}
	for k in pairs(keys or {}) do
		order[#order + 1] = k
	end
	table.sort(order)
	for _, k in ipairs(order) do
		local def = keys[k]
		for field, v in pairs(def) do
			if field == "pair" then
				add(v.first)
				add(v.second)
			elseif field == "cmd" then
				add(v.needs)
			elseif not SKIP_FIELD[field] then
				add(v)
			end
		end
	end
	return list, seen
end
ns.ForeverBlockKeyNames = KeyNames -- the offline check calls it

local views = {}
local function ClassTable()
	local _, token = UnitClass("player")
	local cls = token and ns.FOREVER_BLOCK_CLASSES[token]
	if cls and cls.keys12 and ns.KeyBlockLayoutName and ns.KeyBlockLayoutName() == "12x4" then
		local v = views[token]
		if not v or v._src ~= cls then
			-- A spell of the old block that has no place in 12 x 4 (31 places instead of 33-36) goes to block D, so
			-- it is never lost and never in the red "not in MH's list" line (helper reports, 24 Nov 2026).
			-- These come FIRST, before the class's own toBlockD (ranged attacks, racials, professions): the second check
			-- counted ~14 for 12 places on a level-60 Mage/Warlock, and then the armor buffs were the ones left off.
			local _, in12 = KeyNames(cls.keys12)
			local toD, seenD = {}, {}
			local inOrigD = {}
			for _, n in ipairs(cls.toBlockD or {}) do
				inOrigD[n] = true
			end
			for _, n in ipairs((KeyNames(cls.keys))) do
				if not in12[n] and not seenD[n] and not inOrigD[n] then
					toD[#toD + 1] = n
					seenD[n] = true
				end
			end
			for _, n in ipairs(cls.toBlockD or {}) do
				if not seenD[n] then
					toD[#toD + 1] = n
					seenD[n] = true
				end
			end
			v = setmetatable({ keys = cls.keys12, toBlockD = toD, _src = cls, twelve = true }, { __index = cls })
			views[token] = v
		end
		return v, token
	end
	return cls, token
end
ns.ForeverBlockClassTable = ClassTable

local function InSpellBook(id)
	-- Name lookups should only find spells you have; the spellbook check makes sure (AFGELEID that it is needed).
	if C_SpellBook and C_SpellBook.FindSpellBookSlotForSpell then
		local okS, slot = pcall(C_SpellBook.FindSpellBookSlotForSpell, id)
		if okS and not slot then
			return false
		end
	end
	return true
end

--- 🌍 7 Nov 2026 (Rob: "ja op spell nummers"). The class tables name spells in ENGLISH. On a deDE/frFR/esES/esMX/ptBR/
--- ruRU Forever client a lookup by that name finds nothing (and "/cast Smite" does nothing there), so the block stayed
--- empty for every non-English player. Every English name now also has its spell ids: ForeverSpellIds.lua (measured on
--- wago wowf 1.60.1.70862) plus every rank in ForeverTrainerData.lua. The macro then uses the CLIENT's name for the id
--- the character has (some spells change name per rank in one client: deDE Smite rank 1 "Heilige Pein", later ranks
--- "Göttliche Pein", docs/forever/CLIENT_NAMES_FOREVER_2026-11-07.md section 5).
--- 🔴 The lists are in RANK order, low to high — NOT id order: Slam rank 1 is 1240193 while ranks 2+ are 1464…, and
--- Create Healthstone rank 1 is 6201 while 5699 is rank 3 (mh-research, Spell.NameSubtext "Rank N", 70862). Never
--- sort them; the last id the character knows is its highest rank. Trainer ids are only appended for a name the
--- measured file does not have (in rank order too: the trainer list goes by level).
local idCache
local function IdsFor(name)
	if not idCache then
		idCache = {}
		for n, ids in pairs(ns.FOREVER_SPELL_IDS or {}) do
			local copy = {}
			for i, id in ipairs(ids) do
				copy[i] = id
			end
			idCache[n] = copy
		end
		local extra = {}
		for _, list in pairs(ns.FOREVER_TRAINER_SPELLS or {}) do
			for _, e in ipairs(list) do
				if type(e.n) == "string" and type(e.id) == "number" and not (ns.FOREVER_SPELL_IDS or {})[e.n] then
					extra[e.n] = extra[e.n] or {}
					table.insert(extra[e.n], e)
				end
			end
		end
		for n, es in pairs(extra) do
			table.sort(es, function(a, b)
				return (a.l or 0) < (b.l or 0)
			end)
			idCache[n] = {}
			for _, e in ipairs(es) do
				table.insert(idCache[n], e.id)
			end
		end
	end
	return idCache[name]
end
ns.ForeverSpellIdsFor = IdsFor -- the offline check calls it

local function KnownId(id)
	-- 18 Nov 2026 (second check of option A): `ipairs({ IsPlayerSpell, IsSpellKnown })` stops at the first nil, so on a
	-- client without IsPlayerSpell (in Forever only a deprecation fallback, GEMETEN in Blizzard's 1.60.1.70959 source) the
	-- others were never asked. Fixed slots + C_SpellBook.IsSpellKnown (documented in Forever) first.
	local fns = { C_SpellBook and C_SpellBook.IsSpellKnown, IsPlayerSpell, IsSpellKnown }
	for i = 1, 3 do
		local fn = fns[i]
		if fn then
			local ok, v = pcall(fn, id)
			if ok and v == true then
				return true
			end
		end
	end
	return false
end

--- 🔧 24 Nov 2026 (API watcher [MOET GEFIKST], Sparring 24-11: "Fix Forever Warrior toets 3"). Blizzard's Forever hotfix of
--- 23 Nov 2026, Warrior: "Fixed an issue where players could have and use Mortal Strike from their spellbook, even
--- without the Mortal Strike talent. This does not remove it from their spellbook but prevents it from being used
--- without the talent point spent." The spellbook test below then still says "known", and key 3 became a dead
--- "/cast Mortal Strike" instead of Bloodthirst or Shield Slam. Spells listed here also need their talent node bought.
--- Node 105941 / tree 1117 = ForeverTalentNext.lua's S(105941, 12294, "Mortal Strike") (DB2, re-checked there).
--- When the talent cannot be read (no C_Traits, no config, an error) the old spellbook answer stands: never a worse
--- key than before. AFGELEID, not measured on a client that had the bug.
local TALENT_GATED = {
	["Mortal Strike"] = { tree = 1117, node = 105941 },
}
local lastGate = {} -- name -> "bought" / "not bought: skipped" / why unreadable; /mh block why prints it

--- false only when the client SAYS the talent is not bought; true or nil (unreadable) otherwise.
local function TalentBought(gate)
	if not (C_Traits and C_Traits.GetNodeInfo) then
		return nil, "no C_Traits"
	end
	local ok, ranks = pcall(function()
		local cfg = C_ClassTalents and C_ClassTalents.GetActiveConfigID and C_ClassTalents.GetActiveConfigID()
		local info = cfg and C_Traits.GetConfigInfo and C_Traits.GetConfigInfo(cfg)
		local has = false
		for _, t in ipairs(type(info) == "table" and info.treeIDs or {}) do
			if t == gate.tree then
				has = true
			end
		end
		if not has and C_Traits.GetConfigIDByTreeID then
			cfg = C_Traits.GetConfigIDByTreeID(gate.tree)
		end
		if not cfg then
			return nil
		end
		local n = C_Traits.GetNodeInfo(cfg, gate.node)
		if type(n) ~= "table" then
			return nil
		end
		local r = n.ranksPurchased
		if type(r) ~= "number" or (issecretvalue and issecretvalue(r)) then
			return nil
		end
		return r
	end)
	if not ok then
		return nil, "error: " .. tostring(ranks)
	end
	if ranks == nil then
		return nil, "talent not readable"
	end
	return ranks > 0, nil
end

--- The spell id this character has under this English name (highest rank), or nil when it does not have it.
local KnownRaw
local function Known(name)
	local id = KnownRaw(name)
	local gate = id and TALENT_GATED[name]
	if gate then
		local bought, why = TalentBought(gate)
		lastGate[name] = (bought == true and "bought") or (bought == false and "not bought: skipped") or why
		if bought == false then
			return nil
		end
	end
	return id
end
ns.ForeverBlockTalentGate = lastGate

KnownRaw = function(name)
	if not (C_Spell and C_Spell.GetSpellInfo) then
		return nil
	end
	-- 1. By name: works on an English client, as before.
	local ok, info = pcall(C_Spell.GetSpellInfo, name)
	if ok and type(info) == "table" and info.spellID and not (issecretvalue and issecretvalue(info.spellID)) then
		if InSpellBook(info.spellID) then
			return info.spellID
		end
	end
	-- 2. By id: every other client. Highest rank the character knows.
	local ids = IdsFor(name)
	if ids then
		for i = #ids, 1, -1 do
			local id = ids[i]
			if KnownId(id) and InSpellBook(id) then
				return id
			end
		end
	end
	return nil
end
-- The other modules (trainer, Do this now, quest hints, smart buff) keep the plain spellbook answer: the talent gate above
-- is only for which spell a key casts (24 Nov 2026), so nothing else changes behaviour.
ns.ForeverKnownSpell = KnownRaw

--- The name THIS client uses for a spell id (falls back to the English table name).
local function ClientName(id, english)
	if C_Spell and C_Spell.GetSpellName then
		local ok, nm = pcall(C_Spell.GetSpellName, id)
		if ok and type(nm) == "string" and nm ~= "" and not (issecretvalue and issecretvalue(nm)) then
			return nm
		end
	end
	return english
end

--- The first spell of a name (or list of names) this character has: the CLIENT's name for it (what /cast needs), its id.
local function First(v)
	if type(v) == "table" then
		for i, name in ipairs(v) do
			local id = Known(name)
			if id then
				-- 4th value (24 Nov 2026): the place in the list; > 1 = a fallback (e.g. Immolate on the Warlock's 3).
				return ClientName(id, name), id, name, i
			end
		end
		return nil
	end
	if v then
		local id = Known(v)
		if id then
			return ClientName(id, v), id, v
		end
	end
	return nil
end

--------------------------------------------------------------------------------
-- Mouseover (Rob, 9 Nov 2026: the macro plan, step 4 — "Gaan we door zolang je kan"). OFF by default; players choose
-- (/mh mouseover on|off). On: a spell from these lists gets "[@mouseover,help,nodead]" (friendly spells) or
-- "[@mouseover,harm,nodead]" (spells on an enemy) in front of its normal clause, so it lands on the unit under the mouse
-- and otherwise works as before. GEMETEN that Forever has [@mouseover] in macros: forum macros 2-5 Nov 2026
-- (docs/forever/FOREVER_MACROS_2026-11-09_A.md §1). English names, as in the class tables.
--------------------------------------------------------------------------------
local MO_HELP = {}
for _, n in ipairs({
	-- Druid
	"Healing Touch", "Regrowth", "Rejuvenation", "Swiftmend", "Innervate", "Remove Curse", "Abolish Poison",
	"Cure Poison", "Thorns", "Mark of the Wild", "Gift of the Wild",
	-- Priest
	"Lesser Heal", "Heal", "Greater Heal", "Flash Heal", "Renew", "Power Word: Shield", "Cure Disease",
	"Abolish Disease", "Power Word: Fortitude", "Prayer of Fortitude",
	-- Paladin
	"Holy Light", "Flash of Light", "Lay on Hands", "Cleanse", "Purify", "Blessing of Protection",
	"Blessing of Freedom",
	-- 16 Nov 2026 (Rob via sparring: "zet de andere ook maar op de lijst"; he buffs passers-by): the blessings for
	-- someone else, as far as they are in ns.FOREVER_SPELL_IDS (GEMETEN: Might, Kings, Wisdom, Sacrifice + the three
	-- Greater ones; Salvation/Light/Sanctuary are not in that list, so not here).
	"Blessing of Might", "Blessing of Kings", "Blessing of Wisdom", "Blessing of Sacrifice",
	"Greater Blessing of Might", "Greater Blessing of Kings", "Greater Blessing of Wisdom",
	-- Shaman
	"Healing Wave", "Lesser Healing Wave", "Chain Heal",
	-- Mage (Arcane Brilliance: same day, same reason)
	"Arcane Intellect", "Arcane Brilliance", "Remove Lesser Curse",
}) do
	MO_HELP[n] = true
end
local MO_HARM = {}
for _, n in ipairs({
	"Entangling Roots", "Hibernate", "Faerie Fire", "Polymorph", "Counterspell", "Fear", "Banish",
	"Shackle Undead", "Hunter's Mark", "Earth Shock", "Purge",
	-- 25 Nov 2026 (Rob via Sparring: "We hebben dingen als Taunt en Growl. Ik zou graag ook een macro van willen hebben
	-- voor een mouse over." -> on the proposal "ja graag"): the single-target taunts of the nine block tables (Druid F,
	-- Warrior F, Hunter F / Ctrl-E "taunt: Distracting Shot"). Not the group taunts (Challenging Roar/Shout).
	"Growl", "Taunt", "Mocking Blow", "Distracting Shot",
}) do
	MO_HARM[n] = true
end

local moSuppressed = false -- set while a key that grew past the 255-character limit is rebuilt without mouseover
local function MouseoverOn()
	return not moSuppressed and ns.db and ns.db.foreverMouseover == true
end

--- 27 Nov 2026: the form guard (see BodyRaw), on unless the player switched it off.
local function FormGuardOn()
	return not (ns.db and ns.db.foreverFormGuard == false)
end
function ns.IsForeverFormGuardOn()
	return FormGuardOn()
end

--- 27 Nov 2026: the Rogue's Stealth guard (keys with def.guard), on unless switched off.
local function StealthGuardOn()
	return not (ns.db and ns.db.foreverStealthGuard == false)
end
function ns.IsForeverStealthGuardOn()
	return StealthGuardOn()
end

--- Put the mouseover part in front of a clause's condition ("" or "[x] "). english = the table name of the spell.
local function WithMouseover(cond, english)
	if not (english and MouseoverOn()) then
		return cond
	end
	local kind = (MO_HELP[english] and "help") or (MO_HARM[english] and "harm") or nil
	if not kind then
		return cond
	end
	local inner = cond:match("^%[(.-)%]%s*$")
	if inner and inner ~= "" then
		return ("[@mouseover,%s,nodead,%s][%s] "):format(kind, inner, inner)
	end
	return ("[@mouseover,%s,nodead][] "):format(kind)
end

--- 24 Nov 2026 (Rob's Warlock: Immolate on 3 as the fallback, and still "New for your key block: Immolate -> Shift 2";
--- Rob: "Waarom krijg ik deze, terwijl die ook al op 3 gezet wordt?"). A spell that a key holds as a FALLBACK (a later
--- entry of its list, because the first is not learned yet) is not put on its own key too. Once the real one is learned
--- (Agony), the fallback key takes that and the spell goes back to its own key. Which spells are held this way, per key.
local heldCache = { stamp = nil, cls = nil, map = nil }
local FALLBACK_FIELDS = { "all", "base" }
local function FallbackHeld(cls)
	local now = GetTime and GetTime() or nil
	if now and heldCache.stamp == now and heldCache.cls == cls then
		return heldCache.map
	end
	local held = {}
	for key, def in pairs(cls and cls.keys or {}) do
		local fields = {}
		for _, f in ipairs(FALLBACK_FIELDS) do
			fields[#fields + 1] = f
		end
		for _, st in ipairs(cls.states or {}) do
			fields[#fields + 1] = st.name
		end
		for _, f in ipairs(fields) do
			local v = def[f]
			if type(v) == "table" then
				local _, _, en, idx = First(v)
				if en and idx and idx > 1 then
					held[en] = key
				end
			end
		end
	end
	heldCache.stamp, heldCache.cls, heldCache.map = now, cls, held
	return held
end
ns.ForeverBlockFallbackHeld = function()
	return FallbackHeld((ClassTable()))
end

--- First() for one key: skips a spell another key holds as its fallback (unless it is this key's own fallback).
local function FirstFor(cls, key, v)
	local name, id, en, idx = First(v)
	if en and not (idx and idx > 1) then
		local holder = FallbackHeld(cls)[en]
		if holder and holder ~= key then
			return nil
		end
	end
	return name, id, en, idx
end

local BodyRaw
--- The macro body for one key, the spell ids it uses, and the spell to show on the picture. nil when nothing is known.
--- A macro may hold 255 characters (GEMETEN: client string MACROFRAME_CHAR_LIMIT "%d/255", Forever 70862). When the
--- mouseover parts make a key longer than that, that key is built without them.
local MACRO_MAX = 255
local function Body(cls, key)
	local body, ids, show = BodyRaw(cls, key)
	if body and #body > MACRO_MAX and MouseoverOn() then
		moSuppressed = true
		body, ids, show = BodyRaw(cls, key)
		moSuppressed = false
	end
	return body, ids, show
end

BodyRaw = function(cls, key)
	local def = cls and cls.keys and cls.keys[key]
	if not def then
		return nil
	end
	local ids, show = {}, nil
	-- cmd = { text = "/petattack", needs = spell(s), label = "Pet: Attack", icon = "..." }: a plain macro line instead of
	-- a /cast, only when the character knows a `needs` spell (Rob, 6 Nov 2026: "Doe maar" on keeping Ctrl-1/2/3 for the
	-- pet). Standard slash commands; AFGELEID that Forever keeps them.
	if def.cmd then
		local need, needId = First(def.cmd.needs)
		if not need then
			return nil
		end
		ids[1] = needId
		return def.cmd.text, ids, needId
	end
	-- bang = true: "/cast !Auto Shot" — a second press does not switch the spell off again (Hunter research,
	-- 6 Nov 2026: plain /cast toggles Auto Shot off). Standard macro syntax; AFGELEID that Forever keeps it.
	local bang = def.bang and "!" or ""
	local function use(name, id)
		ids[#ids + 1] = id
		show = show or id
		return bang .. name
	end
	if def.pair then
		-- 16 Nov 2026: the pair keys (paladin blessings: "[group] Greater …; normal …") get mouseover too; before, this
		-- branch never asked WithMouseover. "[@mouseover,help,nodead,group][group] Greater X; [@mouseover,help,nodead][] X".
		-- Body() still drops mouseover for a key that would pass 255 characters.
		local a, aId, aEn = First(def.pair.first)
		local b, bId, bEn = First(def.pair.second)
		local parts = {}
		-- 27 Nov 2026: the form guard reaches the pair keys too (Druid Ctrl-R Rebirth/Revive), merged into the condition.
		local g = cls.formGuard and not def.open and FormGuardOn() and cls.baseGuard and cls.baseGuard:match("^%[(.-)%]$")
		local function G(cond)
			if not g then
				return cond
			end
			local inner = cond:match("^%[(.-)%]%s*$")
			return inner and inner ~= "" and ("[" .. g .. "," .. inner .. "] ") or ("[" .. g .. "] ")
		end
		if a then
			parts[#parts + 1] = WithMouseover(G(b and (def.pair.cond .. " ") or ""), aEn) .. use(a, aId)
		end
		if b then
			parts[#parts + 1] = WithMouseover(G(""), bEn) .. use(b, bId)
		end
		if #parts == 0 then
			return nil
		end
		return "#showtooltip\n/cast " .. table.concat(parts, "; "), ids, show
	end
	local allName, allId, allEn = FirstFor(cls, key, def.all)
	if allName then
		return "#showtooltip\n/cast " .. WithMouseover("", allEn) .. use(allName, allId), ids, show
	end
	-- 27 Nov 2026 (Rob: "als ik in beervorm ben, [ben ik] veel te snel geneigd om op 2 te drukken ... en dan ga ik uit
	-- beervorm" → "akkoord"): with cls.formGuard (the Druid), a caster spell gets the base guard ALWAYS, also before a
	-- form spell on that key is known, so in Bear or Cat the key does nothing instead of taking you out of the form
	-- (Forever's autoUnshift). GEMETEN that day: /cast without a matching condition does nothing (Blizzard Forever
	-- SlashCommands.lua). def.open keys (forms, Travel Form, Nature's Grasp) stay unguarded. Switch: the Keys tab.
	-- 27 Nov 2026 (Rob: "Ik volg uiteraard je advies."): def.guard = this one key gets the guard too (the Rogue's Evasion,
	-- Blade Flurry and Adrenaline Rush do nothing in Stealth instead of breaking it), with its own switch.
	local always = not def.open and ((cls.formGuard and FormGuardOn()) or (def.guard and StealthGuardOn()))
	local clauses, guarded = {}, always and true or false
	for _, st in ipairs(cls.states or {}) do
		local name, id, en = FirstFor(cls, key, def[st.name])
		if name then
			clauses[#clauses + 1] = WithMouseover(st.cond .. " ", en) .. use(name, id)
			if st.guards then
				guarded = true
			end
		end
	end
	local base, baseId, baseEn = FirstFor(cls, key, def.base)
	if base then
		local guard = (guarded and not def.open and cls.baseGuard) and (cls.baseGuard .. " ") or ""
		clauses[#clauses + 1] = WithMouseover(guard, baseEn) .. use(base, baseId)
	end
	if #clauses == 0 then
		return nil
	end
	-- The base spell first on the picture: that is the button's everyday meaning.
	show = baseId or show
	return "#showtooltip\n/cast " .. table.concat(clauses, "; "), ids, show
end
ns.ForeverMacroBody = function(key)
	return Body(ClassTable(), key)
end

--------------------------------------------------------------------------------
-- 🔴 27 Nov 2026, BUG: shared account macros. GEMETEN in Rob's macros-cache.txt: the druid's 18 character macros were
-- full, so new "MH <key>" macros went to the ACCOUNT list, where "MH 4" held the mage's "/cast Fire Blast", "MH CTRL-Q"
-- a paladin blessing and "MH R" the druid's Aquatic Form. GetMacroIndexByName finds the account list first, so every
-- character rewrote the SAME macro with its own spells. Now a character only ever touches its own macro:
--   its character macro "MH <key>" (looked up in the character range, never by a name that also matches the account
--   list), else an account macro "MH <key> <tag>" with a tag of its own (the last 3 characters of its GUID). A plain
--   "MH <key>" in the account list is never edited again; placing the block once more puts the own macro on the bar.
--------------------------------------------------------------------------------
local function Tag()
	local g = UnitGUID and UnitGUID("player")
	if type(g) ~= "string" or (issecretvalue and issecretvalue(g)) or #g < 3 then
		return nil
	end
	return g:sub(-3)
end

local function AcctName(key)
	local t = Tag()
	return t and (MACRO_PREFIX .. key .. " " .. t) or nil
end

local function NumMacros()
	if not GetNumMacros then
		return 0, 0
	end
	local g, c = GetNumMacros()
	return g or 0, c or 0
end

local function CharRange()
	local first = (MAX_ACCOUNT_MACROS or 120) + 1
	local _, perChar = NumMacros()
	return first, first + math.max(perChar, MAX_CHARACTER_MACROS or 18) - 1
end

--- This character's own macro for a key: index and name, or nil.
local function OwnMacro(key)
	local plain = MACRO_PREFIX .. key
	if GetMacroInfo then
		local a, b = CharRange()
		for i = a, b do
			local ok, n = pcall(GetMacroInfo, i)
			if ok and n == plain then
				return i, plain
			end
		end
	end
	local an = AcctName(key)
	local idx = an and GetMacroIndexByName and GetMacroIndexByName(an) or 0
	if idx and idx > 0 then
		return idx, an
	end
	return nil
end
ns.ForeverOwnMacro = OwnMacro -- for the offline check

--- The name this character's macro for a key has, or will get when it is made now.
local function MacroName(key)
	local _, n = OwnMacro(key)
	if n then
		return n
	end
	local _, perChar = NumMacros()
	if perChar >= (MAX_CHARACTER_MACROS or 18) then
		return AcctName(key) or (MACRO_PREFIX .. key)
	end
	return MACRO_PREFIX .. key
end

--- Create or rewrite the macro for this key. @return macro index or nil, reason
function ns.ForeverEnsureMacro(key)
	if InCombatLockdown and InCombatLockdown() then
		return nil, "in combat"
	end
	local body = Body(ClassTable(), key)
	if not body then
		return nil, "nothing known for " .. tostring(key)
	end
	local idx, name = OwnMacro(key)
	name = name or MacroName(key)
	idx = idx or 0
	-- 🔴 24 Nov 2026 (Rob's Druid in Bear Form: "de icoontjes zijn hetzelfde als die van niet in beer vorm"): rewrite with
	-- the icon we WANT, never the one GetMacroInfo returns. For a question-mark macro that is the icon shown at that
	-- moment (MEASURED in his macros-cache.txt: every rewritten "MH" macro had a fixed file id such as 136006 = Wrath,
	-- the never-rewritten ones still INV_MISC_QUESTIONMARK), and passing it back froze the icon: #showtooltip then no
	-- longer followed the form. The question mark lets the game show the spell the key casts NOW.
	local cls0 = ClassTable()
	local def0 = cls0 and cls0.keys and cls0.keys[key]
	local wantIcon = (def0 and def0.cmd and def0.cmd.icon) or MACRO_ICON
	if idx and idx > 0 then
		local _, _, old = GetMacroInfo(idx)
		if old ~= body or ns.ForeverMacroIconFix then
			pcall(EditMacro, idx, name, wantIcon, body)
		end
		-- Found again by OUR lookup: a plain name could also match a shared account macro, which is listed first.
		return (OwnMacro(key))
	end
	-- A character macro first (this character's own spells). How many Forever allows per character is not measured; when
	-- they are full, an account macro with this character's own tag (27 Nov 2026; never a shared name, see above).
	local numGlobal, perChar = GetNumMacros()
	local maxChar = MAX_CHARACTER_MACROS or 18
	local maxGlobal = MAX_ACCOUNT_MACROS or 120
	local perCharacter = true
	if (perChar or 0) >= maxChar then
		if (numGlobal or 0) >= maxGlobal then
			return nil, ("no free macro place (character %d of %d, account %d of %d)"):format(perChar or 0, maxChar,
				numGlobal or 0, maxGlobal)
		end
		perCharacter = false
		name = AcctName(key)
		if not name then
			return nil, "your character macros are full and MH cannot read your character id for an own account macro"
		end
	else
		name = MACRO_PREFIX .. key
	end
	local cls = ClassTable()
	local def = cls and cls.keys and cls.keys[key]
	local icon = (def and def.cmd and def.cmd.icon) or MACRO_ICON
	local ok, newIdx = pcall(CreateMacro, name, icon, body, perCharacter)
	if (not ok or not newIdx) and icon ~= MACRO_ICON then
		ok, newIdx = pcall(CreateMacro, name, MACRO_ICON, body, perCharacter)
	end
	if ok and newIdx then
		return newIdx
	end
	return nil, "CreateMacro failed: " .. tostring(newIdx)
end

--- Rewrite every block macro that exists (new spell or rank learned). Never creates one: a key that gets its first
--- spell is offered by the key block's own "new for your block" question / Update.
local function RefreshExisting()
	local cls = ClassTable()
	if not cls or (InCombatLockdown and InCombatLockdown()) then
		return
	end
	-- Once per character (24 Nov 2026): rewrite every block macro with the question-mark icon, also when its text did
	-- not change, so icons frozen by the old rewrite (see ForeverEnsureMacro) follow the form again.
	local me = UnitGUID and UnitGUID("player")
	ns.db = ns.db or {}
	ns.db.foreverMacroIconFixed = ns.db.foreverMacroIconFixed or {}
	local fix = me and not ns.db.foreverMacroIconFixed[me]
	ns.ForeverMacroIconFix = fix and true or nil
	-- 27 Nov 2026: only this character's own macros (OwnMacro). And a key that knows nothing any more (Swipe moved from
	-- Shift-1 to 4 while Hurricane is not learned yet) is emptied to "#showtooltip", so an old spell does not linger on it
	-- — but only when other keys DO have a text, so a login moment where no spell is readable yet empties nothing.
	local stale, anyBody = {}, false
	for key in pairs(cls.keys) do
		local idx = OwnMacro(key)
		if idx and idx > 0 then
			local got = ns.ForeverEnsureMacro(key)
			if got then
				anyBody = true
			elseif not Body(cls, key) then
				stale[#stale + 1] = key
			end
		end
	end
	if anyBody then
		for _, key in ipairs(stale) do
			local idx, name = OwnMacro(key)
			if idx and name then
				local _, _, old = GetMacroInfo(idx)
				if old and old ~= "#showtooltip" then
					pcall(EditMacro, idx, name, MACRO_ICON, "#showtooltip")
				end
			end
		end
	end
	ns.ForeverMacroIconFix = nil
	if fix then
		ns.db.foreverMacroIconFixed[me] = true
	end
end

--- 27 Nov 2026: the form-guard switch (the overview's Keys tab): store it and rewrite the placed macros (out of combat;
--- in a fight right after it).
function ns.SetForeverFormGuard(on)
	ns.db = ns.db or {}
	if on then
		ns.db.foreverFormGuard = nil -- on = the default
	else
		ns.db.foreverFormGuard = false
	end
	if InCombatLockdown and InCombatLockdown() then
		local once = CreateFrame("Frame")
		once:RegisterEvent("PLAYER_REGEN_ENABLED")
		once:SetScript("OnEvent", function(self)
			self:UnregisterAllEvents()
			RefreshExisting()
		end)
	else
		RefreshExisting()
	end
end
--- 27 Nov 2026: the Rogue's Stealth-guard switch (Keys tab), the same way.
function ns.SetForeverStealthGuard(on)
	ns.db = ns.db or {}
	if on then
		ns.db.foreverStealthGuard = nil
	else
		ns.db.foreverStealthGuard = false
	end
	if InCombatLockdown and InCombatLockdown() then
		local once = CreateFrame("Frame")
		once:RegisterEvent("PLAYER_REGEN_ENABLED")
		once:SetScript("OnEvent", function(self)
			self:UnregisterAllEvents()
			RefreshExisting()
		end)
	else
		RefreshExisting()
	end
end
ns._ForeverBlockRefresh = function() -- for the offline check: the same function login and new spells call
	return RefreshExisting()
end

--- The player's mouseover switch (not the short "too long, rebuilt without" state). The overview's Keys tab shows it.
function ns.IsForeverMouseoverOn()
	return ns.db and ns.db.foreverMouseover == true or false
end

--- /mh mouseover [on|off]: switch the mouseover part on or off and rewrite the placed macros at once (out of combat).
function ns.ForeverMouseoverSlash(arg)
	arg = (arg or ""):lower()
	local P = "|cffffcc00Midnight Helper:|r "
	if arg == "on" or arg == "off" then
		if ns.db then
			ns.db.foreverMouseover = (arg == "on")
		end
		if InCombatLockdown and InCombatLockdown() then
			print(P .. ns:L("FBLOCK_MO_COMBAT"))
			local once = CreateFrame("Frame")
			once:RegisterEvent("PLAYER_REGEN_ENABLED")
			once:SetScript("OnEvent", function(self)
				self:UnregisterAllEvents()
				RefreshExisting()
			end)
		else
			RefreshExisting()
		end
		print(P .. ns:L(MouseoverOn() and "FBLOCK_MO_ON" or "FBLOCK_MO_OFF"))
		return
	end
	print(P .. ("key block mouseover: %s (/mh mouseover on||off)"):format(MouseoverOn() and "on" or "off"))
	local cls = ClassTable()
	if not cls then
		print("  no key-block table for this class")
		return
	end
	local n = 0
	for key in pairs(cls.keys) do
		local body = Body(cls, key)
		if body and body:find("@mouseover", 1, true) then
			n = n + 1
			print(("  %s: %s"):format(key, (body:gsub("\n", " | "))))
		end
	end
	if n == 0 then
		print("  no key uses mouseover now" .. (MouseoverOn() and " (none of your spells is on the list yet)" or ""))
	end
end

--- The key block's Build() result for this character, or nil (no approved Forever table for this class). Same shape as
--- KeyBlock.lua Build: occ[key] = { spell = { id, name, macroName, macroKey, spellIds }, why }.
function ns.ForeverKeyBlockBuild()
	local cls, token = ClassTable()
	if not cls then
		return nil
	end
	local occ, trace = {}, {}
	for key in pairs(cls.keys) do
		local body, ids, show = Body(cls, key)
		if body then
			local okN, nm = pcall(C_Spell.GetSpellName, show)
			local def = cls.keys[key]
			if def.cmd and def.cmd.label then
				okN, nm = true, def.cmd.label
			end
			occ[key] = {
				-- label/iconTex (24 Nov 2026, Rob's Warlock): a pet command shows "Pet: Attack" with its own icon on the
				-- picture, not the summon spell it needs (that made Summon Imp appear on Ctrl-1, Ctrl-2 and Ctrl-3).
				spell = { id = show, name = okN and nm or nil, macroName = MacroName(key), macroKey = key, spellIds = ids,
					label = def.cmd and def.cmd.label or nil,
					iconTex = def.cmd and def.cmd.icon and ("Interface\\Icons\\" .. def.cmd.icon) or nil },
				-- 12 x 4 (24 Nov 2026): the research's own reason per key, shown by /mh block why.
				why = (cls.twelve and type(def.why) == "string") and ("12x4: " .. def.why) or "Forever macro",
			}
			trace[#trace + 1] = { key = key, id = show, why = "Forever macro: " .. body:gsub("\n", " ") }
		end
	end
	-- /mh block why: what the talent gate decided this build (24 Nov 2026), so a skipped Mortal Strike is visible.
	for name, said in pairs(lastGate) do
		trace[#trace + 1] = { key = "talent", why = ("%s: talent %s"):format(name, tostring(said)) }
	end
	local unplaced = {}
	for _, name in ipairs(cls.toBlockD or {}) do
		local id = Known(name)
		if id then
			unplaced[#unplaced + 1] = { id = id, name = ClientName(id, name) }
		end
	end
	local specID
	if ns.GetSpecialization and ns.GetSpecializationInfo then
		local okS, id = pcall(ns.GetSpecializationInfo, ns.GetSpecialization())
		specID = okS and id or nil
	end
	return { occ = occ, unplaced = unplaced, trace = trace, specID = specID, class = token, unknown = 0, forever = true,
		layout = cls.twelve and "12x4" or "old" }
end

--- Active spells in this character's spellbook that the class table does not name. The key block window's red "not in
--- MH's list yet" line uses this on Forever instead of KeybindUnclassified, which only knows the Midnight lists (on
--- 5 Nov 2026 it named Healing Touch, Moonfire, Rejuvenation and Thorns while all four sat in their macros).
function ns.ForeverBlockUnlisted()
	local cls = ClassTable()
	if not cls then
		return nil
	end
	local listed = { ["Attack"] = true }
	local function add(v)
		if type(v) == "table" then
			for _, n in ipairs(v) do
				listed[n] = true
			end
		elseif type(v) == "string" then
			listed[v] = true
		end
	end
	for _, def in pairs(cls.keys) do
		for field, v in pairs(def) do
			if field == "pair" then
				add(v.first)
				add(v.second)
			elseif field == "cmd" then
				add(v.needs)
			elseif field ~= "open" and field ~= "bang" and field ~= "why" then -- why = the 12x4 reason text, no spell
				add(v)
			end
		end
	end
	add(cls.toBlockD)
	add(cls.listed)
	-- 7 Nov 2026: the spellbook gives names in the CLIENT's language; the table's are English. Compare by id too, or a
	-- German player would see every spell as "not in MH's list".
	local listedIds = {}
	for n in pairs(listed) do
		for _, id in ipairs(IdsFor(n) or {}) do
			listedIds[id] = true
		end
	end
	local out, seen = {}, {}
	local SB = C_SpellBook
	if not (SB and SB.GetNumSpellBookSkillLines and SB.GetSpellBookSkillLineInfo and SB.GetSpellBookItemInfo) then
		return out
	end
	local bank = Enum and Enum.SpellBookSpellBank and Enum.SpellBookSpellBank.Player
	-- 19 Nov 2026 (Rob via sparring: "Ja, die mogen door"; the idea from looking at another addon, not its code): a spellbook
	-- item of type FutureSpell is a spell you do NOT know yet (shown greyed for a later level). It must not count as a
	-- known spell here. Whether Forever's spellbook shows future spells is not measured; without the enum this is a no-op.
	local FUTURE = Enum and Enum.SpellBookItemType and Enum.SpellBookItemType.FutureSpell
	local FLYOUT = Enum and Enum.SpellBookItemType and Enum.SpellBookItemType.Flyout
	local okN, n = pcall(SB.GetNumSpellBookSkillLines)
	for i = 1, (okN and tonumber(n) or 0) do
		local okL, line = pcall(SB.GetSpellBookSkillLineInfo, i)
		if okL and type(line) == "table" and not line.shouldHide then
			local first = (tonumber(line.itemIndexOffset) or 0) + 1
			for slot = first, first + (tonumber(line.numSpellBookItems) or 0) - 1 do
				local okI, it = pcall(SB.GetSpellBookItemInfo, slot, bank)
				if okI and type(it) == "table" and FUTURE and it.itemType == FUTURE then
					it = nil -- a spell for later: not yours yet
				end
				-- 24 Nov 2026 (Rob's Warlock: "Not in MH's list: Summon Demon"): a flyout is a folder of spells, not a spell;
				-- the spells in it are what the block places (the summons go to block D). AFGELEID that "Summon Demon" is a
				-- flyout in Forever; its English name is in the Warlock's `listed` as well, in case it is not.
				if okI and type(it) == "table" and FLYOUT and it.itemType == FLYOUT then
					it = nil
				end
				local name = okI and type(it) == "table" and it.name
				local sid = it and it.spellID
				local byId = type(sid) == "number" and not (issecretvalue and issecretvalue(sid)) and listedIds[sid]
				if name and not (issecretvalue and issecretvalue(name)) and not it.isPassive
					and not listed[name] and not byId and not seen[name] then
					seen[name] = true
					out[#out + 1] = name
				end
			end
		end
	end
	table.sort(out)
	return out
end
-- The name the first version used (KeyBlock.lua and the offline test call it).
ns.ForeverDruidUnlisted = ns.ForeverBlockUnlisted

-- New spell or rank → rewrite the macros, out of combat, once things settle.
local pending = false
local ev = CreateFrame("Frame")
ev:RegisterEvent("LEARNED_SPELL_IN_SKILL_LINE")
ev:RegisterEvent("PLAYER_REGEN_ENABLED")
ev:RegisterEvent("PLAYER_ENTERING_WORLD")
-- 24 Nov 2026: a talent point (Mortal Strike) changes what key 3 casts. pcall, as in ForeverMacros.lua: an event the
-- client does not know would throw.
pcall(ev.RegisterEvent, ev, "TRAIT_CONFIG_UPDATED")
-- 24 Nov 2026 (Rob's Druid got Bear Form from its class quest: "ik heb net mijn beer vorm gehaald maar krijg deze spells
-- niet op mijn keys"): also on SPELLS_CHANGED, the event the key block's own "new for your block" question uses. Whether
-- LEARNED_SPELL_IN_SKILL_LINE fires for a spell a QUEST teaches is not measured; SPELLS_CHANGED fires for every change.
-- It comes in bursts, so one rewrite a second after the burst (EditMacro only runs when a body really changed).
ev:RegisterEvent("SPELLS_CHANGED")
local queued = false
ev:SetScript("OnEvent", function(_, event)
	if event == "PLAYER_REGEN_ENABLED" and not pending then
		return
	end
	if InCombatLockdown and InCombatLockdown() then
		pending = true
		return
	end
	pending = false
	if queued then
		return
	end
	if C_Timer and C_Timer.After then
		queued = true
		C_Timer.After(1, function()
			queued = false
			if InCombatLockdown and InCombatLockdown() then
				pending = true -- a fight began in that second: PLAYER_REGEN_ENABLED does it after
				return
			end
			RefreshExisting()
		end)
	else
		RefreshExisting()
	end
end)
