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
	RITUAL_COACH_COPY_BTN = "Copy as text",
	RITUAL_SHARE_COPY_TITLE = "Copy ritual tips",
	RITUAL_SHARE_COPY_HINT = "Ctrl+C, then paste in party chat or Discord.",
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
	RITUAL_TIP_INTRO_TIERS = "• Pick your tier at the Curious Obelisk; clear each tier to unlock the next.|n• Tier 3 needs 1 challenge active, Tier 4 needs 2, Tier 5 needs 4.|n• Higher tiers give more Spoils and renown. |cffffffffThe obelisk itself shows the recommended item level for each tier|r — read it there. Season 2 moved those numbers, and any list printed here is wrong again next patch.",
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
	RITUAL_TIP_BROKENTHRONE_NOTES = "• Tainted Bone Pile (unlocks the Tainted Corpses challenge): /way 47.91 36.52.|n• Dark Obelisks (Malevolent Boons quest — investigate any 5; 6 spawns): 61/50 · 41/50 · 45/59 · 42/68 · 55/58 · 54/54.|n• Destroying the Dark Obelisks strips the buffs that empower the site's enemies — clearing them makes the bosses noticeably easier (only leave them up if you're going for the no-obelisk achievement).|n• Small treasures and Regeneration Orbs are scattered around the site.",
	-- Ritual Boss Coach (boss-venster; EditBox → {SPELL:} mag hier wél).
	RITUAL_BOSS_DRAGONHAWK_STEPS = "• {SPELL:1291610} drops little RED POOLS — SOAK them: stand in a pool to take only a small hit. A pool left empty erupts for huge Shadowflame damage — THAT is the wipe (it killed all three of you). One player per pool is enough.|n• {SPELL:1284125} is a gravity pull; the red pools spawn inside it, so soak them there.|n• Interrupt {SPELL:1284085} from the add that spawns in the middle — a kick removes it instantly.|n• Kill the Unbound Caller adds (their Enervating Volley hits hard) and dodge Radiation Wave.|n• Stand BEHIND the dragonhawk — its frontal Shadowflame Breath is deadly. (Verified in-game + Wowhead.)",
	RITUAL_BOSS_GERLOK_STEPS = "• He summons minions that make him take (almost) no damage — burn every add the instant it spawns; the adds charge with a fire channel that nearly one-shots, so step out of it.|n• {SPELL:1273031} is THE cast to interrupt — a big AoE nuke; not every cast is kickable, so save your interrupt for it.|n• {SPELL:1279186} is spammed — break line of sight behind the pillars.|n• Keep him ON his platform — pulling him down/off it resets the fight (Rob, live). The space is cramped, but don't chase room below.",
	RAID_BOSS_ROTMIRE_STEPS = "• One boss, but watch his energy bar: when it fills he casts {SPELL:1221637} — the wipe. Keep it down by killing the adds and spores he feeds on.|n• Adds: burn Shroomlings and Funglings fast, and interrupt the Sporecaps ({SPELL:1221714} / {SPELL:1221717}).|n• Step out of {SPELL:1221965} and run out of {SPELL:1222088} → {SPELL:1222129}.|n• Mythic only: spread for {SPELL:1222684}, then handle {SPELL:1222495}. (Datamined — confirm in-game at launch.)",
	RAID_BOSS_ROTMIRE_TANK = "• {SPELL:1221781} stacks — swap with the off-tank, and keep the boss out of the spore/vine mess.",
	RAID_BOSS_ROTMIRE_HEALER = "• Damage ramps with {SPELL:1221787} → {SPELL:1222176} (Bursting → Rotting Pustules, a soft enrage) — cool the spikes and dispel where you can.",
	RAID_BOSS_ROTMIRE_DPS = "• Prioritise the adds (especially Sporecaps) so his energy never reaches Fungal Bloom, then back on the boss.",
	RAID_BOSS_NYMRISSA_STEPS = "• |cffffd100The way in is UNDERWATER|r — a submerged cave, so your breath bar starts running before the fight does. There are air bubbles around the entrance to top it up.|n• The first Lair: one boss in an underwater grotto, instanced, and it feeds the Raid row of your Great Vault.|n• Six abilities are known by name from the 12.1 PTR, but not what each one does — read this as a heads-up list, not a strategy.|n• Adds — {SPELL:1257717} brings murlocs; killing them is the call.|n• An orb to get away from — {SPELL:1313393}.|n• Mind where you stand — {SPELL:1258668}.|n• Damage on the whole group — {SPELL:1260837}.|n• Aimed at the tank as a line — {SPELL:1282937}, or {SPELL:1268562} on Mythic.|n• Soft enrage at 10 minutes.|n• The lair opens with Season 2, in the week of 18 August — Tuesday in the Americas, Wednesday in Europe. Its quest marker shows up on your map before that — the entrance is findable, but every difficulty refuses you with a requirements message until it unlocks.|n• The real steps land after the first live run.",
	RAID_BOSS_NYMRISSA_TANK = "• The line comes at you: {SPELL:1282937}, and {SPELL:1268562} on Mythic. Whether it has to be pointed away from the group is still to confirm.",
	RAID_BOSS_NYMRISSA_HEALER = "• {SPELL:1260837} is the hit on the whole group — save your cooldowns for it.",
	RAID_BOSS_NYMRISSA_DPS = "• {SPELL:1257717} summons murlocs — swap to them, then back on the boss. The rest is footwork.",
	RITUAL_BOSS_MINDBREAKER_STEPS = "• Empowered Mindbreaker — Daggerspine Point stage 2 'Beast From the Deep': a deep creature Lady Selen'vjar supercharges with stolen void magic.|n• For now: interrupt its casts and step out of obvious ground effects.|n• Detailed steps arrive in the next Midnight Helper update (its exact abilities aren't datamined yet — filled from the first live run).",
	RITUAL_BOSS_SELENVJAR_STEPS = "• Lady Selen'vjar — naga sorceress, end boss of Daggerspine Point (Eversong Woods, /way 34.9 65.4). Stages: 1) Ritual Roles (her captains guard the ritual, draining void essence); 2) Beast From the Deep (she empowers a Mindbreaker); 3) Summoner's Fall (she takes you on herself).|n• Detailed interrupt/dodge steps arrive in the next Midnight Helper update (her abilities aren't datamined yet — filled from the first live run).",
	RITUAL_ALERT_BINDING_NEBULA = "Binding Nebula! -> kill the nebula",
	RITUAL_ALERT_SHADOWBOLT = "Interrupt Shadowbolt Volley!",
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

merge(ns._mhLocales and ns._mhLocales.itIT, {
	-- Titoli delle sezioni ---------------------------------------------------
	RITUAL_COACH_SEC_OVERVIEW = "Panoramica",
	RITUAL_COACH_SEC_PHASES = "Come si svolge una run",
	RITUAL_COACH_SEC_NOTES = "Note sul sito",
	RITUAL_COACH_SEC_MECHANIC = "Cosa fa",
	RITUAL_COACH_SEC_UNLOCK = "Come sbloccarla",
	RITUAL_COACH_SEC_TIERS = "Tier e challenge",
	RITUAL_COACH_SEC_SCORING = "Spoils e morti",
	RITUAL_COACH_SEC_WEEKLY = "Settimanale e renown",
	RITUAL_COACH_SEC_ORBS = "Regeneration Orb",

	-- Nomi visualizzati ------------------------------------------------------
	RITUAL_COACH_INTRO_NAME = "Come funzionano i Ritual Site",
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

	-- Etichette UI del Coach (fase 2) ----------------------------------------
	RITUAL_COACH_HEADER = "Ritual Coach",
	RITUAL_COACH_CHALLENGES_HEADER = "Challenge — scegli dal Tier 3+ (prima quelle con più Spoils)",
	RITUAL_COACH_ACTIVE_FMT = "Sito di questa settimana: %s",
	RITUAL_COACH_ACTIVE_UNKNOWN = "Sito attivo non ancora rilevato — suggerimenti generali qui sotto.",
	RITUAL_COACH_STATUS_UNLOCKED = "sbloccata",
	RITUAL_COACH_STATUS_LOCKED = "bloccata",

	-- Share (fase 3)
	RITUAL_COACH_SHARE_BTN = "Condividi i tip delle challenge col gruppo",
	RITUAL_SHARE_CHALLENGES_HEADER = "Challenge Ritual per Spoils:",
	RITUAL_SHARE_XLOC_HEADER_FMT = "%s ha condiviso i tip delle challenge Ritual:",
	RITUAL_SHARE_CONFIRM_FMT = "Pubblicare %d righe di tip delle challenge Ritual nel gruppo?",
	RITUAL_SHARE_SENT_FMT = "Condivise %d riga/righe in %s.",
	RITUAL_SHARE_SENT_TEST_FMT = "Condivise %d riga/righe (modalità test).",
	RITUAL_SHARE_NO_GROUP = "Unisciti a un party o a un raid per condividere questi tip (oppure attiva la modalità test della condivisione).",
	RITUAL_SHARE_COMBAT = "Impossibile condividere durante il combat.",
	RITUAL_SHARE_COOLDOWN = "La condivisione è in cooldown — riprova tra poco.",
	RITUAL_SHARE_BUSY = "Una condivisione è già in corso.",
	RITUAL_SHARE_FAILED = "Impossibile creare i tip delle challenge.",

	-- Weekly hint (perché la weekly Ritual non è ancora fatta)
	RITUAL_WEEKLY_HINT_LOCKED_FMT = "Bloccata: %s",
	RITUAL_WEEKLY_HINT_LOCKED_GENERIC = "Bloccata — sblocca i Ritual Site tramite la questline introduttiva a Silvermoon.",
	RITUAL_WEEKLY_HINT_PICKUP = "Non ancora presa — prendi la weekly di questa settimana all'hub del Bazaar a Silvermoon.",
	RITUAL_WEEKLY_HINT_INTRO = "Questo personaggio non ha ancora finito la questline introduttiva — inizia \"Ranger Captain's Summons\" da Ranger Captain Lilatha a Silvermoon (lo step Void Strike avviene nella zona di assalto attiva).",
	RITUAL_INTRO_STEP_FMT = "Questline introduttiva su questo personaggio — step %d/%d: %s",
	RITUAL_INTRO_STEP_INLOG = "(già nel tuo registro delle quest)",
	RITUAL_INTRO_STEP_SUMMONS = "inizia \"Ranger Captain's Summons\" da Ranger Captain Lilatha, allo staging ground sopra il Bazaar.",
	RITUAL_INTRO_STEP_ALLIES = "fai \"Outfitting and Allies\" — incontra gli alleati allo staging ground di Lilatha.",
	RITUAL_INTRO_STEP_VOIDSTRIKE = "\"Void Strike\" — questo step si svolge nella zona di assalto attiva (vedi Void Assault più sotto).",
	RITUAL_INTRO_STEP_PROBLEMS = "\"Ritual Problems\" — indaga sui report dei Ritual Site, poi sabota un Ritual Site.",
	RITUAL_INTRO_STEP_INTEREST = "\"Ritual Interest\" — fai rapporto a Lady Darkglen all'hub.",
	RITUAL_WEEKLY_HINT_INPROGRESS = "È nel tuo registro delle quest — finiscila e consegnala.",

	-- Intro / come funziona --------------------------------------------------
	RITUAL_TIP_INTRO_TIERS = "• Scegli il tuo tier alla Curious Obelisk; completa ogni tier per sbloccare il successivo.|n• Il Tier 3 richiede 1 challenge attiva, il Tier 4 ne richiede 2, il Tier 5 ne richiede 4.|n• I tier più alti danno più Spoils e renown. |cffffffffL'obelisco mostra da sé l'item level consigliato per ogni tier|r — leggilo lì. La Season 2 ha spostato quei numeri, e qualsiasi elenco stampato qui è di nuovo sbagliato alla prossima patch.",
	RITUAL_TIP_INTRO_SCORING = "• Gli Spoils sono il tuo punteggio; il Ritual Chest finale scala con essi.|n• Morti: le prime 2 sono gratis, poi ogni morte taglia gli Spoils del 5%, fino a un massimo del -50%.|n• Le run pulite battono i pull veloci — morire costa ricompense in modo diretto.",
	RITUAL_TIP_INTRO_WEEKLY = "• Ogni settimana il tier necessario per SBLOCCARE una challenge cala di uno, così col tempo tutti le sbloccano.|n• Non puoi sbloccare tutte e 8 le challenge in una sola settimana.|n• Conta per la riga World della Great Vault.|n• Booster del renown: Ritual Tablet (primo sito della settimana), Ritual Tablet Fragment (secondo sito) e Ritual Site Reports (scalati in base ai tuoi Spoils).",
	RITUAL_TIP_INTRO_ORBS = "• In combat, i Regeneration Orb si manifestano e curano il 15% della tua vita (Renown 1).|n• Orb Potency (Renown 4) aumenta quella cura.|n• Affidati agli orb invece di bruciare cooldown sul self-healing.",

	-- Daggerspine Point (Eversong Woods) -------------------------------------
	RITUAL_TIP_DAGGERSPINE_OVERVIEW = "• Eversong Woods — Daggerspine Point, sulla costa ovest vicino a Goldenmist Village.|n• Nemici: naga.|n• Attivo una settimana per volta; l'obelisco mostra un'icona viola sulla mappa.|n• Entra alla Curious Obelisk e scegli lì il tuo tier + le challenge.",
	RITUAL_TIP_DAGGERSPINE_PHASES = "• Un breve scenario istanziato: completa gli obiettivi e le ondate di nemici, poi un boss finale, poi saccheggia il Ritual Chest.|n• Scenario visto all'obelisco: \"A Strike From the Sea\" — la leader naga Selen'vjar (kill del boss finale ancora da confermare).|n• Un sito può avere più di un layout di scenario — da confermare in-game.",
	RITUAL_TIP_DAGGERSPINE_NOTES = "• Tainted Bone Pile (sblocca la challenge Tainted Corpses): /way 66.09 62.58.|n• Dark Obelisk (quest Malevolent Boons — esamina 5 qualsiasi; 9 spawn): 66.6/38.8 · 64.7/49.8 · 63.8/70.9 · 39.2/76.2 · 35.3/63.2 · 50/42 · 42/56 · 62/62 · 44.8/47.3.|n• Piccoli tesori e Regeneration Orb sono sparsi per il sito.",

	-- Broken Throne (Zul'Aman) -----------------------------------------------
	RITUAL_TIP_BROKENTHRONE_OVERVIEW = "• Zul'Aman — Broken Throne, nel sud della zona.|n• Nemici: cultisti di Twilight's Blade.|n• Attivo una settimana per volta; l'obelisco mostra un'icona viola sulla mappa.|n• Entra alla Curious Obelisk e scegli lì il tuo tier + le challenge.",
	RITUAL_TIP_BROKENTHRONE_PHASES = "• Un breve scenario istanziato: completa gli obiettivi e le ondate di nemici, poi un boss finale, poi saccheggia il Ritual Chest.|n• Scenario visto all'obelisco: \"A Corrupted Path\" — Faithbreaker Ger'lok corrompe tutto con il Void ed è il boss finale.|n• MORTALE sui boss successivi (es. il Corrupted Amani Dragonhawk): gli specchi void (Dissonant Reflections) continuano a spawnare e lanciano Dissonant Realities — un enorme burst su tutto entro 100 yard. Non puoi superarne la portata: INTERROMPI il cast e lo specchio sparisce all'istante. Conserva il kick proprio per questo.|n• Corrupted Amani Dragonhawk: una Binding Nebula ti intrappola — NON puoi uscire finché non UCCIDI la nebula stessa, quindi falla fuori a burst nel momento in cui vieni catturato. I giocatori intrappolati muoiono per Volatile Plumage (l'eruzione di piume colpisce per centinaia di migliaia); non stare mai davanti allo Shadowflame Breath.|n• Un sito può avere più di un layout di scenario — da confermare in-game.",
	RITUAL_TIP_BROKENTHRONE_NOTES = "• Tainted Bone Pile (sblocca la challenge Tainted Corpses): /way 47.91 36.52.|n• Dark Obelisk (quest Malevolent Boons — esamina 5 qualsiasi; 6 spawn): 61/50 · 41/50 · 45/59 · 42/68 · 55/58 · 54/54.|n• Distruggere i Dark Obelisk rimuove i buff che potenziano i nemici del sito — eliminarli rende i boss decisamente più facili (lasciali in piedi solo se punti all'achievement no-obelisk).|n• Piccoli tesori e Regeneration Orb sono sparsi per il sito.",
	-- Ritual Boss Coach (finestra boss; EditBox -> {SPELL:} qui è permesso).
	RITUAL_BOSS_DRAGONHAWK_STEPS = "• {SPELL:1291610} lascia piccole POZZE ROSSE — SOAKKALE: stai dentro una pozza per subire solo un colpetto. Una pozza lasciata vuota erutta per danni Shadowflame enormi — QUELLO è il wipe (ha ucciso tutti e tre). Un giocatore per pozza basta.|n• {SPELL:1284125} è una gravity pull; le pozze rosse spawnano al suo interno, quindi soakkale lì.|n• Interrompi {SPELL:1284085} dall'add che spawna al centro — un kick lo rimuove all'istante.|n• Uccidi gli add Unbound Caller (la loro Enervating Volley colpisce duro) e schiva Radiation Wave.|n• Stai DIETRO il dragonhawk — il suo Shadowflame Breath frontale è letale. (Verificato in-game + Wowhead.)",
	RITUAL_BOSS_GERLOK_STEPS = "• Evoca minion che lo rendono (quasi) immune ai danni — falli fuori ogni add nell'istante in cui spawna; gli add caricano con un channel di fuoco che quasi one-shotta, quindi spostati dalla traiettoria.|n• {SPELL:1273031} è IL cast da interrompere — un grosso nuke AoE; non ogni cast è kickabile, quindi conserva l'interrupt per esso.|n• {SPELL:1279186} viene spammato — spezza la linea di vista dietro i pilastri.|n• Tienilo SULLA sua piattaforma — trascinarlo giù/fuori resetta il fight (Rob, live). Lo spazio è angusto, ma non inseguirlo nella stanza sotto.",
	RAID_BOSS_ROTMIRE_STEPS = "• Un solo boss, ma tieni d'occhio la sua barra di energia: quando si riempie lancia {SPELL:1221637} — il wipe. Tienila bassa uccidendo gli add e le spore di cui si nutre.|n• Add: falli fuori in fretta gli Shroomling e i Fungling, e interrompi gli Sporecap ({SPELL:1221714} / {SPELL:1221717}).|n• Esci da {SPELL:1221965} e corri fuori da {SPELL:1222088} -> {SPELL:1222129}.|n• Solo Mythic: sparpagliatevi per {SPELL:1222684}, poi gestisci {SPELL:1222495}. (Datamined — conferma in-game al lancio.)",
	RAID_BOSS_ROTMIRE_TANK = "• {SPELL:1221781} accumula stack — fai swap con l'off-tank, e tieni il boss fuori dal casino di spore/viticci.",
	RAID_BOSS_ROTMIRE_HEALER = "• Il danno cresce con {SPELL:1221787} -> {SPELL:1222176} (Bursting -> Rotting Pustules, un soft enrage) — smorza i picchi e dissolvi dove puoi.",
	RAID_BOSS_ROTMIRE_DPS = "• Dai priorità agli add (soprattutto gli Sporecap) così la sua energia non raggiunge mai Fungal Bloom, poi torna sul boss.",
	RAID_BOSS_NYMRISSA_STEPS = "• |cffffd100L’ingresso è SOTT’ACQUA|r — una grotta sommersa, quindi la barra del fiato scende già prima dello scontro. Intorno all’ingresso ci sono bolle d’aria per riprendere fiato.|n• Il primo Lair: un boss in una grotta sottomarina, istanziato, e conta per la riga Raid della tua Great Vault.|n• Sei abilità sono note per nome dal PTR 12.1, ma non cosa fanno — leggilo come un preavviso, non come una tattica.|n• Add — {SPELL:1257717} porta murloc; ucciderli è la chiamata.|n• Un orbe da cui allontanarsi — {SPELL:1313393}.|n• Attenzione a dove stai — {SPELL:1258668}.|n• Danno su tutto il gruppo — {SPELL:1260837}.|n• In linea sul tank — {SPELL:1282937}, o {SPELL:1268562} in Mitico.|n• Soft enrage a 10 minuti.|n• Il lair apre il 18 ago. Il segnalino della missione compare prima sulla mappa — l’ingresso si trova, ma ogni difficoltà ti rifiuta con un messaggio di requisiti finché non si sblocca.|n• I passi veri arrivano dopo la prima run dal vivo.",
	RAID_BOSS_NYMRISSA_TANK = "• La linea arriva su di te: {SPELL:1282937}, e {SPELL:1268562} in Mitico. Se vada puntata lontano dal gruppo è ancora da confermare.",
	RAID_BOSS_NYMRISSA_HEALER = "• {SPELL:1260837} colpisce tutto il gruppo — tieni da parte i cooldown per quello.",
	RAID_BOSS_NYMRISSA_DPS = "• {SPELL:1257717} evoca murloc — passa su di loro, poi torna sul boss. Il resto è movimento.",
	RITUAL_BOSS_MINDBREAKER_STEPS = "• Empowered Mindbreaker — stage 2 di Daggerspine Point 'Beast From the Deep': una creatura degli abissi che Lady Selen'vjar sovraccarica con magia void rubata.|n• Per ora: interrompi i suoi cast ed esci dagli effetti a terra evidenti.|n• Gli step dettagliati arrivano nel prossimo aggiornamento di Midnight Helper (le sue abilità esatte non sono ancora datamined — compilate dalla prima run live).",
	RITUAL_BOSS_SELENVJAR_STEPS = "• Lady Selen'vjar — incantatrice naga, boss finale di Daggerspine Point (Eversong Woods, /way 34.9 65.4). Stage: 1) Ritual Roles (i suoi capitani sorvegliano il rituale, drenando essenza void); 2) Beast From the Deep (potenzia un Mindbreaker); 3) Summoner's Fall (ti affronta di persona).|n• Gli step dettagliati di interrupt/schivata arrivano nel prossimo aggiornamento di Midnight Helper (le sue abilità non sono ancora datamined — compilate dalla prima run live).",
	RITUAL_ALERT_BINDING_NEBULA = "Binding Nebula! -> uccidi la nebula",
	RITUAL_ALERT_SHADOWBOLT = "Interrompi Shadowbolt Volley!",
	RITUAL_ALERT_DISSONANT = "Interrompi Dissonant Reflections!",

	-- Challenge --------------------------------------------------------------
	RITUAL_TIP_TENDRILS_MECHANIC = "• I tendril afferranti spawnano con un cerchio verde vorticoso — esci o vieni radicato e subisci danni.|n• Aumenta gli Spoils mentre è attiva.",
	RITUAL_TIP_TENDRILS_UNLOCK = "• Saccheggia un Ritual Chest alla fine di un sito qualsiasi, poi consegna la quest \"Ritual Site Challenge Report: Tendrils\".",
	RITUAL_TIP_MANIFESTATIONS_MECHANIC = "• Gli spiriti si manifestano e lanciano incantesimi — interrompili o subisci magia logorante.|n• Aumenta gli Spoils mentre è attiva.",
	RITUAL_TIP_MANIFESTATIONS_UNLOCK = "• Completa un sito Tier 3, poi parla con Ranger Captain Lilatha a Silvermoon (il tier richiesto cala ogni settimana).",
	RITUAL_TIP_ALARMBELLS_MECHANIC = "• Uccidere i nemici evoca rinforzi; più grande e forte è il pull che uccidi, più forti sono gli add.|n• Aumenta gli Spoils mentre è attiva.",
	RITUAL_TIP_ALARMBELLS_UNLOCK = "• Completa un sito Tier 4, poi parla con Lady Darkglen a Silvermoon (il tier richiesto cala ogni settimana).",
	RITUAL_TIP_MALEVOLENTBOONS_MECHANIC = "• I dark obelisk buffano i nemici vicini — distruggi gli obelisk per rimuovere i buff.|n• Aumenta gli Spoils mentre è attiva.",
	RITUAL_TIP_MALEVOLENTBOONS_UNLOCK = "• Completa un sito Tier 2 per una quest da Lady Darkglen, poi esamina 5 Dark Obelisk dentro un sito (il tier richiesto cala ogni settimana).",
	RITUAL_TIP_TAINTEDCORPSES_MECHANIC = "• I nemici uccisi lasciano una pozza di magia void letale — spostati fuori da essa.|n• Aumenta gli Spoils mentre è attiva.",
	RITUAL_TIP_TAINTEDCORPSES_UNLOCK = "• Saccheggia un Tainted Bone Pile dentro un sito Tier 2+ (vedi le note sul sito per la posizione), poi consegna la quest.",
	RITUAL_TIP_REINFORCED_MECHANIC = "• Nemici extra sono distribuiti per tutto il sito — aspettati pack più fitti.|n• Aumenta gli Spoils mentre è attiva (uno dei boost maggiori).",
	RITUAL_TIP_REINFORCED_UNLOCK = "• Completa un sito Tier 2, poi parla con Ranger Captain Lilatha a Silvermoon (il tier richiesto cala ogni settimana).",
	RITUAL_TIP_PATROLS_MECHANIC = "• Nemici elite pattugliano il sito — evita i loro percorsi quando puoi.|n• Aumenta gli Spoils mentre è attiva.",
	RITUAL_TIP_PATROLS_UNLOCK = "• \"Procura\" tesori unici da un sito Tier 3+ (il tier richiesto cala ogni settimana).",
	RITUAL_TIP_EMBERS_MECHANIC = "• Nemici casuali E il boss finale sono potenziati, segnalati da un orb fluttuante sopra di loro.|n• Aumenta gli Spoils mentre è attiva (uno dei boost maggiori).",
	RITUAL_TIP_EMBERS_UNLOCK = "• Saccheggia un Ember of Power dentro un sito Tier 4 per iniziare la quest (il tier richiesto cala ogni settimana).",
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
	RITUAL_COACH_COPY_BTN = "Kopieer als tekst",
	RITUAL_SHARE_COPY_TITLE = "Ritual-tips kopiëren",
	RITUAL_SHARE_COPY_HINT = "Ctrl+C, plak daarna in groepschat of Discord.",
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
	RITUAL_TIP_INTRO_TIERS = "• Kies je tier bij de Curious Obelisk; elke tier moet gecleard zijn om de volgende te ontgrendelen.|n• Tier 3 vereist 1 actieve challenge, Tier 4 vereist er 2, Tier 5 vereist er 4.|n• Hogere tiers geven meer Spoils en renown. |cffffffffDe obelisk toont zelf het aanbevolen item level per tier|r — lees het daar. Season 2 heeft die getallen verschoven, en elk lijstje dat wij hier afdrukken klopt volgende patch alweer niet.",
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
	RITUAL_TIP_BROKENTHRONE_NOTES = "• Tainted Bone Pile (ontgrendelt de Tainted Corpses-challenge): /way 47.91 36.52.|n• Dark Obelisks (Malevolent Boons-quest — onderzoek er 5 van de 6): 61/50 · 41/50 · 45/59 · 42/68 · 55/58 · 54/54.|n• De Dark Obelisks slopen haalt de buffs weg die de vijanden versterken — ze clearen maakt de bazen merkbaar makkelijker (laat ze alleen staan als je voor de no-obelisk-achievement gaat).|n• Kleine treasures en Regeneration Orbs liggen verspreid door de site.",
	RITUAL_BOSS_DRAGONHAWK_STEPS = "• {SPELL:1291610} laat kleine RODE PLASSEN vallen — SOAK ze: ga in een plas staan voor maar een kleine tik. Een lege plas ontploft voor enorme Shadowflame-schade — DÁT is de wipe (zo gingen jullie alle drie dood). Eén speler per plas is genoeg.|n• {SPELL:1284125} is een gravity-pull; de rode plassen spawnen erbinnen, dus soak ze daar.|n• Interrupt {SPELL:1284085} van de add die in het midden spawnt — een kick laat 'm direct verdwijnen.|n• Dood de Unbound Caller-adds (hun Enervating Volley slaat hard) en ontwijk Radiation Wave.|n• Ga ACHTER de dragonhawk staan — zijn frontale Shadowflame Breath is dodelijk. (In-game + Wowhead geverifieerd.)",
	RITUAL_BOSS_GERLOK_STEPS = "• Hij summont minions die hem (vrijwel) immuun maken — brand elke add direct weg zodra die spawnt; de adds chargen met een vuur-channel die je bijna one-shot, dus stap eruit.|n• {SPELL:1273031} is DÉ cast om te interrupten — een grote AoE-knal; niet elke cast is kickbaar, dus bewaar je interrupt hiervoor.|n• {SPELL:1279186} wordt gespamd — breek line of sight achter de pilaren.|n• Houd hem ÓP zijn platform — als je hem naar beneden/eraf pullt, reset het gevecht (Rob, live). Het is krap, maar zoek geen ruimte beneden.",
	RAID_BOSS_ROTMIRE_STEPS = "• Eén boss, maar let op zijn energie-balk: vult die, dan komt {SPELL:1221637} — de wipe. Houd 'm laag door de adds en sporen te killen waar hij op teert.|n• Adds: brand Shroomlings en Funglings snel weg en interrupt de Sporecaps ({SPELL:1221714} / {SPELL:1221717}).|n• Stap uit {SPELL:1221965} en ren uit {SPELL:1222088} → {SPELL:1222129}.|n• Alleen Mythic: spreid voor {SPELL:1222684} en handel {SPELL:1222495}. (Gedataminet — bij launch in-game bevestigen.)",
	RAID_BOSS_ROTMIRE_TANK = "• {SPELL:1221781} stapelt — wissel met de off-tank en houd de boss uit de sporen/vines-rommel.",
	RAID_BOSS_ROTMIRE_HEALER = "• Schade loopt op met {SPELL:1221787} → {SPELL:1222176} (Bursting → Rotting Pustules, soft enrage) — vang de pieken op en dispel waar mogelijk.",
	RAID_BOSS_ROTMIRE_DPS = "• Prioriteer de adds (vooral Sporecaps) zodat zijn energie Fungal Bloom nooit haalt, daarna terug op de boss.",
	RAID_BOSS_NYMRISSA_STEPS = "• |cffffd100De ingang ligt ONDER WATER|r — een verzonken grot, dus je adembalk loopt al vóór het gevecht. Rond de ingang drijven luchtbellen om bij te tanken.|n• De eerste Lair: één boss in een onderwatergrot, instanced, en hij telt mee voor de Raid-rij van je Great Vault.|n• Zes vaardigheden kennen we bij naam uit de 12.1-PTR, maar niet wát ze doen — lees dit als een vooraankondiging, geen tactiek.|n• Adds — {SPELL:1257717} brengt murlocs; die neerhalen is het signaal.|n• Een orb om bij weg te blijven — {SPELL:1313393}.|n• Let op waar je staat — {SPELL:1258668}.|n• Schade op de hele groep — {SPELL:1260837}.|n• Als lijn op de tank — {SPELL:1282937}, op Mythic {SPELL:1268562}.|n• Soft enrage na 10 minuten.|n• De lair opent met Season 2, in de week van 18 augustus — dinsdag in Amerika, woensdag bij ons. De quest-markering staat er al eerder op je kaart — de ingang is dus te vinden, maar elke moeilijkheid weigert je met een vereisten-melding tot hij opengaat.|n• De echte stappen volgen na de eerste live-run.",
	RAID_BOSS_NYMRISSA_TANK = "• De lijn komt op jou: {SPELL:1282937}, op Mythic {SPELL:1268562}. Of je hem van de groep af moet richten, moet nog bevestigd worden.",
	RAID_BOSS_NYMRISSA_HEALER = "• {SPELL:1260837} is de klap op de hele groep — bewaar je cooldowns daarvoor.",
	RAID_BOSS_NYMRISSA_DPS = "• {SPELL:1257717} roept murlocs op — daarheen, daarna terug op de boss. De rest is voetenwerk.",
	RITUAL_BOSS_MINDBREAKER_STEPS = "• Empowered Mindbreaker — Daggerspine Point stage 2 'Beast From the Deep': een diepzee-wezen dat Lady Selen'vjar oplaadt met gestolen void-magie.|n• Voorlopig: interrupt z'n casts en stap uit zichtbare grond-effecten.|n• Gedetailleerde stappen komen in de volgende Midnight Helper-update (z'n exacte abilities zijn nog niet gedataminet — ingevuld uit de eerste live run).",
	RITUAL_BOSS_SELENVJAR_STEPS = "• Lady Selen'vjar — naga-tovenares, eindboss van Daggerspine Point (Eversong Woods, /way 34.9 65.4). Stages: 1) Ritual Roles (haar captains bewaken het ritueel en draineren void-essentie); 2) Beast From the Deep (ze versterkt een Mindbreaker); 3) Summoner's Fall (ze pakt je zelf aan).|n• Gedetailleerde interrupt/ontwijk-stappen komen in de volgende Midnight Helper-update (haar abilities zijn nog niet gedataminet — ingevuld uit de eerste live run).",
	RITUAL_ALERT_BINDING_NEBULA = "Binding Nebula! -> sla de nebula kapot",
	RITUAL_ALERT_SHADOWBOLT = "Interrupt Shadowbolt Volley!",
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
	RITUAL_TIP_INTRO_TIERS = "• Wähle deine Stufe am Curious Obelisk; schließe jede Stufe ab, um die nächste freizuschalten.|n• Tier 3 braucht 1 aktive Challenge, Tier 4 braucht 2, Tier 5 braucht 4.|n• Höhere Stufen geben mehr Spoils und Ansehen. |cffffffffDer Obelisk zeigt selbst die empfohlene Gegenstandsstufe pro Tier|r — lies sie dort. Season 2 hat diese Zahlen verschoben, und jede Liste, die wir hier abdrucken, ist beim nächsten Patch wieder falsch.",
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
	RITUAL_TIP_BROKENTHRONE_NOTES = "• Tainted Bone Pile (schaltet die Tainted-Corpses-Challenge frei): /way 47.91 36.52.|n• Dark Obelisks (Malevolent-Boons-Quest — untersuche 5 von 6): 61/50 · 41/50 · 45/59 · 42/68 · 55/58 · 54/54.|n• Das Zerstören der Dark Obelisks entzieht den Gegnern der Stätte die Buffs, die sie stärken — werden sie beseitigt, sind die Bosse deutlich leichter (lass sie nur stehen, wenn du den Erfolg ohne Obelisken anstrebst).|n• Kleine Schätze und Regeneration Orbs sind über die Stätte verteilt.",
	RITUAL_BOSS_DRAGONHAWK_STEPS = "• {SPELL:1291610} legt kleine ROTE PFÜTZEN — SOAKT sie: Stellt euch in eine Pfütze, um nur einen kleinen Treffer zu kassieren. Eine leere Pfütze explodiert für gewaltigen Shadowflame-Schaden — DAS ist der Wipe (es hat alle drei von euch getötet). Ein Spieler pro Pfütze reicht.|n• {SPELL:1284125} ist ein Gravity Pull; die roten Pfützen entstehen darin, also soakt sie dort.|n• Unterbrecht {SPELL:1284085} vom Add, das in der Mitte spawnt — ein Kick entfernt es sofort.|n• Tötet die Unbound Caller-Adds (ihr Enervating Volley trifft hart) und weicht Radiation Wave aus.|n• Stellt euch HINTER den Drachenfalken — sein frontaler Shadowflame Breath ist tödlich. (Im Spiel + auf Wowhead bestätigt.)",
	RITUAL_BOSS_GERLOK_STEPS = "• Er beschwört Diener, die ihn (fast) immun machen — brennt jedes Add sofort nieder; die Adds stürmen mit einem Feuer-Kanal, der euch fast one-shottet, also tretet heraus.|n• {SPELL:1273031} ist DER Zauber zum Unterbrechen — ein großer AoE-Schlag; nicht jeder ist unterbrechbar, hebt euren Kick dafür auf.|n• {SPELL:1279186} wird gespammt — brecht die Sichtlinie hinter den Säulen.|n• Haltet ihn AUF seiner Plattform — ihn herunter-/herunterzuziehen setzt den Kampf zurück. Der Platz ist eng, aber jagt nicht weiter unten nach Raum.",
	RAID_BOSS_ROTMIRE_STEPS = "• Ein Boss, aber achtet auf seine Energieleiste: ist sie voll, wirkt er {SPELL:1221637} — der Wipe. Haltet sie niedrig, indem ihr die Adds und Sporen tötet, von denen er sich nährt.|n• Adds: brennt Shroomlings und Funglings schnell nieder und unterbrecht die Sporecaps ({SPELL:1221714} / {SPELL:1221717}).|n• Tretet aus {SPELL:1221965} heraus und lauft aus {SPELL:1222088} → {SPELL:1222129}.|n• Nur Mythisch: verteilt euch für {SPELL:1222684} und behandelt {SPELL:1222495}. (Datamined — bei Release im Spiel bestätigen.)",
	RAID_BOSS_ROTMIRE_TANK = "• {SPELL:1221781} stapelt sich — wechselt mit dem Off-Tank und haltet den Boss aus dem Sporen-/Ranken-Chaos.",
	RAID_BOSS_ROTMIRE_HEALER = "• Der Schaden steigt mit {SPELL:1221787} → {SPELL:1222176} (Bursting → Rotting Pustules, ein weicher Enrage) — fangt die Spitzen ab und entfernt, wo ihr könnt.",
	RAID_BOSS_ROTMIRE_DPS = "• Priorisiert die Adds (besonders Sporecaps), damit seine Energie nie Fungal Bloom erreicht, dann zurück auf den Boss.",
	RAID_BOSS_NYMRISSA_STEPS = "• |cffffd100Der Eingang liegt UNTER WASSER|r — eine versunkene Höhle, deine Atemleiste läuft also schon vor dem Kampf. Rund um den Eingang gibt es Luftblasen zum Auffüllen.|n• Der erste Lair: ein Boss in einer Unterwassergrotte, instanziiert, und er zählt für die Schlachtzugsreihe deiner Great Vault.|n• Sechs Fähigkeiten kennen wir vom 12.1-PTR namentlich, aber nicht, was sie tun — lies das als Vorwarnung, nicht als Taktik.|n• Adds — {SPELL:1257717} bringt Murlocs; die umzuhauen ist die Ansage.|n• Eine Kugel, von der du weggehst — {SPELL:1313393}.|n• Achte darauf, wo du stehst — {SPELL:1258668}.|n• Schaden auf die ganze Gruppe — {SPELL:1260837}.|n• Als Linie auf den Tank — {SPELL:1282937}, auf Mythisch {SPELL:1268562}.|n• Soft-Enrage nach 10 Minuten.|n• Der Lair öffnet mit Season 2, in der Woche des 18. August — dienstags in Amerika, mittwochs in Europa. Die Questmarkierung erscheint schon vorher auf der Karte — der Eingang ist also auffindbar, aber jede Schwierigkeit weist dich mit einer Voraussetzungsmeldung ab, bis er freigeschaltet ist.|n• Die echten Schritte folgen nach dem ersten Live-Run.",
	RAID_BOSS_NYMRISSA_TANK = "• Die Linie kommt auf dich: {SPELL:1282937}, auf Mythisch {SPELL:1268562}. Ob sie von der Gruppe weggedreht werden muss, ist noch zu bestätigen.",
	RAID_BOSS_NYMRISSA_HEALER = "• {SPELL:1260837} trifft die ganze Gruppe — heb deine Cooldowns dafür auf.",
	RAID_BOSS_NYMRISSA_DPS = "• {SPELL:1257717} beschwört Murlocs — wechsle drauf, dann zurück auf den Boss. Der Rest ist Laufarbeit.",
	RITUAL_BOSS_MINDBREAKER_STEPS = "• Empowered Mindbreaker — Daggerspine Point Phase 2 'Beast From the Deep': eine Tiefsee-Kreatur, die Lady Selen'vjar mit gestohlener Void-Magie auflädt.|n• Vorerst: unterbrecht seine Zauber und tretet aus offensichtlichen Bodeneffekten.|n• Ausführliche Schritte folgen im nächsten Midnight-Helper-Update (seine genauen Fähigkeiten sind noch nicht datamined — ergänzt nach dem ersten Live-Run).",
	RITUAL_BOSS_SELENVJAR_STEPS = "• Lady Selen'vjar — Naga-Zauberin, Endboss von Daggerspine Point (Eversong Woods, /way 34.9 65.4). Phasen: 1) Ritual Roles (ihre Captains bewachen das Ritual und entziehen Void-Essenz); 2) Beast From the Deep (sie verstärkt einen Mindbreaker); 3) Summoner's Fall (sie stellt sich euch selbst).|n• Ausführliche Unterbrechen-/Ausweichen-Schritte folgen im nächsten Midnight-Helper-Update (ihre Fähigkeiten sind noch nicht datamined — ergänzt nach dem ersten Live-Run).",
	RITUAL_ALERT_BINDING_NEBULA = "Binding Nebula! -> Nebula zerstören",
	RITUAL_ALERT_SHADOWBOLT = "Shadowbolt Volley unterbrechen!",
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
	RITUAL_TIP_INTRO_TIERS = "• Choisis ton palier au Curious Obelisk ; chaque palier doit être terminé pour débloquer le suivant.|n• Le Tier 3 demande 1 challenge actif, le Tier 4 en demande 2, le Tier 5 en demande 4.|n• Les paliers plus élevés donnent plus de Spoils et de renommée. |cffffffffL'obélisque affiche lui-même le niveau d'objet recommandé par palier|r — lis-le là. La Season 2 a déplacé ces chiffres, et toute liste imprimée ici sera fausse au prochain patch.",
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
	RITUAL_TIP_BROKENTHRONE_NOTES = "• Tainted Bone Pile (débloque le challenge Tainted Corpses) : /way 47.91 36.52.|n• Dark Obelisks (quête Malevolent Boons — examines-en 5 sur 6) : 61/50 · 41/50 · 45/59 · 42/68 · 55/58 · 54/54.|n• Détruire les Dark Obelisks retire les buffs qui renforcent les ennemis du site — les éliminer rend les boss nettement plus faciles (ne les laisse debout que si tu vises le haut fait sans obélisque).|n• De petits trésors et des Regeneration Orbs sont dispersés sur le site.",
	RITUAL_BOSS_DRAGONHAWK_STEPS = "• {SPELL:1291610} laisse de petites FLAQUES ROUGES — SOAKEZ-les : tenez-vous dans une flaque pour ne prendre qu'un petit coup. Une flaque laissée vide explose pour d'énormes dégâts de Shadowflame — C'EST ça le wipe (ça vous a tués tous les trois). Un joueur par flaque suffit.|n• {SPELL:1284125} est un gravity pull ; les flaques rouges apparaissent à l'intérieur, alors soakez-les là.|n• Interrompez {SPELL:1284085} de l'add qui apparaît au centre — un kick le retire instantanément.|n• Tuez les adds Unbound Caller (leur Enervating Volley frappe fort) et esquivez Radiation Wave.|n• Tenez-vous DERRIÈRE le faucon-dragon — son Shadowflame Breath frontal est mortel. (Vérifié en jeu + Wowhead.)",
	RITUAL_BOSS_GERLOK_STEPS = "• Il invoque des serviteurs qui le rendent (presque) insensible aux dégâts — brûlez chaque add dès son apparition ; les adds chargent avec un canal de feu qui tue presque d'un coup, sortez-en.|n• {SPELL:1273031} est LA incantation à interrompre — une grosse explosion de zone ; toutes ne sont pas interruptibles, gardez votre kick pour celle-là.|n• {SPELL:1279186} est spammé — coupez la ligne de vue derrière les piliers.|n• Gardez-le SUR sa plateforme — le tirer en bas/hors de celle-ci réinitialise le combat. L'espace est exigu, mais ne cherchez pas de place en contrebas.",
	RAID_BOSS_ROTMIRE_STEPS = "• Un seul boss, mais surveillez sa barre d'énergie : pleine, il lance {SPELL:1221637} — le wipe. Gardez-la basse en tuant les adds et les spores dont il se nourrit.|n• Adds : brûlez vite les Shroomlings et Funglings, et interrompez les Sporecaps ({SPELL:1221714} / {SPELL:1221717}).|n• Sortez de {SPELL:1221965} et fuyez {SPELL:1222088} → {SPELL:1222129}.|n• Mythique seulement : dispersez-vous pour {SPELL:1222684} puis gérez {SPELL:1222495}. (Datamined — à confirmer en jeu à la sortie.)",
	RAID_BOSS_ROTMIRE_TANK = "• {SPELL:1221781} s'accumule — alternez avec l'autre tank et gardez le boss hors du chaos de spores/lianes.",
	RAID_BOSS_ROTMIRE_HEALER = "• Les dégâts montent avec {SPELL:1221787} → {SPELL:1222176} (Bursting → Rotting Pustules, un enrage doux) — atténuez les pics et dissipez quand vous pouvez.",
	RAID_BOSS_ROTMIRE_DPS = "• Priorisez les adds (surtout les Sporecaps) pour que son énergie n'atteigne jamais Fungal Bloom, puis revenez sur le boss.",
	RAID_BOSS_NYMRISSA_STEPS = "• |cffffd100L’entrée est SOUS L’EAU|r — une grotte immergée : votre jauge de souffle descend avant même le combat. Des bulles d’air autour de l’entrée permettent de la remplir.|n• Le premier Lair : un boss dans une grotte sous-marine, en instance, et il alimente la ligne Raid de votre Great Vault.|n• Six capacités sont connues par leur nom depuis le PTR 12.1, mais pas ce qu’elles font — à lire comme un avertissement, pas comme une stratégie.|n• Adds — {SPELL:1257717} amène des murlocs ; les tuer, c’est la consigne.|n• Un orbe dont il faut s’éloigner — {SPELL:1313393}.|n• Attention à où vous vous tenez — {SPELL:1258668}.|n• Dégâts sur tout le groupe — {SPELL:1260837}.|n• En ligne sur le tank — {SPELL:1282937}, ou {SPELL:1268562} en Mythique.|n• Enrage douce à 10 minutes.|n• Le lair ouvre avec la saison 2, dans la semaine du 18 août — mardi en Amérique, mercredi en Europe. Son marqueur de quête apparaît plus tôt sur la carte — l’entrée est donc trouvable, mais chaque difficulté vous refuse avec un message de prérequis jusqu’à l’ouverture.|n• Les vraies étapes arrivent après la première run en live.",
	RAID_BOSS_NYMRISSA_TANK = "• La ligne vous vise : {SPELL:1282937}, et {SPELL:1268562} en Mythique. Reste à confirmer s’il faut l’orienter loin du groupe.",
	RAID_BOSS_NYMRISSA_HEALER = "• {SPELL:1260837} frappe tout le groupe — gardez vos cooldowns pour ça.",
	RAID_BOSS_NYMRISSA_DPS = "• {SPELL:1257717} invoque des murlocs — passez dessus, puis retour sur le boss. Le reste, c’est du placement.",
	RITUAL_BOSS_MINDBREAKER_STEPS = "• Empowered Mindbreaker — Daggerspine Point phase 2 'Beast From the Deep' : une créature des profondeurs que Lady Selen'vjar surcharge de magie du Vide volée.|n• Pour l'instant : interrompez ses incantations et sortez des effets au sol évidents.|n• Les étapes détaillées arrivent dans la prochaine mise à jour de Midnight Helper (ses capacités exactes ne sont pas encore datamined — complétées après le premier run en jeu).",
	RITUAL_BOSS_SELENVJAR_STEPS = "• Lady Selen'vjar — sorcière naga, boss final de Daggerspine Point (Eversong Woods, /way 34.9 65.4). Phases : 1) Ritual Roles (ses capitaines gardent le rituel en drainant l'essence du Vide) ; 2) Beast From the Deep (elle renforce un Mindbreaker) ; 3) Summoner's Fall (elle vous affronte elle-même).|n• Les étapes détaillées (interruption/esquive) arrivent dans la prochaine mise à jour de Midnight Helper (ses capacités ne sont pas encore datamined — complétées après le premier run en jeu).",
	RITUAL_ALERT_BINDING_NEBULA = "Binding Nebula ! -> détruisez la nébuleuse",
	RITUAL_ALERT_SHADOWBOLT = "Interrompez Shadowbolt Volley !",
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
	RITUAL_TIP_INTRO_TIERS = "• Elige tu tier en el Curious Obelisk; cada tier debe completarse para desbloquear el siguiente.|n• Tier 3 requiere 1 challenge activo, Tier 4 requiere 2, Tier 5 requiere 4.|n• Los tiers más altos dan más Spoils y renombre. |cffffffffEl obelisco muestra el nivel de objeto recomendado de cada tier|r — léelo ahí. La Season 2 movió esos números, y cualquier lista impresa aquí vuelve a estar mal en el siguiente parche.",
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
	RITUAL_TIP_BROKENTHRONE_NOTES = "• Tainted Bone Pile (desbloquea el challenge Tainted Corpses): /way 47.91 36.52.|n• Dark Obelisks (misión Malevolent Boons — investiga 5 de 6): 61/50 · 41/50 · 45/59 · 42/68 · 55/58 · 54/54.|n• Destruir los Dark Obelisks elimina las mejoras que potencian a los enemigos del sitio — limpiarlos hace que los jefes sean notablemente más fáciles (déjalos en pie solo si vas a por el logro sin obeliscos).|n• Hay pequeños tesoros y Regeneration Orbs repartidos por el sitio.",
	RITUAL_BOSS_DRAGONHAWK_STEPS = "• {SPELL:1291610} deja pequeños CHARCOS ROJOS — SOAKÉALOS: ponte dentro de un charco para recibir solo un golpe pequeño. Un charco que se deja vacío estalla con un daño enorme de Shadowflame — ESE es el wipe (os mató a los tres). Basta un jugador por charco.|n• {SPELL:1284125} es un gravity pull; los charcos rojos aparecen dentro de él, así que soakéalos ahí.|n• Interrumpe {SPELL:1284085} del add que aparece en el centro — una patada lo elimina al instante.|n• Mata a los adds Unbound Caller (su Enervating Volley pega fuerte) y esquiva Radiation Wave.|n• Ponte DETRÁS del dracohalcón — su Shadowflame Breath frontal es letal. (Verificado en el juego + Wowhead.)",
	RITUAL_BOSS_GERLOK_STEPS = "• Invoca esbirros que lo vuelven (casi) inmune al daño — quema cada add en cuanto aparezca; los adds cargan con un canal de fuego que casi te mata de un golpe, así que sal de él.|n• {SPELL:1273031} es EL lanzamiento a interrumpir — un gran estallido de área; no todos son interrumpibles, guarda tu patada para ese.|n• {SPELL:1279186} se lanza sin parar — corta la línea de visión detrás de los pilares.|n• Mantenlo EN su plataforma — arrastrarlo hacia abajo/fuera de ella reinicia el combate. El espacio es estrecho, pero no busques sitio más abajo.",
	RAID_BOSS_ROTMIRE_STEPS = "• Un solo jefe, pero vigila su barra de energía: al llenarse lanza {SPELL:1221637} — el wipe. Mantenla baja matando los adds y esporas de los que se nutre.|n• Adds: quema rápido a los Shroomlings y Funglings, e interrumpe a los Sporecaps ({SPELL:1221714} / {SPELL:1221717}).|n• Sal de {SPELL:1221965} y corre fuera de {SPELL:1222088} → {SPELL:1222129}.|n• Solo Mítico: dispérsate para {SPELL:1222684} y gestiona {SPELL:1222495}. (Datamined — confirmar en el juego al lanzamiento.)",
	RAID_BOSS_ROTMIRE_TANK = "• {SPELL:1221781} acumula — alterna con el otro tanque y mantén al jefe fuera del lío de esporas/enredaderas.",
	RAID_BOSS_ROTMIRE_HEALER = "• El daño sube con {SPELL:1221787} → {SPELL:1222176} (Bursting → Rotting Pustules, un enrage suave) — amortigua los picos y disipa cuando puedas.",
	RAID_BOSS_ROTMIRE_DPS = "• Prioriza los adds (sobre todo los Sporecaps) para que su energía nunca llegue a Fungal Bloom, luego vuelve al jefe.",
	RAID_BOSS_NYMRISSA_STEPS = "• |cffffd100La entrada está BAJO EL AGUA|r — una cueva sumergida, así que tu barra de aire corre antes de empezar la pelea. Hay burbujas de aire alrededor de la entrada para recuperarla.|n• El primer Lair: un jefe en una gruta submarina, en instancia, y cuenta para la fila de Banda de tu Great Vault.|n• Conocemos seis habilidades por su nombre desde el PTR 12.1, pero no qué hace cada una — léelo como un aviso, no como una táctica.|n• Adds — {SPELL:1257717} trae múrlocs; matarlos es la señal.|n• Un orbe del que alejarse — {SPELL:1313393}.|n• Cuidado con dónde te colocas — {SPELL:1258668}.|n• Daño a todo el grupo — {SPELL:1260837}.|n• En línea sobre el tanque — {SPELL:1282937}, o {SPELL:1268562} en Mítico.|n• Enfurecimiento suave a los 10 minutos.|n• El lair abre con la temporada 2, en la semana del 18 de agosto — martes en América, miércoles en Europa. Su marcador de misión aparece antes en el mapa — la entrada se puede encontrar, pero cada dificultad te rechaza con un mensaje de requisitos hasta que se desbloquea.|n• Los pasos reales llegan tras la primera partida en vivo.",
	RAID_BOSS_NYMRISSA_TANK = "• La línea va hacia ti: {SPELL:1282937}, y {SPELL:1268562} en Mítico. Falta confirmar si hay que apuntarla lejos del grupo.",
	RAID_BOSS_NYMRISSA_HEALER = "• {SPELL:1260837} golpea a todo el grupo — guarda tus cooldowns para eso.",
	RAID_BOSS_NYMRISSA_DPS = "• {SPELL:1257717} invoca múrlocs — cámbiate a ellos y vuelve al jefe. Lo demás es colocación.",
	RITUAL_BOSS_MINDBREAKER_STEPS = "• Empowered Mindbreaker — Daggerspine Point fase 2 'Beast From the Deep': una criatura de las profundidades que Lady Selen'vjar sobrecarga con magia del Vacío robada.|n• Por ahora: interrumpe sus lanzamientos y sal de los efectos de suelo evidentes.|n• Los pasos detallados llegan en la próxima actualización de Midnight Helper (sus habilidades exactas aún no están datamined — se completan tras la primera run en el juego).",
	RITUAL_BOSS_SELENVJAR_STEPS = "• Lady Selen'vjar — hechicera naga, jefa final de Daggerspine Point (Eversong Woods, /way 34.9 65.4). Fases: 1) Ritual Roles (sus capitanes protegen el ritual drenando esencia del Vacío); 2) Beast From the Deep (potencia a un Mindbreaker); 3) Summoner's Fall (te enfrenta ella misma).|n• Los pasos detallados (interrumpir/esquivar) llegan en la próxima actualización de Midnight Helper (sus habilidades aún no están datamined — se completan tras la primera run en el juego).",
	RITUAL_ALERT_BINDING_NEBULA = "¡Binding Nebula! -> destruye la nebulosa",
	RITUAL_ALERT_SHADOWBOLT = "¡Interrumpe Shadowbolt Volley!",
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
	RITUAL_TIP_INTRO_TIERS = "• Escolhe o teu tier no Curious Obelisk; cada tier precisa ser limpo para desbloquear o próximo.|n• O Tier 3 exige 1 challenge ativo, o Tier 4 exige 2, o Tier 5 exige 4.|n• Tiers mais altos dão mais Spoils e renome. |cffffffffO obelisco mostra o item level recomendado de cada tier|r — lê-o aí. A Season 2 mudou esses números, e qualquer lista impressa aqui volta a estar errada no próximo patch.",
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
	RITUAL_TIP_BROKENTHRONE_NOTES = "• Tainted Bone Pile (desbloqueia o challenge Tainted Corpses): /way 47.91 36.52.|n• Dark Obelisks (missão Malevolent Boons — investigue 5 de 6): 61/50 · 41/50 · 45/59 · 42/68 · 55/58 · 54/54.|n• Destruir os Dark Obelisks remove os buffs que fortalecem os inimigos do local — eliminá-los deixa os chefes bem mais fáceis (só deixe-os de pé se estiver buscando a conquista sem obeliscos).|n• Pequenos tesouros e Regeneration Orbs estão espalhados pelo local.",
	RITUAL_BOSS_DRAGONHAWK_STEPS = "• {SPELL:1291610} deixa pequenas POÇAS VERMELHAS — SOAKE-as: fique dentro de uma poça para levar só um dano pequeno. Uma poça deixada vazia explode com um dano enorme de Shadowflame — É ESSE o wipe (matou os três de vocês). Um jogador por poça basta.|n• {SPELL:1284125} é um gravity pull; as poças vermelhas surgem dentro dele, então soake-as ali.|n• Interrompa {SPELL:1284085} do add que surge no meio — um chute o remove na hora.|n• Mate os adds Unbound Caller (a Enervating Volley deles bate forte) e desvie da Radiation Wave.|n• Fique ATRÁS do falcão-dragão — o Shadowflame Breath frontal dele é mortal. (Verificado no jogo + Wowhead.)",
	RAID_BOSS_ROTMIRE_STEPS = "• Um só boss, mas fique de olho na barra de energia: cheia, ele lança {SPELL:1221637} — o wipe. Mantenha-a baixa matando os adds e esporos dos quais ele se alimenta.|n• Adds: queime rápido os Shroomlings e Funglings, e interrompa os Sporecaps ({SPELL:1221714} / {SPELL:1221717}).|n• Saia de {SPELL:1221965} e corra para fora de {SPELL:1222088} → {SPELL:1222129}.|n• Só no Mítico: espalhe-se para {SPELL:1222684} e lide com {SPELL:1222495}. (Datamined — confirmar no jogo no lançamento.)",
	RAID_BOSS_ROTMIRE_TANK = "• {SPELL:1221781} acumula — alterne com o off-tank e mantenha o boss fora da bagunça de esporos/vinhas.",
	RAID_BOSS_ROTMIRE_HEALER = "• O dano sobe com {SPELL:1221787} → {SPELL:1222176} (Bursting → Rotting Pustules, um enrage leve) — segure os picos e dissipe quando puder.",
	RAID_BOSS_ROTMIRE_DPS = "• Priorize os adds (principalmente os Sporecaps) para que a energia nunca chegue ao Fungal Bloom, depois volte ao boss.",
	RAID_BOSS_NYMRISSA_STEPS = "• |cffffd100A entrada fica DEBAIXO D’ÁGUA|r — uma caverna submersa, então sua barra de fôlego corre antes mesmo da luta. Há bolhas de ar em volta da entrada para reabastecer.|n• O primeiro Lair: um chefe numa gruta submersa, em instância, e conta para a linha de Raide da sua Great Vault.|n• Seis habilidades são conhecidas pelo nome desde o PTR 12.1, mas não o que cada uma faz — leia como um aviso, não como tática.|n• Adds — {SPELL:1257717} traz murlocs; matá-los é o chamado.|n• Um orbe do qual se afastar — {SPELL:1313393}.|n• Cuidado com onde você está — {SPELL:1258668}.|n• Dano no grupo inteiro — {SPELL:1260837}.|n• Em linha no tank — {SPELL:1282937}, ou {SPELL:1268562} no Mítico.|n• Enrage leve aos 10 minutos.|n• O lair abre em 18 de ago. O marcador da missão aparece antes no mapa — dá para achar a entrada, mas toda dificuldade recusa você com uma mensagem de requisitos até liberar.|n• Os passos de verdade chegam após a primeira run ao vivo.",
	RAID_BOSS_NYMRISSA_TANK = "• A linha vem em você: {SPELL:1282937}, e {SPELL:1268562} no Mítico. Ainda falta confirmar se precisa ser apontada para longe do grupo.",
	RAID_BOSS_NYMRISSA_HEALER = "• {SPELL:1260837} acerta o grupo inteiro — guarde seus cooldowns para isso.",
	RAID_BOSS_NYMRISSA_DPS = "• {SPELL:1257717} invoca murlocs — troque para eles e volte ao chefe. O resto é movimentação.",
	RITUAL_BOSS_MINDBREAKER_STEPS = "• Empowered Mindbreaker — Daggerspine Point fase 2 'Beast From the Deep': uma criatura das profundezas que Lady Selen'vjar sobrecarrega com magia do Vazio roubada.|n• Por enquanto: interrompa as conjurações dele e saia de efeitos de chão óbvios.|n• Os passos detalhados chegam na próxima atualização do Midnight Helper (as habilidades exatas ainda não foram datamined — preenchidos após a primeira run no jogo).",
	RITUAL_BOSS_SELENVJAR_STEPS = "• Lady Selen'vjar — feiticeira naga, boss final de Daggerspine Point (Eversong Woods, /way 34.9 65.4). Fases: 1) Ritual Roles (as capitãs guardam o ritual drenando essência do Vazio); 2) Beast From the Deep (ela fortalece um Mindbreaker); 3) Summoner's Fall (ela enfrenta você pessoalmente).|n• Os passos detalhados (interromper/desviar) chegam na próxima atualização do Midnight Helper (as habilidades dela ainda não foram datamined — preenchidos após a primeira run no jogo).",
	RITUAL_ALERT_BINDING_NEBULA = "Binding Nebula! -> destrua a nébula",
	RITUAL_ALERT_SHADOWBOLT = "Interrompa Shadowbolt Volley!",
	RITUAL_ALERT_DISSONANT = "Interrompa Dissonant Reflections!",
	RITUAL_BOSS_GERLOK_STEPS = "• Ele invoca lacaios que o deixam (quase) imune a dano — queime cada add assim que surgir; os adds avançam com um canal de fogo que quase te mata de uma vez, então saia dele.|n• {SPELL:1273031} é A conjuração para interromper — um grande estouro em área; nem toda é interrompível, guarde seu kick para ela.|n• {SPELL:1279186} é spammado — quebre a linha de visão atrás dos pilares.|n• Mantenha-o NA plataforma dele — puxá-lo para baixo/para fora dela reseta a luta. O espaço é apertado, mas não procure espaço mais abaixo.",

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
