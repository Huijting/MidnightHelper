local _, ns = ...

--[[
	Midnight Helper — do these two spells replace each other? (`/mh twins`)

	The linter reports seven specs where two spells ask for the same key. Some of those
	are harmless: Death Sweep IS Blade Dance under Metamorphosis, so a player never has
	both and the shared key is fine. Others are real — Shaman's Chain Lightning and
	Crash Lightning are two buttons you press in the same fight.

	Nothing on this machine records which is which. JustAC has archetypes but no
	replacement relationships, and our own data only hints at it in a comment
	("AoE-alternatief (talent)"). Marking them by hand would be guessing about thirteen
	spells across six classes, and the never-lie rule says do not.

	So ask the client. `C_SpellBook.FindSpellOverrideByID` is the same call the layout
	uses to show Ice Cold where our table says Ice Block; it answers for a spell id
	whether something supersedes it. Names resolve globally, so a mage can ask about a
	death knight's spells.

	⚠️ A NULL ANSWER IS NOT A NO. An override can depend on a talent the asking
	character does not have, so "no override" from the wrong class may mean "not for
	me". The result is written down with the class it was asked on, and a pair only
	gets marked as replacing when the game says so — never when it merely stays silent.
]]

--- The pairs the linter flags, by name. Kept here rather than derived, because the
--- linter is a Python script and this is the thing that has to ask the game.
local PAIRS = {
	{ class = "DEATHKNIGHT", spec = 251, a = "Frostscythe",     b = "Howling Blast" },
	{ class = "DEMONHUNTER", spec = 577, a = "Death Sweep",     b = "Blade Dance" },
	{ class = "HUNTER",      spec = 255, a = "Butchery",        b = "Carve" },
	{ class = "PRIEST",      spec = 258, a = "Void Volley",     b = "Void Bolt" },
	{ class = "SHAMAN",      spec = 263, a = "Crash Lightning", b = "Chain Lightning" },
	{ class = "WARRIOR",     spec = 71,  a = "Ravager",         b = "Bladestorm" },
	{ class = "WARRIOR",     spec = 71,  a = "Demolish",        b = "Bladestorm" },
	{ class = "WARRIOR",     spec = 73,  a = "Demolish",        b = "Ravager" },
}

local function IdFor(name)
	if not (C_Spell and C_Spell.GetSpellInfo) then
		return nil
	end
	local ok, info = pcall(C_Spell.GetSpellInfo, name)
	if ok and type(info) == "table" and info.spellID then
		return info.spellID
	end
	return nil
end

local function OverrideOf(id)
	if not (id and C_SpellBook and C_SpellBook.FindSpellOverrideByID) then
		return nil
	end
	local ok, o = pcall(C_SpellBook.FindSpellOverrideByID, id)
	if ok and type(o) == "number" and o ~= 0 and o ~= id then
		return o
	end
	return nil
end

--- `/mh twins` — ask the game about every flagged pair and write down the answers.
function ns.MH_TwinProbe()
	ns.db = ns.db or {}
	local _, askedOn = UnitClass("player")
	local out = { askedOnClass = askedOn, rows = {} }

	for i = 1, #PAIRS do
		local p = PAIRS[i]
		local idA, idB = IdFor(p.a), IdFor(p.b)
		local row = {
			class = p.class, spec = p.spec,
			a = p.a, b = p.b, idA = idA, idB = idB,
		}
		if idA and idB then
			local oA, oB = OverrideOf(idA), OverrideOf(idB)
			row.overrideOfA = oA
			row.overrideOfB = oB
			-- The clear cases: one resolves to the other.
			if oB == idA then
				row.verdict = p.a .. " replaces " .. p.b
			elseif oA == idB then
				row.verdict = p.b .. " replaces " .. p.a
			else
				row.verdict = "no replacement reported"
			end
		else
			row.verdict = "could not resolve both names"
		end
		out.rows[#out.rows + 1] = row
	end

	ns.db.twinProbe = out
	local p = ("|cffffcc00%s|r"):format((ns.L and ns:L("PRINT_PREFIX")) or "Midnight Helper:")
	print(("%s asked the game about %d pair(s) — written to SavedVariables."):format(p, #out.rows))
	print("   |cff9d9d9dA silent answer is not a no: an override can depend on a talent this|r")
	print("   |cff9d9d9dcharacter does not have. |cffffffff/reload|r and the file can be read.|r")
end
