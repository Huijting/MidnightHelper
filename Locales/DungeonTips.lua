--[[
	Midnight Helper — Dungeon Coach boss-step bodies, ALL SIX locales
	(fase 6, 12 Jun: deDE/frFR/esES/ptBR toegevoegd — 129 keys ×6).
	Line breaks |n.

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
	DGN_TIP_AA_ANCIENT_DPS = "DPS: Clear the dormant Lashers before full energy, or they all wake at once. Kill the thrown branch add and kick its cast.",
	DGN_TIP_AA_CRAWTH_DPS = "DPS: Stop casting when the ground erupts - it interrupts you anyway - then spread. Score in the fire goal: it stuns her and she takes 75% extra damage.",
	DGN_TIP_AA_DORAGOSA_DPS = "DPS: Walk your debuff away from the group; it bursts 8 yards wide. Every mechanic you eat stacks, and at 3 it becomes an Arcane Rift.",
	DGN_TIP_AA_VEXAMUS_DPS = "DPS: Soak the orbs one player each: every orb he absorbs blasts the whole group. Carry your own bolt out before it pools.",
	DGN_TIP_BV_IKUZZ_DPS = "DPS: Drop your roots at the edges. Fixated? Just run for the full 10 seconds - you cannot fight it off.",
	DGN_TIP_BV_RUIA_DPS = "DPS: Each form brings its own trick, so watch what she becomes. Hold your cooldowns for the endgame, when everything fires at once.",
	DGN_TIP_BV_TRINITY_DPS = "DPS: Follow the tank's target order, and stand in Kezkitt's beams - an unsoaked seed overgrows after 10 seconds.",
	DGN_TIP_BV_ZIEKKET_DPS = "DPS: Burst the Lightbloom orbs before they drift into Ziekket, and finish the Lashers properly - dormant ones wake back up.",
	DGN_TIP_DN_HOARDMONGER_DPS = "DPS: No adds and no switches: this is a stay-out-of-things fight. Never stand in the frontal, keep off the mushrooms.",
	DGN_TIP_DN_NALORAKK_DPS = "DPS: Bodies beat damage here: stand in the spirit bears' path to intercept them. Every bear that reaches Zul'jarra costs the group.",
	DGN_TIP_DN_SENTINEL_DPS = "DPS: Two burn checks: destroy the Fractured Shivercore the icicles reveal, and break the frozen veil fast - it ticks on the group until it drops.",
	DGN_TIP_MC_MUROJIN_DPS = "DPS: Both bosses have to die close together - watch the two health bars and swap early, because a lone survivor goes berserk.",
	DGN_TIP_MC_RAKTUL_DPS = "DPS: Kill the Soulbind Totems fast. During the soul phase, crowd-control and interrupt the big adds while everyone runs back to their body.",
	DGN_TIP_MC_VORDAZA_DPS = "DPS: The phantoms are your job: kill them before they reach anyone, but one at a time - every death is group damage nobody can dodge.",
	DGN_TIP_MR_KYSTIA_DPS = "DPS: Stun or crowd-control the clones - they all channel Felstorm. Switch to Nibbles when she turns to her light form.",
	DGN_TIP_MR_LITHIEL_DPS = "DPS: Spread 6+ yards, then clear the Wild Imps quickly. The Vilefiend has to be down before the next imp wave.",
	DGN_TIP_MR_XATHUUX_DPS = "DPS: Little to switch to here - take your bolt away from the group, then keep moving and keep your defensives for the group hits.",
	DGN_TIP_MR_ZAEN_DPS = "DPS: Line of sight is the whole fight: be behind a crate or pillar before the shot, not after it.",
	DGN_TIP_MT_ARCANOTRON_DPS = "DPS: Intercept the Energy Orbs during the refuel, and save your cooldowns for it: he takes +20% damage in that window.",
	DGN_TIP_MT_DEGENTRIUS_DPS = "DPS: Soak one Unstable Void Essence impact each, or it erupts. When your Entropy DoT is about to expire, walk out of the group first.",
	DGN_TIP_MT_GEMELLUS_DPS = "DPS: Linked to a copy? Run over and touch it - that breaks the link and strips his absorb shield. Damage into the shield is wasted.",
	DGN_TIP_MT_SERANEL_DPS = "DPS: Purge or spellsteal the Hastening Ward every time it lands. Step into the Suppression Zone for the wave, then get out - it silences you.",
	DGN_TIP_NX_KASRETH_DPS = "DPS: Clear your debuff by stepping into a leyline beam - the short stun costs less than keeping it. Otherwise never cross a leyline.",
	DGN_TIP_NX_LOTHRAXION_DPS = "DPS: When he hides among his images, find the real one and interrupt him - damage on the images is wasted.",
	DGN_TIP_NX_NYSARRA_DPS = "DPS: The Null Vanguard adds are the fight: anything still standing gets devoured, which heals her and bursts the group. Spread first, the strikes splash 14 yards.",
	DGN_TIP_PS_GARFROST_DPS = "DPS: Ore is cover: get behind a chunk for the forge pulse. Stay 5+ yards off the tank so the slam does not catch you too.",
	DGN_TIP_PS_KRICKICK_DPS = "DPS: When Krick teleports to a ritual circle, switch to the Shades. Fixated by Ick? Run wide - everyone else keeps hitting.",
	DGN_TIP_PS_TYRANNUS_DPS = "DPS: Marked? Stand near Bone Piles so they freeze; frozen piles cannot raise adds. When piles do rise, Plaguespreaders die first.",
	DGN_TIP_SR_ARAKNATH_DPS = "DPS: Block the construct beams with your body - every beam that lands heals him back up.",
	DGN_TIP_SR_RANJIT_DPS = "DPS: A positional fight, not a target one: step aside for the line, weave around the vortexes, and mind what is behind you when it blasts.",
	DGN_TIP_SR_RUKHRAN_DPS = "DPS: Quills mean a pillar, every time. Then kill the Sunwing quickly; whoever it fixates keeps their distance.",
	DGN_TIP_SR_VIRYX_DPS = "DPS: Kick the tank nuke every single time - it is a 3-second cast. Free anyone the Solar Zealot grabs before they go off the balcony.",
	DGN_TIP_ST_LURA_DPS = "DPS: Steer your beam through the Notes of Despair - they keep radiating until silenced - and angle it clear of allies, because it hits them too.",
	DGN_TIP_ST_NEZHAR_DPS = "DPS: Kill the tentacles and kick the tank nuke when you can. The zones tick hard, so get out fast rather than pushing for uptime.",
	DGN_TIP_ST_SAPRISH_DPS = "DPS: Kick Shadewing's cast, and drop your Void Bombs at the edges - the fewer bombs on the floor, the gentler the mass ignite.",
	DGN_TIP_ST_ZURAAL_DPS = "DPS: Clear the Coalesced Void adds before Crashing Void, or they get dragged in with you. Never stand in front of him.",
	DGN_TIP_VA_ATROXUS_DPS = "DPS: Kill the Toxic Creepers as they crawl out - the pools keep making more.",
	DGN_TIP_VA_CHARONUS_DPS = "DPS: Kite your own Gravitic Orb into an Unstable Singularity; inside 6 yards it dies. Pick safe ground before the knockback lands.",
	DGN_TIP_VA_TAZRAH_DPS = "DPS: After every teleport, burn the Ethereal Shades down before going back to the boss.",
	DGN_TIP_WS_DUO_DPS = "DPS: Split your damage so both die close together, and keep Shadow Bolt interrupted. Crowd-control the Dark Entity a curse spawns instead of chasing it down.",
	DGN_TIP_WS_EMBER_DPS = "DPS: Drop your fire puddles at the edges so the middle stays clean, and sidestep the breath rather than running out of range.",
	DGN_TIP_WS_HEART_DPS = "DPS: Take a windy arrow at 2-3 stacks, but leave one free for the full-energy blast.",
	DGN_TIP_WS_KROLUK_DPS = "DPS: Adds come at roughly two thirds and one third health: swap straight onto them, Phantasmal Mystic first, and keep it interrupted.",
})

merge(ns._mhLocales and ns._mhLocales.itIT, {
	-- Windrunner Spire ---------------------------------------------------------
	DGN_TIP_WS_DUO_STEPS = "1. Due boss — danneggiali in modo uniforme così muoiono più o meno insieme.|n2. Interrompi Shadow Bolt; esci dai cerchi di vomito ({SPELL:472745}) — non sprecare spazio sul pavimento.|n3. Cursed ({SPELL:474105})? Falla dispellare in fretta — oppure CC la Dark Entity che genera finché non svanisce.|n4. Agganciato da {SPELL:472793} durante l'urlo? Posizionati in modo da venire tirato ATTRAVERSO la dama spettrale — questo interrompe il suo cast.",
	DGN_TIP_WS_DUO_TANK = "Tank: difensiva per {SPELL:472888}; sposta i boss quando il pavimento si affolla.",
	DGN_TIP_WS_DUO_HEALER = "Healer: grandi danni al gruppo durante {SPELL:472736}; dispella {SPELL:474105} in fretta.",

	DGN_TIP_WS_EMBER_STEPS = "1. Fuoco = male. Posiziona le pozze di fuoco ({SPELL:466556}) ai bordi, tieni pulito il centro.|n2. A piena energia corri VERSO il boss per {SPELL:465904}, poi schiva di lato ogni Fire Breath.|n3. Le vecchie pozze generano vortici di fuoco — continua a schivare.",
	DGN_TIP_WS_EMBER_TANK = "Tank: difensiva per {SPELL:466064}.",
	DGN_TIP_WS_EMBER_HEALER = "Healer: forti danni al gruppo durante {SPELL:465904}.",

	DGN_TIP_WS_KROLUK_STEPS = "1. Cerchi marroni = male, esci.|n2. Raggruppati con un alleato prima che {SPELL:1253026} finisca (sovrapponi i cerchi viola).|n3. Fissato o bersaglio del balzo ({SPELL:1283247})? Portalo lontano dal gruppo.|n4. Quando spawnano gli add (a circa due terzi e un terzo di health): uccidili in fretta — prima il Phantasmal Mystic, e continua a interromperlo.",
	DGN_TIP_WS_KROLUK_TANK = "Tank: difensiva per {SPELL:467620}; sii pronto a prendere il secondo {SPELL:1283247}.",
	DGN_TIP_WS_KROLUK_HEALER = "Healer: danni al gruppo durante {SPELL:472043}.",

	DGN_TIP_WS_HEART_STEPS = "1. Stack di {SPELL:1216042} che ticchettano su di te? Cammina su una freccia di vento (Turbulent Arrow) a 2-3 stack — rimuove il DoT e ti fa saltare oltre l'onda d'urto in espansione.|n2. Tieni una freccia libera per la grande esplosione a piena energia ({SPELL:468429}).|n3. Distanziati un po' per {SPELL:1253979} e usa i cerchi grandi per ripulire il terreno elettrico.|n4. Bersaglio di {SPELL:474528}? Resta fermo e lascia che gli altri si spostino; tutti gli altri: uscite dal frontale.",
	DGN_TIP_WS_HEART_TANK = "Tank: difensiva per {SPELL:472662}; orienta il knockback lontano dalle pozze.",
	DGN_TIP_WS_HEART_HEALER = "Healer: cura prima i giocatori con tanti stack di {SPELL:1216042}; cure extra dopo {SPELL:1253979}.",

	-- Maisara Caverns ------------------------------------------------------------
	DGN_TIP_MC_MUROJIN_STEPS = "1. Due boss (cacciatore e uccello) — uccidili a breve distanza l'uno dall'altro, o il sopravvissuto va in berserk.|n2. Trappole di ghiaccio ({SPELL:1243741}), cerchi verdi ({SPELL:1243900}) e il frontale {SPELL:1260643} = male, stai fuori.|n3. Bersaglio di {SPELL:1249478} (la picchiata dell'uccello)? Corri DENTRO una trappola di ghiaccio — il congelamento ferma la picchiata. Tutti gli altri: allontanatevi da quel giocatore.",
	DGN_TIP_MC_MUROJIN_TANK = "Tank: difensiva per {SPELL:1266480}.",
	DGN_TIP_MC_MUROJIN_HEALER = "Healer: dispella {SPELL:1246666} (malattia) — forti danni al gruppo.",

	DGN_TIP_MC_VORDAZA_STEPS = "1. Il boss genera Unstable Phantoms ({SPELL:1251204}) che inseguono i giocatori. UCCIDILI prima che raggiungano qualcuno — un fantasma che raggiunge il suo bersaglio (o tocca un altro fantasma) esplode con forti danni nelle vicinanze.|n2. Ogni fantasma ucciso urla: danni al gruppo inevitabili — quindi uccidili UNO alla volta.|n3. Schiva l'ondata frontale di {SPELL:1252054} (ti spinge via), gli orb fluttuanti e Soulrot.|n4. Qualcuno avvolto in un Deathshroud? Liberalo in fretta; interrompi {SPELL:1250708} e schiva i vortici durante.",
	DGN_TIP_MC_VORDAZA_TANK = "Tank: difensiva per {SPELL:1251554}.",
	DGN_TIP_MC_VORDAZA_HEALER = "Healer: ogni fantasma ucciso urla ({SPELL:1251813}) = danni al gruppo — cura tra le uccisioni scaglionate.",

	DGN_TIP_MC_RAKTUL_STEPS = "1. Il boss balza su tre giocatori ({SPELL:1252676}) e lascia Soulbind Totems — distanziatevi così i totem atterrano separati, non farti schiacciare, e uccidi i totem in fretta.|n2. Stai fuori dal terreno di Chill of Death.|n3. Fase dell'anima ({SPELL:1253788}): vieni estratto dal tuo corpo — CC e interrompi i grandi add mentre corri verso il tuo corpo.|n4. Schiva i vortici della Deathgorged Vessel.",
	DGN_TIP_MC_RAKTUL_TANK = "Tank: difensiva per {SPELL:1251023}; posiziona le pozze lontano dal gruppo.",
	DGN_TIP_MC_RAKTUL_HEALER = "Healer: forti danni al gruppo durante la Deathgorged Vessel e quando i totem si frantumano.",

	-- Murder Row ----------------------------------------------------------------
	DGN_TIP_MR_KYSTIA_STEPS = "1. Kystia si clona ({SPELL:1264095}) — CC o stunna le copie; tutte canalizzano Felstorm.|n2. {SPELL:474240}: si teletrasporta su un giocatore ed esplode con un knockback — esci dall'esplosione.|n3. Stai fuori dal cono {SPELL:1253813} di Nibbles (fuoco che ticchetta).|n4. Quando Nibbles passa alla sua forma di luce canalizza {SPELL:1230304} su Kystia — cambia bersaglio quando succede.",
	DGN_TIP_MR_KYSTIA_TANK = "Tank: tieni il cono {SPELL:1253813} di Nibbles puntato lontano dal gruppo.",
	DGN_TIP_MR_KYSTIA_HEALER = "Healer: picco di danni quando atterra {SPELL:474240}; danni costanti su chi viene colpito dalle copie di Felstorm.",

	DGN_TIP_MR_ZAEN_STEPS = "1. {SPELL:474545}: spara a tutti quelli nella sua LINEA DI VISTA — spezzala: nasconditi dietro le casse e i pilastri prima del colpo (lascia anche un bleed di 15s).|n2. {SPELL:474765}: il carico piove sui giocatori e ti respinge — esci dai segnalini.|n3. {SPELL:474478}: 3 secondi di forte fuoco su tutto il gruppo — sii al massimo, usa una difensiva.|n4. Schiva le Fire Bomb ({SPELL:1214352}).",
	DGN_TIP_MR_ZAEN_TANK = "Tank: difensiva per {SPELL:1222795}.",
	DGN_TIP_MR_ZAEN_HEALER = "Healer: porta il gruppo al massimo prima di {SPELL:474478}; i bleed ticchettano su chi viene colpito da {SPELL:474545}.",

	DGN_TIP_MR_XATHUUX_STEPS = "1. {SPELL:1214637} è puntato su un giocatore — portalo lontano dal gruppo e fuori dall'impatto.|n2. {SPELL:474197}: forti danni a tutti — difensive e continua a muoverti.|n3. Grandi colpi al tank ({SPELL:473898}) — concedi all'healer un momento di calma attorno ad essi.",
	DGN_TIP_MR_XATHUUX_TANK = "Tank: difensiva per {SPELL:473898}.",
	DGN_TIP_MR_XATHUUX_HEALER = "Healer: danni al gruppo durante {SPELL:474197}.",

	DGN_TIP_MR_LITHIEL_STEPS = "1. {SPELL:1218203}: distanziatevi (6+ yard) — ogni impatto genera Wild Imps; uccidi gli imp in fretta.|n2. Uccidi il Vilefiend evocato ({SPELL:474408}) prima della prossima ondata di imp.|n3. {SPELL:1224478}: si scuda e manda un'onda di fuoco fel attraverso la stanza — usa il gateway per sfuggirle (il colpo accumula +50% danni da fuoco subiti, e i demoni che tocca vengono potenziati).",
	DGN_TIP_MR_LITHIEL_TANK = "Tank: prendi il Vilefiend e gli imp in fretta.",
	DGN_TIP_MR_LITHIEL_HEALER = "Healer: chi viene colpito da {SPELL:1224478} subisce danni da fuoco crescenti — tienilo alto.",

	-- Den of Nalorakk -----------------------------------------------------------
	DGN_TIP_DN_HOARDMONGER_STEPS = "1. {SPELL:1234233}: cibo marcio piove per 7 secondi e cosparge Rotten Mushrooms — schiva gli impatti e stai lontano dai funghi.|n2. {SPELL:1253268} è un cono frontale — non stare mai davanti.|n3. {SPELL:1235118} colpisce tutti (ignora l'armatura) — resta al massimo.",
	DGN_TIP_DN_HOARDMONGER_TANK = "Tank: il frontale ti segue — orienta il boss lontano dal gruppo.",
	DGN_TIP_DN_HOARDMONGER_HEALER = "Healer: cura di gruppo dopo ogni {SPELL:1235118}.",

	DGN_TIP_DN_SENTINEL_STEPS = "1. Le Raging Squalls ({SPELL:1235623}) vagano per l'arena a lungo — continua a serpeggiare attorno ad esse.|n2. I ghiaccioli {SPELL:1235783} cadono e rivelano un Fractured Shivercore — distruggilo.|n3. {SPELL:1235656}: un velo ghiacciato assorbe danni mentre la tempesta respinge tutti e ticchetta sul gruppo — rompi lo scudo IN FRETTA.",
	DGN_TIP_DN_SENTINEL_TANK = "Tank: tieni il boss lontano dalle raffiche.",
	DGN_TIP_DN_SENTINEL_HEALER = "Healer: dispella/cura attraverso {SPELL:1235548} (DoT di gelo da 16s); tutti ticchettano durante {SPELL:1235656}.",

	DGN_TIP_DN_NALORAKK_STEPS = "1. {SPELL:1243011}: Nalorakk butta a terra Zul'jarra e gli orsi spiritici caricano verso di lei — mettiti sul loro percorso per intercettarli (ogni orso che la raggiunge scatena un urlo brutale).|n2. {SPELL:1255385} respinge tutti — attento a dove metti i piedi vicino ai pericoli.|n3. {SPELL:1243569} dilania il tank per 4 secondi — aiuta con esterne se le hai.",
	DGN_TIP_DN_NALORAKK_TANK = "Tank: {SPELL:1243569} = colpi crescenti, +50% danni subiti per colpo — grande difensiva, ogni volta.",
	DGN_TIP_DN_NALORAKK_HEALER = "Healer: il tank subisce picchi forti durante {SPELL:1243569}; cura di gruppo dopo ogni ruggito.",

	-- The Blinding Vale ---------------------------------------------------------
	DGN_TIP_BV_TRINITY_STEPS = "1. Tre boss insieme — segui l'ordine dei bersagli del tuo tank.|n2. Lekshi scatta tra le chiazze di terra ({SPELL:1234850}) e semina Lightblossom lungo il percorso — stai fuori dai percorsi dello scatto.|n3. Kezkitt irradia ogni seme ({SPELL:1235564}): STAI DENTRO il raggio per fermare la crescita del seme (un seme non soakato cresce troppo dopo 10 secondi).|n4. Meittik colpisce duro il tank ({SPELL:1234753}).",
	DGN_TIP_BV_TRINITY_TANK = "Tank: difensiva per {SPELL:1234753}; attento al {SPELL:1261276} di Lekshi.",
	DGN_TIP_BV_TRINITY_HEALER = "Healer: chi soaka i raggi subisce danni Holy costanti — tienilo su.",

	DGN_TIP_BV_IKUZZ_STEPS = "1. {SPELL:1236746} respinge tutti e spuntano radici dove stanno i giocatori — lasciale ai bordi.|n2. {SPELL:1237091}: fissa e insegue un giocatore per 10 secondi — corri, non lasciarti raggiungere.|n3. Continua a schivare le eruzioni di spine ({SPELL:1236709}).",
	DGN_TIP_BV_IKUZZ_TANK = "Tank: riprendilo dopo ogni inseguimento di Gaze.",
	DGN_TIP_BV_IKUZZ_HEALER = "Healer: tieni in salute il giocatore inseguito — farsi prendere fa male.",

	DGN_TIP_BV_RUIA_STEPS = "1. Il warden cambia forma (orso, moonkin, haranir) — ognuna ha i suoi trucchi.|n2. Schiva i cerchi d'impatto di {SPELL:1240098}.|n3. {SPELL:1241058} lascia un bleed che si ferma solo quando il bersaglio viene curato al MASSIMO — segnalalo.|n4. Fase finale ({SPELL:1241067}): tutto si attiva ogni pochi secondi — risparmia i cooldown e continua a muoverti.",
	DGN_TIP_BV_RUIA_TANK = "Tank: la forma orso colpisce più duro — difensiva per {SPELL:1240222}.",
	DGN_TIP_BV_RUIA_HEALER = "Healer: {SPELL:1241058} fa bleed finché il giocatore non è alla salute MASSIMA — curalo subito.",

	DGN_TIP_BV_ZIEKKET_STEPS = "1. Gli orb Lightbloom ({SPELL:1246858}) si dirigono verso Ziekket — toccali per farli scoppiare prima che lo raggiungano.|n2. Le Lightspawn Lashers continuano a spuntare ({SPELL:1246372}, e quelle dormienti si risvegliano) — uccidile per bene.|n3. Attento ai piedi per {SPELL:1246753} e fai attenzione a {SPELL:1253690}.",
	DGN_TIP_BV_ZIEKKET_TANK = "Tank: difensiva per {SPELL:1247685}; prendi le lasher.",
	DGN_TIP_BV_ZIEKKET_HEALER = "Healer: danni al gruppo costanti — aspettati un picco quando un orb sfugge.",

	-- Voidscar Arena ------------------------------------------------------------
	DGN_TIP_VA_TAZRAH_STEPS = "1. {SPELL:1222274} trascina tutti verso di sé per 6 secondi — corri contro l'attrazione; il centro fa molto male.|n2. Dopo ogni teletrasporto ({SPELL:1262901}) le Ethereal Shades attaccano — bruciale.|n3. Schiva {SPELL:1225011}.",
	DGN_TIP_VA_TAZRAH_TANK = "Tank: difensiva per {SPELL:1222085}.",
	DGN_TIP_VA_TAZRAH_HEALER = "Healer: la frattura ticchetta su tutti mentre corrono — tieni stabile il gruppo.",

	DGN_TIP_VA_ATROXUS_STEPS = "1. I Toxic Creepers ({SPELL:1222371}) strisciano fuori dalle pozze — uccidili in fretta.|n2. Stai fuori dal frontale {SPELL:1263977} e dai cerchi {SPELL:1226120}.|n3. {SPELL:1262497} ti respinge — non stare con una pozza dietro di te.",
	DGN_TIP_VA_ATROXUS_TANK = "Tank: difensiva per {SPELL:1222642}; orienta il respiro lontano.",
	DGN_TIP_VA_ATROXUS_HEALER = "Healer: cura in anticipo prima di {SPELL:1262497}; il veleno ticchetta sui piedi distratti.",

	DGN_TIP_VA_CHARONUS_STEPS = "1. Un Gravitic Orb ({SPELL:1263982}) insegue ogni giocatore — kita il tuo verso una Unstable Singularity ({SPELL:1282770}; entro 6 yard viene distrutto).|n2. {SPELL:1227264}: tutti vengono respinti più un DoT di 20 secondi — scegli un terreno sicuro prima che colpisca.|n3. Schiva i proiettili {SPELL:1222758} (contatto = danni + knockback).",
	DGN_TIP_VA_CHARONUS_TANK = "Tank: posizionamento stabile — dai ai giocatori spazio per kitare i loro orb.",
	DGN_TIP_VA_CHARONUS_HEALER = "Healer: dopo {SPELL:1227264} tutto il gruppo porta un lungo DoT — grandi cure lì.",

	-- Nexus-Point Xenas ---------------------------------------------------------
	DGN_TIP_NX_KASRETH_STEPS = "1. Hai {SPELL:1251785}? Cammina DENTRO un raggio di leyline ({SPELL:1251183}) — rimuove il debuff (breve stun, ne vale la pena).|n2. Tutti gli altri: NON attraversate le leyline (danni + rallentamento crescente).|n3. Piena energia = {SPELL:1257509}: grande zona d'impatto, allontanati — le fuoriuscite arcane ({SPELL:1264048}) restano dopo.",
	DGN_TIP_NX_KASRETH_TANK = "Tank: tieni il boss lontano dalle leyline.",
	DGN_TIP_NX_KASRETH_HEALER = "Healer: Sparkburn ticchetta su tutti dopo ogni detonazione.",

	DGN_TIP_NX_NYSARRA_STEPS = "1. Distanziatevi — i colpi di {SPELL:1249020} schizzano per 14 yard.|n2. Uccidi gli add Null Vanguard ({SPELL:1252703}) IN FRETTA: tutto ciò che resta vivo viene divorato ({SPELL:1271684}), la cura e fa esplodere il gruppo.|n3. Schiva {SPELL:1264439}.",
	DGN_TIP_NX_NYSARRA_TANK = "Tank: balza su di te con una combo di fendenti ({SPELL:1247937}) — difensiva, preparati al finisher.",
	DGN_TIP_NX_NYSARRA_HEALER = "Healer: danni distribuiti dopo {SPELL:1249020}; esplosione di gruppo se gli add sopravvivono al divoramento.",

	DGN_TIP_NX_LOTHRAXION_STEPS = "1. {SPELL:1255503}: distanziatevi — gli impatti schizzano per 8 yard e generano Fractured Images.|n2. {SPELL:1257567}: si nasconde tra le sue immagini e canalizzano tutte — trova il VERO Lothraxion e interrompilo.|n3. Le immagini sfarfallano in giro con knockback ({SPELL:1255531}); stai fuori da {SPELL:1255310} sul pavimento.",
	DGN_TIP_NX_LOTHRAXION_TANK = "Tank: {SPELL:1255335} è un doppio fendente che incide cicatrici nel terreno — orientalo lontano dal gruppo.",
	DGN_TIP_NX_LOTHRAXION_HEALER = "Healer: DoT Holy dopo ogni {SPELL:1255503}; danni costanti finché non scatta l'interrupt su Guile.",

	-- Magisters' Terrace --------------------------------------------------------
	DGN_TIP_MT_ARCANOTRON_STEPS = "1. Quando si rifornisce ({SPELL:474345}), gli Energy Orbs vengono attratti verso di lui — intercettali; nel frattempo subisce +20% danni: finestra di burst!|n2. I giocatori incatenati ({SPELL:1214038}) sono immobilizzati (magic) — dispella o liberali.|n3. {SPELL:1214081} respinge tutti e lascia residui ai suoi piedi — esci da essi.",
	DGN_TIP_MT_ARCANOTRON_TANK = "Tank: {SPELL:474496} ti lancia — tieni le spalle libere.",
	DGN_TIP_MT_ARCANOTRON_HEALER = "Healer: dispella {SPELL:1214038} (root magic) in fretta.",

	DGN_TIP_MT_SERANEL_STEPS = "1. {SPELL:1225193} pacifica tutti FUORI dalla Suppression Zone ({SPELL:1224903}) — entra nella zona per l'onda (ma la zona ti silenzia, quindi non indugiare).|n2. Purge/spellsteal il suo {SPELL:1248689} (+100% velocità d'attacco) ogni volta che è attivo.|n3. {SPELL:1225787} rimbalza su un giocatore vicino — distanziatevi.",
	DGN_TIP_MT_SERANEL_TANK = "Tank: un Ward non rimosso raddoppia la sua velocità d'attacco — difensiva finché non sparisce.",
	DGN_TIP_MT_SERANEL_HEALER = "Healer: i giocatori marcati ticchettano; ricorda che non puoi lanciare dentro la zona.",

	DGN_TIP_MT_GEMELLUS_STEPS = "1. {SPELL:1223847} (all'inizio e a metà salute): si divide in tre.|n2. {SPELL:1253709}: collegato a uno di loro? CORRI a toccarlo — questo spezza il legame e rimuove il suo scudo di assorbimento.|n3. {SPELL:1224299} ti attira — ricorri fuori.",
	DGN_TIP_MT_GEMELLUS_TANK = "Tank: raggruppa il trio dopo ogni {SPELL:1223847} così i giocatori collegati possono raggiungere il loro.",
	DGN_TIP_MT_GEMELLUS_HEALER = "Healer: i giocatori collegati subiscono +20% danni finché non spezzano il legame.",

	DGN_TIP_MT_DEGENTRIUS_STEPS = "1. {SPELL:1215897}: DoT void con durate diverse — quando il tuo scade, gli Entropy Orbs partono dalla TUA posizione, quindi allontanati prima dal gruppo.|n2. {SPELL:1215087} rimbalza su 4 punti — SOAK un impatto (un giocatore ciascuno), o erutta in Void Destruction.|n3. {SPELL:1280113} colpisce il tank e respinge chiunque entro 8 yard — dai spazio al tank.",
	DGN_TIP_MT_DEGENTRIUS_TANK = "Tank: difensiva per {SPELL:1280113}; tankalo lontano dal gruppo.",
	DGN_TIP_MT_DEGENTRIUS_HEALER = "Healer: i DoT Entropy ticchettano forte — tieni su i portatori mentre si riposizionano.",

	-- Skyreach ------------------------------------------------------------------
	DGN_TIP_SR_RANJIT_STEPS = "1. {SPELL:1258148} vola in linea retta davanti a lui — spostati di lato.|n2. {SPELL:156793}: un impatto al centro più vortici di vento vaganti che ti lanciano — continua a serpeggiare.|n3. {SPELL:153757} colpisce tutti con un bleed — sii al massimo.|n4. {SPELL:1252733} scaglia via i suoi bersagli — attento a cosa hai dietro.",
	DGN_TIP_SR_RANJIT_TANK = "Tank: tienilo lontano dai percorsi dei vortici.",
	DGN_TIP_SR_RANJIT_HEALER = "Healer: danni al gruppo più bleed dopo ogni {SPELL:153757}.",

	DGN_TIP_SR_ARAKNATH_STEPS = "1. {SPELL:154162}: i costrutti irradiano luce nel boss e lo CURANO — stai in un raggio per bloccarlo.|n2. {SPELL:154115}: una bracciata da un lato — farsi colpire accumula un brutale debuff di danni subiti.|n3. {SPELL:154135} colpisce tutti — sii pronto.",
	DGN_TIP_SR_ARAKNATH_TANK = "Tank: non soakare mai i raggi tu stesso — il suo smash arriva durante il soak.",
	DGN_TIP_SR_ARAKNATH_HEALER = "Healer: chi soaka i raggi ticchetta costantemente; cura di gruppo a {SPELL:154135}.",

	DGN_TIP_SR_RUKHRAN_STEPS = "1. {SPELL:1253527}: le piume volano ovunque per 3 secondi — spezza la linea di vista dietro un pilastro.|n2. {SPELL:1253510} colpisce il gruppo ed evoca un Sunwing che fissa qualcuno e pulsa fuoco — uccidilo in fretta; il giocatore fissato mantiene la distanza.|n3. Ripeti — penne dietro la copertura, uccello giù in fretta.",
	DGN_TIP_SR_RUKHRAN_TANK = "Tank: difensiva per {SPELL:1253519} (grande colpo + DoT da bruciatura).",
	DGN_TIP_SR_RUKHRAN_HEALER = "Healer: danni al gruppo pulsanti finché vive un Sunwing — chiedi che venga ucciso.",

	DGN_TIP_SR_VIRYX_STEPS = "1. {SPELL:154396}: un cast di 3 secondi che annienta il tank — KICKALO, ogni volta.|n2. {SPELL:1253998}: un Solar Zealot afferra un giocatore per buttarlo giù dal balcone — liberalo in fretta.|n3. {SPELL:1253531} su di te? Portalo lontano e largo — lascia Blazing Ground.",
	DGN_TIP_SR_VIRYX_TANK = "Tank: ogni {SPELL:154396} che passa fa male — tieni stretto l'ordine dei kick.",
	DGN_TIP_SR_VIRYX_HEALER = "Healer: {SPELL:1253538} mette DoT di fuoco su più giocatori contemporaneamente.",

	-- Pit of Saron --------------------------------------------------------------
	DGN_TIP_PS_GARFROST_STEPS = "1. {SPELL:1262029}: la forgia pulsa gelo crescente — NASCONDITI DIETRO un blocco di minerale di saronite, blocca l'esplosione.|n2. {SPELL:1261546} colpisce tutto attorno al bersaglio principale — stai a 5+ yard dal tank; vicino al minerale lo smash rompe il minerale invece di stunnare.|n3. {SPELL:1261847} colpisce tutti e frantuma TUTTO il minerale — nuovo minerale arriva via {SPELL:1261286}.|n4. Stai fuori da {SPELL:1261799}.",
	DGN_TIP_PS_GARFROST_TANK = "Tank: posizionati accanto a un blocco di minerale — {SPELL:1261546} poi rompe il minerale, non te.",
	DGN_TIP_PS_GARFROST_HEALER = "Healer: picco di gruppo a {SPELL:1261847}; gelo crescente su chi viene preso senza copertura.",

	DGN_TIP_PS_KRICKICK_STEPS = "1. {SPELL:1264363}: Ick fissa e insegue un giocatore, spargendo Blight e Plague Glob — corri largo; il resto continua a colpire.|n2. {SPELL:1264027}: Krick si teletrasporta a un cerchio rituale ed evoca Shades — cambia e uccidile.|n3. {SPELL:1264336}: schiva l'onda e i glob che rotolano verso di te.|n4. Non stare mai nel Blight ({SPELL:1264299}).",
	DGN_TIP_PS_KRICKICK_TANK = "Tank: {SPELL:1264287} lascia una pozza su di te — orientala verso il bordo.",
	DGN_TIP_PS_KRICKICK_HEALER = "Healer: tieni il giocatore inseguito in movimento; danni al gruppo a {SPELL:1264336}.",

	DGN_TIP_PS_TYRANNUS_STEPS = "1. {SPELL:1262772} congela le Bone Piles attorno al suo bersaglio — stai vicino alle pile quando sei marcato: le pile congelate non possono rianimare add.|n2. {SPELL:1263406} rianima le pile rimanenti — uccidi prima i Plaguespreaders.|n3. Continua a schivare {SPELL:1263756} e {SPELL:1276948} di Rimefang.|n4. {SPELL:1276648} = colpo al gruppo + DoT, e le pile infuse generano add più cattivi.",
	DGN_TIP_PS_TYRANNUS_TANK = "Tank: {SPELL:1262582} ti lancia e accumula +200% shadow subito — difensiva e preparati.",
	DGN_TIP_PS_TYRANNUS_HEALER = "Healer: DoT di gruppo dopo {SPELL:1276648}; picco sul tank subito dopo Brand.",

	-- Seat of the Triumvirate ---------------------------------------------------
	DGN_TIP_ST_ZURAAL_STEPS = "1. {SPELL:1268916} colpisce tutto DAVANTI a lui — non stare mai davanti al boss.|n2. {SPELL:1263304} (piena energia): trascina tutti dentro, poi esplode con un knockback — esci in tempo; anche gli add vengono trascinati dentro.|n3. {SPELL:1263399} genera add Coalesced Void — eliminali prima di Crashing Void.|n4. {SPELL:1263282} lascia Void Sludge ({SPELL:244588}) — tieni pulito il pavimento.",
	DGN_TIP_ST_ZURAAL_TANK = "Tank: difensiva per {SPELL:1263440} (triplo fendente).",
	DGN_TIP_ST_ZURAAL_HEALER = "Healer: grande colpo al gruppo a {SPELL:1263304}.",

	DGN_TIP_ST_SAPRISH_STEPS = "1. Le Void Bomb ({SPELL:247175}) atterrano sulle posizioni dei giocatori — NON toccarle; lasciale ai bordi.|n2. {SPELL:1280064}: le shade scattano verso ogni giocatore e fanno detonare le bombe che attraversano — angola la linea del tuo scatto lontano dalle bombe.|n3. {SPELL:1263523} accende TUTTE le bombe insieme — meno bombe ci sono, più è leggero.|n4. Kicka {SPELL:248831} di Shadewing (colpo al gruppo + disorientamento).",
	DGN_TIP_ST_SAPRISH_TANK = "Tank: tieni unito il trio; il balzo di Darkfang ({SPELL:245738}) lascia la sua vittima sanguinante.",
	DGN_TIP_ST_SAPRISH_HEALER = "Healer: le vittime del balzo sanguinano; esplosione di gruppo a {SPELL:1263523}.",

	DGN_TIP_ST_NEZHAR_STEPS = "1. {SPELL:1263528} respinge tutti — attento a dove metti i piedi vicino alle tempeste.|n2. {SPELL:1263538} e l'add {SPELL:1277358} aggiungono caos — uccidi i tentacoli, schiva le Umbral Wave dal cancello.|n3. Le zone {SPELL:1263532} ticchettano forte, dentro è peggio — fuori, in fretta.|n4. {SPELL:244750} annienta il tank — kickalo quando puoi.",
	DGN_TIP_ST_NEZHAR_TANK = "Tank: preparati a {SPELL:244750} ogni volta che un kick è in cooldown.",
	DGN_TIP_ST_NEZHAR_HEALER = "Healer: {SPELL:1263542} = diversi DoT di marcescenza che ticchettano insieme.",

	DGN_TIP_ST_LURA_STEPS = "1. Le Notes of Despair continuano a irradiare ({SPELL:1265421}) finché non vengono silenziate — guida il tuo {SPELL:1265426} ATTRAVERSO le note (colpisce anche gli alleati in linea, quindi angolalo lontano da loro).|n2. {SPELL:1265689}: 20 secondi di dolore attorno a ogni nota attiva — rompi le note in fretta.|n3. {SPELL:1264151}: raggi void rotanti — muoviti con i varchi.|n4. {SPELL:1266003} è una canalizzazione letale di 10 secondi — ogni difensiva che hai, e cura attraverso.",
	DGN_TIP_ST_LURA_TANK = "Tank: dopo {SPELL:1266001} tutti vengono sbalzati in giro — raggruppatevi in fretta.",
	DGN_TIP_ST_LURA_HEALER = "Healer: {SPELL:1265421} colpisce il gruppo più le aure delle note — rompere le note È il piano di cura.",

	-- Algeth'ar Academy ---------------------------------------------------------
	DGN_TIP_AA_VEXAMUS_STEPS = "1. {SPELL:385974} si dirigono verso il boss — soakali, un giocatore ciascuno (piccolo colpo); ogni orb che LUI assorbe fa esplodere tutto il gruppo.|n2. {SPELL:386173}: porta il tuo fuori — diventa una pozza {SPELL:386201}.|n3. Piena energia = {SPELL:388537}: colpo al gruppo più eruzioni ripetute sotto i giocatori — continua a muoverti.",
	DGN_TIP_AA_VEXAMUS_TANK = "Tank: {SPELL:385958} fa esplodere tutto davanti a lui — difensiva, orientalo lontano.",
	DGN_TIP_AA_VEXAMUS_HEALER = "Healer: i portatori di bomba ticchettano; danni al gruppo per ogni orb che raggiunge il boss.",

	DGN_TIP_AA_ANCIENT_STEPS = "1. {SPELL:388796}: i semi eruttano sotto tutti per 4 secondi — schiva; i semi mancati lasciano Lasher dormienti.|n2. A piena energia ({SPELL:388923}) TUTTE le Lasher dormienti si svegliano insieme — eliminale prima.|n3. {SPELL:388623} lancia un ramo che diventa un grande add — uccidilo e KICKA il suo {SPELL:396640}.",
	DGN_TIP_AA_ANCIENT_TANK = "Tank: {SPELL:388544} raddoppia i danni fisici che subisci — difensiva ogni volta.",
	DGN_TIP_AA_ANCIENT_HEALER = "Healer: cura {SPELL:389033} (veleno) prima che si accumuli troppo.",

	DGN_TIP_AA_CRAWTH_STEPS = "1. {SPELL:377004} erutta sotto ogni giocatore e interrompe i cast — SMETTI di lanciare, poi distanziatevi.|n2. {SPELL:377034}: punta qualcuno e soffia un cono d'ali in quella direzione — esci.|n3. {SPELL:377182}: segna in una porta — la porta del fuoco la stunna e subisce 75% danni extra.",
	DGN_TIP_AA_CRAWTH_TANK = "Tank: difensiva per {SPELL:376997} (colpo + bleed di 10s).",
	DGN_TIP_AA_CRAWTH_HEALER = "Healer: forti danni al gruppo dopo lo strillo; il tank sanguina.",

	DGN_TIP_AA_DORAGOSA_STEPS = "1. {SPELL:374341} su di te? Portalo lontano dal gruppo — esplode largo 8 yard.|n2. {SPELL:388820} trascina tutti dentro, poi esplode — CORRI FUORI prima dell'esplosione.|n3. {SPELL:389011} si accumula da ogni meccanica che incassi — a 3 stack esplode in un Arcane Rift; resta pulito.|n4. Stai fuori dal terreno {SPELL:389007}.",
	DGN_TIP_AA_DORAGOSA_TANK = "Tank: difensiva per {SPELL:1282251}.",
	DGN_TIP_AA_DORAGOSA_HEALER = "Healer: attento agli stack di {SPELL:389011} — i portatori ticchettano più forte per stack.",
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
	DGN_TIP_AA_ANCIENT_DPS = "DPS: Ruim de slapende Lashers op voor volle energie, anders worden ze allemaal tegelijk wakker. Dood de geworpen tak-add en kick zijn cast.",
	DGN_TIP_AA_CRAWTH_DPS = "DPS: Stop met casten als de grond openbarst - hij onderbreekt je toch - en spreid dan. Scoor in het vuurdoel: dat stunt haar en ze krijgt 75% extra schade.",
	DGN_TIP_AA_DORAGOSA_DPS = "DPS: Loop je debuff weg van de groep; hij barst 8 yards breed. Alles wat je eet stapelt, en bij 3 wordt het een Arcane Rift.",
	DGN_TIP_AA_VEXAMUS_DPS = "DPS: Soak de orbs, een per speler: elke orb die hij opneemt raakt de hele groep. Draag je eigen bolt weg voor hij een plas wordt.",
	DGN_TIP_BV_IKUZZ_DPS = "DPS: Laat je wortels aan de rand vallen. Gefixeerd? Gewoon 10 seconden rennen - vechten helpt niet.",
	DGN_TIP_BV_RUIA_DPS = "DPS: Elke vorm heeft zijn eigen truc, dus let op wat ze wordt. Bewaar je cooldowns voor de eindfase, als alles tegelijk afgaat.",
	DGN_TIP_BV_TRINITY_DPS = "DPS: Volg de doelvolgorde van je tank, en ga in Kezkitts stralen staan - een ongesoakt zaadje groeit na 10 seconden door.",
	DGN_TIP_BV_ZIEKKET_DPS = "DPS: Knal de Lightbloom-orbs kapot voor ze Ziekket bereiken, en maak de Lashers echt af - slapende worden weer wakker.",
	DGN_TIP_DN_HOARDMONGER_DPS = "DPS: Geen adds en geen wissels: dit is een blijf-overal-uit gevecht. Nooit voor de frontal staan, weg van de paddenstoelen.",
	DGN_TIP_DN_NALORAKK_DPS = "DPS: Lichamen tellen hier zwaarder dan schade: ga in het pad van de geestberen staan. Elke beer die Zul'jarra bereikt kost de groep.",
	DGN_TIP_DN_SENTINEL_DPS = "DPS: Twee burn-checks: sloop de Fractured Shivercore die de ijspegels blootleggen, en breek het bevroren schild snel - het tikt op de groep tot het valt.",
	DGN_TIP_MC_MUROJIN_DPS = "DPS: Beide bosses moeten bijna tegelijk sterven - kijk naar de twee balken en wissel op tijd, want een overlevende gaat berserk.",
	DGN_TIP_MC_RAKTUL_DPS = "DPS: Dood de Soulbind Totems snel. In de soul-fase: crowd-control en onderbreek de grote adds terwijl iedereen terugrent.",
	DGN_TIP_MC_VORDAZA_DPS = "DPS: De fantomen zijn jouw taak: dood ze voor ze iemand bereiken, maar een voor een - elke dood is groepsschade die niemand kan ontwijken.",
	DGN_TIP_MR_KYSTIA_DPS = "DPS: Stun of crowd-control de klonen - ze channelen allemaal Felstorm. Wissel naar Nibbles zodra ze haar lichtvorm aanneemt.",
	DGN_TIP_MR_LITHIEL_DPS = "DPS: Spreid 6+ yards en ruim de Wild Imps snel op. De Vilefiend moet dood zijn voor de volgende imp-golf.",
	DGN_TIP_MR_XATHUUX_DPS = "DPS: Weinig om naar te wisselen - neem je bolt weg van de groep, blijf bewegen en bewaar defensives voor de groepsklappen.",
	DGN_TIP_MR_ZAEN_DPS = "DPS: Line of sight is het hele gevecht: sta achter een krat of pilaar voor het schot, niet erna.",
	DGN_TIP_MT_ARCANOTRON_DPS = "DPS: Onderschep de Energy Orbs tijdens het bijtanken, en bewaar je cooldowns daarvoor: hij krijgt dan +20% schade.",
	DGN_TIP_MT_DEGENTRIUS_DPS = "DPS: Soak elk een Unstable Void Essence-inslag, anders barst hij open. Loopt je Entropy-DoT af? Eerst weg van de groep.",
	DGN_TIP_MT_GEMELLUS_DPS = "DPS: Verbonden met een kopie? Ren erheen en raak hem aan - dat breekt de link en haalt zijn absorb-schild weg. Schade in dat schild is verspild.",
	DGN_TIP_MT_SERANEL_DPS = "DPS: Purge of spellsteal de Hastening Ward elke keer. Stap in de Suppression Zone voor de wave en dan eruit - hij silencet je.",
	DGN_TIP_NX_KASRETH_DPS = "DPS: Haal je debuff eraf in een leyline-straal - die korte stun kost minder dan de debuff. Kruis de leylines verder nooit.",
	DGN_TIP_NX_LOTHRAXION_DPS = "DPS: Verstopt hij zich tussen zijn beelden? Zoek de echte en onderbreek hem - schade op de beelden is verspild.",
	DGN_TIP_NX_NYSARRA_DPS = "DPS: De Null Vanguard-adds zijn het gevecht: wat nog leeft wordt opgeslokt, wat haar healt en de groep raakt. Spreid eerst, de klappen splashen 14 yards.",
	DGN_TIP_PS_GARFROST_DPS = "DPS: Erts is dekking: ga achter een brok staan bij de forge-puls. Blijf 5+ yards van de tank zodat de slam jou niet meepakt.",
	DGN_TIP_PS_KRICKICK_DPS = "DPS: Teleporteert Krick naar een ritueelcirkel? Wissel naar de Shades. Gefixeerd door Ick: ren wijd, de rest blijft slaan.",
	DGN_TIP_PS_TYRANNUS_DPS = "DPS: Gemarkeerd? Ga bij Bone Piles staan zodat ze bevriezen; bevroren stapels kunnen geen adds oproepen. Komen ze toch: Plaguespreaders eerst.",
	DGN_TIP_SR_ARAKNATH_DPS = "DPS: Blokkeer de stralen van de constructs met je lichaam - elke straal die aankomt healt hem weer op.",
	DGN_TIP_SR_RANJIT_DPS = "DPS: Een positioneel gevecht, geen doelwit-gevecht: opzij voor de lijn, om de vortexen heen, en let op wat er achter je staat.",
	DGN_TIP_SR_RUKHRAN_DPS = "DPS: Quills betekent pilaar, elke keer. Dood daarna de Sunwing snel; wie hij fixeert houdt afstand.",
	DGN_TIP_SR_VIRYX_DPS = "DPS: Kick de tank-nuke elke keer - het is een cast van 3 seconden. Bevrijd wie de Solar Zealot grijpt voor ze van het balkon gaan.",
	DGN_TIP_ST_LURA_DPS = "DPS: Stuur je straal door de Notes of Despair - die blijven stralen tot ze gedempt zijn - en houd hem weg van je maten, want hij raakt hen ook.",
	DGN_TIP_ST_NEZHAR_DPS = "DPS: Dood de tentakels en kick de tank-nuke als het kan. De zones tikken hard, dus eruit in plaats van uptime pakken.",
	DGN_TIP_ST_SAPRISH_DPS = "DPS: Kick Shadewings cast, en laat je Void Bombs aan de rand vallen - hoe minder bommen, hoe milder de massa-ontsteking.",
	DGN_TIP_ST_ZURAAL_DPS = "DPS: Ruim de Coalesced Void-adds op voor Crashing Void, anders worden ze mee naar binnen getrokken. Nooit voor hem staan.",
	DGN_TIP_VA_ATROXUS_DPS = "DPS: Dood de Toxic Creepers zodra ze uit de plassen kruipen - er komen er steeds meer.",
	DGN_TIP_VA_CHARONUS_DPS = "DPS: Sleep je eigen Gravitic Orb naar een Unstable Singularity; binnen 6 yards gaat hij kapot. Kies veilige grond voor de knockback.",
	DGN_TIP_VA_TAZRAH_DPS = "DPS: Na elke teleport: brand de Ethereal Shades weg voor je terug naar de boss gaat.",
	DGN_TIP_WS_DUO_DPS = "DPS: Verdeel je schade zodat ze bijna tegelijk sterven, en houd Shadow Bolt onderbroken. De Dark Entity uit een curse: crowd-controlen, niet achterna jagen.",
	DGN_TIP_WS_EMBER_DPS = "DPS: Laat je vuurplassen aan de rand vallen zodat het midden schoon blijft, en stap opzij voor de breath in plaats van weg te rennen.",
	DGN_TIP_WS_HEART_DPS = "DPS: Pak een windpijl bij 2-3 stacks, maar houd er een vrij voor de grote klap op volle energie.",
	DGN_TIP_WS_KROLUK_DPS = "DPS: Adds komen rond twee derde en een derde health: meteen erop, Phantasmal Mystic eerst, en blijf hem onderbreken.",
})

-- Fase 6 (12 jun): deDE/frFR/esES/ptBR — mens-kwaliteit, game-termen en
-- eigennamen in het Engels (proper-names-policy); spellnamen lokaliseren
-- zichzelf via de {SPELL:id}-tokens.
merge(ns._mhLocales and ns._mhLocales.deDE, {
	-- Windrunner Spire ----------------------------------------------------------
	DGN_TIP_WS_DUO_STEPS = "1. Zwei Bosse — mache ihnen gleichmäßig Schaden, damit sie etwa gleichzeitig sterben.|n2. Unterbrich Shadow Bolt; tritt aus den Spuckkreisen ({SPELL:472745}) — verschwende keinen Bodenplatz.|n3. Verflucht ({SPELL:474105})? Schnell bannen lassen — oder die Dark Entity, die daraus spawnt, mit CC belegen, bis sie verschwindet.|n4. Von {SPELL:472793} während des Schreis gehakt? Stell dich so, dass du DURCH die Geisterdame gezogen wirst — das bricht ihren Zauber.",
	DGN_TIP_WS_DUO_TANK = "Tank: Defensive für {SPELL:472888}; verschiebe die Bosse, wenn der Boden zu voll wird.",
	DGN_TIP_WS_DUO_HEALER = "Heiler: viel Gruppenschaden während {SPELL:472736}; banne {SPELL:474105} schnell.",

	DGN_TIP_WS_EMBER_STEPS = "1. Feuer = schlecht. Lege die Feuerpfützen ({SPELL:466556}) an die Ränder, halte die Mitte sauber.|n2. Bei voller Energie: lauf ZUM Boss für {SPELL:465904} und weiche danach jedem Fire Breath aus.|n3. Alte Pfützen spawnen Feuerhosen — bleib in Bewegung.",
	DGN_TIP_WS_EMBER_TANK = "Tank: Defensive für {SPELL:466064}.",
	DGN_TIP_WS_EMBER_HEALER = "Heiler: schwerer Gruppenschaden während {SPELL:465904}.",

	DGN_TIP_WS_KROLUK_STEPS = "1. Braune Kreise = schlecht, raus da.|n2. Stell dich zu einem Mitspieler, bevor {SPELL:1253026} abläuft (überlappe die lila Kreise).|n3. Fixiert oder Sprungziel ({SPELL:1283247})? Lauf damit WEG von der Gruppe.|n4. Spawnen Adds (etwa bei zwei Dritteln und einem Drittel Leben): schnell töten — den Phantasmal Mystic zuerst, und unterbrich ihn weiter.",
	DGN_TIP_WS_KROLUK_TANK = "Tank: Defensive für {SPELL:467620}; sei bereit, den zweiten {SPELL:1283247} aufzufangen.",
	DGN_TIP_WS_KROLUK_HEALER = "Heiler: Gruppenschaden während {SPELL:472043}.",

	DGN_TIP_WS_HEART_STEPS = "1. Ticken die {SPELL:1216042}-Stapel auf dir? Tritt bei 2-3 Stapeln auf einen Windpfeil (Turbulent Arrow) — er entfernt den DoT und springt dich über die wachsende Schockwelle.|n2. Halte einen Pfeil für den großen Knall bei voller Energie frei ({SPELL:468429}).|n3. Verteilt euch leicht für {SPELL:1253979} und nutzt die großen Kreise, um den elektrischen Boden zu räumen.|n4. Ziel von {SPELL:474528}? Bleib stehen und lass die anderen wegtreten; alle anderen: raus aus dem Frontalkegel.",
	DGN_TIP_WS_HEART_TANK = "Tank: Defensive für {SPELL:472662}; richte den Rückstoß WEG von den Pfützen.",
	DGN_TIP_WS_HEART_HEALER = "Heiler: Spieler mit hohen {SPELL:1216042}-Stapeln zuerst hochheilen; extra Heilung nach {SPELL:1253979}.",

	-- Maisara Caverns ------------------------------------------------------------
	DGN_TIP_MC_MUROJIN_STEPS = "1. Zwei Bosse (Jäger und Vogel) — töte sie dicht beieinander, sonst geht der Überlebende in Berserkerwut.|n2. Eisfallen ({SPELL:1243741}), grüne Kreise ({SPELL:1243900}) und der frontale {SPELL:1260643} = schlecht, bleib raus.|n3. Ziel von {SPELL:1249478} (dem Sturzflug)? Lauf IN eine Eisfalle — das Einfrieren stoppt den Sturzflug. Alle anderen: weg von diesem Spieler.",
	DGN_TIP_MC_MUROJIN_TANK = "Tank: Defensive für {SPELL:1266480}.",
	DGN_TIP_MC_MUROJIN_HEALER = "Heiler: banne {SPELL:1246666} (Krankheit) — schwerer Gruppenschaden.",

	DGN_TIP_MC_VORDAZA_STEPS = "1. Der Boss spawnt Unstable Phantoms ({SPELL:1251204}), die Spieler jagen. TÖTE sie, bevor sie jemanden erreichen — ein Phantom, das sein Ziel erreicht (oder ein anderes Phantom berührt), explodiert mit schwerem Schaden in der Nähe.|n2. Jedes getötete Phantom schreit: unvermeidbarer Gruppenschaden — töte sie also EINZELN.|n3. Weiche der Frontalwelle von {SPELL:1252054} aus (sie stößt dich weg), den schwebenden Orbs und Soulrot.|n4. Steckt jemand in einem Deathshroud? Schlag ihn schnell frei; unterbrich {SPELL:1250708} und weiche währenddessen den Swirls aus.",
	DGN_TIP_MC_VORDAZA_TANK = "Tank: Defensive für {SPELL:1251554}.",
	DGN_TIP_MC_VORDAZA_HEALER = "Heiler: jedes getötete Phantom schreit ({SPELL:1251813}) = Gruppenschaden — heile zwischen den gestaffelten Kills.",

	DGN_TIP_MC_RAKTUL_STEPS = "1. Der Boss springt auf drei Spieler ({SPELL:1252676}) und hinterlässt Soulbind Totems — verteilt euch, damit die Totems getrennt landen, werdet nicht zerquetscht, und zerstört die Totems schnell.|n2. Bleib aus dem Chill-of-Death-Boden.|n3. Seelenphase ({SPELL:1253788}): du wirst aus deinem Körper gezogen — CC und unterbrich die großen Adds, während du zu deinem Körper zurückläufst.|n4. Weiche den Swirls des Deathgorged Vessel aus.",
	DGN_TIP_MC_RAKTUL_TANK = "Tank: Defensive für {SPELL:1251023}; lege die Pfützen WEG von der Gruppe.",
	DGN_TIP_MC_RAKTUL_HEALER = "Heiler: schwerer Gruppenschaden während Deathgorged Vessel und wenn Totems zerbrechen.",

	-- Murder Row -----------------------------------------------------------------
	DGN_TIP_MR_KYSTIA_STEPS = "1. Kystia klont sich selbst ({SPELL:1264095}) — CC oder stunne die Kopien; sie kanalisieren alle Felstorm.|n2. {SPELL:474240}: sie teleportiert zu einem Spieler und explodiert mit Rückstoß — raus aus dem Knall.|n3. Bleib aus Nibbles' {SPELL:1253813}-Kegel (tickendes Feuer).|n4. Wechselt Nibbles in ihre Lichtform, kanalisiert sie {SPELL:1230304} auf Kystia — dann Ziel wechseln.",
	DGN_TIP_MR_KYSTIA_TANK = "Tank: halte Nibbles' {SPELL:1253813}-Kegel von der Gruppe weggedreht.",
	DGN_TIP_MR_KYSTIA_HEALER = "Heiler: Spitzenschaden, wenn {SPELL:474240} einschlägt; stetiger Schaden auf alle, die Felstorm-Kopien erwischen.",

	DGN_TIP_MR_ZAEN_STEPS = "1. {SPELL:474545}: er schießt auf jeden in seiner SICHTLINIE — brich sie: duck dich vor dem Schuss hinter die Kisten und Säulen (hinterlässt auch eine 15s-Blutung).|n2. {SPELL:474765}: Fracht regnet auf Spieler und schleudert dich weg — raus aus den Markierungen.|n3. {SPELL:474478}: 3 Sekunden schweres Feuer auf die ganze Gruppe — voll sein, Defensive nutzen.|n4. Weiche den Fire Bombs aus ({SPELL:1214352}).",
	DGN_TIP_MR_ZAEN_TANK = "Tank: Defensive für {SPELL:1222795}.",
	DGN_TIP_MR_ZAEN_HEALER = "Heiler: Gruppe voll vor {SPELL:474478}; Blutungen ticken auf jedem, den der Schuss erwischt hat.",

	DGN_TIP_MR_XATHUUX_STEPS = "1. {SPELL:1214637} zielt auf einen Spieler — trag ihn WEG von der Gruppe und tritt aus dem Einschlag.|n2. {SPELL:474197}: schwerer Schaden auf alle — Defensiven und in Bewegung bleiben.|n3. Große Tank-Schläge ({SPELL:473898}) — gönn dem Heiler Ruhe drumherum.",
	DGN_TIP_MR_XATHUUX_TANK = "Tank: Defensive für {SPELL:473898}.",
	DGN_TIP_MR_XATHUUX_HEALER = "Heiler: Gruppenschaden während {SPELL:474197}.",

	DGN_TIP_MR_LITHIEL_STEPS = "1. {SPELL:1218203}: verteilt euch (6+ Meter) — jeder Einschlag spawnt Wild Imps; töte die Imps schnell.|n2. Töte den beschworenen Vilefiend ({SPELL:474408}) vor der nächsten Imp-Welle.|n3. {SPELL:1224478}: sie schildet sich und schickt eine Welle Fel-Feuer durch den Raum — nutze das Gateway, um ihr zu entkommen (der Treffer stapelt +50% Feuerschaden, und getroffene Dämonen werden verstärkt).",
	DGN_TIP_MR_LITHIEL_TANK = "Tank: nimm den Vilefiend und die Imps schnell auf.",
	DGN_TIP_MR_LITHIEL_HEALER = "Heiler: wer {SPELL:1224478} abbekommt, erleidet stapelnden Feuerschaden — halte sie hoch.",

	-- Den of Nalorakk -----------------------------------------------------------
	DGN_TIP_DN_HOARDMONGER_STEPS = "1. {SPELL:1234233}: 7 Sekunden lang regnet verdorbenes Essen, das Rotten Mushrooms hinterlässt — weiche den Einschlägen aus und bleib von den Pilzen weg.|n2. {SPELL:1253268} ist ein Frontalkegel — steh nie vor ihm.|n3. {SPELL:1235118} trifft alle (ignoriert Rüstung) — voll bleiben.",
	DGN_TIP_DN_HOARDMONGER_TANK = "Tank: der Frontalkegel folgt dir — dreh den Boss von der Gruppe weg.",
	DGN_TIP_DN_HOARDMONGER_HEALER = "Heiler: Gruppenheilung nach jedem {SPELL:1235118}.",

	DGN_TIP_DN_SENTINEL_STEPS = "1. Raging Squalls ({SPELL:1235623}) wandern lange durch die Arena — weiche ihnen weiter aus.|n2. {SPELL:1235783}-Eiszapfen schlagen ein und enthüllen einen Fractured Shivercore — zerstöre ihn.|n3. {SPELL:1235656}: ein Eisschleier absorbiert Schaden, während der Sturm alle wegdrückt und auf der Gruppe tickt — brich den Schild SCHNELL.",
	DGN_TIP_DN_SENTINEL_TANK = "Tank: halte den Boss von den Squalls fern.",
	DGN_TIP_DN_SENTINEL_HEALER = "Heiler: banne/heile durch {SPELL:1235548} (16s-Frost-DoT); alle ticken während {SPELL:1235656}.",

	DGN_TIP_DN_NALORAKK_STEPS = "1. {SPELL:1243011}: Nalorakk schmettert Zul'jarra nieder und Geisterbären stürmen auf sie zu — stell dich in ihren Weg, um sie abzufangen (jeder Bär, der sie erreicht, löst einen üblen Schrei aus).|n2. {SPELL:1255385} stößt alle zurück — achte auf deine Position bei Gefahren.|n3. {SPELL:1243569} zerfetzt den Tank 4 Sekunden lang — hilf mit Externals, wenn du welche hast.",
	DGN_TIP_DN_NALORAKK_TANK = "Tank: {SPELL:1243569} = stapelnde Schläge, +50% Schaden pro Treffer — große Defensive, JEDES Mal.",
	DGN_TIP_DN_NALORAKK_HEALER = "Heiler: der Tank spikt hart während {SPELL:1243569}; Gruppenheilung nach jedem Brüllen.",

	-- The Blinding Vale -----------------------------------------------------------
	DGN_TIP_BV_TRINITY_STEPS = "1. Drei Bosse gleichzeitig — folge der Zielreihenfolge deines Tanks.|n2. Lekshi dasht zwischen den Loam-Flecken ({SPELL:1234850}) und sät unterwegs Lightblossom-Samen — bleib aus den Dash-Bahnen.|n3. Kezkitt strahlt jeden Samen an ({SPELL:1235564}): STELL DICH IN den Strahl, um das Wachstum zu stoppen (ein ungesoakter Samen überwuchert nach 10 Sekunden).|n4. Meittik schlägt den Tank hart ({SPELL:1234753}).",
	DGN_TIP_BV_TRINITY_TANK = "Tank: Defensive für {SPELL:1234753}; achte auf Lekshis {SPELL:1261276}.",
	DGN_TIP_BV_TRINITY_HEALER = "Heiler: Strahl-Soaker erleiden stetigen Heilig-Schaden — halte sie oben.",

	DGN_TIP_BV_IKUZZ_STEPS = "1. {SPELL:1236746} stößt alle zurück und Wurzeln sprießen, wo Spieler stehen — leg sie an die Ränder.|n2. {SPELL:1237091}: er fixiert und jagt einen Spieler 10 Sekunden — renn, lass ihn dich nicht erreichen.|n3. Weiche weiter den Dornen-Eruptionen aus ({SPELL:1236709}).",
	DGN_TIP_BV_IKUZZ_TANK = "Tank: nimm ihn sofort wieder auf, sobald die Jagd endet.",
	DGN_TIP_BV_IKUZZ_HEALER = "Heiler: halte den Gejagten gesund — erwischt zu werden tut weh.",

	DGN_TIP_BV_RUIA_STEPS = "1. Der Wächter wechselt die Form (Bär, Moonkin, Haranir) — jede hat eigene Tricks.|n2. Weiche den {SPELL:1240098}-Einschlagkreisen aus.|n3. {SPELL:1241058} hinterlässt eine Blutung, die erst stoppt, wenn das Ziel VOLL geheilt ist — sag es an.|n4. Endphase ({SPELL:1241067}): alles kommt alle paar Sekunden — spare Cooldowns und bleib in Bewegung.",
	DGN_TIP_BV_RUIA_TANK = "Tank: die Bärenform schlägt am härtesten — Defensive für {SPELL:1240222}.",
	DGN_TIP_BV_RUIA_HEALER = "Heiler: {SPELL:1241058} blutet, bis der Spieler auf VOLLEM Leben ist — sofort hochheilen.",

	DGN_TIP_BV_ZIEKKET_STEPS = "1. Lightbloom-Orbs ({SPELL:1246858}) schweben zu Ziekket — berühre sie, damit sie platzen, bevor sie ihn erreichen.|n2. Lightspawn Lashers sprießen ständig ({SPELL:1246372}, und schlafende erwachen wieder) — töte sie richtig.|n3. Achte auf deine Füße wegen {SPELL:1246753} und Vorsicht vor dem {SPELL:1253690}.",
	DGN_TIP_BV_ZIEKKET_TANK = "Tank: Defensive für {SPELL:1247685}; nimm die Lashers auf.",
	DGN_TIP_BV_ZIEKKET_HEALER = "Heiler: stetiger Gruppenschaden — erwarte eine Spitze, wenn ein Orb durchrutscht.",

	-- Voidscar Arena ----------------------------------------------------------------
	DGN_TIP_VA_TAZRAH_STEPS = "1. {SPELL:1222274} saugt alle 6 Sekunden lang heran — lauf gegen den Sog; das Zentrum tut höllisch weh.|n2. Nach jedem Teleport ({SPELL:1262901}) greifen Ethereal Shades an — brenn sie weg.|n3. Weiche den {SPELL:1225011} aus.",
	DGN_TIP_VA_TAZRAH_TANK = "Tank: Defensive für {SPELL:1222085}.",
	DGN_TIP_VA_TAZRAH_HEALER = "Heiler: der Riss tickt auf allen, während sie laufen — halte die Gruppe stabil.",

	DGN_TIP_VA_ATROXUS_STEPS = "1. Toxic Creepers ({SPELL:1222371}) kriechen aus den Tümpeln — töte sie schnell.|n2. Bleib aus dem {SPELL:1263977}-Frontalkegel und den {SPELL:1226120}-Kreisen.|n3. {SPELL:1262497} schleudert dich zurück — steh nicht mit einem Tümpel im Rücken.",
	DGN_TIP_VA_ATROXUS_TANK = "Tank: Defensive für {SPELL:1222642}; dreh den Atem von der Gruppe weg.",
	DGN_TIP_VA_ATROXUS_HEALER = "Heiler: vorheilen vor {SPELL:1262497}; Gift tickt auf unachtsamen Füßen.",

	DGN_TIP_VA_CHARONUS_STEPS = "1. Ein Gravitic Orb ({SPELL:1263982}) verfolgt jeden Spieler — kite deinen zu einer Unstable Singularity ({SPELL:1282770}; innerhalb von 6 Metern wird er zerstört).|n2. {SPELL:1227264}: alle fliegen weg plus ein 20-Sekunden-DoT — such dir vorher sicheren Boden.|n3. Weiche den {SPELL:1222758}-Projektilen aus (Kontakt = Schaden + Rückstoß).",
	DGN_TIP_VA_CHARONUS_TANK = "Tank: ruhige Positionierung — gib den Spielern Platz, ihre Orbs zu kiten.",
	DGN_TIP_VA_CHARONUS_HEALER = "Heiler: nach {SPELL:1227264} trägt die ganze Gruppe einen langen DoT — dort die großen Heilungen.",

	-- Nexus-Point Xenas ---------------------------------------------------------------
	DGN_TIP_NX_KASRETH_STEPS = "1. {SPELL:1251785} auf dir? Tritt IN einen Leyline-Strahl ({SPELL:1251183}) — er entfernt den Debuff (kurzer Stun, fairer Tausch).|n2. Alle anderen: kreuzt die Leylines NICHT (Schaden + stapelnde Verlangsamung).|n3. Volle Energie = {SPELL:1257509}: große Einschlagzone, mach Platz — danach bleiben Arkanlachen ({SPELL:1264048}) liegen.",
	DGN_TIP_NX_KASRETH_TANK = "Tank: halte den Boss von den Leylines fern.",
	DGN_TIP_NX_KASRETH_HEALER = "Heiler: Sparkburn tickt nach jeder Detonation auf allen.",

	DGN_TIP_NX_NYSARRA_STEPS = "1. Verteilt euch — die Schläge von {SPELL:1249020} splashen 14 Meter.|n2. Tötet die Null-Vanguard-Adds ({SPELL:1252703}) SCHNELL: was noch lebt, wird verschlungen ({SPELL:1271684}), heilt sie und knallt auf die Gruppe.|n3. Weiche den {SPELL:1264439} aus.",
	DGN_TIP_NX_NYSARRA_TANK = "Tank: sie springt dich mit einer Hieb-Kombo an ({SPELL:1247937}) — Defensive, mach dich auf den Finisher gefasst.",
	DGN_TIP_NX_NYSARRA_HEALER = "Heiler: Streuschaden nach {SPELL:1249020}; Gruppenknall, wenn Adds das Verschlingen überleben.",

	DGN_TIP_NX_LOTHRAXION_STEPS = "1. {SPELL:1255503}: verteilt euch — Einschläge splashen 8 Meter und spawnen Fractured Images.|n2. {SPELL:1257567}: er versteckt sich unter seinen Abbildern und alle kanalisieren — finde den ECHTEN Lothraxion und unterbrich ihn.|n3. Abbilder flackern mit Rückstößen umher ({SPELL:1255531}); bleib von den {SPELL:1255310} am Boden weg.",
	DGN_TIP_NX_LOTHRAXION_TANK = "Tank: {SPELL:1255335} ist ein Doppelhieb, der Narben in den Boden kerbt — richte ihn von der Gruppe weg.",
	DGN_TIP_NX_LOTHRAXION_HEALER = "Heiler: Heilig-DoTs nach jeder {SPELL:1255503}; stetiger Schaden, bis der Guile-Interrupt sitzt.",

	-- Magisters' Terrace ---------------------------------------------------------------
	DGN_TIP_MT_ARCANOTRON_STEPS = "1. Beim Auftanken ({SPELL:474345}) werden Energy Orbs zu ihm gezogen — fang sie ab; währenddessen erleidet er +20% Schaden: Burst-Fenster!|n2. Gefesselte Spieler ({SPELL:1214038}) sind verwurzelt (Magie) — bannen oder freischlagen.|n3. {SPELL:1214081} schleudert alle zurück und hinterlässt Rückstände zu seinen Füßen — tritt raus.",
	DGN_TIP_MT_ARCANOTRON_TANK = "Tank: {SPELL:474496} katapultiert dich — halte deinen Rücken frei.",
	DGN_TIP_MT_ARCANOTRON_HEALER = "Heiler: banne {SPELL:1214038} (Magie-Wurzel) schnell.",

	DGN_TIP_MT_SERANEL_STEPS = "1. {SPELL:1225193} pazifiziert alle AUSSERHALB der Suppression Zone ({SPELL:1224903}) — steh für die Welle IN der Zone (aber die Zone stummt dich, also nicht verweilen).|n2. Purge/spellsteal seine {SPELL:1248689} (+100% Angriffstempo), sobald sie aktiv ist.|n3. {SPELL:1225787} springt auf einen Spieler in der Nähe über — verteilt euch.",
	DGN_TIP_MT_SERANEL_TANK = "Tank: eine ungepurgte Ward verdoppelt sein Angriffstempo — Defensive, bis sie weg ist.",
	DGN_TIP_MT_SERANEL_HEALER = "Heiler: markierte Spieler ticken; denk daran, dass du in der Zone nicht zaubern kannst.",

	DGN_TIP_MT_GEMELLUS_STEPS = "1. {SPELL:1223847} (am Anfang und bei halbem Leben): er teilt sich in drei.|n2. {SPELL:1253709}: mit einem verlinkt? RENN hin und berühr ihn — das bricht den Link und entfernt seinen Absorbschild.|n3. {SPELL:1224299} zieht dich hinein — lauf wieder raus.",
	DGN_TIP_MT_GEMELLUS_TANK = "Tank: gruppiere das Trio nach jedem {SPELL:1223847} neu, damit verlinkte Spieler ihren erreichen.",
	DGN_TIP_MT_GEMELLUS_HEALER = "Heiler: verlinkte Spieler erleiden +20% Schaden, bis sie ihren Link brechen.",

	DGN_TIP_MT_DEGENTRIUS_STEPS = "1. {SPELL:1215897}: Leeren-DoTs mit unterschiedlichen Laufzeiten — läuft deiner ab, schießen Entropy Orbs von DEINER Position: geh erst weg von der Gruppe.|n2. {SPELL:1215087} springt zu 4 Stellen — SOAKE einen Einschlag (ein Spieler pro Stelle), sonst bricht er in Void Destruction aus.|n3. {SPELL:1280113} zerschmettert den Tank und schleudert alle im Umkreis von 8 Metern weg — gib dem Tank Raum.",
	DGN_TIP_MT_DEGENTRIUS_TANK = "Tank: Defensive für {SPELL:1280113}; tanke ihn weg von der Gruppe.",
	DGN_TIP_MT_DEGENTRIUS_HEALER = "Heiler: Entropy-DoTs ticken hart — halte die Träger oben, während sie umziehen.",

	-- Skyreach ----------------------------------------------------------------------
	DGN_TIP_SR_RANJIT_STEPS = "1. {SPELL:1258148} fliegt in gerader Linie vor ihm her — tritt zur Seite.|n2. {SPELL:156793}: ein Einschlag in der Mitte plus wandernde Windhosen, die dich hochschleudern — bleib am Laufen.|n3. {SPELL:153757} trifft alle mit einer Blutung — voll bleiben.|n4. {SPELL:1252733} bläst seine Ziele weg — achte darauf, was hinter dir ist.",
	DGN_TIP_SR_RANJIT_TANK = "Tank: halte ihn aus den Vortex-Bahnen.",
	DGN_TIP_SR_RANJIT_HEALER = "Heiler: Gruppenschaden plus Blutungen nach jedem {SPELL:153757}.",

	DGN_TIP_SR_ARAKNATH_STEPS = "1. {SPELL:154162}: Konstrukte strahlen Licht in den Boss und HEILEN ihn — stell dich in einen Strahl, um ihn zu blockieren.|n2. {SPELL:154115}: ein einseitiger Armschlag — getroffen zu werden stapelt einen brutalen Schadensdebuff.|n3. {SPELL:154135} trifft alle — sei bereit.",
	DGN_TIP_SR_ARAKNATH_TANK = "Tank: soake die Strahlen nie selbst — sein Schlag fällt genau in den Soak.",
	DGN_TIP_SR_ARAKNATH_HEALER = "Heiler: Strahl-Soaker ticken stetig; Gruppenheilung bei {SPELL:154135}.",

	DGN_TIP_SR_RUKHRAN_STEPS = "1. {SPELL:1253527}: 3 Sekunden lang fliegen Federn in alle Richtungen — brich die Sichtlinie hinter einer Säule.|n2. {SPELL:1253510} trifft die Gruppe und beschwört einen Sunwing, der jemanden fixiert und Feuer pulsiert — schnell töten; der Fixierte hält Abstand.|n3. Wiederholen — Federn hinter Deckung, Vogel schnell runter.",
	DGN_TIP_SR_RUKHRAN_TANK = "Tank: Defensive für {SPELL:1253519} (großer Schlag + Brand-DoT).",
	DGN_TIP_SR_RUKHRAN_HEALER = "Heiler: pulsierender Gruppenschaden, solange ein Sunwing lebt — ruf nach dem Kill.",

	DGN_TIP_SR_VIRYX_STEPS = "1. {SPELL:154396}: ein 3-Sekunden-Zauber, der den Tank zerlegt — UNTERBRICH ihn, jedes Mal.|n2. {SPELL:1253998}: ein Solar Zealot packt einen Spieler, um ihn vom Balkon zu werfen — befreit ihn schnell.|n3. {SPELL:1253531} auf dir? Lauf ihn weiträumig aus — er hinterlässt Blazing Ground.",
	DGN_TIP_SR_VIRYX_TANK = "Tank: jeder durchgelassene {SPELL:154396} tut weh — haltet die Kick-Reihenfolge straff.",
	DGN_TIP_SR_VIRYX_HEALER = "Heiler: {SPELL:1253538} legt Feuer-DoTs auf mehrere Spieler gleichzeitig.",

	-- Pit of Saron ----------------------------------------------------------------
	DGN_TIP_PS_GARFROST_STEPS = "1. {SPELL:1262029}: die Schmiede pulsiert stapelnden Frost — VERSTECK DICH HINTER einem Saronit-Brocken, er blockt die Strahlung.|n2. {SPELL:1261546} zertrümmert alles um das Hauptziel — bleib 5+ Meter vom Tank weg; neben Erz zerbricht der Schlag das Erz statt zu stunnen.|n3. {SPELL:1261847} trifft alle und zerschmettert ALLES Erz — neues Erz folgt via {SPELL:1261286}.|n4. Bleib aus dem {SPELL:1261799}.",
	DGN_TIP_PS_GARFROST_TANK = "Tank: park dich neben einem Erzbrocken — {SPELL:1261546} zertrümmert dann das Erz, nicht dich.",
	DGN_TIP_PS_GARFROST_HEALER = "Heiler: Gruppenspitze bei {SPELL:1261847}; stapelnder Frost auf allen ohne Deckung.",

	DGN_TIP_PS_KRICKICK_STEPS = "1. {SPELL:1264363}: Ick fixiert und jagt einen Spieler und schleudert dabei Blight und Plague Globs — lauf weiträumig; der Rest haut weiter drauf.|n2. {SPELL:1264027}: Krick teleportiert zu einem Ritualkreis und beschwört Shades — wechseln und töten.|n3. {SPELL:1264336}: weiche der Welle und den anrollenden Globs aus.|n4. Steh nie im Blight ({SPELL:1264299}).",
	DGN_TIP_PS_KRICKICK_TANK = "Tank: {SPELL:1264287} legt eine Pfütze auf dich — richte sie an den Rand.",
	DGN_TIP_PS_KRICKICK_HEALER = "Heiler: halte den Gejagten am Leben; Gruppenschaden bei {SPELL:1264336}.",

	DGN_TIP_PS_TYRANNUS_STEPS = "1. {SPELL:1262772} friert Bone Piles um sein Ziel ein — steh bei Haufen, wenn du markiert bist: gefrorene Haufen können keine Adds liefern.|n2. {SPELL:1263406} erweckt die übrigen Haufen — Plaguespreaders zuerst töten.|n3. Weiche weiter {SPELL:1263756} und Rimefangs {SPELL:1276948} aus.|n4. {SPELL:1276648} = Gruppenschlag + DoT, und infundierte Haufen liefern üblere Adds.",
	DGN_TIP_PS_TYRANNUS_TANK = "Tank: {SPELL:1262582} katapultiert dich und stapelt +200% Schattenschaden — Defensive und festhalten.",
	DGN_TIP_PS_TYRANNUS_HEALER = "Heiler: Gruppen-DoTs nach {SPELL:1276648}; Tank-Spitze direkt nach dem Brand.",

	-- Seat of the Triumvirate --------------------------------------------------------
	DGN_TIP_ST_ZURAAL_STEPS = "1. {SPELL:1268916} trifft alles VOR ihm — steh nie vor dem Boss.|n2. {SPELL:1263304} (volle Energie): er zieht alle heran und explodiert dann mit Rückstoß — lauf rechtzeitig raus; auch die Adds werden hineingezogen.|n3. {SPELL:1263399} spawnt Coalesced-Void-Adds — räum sie vor Crashing Void.|n4. {SPELL:1263282} hinterlässt Void Sludge ({SPELL:244588}) — halte den Boden sauber.",
	DGN_TIP_ST_ZURAAL_TANK = "Tank: Defensive für {SPELL:1263440} (Dreifachhieb).",
	DGN_TIP_ST_ZURAAL_HEALER = "Heiler: großer Gruppenschlag bei {SPELL:1263304}.",

	DGN_TIP_ST_SAPRISH_STEPS = "1. Void Bombs ({SPELL:247175}) landen auf Spielerpositionen — NICHT anfassen; legt sie an die Ränder.|n2. {SPELL:1280064}: Schemen dashen auf jeden Spieler zu und zünden Bomben, die sie kreuzen — leg deine Dash-Linie frei von Bomben.|n3. {SPELL:1263523} zündet ALLE Bomben gleichzeitig — je weniger Bomben, desto sanfter.|n4. Unterbrich Shadewings {SPELL:248831} (Gruppenschlag + Desorientierung).",
	DGN_TIP_ST_SAPRISH_TANK = "Tank: halte das Trio zusammen; Darkfangs Sprung ({SPELL:245738}) lässt sein Opfer bluten.",
	DGN_TIP_ST_SAPRISH_HEALER = "Heiler: Sprung-Opfer bluten; Gruppenknall bei {SPELL:1263523}.",

	DGN_TIP_ST_NEZHAR_STEPS = "1. {SPELL:1263528} schleudert alle zurück — achte auf deine Position bei Stürmen.|n2. {SPELL:1263538} und die {SPELL:1277358} stiften Chaos — töte Tentakel, weiche den Umbral Waves aus dem Tor aus.|n3. {SPELL:1263532}-Zonen ticken hart, innen schlimmer — raus, schnell.|n4. {SPELL:244750} zerlegt den Tank — unterbrich ihn, wenn möglich.",
	DGN_TIP_ST_NEZHAR_TANK = "Tank: mach dich auf {SPELL:244750} gefasst, wenn kein Kick bereit ist.",
	DGN_TIP_ST_NEZHAR_HEALER = "Heiler: {SPELL:1263542} = mehrere Rot-DoTs gleichzeitig.",

	DGN_TIP_ST_LURA_STEPS = "1. Notes of Despair strahlen weiter ({SPELL:1265421}), bis sie gestummt sind — lenke deinen {SPELL:1265426} QUER DURCH die Noten (der Strahl trifft auch Verbündete in der Linie, also ziele frei).|n2. {SPELL:1265689}: 20 Sekunden Schmerz um jede aktive Note — brich Noten schnell.|n3. {SPELL:1264151}: rotierende Leerenstrahlen — beweg dich mit den Lücken.|n4. {SPELL:1266003} ist ein tödlicher 10-Sekunden-Kanal — alle Defensiven rein und durchheilen.",
	DGN_TIP_ST_LURA_TANK = "Tank: nach {SPELL:1266001} fliegt jeder — sammelt euch schnell.",
	DGN_TIP_ST_LURA_HEALER = "Heiler: {SPELL:1265421}-Gruppenschläge plus Noten-Auren — Noten brechen IST der Heilplan.",

	-- Algeth'ar Academy ----------------------------------------------------------------
	DGN_TIP_AA_VEXAMUS_STEPS = "1. {SPELL:385974} schweben zum Boss — soakt sie, ein Spieler pro Orb (kleiner Treffer); jeder Orb, den ER absorbiert, knallt auf die ganze Gruppe.|n2. {SPELL:386173}: trag deine raus — sie platzt in eine {SPELL:386201}-Lache.|n3. Volle Energie = {SPELL:388537}: Gruppenschlag plus wiederholte Eruptionen unter Spielern — bleib in Bewegung.",
	DGN_TIP_AA_VEXAMUS_TANK = "Tank: {SPELL:385958} sprengt alles vor ihm weg — Defensive, dreh ihn von der Gruppe weg.",
	DGN_TIP_AA_VEXAMUS_HEALER = "Heiler: Bombenträger ticken; Gruppenschaden für jeden Orb, der den Boss erreicht.",

	DGN_TIP_AA_ANCIENT_STEPS = "1. {SPELL:388796}: 4 Sekunden lang keimen Samen unter allen — ausweichen; verpasste Samen hinterlassen schlafende Lashers.|n2. Bei voller Energie ({SPELL:388923}) erwachen ALLE schlafenden Lashers gleichzeitig — räum sie vorher.|n3. {SPELL:388623} wirft einen Ast, der ein großes Add wird — töte es und UNTERBRICH seinen {SPELL:396640}.",
	DGN_TIP_AA_ANCIENT_TANK = "Tank: {SPELL:388544} verdoppelt deinen erlittenen Physisch-Schaden — Defensive, jedes Mal.",
	DGN_TIP_AA_ANCIENT_HEALER = "Heiler: entferne {SPELL:389033} (Gift), bevor es hoch stapelt.",

	DGN_TIP_AA_CRAWTH_STEPS = "1. {SPELL:377004} bricht unter jedem Spieler aus und unterbricht Zauber — HÖR AUF zu zaubern, dann verteilt euch.|n2. {SPELL:377034}: sie blickt jemanden an und schlägt einen Kegel in diese Richtung — tritt raus.|n3. {SPELL:377182}: erziel ein Tor — das Feuertor stunnt sie und sie erleidet 75% mehr Schaden.",
	DGN_TIP_AA_CRAWTH_TANK = "Tank: Defensive für {SPELL:376997} (Schlag + 10s-Blutung).",
	DGN_TIP_AA_CRAWTH_HEALER = "Heiler: schwerer Gruppenschaden nach dem Kreischen; der Tank blutet.",

	DGN_TIP_AA_DORAGOSA_STEPS = "1. {SPELL:374341} auf dir? Trag sie weg von der Gruppe — sie platzt 8 Meter breit.|n2. {SPELL:388820} zieht alle hinein und explodiert dann — LAUF RAUS vor dem Knall.|n3. {SPELL:389011} stapelt von jeder Mechanik, die du frisst — bei 3 Stapeln bricht es in einen Arcane Rift aus; bleib sauber.|n4. Bleib vom {SPELL:389007}-Boden weg.",
	DGN_TIP_AA_DORAGOSA_TANK = "Tank: Defensive für {SPELL:1282251}.",
	DGN_TIP_AA_DORAGOSA_HEALER = "Heiler: achte auf {SPELL:389011}-Stapel — Träger ticken pro Stapel härter.",
})

merge(ns._mhLocales and ns._mhLocales.frFR, {
	-- Windrunner Spire ----------------------------------------------------------
	DGN_TIP_WS_DUO_STEPS = "1. Deux boss — répartis les dégâts pour qu'ils meurent à peu près en même temps.|n2. Interromps Shadow Bolt ; sors des cercles de crachat ({SPELL:472745}) — ne gaspille pas le sol.|n3. Maudit ({SPELL:474105}) ? Fais-le dissiper vite — ou contrôle la Dark Entity qu'il fait apparaître jusqu'à ce qu'elle disparaisse.|n4. Accroché par {SPELL:472793} pendant le cri ? Place-toi pour être tiré À TRAVERS la dame fantôme — ça brise son incantation.",
	DGN_TIP_WS_DUO_TANK = "Tank : défensif pour {SPELL:472888} ; déplace les boss quand le sol s'encombre.",
	DGN_TIP_WS_DUO_HEALER = "Heal : gros dégâts de groupe pendant {SPELL:472736} ; dissipe {SPELL:474105} vite.",

	DGN_TIP_WS_EMBER_STEPS = "1. Feu = mauvais. Pose les flaques de feu ({SPELL:466556}) sur les bords, garde le centre propre.|n2. À pleine énergie : cours VERS le boss pour {SPELL:465904}, puis esquive chaque Fire Breath.|n3. Les vieilles flaques font naître des tourbillons de feu — continue d'esquiver.",
	DGN_TIP_WS_EMBER_TANK = "Tank : défensif pour {SPELL:466064}.",
	DGN_TIP_WS_EMBER_HEALER = "Heal : lourds dégâts de groupe pendant {SPELL:465904}.",

	DGN_TIP_WS_KROLUK_STEPS = "1. Cercles bruns = mauvais, sors-en.|n2. Colle-toi à un allié avant la fin de {SPELL:1253026} (superpose les cercles violets).|n3. Fixé ou cible du saut ({SPELL:1283247}) ? Emmène-le LOIN du groupe.|n4. Quand des adds apparaissent (vers deux tiers et un tiers de vie) : tue-les vite — le Phantasmal Mystic d'abord, et interromps-le sans cesse.",
	DGN_TIP_WS_KROLUK_TANK = "Tank : défensif pour {SPELL:467620} ; sois prêt à rattraper le second {SPELL:1283247}.",
	DGN_TIP_WS_KROLUK_HEALER = "Heal : dégâts de groupe pendant {SPELL:472043}.",

	DGN_TIP_WS_HEART_STEPS = "1. Les stacks de {SPELL:1216042} te rongent ? Monte sur une flèche de vent (Turbulent Arrow) à 2-3 stacks — elle retire le DoT et te fait sauter par-dessus l'onde de choc.|n2. Garde une flèche pour la grosse explosion à pleine énergie ({SPELL:468429}).|n3. Espacez-vous un peu pour {SPELL:1253979} et utilisez les grands cercles pour nettoyer le sol électrique.|n4. Ciblé par {SPELL:474528} ? Reste immobile et laisse les autres s'écarter ; tous les autres : sortez du cône frontal.",
	DGN_TIP_WS_HEART_TANK = "Tank : défensif pour {SPELL:472662} ; oriente la projection LOIN des flaques.",
	DGN_TIP_WS_HEART_HEALER = "Heal : remonte d'abord les joueurs avec beaucoup de stacks de {SPELL:1216042} ; soins supplémentaires après {SPELL:1253979}.",

	-- Maisara Caverns ------------------------------------------------------------
	DGN_TIP_MC_MUROJIN_STEPS = "1. Deux boss (chasseur et oiseau) — tue-les presque ensemble, sinon le survivant devient fou furieux.|n2. Pièges de glace ({SPELL:1243741}), cercles verts ({SPELL:1243900}) et le {SPELL:1260643} frontal = mauvais, reste dehors.|n3. Ciblé par {SPELL:1249478} (le piqué de l'oiseau) ? Cours DANS un piège de glace — le gel stoppe le piqué. Les autres : éloignez-vous de ce joueur.",
	DGN_TIP_MC_MUROJIN_TANK = "Tank : défensif pour {SPELL:1266480}.",
	DGN_TIP_MC_MUROJIN_HEALER = "Heal : dissipe {SPELL:1246666} (maladie) — lourds dégâts de groupe.",

	DGN_TIP_MC_VORDAZA_STEPS = "1. Le boss invoque des Unstable Phantoms ({SPELL:1251204}) qui poursuivent les joueurs. TUE-les avant qu'ils n'atteignent quelqu'un — un fantôme qui atteint sa cible (ou touche un autre fantôme) explose avec de lourds dégâts de proximité.|n2. Chaque fantôme tué hurle : dégâts de groupe inévitables — tue-les donc UN par UN.|n3. Esquive la vague frontale de {SPELL:1252054} (elle te repousse), les orbes flottants et Soulrot.|n4. Quelqu'un est pris dans un Deathshroud ? Libère-le vite ; interromps {SPELL:1250708} et esquive les swirls pendant ce temps.",
	DGN_TIP_MC_VORDAZA_TANK = "Tank : défensif pour {SPELL:1251554}.",
	DGN_TIP_MC_VORDAZA_HEALER = "Heal : chaque fantôme tué hurle ({SPELL:1251813}) = dégâts de groupe — soigne entre les kills espacés.",

	DGN_TIP_MC_RAKTUL_STEPS = "1. Le boss bondit sur trois joueurs ({SPELL:1252676}) et laisse des Soulbind Totems — espacez-vous pour que les totems tombent séparés, ne te fais pas écraser, et détruis-les vite.|n2. Reste hors du sol Chill of Death.|n3. Phase d'âme ({SPELL:1253788}) : tu es arraché de ton corps — contrôle et interromps les gros adds pendant que tu retournes à ton corps.|n4. Esquive les swirls du Deathgorged Vessel.",
	DGN_TIP_MC_RAKTUL_TANK = "Tank : défensif pour {SPELL:1251023} ; pose les flaques LOIN du groupe.",
	DGN_TIP_MC_RAKTUL_HEALER = "Heal : lourds dégâts de groupe pendant Deathgorged Vessel et quand les totems se brisent.",

	-- Murder Row -----------------------------------------------------------------
	DGN_TIP_MR_KYSTIA_STEPS = "1. Kystia se clone ({SPELL:1264095}) — contrôle ou étourdis les copies ; elles canalisent toutes Felstorm.|n2. {SPELL:474240} : elle se téléporte sur un joueur et explose avec projection — sors du souffle.|n3. Reste hors du cône {SPELL:1253813} de Nibbles (feu qui ronge).|n4. Quand Nibbles passe en forme de lumière, elle canalise {SPELL:1230304} sur Kystia — change alors de cible.",
	DGN_TIP_MR_KYSTIA_TANK = "Tank : garde le cône {SPELL:1253813} de Nibbles orienté loin du groupe.",
	DGN_TIP_MR_KYSTIA_HEALER = "Heal : pic de dégâts quand {SPELL:474240} tombe ; dégâts réguliers sur ceux que frôlent les copies Felstorm.",

	DGN_TIP_MR_ZAEN_STEPS = "1. {SPELL:474545} : il tire sur tous ceux dans sa LIGNE DE VUE — brise-la : planque-toi derrière les caisses et piliers avant le tir (laisse aussi un saignement de 15 s).|n2. {SPELL:474765} : du fret pleut sur les joueurs et te projette — sors des marqueurs.|n3. {SPELL:474478} : 3 secondes de feu nourri sur tout le groupe — sois plein, utilise un défensif.|n4. Esquive les Fire Bombs ({SPELL:1214352}).",
	DGN_TIP_MR_ZAEN_TANK = "Tank : défensif pour {SPELL:1222795}.",
	DGN_TIP_MR_ZAEN_HEALER = "Heal : groupe plein avant {SPELL:474478} ; les saignements rongent quiconque a pris le tir.",

	DGN_TIP_MR_XATHUUX_STEPS = "1. {SPELL:1214637} vise un joueur — emmène-la LOIN du groupe et sors de l'impact.|n2. {SPELL:474197} : lourds dégâts sur tous — défensifs et reste en mouvement.|n3. Gros coups sur le tank ({SPELL:473898}) — laisse au heal un moment calme autour.",
	DGN_TIP_MR_XATHUUX_TANK = "Tank : défensif pour {SPELL:473898}.",
	DGN_TIP_MR_XATHUUX_HEALER = "Heal : dégâts de groupe pendant {SPELL:474197}.",

	DGN_TIP_MR_LITHIEL_STEPS = "1. {SPELL:1218203} : espacez-vous (6+ mètres) — chaque impact fait naître des Wild Imps ; tue-les vite.|n2. Tue le Vilefiend invoqué ({SPELL:474408}) avant la vague d'imps suivante.|n3. {SPELL:1224478} : elle se protège et envoie une vague de feu gangrené à travers la salle — utilise le gateway pour y échapper (le coup stacke +50% de dégâts de feu subis, et les démons touchés sont renforcés).",
	DGN_TIP_MR_LITHIEL_TANK = "Tank : récupère vite le Vilefiend et les imps.",
	DGN_TIP_MR_LITHIEL_HEALER = "Heal : quiconque prend {SPELL:1224478} subit des dégâts de feu cumulés — garde-les hauts.",

	-- Den of Nalorakk -----------------------------------------------------------
	DGN_TIP_DN_HOARDMONGER_STEPS = "1. {SPELL:1234233} : pendant 7 secondes, de la nourriture pourrie pleut et laisse des Rotten Mushrooms — esquive les impacts et ne touche pas aux champignons.|n2. {SPELL:1253268} est un cône frontal — ne reste jamais devant.|n3. {SPELL:1235118} frappe tout le monde (ignore l'armure) — reste plein.",
	DGN_TIP_DN_HOARDMONGER_TANK = "Tank : le cône te suit — oriente le boss loin du groupe.",
	DGN_TIP_DN_HOARDMONGER_HEALER = "Heal : soin de groupe après chaque {SPELL:1235118}.",

	DGN_TIP_DN_SENTINEL_STEPS = "1. Les Raging Squalls ({SPELL:1235623}) errent longtemps dans l'arène — slalome en continu.|n2. Les stalactites de {SPELL:1235783} s'écrasent et révèlent un Fractured Shivercore — détruis-le.|n3. {SPELL:1235656} : un voile de glace absorbe les dégâts pendant que la tempête repousse tout le monde et ronge le groupe — brise le bouclier VITE.",
	DGN_TIP_DN_SENTINEL_TANK = "Tank : garde le boss loin des squalls.",
	DGN_TIP_DN_SENTINEL_HEALER = "Heal : dissipe/soigne à travers {SPELL:1235548} (DoT de givre 16 s) ; tout le monde tique pendant {SPELL:1235656}.",

	DGN_TIP_DN_NALORAKK_STEPS = "1. {SPELL:1243011} : Nalorakk terrasse Zul'jarra et des ours spirituels chargent vers elle — mets-toi sur leur chemin pour les intercepter (chaque ours qui l'atteint déclenche un cri redoutable).|n2. {SPELL:1255385} repousse tout le monde — attention où tu te trouves près des dangers.|n3. {SPELL:1243569} déchiquette le tank pendant 4 secondes — aide avec des externes si tu en as.",
	DGN_TIP_DN_NALORAKK_TANK = "Tank : {SPELL:1243569} = coups cumulés, +50% de dégâts par coup — gros défensif, À CHAQUE fois.",
	DGN_TIP_DN_NALORAKK_HEALER = "Heal : le tank pique fort pendant {SPELL:1243569} ; soin de groupe après chaque rugissement.",

	-- The Blinding Vale -----------------------------------------------------------
	DGN_TIP_BV_TRINITY_STEPS = "1. Trois boss à la fois — suis l'ordre de cibles de ton tank.|n2. Lekshi dash entre les zones de terreau ({SPELL:1234850}) et sème des graines de Lightblossom en chemin — reste hors des trajectoires.|n3. Kezkitt canalise un rayon sur chaque graine ({SPELL:1235564}) : METS-TOI DANS le rayon pour stopper la pousse (une graine non absorbée prolifère après 10 secondes).|n4. Meittik cogne fort le tank ({SPELL:1234753}).",
	DGN_TIP_BV_TRINITY_TANK = "Tank : défensif pour {SPELL:1234753} ; surveille le {SPELL:1261276} de Lekshi.",
	DGN_TIP_BV_TRINITY_HEALER = "Heal : les absorbeurs de rayon subissent des dégâts sacrés réguliers — garde-les debout.",

	DGN_TIP_BV_IKUZZ_STEPS = "1. {SPELL:1236746} repousse tout le monde et des racines poussent là où se tiennent les joueurs — pose-les sur les bords.|n2. {SPELL:1237091} : il se fixe sur un joueur et le poursuit 10 secondes — cours, ne le laisse pas t'atteindre.|n3. Continue d'esquiver les éruptions d'épines ({SPELL:1236709}).",
	DGN_TIP_BV_IKUZZ_TANK = "Tank : reprends-le dès que la chasse s'arrête.",
	DGN_TIP_BV_IKUZZ_HEALER = "Heal : garde le joueur poursuivi en vie — se faire rattraper fait mal.",

	DGN_TIP_BV_RUIA_STEPS = "1. Le gardien change de forme (ours, sélénien, haranir) — chacune a ses tours.|n2. Esquive les cercles d'impact de {SPELL:1240098}.|n3. {SPELL:1241058} laisse un saignement qui ne s'arrête que lorsque la cible est soignée À FOND — annonce-le.|n4. Phase finale ({SPELL:1241067}) : tout tombe toutes les quelques secondes — garde tes cooldowns et reste en mouvement.",
	DGN_TIP_BV_RUIA_TANK = "Tank : la forme d'ours frappe le plus fort — défensif pour {SPELL:1240222}.",
	DGN_TIP_BV_RUIA_HEALER = "Heal : {SPELL:1241058} saigne jusqu'à ce que le joueur soit PLEINE vie — remonte-le immédiatement.",

	DGN_TIP_BV_ZIEKKET_STEPS = "1. Les orbes de Lightbloom ({SPELL:1246858}) dérivent vers Ziekket — touche-les pour les faire éclater avant qu'ils ne l'atteignent.|n2. Les Lightspawn Lashers repoussent sans cesse ({SPELL:1246372}, et les dormants se réveillent) — tue-les pour de bon.|n3. Attention à tes pieds pour {SPELL:1246753} et gare au {SPELL:1253690}.",
	DGN_TIP_BV_ZIEKKET_TANK = "Tank : défensif pour {SPELL:1247685} ; récupère les lashers.",
	DGN_TIP_BV_ZIEKKET_HEALER = "Heal : dégâts de groupe réguliers — attends-toi à un pic si un orbe passe.",

	-- Voidscar Arena ----------------------------------------------------------------
	DGN_TIP_VA_TAZRAH_STEPS = "1. {SPELL:1222274} aspire tout le monde pendant 6 secondes — cours contre l'aspiration ; le centre fait très mal.|n2. Après chaque téléportation ({SPELL:1262901}), des Ethereal Shades attaquent — brûle-les.|n3. Esquive les {SPELL:1225011}.",
	DGN_TIP_VA_TAZRAH_TANK = "Tank : défensif pour {SPELL:1222085}.",
	DGN_TIP_VA_TAZRAH_HEALER = "Heal : la faille tique sur tout le monde pendant la course — garde le groupe stable.",

	DGN_TIP_VA_ATROXUS_STEPS = "1. Des Toxic Creepers ({SPELL:1222371}) rampent hors des mares — tue-les vite.|n2. Reste hors du cône {SPELL:1263977} et des cercles {SPELL:1226120}.|n3. {SPELL:1262497} te projette en arrière — ne te tiens pas avec une mare dans le dos.",
	DGN_TIP_VA_ATROXUS_TANK = "Tank : défensif pour {SPELL:1222642} ; oriente le souffle loin du groupe.",
	DGN_TIP_VA_ATROXUS_HEALER = "Heal : pré-soigne avant {SPELL:1262497} ; le poison ronge les pieds distraits.",

	DGN_TIP_VA_CHARONUS_STEPS = "1. Un Gravitic Orb ({SPELL:1263982}) poursuit chaque joueur — kite le tien vers une Unstable Singularity ({SPELL:1282770} ; à moins de 6 mètres, il est détruit).|n2. {SPELL:1227264} : tout le monde est projeté plus un DoT de 20 secondes — choisis un sol sûr avant l'impact.|n3. Esquive les projectiles de {SPELL:1222758} (contact = dégâts + projection).",
	DGN_TIP_VA_CHARONUS_TANK = "Tank : positionnement posé — laisse aux joueurs la place de kiter leurs orbes.",
	DGN_TIP_VA_CHARONUS_HEALER = "Heal : après {SPELL:1227264}, tout le groupe porte un long DoT — les gros soins, c'est là.",

	-- Nexus-Point Xenas ---------------------------------------------------------------
	DGN_TIP_NX_KASRETH_STEPS = "1. {SPELL:1251785} sur toi ? Entre DANS un rayon de leyline ({SPELL:1251183}) — il retire le debuff (court étourdissement, bon échange).|n2. Tous les autres : ne CROISEZ PAS les leylines (dégâts + ralentissement cumulé).|n3. Pleine énergie = {SPELL:1257509} : grosse zone d'impact, dégage — des flaques arcaniques ({SPELL:1264048}) traînent ensuite.",
	DGN_TIP_NX_KASRETH_TANK = "Tank : garde le boss loin des leylines.",
	DGN_TIP_NX_KASRETH_HEALER = "Heal : Sparkburn tique sur tout le monde après chaque détonation.",

	DGN_TIP_NX_NYSARRA_STEPS = "1. Espacez-vous — les frappes de {SPELL:1249020} éclaboussent à 14 mètres.|n2. Tue les adds Null Vanguard ({SPELL:1252703}) VITE : tout ce qui survit est dévoré ({SPELL:1271684}), la soigne et explose sur le groupe.|n3. Esquive les {SPELL:1264439}.",
	DGN_TIP_NX_NYSARRA_TANK = "Tank : elle te bondit dessus avec un combo de taillades ({SPELL:1247937}) — défensif, prépare-toi au finisher.",
	DGN_TIP_NX_NYSARRA_HEALER = "Heal : dégâts dispersés après {SPELL:1249020} ; explosion de groupe si des adds survivent à la dévoration.",

	DGN_TIP_NX_LOTHRAXION_STEPS = "1. {SPELL:1255503} : espacez-vous — les impacts éclaboussent à 8 mètres et font naître des Fractured Images.|n2. {SPELL:1257567} : il se cache parmi ses reflets et tous canalisent — trouve le VRAI Lothraxion et interromps-le.|n3. Les reflets scintillent en projetant ({SPELL:1255531}) ; évite les {SPELL:1255310} au sol.",
	DGN_TIP_NX_LOTHRAXION_TANK = "Tank : {SPELL:1255335} est une double taillade qui grave des cicatrices au sol — oriente-la loin du groupe.",
	DGN_TIP_NX_LOTHRAXION_HEALER = "Heal : DoT sacrés après chaque {SPELL:1255503} ; dégâts réguliers jusqu'à ce que l'interrupt du Guile passe.",

	-- Magisters' Terrace ---------------------------------------------------------------
	DGN_TIP_MT_ARCANOTRON_STEPS = "1. Quand il refait le plein ({SPELL:474345}), des Energy Orbs sont attirés vers lui — intercepte-les ; pendant ce temps il subit +20% de dégâts : fenêtre de burst !|n2. Les joueurs enchaînés ({SPELL:1214038}) sont enracinés (magie) — dissipe ou libère-les.|n3. {SPELL:1214081} projette tout le monde et laisse des résidus à ses pieds — sors-en.",
	DGN_TIP_MT_ARCANOTRON_TANK = "Tank : {SPELL:474496} t'envoie voler — garde ton dos dégagé.",
	DGN_TIP_MT_ARCANOTRON_HEALER = "Heal : dissipe {SPELL:1214038} (racine magique) vite.",

	DGN_TIP_MT_SERANEL_STEPS = "1. {SPELL:1225193} pacifie tous ceux HORS de la Suppression Zone ({SPELL:1224903}) — entre DANS la zone pour la vague (mais la zone te réduit au silence, n'y campe pas).|n2. Purge/vole sa {SPELL:1248689} (+100% de vitesse d'attaque) dès qu'elle est active.|n3. {SPELL:1225787} rebondit vers un joueur proche — espacez-vous.",
	DGN_TIP_MT_SERANEL_TANK = "Tank : une Ward non purgée double sa vitesse d'attaque — défensif jusqu'à sa fin.",
	DGN_TIP_MT_SERANEL_HEALER = "Heal : les joueurs marqués tiquent ; rappelle-toi qu'on ne lance rien dans la zone.",

	DGN_TIP_MT_GEMELLUS_STEPS = "1. {SPELL:1223847} (au début et à mi-vie) : il se divise en trois.|n2. {SPELL:1253709} : lié à l'un d'eux ? COURS le toucher — ça brise le lien et retire son bouclier d'absorption.|n3. {SPELL:1224299} t'aspire — ressors en courant.",
	DGN_TIP_MT_GEMELLUS_TANK = "Tank : regroupe le trio après chaque {SPELL:1223847} pour que les joueurs liés atteignent le leur.",
	DGN_TIP_MT_GEMELLUS_HEALER = "Heal : les joueurs liés subissent +20% de dégâts tant que leur lien tient.",

	DGN_TIP_MT_DEGENTRIUS_STEPS = "1. {SPELL:1215897} : des DoT du Vide aux durées différentes — quand le tien expire, des Entropy Orbs partent de TA position : éloigne-toi d'abord du groupe.|n2. {SPELL:1215087} rebondit sur 4 points — ABSORBE un impact (un joueur par point), sinon il éclate en Void Destruction.|n3. {SPELL:1280113} fracasse le tank et projette quiconque à moins de 8 mètres — laisse de l'espace au tank.",
	DGN_TIP_MT_DEGENTRIUS_TANK = "Tank : défensif pour {SPELL:1280113} ; tanke-le loin du groupe.",
	DGN_TIP_MT_DEGENTRIUS_HEALER = "Heal : les DoT d'Entropy tiquent fort — garde les porteurs debout pendant qu'ils se replacent.",

	-- Skyreach ----------------------------------------------------------------------
	DGN_TIP_SR_RANJIT_STEPS = "1. {SPELL:1258148} file en ligne droite devant lui — fais un pas de côté.|n2. {SPELL:156793} : un impact au centre plus des tourbillons errants qui te catapultent — slalome.|n3. {SPELL:153757} frappe tout le monde avec un saignement — reste plein.|n4. {SPELL:1252733} souffle ses cibles au loin — regarde ce qu'il y a derrière toi.",
	DGN_TIP_SR_RANJIT_TANK = "Tank : garde-le hors des trajectoires de vortex.",
	DGN_TIP_SR_RANJIT_HEALER = "Heal : dégâts de groupe plus saignements après chaque {SPELL:153757}.",

	DGN_TIP_SR_ARAKNATH_STEPS = "1. {SPELL:154162} : des assemblages canalisent de la lumière dans le boss et le SOIGNENT — mets-toi dans un rayon pour le bloquer.|n2. {SPELL:154115} : un coup de bras d'un seul côté — se faire toucher stacke un débuff de dégâts brutal.|n3. {SPELL:154135} frappe tout le monde — sois prêt.",
	DGN_TIP_SR_ARAKNATH_TANK = "Tank : n'absorbe jamais les rayons toi-même — son coup tombe pile pendant l'absorption.",
	DGN_TIP_SR_ARAKNATH_HEALER = "Heal : les absorbeurs de rayon tiquent en continu ; soin de groupe à {SPELL:154135}.",

	DGN_TIP_SR_RUKHRAN_STEPS = "1. {SPELL:1253527} : 3 secondes de plumes dans tous les sens — brise la ligne de vue derrière un pilier.|n2. {SPELL:1253510} frappe le groupe et invoque un Sunwing qui se fixe sur quelqu'un et pulse du feu — tue-le vite ; le fixé garde ses distances.|n3. Répète — plumes derrière un abri, oiseau à terre rapidement.",
	DGN_TIP_SR_RUKHRAN_TANK = "Tank : défensif pour {SPELL:1253519} (gros coup + DoT de brûlure).",
	DGN_TIP_SR_RUKHRAN_HEALER = "Heal : dégâts de groupe pulsés tant qu'un Sunwing vit — réclame le kill.",

	DGN_TIP_SR_VIRYX_STEPS = "1. {SPELL:154396} : une incantation de 3 secondes qui atomise le tank — INTERROMPS-la, à chaque fois.|n2. {SPELL:1253998} : un Solar Zealot attrape un joueur pour le jeter du balcon — libérez-le vite.|n3. {SPELL:1253531} sur toi ? Emmène-le au large — il laisse du Blazing Ground.",
	DGN_TIP_SR_VIRYX_TANK = "Tank : chaque {SPELL:154396} qui passe fait mal — gardez l'ordre des interrupts carré.",
	DGN_TIP_SR_VIRYX_HEALER = "Heal : {SPELL:1253538} pose des DoT de feu sur plusieurs joueurs à la fois.",

	-- Pit of Saron ----------------------------------------------------------------
	DGN_TIP_PS_GARFROST_STEPS = "1. {SPELL:1262029} : la forge pulse du givre cumulé — CACHE-TOI DERRIÈRE un bloc de saronite, il bloque le rayonnement.|n2. {SPELL:1261546} fracasse tout autour de la cible principale — reste à 5+ mètres du tank ; près du minerai, le coup brise le minerai au lieu d'étourdir.|n3. {SPELL:1261847} frappe tout le monde et brise TOUT le minerai — du neuf arrive via {SPELL:1261286}.|n4. Reste hors du {SPELL:1261799}.",
	DGN_TIP_PS_GARFROST_TANK = "Tank : gare-toi près d'un bloc de minerai — {SPELL:1261546} fracasse alors le minerai, pas toi.",
	DGN_TIP_PS_GARFROST_HEALER = "Heal : pic de groupe à {SPELL:1261847} ; givre cumulé sur quiconque est sans abri.",

	DGN_TIP_PS_KRICKICK_STEPS = "1. {SPELL:1264363} : Ick se fixe sur un joueur et le poursuit en éclaboussant Blight et Plague Globs — cours large ; les autres continuent de taper.|n2. {SPELL:1264027} : Krick se téléporte à un cercle rituel et invoque des Shades — switch et tue-les.|n3. {SPELL:1264336} : esquive la vague et les globs qui roulent vers toi.|n4. Ne reste jamais dans le Blight ({SPELL:1264299}).",
	DGN_TIP_PS_KRICKICK_TANK = "Tank : {SPELL:1264287} pose une flaque sur toi — oriente-la vers le bord.",
	DGN_TIP_PS_KRICKICK_HEALER = "Heal : garde le poursuivi en vie ; dégâts de groupe à {SPELL:1264336}.",

	DGN_TIP_PS_TYRANNUS_STEPS = "1. {SPELL:1262772} gèle les Bone Piles autour de sa cible — tiens-toi près des tas quand tu es marqué : les tas gelés ne lèvent pas d'adds.|n2. {SPELL:1263406} relève les tas restants — tue les Plaguespreaders d'abord.|n3. Continue d'esquiver {SPELL:1263756} et le {SPELL:1276948} de Rimefang.|n4. {SPELL:1276648} = coup de groupe + DoT, et les tas infusés donnent des adds plus méchants.",
	DGN_TIP_PS_TYRANNUS_TANK = "Tank : {SPELL:1262582} te catapulte et stacke +200% de dégâts d'ombre — défensif et accroche-toi.",
	DGN_TIP_PS_TYRANNUS_HEALER = "Heal : DoT de groupe après {SPELL:1276648} ; pic sur le tank juste après le Brand.",

	-- Seat of the Triumvirate --------------------------------------------------------
	DGN_TIP_ST_ZURAAL_STEPS = "1. {SPELL:1268916} touche tout DEVANT lui — ne reste jamais face au boss.|n2. {SPELL:1263304} (pleine énergie) : il aspire tout le monde puis éclate avec projection — sors à temps ; les adds sont aspirés aussi.|n3. {SPELL:1263399} invoque des adds Coalesced Void — nettoie-les avant Crashing Void.|n4. {SPELL:1263282} laisse du Void Sludge ({SPELL:244588}) — garde le sol propre.",
	DGN_TIP_ST_ZURAAL_TANK = "Tank : défensif pour {SPELL:1263440} (triple taillade).",
	DGN_TIP_ST_ZURAAL_HEALER = "Heal : gros coup de groupe à {SPELL:1263304}.",

	DGN_TIP_ST_SAPRISH_STEPS = "1. Les Void Bombs ({SPELL:247175}) tombent sur les positions des joueurs — n'y TOUCHE PAS ; pose-les sur les bords.|n2. {SPELL:1280064} : des ombres dashent vers chaque joueur et font détoner les bombes croisées — trace ta ligne de dash loin des bombes.|n3. {SPELL:1263523} allume TOUTES les bombes d'un coup — moins de bombes, moins de douleur.|n4. Interromps le {SPELL:248831} de Shadewing (coup de groupe + désorientation).",
	DGN_TIP_ST_SAPRISH_TANK = "Tank : garde le trio ensemble ; le bond de Darkfang ({SPELL:245738}) laisse sa victime en sang.",
	DGN_TIP_ST_SAPRISH_HEALER = "Heal : les victimes du bond saignent ; explosion de groupe à {SPELL:1263523}.",

	DGN_TIP_ST_NEZHAR_STEPS = "1. {SPELL:1263528} projette tout le monde — attention où tu es près des tempêtes.|n2. {SPELL:1263538} et les {SPELL:1277358} sèment le chaos — tue les tentacules, esquive les Umbral Waves du portail.|n3. Les zones de {SPELL:1263532} tiquent fort, pire au centre — dehors, vite.|n4. {SPELL:244750} atomise le tank — interromps quand tu peux.",
	DGN_TIP_ST_NEZHAR_TANK = "Tank : encaisse {SPELL:244750} quand aucun interrupt n'est prêt.",
	DGN_TIP_ST_NEZHAR_HEALER = "Heal : {SPELL:1263542} = plusieurs DoT qui rongent en même temps.",

	DGN_TIP_ST_LURA_STEPS = "1. Les Notes of Despair rayonnent ({SPELL:1265421}) jusqu'à être réduites au silence — dirige ton {SPELL:1265426} À TRAVERS les notes (le rayon touche aussi les alliés dans la ligne, vise dégagé).|n2. {SPELL:1265689} : 20 secondes de douleur autour de chaque note active — brise-les vite.|n3. {SPELL:1264151} : rayons du Vide rotatifs — bouge avec les ouvertures.|n4. {SPELL:1266003} est une canalisation mortelle de 10 secondes — tous les défensifs, et soigne à fond.",
	DGN_TIP_ST_LURA_TANK = "Tank : après {SPELL:1266001}, tout le monde valdingue — regroupez-vous vite.",
	DGN_TIP_ST_LURA_HEALER = "Heal : coups de groupe de {SPELL:1265421} plus les auras des notes — briser les notes EST le plan de soin.",

	-- Algeth'ar Academy ----------------------------------------------------------------
	DGN_TIP_AA_VEXAMUS_STEPS = "1. Les {SPELL:385974} dérivent vers le boss — absorbe-les, un joueur par orbe (petit coup) ; chaque orbe qu'IL absorbe explose sur tout le groupe.|n2. {SPELL:386173} : emmène la tienne à l'écart — elle éclate en flaque de {SPELL:386201}.|n3. Pleine énergie = {SPELL:388537} : coup de groupe plus éruptions répétées sous les joueurs — reste en mouvement.",
	DGN_TIP_AA_VEXAMUS_TANK = "Tank : {SPELL:385958} souffle tout devant lui — défensif, oriente-le loin du groupe.",
	DGN_TIP_AA_VEXAMUS_HEALER = "Heal : les porteurs de bombe tiquent ; dégâts de groupe pour chaque orbe qui atteint le boss.",

	DGN_TIP_AA_ANCIENT_STEPS = "1. {SPELL:388796} : pendant 4 secondes, des graines germent sous tout le monde — esquive ; les ratées laissent des Lashers dormants.|n2. À pleine énergie ({SPELL:388923}), TOUS les Lashers dormants se réveillent d'un coup — nettoie-les avant.|n3. {SPELL:388623} lance une branche qui devient un gros add — tue-le et INTERROMPS son {SPELL:396640}.",
	DGN_TIP_AA_ANCIENT_TANK = "Tank : {SPELL:388544} double les dégâts physiques que tu subis — défensif, à chaque fois.",
	DGN_TIP_AA_ANCIENT_HEALER = "Heal : purge {SPELL:389033} (poison) avant qu'il ne grimpe.",

	DGN_TIP_AA_CRAWTH_STEPS = "1. {SPELL:377004} éclate sous chaque joueur et interrompt les incantations — ARRÊTE de lancer, puis espacez-vous.|n2. {SPELL:377034} : elle fixe quelqu'un et balaie un cône dans cette direction — sors-en.|n3. {SPELL:377182} : marque dans un but — le but de feu l'étourdit et elle subit 75% de dégâts en plus.",
	DGN_TIP_AA_CRAWTH_TANK = "Tank : défensif pour {SPELL:376997} (coup + saignement 10 s).",
	DGN_TIP_AA_CRAWTH_HEALER = "Heal : lourds dégâts de groupe après le cri ; le tank saigne.",

	DGN_TIP_AA_DORAGOSA_STEPS = "1. {SPELL:374341} sur toi ? Éloigne-la du groupe — elle éclate sur 8 mètres.|n2. {SPELL:388820} aspire tout le monde puis explose — SORS EN COURANT avant l'éclat.|n3. {SPELL:389011} se cumule à chaque mécanique encaissée — à 3 stacks, ça éclate en Arcane Rift ; reste propre.|n4. Évite le sol {SPELL:389007}.",
	DGN_TIP_AA_DORAGOSA_TANK = "Tank : défensif pour {SPELL:1282251}.",
	DGN_TIP_AA_DORAGOSA_HEALER = "Heal : surveille les stacks de {SPELL:389011} — les porteurs tiquent plus fort par stack.",
})

merge(ns._mhLocales and ns._mhLocales.esES, {
	-- Windrunner Spire ----------------------------------------------------------
	DGN_TIP_WS_DUO_STEPS = "1. Dos jefes — repárteles el daño para que mueran casi a la vez.|n2. Interrumpe Shadow Bolt; sal de los círculos de escupitajo ({SPELL:472745}) — no malgastes suelo.|n3. ¿Maldito ({SPELL:474105})? Que te lo disipen rápido — o controla a la Dark Entity que genera hasta que desaparezca.|n4. ¿Enganchado por {SPELL:472793} durante el grito? Colócate para que te arrastre A TRAVÉS de la dama fantasma — eso rompe su lanzamiento.",
	DGN_TIP_WS_DUO_TANK = "Tanque: defensivo para {SPELL:472888}; mueve a los jefes cuando el suelo se llene.",
	DGN_TIP_WS_DUO_HEALER = "Sanador: mucho daño de grupo durante {SPELL:472736}; disipa {SPELL:474105} rápido.",

	DGN_TIP_WS_EMBER_STEPS = "1. Fuego = malo. Deja los charcos de fuego ({SPELL:466556}) en los bordes, mantén el centro limpio.|n2. Con energía llena: corre HACIA el jefe para {SPELL:465904} y luego esquiva cada Fire Breath.|n3. Los charcos viejos generan remolinos de fuego — sigue esquivando.",
	DGN_TIP_WS_EMBER_TANK = "Tanque: defensivo para {SPELL:466064}.",
	DGN_TIP_WS_EMBER_HEALER = "Sanador: daño de grupo pesado durante {SPELL:465904}.",

	DGN_TIP_WS_KROLUK_STEPS = "1. Círculos marrones = malos, sal de ahí.|n2. Júntate con un aliado antes de que termine {SPELL:1253026} (superpón los círculos morados).|n3. ¿Fijado u objetivo del salto ({SPELL:1283247})? Llévalo LEJOS del grupo.|n4. Cuando salgan adds (hacia dos tercios y un tercio de vida): mátalos rápido — primero el Phantasmal Mystic, y no dejes de interrumpirlo.",
	DGN_TIP_WS_KROLUK_TANK = "Tanque: defensivo para {SPELL:467620}; prepárate para recoger el segundo {SPELL:1283247}.",
	DGN_TIP_WS_KROLUK_HEALER = "Sanador: daño de grupo durante {SPELL:472043}.",

	DGN_TIP_WS_HEART_STEPS = "1. ¿Te hacen tictac los stacks de {SPELL:1216042}? Pisa una flecha de viento (Turbulent Arrow) con 2-3 stacks — quita el DoT y te salta por encima de la onda expansiva.|n2. Guarda una flecha para el estallido grande a energía llena ({SPELL:468429}).|n3. Sepárate un poco para {SPELL:1253979} y usa los círculos grandes para limpiar el suelo eléctrico.|n4. ¿Objetivo de {SPELL:474528}? Quédate quieto y deja que los demás se aparten; el resto: fuera del cono frontal.",
	DGN_TIP_WS_HEART_TANK = "Tanque: defensivo para {SPELL:472662}; apunta el empujón LEJOS de los charcos.",
	DGN_TIP_WS_HEART_HEALER = "Sanador: cura primero a los jugadores con muchos stacks de {SPELL:1216042}; curación extra tras {SPELL:1253979}.",

	-- Maisara Caverns ------------------------------------------------------------
	DGN_TIP_MC_MUROJIN_STEPS = "1. Dos jefes (cazador y ave) — mátalos casi juntos, o el superviviente se enfurece.|n2. Trampas de hielo ({SPELL:1243741}), círculos verdes ({SPELL:1243900}) y el {SPELL:1260643} frontal = malos, quédate fuera.|n3. ¿Objetivo de {SPELL:1249478} (el picado del ave)? Corre HACIA una trampa de hielo — la congelación detiene el picado. Los demás: alejaos de ese jugador.",
	DGN_TIP_MC_MUROJIN_TANK = "Tanque: defensivo para {SPELL:1266480}.",
	DGN_TIP_MC_MUROJIN_HEALER = "Sanador: disipa {SPELL:1246666} (enfermedad) — daño de grupo pesado.",

	DGN_TIP_MC_VORDAZA_STEPS = "1. El jefe genera Unstable Phantoms ({SPELL:1251204}) que persiguen a los jugadores. MÁTALOS antes de que alcancen a alguien — un fantasma que llega a su objetivo (o toca a otro fantasma) estalla con daño pesado cercano.|n2. Cada fantasma muerto grita: daño de grupo inevitable — mátalos de UNO en UNO.|n3. Esquiva la oleada frontal de {SPELL:1252054} (te empuja), los orbes flotantes y Soulrot.|n4. ¿Alguien envuelto en un Deathshroud? Sácalo rápido; interrumpe {SPELL:1250708} y esquiva los remolinos mientras tanto.",
	DGN_TIP_MC_VORDAZA_TANK = "Tanque: defensivo para {SPELL:1251554}.",
	DGN_TIP_MC_VORDAZA_HEALER = "Sanador: cada fantasma muerto grita ({SPELL:1251813}) = daño de grupo — cura entre los kills escalonados.",

	DGN_TIP_MC_RAKTUL_STEPS = "1. El jefe salta sobre tres jugadores ({SPELL:1252676}) y deja Soulbind Totems — separaos para que los tótems caigan apartados, que no te aplaste, y destrúyelos rápido.|n2. Quédate fuera del suelo de Chill of Death.|n3. Fase de alma ({SPELL:1253788}): te arrancan del cuerpo — controla e interrumpe a los adds grandes mientras vuelves corriendo a tu cuerpo.|n4. Esquiva los remolinos del Deathgorged Vessel.",
	DGN_TIP_MC_RAKTUL_TANK = "Tanque: defensivo para {SPELL:1251023}; deja los charcos LEJOS del grupo.",
	DGN_TIP_MC_RAKTUL_HEALER = "Sanador: daño de grupo pesado durante Deathgorged Vessel y cuando los tótems se rompen.",

	-- Murder Row -----------------------------------------------------------------
	DGN_TIP_MR_KYSTIA_STEPS = "1. Kystia se clona ({SPELL:1264095}) — controla o aturde a las copias; todas canalizan Felstorm.|n2. {SPELL:474240}: se teletransporta sobre un jugador y explota con empujón — sal del estallido.|n3. Quédate fuera del cono {SPELL:1253813} de Nibbles (fuego que hace tictac).|n4. Cuando Nibbles pase a su forma de luz, canaliza {SPELL:1230304} sobre Kystia — cambia de objetivo entonces.",
	DGN_TIP_MR_KYSTIA_TANK = "Tanque: mantén el cono {SPELL:1253813} de Nibbles apuntando lejos del grupo.",
	DGN_TIP_MR_KYSTIA_HEALER = "Sanador: pico de daño cuando cae {SPELL:474240}; daño constante en quien rocen las copias de Felstorm.",

	DGN_TIP_MR_ZAEN_STEPS = "1. {SPELL:474545}: dispara a todos en su LÍNEA DE VISIÓN — rómpela: escóndete tras las cajas y pilares antes del disparo (también deja un sangrado de 15 s).|n2. {SPELL:474765}: llueve carga sobre los jugadores y te lanza — sal de las marcas.|n3. {SPELL:474478}: 3 segundos de fuego pesado sobre todo el grupo — ve lleno, usa un defensivo.|n4. Esquiva las Fire Bombs ({SPELL:1214352}).",
	DGN_TIP_MR_ZAEN_TANK = "Tanque: defensivo para {SPELL:1222795}.",
	DGN_TIP_MR_ZAEN_HEALER = "Sanador: grupo lleno antes de {SPELL:474478}; los sangrados hacen tictac en quien recibió el disparo.",

	DGN_TIP_MR_XATHUUX_STEPS = "1. {SPELL:1214637} apunta a un jugador — llévala LEJOS del grupo y sal del impacto.|n2. {SPELL:474197}: daño pesado a todos — defensivos y sigue moviéndote.|n3. Golpes grandes al tanque ({SPELL:473898}) — dale al sanador calma alrededor.",
	DGN_TIP_MR_XATHUUX_TANK = "Tanque: defensivo para {SPELL:473898}.",
	DGN_TIP_MR_XATHUUX_HEALER = "Sanador: daño de grupo durante {SPELL:474197}.",

	DGN_TIP_MR_LITHIEL_STEPS = "1. {SPELL:1218203}: separaos (6+ metros) — cada impacto genera Wild Imps; mátalos rápido.|n2. Mata al Vilefiend invocado ({SPELL:474408}) antes de la siguiente oleada de imps.|n3. {SPELL:1224478}: se escuda y lanza una oleada de fuego vil por la sala — usa el gateway para escapar (el golpe acumula +50% de daño de fuego recibido, y los demonios alcanzados se potencian).",
	DGN_TIP_MR_LITHIEL_TANK = "Tanque: recoge rápido al Vilefiend y a los imps.",
	DGN_TIP_MR_LITHIEL_HEALER = "Sanador: quien reciba {SPELL:1224478} sufre daño de fuego acumulado — mantenlos altos.",

	-- Den of Nalorakk -----------------------------------------------------------
	DGN_TIP_DN_HOARDMONGER_STEPS = "1. {SPELL:1234233}: durante 7 segundos llueve comida podrida que deja Rotten Mushrooms — esquiva los impactos y no toques las setas.|n2. {SPELL:1253268} es un cono frontal — nunca te pongas delante.|n3. {SPELL:1235118} golpea a todos (ignora armadura) — ve lleno.",
	DGN_TIP_DN_HOARDMONGER_TANK = "Tanque: el cono te sigue — apunta al jefe lejos del grupo.",
	DGN_TIP_DN_HOARDMONGER_HEALER = "Sanador: curación de grupo tras cada {SPELL:1235118}.",

	DGN_TIP_DN_SENTINEL_STEPS = "1. Los Raging Squalls ({SPELL:1235623}) vagan mucho rato por la arena — sigue sorteándolos.|n2. Los carámbanos de {SPELL:1235783} impactan y revelan un Fractured Shivercore — destrúyelo.|n3. {SPELL:1235656}: un velo de hielo absorbe daño mientras la tormenta empuja a todos y hace tictac al grupo — rompe el escudo RÁPIDO.",
	DGN_TIP_DN_SENTINEL_TANK = "Tanque: mantén al jefe lejos de los squalls.",
	DGN_TIP_DN_SENTINEL_HEALER = "Sanador: disipa/cura a través de {SPELL:1235548} (DoT de escarcha de 16 s); todos hacen tictac durante {SPELL:1235656}.",

	DGN_TIP_DN_NALORAKK_STEPS = "1. {SPELL:1243011}: Nalorakk derriba a Zul'jarra y osos espirituales cargan hacia ella — ponte en su camino para interceptarlos (cada oso que la alcanza desata un grito horrible).|n2. {SPELL:1255385} empuja a todos — cuidado con tu posición cerca de peligros.|n3. {SPELL:1243569} tritura al tanque durante 4 segundos — ayuda con externos si los tienes.",
	DGN_TIP_DN_NALORAKK_TANK = "Tanque: {SPELL:1243569} = golpes acumulados, +50% de daño por golpe — defensivo grande, CADA vez.",
	DGN_TIP_DN_NALORAKK_HEALER = "Sanador: el tanque pica fuerte durante {SPELL:1243569}; curación de grupo tras cada rugido.",

	-- The Blinding Vale -----------------------------------------------------------
	DGN_TIP_BV_TRINITY_STEPS = "1. Tres jefes a la vez — sigue el orden de objetivos de tu tanque.|n2. Lekshi se lanza entre las zonas de marga ({SPELL:1234850}) y va sembrando semillas de Lightblossom — quédate fuera de sus trayectorias.|n3. Kezkitt canaliza un rayo sobre cada semilla ({SPELL:1235564}): PONTE EN el rayo para frenar el crecimiento (una semilla sin absorber prolifera a los 10 segundos).|n4. Meittik golpea fuerte al tanque ({SPELL:1234753}).",
	DGN_TIP_BV_TRINITY_TANK = "Tanque: defensivo para {SPELL:1234753}; vigila el {SPELL:1261276} de Lekshi.",
	DGN_TIP_BV_TRINITY_HEALER = "Sanador: los que absorben el rayo sufren daño Sagrado constante — mantenlos en pie.",

	DGN_TIP_BV_IKUZZ_STEPS = "1. {SPELL:1236746} empuja a todos y brotan raíces donde están los jugadores — déjalas en los bordes.|n2. {SPELL:1237091}: se fija y persigue a un jugador 10 segundos — corre, no dejes que te alcance.|n3. Sigue esquivando las erupciones de espinas ({SPELL:1236709}).",
	DGN_TIP_BV_IKUZZ_TANK = "Tanque: recógelo en cuanto termine la persecución.",
	DGN_TIP_BV_IKUZZ_HEALER = "Sanador: mantén sano al perseguido — que te pille duele.",

	DGN_TIP_BV_RUIA_STEPS = "1. El guardián cambia de forma (oso, lechúcico, haranir) — cada una con sus trucos.|n2. Esquiva los círculos de impacto de {SPELL:1240098}.|n3. {SPELL:1241058} deja un sangrado que solo para cuando el objetivo está curado AL MÁXIMO — avísalo.|n4. Fase final ({SPELL:1241067}): todo cae cada pocos segundos — guarda cooldowns y sigue moviéndote.",
	DGN_TIP_BV_RUIA_TANK = "Tanque: la forma de oso pega más fuerte — defensivo para {SPELL:1240222}.",
	DGN_TIP_BV_RUIA_HEALER = "Sanador: {SPELL:1241058} sangra hasta que el jugador esté a vida COMPLETA — súbelo de inmediato.",

	DGN_TIP_BV_ZIEKKET_STEPS = "1. Los orbes de Lightbloom ({SPELL:1246858}) derivan hacia Ziekket — tócalos para reventarlos antes de que lo alcancen.|n2. Los Lightspawn Lashers no paran de brotar ({SPELL:1246372}, y los dormidos despiertan) — mátalos de verdad.|n3. Ojo a tus pies con {SPELL:1246753} y cuidado con el {SPELL:1253690}.",
	DGN_TIP_BV_ZIEKKET_TANK = "Tanque: defensivo para {SPELL:1247685}; recoge a los lashers.",
	DGN_TIP_BV_ZIEKKET_HEALER = "Sanador: daño de grupo constante — espera un pico si se cuela un orbe.",

	-- Voidscar Arena ----------------------------------------------------------------
	DGN_TIP_VA_TAZRAH_STEPS = "1. {SPELL:1222274} arrastra a todos hacia sí durante 6 segundos — corre contra el tirón; el centro duele muchísimo.|n2. Tras cada teletransporte ({SPELL:1262901}) atacan Ethereal Shades — quémalos.|n3. Esquiva los {SPELL:1225011}.",
	DGN_TIP_VA_TAZRAH_TANK = "Tanque: defensivo para {SPELL:1222085}.",
	DGN_TIP_VA_TAZRAH_HEALER = "Sanador: la grieta hace tictac a todos mientras corren — mantén estable al grupo.",

	DGN_TIP_VA_ATROXUS_STEPS = "1. Los Toxic Creepers ({SPELL:1222371}) salen de las charcas — mátalos rápido.|n2. Quédate fuera del cono {SPELL:1263977} y de los círculos {SPELL:1226120}.|n3. {SPELL:1262497} te lanza hacia atrás — no te pongas con una charca a la espalda.",
	DGN_TIP_VA_ATROXUS_TANK = "Tanque: defensivo para {SPELL:1222642}; apunta el aliento lejos del grupo.",
	DGN_TIP_VA_ATROXUS_HEALER = "Sanador: pre-cura antes de {SPELL:1262497}; el veneno castiga los pies despistados.",

	DGN_TIP_VA_CHARONUS_STEPS = "1. Un Gravitic Orb ({SPELL:1263982}) persigue a cada jugador — lleva el tuyo a una Unstable Singularity ({SPELL:1282770}; a menos de 6 metros se destruye).|n2. {SPELL:1227264}: todos salen volando más un DoT de 20 segundos — elige suelo seguro antes del golpe.|n3. Esquiva los proyectiles de {SPELL:1222758} (contacto = daño + empujón).",
	DGN_TIP_VA_CHARONUS_TANK = "Tanque: posicionamiento tranquilo — deja sitio para que los jugadores lleven sus orbes.",
	DGN_TIP_VA_CHARONUS_HEALER = "Sanador: tras {SPELL:1227264} todo el grupo lleva un DoT largo — ahí las curas grandes.",

	-- Nexus-Point Xenas ---------------------------------------------------------------
	DGN_TIP_NX_KASRETH_STEPS = "1. ¿{SPELL:1251785} en ti? Pisa DENTRO de un rayo de leyline ({SPELL:1251183}) — quita el debuff (aturdimiento corto, buen trato).|n2. Los demás: NO crucéis las leylines (daño + ralentización acumulada).|n3. Energía llena = {SPELL:1257509}: gran zona de impacto, despeja — luego quedan charcos arcanos ({SPELL:1264048}).",
	DGN_TIP_NX_KASRETH_TANK = "Tanque: mantén al jefe lejos de las leylines.",
	DGN_TIP_NX_KASRETH_HEALER = "Sanador: Sparkburn hace tictac a todos tras cada detonación.",

	DGN_TIP_NX_NYSARRA_STEPS = "1. Separaos — los golpes de {SPELL:1249020} salpican a 14 metros.|n2. Matad a los adds Null Vanguard ({SPELL:1252703}) RÁPIDO: lo que siga vivo es devorado ({SPELL:1271684}), la cura y estalla sobre el grupo.|n3. Esquiva las {SPELL:1264439}.",
	DGN_TIP_NX_NYSARRA_TANK = "Tanque: te salta encima con un combo de tajos ({SPELL:1247937}) — defensivo, prepárate para el remate.",
	DGN_TIP_NX_NYSARRA_HEALER = "Sanador: daño disperso tras {SPELL:1249020}; estallido de grupo si los adds sobreviven a la devoración.",

	DGN_TIP_NX_LOTHRAXION_STEPS = "1. {SPELL:1255503}: separaos — los impactos salpican a 8 metros y generan Fractured Images.|n2. {SPELL:1257567}: se esconde entre sus reflejos y todos canalizan — encuentra al Lothraxion REAL e interrúmpelo.|n3. Los reflejos parpadean con empujones ({SPELL:1255531}); no pises las {SPELL:1255310} del suelo.",
	DGN_TIP_NX_LOTHRAXION_TANK = "Tanque: {SPELL:1255335} es un tajo doble que graba cicatrices en el suelo — apúntalo lejos del grupo.",
	DGN_TIP_NX_LOTHRAXION_HEALER = "Sanador: DoTs Sagrados tras cada {SPELL:1255503}; daño constante hasta que entre la interrupción del Guile.",

	-- Magisters' Terrace ---------------------------------------------------------------
	DGN_TIP_MT_ARCANOTRON_STEPS = "1. Cuando reposta ({SPELL:474345}), los Energy Orbs son atraídos hacia él — intercéptalos; mientras tanto recibe +20% de daño: ¡ventana de burst!|n2. Los jugadores encadenados ({SPELL:1214038}) quedan enraizados (magia) — disipa o libéralos.|n3. {SPELL:1214081} empuja a todos y deja residuos a sus pies — sal de ahí.",
	DGN_TIP_MT_ARCANOTRON_TANK = "Tanque: {SPELL:474496} te lanza por los aires — mantén la espalda despejada.",
	DGN_TIP_MT_ARCANOTRON_HEALER = "Sanador: disipa {SPELL:1214038} (raíz mágica) rápido.",

	DGN_TIP_MT_SERANEL_STEPS = "1. {SPELL:1225193} pacifica a todos FUERA de la Suppression Zone ({SPELL:1224903}) — entra EN la zona para la oleada (pero la zona te silencia, no te quedes).|n2. Purga/roba su {SPELL:1248689} (+100% de velocidad de ataque) en cuanto esté activa.|n3. {SPELL:1225787} rebota a un jugador cercano — separaos.",
	DGN_TIP_MT_SERANEL_TANK = "Tanque: una Ward sin purgar duplica su velocidad de ataque — defensivo hasta que se vaya.",
	DGN_TIP_MT_SERANEL_HEALER = "Sanador: los jugadores marcados hacen tictac; recuerda que dentro de la zona no se lanza nada.",

	DGN_TIP_MT_GEMELLUS_STEPS = "1. {SPELL:1223847} (al inicio y a media vida): se divide en tres.|n2. {SPELL:1253709}: ¿vinculado a uno? CORRE a tocarlo — eso rompe el vínculo y quita su escudo de absorción.|n3. {SPELL:1224299} te atrae — sal corriendo.",
	DGN_TIP_MT_GEMELLUS_TANK = "Tanque: reagrupa al trío tras cada {SPELL:1223847} para que los vinculados alcancen el suyo.",
	DGN_TIP_MT_GEMELLUS_HEALER = "Sanador: los vinculados reciben +20% de daño hasta romper su vínculo.",

	DGN_TIP_MT_DEGENTRIUS_STEPS = "1. {SPELL:1215897}: DoTs de vacío con duraciones distintas — cuando el tuyo expire, salen Entropy Orbs desde TU posición: apártate antes del grupo.|n2. {SPELL:1215087} rebota en 4 puntos — ABSORBE un impacto (un jugador por punto), o estalla en Void Destruction.|n3. {SPELL:1280113} machaca al tanque y lanza a quien esté a menos de 8 metros — dadle espacio al tanque.",
	DGN_TIP_MT_DEGENTRIUS_TANK = "Tanque: defensivo para {SPELL:1280113}; tanquéalo lejos del grupo.",
	DGN_TIP_MT_DEGENTRIUS_HEALER = "Sanador: los DoTs de Entropy pegan fuerte — mantén en pie a los portadores mientras se recolocan.",

	-- Skyreach ----------------------------------------------------------------------
	DGN_TIP_SR_RANJIT_STEPS = "1. {SPELL:1258148} vuela en línea recta frente a él — hazte a un lado.|n2. {SPELL:156793}: un impacto en el centro más remolinos errantes que te lanzan — sigue sorteando.|n3. {SPELL:153757} golpea a todos con un sangrado — ve lleno.|n4. {SPELL:1252733} lanza lejos a sus objetivos — mira qué hay detrás de ti.",
	DGN_TIP_SR_RANJIT_TANK = "Tanque: mantenlo fuera de las trayectorias de los vórtices.",
	DGN_TIP_SR_RANJIT_HEALER = "Sanador: daño de grupo más sangrados tras cada {SPELL:153757}.",

	DGN_TIP_SR_ARAKNATH_STEPS = "1. {SPELL:154162}: los ensamblajes canalizan luz al jefe y lo CURAN — ponte en un rayo para bloquearlo.|n2. {SPELL:154115}: un brazazo por un solo lado — que te dé acumula un debuff de daño brutal.|n3. {SPELL:154135} golpea a todos — prepárate.",
	DGN_TIP_SR_ARAKNATH_TANK = "Tanque: nunca absorbas los rayos tú — su golpe cae justo durante la absorción.",
	DGN_TIP_SR_ARAKNATH_HEALER = "Sanador: los que absorben rayos hacen tictac constante; curación de grupo en {SPELL:154135}.",

	DGN_TIP_SR_RUKHRAN_STEPS = "1. {SPELL:1253527}: 3 segundos de plumas en todas direcciones — rompe la línea de visión tras un pilar.|n2. {SPELL:1253510} golpea al grupo e invoca un Sunwing que se fija en alguien y pulsa fuego — mátalo rápido; el fijado mantiene distancia.|n3. Repite — plumas tras cobertura, ave abajo rápido.",
	DGN_TIP_SR_RUKHRAN_TANK = "Tanque: defensivo para {SPELL:1253519} (golpazo + DoT de quemadura).",
	DGN_TIP_SR_RUKHRAN_HEALER = "Sanador: daño de grupo pulsante mientras viva un Sunwing — pide su muerte.",

	DGN_TIP_SR_VIRYX_STEPS = "1. {SPELL:154396}: un lanzamiento de 3 segundos que destroza al tanque — INTERRÚMPELO, siempre.|n2. {SPELL:1253998}: un Solar Zealot agarra a un jugador para tirarlo del balcón — liberadlo rápido.|n3. ¿{SPELL:1253531} en ti? Llévalo bien lejos — deja Blazing Ground.",
	DGN_TIP_SR_VIRYX_TANK = "Tanque: cada {SPELL:154396} que se cuele duele — mantened firme el orden de interrupciones.",
	DGN_TIP_SR_VIRYX_HEALER = "Sanador: {SPELL:1253538} pone DoTs de fuego en varios jugadores a la vez.",

	-- Pit of Saron ----------------------------------------------------------------
	DGN_TIP_PS_GARFROST_STEPS = "1. {SPELL:1262029}: la forja pulsa escarcha acumulada — ESCÓNDETE DETRÁS de un bloque de saronita, bloquea la radiación.|n2. {SPELL:1261546} machaca todo alrededor del objetivo principal — quédate a 5+ metros del tanque; junto al mineral, el golpe rompe el mineral en vez de aturdir.|n3. {SPELL:1261847} golpea a todos y destroza TODO el mineral — llega más vía {SPELL:1261286}.|n4. Quédate fuera del {SPELL:1261799}.",
	DGN_TIP_PS_GARFROST_TANK = "Tanque: aparca junto a un bloque de mineral — {SPELL:1261546} romperá el mineral, no a ti.",
	DGN_TIP_PS_GARFROST_HEALER = "Sanador: pico de grupo en {SPELL:1261847}; escarcha acumulada en quien esté sin cobertura.",

	DGN_TIP_PS_KRICKICK_STEPS = "1. {SPELL:1264363}: Ick se fija y persigue a un jugador salpicando Blight y Plague Globs — corre amplio; el resto sigue pegando.|n2. {SPELL:1264027}: Krick se teletransporta a un círculo ritual e invoca Shades — cambiad y matadlos.|n3. {SPELL:1264336}: esquiva la oleada y los globs que ruedan hacia ti.|n4. Nunca pises el Blight ({SPELL:1264299}).",
	DGN_TIP_PS_KRICKICK_TANK = "Tanque: {SPELL:1264287} deja un charco sobre ti — apúntalo al borde.",
	DGN_TIP_PS_KRICKICK_HEALER = "Sanador: mantén vivo al perseguido; daño de grupo en {SPELL:1264336}.",

	DGN_TIP_PS_TYRANNUS_STEPS = "1. {SPELL:1262772} congela los Bone Piles alrededor de su objetivo — ponte junto a montones cuando estés marcado: los congelados no levantan adds.|n2. {SPELL:1263406} levanta los montones restantes — Plaguespreaders primero.|n3. Sigue esquivando {SPELL:1263756} y el {SPELL:1276948} de Rimefang.|n4. {SPELL:1276648} = golpe de grupo + DoT, y los montones infundidos dan adds peores.",
	DGN_TIP_PS_TYRANNUS_TANK = "Tanque: {SPELL:1262582} te catapulta y acumula +200% de daño de sombras — defensivo y agárrate.",
	DGN_TIP_PS_TYRANNUS_HEALER = "Sanador: DoTs de grupo tras {SPELL:1276648}; pico en el tanque justo tras el Brand.",

	-- Seat of the Triumvirate --------------------------------------------------------
	DGN_TIP_ST_ZURAAL_STEPS = "1. {SPELL:1268916} golpea todo lo que tenga DELANTE — nunca te pongas frente al jefe.|n2. {SPELL:1263304} (energía llena): arrastra a todos y luego estalla con empujón — sal a tiempo; los adds también son arrastrados.|n3. {SPELL:1263399} genera adds Coalesced Void — límpialos antes de Crashing Void.|n4. {SPELL:1263282} deja Void Sludge ({SPELL:244588}) — mantén el suelo limpio.",
	DGN_TIP_ST_ZURAAL_TANK = "Tanque: defensivo para {SPELL:1263440} (tajo triple).",
	DGN_TIP_ST_ZURAAL_HEALER = "Sanador: golpe de grupo grande en {SPELL:1263304}.",

	DGN_TIP_ST_SAPRISH_STEPS = "1. Las Void Bombs ({SPELL:247175}) caen en posiciones de jugadores — NO las toques; déjalas en los bordes.|n2. {SPELL:1280064}: sombras se lanzan hacia cada jugador y detonan las bombas que cruzan — traza tu línea libre de bombas.|n3. {SPELL:1263523} enciende TODAS las bombas a la vez — cuantas menos, más suave.|n4. Interrumpe el {SPELL:248831} de Shadewing (golpe de grupo + desorientación).",
	DGN_TIP_ST_SAPRISH_TANK = "Tanque: mantén al trío junto; el salto de Darkfang ({SPELL:245738}) deja sangrando a su víctima.",
	DGN_TIP_ST_SAPRISH_HEALER = "Sanador: las víctimas del salto sangran; estallido de grupo en {SPELL:1263523}.",

	DGN_TIP_ST_NEZHAR_STEPS = "1. {SPELL:1263528} empuja a todos — cuidado con tu posición cerca de tormentas.|n2. {SPELL:1263538} y las {SPELL:1277358} siembran el caos — mata tentáculos, esquiva las Umbral Waves del portal.|n3. Las zonas de {SPELL:1263532} pegan fuerte, dentro peor — fuera, rápido.|n4. {SPELL:244750} destroza al tanque — interrúmpelo cuando puedas.",
	DGN_TIP_ST_NEZHAR_TANK = "Tanque: aguanta {SPELL:244750} cuando no haya interrupción lista.",
	DGN_TIP_ST_NEZHAR_HEALER = "Sanador: {SPELL:1263542} = varios DoTs carcomiendo a la vez.",

	DGN_TIP_ST_LURA_STEPS = "1. Las Notes of Despair siguen irradiando ({SPELL:1265421}) hasta silenciarlas — dirige tu {SPELL:1265426} A TRAVÉS de las notas (el rayo también golpea a aliados en la línea, apunta despejado).|n2. {SPELL:1265689}: 20 segundos de dolor alrededor de cada nota activa — rómpelas rápido.|n3. {SPELL:1264151}: rayos de vacío rotatorios — muévete con los huecos.|n4. {SPELL:1266003} es una canalización letal de 10 segundos — todos los defensivos, y a curar a tope.",
	DGN_TIP_ST_LURA_TANK = "Tanque: tras {SPELL:1266001} todos salen volando — reagrupaos rápido.",
	DGN_TIP_ST_LURA_HEALER = "Sanador: golpes de grupo de {SPELL:1265421} más las auras de las notas — romper notas ES el plan de curación.",

	-- Algeth'ar Academy ----------------------------------------------------------------
	DGN_TIP_AA_VEXAMUS_STEPS = "1. Los {SPELL:385974} derivan hacia el jefe — absorbedlos, un jugador por orbe (golpecito); cada orbe que ÉL absorbe estalla sobre todo el grupo.|n2. {SPELL:386173}: llévate la tuya aparte — revienta en un charco de {SPELL:386201}.|n3. Energía llena = {SPELL:388537}: golpe de grupo más erupciones repetidas bajo los jugadores — sigue moviéndote.",
	DGN_TIP_AA_VEXAMUS_TANK = "Tanque: {SPELL:385958} revienta todo lo que tenga delante — defensivo, apúntalo lejos del grupo.",
	DGN_TIP_AA_VEXAMUS_HEALER = "Sanador: los portadores de bomba hacen tictac; daño de grupo por cada orbe que llegue al jefe.",

	DGN_TIP_AA_ANCIENT_STEPS = "1. {SPELL:388796}: durante 4 segundos germinan semillas bajo todos — esquiva; las falladas dejan Lashers dormidos.|n2. Con energía llena ({SPELL:388923}) despiertan TODOS los Lashers dormidos a la vez — límpialos antes.|n3. {SPELL:388623} lanza una rama que se vuelve un add grande — mátalo e INTERRUMPE su {SPELL:396640}.",
	DGN_TIP_AA_ANCIENT_TANK = "Tanque: {SPELL:388544} duplica el daño físico que recibes — defensivo, cada vez.",
	DGN_TIP_AA_ANCIENT_HEALER = "Sanador: limpia {SPELL:389033} (veneno) antes de que se acumule.",

	DGN_TIP_AA_CRAWTH_STEPS = "1. {SPELL:377004} estalla bajo cada jugador e interrumpe lanzamientos — DEJA de lanzar, luego separaos.|n2. {SPELL:377034}: mira a alguien y barre un cono hacia allí — sal de él.|n3. {SPELL:377182}: marca en una portería — la de fuego la aturde y recibe un 75% más de daño.",
	DGN_TIP_AA_CRAWTH_TANK = "Tanque: defensivo para {SPELL:376997} (golpe + sangrado de 10 s).",
	DGN_TIP_AA_CRAWTH_HEALER = "Sanador: daño de grupo pesado tras el chillido; el tanque sangra.",

	DGN_TIP_AA_DORAGOSA_STEPS = "1. ¿{SPELL:374341} en ti? Aléjala del grupo — estalla en 8 metros.|n2. {SPELL:388820} arrastra a todos y luego explota — SAL CORRIENDO antes del estallido.|n3. {SPELL:389011} se acumula con cada mecánica que comas — a 3 stacks revienta en un Arcane Rift; mantente limpio.|n4. No pises el suelo de {SPELL:389007}.",
	DGN_TIP_AA_DORAGOSA_TANK = "Tanque: defensivo para {SPELL:1282251}.",
	DGN_TIP_AA_DORAGOSA_HEALER = "Sanador: vigila los stacks de {SPELL:389011} — los portadores hacen más tictac por stack.",
})

merge(ns._mhLocales and ns._mhLocales.ptBR, {
	-- Windrunner Spire ----------------------------------------------------------
	DGN_TIP_WS_DUO_STEPS = "1. Dois chefes — divida o dano para que morram quase juntos.|n2. Interrompa Shadow Bolt; saia dos círculos de cuspe ({SPELL:472745}) — não desperdice chão.|n3. Amaldiçoado ({SPELL:474105})? Peça dispel rápido — ou controle a Dark Entity que ela gera até sumir.|n4. Fisgado por {SPELL:472793} durante o grito? Posicione-se para ser puxado ATRAVÉS da dama fantasma — isso quebra a conjuração dela.",
	DGN_TIP_WS_DUO_TANK = "Tanque: defensivo para {SPELL:472888}; mova os chefes quando o chão encher.",
	DGN_TIP_WS_DUO_HEALER = "Curandeiro: muito dano de grupo durante {SPELL:472736}; dissipe {SPELL:474105} rápido.",

	DGN_TIP_WS_EMBER_STEPS = "1. Fogo = ruim. Deixe as poças de fogo ({SPELL:466556}) nas bordas, mantenha o centro limpo.|n2. Com energia cheia: corra ATÉ o chefe para {SPELL:465904} e depois desvie de cada Fire Breath.|n3. Poças antigas geram redemoinhos de fogo — continue desviando.",
	DGN_TIP_WS_EMBER_TANK = "Tanque: defensivo para {SPELL:466064}.",
	DGN_TIP_WS_EMBER_HEALER = "Curandeiro: dano de grupo pesado durante {SPELL:465904}.",

	DGN_TIP_WS_KROLUK_STEPS = "1. Círculos marrons = ruins, saia deles.|n2. Junte-se a um aliado antes de {SPELL:1253026} terminar (sobreponha os círculos roxos).|n3. Fixado ou alvo do salto ({SPELL:1283247})? Leve-o para LONGE do grupo.|n4. Quando surgirem adds (perto de dois terços e um terço de vida): mate-os rápido — o Phantasmal Mystic primeiro, e continue interrompendo.",
	DGN_TIP_WS_KROLUK_TANK = "Tanque: defensivo para {SPELL:467620}; esteja pronto para segurar o segundo {SPELL:1283247}.",
	DGN_TIP_WS_KROLUK_HEALER = "Curandeiro: dano de grupo durante {SPELL:472043}.",

	DGN_TIP_WS_HEART_STEPS = "1. Os stacks de {SPELL:1216042} estão batendo em você? Pise numa flecha de vento (Turbulent Arrow) com 2-3 stacks — ela limpa o DoT e te faz saltar por cima da onda de choque.|n2. Guarde uma flecha para a explosão grande na energia cheia ({SPELL:468429}).|n3. Espalhem-se um pouco para {SPELL:1253979} e usem os círculos grandes para limpar o chão elétrico.|n4. Alvo de {SPELL:474528}? Fique parado e deixe os outros saírem; todos os demais: fora do cone frontal.",
	DGN_TIP_WS_HEART_TANK = "Tanque: defensivo para {SPELL:472662}; aponte o empurrão para LONGE das poças.",
	DGN_TIP_WS_HEART_HEALER = "Curandeiro: cure primeiro quem tiver muitos stacks de {SPELL:1216042}; cura extra depois de {SPELL:1253979}.",

	-- Maisara Caverns ------------------------------------------------------------
	DGN_TIP_MC_MUROJIN_STEPS = "1. Dois chefes (caçador e ave) — mate-os quase juntos, ou o sobrevivente enfurece.|n2. Armadilhas de gelo ({SPELL:1243741}), círculos verdes ({SPELL:1243900}) e o {SPELL:1260643} frontal = ruins, fique fora.|n3. Alvo de {SPELL:1249478} (o mergulho da ave)? Corra PARA DENTRO de uma armadilha de gelo — o congelamento para o mergulho. Os demais: afastem-se desse jogador.",
	DGN_TIP_MC_MUROJIN_TANK = "Tanque: defensivo para {SPELL:1266480}.",
	DGN_TIP_MC_MUROJIN_HEALER = "Curandeiro: dissipe {SPELL:1246666} (doença) — dano de grupo pesado.",

	DGN_TIP_MC_VORDAZA_STEPS = "1. O chefe gera Unstable Phantoms ({SPELL:1251204}) que perseguem jogadores. MATE-os antes que alcancem alguém — um fantasma que chega ao alvo (ou toca outro fantasma) estoura com dano pesado por perto.|n2. Cada fantasma morto grita: dano de grupo inevitável — mate-os UM de cada vez.|n3. Desvie da onda frontal de {SPELL:1252054} (ela te empurra), dos orbes flutuantes e de Soulrot.|n4. Alguém preso num Deathshroud? Liberte-o rápido; interrompa {SPELL:1250708} e desvie dos redemoinhos enquanto isso.",
	DGN_TIP_MC_VORDAZA_TANK = "Tanque: defensivo para {SPELL:1251554}.",
	DGN_TIP_MC_VORDAZA_HEALER = "Curandeiro: cada fantasma morto grita ({SPELL:1251813}) = dano de grupo — cure entre as mortes espaçadas.",

	DGN_TIP_MC_RAKTUL_STEPS = "1. O chefe salta sobre três jogadores ({SPELL:1252676}) e deixa Soulbind Totems — espalhem-se para os totens caírem separados, não seja esmagado, e destrua os totens rápido.|n2. Fique fora do chão de Chill of Death.|n3. Fase de alma ({SPELL:1253788}): você é arrancado do corpo — controle e interrompa os adds grandes enquanto corre de volta ao corpo.|n4. Desvie dos redemoinhos do Deathgorged Vessel.",
	DGN_TIP_MC_RAKTUL_TANK = "Tanque: defensivo para {SPELL:1251023}; deixe as poças LONGE do grupo.",
	DGN_TIP_MC_RAKTUL_HEALER = "Curandeiro: dano de grupo pesado durante Deathgorged Vessel e quando os totens quebram.",

	-- Murder Row -----------------------------------------------------------------
	DGN_TIP_MR_KYSTIA_STEPS = "1. Kystia se clona ({SPELL:1264095}) — controle ou atordoe as cópias; todas canalizam Felstorm.|n2. {SPELL:474240}: ela teleporta para cima de um jogador e explode com empurrão — saia do estouro.|n3. Fique fora do cone {SPELL:1253813} da Nibbles (fogo contínuo).|n4. Quando Nibbles mudar para a forma de luz, ela canaliza {SPELL:1230304} na Kystia — troque de alvo então.",
	DGN_TIP_MR_KYSTIA_TANK = "Tanque: mantenha o cone {SPELL:1253813} da Nibbles apontado para longe do grupo.",
	DGN_TIP_MR_KYSTIA_HEALER = "Curandeiro: pico de dano quando {SPELL:474240} cai; dano constante em quem as cópias de Felstorm rasparem.",

	DGN_TIP_MR_ZAEN_STEPS = "1. {SPELL:474545}: ele atira em todos na LINHA DE VISÃO dele — quebre-a: esconda-se atrás das caixas e pilares antes do tiro (também deixa um sangramento de 15 s).|n2. {SPELL:474765}: carga chove sobre os jogadores e te arremessa — saia das marcas.|n3. {SPELL:474478}: 3 segundos de fogo pesado no grupo todo — esteja cheio, use um defensivo.|n4. Desvie das Fire Bombs ({SPELL:1214352}).",
	DGN_TIP_MR_ZAEN_TANK = "Tanque: defensivo para {SPELL:1222795}.",
	DGN_TIP_MR_ZAEN_HEALER = "Curandeiro: grupo cheio antes de {SPELL:474478}; sangramentos batem em quem levou o tiro.",

	DGN_TIP_MR_XATHUUX_STEPS = "1. {SPELL:1214637} mira um jogador — leve-o para LONGE do grupo e saia do impacto.|n2. {SPELL:474197}: dano pesado em todos — defensivos e continue se movendo.|n3. Golpes grandes no tanque ({SPELL:473898}) — dê calma ao curandeiro em volta deles.",
	DGN_TIP_MR_XATHUUX_TANK = "Tanque: defensivo para {SPELL:473898}.",
	DGN_TIP_MR_XATHUUX_HEALER = "Curandeiro: dano de grupo durante {SPELL:474197}.",

	DGN_TIP_MR_LITHIEL_STEPS = "1. {SPELL:1218203}: espalhem-se (6+ metros) — cada impacto gera Wild Imps; mate-os rápido.|n2. Mate o Vilefiend invocado ({SPELL:474408}) antes da próxima leva de imps.|n3. {SPELL:1224478}: ela se escuda e manda uma onda de fogo vil pela sala — use o gateway para escapar (o golpe acumula +50% de dano de fogo recebido, e demônios atingidos ficam fortalecidos).",
	DGN_TIP_MR_LITHIEL_TANK = "Tanque: pegue o Vilefiend e os imps rápido.",
	DGN_TIP_MR_LITHIEL_HEALER = "Curandeiro: quem levar {SPELL:1224478} sofre dano de fogo acumulado — mantenha-os altos.",

	-- Den of Nalorakk -----------------------------------------------------------
	DGN_TIP_DN_HOARDMONGER_STEPS = "1. {SPELL:1234233}: por 7 segundos chove comida podre que deixa Rotten Mushrooms — desvie dos impactos e não toque nos cogumelos.|n2. {SPELL:1253268} é um cone frontal — nunca fique na frente.|n3. {SPELL:1235118} atinge todos (ignora armadura) — fique cheio.",
	DGN_TIP_DN_HOARDMONGER_TANK = "Tanque: o cone segue você — aponte o chefe para longe do grupo.",
	DGN_TIP_DN_HOARDMONGER_HEALER = "Curandeiro: cura de grupo depois de cada {SPELL:1235118}.",

	DGN_TIP_DN_SENTINEL_STEPS = "1. Os Raging Squalls ({SPELL:1235623}) vagam muito tempo pela arena — continue desviando.|n2. Os sincelos de {SPELL:1235783} caem e revelam um Fractured Shivercore — destrua-o.|n3. {SPELL:1235656}: um véu de gelo absorve dano enquanto a tempestade empurra todos e bate no grupo — quebre o escudo RÁPIDO.",
	DGN_TIP_DN_SENTINEL_TANK = "Tanque: mantenha o chefe longe dos squalls.",
	DGN_TIP_DN_SENTINEL_HEALER = "Curandeiro: dissipe/cure através de {SPELL:1235548} (DoT de gelo de 16 s); todos sofrem durante {SPELL:1235656}.",

	DGN_TIP_DN_NALORAKK_STEPS = "1. {SPELL:1243011}: Nalorakk derruba Zul'jarra e ursos espirituais investem contra ela — fique no caminho deles para interceptá-los (cada urso que a alcança dispara um grito terrível).|n2. {SPELL:1255385} empurra todos — cuidado com sua posição perto de perigos.|n3. {SPELL:1243569} tritura o tanque por 4 segundos — ajude com externos se tiver.",
	DGN_TIP_DN_NALORAKK_TANK = "Tanque: {SPELL:1243569} = golpes acumulados, +50% de dano por golpe — defensivo grande, TODA vez.",
	DGN_TIP_DN_NALORAKK_HEALER = "Curandeiro: o tanque sofre picos durante {SPELL:1243569}; cura de grupo após cada rugido.",

	-- The Blinding Vale -----------------------------------------------------------
	DGN_TIP_BV_TRINITY_STEPS = "1. Três chefes ao mesmo tempo — siga a ordem de alvos do seu tanque.|n2. Lekshi dispara entre as áreas de húmus ({SPELL:1234850}) e vai semeando Lightblossom — fique fora das trajetórias.|n3. Kezkitt canaliza um feixe em cada semente ({SPELL:1235564}): FIQUE NO feixe para frear o crescimento (uma semente sem soak prolifera em 10 segundos).|n4. Meittik bate forte no tanque ({SPELL:1234753}).",
	DGN_TIP_BV_TRINITY_TANK = "Tanque: defensivo para {SPELL:1234753}; cuidado com o {SPELL:1261276} da Lekshi.",
	DGN_TIP_BV_TRINITY_HEALER = "Curandeiro: quem soaka o feixe sofre dano Sagrado constante — mantenha-os de pé.",

	DGN_TIP_BV_IKUZZ_STEPS = "1. {SPELL:1236746} empurra todos e raízes brotam onde os jogadores estão — deixe-as nas bordas.|n2. {SPELL:1237091}: ele fixa e persegue um jogador por 10 segundos — corra, não deixe que ele te alcance.|n3. Continue desviando das erupções de espinhos ({SPELL:1236709}).",
	DGN_TIP_BV_IKUZZ_TANK = "Tanque: pegue-o de volta assim que a caçada terminar.",
	DGN_TIP_BV_IKUZZ_HEALER = "Curandeiro: mantenha o perseguido saudável — ser pego dói.",

	DGN_TIP_BV_RUIA_STEPS = "1. O guardião troca de forma (urso, coruja lunar, haranir) — cada uma com seus truques.|n2. Desvie dos círculos de impacto de {SPELL:1240098}.|n3. {SPELL:1241058} deixa um sangramento que só para quando o alvo é curado por COMPLETO — avise.|n4. Fase final ({SPELL:1241067}): tudo cai a cada poucos segundos — guarde cooldowns e continue se movendo.",
	DGN_TIP_BV_RUIA_TANK = "Tanque: a forma de urso bate mais forte — defensivo para {SPELL:1240222}.",
	DGN_TIP_BV_RUIA_HEALER = "Curandeiro: {SPELL:1241058} sangra até o jogador estar com vida CHEIA — encha-o imediatamente.",

	DGN_TIP_BV_ZIEKKET_STEPS = "1. Os orbes de Lightbloom ({SPELL:1246858}) derivam até Ziekket — toque neles para estourá-los antes que o alcancem.|n2. Os Lightspawn Lashers não param de brotar ({SPELL:1246372}, e os dormentes despertam) — mate-os de verdade.|n3. Cuidado com os pés por causa de {SPELL:1246753} e atenção ao {SPELL:1253690}.",
	DGN_TIP_BV_ZIEKKET_TANK = "Tanque: defensivo para {SPELL:1247685}; pegue os lashers.",
	DGN_TIP_BV_ZIEKKET_HEALER = "Curandeiro: dano de grupo constante — espere um pico se um orbe passar.",

	-- Voidscar Arena ----------------------------------------------------------------
	DGN_TIP_VA_TAZRAH_STEPS = "1. {SPELL:1222274} suga todos por 6 segundos — corra contra a sucção; o centro dói demais.|n2. Depois de cada teleporte ({SPELL:1262901}) Ethereal Shades atacam — queime-os.|n3. Desvie dos {SPELL:1225011}.",
	DGN_TIP_VA_TAZRAH_TANK = "Tanque: defensivo para {SPELL:1222085}.",
	DGN_TIP_VA_TAZRAH_HEALER = "Curandeiro: a fenda bate em todos enquanto correm — mantenha o grupo estável.",

	DGN_TIP_VA_ATROXUS_STEPS = "1. Toxic Creepers ({SPELL:1222371}) rastejam das poças — mate-os rápido.|n2. Fique fora do cone {SPELL:1263977} e dos círculos {SPELL:1226120}.|n3. {SPELL:1262497} te arremessa para trás — não fique com uma poça às costas.",
	DGN_TIP_VA_ATROXUS_TANK = "Tanque: defensivo para {SPELL:1222642}; aponte o bafo para longe do grupo.",
	DGN_TIP_VA_ATROXUS_HEALER = "Curandeiro: pré-cure antes de {SPELL:1262497}; veneno castiga pés desatentos.",

	DGN_TIP_VA_CHARONUS_STEPS = "1. Um Gravitic Orb ({SPELL:1263982}) persegue cada jogador — leve o seu até uma Unstable Singularity ({SPELL:1282770}; a menos de 6 metros ele é destruído).|n2. {SPELL:1227264}: todos voam mais um DoT de 20 segundos — escolha chão seguro antes do golpe.|n3. Desvie dos projéteis de {SPELL:1222758} (contato = dano + empurrão).",
	DGN_TIP_VA_CHARONUS_TANK = "Tanque: posicionamento calmo — dê espaço para os jogadores levarem seus orbes.",
	DGN_TIP_VA_CHARONUS_HEALER = "Curandeiro: depois de {SPELL:1227264} o grupo todo carrega um DoT longo — as curas grandes vão ali.",

	-- Nexus-Point Xenas ---------------------------------------------------------------
	DGN_TIP_NX_KASRETH_STEPS = "1. {SPELL:1251785} em você? Pise DENTRO de um feixe de leyline ({SPELL:1251183}) — ele limpa o debuff (atordoamento curto, troca justa).|n2. Os demais: NÃO cruzem as leylines (dano + lentidão acumulada).|n3. Energia cheia = {SPELL:1257509}: zona de impacto grande, abra espaço — depois ficam poças arcanas ({SPELL:1264048}).",
	DGN_TIP_NX_KASRETH_TANK = "Tanque: mantenha o chefe longe das leylines.",
	DGN_TIP_NX_KASRETH_HEALER = "Curandeiro: Sparkburn bate em todos depois de cada detonação.",

	DGN_TIP_NX_NYSARRA_STEPS = "1. Espalhem-se — os golpes de {SPELL:1249020} respingam a 14 metros.|n2. Matem os adds Null Vanguard ({SPELL:1252703}) RÁPIDO: o que sobreviver é devorado ({SPELL:1271684}), cura ela e estoura no grupo.|n3. Desvie das {SPELL:1264439}.",
	DGN_TIP_NX_NYSARRA_TANK = "Tanque: ela salta em você com um combo de talhos ({SPELL:1247937}) — defensivo, prepare-se para o golpe final.",
	DGN_TIP_NX_NYSARRA_HEALER = "Curandeiro: dano espalhado depois de {SPELL:1249020}; estouro de grupo se os adds sobreviverem à devoração.",

	DGN_TIP_NX_LOTHRAXION_STEPS = "1. {SPELL:1255503}: espalhem-se — impactos respingam 8 metros e geram Fractured Images.|n2. {SPELL:1257567}: ele se esconde entre os reflexos e todos canalizam — ache o Lothraxion VERDADEIRO e interrompa-o.|n3. Os reflexos piscam por aí com empurrões ({SPELL:1255531}); fique fora das {SPELL:1255310} no chão.",
	DGN_TIP_NX_LOTHRAXION_TANK = "Tanque: {SPELL:1255335} é um talho duplo que grava cicatrizes no chão — aponte-o para longe do grupo.",
	DGN_TIP_NX_LOTHRAXION_HEALER = "Curandeiro: DoTs Sagrados depois de cada {SPELL:1255503}; dano constante até a interrupção do Guile entrar.",

	-- Magisters' Terrace ---------------------------------------------------------------
	DGN_TIP_MT_ARCANOTRON_STEPS = "1. Quando ele reabastece ({SPELL:474345}), Energy Orbs são puxados até ele — intercepte-os; enquanto isso ele recebe +20% de dano: janela de burst!|n2. Jogadores acorrentados ({SPELL:1214038}) ficam enraizados (magia) — dissipe ou liberte-os.|n3. {SPELL:1214081} arremessa todos e deixa resíduo aos pés dele — saia de lá.",
	DGN_TIP_MT_ARCANOTRON_TANK = "Tanque: {SPELL:474496} te lança longe — mantenha as costas livres.",
	DGN_TIP_MT_ARCANOTRON_HEALER = "Curandeiro: dissipe {SPELL:1214038} (raiz mágica) rápido.",

	DGN_TIP_MT_SERANEL_STEPS = "1. {SPELL:1225193} pacifica todos FORA da Suppression Zone ({SPELL:1224903}) — entre NA zona para a onda (mas a zona te silencia, não demore).|n2. Purgue/roube a {SPELL:1248689} dele (+100% de velocidade de ataque) sempre que estiver ativa.|n3. {SPELL:1225787} quica para um jogador próximo — espalhem-se.",
	DGN_TIP_MT_SERANEL_TANK = "Tanque: uma Ward sem purge dobra a velocidade de ataque dele — defensivo até ela sumir.",
	DGN_TIP_MT_SERANEL_HEALER = "Curandeiro: jogadores marcados sofrem dano contínuo; lembre que dentro da zona não se conjura.",

	DGN_TIP_MT_GEMELLUS_STEPS = "1. {SPELL:1223847} (no início e na metade da vida): ele se divide em três.|n2. {SPELL:1253709}: vinculado a um deles? CORRA até ele e toque-o — isso quebra o vínculo e remove o escudo de absorção.|n3. {SPELL:1224299} te puxa — corra para fora de novo.",
	DGN_TIP_MT_GEMELLUS_TANK = "Tanque: reagrupe o trio depois de cada {SPELL:1223847} para os vinculados alcançarem o seu.",
	DGN_TIP_MT_GEMELLUS_HEALER = "Curandeiro: vinculados recebem +20% de dano até quebrarem o vínculo.",

	DGN_TIP_MT_DEGENTRIUS_STEPS = "1. {SPELL:1215897}: DoTs do Vazio com durações diferentes — quando o seu expirar, Entropy Orbs saem da SUA posição: afaste-se do grupo antes.|n2. {SPELL:1215087} quica em 4 pontos — SOAKE um impacto (um jogador por ponto), ou ele estoura em Void Destruction.|n3. {SPELL:1280113} esmaga o tanque e arremessa quem estiver a menos de 8 metros — dê espaço ao tanque.",
	DGN_TIP_MT_DEGENTRIUS_TANK = "Tanque: defensivo para {SPELL:1280113}; tanque-o longe do grupo.",
	DGN_TIP_MT_DEGENTRIUS_HEALER = "Curandeiro: os DoTs de Entropy batem forte — mantenha os portadores de pé enquanto se reposicionam.",

	-- Skyreach ----------------------------------------------------------------------
	DGN_TIP_SR_RANJIT_STEPS = "1. {SPELL:1258148} voa em linha reta à frente dele — dê um passo para o lado.|n2. {SPELL:156793}: um impacto no centro mais redemoinhos errantes que te lançam — continue ziguezagueando.|n3. {SPELL:153757} atinge todos com sangramento — fique cheio.|n4. {SPELL:1252733} sopra os alvos para longe — veja o que há atrás de você.",
	DGN_TIP_SR_RANJIT_TANK = "Tanque: mantenha-o fora das rotas dos vórtices.",
	DGN_TIP_SR_RANJIT_HEALER = "Curandeiro: dano de grupo mais sangramentos depois de cada {SPELL:153757}.",

	DGN_TIP_SR_ARAKNATH_STEPS = "1. {SPELL:154162}: constructos canalizam luz no chefe e o CURAM — fique num feixe para bloqueá-lo.|n2. {SPELL:154115}: um golpe de braço de um lado só — ser atingido acumula um debuff de dano brutal.|n3. {SPELL:154135} atinge todos — esteja pronto.",
	DGN_TIP_SR_ARAKNATH_TANK = "Tanque: nunca soake os feixes você mesmo — o golpe dele cai bem durante o soak.",
	DGN_TIP_SR_ARAKNATH_HEALER = "Curandeiro: quem soaka feixes sofre dano contínuo; cura de grupo no {SPELL:154135}.",

	DGN_TIP_SR_RUKHRAN_STEPS = "1. {SPELL:1253527}: 3 segundos de penas para todo lado — quebre a linha de visão atrás de um pilar.|n2. {SPELL:1253510} atinge o grupo e invoca um Sunwing que fixa em alguém e pulsa fogo — mate-o rápido; o fixado mantém distância.|n3. Repita — penas atrás de cobertura, ave no chão rápido.",
	DGN_TIP_SR_RUKHRAN_TANK = "Tanque: defensivo para {SPELL:1253519} (golpe grande + DoT de queimadura).",
	DGN_TIP_SR_RUKHRAN_HEALER = "Curandeiro: dano de grupo pulsante enquanto um Sunwing viver — peça a morte dele.",

	DGN_TIP_SR_VIRYX_STEPS = "1. {SPELL:154396}: uma conjuração de 3 segundos que arrebenta o tanque — INTERROMPA, toda vez.|n2. {SPELL:1253998}: um Solar Zealot agarra um jogador para jogá-lo da sacada — libertem-no rápido.|n3. {SPELL:1253531} em você? Leve-o bem para longe — ele deixa Blazing Ground.",
	DGN_TIP_SR_VIRYX_TANK = "Tanque: cada {SPELL:154396} que passar dói — mantenham a ordem de interrupções firme.",
	DGN_TIP_SR_VIRYX_HEALER = "Curandeiro: {SPELL:1253538} coloca DoTs de fogo em vários jogadores ao mesmo tempo.",

	-- Pit of Saron ----------------------------------------------------------------
	DGN_TIP_PS_GARFROST_STEPS = "1. {SPELL:1262029}: a forja pulsa gelo acumulado — ESCONDA-SE ATRÁS de um bloco de saronita, ele bloqueia a radiação.|n2. {SPELL:1261546} esmaga tudo ao redor do alvo principal — fique a 5+ metros do tanque; perto do minério, o golpe quebra o minério em vez de atordoar.|n3. {SPELL:1261847} atinge todos e estilhaça TODO o minério — minério novo vem via {SPELL:1261286}.|n4. Fique fora do {SPELL:1261799}.",
	DGN_TIP_PS_GARFROST_TANK = "Tanque: estacione ao lado de um bloco de minério — {SPELL:1261546} esmaga o minério, não você.",
	DGN_TIP_PS_GARFROST_HEALER = "Curandeiro: pico de grupo no {SPELL:1261847}; gelo acumulado em quem ficar sem cobertura.",

	DGN_TIP_PS_KRICKICK_STEPS = "1. {SPELL:1264363}: Ick fixa e persegue um jogador espalhando Blight e Plague Globs — corra largo; o resto continua batendo.|n2. {SPELL:1264027}: Krick teleporta para um círculo ritual e invoca Shades — troquem e matem.|n3. {SPELL:1264336}: desvie da onda e dos globs rolando até você.|n4. Nunca pise no Blight ({SPELL:1264299}).",
	DGN_TIP_PS_KRICKICK_TANK = "Tanque: {SPELL:1264287} deixa uma poça em você — aponte-a para a borda.",
	DGN_TIP_PS_KRICKICK_HEALER = "Curandeiro: mantenha o perseguido vivo; dano de grupo no {SPELL:1264336}.",

	DGN_TIP_PS_TYRANNUS_STEPS = "1. {SPELL:1262772} congela os Bone Piles ao redor do alvo — fique perto de pilhas quando for marcado: pilhas congeladas não levantam adds.|n2. {SPELL:1263406} levanta as pilhas restantes — Plaguespreaders primeiro.|n3. Continue desviando de {SPELL:1263756} e do {SPELL:1276948} do Rimefang.|n4. {SPELL:1276648} = golpe de grupo + DoT, e pilhas infundidas dão adds piores.",
	DGN_TIP_PS_TYRANNUS_TANK = "Tanque: {SPELL:1262582} te catapulta e acumula +200% de dano sombrio — defensivo e segure firme.",
	DGN_TIP_PS_TYRANNUS_HEALER = "Curandeiro: DoTs de grupo depois de {SPELL:1276648}; pico no tanque logo após o Brand.",

	-- Seat of the Triumvirate --------------------------------------------------------
	DGN_TIP_ST_ZURAAL_STEPS = "1. {SPELL:1268916} atinge tudo NA FRENTE dele — nunca fique de frente para o chefe.|n2. {SPELL:1263304} (energia cheia): ele puxa todos e depois estoura com empurrão — saia a tempo; os adds também são puxados.|n3. {SPELL:1263399} gera adds Coalesced Void — limpe-os antes do Crashing Void.|n4. {SPELL:1263282} deixa Void Sludge ({SPELL:244588}) — mantenha o chão limpo.",
	DGN_TIP_ST_ZURAAL_TANK = "Tanque: defensivo para {SPELL:1263440} (talho triplo).",
	DGN_TIP_ST_ZURAAL_HEALER = "Curandeiro: golpe de grupo grande no {SPELL:1263304}.",

	DGN_TIP_ST_SAPRISH_STEPS = "1. As Void Bombs ({SPELL:247175}) caem nas posições dos jogadores — NÃO toque nelas; deixe-as nas bordas.|n2. {SPELL:1280064}: sombras disparam contra cada jogador e detonam bombas que cruzarem — trace sua linha livre de bombas.|n3. {SPELL:1263523} acende TODAS as bombas de uma vez — quanto menos bombas, mais suave.|n4. Interrompa o {SPELL:248831} do Shadewing (golpe de grupo + desorientação).",
	DGN_TIP_ST_SAPRISH_TANK = "Tanque: mantenha o trio junto; o bote do Darkfang ({SPELL:245738}) deixa a vítima sangrando.",
	DGN_TIP_ST_SAPRISH_HEALER = "Curandeiro: vítimas do bote sangram; estouro de grupo no {SPELL:1263523}.",

	DGN_TIP_ST_NEZHAR_STEPS = "1. {SPELL:1263528} arremessa todos — cuidado com a posição perto de tempestades.|n2. {SPELL:1263538} e os {SPELL:1277358} espalham caos — mate tentáculos, desvie das Umbral Waves do portal.|n3. As zonas de {SPELL:1263532} batem forte, dentro é pior — fora, rápido.|n4. {SPELL:244750} arrebenta o tanque — interrompa quando puder.",
	DGN_TIP_ST_NEZHAR_TANK = "Tanque: aguente {SPELL:244750} quando não houver interrupção pronta.",
	DGN_TIP_ST_NEZHAR_HEALER = "Curandeiro: {SPELL:1263542} = vários DoTs roendo ao mesmo tempo.",

	DGN_TIP_ST_LURA_STEPS = "1. As Notes of Despair continuam irradiando ({SPELL:1265421}) até serem silenciadas — direcione seu {SPELL:1265426} ATRAVÉS das notas (o feixe também atinge aliados na linha, mire livre).|n2. {SPELL:1265689}: 20 segundos de dor ao redor de cada nota ativa — quebre as notas rápido.|n3. {SPELL:1264151}: feixes do Vazio rotativos — mova-se com as brechas.|n4. {SPELL:1266003} é uma canalização letal de 10 segundos — todos os defensivos, e cure com tudo.",
	DGN_TIP_ST_LURA_TANK = "Tanque: depois de {SPELL:1266001} todos voam — reagrupem rápido.",
	DGN_TIP_ST_LURA_HEALER = "Curandeiro: golpes de grupo de {SPELL:1265421} mais as auras das notas — quebrar notas É o plano de cura.",

	-- Algeth'ar Academy ----------------------------------------------------------------
	DGN_TIP_AA_VEXAMUS_STEPS = "1. Os {SPELL:385974} derivam até o chefe — soakem, um jogador por orbe (golpe pequeno); cada orbe que ELE absorver estoura no grupo todo.|n2. {SPELL:386173}: leve a sua para longe — ela estoura numa poça de {SPELL:386201}.|n3. Energia cheia = {SPELL:388537}: golpe de grupo mais erupções repetidas sob os jogadores — continue se movendo.",
	DGN_TIP_AA_VEXAMUS_TANK = "Tanque: {SPELL:385958} explode tudo na frente dele — defensivo, aponte-o para longe do grupo.",
	DGN_TIP_AA_VEXAMUS_HEALER = "Curandeiro: portadores de bomba sofrem dano contínuo; dano de grupo por cada orbe que chegar ao chefe.",

	DGN_TIP_AA_ANCIENT_STEPS = "1. {SPELL:388796}: por 4 segundos sementes brotam sob todos — desvie; sementes perdidas deixam Lashers dormentes.|n2. Com energia cheia ({SPELL:388923}) TODOS os Lashers dormentes acordam de uma vez — limpe-os antes.|n3. {SPELL:388623} arremessa um galho que vira um add grande — mate-o e INTERROMPA o {SPELL:396640} dele.",
	DGN_TIP_AA_ANCIENT_TANK = "Tanque: {SPELL:388544} dobra o dano físico que você recebe — defensivo, toda vez.",
	DGN_TIP_AA_ANCIENT_HEALER = "Curandeiro: limpe {SPELL:389033} (veneno) antes de acumular alto.",

	DGN_TIP_AA_CRAWTH_STEPS = "1. {SPELL:377004} explode sob cada jogador e interrompe conjurações — PARE de conjurar, depois espalhem-se.|n2. {SPELL:377034}: ela encara alguém e varre um cone naquela direção — saia dele.|n3. {SPELL:377182}: marque num gol — o gol de fogo a atordoa e ela recebe 75% mais dano.",
	DGN_TIP_AA_CRAWTH_TANK = "Tanque: defensivo para {SPELL:376997} (golpe + sangramento de 10 s).",
	DGN_TIP_AA_CRAWTH_HEALER = "Curandeiro: dano de grupo pesado depois do grito; o tanque sangra.",

	DGN_TIP_AA_DORAGOSA_STEPS = "1. {SPELL:374341} em você? Leve-a para longe do grupo — ela estoura em 8 metros.|n2. {SPELL:388820} puxa todos e depois explode — CORRA PARA FORA antes do estouro.|n3. {SPELL:389011} acumula a cada mecânica que você comer — com 3 stacks vira um Arcane Rift; fique limpo.|n4. Fique fora do chão de {SPELL:389007}.",
	DGN_TIP_AA_DORAGOSA_TANK = "Tanque: defensivo para {SPELL:1282251}.",
	DGN_TIP_AA_DORAGOSA_HEALER = "Curandeiro: vigie os stacks de {SPELL:389011} — portadores sofrem mais por stack.",
})
