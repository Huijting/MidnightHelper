--[[
	Midnight Helper — Dungeons tab strings, all six locales (deDE/frFR/esES/
	ptBR added 11 Jun; game terms stay in English per project convention).
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
	DGN_SUBTITLE = "Your dungeon companion: what to run this week, a beginner course from first queue to Heroic, and per-boss steps in the Coach, plus a Mythic+ tab with the affixes and must-kicks.",

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
	DGN_CH5_BODY = "• Before a run, open the Dungeon Coach view and read the short steps for each boss — and the moment you pull a boss, Midnight Helper prints those steps right in your chat.|n• Share them with your group: type /mh bossshare after the pull (plain text; localized sharing comes later).|n• Don't memorize everything: knowing the one deadly mechanic per boss is enough to start.",

	DGN_CH6_TITLE = "6. Next step: Heroic",
	DGN_CH6_BODY = "• Heroic uses this season's rotation (eight dungeons — see the Coach view, marked Season 1) with stronger enemies and better loot.|n• The Group Finder shows the gear requirement; gear up via Normal dungeons, Delves and world content first.|n• Combine it with your weeklies: Halduron's dungeon-of-the-week and Lady Liadrin's Spark weekly both live next to the vault — the This week view tracks them.|n• After Heroic comes Mythic and Mythic+ — that chapter arrives with the Mythic update of this course.",

	-- Coach -----------------------------------------------------------------------
	DGN_COACH_HEADER = "Dungeon Coach",
	DGN_COACH_INTRO = "Every dungeon and boss this expansion — click a dungeon name to open its boss steps (what to dodge, what to kick, what your role does). Spell names are clickable links. Written against DBM data and Wowhead tooltips; in-game verification is ongoing.",
	DGN_GROUP_LAUNCH = "Midnight dungeons — Normal & Follower (always available)",
	DGN_GROUP_SEASON = "Season 1 rotation — Heroic & Mythic",
	DGN_BADGE_S1 = "Season 1",
	DGN_TIPS_SOON = "Boss steps for this dungeon are being written and verified — coming in an upcoming update.",

	-- Live coach (boss pull + share) -------------------------------------------
	DGN_LIVE_HEADER_FMT = "%s — boss steps:",
	DGN_LIVE_SHARE_HINT = "Share with your group: /mh bossshare",
	DGN_LIVE_TOGGLE_ON = "Boss steps at pull: ON",
	DGN_LIVE_TOGGLE_OFF = "Boss steps at pull: OFF (/mh livetips turns them back on)",
	DGN_SHARE_NONE = "No boss engaged yet — pull first, then share.",
	DGN_SHARE_QUEUED = "In combat — the steps will be shared automatically the moment the fight ends.",
	DGN_WIN_CHAT = "Chat",
	DGN_WIN_SHARE = "Share",
	DGN_WIN_PANEL_HINT = "Model hidden — click the boss portrait in the window header to bring it back.",
	DGN_WIN_PICK_HINT = "Click to pick a different dungeon (or the ritual).",
	DGN_WIN_PICK_RITUALRAID = "Rituals & Raids",
	DGN_WIN_PICK_RITUALS = "Rituals",
	DGN_WIN_PICK_RAIDS = "Raids",
	DGN_WIN_PICK_DUNGEONS = "Dungeons",
	DGN_SHARE_SENT_FMT = "Steps for %s shared with the group.",
})

merge(ns._mhLocales and ns._mhLocales.nlNL, {
	TAB_DUNGEONS = "Dungeons",
	DGN_TITLE = "Dungeons",
	DGN_SUBTITLE = "Je dungeon-maatje: wat je deze week draait, een beginnerscursus van eerste queue tot Heroic, en per-boss-stappen in de Coach, plus een Mythic+-tab met de affixen en must-kicks.",

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
	DGN_CH5_BODY = "• Open vóór een run de Dungeon Coach-weergave en lees de korte stappen per boss — en zodra je een boss pullt, print Midnight Helper die stappen direct in je chat.|n• Delen met je groep: typ /mh bossshare na de pull (platte tekst; gelokaliseerd delen volgt later).|n• Je hoeft niet alles uit je hoofd te leren: dé ene dodelijke mechanic per boss kennen is genoeg om te starten.",

	DGN_CH6_TITLE = "6. Volgende stap: Heroic",
	DGN_CH6_BODY = "• Heroic gebruikt de seizoensrotatie (acht dungeons — zie de Coach-weergave, gemarkeerd Season 1) met sterkere vijanden en betere loot.|n• De Group Finder toont de gear-eis; gear eerst op via Normal-dungeons, Delves en world content.|n• Combineer met je weeklies: Haldurons dungeon-van-de-week en Lady Liadrins Spark-weekly wonen allebei naast de vault — de Deze week-weergave trackt ze.|n• Na Heroic komen Mythic en Mythic+ — dat hoofdstuk verschijnt met de Mythic-update van deze cursus.",

	-- Coach --------------------------------------------------------------------------
	DGN_COACH_HEADER = "Dungeon Coach",
	DGN_COACH_INTRO = "Elke dungeon en boss van deze expansion — klik op een dungeon-naam om de boss-stappen te openen (wat ontwijk je, wat kick je, wat doet jouw rol). Spelnamen zijn klikbare links. Geschreven op basis van DBM-data en Wowhead-tooltips; in-game verificatie loopt.",
	DGN_GROUP_LAUNCH = "Midnight-dungeons — Normal & Follower (altijd beschikbaar)",
	DGN_GROUP_SEASON = "Season 1-rotatie — Heroic & Mythic",
	DGN_BADGE_S1 = "Season 1",
	DGN_TIPS_SOON = "De boss-stappen voor deze dungeon worden geschreven en geverifieerd — komen in een volgende update.",

	-- Live coach (boss pull + share) -------------------------------------------
	DGN_LIVE_HEADER_FMT = "%s — boss-stappen:",
	DGN_LIVE_SHARE_HINT = "Delen met je groep: /mh bossshare",
	DGN_LIVE_TOGGLE_ON = "Boss-stappen bij de pull: AAN",
	DGN_LIVE_TOGGLE_OFF = "Boss-stappen bij de pull: UIT (/mh livetips zet ze weer aan)",
	DGN_SHARE_NONE = "Nog geen boss aangevallen — pull eerst, deel daarna.",
	DGN_SHARE_QUEUED = "In gevecht — de stappen worden automatisch gedeeld zodra het gevecht eindigt.",
	DGN_WIN_CHAT = "Chat",
	DGN_WIN_SHARE = "Deel",
	DGN_WIN_PANEL_HINT = "Model verborgen — klik op het boss-portret in de vensterkop om het terug te halen.",
	DGN_WIN_PICK_HINT = "Klik om een andere dungeon (of de ritual) te kiezen.",
	DGN_WIN_PICK_RITUALRAID = "Rituals & Raids",
	DGN_WIN_PICK_RITUALS = "Rituals",
	DGN_WIN_PICK_RAIDS = "Raids",
	DGN_WIN_PICK_DUNGEONS = "Dungeons",
	DGN_SHARE_SENT_FMT = "Stappen voor %s gedeeld met de groep.",
})

merge(ns._mhLocales and ns._mhLocales.deDE, {
	TAB_DUNGEONS = "Dungeons",
	DGN_TITLE = "Dungeons",
	DGN_SUBTITLE = "Dein Dungeon-Begleiter: was du diese Woche läufst, ein Einsteigerkurs von der ersten Warteschlange bis Heroic, und Boss-Schritte im Coach, plus ein Mythic+-Reiter mit den Affixen und Pflicht-Unterbrechungen.",

	DGN_VIEW_WEEK = "Diese Woche",
	DGN_VIEW_COURSE = "Dungeons 101",
	DGN_VIEW_COACH = "Dungeon-Coach",

	-- Diese Woche -------------------------------------------------------------
	DGN_WEEK_HEADER = "Diese Woche",
	DGN_SPARK_DONE = "Spark-Weekly (Midnight: Dungeons): diese Woche erledigt.",
	DGN_SPARK_INLOG = "Spark-Weekly (Midnight: Dungeons): angenommen — schließe einen beliebigen Saison-Dungeon ab.",
	DGN_SPARK_TODO = "Spark-Weekly (Midnight: Dungeons): eine von Lady Liadrins Optionen — neben dem Vault abholen.",
	DGN_WEEKDGN_INLOG_FMT = "Dungeon der Woche (Halduron): %s — Quest angenommen.",
	DGN_WEEKDGN_DONE_FMT = "Dungeon der Woche (Halduron): %s — diese Woche erledigt.",
	DGN_WEEKDGN_UNKNOWN = "Dungeon der Woche (Halduron): nimm seine Quest neben dem Vault an, um ihn hier zu sehen.",
	DGN_KEYSTONE_DONE = "Cracked Keystone (Mythic+-Einstieg): erledigt.",
	DGN_KEYSTONE_TODO = "Cracked Keystone (Mythic+-Einstieg): droppt aus einer Tier-11-Tiefen-Belohnung — einmal pro Saison.",
	DGN_VAULT_FMT = "Great Vault — Dungeon-Reihe: %d/%d Plätze freigeschaltet (Fortschritt %d).",
	DGN_VAULT_UNKNOWN = "Great Vault — Dungeon-Reihe: Daten laden nach dem Login oder beim Öffnen des Vaults.",
	DGN_FOLLOWER_HINT = "Neu in Dungeons? Starte einen Follower Dungeon (Gruppensuche): du läufst Normal solo mit NPC-Begleitern — kein Druck, perfekt zum Üben. Der Kurs unten führt dich durch alles.",

	-- Dungeons 101 --------------------------------------------------------------
	DGN_COURSE_HEADER = "Dungeons 101 — von null zu deinem ersten Heroic",
	DGN_COURSE_PROGRESS_FMT = "Fortschritt: %d/%d Kapitel erledigt",
	DGN_CH_MARK = "Klicke hier, wenn du das erledigt hast — wird pro Charakter gespeichert.",
	DGN_CH_DONE = "Erledigt — klicke zum Rückgängigmachen.",

	DGN_CH1_TITLE = "1. Was ist ein Dungeon?",
	DGN_CH1_BODY = "• Ein Dungeon ist ein instanziiertes Abenteuer für 5 Spieler: 1 Tank, 1 Heiler, 3 Schadensausteiler.|n• Schwierigkeiten, von leicht bis schwer: Follower (solo mit NPC-Begleitern — Übungsmodus), Normal (alle Midnight-Dungeons, immer verfügbar), Heroic (die Saisonrotation, bessere Beute) und Mythic/Mythic+ (kommt später in diesem Kurs).|n• Dungeon-Läufe füllen die Dungeon-Reihe deines Great Vault — eine kostenlose Wochenbelohnung.",

	DGN_CH2_TITLE = "2. So kommst du rein",
	DGN_CH2_BODY = "• Drücke I (Gruppensuche) und wähle den Dungeonbrowser.|n• Hake die Rolle an, die du spielen willst; Tank- und Heiler-Warteschlangen ploppen am schnellsten.|n• Null Druck? Wähle zuerst einen Follower Dungeon: Normal-Schwierigkeit, NPC-Begleiter in deinem Tempo, verfügbar beim Leveln 80-90 (es gibt ein tägliches Start-Limit).|n• Ploppt die Warteschlange, klicke Annehmen — du wirst hineinteleportiert und am Ende wieder hinaus.",

	DGN_CH3_TITLE = "3. Mach dich bereit",
	DGN_CH3_BODY = "• Wähle deine Rolle und lerne die Grundlagen — die Role Academy in diesem Addon erklärt Tanken, Heilen und DPS in einfacher Sprache.|n• Lege ein Interrupt-Makro und ein Defensiv bereit (Toolbox → Makros — fertig zum Kopieren für deine Spezialisierung).|n• Nimm Fläschchen, Essen und einen Trank mit (Toolbox → Verbrauchsgüter hat die Liste für deine Spezialisierung, mit Auktionshaus-Namenskopie).|n• Repariere deine Ausrüstung, bevor du dich anstellst. Für Heroic zeigt die Gruppensuche die Ausrüstungsanforderung neben dem Warteschlangen-Knopf.",

	DGN_CH4_TITLE = "4. In der Gruppe",
	DGN_CH4_BODY = "• Lass den Tank pullen — vor dem Tank herzulaufen ist DER klassische Anfängerfehler.|n• Sag am Anfang \"first time here\"; die meisten Spieler zeigen dir gern den Weg.|n• Kicke (unterbrich) gefährliche Zauber, wann immer du kannst — dein Makro aus Kapitel 3 macht die Arbeit.|n• Beute: nimm nur, was du selbst nutzt; greed/entzaubere den Rest.|n• Wipe? Passiert jedem. Lauf zurück, iss dich voll, versuch es nochmal. Ein \"ty gg\" am Ende wirkt Wunder.",

	DGN_CH5_TITLE = "5. Kenne die Bosse",
	DGN_CH5_BODY = "• Öffne vor einem Lauf die Dungeon-Coach-Ansicht und lies die kurzen Schritte pro Boss — und sobald du einen Boss pullst, schreibt Midnight Helper diese Schritte direkt in deinen Chat.|n• Teile sie mit deiner Gruppe: tippe /mh bossshare nach dem Pull (Klartext; lokalisiertes Teilen folgt später).|n• Du musst nicht alles auswendig lernen: die eine tödliche Mechanik pro Boss zu kennen reicht für den Anfang.",

	DGN_CH6_TITLE = "6. Nächster Schritt: Heroic",
	DGN_CH6_BODY = "• Heroic nutzt die Saisonrotation (acht Dungeons — siehe Coach-Ansicht, markiert mit Season 1) mit stärkeren Gegnern und besserer Beute.|n• Die Gruppensuche zeigt die Ausrüstungsanforderung; rüste dich erst über Normal-Dungeons, Tiefen und Weltinhalte aus.|n• Kombiniere es mit deinen Weeklies: Haldurons Dungeon der Woche und Lady Liadrins Spark-Weekly wohnen beide neben dem Vault — die Diese-Woche-Ansicht verfolgt sie.|n• Nach Heroic kommen Mythic und Mythic+ — dieses Kapitel erscheint mit dem Mythic-Update dieses Kurses.",

	-- Coach ---------------------------------------------------------------------
	DGN_COACH_HEADER = "Dungeon-Coach",
	DGN_COACH_INTRO = "Jeder Dungeon und Boss dieser Erweiterung — klicke auf einen Dungeon-Namen, um die Boss-Schritte zu öffnen (was ausweichen, was kicken, was deine Rolle tut). Zaubernamen sind klickbare Links. Geschrieben auf Basis von DBM-Daten und Wowhead-Tooltips; In-Game-Verifizierung läuft.",
	DGN_GROUP_LAUNCH = "Midnight-Dungeons — Normal & Follower (immer verfügbar)",
	DGN_GROUP_SEASON = "Season-1-Rotation — Heroic & Mythic",
	DGN_BADGE_S1 = "Season 1",
	DGN_TIPS_SOON = "Die Boss-Schritte für diesen Dungeon werden geschrieben und verifiziert — kommen in einem nächsten Update.",

	-- Live coach (boss pull + share) -------------------------------------------
	DGN_LIVE_HEADER_FMT = "%s — Boss-Schritte:",
	DGN_LIVE_SHARE_HINT = "Mit deiner Gruppe teilen: /mh bossshare",
	DGN_LIVE_TOGGLE_ON = "Boss-Schritte beim Pull: AN",
	DGN_LIVE_TOGGLE_OFF = "Boss-Schritte beim Pull: AUS (/mh livetips schaltet sie wieder an)",
	DGN_SHARE_NONE = "Noch kein Boss angegriffen — erst pullen, dann teilen.",
	DGN_SHARE_QUEUED = "Im Kampf — die Schritte werden automatisch geteilt, sobald der Kampf endet.",
	DGN_WIN_CHAT = "Chat",
	DGN_WIN_SHARE = "Teilen",
	DGN_WIN_PANEL_HINT = "Modell ausgeblendet — klicke auf das Boss-Porträt in der Fensterkopfzeile, um es zurückzuholen.",
	DGN_WIN_PICK_HINT = "Klicke, um einen anderen Dungeon (oder das Ritual) zu wählen.",
	DGN_WIN_PICK_RITUALRAID = "Rituale & Raids",
	DGN_WIN_PICK_RITUALS = "Rituale",
	DGN_WIN_PICK_RAIDS = "Raids",
	DGN_WIN_PICK_DUNGEONS = "Dungeons",
	DGN_SHARE_SENT_FMT = "Schritte für %s mit der Gruppe geteilt.",
})

merge(ns._mhLocales and ns._mhLocales.frFR, {
	TAB_DUNGEONS = "Donjons",
	DGN_TITLE = "Donjons",
	DGN_SUBTITLE = "Ton compagnon de donjon : quoi faire cette semaine, un cours débutant de la première file jusqu'au Heroic, et les étapes par boss dans le Coach, plus un onglet Mythic+ avec les affixes et les interruptions clés.",

	DGN_VIEW_WEEK = "Cette semaine",
	DGN_VIEW_COURSE = "Dungeons 101",
	DGN_VIEW_COACH = "Dungeon Coach",

	-- Cette semaine -------------------------------------------------------------
	DGN_WEEK_HEADER = "Cette semaine",
	DGN_SPARK_DONE = "Hebdo Spark (Midnight: Dungeons) : faite cette semaine.",
	DGN_SPARK_INLOG = "Hebdo Spark (Midnight: Dungeons) : prise — termine n'importe quel donjon de la saison.",
	DGN_SPARK_TODO = "Hebdo Spark (Midnight: Dungeons) : un des choix de Lady Liadrin — à récupérer à côté du Vault.",
	DGN_WEEKDGN_INLOG_FMT = "Donjon de la semaine (Halduron) : %s — quête prise.",
	DGN_WEEKDGN_DONE_FMT = "Donjon de la semaine (Halduron) : %s — fait cette semaine.",
	DGN_WEEKDGN_UNKNOWN = "Donjon de la semaine (Halduron) : prends sa quête à côté du Vault pour le voir ici.",
	DGN_KEYSTONE_DONE = "Cracked Keystone (intro Mythic+) : fait.",
	DGN_KEYSTONE_TODO = "Cracked Keystone (intro Mythic+) : tombe d'une récompense de gouffre Tier 11 — une fois par saison.",
	DGN_VAULT_FMT = "Great Vault — rangée Donjons : %d/%d emplacements débloqués (progression %d).",
	DGN_VAULT_UNKNOWN = "Great Vault — rangée Donjons : les données se chargent après la connexion ou à l'ouverture du Vault.",
	DGN_FOLLOWER_HINT = "Nouveau en donjon ? Lance un Follower Dungeon (Recherche de groupe) : tu joues en Normal, en solo avec des PNJ — zéro pression, parfait pour s'entraîner. Le cours ci-dessous t'accompagne pas à pas.",

	-- Dungeons 101 ----------------------------------------------------------------
	DGN_COURSE_HEADER = "Dungeons 101 — de zéro à ton premier Heroic",
	DGN_COURSE_PROGRESS_FMT = "Progression : %d/%d chapitres faits",
	DGN_CH_MARK = "Clique ici quand c'est fait — sauvegardé par personnage.",
	DGN_CH_DONE = "Fait — clique pour annuler.",

	DGN_CH1_TITLE = "1. C'est quoi, un donjon ?",
	DGN_CH1_BODY = "• Un donjon est une aventure instanciée pour 5 joueurs : 1 tank, 1 soigneur, 3 DPS.|n• Difficultés, du plus simple au plus dur : Follower (solo avec des PNJ — mode entraînement), Normal (tous les donjons Midnight, toujours disponibles), Heroic (la rotation de la saison, meilleur butin) et Mythic/Mythic+ (abordés plus tard dans ce cours).|n• Les donjons remplissent la rangée Donjons de ton Great Vault — une récompense hebdomadaire gratuite.",

	DGN_CH2_TITLE = "2. Comment entrer",
	DGN_CH2_BODY = "• Appuie sur I (Recherche de groupe) et choisis l'outil Donjons.|n• Coche le rôle que tu veux jouer ; les files tank et soigneur partent le plus vite.|n• Zéro pression ? Choisis d'abord un Follower Dungeon : difficulté Normal, des PNJ qui suivent ton rythme, disponible pendant le leveling 80-90 (avec une limite de lancements par jour).|n• Quand la file sonne, clique Accepter — tu es téléporté dedans, puis dehors à la fin.",

	DGN_CH3_TITLE = "3. Prépare-toi",
	DGN_CH3_BODY = "• Choisis ton rôle et apprends les bases — la Role Academy de cet addon explique tank, heal et DPS en langage simple.|n• Prépare une macro d'interruption et un défensif (Toolbox → Macros — prêts à copier pour ta spé).|n• Prends un flacon, de la nourriture et une potion (Toolbox → Consommables a la liste pour ta spé, avec copie du nom pour l'hôtel des ventes).|n• Répare ton équipement avant de t'inscrire. Pour Heroic, la Recherche de groupe affiche le prérequis d'équipement à côté du bouton de file.",

	DGN_CH4_TITLE = "4. En groupe",
	DGN_CH4_BODY = "• Laisse le tank engager — courir devant le tank est LA classique erreur de débutant.|n• Dis \"first time here\" au début ; la plupart des joueurs t'expliqueront volontiers.|n• Interromps (kick) les incantations dangereuses quand tu peux — ta macro du chapitre 3 fait le travail.|n• Butin : ne prends que ce que tu utilises ; greed/désenchante le reste.|n• Un wipe ? Ça arrive à tout le monde. Reviens en courant, mange, réessaie. Un \"ty gg\" à la fin fait des merveilles.",

	DGN_CH5_TITLE = "5. Connais les boss",
	DGN_CH5_BODY = "• Avant un run, ouvre la vue Dungeon Coach et lis les étapes courtes de chaque boss — et dès que tu pull un boss, Midnight Helper affiche ces étapes directement dans ton chat.|n• Partage-les avec ton groupe : tape /mh bossshare après le pull (texte brut ; le partage localisé arrive plus tard).|n• Pas besoin de tout mémoriser : connaître LA mécanique mortelle de chaque boss suffit pour commencer.",

	DGN_CH6_TITLE = "6. Étape suivante : Heroic",
	DGN_CH6_BODY = "• Heroic utilise la rotation de la saison (huit donjons — voir la vue Coach, marqués Season 1) avec des ennemis plus forts et un meilleur butin.|n• La Recherche de groupe affiche le prérequis d'équipement ; équipe-toi d'abord via les donjons Normal, les gouffres et le contenu mondial.|n• Combine avec tes hebdos : le donjon de la semaine d'Halduron et l'hebdo Spark de Lady Liadrin vivent tous deux à côté du Vault — la vue Cette semaine les suit.|n• Après Heroic viennent Mythic et Mythic+ — ce chapitre arrivera avec la mise à jour Mythic de ce cours.",

	-- Coach -----------------------------------------------------------------------
	DGN_COACH_HEADER = "Dungeon Coach",
	DGN_COACH_INTRO = "Chaque donjon et boss de cette extension — clique sur le nom d'un donjon pour ouvrir les étapes des boss (quoi esquiver, quoi interrompre, ce que fait ton rôle). Les noms de sorts sont des liens cliquables. Écrit à partir des données DBM et des tooltips Wowhead ; la vérification en jeu est en cours.",
	DGN_GROUP_LAUNCH = "Donjons Midnight — Normal & Follower (toujours disponibles)",
	DGN_GROUP_SEASON = "Rotation Season 1 — Heroic & Mythic",
	DGN_BADGE_S1 = "Season 1",
	DGN_TIPS_SOON = "Les étapes des boss de ce donjon sont en cours d'écriture et de vérification — elles arrivent dans une prochaine mise à jour.",

	-- Live coach (boss pull + share) -------------------------------------------
	DGN_LIVE_HEADER_FMT = "%s — étapes du boss :",
	DGN_LIVE_SHARE_HINT = "Partager avec votre groupe : /mh bossshare",
	DGN_LIVE_TOGGLE_ON = "Étapes du boss au pull : ACTIVÉ",
	DGN_LIVE_TOGGLE_OFF = "Étapes du boss au pull : DÉSACTIVÉ (/mh livetips pour réactiver)",
	DGN_SHARE_NONE = "Aucun boss engagé pour l'instant — pull d'abord, partage ensuite.",
	DGN_SHARE_QUEUED = "En combat — les étapes seront partagées automatiquement dès la fin du combat.",
	DGN_WIN_CHAT = "Chat",
	DGN_WIN_SHARE = "Partager",
	DGN_WIN_PANEL_HINT = "Modèle masqué — clique sur le portrait du boss dans l'en-tête de la fenêtre pour le réafficher.",
	DGN_WIN_PICK_HINT = "Clique pour choisir un autre donjon (ou le rituel).",
	DGN_WIN_PICK_RITUALRAID = "Rituels et raids",
	DGN_WIN_PICK_RITUALS = "Rituels",
	DGN_WIN_PICK_RAIDS = "Raids",
	DGN_WIN_PICK_DUNGEONS = "Donjons",
	DGN_SHARE_SENT_FMT = "Étapes de %s partagées avec le groupe.",
})

merge(ns._mhLocales and ns._mhLocales.esES, {
	TAB_DUNGEONS = "Mazmorras",
	DGN_TITLE = "Mazmorras",
	DGN_SUBTITLE = "Tu compañero de mazmorras: qué hacer esta semana, un curso para principiantes desde la primera cola hasta Heroic, y pasos por jefe en el Coach, además de una pestaña de Mythic+ con los afijos y las interrupciones clave.",

	DGN_VIEW_WEEK = "Esta semana",
	DGN_VIEW_COURSE = "Dungeons 101",
	DGN_VIEW_COACH = "Dungeon Coach",

	-- Esta semana ---------------------------------------------------------------
	DGN_WEEK_HEADER = "Esta semana",
	DGN_SPARK_DONE = "Semanal de Spark (Midnight: Dungeons): hecha esta semana.",
	DGN_SPARK_INLOG = "Semanal de Spark (Midnight: Dungeons): aceptada — completa cualquier mazmorra de la temporada.",
	DGN_SPARK_TODO = "Semanal de Spark (Midnight: Dungeons): una de las opciones de Lady Liadrin — recógela junto al Vault.",
	DGN_WEEKDGN_INLOG_FMT = "Mazmorra de la semana (Halduron): %s — misión aceptada.",
	DGN_WEEKDGN_DONE_FMT = "Mazmorra de la semana (Halduron): %s — hecha esta semana.",
	DGN_WEEKDGN_UNKNOWN = "Mazmorra de la semana (Halduron): acepta su misión junto al Vault para verla aquí.",
	DGN_KEYSTONE_DONE = "Cracked Keystone (introducción a Mythic+): hecho.",
	DGN_KEYSTONE_TODO = "Cracked Keystone (introducción a Mythic+): cae de una recompensa de profundidad Tier 11 — una vez por temporada.",
	DGN_VAULT_FMT = "Great Vault — fila de Mazmorras: %d/%d casillas desbloqueadas (progreso %d).",
	DGN_VAULT_UNKNOWN = "Great Vault — fila de Mazmorras: los datos cargan tras iniciar sesión o abrir el Vault.",
	DGN_FOLLOWER_HINT = "¿Nuevo en mazmorras? Inicia una Follower Dungeon (Buscador de grupos): juegas en Normal en solitario con PNJ de equipo — sin presión, perfecto para practicar. El curso de abajo te guía por todo.",

	-- Dungeons 101 ----------------------------------------------------------------
	DGN_COURSE_HEADER = "Dungeons 101 — de cero a tu primer Heroic",
	DGN_COURSE_PROGRESS_FMT = "Progreso: %d/%d capítulos hechos",
	DGN_CH_MARK = "Haz clic aquí cuando lo hayas hecho — se guarda por personaje.",
	DGN_CH_DONE = "Hecho — haz clic para deshacer.",

	DGN_CH1_TITLE = "1. ¿Qué es una mazmorra?",
	DGN_CH1_BODY = "• Una mazmorra es una aventura instanciada para 5 jugadores: 1 tanque, 1 sanador, 3 DPS.|n• Dificultades, de fácil a difícil: Follower (en solitario con PNJ — modo práctica), Normal (todas las mazmorras de Midnight, siempre disponibles), Heroic (la rotación de la temporada, mejor botín) y Mythic/Mythic+ (se tratan más adelante en este curso).|n• Las mazmorras llenan la fila de Mazmorras de tu Great Vault — una recompensa semanal gratuita.",

	DGN_CH2_TITLE = "2. Cómo entrar",
	DGN_CH2_BODY = "• Pulsa I (Buscador de grupos) y elige el Buscador de mazmorras.|n• Marca el rol que quieres jugar; las colas de tanque y sanador salen más rápido.|n• ¿Cero presión? Elige primero una Follower Dungeon: dificultad Normal, PNJ que siguen tu ritmo, disponible mientras subes de 80 a 90 (hay un límite diario de inicios).|n• Cuando salte la cola, haz clic en Aceptar — te teletransporta dentro, y fuera al terminar.",

	DGN_CH3_TITLE = "3. Prepárate",
	DGN_CH3_BODY = "• Elige tu rol y aprende lo básico — la Role Academy de este addon explica tanquear, sanar y DPS en lenguaje sencillo.|n• Prepara una macro de interrupción y un defensivo (Toolbox → Macros — listos para copiar para tu especialización).|n• Lleva frasco, comida y una poción (Toolbox → Consumibles tiene la lista para tu especialización, con copia del nombre para la casa de subastas).|n• Repara tu equipo antes de apuntarte. Para Heroic, el Buscador de grupos muestra el requisito de equipo junto al botón de cola.",

	DGN_CH4_TITLE = "4. En el grupo",
	DGN_CH4_BODY = "• Deja que el tanque tire — adelantarse al tanque es EL clásico error de principiante.|n• Di \"first time here\" al empezar; la mayoría te indicará encantada.|n• Interrumpe (kick) los lanzamientos peligrosos cuando puedas — tu macro del capítulo 3 hace el trabajo.|n• Botín: coge solo lo que vayas a usar; greed/desencanta el resto.|n• ¿Wipe? Le pasa a todos. Vuelve corriendo, come hasta llenarte, inténtalo de nuevo. Un \"ty gg\" al final obra milagros.",

	DGN_CH5_TITLE = "5. Conoce a los jefes",
	DGN_CH5_BODY = "• Antes de una run, abre la vista Dungeon Coach y lee los pasos cortos de cada jefe — y al hacer pull, Midnight Helper imprime esos pasos directamente en tu chat.|n• Compártelos con tu grupo: escribe /mh bossshare tras el pull (texto plano; el compartir localizado llegará más adelante).|n• No memorices todo: conocer LA mecánica mortal de cada jefe basta para empezar.",

	DGN_CH6_TITLE = "6. Siguiente paso: Heroic",
	DGN_CH6_BODY = "• Heroic usa la rotación de la temporada (ocho mazmorras — ver la vista Coach, marcadas Season 1) con enemigos más fuertes y mejor botín.|n• El Buscador de grupos muestra el requisito de equipo; equípate primero con mazmorras Normal, Profundidades y contenido de mundo.|n• Combínalo con tus semanales: la mazmorra de la semana de Halduron y la semanal de Spark de Lady Liadrin viven junto al Vault — la vista Esta semana las sigue.|n• Tras Heroic vienen Mythic y Mythic+ — ese capítulo llegará con la actualización Mythic de este curso.",

	-- Coach -----------------------------------------------------------------------
	DGN_COACH_HEADER = "Dungeon Coach",
	DGN_COACH_INTRO = "Cada mazmorra y jefe de esta expansión — haz clic en el nombre de una mazmorra para abrir los pasos de sus jefes (qué esquivar, qué interrumpir, qué hace tu rol). Los nombres de hechizos son enlaces clicables. Escrito a partir de datos de DBM y tooltips de Wowhead; la verificación en juego está en curso.",
	DGN_GROUP_LAUNCH = "Mazmorras de Midnight — Normal & Follower (siempre disponibles)",
	DGN_GROUP_SEASON = "Rotación Season 1 — Heroic & Mythic",
	DGN_BADGE_S1 = "Season 1",
	DGN_TIPS_SOON = "Los pasos de los jefes de esta mazmorra se están escribiendo y verificando — llegarán en una próxima actualización.",

	-- Live coach (boss pull + share) -------------------------------------------
	DGN_LIVE_HEADER_FMT = "%s — pasos del jefe:",
	DGN_LIVE_SHARE_HINT = "Compartir con tu grupo: /mh bossshare",
	DGN_LIVE_TOGGLE_ON = "Pasos del jefe al pull: ACTIVADO",
	DGN_LIVE_TOGGLE_OFF = "Pasos del jefe al pull: DESACTIVADO (/mh livetips los reactiva)",
	DGN_SHARE_NONE = "Aún no has atacado a ningún jefe — primero el pull, luego comparte.",
	DGN_SHARE_QUEUED = "En combate — los pasos se compartirán automáticamente en cuanto termine el combate.",
	DGN_WIN_CHAT = "Chat",
	DGN_WIN_SHARE = "Compartir",
	DGN_WIN_PANEL_HINT = "Modelo oculto — haz clic en el retrato del jefe en la cabecera de la ventana para recuperarlo.",
	DGN_WIN_PICK_HINT = "Haz clic para elegir otra mazmorra (o el ritual).",
	DGN_WIN_PICK_RITUALRAID = "Rituales y raids",
	DGN_WIN_PICK_RITUALS = "Rituales",
	DGN_WIN_PICK_RAIDS = "Raids",
	DGN_WIN_PICK_DUNGEONS = "Mazmorras",
	DGN_SHARE_SENT_FMT = "Pasos de %s compartidos con el grupo.",
})

merge(ns._mhLocales and ns._mhLocales.ptBR, {
	TAB_DUNGEONS = "Masmorras",
	DGN_TITLE = "Masmorras",
	DGN_SUBTITLE = "Seu companheiro de masmorras: o que rodar esta semana, um curso para iniciantes da primeira fila até o Heroic, e passos por chefe no Coach, além de uma aba de Mythic+ com os afixos e as interrupções essenciais.",

	DGN_VIEW_WEEK = "Esta semana",
	DGN_VIEW_COURSE = "Dungeons 101",
	DGN_VIEW_COACH = "Dungeon Coach",

	-- Esta semana ---------------------------------------------------------------
	DGN_WEEK_HEADER = "Esta semana",
	DGN_SPARK_DONE = "Semanal do Spark (Midnight: Dungeons): feita esta semana.",
	DGN_SPARK_INLOG = "Semanal do Spark (Midnight: Dungeons): aceita — complete qualquer masmorra da temporada.",
	DGN_SPARK_TODO = "Semanal do Spark (Midnight: Dungeons): uma das opções de Lady Liadrin — pegue ao lado do Vault.",
	DGN_WEEKDGN_INLOG_FMT = "Masmorra da semana (Halduron): %s — missão aceita.",
	DGN_WEEKDGN_DONE_FMT = "Masmorra da semana (Halduron): %s — feita esta semana.",
	DGN_WEEKDGN_UNKNOWN = "Masmorra da semana (Halduron): aceite a missão dele ao lado do Vault para vê-la aqui.",
	DGN_KEYSTONE_DONE = "Cracked Keystone (introdução ao Mythic+): feito.",
	DGN_KEYSTONE_TODO = "Cracked Keystone (introdução ao Mythic+): cai de uma recompensa de profundidade Tier 11 — uma vez por temporada.",
	DGN_VAULT_FMT = "Great Vault — fileira de Masmorras: %d/%d espaços desbloqueados (progresso %d).",
	DGN_VAULT_UNKNOWN = "Great Vault — fileira de Masmorras: os dados carregam após o login ou ao abrir o Vault.",
	DGN_FOLLOWER_HINT = "Novo em masmorras? Inicie uma Follower Dungeon (Localizador de grupos): você joga no Normal sozinho com NPCs na equipe — sem pressão, perfeito para praticar. O curso abaixo te guia por tudo.",

	-- Dungeons 101 ----------------------------------------------------------------
	DGN_COURSE_HEADER = "Dungeons 101 — do zero ao seu primeiro Heroic",
	DGN_COURSE_PROGRESS_FMT = "Progresso: %d/%d capítulos feitos",
	DGN_CH_MARK = "Clique aqui quando tiver feito — salvo por personagem.",
	DGN_CH_DONE = "Feito — clique para desfazer.",

	DGN_CH1_TITLE = "1. O que é uma masmorra?",
	DGN_CH1_BODY = "• Uma masmorra é uma aventura instanciada para 5 jogadores: 1 tanque, 1 curandeiro, 3 DPS.|n• Dificuldades, da mais fácil à mais difícil: Follower (solo com NPCs — modo treino), Normal (todas as masmorras de Midnight, sempre disponíveis), Heroic (a rotação da temporada, melhor saque) e Mythic/Mythic+ (tratados mais adiante neste curso).|n• Masmorras enchem a fileira de Masmorras do seu Great Vault — uma recompensa semanal grátis.",

	DGN_CH2_TITLE = "2. Como entrar",
	DGN_CH2_BODY = "• Pressione I (Localizador de grupos) e escolha o Localizador de masmorras.|n• Marque a função que você quer jogar; filas de tanque e curandeiro saem mais rápido.|n• Zero pressão? Escolha primeiro uma Follower Dungeon: dificuldade Normal, NPCs que seguem o seu ritmo, disponível ao upar do 80 ao 90 (há um limite diário de inícios).|n• Quando a fila estourar, clique em Aceitar — você é teleportado para dentro, e para fora quando acabar.",

	DGN_CH3_TITLE = "3. Prepare-se",
	DGN_CH3_BODY = "• Escolha sua função e aprenda o básico — a Role Academy deste addon explica tanque, cura e DPS em linguagem simples.|n• Deixe prontos uma macro de interrupção e um defensivo (Toolbox → Macros — prontos para copiar para a sua spec).|n• Leve frasco, comida e uma poção (Toolbox → Consumíveis tem a lista para a sua spec, com cópia do nome para a casa de leilões).|n• Conserte seu equipamento antes de entrar na fila. Para Heroic, o Localizador de grupos mostra o requisito de equipamento ao lado do botão da fila.",

	DGN_CH4_TITLE = "4. No grupo",
	DGN_CH4_BODY = "• Deixe o tanque puxar — andar na frente do tanque é O clássico erro de iniciante.|n• Diga \"first time here\" no começo; a maioria dos jogadores adora ajudar.|n• Interrompa (kick) conjurações perigosas quando puder — sua macro do capítulo 3 faz o trabalho.|n• Saque: pegue só o que você usa; greed/desencante o resto.|n• Wipe? Acontece com todo mundo. Volte correndo, coma até encher, tente de novo. Um \"ty gg\" no final faz maravilhas.",

	DGN_CH5_TITLE = "5. Conheça os chefes",
	DGN_CH5_BODY = "• Antes de uma run, abra a visão Dungeon Coach e leia os passos curtos de cada chefe — e ao puxar um chefe, o Midnight Helper imprime esses passos direto no seu chat.|n• Compartilhe com o grupo: digite /mh bossshare depois do pull (texto simples; compartilhamento localizado vem depois).|n• Não decore tudo: conhecer A mecânica mortal de cada chefe já basta para começar.",

	DGN_CH6_TITLE = "6. Próximo passo: Heroic",
	DGN_CH6_BODY = "• Heroic usa a rotação da temporada (oito masmorras — veja a visão Coach, marcadas Season 1) com inimigos mais fortes e melhor saque.|n• O Localizador de grupos mostra o requisito de equipamento; equipe-se primeiro com masmorras Normal, Profundidades e conteúdo de mundo.|n• Combine com suas semanais: a masmorra da semana do Halduron e a semanal do Spark de Lady Liadrin moram ao lado do Vault — a visão Esta semana acompanha as duas.|n• Depois do Heroic vêm Mythic e Mythic+ — esse capítulo chega com a atualização Mythic deste curso.",

	-- Coach -----------------------------------------------------------------------
	DGN_COACH_HEADER = "Dungeon Coach",
	DGN_COACH_INTRO = "Cada masmorra e chefe desta expansão — clique no nome de uma masmorra para abrir os passos dos chefes (do que desviar, o que interromper, o que a sua função faz). Nomes de feitiços são links clicáveis. Escrito com base em dados do DBM e tooltips do Wowhead; a verificação no jogo está em andamento.",
	DGN_GROUP_LAUNCH = "Masmorras de Midnight — Normal & Follower (sempre disponíveis)",
	DGN_GROUP_SEASON = "Rotação Season 1 — Heroic & Mythic",
	DGN_BADGE_S1 = "Season 1",
	DGN_TIPS_SOON = "Os passos dos chefes desta masmorra estão sendo escritos e verificados — chegam em uma próxima atualização.",

	-- Live coach (boss pull + share) -------------------------------------------
	DGN_LIVE_HEADER_FMT = "%s — passos do chefe:",
	DGN_LIVE_SHARE_HINT = "Compartilhar com o grupo: /mh bossshare",
	DGN_LIVE_TOGGLE_ON = "Passos do chefe no pull: LIGADO",
	DGN_LIVE_TOGGLE_OFF = "Passos do chefe no pull: DESLIGADO (/mh livetips liga de novo)",
	DGN_SHARE_NONE = "Nenhum chefe enfrentado ainda — primeiro o pull, depois compartilhe.",
	DGN_SHARE_QUEUED = "Em combate — os passos serão compartilhados automaticamente assim que o combate terminar.",
	DGN_WIN_CHAT = "Chat",
	DGN_WIN_SHARE = "Enviar",
	DGN_WIN_PANEL_HINT = "Modelo oculto — clique no retrato do chefe no topo da janela para trazê-lo de volta.",
	DGN_WIN_PICK_HINT = "Clique para escolher outra masmorra (ou o ritual).",
	DGN_WIN_PICK_RITUALRAID = "Rituais e raids",
	DGN_WIN_PICK_RITUALS = "Rituais",
	DGN_WIN_PICK_RAIDS = "Raids",
	DGN_WIN_PICK_DUNGEONS = "Masmorras",
	DGN_SHARE_SENT_FMT = "Passos de %s compartilhados com o grupo.",
})
