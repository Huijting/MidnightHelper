--[[
	Midnight Helper — Ritual Coach tip bodies (all 6 locales).
	Sources: Blizzard 12.0.5 news post (14 Apr 2026) + Wowhead/Method/Skycoach/
	Overgear/wow.gg ritual-sites guides. Line breaks use |n; bullets use •.

	never-lie: no Spoils % numbers in this text (sources conflict — verify at the
	obelisk tooltip). Boss names / per-scenario routes stay generic until an
	in-game run confirms them. See docs/RITUAL_COACH_PLAN.md.

	WoW proper names (challenge names, sites, NPCs, items, quest/scenario names)
	stay in English in every locale; city/zone words follow each locale file's
	existing convention (Silbermond / Lune-d'argent / Lunargenta / Luaprata).

	Locale audit: 68 RITUAL_* keys per language, ×6 languages.
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
	-- Section titles ---------------------------------------------------------
	RITUAL_COACH_SEC_OVERVIEW = "Overview",
	RITUAL_COACH_SEC_PHASES = "How a run goes",
	RITUAL_COACH_SEC_NOTES = "Site notes",
	RITUAL_COACH_SEC_MECHANIC = "What it does",
	RITUAL_COACH_SEC_UNLOCK = "How to unlock",
	RITUAL_COACH_SEC_TIERS = "Tiers & challenges",
	RITUAL_COACH_SEC_SCORING = "Spoils & deaths",
	RITUAL_COACH_SEC_WEEKLY = "Weekly & renown",
	RITUAL_COACH_SEC_ORBS = "Regeneration Orbs",

	-- Display names ----------------------------------------------------------
	RITUAL_COACH_INTRO_NAME = "How Ritual Sites work",
	RITUAL_COACH_SITE_DAGGERSPINE = "Daggerspine Point",
	RITUAL_COACH_SITE_BROKENTHRONE = "Broken Throne",
	RITUAL_CHAL_TENDRILS = "Tendrils",
	RITUAL_CHAL_MANIFESTATIONS = "Manifestations",
	RITUAL_CHAL_ALARMBELLS = "Magical Alarm Bells",
	RITUAL_CHAL_MALEVOLENTBOONS = "Malevolent Boons",
	RITUAL_CHAL_TAINTEDCORPSES = "Tainted Corpses",
	RITUAL_CHAL_REINFORCED = "Reinforced",
	RITUAL_CHAL_PATROLS = "Patrols",
	RITUAL_CHAL_EMBERS = "Embers",

	-- Coach UI labels (fase 2) -----------------------------------------------
	RITUAL_COACH_HEADER = "Ritual Coach",
	RITUAL_COACH_CHALLENGES_HEADER = "Challenges — pick at Tier 3+ (highest Spoils first)",
	RITUAL_COACH_ACTIVE_FMT = "This week's site: %s",
	RITUAL_COACH_ACTIVE_UNKNOWN = "Active site not detected yet — general tips below.",
	RITUAL_COACH_STATUS_UNLOCKED = "unlocked",
	RITUAL_COACH_STATUS_LOCKED = "locked",

	-- Share (fase 3)
	RITUAL_COACH_SHARE_BTN = "Share challenge tips to group",
	RITUAL_SHARE_CHALLENGES_HEADER = "Ritual challenges by Spoils:",
	RITUAL_SHARE_XLOC_HEADER_FMT = "%s shared Ritual challenge tips:",
	RITUAL_SHARE_CONFIRM_FMT = "Post %d lines of Ritual challenge tips to your group?",
	RITUAL_SHARE_SENT_FMT = "Shared %d line(s) to %s.",
	RITUAL_SHARE_SENT_TEST_FMT = "Shared %d line(s) (test mode).",
	RITUAL_SHARE_NO_GROUP = "Join a party or raid to share these tips (or turn on share test mode).",
	RITUAL_SHARE_COMBAT = "Can't share while in combat.",
	RITUAL_SHARE_COOLDOWN = "Sharing is on cooldown — try again shortly.",
	RITUAL_SHARE_BUSY = "A share is already in progress.",
	RITUAL_SHARE_FAILED = "Couldn't build the challenge tips.",

	-- Weekly hint (why the Ritual weekly isn't done yet)
	RITUAL_WEEKLY_HINT_LOCKED_FMT = "Locked: %s",
	RITUAL_WEEKLY_HINT_LOCKED_GENERIC = "Locked — unlock Ritual Sites via the intro questline in Silvermoon.",
	RITUAL_WEEKLY_HINT_PICKUP = "Not picked up yet — grab this week's weekly at the Bazaar hub in Silvermoon.",
	RITUAL_WEEKLY_HINT_INTRO = "This character hasn't finished the intro questline yet — start \"Ranger Captain's Summons\" at Ranger Captain Lilatha in Silvermoon (the Void Strike step happens in the active assault zone).",
	RITUAL_INTRO_STEP_FMT = "Intro questline on this character — step %d/%d: %s",
	RITUAL_INTRO_STEP_INLOG = "(already in your quest log)",
	RITUAL_INTRO_STEP_SUMMONS = "start \"Ranger Captain's Summons\" at Ranger Captain Lilatha, staging grounds above the Bazaar.",
	RITUAL_INTRO_STEP_ALLIES = "do \"Outfitting and Allies\" — meet the allies at Lilatha's staging grounds.",
	RITUAL_INTRO_STEP_VOIDSTRIKE = "\"Void Strike\" — this step takes place in the active assault zone (see Void Assaults below).",
	RITUAL_INTRO_STEP_PROBLEMS = "\"Ritual Problems\" — investigate the Ritual Site reports, then disrupt a Ritual Site.",
	RITUAL_INTRO_STEP_INTEREST = "\"Ritual Interest\" — check in with Lady Darkglen at the hub.",
	RITUAL_WEEKLY_HINT_INPROGRESS = "It's in your quest log — finish it and turn it in.",

	-- Intro / how it works ---------------------------------------------------
	RITUAL_TIP_INTRO_TIERS = "• Pick Tier 1-5 at the Curious Obelisk; clear each tier to unlock the next.|n• Tier 3 needs 1 challenge active, Tier 4 needs 2, Tier 5 needs 4.|n• Higher tiers give more Spoils and renown. Recommended item level: T1 215 · T2 231 · T3 244 · T4 257 · T5 264 (a recommendation, not a hard gate).",
	RITUAL_TIP_INTRO_SCORING = "• Spoils are your score; the Ritual Chest at the end scales with them.|n• Deaths: the first 2 are free, then every death cuts Spoils by 5%, up to a maximum of -50%.|n• Clean clears beat fast pulls — dying costs rewards directly.",
	RITUAL_TIP_INTRO_WEEKLY = "• Each week the tier needed to UNLOCK a challenge drops by one, so everyone unlocks them over time.|n• You cannot unlock all 8 challenges in a single week.|n• Counts for the World row of the Great Vault.|n• Renown boosters: Ritual Tablet (first site of the week), Ritual Tablet Fragment (second site), and Ritual Site Reports (scaled by your Spoils).",
	RITUAL_TIP_INTRO_ORBS = "• In combat, Regeneration Orbs manifest and heal 15% of your health (Renown 1).|n• Orb Potency (Renown 4) increases that healing.|n• Lean on the orbs instead of burning cooldowns on self-healing.",

	-- Daggerspine Point (Eversong Woods) -------------------------------------
	RITUAL_TIP_DAGGERSPINE_OVERVIEW = "• Eversong Woods — Daggerspine Point, on the west coast near Goldenmist Village.|n• Enemies: naga.|n• Active one week at a time; the obelisk shows a purple icon on the map.|n• Enter at the Curious Obelisk and pick your tier + challenges there.",
	RITUAL_TIP_DAGGERSPINE_PHASES = "• A short instanced scenario: clear objectives and enemy waves, then a final boss, then loot the Ritual Chest.|n• Scenario seen at the obelisk: \"A Strike From the Sea\" — the naga leader Selen'vjar (final-boss kill still to confirm).|n• A site may run more than one scenario layout — to confirm in-game.",
	RITUAL_TIP_DAGGERSPINE_NOTES = "• Tainted Bone Pile (unlocks the Tainted Corpses challenge): /way 66.09 62.58.|n• Dark Obelisks (Malevolent Boons quest — investigate any 5; 9 spawns): 66.6/38.8 · 64.7/49.8 · 63.8/70.9 · 39.2/76.2 · 35.3/63.2 · 50/42 · 42/56 · 62/62 · 44.8/47.3.|n• Small treasures and Regeneration Orbs are scattered around the site.",

	-- Broken Throne (Zul'Aman) -----------------------------------------------
	RITUAL_TIP_BROKENTHRONE_OVERVIEW = "• Zul'Aman — Broken Throne, in the south of the zone.|n• Enemies: Twilight's Blade cultists.|n• Active one week at a time; the obelisk shows a purple icon on the map.|n• Enter at the Curious Obelisk and pick your tier + challenges there.",
	RITUAL_TIP_BROKENTHRONE_PHASES = "• A short instanced scenario: clear objectives and enemy waves, then a final boss, then loot the Ritual Chest.|n• Scenario seen at the obelisk: \"A Corrupted Path\" — Faithbreaker Ger'lok corrupts everything with the Void and is the final boss.|n• DEADLY on the later bosses (e.g. the Corrupted Amani Dragonhawk): void mirrors (Dissonant Reflections) keep spawning and cast Dissonant Realities — a massive burst on everything within 100 yards. You can't outrange it: INTERRUPT the cast and the mirror vanishes instantly. Save your kick for exactly this.|n• Corrupted Amani Dragonhawk: a Binding Nebula traps you — you CANNOT leave until you KILL the nebula itself, so burst it down the moment you're caught. Trapped players die to Volatile Plumage (the feather eruption hits for hundreds of thousands); never stand in front of the Shadowflame Breath.|n• A site may run more than one scenario layout — to confirm in-game.",
	RITUAL_TIP_BROKENTHRONE_NOTES = "• Tainted Bone Pile (unlocks the Tainted Corpses challenge): /way 47.91 36.52.|n• Dark Obelisks (Malevolent Boons quest — investigate any 5; 6 spawns): 61/50 · 41/50 · 45/59 · 42/68 · 55/58 · 54/54.|n• Small treasures and Regeneration Orbs are scattered around the site.",
	-- Ritual Boss Coach (boss-venster; EditBox → {SPELL:} mag hier wél).
	RITUAL_BOSS_DRAGONHAWK_STEPS = "• {SPELL:1284125} traps a player — escape is IMPOSSIBLE while the nebula lives: everyone switch and kill the nebula immediately.|n• Trapped players die to {SPELL:1291610} (the feather eruption hits for hundreds of thousands) — another reason the nebula must die fast.|n• Dissonant Reflections keep spawning and cast {SPELL:1284085}: a massive burst on everything within 100 yd — you cannot outrange it. Save your interrupt for exactly this cast; a kick removes the mirror instantly.|n• Never stand in front of the dragonhawk (Shadowflame Breath).",
	RITUAL_BOSS_GERLOK_STEPS = "• He summons minions that make him take (almost) no damage — burn every add the moment it spawns, then back to the boss.|n• Drops burning ground (wildfire) — step out immediately (seen in our runs; exact spell name to confirm).|n• His ritual platform is cramped: you can drag him to the lower platform for room, but not too far — he resets back to his platform.",
	RAID_BOSS_ROTMIRE_STEPS = "• One boss, but watch his energy bar: when it fills he casts {SPELL:1221637} (Fungal Bloom) — the wipe. Keep it down by killing the adds and spores he feeds on.|n• Adds: burn Shroomlings and Funglings fast, and interrupt the Sporecaps ({SPELL:1221714} / {SPELL:1221717}).|n• Step out of {SPELL:1221965} (Bursting Shroom) and run out of {SPELL:1222088} → {SPELL:1222129} (Festering → Writhing Vines).|n• Mythic only: spread for {SPELL:1222684}, then handle {SPELL:1222495} (Bursting Doom Shroom). (Datamined — confirm in-game at launch.)",
	RAID_BOSS_ROTMIRE_TANK = "• {SPELL:1221781} (Putrid Fist) stacks — swap with the off-tank, and keep the boss out of the spore/vine mess.",
	RAID_BOSS_ROTMIRE_HEALER = "• Damage ramps with {SPELL:1221787} → {SPELL:1222176} (Bursting → Rotting Pustules, a soft enrage) — cool the spikes and dispel where you can.",
	RAID_BOSS_ROTMIRE_DPS = "• Prioritise the adds (especially Sporecaps) so his energy never reaches Fungal Bloom, then back on the boss.",
	RITUAL_BOSS_MINDBREAKER_STEPS = "• Stage 2 (Beast From the Deep): a Mindbreaker empowered by void magic. Its abilities aren't datamined yet — interrupt casts and step out of obvious effects; we'll fill the exact steps from your first run.",
	RITUAL_BOSS_SELENVJAR_STEPS = "• End boss of Daggerspine Point (stage 3, Summoner's Fall). Web-confirmed as the final boss; her exact mechanics still need an in-game run (death recaps) — placeholder until then. Stage 1 = Ritual Roles, stage 2 = the empowered Mindbreaker.",
	RITUAL_ALERT_BINDING_NEBULA = "Binding Nebula! -> kill the nebula",
	RITUAL_ALERT_DISSONANT = "Interrupt Dissonant Reflections!",

	-- Challenges -------------------------------------------------------------
	RITUAL_TIP_TENDRILS_MECHANIC = "• Grasping tendrils spawn with a swirling green circle — step out or you get rooted and take damage.|n• Raises Spoils while active.",
	RITUAL_TIP_TENDRILS_UNLOCK = "• Loot a Ritual Chest at the end of any site, then turn in the quest \"Ritual Site Challenge Report: Tendrils\".",
	RITUAL_TIP_MANIFESTATIONS_MECHANIC = "• Spirits manifest and cast spells — interrupt them or take withering magic.|n• Raises Spoils while active.",
	RITUAL_TIP_MANIFESTATIONS_UNLOCK = "• Clear a Tier 3 site, then speak with Ranger Captain Lilatha in Silvermoon (the required tier drops each week).",
	RITUAL_TIP_ALARMBELLS_MECHANIC = "• Killing enemies summons reinforcements; the bigger and stronger the pull you kill, the stronger the adds.|n• Raises Spoils while active.",
	RITUAL_TIP_ALARMBELLS_UNLOCK = "• Clear a Tier 4 site, then speak with Lady Darkglen in Silvermoon (the required tier drops each week).",
	RITUAL_TIP_MALEVOLENTBOONS_MECHANIC = "• Dark obelisks buff nearby enemies — destroy the obelisks to strip the buffs.|n• Raises Spoils while active.",
	RITUAL_TIP_MALEVOLENTBOONS_UNLOCK = "• Clear a Tier 2 site for a quest from Lady Darkglen, then investigate 5 Dark Obelisks inside a site (the required tier drops each week).",
	RITUAL_TIP_TAINTEDCORPSES_MECHANIC = "• Slain enemies leave a pool of deadly void magic — move out of it.|n• Raises Spoils while active.",
	RITUAL_TIP_TAINTEDCORPSES_UNLOCK = "• Loot a Tainted Bone Pile inside a Tier 2+ site (see the site notes for its location), then turn in the quest.",
	RITUAL_TIP_REINFORCED_MECHANIC = "• Extra enemies are spread throughout the site — expect denser packs.|n• Raises Spoils while active (one of the larger boosts).",
	RITUAL_TIP_REINFORCED_UNLOCK = "• Clear a Tier 2 site, then speak with Ranger Captain Lilatha in Silvermoon (the required tier drops each week).",
	RITUAL_TIP_PATROLS_MECHANIC = "• Elite enemies patrol the site — avoid their paths where you can.|n• Raises Spoils while active.",
	RITUAL_TIP_PATROLS_UNLOCK = "• \"Procure\" unique treasures from a Tier 3+ site (the required tier drops each week).",
	RITUAL_TIP_EMBERS_MECHANIC = "• Random enemies AND the final boss are empowered, marked by a floating orb above them.|n• Raises Spoils while active (one of the larger boosts).",
	RITUAL_TIP_EMBERS_UNLOCK = "• Loot an Ember of Power inside a Tier 4 site to start the quest (the required tier drops each week).",
})

merge(ns._mhLocales and ns._mhLocales.nlNL, {
	-- Sectietitels -----------------------------------------------------------
	RITUAL_COACH_SEC_OVERVIEW = "Overzicht",
	RITUAL_COACH_SEC_PHASES = "Hoe een run verloopt",
	RITUAL_COACH_SEC_NOTES = "Site-notities",
	RITUAL_COACH_SEC_MECHANIC = "Wat het doet",
	RITUAL_COACH_SEC_UNLOCK = "Hoe ontgrendel je het",
	RITUAL_COACH_SEC_TIERS = "Tiers & challenges",
	RITUAL_COACH_SEC_SCORING = "Spoils & doden",
	RITUAL_COACH_SEC_WEEKLY = "Wekelijks & renown",
	RITUAL_COACH_SEC_ORBS = "Regeneratie-orbs",

	-- Weergavenamen ----------------------------------------------------------
	RITUAL_COACH_INTRO_NAME = "Hoe Ritual Sites werken",
	RITUAL_COACH_SITE_DAGGERSPINE = "Daggerspine Point",
	RITUAL_COACH_SITE_BROKENTHRONE = "Broken Throne",
	RITUAL_CHAL_TENDRILS = "Tendrils",
	RITUAL_CHAL_MANIFESTATIONS = "Manifestations",
	RITUAL_CHAL_ALARMBELLS = "Magical Alarm Bells",
	RITUAL_CHAL_MALEVOLENTBOONS = "Malevolent Boons",
	RITUAL_CHAL_TAINTEDCORPSES = "Tainted Corpses",
	RITUAL_CHAL_REINFORCED = "Reinforced",
	RITUAL_CHAL_PATROLS = "Patrols",
	RITUAL_CHAL_EMBERS = "Embers",

	-- Coach UI-labels (fase 2) -----------------------------------------------
	RITUAL_COACH_HEADER = "Ritual Coach",
	RITUAL_COACH_CHALLENGES_HEADER = "Challenges — kies vanaf Tier 3 (hoogste Spoils eerst)",
	RITUAL_COACH_ACTIVE_FMT = "Site van deze week: %s",
	RITUAL_COACH_ACTIVE_UNKNOWN = "Actieve site nog niet gedetecteerd — algemene tips hieronder.",
	RITUAL_COACH_STATUS_UNLOCKED = "ontgrendeld",
	RITUAL_COACH_STATUS_LOCKED = "vergrendeld",

	-- Share (fase 3)
	RITUAL_COACH_SHARE_BTN = "Deel challenge-tips met groep",
	RITUAL_SHARE_CHALLENGES_HEADER = "Ritual-challenges op Spoils:",
	RITUAL_SHARE_XLOC_HEADER_FMT = "%s deelde Ritual-challenge-tips:",
	RITUAL_SHARE_CONFIRM_FMT = "%d regels Ritual-challenge-tips in je groep posten?",
	RITUAL_SHARE_SENT_FMT = "%d regel(s) gedeeld naar %s.",
	RITUAL_SHARE_SENT_TEST_FMT = "%d regel(s) gedeeld (testmodus).",
	RITUAL_SHARE_NO_GROUP = "Sluit je aan bij een party of raid om te delen (of zet share-testmodus aan).",
	RITUAL_SHARE_COMBAT = "Kan niet delen tijdens gevecht.",
	RITUAL_SHARE_COOLDOWN = "Delen heeft cooldown — probeer zo opnieuw.",
	RITUAL_SHARE_BUSY = "Er loopt al een share.",
	RITUAL_SHARE_FAILED = "Kon de challenge-tips niet opbouwen.",

	-- Weekly hint (waarom de Ritual-weekly nog niet gedaan is)
	RITUAL_WEEKLY_HINT_LOCKED_FMT = "Gegrendeld: %s",
	RITUAL_WEEKLY_HINT_LOCKED_GENERIC = "Gegrendeld — ontgrendel Ritual Sites via de intro-questlijn in Silvermoon.",
	RITUAL_WEEKLY_HINT_PICKUP = "Nog niet opgepakt — haal de weekly bij de Bazaar-hub in Silvermoon.",
	RITUAL_WEEKLY_HINT_INTRO = "Dit personage heeft de intro-questlijn nog niet af — start \"Ranger Captain's Summons\" bij Ranger Captain Lilatha in Silvermoon (de Void Strike-stap doe je in de actieve assault-zone).",
	RITUAL_INTRO_STEP_FMT = "Introlijn op dit personage — stap %d/%d: %s",
	RITUAL_INTRO_STEP_INLOG = "(staat al in je questlog)",
	RITUAL_INTRO_STEP_SUMMONS = "start \"Ranger Captain's Summons\" bij Ranger Captain Lilatha, staging grounds boven de Bazaar.",
	RITUAL_INTRO_STEP_ALLIES = "doe \"Outfitting and Allies\" — maak kennis met de bondgenoten bij Lilatha's staging grounds.",
	RITUAL_INTRO_STEP_VOIDSTRIKE = "\"Void Strike\" — deze stap speelt zich af in de actieve assault-zone (zie Void Assaults hieronder).",
	RITUAL_INTRO_STEP_PROBLEMS = "\"Ritual Problems\" — onderzoek de Ritual Site-rapporten en verstoor daarna een Ritual Site.",
	RITUAL_INTRO_STEP_INTEREST = "\"Ritual Interest\" — meld je bij Lady Darkglen bij de hub.",
	RITUAL_WEEKLY_HINT_INPROGRESS = "Staat in je questlog — afmaken en inleveren.",

	-- Intro / hoe het werkt --------------------------------------------------
	RITUAL_TIP_INTRO_TIERS = "• Kies Tier 1-5 bij de Curious Obelisk; elke tier moet gecleard zijn om de volgende te ontgrendelen.|n• Tier 3 vereist 1 actieve challenge, Tier 4 vereist er 2, Tier 5 vereist er 4.|n• Hogere tiers geven meer Spoils en renown. Aanbevolen item level: T1 215 · T2 231 · T3 244 · T4 257 · T5 264 (advies, geen harde eis).",
	RITUAL_TIP_INTRO_SCORING = "• Spoils zijn je score; de Ritual Chest aan het eind schaalt ermee.|n• Doden: de eerste 2 zijn gratis, daarna kost elke dood 5% Spoils, tot maximaal -50%.|n• Schone clears verslaan snelle pulls — doodgaan kost direct beloning.",
	RITUAL_TIP_INTRO_WEEKLY = "• Elke week zakt de tier die nodig is om een challenge te ONTGRENDELEN met één, zodat iedereen ze na verloop van tijd vrijspeelt.|n• Je kunt niet alle 8 challenges in één week ontgrendelen.|n• Telt mee voor de World-rij van de Great Vault.|n• Renown-boosters: Ritual Tablet (eerste site van de week), Ritual Tablet Fragment (tweede site), en Ritual Site Reports (schaalt met je Spoils).",
	RITUAL_TIP_INTRO_ORBS = "• In combat verschijnen Regeneration Orbs die 15% van je health healen (Renown 1).|n• Orb Potency (Renown 4) verhoogt die healing.|n• Leun op de orbs in plaats van cooldowns te verbranden aan zelf-healing.",

	-- Daggerspine Point (Eversong Woods) -------------------------------------
	RITUAL_TIP_DAGGERSPINE_OVERVIEW = "• Eversong Woods — Daggerspine Point, aan de westkust bij Goldenmist Village.|n• Vijanden: naga.|n• Eén week per keer actief; de obelisk heeft een paars icoon op de map.|n• Ga naar de Curious Obelisk en kies daar je tier + challenges.",
	RITUAL_TIP_DAGGERSPINE_PHASES = "• Een korte instanced scenario: clear objectives en vijandgolven, dan een eindboss, dan loot je de Ritual Chest.|n• Scenario gezien bij de obelisk: \"A Strike From the Sea\" — de naga-leider Selen'vjar (eindboss-kill nog te bevestigen).|n• Een site kan meer dan één scenario-layout draaien — nog in-game bevestigen.",
	RITUAL_TIP_DAGGERSPINE_NOTES = "• Tainted Bone Pile (ontgrendelt de Tainted Corpses-challenge): /way 66.09 62.58.|n• Dark Obelisks (Malevolent Boons-quest — onderzoek er 5 van de 9): 66.6/38.8 · 64.7/49.8 · 63.8/70.9 · 39.2/76.2 · 35.3/63.2 · 50/42 · 42/56 · 62/62 · 44.8/47.3.|n• Kleine treasures en Regeneration Orbs liggen verspreid door de site.",

	-- Broken Throne (Zul'Aman) -----------------------------------------------
	RITUAL_TIP_BROKENTHRONE_OVERVIEW = "• Zul'Aman — Broken Throne, in het zuiden van de zone.|n• Vijanden: Twilight's Blade-cultisten.|n• Eén week per keer actief; de obelisk heeft een paars icoon op de map.|n• Ga naar de Curious Obelisk en kies daar je tier + challenges.",
	RITUAL_TIP_BROKENTHRONE_PHASES = "• Een korte instanced scenario: clear objectives en vijandgolven, dan een eindboss, dan loot je de Ritual Chest.|n• Scenario gezien bij de obelisk: \"A Corrupted Path\" — Faithbreaker Ger'lok corrumpeert alles met de Void en is de eindboss.|n• DODELIJK bij de latere bosses (o.a. de Corrupted Amani Dragonhawk): void-spiegelbeelden (Dissonant Reflections) blijven spawnen en casten Dissonant Realities — een enorme knal op alles binnen 100 yards. Wegrennen kan niet: INTERRUPT de cast en het spiegelbeeld verdwijnt direct. Bewaar je kick precies hiervoor.|n• Corrupted Amani Dragonhawk: een Binding Nebula zet je VAST — je kunt er pas uit als je de nebula zélf kapotslaat, dus burst 'm meteen zodra je gevangen zit. Gevangen spelers sterven aan Volatile Plumage (de veren-eruptie slaat voor honderdduizenden); sta nooit voor de Shadowflame Breath.|n• Een site kan meer dan één scenario-layout draaien — nog in-game bevestigen.",
	RITUAL_TIP_BROKENTHRONE_NOTES = "• Tainted Bone Pile (ontgrendelt de Tainted Corpses-challenge): /way 47.91 36.52.|n• Dark Obelisks (Malevolent Boons-quest — onderzoek er 5 van de 6): 61/50 · 41/50 · 45/59 · 42/68 · 55/58 · 54/54.|n• Kleine treasures en Regeneration Orbs liggen verspreid door de site.",
	RITUAL_BOSS_DRAGONHAWK_STEPS = "• {SPELL:1284125} zet een speler VAST — ontsnappen kan pas als de nebula dood is: iedereen direct omschakelen en de nebula kapotslaan.|n• Gevangen spelers sterven aan {SPELL:1291610} (de veren-eruptie slaat voor honderdduizenden) — nóg een reden om de nebula snel te doden.|n• Dissonant Reflections blijven spawnen en casten {SPELL:1284085}: een enorme knal op alles binnen 100 yards — wegrennen kan niet. Bewaar je interrupt precies voor deze cast; een kick laat het spiegelbeeld direct verdwijnen.|n• Sta nooit vóór de dragonhawk (Shadowflame Breath).",
	RITUAL_BOSS_GERLOK_STEPS = "• Hij summont minions die hem (vrijwel) immuun maken — brand elke add direct weg zodra die spawnt, daarna terug naar de boss.|n• Laat brandende grond achter (wildfire) — stap er meteen uit (gezien in onze runs; exacte spellnaam nog te bevestigen).|n• Zijn ritual-platform is krap: je mag hem naar het lagere platform trekken voor ruimte, maar niet te ver — dan reset hij terug naar zijn platform.",
	RAID_BOSS_ROTMIRE_STEPS = "• Eén boss, maar let op zijn energie-balk: vult die, dan komt {SPELL:1221637} (Fungal Bloom) — de wipe. Houd 'm laag door de adds en sporen te killen waar hij op teert.|n• Adds: brand Shroomlings en Funglings snel weg en interrupt de Sporecaps ({SPELL:1221714} / {SPELL:1221717}).|n• Stap uit {SPELL:1221965} (Bursting Shroom) en ren uit {SPELL:1222088} → {SPELL:1222129} (Festering → Writhing Vines).|n• Alleen Mythic: spreid voor {SPELL:1222684} en handel {SPELL:1222495} (Bursting Doom Shroom). (Gedataminet — bij launch in-game bevestigen.)",
	RAID_BOSS_ROTMIRE_TANK = "• {SPELL:1221781} (Putrid Fist) stapelt — wissel met de off-tank en houd de boss uit de sporen/vines-rommel.",
	RAID_BOSS_ROTMIRE_HEALER = "• Schade loopt op met {SPELL:1221787} → {SPELL:1222176} (Bursting → Rotting Pustules, soft enrage) — vang de pieken op en dispel waar mogelijk.",
	RAID_BOSS_ROTMIRE_DPS = "• Prioriteer de adds (vooral Sporecaps) zodat zijn energie Fungal Bloom nooit haalt, daarna terug op de boss.",
	RITUAL_BOSS_MINDBREAKER_STEPS = "• Stage 2 (Beast From the Deep): een door void-magie versterkte Mindbreaker. Z'n abilities zijn nog niet gedataminet — interrupt casts en stap uit zichtbare effecten; de exacte stappen vullen we uit je eerste run.",
	RITUAL_BOSS_SELENVJAR_STEPS = "• Eindboss van Daggerspine Point (stage 3, Summoner's Fall). Web-bevestigd als eindbaas; haar exacte mechanics hebben nog een in-game run nodig (death recaps) — placeholder tot dan. Stage 1 = Ritual Roles, stage 2 = de empowered Mindbreaker.",
	RITUAL_ALERT_BINDING_NEBULA = "Binding Nebula! -> sla de nebula kapot",
	RITUAL_ALERT_DISSONANT = "Interrupt Dissonant Reflections!",

	-- Challenges -------------------------------------------------------------
	RITUAL_TIP_TENDRILS_MECHANIC = "• Grijpende tendrils verschijnen met een draaiende groene cirkel — eruit lopen, anders word je geroot en neem je schade.|n• Verhoogt Spoils zolang actief.",
	RITUAL_TIP_TENDRILS_UNLOCK = "• Loot een Ritual Chest aan het eind van een site en lever de quest \"Ritual Site Challenge Report: Tendrils\" in.",
	RITUAL_TIP_MANIFESTATIONS_MECHANIC = "• Geesten manifesteren en casten spells — interrupt ze of neem withering-magie.|n• Verhoogt Spoils zolang actief.",
	RITUAL_TIP_MANIFESTATIONS_UNLOCK = "• Clear een Tier 3-site en praat dan met Ranger Captain Lilatha in Silvermoon (de vereiste tier zakt elke week).",
	RITUAL_TIP_ALARMBELLS_MECHANIC = "• Kills summonen reinforcements; hoe groter en sterker de pull die je doodt, hoe sterker de adds.|n• Verhoogt Spoils zolang actief.",
	RITUAL_TIP_ALARMBELLS_UNLOCK = "• Clear een Tier 4-site en praat dan met Lady Darkglen in Silvermoon (de vereiste tier zakt elke week).",
	RITUAL_TIP_MALEVOLENTBOONS_MECHANIC = "• Dark obelisks buffen vijanden in de buurt — vernietig de obelisks om de buffs weg te halen.|n• Verhoogt Spoils zolang actief.",
	RITUAL_TIP_MALEVOLENTBOONS_UNLOCK = "• Clear een Tier 2-site voor een quest van Lady Darkglen en investigeer dan 5 Dark Obelisks in een site (de vereiste tier zakt elke week).",
	RITUAL_TIP_TAINTEDCORPSES_MECHANIC = "• Gedode vijanden laten een plas dodelijke void-magie achter — eruit bewegen.|n• Verhoogt Spoils zolang actief.",
	RITUAL_TIP_TAINTEDCORPSES_UNLOCK = "• Loot een Tainted Bone Pile in een Tier 2+-site (zie de site-notities voor de locatie) en lever de quest in.",
	RITUAL_TIP_REINFORCED_MECHANIC = "• Extra vijanden verspreid door de hele site — reken op dichtere packs.|n• Verhoogt Spoils zolang actief (een van de grotere boosts).",
	RITUAL_TIP_REINFORCED_UNLOCK = "• Clear een Tier 2-site en praat dan met Ranger Captain Lilatha in Silvermoon (de vereiste tier zakt elke week).",
	RITUAL_TIP_PATROLS_MECHANIC = "• Elite-vijanden patrouilleren door de site — vermijd hun routes waar het kan.|n• Verhoogt Spoils zolang actief.",
	RITUAL_TIP_PATROLS_UNLOCK = "• \"Procure\" unieke treasures uit een Tier 3+-site (de vereiste tier zakt elke week).",
	RITUAL_TIP_EMBERS_MECHANIC = "• Random vijanden ÉN de eindboss zijn empowered, gemarkeerd met een zwevende orb erboven.|n• Verhoogt Spoils zolang actief (een van de grotere boosts).",
	RITUAL_TIP_EMBERS_UNLOCK = "• Loot een Ember of Power in een Tier 4-site om de quest te starten (de vereiste tier zakt elke week).",
})

merge(ns._mhLocales and ns._mhLocales.deDE, {
	-- Abschnittstitel ----------------------------------------------------------
	RITUAL_COACH_SEC_OVERVIEW = "Überblick",
	RITUAL_COACH_SEC_PHASES = "So läuft ein Run ab",
	RITUAL_COACH_SEC_NOTES = "Notizen zur Stätte",
	RITUAL_COACH_SEC_MECHANIC = "Was es bewirkt",
	RITUAL_COACH_SEC_UNLOCK = "So schaltest du es frei",
	RITUAL_COACH_SEC_TIERS = "Tiers & Challenges",
	RITUAL_COACH_SEC_SCORING = "Spoils & Tode",
	RITUAL_COACH_SEC_WEEKLY = "Wöchentlich & Ansehen",
	RITUAL_COACH_SEC_ORBS = "Regeneration Orbs",

	-- Anzeigenamen (Eigennamen bleiben Englisch) -------------------------------
	RITUAL_COACH_INTRO_NAME = "So funktionieren Ritual Sites",
	RITUAL_COACH_SITE_DAGGERSPINE = "Daggerspine Point",
	RITUAL_COACH_SITE_BROKENTHRONE = "Broken Throne",
	RITUAL_CHAL_TENDRILS = "Tendrils",
	RITUAL_CHAL_MANIFESTATIONS = "Manifestations",
	RITUAL_CHAL_ALARMBELLS = "Magical Alarm Bells",
	RITUAL_CHAL_MALEVOLENTBOONS = "Malevolent Boons",
	RITUAL_CHAL_TAINTEDCORPSES = "Tainted Corpses",
	RITUAL_CHAL_REINFORCED = "Reinforced",
	RITUAL_CHAL_PATROLS = "Patrols",
	RITUAL_CHAL_EMBERS = "Embers",

	-- Coach-UI-Labels (Phase 2) ------------------------------------------------
	RITUAL_COACH_HEADER = "Ritual Coach",
	RITUAL_COACH_CHALLENGES_HEADER = "Challenges — wählbar ab Tier 3 (höchste Spoils zuerst)",
	RITUAL_COACH_ACTIVE_FMT = "Stätte dieser Woche: %s",
	RITUAL_COACH_ACTIVE_UNKNOWN = "Aktive Stätte noch nicht erkannt — allgemeine Tipps unten.",
	RITUAL_COACH_STATUS_UNLOCKED = "freigeschaltet",
	RITUAL_COACH_STATUS_LOCKED = "gesperrt",

	-- Teilen (Phase 3)
	RITUAL_COACH_SHARE_BTN = "Challenge-Tipps mit der Gruppe teilen",
	RITUAL_SHARE_CHALLENGES_HEADER = "Ritual-Challenges nach Spoils:",
	RITUAL_SHARE_XLOC_HEADER_FMT = "%s hat Ritual-Challenge-Tipps geteilt:",
	RITUAL_SHARE_CONFIRM_FMT = "%d Zeilen Ritual-Challenge-Tipps in deine Gruppe posten?",
	RITUAL_SHARE_SENT_FMT = "%d Zeile(n) an %s geteilt.",
	RITUAL_SHARE_SENT_TEST_FMT = "%d Zeile(n) geteilt (Testmodus).",
	RITUAL_SHARE_NO_GROUP = "Tritt einer Gruppe oder einem Schlachtzug bei, um die Tipps zu teilen (oder aktiviere den Share-Testmodus).",
	RITUAL_SHARE_COMBAT = "Im Kampf kann nicht geteilt werden.",
	RITUAL_SHARE_COOLDOWN = "Teilen hat Abklingzeit — versuch es gleich noch einmal.",
	RITUAL_SHARE_BUSY = "Es läuft bereits ein Share.",
	RITUAL_SHARE_FAILED = "Die Challenge-Tipps konnten nicht erstellt werden.",

	-- Weekly-Hinweis (warum die Ritual-Weekly noch offen ist)
	RITUAL_WEEKLY_HINT_LOCKED_FMT = "Gesperrt: %s",
	RITUAL_WEEKLY_HINT_LOCKED_GENERIC = "Gesperrt — schalte Ritual Sites über die Einstiegs-Questreihe in Silbermond frei.",
	RITUAL_WEEKLY_HINT_PICKUP = "Noch nicht angenommen — hol dir die Wochenquest am Basar-Hub in Silbermond.",
	RITUAL_WEEKLY_HINT_INTRO = "Dieser Charakter hat die Einstiegs-Questreihe noch nicht abgeschlossen — starte \"Ranger Captain's Summons\" bei Ranger Captain Lilatha in Silbermond (der Void-Strike-Schritt passiert in der aktiven Angriffszone).",
	RITUAL_INTRO_STEP_FMT = "Einstiegs-Questreihe auf diesem Charakter — Schritt %d/%d: %s",
	RITUAL_INTRO_STEP_INLOG = "(bereits in deinem Questlog)",
	RITUAL_INTRO_STEP_SUMMONS = "starte \"Ranger Captain's Summons\" bei Ranger Captain Lilatha, Sammelplatz über dem Basar.",
	RITUAL_INTRO_STEP_ALLIES = "erledige \"Outfitting and Allies\" — triff die Verbündeten an Lilathas Sammelplatz.",
	RITUAL_INTRO_STEP_VOIDSTRIKE = "\"Void Strike\" — dieser Schritt findet in der aktiven Angriffszone statt (siehe Void Assaults unten).",
	RITUAL_INTRO_STEP_PROBLEMS = "\"Ritual Problems\" — untersuche die Ritualstätten-Berichte und störe danach eine Ritualstätte.",
	RITUAL_INTRO_STEP_INTEREST = "\"Ritual Interest\" — melde dich bei Lady Darkglen am Stützpunkt.",
	RITUAL_WEEKLY_HINT_INPROGRESS = "Steht in deinem Questlog — abschließen und abgeben.",

	-- Intro / So funktioniert es -----------------------------------------------
	RITUAL_TIP_INTRO_TIERS = "• Wähle Tier 1-5 am Curious Obelisk; schließe jede Stufe ab, um die nächste freizuschalten.|n• Tier 3 braucht 1 aktive Challenge, Tier 4 braucht 2, Tier 5 braucht 4.|n• Höhere Stufen geben mehr Spoils und Ansehen. Empfohlene Gegenstandsstufe: T1 215 · T2 231 · T3 244 · T4 257 · T5 264 (Empfehlung, keine harte Sperre).",
	RITUAL_TIP_INTRO_SCORING = "• Spoils sind deine Punktzahl; die Ritual Chest am Ende skaliert damit.|n• Tode: die ersten 2 sind frei, danach kostet jeder Tod 5% Spoils, bis maximal -50%.|n• Saubere Clears schlagen schnelle Pulls — Sterben kostet direkt Belohnung.",
	RITUAL_TIP_INTRO_WEEKLY = "• Jede Woche sinkt die Stufe, die zum FREISCHALTEN einer Challenge nötig ist, um eins — mit der Zeit schaltet also jeder alles frei.|n• Du kannst nicht alle 8 Challenges in einer einzigen Woche freischalten.|n• Zählt für die Welt-Reihe des Great Vault.|n• Ansehen-Booster: Ritual Tablet (erste Stätte der Woche), Ritual Tablet Fragment (zweite Stätte) und Ritual Site Reports (skaliert mit deinen Spoils).",
	RITUAL_TIP_INTRO_ORBS = "• Im Kampf erscheinen Regeneration Orbs, die 15% deiner Gesundheit heilen (Ansehen 1).|n• Orb Potency (Ansehen 4) erhöht diese Heilung.|n• Nutz die Orbs, statt Cooldowns für Selbstheilung zu verbrennen.",

	-- Daggerspine Point (Eversong Woods) ---------------------------------------
	RITUAL_TIP_DAGGERSPINE_OVERVIEW = "• Eversong Woods — Daggerspine Point, an der Westküste bei Goldenmist Village.|n• Gegner: Naga.|n• Jeweils eine Woche aktiv; der Obelisk zeigt ein violettes Symbol auf der Karte.|n• Betrete die Stätte am Curious Obelisk und wähle dort Stufe + Challenges.",
	RITUAL_TIP_DAGGERSPINE_PHASES = "• Ein kurzes instanziertes Szenario: Ziele erfüllen und Gegnerwellen besiegen, dann ein Endboss, danach die Ritual Chest looten.|n• Am Obelisken gesehenes Szenario: \"A Strike From the Sea\" — die Naga-Anführerin Selen'vjar (Endboss-Kill noch zu bestätigen).|n• Eine Stätte kann mehr als ein Szenario-Layout haben — noch im Spiel zu bestätigen.",
	RITUAL_TIP_DAGGERSPINE_NOTES = "• Tainted Bone Pile (schaltet die Tainted-Corpses-Challenge frei): /way 66.09 62.58.|n• Dark Obelisks (Malevolent-Boons-Quest — untersuche 5 von 9): 66.6/38.8 · 64.7/49.8 · 63.8/70.9 · 39.2/76.2 · 35.3/63.2 · 50/42 · 42/56 · 62/62 · 44.8/47.3.|n• Kleine Schätze und Regeneration Orbs sind über die Stätte verteilt.",

	-- Broken Throne (Zul'Aman) --------------------------------------------------
	RITUAL_TIP_BROKENTHRONE_OVERVIEW = "• Zul'Aman — Broken Throne, im Süden der Zone.|n• Gegner: Kultisten der Twilight's Blade.|n• Jeweils eine Woche aktiv; der Obelisk zeigt ein violettes Symbol auf der Karte.|n• Betrete die Stätte am Curious Obelisk und wähle dort Stufe + Challenges.",
	RITUAL_TIP_BROKENTHRONE_PHASES = "• Ein kurzes instanziertes Szenario: Ziele erfüllen und Gegnerwellen besiegen, dann ein Endboss, danach die Ritual Chest looten.|n• Am Obelisken gesehenes Szenario: \"A Corrupted Path\" — Faithbreaker Ger'lok korrumpiert alles mit der Leere und ist der Endboss.|n• TÖDLICH bei den späteren Bossen (u.a. dem Corrupted Amani Dragonhawk): Leeren-Spiegelbilder (Dissonant Reflections) spawnen laufend und wirken Dissonant Realities — eine massive Explosion auf alles im Umkreis von 100 Metern. Weglaufen geht nicht: UNTERBRICH den Zauber und das Spiegelbild verschwindet sofort. Heb deinen Kick genau dafür auf.|n• Corrupted Amani Dragonhawk: eine Binding Nebula hält dich FEST — du kommst erst raus, wenn du die Nebula SELBST zerstörst, also sofort umnieten, sobald du gefangen bist. Gefangene sterben an Volatile Plumage (die Federn-Eruption schlägt für Hunderttausende); steh nie vor dem Shadowflame Breath.|n• Eine Stätte kann mehr als ein Szenario-Layout haben — noch im Spiel zu bestätigen.",
	RITUAL_TIP_BROKENTHRONE_NOTES = "• Tainted Bone Pile (schaltet die Tainted-Corpses-Challenge frei): /way 47.91 36.52.|n• Dark Obelisks (Malevolent-Boons-Quest — untersuche 5 von 6): 61/50 · 41/50 · 45/59 · 42/68 · 55/58 · 54/54.|n• Kleine Schätze und Regeneration Orbs sind über die Stätte verteilt.",
	RITUAL_BOSS_DRAGONHAWK_STEPS = "• {SPELL:1284125} fängt einen Spieler ein — Entkommen ist UNMÖGLICH, solange der Nebel lebt: alle sofort umschalten und den Nebel zerstören.|n• Gefangene Spieler sterben an {SPELL:1291610} (die Federn-Eruption trifft für Hunderttausende) — noch ein Grund, den Nebel schnell zu töten.|n• Dissonant Reflections spawnen immer weiter und wirken {SPELL:1284085}: ein gewaltiger Schlag auf alles innerhalb von 100 Metern — Weglaufen hilft nicht. Hebt euren Unterbrecher genau für diesen Zauberwirkvorgang auf; ein Kick lässt das Spiegelbild sofort verschwinden.|n• Stellt euch nie vor den Drachenfalken (Shadowflame Breath).",
	RITUAL_BOSS_GERLOK_STEPS = "• Er beschwört Diener, die ihn (fast) immun machen — brennt jedes Add sofort nieder, sobald es erscheint, dann zurück auf den Boss.|n• Hinterlässt brennenden Boden (Wildfeuer) — sofort heraustreten (in unseren Runs gesehen; genauer Zaubername noch zu bestätigen).|n• Seine Ritualplattform ist eng: ihr könnt ihn für mehr Platz auf die untere Plattform ziehen, aber nicht zu weit — sonst setzt er sich auf seine Plattform zurück.",
	RAID_BOSS_ROTMIRE_STEPS = "• Ein Boss, aber achtet auf seine Energieleiste: ist sie voll, wirkt er {SPELL:1221637} (Fungal Bloom) — der Wipe. Haltet sie niedrig, indem ihr die Adds und Sporen tötet, von denen er sich nährt.|n• Adds: brennt Shroomlings und Funglings schnell nieder und unterbrecht die Sporecaps ({SPELL:1221714} / {SPELL:1221717}).|n• Tretet aus {SPELL:1221965} (Bursting Shroom) heraus und lauft aus {SPELL:1222088} → {SPELL:1222129} (Festering → Writhing Vines).|n• Nur Mythisch: verteilt euch für {SPELL:1222684} und behandelt {SPELL:1222495} (Bursting Doom Shroom). (Datamined — bei Release im Spiel bestätigen.)",
	RAID_BOSS_ROTMIRE_TANK = "• {SPELL:1221781} (Putrid Fist) stapelt sich — wechselt mit dem Off-Tank und haltet den Boss aus dem Sporen-/Ranken-Chaos.",
	RAID_BOSS_ROTMIRE_HEALER = "• Der Schaden steigt mit {SPELL:1221787} → {SPELL:1222176} (Bursting → Rotting Pustules, ein weicher Enrage) — fangt die Spitzen ab und entfernt, wo ihr könnt.",
	RAID_BOSS_ROTMIRE_DPS = "• Priorisiert die Adds (besonders Sporecaps), damit seine Energie nie Fungal Bloom erreicht, dann zurück auf den Boss.",
	RITUAL_BOSS_MINDBREAKER_STEPS = "• Phase 2 (Beast From the Deep): ein durch Void-Magie verstärkter Mindbreaker. Seine Fähigkeiten sind noch nicht datamined — unterbrecht Zauber und tretet aus offensichtlichen Effekten; die genauen Schritte füllen wir nach deinem ersten Run.",
	RITUAL_BOSS_SELENVJAR_STEPS = "• Endboss von Daggerspine Point (Phase 3, Summoner's Fall). Web-bestätigt als Endboss; ihre genauen Mechaniken brauchen noch einen Run im Spiel (Death Recaps) — bis dahin Platzhalter. Phase 1 = Ritual Roles, Phase 2 = der verstärkte Mindbreaker.",
	RITUAL_ALERT_BINDING_NEBULA = "Binding Nebula! -> Nebula zerstören",
	RITUAL_ALERT_DISSONANT = "Dissonant Reflections unterbrechen!",

	-- Challenges -----------------------------------------------------------------
	RITUAL_TIP_TENDRILS_MECHANIC = "• Greifende Tendrils erscheinen mit einem wirbelnden grünen Kreis — geh raus, sonst wirst du festgewurzelt und nimmst Schaden.|n• Erhöht die Spoils, solange aktiv.",
	RITUAL_TIP_TENDRILS_UNLOCK = "• Loote am Ende einer Stätte eine Ritual Chest und gib dann die Quest \"Ritual Site Challenge Report: Tendrils\" ab.",
	RITUAL_TIP_MANIFESTATIONS_MECHANIC = "• Geister manifestieren sich und wirken Zauber — unterbrich sie, sonst trifft dich zehrende Magie.|n• Erhöht die Spoils, solange aktiv.",
	RITUAL_TIP_MANIFESTATIONS_UNLOCK = "• Schließe eine Tier-3-Stätte ab und sprich dann mit Ranger Captain Lilatha in Silbermond (die nötige Stufe sinkt jede Woche).",
	RITUAL_TIP_ALARMBELLS_MECHANIC = "• Kills rufen Verstärkung herbei; je größer und stärker der getötete Pull, desto stärker die Adds.|n• Erhöht die Spoils, solange aktiv.",
	RITUAL_TIP_ALARMBELLS_UNLOCK = "• Schließe eine Tier-4-Stätte ab und sprich dann mit Lady Darkglen in Silbermond (die nötige Stufe sinkt jede Woche).",
	RITUAL_TIP_MALEVOLENTBOONS_MECHANIC = "• Dark Obelisks stärken Gegner in der Nähe — zerstöre die Obelisken, um die Buffs zu entfernen.|n• Erhöht die Spoils, solange aktiv.",
	RITUAL_TIP_MALEVOLENTBOONS_UNLOCK = "• Schließe eine Tier-2-Stätte ab für eine Quest von Lady Darkglen und untersuche dann 5 Dark Obelisks in einer Stätte (die nötige Stufe sinkt jede Woche).",
	RITUAL_TIP_TAINTEDCORPSES_MECHANIC = "• Getötete Gegner hinterlassen eine Lache tödlicher Leerenmagie — raus aus der Fläche.|n• Erhöht die Spoils, solange aktiv.",
	RITUAL_TIP_TAINTEDCORPSES_UNLOCK = "• Loote einen Tainted Bone Pile in einer Stätte ab Tier 2 (Standort: siehe Notizen zur Stätte) und gib die Quest ab.",
	RITUAL_TIP_REINFORCED_MECHANIC = "• Zusätzliche Gegner in der ganzen Stätte — rechne mit dichteren Packs.|n• Erhöht die Spoils, solange aktiv (einer der größeren Boni).",
	RITUAL_TIP_REINFORCED_UNLOCK = "• Schließe eine Tier-2-Stätte ab und sprich dann mit Ranger Captain Lilatha in Silbermond (die nötige Stufe sinkt jede Woche).",
	RITUAL_TIP_PATROLS_MECHANIC = "• Elitegegner patrouillieren durch die Stätte — weich ihren Routen aus, wo es geht.|n• Erhöht die Spoils, solange aktiv.",
	RITUAL_TIP_PATROLS_UNLOCK = "• \"Procure\" einzigartige Schätze aus einer Stätte ab Tier 3 (die nötige Stufe sinkt jede Woche).",
	RITUAL_TIP_EMBERS_MECHANIC = "• Zufällige Gegner UND der Endboss sind verstärkt, markiert durch eine schwebende Kugel über ihnen.|n• Erhöht die Spoils, solange aktiv (einer der größeren Boni).",
	RITUAL_TIP_EMBERS_UNLOCK = "• Loote ein Ember of Power in einer Tier-4-Stätte, um die Quest zu starten (die nötige Stufe sinkt jede Woche).",
})

merge(ns._mhLocales and ns._mhLocales.frFR, {
	-- Titres de section ----------------------------------------------------------
	RITUAL_COACH_SEC_OVERVIEW = "Aperçu",
	RITUAL_COACH_SEC_PHASES = "Déroulement d'une run",
	RITUAL_COACH_SEC_NOTES = "Notes du site",
	RITUAL_COACH_SEC_MECHANIC = "Ce que ça fait",
	RITUAL_COACH_SEC_UNLOCK = "Comment le débloquer",
	RITUAL_COACH_SEC_TIERS = "Tiers & challenges",
	RITUAL_COACH_SEC_SCORING = "Spoils & morts",
	RITUAL_COACH_SEC_WEEKLY = "Hebdo & renommée",
	RITUAL_COACH_SEC_ORBS = "Regeneration Orbs",

	-- Noms affichés (noms propres en anglais) -------------------------------------
	RITUAL_COACH_INTRO_NAME = "Comment fonctionnent les Ritual Sites",
	RITUAL_COACH_SITE_DAGGERSPINE = "Daggerspine Point",
	RITUAL_COACH_SITE_BROKENTHRONE = "Broken Throne",
	RITUAL_CHAL_TENDRILS = "Tendrils",
	RITUAL_CHAL_MANIFESTATIONS = "Manifestations",
	RITUAL_CHAL_ALARMBELLS = "Magical Alarm Bells",
	RITUAL_CHAL_MALEVOLENTBOONS = "Malevolent Boons",
	RITUAL_CHAL_TAINTEDCORPSES = "Tainted Corpses",
	RITUAL_CHAL_REINFORCED = "Reinforced",
	RITUAL_CHAL_PATROLS = "Patrols",
	RITUAL_CHAL_EMBERS = "Embers",

	-- Labels UI du Coach (phase 2) ------------------------------------------------
	RITUAL_COACH_HEADER = "Ritual Coach",
	RITUAL_COACH_CHALLENGES_HEADER = "Challenges — à choisir à partir du Tier 3 (plus hauts Spoils d'abord)",
	RITUAL_COACH_ACTIVE_FMT = "Site de la semaine : %s",
	RITUAL_COACH_ACTIVE_UNKNOWN = "Site actif pas encore détecté — conseils généraux ci-dessous.",
	RITUAL_COACH_STATUS_UNLOCKED = "débloqué",
	RITUAL_COACH_STATUS_LOCKED = "verrouillé",

	-- Partage (phase 3)
	RITUAL_COACH_SHARE_BTN = "Partager les astuces de challenge au groupe",
	RITUAL_SHARE_CHALLENGES_HEADER = "Challenges rituels triés par Spoils :",
	RITUAL_SHARE_XLOC_HEADER_FMT = "%s a partagé des astuces de challenges rituels :",
	RITUAL_SHARE_CONFIRM_FMT = "Poster %d lignes d'astuces de challenges rituels dans ton groupe ?",
	RITUAL_SHARE_SENT_FMT = "%d ligne(s) partagée(s) sur %s.",
	RITUAL_SHARE_SENT_TEST_FMT = "%d ligne(s) partagée(s) (mode test).",
	RITUAL_SHARE_NO_GROUP = "Rejoins un groupe ou un raid pour partager ces astuces (ou active le mode test de partage).",
	RITUAL_SHARE_COMBAT = "Impossible de partager en combat.",
	RITUAL_SHARE_COOLDOWN = "Le partage est en recharge — réessaie dans un instant.",
	RITUAL_SHARE_BUSY = "Un partage est déjà en cours.",
	RITUAL_SHARE_FAILED = "Impossible de construire les astuces de challenge.",

	-- Indice hebdo (pourquoi l'hebdo rituelle n'est pas faite)
	RITUAL_WEEKLY_HINT_LOCKED_FMT = "Verrouillé : %s",
	RITUAL_WEEKLY_HINT_LOCKED_GENERIC = "Verrouillé — débloque les Ritual Sites via la chaîne de quêtes d'introduction à Lune-d'argent.",
	RITUAL_WEEKLY_HINT_PICKUP = "Pas encore prise — récupère l'hebdo de la semaine au hub du Bazar à Lune-d'argent.",
	RITUAL_WEEKLY_HINT_INTRO = "Ce personnage n'a pas encore terminé la chaîne de quêtes d'introduction — commence \"Ranger Captain's Summons\" auprès de Ranger Captain Lilatha à Lune-d'argent (l'étape Void Strike se fait dans la zone d'assaut active).",
	RITUAL_INTRO_STEP_FMT = "Chaîne d'introduction sur ce personnage — étape %d/%d : %s",
	RITUAL_INTRO_STEP_INLOG = "(déjà dans votre journal de quêtes)",
	RITUAL_INTRO_STEP_SUMMONS = "commencez \"Ranger Captain's Summons\" auprès de Ranger Captain Lilatha, au camp au-dessus du Bazar.",
	RITUAL_INTRO_STEP_ALLIES = "faites \"Outfitting and Allies\" — rencontrez les alliés au camp de Lilatha.",
	RITUAL_INTRO_STEP_VOIDSTRIKE = "\"Void Strike\" — cette étape se déroule dans la zone d'assaut active (voir Void Assaults ci-dessous).",
	RITUAL_INTRO_STEP_PROBLEMS = "\"Ritual Problems\" — examinez les rapports des sites rituels puis perturbez un site rituel.",
	RITUAL_INTRO_STEP_INTEREST = "\"Ritual Interest\" — faites votre rapport à Lady Darkglen au camp.",
	RITUAL_WEEKLY_HINT_INPROGRESS = "Elle est dans ton journal de quêtes — termine-la et rends-la.",

	-- Intro / comment ça marche -----------------------------------------------------
	RITUAL_TIP_INTRO_TIERS = "• Choisis le Tier 1-5 au Curious Obelisk ; chaque palier doit être terminé pour débloquer le suivant.|n• Le Tier 3 demande 1 challenge actif, le Tier 4 en demande 2, le Tier 5 en demande 4.|n• Les paliers plus élevés donnent plus de Spoils et de renommée. Niveau d'objet recommandé : T1 215 · T2 231 · T3 244 · T4 257 · T5 264 (recommandation, pas un verrou).",
	RITUAL_TIP_INTRO_SCORING = "• Les Spoils sont ton score ; la Ritual Chest à la fin s'ajuste dessus.|n• Morts : les 2 premières sont gratuites, ensuite chaque mort retire 5% de Spoils, jusqu'à -50% maximum.|n• Des clears propres valent mieux que des pulls rapides — mourir coûte directement des récompenses.",
	RITUAL_TIP_INTRO_WEEKLY = "• Chaque semaine, le palier requis pour DÉBLOQUER un challenge baisse d'un cran — tout le monde finit donc par tout débloquer.|n• Impossible de débloquer les 8 challenges en une seule semaine.|n• Compte pour la ligne Monde du Great Vault.|n• Boosters de renommée : Ritual Tablet (premier site de la semaine), Ritual Tablet Fragment (deuxième site) et Ritual Site Reports (selon tes Spoils).",
	RITUAL_TIP_INTRO_ORBS = "• En combat, des Regeneration Orbs apparaissent et soignent 15% de ta vie (renommée 1).|n• Orb Potency (renommée 4) augmente ce soin.|n• Appuie-toi sur les orbes plutôt que de brûler tes cooldowns en soins personnels.",

	-- Daggerspine Point (Eversong Woods) ----------------------------------------------
	RITUAL_TIP_DAGGERSPINE_OVERVIEW = "• Eversong Woods — Daggerspine Point, sur la côte ouest près de Goldenmist Village.|n• Ennemis : nagas.|n• Actif une semaine à la fois ; l'obélisque affiche une icône violette sur la carte.|n• Entre au Curious Obelisk et choisis-y ton palier + tes challenges.",
	RITUAL_TIP_DAGGERSPINE_PHASES = "• Un court scénario instancié : remplis les objectifs et nettoie les vagues d'ennemis, puis un boss final, puis loote la Ritual Chest.|n• Scénario vu à l'obélisque : \"A Strike From the Sea\" — la meneuse naga Selen'vjar (kill du boss final encore à confirmer).|n• Un site peut avoir plusieurs layouts de scénario — à confirmer en jeu.",
	RITUAL_TIP_DAGGERSPINE_NOTES = "• Tainted Bone Pile (débloque le challenge Tainted Corpses) : /way 66.09 62.58.|n• Dark Obelisks (quête Malevolent Boons — examines-en 5 sur 9) : 66.6/38.8 · 64.7/49.8 · 63.8/70.9 · 39.2/76.2 · 35.3/63.2 · 50/42 · 42/56 · 62/62 · 44.8/47.3.|n• De petits trésors et des Regeneration Orbs sont dispersés sur le site.",

	-- Broken Throne (Zul'Aman) -----------------------------------------------------
	RITUAL_TIP_BROKENTHRONE_OVERVIEW = "• Zul'Aman — Broken Throne, au sud de la zone.|n• Ennemis : cultistes de la Twilight's Blade.|n• Actif une semaine à la fois ; l'obélisque affiche une icône violette sur la carte.|n• Entre au Curious Obelisk et choisis-y ton palier + tes challenges.",
	RITUAL_TIP_BROKENTHRONE_PHASES = "• Un court scénario instancié : remplis les objectifs et nettoie les vagues d'ennemis, puis un boss final, puis loote la Ritual Chest.|n• Scénario vu à l'obélisque : \"A Corrupted Path\" — Faithbreaker Ger'lok corrompt tout avec le Vide et c'est le boss final.|n• MORTEL sur les derniers boss (dont le Corrupted Amani Dragonhawk) : des reflets du Vide (Dissonant Reflections) apparaissent sans cesse et incantent Dissonant Realities — une énorme explosion sur tout dans un rayon de 100 mètres. Impossible de fuir : INTERROMPS l'incantation et le reflet disparaît aussitôt. Garde ton kick exactement pour ça.|n• Corrupted Amani Dragonhawk : une Binding Nebula te PIÈGE — tu ne peux en sortir qu'en DÉTRUISANT la nébuleuse elle-même, alors burst-la dès que tu es pris. Les joueurs piégés meurent au Volatile Plumage (l'éruption de plumes frappe pour des centaines de milliers) ; ne reste jamais face au Shadowflame Breath.|n• Un site peut avoir plusieurs layouts de scénario — à confirmer en jeu.",
	RITUAL_TIP_BROKENTHRONE_NOTES = "• Tainted Bone Pile (débloque le challenge Tainted Corpses) : /way 47.91 36.52.|n• Dark Obelisks (quête Malevolent Boons — examines-en 5 sur 6) : 61/50 · 41/50 · 45/59 · 42/68 · 55/58 · 54/54.|n• De petits trésors et des Regeneration Orbs sont dispersés sur le site.",
	RITUAL_BOSS_DRAGONHAWK_STEPS = "• {SPELL:1284125} piège un joueur — IMPOSSIBLE de s'échapper tant que la nébuleuse vit : tout le monde bascule dessus et la détruit immédiatement.|n• Les joueurs piégés meurent sous {SPELL:1291610} (l'éruption de plumes frappe pour des centaines de milliers) — raison de plus de tuer la nébuleuse vite.|n• Les Dissonant Reflections réapparaissent sans cesse et incantent {SPELL:1284085} : une énorme explosion sur tout ce qui se trouve à moins de 100 m — fuir ne sert à rien. Gardez votre interruption exactement pour cette incantation ; un kick fait disparaître le reflet instantanément.|n• Ne restez jamais devant le faucon-dragon (Shadowflame Breath).",
	RITUAL_BOSS_GERLOK_STEPS = "• Il invoque des serviteurs qui le rendent (presque) insensible aux dégâts — brûlez chaque add dès son apparition, puis revenez sur le boss.|n• Laisse du sol enflammé (feu sauvage) — sortez-en immédiatement (vu dans nos runs ; nom exact du sort à confirmer).|n• Sa plateforme rituelle est exiguë : vous pouvez le tirer vers la plateforme inférieure pour avoir de la place, mais pas trop loin — il se réinitialise sur sa plateforme.",
	RAID_BOSS_ROTMIRE_STEPS = "• Un seul boss, mais surveillez sa barre d'énergie : pleine, il lance {SPELL:1221637} (Fungal Bloom) — le wipe. Gardez-la basse en tuant les adds et les spores dont il se nourrit.|n• Adds : brûlez vite les Shroomlings et Funglings, et interrompez les Sporecaps ({SPELL:1221714} / {SPELL:1221717}).|n• Sortez de {SPELL:1221965} (Bursting Shroom) et fuyez {SPELL:1222088} → {SPELL:1222129} (Festering → Writhing Vines).|n• Mythique seulement : dispersez-vous pour {SPELL:1222684} puis gérez {SPELL:1222495} (Bursting Doom Shroom). (Datamined — à confirmer en jeu à la sortie.)",
	RAID_BOSS_ROTMIRE_TANK = "• {SPELL:1221781} (Putrid Fist) s'accumule — alternez avec l'autre tank et gardez le boss hors du chaos de spores/lianes.",
	RAID_BOSS_ROTMIRE_HEALER = "• Les dégâts montent avec {SPELL:1221787} → {SPELL:1222176} (Bursting → Rotting Pustules, un enrage doux) — atténuez les pics et dissipez quand vous pouvez.",
	RAID_BOSS_ROTMIRE_DPS = "• Priorisez les adds (surtout les Sporecaps) pour que son énergie n'atteigne jamais Fungal Bloom, puis revenez sur le boss.",
	RITUAL_BOSS_MINDBREAKER_STEPS = "• Phase 2 (Beast From the Deep) : un Mindbreaker renforcé par la magie du Vide. Ses capacités ne sont pas encore datamined — interrompez les incantations et sortez des effets évidents ; on remplira les étapes exactes après votre premier run.",
	RITUAL_BOSS_SELENVJAR_STEPS = "• Boss final de Daggerspine Point (phase 3, Summoner's Fall). Confirmée comme boss final ; ses mécaniques exactes nécessitent encore un run en jeu (death recaps) — provisoire jusque-là. Phase 1 = Ritual Roles, phase 2 = le Mindbreaker renforcé.",
	RITUAL_ALERT_BINDING_NEBULA = "Binding Nebula ! -> détruisez la nébuleuse",
	RITUAL_ALERT_DISSONANT = "Interrompez Dissonant Reflections !",

	-- Challenges ---------------------------------------------------------------------
	RITUAL_TIP_TENDRILS_MECHANIC = "• Des tendrils apparaissent avec un cercle vert tourbillonnant — sors-en, sinon tu es immobilisé et tu prends des dégâts.|n• Augmente les Spoils tant qu'actif.",
	RITUAL_TIP_TENDRILS_UNLOCK = "• Loote une Ritual Chest à la fin d'un site, puis rends la quête \"Ritual Site Challenge Report: Tendrils\".",
	RITUAL_TIP_MANIFESTATIONS_MECHANIC = "• Des esprits se manifestent et lancent des sorts — interromps-les ou subis leur magie flétrissante.|n• Augmente les Spoils tant qu'actif.",
	RITUAL_TIP_MANIFESTATIONS_UNLOCK = "• Termine un site Tier 3, puis parle à Ranger Captain Lilatha à Lune-d'argent (le palier requis baisse chaque semaine).",
	RITUAL_TIP_ALARMBELLS_MECHANIC = "• Les kills invoquent des renforts ; plus le pull tué est gros et fort, plus les adds sont puissants.|n• Augmente les Spoils tant qu'actif.",
	RITUAL_TIP_ALARMBELLS_UNLOCK = "• Termine un site Tier 4, puis parle à Lady Darkglen à Lune-d'argent (le palier requis baisse chaque semaine).",
	RITUAL_TIP_MALEVOLENTBOONS_MECHANIC = "• Des Dark Obelisks renforcent les ennemis proches — détruis les obélisques pour retirer les buffs.|n• Augmente les Spoils tant qu'actif.",
	RITUAL_TIP_MALEVOLENTBOONS_UNLOCK = "• Termine un site Tier 2 pour une quête de Lady Darkglen, puis examine 5 Dark Obelisks dans un site (le palier requis baisse chaque semaine).",
	RITUAL_TIP_TAINTEDCORPSES_MECHANIC = "• Les ennemis tués laissent une flaque de magie du Vide mortelle — sors-en.|n• Augmente les Spoils tant qu'actif.",
	RITUAL_TIP_TAINTEDCORPSES_UNLOCK = "• Loote un Tainted Bone Pile dans un site Tier 2+ (voir les notes du site pour l'emplacement), puis rends la quête.",
	RITUAL_TIP_REINFORCED_MECHANIC = "• Des ennemis supplémentaires sont répartis sur tout le site — attends-toi à des packs plus denses.|n• Augmente les Spoils tant qu'actif (un des plus gros bonus).",
	RITUAL_TIP_REINFORCED_UNLOCK = "• Termine un site Tier 2, puis parle à Ranger Captain Lilatha à Lune-d'argent (le palier requis baisse chaque semaine).",
	RITUAL_TIP_PATROLS_MECHANIC = "• Des ennemis d'élite patrouillent sur le site — évite leurs trajets quand c'est possible.|n• Augmente les Spoils tant qu'actif.",
	RITUAL_TIP_PATROLS_UNLOCK = "• \"Procure\" des trésors uniques dans un site Tier 3+ (le palier requis baisse chaque semaine).",
	RITUAL_TIP_EMBERS_MECHANIC = "• Des ennemis aléatoires ET le boss final sont renforcés, marqués d'un orbe flottant au-dessus d'eux.|n• Augmente les Spoils tant qu'actif (un des plus gros bonus).",
	RITUAL_TIP_EMBERS_UNLOCK = "• Loote un Ember of Power dans un site Tier 4 pour lancer la quête (le palier requis baisse chaque semaine).",
})

merge(ns._mhLocales and ns._mhLocales.esES, {
	-- Títulos de sección ---------------------------------------------------------
	RITUAL_COACH_SEC_OVERVIEW = "Resumen",
	RITUAL_COACH_SEC_PHASES = "Cómo va una run",
	RITUAL_COACH_SEC_NOTES = "Notas del sitio",
	RITUAL_COACH_SEC_MECHANIC = "Qué hace",
	RITUAL_COACH_SEC_UNLOCK = "Cómo desbloquearlo",
	RITUAL_COACH_SEC_TIERS = "Tiers y challenges",
	RITUAL_COACH_SEC_SCORING = "Spoils y muertes",
	RITUAL_COACH_SEC_WEEKLY = "Semanal y renombre",
	RITUAL_COACH_SEC_ORBS = "Regeneration Orbs",

	-- Nombres mostrados (nombres propios en inglés) --------------------------------
	RITUAL_COACH_INTRO_NAME = "Cómo funcionan los Ritual Sites",
	RITUAL_COACH_SITE_DAGGERSPINE = "Daggerspine Point",
	RITUAL_COACH_SITE_BROKENTHRONE = "Broken Throne",
	RITUAL_CHAL_TENDRILS = "Tendrils",
	RITUAL_CHAL_MANIFESTATIONS = "Manifestations",
	RITUAL_CHAL_ALARMBELLS = "Magical Alarm Bells",
	RITUAL_CHAL_MALEVOLENTBOONS = "Malevolent Boons",
	RITUAL_CHAL_TAINTEDCORPSES = "Tainted Corpses",
	RITUAL_CHAL_REINFORCED = "Reinforced",
	RITUAL_CHAL_PATROLS = "Patrols",
	RITUAL_CHAL_EMBERS = "Embers",

	-- Etiquetas de UI del Coach (fase 2) -------------------------------------------
	RITUAL_COACH_HEADER = "Ritual Coach",
	RITUAL_COACH_CHALLENGES_HEADER = "Challenges — elige a partir de Tier 3 (mayor Spoils primero)",
	RITUAL_COACH_ACTIVE_FMT = "Sitio de esta semana: %s",
	RITUAL_COACH_ACTIVE_UNKNOWN = "Sitio activo aún no detectado — consejos generales abajo.",
	RITUAL_COACH_STATUS_UNLOCKED = "desbloqueado",
	RITUAL_COACH_STATUS_LOCKED = "bloqueado",

	-- Compartir (fase 3)
	RITUAL_COACH_SHARE_BTN = "Compartir consejos de challenges con el grupo",
	RITUAL_SHARE_CHALLENGES_HEADER = "Challenges de ritual por Spoils:",
	RITUAL_SHARE_XLOC_HEADER_FMT = "%s compartió consejos de challenges de ritual:",
	RITUAL_SHARE_CONFIRM_FMT = "¿Publicar %d líneas de consejos de challenges en tu grupo?",
	RITUAL_SHARE_SENT_FMT = "%d línea(s) compartida(s) en %s.",
	RITUAL_SHARE_SENT_TEST_FMT = "%d línea(s) compartida(s) (modo de prueba).",
	RITUAL_SHARE_NO_GROUP = "Únete a un grupo o banda para compartir estos consejos (o activa el modo de prueba de compartir).",
	RITUAL_SHARE_COMBAT = "No se puede compartir en combate.",
	RITUAL_SHARE_COOLDOWN = "Compartir está en enfriamiento — inténtalo de nuevo en un momento.",
	RITUAL_SHARE_BUSY = "Ya hay un envío en curso.",
	RITUAL_SHARE_FAILED = "No se pudieron generar los consejos de challenges.",

	-- Pista semanal (por qué la semanal de Ritual sigue pendiente)
	RITUAL_WEEKLY_HINT_LOCKED_FMT = "Bloqueado: %s",
	RITUAL_WEEKLY_HINT_LOCKED_GENERIC = "Bloqueado — desbloquea los Ritual Sites con la cadena de misiones de introducción en Lunargenta.",
	RITUAL_WEEKLY_HINT_PICKUP = "Aún sin recoger — coge la semanal de esta semana en el centro del Bazar en Lunargenta.",
	RITUAL_WEEKLY_HINT_INTRO = "Este personaje aún no ha terminado la cadena de misiones de introducción — empieza \"Ranger Captain's Summons\" con Ranger Captain Lilatha en Lunargenta (el paso Void Strike se hace en la zona de asalto activa).",
	RITUAL_INTRO_STEP_FMT = "Cadena de introducción en este personaje — paso %d/%d: %s",
	RITUAL_INTRO_STEP_INLOG = "(ya está en tu registro de misiones)",
	RITUAL_INTRO_STEP_SUMMONS = "empieza \"Ranger Captain's Summons\" con Ranger Captain Lilatha, en el campamento sobre el Bazar.",
	RITUAL_INTRO_STEP_ALLIES = "haz \"Outfitting and Allies\" — conoce a los aliados en el campamento de Lilatha.",
	RITUAL_INTRO_STEP_VOIDSTRIKE = "\"Void Strike\" — este paso ocurre en la zona de asalto activa (ver Void Assaults abajo).",
	RITUAL_INTRO_STEP_PROBLEMS = "\"Ritual Problems\" — investiga los informes de los sitios rituales y luego interrumpe un sitio ritual.",
	RITUAL_INTRO_STEP_INTEREST = "\"Ritual Interest\" — preséntate ante Lady Darkglen en el campamento.",
	RITUAL_WEEKLY_HINT_INPROGRESS = "Está en tu registro de misiones — termínala y entrégala.",

	-- Intro / cómo funciona ----------------------------------------------------------
	RITUAL_TIP_INTRO_TIERS = "• Elige Tier 1-5 en el Curious Obelisk; cada tier debe completarse para desbloquear el siguiente.|n• Tier 3 requiere 1 challenge activo, Tier 4 requiere 2, Tier 5 requiere 4.|n• Los tiers más altos dan más Spoils y renombre. Nivel de objeto recomendado: T1 215 · T2 231 · T3 244 · T4 257 · T5 264 (recomendación, no un requisito).",
	RITUAL_TIP_INTRO_SCORING = "• Los Spoils son tu puntuación; el Ritual Chest del final escala con ellos.|n• Muertes: las 2 primeras son gratis, después cada muerte resta un 5% de Spoils, hasta un máximo de -50%.|n• Limpiar con cuidado gana a los pulls rápidos — morir cuesta recompensas directamente.",
	RITUAL_TIP_INTRO_WEEKLY = "• Cada semana, el tier necesario para DESBLOQUEAR un challenge baja en uno, así que con el tiempo todos lo desbloquean todo.|n• No puedes desbloquear los 8 challenges en una sola semana.|n• Cuenta para la fila de Mundo del Great Vault.|n• Potenciadores de renombre: Ritual Tablet (primer sitio de la semana), Ritual Tablet Fragment (segundo sitio) y Ritual Site Reports (según tus Spoils).",
	RITUAL_TIP_INTRO_ORBS = "• En combate aparecen Regeneration Orbs que curan el 15% de tu vida (renombre 1).|n• Orb Potency (renombre 4) aumenta esa curación.|n• Apóyate en los orbes en lugar de quemar cooldowns en curarte.",

	-- Daggerspine Point (Eversong Woods) ----------------------------------------------
	RITUAL_TIP_DAGGERSPINE_OVERVIEW = "• Eversong Woods — Daggerspine Point, en la costa oeste cerca de Goldenmist Village.|n• Enemigos: nagas.|n• Activo una semana cada vez; el obelisco muestra un icono morado en el mapa.|n• Entra por el Curious Obelisk y elige allí tu tier + challenges.",
	RITUAL_TIP_DAGGERSPINE_PHASES = "• Un escenario corto instanciado: completa objetivos y oleadas de enemigos, luego un jefe final, y al final saquea el Ritual Chest.|n• Escenario visto en el obelisco: \"A Strike From the Sea\" — la líder naga Selen'vjar (muerte del jefe final por confirmar).|n• Un sitio puede tener más de un diseño de escenario — por confirmar en el juego.",
	RITUAL_TIP_DAGGERSPINE_NOTES = "• Tainted Bone Pile (desbloquea el challenge Tainted Corpses): /way 66.09 62.58.|n• Dark Obelisks (misión Malevolent Boons — investiga 5 de 9): 66.6/38.8 · 64.7/49.8 · 63.8/70.9 · 39.2/76.2 · 35.3/63.2 · 50/42 · 42/56 · 62/62 · 44.8/47.3.|n• Hay pequeños tesoros y Regeneration Orbs repartidos por el sitio.",

	-- Broken Throne (Zul'Aman) ------------------------------------------------------
	RITUAL_TIP_BROKENTHRONE_OVERVIEW = "• Zul'Aman — Broken Throne, en el sur de la zona.|n• Enemigos: cultistas de Twilight's Blade.|n• Activo una semana cada vez; el obelisco muestra un icono morado en el mapa.|n• Entra por el Curious Obelisk y elige allí tu tier + challenges.",
	RITUAL_TIP_BROKENTHRONE_PHASES = "• Un escenario corto instanciado: completa objetivos y oleadas de enemigos, luego un jefe final, y al final saquea el Ritual Chest.|n• Escenario visto en el obelisco: \"A Corrupted Path\" — Faithbreaker Ger'lok lo corrompe todo con el Vacío y es el jefe final.|n• LETAL en los jefes finales (incluido el Corrupted Amani Dragonhawk): reflejos del Vacío (Dissonant Reflections) aparecen sin parar y lanzan Dissonant Realities — una explosión enorme sobre todo en 100 metros. No puedes alejarte: INTERRUMPE el lanzamiento y el reflejo desaparece al instante. Guarda tu interrupción justo para esto.|n• Corrupted Amani Dragonhawk: una Binding Nebula te ATRAPA — no puedes salir hasta que MATAS la propia nebulosa, así que revientala en cuanto te atrape. Los jugadores atrapados mueren por Volatile Plumage (la erupción de plumas golpea por cientos de miles); nunca te pongas frente al Shadowflame Breath.|n• Un sitio puede tener más de un diseño de escenario — por confirmar en el juego.",
	RITUAL_TIP_BROKENTHRONE_NOTES = "• Tainted Bone Pile (desbloquea el challenge Tainted Corpses): /way 47.91 36.52.|n• Dark Obelisks (misión Malevolent Boons — investiga 5 de 6): 61/50 · 41/50 · 45/59 · 42/68 · 55/58 · 54/54.|n• Hay pequeños tesoros y Regeneration Orbs repartidos por el sitio.",
	RITUAL_BOSS_DRAGONHAWK_STEPS = "• {SPELL:1284125} atrapa a un jugador — escapar es IMPOSIBLE mientras la nebulosa viva: que todos cambien de objetivo y la maten de inmediato.|n• Los jugadores atrapados mueren por {SPELL:1291610} (la erupción de plumas golpea por cientos de miles) — otra razón para matar la nebulosa rápido.|n• Las Dissonant Reflections no dejan de aparecer y lanzan {SPELL:1284085}: un estallido enorme contra todo en un radio de 100 metros — no puedes alejarte. Guarda tu interrupción justo para este lanzamiento; una patada hace desaparecer el reflejo al instante.|n• Nunca te pongas delante del dracohalcón (Shadowflame Breath).",
	RITUAL_BOSS_GERLOK_STEPS = "• Invoca esbirros que lo vuelven (casi) inmune al daño — quema cada add en cuanto aparezca y luego vuelve al jefe.|n• Deja suelo en llamas (fuego salvaje) — sal de inmediato (visto en nuestras runs; nombre exacto del hechizo por confirmar).|n• Su plataforma ritual es estrecha: puedes arrastrarlo a la plataforma inferior para tener espacio, pero no demasiado lejos — se reinicia de vuelta a su plataforma.",
	RAID_BOSS_ROTMIRE_STEPS = "• Un solo jefe, pero vigila su barra de energía: al llenarse lanza {SPELL:1221637} (Fungal Bloom) — el wipe. Mantenla baja matando los adds y esporas de los que se nutre.|n• Adds: quema rápido a los Shroomlings y Funglings, e interrumpe a los Sporecaps ({SPELL:1221714} / {SPELL:1221717}).|n• Sal de {SPELL:1221965} (Bursting Shroom) y corre fuera de {SPELL:1222088} → {SPELL:1222129} (Festering → Writhing Vines).|n• Solo Mítico: dispérsate para {SPELL:1222684} y gestiona {SPELL:1222495} (Bursting Doom Shroom). (Datamined — confirmar en el juego al lanzamiento.)",
	RAID_BOSS_ROTMIRE_TANK = "• {SPELL:1221781} (Putrid Fist) acumula — alterna con el otro tanque y mantén al jefe fuera del lío de esporas/enredaderas.",
	RAID_BOSS_ROTMIRE_HEALER = "• El daño sube con {SPELL:1221787} → {SPELL:1222176} (Bursting → Rotting Pustules, un enrage suave) — amortigua los picos y disipa cuando puedas.",
	RAID_BOSS_ROTMIRE_DPS = "• Prioriza los adds (sobre todo los Sporecaps) para que su energía nunca llegue a Fungal Bloom, luego vuelve al jefe.",
	RITUAL_BOSS_MINDBREAKER_STEPS = "• Fase 2 (Beast From the Deep): un Mindbreaker reforzado por la magia del Vacío. Sus habilidades aún no están datamined — interrumpe los lanzamientos y sal de los efectos evidentes; rellenaremos los pasos exactos tras tu primera run.",
	RITUAL_BOSS_SELENVJAR_STEPS = "• Jefe final de Daggerspine Point (fase 3, Summoner's Fall). Confirmada como jefe final; sus mecánicas exactas aún necesitan una run en el juego (death recaps) — provisional hasta entonces. Fase 1 = Ritual Roles, fase 2 = el Mindbreaker reforzado.",
	RITUAL_ALERT_BINDING_NEBULA = "¡Binding Nebula! -> destruye la nebulosa",
	RITUAL_ALERT_DISSONANT = "¡Interrumpe Dissonant Reflections!",

	-- Challenges ----------------------------------------------------------------------
	RITUAL_TIP_TENDRILS_MECHANIC = "• Aparecen tendrils que agarran, con un círculo verde giratorio — sal de él o quedarás inmovilizado y recibirás daño.|n• Aumenta los Spoils mientras está activo.",
	RITUAL_TIP_TENDRILS_UNLOCK = "• Saquea un Ritual Chest al final de cualquier sitio y entrega la misión \"Ritual Site Challenge Report: Tendrils\".",
	RITUAL_TIP_MANIFESTATIONS_MECHANIC = "• Espíritus se manifiestan y lanzan hechizos — interrúmpelos o sufre su magia marchitadora.|n• Aumenta los Spoils mientras está activo.",
	RITUAL_TIP_MANIFESTATIONS_UNLOCK = "• Completa un sitio de Tier 3 y habla con Ranger Captain Lilatha en Lunargenta (el tier requerido baja cada semana).",
	RITUAL_TIP_ALARMBELLS_MECHANIC = "• Matar enemigos invoca refuerzos; cuanto más grande y fuerte sea el pull que matas, más fuertes los adds.|n• Aumenta los Spoils mientras está activo.",
	RITUAL_TIP_ALARMBELLS_UNLOCK = "• Completa un sitio de Tier 4 y habla con Lady Darkglen en Lunargenta (el tier requerido baja cada semana).",
	RITUAL_TIP_MALEVOLENTBOONS_MECHANIC = "• Los Dark Obelisks potencian a los enemigos cercanos — destruye los obeliscos para quitarles los buffs.|n• Aumenta los Spoils mientras está activo.",
	RITUAL_TIP_MALEVOLENTBOONS_UNLOCK = "• Completa un sitio de Tier 2 para una misión de Lady Darkglen y luego investiga 5 Dark Obelisks dentro de un sitio (el tier requerido baja cada semana).",
	RITUAL_TIP_TAINTEDCORPSES_MECHANIC = "• Los enemigos muertos dejan un charco de magia del Vacío letal — sal de él.|n• Aumenta los Spoils mientras está activo.",
	RITUAL_TIP_TAINTEDCORPSES_UNLOCK = "• Saquea un Tainted Bone Pile dentro de un sitio de Tier 2+ (mira las notas del sitio para la ubicación) y entrega la misión.",
	RITUAL_TIP_REINFORCED_MECHANIC = "• Hay enemigos extra repartidos por todo el sitio — espera grupos más densos.|n• Aumenta los Spoils mientras está activo (uno de los bonus más grandes).",
	RITUAL_TIP_REINFORCED_UNLOCK = "• Completa un sitio de Tier 2 y habla con Ranger Captain Lilatha en Lunargenta (el tier requerido baja cada semana).",
	RITUAL_TIP_PATROLS_MECHANIC = "• Enemigos de élite patrullan el sitio — evita sus rutas cuando puedas.|n• Aumenta los Spoils mientras está activo.",
	RITUAL_TIP_PATROLS_UNLOCK = "• \"Procure\" tesoros únicos de un sitio de Tier 3+ (el tier requerido baja cada semana).",
	RITUAL_TIP_EMBERS_MECHANIC = "• Enemigos aleatorios Y el jefe final están potenciados, marcados con un orbe flotante encima.|n• Aumenta los Spoils mientras está activo (uno de los bonus más grandes).",
	RITUAL_TIP_EMBERS_UNLOCK = "• Saquea un Ember of Power dentro de un sitio de Tier 4 para iniciar la misión (el tier requerido baja cada semana).",
})

merge(ns._mhLocales and ns._mhLocales.ptBR, {
	-- Títulos de seção -------------------------------------------------------------
	RITUAL_COACH_SEC_OVERVIEW = "Visão geral",
	RITUAL_COACH_SEC_PHASES = "Como é uma run",
	RITUAL_COACH_SEC_NOTES = "Notas do local",
	RITUAL_COACH_SEC_MECHANIC = "O que faz",
	RITUAL_COACH_SEC_UNLOCK = "Como desbloquear",
	RITUAL_COACH_SEC_TIERS = "Tiers e challenges",
	RITUAL_COACH_SEC_SCORING = "Spoils e mortes",
	RITUAL_COACH_SEC_WEEKLY = "Semanal e renome",
	RITUAL_COACH_SEC_ORBS = "Regeneration Orbs",

	-- Nomes exibidos (nomes próprios em inglês) --------------------------------------
	RITUAL_COACH_INTRO_NAME = "Como funcionam os Ritual Sites",
	RITUAL_COACH_SITE_DAGGERSPINE = "Daggerspine Point",
	RITUAL_COACH_SITE_BROKENTHRONE = "Broken Throne",
	RITUAL_CHAL_TENDRILS = "Tendrils",
	RITUAL_CHAL_MANIFESTATIONS = "Manifestations",
	RITUAL_CHAL_ALARMBELLS = "Magical Alarm Bells",
	RITUAL_CHAL_MALEVOLENTBOONS = "Malevolent Boons",
	RITUAL_CHAL_TAINTEDCORPSES = "Tainted Corpses",
	RITUAL_CHAL_REINFORCED = "Reinforced",
	RITUAL_CHAL_PATROLS = "Patrols",
	RITUAL_CHAL_EMBERS = "Embers",

	-- Rótulos de UI do Coach (fase 2) -------------------------------------------------
	RITUAL_COACH_HEADER = "Ritual Coach",
	RITUAL_COACH_CHALLENGES_HEADER = "Challenges — escolha a partir do Tier 3 (maior Spoils primeiro)",
	RITUAL_COACH_ACTIVE_FMT = "Local desta semana: %s",
	RITUAL_COACH_ACTIVE_UNKNOWN = "Local ativo ainda não detectado — dicas gerais abaixo.",
	RITUAL_COACH_STATUS_UNLOCKED = "desbloqueado",
	RITUAL_COACH_STATUS_LOCKED = "bloqueado",

	-- Compartilhar (fase 3)
	RITUAL_COACH_SHARE_BTN = "Compartilhar dicas de challenges com o grupo",
	RITUAL_SHARE_CHALLENGES_HEADER = "Challenges de ritual por Spoils:",
	RITUAL_SHARE_XLOC_HEADER_FMT = "%s compartilhou dicas de challenges de ritual:",
	RITUAL_SHARE_CONFIRM_FMT = "Postar %d linhas de dicas de challenges no seu grupo?",
	RITUAL_SHARE_SENT_FMT = "%d linha(s) compartilhada(s) em %s.",
	RITUAL_SHARE_SENT_TEST_FMT = "%d linha(s) compartilhada(s) (modo de teste).",
	RITUAL_SHARE_NO_GROUP = "Entre em um grupo ou raide para compartilhar estas dicas (ou ative o modo de teste de compartilhamento).",
	RITUAL_SHARE_COMBAT = "Não é possível compartilhar em combate.",
	RITUAL_SHARE_COOLDOWN = "O compartilhamento está em recarga — tente de novo em instantes.",
	RITUAL_SHARE_BUSY = "Já há um compartilhamento em andamento.",
	RITUAL_SHARE_FAILED = "Não foi possível montar as dicas de challenges.",

	-- Dica semanal (por que a semanal de Ritual ainda está pendente)
	RITUAL_WEEKLY_HINT_LOCKED_FMT = "Bloqueado: %s",
	RITUAL_WEEKLY_HINT_LOCKED_GENERIC = "Bloqueado — desbloqueie os Ritual Sites pela linha de missões de introdução em Luaprata.",
	RITUAL_WEEKLY_HINT_PICKUP = "Ainda não pega — pegue a semanal desta semana no hub do Bazar em Luaprata.",
	RITUAL_WEEKLY_HINT_INTRO = "Este personagem ainda não terminou a linha de missões de introdução — comece \"Ranger Captain's Summons\" com Ranger Captain Lilatha em Luaprata (a etapa Void Strike acontece na zona de assalto ativa).",
	RITUAL_INTRO_STEP_FMT = "Linha de introdução neste personagem — etapa %d/%d: %s",
	RITUAL_INTRO_STEP_INLOG = "(já está no seu registro de missões)",
	RITUAL_INTRO_STEP_SUMMONS = "comece \"Ranger Captain's Summons\" com Ranger Captain Lilatha, no acampamento acima do Bazar.",
	RITUAL_INTRO_STEP_ALLIES = "faça \"Outfitting and Allies\" — conheça os aliados no acampamento de Lilatha.",
	RITUAL_INTRO_STEP_VOIDSTRIKE = "\"Void Strike\" — esta etapa acontece na zona de assalto ativa (veja Void Assaults abaixo).",
	RITUAL_INTRO_STEP_PROBLEMS = "\"Ritual Problems\" — investigue os relatórios dos Sítios Rituais e depois interrompa um Sítio Ritual.",
	RITUAL_INTRO_STEP_INTEREST = "\"Ritual Interest\" — apresente-se a Lady Darkglen no acampamento.",
	RITUAL_WEEKLY_HINT_INPROGRESS = "Está no seu registro de missões — termine e entregue.",

	-- Intro / como funciona --------------------------------------------------------------
	RITUAL_TIP_INTRO_TIERS = "• Escolha o Tier 1-5 no Curious Obelisk; cada tier precisa ser limpo para desbloquear o próximo.|n• O Tier 3 exige 1 challenge ativo, o Tier 4 exige 2, o Tier 5 exige 4.|n• Tiers mais altos dão mais Spoils e renome. Item level recomendado: T1 215 · T2 231 · T3 244 · T4 257 · T5 264 (recomendação, não uma exigência).",
	RITUAL_TIP_INTRO_SCORING = "• Spoils são sua pontuação; o Ritual Chest no final escala com eles.|n• Mortes: as 2 primeiras são de graça, depois cada morte corta 5% dos Spoils, até no máximo -50%.|n• Limpar com calma vale mais que pulls rápidos — morrer custa recompensa na hora.",
	RITUAL_TIP_INTRO_WEEKLY = "• A cada semana, o tier necessário para DESBLOQUEAR um challenge cai em um — com o tempo todo mundo desbloqueia tudo.|n• Não dá para desbloquear os 8 challenges em uma única semana.|n• Conta para a fileira de Mundo do Great Vault.|n• Reforços de renome: Ritual Tablet (primeiro local da semana), Ritual Tablet Fragment (segundo local) e Ritual Site Reports (escala com seus Spoils).",
	RITUAL_TIP_INTRO_ORBS = "• Em combate, Regeneration Orbs aparecem e curam 15% da sua vida (renome 1).|n• Orb Potency (renome 4) aumenta essa cura.|n• Conte com os orbes em vez de gastar cooldowns com cura própria.",

	-- Daggerspine Point (Eversong Woods) ---------------------------------------------------
	RITUAL_TIP_DAGGERSPINE_OVERVIEW = "• Eversong Woods — Daggerspine Point, na costa oeste perto de Goldenmist Village.|n• Inimigos: nagas.|n• Ativo uma semana por vez; o obelisco mostra um ícone roxo no mapa.|n• Entre pelo Curious Obelisk e escolha lá seu tier + challenges.",
	RITUAL_TIP_DAGGERSPINE_PHASES = "• Um cenário curto instanciado: cumpra objetivos e ondas de inimigos, depois um chefe final, e então saqueie o Ritual Chest.|n• Cenário visto no obelisco: \"A Strike From the Sea\" — a líder naga Selen'vjar (morte do chefe final ainda a confirmar).|n• Um local pode ter mais de um layout de cenário — a confirmar no jogo.",
	RITUAL_TIP_DAGGERSPINE_NOTES = "• Tainted Bone Pile (desbloqueia o challenge Tainted Corpses): /way 66.09 62.58.|n• Dark Obelisks (missão Malevolent Boons — investigue 5 de 9): 66.6/38.8 · 64.7/49.8 · 63.8/70.9 · 39.2/76.2 · 35.3/63.2 · 50/42 · 42/56 · 62/62 · 44.8/47.3.|n• Pequenos tesouros e Regeneration Orbs estão espalhados pelo local.",

	-- Broken Throne (Zul'Aman) ----------------------------------------------------------
	RITUAL_TIP_BROKENTHRONE_OVERVIEW = "• Zul'Aman — Broken Throne, no sul da zona.|n• Inimigos: cultistas da Twilight's Blade.|n• Ativo uma semana por vez; o obelisco mostra um ícone roxo no mapa.|n• Entre pelo Curious Obelisk e escolha lá seu tier + challenges.",
	RITUAL_TIP_BROKENTHRONE_PHASES = "• Um cenário curto instanciado: cumpra objetivos e ondas de inimigos, depois um chefe final, e então saqueie o Ritual Chest.|n• Cenário visto no obelisco: \"A Corrupted Path\" — Faithbreaker Ger'lok corrompe tudo com o Vazio e é o chefe final.|n• MORTAL nos chefes finais (incluindo o Corrupted Amani Dragonhawk): reflexos do Vazio (Dissonant Reflections) surgem sem parar e conjuram Dissonant Realities — uma explosão enorme em tudo num raio de 100 metros. Não dá para fugir: INTERROMPA a conjuração e o reflexo some na hora. Guarde seu kick exatamente para isso.|n• Corrupted Amani Dragonhawk: uma Binding Nebula te PRENDE — você só sai quando MATA a própria nébula, então estoure-a assim que for capturado. Jogadores presos morrem para Volatile Plumage (a erupção de penas bate em centenas de milhares); nunca fique na frente do Shadowflame Breath.|n• Um local pode ter mais de um layout de cenário — a confirmar no jogo.",
	RITUAL_TIP_BROKENTHRONE_NOTES = "• Tainted Bone Pile (desbloqueia o challenge Tainted Corpses): /way 47.91 36.52.|n• Dark Obelisks (missão Malevolent Boons — investigue 5 de 6): 61/50 · 41/50 · 45/59 · 42/68 · 55/58 · 54/54.|n• Pequenos tesouros e Regeneration Orbs estão espalhados pelo local.",
	RITUAL_BOSS_DRAGONHAWK_STEPS = "• {SPELL:1284125} prende um jogador — escapar é IMPOSSÍVEL enquanto a nébula viver: todos trocam de alvo e matam a nébula imediatamente.|n• Jogadores presos morrem para {SPELL:1291610} (a erupção de penas acerta por centenas de milhares) — mais um motivo para matar a nébula rápido.|n• As Dissonant Reflections continuam surgindo e conjuram {SPELL:1284085}: uma explosão enorme em tudo num raio de 100 metros — não dá para fugir. Guarde sua interrupção exatamente para essa conjuração; um chute faz o reflexo sumir na hora.|n• Nunca fique na frente do falcão-dragão (Shadowflame Breath).",
	RAID_BOSS_ROTMIRE_STEPS = "• Um só boss, mas fique de olho na barra de energia: cheia, ele lança {SPELL:1221637} (Fungal Bloom) — o wipe. Mantenha-a baixa matando os adds e esporos dos quais ele se alimenta.|n• Adds: queime rápido os Shroomlings e Funglings, e interrompa os Sporecaps ({SPELL:1221714} / {SPELL:1221717}).|n• Saia de {SPELL:1221965} (Bursting Shroom) e corra para fora de {SPELL:1222088} → {SPELL:1222129} (Festering → Writhing Vines).|n• Só no Mítico: espalhe-se para {SPELL:1222684} e lide com {SPELL:1222495} (Bursting Doom Shroom). (Datamined — confirmar no jogo no lançamento.)",
	RAID_BOSS_ROTMIRE_TANK = "• {SPELL:1221781} (Putrid Fist) acumula — alterne com o off-tank e mantenha o boss fora da bagunça de esporos/vinhas.",
	RAID_BOSS_ROTMIRE_HEALER = "• O dano sobe com {SPELL:1221787} → {SPELL:1222176} (Bursting → Rotting Pustules, um enrage leve) — segure os picos e dissipe quando puder.",
	RAID_BOSS_ROTMIRE_DPS = "• Priorize os adds (principalmente os Sporecaps) para que a energia nunca chegue ao Fungal Bloom, depois volte ao boss.",
	RITUAL_BOSS_MINDBREAKER_STEPS = "• Fase 2 (Beast From the Deep): um Mindbreaker fortalecido pela magia do Vazio. As habilidades dele ainda não foram datamined — interrompa as conjurações e saia de efeitos óbvios; preenchemos os passos exatos após sua primeira run.",
	RITUAL_BOSS_SELENVJAR_STEPS = "• Boss final de Daggerspine Point (fase 3, Summoner's Fall). Confirmada como boss final; as mecânicas exatas ainda precisam de uma run no jogo (death recaps) — provisório até lá. Fase 1 = Ritual Roles, fase 2 = o Mindbreaker fortalecido.",
	RITUAL_ALERT_BINDING_NEBULA = "Binding Nebula! -> destrua a nébula",
	RITUAL_ALERT_DISSONANT = "Interrompa Dissonant Reflections!",
	RITUAL_BOSS_GERLOK_STEPS = "• Ele invoca lacaios que o deixam (quase) imune a dano — queime cada add assim que surgir e depois volte ao chefe.|n• Deixa chão em chamas (fogo selvagem) — saia imediatamente (visto nas nossas runs; nome exato do feitiço a confirmar).|n• A plataforma ritual dele é apertada: dá para puxá-lo à plataforma inferior por espaço, mas não longe demais — ele reseta de volta à plataforma.",

	-- Challenges ------------------------------------------------------------------------
	RITUAL_TIP_TENDRILS_MECHANIC = "• Tendrils que agarram surgem com um círculo verde girando — saia dele ou você fica enraizado e toma dano.|n• Aumenta os Spoils enquanto ativo.",
	RITUAL_TIP_TENDRILS_UNLOCK = "• Saqueie um Ritual Chest no final de qualquer local e entregue a missão \"Ritual Site Challenge Report: Tendrils\".",
	RITUAL_TIP_MANIFESTATIONS_MECHANIC = "• Espíritos se manifestam e conjuram feitiços — interrompa-os ou sofra magia debilitante.|n• Aumenta os Spoils enquanto ativo.",
	RITUAL_TIP_MANIFESTATIONS_UNLOCK = "• Limpe um local de Tier 3 e fale com Ranger Captain Lilatha em Luaprata (o tier exigido cai a cada semana).",
	RITUAL_TIP_ALARMBELLS_MECHANIC = "• Abates invocam reforços; quanto maior e mais forte o pull que você mata, mais fortes os adds.|n• Aumenta os Spoils enquanto ativo.",
	RITUAL_TIP_ALARMBELLS_UNLOCK = "• Limpe um local de Tier 4 e fale com Lady Darkglen em Luaprata (o tier exigido cai a cada semana).",
	RITUAL_TIP_MALEVOLENTBOONS_MECHANIC = "• Dark Obelisks fortalecem inimigos próximos — destrua os obeliscos para remover os buffs.|n• Aumenta os Spoils enquanto ativo.",
	RITUAL_TIP_MALEVOLENTBOONS_UNLOCK = "• Limpe um local de Tier 2 para uma missão de Lady Darkglen e depois investigue 5 Dark Obelisks dentro de um local (o tier exigido cai a cada semana).",
	RITUAL_TIP_TAINTEDCORPSES_MECHANIC = "• Inimigos mortos deixam uma poça de magia do Vazio letal — saia dela.|n• Aumenta os Spoils enquanto ativo.",
	RITUAL_TIP_TAINTEDCORPSES_UNLOCK = "• Saqueie um Tainted Bone Pile dentro de um local de Tier 2+ (veja as notas do local para a localização) e entregue a missão.",
	RITUAL_TIP_REINFORCED_MECHANIC = "• Inimigos extras espalhados por todo o local — espere packs mais densos.|n• Aumenta os Spoils enquanto ativo (um dos bônus maiores).",
	RITUAL_TIP_REINFORCED_UNLOCK = "• Limpe um local de Tier 2 e fale com Ranger Captain Lilatha em Luaprata (o tier exigido cai a cada semana).",
	RITUAL_TIP_PATROLS_MECHANIC = "• Inimigos de elite patrulham o local — evite as rotas deles quando puder.|n• Aumenta os Spoils enquanto ativo.",
	RITUAL_TIP_PATROLS_UNLOCK = "• \"Procure\" tesouros únicos de um local de Tier 3+ (o tier exigido cai a cada semana).",
	RITUAL_TIP_EMBERS_MECHANIC = "• Inimigos aleatórios E o chefe final ficam fortalecidos, marcados por um orbe flutuante acima deles.|n• Aumenta os Spoils enquanto ativo (um dos bônus maiores).",
	RITUAL_TIP_EMBERS_UNLOCK = "• Saqueie um Ember of Power dentro de um local de Tier 4 para iniciar a missão (o tier exigido cai a cada semana).",
})
