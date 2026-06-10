--[[
	Midnight Helper — Dungeons tab strings (EN + NL pilot; the other four
	locales fall back to EN until the localization pass, like StartHere did).
	Line breaks use |n; bullets use •. See docs/DUNGEON_COACH_PLAN.md.

	never-lie: no invented numbers — the Follower daily cap is phrased as a
	launch value, the Heroic gear requirement points at the Group Finder
	tooltip until verified in-game.
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
	TAB_DUNGEONS = "Dungeons",
	DGN_TITLE = "Dungeons",
	DGN_SUBTITLE = "Your dungeon companion: what to run this week, a beginner course from first queue to Heroic, and per-boss steps in the Coach. Mythic+ support follows later.",

	DGN_VIEW_WEEK = "This week",
	DGN_VIEW_COURSE = "Dungeons 101",
	DGN_VIEW_COACH = "Dungeon Coach",

	-- This week ---------------------------------------------------------------
	DGN_WEEK_HEADER = "This week",
	DGN_SPARK_DONE = "Spark weekly (Midnight: Dungeons): done this week.",
	DGN_SPARK_INLOG = "Spark weekly (Midnight: Dungeons): picked up — complete any seasonal dungeon.",
	DGN_SPARK_TODO = "Spark weekly (Midnight: Dungeons): one of Lady Liadrin's choices — pick it up next to the vault.",
	DGN_WEEKDGN_INLOG_FMT = "Dungeon of the week (Halduron): %s — quest picked up.",
	DGN_WEEKDGN_DONE_FMT = "Dungeon of the week (Halduron): %s — done this week.",
	DGN_WEEKDGN_UNKNOWN = "Dungeon of the week (Halduron): pick up his quest next to the vault to see it here.",
	DGN_KEYSTONE_DONE = "Cracked Keystone (Mythic+ intro): done.",
	DGN_KEYSTONE_TODO = "Cracked Keystone (Mythic+ intro): drops from a Tier 11 delve reward — once per season.",
	DGN_VAULT_FMT = "Great Vault — Dungeons row: %d/%d slots unlocked (progress %d).",
	DGN_VAULT_UNKNOWN = "Great Vault — Dungeons row: data loads after login or opening the vault.",
	DGN_FOLLOWER_HINT = "New to dungeons? Start a Follower Dungeon (Group Finder): you run Normal difficulty solo with NPC teammates — no pressure, perfect practice. The course below walks you through everything.",

	-- Dungeons 101 --------------------------------------------------------------
	DGN_COURSE_HEADER = "Dungeons 101 — from zero to your first Heroic",
	DGN_COURSE_PROGRESS_FMT = "Progress: %d/%d chapters done",
	DGN_CH_MARK = "Click here when you've done this — saved per character.",
	DGN_CH_DONE = "Done — click to undo.",

	DGN_CH1_TITLE = "1. What is a dungeon?",
	DGN_CH1_BODY = "• A dungeon is an instanced adventure for 5 players: 1 tank, 1 healer, 3 damage dealers.|n• Difficulties, from easy to hard: Follower (solo with NPC teammates — practice mode), Normal (all Midnight dungeons, always available), Heroic (this season's rotation, better loot), and Mythic/Mythic+ (covered later in this course).|n• Dungeon runs fill the Dungeons row of your Great Vault — a free weekly reward.",

	DGN_CH2_TITLE = "2. Getting in",
	DGN_CH2_BODY = "• Press I (Group Finder) and pick Dungeon Finder.|n• Tick the role you want to play; tank and healer queues pop fastest.|n• Want zero pressure? Choose a Follower Dungeon first: Normal difficulty, NPC teammates that follow your pace, available while leveling 80-90 (there is a daily start cap).|n• When the queue pops, click Accept — you are teleported in, and back out when it's done.",

	DGN_CH3_TITLE = "3. Get ready",
	DGN_CH3_BODY = "• Pick your role and learn its basics — the Role Academy in this addon explains tanking, healing and DPS in plain language.|n• Set up an interrupt macro and a defensive (Toolbox → Macros — ready to copy for your spec).|n• Bring a flask, food and a potion (Toolbox → Consumables has the list for your spec, with Auction House name copy).|n• Repair your gear before you queue. For Heroic, the Group Finder shows the gear requirement next to the queue button.",

	DGN_CH4_TITLE = "4. In the group",
	DGN_CH4_BODY = "• Let the tank pull — walking ahead of the tank is the classic beginner mistake.|n• Say \"first time here\" at the start; most players are happy to point things out.|n• Kick (interrupt) dangerous casts when you can — your macro from chapter 3 does the work.|n• Loot: take what you can use; greed/disenchant the rest.|n• Wipe? It happens to everyone. Run back, eat to full, try again. A \"ty gg\" at the end goes a long way.",

	DGN_CH5_TITLE = "5. Know the bosses",
	DGN_CH5_BODY = "• Before a run, open the Dungeon Coach view and read the short steps for each boss — three lines tell you what actually matters.|n• Groupmates with Midnight Helper can share those steps into chat, each in their own language.|n• Don't memorize everything: knowing the one deadly mechanic per boss is enough to start.",

	DGN_CH6_TITLE = "6. Next step: Heroic",
	DGN_CH6_BODY = "• Heroic uses this season's rotation (eight dungeons — see the Coach view, marked Season 1) with stronger enemies and better loot.|n• The Group Finder shows the gear requirement; gear up via Normal dungeons, Delves and world content first.|n• Combine it with your weeklies: Halduron's dungeon-of-the-week and Lady Liadrin's Spark weekly both live next to the vault — the This week view tracks them.|n• After Heroic comes Mythic and Mythic+ — that chapter arrives with the Mythic update of this course.",

	-- Coach -----------------------------------------------------------------------
	DGN_COACH_HEADER = "Dungeon Coach",
	DGN_COACH_INTRO = "Every dungeon and boss this expansion. Per-boss steps (what to dodge, what to kick, what your role does) are being written and verified — they appear here per dungeon in upcoming updates.",
	DGN_GROUP_LAUNCH = "Midnight dungeons — Normal & Follower (always available)",
	DGN_GROUP_SEASON = "Season 1 rotation — Heroic & Mythic",
	DGN_BADGE_S1 = "Season 1",
	DGN_TIPS_SOON = "Boss steps for this dungeon are being written and verified — coming in an upcoming update.",
})

merge(ns._mhLocales and ns._mhLocales.nlNL, {
	TAB_DUNGEONS = "Dungeons",
	DGN_TITLE = "Dungeons",
	DGN_SUBTITLE = "Je dungeon-maatje: wat je deze week draait, een beginnerscursus van eerste queue tot Heroic, en per-boss-stappen in de Coach. Mythic+ volgt later.",

	DGN_VIEW_WEEK = "Deze week",
	DGN_VIEW_COURSE = "Dungeons 101",
	DGN_VIEW_COACH = "Dungeon Coach",

	-- Deze week -----------------------------------------------------------------
	DGN_WEEK_HEADER = "Deze week",
	DGN_SPARK_DONE = "Spark-weekly (Midnight: Dungeons): deze week gedaan.",
	DGN_SPARK_INLOG = "Spark-weekly (Midnight: Dungeons): opgepakt — voltooi een willekeurige seizoens-dungeon.",
	DGN_SPARK_TODO = "Spark-weekly (Midnight: Dungeons): één van Lady Liadrins keuzes — ophalen naast de vault.",
	DGN_WEEKDGN_INLOG_FMT = "Dungeon van de week (Halduron): %s — quest opgepakt.",
	DGN_WEEKDGN_DONE_FMT = "Dungeon van de week (Halduron): %s — deze week gedaan.",
	DGN_WEEKDGN_UNKNOWN = "Dungeon van de week (Halduron): pak zijn quest naast de vault om 'm hier te zien.",
	DGN_KEYSTONE_DONE = "Cracked Keystone (Mythic+-intro): gedaan.",
	DGN_KEYSTONE_TODO = "Cracked Keystone (Mythic+-intro): dropt uit een Tier 11-delve-beloning — eens per season.",
	DGN_VAULT_FMT = "Great Vault — Dungeons-rij: %d/%d slots ontgrendeld (voortgang %d).",
	DGN_VAULT_UNKNOWN = "Great Vault — Dungeons-rij: data laadt na login of het openen van de vault.",
	DGN_FOLLOWER_HINT = "Nieuw in dungeons? Start een Follower Dungeon (Group Finder): je draait Normal solo met NPC-teamgenoten — geen druk, perfect oefenen. De cursus hieronder neemt je overal doorheen.",

	-- Dungeons 101 -----------------------------------------------------------------
	DGN_COURSE_HEADER = "Dungeons 101 — van nul naar je eerste Heroic",
	DGN_COURSE_PROGRESS_FMT = "Voortgang: %d/%d hoofdstukken gedaan",
	DGN_CH_MARK = "Klik hier als je dit gedaan hebt — wordt per character bewaard.",
	DGN_CH_DONE = "Gedaan — klik om terug te zetten.",

	DGN_CH1_TITLE = "1. Wat is een dungeon?",
	DGN_CH1_BODY = "• Een dungeon is een instanced avontuur voor 5 spelers: 1 tank, 1 healer, 3 damage dealers.|n• Moeilijkheden, van makkelijk naar zwaar: Follower (solo met NPC-teamgenoten — oefenstand), Normal (alle Midnight-dungeons, altijd beschikbaar), Heroic (de seizoensrotatie, betere loot) en Mythic/Mythic+ (komt later in deze cursus).|n• Dungeon-runs vullen de Dungeons-rij van je Great Vault — een gratis wekelijkse beloning.",

	DGN_CH2_TITLE = "2. Zo kom je binnen",
	DGN_CH2_BODY = "• Druk op I (Group Finder) en kies Dungeon Finder.|n• Vink de rol aan die je wilt spelen; tank- en healer-queues poppen het snelst.|n• Nul druk? Kies eerst een Follower Dungeon: Normal-difficulty, NPC-teamgenoten die jouw tempo volgen, beschikbaar tijdens het levelen 80-90 (er zit een dagelijkse start-limiet op).|n• Popt de queue, klik Accept — je wordt erin geteleporteerd, en er ook weer uit als het klaar is.",

	DGN_CH3_TITLE = "3. Maak je klaar",
	DGN_CH3_BODY = "• Kies je rol en leer de basis — de Role Academy in deze addon legt tanken, healen en DPS uit in gewone taal.|n• Zet een interrupt-macro en een defensive klaar (Toolbox → Macros — kant-en-klaar voor jouw spec).|n• Neem een flask, food en een potion mee (Toolbox → Consumables heeft de lijst voor jouw spec, met veilinghuis-naamkopie).|n• Repareer je gear vóór je in de rij gaat staan. Voor Heroic toont de Group Finder de gear-eis naast de queue-knop.",

	DGN_CH4_TITLE = "4. In de groep",
	DGN_CH4_BODY = "• Laat de tank pullen — vóór de tank uit lopen is dé klassieke beginnersfout.|n• Zeg \"first time here\" aan het begin; de meeste spelers wijzen je graag de weg.|n• Kick (interrupt) gevaarlijke casts waar je kunt — je macro uit hoofdstuk 3 doet het werk.|n• Loot: need alleen wat je zelf gebruikt; greed/disenchant de rest.|n• Wipe? Overkomt iedereen. Loop terug, eet jezelf vol, probeer opnieuw. Een \"ty gg\" aan het eind doet wonderen.",

	DGN_CH5_TITLE = "5. Ken de bossen",
	DGN_CH5_BODY = "• Open vóór een run de Dungeon Coach-weergave en lees de korte stappen per boss — drie regels vertellen je wat er écht toe doet.|n• Groepsgenoten met Midnight Helper kunnen die stappen in de chat delen, ieder in z'n eigen taal.|n• Je hoeft niet alles uit je hoofd te leren: dé ene dodelijke mechanic per boss kennen is genoeg om te starten.",

	DGN_CH6_TITLE = "6. Volgende stap: Heroic",
	DGN_CH6_BODY = "• Heroic gebruikt de seizoensrotatie (acht dungeons — zie de Coach-weergave, gemarkeerd Season 1) met sterkere vijanden en betere loot.|n• De Group Finder toont de gear-eis; gear eerst op via Normal-dungeons, Delves en world content.|n• Combineer met je weeklies: Haldurons dungeon-van-de-week en Lady Liadrins Spark-weekly wonen allebei naast de vault — de Deze week-weergave trackt ze.|n• Na Heroic komen Mythic en Mythic+ — dat hoofdstuk verschijnt met de Mythic-update van deze cursus.",

	-- Coach --------------------------------------------------------------------------
	DGN_COACH_HEADER = "Dungeon Coach",
	DGN_COACH_INTRO = "Elke dungeon en boss van deze expansion. De per-boss-stappen (wat ontwijk je, wat kick je, wat doet jouw rol) worden geschreven en geverifieerd — ze verschijnen hier per dungeon in komende updates.",
	DGN_GROUP_LAUNCH = "Midnight-dungeons — Normal & Follower (altijd beschikbaar)",
	DGN_GROUP_SEASON = "Season 1-rotatie — Heroic & Mythic",
	DGN_BADGE_S1 = "Season 1",
	DGN_TIPS_SOON = "De boss-stappen voor deze dungeon worden geschreven en geverifieerd — komen in een volgende update.",
})
