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

	-- Disciple of Vashnik — Season 2 variant boss: Atal'Aman (Venomous Vapors) and Shadowguard Point
	-- (Basilisk Blitz). Ids and tooltip text read on Wowhead (nether.wowhead.com tooltips) by a
	-- research helper on 15 Sep 2026, after Rob met the boss. DBM has no encounter mod for him.
	malignance = 1311537, -- 4 s volley of venom globs, stacking DoT + slow; interrupt
	toxic_froth = 1292454, -- 8 s poison DoT on the player, dispel type Poison
	living_venom = 1292441, -- knockback + summons Living Venom
	-- Venomous Vapors' own tool: GEMETEN in Rob's client, 15 Sep 2026 (tooltip with CDPulse's Spell ID):
	-- "Fireball", 50 yd, instant, 5 s cooldown, "Cast into poison for explosive results. Stand clear!"
	-- Picked up from one of the 2 chests in the first room.
	venomous_fireball = 1298792,

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

	-- Replicating Venomborne (NPC 269179) — Grudge Pit: Fungal Pharmacon; Darkway: Eggsplosive
	-- Growth. Candidates from Wowhead's search, 11 Sep 2026; chosen by TOOLTIP TEXT (nether
	-- tooltip API), NOT by an NPC link — Wowhead's used-by list did not come through. So these
	-- are INFERRED; the player's own debuff tooltips settle it (see docs/TESTLIJST.md).
	--- 🔴 Venom Splash has two 12.1 families and the suffix is load-bearing. 1303316: "The glob
	--- forms into a Venomborne and leaves behind a toxic pool" (pool = 1303318, 30% slow) — the
	--- replicating boss. 1289623 is a different caster's "sticky venom" (20 damage, 60% slow).
	venom_splash_venomborne = 1303316,
	--- 1289224 is the 2 s melee cast; 1289223 is the stacking DoT it leaves. Only these two exist.
	hydra_strike = 1289224,
	--- 1311500 is the 1 s cast; 1303330 the summon of Lesser Venomborne (NPC 263118), same text.
	serpentogenesis = 1311500,

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

	-- ⚠️ 15 Sep 2026, delve Season 2 audit. Ids read in SpellName.db2 (wago.tools, live 12.1.0) and on
	-- Wowhead's tooltips by five research helpers. Unless noted, each is tied to its boss by name and
	-- tooltip text, not by an npc link. DBM has no mod for any of these bosses except Azta'rec.
	-- The shared 12.1 delve tool of the Ula'tek stories: cleans Ula'tek Poison Pools, hits enemies within 5 yd.
	fungal_pharmacon = 1279443,
	-- The Shadow Enclave — Abominable Blunder (Infiltrate and Ameliorate). One of only two SpellName rows
	-- with this name, both new in 12.1 (1307603 is the 4 s cast bar); the link to the boss is inferred.
	searing_spew = 1307600,
	-- Gnarldor Isle — Gralka Snake-Eater (DB2 encounter 3512)
	snake_eater = 1287653,
	venomblade_slash = 1287794,
	purging_breath = 1287716,
	muckwave = 1287559, -- Stonerender Raider; GTFO ties it to instance 3038
	-- Gnarldor Isle — Osseous Amalgamation (DB2 encounter 3560). The 1305761-1305771 block: the tooltips
	-- name no caster, so the link is Icy Veins' ability list plus the ids sitting together.
	bone_armor_osseous = 1305761,
	frost_strike_osseous = 1305762,
	bonestorm_osseous = 1305764,
	bone_spike_osseous = 1305771,
	-- The Ring of Glory — Drakta (3535) and Gnok (3514, undead 3515); trash and floor traps via GTFO (3077)
	soul_cleave_drakta = 1303106,
	spirit_tear = 1301863,
	roar_of_the_champion = 1301848,
	upheaval_gnok = 1306011,
	ruptured_ground_gnok = 1306124,
	necrotic_upheaval_gnok = 1306117,
	necrotic_ground_gnok = 1306135,
	ejecting_decay = 1306233,
	soul_impale = 1239757,
	whirling_spirit = 1238255,
	hex_pile = 1296441,
	thrusting_spear = 1296414,
	-- Venomfall Deeps — Azta'rec: the ids DBM's own mod uses (Nemesis\Aztarec.lua, revision 20260828)
	noxious_bile = 1291555,
	soul_extinction = 1294963,
	serpents_strike = 1293825,
	venom_storm = 1309418,
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
