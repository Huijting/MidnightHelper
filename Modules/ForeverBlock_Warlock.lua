local _, ns = ...

--[[
	ForeverBlock_Warlock.lua — the key-block table for the Warlock in WoW Forever (ForeverBlock.lua is the engine).

	Rob, 6 Nov 2026: "Ja, 1 tot en met 5" (after "vertrouw ik op jouw expertise mbt de classes"), so this is the proposal
	from docs/forever/FOREVER_WARLOCK_2026-11-06.md as written. The open questions there were settled with the
	proposal's own pick: E stays empty (the only interrupt is the Felhunter's pet spell, untested in a macro),
	Ctrl-1/2/3 = Conflagrate / Wrack-or-Incinerate / Bane of Havoc with the demon summons on block D, Drain Soul on 4.
	Changed the same day: Ctrl-1/2/3 are now the pet commands, those three spells are on block D (see below).
	No forms, stances or stealth (DB2 70790): no bar paging, so no states and no base guard.
]]

if not ns.IS_FOREVER then
	return
end

ns.FOREVER_BLOCK_CLASSES = ns.FOREVER_BLOCK_CLASSES or {}

-- Any demon summon means the Ctrl pet keys get their macros.
local PET = { "Summon Imp", "Summon Voidwalker", "Summon Succubus", "Summon Incubus", "Summon Felhunter" }

ns.FOREVER_BLOCK_CLASSES.WARLOCK = {
	states = {},
	keys = {
		["1"] = { base = "Shadow Bolt" },
		["2"] = { base = "Corruption" },
		["3"] = { base = "Immolate" },
		["4"] = { base = "Drain Soul" },
		["SHIFT-4"] = { base = "Shadowburn" },
		["5"] = { base = "Bane of Agony" },
		["SHIFT-1"] = { base = "Rain of Fire" },
		["SHIFT-2"] = { base = "Hellfire" },
		["Q"] = { base = "Soul Fire" },
		["F1"] = { base = "Bane of Doom" },
		["SHIFT-3"] = { base = "Amplify Curse" },
		["F3"] = { base = "Inferno" },
		["SHIFT-F1"] = { base = "Fel Domination" },
		-- E stays empty on purpose: no interrupt of its own (Spell Lock belongs to the Felhunter).
		["R"] = { base = "Curse of Exhaustion" },
		["SHIFT-R"] = { base = "Unending Breath" },
		["F"] = { base = "Life Tap" },
		["Z"] = { base = "Shadow Ward" },
		["X"] = { base = "Death Coil" },
		["C"] = { base = "Drain Life" },
		["F2"] = { base = "Health Funnel" },
		["F4"] = { base = "Siphon Life" },
		["V"] = { base = "Fear" },
		["SHIFT-Q"] = { base = "Banish" },
		["SHIFT-F"] = { base = "Howl of Terror" },
		["SHIFT-V"] = { base = { "Curse of the Elements", "Curse of Weakness" } },
		["SHIFT-Z"] = { base = { "Demon Armor", "Demon Skin" } },
		["SHIFT-X"] = { base = "Soul Link" },
		["SHIFT-C"] = { base = "Demonic Sacrifice" },
		["SHIFT-E"] = { base = { "Will to Survive", "Blood Fury", "Will of the Forsaken", "Escape Artist", "Berserking" } },
		-- Rob, 6 Nov 2026 ("Doe maar", same as the Hunter): Ctrl-1/2/3 stay the demon's keys (attack, follow, stay, the
		-- order of Blizzard's pet bar). Conflagrate, Wrack/Incinerate and Bane of Havoc moved to block D.
		["CTRL-1"] = { cmd = { text = "/petattack", needs = PET, label = "Pet: Attack", icon = "Ability_GhoulFrenzy" } },
		["CTRL-2"] = { cmd = { text = "/petfollow", needs = PET, label = "Pet: Follow", icon = "Ability_Tracking" } },
		["CTRL-3"] = { cmd = { text = "/petstay", needs = PET, label = "Pet: Stay", icon = "Spell_Nature_TimeStop" } },
	},
	-- Block D has 12 places. With the three talent spells above it, a Destruction Warlock reached 14-15 (6 Nov 2026), so
	-- Rob chose ("ja") to move the rarely used Create Soulstone, Curse of Tongues and Ritual of Summoning to `listed`.
	toBlockD = { "Conflagrate", "Wrack", "Incinerate", "Bane of Havoc", "Summon Imp", "Summon Voidwalker", "Summon Succubus",
		"Summon Incubus", "Summon Felhunter", "Create Healthstone", "Searing Pain", "Curse of Recklessness",
		"Perception", "Shatter Curse", "Cannibalize", "Eureka!", "Rapid Regeneration" },
	listed = { "Shoot", "Create Soulstone", "Curse of Tongues", "Ritual of Summoning", "Create Spellstone",
		"Create Firestone", "Drain Mana", "Subjugate Demon", "Eye of Kilrogg", "Sense Demons", "Detect Invisibility",
		"Ritual of Doom", "Portal of Summoning" },
	-- 12 x 4 (Forever, 24 Nov 2026; /mh block style 12x4). From docs/forever/KEYBLOCK12_WARLOCK.md (mh-research,
	-- checked by a second helper). Rob via Sparring 24-11: "laat een agent uitzoeken welke spells logisch zijn per class".
	keys12 = {
		["1"] = { base = "Shadow Bolt", why = "main attack spell; instant when Shadow Trance lights up" },
		["2"] = { base = "Corruption", why = "your first damage over time" },
		-- 3 <-> SHIFT-2 after the second check (KEYBLOCK12_REVIEW.md): Affliction is the default tree; there Agony is
		-- step 2 of every pull and Immolate "only on a tough enemy" (ForeverHowToPlay.lua).
		["3"] = { base = "Bane of Agony", why = "your second DoT, every pull, after Corruption on 2" },
		["4"] = { base = "Drain Soul", why = "finisher: kill with it and you get a Soul Shard" },
		["Q"] = { base = "Soul Fire", why = "big cooldown: your biggest hit (48, costs a Soul Shard)" },
		-- E stays empty on purpose: no interrupt of its own (Spell Lock belongs to the Felhunter, on Blizzard's pet bar).
		["R"] = { base = "Curse of Exhaustion", why = "slows the enemy so you can stay away from it (talent)" },
		["F"] = { base = "Life Tap", why = "helper: turns health into mana" },
		["Z"] = { base = "Shadow Ward", why = "small defensive: soaks up shadow damage" },
		["X"] = { base = "Death Coil", why = "second defensive: a horror on the enemy and a heal" },
		["C"] = { base = "Drain Life", why = "big defensive: your own heal; a Warlock has no stun" },
		["V"] = { base = "Fear", why = "crowd control: takes one enemy out for a while" },
		["SHIFT-1"] = { base = "Rain of Fire", why = "AoE: hits several enemies" },
		["SHIFT-2"] = { base = "Immolate", why = "fire damage, then more damage over time: on a tough enemy" },
		["SHIFT-3"] = { base = { "Curse of the Elements", "Curse of Weakness" }, why = "your curse, under Agony on 3" },
		["SHIFT-4"] = { base = "Shadowburn", why = "second finisher: the shard comes back if it kills (talent)" },
		["SHIFT-Q"] = { base = "Amplify Curse", why = "second cooldown: next curse or bane 50% stronger (talent)" },
		["SHIFT-E"] = { base = { "Will to Survive", "Blood Fury", "Will of the Forsaken", "Escape Artist", "Berserking" },
			why = "your race spell: Shift-E for every class" },
		["SHIFT-R"] = { base = "Hellfire", why = "no second movement spell: AoE that also costs you health" },
		["SHIFT-F"] = { base = "Howl of Terror", why = "crowd control 2: fears several enemies" },
		["SHIFT-Z"] = { base = "Siphon Life", why = "second small defensive: a DoT that heals you (talent)" },
		["SHIFT-X"] = { base = "Soul Link", why = "defensive: part of the damage on you goes to your demon" },
		["SHIFT-C"] = { base = "Demonic Sacrifice", why = "trade your demon for a 2-hour buff (talent)" },
		["SHIFT-V"] = { base = "Banish", why = "crowd control 3: demons and elementals only" },
		-- Same as the old block (Rob, 6 Nov 2026, "Doe maar"): Ctrl-1/2/3 are the demon's keys, in Blizzard's pet-bar order.
		["CTRL-1"] = { cmd = { text = "/petattack", needs = PET, label = "Pet: Attack", icon = "Ability_GhoulFrenzy" },
			why = "pet: attack your target" },
		["CTRL-2"] = { cmd = { text = "/petfollow", needs = PET, label = "Pet: Follow", icon = "Ability_Tracking" },
			why = "pet: follow you" },
		["CTRL-3"] = { cmd = { text = "/petstay", needs = PET, label = "Pet: Stay", icon = "Spell_Nature_TimeStop" },
			why = "pet: stay where it is" },
		["CTRL-4"] = { base = "Bane of Doom", why = "no form 4: a big hit after 60 s (level 60, long fights)" },
		["CTRL-Q"] = { base = "Fel Domination", why = "cooldown: your next summon is fast and cheap (talent)" },
		["CTRL-E"] = { base = "Inferno", why = "cooldown: calls an Infernal (needs an Infernal Stone)" },
		["CTRL-R"] = { base = "Health Funnel", why = "recovery: heals your demon with your own health" },
	},
}
