local _, ns = ...

--[[
	"How you fight alone" for the seven healer specs (Rob, 6 Oct 2026, Resto Druid in the open world: "ze verwachten
	ook dat je af en toe meevecht ... hoe weet ik welke knop ik moet gebruiken?").

	Used twice, from this one table, so the two can never disagree:
	  - the play card gets a short "How you fight alone" list with YOUR keys behind each spell (PlayCardWindow.lua);
	  - the key block picture (/mh block) gives those spells a red border (KeyBlock.lua).

	Source: docs/HEALER_SOLO_DAMAGE_2026-10-06.md (mh-research). The order is Blizzard's own Single-Button Assistant per
	healer spec (wago DB2 AssistedCombatStep, 12.1.0.69933, GEMETEN); Icy Veins agrees for Disc, Holy Priest, Resto Shaman
	and Preservation. Spell ids from wago SpellName, same build.

	A step lists one or more spell ids: the first one this character KNOWS is shown (talents differ: Resto's Starsurge
	is 197626, Balance's 78674). A step nobody knows is left out, so the list never names a spell you do not have.
	note = what the step is for; one of the CARD_SOLO_NOTE_* keys.
]]

ns.HEALER_SOLO = {
	[105] = { -- Restoration Druid
		{ ids = { 93402 }, note = "DOT" }, -- Sunfire
		{ ids = { 8921 }, note = "DOT" }, -- Moonfire
		{ ids = { 197626, 78674 }, note = "CD" }, -- Starsurge (Resto, Balance id as fallback)
		{ ids = { 5176 }, note = "FILL" }, -- Wrath
		{ ids = { 197628, 194153 }, note = "AOE" }, -- Starfire (talent)
	},
	[65] = { -- Holy Paladin
		{ ids = { 275773, 20271 }, note = "CD" }, -- Judgment (Holy's id first)
		{ ids = { 20473 }, note = "CD" }, -- Holy Shock
		{ ids = { 415091, 53600 }, note = "SPEND" }, -- Shield of the Righteous (Holy's id first; 53600 per KeybindRoles_Paladin.lua)
	},
	[256] = { -- Discipline Priest
		{ ids = { 589 }, note = "DOT" }, -- Shadow Word: Pain
		{ ids = { 8092 }, note = "CD" }, -- Mind Blast
		{ ids = { 47540 }, note = "CD" }, -- Penance
		{ ids = { 585 }, note = "FILL" }, -- Smite
		{ ids = { 32379 }, note = "EXECUTE" }, -- Shadow Word: Death (talent)
	},
	[257] = { -- Holy Priest
		{ ids = { 88625 }, note = "CD" }, -- Holy Word: Chastise (talent)
		{ ids = { 14914 }, note = "CD" }, -- Holy Fire (talent)
		{ ids = { 589 }, note = "DOT" }, -- Shadow Word: Pain
		{ ids = { 585 }, note = "FILL" }, -- Smite
		{ ids = { 132157 }, note = "AOE" }, -- Holy Nova
	},
	[264] = { -- Restoration Shaman
		{ ids = { 470411 }, note = "DOT" }, -- Flame Shock (Resto's own id; 188389 is not learnable for Resto, KeybindRoles_Shaman.lua)
		{ ids = { 51505 }, note = "CD" }, -- Lava Burst
		{ ids = { 188196 }, note = "FILL" }, -- Lightning Bolt
		{ ids = { 188443 }, note = "AOE" }, -- Chain Lightning (talent)
	},
	[270] = { -- Mistweaver Monk
		{ ids = { 467307, 107428 }, note = "CD" }, -- Rushing Wind Kick / Rising Sun Kick
		{ ids = { 100780 }, note = "X3" }, -- Tiger Palm
		{ ids = { 100784 }, note = "AFTER" }, -- Blackout Kick
		{ ids = { 101546 }, note = "AOE" }, -- Spinning Crane Kick
		{ ids = { 117952 }, note = "RANGED" }, -- Crackling Jade Lightning
	},
	[1468] = { -- Preservation Evoker
		{ ids = { 357208 }, note = "CD" }, -- Fire Breath
		{ ids = { 356995 }, note = "CD" }, -- Disintegrate
		{ ids = { 361469 }, note = "FILL" }, -- Living Flame
	},
}

local NOTE_KEY = {
	DOT = "CARD_SOLO_NOTE_DOT", CD = "CARD_SOLO_NOTE_CD", FILL = "CARD_SOLO_NOTE_FILL", AOE = "CARD_SOLO_NOTE_AOE",
	EXECUTE = "CARD_SOLO_NOTE_EXECUTE", RANGED = "CARD_SOLO_NOTE_RANGED", X3 = "CARD_SOLO_NOTE_X3",
	AFTER = "CARD_SOLO_NOTE_AFTER", SPEND = "CARD_SOLO_NOTE_SPEND",
}

local function Knows(id)
	if C_SpellBook and C_SpellBook.IsSpellKnown then
		local ok, k = pcall(C_SpellBook.IsSpellKnown, id)
		if ok and k then
			return true
		end
	end
	if IsPlayerSpell then
		local ok, k = pcall(IsPlayerSpell, id)
		if ok and k then
			return true
		end
	end
	return false
end

local function ActiveSpecID()
	if not (ns.GetSpecialization and ns.GetSpecializationInfo) then
		return nil
	end
	local idx = ns.GetSpecialization()
	return idx and (ns.GetSpecializationInfo(idx)) or nil
end

--- The steps for a spec as { id, note } with the id this character has. `live` = the player's own active spec:
--- then unknown steps are dropped; for another spec the first id is shown (you are only reading about it).
function ns.HealerSoloSteps(specID, live)
	local def = specID and ns.HEALER_SOLO[specID]
	if not def then
		return nil
	end
	local out = {}
	for _, step in ipairs(def) do
		local pick
		for _, id in ipairs(step.ids) do
			if not live or Knows(id) then
				pick = id
				break
			end
		end
		if pick then
			out[#out + 1] = { id = pick, note = NOTE_KEY[step.note] }
		end
	end
	return out
end

--- Is this spell one of the "fight alone" spells of the player's active healer spec? (red border on the key block)
function ns.IsHealerSoloSpell(spellID)
	local def = ns.HEALER_SOLO[ActiveSpecID() or 0]
	if not (def and spellID) then
		return false
	end
	for _, step in ipairs(def) do
		for _, id in ipairs(step.ids) do
			if id == spellID then
				return true
			end
		end
	end
	return false
end

function ns.IsHealerSoloSpec()
	return ns.HEALER_SOLO[ActiveSpecID() or 0] ~= nil
end
