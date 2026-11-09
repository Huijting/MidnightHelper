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

local function ClassTable()
	local _, token = UnitClass("player")
	return token and ns.FOREVER_BLOCK_CLASSES[token], token
end

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
	for _, fn in ipairs({ IsPlayerSpell, IsSpellKnown }) do
		if fn then
			local ok, v = pcall(fn, id)
			if ok and v == true then
				return true
			end
		end
	end
	return false
end

--- The spell id this character has under this English name (highest rank), or nil when it does not have it.
local function Known(name)
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
ns.ForeverKnownSpell = Known

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
		for _, name in ipairs(v) do
			local id = Known(name)
			if id then
				return ClientName(id, name), id, name
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
	-- Shaman
	"Healing Wave", "Lesser Healing Wave", "Chain Heal",
	-- Mage
	"Arcane Intellect", "Remove Lesser Curse",
}) do
	MO_HELP[n] = true
end
local MO_HARM = {}
for _, n in ipairs({
	"Entangling Roots", "Hibernate", "Faerie Fire", "Polymorph", "Counterspell", "Fear", "Banish",
	"Shackle Undead", "Hunter's Mark", "Earth Shock", "Purge",
}) do
	MO_HARM[n] = true
end

local moSuppressed = false -- set while a key that grew past the 255-character limit is rebuilt without mouseover
local function MouseoverOn()
	return not moSuppressed and ns.db and ns.db.foreverMouseover == true
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
		local a, aId = First(def.pair.first)
		local b, bId = First(def.pair.second)
		local parts = {}
		if a then
			parts[#parts + 1] = (b and (def.pair.cond .. " ") or "") .. use(a, aId)
		end
		if b then
			parts[#parts + 1] = use(b, bId)
		end
		if #parts == 0 then
			return nil
		end
		return "#showtooltip\n/cast " .. table.concat(parts, "; "), ids, show
	end
	local allName, allId, allEn = First(def.all)
	if allName then
		return "#showtooltip\n/cast " .. WithMouseover("", allEn) .. use(allName, allId), ids, show
	end
	local clauses, guarded = {}, false
	for _, st in ipairs(cls.states or {}) do
		local name, id, en = First(def[st.name])
		if name then
			clauses[#clauses + 1] = WithMouseover(st.cond .. " ", en) .. use(name, id)
			if st.guards then
				guarded = true
			end
		end
	end
	local base, baseId, baseEn = First(def.base)
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

local function MacroName(key)
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
	local name = MacroName(key)
	local idx = GetMacroIndexByName and GetMacroIndexByName(name) or 0
	if idx and idx > 0 then
		local _, icon, old = GetMacroInfo(idx)
		if old ~= body then
			pcall(EditMacro, idx, name, icon, body)
		end
		return GetMacroIndexByName(name)
	end
	-- A character macro first (this character's own spells). How many Forever allows per character is not measured; when
	-- they are full, the account's shared list is used. A shared "MH 1" is rewritten by whichever character logs in, with
	-- that character's own spells (RefreshExisting on PLAYER_ENTERING_WORLD), so it stays right for the one playing.
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
	for key in pairs(cls.keys) do
		local idx = GetMacroIndexByName and GetMacroIndexByName(MacroName(key))
		if idx and idx > 0 then
			ns.ForeverEnsureMacro(key)
		end
	end
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
				spell = { id = show, name = okN and nm or nil, macroName = MacroName(key), macroKey = key, spellIds = ids },
				why = "Forever macro",
			}
			trace[#trace + 1] = { key = key, id = show, why = "Forever macro: " .. body:gsub("\n", " ") }
		end
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
	return { occ = occ, unplaced = unplaced, trace = trace, specID = specID, class = token, unknown = 0, forever = true }
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
			elseif field ~= "open" and field ~= "bang" then
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
	local okN, n = pcall(SB.GetNumSpellBookSkillLines)
	for i = 1, (okN and tonumber(n) or 0) do
		local okL, line = pcall(SB.GetSpellBookSkillLineInfo, i)
		if okL and type(line) == "table" and not line.shouldHide then
			local first = (tonumber(line.itemIndexOffset) or 0) + 1
			for slot = first, first + (tonumber(line.numSpellBookItems) or 0) - 1 do
				local okI, it = pcall(SB.GetSpellBookItemInfo, slot, bank)
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
ev:SetScript("OnEvent", function(_, event)
	if event == "PLAYER_REGEN_ENABLED" and not pending then
		return
	end
	if InCombatLockdown and InCombatLockdown() then
		pending = true
		return
	end
	pending = false
	if C_Timer and C_Timer.After then
		C_Timer.After(1, RefreshExisting)
	else
		RefreshExisting()
	end
end)
