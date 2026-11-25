local _, ns = ...

--[[
	ForeverMainStats.lua — per class, the primary stats that matter most while LEVELING solo in WoW Forever, for the
	quest reward hint (ForeverQuestHint.lua).

	Source: mh-research, 7 Nov 2026 — docs/forever/FOREVER_MAIN_STATS_2026-11-07.md (every row with its sources).
	  - GEMETEN: the Forever client has no primary stat to ask (wago ChrSpecialization 1.60.1.70862: PrimaryStatPriority 0
	    on every class row), so MH needs this table.
	  - GEMETEN in client strings: Agility gives attack power to Hunter and Rogue, to Druid only in Cat Form, to Warrior only
	    ranged; Shaman and Paladin get none from Agility.
	  - The default is the solo leveling role the guides agree on (Retribution, Enhancement, Feral, Shadow).
	  - Disputed: Ret Paladin (guides split Strength vs Intellect). Chosen: Strength first, flipping to Intellect once the
	    talent that converts Intellect is known (`later`); the levels are AFGELEID, the talent check is what the hint uses.
	    Enhancement Shaman had the same flip until 11 Nov 2026; Blizzard settled it on Strength (see the SHAMAN row).
	main    = in order; the hint weighs the first 1 and the second 0.5 (MH's own choice, AFGELEID).
	stamTie = Stamina breaks a tie (when it is not already a main stat).
]]

if not ns.IS_FOREVER then
	return
end

ns.FOREVER_MAIN_STATS = {
	WARRIOR = { main = { "STRENGTH", "AGILITY" }, stamTie = true },
	PALADIN = { main = { "STRENGTH", "INTELLECT" }, stamTie = true,
		later = { talent = "Champion of the Light", main = { "INTELLECT", "STRENGTH" } } },
	HUNTER = { main = { "AGILITY", "SPIRIT" }, stamTie = false,
		later = { talent = "Careful Aim", main = { "AGILITY", "INTELLECT" } } },
	ROGUE = { main = { "AGILITY", "STRENGTH" }, stamTie = true },
	PRIEST = { main = { "INTELLECT", "SPIRIT" }, stamTie = true },
	-- Enhancement: Strength first, ALWAYS (Rob, 11 Nov 2026: "Ja, repareer"). The flip to Intellect at Mental Dexterity
	-- is gone: Blizzard's blue post of 6 Nov ("Strength is always their strongest stat ... collect Strength and Attack
	-- Power gear from now on") and the 10 Nov hotfix (Mental Dexterity back to 33/66/100% of Int) undid the reason for
	-- it. Found by the content watch's Forever catch-up, 11 Nov (read via search on several mirrors, not in the client).
	SHAMAN = { main = { "STRENGTH", "INTELLECT" }, stamTie = false },
	MAGE = { main = { "INTELLECT", "SPIRIT" }, stamTie = true },
	WARLOCK = { main = { "INTELLECT", "STAMINA" }, stamTie = true },
	DRUID = { main = { "AGILITY", "STRENGTH" }, stamTie = true, lead = "dps" },
}
-- `lead` (25 Nov 2026, Rob via Sparring: "begin maar met de Druid" → "Ja"): what comes BEFORE the stats in the "Do this
-- now" sentence, for text only (the tooltip math reads `main`). dps = weapon damage per second (in a form your attacks
-- do your weapon's DPS: Blizzard, Forever Class Deep Dive Druid 30 Sep 2026); spell / heal = the spell damage and
-- healing line on items. `armor` = name Armor between the two stats (Bear Form: +180% armor from items, GEMETEN).
-- See ForeverWeapons.lua "Which weapon?" for the sources.

--[[ 16 Nov 2026 — stats per ROLE (Rob via sparring: "b , maar hou ook dps en heling in je achterhoofd" → on the four
	choices "alle 4 ja"). Research: docs/forever/STATS_PER_ROL_2026-11-16.md (mh-research, sources per row).
	1. The role comes from the player's own "direction" (ForeverDirection.lua, tree 1-3). No direction = the table above.
	   Tree order per class = the classic talent-tree order (AFGELEID; /mh donow check prints the tree NAME, so it shows).
	2. A tank line for Warrior, Paladin and Druid only (the only classes with the tank bit in ChrClasses.RolesMask,
	   GEMETEN), always as a second line in "Do this now".
	3. Guides disagree: Blizzard wins where it spoke (Enhancement = Strength), else Icy Veins; when guides disagree and
	   Blizzard did not speak, the two count the SAME (`equal`: both weigh 1 in the tooltip math).
	4. The green tooltip line and the quest-reward hint (ForeverQuestHint.lua) read ns.ForeverStatDef too, so the three
	   never contradict each other. This also ends Strength advice for Elemental/Resto Shaman and Holy/Prot Paladin,
	   Agility advice for Balance/Resto Druid, and gives Affliction Warlocks Spirit.
]]
local BY_TREE = {
	PALADIN = {
		[1] = { role = "heal", main = { "INTELLECT", "SPIRIT" }, stamTie = true },
		-- Prot: see TANK.PALADIN below (21 Nov 2026: Stamina, then Intellect).
		[2] = { role = "tank", main = { "STAMINA", "INTELLECT" }, stamTie = false },
		-- Ret: Icy Veins Int > Str, SixtySim Str first, Blizzard silent → equal.
		[3] = { role = "melee", main = { "STRENGTH", "INTELLECT" }, stamTie = true, equal = true },
	},
	PRIEST = {
		-- Healing: Icy Veins Spi > Int, others Int > Spi → equal.
		[1] = { role = "heal", main = { "INTELLECT", "SPIRIT" }, stamTie = true, equal = true },
		[2] = { role = "heal", main = { "INTELLECT", "SPIRIT" }, stamTie = true, equal = true },
		[3] = { role = "caster", main = { "INTELLECT", "SPIRIT" }, stamTie = true },
	},
	SHAMAN = {
		[1] = { role = "caster", main = { "INTELLECT", "SPIRIT" }, stamTie = true },
		[2] = { role = "melee", main = { "STRENGTH", "INTELLECT" }, stamTie = false }, -- Blizzard: Strength
		[3] = { role = "heal", main = { "INTELLECT", "SPIRIT" }, stamTie = true, equal = true },
	},
	MAGE = {
		-- Icy Veins Frost Spi > Int, Mobalytics Int > Spi → equal, every tree.
		[1] = { role = "caster", main = { "INTELLECT", "SPIRIT" }, stamTie = true, equal = true },
		[2] = { role = "caster", main = { "INTELLECT", "SPIRIT" }, stamTie = true, equal = true },
		[3] = { role = "caster", main = { "INTELLECT", "SPIRIT" }, stamTie = true, equal = true },
	},
	WARLOCK = {
		[1] = { role = "caster", main = { "SPIRIT", "INTELLECT" }, stamTie = true }, -- Affliction: Life Tap uses Spirit
		[2] = { role = "caster", main = { "INTELLECT", "STAMINA" }, stamTie = false, equal = true },
		[3] = { role = "caster", main = { "INTELLECT", "STAMINA" }, stamTie = false, equal = true },
	},
	DRUID = {
		[1] = { role = "caster", main = { "INTELLECT", "SPIRIT" }, stamTie = true, lead = "spell" },
		-- Cat: Icy Veins Agi, Mobalytics/ForeverDB Str ≥ Agi → equal.
		[2] = { role = "melee", main = { "AGILITY", "STRENGTH" }, stamTie = true, equal = true, lead = "dps" },
		[3] = { role = "heal", main = { "INTELLECT", "SPIRIT" }, stamTie = true, lead = "heal" },
	},
}

-- Second line in "Do this now": when you tank.
local TANK = {
	WARRIOR = { main = { "STAMINA", "STRENGTH" }, equal = true }, -- guides disagree (Icy Veins leveling: Str first)
	-- 21 Nov 2026 (Rob via sparring: "welke talentpunten" / tanking a Paladin; GO "Ja, voeg dat maar toe"): was Stamina,
	-- then Strength (16 Nov research, no guide named for that row). Read today: wowforeverbuilder.com Protection page
	-- (talent snapshot 3 Nov, client 1.60.1.70753) "Defense to 440, Stamina, Spell power, Intellect, Block value, Armor",
	-- no Strength, and "Spell power raises Consecration and Holy Shield threat; it is a tank stat for you". Mobalytics Prot
	-- (8 Nov, per sparring's mh-research report; 403 for our fetch): from 20 Spell Power, Stamina, Intellect, Strength.
	-- Icy Veins: 403, not read. So: Stamina, then Intellect (MH has no Spell Power / Defense stat in this table).
	PALADIN = { main = { "STAMINA", "INTELLECT" } },
	-- Bear (25 Nov 2026): weapon damage per second first, then Stamina, Armor, Agility (text: lead + armor).
	DRUID = { main = { "STAMINA", "AGILITY" }, lead = "dps", armor = true },
}

--- The stat def for this class and this character's direction: def, role, source ("direction N" or "class default").
function ns.ForeverStatDef(token)
	local base = ns.FOREVER_MAIN_STATS[token]
	local band = ns.GetForeverDirection and ns.GetForeverDirection()
	local row = band and BY_TREE[token] and BY_TREE[token][band]
	if row then
		return row, row.role, "direction " .. tostring(band)
	end
	local role = (token == "HUNTER" and "ranged") or ((token == "MAGE" or token == "WARLOCK" or token == "PRIEST") and "caster")
		or "melee"
	return base, role, band and ("direction " .. band .. " (same as the class default)") or "class default (no direction chosen)"
end

--- The tank def for Warrior/Paladin/Druid, else nil.
function ns.ForeverTankStatDef(token)
	return TANK[token]
end
