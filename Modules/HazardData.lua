local _, ns = ...

--[[
	Midnight Helper — what damages you avoidably, keyed by instance.

	Source: GTFO 6.7.2 (17 aug 2026), harvested per entry rather than per section
	header. GTFO records exactly one thing — damage you could have walked out of —
	which is the shape a "do not stand in this" line wants, and it is curated by hand
	by an author who writes `??????` when he does not know rather than guessing.

	⚠️ THE NAMES ARE MEASURED, THE PLACEMENT IS NOT.

	Every spell id below was put to Rob's client twice (`/mh mech`, 16-17 aug) and all
	173 came back named, with two controls holding: an id that cannot exist stayed
	empty, and our own six DBM ids all resolved. So these are real spells.

	That the spell belongs to THIS instance is GTFO's claim, not the client's. The
	client has no opinion on it — asked what instance 1592 is called it answered
	"Ny'alotha", a Battle for Azeroth raid, because GTFO's `instance` field is not a
	uiMapID and the lookup was mine. Sixteen of seventeen returned nothing; the one
	that answered was the wrong one. That is the whole reason nothing here is keyed by
	a zone NAME that somebody typed.

	⚠️ SO WE DO NOT TRANSLATE INSTANCE IDS INTO ZONE NAMES BY HAND. The player's own
	client reports its instance id on entry (`GetInstanceInfo`), which is the same
	number GTFO keys on, and the name comes back in the same call. Standing in a place
	is the measurement. `ns.db.hazardZones` accumulates what has been seen, so the four
	instances nobody can name yet (3079, 2963, 2858, 1592) name themselves the first
	time anyone walks in.

	`{SPELL:id}` renders each name from the client at display time, so the list is
	already correct in all seven languages and cannot drift from the game.
]]

--- [instanceID] = ordered spell ids. Order is GTFO's, so a re-harvest diffs cleanly.
--- The trailing comment on each line is the name Rob's client returned — a record of
--- the measurement, never the source: the UI reads {SPELL:id}, never this text.
ns.INSTANCE_HAZARDS = {
	[2805] = { -- Windrunner Spire
		473784,  -- Fetid Spew
		472118,  -- Ignited Embers
		468924,  -- Bladestorm
		472777,  -- Gunk Splatter
	},
	[2811] = { -- Magister's Terrace
		1214089, -- Arcane Residue
	},
	[2813] = { -- Murder Row
		1215200, -- Rain of Felfire
		1215985, -- Fel Beam
		1216590, -- Heartstop Poison
		1216955, -- Eye Beam
		1294870, -- Fel-Scarred Earth
		474234,  -- Burning Steps
		1223906, -- Fel Nova
		474740,  -- Murder in a Row
		474768,  -- Delivery!
		1266241, -- Freight Explosion
		1214663, -- Axe Toss
		1217384, -- Malefic Wave
		1297691, -- Whirlwind
		1297695, -- Felfire Bombardment
		1294836, -- Defiled Detonation
	},
	[2825] = { -- Den of Nalorakk
		1235405, -- Bonespiked
		1236289, -- Blizzard's Wrath
		1247367, -- Earthquake
		1252825, -- Harsh Winds
		1297701, -- Rotten Ground
		1234021, -- Earthshatter Slam
		1235129, -- Bonespike Slam
		1240280, -- Pulverize
		1235795, -- Shattering Frostspike
		1235641, -- Raging Squall
		1247030, -- Poison Spear Volley
		1242887, -- Echoing Maul
		1297797, -- Forceful Slam
	},
	[2858] = { -- name still unknown — the client has never been asked from inside
		1225385, -- Grasping Shadows
		1226990, -- Wrath of Void
		1257514, -- Seismic Stomp
		1257563, -- Seismic Stomp
	},
	[2859] = { -- The Blinding Vale
		1234802, -- Fertile Loam
		1235828, -- Light-Scorched Earth
		1237858, -- Ruptured Earth
		1239919, -- Lightfire Beams
		1246751, -- Concentrated Lightbeam
		1251345, -- Blight Resin
		1314885, -- Hunting Leap
		1238638, -- Bullet Seeds
		1263642, -- Belch Spores
		1237267, -- Incise
		1259365, -- Bloodthorn Roots
		1242138, -- Solar Breath
		1242200, -- Lightwarden's Blight
	},
	[2874] = { -- Maisara Caverns
		1243752, -- Icy Slick
		1251833, -- Soulrot
		1252130, -- Unmake
		1252816, -- Chill of Death
		1253779, -- Spectral Decay
		1254043, -- Eternal Suffering
		1257782, -- Shredding Talons
		1257898, -- Ancestral Crush
		1259777, -- Umbral Vortex
		1257160, -- Rain of Toads
		1257164, -- Vile Potatoad
		1258823, -- Ritual Firebrand
		1265832, -- Shadow Burst
		1249638, -- Carrion Swoop
		1249989, -- Coordinated Assault
		1256247, -- Fetid Quillstorm
		1252611, -- Coalesced Death
		1266706, -- Haunting Remains
		1259887, -- Ritual Drums
		1257895, -- Ancestral Crush
		1259664, -- Soulstorms
		1259713, -- Rended Soul
		1248980, -- Volatile Essence
		1279517, -- Soul Expulsion
		1254175, -- Cries of the Fallen
	},
	[2912] = { -- The Voidspire
		1238206, -- Volatile Fissure
		1242553, -- Void Remnants
		1244672, -- Nullzone
		1245421, -- Gloomfield
		1245592, -- Torturous Extract
		1246158, -- Consecration
		1251213, -- Twilight Spikes
		1260030, -- Umbral Beams
		1272324, -- Divine Tempest
		1276982, -- Divine Consecration
		1280101, -- Dark Energy
		1284786, -- Shadow Phalanx
		1258883, -- Void Fall
		1259186, -- Blisterburst
		1241844, -- Smashed
		1264467, -- Tail Lash
		1265152, -- Impale
		1248652, -- Divine Toll
		1243753, -- Ravenous Abyss
	},
	[2913] = { -- March on Quel'Danas
		1222306, -- Sporecloud
		1241840, -- Light Patch
		1241841, -- Void Patch
		1242803, -- Light Flames
		1242815, -- Void Flames
		1282470, -- Dark Quasar
		1243866, -- Voidlight Rupture
	},
	[2915] = { -- Nexus-Point Xenas
		1277597, -- Radiant Scar
	},
	[2923] = { -- Voidscar Arena
		1222484, -- Poison Pool
		1228126, -- Macestorm
		1248130, -- Unstable Singularity
		1249712, -- Venomous Spit
		1264188, -- Unstable Singularity
		1282892, -- Sickening Bite
		1296967, -- Void Fissure
		1299210, -- Aftershock
		1299145, -- Earthsplitter
		1311712, -- Lightning Strike
		1234917, -- Smashing Charge
		1296963, -- Umbral Rupture
		1300262, -- Dark Bloom
		1233264, -- Blisterburst
		1226031, -- Poison Splash
		1222724, -- Noxious Breath
		1310026, -- Atomized
	},
	[2939] = { -- The Dreamrift
		1245919, -- Alndust Essence
	},
	[2963] = { -- The Grudge Pit
		1280182, -- Ula'tek Poison Pool
	},
	[2987] = { -- Tidebound Grotto (lair) — 2987 also matches our own 15 jul measurement
		1257654, -- Lingering Frost
		1265425, -- Wild Bite
		1281341, -- Wild Bite
		1307062, -- Big Wave
		1313448, -- Frost Orb
	},
	[2993] = { -- Altar of Fangs
		1301231, -- Bloodletting
		1306232, -- Septic Spatter
		1306669, -- Toxic Breath
		1307531, -- Bloodletting
		1307573, -- Triple Shot
		1309416, -- Virulent Twister
		1307915, -- Ravenous Stomp
		1296069, -- Regurgitate
		1300083, -- Burrowing Charge
		1300044, -- Venom Jet
		1305393, -- Undermining
		1295073, -- Virulent Whirl
		1306856, -- Toxic Beam
		1294197, -- Experimental Toxin
	},
	[3004] = { -- The Venomous Abyss (raid)
		1285623, -- Soulcoil Well
		1296439, -- Corpse Blight
		1294846, -- Anguished Echoes
	},
	[3038] = { -- Gnarldor Isle (Season 2 delve) — CONFIRMED by Rob's client 17 aug,
		-- which named the instance itself on entry. The one placement in this file
		-- that is not GTFO's word for it.
		--
		-- ⚠️ Its boss is spelled two ways: GTFO writes "Graka Snake-Eater", Method
		-- writes "Gralka Snake-Eater". Encounter 3512 will say which.
		1287680, -- Snake Eater
		1287559, -- Muckwave
	},
	[3077] = { -- The Ring of Glory (Season 2 delve)
		1301863, -- Spirit Tear
		1238255, -- Whirling Spirit
		392013,  -- Golem Smash
		1239757, -- Soul Impale
		1296414, -- Thrusting Spear
		1296441, -- Hex Pile
		1296366, -- Scything Blade
	},
	[3079] = { -- CANDIDATE, 17 aug: Method publishes an "Azta'rec nemesis delve"
		-- guide whose boss abilities include Noxious Bile — one of the four ids
		-- below — at 2512 51.22 / 30.27, and Venomfall Deeps was already on our
		-- Season 2 list. Matching ability names is a strong hint and still a hint;
		-- the client names this instance the moment anyone walks in, and that is
		-- what will actually settle it.
		1298887, -- Noxious Venom
		1291555, -- Noxious Bile
		1309412, -- Venom Wave
		1288126, -- Wrath of Ula'tek
	},
	[1592] = { -- name still unknown. NOT Ny'alotha: that is what a uiMapID lookup
		-- answered, and it is wrong — the spell here is Midnight fungal content.
		1221901, -- Awaken Fungi
	},
}

--- GTFO files these with no instance at all: Midnight world content and Prey hunts.
--- Kept apart rather than folded into a zone, because "somewhere outdoors" is not a
--- placement and pretending otherwise is the exact error this file is built to avoid.
ns.WORLD_HAZARDS = {
	1243988, -- Blinding Fissure
	1270862, -- Ruptured Ground
	1284716, -- Mana Pool
	1295990, -- Arcane Dissolution
	1270524, -- Alchemical Sludge
	1276517, -- Ancient Seeds
	1297422, -- Deadly Venom
	1253237, -- Null-Magic Missiles
	1256357, -- Undead Eruption
	1271755, -- Earsplitting Roar
	1266183, -- Crushing Leap
	1258640, -- Rigor Mortis
	1230634, -- Crushing Stomp
	1235134, -- Erupting Roots
	1285974, -- Deadly Slam
	1291560, -- Stunned
}
