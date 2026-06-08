--[[
	Midnight Helper — Ritual Coach tip bodies (EN + NL).
	Sources: Blizzard 12.0.5 news post (14 Apr 2026) + Wowhead/Method/Skycoach/
	Overgear/wow.gg ritual-sites guides. Line breaks use |n; bullets use •.

	never-lie: no Spoils % numbers in this text (sources conflict — verify at the
	obelisk tooltip). Boss names / per-scenario routes stay generic until an
	in-game run confirms them. See docs/RITUAL_COACH_PLAN.md.

	Locale audit: section titles (11) + names (11) + bodies (26) per language.
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

	-- Intro / how it works ---------------------------------------------------
	RITUAL_TIP_INTRO_TIERS = "• Pick Tier 1-5 at the Curious Obelisk; clear each tier to unlock the next.|n• Tier 3 needs 1 challenge active, Tier 4 needs 2, Tier 5 needs 4.|n• Higher tiers give more Spoils and renown (each tier also has a minimum item level — values to confirm in-game).",
	RITUAL_TIP_INTRO_SCORING = "• Spoils are your score; the Ritual Chest at the end scales with them.|n• Deaths: the first 2 are free, then every death cuts Spoils by 5%, up to a maximum of -50%.|n• Clean clears beat fast pulls — dying costs rewards directly.",
	RITUAL_TIP_INTRO_WEEKLY = "• Each week the tier needed to UNLOCK a challenge drops by one, so everyone unlocks them over time.|n• You cannot unlock all 8 challenges in a single week.|n• Counts for the World row of the Great Vault.|n• Renown boosters: Ritual Tablet (first site of the week), Ritual Tablet Fragment (second site), and Ritual Site Reports (scaled by your Spoils).",
	RITUAL_TIP_INTRO_ORBS = "• In combat, Regeneration Orbs manifest and heal 15% of your health (Renown 1).|n• Orb Potency (Renown 4) increases that healing.|n• Lean on the orbs instead of burning cooldowns on self-healing.",

	-- Daggerspine Point (Eversong Woods) -------------------------------------
	RITUAL_TIP_DAGGERSPINE_OVERVIEW = "• Eversong Woods — Daggerspine Point, on the west coast near Goldenmist Village.|n• Enemies: naga.|n• Active one week at a time; the obelisk shows a purple icon on the map.|n• Enter at the Curious Obelisk and pick your tier + challenges there.",
	RITUAL_TIP_DAGGERSPINE_PHASES = "• A short instanced scenario: clear objectives and enemy waves, then a final boss, then loot the Ritual Chest.|n• Scenario seen at the obelisk: \"A Strike From the Sea\" — the naga leader Selen'vjar (final-boss kill still to confirm).|n• A site may run more than one scenario layout — to confirm in-game.",
	RITUAL_TIP_DAGGERSPINE_NOTES = "• Tainted Bone Pile (unlocks the Tainted Corpses challenge): /way 66.09 62.58.|n• Dark Obelisks (Malevolent Boons quest — investigate 5): 66.57/38.78, 64.71/49.79, 63.82/70.92, 39.16/76.15, 35.28/63.18.|n• Small treasures and Regeneration Orbs are scattered around the site.",

	-- Broken Throne (Zul'Aman) -----------------------------------------------
	RITUAL_TIP_BROKENTHRONE_OVERVIEW = "• Zul'Aman — Broken Throne, in the south of the zone.|n• Enemies: Twilight's Blade cultists.|n• Active one week at a time; the obelisk shows a purple icon on the map.|n• Enter at the Curious Obelisk and pick your tier + challenges there.",
	RITUAL_TIP_BROKENTHRONE_PHASES = "• A short instanced scenario: clear objectives and enemy waves, then a final boss, then loot the Ritual Chest.|n• A site may run one or two scenario layouts (objectives differ) — to confirm in-game.|n• Final boss name: to confirm in-game.",
	RITUAL_TIP_BROKENTHRONE_NOTES = "• Tainted Bone Pile (unlocks the Tainted Corpses challenge): /way 47.91 36.52.|n• Dark Obelisk locations (Malevolent Boons quest): to confirm in-game.|n• Small treasures and Regeneration Orbs are scattered around the site.",

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

	-- Intro / hoe het werkt --------------------------------------------------
	RITUAL_TIP_INTRO_TIERS = "• Kies Tier 1-5 bij de Curious Obelisk; elke tier moet gecleard zijn om de volgende te ontgrendelen.|n• Tier 3 vereist 1 actieve challenge, Tier 4 vereist er 2, Tier 5 vereist er 4.|n• Hogere tiers geven meer Spoils en renown (elke tier heeft ook een minimum item level — waarden nog in-game bevestigen).",
	RITUAL_TIP_INTRO_SCORING = "• Spoils zijn je score; de Ritual Chest aan het eind schaalt ermee.|n• Doden: de eerste 2 zijn gratis, daarna kost elke dood 5% Spoils, tot maximaal -50%.|n• Schone clears verslaan snelle pulls — doodgaan kost direct beloning.",
	RITUAL_TIP_INTRO_WEEKLY = "• Elke week zakt de tier die nodig is om een challenge te ONTGRENDELEN met één, zodat iedereen ze na verloop van tijd vrijspeelt.|n• Je kunt niet alle 8 challenges in één week ontgrendelen.|n• Telt mee voor de World-rij van de Great Vault.|n• Renown-boosters: Ritual Tablet (eerste site van de week), Ritual Tablet Fragment (tweede site), en Ritual Site Reports (schaalt met je Spoils).",
	RITUAL_TIP_INTRO_ORBS = "• In combat verschijnen Regeneration Orbs die 15% van je health healen (Renown 1).|n• Orb Potency (Renown 4) verhoogt die healing.|n• Leun op de orbs in plaats van cooldowns te verbranden aan zelf-healing.",

	-- Daggerspine Point (Eversong Woods) -------------------------------------
	RITUAL_TIP_DAGGERSPINE_OVERVIEW = "• Eversong Woods — Daggerspine Point, aan de westkust bij Goldenmist Village.|n• Vijanden: naga.|n• Eén week per keer actief; de obelisk heeft een paars icoon op de map.|n• Ga naar de Curious Obelisk en kies daar je tier + challenges.",
	RITUAL_TIP_DAGGERSPINE_PHASES = "• Een korte instanced scenario: clear objectives en vijandgolven, dan een eindboss, dan loot je de Ritual Chest.|n• Scenario gezien bij de obelisk: \"A Strike From the Sea\" — de naga-leider Selen'vjar (eindboss-kill nog te bevestigen).|n• Een site kan meer dan één scenario-layout draaien — nog in-game bevestigen.",
	RITUAL_TIP_DAGGERSPINE_NOTES = "• Tainted Bone Pile (ontgrendelt de Tainted Corpses-challenge): /way 66.09 62.58.|n• Dark Obelisks (Malevolent Boons-quest — investigeer er 5): 66.57/38.78, 64.71/49.79, 63.82/70.92, 39.16/76.15, 35.28/63.18.|n• Kleine treasures en Regeneration Orbs liggen verspreid door de site.",

	-- Broken Throne (Zul'Aman) -----------------------------------------------
	RITUAL_TIP_BROKENTHRONE_OVERVIEW = "• Zul'Aman — Broken Throne, in het zuiden van de zone.|n• Vijanden: Twilight's Blade-cultisten.|n• Eén week per keer actief; de obelisk heeft een paars icoon op de map.|n• Ga naar de Curious Obelisk en kies daar je tier + challenges.",
	RITUAL_TIP_BROKENTHRONE_PHASES = "• Een korte instanced scenario: clear objectives en vijandgolven, dan een eindboss, dan loot je de Ritual Chest.|n• Een site kan één of twee scenario-layouts draaien (andere objectives) — nog in-game bevestigen.|n• Naam van de eindboss: nog in-game bevestigen.",
	RITUAL_TIP_BROKENTHRONE_NOTES = "• Tainted Bone Pile (ontgrendelt de Tainted Corpses-challenge): /way 47.91 36.52.|n• Dark Obelisk-locaties (Malevolent Boons-quest): nog in-game bevestigen.|n• Kleine treasures en Regeneration Orbs liggen verspreid door de site.",

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
