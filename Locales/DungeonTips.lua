--[[
	Midnight Helper — Dungeon Coach boss-step bodies (EN + NL pilot; other
	locales fall back to EN until the localization pass). Line breaks |n.

	Phase 3, batch 1: Windrunner Spire + Maisara Caverns (Normal difficulty).
	Own MH text in beginner language, cross-referenced against BossHelper
	(MIT) and DungeonHelper on Rob's machine; to be verified by Rob in
	follower runs before this ships in a release. Spell names stay in English
	(proper names policy).

	Batch 2 (11 Jun): the remaining six Season 1 dungeons (Murder Row, Den of
	Nalorakk, The Blinding Vale, Voidscar Arena, Nexus-Point Xenas, Magisters'
	Terrace). Source: DBM-Party-Midnight mods (spell IDs, voice cues, comments)
	cross-checked against Wowhead spell tooltips — every mechanical claim
	traces to one of those two. Not yet run in-game; same verification status
	as batch 1 before Rob's follower runs.

	Batch 3 (11 Jun): the four legacy Season 1 dungeons via DBM-Party-WoD/
	WotLK/Legion/Dragonflight (IsPostMidnight branch = Midnight revamp spells)
	+ Wowhead tooltips.

	{SPELL:id} markup (11 Jun, Robs DungeonHelper-vergelijk): ability-namen
	zijn {SPELL:<id>}-tokens — DelveTipMarkup rendert ze als klikbare,
	client-gelokaliseerde [Spell]-links met hover-tooltip; de live coach
	print ze klikbaar in chat en /mh bossshare verstuurt kale namen.
	Spell-IDs komen uit de DBM-mods (zelfde bron als de mechanics).
	Namen zonder zeker ID blijven platte tekst.
]]

local _, ns = ...

local function merge(target, patch)
	if not target or not patch then
		return
	end
	for k, v in pairs(patch) do
		target[k] = v
	end
end

merge(ns._mhLocales and ns._mhLocales.enUS, {
	-- Windrunner Spire ---------------------------------------------------------
	DGN_TIP_WS_DUO_STEPS = "1. Two bosses — damage them evenly so they die around the same time.|n2. Interrupt Shadow Bolt; step out of the spew circles ({SPELL:472745}) — don't waste floor space.|n3. Cursed ({SPELL:474105})? Have it dispelled fast — or crowd-control the Dark Entity it spawns until it fades.|n4. Hooked by {SPELL:472793} during the shriek? Position so you get pulled THROUGH the ghost lady — that breaks her cast.",
	DGN_TIP_WS_DUO_TANK = "Tank: defensive for {SPELL:472888}; move the bosses when the floor gets cluttered.",
	DGN_TIP_WS_DUO_HEALER = "Healer: big group damage during {SPELL:472736}; dispel {SPELL:474105} quickly.",

	DGN_TIP_WS_EMBER_STEPS = "1. Fire = bad. Drop the fire puddles ({SPELL:466556}) at the edges, keep the middle clean.|n2. At full energy run TO the boss for {SPELL:465904}, then sidestep every Fire Breath.|n3. Old puddles spawn fire twisters — keep dodging.",
	DGN_TIP_WS_EMBER_TANK = "Tank: defensive for {SPELL:466064}.",
	DGN_TIP_WS_EMBER_HEALER = "Healer: heavy group damage during {SPELL:465904}.",

	DGN_TIP_WS_KROLUK_STEPS = "1. Brown circles = bad, step out.|n2. Stack with an ally before {SPELL:1253026} finishes (overlap the purple circles).|n3. Fixated or leaped at ({SPELL:1283247})? Run it away from the group.|n4. When adds spawn (about two thirds and one third health): kill them fast — the Phantasmal Mystic first, and keep interrupting it.",
	DGN_TIP_WS_KROLUK_TANK = "Tank: defensive for {SPELL:467620}; be ready to pick up the second {SPELL:1283247}.",
	DGN_TIP_WS_KROLUK_HEALER = "Healer: group damage during {SPELL:472043}.",

	DGN_TIP_WS_HEART_STEPS = "1. {SPELL:1216042} stacks ticking on you? Step on a windy arrow (Turbulent Arrow) at 2-3 stacks — it clears the DoT and jumps you over the expanding shockwave.|n2. Keep one arrow free for the big blast at full energy ({SPELL:468429}).|n3. Spread a little for {SPELL:1253979} and use the big circles to clear the electric ground.|n4. Targeted by {SPELL:474528}? Stand still and let the others move out; everyone else: step out of the frontal.",
	DGN_TIP_WS_HEART_TANK = "Tank: defensive for {SPELL:472662}; aim the knockback away from the puddles.",
	DGN_TIP_WS_HEART_HEALER = "Healer: top up players with high {SPELL:1216042} stacks first; extra healing after {SPELL:1253979}.",

	-- Maisara Caverns ------------------------------------------------------------
	DGN_TIP_MC_MUROJIN_STEPS = "1. Two bosses (hunter and bird) — kill them close together, or the survivor goes berserk.|n2. Ice traps ({SPELL:1243741}), green circles ({SPELL:1243900}) and the frontal {SPELL:1260643} = bad, stay out.|n3. Targeted by {SPELL:1249478} (the bird dive)? Run INTO an ice trap — the freeze stops the dive. Everyone else: get away from that player.",
	DGN_TIP_MC_MUROJIN_TANK = "Tank: defensive for {SPELL:1266480}.",
	DGN_TIP_MC_MUROJIN_HEALER = "Healer: dispel {SPELL:1246666} (disease) — heavy group damage.",

	DGN_TIP_MC_VORDAZA_STEPS = "1. The boss spawns Unstable Phantoms ({SPELL:1251204}) that chase players. KILL them before they reach anyone — a phantom that reaches its target (or touches another phantom) bursts for heavy damage nearby.|n2. Each phantom killed screams: unavoidable group damage — so kill them ONE at a time.|n3. Dodge {SPELL:1252054}'s frontal surge (it pushes you away), the floating orbs and Soulrot.|n4. Someone wrapped in a Deathshroud? Break them out fast; interrupt {SPELL:1250708} and dodge the swirls during it.",
	DGN_TIP_MC_VORDAZA_TANK = "Tank: defensive for {SPELL:1251554}.",
	DGN_TIP_MC_VORDAZA_HEALER = "Healer: each slain phantom screams ({SPELL:1251813}) = group damage — heal between staggered kills.",

	DGN_TIP_MC_RAKTUL_STEPS = "1. The boss leaps at three players ({SPELL:1252676}) and leaves Soulbind Totems — spread so the totems land apart, don't get crushed, and kill the totems fast.|n2. Stay out of the Chill of Death ground.|n3. Soul phase ({SPELL:1253788}): you're pulled out of your body — crowd-control and interrupt the big adds while you run back to your body.|n4. Dodge the swirls from the Deathgorged Vessel.",
	DGN_TIP_MC_RAKTUL_TANK = "Tank: defensive for {SPELL:1251023}; place the puddles away from the group.",
	DGN_TIP_MC_RAKTUL_HEALER = "Healer: heavy group damage during Deathgorged Vessel and when totems shatter.",

	-- Murder Row (batch 2 — geverifieerd via DBM-Party-Midnight + Wowhead) ------
	DGN_TIP_MR_KYSTIA_STEPS = "1. Kystia clones herself ({SPELL:1264095}) — crowd-control or stun the copies; they all channel Felstorm.|n2. {SPELL:474240}: she teleports onto a player and explodes with a knockback — get out of the blast.|n3. Stay out of Nibbles' {SPELL:1253813} cone (ticking fire).|n4. When Nibbles turns to her light form she channels {SPELL:1230304} at Kystia — switch targets when it happens.",
	DGN_TIP_MR_KYSTIA_TANK = "Tank: keep Nibbles' {SPELL:1253813} cone pointed away from the group.",
	DGN_TIP_MR_KYSTIA_HEALER = "Healer: spike damage when {SPELL:474240} lands; steady damage on anyone clipped by Felstorm copies.",

	DGN_TIP_MR_ZAEN_STEPS = "1. {SPELL:474545}: he shoots everyone in his LINE OF SIGHT — break it: hide behind the crates and pillars before the shot (it also leaves a 15s bleed).|n2. {SPELL:474765}: freight rains down on players and knocks you away — move out of the markers.|n3. {SPELL:474478}: 3 seconds of heavy fire on the whole group — be topped up, use a defensive.|n4. Dodge the Fire Bombs ({SPELL:1214352}).",
	DGN_TIP_MR_ZAEN_TANK = "Tank: defensive for {SPELL:1222795}.",
	DGN_TIP_MR_ZAEN_HEALER = "Healer: have the group topped before {SPELL:474478}; bleeds tick on anyone caught by {SPELL:474545}.",

	DGN_TIP_MR_XATHUUX_STEPS = "1. {SPELL:1214637} is aimed at a player — move it away from the group and out of the impact.|n2. {SPELL:474197}: heavy damage on everyone — defensives and keep moving.|n3. Big tank hits ({SPELL:473898}) — give the healer a calm moment around them.",
	DGN_TIP_MR_XATHUUX_TANK = "Tank: defensive for {SPELL:473898}.",
	DGN_TIP_MR_XATHUUX_HEALER = "Healer: group damage during {SPELL:474197}.",

	DGN_TIP_MR_LITHIEL_STEPS = "1. {SPELL:1218203}: spread out (6+ yards) — every impact spawns Wild Imps; kill the imps fast.|n2. Kill the summoned Vilefiend ({SPELL:474408}) before the next imp wave.|n3. {SPELL:1224478}: she shields up and sends a wave of fel fire through the room — use the gateway to escape it (the hit stacks +50% fire damage taken, and demons it touches get empowered).",
	DGN_TIP_MR_LITHIEL_TANK = "Tank: pick up the Vilefiend and the imps quickly.",
	DGN_TIP_MR_LITHIEL_HEALER = "Healer: anyone hit by {SPELL:1224478} takes stacking fire damage — keep them high.",

	-- Den of Nalorakk -----------------------------------------------------------
	DGN_TIP_DN_HOARDMONGER_STEPS = "1. {SPELL:1234233}: rotten food rains down for 7 seconds and litters Rotten Mushrooms — dodge the impacts and stay off the mushrooms.|n2. {SPELL:1253268} is a frontal cone — never stand in front.|n3. {SPELL:1235118} hits everyone (ignores armor) — stay topped up.",
	DGN_TIP_DN_HOARDMONGER_TANK = "Tank: the frontal follows you — aim the boss away from the group.",
	DGN_TIP_DN_HOARDMONGER_HEALER = "Healer: group heal after every {SPELL:1235118}.",

	DGN_TIP_DN_SENTINEL_STEPS = "1. Raging Squalls ({SPELL:1235623}) wander the arena for a long time — keep weaving around them.|n2. {SPELL:1235783} icicles crash down and reveal a Fractured Shivercore — destroy it.|n3. {SPELL:1235656}: a frozen veil absorbs damage while the storm pushes everyone away and ticks on the group — break the shield FAST.",
	DGN_TIP_DN_SENTINEL_TANK = "Tank: hold the boss clear of the squalls.",
	DGN_TIP_DN_SENTINEL_HEALER = "Healer: dispel/heal through {SPELL:1235548} (16s frost DoT); everyone ticks during {SPELL:1235656}.",

	DGN_TIP_DN_NALORAKK_STEPS = "1. {SPELL:1243011}: Nalorakk knocks Zul'jarra down and spirit bears charge at her — stand in their path to intercept them (every bear that reaches her triggers a nasty scream).|n2. {SPELL:1255385} pushes everyone back — mind your footing near hazards.|n3. {SPELL:1243569} shreds the tank for 4 seconds — help with externals if you have them.",
	DGN_TIP_DN_NALORAKK_TANK = "Tank: {SPELL:1243569} = stacking hits, +50% damage taken per hit — big defensive, every time.",
	DGN_TIP_DN_NALORAKK_HEALER = "Healer: the tank spikes hard during {SPELL:1243569}; group heal after each roar.",

	-- The Blinding Vale -----------------------------------------------------------
	DGN_TIP_BV_TRINITY_STEPS = "1. Three bosses at once — follow your tank's target order.|n2. Lekshi dashes between loam patches ({SPELL:1234850}) and sows Lightblossom seeds along the way — stay out of the dash paths.|n3. Kezkitt beams every seed ({SPELL:1235564}): STAND IN the beam to stop the seed growing (an unsoaked seed overgrows after 10 seconds).|n4. Meittik hits the tank hard ({SPELL:1234753}).",
	DGN_TIP_BV_TRINITY_TANK = "Tank: defensive for {SPELL:1234753}; watch Lekshi's {SPELL:1261276}.",
	DGN_TIP_BV_TRINITY_HEALER = "Healer: beam-soakers take steady Holy damage — keep them up.",

	DGN_TIP_BV_IKUZZ_STEPS = "1. {SPELL:1236746} knocks everyone back and roots sprout where players stand — drop them at the edges.|n2. {SPELL:1237091}: he fixates and chases a player for 10 seconds — run, don't let him reach you.|n3. Keep dodging the thorn eruptions ({SPELL:1236709}).",
	DGN_TIP_BV_IKUZZ_TANK = "Tank: regrab him after each Gaze chase ends.",
	DGN_TIP_BV_IKUZZ_HEALER = "Healer: keep the chased player healthy — getting caught hurts.",

	DGN_TIP_BV_RUIA_STEPS = "1. The warden swaps forms (bear, moonkin, haranir) — each has its own tricks.|n2. Dodge the {SPELL:1240098} impact circles.|n3. {SPELL:1241058} leaves a bleed that only stops when the target is healed to FULL — call it out.|n4. Endgame ({SPELL:1241067}): everything fires every few seconds — save cooldowns and keep moving.",
	DGN_TIP_BV_RUIA_TANK = "Tank: bear form hits hardest — defensive for {SPELL:1240222}.",
	DGN_TIP_BV_RUIA_HEALER = "Healer: {SPELL:1241058} bleeds until the player is at FULL health — top them immediately.",

	DGN_TIP_BV_ZIEKKET_STEPS = "1. Lightbloom orbs ({SPELL:1246858}) drift toward Ziekket — touch them to burst them before they reach him.|n2. Lightspawn Lashers keep sprouting ({SPELL:1246372}, and dormant ones reawaken) — kill them properly.|n3. Watch your feet for {SPELL:1246753} and mind the {SPELL:1253690}.",
	DGN_TIP_BV_ZIEKKET_TANK = "Tank: defensive for {SPELL:1247685}; pick up the lashers.",
	DGN_TIP_BV_ZIEKKET_HEALER = "Healer: steady group damage — expect a spike when an orb slips through.",

	-- Voidscar Arena ----------------------------------------------------------------
	DGN_TIP_VA_TAZRAH_STEPS = "1. {SPELL:1222274} drags everyone toward it for 6 seconds — run against the pull; the center hurts badly.|n2. After each teleport ({SPELL:1262901}) Ethereal Shades attack — burn them down.|n3. Dodge the {SPELL:1225011}.",
	DGN_TIP_VA_TAZRAH_TANK = "Tank: defensive for {SPELL:1222085}.",
	DGN_TIP_VA_TAZRAH_HEALER = "Healer: the rift ticks on everyone while they run — keep the group stable.",

	DGN_TIP_VA_ATROXUS_STEPS = "1. Toxic Creepers ({SPELL:1222371}) crawl out of the pools — kill them quickly.|n2. Stay out of the {SPELL:1263977} frontal and the {SPELL:1226120} circles.|n3. {SPELL:1262497} knocks you back — don't stand with a pool behind you.",
	DGN_TIP_VA_ATROXUS_TANK = "Tank: defensive for {SPELL:1222642}; face the breath away.",
	DGN_TIP_VA_ATROXUS_HEALER = "Healer: pre-heal before {SPELL:1262497}; poison ticks on careless feet.",

	DGN_TIP_VA_CHARONUS_STEPS = "1. A Gravitic Orb ({SPELL:1263982}) chases every player — kite yours to an Unstable Singularity ({SPELL:1282770}; within 6 yards it's destroyed).|n2. {SPELL:1227264}: everyone gets knocked back plus a 20-second DoT — pick safe ground before it hits.|n3. Dodge the {SPELL:1222758} projectiles (contact = damage + knockback).",
	DGN_TIP_VA_CHARONUS_TANK = "Tank: steady positioning — give players room to kite their orbs.",
	DGN_TIP_VA_CHARONUS_HEALER = "Healer: after {SPELL:1227264} the whole group carries a long DoT — big heals there.",

	-- Nexus-Point Xenas ---------------------------------------------------------------
	DGN_TIP_NX_KASRETH_STEPS = "1. Got {SPELL:1251785}? Step INTO a leyline beam ({SPELL:1251183}) — it clears the debuff (short stun, worth it).|n2. Everyone else: do NOT cross the leylines (damage + stacking slow).|n3. Full energy = {SPELL:1257509}: big impact zone, get clear — arcane spills ({SPELL:1264048}) linger afterwards.",
	DGN_TIP_NX_KASRETH_TANK = "Tank: hold the boss away from the leylines.",
	DGN_TIP_NX_KASRETH_HEALER = "Healer: Sparkburn ticks on everyone after each detonation.",

	DGN_TIP_NX_NYSARRA_STEPS = "1. Spread out — {SPELL:1249020} strikes splash 14 yards.|n2. Kill the Null Vanguard adds ({SPELL:1252703}) FAST: anything still alive gets devoured ({SPELL:1271684}), heals her and bursts the group.|n3. Dodge the {SPELL:1264439}.",
	DGN_TIP_NX_NYSARRA_TANK = "Tank: she leaps at you with a slash combo ({SPELL:1247937}) — defensive, brace for the finisher.",
	DGN_TIP_NX_NYSARRA_HEALER = "Healer: spread damage after {SPELL:1249020}; group burst if adds survive the devour.",

	DGN_TIP_NX_LOTHRAXION_STEPS = "1. {SPELL:1255503}: spread — impacts splash 8 yards and spawn Fractured Images.|n2. {SPELL:1257567}: he hides among his images and they all channel — find the REAL Lothraxion and interrupt him.|n3. Images flicker around with knockbacks ({SPELL:1255531}); stay off the {SPELL:1255310} on the floor.",
	DGN_TIP_NX_LOTHRAXION_TANK = "Tank: {SPELL:1255335} is a double slash that carves ground scars — aim it away from the group.",
	DGN_TIP_NX_LOTHRAXION_HEALER = "Healer: Holy DoTs after every {SPELL:1255503}; steady damage until the Guile interrupt lands.",

	-- Magisters' Terrace ---------------------------------------------------------------
	DGN_TIP_MT_ARCANOTRON_STEPS = "1. When it refuels ({SPELL:474345}), Energy Orbs get drawn toward it — intercept them; meanwhile it takes +20% damage: burst window!|n2. Shackled players ({SPELL:1214038}) are rooted (magic) — dispel or break them out.|n3. {SPELL:1214081} knocks everyone back and leaves residue at its feet — step out of it.",
	DGN_TIP_MT_ARCANOTRON_TANK = "Tank: {SPELL:474496} launches you — keep your back clear.",
	DGN_TIP_MT_ARCANOTRON_HEALER = "Healer: dispel {SPELL:1214038} (magic root) quickly.",

	DGN_TIP_MT_SERANEL_STEPS = "1. {SPELL:1225193} pacifies everyone OUTSIDE the Suppression Zone ({SPELL:1224903}) — step IN the zone for the wave (but the zone silences you, so don't linger).|n2. Purge/spellsteal his {SPELL:1248689} (+100% attack speed) whenever it's up.|n3. {SPELL:1225787} bounces to a nearby player — spread.",
	DGN_TIP_MT_SERANEL_TANK = "Tank: an unpurged Ward doubles his attack speed — defensive until it's gone.",
	DGN_TIP_MT_SERANEL_HEALER = "Healer: marked players tick; remember you can't cast inside the zone.",

	DGN_TIP_MT_GEMELLUS_STEPS = "1. {SPELL:1223847} (at the start and at half health): he splits into three.|n2. {SPELL:1253709}: linked to one of them? RUN over and touch it — that breaks the link and removes his absorb shield.|n3. {SPELL:1224299} pulls you in — run back out.",
	DGN_TIP_MT_GEMELLUS_TANK = "Tank: regroup the trio after each {SPELL:1223847} so linked players can reach theirs.",
	DGN_TIP_MT_GEMELLUS_HEALER = "Healer: linked players take +20% damage until they break their link.",

	DGN_TIP_MT_DEGENTRIUS_STEPS = "1. {SPELL:1215897}: void DoTs with different durations — when yours expires, Entropy Orbs launch from YOUR position, so walk away from the group first.|n2. {SPELL:1215087} bounces to 4 spots — SOAK an impact (one player each), or it erupts in Void Destruction.|n3. {SPELL:1280113} smashes the tank and knocks away anyone within 8 yards — give the tank space.",
	DGN_TIP_MT_DEGENTRIUS_TANK = "Tank: defensive for {SPELL:1280113}; tank him away from the group.",
	DGN_TIP_MT_DEGENTRIUS_HEALER = "Healer: Entropy DoTs tick hard — keep carriers up while they reposition.",

	-- Skyreach (batch 3 — Midnight-revamp abilities via DBM + Wowhead) ----------
	DGN_TIP_SR_RANJIT_STEPS = "1. {SPELL:1258148} flies in a straight line in front of him — step aside.|n2. {SPELL:156793}: an impact in the middle plus roaming wind vortexes that launch you — keep weaving.|n3. {SPELL:153757} hits everyone with a bleed — be topped up.|n4. {SPELL:1252733} blasts its targets away — mind what's behind you.",
	DGN_TIP_SR_RANJIT_TANK = "Tank: keep him clear of the vortex paths.",
	DGN_TIP_SR_RANJIT_HEALER = "Healer: group damage plus bleeds after every {SPELL:153757}.",

	DGN_TIP_SR_ARAKNATH_STEPS = "1. {SPELL:154162}: constructs beam light into the boss and HEAL him — stand in a beam to block it.|n2. {SPELL:154115}: a one-sided arm slam — getting hit stacks a brutal damage-taken debuff.|n3. {SPELL:154135} hits everyone — be ready.",
	DGN_TIP_SR_ARAKNATH_TANK = "Tank: never soak the beams yourself — his smash lands during the soak.",
	DGN_TIP_SR_ARAKNATH_HEALER = "Healer: beam-soakers tick steadily; group heal at {SPELL:154135}.",

	DGN_TIP_SR_RUKHRAN_STEPS = "1. {SPELL:1253527}: feathers fly everywhere for 3 seconds — break line of sight behind a pillar.|n2. {SPELL:1253510} hits the group and summons a Sunwing that fixates someone and pulses fire — kill it fast; fixated player keeps distance.|n3. Repeat — quills behind cover, bird down quickly.",
	DGN_TIP_SR_RUKHRAN_TANK = "Tank: defensive for {SPELL:1253519} (big hit + burn DoT).",
	DGN_TIP_SR_RUKHRAN_HEALER = "Healer: pulsing group damage while a Sunwing lives — call for its kill.",

	DGN_TIP_SR_VIRYX_STEPS = "1. {SPELL:154396}: a 3-second cast that nukes the tank — KICK it, every time.|n2. {SPELL:1253998}: a Solar Zealot grabs a player to drop them off the balcony — free them fast.|n3. {SPELL:1253531} on you? Run it out wide — it leaves Blazing Ground.",
	DGN_TIP_SR_VIRYX_TANK = "Tank: every {SPELL:154396} that slips through hurts — keep the kick order tight.",
	DGN_TIP_SR_VIRYX_HEALER = "Healer: {SPELL:1253538} puts fire DoTs on several players at once.",

	-- Pit of Saron ----------------------------------------------------------------
	DGN_TIP_PS_GARFROST_STEPS = "1. {SPELL:1262029}: the forge pulses stacking frost — HIDE BEHIND a saronite ore chunk, it blocks the blast.|n2. {SPELL:1261546} slams everything around the main target — stay 5+ yards off the tank; near ore the slam breaks ore instead of stunning.|n3. {SPELL:1261847} hits everyone and shatters ALL ore — fresh ore follows via {SPELL:1261286}.|n4. Stay out of the {SPELL:1261799}.",
	DGN_TIP_PS_GARFROST_TANK = "Tank: park yourself next to an ore chunk — {SPELL:1261546} then smashes the ore, not you.",
	DGN_TIP_PS_GARFROST_HEALER = "Healer: group spike at {SPELL:1261847}; stacking frost on anyone caught without cover.",

	DGN_TIP_PS_KRICKICK_STEPS = "1. {SPELL:1264363}: Ick fixates and chases a player, splattering Blight and Plague Globs — run wide; the rest keeps hitting.|n2. {SPELL:1264027}: Krick teleports to a ritual circle and summons Shades — switch and kill them.|n3. {SPELL:1264336}: dodge the wave and the globs rolling at you.|n4. Never stand in the Blight ({SPELL:1264299}).",
	DGN_TIP_PS_KRICKICK_TANK = "Tank: {SPELL:1264287} drops a pool on you — aim it at the edge.",
	DGN_TIP_PS_KRICKICK_HEALER = "Healer: keep the chased player rolling; group damage at {SPELL:1264336}.",

	DGN_TIP_PS_TYRANNUS_STEPS = "1. {SPELL:1262772} freezes Bone Piles around its target — stand near piles when marked: frozen piles can't raise adds.|n2. {SPELL:1263406} raises the remaining piles — kill Plaguespreaders first.|n3. Keep dodging {SPELL:1263756} and Rimefang's {SPELL:1276948}.|n4. {SPELL:1276648} = group hit + DoT, and infused piles spawn nastier adds.",
	DGN_TIP_PS_TYRANNUS_TANK = "Tank: {SPELL:1262582} launches you and stacks +200% shadow taken — defensive and brace.",
	DGN_TIP_PS_TYRANNUS_HEALER = "Healer: group DoTs after {SPELL:1276648}; tank spike right after Brand.",

	-- Seat of the Triumvirate --------------------------------------------------------
	DGN_TIP_ST_ZURAAL_STEPS = "1. {SPELL:1268916} hits everything in FRONT of him — never stand before the boss.|n2. {SPELL:1263304} (full energy): he drags everyone in, then bursts with a knockback — run out in time; adds get dragged in too.|n3. {SPELL:1263399} spawns Coalesced Void adds — clear them before Crashing Void.|n4. {SPELL:1263282} leaves Void Sludge ({SPELL:244588}) — keep the floor clean.",
	DGN_TIP_ST_ZURAAL_TANK = "Tank: defensive for {SPELL:1263440} (triple swipe).",
	DGN_TIP_ST_ZURAAL_HEALER = "Healer: big group hit at {SPELL:1263304}.",

	DGN_TIP_ST_SAPRISH_STEPS = "1. Void Bombs ({SPELL:247175}) land on player spots — do NOT touch them; drop them at the edges.|n2. {SPELL:1280064}: shades dash at every player and detonate bombs they cross — angle your dash line clear of bombs.|n3. {SPELL:1263523} ignites ALL bombs at once — the fewer bombs, the gentler it gets.|n4. Kick Shadewing's {SPELL:248831} (group hit + disorient).",
	DGN_TIP_ST_SAPRISH_TANK = "Tank: keep the trio together; Darkfang's pounce ({SPELL:245738}) leaves its victim bleeding.",
	DGN_TIP_ST_SAPRISH_HEALER = "Healer: pounce victims bleed; group burst at {SPELL:1263523}.",

	DGN_TIP_ST_NEZHAR_STEPS = "1. {SPELL:1263528} knocks everyone back — watch your footing near storms.|n2. {SPELL:1263538} and the {SPELL:1277358} add chaos — kill tentacles, dodge the Umbral Waves from the gate.|n3. {SPELL:1263532} zones tick hard, inside is worse — out, fast.|n4. {SPELL:244750} nukes the tank — kick it when you can.",
	DGN_TIP_ST_NEZHAR_TANK = "Tank: brace for {SPELL:244750} whenever a kick is down.",
	DGN_TIP_ST_NEZHAR_HEALER = "Healer: {SPELL:1263542} = several rot DoTs ticking at once.",

	DGN_TIP_ST_LURA_STEPS = "1. Notes of Despair keep radiating ({SPELL:1265421}) until silenced — steer your {SPELL:1265426} THROUGH the notes (it also hits allies in the line, so angle it clear of them).|n2. {SPELL:1265689}: 20 seconds of pain around every active note — break notes fast.|n3. {SPELL:1264151}: rotating void beams — move with the gaps.|n4. {SPELL:1266003} is a deadly 10-second channel — every defensive you have, and heal through it.",
	DGN_TIP_ST_LURA_TANK = "Tank: after {SPELL:1266001} everyone gets knocked around — regroup quickly.",
	DGN_TIP_ST_LURA_HEALER = "Healer: {SPELL:1265421} group hits plus note auras — breaking notes IS the healing plan.",

	-- Algeth'ar Academy ----------------------------------------------------------------
	DGN_TIP_AA_VEXAMUS_STEPS = "1. {SPELL:385974} drift toward the boss — soak them, one player each (small hit); every orb HE absorbs blasts the whole group.|n2. {SPELL:386173}: carry yours out — it pops into a {SPELL:386201} pool.|n3. Full energy = {SPELL:388537}: group hit plus repeated eruptions under players — keep moving.",
	DGN_TIP_AA_VEXAMUS_TANK = "Tank: {SPELL:385958} bursts everything in front of him — defensive, face him away.",
	DGN_TIP_AA_VEXAMUS_HEALER = "Healer: bomb carriers tick; group damage for every orb that reaches the boss.",

	DGN_TIP_AA_ANCIENT_STEPS = "1. {SPELL:388796}: seeds erupt under everyone for 4 seconds — dodge; missed seeds leave dormant Lashers.|n2. At full energy ({SPELL:388923}) ALL dormant Lashers wake at once — clear them beforehand.|n3. {SPELL:388623} throws a branch that becomes a big add — kill it and KICK its {SPELL:396640}.",
	DGN_TIP_AA_ANCIENT_TANK = "Tank: {SPELL:388544} doubles the physical damage you take — defensive every time.",
	DGN_TIP_AA_ANCIENT_HEALER = "Healer: cleanse {SPELL:389033} (poison) before it stacks high.",

	DGN_TIP_AA_CRAWTH_STEPS = "1. {SPELL:377004} erupts under every player and interrupts casts — STOP casting, then spread.|n2. {SPELL:377034}: she eyes someone and wing-blasts a cone that way — step out.|n3. {SPELL:377182}: score in a goal — the fire goal stuns her and she takes 75% extra damage.",
	DGN_TIP_AA_CRAWTH_TANK = "Tank: defensive for {SPELL:376997} (hit + 10s bleed).",
	DGN_TIP_AA_CRAWTH_HEALER = "Healer: heavy group damage after the screech; the tank bleeds.",

	DGN_TIP_AA_DORAGOSA_STEPS = "1. {SPELL:374341} on you? Walk it away from the group — it bursts 8 yards wide.|n2. {SPELL:388820} drags everyone in, then explodes — RUN OUT before the blast.|n3. {SPELL:389011} stacks from every mechanic you eat — at 3 stacks it bursts into an Arcane Rift; stay clean.|n4. Stay off the {SPELL:389007} ground.",
	DGN_TIP_AA_DORAGOSA_TANK = "Tank: defensive for {SPELL:1282251}.",
	DGN_TIP_AA_DORAGOSA_HEALER = "Healer: watch {SPELL:389011} stacks — carriers tick harder per stack.",
})

merge(ns._mhLocales and ns._mhLocales.nlNL, {
	-- Windrunner Spire ----------------------------------------------------------
	DGN_TIP_WS_DUO_STEPS = "1. Twee bosses — beschadig ze gelijkmatig zodat ze ongeveer tegelijk doodgaan.|n2. Interrupt Shadow Bolt; stap uit de spuugcirkels ({SPELL:472745}) — verspil geen vloerruimte.|n3. Vervloekt ({SPELL:474105})? Laat 'm snel dispellen — of CC de Dark Entity die eruit spawnt tot 'ie verdwijnt.|n4. Gegrepen door {SPELL:472793} tijdens de schreeuw? Ga zo staan dat je DWARS DOOR de spookdame getrokken wordt — dat breekt haar cast.",
	DGN_TIP_WS_DUO_TANK = "Tank: defensive voor {SPELL:472888}; verplaats de bosses als de vloer te vol raakt.",
	DGN_TIP_WS_DUO_HEALER = "Healer: veel groepsschade tijdens {SPELL:472736}; dispel {SPELL:474105} snel.",

	DGN_TIP_WS_EMBER_STEPS = "1. Vuur = slecht. Leg de vuurplassen ({SPELL:466556}) aan de randen, houd het midden schoon.|n2. Op volle energie: ren NAAR de boss voor {SPELL:465904} en stap daarna elke Fire Breath opzij.|n3. Oude plassen spawnen vuurhozen — blijf ontwijken.",
	DGN_TIP_WS_EMBER_TANK = "Tank: defensive voor {SPELL:466064}.",
	DGN_TIP_WS_EMBER_HEALER = "Healer: zware groepsschade tijdens {SPELL:465904}.",

	DGN_TIP_WS_KROLUK_STEPS = "1. Bruine cirkels = slecht, stap eruit.|n2. Ga bij een maatje staan vóór {SPELL:1253026} afloopt (overlap de paarse cirkels).|n3. Gefixeerd of doelwit van de sprong ({SPELL:1283247})? Ren 'm wég van de groep.|n4. Spawnen er adds (rond tweederde en eenderde health): maak ze snel dood — de Phantasmal Mystic eerst, en blijf 'm interrupten.",
	DGN_TIP_WS_KROLUK_TANK = "Tank: defensive voor {SPELL:467620}; sta klaar om de tweede {SPELL:1283247} op te vangen.",
	DGN_TIP_WS_KROLUK_HEALER = "Healer: groepsschade tijdens {SPELL:472043}.",

	DGN_TIP_WS_HEART_STEPS = "1. Tikken de {SPELL:1216042}-stacks op je? Stap op een windpijl (Turbulent Arrow) bij 2-3 stacks — die haalt de DoT weg én springt je over de uitdijende schokgolf.|n2. Houd één pijl over voor de grote knal op volle energie ({SPELL:468429}).|n3. Spreid licht voor {SPELL:1253979} en gebruik de grote cirkels om de elektrische vloer schoon te vegen.|n4. Doelwit van {SPELL:474528}? Blijf stilstaan en laat de rest wegstappen; iedereen anders: uit de frontal.",
	DGN_TIP_WS_HEART_TANK = "Tank: defensive voor {SPELL:472662}; richt de knockback wég van de plassen.",
	DGN_TIP_WS_HEART_HEALER = "Healer: spelers met hoge {SPELL:1216042}-stacks eerst bijhealen; extra healing na {SPELL:1253979}.",

	-- Maisara Caverns -------------------------------------------------------------
	DGN_TIP_MC_MUROJIN_STEPS = "1. Twee bosses (jager en vogel) — maak ze dicht bij elkaar dood, anders gaat de overlever berserk.|n2. IJsvallen ({SPELL:1243741}), groene cirkels ({SPELL:1243900}) en de frontale {SPELL:1260643} = slecht, blijf eruit.|n3. Doelwit van {SPELL:1249478} (de duikvlucht)? Ren een ijsval IN — de freeze stopt de duik. De rest: weg bij die speler.",
	DGN_TIP_MC_MUROJIN_TANK = "Tank: defensive voor {SPELL:1266480}.",
	DGN_TIP_MC_MUROJIN_HEALER = "Healer: dispel {SPELL:1246666} (disease) — zware groepsschade.",

	DGN_TIP_MC_VORDAZA_STEPS = "1. De boss spawnt Unstable Phantoms ({SPELL:1251204}) die spelers achtervolgen. MAAK ZE DOOD vóór ze iemand bereiken — een fantoom dat zijn doelwit bereikt (of een ander fantoom raakt) knalt voor zware schade in de buurt.|n2. Elk gedood fantoom schreeuwt: onvermijdbare groepsschade — dood ze dus ÉÉN tegelijk.|n3. Ontwijk de frontale golf van {SPELL:1252054} (die duwt je weg), de zwevende orbs en Soulrot.|n4. Zit iemand in een Deathshroud? Sla 'm er snel uit; interrupt {SPELL:1250708} en ontwijk de swirls ondertussen.",
	DGN_TIP_MC_VORDAZA_TANK = "Tank: defensive voor {SPELL:1251554}.",
	DGN_TIP_MC_VORDAZA_HEALER = "Healer: elk gedood fantoom schreeuwt ({SPELL:1251813}) = groepsschade — heal bij tussen de gespreide kills.",

	DGN_TIP_MC_RAKTUL_STEPS = "1. De boss springt naar drie spelers ({SPELL:1252676}) en laat Soulbind Totems achter — spreid zodat de totems uit elkaar landen, word niet geplet, en maak de totems snel dood.|n2. Blijf uit de Chill of Death-vloer.|n3. Zielfase ({SPELL:1253788}): je wordt uit je lichaam getrokken — CC en kick de grote adds terwijl je terugrent naar je lichaam.|n4. Ontwijk de swirls van het Deathgorged Vessel.",
	DGN_TIP_MC_RAKTUL_TANK = "Tank: defensive voor {SPELL:1251023}; leg de plassen wég van de groep.",
	DGN_TIP_MC_RAKTUL_HEALER = "Healer: zware groepsschade tijdens Deathgorged Vessel en wanneer totems breken.",

	-- Murder Row (batch 2 — geverifieerd via DBM-Party-Midnight + Wowhead) ------
	DGN_TIP_MR_KYSTIA_STEPS = "1. Kystia kloont zichzelf ({SPELL:1264095}) — CC of stun de kopieën; ze channelen allemaal Felstorm.|n2. {SPELL:474240}: ze teleporteert naar een speler en ontploft met een knockback — weg uit de knal.|n3. Blijf uit Nibbles' {SPELL:1253813}-kegel (tikkend vuur).|n4. Wisselt Nibbles naar haar lichtvorm, dan channelt ze {SPELL:1230304} op Kystia — wissel dan van doelwit.",
	DGN_TIP_MR_KYSTIA_TANK = "Tank: houd Nibbles' {SPELL:1253813}-kegel van de groep af gericht.",
	DGN_TIP_MR_KYSTIA_HEALER = "Healer: piekschade als {SPELL:474240} landt; gestage schade op wie door Felstorm-kopieën geraakt wordt.",

	DGN_TIP_MR_ZAEN_STEPS = "1. {SPELL:474545}: hij schiet iedereen in zijn ZICHTLIJN — verbreek die: duik achter de kratten en pilaren vóór het schot (laat ook een bleed van 15s achter).|n2. {SPELL:474765}: vracht regent op spelers en slingert je weg — stap uit de markers.|n3. {SPELL:474478}: 3 seconden zwaar vuur op de hele groep — sta vol, gebruik een defensive.|n4. Ontwijk de Fire Bombs ({SPELL:1214352}).",
	DGN_TIP_MR_ZAEN_TANK = "Tank: defensive voor {SPELL:1222795}.",
	DGN_TIP_MR_ZAEN_HEALER = "Healer: groep vol vóór {SPELL:474478}; bleeds tikken op iedereen die het schot ving.",

	DGN_TIP_MR_XATHUUX_STEPS = "1. {SPELL:1214637} is op een speler gericht — neem 'm wég van de groep en stap uit de inslag.|n2. {SPELL:474197}: zware schade op iedereen — defensives en blijf bewegen.|n3. Grote tank-klappen ({SPELL:473898}) — gun de healer rust eromheen.",
	DGN_TIP_MR_XATHUUX_TANK = "Tank: defensive voor {SPELL:473898}.",
	DGN_TIP_MR_XATHUUX_HEALER = "Healer: groepsschade tijdens {SPELL:474197}.",

	DGN_TIP_MR_LITHIEL_STEPS = "1. {SPELL:1218203}: spreid (6+ yards) — elke inslag spawnt Wild Imps; maak de imps snel dood.|n2. Dood de opgeroepen Vilefiend ({SPELL:474408}) vóór de volgende imp-golf.|n3. {SPELL:1224478}: ze schildt zichzelf en stuurt een golf fel-vuur door de zaal — gebruik de gateway om eraan te ontsnappen (de hit stapelt +50% vuurschade, en demonen die 'm vangen worden versterkt).",
	DGN_TIP_MR_LITHIEL_TANK = "Tank: pak de Vilefiend en de imps snel op.",
	DGN_TIP_MR_LITHIEL_HEALER = "Healer: wie {SPELL:1224478} ving krijgt stapelende vuurschade — houd ze hoog.",

	-- Den of Nalorakk -----------------------------------------------------------
	DGN_TIP_DN_HOARDMONGER_STEPS = "1. {SPELL:1234233}: 7 seconden lang regent er rot voedsel dat Rotten Mushrooms achterlaat — ontwijk de inslagen en blijf van de paddenstoelen af.|n2. {SPELL:1253268} is een frontale kegel — sta nooit voor 'm.|n3. {SPELL:1235118} raakt iedereen (negeert armor) — sta vol.",
	DGN_TIP_DN_HOARDMONGER_TANK = "Tank: de frontal volgt jou — richt de boss van de groep af.",
	DGN_TIP_DN_HOARDMONGER_HEALER = "Healer: groepsheal na elke {SPELL:1235118}.",

	DGN_TIP_DN_SENTINEL_STEPS = "1. Raging Squalls ({SPELL:1235623}) dwalen lang door de arena — blijf eromheen laveren.|n2. {SPELL:1235783}-ijspegels slaan in en onthullen een Fractured Shivercore — sloop die.|n3. {SPELL:1235656}: een ijssluier absorbeert schade terwijl de storm iedereen wegduwt en op de groep tikt — breek het schild SNEL.",
	DGN_TIP_DN_SENTINEL_TANK = "Tank: houd de boss weg van de squalls.",
	DGN_TIP_DN_SENTINEL_HEALER = "Healer: dispel/heal door {SPELL:1235548} heen (16s frost-DoT); iedereen tikt tijdens {SPELL:1235656}.",

	DGN_TIP_DN_NALORAKK_STEPS = "1. {SPELL:1243011}: Nalorakk beukt Zul'jarra neer en geestberen stormen op haar af — ga in hun pad staan om ze te onderscheppen (elke beer die haar bereikt = een nare scream).|n2. {SPELL:1255385} duwt iedereen weg — let op je positie bij gevaar.|n3. {SPELL:1243569} versnippert de tank 4 seconden lang — help met externals als je ze hebt.",
	DGN_TIP_DN_NALORAKK_TANK = "Tank: {SPELL:1243569} = stapelende klappen, +50% schade per hit — grote defensive, élke keer.",
	DGN_TIP_DN_NALORAKK_HEALER = "Healer: de tank piekt hard tijdens {SPELL:1243569}; groepsheal na elke roar.",

	-- The Blinding Vale -----------------------------------------------------------
	DGN_TIP_BV_TRINITY_STEPS = "1. Drie bosses tegelijk — volg de target-volgorde van je tank.|n2. Lekshi dasht tussen de loam-plekken ({SPELL:1234850}) en zaait onderweg Lightblossom-zaden — blijf uit de dash-paden.|n3. Kezkitt beamt elk zaadje ({SPELL:1235564}): GA IN de beam staan om de groei te stoppen (een ongesoakt zaadje groeit na 10 seconden uit).|n4. Meittik slaat de tank hard ({SPELL:1234753}).",
	DGN_TIP_BV_TRINITY_TANK = "Tank: defensive voor {SPELL:1234753}; let op Lekshi's {SPELL:1261276}.",
	DGN_TIP_BV_TRINITY_HEALER = "Healer: beam-soakers krijgen gestage Holy-schade — houd ze op de been.",

	DGN_TIP_BV_IKUZZ_STEPS = "1. {SPELL:1236746} slingert iedereen weg en er ontkiemen wortels waar spelers staan — leg ze aan de randen.|n2. {SPELL:1237091}: hij fixeert en jaagt 10 seconden op een speler — rennen, laat 'm je niet bereiken.|n3. Blijf de doorn-erupties ontwijken ({SPELL:1236709}).",
	DGN_TIP_BV_IKUZZ_TANK = "Tank: pak 'm direct weer op zodra de jacht stopt.",
	DGN_TIP_BV_IKUZZ_HEALER = "Healer: houd de opgejaagde speler gezond — gepakt worden doet pijn.",

	DGN_TIP_BV_RUIA_STEPS = "1. De warden wisselt van vorm (beer, moonkin, haranir) — elk met eigen streken.|n2. Ontwijk de {SPELL:1240098}-inslagcirkels.|n3. {SPELL:1241058} laat een bleed achter die pas stopt als het doelwit VOL geheald is — roep het af.|n4. Eindfase ({SPELL:1241067}): alles komt om de paar seconden — bewaar cooldowns en blijf bewegen.",
	DGN_TIP_BV_RUIA_TANK = "Tank: beervorm slaat het hardst — defensive voor {SPELL:1240222}.",
	DGN_TIP_BV_RUIA_HEALER = "Healer: {SPELL:1241058} bloedt tot de speler op VOLLE health staat — meteen bijtoppen.",

	DGN_TIP_BV_ZIEKKET_STEPS = "1. Lightbloom-orbs ({SPELL:1246858}) zweven naar Ziekket — raak ze aan om ze te laten knappen vóór ze 'm bereiken.|n2. Lightspawn Lashers blijven ontkiemen ({SPELL:1246372}, en slapende ontwaken weer) — maak ze écht dood.|n3. Let op je voeten voor {SPELL:1246753} en pas op de {SPELL:1253690}.",
	DGN_TIP_BV_ZIEKKET_TANK = "Tank: defensive voor {SPELL:1247685}; pak de lashers op.",
	DGN_TIP_BV_ZIEKKET_HEALER = "Healer: gestage groepsschade — verwacht een piek als er een orb doorglipt.",

	-- Voidscar Arena ----------------------------------------------------------------
	DGN_TIP_VA_TAZRAH_STEPS = "1. {SPELL:1222274} zuigt iedereen 6 seconden naar zich toe — ren tegen de trek in; het centrum doet vreselijk pijn.|n2. Na elke teleport ({SPELL:1262901}) vallen Ethereal Shades aan — brand ze weg.|n3. Ontwijk de {SPELL:1225011}.",
	DGN_TIP_VA_TAZRAH_TANK = "Tank: defensive voor {SPELL:1222085}.",
	DGN_TIP_VA_TAZRAH_HEALER = "Healer: de rift tikt op iedereen terwijl ze rennen — houd de groep stabiel.",

	DGN_TIP_VA_ATROXUS_STEPS = "1. Toxic Creepers ({SPELL:1222371}) kruipen uit de poelen — maak ze snel dood.|n2. Blijf uit de {SPELL:1263977}-frontal en de {SPELL:1226120}-cirkels.|n3. {SPELL:1262497} slingert je weg — sta niet met een poel achter je.",
	DGN_TIP_VA_ATROXUS_TANK = "Tank: defensive voor {SPELL:1222642}; richt de breath van de groep af.",
	DGN_TIP_VA_ATROXUS_HEALER = "Healer: pre-heal vóór {SPELL:1262497}; gif tikt op onoplettende voeten.",

	DGN_TIP_VA_CHARONUS_STEPS = "1. Een Gravitic Orb ({SPELL:1263982}) achtervolgt elke speler — kite de jouwe naar een Unstable Singularity ({SPELL:1282770}; binnen 6 yards knapt 'ie).|n2. {SPELL:1227264}: iedereen vliegt weg plus een DoT van 20 seconden — kies veilige grond vóór de klap.|n3. Ontwijk de {SPELL:1222758}-projectielen (raken = schade + knockback).",
	DGN_TIP_VA_CHARONUS_TANK = "Tank: rustige positionering — geef spelers ruimte om hun orbs te kiten.",
	DGN_TIP_VA_CHARONUS_HEALER = "Healer: na {SPELL:1227264} draagt de hele groep een lange DoT — daar de grote heals.",

	-- Nexus-Point Xenas ---------------------------------------------------------------
	DGN_TIP_NX_KASRETH_STEPS = "1. {SPELL:1251785} op jou? Stap IN een leyline-straal ({SPELL:1251183}) — die haalt de debuff weg (korte stun, prima ruil).|n2. De rest: kruis de leylines NIET (schade + stapelende slow).|n3. Volle energie = {SPELL:1257509}: grote inslagzone, maak ruimte — daarna blijven arcane spills ({SPELL:1264048}) liggen.",
	DGN_TIP_NX_KASRETH_TANK = "Tank: houd de boss weg van de leylines.",
	DGN_TIP_NX_KASRETH_HEALER = "Healer: Sparkburn tikt op iedereen na elke detonatie.",

	DGN_TIP_NX_NYSARRA_STEPS = "1. Spreid — de klappen van {SPELL:1249020} splashen 14 yards.|n2. Maak de Null Vanguard-adds ({SPELL:1252703}) SNEL dood: wat nog leeft wordt verslonden ({SPELL:1271684}), healt haar en knalt op de groep.|n3. Ontwijk de {SPELL:1264439}.",
	DGN_TIP_NX_NYSARRA_TANK = "Tank: ze springt op je af met een slash-combo ({SPELL:1247937}) — defensive, zet je schrap voor de finisher.",
	DGN_TIP_NX_NYSARRA_HEALER = "Healer: spreidschade na {SPELL:1249020}; groepsknal als adds de verslinding overleven.",

	DGN_TIP_NX_LOTHRAXION_STEPS = "1. {SPELL:1255503}: spreid — inslagen splashen 8 yards en spawnen Fractured Images.|n2. {SPELL:1257567}: hij verstopt zich tussen zijn evenbeelden en allemaal channelen ze — vind de ÉCHTE Lothraxion en interrupt hem.|n3. Evenbeelden flikkeren rond met knockbacks ({SPELL:1255531}); blijf van de {SPELL:1255310} op de vloer.",
	DGN_TIP_NX_LOTHRAXION_TANK = "Tank: {SPELL:1255335} is een dubbele slash die littekens in de grond kerft — richt 'm van de groep af.",
	DGN_TIP_NX_LOTHRAXION_HEALER = "Healer: Holy-DoTs na elke {SPELL:1255503}; gestage schade tot de Guile-interrupt zit.",

	-- Magisters' Terrace ---------------------------------------------------------------
	DGN_TIP_MT_ARCANOTRON_STEPS = "1. Bij het bijtanken ({SPELL:474345}) worden Energy Orbs naar 'm toe getrokken — onderschep ze; ondertussen krijgt hij +20% schade: burst-window!|n2. Geketende spelers ({SPELL:1214038}) staan vastgeworteld (magic) — dispel of sla ze los.|n3. {SPELL:1214081} slingert iedereen weg en laat residu achter bij z'n voeten — stap eruit.",
	DGN_TIP_MT_ARCANOTRON_TANK = "Tank: {SPELL:474496} lanceert je — houd je rug vrij.",
	DGN_TIP_MT_ARCANOTRON_HEALER = "Healer: dispel {SPELL:1214038} (magic root) snel.",

	DGN_TIP_MT_SERANEL_STEPS = "1. {SPELL:1225193} pacificeert iedereen BUITEN de Suppression Zone ({SPELL:1224903}) — sta IN de zone tijdens de wave (maar de zone silencet je, dus blijf er niet hangen).|n2. Purge/spellsteal zijn {SPELL:1248689} (+100% attack speed) zodra die opstaat.|n3. {SPELL:1225787} stuitert naar een speler in de buurt — spreid.",
	DGN_TIP_MT_SERANEL_TANK = "Tank: een niet-gepurgde Ward verdubbelt zijn attack speed — defensive tot 'ie weg is.",
	DGN_TIP_MT_SERANEL_HEALER = "Healer: gemarkeerde spelers tikken; bedenk dat je in de zone niet kunt casten.",

	DGN_TIP_MT_GEMELLUS_STEPS = "1. {SPELL:1223847} (bij de start en op halve health): hij splitst in drieën.|n2. {SPELL:1253709}: gelinkt aan eentje? REN ernaartoe en raak 'm aan — dat verbreekt de link en sloopt zijn absorb-schild.|n3. {SPELL:1224299} trekt je naar binnen — ren er weer uit.",
	DGN_TIP_MT_GEMELLUS_TANK = "Tank: hergroepeer het drietal na elke {SPELL:1223847} zodat gelinkte spelers de hunne kunnen bereiken.",
	DGN_TIP_MT_GEMELLUS_HEALER = "Healer: gelinkte spelers krijgen +20% schade tot ze hun link verbreken.",

	DGN_TIP_MT_DEGENTRIUS_STEPS = "1. {SPELL:1215897}: void-DoTs met verschillende looptijden — loopt de jouwe af, dan schieten er Entropy Orbs vanaf JOUW plek: loop eerst weg van de groep.|n2. {SPELL:1215087} stuitert naar 4 plekken — SOAK een inslag (één speler per plek), anders barst 'ie in Void Destruction.|n3. {SPELL:1280113} verbrijzelt de tank en slingert iedereen binnen 8 yards weg — geef de tank ruimte.",
	DGN_TIP_MT_DEGENTRIUS_TANK = "Tank: defensive voor {SPELL:1280113}; tank 'm weg van de groep.",
	DGN_TIP_MT_DEGENTRIUS_HEALER = "Healer: Entropy-DoTs tikken hard — houd de dragers op de been terwijl ze verkassen.",

	-- Skyreach (batch 3 — Midnight-revamp abilities via DBM + Wowhead) ----------
	DGN_TIP_SR_RANJIT_STEPS = "1. {SPELL:1258148} vliegt in een rechte lijn voor 'm uit — stap opzij.|n2. {SPELL:156793}: een inslag in het midden plus dwalende windhozen die je lanceren — blijf laveren.|n3. {SPELL:153757} raakt iedereen met een bleed — sta vol.|n4. {SPELL:1252733} blaast zijn doelwitten weg — let op wat er achter je is.",
	DGN_TIP_SR_RANJIT_TANK = "Tank: houd 'm uit de vortex-paden.",
	DGN_TIP_SR_RANJIT_HEALER = "Healer: groepsschade plus bleeds na elke {SPELL:153757}.",

	DGN_TIP_SR_ARAKNATH_STEPS = "1. {SPELL:154162}: constructs stralen licht in de boss en HELEN hem — ga in een straal staan om 'm te blokkeren.|n2. {SPELL:154115}: een armslag aan één kant — geraakt worden stapelt een gemene damage-taken-debuff.|n3. {SPELL:154135} raakt iedereen — wees er klaar voor.",
	DGN_TIP_SR_ARAKNATH_TANK = "Tank: soak de stralen nooit zelf — zijn smash valt precies tijdens het soaken.",
	DGN_TIP_SR_ARAKNATH_HEALER = "Healer: straal-soakers tikken gestaag; groepsheal bij {SPELL:154135}.",

	DGN_TIP_SR_RUKHRAN_STEPS = "1. {SPELL:1253527}: 3 seconden veren alle kanten op — verbreek zichtlijn achter een pilaar.|n2. {SPELL:1253510} raakt de groep en summont een Sunwing die iemand fixeert en vuur pulseert — snel doden; gefixeerde speler houdt afstand.|n3. Herhaal — quills achter dekking, vogel snel neer.",
	DGN_TIP_SR_RUKHRAN_TANK = "Tank: defensive voor {SPELL:1253519} (grote klap + burn-DoT).",
	DGN_TIP_SR_RUKHRAN_HEALER = "Healer: pulserende groepsschade zolang een Sunwing leeft — roep om de kill.",

	DGN_TIP_SR_VIRYX_STEPS = "1. {SPELL:154396}: een cast van 3 seconden die de tank sloopt — KICK 'm, elke keer.|n2. {SPELL:1253998}: een Solar Zealot grijpt een speler om 'm van het balkon te gooien — bevrijd ze snel.|n3. {SPELL:1253531} op jou? Ren 'm ruim uit — hij laat Blazing Ground achter.",
	DGN_TIP_SR_VIRYX_TANK = "Tank: elke doorgelaten {SPELL:154396} doet zeer — houd de kick-volgorde strak.",
	DGN_TIP_SR_VIRYX_HEALER = "Healer: {SPELL:1253538} zet vuur-DoTs op meerdere spelers tegelijk.",

	-- Pit of Saron ----------------------------------------------------------------
	DGN_TIP_PS_GARFROST_STEPS = "1. {SPELL:1262029}: de smidse pulseert stapelende frost — VERSTOP JE ACHTER een brok saronite-erts, dat blokkeert de straling.|n2. {SPELL:1261546} beukt alles rond het main target — blijf 5+ yards van de tank; naast erts breekt de slag het erts in plaats van te stunnen.|n3. {SPELL:1261847} raakt iedereen en verbrijzelt AL het erts — nieuw erts volgt via {SPELL:1261286}.|n4. Blijf uit de {SPELL:1261799}.",
	DGN_TIP_PS_GARFROST_TANK = "Tank: parkeer jezelf naast een ertsbrok — {SPELL:1261546} sloopt dan het erts, niet jou.",
	DGN_TIP_PS_GARFROST_HEALER = "Healer: groepspiek bij {SPELL:1261847}; stapelende frost op iedereen zonder dekking.",

	DGN_TIP_PS_KRICKICK_STEPS = "1. {SPELL:1264363}: Ick fixeert en jaagt op een speler, en smijt onderweg Blight en Plague Globs — ren ruim; de rest blijft meppen.|n2. {SPELL:1264027}: Krick teleporteert naar een ritueelcirkel en summont Shades — switch en dood ze.|n3. {SPELL:1264336}: ontwijk de golf en de globs die op je afrollen.|n4. Sta nooit in de Blight ({SPELL:1264299}).",
	DGN_TIP_PS_KRICKICK_TANK = "Tank: {SPELL:1264287} legt een poel op jou — richt 'm naar de rand.",
	DGN_TIP_PS_KRICKICK_HEALER = "Healer: houd de opgejaagde speler op de been; groepsschade bij {SPELL:1264336}.",

	DGN_TIP_PS_TYRANNUS_STEPS = "1. {SPELL:1262772} bevriest Bone Piles rond zijn doelwit — sta bij stapels als je gemarkeerd bent: bevroren stapels kunnen geen adds leveren.|n2. {SPELL:1263406} wekt de overige stapels — Plaguespreaders eerst dood.|n3. Blijf {SPELL:1263756} en Rimefangs {SPELL:1276948} ontwijken.|n4. {SPELL:1276648} = groepsklap + DoT, en geïnfuseerde stapels leveren nare adds.",
	DGN_TIP_PS_TYRANNUS_TANK = "Tank: {SPELL:1262582} lanceert je en stapelt +200% shadow-schade — defensive en schrap zetten.",
	DGN_TIP_PS_TYRANNUS_HEALER = "Healer: groeps-DoTs na {SPELL:1276648}; tankpiek direct na Brand.",

	-- Seat of the Triumvirate --------------------------------------------------------
	DGN_TIP_ST_ZURAAL_STEPS = "1. {SPELL:1268916} raakt alles VOOR hem — sta nooit voor de boss.|n2. {SPELL:1263304} (volle energie): hij sleurt iedereen naar zich toe en barst dan met een knockback — ren op tijd uit; ook de adds worden meegezogen.|n3. {SPELL:1263399} spawnt Coalesced Void-adds — ruim ze vóór Crashing Void.|n4. {SPELL:1263282} laat Void Sludge ({SPELL:244588}) achter — houd de vloer schoon.",
	DGN_TIP_ST_ZURAAL_TANK = "Tank: defensive voor {SPELL:1263440} (driedubbele haal).",
	DGN_TIP_ST_ZURAAL_HEALER = "Healer: grote groepsklap bij {SPELL:1263304}.",

	DGN_TIP_ST_SAPRISH_STEPS = "1. Void Bombs ({SPELL:247175}) landen op spelersplekken — raak ze NIET aan; leg ze aan de randen.|n2. {SPELL:1280064}: schimmen dashen op elke speler af en detoneren bommen die ze kruisen — zorg dat jouw dash-lijn vrij van bommen loopt.|n3. {SPELL:1263523} ontsteekt ALLE bommen tegelijk — hoe minder bommen, hoe zachter.|n4. Kick Shadewings {SPELL:248831} (groepsklap + disorient).",
	DGN_TIP_ST_SAPRISH_TANK = "Tank: houd het drietal bijeen; Darkfangs pounce ({SPELL:245738}) laat zijn slachtoffer bloeden.",
	DGN_TIP_ST_SAPRISH_HEALER = "Healer: pounce-slachtoffers bloeden; groepsknal bij {SPELL:1263523}.",

	DGN_TIP_ST_NEZHAR_STEPS = "1. {SPELL:1263528} slingert iedereen weg — let op je positie bij stormen.|n2. {SPELL:1263538} en de {SPELL:1277358} zaaien chaos — dood tentakels, ontwijk de Umbral Waves uit de poort.|n3. {SPELL:1263532}-zones tikken hard, binnenin erger — eruit, snel.|n4. {SPELL:244750} sloopt de tank — kick 'm als het kan.",
	DGN_TIP_ST_NEZHAR_TANK = "Tank: zet je schrap voor {SPELL:244750} als de kick onderweg is.",
	DGN_TIP_ST_NEZHAR_HEALER = "Healer: {SPELL:1263542} = meerdere rot-DoTs tegelijk.",

	DGN_TIP_ST_LURA_STEPS = "1. Notes of Despair blijven stralen ({SPELL:1265421}) tot ze gesilencet zijn — stuur je {SPELL:1265426} DWARS DOOR de noten (de beam raakt ook teamgenoten in de lijn, dus mik vrij).|n2. {SPELL:1265689}: 20 seconden pijn rond elke actieve noot — breek noten snel.|n3. {SPELL:1264151}: roterende void-stralen — beweeg mee met de gaten.|n4. {SPELL:1266003} is een dodelijke channel van 10 seconden — alle defensives erop en doorhealen.",
	DGN_TIP_ST_LURA_TANK = "Tank: na {SPELL:1266001} vliegt iedereen — hergroepeer snel.",
	DGN_TIP_ST_LURA_HEALER = "Healer: {SPELL:1265421}-groepsklappen plus noot-aura's — noten breken IS het heal-plan.",

	-- Algeth'ar Academy ----------------------------------------------------------------
	DGN_TIP_AA_VEXAMUS_STEPS = "1. {SPELL:385974} zweven naar de boss — soak ze, één speler per orb (kleine tik); elke orb die HIJ absorbeert knalt op de hele groep.|n2. {SPELL:386173}: draag de jouwe weg — hij knapt in een {SPELL:386201}-poel.|n3. Volle energie = {SPELL:388537}: groepsklap plus herhaalde erupties onder spelers — blijf bewegen.",
	DGN_TIP_AA_VEXAMUS_TANK = "Tank: {SPELL:385958} knalt alles voor 'm weg — defensive, richt 'm van de groep af.",
	DGN_TIP_AA_VEXAMUS_HEALER = "Healer: bom-dragers tikken; groepsschade voor elke orb die de boss bereikt.",

	DGN_TIP_AA_ANCIENT_STEPS = "1. {SPELL:388796}: 4 seconden lang ontkiemen zaden onder iedereen — ontwijk; gemiste zaden laten slapende Lashers achter.|n2. Op volle energie ({SPELL:388923}) ontwaken ALLE slapende Lashers tegelijk — ruim ze van tevoren.|n3. {SPELL:388623} gooit een tak die een grote add wordt — dood 'm en KICK z'n {SPELL:396640}.",
	DGN_TIP_AA_ANCIENT_TANK = "Tank: {SPELL:388544} verdubbelt de physical schade die je krijgt — defensive, elke keer.",
	DGN_TIP_AA_ANCIENT_HEALER = "Healer: cleanse {SPELL:389033} (poison) vóór het hoog stapelt.",

	DGN_TIP_AA_CRAWTH_STEPS = "1. {SPELL:377004} erupteert onder elke speler en onderbreekt casts — STOP met casten, spreid daarna.|n2. {SPELL:377034}: ze kijkt iemand aan en vleugelt een kegel die kant op — stap eruit.|n3. {SPELL:377182}: scoor in een doel — het vuurdoel stunt haar en ze krijgt 75% extra schade.",
	DGN_TIP_AA_CRAWTH_TANK = "Tank: defensive voor {SPELL:376997} (klap + 10s bleed).",
	DGN_TIP_AA_CRAWTH_HEALER = "Healer: zware groepsschade na de screech; de tank bloedt.",

	DGN_TIP_AA_DORAGOSA_STEPS = "1. {SPELL:374341} op jou? Loop 'm weg van de groep — hij barst 8 yards breed.|n2. {SPELL:388820} sleurt iedereen naar binnen en explodeert dan — REN ERUIT vóór de knal.|n3. {SPELL:389011} stapelt van elke mechanic die je vangt — op 3 stacks barst het in een Arcane Rift; blijf schoon.|n4. Blijf van de {SPELL:389007}-grond.",
	DGN_TIP_AA_DORAGOSA_TANK = "Tank: defensive voor {SPELL:1282251}.",
	DGN_TIP_AA_DORAGOSA_HEALER = "Healer: let op {SPELL:389011}-stacks — dragers tikken harder per stack.",
})
