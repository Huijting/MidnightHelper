--[[
	Midnight Helper — "Start Here" new-player roadmap (all 6 locales).
	A guided first-week path that ties the existing systems together. Steps link
	to the relevant tab via ns.SelectTab; the weekly steps auto-tick from the same
	helpers the Home dashboard uses (never-lie: only ticked where a real signal
	exists). Line breaks |n.
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
	TAB_START_HERE = "Start Here",
	START_TITLE = "Start Here — new to Midnight",
	START_SUBTITLE = "Just hit max level and not sure what to do? This is the whole endgame, in order. Click a step to jump straight to the tool for it; the weekly ones tick off on their own.",

	START_INTRO_HEADER = "The Midnight loop in a nutshell",
	START_INTRO_BODY = "Endgame is a weekly rhythm: lift your item level, tune your character, then each week fill your Great Vault from Delves, Ritual Sites and Void Assaults. Renown, professions and currencies layer on top once that loop feels routine.",

	START_S1_TITLE = "1. Lift your item level first",
	START_S1_BODY = "Start with the easy wins: do the Midnight campaign, grab gear from world quests and the renown milestone quests, and run regular Delves (plus Prey hunts and Heroic dungeons) to climb your item level. A few cheap crafted/AH pieces help too. Higher item level then opens the higher tiers where the real rewards are.",
	START_S1_NAV = "Open Delves",

	START_S2_TITLE = "2. Tune your character",
	START_S2_BODY = "Before harder content: pick your talents, grab the right flask, food, potion and enchants/gems for your spec, and set an interrupt + defensive macro. MH has a consumables checklist, ready-made macros (Toolbox) and rotation help (Role Academy).",
	START_S2_NAV = "Open Consumables",

	START_S3_TITLE = "3. Aim everything at the Great Vault",
	START_S3_BODY = "The Great Vault hands you one free reward each week. Its World row fills from Delves, Ritual Sites and Prey; dungeons and raid fill the other rows. Unlock as many slots as you can before reset.",
	START_S3_NAV = "Open Home",

	START_S4_TITLE = "4. Run your Delves",
	START_S4_BODY = "Delves are solo or small-group dungeons with Valeera at your side — steady gear and the easiest World-row vault progress. Climb the regular tiers first (below level 90 you're capped at Tier 3); once you reach Tier 8 you can run Bountiful Delves (you need a Restored Coffer Key) for Champion gear and Hero-track vault picks. The Delve Coach gives per-delve tips you can share with your group.",
	START_S4_NAV = "Open Delves",

	START_S5_TITLE = "5. Ritual Sites & Void Assaults",
	START_S5_BODY = "Two more World-row activities, best once you're geared a bit (they give random Champion gear). Unlock Ritual Sites first via the \"Ritual Interest\" questline in Silvermoon; Void Assaults are the rotating outdoor zone event and your way in. At the Curious Obelisk you pick a tier + challenges — the Ritual Coach explains every one.",
	START_S5_NAV = "Open Void & Rituals",

	START_S6_TITLE = "6. Go deeper: renown, professions & currencies",
	START_S6_BODY = "Renown unlocks perks and cosmetics; professions make gear, consumables and gold (MH has a full beginner course); and the Bazaar vendors in Silvermoon turn your currencies into upgrades. Pick these up once the weekly loop is routine.",
	START_S6_NAV = "Open Professions 101",

	START_RESET_TITLE = "Reset day: do it all again",
	START_RESET_BODY = "Weeklies and the Great Vault reset every week — Wednesday on EU realms, Tuesday on US. Claim last week's vault first, then run the loop again. That's the whole game — welcome to Midnight!",

	START_WEEKLY_RITUAL = "Ritual Sites weekly",
	START_WEEKLY_VOID = "Void Assaults weekly",
	START_STATUS_DONE = "done this week",
	START_STATUS_TODO = "still to do this week",

	START_WEEKLY_SUMMARY_FMT = "This week: %d/%d weekly objectives done",
	START_VAULT_READY = "A Great Vault reward is waiting — claim it!",
	START_VAULT_NONE = "No vault reward waiting yet — keep filling it before reset.",
	START_DELVERCALL_FMT = "Delver's Call: %d/%d done this week",

	TOUR_SECTION_HEADER = "How Midnight Helper works",
	TOUR_SECTION_BODY = "A quick, guided tour of the addon itself — it highlights each part of the window, one step at a time.",
	TOUR_HOME_NAV = "Open This Week",
	TOUR_CODEX_NAV = "Open Codex",
	TOUR_DELVES_NAV = "Open Delves & Vault",
	TOUR_ENCHANTS_NAV = "Open Enchants & Gems",
	TOUR_TOOLS_NAV = "Open Tools",
	TOUR_SETTINGS_NAV = "Open Settings",

	TOUR_START_BTN = "Start the interactive tour",
	TOUR_CM_SKIP = "Skip",
	TOUR_CM_NEXT = "Next",
	TOUR_CM_BACK = "Back",
	TOUR_CM_DONE = "Done",
	TOUR_CM_ROOMS_TITLE = "The rooms & tabs",
	TOUR_CM_ROOMS_BODY = "This is your navigation. The icons up top are the four rooms; the buttons below switch tabs within the room you're in.",
	TOUR_CM_SEARCH_TITLE = "Search anything",
	TOUR_CM_SEARCH_BODY = "Type here to jump straight to any tab or guide — your fastest way around.",
	TOUR_CM_FAV_TITLE = "Your favourites",
	TOUR_CM_FAV_BODY = "Pin your most-used tabs here with the +. One click takes you straight there.",
	TOUR_CM_INFO_TITLE = "Per-tab help",
	TOUR_CM_INFO_BODY = "The Info button opens a short explanation of whatever tab you're on right now.",
	TOUR_CM_CONTENT_TITLE = "The main view",
	TOUR_CM_CONTENT_BODY = "Everything you pick shows here. That's the whole tour — explore at your own pace!",
	TOUR_ROOMS_TITLE = "The four rooms",
	TOUR_ROOMS_BODY = "The icons on the left are four rooms — Me, Codex, Tools and Settings. Each groups related tabs, so the sidebar only shows what fits the room you're in.",
	TOUR_HOME_TITLE = "This Week — your cockpit",
	TOUR_HOME_BODY = "Your weekly landing page: Great Vault, the active world boss, weekly chores and rares, all at a glance with one-click jumps.",
	TOUR_SEARCH_TITLE = "Search & favourites",
	TOUR_SEARCH_BODY = "Type in the bar at the top to jump to any tab or guide. Pin your most-used tabs with the + just below it for one-click access.",
	TOUR_CODEX_TITLE = "Codex — the handbook",
	TOUR_CODEX_BODY = "In-game guides and reference for Midnight's systems — read up without leaving the game.",
	TOUR_DELVES_TITLE = "Delves & coaches",
	TOUR_DELVES_BODY = "Track your Great Vault and get per-boss tips from the Delve, Dungeon and Ritual coaches — shareable with your group.",
	TOUR_ENCHANTS_TITLE = "Enchants & Gems advisor",
	TOUR_ENCHANTS_BODY = "Checks your equipped gear for missing enchants and empty sockets, with a stat-matched suggestion for your spec.",
	TOUR_TOOLS_TITLE = "Tools launchpad",
	TOUR_TOOLS_BODY = "Open the floating helper windows — boss window, consumable board, curios and the ritual boss coach — from one place.",
	TOUR_SETTINGS_TITLE = "Settings",
	TOUR_SETTINGS_BODY = "Tune text size, language and every popup or alert to taste. Make MH yours.",
})

merge(ns._mhLocales and ns._mhLocales.itIT, {
	TAB_START_HERE = "Inizia qui",
	START_TITLE = "Inizia qui — nuovo in Midnight",
	START_SUBTITLE = "Appena arrivato al livello massimo e non sai cosa fare? Questo è tutto l'endgame, in ordine. Clicca un passo per saltare direttamente allo strumento giusto; quelli settimanali si spuntano da soli.",

	START_INTRO_HEADER = "Il loop di Midnight in breve",
	START_INTRO_BODY = "L'endgame è un ritmo settimanale: alza il tuo item level, metti a punto il personaggio e poi ogni settimana riempi il Great Vault con Delves, Ritual Sites e Void Assaults. Renown, professioni e valute si aggiungono una volta che il loop diventa routine.",

	START_S1_TITLE = "1. Alza prima il tuo item level",
	START_S1_BODY = "Comincia con le vittorie facili: fai la campagna di Midnight, prendi equipaggiamento dalle world quest e dalle quest di traguardo Renown, e fai Delves normali (più le cacce Prey e i dungeon Heroic) per salire di item level. Anche qualche pezzo craftato/dell'AH economico aiuta. Un item level più alto apre poi i tier superiori, dove ci sono le ricompense vere.",
	START_S1_NAV = "Apri Delves",

	START_S2_TITLE = "2. Metti a punto il personaggio",
	START_S2_BODY = "Prima dei contenuti più impegnativi: scegli i talenti, prendi la flask, il cibo, la pozione e gli enchant/gemme giusti per la tua spec, e imposta una macro di interrupt + una difensiva. MH ha una checklist dei consumabili, macro pronte all'uso (Toolbox) e aiuto sulla rotazione (Role Academy).",
	START_S2_NAV = "Apri Consumables",

	START_S3_TITLE = "3. Punta tutto al Great Vault",
	START_S3_BODY = "Il Great Vault ti regala una ricompensa gratuita ogni settimana. La sua riga World si riempie con Delves, Ritual Sites e Prey; i dungeon e il raid riempiono le altre righe. Sblocca più slot possibile prima del reset.",
	START_S3_NAV = "Apri Home",

	START_S4_TITLE = "4. Fai le tue Delves",
	START_S4_BODY = "Le Delves sono dungeon in solo o in piccolo gruppo con Valeera al tuo fianco — equipaggiamento costante e il progresso più facile per la riga World del Vault. Sali prima i tier normali (sotto il livello 90 sei limitato al Tier 3); una volta raggiunto il Tier 8 puoi fare le Bountiful Delves (ti serve una Restored Coffer Key) per equipaggiamento Champion e scelte Vault su Hero-track. Il Delve Coach dà consigli per ogni delve che puoi condividere col gruppo.",
	START_S4_NAV = "Apri Delves",

	START_S5_TITLE = "5. Ritual Sites & Void Assaults",
	START_S5_BODY = "Altre due attività della riga World, ideali una volta un po' equipaggiato (danno equipaggiamento Champion casuale). Sblocca prima le Ritual Sites tramite la linea di quest \"Ritual Interest\" a Silvermoon; i Void Assaults sono l'evento esterno a rotazione e la tua via d'accesso. Al Curious Obelisk scegli un tier + le challenge — il Ritual Coach le spiega tutte.",
	START_S5_NAV = "Apri Void & Rituals",

	START_S6_TITLE = "6. Vai più a fondo: Renown, professioni e valute",
	START_S6_BODY = "Renown sblocca vantaggi e cosmetici; le professioni producono equipaggiamento, consumabili e oro (MH ha un corso completo per principianti); e i vendor del Bazaar a Silvermoon trasformano le tue valute in upgrade. Dedicati a questi una volta che il loop settimanale è routine.",
	START_S6_NAV = "Apri Professions 101",

	START_RESET_TITLE = "Giorno del reset: si ricomincia",
	START_RESET_BODY = "Le settimanali e il Great Vault si resettano ogni settimana — mercoledì sui realm EU, martedì su quelli US. Riscatta prima il vault della settimana scorsa, poi rifai il loop. Questo è tutto il gioco — benvenuto in Midnight!",

	START_WEEKLY_RITUAL = "Settimanale Ritual Sites",
	START_WEEKLY_VOID = "Settimanale Void Assaults",
	START_STATUS_DONE = "fatto questa settimana",
	START_STATUS_TODO = "ancora da fare questa settimana",

	START_WEEKLY_SUMMARY_FMT = "Questa settimana: %d/%d obiettivi settimanali completati",
	START_VAULT_READY = "C'è una ricompensa del Great Vault che ti aspetta — riscattala!",
	START_VAULT_NONE = "Nessuna ricompensa del vault ancora — continua a riempirlo prima del reset.",
	START_DELVERCALL_FMT = "Delver's Call: %d/%d completate questa settimana",
})

merge(ns._mhLocales and ns._mhLocales.nlNL, {
	TAB_START_HERE = "Start Here",
	START_TITLE = "Start Here — nieuw in Midnight",
	START_SUBTITLE = "Net max level en geen idee wat je moet doen? Dit is de hele endgame, op volgorde. Klik een stap om direct naar de juiste tool te springen; de wekelijkse stappen vinken zichzelf af.",

	START_INTRO_HEADER = "De Midnight-loop in het kort",
	START_INTRO_BODY = "Endgame is een wekelijks ritme: verhoog je item level, stel je character af, en vul daarna elke week je Great Vault met Delves, Ritual Sites en Void Assaults. Renown, professies en currencies komen erbovenop zodra die loop routine wordt.",

	START_S1_TITLE = "1. Verhoog eerst je item level",
	START_S1_BODY = "Begin met de makkelijke winst: doe de Midnight-campaign, pak gear uit world quests en de renown-milestone-quests, en draai gewone Delves (plus Prey-hunts en Heroic dungeons) om je item level te klimmen. Een paar goedkope crafted/AH-stukken helpen ook. Een hoger item level opent dan de hogere tiers waar de echte beloningen zitten.",
	START_S1_NAV = "Open Delves",

	START_S2_TITLE = "2. Stel je character af",
	START_S2_BODY = "Vóór zwaardere content: kies je talents, pak de juiste flask, food, potion en enchants/gems voor je spec, en zet een interrupt- + defensive-macro. MH heeft een consumables-checklist, kant-en-klare macro's (Toolbox) en rotatie-hulp (Role Academy).",
	START_S2_NAV = "Open Consumables",

	START_S3_TITLE = "3. Richt alles op de Great Vault",
	START_S3_BODY = "De Great Vault geeft je elke week één gratis beloning. De World-rij vult met Delves, Ritual Sites en Prey; dungeons en raid vullen de andere rijen. Ontgrendel zoveel mogelijk slots vóór de reset.",
	START_S3_NAV = "Open Home",

	START_S4_TITLE = "4. Doe je Delves",
	START_S4_BODY = "Delves zijn solo- of kleine-groep-dungeons met Valeera aan je zij — stabiele gear en de makkelijkste World-rij-vaultvoortgang. Klim eerst de gewone tiers (onder level 90 is Tier 3 het maximum); vanaf Tier 8 kun je Bountiful Delves doen (je hebt een Restored Coffer Key nodig) voor Champion-gear en Hero-track vault-picks. De Delve Coach geeft tips per delve die je kunt delen.",
	START_S4_NAV = "Open Delves",

	START_S5_TITLE = "5. Ritual Sites & Void Assaults",
	START_S5_BODY = "Nog twee World-rij-activiteiten, het best zodra je wat gear hebt (ze geven random Champion-gear). Ontgrendel Ritual Sites eerst via de \"Ritual Interest\"-questlijn in Silvermoon; Void Assaults zijn het roterende outdoor-zone-event en je toegang ertoe. Bij de Curious Obelisk kies je een tier + challenges — de Ritual Coach legt elke challenge uit.",
	START_S5_NAV = "Open Void & Rituals",

	START_S6_TITLE = "6. Ga dieper: renown, professies & currencies",
	START_S6_BODY = "Renown ontgrendelt perks en cosmetics; professies maken gear, consumables en goud (MH heeft een volledige beginnerscursus); en de Bazaar-vendors in Silvermoon zetten je currencies om in upgrades. Pak deze op zodra de weekly loop routine is.",
	START_S6_NAV = "Open Professions 101",

	START_RESET_TITLE = "Reset-dag: alles opnieuw",
	START_RESET_BODY = "Weeklies en de Great Vault resetten elke week — woensdag op EU-realms, dinsdag op US. Claim eerst de vault van vorige week, draai dan de loop opnieuw. Dat is het hele spel — welkom in Midnight!",

	START_WEEKLY_RITUAL = "Ritual Sites weekly",
	START_WEEKLY_VOID = "Void Assaults weekly",
	START_STATUS_DONE = "deze week gedaan",
	START_STATUS_TODO = "nog te doen deze week",

	START_WEEKLY_SUMMARY_FMT = "Deze week: %d/%d wekelijkse doelen gedaan",
	START_VAULT_READY = "Er wacht een Great Vault-beloning — claim 'm!",
	START_VAULT_NONE = "Nog geen vault-beloning klaar — blijf 'm vullen vóór de reset.",
	START_DELVERCALL_FMT = "Delver's Call: %d/%d gedaan deze week",

	TOUR_SECTION_HEADER = "Zo werkt Midnight Helper",
	TOUR_SECTION_BODY = "Een korte, begeleide rondleiding door de addon zelf — hij licht elk onderdeel van het venster stap voor stap uit.",
	TOUR_HOME_NAV = "Open Deze week",
	TOUR_CODEX_NAV = "Open Codex",
	TOUR_DELVES_NAV = "Open Delves & Vault",
	TOUR_ENCHANTS_NAV = "Open Enchants & Gems",
	TOUR_TOOLS_NAV = "Open Tools",
	TOUR_SETTINGS_NAV = "Open Instellingen",

	TOUR_START_BTN = "Start de interactieve rondleiding",
	TOUR_CM_SKIP = "Overslaan",
	TOUR_CM_NEXT = "Volgende",
	TOUR_CM_BACK = "Terug",
	TOUR_CM_DONE = "Klaar",
	TOUR_CM_ROOMS_TITLE = "De kamers & tabs",
	TOUR_CM_ROOMS_BODY = "Dit is je navigatie. De iconen bovenaan zijn de vier kamers; de knoppen eronder wisselen tabs binnen je huidige kamer.",
	TOUR_CM_SEARCH_TITLE = "Zoek alles",
	TOUR_CM_SEARCH_BODY = "Typ hier om meteen naar een tab of guide te springen — je snelste route.",
	TOUR_CM_FAV_TITLE = "Je favorieten",
	TOUR_CM_FAV_BODY = "Pin je meest gebruikte tabs hier met de +. Eén klik brengt je er meteen heen.",
	TOUR_CM_INFO_TITLE = "Hulp per tab",
	TOUR_CM_INFO_BODY = "De Info-knop opent een korte uitleg van de tab waar je nu op staat.",
	TOUR_CM_CONTENT_TITLE = "Het hoofdscherm",
	TOUR_CM_CONTENT_BODY = "Alles wat je kiest verschijnt hier. Dat was de rondleiding — verken nu op je eigen tempo!",
	TOUR_ROOMS_TITLE = "De vier kamers",
	TOUR_ROOMS_BODY = "De iconen links zijn vier kamers — Me, Codex, Tools en Settings. Elke groepeert verwante tabs, dus de zijbalk toont alleen wat bij je huidige kamer past.",
	TOUR_HOME_TITLE = "Deze week — je cockpit",
	TOUR_HOME_BODY = "Je wekelijkse startpagina: Great Vault, de actieve world boss, wekelijkse klusjes en rares, in één oogopslag met één-klik-sprongen.",
	TOUR_SEARCH_TITLE = "Zoeken & favorieten",
	TOUR_SEARCH_BODY = "Typ in de balk bovenaan om naar een tab of guide te springen. Pin je meest gebruikte tabs met de + eronder voor één-klik-toegang.",
	TOUR_CODEX_TITLE = "Codex — het handboek",
	TOUR_CODEX_BODY = "In-game guides en naslag voor Midnight's systemen — lees bij zonder het spel te verlaten.",
	TOUR_DELVES_TITLE = "Delves & coaches",
	TOUR_DELVES_BODY = "Volg je Great Vault en krijg per-boss-tips van de Delve-, Dungeon- en Ritual-coaches — deelbaar met je groep.",
	TOUR_ENCHANTS_TITLE = "Enchants & Gems-advisor",
	TOUR_ENCHANTS_BODY = "Checkt je uitrusting op missende enchants en lege sockets, met een stat-gematchte aanrader voor jouw spec.",
	TOUR_TOOLS_TITLE = "Tools-launchpad",
	TOUR_TOOLS_BODY = "Open de zwevende helper-vensters — boss-venster, consumable-board, curios en de ritual-boss-coach — vanaf één plek.",
	TOUR_SETTINGS_TITLE = "Instellingen",
	TOUR_SETTINGS_BODY = "Pas tekstgrootte, taal en elke popup of alert naar smaak aan. Maak MH van jou.",
})

merge(ns._mhLocales and ns._mhLocales.deDE, {
	TAB_START_HERE = "Erste Schritte",
	START_TITLE = "Erste Schritte — neu in Midnight",
	START_SUBTITLE = "Gerade Maximalstufe erreicht und unsicher, was jetzt? Das hier ist das ganze Endgame, der Reihe nach. Klick einen Schritt, um direkt zum passenden Tool zu springen; die wöchentlichen Schritte haken sich von selbst ab.",

	START_INTRO_HEADER = "Der Midnight-Loop in Kürze",
	START_INTRO_BODY = "Endgame ist ein wöchentlicher Rhythmus: Heb deine Gegenstandsstufe an, stimm deinen Charakter ab und füll dann jede Woche deinen Great Vault über Tiefen, Ritual Sites und Void Assaults. Ansehen, Berufe und Währungen kommen obendrauf, sobald dieser Loop Routine ist.",

	START_S1_TITLE = "1. Heb zuerst deine Gegenstandsstufe an",
	START_S1_BODY = "Fang mit den leichten Erfolgen an: Spiel die Midnight-Kampagne, hol dir Ausrüstung aus Weltquests und den Ansehen-Meilenstein-Quests und lauf normale Tiefen (plus Prey-Jagden und heroische Dungeons), um deine Gegenstandsstufe zu steigern. Ein paar günstige hergestellte/AH-Teile helfen auch. Mit höherer Gegenstandsstufe öffnen sich dann die höheren Stufen mit den echten Belohnungen.",
	START_S1_NAV = "Tiefen öffnen",

	START_S2_TITLE = "2. Stimm deinen Charakter ab",
	START_S2_BODY = "Vor härterem Content: Wähl deine Talente, besorg das richtige Fläschchen, Essen, den richtigen Trank und Verzauberungen/Edelsteine für deine Spezialisierung und richte ein Unterbrechungs- und Defensiv-Makro ein. MH hat eine Verbrauchsmaterial-Checkliste, fertige Makros (Werkzeugkiste) und Rotationshilfe (Role Academy).",
	START_S2_NAV = "Verbrauchsmaterial öffnen",

	START_S3_TITLE = "3. Richte alles auf den Great Vault aus",
	START_S3_BODY = "Der Great Vault schenkt dir jede Woche eine Belohnung. Seine Welt-Reihe füllt sich über Tiefen, Ritual Sites und Prey; Dungeons und Schlachtzug füllen die anderen Reihen. Schalte vor dem Reset so viele Plätze frei wie möglich.",
	START_S3_NAV = "Start öffnen",

	START_S4_TITLE = "4. Lauf deine Tiefen",
	START_S4_BODY = "Tiefen sind Dungeons für solo oder kleine Gruppen mit Valeera an deiner Seite — stetige Ausrüstung und der einfachste Welt-Reihen-Fortschritt für den Vault. Klettere zuerst die normalen Stufen hoch (unter Stufe 90 ist Tier 3 das Maximum); ab Stufe 8 kannst du Bountiful Delves laufen (du brauchst einen Restored Coffer Key) für Champion-Ausrüstung und Hero-Track-Vault-Optionen. Der Tiefen-Coach gibt Tipps pro Tiefe, die du mit deiner Gruppe teilen kannst.",
	START_S4_NAV = "Tiefen öffnen",

	START_S5_TITLE = "5. Ritual Sites & Void Assaults",
	START_S5_BODY = "Zwei weitere Welt-Reihen-Aktivitäten, am besten sobald du etwas Ausrüstung hast (sie geben zufällige Champion-Ausrüstung). Schalte Ritual Sites zuerst über die Questreihe \"Ritual Interest\" in Silbermond frei; Void Assaults sind das rotierende Open-World-Event und dein Einstieg. Am Curious Obelisk wählst du Stufe + Challenges — der Ritual Coach erklärt jede einzelne.",
	START_S5_NAV = "Void & Rituals öffnen",

	START_S6_TITLE = "6. Geh tiefer: Ansehen, Berufe & Währungen",
	START_S6_BODY = "Ansehen schaltet Vorteile und Kosmetisches frei; Berufe liefern Ausrüstung, Verbrauchsmaterial und Gold (MH hat einen kompletten Einsteigerkurs); und die Basar-Händler in Silbermond machen aus deinen Währungen Upgrades. Nimm das mit, sobald der Wochen-Loop Routine ist.",
	START_S6_NAV = "Berufe 101 öffnen",

	START_RESET_TITLE = "Reset-Tag: alles noch einmal",
	START_RESET_BODY = "Wochenquests und der Great Vault setzen sich jede Woche zurück — Mittwoch auf EU-Realms, Dienstag auf US. Hol zuerst die Vault-Belohnung der Vorwoche ab und lauf dann den Loop erneut. Das ist das ganze Spiel — willkommen in Midnight!",

	START_WEEKLY_RITUAL = "Ritual-Sites-Weekly",
	START_WEEKLY_VOID = "Void-Assaults-Weekly",
	START_STATUS_DONE = "diese Woche erledigt",
	START_STATUS_TODO = "diese Woche noch offen",

	START_WEEKLY_SUMMARY_FMT = "Diese Woche: %d/%d Wochenziele erledigt",
	START_VAULT_READY = "Eine Great-Vault-Belohnung wartet — hol sie ab!",
	START_VAULT_NONE = "Noch keine Vault-Belohnung bereit — füll ihn weiter vor dem Reset.",
	START_DELVERCALL_FMT = "Delver's Call: %d/%d diese Woche erledigt",
})

merge(ns._mhLocales and ns._mhLocales.frFR, {
	TAB_START_HERE = "Bien démarrer",
	START_TITLE = "Bien démarrer — nouveau dans Midnight",
	START_SUBTITLE = "Tout juste niveau max et pas sûr de quoi faire ? Voici tout l'endgame, dans l'ordre. Clique une étape pour aller droit à l'outil correspondant ; les étapes hebdomadaires se cochent toutes seules.",

	START_INTRO_HEADER = "La boucle Midnight en bref",
	START_INTRO_BODY = "L'endgame est un rythme hebdomadaire : monte ton niveau d'objet, règle ton personnage, puis remplis chaque semaine ton Great Vault avec les Gouffres, les Ritual Sites et les Void Assaults. La renommée, les métiers et les devises viennent par-dessus une fois cette boucle devenue routinière.",

	START_S1_TITLE = "1. Monte d'abord ton niveau d'objet",
	START_S1_BODY = "Commence par les gains faciles : fais la campagne de Midnight, récupère de l'équipement via les expéditions mondiales et les quêtes de palier de renommée, et enchaîne des Gouffres normaux (plus les chasses Prey et les donjons héroïques) pour grimper en niveau d'objet. Quelques pièces craftées/HV pas chères aident aussi. Un niveau d'objet plus haut ouvre ensuite les paliers supérieurs, là où sont les vraies récompenses.",
	START_S1_NAV = "Ouvrir Gouffres",

	START_S2_TITLE = "2. Règle ton personnage",
	START_S2_BODY = "Avant le contenu plus dur : choisis tes talents, prends le bon flacon, la bonne nourriture, la bonne potion et les enchantements/gemmes pour ta spécialisation, et configure une macro d'interruption + une défensive. MH a une checklist de consommables, des macros prêtes à l'emploi (Boîte à outils) et de l'aide à la rotation (Role Academy).",
	START_S2_NAV = "Ouvrir Consommables",

	START_S3_TITLE = "3. Vise tout sur le Great Vault",
	START_S3_BODY = "Le Great Vault t'offre une récompense gratuite chaque semaine. Sa ligne Monde se remplit avec les Gouffres, les Ritual Sites et Prey ; les donjons et le raid remplissent les autres lignes. Débloque autant d'emplacements que possible avant le reset.",
	START_S3_NAV = "Ouvrir Accueil",

	START_S4_TITLE = "4. Fais tes Gouffres",
	START_S4_BODY = "Les Gouffres sont des donjons en solo ou petit groupe avec Valeera à tes côtés — de l'équipement régulier et la progression Monde la plus simple pour le Vault. Grimpe d'abord les paliers normaux (sous le niveau 90, Tier 3 est le maximum) ; à partir du Tier 8 tu peux faire des Bountiful Delves (il te faut une Restored Coffer Key) pour de l'équipement Champion et des choix de Vault Hero-track. Le Coach de gouffre donne des astuces par gouffre, à partager avec ton groupe.",
	START_S4_NAV = "Ouvrir Gouffres",

	START_S5_TITLE = "5. Ritual Sites & Void Assaults",
	START_S5_BODY = "Deux autres activités de la ligne Monde, idéales une fois un peu équipé (elles donnent de l'équipement Champion aléatoire). Débloque d'abord les Ritual Sites via la chaîne de quêtes \"Ritual Interest\" à Lune-d'argent ; les Void Assaults sont l'événement de zone extérieur en rotation et ta porte d'entrée. Au Curious Obelisk tu choisis un palier + des challenges — le Ritual Coach explique chacun d'eux.",
	START_S5_NAV = "Ouvrir Void & Rituals",

	START_S6_TITLE = "6. Va plus loin : renommée, métiers & devises",
	START_S6_BODY = "La renommée débloque des avantages et des cosmétiques ; les métiers fabriquent équipement, consommables et or (MH a un cours complet pour débutants) ; et les marchands du Bazar à Lune-d'argent transforment tes devises en améliorations. Prends tout ça une fois la boucle hebdo devenue routinière.",
	START_S6_NAV = "Ouvrir Métiers 101",

	START_RESET_TITLE = "Jour de reset : on recommence",
	START_RESET_BODY = "Les hebdos et le Great Vault se réinitialisent chaque semaine — mercredi sur les royaumes EU, mardi sur les US. Réclame d'abord le Vault de la semaine passée, puis relance la boucle. C'est tout le jeu — bienvenue dans Midnight !",

	START_WEEKLY_RITUAL = "Hebdo Ritual Sites",
	START_WEEKLY_VOID = "Hebdo Void Assaults",
	START_STATUS_DONE = "fait cette semaine",
	START_STATUS_TODO = "encore à faire cette semaine",

	START_WEEKLY_SUMMARY_FMT = "Cette semaine : %d/%d objectifs hebdo faits",
	START_VAULT_READY = "Une récompense du Great Vault t'attend — réclame-la !",
	START_VAULT_NONE = "Pas encore de récompense de Vault — continue de le remplir avant le reset.",
	START_DELVERCALL_FMT = "Delver's Call : %d/%d faits cette semaine",
})

merge(ns._mhLocales and ns._mhLocales.esES, {
	TAB_START_HERE = "Primeros pasos",
	START_TITLE = "Primeros pasos — nuevo en Midnight",
	START_SUBTITLE = "¿Acabas de llegar al nivel máximo y no sabes qué hacer? Esto es todo el endgame, en orden. Haz clic en un paso para saltar directo a su herramienta; los semanales se marcan solos.",

	START_INTRO_HEADER = "El bucle de Midnight en resumen",
	START_INTRO_BODY = "El endgame es un ritmo semanal: sube tu nivel de objeto, ajusta tu personaje y luego llena cada semana tu Great Vault con Profundidades, Ritual Sites y Void Assaults. El renombre, las profesiones y las monedas vienen encima cuando ese bucle ya sea rutina.",

	START_S1_TITLE = "1. Sube primero tu nivel de objeto",
	START_S1_BODY = "Empieza por las victorias fáciles: haz la campaña de Midnight, consigue equipo en las misiones de mundo y en las misiones de hito de renombre, y corre Profundidades normales (más cacerías Prey y mazmorras heroicas) para subir tu nivel de objeto. Unas cuantas piezas baratas crafteadas o de la casa de subastas también ayudan. Un nivel de objeto más alto abre luego los tiers superiores, donde están las recompensas de verdad.",
	START_S1_NAV = "Abrir Profundidades",

	START_S2_TITLE = "2. Ajusta tu personaje",
	START_S2_BODY = "Antes del contenido más duro: elige tus talentos, hazte con el frasco, la comida, la poción y los encantamientos/gemas adecuados para tu especialización, y prepara una macro de interrupción + una defensiva. MH tiene una lista de consumibles, macros listas para usar (Herramientas) y ayuda con la rotación (Role Academy).",
	START_S2_NAV = "Abrir Consumibles",

	START_S3_TITLE = "3. Apunta todo al Great Vault",
	START_S3_BODY = "El Great Vault te da una recompensa gratis cada semana. Su fila de Mundo se llena con Profundidades, Ritual Sites y Prey; las mazmorras y la banda llenan las otras filas. Desbloquea tantas casillas como puedas antes del reinicio.",
	START_S3_NAV = "Abrir Inicio",

	START_S4_TITLE = "4. Haz tus Profundidades",
	START_S4_BODY = "Las Profundidades son mazmorras en solitario o en grupo pequeño con Valeera a tu lado — equipo constante y el progreso más fácil de la fila de Mundo. Sube primero los tiers normales (por debajo del nivel 90 el máximo es el Tier 3); al llegar al Tier 8 puedes hacer Bountiful Delves (necesitas una Restored Coffer Key) para equipo Champion y opciones Hero-track en el Vault. El Entrenador de profundidades da consejos por profundidad que puedes compartir con tu grupo.",
	START_S4_NAV = "Abrir Profundidades",

	START_S5_TITLE = "5. Ritual Sites y Void Assaults",
	START_S5_BODY = "Dos actividades más de la fila de Mundo, mejores cuando ya tienes algo de equipo (dan equipo Champion aleatorio). Desbloquea primero los Ritual Sites con la cadena de misiones \"Ritual Interest\" en Lunargenta; los Void Assaults son el evento de zona exterior rotativo y tu vía de entrada. En el Curious Obelisk eliges tier + challenges — el Ritual Coach explica cada uno.",
	START_S5_NAV = "Abrir Void & Rituals",

	START_S6_TITLE = "6. Profundiza: renombre, profesiones y monedas",
	START_S6_BODY = "El renombre desbloquea ventajas y cosméticos; las profesiones producen equipo, consumibles y oro (MH tiene un curso completo para principiantes); y los vendedores del Bazar en Lunargenta convierten tus monedas en mejoras. Súmalos cuando el bucle semanal sea rutina.",
	START_S6_NAV = "Abrir Profesiones 101",

	START_RESET_TITLE = "Día de reinicio: vuelta a empezar",
	START_RESET_BODY = "Las semanales y el Great Vault se reinician cada semana — miércoles en reinos de EU, martes en US. Reclama primero el vault de la semana pasada y vuelve a correr el bucle. Ese es todo el juego — ¡bienvenido a Midnight!",

	START_WEEKLY_RITUAL = "Semanal de Ritual Sites",
	START_WEEKLY_VOID = "Semanal de Void Assaults",
	START_STATUS_DONE = "hecho esta semana",
	START_STATUS_TODO = "pendiente esta semana",

	START_WEEKLY_SUMMARY_FMT = "Esta semana: %d/%d objetivos semanales hechos",
	START_VAULT_READY = "Hay una recompensa del Great Vault esperando — ¡reclámala!",
	START_VAULT_NONE = "Aún no hay recompensa del vault — sigue llenándolo antes del reinicio.",
	START_DELVERCALL_FMT = "Delver's Call: %d/%d hechas esta semana",
})

merge(ns._mhLocales and ns._mhLocales.ptBR, {
	TAB_START_HERE = "Comece aqui",
	START_TITLE = "Comece aqui — novo no Midnight",
	START_SUBTITLE = "Acabou de chegar ao nível máximo e não sabe o que fazer? Este é todo o endgame, em ordem. Clique em um passo para ir direto à ferramenta certa; os semanais se marcam sozinhos.",

	START_INTRO_HEADER = "O loop do Midnight em resumo",
	START_INTRO_BODY = "O endgame é um ritmo semanal: suba seu item level, ajuste seu personagem e depois encha o Great Vault toda semana com Profundidades, Ritual Sites e Void Assaults. Renome, profissões e moedas vêm por cima quando esse loop virar rotina.",

	START_S1_TITLE = "1. Suba primeiro o seu item level",
	START_S1_BODY = "Comece pelas vitórias fáceis: faça a campanha do Midnight, pegue equipamento nas missões de mundo e nas missões de marco de renome, e rode Profundidades normais (mais caçadas Prey e masmorras heroicas) para subir o item level. Algumas peças baratas craftadas ou da casa de leilões também ajudam. Um item level mais alto abre os tiers maiores, onde estão as recompensas de verdade.",
	START_S1_NAV = "Abrir Profundidades",

	START_S2_TITLE = "2. Ajuste seu personagem",
	START_S2_BODY = "Antes do conteúdo mais difícil: escolha seus talentos, pegue o frasco, a comida, a poção e os encantamentos/gemas certos para a sua especialização, e monte uma macro de interrupção + uma defensiva. O MH tem uma checklist de consumíveis, macros prontas (Ferramentas) e ajuda de rotação (Role Academy).",
	START_S2_NAV = "Abrir Consumíveis",

	START_S3_TITLE = "3. Mire tudo no Great Vault",
	START_S3_BODY = "O Great Vault te dá uma recompensa grátis por semana. A fileira de Mundo enche com Profundidades, Ritual Sites e Prey; masmorras e raide enchem as outras fileiras. Desbloqueie o máximo de espaços que conseguir antes do reset.",
	START_S3_NAV = "Abrir Início",

	START_S4_TITLE = "4. Rode suas Profundidades",
	START_S4_BODY = "Profundidades são masmorras solo ou de grupo pequeno com o Valeera ao seu lado — equipamento constante e o progresso mais fácil da fileira de Mundo. Suba primeiro os tiers normais (abaixo do nível 90 o máximo é o Tier 3); ao chegar ao Tier 8 você pode rodar Bountiful Delves (precisa de uma Restored Coffer Key) para equipamento Champion e opções Hero-track no Vault. O Treinador de profundidades dá dicas por profundidade que você pode compartilhar com o grupo.",
	START_S4_NAV = "Abrir Profundidades",

	START_S5_TITLE = "5. Ritual Sites e Void Assaults",
	START_S5_BODY = "Mais duas atividades da fileira de Mundo, melhores quando você já tiver algum equipamento (dão equipamento Champion aleatório). Desbloqueie primeiro os Ritual Sites pela linha de missões \"Ritual Interest\" em Luaprata; os Void Assaults são o evento rotativo de zona aberta e a sua porta de entrada. No Curious Obelisk você escolhe tier + challenges — o Ritual Coach explica cada um.",
	START_S5_NAV = "Abrir Void & Rituals",

	START_S6_TITLE = "6. Vá mais fundo: renome, profissões e moedas",
	START_S6_BODY = "Renome desbloqueia vantagens e cosméticos; profissões produzem equipamento, consumíveis e ouro (o MH tem um curso completo para iniciantes); e os vendedores do Bazar em Luaprata transformam suas moedas em melhorias. Pegue isso quando o loop semanal virar rotina.",
	START_S6_NAV = "Abrir Profissões 101",

	START_RESET_TITLE = "Dia de reset: tudo de novo",
	START_RESET_BODY = "As semanais e o Great Vault resetam toda semana — quarta nos reinos da EU, terça nos dos EUA. Resgate primeiro o vault da semana passada e rode o loop de novo. Esse é o jogo inteiro — bem-vindo ao Midnight!",

	START_WEEKLY_RITUAL = "Semanal de Ritual Sites",
	START_WEEKLY_VOID = "Semanal de Void Assaults",
	START_STATUS_DONE = "feito esta semana",
	START_STATUS_TODO = "ainda a fazer esta semana",

	START_WEEKLY_SUMMARY_FMT = "Esta semana: %d/%d objetivos semanais feitos",
	START_VAULT_READY = "Há uma recompensa do Great Vault esperando — resgate-a!",
	START_VAULT_NONE = "Nenhuma recompensa do vault ainda — continue enchendo antes do reset.",
	START_DELVERCALL_FMT = "Delver's Call: %d/%d feitas esta semana",
})
