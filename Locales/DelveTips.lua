--[[
	Midnight Helper — Delve Coach tip bodies (per delve, EN + NL).
	Sources: primarily Icy Veins delve guides; Torment's Rise also Boostmatch/Wowhead.
	Line breaks use |n; bullets use • for readable lists in-game.

	Locale audit: 11 delves × 4 sections = 44 body keys in enUS and nlNL each (88 total).
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
	-- Display names (coach title / picker; rosterName stays English for POI matching)
	DELVE_NAME_SHADOW_ENCLAVE = "The Shadow Enclave",
	DELVE_NAME_COLLEGIATE_CALAMITY = "Collegiate Calamity",
	DELVE_NAME_THE_DARKWAY = "The Darkway",
	DELVE_NAME_PARHELION_PLAZA = "Parhelion Plaza",
	DELVE_NAME_ATAL_AMAN = "Atal'Aman",
	DELVE_NAME_TWILIGHT_CRYPTS = "Twilight Crypts",
	DELVE_NAME_GULF_OF_MEMORY = "The Gulf of Memory",
	DELVE_NAME_GRUDGE_PIT = "The Grudge Pit",
	DELVE_NAME_SUNKILLER_SANCTUM = "Sunkiller Sanctum",
	DELVE_NAME_SHADOWGUARD_POINT = "Shadowguard Point",
	DELVE_NAME_TORMENTS_RISE = "Torment's Rise",

	-- The Shadow Enclave
	DELVE_TIP_SHADOW_ENCLAVE_OVERVIEW = "• Southwest Eversong Woods (Ruins of Deathholme).|n• Three variants: Mirror Shine, Shadowy Supplies, Traitor's Due.|n• Traitor's Due: stop rituals, void orbs, cultists (leveling).|n• Final boss every run: Lord Antenorian.",
	DELVE_TIP_SHADOW_ENCLAVE_ROUTE = "• Mirror Shine: carry mirrors through dark halls; hit Shadow Nexuses to spread light (avoids grues).|n• Shadowy Supplies: loot Twilight's Blade valuables from mobs or the ground.|n• Traitor's Due: chase Antenorian through the delve to the boss room.",
	DELVE_TIP_SHADOW_ENCLAVE_TRASH = "• In mirror light, you and enemies are Dazzled (higher crit chance).|n• Interrupt shadow casters.|n• Clear Twilight's Blade during Supplies.|n• Do not stack in hazardous ground; pull carefully in tight corridors.",
	DELVE_TIP_SHADOW_ENCLAVE_BOSS = "• Interrupt {SPELL:@shadow_bolt} whenever you can.|n• Teleports leave a damaging puddle — keep him near the center.|n• {SPELL:@shadowveil_annihilation}: lethal channel — destroy 3 Shadow Orbs (only the unshielded orb takes damage; each kill unshields the next).|n• All orbs dead breaks his shield, stops the channel, and he takes extra damage briefly.|n• Save burst for orbs; Valeera helps break them.",

	-- Collegiate Calamity
	DELVE_TIP_COLLEGIATE_CALAMITY_OVERVIEW = "• Northwest Silvermoon / Eversong Woods (Thalassian University).|n• Academy Under Siege: void portals.|n• Faculty of Fear: disguised Twilight's Blade.|n• Invasive Glow: Lightbloom + Deweeder.|n• Three different final bosses.",
	DELVE_TIP_COLLEGIATE_CALAMITY_ROUTE = "• Under Siege: close void portals and kill Devouring Host.|n• Faculty of Fear: Eye of Revelation — suspicious students glow yellow through walls.|n• Invasive Glow: Deweeder kills small Lightbloom and damages large ones.|n• Clear Luminibulb patches on the main level.",
	DELVE_TIP_COLLEGIATE_CALAMITY_TRASH = "• Under Siege: prioritize portal closers.|n• Faculty: reveal disguised students, then kill before they ambush.|n• Glow: channel Deweeder while moving.|n• Do not skip Luminibulb patches or the run drags.",
	DELVE_TIP_COLLEGIATE_CALAMITY_BOSS = "• Hydrangea (Glow): kill {SPELL:@wildroot_weave} roots before {SPELL:@lightbloom_salvo}; dodge light zones.|n• Garand (Faculty): dodge {SPELL:@shadow_laceration} or use a defensive; spread for {SPELL:@twilight_crash} jumps.|n• Voidscorned Vagrant (Siege): sidestep {SPELL:@void_eruption}; always interrupt {SPELL:@terrifying_power}.",

	-- The Darkway
	DELVE_TIP_THE_DARKWAY_OVERVIEW = "• North Silvermoon / Eversong Woods (the Arcway).|n• Focusers Under Pressure, Leyline Technician, Ogre Powered (7 Unstable Aberrations).|n• Final boss on all runs: Infiltrator Gulkat.",
	DELVE_TIP_THE_DARKWAY_ROUTE = "• Focusers: find ley line focusers and return them to the delve center.|n• Leyline: tap conduits once per line to empower three focus crystals.|n• Ogre Powered: kill 7 Unstable Aberrations in the middle section before Gulkat.",
	DELVE_TIP_THE_DARKWAY_TRASH = "• Interrupt Twilight Seekers and Arcane Deluge on aberrations.|n• Leyline variant: kill Twilight's Blade while routing power.|n• Pull away from corners in narrow Arcway halls.",
	DELVE_TIP_THE_DARKWAY_BOSS = "• Interrupt Twilight Seekers.|n• Dodge {SPELL:@abyssal_burst} (frontal cone).|n• {SPELL:@illusory_deceit}: exploding illusions — keep distance while handling Gulkat.",

	-- Parhelion Plaza
	DELVE_TIP_PARHELION_PLAZA_OVERVIEW = "• West Isle of Quel'Danas (Sunwell area).|n• Unlocks with March on Quel'Danas (late March 2026).|n• Three variants; tough boss on all: Gladius Slaurna.|n• One of the harder Midnight delves.",
	DELVE_TIP_PARHELION_PLAZA_ROUTE = "• Bombing Run: Improvised Arcane Device for void portals (40s carry limit; drop in combat).|n• Holding the Line: Tempest Keep weapons + rebuild barricades.|n• March of the Arcane Parade: Sentinel machines destroy void pylons.",
	DELVE_TIP_PARHELION_PLAZA_TRASH = "• Interrupt Sacrificial Voidcaller Void Bolt whenever possible.|n• Bombing Run: do not lose portals by stepping out at the wrong time.|n• Clear Devouring Host waves before Slaurna.",
	DELVE_TIP_PARHELION_PLAZA_BOSS = "• Kill three Sacrificial Voidcallers quickly (interrupt Void Bolt).|n• If any live through {SPELL:@devouring_nova}, Slaurna gains damage done and damage reduction — wipe risk on high tiers.|n• Dodge {SPELL:@voidscar_raze} (ground line).|n• Fight near center to avoid knockback off the platform.",

	-- Atal'Aman
	DELVE_TIP_ATAL_AMAN_OVERVIEW = "• West Zul'Aman (Eversong border).|n• Ritual Interrupted, Toadly Unbecoming, Totem Annihilation.|n• Final boss on all: Spiritflayer Jin'Ma.",
	DELVE_TIP_ATAL_AMAN_ROUTE = "• Ritual: rescue kidnapped Spiritpaw furbolgs across the delve.|n• Toadly: dispel hexed Amani with Vilebranch Hex Stick while killing invaders.|n• Totem: destroy cursed totems to free Akil'zon; use eagles for alternate approaches.",
	DELVE_TIP_ATAL_AMAN_TRASH = "• Interrupt Vilebranch casts.|n• Totem variant: prioritize totems on the path.|n• Pull beasts away from hexed NPCs you are trying to save.",
	DELVE_TIP_ATAL_AMAN_BOSS = "• {SPELL:@flaying_knife} splits spirits — each collected spirit gives +10% damage (pick them up deliberately).|n• Dodge {SPELL:@raging_spirits} on the floor.|n• Before {SPELL:@claim_spirits} ends, grab your spirits or Jin'Ma gains their buff.",

	-- Twilight Crypts
	DELVE_TIP_TWILIGHT_CRYPTS_OVERVIEW = "• Southwest Zul'Aman (Broken Throne).|n• Loosed Loa (avoid Mot'amra), Party Crasher, Trapped!|n• Final boss on all: Blademaster Darza.",
	DELVE_TIP_TWILIGHT_CRYPTS_ROUTE = "• Loosed Loa: Evasive Elixir to explore; kill Skeleton Charmers and totems — track Mot'amra, do not cross his path.|n• Party Crasher: escort Explorer, avoid bear traps, open levels with levers.|n• Trapped: save hostages and find levers through the maze.",
	DELVE_TIP_TWILIGHT_CRYPTS_TRASH = "• Mot'amra hits hard with knockback if you walk into him.|n• Party Crasher: watch trap tiles.|n• Interrupt Twilight's Blade summoners.",
	DELVE_TIP_TWILIGHT_CRYPTS_BOSS = "• Sidestep {SPELL:@shade_cleave} — fighting close prevents {SPELL:@dark_pursuit} gap-closer.|n• {SPELL:@bask_in_the_twilight} leaves a void zone.|n• Drag Darza out of it or she gains +30% damage while standing inside.",

	-- The Gulf of Memory
	DELVE_TIP_GULF_OF_MEMORY_OVERVIEW = "• West Harandar (Den of Echoes / Har'alnor).|n• Three variants.|n• Bosses: Lumenia (Munchies / Sporasaur) and Mul'tha'ul (Descent of the Haranir).",
	DELVE_TIP_GULF_OF_MEMORY_ROUTE = "• Alnmoth Munchies: extra-action Alnmoth Storm while moving — devour bushes or help vs Rutaani.|n• Descent: light giant candles; more damage taken in dark areas.|n• Sporasaur: kick green-reticle Sporbits into Sporasaurs to remove their shield.",
	DELVE_TIP_GULF_OF_MEMORY_TRASH = "• Stay in lit areas during Descent.|n• Kick Sporbits before they explode.|n• Channel Alnmoth Storm while moving — you can move and cast.",
	DELVE_TIP_GULF_OF_MEMORY_BOSS = "• Lumenia: kill {SPELL:@radiant_command} add before it reaches you (explodes).|n• Dodge {SPELL:@searing_light} patches unless using them on the add.|n• Mul'tha'ul: interrupt or dispel {SPELL:@hopeless_curse}.|n• Kite away from {SPELL:@tear_it_down} tentacles.|n• Keep distance during {SPELL:@unanswered_call} (high damage, slow walk).",

	-- The Grudge Pit
	DELVE_TIP_GRUDGE_PIT_OVERVIEW = "• Southeast Harandar.|n• Arena-themed delve with three variants.|n• Bosses: Brightthorn, Gyrospore, Mycomight.",
	DELVE_TIP_GRUDGE_PIT_ROUTE = "• Arena Champion: wave arena fights (Sporbits help).|n• Dastardly Rotstalk: heel role — punt fans, taunt crowd (can move while taunting).|n• Lightbloom Invasion: waves, free fighters to blow up spawn points, build defenses.",
	DELVE_TIP_GRUDGE_PIT_TRASH = "• Arena: use Sporbits for damage.|n• Invasion: clear waves before boss.|n• Rotstalk: keep crowd control — fans hurt if ignored.",
	DELVE_TIP_GRUDGE_PIT_BOSS = "• Brightthorn: sidestep {SPELL:@solar_charge} and Overbloom zones; interrupt Bloom Thorn; turn away before {SPELL:@blinding_burst}.|n• Gyrospore: dodge {SPELL:@fungalstorm} zones, then burst during 10s dizzy; step back from Fungsplosion; sidestep Fungal Charge.|n• Mycomight: drop Rancid Rain puddles away from fight area; dodge Fungi's Fist shockwaves; sidestep Fling Chair.",

	-- Sunkiller Sanctum
	DELVE_TIP_SUNKILLER_SANCTUM_OVERVIEW = "• East Voidstorm (Voidspire entrance).|n• Three variants; Esuritus is final boss on two.|n• Not What I Expected: no boss — ends after 3 Corrupted Umbraroot kills.",
	DELVE_TIP_SUNKILLER_SANCTUM_ROUTE = "• Core of the Problem: portals + stop Domanaar stealing Energized Orbs (orb buff: speed + damage reduction).|n• Not What I Expected: kill Lightbloom and Domanaar units, then 3 Corrupted Umbraroot.|n• Gravitational Effect: use micro-singularities to navigate and disable boss shields.",
	DELVE_TIP_SUNKILLER_SANCTUM_TRASH = "• Kill Voidcallers quickly on every pack — they empower Esuritus later.|n• Interrupt Arcane Deluge where it appears.|n• Pick up orbs in Core variant for survivability.",
	DELVE_TIP_SUNKILLER_SANCTUM_BOSS = "• Kill all Voidcallers before {SPELL:@gorge} or he gains +damage for 30s per devour.|n• Interrupt {SPELL:@calling_bolt}.|n• Dispel {SPELL:@coalescing_malediction} or kill the add it spawns.|n• Dodge {SPELL:@crushing_rift} (spawns 4 Voidcallers).",

	-- Shadowguard Point
	DELVE_TIP_SHADOWGUARD_POINT_OVERVIEW = "• West Voidstorm (north of Abundant Voidburrow).|n• Three variants vs Shadowguard Ethereals.|n• Final boss on all: Chief-Arcanist Patram.",
	DELVE_TIP_SHADOWGUARD_POINT_ROUTE = "• Calamitous: overload Void Stabilizers with Arcane Charges (speed buff; explosions kill mobs — do not stand in them).|n• Captured Wildlife: free void creatures (their AoE can still hit you).|n• Stolen Mana: rifle destabilizes mana containers until boss opens.",
	DELVE_TIP_SHADOWGUARD_POINT_TRASH = "• Calamitous: plan overloads safely while carrying Arcane Charges.|n• Ethereal packs: interrupt casts.|n• Wildlife variant: give freed creatures space.",
	DELVE_TIP_SHADOWGUARD_POINT_BOSS = "• Interrupt {SPELL:@void_bolt_patram}.|n• Kill Void Emissary before {SPELL:@submit_to_the_void} ends (you get Vers + CDR; Patram gets the buff if you fail).|n• Sidestep {SPELL:@discordant_hymn} void zones (slow + damage).",

	-- Torment's Rise (Nemesis)
	DELVE_TIP_TORMENTS_RISE_OVERVIEW = "• Voidstorm — Season 1 Nemesis Delve (capstone).|n• Tier ? after any T7 with 1+ life; Tier ?? after any T10 with 1+ life.|n• Boss: Nullaeus.|n• Healer Valeera strongly recommended on Tier ??.",
	DELVE_TIP_TORMENTS_RISE_ROUTE = "• Dedicated instance portal (not a rotating world delve).|n• Use Adventure Guide (Shift-J) or TomTom.|n• Weekly bounty: Beacon of Hope can pull Nullaeus into a normal delve at 50% instead.",
	DELVE_TIP_TORMENTS_RISE_TRASH = "• Pactsworn mobs live in regular delves, not inside Torment's Rise.|n• Pace cooldowns — save defensives and interrupts for Nullaeus.",
	DELVE_TIP_TORMENTS_RISE_BOSS = "• Interrupt {SPELL:@devouring_essence} every cast (DoT + feeds {SPELL:@umbral_rage} stacks).|n• {SPELL:@dread_portal}: 100% damage reduction until all adds die — full AoE burst on spawn.|n• {SPELL:@oblivion_shell} phase is a DPS check.|n• {SPELL:@umbral_rage}: +10% damage per stack if adds or DoTs linger — kill adds fast.",

	-- Party chat (short; spell tokens expand to links for the whole group)
	DELVE_CHAT_SHADOW_ENCLAVE_OVERVIEW = "SW Eversong (Deathholme). Variants: mirrors, supplies, traitor. Final boss: Lord Antenorian.",
	DELVE_CHAT_SHADOW_ENCLAVE_ROUTE = "Mirrors: hit Shadow Nexuses for light. Supplies: loot Twilight valuables. Traitor: stop rituals, chase to boss.",
	DELVE_CHAT_SHADOW_ENCLAVE_TRASH = "Mirror light = Dazzled (more crits). Interrupt shadow casters. Don't stack on bad ground.",
	DELVE_CHAT_SHADOW_ENCLAVE_BOSS = "Kick {SPELL:@shadow_bolt}. Teleport leaves a pool — keep him central. {SPELL:@shadowveil_annihilation}: kill 3 Orbs (only the unshielded orb). Burst orbs.",

	DELVE_CHAT_COLLEGIATE_CALAMITY_OVERVIEW = "NW Silvermoon / Eversong (university). Siege / Faculty / Glow variants. Three different final bosses.",
	DELVE_CHAT_COLLEGIATE_CALAMITY_ROUTE = "Siege: close void portals. Faculty: Eye of Revelation — yellow students through walls. Glow: Deweeder + clear Luminibulb.",
	DELVE_CHAT_COLLEGIATE_CALAMITY_TRASH = "Siege: portals first. Faculty: reveal then kill students. Glow: channel Deweeder while moving.",
	DELVE_CHAT_COLLEGIATE_CALAMITY_BOSS = "Hydrangea: kill {SPELL:@wildroot_weave} before {SPELL:@lightbloom_salvo}. Garand: dodge {SPELL:@shadow_laceration}, spread {SPELL:@twilight_crash}. Vagrant: kick {SPELL:@terrifying_power}.",

	DELVE_CHAT_THE_DARKWAY_OVERVIEW = "North Silvermoon Arcway. Focusers, Leyline, or 7 Aberrations. Boss: Infiltrator Gulkat.",
	DELVE_CHAT_THE_DARKWAY_ROUTE = "Focusers: return ley focusers to center. Leyline: tap conduits for 3 crystals. Ogre: kill 7 Unstable Aberrations mid.",
	DELVE_CHAT_THE_DARKWAY_TRASH = "Interrupt Twilight Seekers and Arcane Deluge. Pull out of tight corners.",
	DELVE_CHAT_THE_DARKWAY_BOSS = "Kick Seekers. Dodge {SPELL:@abyssal_burst}. {SPELL:@illusory_deceit}: stay clear of exploding illusions.",

	DELVE_CHAT_PARHELION_PLAZA_OVERVIEW = "West Isle of Quel'Danas (Sunwell). Three variants — harder delve. Boss: Gladius Slaurna.",
	DELVE_CHAT_PARHELION_PLAZA_ROUTE = "Bombing Run: arcane device for portals (40s carry). Holding the Line: weapons + barricades. Parade: sentinels vs pylons.",
	DELVE_CHAT_PARHELION_PLAZA_TRASH = "Kick Voidcaller Void Bolt. Clear Devouring Host waves before boss.",
	DELVE_CHAT_PARHELION_PLAZA_BOSS = "Kill 3 Voidcallers fast (kick Void Bolt). If one lives through {SPELL:@devouring_nova}, Slaurna buffs hard. Dodge {SPELL:@voidscar_raze}, fight center.",

	DELVE_CHAT_ATAL_AMAN_OVERVIEW = "West Zul'Aman. Ritual / Toadly / Totem variants. Boss: Spiritflayer Jin'Ma.",
	DELVE_CHAT_ATAL_AMAN_ROUTE = "Ritual: rescue furbolgs. Toadly: Hex Stick on hexed Amani. Totem: destroy totems, free Akil'zon.",
	DELVE_CHAT_ATAL_AMAN_TRASH = "Interrupt Vilebranch. Totem run: totems on path first.",
	DELVE_CHAT_ATAL_AMAN_BOSS = "{SPELL:@flaying_knife} spirits = +10% dmg each — pick yours up. Dodge {SPELL:@raging_spirits}. Before {SPELL:@claim_spirits}, collect spirits or Jin'Ma buffs.",

	DELVE_CHAT_TWILIGHT_CRYPTS_OVERVIEW = "SW Zul'Aman (Broken Throne). Loa / Party Crasher / Trapped. Boss: Blademaster Darza.",
	DELVE_CHAT_TWILIGHT_CRYPTS_ROUTE = "Loa: don't cross Mot'amra's path. Party Crasher: escort, traps, levers. Trapped: hostages + levers.",
	DELVE_CHAT_TWILIGHT_CRYPTS_TRASH = "Mot'amra = big knockback on his path. Interrupt summoners. Watch trap tiles.",
	DELVE_CHAT_TWILIGHT_CRYPTS_BOSS = "Dodge {SPELL:@shade_cleave} (melee range stops {SPELL:@dark_pursuit}). Drag Darza out of {SPELL:@bask_in_the_twilight} (+30% dmg inside).",

	DELVE_CHAT_GULF_OF_MEMORY_OVERVIEW = "West Harandar. Munchies / Descent / Sporasaur. Bosses: Lumenia or Mul'tha'ul.",
	DELVE_CHAT_GULF_OF_MEMORY_ROUTE = "Munchies: Alnmoth Storm on the move. Descent: light candles, avoid dark. Sporasaur: kick Sporbits into shielded mobs.",
	DELVE_CHAT_GULF_OF_MEMORY_TRASH = "Stay lit in Descent. Kick Sporbits early. You can move while channeling storm.",
	DELVE_CHAT_GULF_OF_MEMORY_BOSS = "Lumenia: kill {SPELL:@radiant_command} add before it reaches you. Mul'tha'ul: dispel {SPELL:@hopeless_curse}, kite {SPELL:@tear_it_down}, respect {SPELL:@unanswered_call}.",

	DELVE_CHAT_GRUDGE_PIT_OVERVIEW = "SE Harandar arena delve. Champion / Rotstalk / Invasion. Bosses: Brightthorn, Gyrospore, or Mycomight.",
	DELVE_CHAT_GRUDGE_PIT_ROUTE = "Champion: wave arena (Sporbits help). Rotstalk: punt fans, taunt crowd. Invasion: free fighters, blow spawn points.",
	DELVE_CHAT_GRUDGE_PIT_TRASH = "Use Sporbits in arena. Clear invasion waves. Don't ignore Rotstalk fans.",
	DELVE_CHAT_GRUDGE_PIT_BOSS = "Brightthorn: dodge {SPELL:@solar_charge}, interrupt Bloom Thorn, turn from {SPELL:@blinding_burst}. Gyrospore: dodge {SPELL:@fungalstorm}, burst when dizzy. Mycomight: puddles away from fight.",

	DELVE_CHAT_SUNKILLER_SANCTUM_OVERVIEW = "East Voidstorm. Core / Not Expected / Gravity variants. Boss: Esuritus (or 3 Umbraroot, no boss).",
	DELVE_CHAT_SUNKILLER_SANCTUM_ROUTE = "Core: stop Domanaar stealing orbs (speed + DR buff). Not Expected: 3 Corrupted Umbraroot. Gravity: singularities drop shields.",
	DELVE_CHAT_SUNKILLER_SANCTUM_TRASH = "Kill Voidcallers every pack — they buff Esuritus. Pick up orbs in Core.",
	DELVE_CHAT_SUNKILLER_SANCTUM_BOSS = "All Voidcallers dead before {SPELL:@gorge} or +damage stacks. Kick {SPELL:@calling_bolt}. Dispel {SPELL:@coalescing_malediction}. Dodge {SPELL:@crushing_rift} (4 callers).",

	DELVE_CHAT_SHADOWGUARD_POINT_OVERVIEW = "West Voidstorm vs ethereals. Calamitous / Wildlife / Stolen Mana. Boss: Chief-Arcanist Patram.",
	DELVE_CHAT_SHADOWGUARD_POINT_ROUTE = "Calamitous: overload stabilizers with Arcane Charges (don't stand in blasts). Wildlife: free mobs carefully. Mana: rifle containers.",
	DELVE_CHAT_SHADOWGUARD_POINT_TRASH = "Interrupt ethereals. Plan charge carries safely.",
	DELVE_CHAT_SHADOWGUARD_POINT_BOSS = "Kick {SPELL:@void_bolt_patram}. Kill Void Emissary before {SPELL:@submit_to_the_void} or Patram gets the buff. Dodge {SPELL:@discordant_hymn}.",

	DELVE_CHAT_TORMENTS_RISE_OVERVIEW = "Nemesis delve (Voidstorm). Tier ? / ?? rules. Boss Nullaeus — healer Valeera recommended on ??.",
	DELVE_CHAT_TORMENTS_RISE_ROUTE = "Dedicated portal (Shift-J / TomTom). Not a rotating world delve.",
	DELVE_CHAT_TORMENTS_RISE_TRASH = "Save CDs for Nullaeus — no Pactsworn trash inside.",
	DELVE_CHAT_TORMENTS_RISE_BOSS = "Kick every {SPELL:@devouring_essence}. {SPELL:@dread_portal}: AoE adds until dead. {SPELL:@oblivion_shell} = DPS check. Don't stack {SPELL:@umbral_rage}.",
})

merge(ns._mhLocales and ns._mhLocales.nlNL, {
	DELVE_NAME_SHADOW_ENCLAVE = "The Shadow Enclave",
	DELVE_NAME_COLLEGIATE_CALAMITY = "Collegiate Calamity",
	DELVE_NAME_THE_DARKWAY = "The Darkway",
	DELVE_NAME_PARHELION_PLAZA = "Parhelion Plaza",
	DELVE_NAME_ATAL_AMAN = "Atal'Aman",
	DELVE_NAME_TWILIGHT_CRYPTS = "Twilight Crypts",
	DELVE_NAME_GULF_OF_MEMORY = "The Gulf of Memory",
	DELVE_NAME_GRUDGE_PIT = "The Grudge Pit",
	DELVE_NAME_SUNKILLER_SANCTUM = "Sunkiller Sanctum",
	DELVE_NAME_SHADOWGUARD_POINT = "Shadowguard Point",
	DELVE_NAME_TORMENTS_RISE = "Torment's Rise",

	-- The Shadow Enclave
	DELVE_TIP_SHADOW_ENCLAVE_OVERVIEW = "• Zuidwest Eversong Woods (bij Ruins of Deathholme).|n• Drie varianten: Mirror Shine, Shadowy Supplies, Traitor's Due.|n• Traitor's Due: stop rituals, void orbs en cultists (leveling).|n• Eindbaas in elke run: Lord Antenorian.",
	DELVE_TIP_SHADOW_ENCLAVE_ROUTE = "• Mirror Shine: draag spiegels door donkere gangen; raak Shadow Nexuses om licht te verspreiden (voorkomt grues).|n• Shadowy Supplies: pak buit van Twilight's Blade of van de grond.|n• Traitor's Due: achtervolg Antenorian door de delve tot de baaskamer.",
	DELVE_TIP_SHADOW_ENCLAVE_TRASH = "• In spiegellicht zijn jij en vijanden Dazzled (hogere kans op crits).|n• Onderbreek shadow-casters.|n• Ruim Twilight's Blade op tijdens Supplies.|n• Sta niet gestapeld op gevaarlijke grond; pull rustig in smalle gangen.",
	DELVE_TIP_SHADOW_ENCLAVE_BOSS = "• Onderbreek {SPELL:@shadow_bolt} zoveel mogelijk.|n• Bij teleport blijft een schadende plas achter — houd hem bij voorkeur centraal.|n• {SPELL:@shadowveil_annihilation}: dodelijke channel — vernietig 3 Shadow Orbs (alleen de orb zonder schild kan schade krijgen).|n• Alle orbs dood = schild weg, channel stopt, baas neemt kort extra schade.|n• Bewaar burst voor de orbs; Valeera helpt ze sneller te breken.",

	-- Collegiate Calamity
	DELVE_TIP_COLLEGIATE_CALAMITY_OVERVIEW = "• Noordwest Silvermoon / Eversong Woods (Thalassian University).|n• Academy Under Siege: void-portals.|n• Faculty of Fear: vermomde Twilight's Blade.|n• Invasive Glow: Lightbloom + Deweeder.|n• Drie verschillende eindbazen.",
	DELVE_TIP_COLLEGIATE_CALAMITY_ROUTE = "• Under Siege: sluit void-portals en kill Devouring Host.|n• Faculty of Fear: Eye of Revelation — verdachte studenten gloeien geel door muren.|n• Invasive Glow: Deweeder voor kleine Lightbloom, schade aan grote.|n• Verwijder Luminibulb-patches op het hoofdniveau.",
	DELVE_TIP_COLLEGIATE_CALAMITY_TRASH = "• Under Siege: prioriteit op portals sluiten.|n• Faculty: eerst onthullen, dan studenten killen vóór de ambush.|n• Glow: Deweeder kan je tijdens lopen channelen.|n• Haal Luminibulb-patches niet over.",
	DELVE_TIP_COLLEGIATE_CALAMITY_BOSS = "• Hydrangea (Glow): kap {SPELL:@wildroot_weave}-roots vóór {SPELL:@lightbloom_salvo}; ontwijk lichtzones.|n• Garand (Faculty): ontwijk {SPELL:@shadow_laceration} of gebruik defensive; spreid voor {SPELL:@twilight_crash}.|n• Voidscorned Vagrant (Siege): ontwijk {SPELL:@void_eruption}; onderbreek {SPELL:@terrifying_power} altijd.",

	-- The Darkway
	DELVE_TIP_THE_DARKWAY_OVERVIEW = "• Noord Silvermoon / Eversong Woods (de Arcway).|n• Focusers Under Pressure, Leyline Technician, Ogre Powered (7 Unstable Aberrations).|n• Zelfde eindbaas: Infiltrator Gulkat.",
	DELVE_TIP_THE_DARKWAY_ROUTE = "• Focusers: zoek ley focusers en breng ze terug naar het centrum.|n• Leyline: tap conduits per lijn om drie focus crystals te laden.|n• Ogre Powered: kill 7 Unstable Aberrations in het midden vóór Gulkat.",
	DELVE_TIP_THE_DARKWAY_TRASH = "• Onderbreek Twilight Seekers en Arcane Deluge op aberrations.|n• Leyline: kill Twilight's Blade tijdens het routen.|n• Pull uit hoeken in smalle Arcway-gangen.",
	DELVE_TIP_THE_DARKWAY_BOSS = "• Onderbreek Twilight Seekers.|n• Ontwijk {SPELL:@abyssal_burst} (frontale cone).|n• {SPELL:@illusory_deceit}: illusies exploderen — houd afstand tijdens andere mechanics.",

	-- Parhelion Plaza
	DELVE_TIP_PARHELION_PLAZA_OVERVIEW = "• West Isle of Quel'Danas (Sunwell-gebied).|n• Ontgrendelt met March on Quel'Danas (eind maart 2026).|n• Drie varianten; zware eindbaas: Gladius Slaurna.",
	DELVE_TIP_PARHELION_PLAZA_ROUTE = "• Bombing Run: Improvised Arcane Device voor void-portals (max. 40s dragen; laat vallen in combat).|n• Holding the Line: Tempest Keep-wapens + barricades herstellen.|n• March of the Arcane Parade: Sentinel-machines vernietigen void-pylons.",
	DELVE_TIP_PARHELION_PLAZA_TRASH = "• Onderbreek Sacrificial Voidcaller Void Bolt.|n• Bombing Run: verlaat geen portal op het verkeerde moment.|n• Clear Devouring Host vóór Slaurna.",
	DELVE_TIP_PARHELION_PLAZA_BOSS = "• Kill drie Sacrificial Voidcallers snel (onderbreek Void Bolt).|n• Overleeft er één {SPELL:@devouring_nova}, dan krijgt Slaurna meer damage en damage reduction.|n• Ontwijk {SPELL:@voidscar_raze}.|n• Vecht centraal tegen knockback van het platform.",

	-- Atal'Aman
	DELVE_TIP_ATAL_AMAN_OVERVIEW = "• West Zul'Aman (grens Eversong).|n• Ritual Interrupted, Toadly Unbecoming, Totem Annihilation.|n• Eindbaas: Spiritflayer Jin'Ma.",
	DELVE_TIP_ATAL_AMAN_ROUTE = "• Ritual: red ontvoerde Spiritpaw furbolgs.|n• Toadly: ontwerp hex met Vilebranch Hex Stick en kill invaders.|n• Totem: vernietig cursed totems; gebruik eagles voor andere routes.",
	DELVE_TIP_ATAL_AMAN_TRASH = "• Onderbreek Vilebranch-casts.|n• Totem-variant: totems op je pad eerst.|n• Beasts weg van NPCs die je redt.",
	DELVE_TIP_ATAL_AMAN_BOSS = "• {SPELL:@flaying_knife} splitst spirits — elk opgepakt spirit geeft +10% damage.|n• Ontwijk {SPELL:@raging_spirits} op de grond.|n• Vóór {SPELL:@claim_spirits}: pak jouw spirits, anders bufft Jin'Ma.",

	-- Twilight Crypts
	DELVE_TIP_TWILIGHT_CRYPTS_OVERVIEW = "• Zuidwest Zul'Aman (Broken Throne).|n• Loosed Loa (ontwijk Mot'amra), Party Crasher, Trapped!|n• Eindbaas: Blademaster Darza.",
	DELVE_TIP_TWILIGHT_CRYPTS_ROUTE = "• Loosed Loa: Evasive Elixir om te verkennen; kill Skeleton Charmers en totems — volg Mot'amra, loop niet door zijn pad.|n• Party Crasher: escort Explorer, ontwijk berenvallen, levers voor nieuwe levels.|n• Trapped: red gijzelaars, levers door het doolhof.",
	DELVE_TIP_TWILIGHT_CRYPTS_TRASH = "• Mot'amra doet zware schade + knockback op zijn pad.|n• Party Crasher: let op vallen.|n• Onderbreek Twilight's Blade summoners.",
	DELVE_TIP_TWILIGHT_CRYPTS_BOSS = "• Ontwijk {SPELL:@shade_cleave} — dichtbij vechten voorkomt {SPELL:@dark_pursuit}.|n• {SPELL:@bask_in_the_twilight} laat void-zone achter.|n• Trek Darza eruit of +30% damage zolang ze erin staat.",

	-- The Gulf of Memory
	DELVE_TIP_GULF_OF_MEMORY_OVERVIEW = "• West Harandar (Den of Echoes / Har'alnor).|n• Drie varianten.|n• Bazen: Lumenia (Munchies / Sporasaur) en Mul'tha'ul (Descent of the Haranir).",
	DELVE_TIP_GULF_OF_MEMORY_ROUTE = "• Alnmoth Munchies: extra-action Alnmoth Storm tijdens lopen — bushes of Rutaani.|n• Descent: steek grote kaarsen aan; meer schade in donkere zones.|n• Sporasaur: schop Sporbits (groen reticle) tegen Sporasaurs om schild te breken.",
	DELVE_TIP_GULF_OF_MEMORY_TRASH = "• Blijf in verlichte zones tijdens Descent.|n• Schop Sporbits vóór ze exploderen.|n• Je kunt tijdens Alnmoth Storm bewegen en casten.",
	DELVE_TIP_GULF_OF_MEMORY_BOSS = "• Lumenia: kill {SPELL:@radiant_command}-add vóór hij je bereikt (explodeert).|n• Ontwijk {SPELL:@searing_light}, tenzij je de add daarmee killt.|n• Mul'tha'ul: onderbreek of dispel {SPELL:@hopeless_curse}.|n• Kit weg van {SPELL:@tear_it_down}-tentakels.|n• Afstand tijdens {SPELL:@unanswered_call}.",

	-- The Grudge Pit
	DELVE_TIP_GRUDGE_PIT_OVERVIEW = "• Zuidoost Harandar.|n• Arena-delve met drie varianten.|n• Eindbazen: Brightthorn, Gyrospore, Mycomight.",
	DELVE_TIP_GRUDGE_PIT_ROUTE = "• Arena Champion: golven arena (Sporbits helpen).|n• Dastardly Rotstalk: heel-rol — schop fans, taunt crowd (bewegen tijdens taunt kan).|n• Lightbloom Invasion: golven, bevrijd fighters voor spawn-points, bouw verdediging.",
	DELVE_TIP_GRUDGE_PIT_TRASH = "• Arena: gebruik Sporbits voor damage.|n• Invasion: clear golven vóór de baas.|n• Rotstalk: crowd niet negeren.",
	DELVE_TIP_GRUDGE_PIT_BOSS = "• Brightthorn: ontwijk {SPELL:@solar_charge} en Overbloom; onderbreek Bloom Thorn; draai weg vóór {SPELL:@blinding_burst}.|n• Gyrospore: ontwijk {SPELL:@fungalstorm}, burst tijdens 10s dizzy; stap terug voor Fungsplosion; ontwijk Fungal Charge.|n• Mycomight: Rancid Rain weg van fight-zone; ontwijk Fungi's Fist; ontwijk Fling Chair.",

	-- Sunkiller Sanctum
	DELVE_TIP_SUNKILLER_SANCTUM_OVERVIEW = "• Oost Voidstorm (Voidspire-ingang).|n• Drie varianten; Esuritus is eindbaas op twee.|n• Not What I Expected: geen baas — eindigt na 3 Corrupted Umbraroot.",
	DELVE_TIP_SUNKILLER_SANCTUM_ROUTE = "• Core of the Problem: portals + stop Domanaar met Energized Orbs (buff: snelheid + minder schade).|n• Not What I Expected: kill Lightbloom en Domanaar, daarna 3 Corrupted Umbraroot.|n• Gravitational Effect: micro-singularities om schilden van de baas uit te schakelen.",
	DELVE_TIP_SUNKILLER_SANCTUM_TRASH = "• Kill Voidcallers snel — ze empoweren Esuritus later.|n• Onderbreek Arcane Deluge.|n• Pak orbs in Core-variant voor overleving.",
	DELVE_TIP_SUNKILLER_SANCTUM_BOSS = "• Kill alle Voidcallers vóór {SPELL:@gorge} of hij krijgt +damage per devour (30s).|n• Onderbreek {SPELL:@calling_bolt}.|n• Dispel {SPELL:@coalescing_malediction}.|n• Ontwijk {SPELL:@crushing_rift} (spawnt 4 Voidcallers).",

	-- Shadowguard Point
	DELVE_TIP_SHADOWGUARD_POINT_OVERVIEW = "• West Voidstorm (noord van Abundant Voidburrow).|n• Drie varianten vs Shadowguard Ethereals.|n• Eindbaas: Chief-Arcanist Patram.",
	DELVE_TIP_SHADOWGUARD_POINT_ROUTE = "• Calamitous: overload Void Stabilizers met Arcane Charges (sneller lopen; explosies killen mobs — sta er niet in).|n• Captured Wildlife: bevrijd creatures (hun AoE kan jou raken).|n• Stolen Mana: rifle op mana-containers tot baas opent.",
	DELVE_TIP_SHADOWGUARD_POINT_TRASH = "• Calamitous: plan overloads veilig met Arcane Charges.|n• Onderbreek ethereals.|n• Wildlife: ruimte voor bevrijde creatures.",
	DELVE_TIP_SHADOWGUARD_POINT_BOSS = "• Onderbreek {SPELL:@void_bolt_patram}.|n• Kill Void Emissary vóór {SPELL:@submit_to_the_void} (jij krijgt Vers + CDR; anders bufft Patram).|n• Ontwijk {SPELL:@discordant_hymn} (slow + schade).",

	-- Torment's Rise (Nemesis)
	DELVE_TIP_TORMENTS_RISE_OVERVIEW = "• Voidstorm — Nemesis Delve seizoen 1.|n• Tier ? na elke T7 met 1+ leven; Tier ?? na elke T10 met 1+ leven.|n• Baas: Nullaeus.|n• Healer-Valeera sterk aanbevolen op Tier ??.",
	DELVE_TIP_TORMENTS_RISE_ROUTE = "• Eigen instance-portal (geen roterende world-delve).|n• Adventure Guide (Shift-J) of TomTom.|n• Weekly bounty: Beacon of Hope kan Nullaeus op 50% in een normale delve trekken.",
	DELVE_TIP_TORMENTS_RISE_TRASH = "• Pactsworn zit in normale delves, niet in Torment's Rise.|n• Verdeel cooldowns voor Nullaeus.",
	DELVE_TIP_TORMENTS_RISE_BOSS = "• Onderbreek {SPELL:@devouring_essence} elke cast (DoT + {SPELL:@umbral_rage}-stacks).|n• {SPELL:@dread_portal}: baas 100% damage reduction tot alle adds dood — volle AoE op spawn.|n• {SPELL:@oblivion_shell}: DPS-check.|n• {SPELL:@umbral_rage}: +10% damage per stack — kill adds snel.",

	DELVE_CHAT_SHADOW_ENCLAVE_OVERVIEW = "ZW Eversong (Deathholme). Varianten: spiegels, supplies, traitor. Eindbaas: Lord Antenorian.",
	DELVE_CHAT_SHADOW_ENCLAVE_ROUTE = "Spiegels: Shadow Nexuses voor licht. Supplies: buit looten. Traitor: rituals stoppen, achtervolg naar baas.",
	DELVE_CHAT_SHADOW_ENCLAVE_TRASH = "Spiegellicht = Dazzled (meer crits). Onderbreek casters. Niet stapelen op vuil.",
	DELVE_CHAT_SHADOW_ENCLAVE_BOSS = "Kick {SPELL:@shadow_bolt}. Teleport = plas — houd hem centraal. {SPELL:@shadowveil_annihilation}: 3 Orbs (alleen onbeschermde). Burst orbs.",

	DELVE_CHAT_COLLEGIATE_CALAMITY_OVERVIEW = "NW Silvermoon / Eversong (universiteit). Siege / Faculty / Glow. Drie eindbazen.",
	DELVE_CHAT_COLLEGIATE_CALAMITY_ROUTE = "Siege: sluit portals. Faculty: Eye of Revelation — gele studenten door muren. Glow: Deweeder + Luminibulb.",
	DELVE_CHAT_COLLEGIATE_CALAMITY_TRASH = "Siege: portals eerst. Faculty: onthul, kill studenten. Glow: Deweeder tijdens lopen.",
	DELVE_CHAT_COLLEGIATE_CALAMITY_BOSS = "Hydrangea: kill {SPELL:@wildroot_weave} vóór {SPELL:@lightbloom_salvo}. Garand: ontwijk {SPELL:@shadow_laceration}, spreid {SPELL:@twilight_crash}. Vagrant: kick {SPELL:@terrifying_power}.",

	DELVE_CHAT_THE_DARKWAY_OVERVIEW = "Noord Silvermoon Arcway. Focusers, Leyline of 7 Aberrations. Baas: Infiltrator Gulkat.",
	DELVE_CHAT_THE_DARKWAY_ROUTE = "Focusers: ley focusers naar centrum. Leyline: conduits voor 3 crystals. Ogre: 7 Aberrations mid.",
	DELVE_CHAT_THE_DARKWAY_TRASH = "Onderbreek Seekers en Arcane Deluge. Pull uit hoeken.",
	DELVE_CHAT_THE_DARKWAY_BOSS = "Kick Seekers. Ontwijk {SPELL:@abyssal_burst}. {SPELL:@illusory_deceit}: weg van exploderende illusies.",

	DELVE_CHAT_PARHELION_PLAZA_OVERVIEW = "West Quel'Danas (Sunwell). Drie varianten — zware delve. Baas: Gladius Slaurna.",
	DELVE_CHAT_PARHELION_PLAZA_ROUTE = "Bombing Run: device voor portals (40s dragen). Holding the Line: wapens + barricades. Parade: sentinels vs pylons.",
	DELVE_CHAT_PARHELION_PLAZA_TRASH = "Kick Voidcaller Void Bolt. Clear Devouring Host vóór baas.",
	DELVE_CHAT_PARHELION_PLAZA_BOSS = "Kill 3 Voidcallers snel. Overleeft er één {SPELL:@devouring_nova}, Slaurna bufft hard. Ontwijk {SPELL:@voidscar_raze}, vecht centraal.",

	DELVE_CHAT_ATAL_AMAN_OVERVIEW = "West Zul'Aman. Ritual / Toadly / Totem. Baas: Spiritflayer Jin'Ma.",
	DELVE_CHAT_ATAL_AMAN_ROUTE = "Ritual: red furbolgs. Toadly: Hex Stick. Totem: vernietig totems, Akil'zon.",
	DELVE_CHAT_ATAL_AMAN_TRASH = "Onderbreek Vilebranch. Totem: totems op pad eerst.",
	DELVE_CHAT_ATAL_AMAN_BOSS = "{SPELL:@flaying_knife} spirits = +10% dmg — pak de jouwe. Ontwijk {SPELL:@raging_spirits}. Vóór {SPELL:@claim_spirits}: spirits ophalen.",

	DELVE_CHAT_TWILIGHT_CRYPTS_OVERVIEW = "ZW Zul'Aman (Broken Throne). Loa / Party Crasher / Trapped. Baas: Blademaster Darza.",
	DELVE_CHAT_TWILIGHT_CRYPTS_ROUTE = "Loa: niet door Mot'amra's pad. Party Crasher: escort, vallen. Trapped: gijzelaars + levers.",
	DELVE_CHAT_TWILIGHT_CRYPTS_TRASH = "Mot'amra = knockback op zijn pad. Onderbreek summoners. Let op vallen.",
	DELVE_CHAT_TWILIGHT_CRYPTS_BOSS = "Ontwijk {SPELL:@shade_cleave} (dichtbij = geen {SPELL:@dark_pursuit}). Trek Darza uit {SPELL:@bask_in_the_twilight} (+30% dmg erin).",

	DELVE_CHAT_GULF_OF_MEMORY_OVERVIEW = "West Harandar. Munchies / Descent / Sporasaur. Bazen: Lumenia of Mul'tha'ul.",
	DELVE_CHAT_GULF_OF_MEMORY_ROUTE = "Munchies: Alnmoth Storm onderweg. Descent: kaarsen, uit duisternis. Sporasaur: schop Sporbits in schild.",
	DELVE_CHAT_GULF_OF_MEMORY_TRASH = "Blijf in licht (Descent). Schop Sporbits vroeg. Storm = bewegen mag.",
	DELVE_CHAT_GULF_OF_MEMORY_BOSS = "Lumenia: kill {SPELL:@radiant_command}-add vóór explode. Mul'tha'ul: dispel {SPELL:@hopeless_curse}, kit {SPELL:@tear_it_down}, {SPELL:@unanswered_call}.",

	DELVE_CHAT_GRUDGE_PIT_OVERVIEW = "ZO Harandar arena. Champion / Rotstalk / Invasion. Bazen: Brightthorn, Gyrospore of Mycomight.",
	DELVE_CHAT_GRUDGE_PIT_ROUTE = "Champion: golven (Sporbits). Rotstalk: fans schoppen, taunt crowd. Invasion: fighters vrij, spawn points.",
	DELVE_CHAT_GRUDGE_PIT_TRASH = "Sporbits in arena. Clear invasion-golven. Rotstalk-fans niet negeren.",
	DELVE_CHAT_GRUDGE_PIT_BOSS = "Brightthorn: ontwijk {SPELL:@solar_charge}, interrupt Bloom Thorn, weg van {SPELL:@blinding_burst}. Gyrospore: ontwijk {SPELL:@fungalstorm}, burst dizzy. Mycomight: plassen weg.",

	DELVE_CHAT_SUNKILLER_SANCTUM_OVERVIEW = "Oost Voidstorm. Core / Not Expected / Gravity. Baas Esuritus (of 3 Umbraroot, geen baas).",
	DELVE_CHAT_SUNKILLER_SANCTUM_ROUTE = "Core: stop Domanaar met orbs (snelheid + DR). Not Expected: 3 Umbraroot. Gravity: singularities voor schilden.",
	DELVE_CHAT_SUNKILLER_SANCTUM_TRASH = "Kill Voidcallers elke pack — buffen Esuritus. Orbs pakken in Core.",
	DELVE_CHAT_SUNKILLER_SANCTUM_BOSS = "Alle Voidcallers dood vóór {SPELL:@gorge}. Kick {SPELL:@calling_bolt}. Dispel {SPELL:@coalescing_malediction}. Ontwijk {SPELL:@crushing_rift}.",

	DELVE_CHAT_SHADOWGUARD_POINT_OVERVIEW = "West Voidstorm vs ethereals. Calamitous / Wildlife / Mana. Baas: Patram.",
	DELVE_CHAT_SHADOWGUARD_POINT_ROUTE = "Calamitous: overload met Arcane Charges (niet in explosie). Wildlife: voorzichtig vrijlaten. Mana: rifle op containers.",
	DELVE_CHAT_SHADOWGUARD_POINT_TRASH = "Onderbreek ethereals. Charges veilig dragen.",
	DELVE_CHAT_SHADOWGUARD_POINT_BOSS = "Kick {SPELL:@void_bolt_patram}. Kill Void Emissary vóór {SPELL:@submit_to_the_void}. Ontwijk {SPELL:@discordant_hymn}.",

	DELVE_CHAT_TORMENTS_RISE_OVERVIEW = "Nemesis-delve (Voidstorm). Tier ? / ?? regels. Baas Nullaeus — healer Valeera op ??.",
	DELVE_CHAT_TORMENTS_RISE_ROUTE = "Eigen portal (Shift-J / TomTom). Geen roterende world-delve.",
	DELVE_CHAT_TORMENTS_RISE_TRASH = "Bewaar CDs voor Nullaeus — geen Pactsworn binnen.",
	DELVE_CHAT_TORMENTS_RISE_BOSS = "Kick elke {SPELL:@devouring_essence}. {SPELL:@dread_portal}: AoE adds tot dood. {SPELL:@oblivion_shell} = DPS-check. Geen {SPELL:@umbral_rage}-stacks.",
})
