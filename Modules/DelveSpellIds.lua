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
	-- shadow_bolt: not linked on Icy Veins; add ID after verifying on Wowhead or in-game

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
	fungalstorm = 415404,
	fungsplosion = 425315,
	fungal_charge = 415494,
	rancid_rain = 1264553,
	fungis_fist = 1264111,
	fling_chair = 1264310,

	-- Sunkiller Sanctum — Esuritus
	calling_bolt = 1262702,
	coalescing_malediction = 1262075,
	crushing_rift = 1261970,
	gorge = 1262581,

	-- Shadowguard Point — Chief-Arcanist Patram (Void Bolt: interrupt priority on Icy Veins)
	dark_communion = 1263416,
	submit_to_the_void = 1263615,
	discordant_hymn = 1263722,

	-- Torment's Rise — Nullaeus
	devouring_essence = 1256358,
	emptiness_of_the_void = 1256351,
	imploding_strike = 1256355,
	oblivion_shell = 1255886,
	-- dread_portal / umbral_rage: add from Wowhead boss page when confirmed
}

--- Display name when no ID is mapped yet ({SPELL:@token} without entry above).
ns.DELVE_SPELL_FALLBACK = {
	shadow_bolt = "Shadow Bolt",
	void_bolt_patram = "Void Bolt",
	dread_portal = "Dread Portal",
	umbral_rage = "Umbral Rage",
	twilight_seekers = "Twilight Seekers",
}
