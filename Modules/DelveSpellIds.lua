--[[
	Midnight Helper — spell IDs for Delve Coach tooltips ({SPELL:123} / {SPELL:@token}).

	IDs verified via Wowhead tooltip API (nether.wowhead.com) from links embedded in
	Icy Veins delve guides and DBM-Delves-Midnight notes. Add more in-game with:
	  /dump C_Spell.GetSpellName(SPELL_ID)
]]

local _, ns = ...

---@type table<string, number>
ns.DELVE_SPELL_IDS = {
	-- The Shadow Enclave — Lord Antenorian
	shadowveil_annihilation = 1256093,
	shadow_bolt = 1256015,

	-- Collegiate Calamity
	wildroot_weave = 1263720,
	lightbloom_salvo = 1262709,
	shadow_laceration = 1256547,
	twilight_crash = 1257609,
	void_eruption = 1252107,
	terrifying_power = 1256027,

	-- The Darkway — Infiltrator Gulkat
	abyssal_burst = 1272820,
	illusory_deceit = 1272935,

	-- Parhelion Plaza — Gladius Slaurna
	devouring_nova = 1254856,
	voidscar_raze = 1286397,

	-- Atal'Aman — Spiritflayer Jin'Ma
	flaying_knife = 1264990,
	raging_spirits = 1266023,
	claim_spirits = 1266337,

	-- Twilight Crypts — Blademaster Darza
	shade_cleave = 1267227,
	dark_pursuit = 1267121,
	bask_in_the_twilight = 1268950,

	-- The Gulf of Memory
	radiant_command = 1264966,
	searing_light = 1265769,
	malignant_gleam = 1265511,
	hopeless_curse = 1213776,
	tear_it_down = 1213707,
	unanswered_call = 1213700,

	-- The Grudge Pit
	solar_charge = 1265262,
	bloom_thorn = 1265326,
	blinding_burst = 1265320,
	rancid_rain = 1264553,
	fungis_fist = 1264111,
	fling_chair = 1264310,
	--- Gyrospore, measured 31 Aug 2026 in SpellName.db2 @ 12.1.0.69497 and pinned to the boss
	--- through Wowhead's used-by-npc list (Gyrospore = NPC 247910).
	---
	--- 🔴 Each of these has a same-named sibling that Icy Veins publishes, and two of those
	--- three published ids are WRONG for us: 415494 (fungal_charge) has no NPC link at all,
	--- and 425315 (fungsplosion) is shared with Spinshroom and Shroomsprew. The ids below are
	--- the Gyrospore-exclusive rows, so they can never render another creature's tooltip.
	--- ⚠️ fungal_charge has no exclusive variant -- 415492 is the shared Fungarian ability.
	fungalstorm = 415404,
	fungal_charge = 415492,
	fungsplosion = 425319,

	-- Sunkiller Sanctum — Esuritus
	calling_bolt = 1262702,
	coalescing_malediction = 1262075,
	crushing_rift = 1261970,
	gorge = 1262581,

	-- Shadowguard Point — Chief-Arcanist Patram (Void Bolt: interrupt priority on Icy Veins)
	dark_communion = 1263416,
	submit_to_the_void = 1263615,
	discordant_hymn = 1263722,
	--- 🔴 The suffix on this alias is load-bearing. There are ~125 spells named "Void Bolt",
	--- and the generic Midnight one (1251883) is shared by 85+ void NPCs -- Patram is NOT among
	--- them. A search on the name alone lands on that one and shows the player a tooltip for an
	--- ability that is not the one being cast at them. 1260196 lists Chief-Arcanist Patram
	--- (NPC 248676) directly. SpellName.db2 @ 12.1.0.69497.
	void_bolt_patram = 1260196,

	-- Torment's Rise — Nullaeus
	devouring_essence = 1256358,
	--- 1258147 is the 75% cast; 1258157 and 1258167 are same-named siblings with no NPC link,
	--- almost certainly the 50% and 25% ones. Only 1258147 lists Nullaeus (NPC 252950).
	dread_portal = 1258147,
	emptiness_of_the_void = 1256351,
	imploding_strike = 1256355,
	oblivion_shell = 1255886,
	umbral_rage = 1256180,
	-- dread_portal: no Wowhead spell with this exact name in Nullaeus ID range yet (tips use mechanic name)
}

--- Display name when no ID is mapped yet ({SPELL:@token} without entry above).
ns.DELVE_SPELL_FALLBACK = {
	void_bolt_patram = "Void Bolt",
	dread_portal = "Dread Portal",
	twilight_seekers = "Twilight Seekers",
	fungalstorm = "Fungalstorm",
	fungsplosion = "Fungsplosion",
	fungal_charge = "Fungal Charge",
}
