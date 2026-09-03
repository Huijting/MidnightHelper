--[[
	Midnight Helper — Raid Coach tip bodies (all 6 locales).

	Covers the three Season 1 raids: The Dreamrift (Chimaerus), The Voidspire
	(6 bosses) and March on Quel'Danas (Belo'ren + Midnight Falls/L'ura).
	Rotmire (Sporefall) lives in RitualTips.lua. See docs/RAID_MPLUS_DATA.md.

	Sources: Wowhead / Method / Icy-Veins boss guides + DBM-Raids-Midnight
	spell-IDs. never-lie: spell-IDs only where datamined; where a mechanic name
	is known but the spell-ID is not, the text says so and stays descriptive.
	Line breaks use |n; bullets use •. {SPELL:id} renders a localized link.

	WoW proper names (raids, bosses, abilities) stay in English in every locale;
	only the connecting prose follows each locale's convention.
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
	-- The Dreamrift — Chimaerus, the Undreamt God ---------------------------
	RAID_BOSS_CHIMAERUS_STEPS = "• Energy mechanic: adds walk toward Chimaerus — kill them before they arrive. If one reaches him he gains a big damage buff, and at full energy he devours an add for a near-wipe.|n• Interrupt {SPELL:1249017} — the Haunting Essence caster's cast is the priority kick.|n• Kill the Colossal Horror add fast; its damage keeps climbing.|n• Soak/split for Alndust Upheaval (the raid is divided into two groups) and dodge the Corrupted Devastation lines during the intermission.|n• Mythic adds Dissonance (don't stand near opposite-phase players) and Rift Madness (a debuff that must be soaked/swapped).|n• Dodge the {SPELL:1272726} frontal and the {SPELL:1245452} breath; group-soak {SPELL:1262289}.|n• {SPELL:1245404} flips the phase; kill the {SPELL:1251021} adds.|n• Healers dispel {SPELL:1257087}; on Mythic {SPELL:1264780} swaps players around.",
	RAID_PRERELEASE_NOTE = "Written before the raid opened (18 Aug), from DBM’s encounter modules and the game’s own journal. Nothing here is invented, but none of it has been walked yet — verify against the fight.",
	RAID_BOSS_NEKZALI_STEPS = "• Run out when {SPELL:1284103} fires — tanks trade on the same cast.|n• Kill the {SPELL:1297630} adds quickly.|n• Group-soak {SPELL:1305421}.|n• {SPELL:1287426} drops a line on someone — move out of it.|n• {SPELL:1299673} announces the next special; {SPELL:1298698} hits the whole raid.|n• Mythic only: {SPELL:1293212} drags you in.",
	RAID_BOSS_NEKZALI_TANK = "Taunt-swap after every {SPELL:1284103}.",
	RAID_BOSS_ENTOMBEDSENT_STEPS = "• Two golems: keep them far apart — close together they barely take damage.|n• {SPELL:1284588} is the stack puzzle; defuse it on a {SPELL:1284434} orb.|n• Group-soak {SPELL:1288232}, and burn the {SPELL:1284251} big adds.|n• Mythic only: {SPELL:1296878} changes which side is safe — watch the colour.",
	RAID_BOSS_ENTOMBEDSENT_TANK = "Swap on {SPELL:1284458} and {SPELL:1284487}; both want a defensive.",
	RAID_BOSS_ENTOMBEDSENT_HEALER = "Dispel {SPELL:1284483} — on call, not on sight.",
	RAID_BOSS_LOSTEXPLORERS_STEPS = "• Interrupt {SPELL:1286921}.|n• The floor is the fight: dodge {SPELL:1291759}, {SPELL:1291933} and {SPELL:1292104}.|n• {SPELL:1290711}: our two sources disagree — run out or stack up — so follow your leader’s call.|n• Feed Disgusting Fish to possessed Tortollans to break the possession.",
	RAID_BOSS_VASHNIK_STEPS = "• When he drinks ({SPELL:1283164}), venom adds crawl toward the centre — kill them before they arrive.|n• Carry {SPELL:1281907} away from the group.|n• Help soak {SPELL:1282509}.|n• {SPELL:1282114} is the debuff phase — check what you were given before you move.|n• Dodge {SPELL:1302489}.",
	RAID_BOSS_VASHNIK_TANK = "Defensive on {SPELL:1280935}.",
	RAID_BOSS_SSZORAK_STEPS = "• Wind is the enemy: {SPELL:1285732} pushes you — mind what is behind you.|n• Dodge {SPELL:1305959}, spread for {SPELL:1285733}.|n• Do not touch the cysts on the floor.",
	RAID_BOSS_SSZORAK_TANK = "{SPELL:1277025} is a combo — hold a defensive through all of it.",
	RAID_BOSS_TWINFANGS_STEPS = "• Everyone’s venom debuff keeps stacking; stand in {SPELL:1290516} to get it eaten before it stuns you.|n• Help soak {SPELL:1288484}.|n• Dodge the {SPELL:1294293} frontal, kill the {SPELL:1291404} adds.",
	RAID_BOSS_TWINFANGS_TANK = "The two bosses’ tank debuffs must never mix — keep your own boss, never cross.",
	RAID_BOSS_COILEDALTAR_STEPS = "• Give each other room at Guillotine.|n• Break the {SPELL:1286918} shield, dodge {SPELL:1283832}.|n• When someone is mind-controlled ({SPELL:1289900}), free them.|n• Three stages; at the end keep both bosses’ health even — one dying early enrages the other.",
	RAID_BOSS_COILEDALTAR_HEALER = "Dispel poison: {SPELL:1282281}.",
	RAID_BOSS_ULATEK_STEPS = "• Run from {SPELL:1301510}, dodge {SPELL:1302982} and {SPELL:1296301}.|n• Soak {SPELL:1300530} and {SPELL:1299757} — but not while you carry {SPELL:1300685}.|n• Switch to the {SPELL:1298559} add when it spawns; {SPELL:1300751} announces more.|n• {SPELL:1286860} and {SPELL:1292188} are the raid-damage windows; {SPELL:1292999} ends the phase.|n• {SPELL:1286905} in the last stage is the soft enrage — it does not stop.",
	RAID_BOSS_CHIMAERUS_TANK = "• Rending Tear is a bleed + knockback — face him away from the raid and don't get knocked off the platform; trade the Colossal Horror add with the off-tank.",
	RAID_BOSS_CHIMAERUS_HEALER = "• Damage spikes during the intermission (Corrupted Devastation / Ravenous Dive) and each time an add reaches the boss — save cooldowns for those windows.",

	-- The Voidspire — Imperator Averzian -----------------------------------
	RAID_BOSS_AVERZIAN_STEPS = "• A territory fight: adds are immune until hit by {SPELL:1249265} (Umbral Collapse, a group soak) — drop the soak on top of the adds to make them killable.|n• Interrupt {SPELL:1255702}.|n• Kill the Abyssal Voidshaper adds promptly.",
	RAID_BOSS_AVERZIAN_HEALER = "• The group soak ({SPELL:1249265}) lands on everyone stacked together — top the raid before each one.",

	-- The Voidspire — Vorasius ---------------------------------------------
	RAID_BOSS_VORASIUS_STEPS = "• He raises crystal walls; use them as cover from {SPELL:1243853} — stand behind a wall when he breathes.|n• Kite the Blistercreep adds into the walls to break them and open safe lanes.|n• His damage ramps with every wall set — keep the tempo up, it's a soft enrage.",
	RAID_BOSS_VORASIUS_HEALER = "• Raid damage climbs with each wall phase (soft enrage) — pace your cooldowns so the later sets are covered.",

	-- The Voidspire — Fallen-King Salhadaar --------------------------------
	RAID_BOSS_SALHADAAR_STEPS = "• {SPELL:1243453} spawns Concentrated Void orb-adds — kill them before they reach the boss.|n• At full energy he casts {SPELL:1246175}: dodge the beams. During it he takes +25% damage for ~20s — that's your burn window.|n• Keep the orbs under control and save burst for the Unraveling window.",
	RAID_BOSS_SALHADAAR_DPS = "• Hold cooldowns for the {SPELL:1246175} window (+25% damage taken for ~20s); otherwise prioritise the Concentrated Void orbs over the boss.",

	-- The Voidspire — Vaelgor & Ezzorak ------------------------------------
	RAID_BOSS_VAELGOR_STEPS = "Run out with {SPELL:1244221}; soak {SPELL:1245391} before the orb hits a wall to keep the room open.|n• During the intermission, stand inside {SPELL:1248847} to survive the pulsing damage.",
	RAID_BOSS_VAELGOR_TANK = "• {SPELL:1262623} is a stacking tank soak — manage it with the other tank; keep the two bosses close enough for even damage but their frontals pointed away from the raid.",
	RAID_BOSS_VAELGOR_HEALER = "• The intermission pulses hard — make sure everyone is inside {SPELL:1248847}, and top up before each Twilight Bond window.",

	-- The Voidspire — Lightblinded Vanguard --------------------------------
	RAID_BOSS_VANGUARD_STEPS = "At full energy one paladin casts an aura buffing the other two — drag the bosses out of it: {SPELL:1248449}, {SPELL:1246162}, {SPELL:1248451}.|n• Group-soak {SPELL:1276368}.|n• Dodge {SPELL:1248652}; melee run out of {SPELL:1246765}.|n• Break {SPELL:1248674}.|n• {SPELL:1246749} and {SPELL:1255738} are the raid-damage windows; healers watch the {SPELL:1248721} absorbs.",
	RAID_BOSS_VANGUARD_TANK = "• {SPELL:1246736} drives the tank swap — trade on the stacks and keep the three paladins grouped for cleave but out of the active aura.",

	-- The Voidspire — Crown of the Cosmos ----------------------------------
	RAID_BOSS_CROWN_STEPS = "• The finale: three stages with intermissions ({SPELL:1238843}), featuring three mini-bosses (Xal'atath with Turalyon, Arator and Alleria) before the final push.|n• Survive each intermission, then burn the active target in each stage.|n• Switch to the {SPELL:1237837} adds and break {SPELL:1246918}.|n• Dodge {SPELL:1234564} and {SPELL:1243753}; {SPELL:1283236} is raid damage.|n• Tanks: {SPELL:1233787} and {SPELL:1246461} both want a defensive.|n• Mythic only: {SPELL:1261339} brings a big add.",

	-- March on Quel'Danas — Belo'ren, Child of Al'ar -----------------------
	RAID_BOSS_BELOREN_STEPS = "At 0 HP he doesn't die — {SPELL:1241313} turns him into an egg in the center. The egg is the real health bar: burst it down, then the cycle repeats.|n• Pop your color-matched orbs to make safe gaps, and keep handling the casts your color is assigned.|n• {SPELL:1242515} swaps your colour — check it before you move.|n• Kill the {SPELL:1241282} adds; dodge {SPELL:1242792} and the {SPELL:1242260} lines.|n• Run from {SPELL:1246709}; {SPELL:1242981} sends orbs out.|n• Tanks: {SPELL:1260763} is a combo.",

	-- March on Quel'Danas — Midnight Falls (L'ura) -------------------------
	RAID_BOSS_LURA_STEPS = "• Phase 1 (Death's Dirge): five players get Dark Rune symbols in a set order — the rotating laser must hit those players in that same order, so call it out.|n• Phase 2 (Void Cores): beams (Galvanize) land on four players — aim them at the Void Cores to detonate them; a damaged core opens and pulls you in.|n• The Darkwell in the center is instant death; Total Eclipse pulls everyone toward it, and the outer ring (Iris of Oblivion) kills anyone who leaves the arena. Dodge the Starsplinter spikes.|n• Key casts: interrupt {SPELL:1251386}, dodge {SPELL:1253915} & {SPELL:1279420}, move {SPELL:1250898} away, and use a defensive for the knockback {SPELL:1281194} and the intermission {SPELL:1282047}. (EXBoss timeline — confirm in-game.)",
	RAID_BOSS_LURA_TANK = "• Heaven's Lance stacks to 5 and then applies Impale (+50% damage for ~25s) — swap with the off-tank each cycle before Impale lands.",
})

merge(ns._mhLocales and ns._mhLocales.itIT, {
	-- The Dreamrift — Chimaerus, the Undreamt God ---------------------------
	RAID_BOSS_CHIMAERUS_STEPS = "• Meccanica dell'energia: gli add camminano verso Chimaerus — uccidili prima che arrivino. Se uno lo raggiunge ottiene un grosso buff ai danni, e a energia piena divora un add per un quasi-wipe.|n• Interrompi {SPELL:1249017} — il cast del caster di Haunting Essence è il kick prioritario.|n• Uccidi in fretta l'add Colossal Horror; i suoi danni continuano a salire.|n• Soak/dividetevi per Alndust Upheaval (il raid viene diviso in due gruppi) e schiva le linee di Corrupted Devastation durante l'intermission.|n• In Mythic si aggiungono Dissonance (non stare vicino ai giocatori in fase opposta) e Rift Madness (un debuff che va soakato/scambiato).|n• Schivate il frontale {SPELL:1272726} e il soffio {SPELL:1245452}; assorbite in gruppo {SPELL:1262289}.|n• {SPELL:1245404} cambia fase; uccidete gli add di {SPELL:1251021}.|n• I healer dissipano {SPELL:1257087}; in mitico {SPELL:1264780} scambia i giocatori.",
	RAID_PRERELEASE_NOTE = "Scritto prima dell’apertura del raid (18 ago), dai moduli DBM e dal diario del gioco stesso. Niente qui è inventato, ma niente è stato ancora percorso — verificalo nello scontro.",
	RAID_BOSS_NEKZALI_STEPS = "• Corri fuori quando parte {SPELL:1284103} — i tank si scambiano sullo stesso cast.|n• Uccidete in fretta gli add di {SPELL:1297630}.|n• Assorbite in gruppo {SPELL:1305421}.|n• {SPELL:1287426} traccia una linea su qualcuno — spostati.|n• {SPELL:1299673} annuncia la prossima speciale; {SPELL:1298698} colpisce tutto il raid.|n• Solo mitico: {SPELL:1293212} ti trascina dentro.",
	RAID_BOSS_NEKZALI_TANK = "Cambio con provocazione dopo ogni {SPELL:1284103}.",
	RAID_BOSS_ENTOMBEDSENT_STEPS = "• Due golem: tienili ben distanti — vicini non subiscono quasi danni.|n• {SPELL:1284588} è il rompicapo degli stack; disinnescalo su una sfera di {SPELL:1284434}.|n• Assorbite in gruppo {SPELL:1288232} e bruciate i grossi add di {SPELL:1284251}.|n• Solo mitico: {SPELL:1296878} cambia quale lato è sicuro — guarda il colore.",
	RAID_BOSS_ENTOMBEDSENT_TANK = "Cambio su {SPELL:1284458} e {SPELL:1284487}; entrambi vogliono una difensiva.",
	RAID_BOSS_ENTOMBEDSENT_HEALER = "Dissipa {SPELL:1284483} — a chiamata, non a vista.",
	RAID_BOSS_LOSTEXPLORERS_STEPS = "• Interrompi {SPELL:1286921}.|n• Il pavimento è lo scontro: schiva {SPELL:1291759}, {SPELL:1291933} e {SPELL:1292104}.|n• {SPELL:1290711}: le nostre due fonti si contraddicono — allontanarsi o ammassarsi — segui quindi la chiamata del tuo leader.|n• Dai Disgusting Fish ai Tortollan posseduti per spezzare la possessione.",
	RAID_BOSS_VASHNIK_STEPS = "• Quando beve ({SPELL:1283164}), gli add di veleno strisciano verso il centro — uccideteli prima che arrivino.|n• Porta {SPELL:1281907} lontano dal gruppo.|n• Aiuta ad assorbire {SPELL:1282509}.|n• {SPELL:1282114} è la fase dei debuff — guarda cosa ti è toccato prima di muoverti.|n• Schiva {SPELL:1302489}.",
	RAID_BOSS_VASHNIK_TANK = "Difensiva su {SPELL:1280935}.",
	RAID_BOSS_SSZORAK_STEPS = "• Il vento è il nemico: {SPELL:1285732} ti spinge — bada a cosa hai alle spalle.|n• Schiva {SPELL:1305959}, sparpagliatevi per {SPELL:1285733}.|n• Non toccare le cisti sul pavimento.",
	RAID_BOSS_SSZORAK_TANK = "{SPELL:1277025} è una combo — tieni una difensiva per tutta la durata.",
	RAID_BOSS_TWINFANGS_STEPS = "• Il debuff di veleno di tutti continua a salire; mettiti in {SPELL:1290516} perché venga divorato prima che ti stordisca.|n• Aiuta a soakare {SPELL:1288484}.|n• Schiva il frontale di {SPELL:1294293}, uccidi gli add di {SPELL:1291404}.",
	RAID_BOSS_TWINFANGS_TANK = "I debuff da tank dei due boss non devono mai mescolarsi — tieni il tuo boss, mai incrociare.",
	RAID_BOSS_COILEDALTAR_STEPS = "• Datevi spazio sulla Guillotine.|n• Spaccate lo scudo di {SPELL:1286918}, schiva {SPELL:1283832}.|n• Se qualcuno viene controllato ({SPELL:1289900}), liberatelo.|n• Tre fasi; alla fine tenete pari la vita dei due boss — se uno muore troppo presto, l’altro si infuria.",
	RAID_BOSS_COILEDALTAR_HEALER = "Dissipa il veleno: {SPELL:1282281}.",
	RAID_BOSS_ULATEK_STEPS = "• Scappa da {SPELL:1301510}, schiva {SPELL:1302982} e {SPELL:1296301}.|n• Assorbi {SPELL:1300530} e {SPELL:1299757} — ma non mentre porti {SPELL:1300685}.|n• Passa sull'add di {SPELL:1298559} quando compare; {SPELL:1300751} ne annuncia altri.|n• {SPELL:1286860} e {SPELL:1292188} sono le finestre di danno al raid; {SPELL:1292999} chiude la fase.|n• {SPELL:1286905} nell'ultima fase è l'enrage morbido — non si ferma.",
	RAID_BOSS_CHIMAERUS_TANK = "• Rending Tear è un bleed + knockback — orientalo lontano dal raid e non farti buttare giù dalla piattaforma; scambia l'add Colossal Horror con l'off-tank.",
	RAID_BOSS_CHIMAERUS_HEALER = "• I danni piccano durante l'intermission (Corrupted Devastation / Ravenous Dive) e ogni volta che un add raggiunge il boss — tieni i cooldown per quelle finestre.",

	-- The Voidspire — Imperator Averzian -----------------------------------
	RAID_BOSS_AVERZIAN_STEPS = "• Una lotta di territorio: gli add sono immuni finché non vengono colpiti da {SPELL:1249265} (Umbral Collapse, un soak di gruppo) — lascia cadere il soak sopra agli add per renderli uccidibili.|n• Interrompi {SPELL:1255702}.|n• Uccidi prontamente gli add Abyssal Voidshaper.",
	RAID_BOSS_AVERZIAN_HEALER = "• Il soak di gruppo ({SPELL:1249265}) cade su tutti ammassati insieme — porta il raid al massimo prima di ognuno.",

	-- The Voidspire — Vorasius ---------------------------------------------
	RAID_BOSS_VORASIUS_STEPS = "• Erige muri di cristallo; usali come copertura da {SPELL:1243853} — stai dietro un muro quando soffia.|n• Kita gli add Blistercreep nei muri per romperli e aprire corsie sicure.|n• I suoi danni aumentano a ogni set di muri — mantieni il ritmo, è un soft enrage.",
	RAID_BOSS_VORASIUS_HEALER = "• I danni al raid salgono a ogni fase dei muri (soft enrage) — distribuisci i cooldown in modo da coprire i set finali.",

	-- The Voidspire — Fallen-King Salhadaar --------------------------------
	RAID_BOSS_SALHADAAR_STEPS = "• {SPELL:1243453} genera add-orbe Concentrated Void — uccidili prima che raggiungano il boss.|n• A energia piena lancia {SPELL:1246175}: schiva i beam. Durante questo subisce +25% danni per ~20s — è la tua finestra di burn.|n• Tieni gli orbe sotto controllo e conserva il burst per la finestra di Unraveling.",
	RAID_BOSS_SALHADAAR_DPS = "• Trattieni i cooldown per la finestra di {SPELL:1246175} (+25% danni subiti per ~20s); altrimenti dai priorità agli orbe Concentrated Void rispetto al boss.",

	-- The Voidspire — Vaelgor & Ezzorak ------------------------------------
	RAID_BOSS_VAELGOR_STEPS = "Esci da {SPELL:1244221}; soak {SPELL:1245391} prima che l'orbe colpisca un muro per tenere la stanza aperta.|n• Durante l'intermission, stai dentro {SPELL:1248847} per sopravvivere ai danni pulsanti.",
	RAID_BOSS_VAELGOR_TANK = "• {SPELL:1262623} è un tank soak che si accumula — gestiscilo con l'altro tank; tieni i due boss abbastanza vicini per danni uniformi ma con i loro frontali puntati lontano dal raid.",
	RAID_BOSS_VAELGOR_HEALER = "• L'intermission pulsa forte — assicurati che tutti siano dentro {SPELL:1248847}, e porta al massimo prima di ogni finestra di Twilight Bond.",

	-- The Voidspire — Lightblinded Vanguard --------------------------------
	RAID_BOSS_VANGUARD_STEPS = "A energia piena un paladin lancia un'aura che potenzia gli altri due — trascina i boss fuori da essa: {SPELL:1248449}, {SPELL:1246162}, {SPELL:1248451}.|n• Assorbite in gruppo {SPELL:1276368}.|n• Schivate {SPELL:1248652}; i melee escono da {SPELL:1246765}.|n• Rompete {SPELL:1248674}.|n• {SPELL:1246749} e {SPELL:1255738} sono le finestre di danno al raid; i healer guardano gli assorbimenti di {SPELL:1248721}.",
	RAID_BOSS_VANGUARD_TANK = "• {SPELL:1246736} guida il tank swap — scambia sugli stack e tieni i tre paladin raggruppati per il cleave ma fuori dall'aura attiva.",

	-- The Voidspire — Crown of the Cosmos ----------------------------------
	RAID_BOSS_CROWN_STEPS = "• Il finale: tre stage con intermission ({SPELL:1238843}), con tre mini-boss (Xal'atath con Turalyon, Arator e Alleria) prima della spinta finale.|n• Sopravvivi a ogni intermission, poi brucia il bersaglio attivo in ogni stage.|n• Passate sugli add di {SPELL:1237837} e rompete {SPELL:1246918}.|n• Schivate {SPELL:1234564} e {SPELL:1243753}; {SPELL:1283236} è danno al raid.|n• Tank: {SPELL:1233787} e {SPELL:1246461} vogliono entrambi una difensiva.|n• Solo mitico: {SPELL:1261339} porta un grosso add.",

	-- March on Quel'Danas — Belo'ren, Child of Al'ar -----------------------
	RAID_BOSS_BELOREN_STEPS = "A 0 HP non muore — {SPELL:1241313} lo trasforma in un uovo al centro. L'uovo è la vera barra della vita: bruscialo, poi il ciclo si ripete.|n• Attiva gli orbe del tuo colore per creare varchi sicuri, e continua a gestire i cast assegnati al tuo colore.|n• {SPELL:1242515} ti cambia colore — controllalo prima di muoverti.|n• Uccidete gli add di {SPELL:1241282}; schivate {SPELL:1242792} e le linee di {SPELL:1242260}.|n• Scappate da {SPELL:1246709}; {SPELL:1242981} manda fuori gli orbe.|n• Tank: {SPELL:1260763} è una combo.",

	-- March on Quel'Danas — Midnight Falls (L'ura) -------------------------
	RAID_BOSS_LURA_STEPS = "• Fase 1 (Death's Dirge): cinque giocatori ricevono i simboli Dark Rune in un ordine prestabilito — il laser rotante deve colpire quei giocatori in quello stesso ordine, quindi annuncialo.|n• Fase 2 (Void Cores): i beam (Galvanize) cadono su quattro giocatori — puntali sui Void Cores per farli detonare; un core danneggiato si apre e ti risucchia.|n• The Darkwell al centro è morte istantanea; Total Eclipse attira tutti verso di esso, e l'anello esterno (Iris of Oblivion) uccide chiunque lasci l'arena. Schiva gli spike di Starsplinter.|n• Cast chiave: interrompi {SPELL:1251386}, schiva {SPELL:1253915} & {SPELL:1279420}, sposta {SPELL:1250898} lontano, e usa una defensive per il knockback {SPELL:1281194} e l'intermission {SPELL:1282047}. (Timeline EXBoss — confermare in-game.)",
	RAID_BOSS_LURA_TANK = "• Heaven's Lance si accumula fino a 5 e poi applica Impale (+50% danni per ~25s) — scambia con l'off-tank a ogni ciclo prima che Impale arrivi.",
})

merge(ns._mhLocales and ns._mhLocales.nlNL, {
	-- The Dreamrift — Chimaerus, the Undreamt God ---------------------------
	RAID_BOSS_CHIMAERUS_STEPS = "• Energiemechanic: adds lopen naar Chimaerus toe — dood ze voordat ze aankomen. Bereikt er één hem, dan krijgt hij een grote damage-buff, en bij volle energie verslindt hij een add voor een bijna-wipe.|n• Interrupt {SPELL:1249017} — de cast van de Haunting Essence-caster is de prioriteitskick.|n• Dood de Colossal Horror-add snel; zijn damage blijft oplopen.|n• Soak/split voor Alndust Upheaval (de raid wordt in twee groepen verdeeld) en ontwijk de Corrupted Devastation-lijnen tijdens de intermission.|n• Mythic voegt Dissonance toe (sta niet bij spelers in de tegenovergestelde fase) en Rift Madness (een debuff die gesoaked/geswapt moet worden).|n• Ontwijk de {SPELL:1272726}-frontal en de {SPELL:1245452}-breath; soak {SPELL:1262289} met de groep.|n• {SPELL:1245404} wisselt de fase; dood de {SPELL:1251021}-adds.|n• Healers dispellen {SPELL:1257087}; op Mythic wisselt {SPELL:1264780} spelers om.",
	RAID_PRERELEASE_NOTE = "Geschreven vóór de opening van de raid (18 aug), uit DBM’s encounter-modules en het journal van het spel zelf. Niets hier is verzonnen, maar niets is al gelopen — toets het aan het gevecht.",
	RAID_BOSS_NEKZALI_STEPS = "• Ren naar buiten als {SPELL:1284103} komt — de tanks wisselen op diezelfde cast.|n• Maak de {SPELL:1297630}-adds snel dood.|n• Soak {SPELL:1305421} met de groep.|n• {SPELL:1287426} legt een lijn op iemand — stap eruit.|n• {SPELL:1299673} kondigt de volgende special aan; {SPELL:1298698} raakt de hele raid.|n• Alleen Mythic: {SPELL:1293212} trekt je naar binnen.",
	RAID_BOSS_NEKZALI_TANK = "Taunt-swap na elke {SPELL:1284103}.",
	RAID_BOSS_ENTOMBEDSENT_STEPS = "• Twee golems: houd ze ver uit elkaar — dicht bij elkaar nemen ze nauwelijks schade.|n• {SPELL:1284588} is de stack-puzzel; maak hem onschadelijk op een {SPELL:1284434}-bol.|n• Soak {SPELL:1288232} met de groep en brand de grote {SPELL:1284251}-adds weg.|n• Alleen Mythic: {SPELL:1296878} verandert welke kant veilig is — let op de kleur.",
	RAID_BOSS_ENTOMBEDSENT_TANK = "Swap op {SPELL:1284458} en {SPELL:1284487}; allebei willen een defensive.",
	RAID_BOSS_ENTOMBEDSENT_HEALER = "Dispel {SPELL:1284483} — op afroep, niet meteen.",
	RAID_BOSS_LOSTEXPLORERS_STEPS = "• Interrupt {SPELL:1286921}.|n• De vloer ís het gevecht: ontwijk {SPELL:1291759}, {SPELL:1291933} en {SPELL:1292104}.|n• {SPELL:1290711}: onze twee bronnen spreken elkaar tegen — wegrennen of juist stapelen — volg dus de afroep van je leider.|n• Voer Disgusting Fish aan bezeten Tortollans om de bezetenheid te breken.",
	RAID_BOSS_VASHNIK_STEPS = "• Als hij drinkt ({SPELL:1283164}) kruipen er venom-adds naar het midden — maak ze dood vóór ze er zijn.|n• Draag {SPELL:1281907} weg van de groep.|n• Help soaken bij {SPELL:1282509}.|n• {SPELL:1282114} is de debuff-fase — kijk wat jíj kreeg voor je gaat lopen.|n• Ontwijk {SPELL:1302489}.",
	RAID_BOSS_VASHNIK_TANK = "Defensive op {SPELL:1280935}.",
	RAID_BOSS_SSZORAK_STEPS = "• De wind is de vijand: {SPELL:1285732} duwt je — let op wat er achter je ligt.|n• Ontwijk {SPELL:1305959}, spreid voor {SPELL:1285733}.|n• Blijf van de cysten op de vloer af.",
	RAID_BOSS_SSZORAK_TANK = "{SPELL:1277025} is een combo — houd er een defensive doorheen vast.",
	RAID_BOSS_TWINFANGS_STEPS = "• Ieders gif-debuff blijft stapelen; ga in {SPELL:1290516} staan zodat hij wordt opgegeten vóór hij je stunt.|n• Help soaken bij {SPELL:1288484}.|n• Ontwijk de {SPELL:1294293}-frontal, dood de {SPELL:1291404}-adds.",
	RAID_BOSS_TWINFANGS_TANK = "De tank-debuffs van de twee bosses mogen nooit mengen — houd je eigen boss, wissel nooit kruislings.",
	RAID_BOSS_COILEDALTAR_STEPS = "• Geef elkaar ruimte bij Guillotine.|n• Sla het {SPELL:1286918}-schild kapot, ontwijk {SPELL:1283832}.|n• Wordt iemand mind-controlled ({SPELL:1289900}), bevrijd diegene.|n• Drie fases; houd aan het eind de levens van beide bosses gelijk — sterft er één te vroeg, dan enraget de ander.",
	RAID_BOSS_COILEDALTAR_HEALER = "Dispel poison: {SPELL:1282281}.",
	RAID_BOSS_ULATEK_STEPS = "• Ren weg van {SPELL:1301510}, ontwijk {SPELL:1302982} en {SPELL:1296301}.|n• Soak {SPELL:1300530} en {SPELL:1299757} — maar niet terwijl je {SPELL:1300685} draagt.|n• Switch naar de {SPELL:1298559}-add zodra hij spawnt; {SPELL:1300751} kondigt er meer aan.|n• {SPELL:1286860} en {SPELL:1292188} zijn de raid-damage-vensters; {SPELL:1292999} sluit de fase af.|n• {SPELL:1286905} in de laatste fase is de soft enrage — die stopt niet.",
	RAID_BOSS_CHIMAERUS_TANK = "• Rending Tear is een bleed + knockback — draai hem weg van de raid en laat je niet van het platform slaan; wissel de Colossal Horror-add met de off-tank.",
	RAID_BOSS_CHIMAERUS_HEALER = "• Schade piekt tijdens de intermission (Corrupted Devastation / Ravenous Dive) en telkens als een add de boss bereikt — bewaar cooldowns voor die vensters.",

	-- The Voidspire — Imperator Averzian -----------------------------------
	RAID_BOSS_AVERZIAN_STEPS = "• Een territoriumgevecht: adds zijn immuun tot ze geraakt worden door {SPELL:1249265} (Umbral Collapse, een groeps-soak) — laat de soak boven op de adds vallen om ze killbaar te maken.|n• Interrupt {SPELL:1255702}.|n• Dood de Abyssal Voidshaper-adds prompt.",
	RAID_BOSS_AVERZIAN_HEALER = "• De groeps-soak ({SPELL:1249265}) landt op iedereen samengepakt — top de raid vóór elke soak.",

	-- The Voidspire — Vorasius ---------------------------------------------
	RAID_BOSS_VORASIUS_STEPS = "• Hij hijst kristalmuren op; gebruik ze als dekking tegen {SPELL:1243853} — sta achter een muur als hij ademt.|n• Kite de Blistercreep-adds in de muren om ze te breken en veilige banen te openen.|n• Zijn damage loopt op met elke muurset — houd het tempo erin, het is een soft enrage.",
	RAID_BOSS_VORASIUS_HEALER = "• Raidschade loopt op met elke muurfase (soft enrage) — verdeel je cooldowns zo dat de latere sets gedekt zijn.",

	-- The Voidspire — Fallen-King Salhadaar --------------------------------
	RAID_BOSS_SALHADAAR_STEPS = "• {SPELL:1243453} spawnt Concentrated Void-orb-adds — dood ze voordat ze de boss bereiken.|n• Bij volle energie cast hij {SPELL:1246175}: ontwijk de beams. Tijdens deze cast neemt hij +25% damage voor ~20s — dat is je burn-venster.|n• Houd de orbs onder controle en bewaar burst voor het Unraveling-venster.",
	RAID_BOSS_SALHADAAR_DPS = "• Houd cooldowns vast voor het {SPELL:1246175}-venster (+25% damage taken voor ~20s); prioriteer anders de Concentrated Void-orbs boven de boss.",

	-- The Voidspire — Vaelgor & Ezzorak ------------------------------------
	RAID_BOSS_VAELGOR_STEPS = "Ren uit {SPELL:1244221}; soak {SPELL:1245391} voordat de orb een muur raakt om de ruimte open te houden.|n• Sta tijdens de intermission in {SPELL:1248847} om de pulserende schade te overleven.",
	RAID_BOSS_VAELGOR_TANK = "• {SPELL:1262623} is een stapelende tank-soak — beheer 'm met de andere tank; houd de twee bosses dicht genoeg voor gelijke damage maar met hun frontals weg van de raid.",
	RAID_BOSS_VAELGOR_HEALER = "• De intermission pulseert hard — zorg dat iedereen in {SPELL:1248847} staat, en top op vóór elk Twilight Bond-venster.",

	-- The Voidspire — Lightblinded Vanguard --------------------------------
	RAID_BOSS_VANGUARD_STEPS = "Bij volle energie cast één paladin een aura die de andere twee buft — sleep de bosses eruit: {SPELL:1248449}, {SPELL:1246162}, {SPELL:1248451}.|n• Soak {SPELL:1276368} met de groep.|n• Ontwijk {SPELL:1248652}; melee rent weg bij {SPELL:1246765}.|n• Sla {SPELL:1248674} kapot.|n• {SPELL:1246749} en {SPELL:1255738} zijn de raid-damage-vensters; healers letten op de {SPELL:1248721}-absorbs.",
	RAID_BOSS_VANGUARD_TANK = "• {SPELL:1246736} stuurt de tank-swap — wissel op de stacks en houd de drie paladins gegroepeerd voor cleave maar uit de actieve aura.",

	-- The Voidspire — Crown of the Cosmos ----------------------------------
	RAID_BOSS_CROWN_STEPS = "• De finale: drie stages met intermissions ({SPELL:1238843}), met drie mini-bosses (Xal'atath met Turalyon, Arator en Alleria) vóór de laatste push.|n• Overleef elke intermission en burn daarna het actieve doelwit in elke stage.|n• Switch naar de {SPELL:1237837}-adds en sla {SPELL:1246918} kapot.|n• Ontwijk {SPELL:1234564} en {SPELL:1243753}; {SPELL:1283236} is raid-damage.|n• Tanks: {SPELL:1233787} en {SPELL:1246461} willen allebei een defensive.|n• Alleen Mythic: {SPELL:1261339} brengt een grote add.",

	-- March on Quel'Danas — Belo'ren, Child of Al'ar -----------------------
	RAID_BOSS_BELOREN_STEPS = "Op 0 HP gaat hij niet dood — {SPELL:1241313} verandert hem in een ei in het midden. Het ei is de echte health-bar: burst 'm down, daarna herhaalt de cyclus.|n• Pop je kleur-bijpassende orbs om veilige gaten te maken, en blijf de casts afhandelen die aan jouw kleur zijn toegewezen.|n• {SPELL:1242515} wisselt je kleur — kijk welke je hebt voor je gaat lopen.|n• Dood de {SPELL:1241282}-adds; ontwijk {SPELL:1242792} en de {SPELL:1242260}-lijnen.|n• Ren weg van {SPELL:1246709}; {SPELL:1242981} stuurt orbs naar buiten.|n• Tanks: {SPELL:1260763} is een combo.",

	-- March on Quel'Danas — Midnight Falls (L'ura) -------------------------
	RAID_BOSS_LURA_STEPS = "• Fase 1 (Death's Dirge): vijf spelers krijgen Dark Rune-symbolen in een vaste volgorde — de roterende laser moet die spelers in diezelfde volgorde raken, dus call het uit.|n• Fase 2 (Void Cores): beams (Galvanize) landen op vier spelers — richt ze op de Void Cores om ze te laten detoneren; een beschadigde core opent en trekt je naar binnen.|n• The Darkwell in het midden is instant dood; Total Eclipse trekt iedereen ernaartoe, en de buitenring (Iris of Oblivion) doodt iedereen die de arena verlaat. Ontwijk de Starsplinter-spikes.|n• Belangrijke casts: interrupt {SPELL:1251386}, ontwijk {SPELL:1253915} & {SPELL:1279420}, leg {SPELL:1250898} weg, en gebruik een defensive voor de knockback {SPELL:1281194} en de intermission {SPELL:1282047}. (EXBoss-timeline — in-game bevestigen.)",
	RAID_BOSS_LURA_TANK = "• Heaven's Lance stapelt tot 5 en past dan Impale toe (+50% damage voor ~25s) — wissel elke cyclus met de off-tank voordat Impale landt.",
})

merge(ns._mhLocales and ns._mhLocales.deDE, {
	-- The Dreamrift — Chimaerus, the Undreamt God ---------------------------
	RAID_BOSS_CHIMAERUS_STEPS = "• Energiemechanik: Adds laufen auf Chimaerus zu — töte sie, bevor sie ankommen. Erreicht ihn einer, erhält er einen großen Schadensbuff, und bei voller Energie verschlingt er einen Add für einen Beinahe-Wipe.|n• Unterbrich {SPELL:1249017} — der Zauber des Haunting-Essence-Casters ist der Prioritäts-Kick.|n• Töte den Colossal-Horror-Add schnell; sein Schaden steigt stetig.|n• Soake/splitte für Alndust Upheaval (der Schlachtzug wird in zwei Gruppen geteilt) und weiche den Corrupted-Devastation-Linien während des Zwischenspiels aus.|n• Mythic fügt Dissonance hinzu (steh nicht bei Spielern in der Gegenphase) und Rift Madness (ein Debuff, der gesoakt/geswappt werden muss).|n• Weicht dem {SPELL:1272726}-Frontal und dem {SPELL:1245452}-Atem aus; soakt {SPELL:1262289} als Gruppe.|n• {SPELL:1245404} wechselt die Phase; tötet die {SPELL:1251021}-Adds.|n• Heiler entfernen {SPELL:1257087}; im Mythisch tauscht {SPELL:1264780} Spieler.",
	RAID_PRERELEASE_NOTE = "Geschrieben vor der Öffnung des Raids (18. Aug.), aus DBMs Encounter-Modulen und dem Journal des Spiels selbst. Nichts hier ist erfunden, aber nichts davon wurde schon gelaufen — prüfe es am Kampf.",
	RAID_BOSS_NEKZALI_STEPS = "• Lauf raus, wenn {SPELL:1284103} kommt — die Tanks wechseln beim selben Zauber.|n• Tötet die {SPELL:1297630}-Adds schnell.|n• Soakt {SPELL:1305421} als Gruppe.|n• {SPELL:1287426} legt eine Linie auf jemanden — geh raus.|n• {SPELL:1299673} kündigt die nächste Spezialfähigkeit an; {SPELL:1298698} trifft den ganzen Raid.|n• Nur Mythisch: {SPELL:1293212} zieht dich hinein.",
	RAID_BOSS_NEKZALI_TANK = "Spott-Wechsel nach jedem {SPELL:1284103}.",
	RAID_BOSS_ENTOMBEDSENT_STEPS = "• Zwei Golems: halte sie weit auseinander — nah beieinander nehmen sie kaum Schaden.|n• {SPELL:1284588} ist das Stapel-Rätsel; entschärfe es auf einer {SPELL:1284434}-Kugel.|n• Soakt {SPELL:1288232} als Gruppe und brennt die großen {SPELL:1284251}-Adds weg.|n• Nur Mythisch: {SPELL:1296878} ändert, welche Seite sicher ist — achte auf die Farbe.",
	RAID_BOSS_ENTOMBEDSENT_TANK = "Wechsel bei {SPELL:1284458} und {SPELL:1284487}; beide wollen eine Defensive.",
	RAID_BOSS_ENTOMBEDSENT_HEALER = "Entferne {SPELL:1284483} — auf Ansage, nicht sofort.",
	RAID_BOSS_LOSTEXPLORERS_STEPS = "• Unterbrich {SPELL:1286921}.|n• Der Boden ist der Kampf: weiche {SPELL:1291759}, {SPELL:1291933} und {SPELL:1292104} aus.|n• {SPELL:1290711}: unsere zwei Quellen widersprechen sich — rauslaufen oder stapeln — folge also der Ansage deines Leiters.|n• Füttere besessene Tortollan mit Disgusting Fish, um die Besessenheit zu brechen.",
	RAID_BOSS_VASHNIK_STEPS = "• Wenn er trinkt ({SPELL:1283164}), kriechen Gift-Adds zur Mitte — tötet sie, bevor sie ankommen.|n• Trag {SPELL:1281907} von der Gruppe weg.|n• Hilf beim Soaken von {SPELL:1282509}.|n• {SPELL:1282114} ist die Debuff-Phase — schau nach, was du bekommen hast, bevor du läufst.|n• Weiche {SPELL:1302489} aus.",
	RAID_BOSS_VASHNIK_TANK = "Defensive bei {SPELL:1280935}.",
	RAID_BOSS_SSZORAK_STEPS = "• Der Wind ist der Feind: {SPELL:1285732} schiebt dich — achte darauf, was hinter dir liegt.|n• Weiche {SPELL:1305959} aus, verteilt euch bei {SPELL:1285733}.|n• Fass die Zysten am Boden nicht an.",
	RAID_BOSS_SSZORAK_TANK = "{SPELL:1277025} ist eine Kombo — halte eine Defensive durchgehend.",
	RAID_BOSS_TWINFANGS_STEPS = "• Der Gift-Debuff aller stapelt weiter; stell dich in {SPELL:1290516}, damit er gefressen wird, bevor er dich betäubt.|n• Hilf beim Soaken von {SPELL:1288484}.|n• Weiche dem {SPELL:1294293}-Frontal aus, töte die {SPELL:1291404}-Adds.",
	RAID_BOSS_TWINFANGS_TANK = "Die Tank-Debuffs der beiden Bosse dürfen sich nie mischen — behalte deinen Boss, nie kreuzen.",
	RAID_BOSS_COILEDALTAR_STEPS = "• Gebt euch Platz bei Guillotine.|n• Schlagt den {SPELL:1286918}-Schild weg, weiche {SPELL:1283832} aus.|n• Wird jemand gedankenkontrolliert ({SPELL:1289900}), befreit die Person.|n• Drei Phasen; haltet am Ende die Leben beider Bosse gleich — stirbt einer zu früh, gerät der andere in Raserei.",
	RAID_BOSS_COILEDALTAR_HEALER = "Gift entfernen: {SPELL:1282281}.",
	RAID_BOSS_ULATEK_STEPS = "• Lauf vor {SPELL:1301510} weg, weiche {SPELL:1302982} und {SPELL:1296301} aus.|n• Soakt {SPELL:1300530} und {SPELL:1299757} — aber nicht, während du {SPELL:1300685} trägst.|n• Wechsle auf den {SPELL:1298559}-Add, sobald er erscheint; {SPELL:1300751} kündigt weitere an.|n• {SPELL:1286860} und {SPELL:1292188} sind die Raidschadensfenster; {SPELL:1292999} beendet die Phase.|n• {SPELL:1286905} in der letzten Phase ist der weiche Enrage — er hört nicht auf.",
	RAID_BOSS_CHIMAERUS_TANK = "• Rending Tear ist ein Blutung + Rückstoß — dreh ihn vom Schlachtzug weg und lass dich nicht von der Plattform stoßen; tausche den Colossal-Horror-Add mit dem Off-Tank.",
	RAID_BOSS_CHIMAERUS_HEALER = "• Der Schaden spitzt sich während des Zwischenspiels zu (Corrupted Devastation / Ravenous Dive) und jedes Mal, wenn ein Add den Boss erreicht — heb dir Cooldowns für diese Fenster auf.",

	-- The Voidspire — Imperator Averzian -----------------------------------
	RAID_BOSS_AVERZIAN_STEPS = "• Ein Territoriumskampf: Adds sind immun, bis sie von {SPELL:1249265} (Umbral Collapse, ein Gruppen-Soak) getroffen werden — lass den Soak direkt auf den Adds fallen, um sie tötbar zu machen.|n• Unterbrich {SPELL:1255702}.|n• Töte die Abyssal-Voidshaper-Adds umgehend.",
	RAID_BOSS_AVERZIAN_HEALER = "• Der Gruppen-Soak ({SPELL:1249265}) landet auf allen zusammengestellten Spielern — heile den Schlachtzug vor jedem hoch.",

	-- The Voidspire — Vorasius ---------------------------------------------
	RAID_BOSS_VORASIUS_STEPS = "• Er errichtet Kristallwände; nutze sie als Deckung gegen {SPELL:1243853} — steh hinter einer Wand, wenn er atmet.|n• Kite die Blistercreep-Adds in die Wände, um sie zu zerstören und sichere Gassen zu öffnen.|n• Sein Schaden steigt mit jedem Wandsatz — halt das Tempo hoch, es ist ein Soft-Enrage.",
	RAID_BOSS_VORASIUS_HEALER = "• Der Schlachtzugsschaden steigt mit jeder Wandphase (Soft-Enrage) — teil deine Cooldowns so ein, dass die späteren Sätze abgedeckt sind.",

	-- The Voidspire — Fallen-King Salhadaar --------------------------------
	RAID_BOSS_SALHADAAR_STEPS = "• {SPELL:1243453} spawnt Concentrated-Void-Orb-Adds — töte sie, bevor sie den Boss erreichen.|n• Bei voller Energie wirkt er {SPELL:1246175}: weiche den Strahlen aus. Währenddessen nimmt er ~20s lang +25% Schaden — das ist dein Burn-Fenster.|n• Halt die Orbs unter Kontrolle und heb dir Burst für das Unraveling-Fenster auf.",
	RAID_BOSS_SALHADAAR_DPS = "• Halt Cooldowns für das {SPELL:1246175}-Fenster zurück (+25% erlittener Schaden für ~20s); priorisiere ansonsten die Concentrated-Void-Orbs vor dem Boss.",

	-- The Voidspire — Vaelgor & Ezzorak ------------------------------------
	RAID_BOSS_VAELGOR_STEPS = "Lauf aus {SPELL:1244221} heraus; soake {SPELL:1245391}, bevor der Orb eine Wand trifft, um den Raum offen zu halten.|n• Steh während des Zwischenspiels in {SPELL:1248847}, um den pulsierenden Schaden zu überleben.",
	RAID_BOSS_VAELGOR_TANK = "• {SPELL:1262623} ist ein stapelnder Tank-Soak — verwalte ihn mit dem anderen Tank; halt die beiden Bosse nah genug für gleichmäßigen Schaden, aber ihre Frontals vom Schlachtzug weggerichtet.",
	RAID_BOSS_VAELGOR_HEALER = "• Das Zwischenspiel pulsiert hart — sorg dafür, dass alle in {SPELL:1248847} stehen, und heil vor jedem Twilight-Bond-Fenster hoch.",

	-- The Voidspire — Lightblinded Vanguard --------------------------------
	RAID_BOSS_VANGUARD_STEPS = "Bei voller Energie wirkt ein Paladin eine Aura, die die anderen beiden bufft — zieh die Bosse heraus: {SPELL:1248449}, {SPELL:1246162}, {SPELL:1248451}.|n• Soakt {SPELL:1276368} als Gruppe.|n• Weicht {SPELL:1248652} aus; Nahkämpfer raus aus {SPELL:1246765}.|n• Zerschlagt {SPELL:1248674}.|n• {SPELL:1246749} und {SPELL:1255738} sind die Raidschadensfenster; Heiler achten auf die {SPELL:1248721}-Absorptionen.",
	RAID_BOSS_VANGUARD_TANK = "• {SPELL:1246736} treibt den Tankwechsel an — wechsle bei den Stacks und halt die drei Paladine für Cleave gruppiert, aber außerhalb der aktiven Aura.",

	-- The Voidspire — Crown of the Cosmos ----------------------------------
	RAID_BOSS_CROWN_STEPS = "• Das Finale: drei Phasen mit Zwischenspielen ({SPELL:1238843}), mit drei Mini-Bossen (Xal'atath mit Turalyon, Arator und Alleria) vor dem letzten Ansturm.|n• Überlebe jedes Zwischenspiel und burne dann das aktive Ziel in jeder Phase.|n• Wechselt auf die {SPELL:1237837}-Adds und zerschlagt {SPELL:1246918}.|n• Weicht {SPELL:1234564} und {SPELL:1243753} aus; {SPELL:1283236} ist Raidschaden.|n• Tanks: {SPELL:1233787} und {SPELL:1246461} wollen beide eine Defensive.|n• Nur Mythisch: {SPELL:1261339} bringt einen großen Add.",

	-- March on Quel'Danas — Belo'ren, Child of Al'ar -----------------------
	RAID_BOSS_BELOREN_STEPS = "Bei 0 HP stirbt er nicht — {SPELL:1241313} verwandelt ihn in ein Ei in der Mitte. Das Ei ist die echte Gesundheitsleiste: burne es runter, dann wiederholt sich der Zyklus.|n• Zünde deine farblich passenden Orbs, um sichere Lücken zu schaffen, und handhabe weiter die Zauber, die deiner Farbe zugewiesen sind.|n• {SPELL:1242515} tauscht deine Farbe — prüf sie, bevor du läufst.|n• Tötet die {SPELL:1241282}-Adds; weicht {SPELL:1242792} und den {SPELL:1242260}-Linien aus.|n• Lauf vor {SPELL:1246709} weg; {SPELL:1242981} schickt Orbs hinaus.|n• Tanks: {SPELL:1260763} ist eine Kombo.",

	-- March on Quel'Danas — Midnight Falls (L'ura) -------------------------
	RAID_BOSS_LURA_STEPS = "• Phase 1 (Death's Dirge): fünf Spieler erhalten Dark-Rune-Symbole in einer festen Reihenfolge — der rotierende Laser muss diese Spieler in genau dieser Reihenfolge treffen, also sag es an.|n• Phase 2 (Void Cores): Strahlen (Galvanize) landen auf vier Spielern — richte sie auf die Void Cores, um sie zu detonieren; ein beschädigter Kern öffnet sich und zieht dich hinein.|n• The Darkwell in der Mitte ist sofortiger Tod; Total Eclipse zieht alle dorthin, und der äußere Ring (Iris of Oblivion) tötet jeden, der die Arena verlässt. Weiche den Starsplinter-Spitzen aus.|n• Wichtige Zauber: unterbrich {SPELL:1251386}, weiche {SPELL:1253915} & {SPELL:1279420} aus, beweg {SPELL:1250898} weg, und nutz eine Defensive für den Rückstoß {SPELL:1281194} und das Zwischenspiel {SPELL:1282047}. (EXBoss-Timeline — im Spiel bestätigen.)",
	RAID_BOSS_LURA_TANK = "• Heaven's Lance stapelt bis 5 und wendet dann Impale an (+50% Schaden für ~25s) — wechsle jeden Zyklus mit dem Off-Tank, bevor Impale landet.",
})

merge(ns._mhLocales and ns._mhLocales.frFR, {
	-- The Dreamrift — Chimaerus, the Undreamt God ---------------------------
	RAID_BOSS_CHIMAERUS_STEPS = "• Mécanique d'énergie : les adds marchent vers Chimaerus — tuez-les avant qu'ils n'arrivent. Si l'un l'atteint, il gagne un gros bonus de dégâts, et à pleine énergie il dévore un add pour un quasi-wipe.|n• Interrompez {SPELL:1249017} — l'incantation du lanceur de Haunting Essence est le kick prioritaire.|n• Tuez vite l'add Colossal Horror ; ses dégâts ne cessent de monter.|n• Soakez/répartissez-vous pour Alndust Upheaval (le raid est divisé en deux groupes) et esquivez les lignes de Corrupted Devastation pendant l'intermède.|n• En Mythique s'ajoutent Dissonance (ne restez pas près des joueurs en phase opposée) et Rift Madness (un debuff à soaker/échanger).|n• Esquivez le frontal {SPELL:1272726} et le souffle {SPELL:1245452} ; absorbez {SPELL:1262289} en groupe.|n• {SPELL:1245404} change de phase ; tuez les adds {SPELL:1251021}.|n• Les soigneurs dissipent {SPELL:1257087} ; en Mythique {SPELL:1264780} échange les joueurs.",
	RAID_PRERELEASE_NOTE = "Écrit avant l’ouverture du raid (18 août), à partir des modules DBM et du journal du jeu lui-même. Rien ici n’est inventé, mais rien n’a encore été parcouru — vérifie face au combat.",
	RAID_BOSS_NEKZALI_STEPS = "• Sors quand {SPELL:1284103} part — les tanks échangent sur ce même sort.|n• Tuez vite les adds {SPELL:1297630}.|n• Absorbez {SPELL:1305421} en groupe.|n• {SPELL:1287426} pose une ligne sur quelqu'un — sors-en.|n• {SPELL:1299673} annonce la prochaine spéciale ; {SPELL:1298698} touche tout le raid.|n• Mythique seulement : {SPELL:1293212} t'attire dedans.",
	RAID_BOSS_NEKZALI_TANK = "Échange de provocation après chaque {SPELL:1284103}.",
	RAID_BOSS_ENTOMBEDSENT_STEPS = "• Deux golems : garde-les loin l'un de l'autre — proches, ils ne prennent presque pas de dégâts.|n• {SPELL:1284588} est le casse-tête à stacks ; désamorce-le sur une orbe {SPELL:1284434}.|n• Absorbez {SPELL:1288232} en groupe et brûlez les gros adds {SPELL:1284251}.|n• Mythique seulement : {SPELL:1296878} change le côté sûr — regarde la couleur.",
	RAID_BOSS_ENTOMBEDSENT_TANK = "Échange sur {SPELL:1284458} et {SPELL:1284487} ; les deux demandent un défensif.",
	RAID_BOSS_ENTOMBEDSENT_HEALER = "Dissipe {SPELL:1284483} — à l’annonce, pas à vue.",
	RAID_BOSS_LOSTEXPLORERS_STEPS = "• Interromps {SPELL:1286921}.|n• Le sol est le combat : esquive {SPELL:1291759}, {SPELL:1291933} et {SPELL:1292104}.|n• {SPELL:1290711} : nos deux sources se contredisent — s’écarter ou se regrouper — suis donc l’annonce de ton leader.|n• Donne des Disgusting Fish aux Tortollans possédés pour briser la possession.",
	RAID_BOSS_VASHNIK_STEPS = "• Quand il boit ({SPELL:1283164}), des adds de venin rampent vers le centre — tuez-les avant qu'ils arrivent.|n• Emmène {SPELL:1281907} loin du groupe.|n• Aide à absorber {SPELL:1282509}.|n• {SPELL:1282114} est la phase de debuffs — regarde ce que tu as reçu avant de bouger.|n• Esquive {SPELL:1302489}.",
	RAID_BOSS_VASHNIK_TANK = "Défensif sur {SPELL:1280935}.",
	RAID_BOSS_SSZORAK_STEPS = "• Le vent est l’ennemi : {SPELL:1285732} te pousse — regarde ce qu’il y a derrière toi.|n• Esquive {SPELL:1305959}, dispersez-vous pour {SPELL:1285733}.|n• Ne touche pas aux kystes au sol.",
	RAID_BOSS_SSZORAK_TANK = "{SPELL:1277025} est un combo — garde un défensif pendant toute sa durée.",
	RAID_BOSS_TWINFANGS_STEPS = "• Le debuff de venin de chacun continue de monter ; place-toi dans {SPELL:1290516} pour le faire dévorer avant qu’il ne t’étourdisse.|n• Aide à absorber {SPELL:1288484}.|n• Esquive le frontal {SPELL:1294293}, tue les adds de {SPELL:1291404}.",
	RAID_BOSS_TWINFANGS_TANK = "Les debuffs de tank des deux boss ne doivent jamais se mélanger — garde ton boss, ne croise jamais.",
	RAID_BOSS_COILEDALTAR_STEPS = "• Laissez-vous de la place pour Guillotine.|n• Cassez le bouclier {SPELL:1286918}, esquive {SPELL:1283832}.|n• Si quelqu’un est contrôlé ({SPELL:1289900}), libérez la personne.|n• Trois phases ; à la fin gardez les vies des deux boss égales — l’un qui meurt trop tôt enrage l’autre.",
	RAID_BOSS_COILEDALTAR_HEALER = "Dissipe le poison : {SPELL:1282281}.",
	RAID_BOSS_ULATEK_STEPS = "• Fuis {SPELL:1301510}, esquive {SPELL:1302982} et {SPELL:1296301}.|n• Absorbe {SPELL:1300530} et {SPELL:1299757} — mais pas tant que tu portes {SPELL:1300685}.|n• Passe sur l'add {SPELL:1298559} dès qu'il apparaît ; {SPELL:1300751} en annonce d'autres.|n• {SPELL:1286860} et {SPELL:1292188} sont les fenêtres de dégâts sur le raid ; {SPELL:1292999} termine la phase.|n• {SPELL:1286905} dans la dernière phase est l'enrage doux — il ne s'arrête pas.",
	RAID_BOSS_CHIMAERUS_TANK = "• Rending Tear est un saignement + recul — orientez-le loin du raid et ne vous faites pas projeter hors de la plateforme ; échangez l'add Colossal Horror avec l'off-tank.",
	RAID_BOSS_CHIMAERUS_HEALER = "• Les dégâts montent en flèche pendant l'intermède (Corrupted Devastation / Ravenous Dive) et à chaque fois qu'un add atteint le boss — gardez les cooldowns pour ces fenêtres.",

	-- The Voidspire — Imperator Averzian -----------------------------------
	RAID_BOSS_AVERZIAN_STEPS = "• Un combat de territoire : les adds sont immunisés tant qu'ils ne sont pas touchés par {SPELL:1249265} (Umbral Collapse, un soak de groupe) — posez le soak sur les adds pour les rendre tuables.|n• Interrompez {SPELL:1255702}.|n• Tuez rapidement les adds Abyssal Voidshaper.",
	RAID_BOSS_AVERZIAN_HEALER = "• Le soak de groupe ({SPELL:1249265}) tombe sur tout le monde regroupé — remontez le raid avant chacun.",

	-- The Voidspire — Vorasius ---------------------------------------------
	RAID_BOSS_VORASIUS_STEPS = "• Il dresse des murs de cristal ; utilisez-les comme abri contre {SPELL:1243853} — restez derrière un mur quand il souffle.|n• Kitez les adds Blistercreep dans les murs pour les briser et ouvrir des couloirs sûrs.|n• Ses dégâts augmentent à chaque série de murs — gardez le rythme, c'est un soft enrage.",
	RAID_BOSS_VORASIUS_HEALER = "• Les dégâts au raid montent à chaque phase de murs (soft enrage) — répartissez vos cooldowns pour couvrir les dernières séries.",

	-- The Voidspire — Fallen-King Salhadaar --------------------------------
	RAID_BOSS_SALHADAAR_STEPS = "• {SPELL:1243453} fait apparaître des adds-orbes Concentrated Void — tuez-les avant qu'ils n'atteignent le boss.|n• À pleine énergie il lance {SPELL:1246175} : esquivez les rayons. Pendant ce temps il subit +25% de dégâts pendant ~20s — c'est votre fenêtre de burn.|n• Gardez les orbes sous contrôle et réservez le burst pour la fenêtre d'Unraveling.",
	RAID_BOSS_SALHADAAR_DPS = "• Gardez les cooldowns pour la fenêtre de {SPELL:1246175} (+25% de dégâts subis pendant ~20s) ; sinon, priorisez les orbes Concentrated Void sur le boss.",

	-- The Voidspire — Vaelgor & Ezzorak ------------------------------------
	RAID_BOSS_VAELGOR_STEPS = "Sortez de {SPELL:1244221} ; soakez {SPELL:1245391} avant que l'orbe ne touche un mur pour garder la salle ouverte.|n• Pendant l'intermède, restez dans {SPELL:1248847} pour survivre aux dégâts pulsés.",
	RAID_BOSS_VAELGOR_TANK = "• {SPELL:1262623} est un soak de tank cumulatif — gérez-le avec l'autre tank ; gardez les deux boss assez proches pour des dégâts équilibrés mais leurs frontaux pointés loin du raid.",
	RAID_BOSS_VAELGOR_HEALER = "• L'intermède pulse fort — assurez-vous que tout le monde est dans {SPELL:1248847}, et remontez avant chaque fenêtre de Twilight Bond.",

	-- The Voidspire — Lightblinded Vanguard --------------------------------
	RAID_BOSS_VANGUARD_STEPS = "À pleine énergie, un paladin lance une aura qui booste les deux autres — sortez les boss de la zone : {SPELL:1248449}, {SPELL:1246162}, {SPELL:1248451}.|n• Absorbez {SPELL:1276368} en groupe.|n• Esquivez {SPELL:1248652} ; les mêlées sortent de {SPELL:1246765}.|n• Briséz {SPELL:1248674}.|n• {SPELL:1246749} et {SPELL:1255738} sont les fenêtres de dégâts sur le raid ; les soigneurs surveillent les absorptions de {SPELL:1248721}.",
	RAID_BOSS_VANGUARD_TANK = "• {SPELL:1246736} impose l'échange de tank — échangez sur les stacks et gardez les trois paladins groupés pour le cleave mais hors de l'aura active.",

	-- The Voidspire — Crown of the Cosmos ----------------------------------
	RAID_BOSS_CROWN_STEPS = "• Le final : trois étapes avec intermèdes ({SPELL:1238843}), mettant en scène trois mini-boss (Xal'atath avec Turalyon, Arator et Alleria) avant la poussée finale.|n• Survivez à chaque intermède, puis burnez la cible active à chaque étape.|n• Passez sur les adds {SPELL:1237837} et brisez {SPELL:1246918}.|n• Esquivez {SPELL:1234564} et {SPELL:1243753} ; {SPELL:1283236} est un dégât de raid.|n• Tanks : {SPELL:1233787} et {SPELL:1246461} veulent tous deux une défensive.|n• Mythique seulement : {SPELL:1261339} amène un gros add.",

	-- March on Quel'Danas — Belo'ren, Child of Al'ar -----------------------
	RAID_BOSS_BELOREN_STEPS = "À 0 PV il ne meurt pas — {SPELL:1241313} le transforme en œuf au centre. L'œuf est la vraie barre de vie : burnez-le, puis le cycle recommence.|n• Activez vos orbes de votre couleur pour créer des espaces sûrs, et continuez à gérer les incantations assignées à votre couleur.|n• {SPELL:1242515} change ta couleur — vérifie-la avant de bouger.|n• Tuez les adds {SPELL:1241282} ; esquivez {SPELL:1242792} et les lignes {SPELL:1242260}.|n• Fuis {SPELL:1246709} ; {SPELL:1242981} envoie des orbes.|n• Tanks : {SPELL:1260763} est une combo.",

	-- March on Quel'Danas — Midnight Falls (L'ura) -------------------------
	RAID_BOSS_LURA_STEPS = "• Phase 1 (Death's Dirge) : cinq joueurs reçoivent des symboles Dark Rune dans un ordre défini — le laser rotatif doit toucher ces joueurs dans ce même ordre, donc annoncez-le.|n• Phase 2 (Void Cores) : des rayons (Galvanize) tombent sur quatre joueurs — dirigez-les vers les Void Cores pour les faire détoner ; un noyau endommagé s'ouvre et vous aspire.|n• The Darkwell au centre est une mort instantanée ; Total Eclipse attire tout le monde vers lui, et l'anneau extérieur (Iris of Oblivion) tue quiconque quitte l'arène. Esquivez les pointes de Starsplinter.|n• Sorts clés : interrompez {SPELL:1251386}, esquivez {SPELL:1253915} & {SPELL:1279420}, déplacez {SPELL:1250898} loin, et utilisez un défensif pour le recul {SPELL:1281194} et l'intermède {SPELL:1282047}. (Timeline EXBoss — à confirmer en jeu.)",
	RAID_BOSS_LURA_TANK = "• Heaven's Lance se cumule jusqu'à 5 puis applique Impale (+50% de dégâts pendant ~25s) — échangez avec l'off-tank à chaque cycle avant qu'Impale ne tombe.",
})

merge(ns._mhLocales and ns._mhLocales.esES, {
	-- The Dreamrift — Chimaerus, the Undreamt God ---------------------------
	RAID_BOSS_CHIMAERUS_STEPS = "• Mecánica de energía: los adds caminan hacia Chimaerus — mátalos antes de que lleguen. Si uno lo alcanza, gana un gran bonus de daño, y a energía máxima devora a un add para un casi-wipe.|n• Interrumpe {SPELL:1249017} — el lanzamiento del invocador de Haunting Essence es el kick prioritario.|n• Mata rápido al add Colossal Horror; su daño no para de subir.|n• Soakea/divídete para Alndust Upheaval (el raid se divide en dos grupos) y esquiva las líneas de Corrupted Devastation durante el interludio.|n• En Mítico se añaden Dissonance (no te quedes cerca de jugadores en fase opuesta) y Rift Madness (un debuff que hay que soakear/intercambiar).|n• Esquivad el frontal {SPELL:1272726} y el aliento {SPELL:1245452}; absorbed {SPELL:1262289} en grupo.|n• {SPELL:1245404} cambia de fase; matad los adds de {SPELL:1251021}.|n• Los sanadores disipan {SPELL:1257087}; en Mítico {SPELL:1264780} intercambia jugadores.",
	RAID_PRERELEASE_NOTE = "Escrito antes de la apertura de la banda (18 ago), a partir de los módulos de DBM y del diario del propio juego. Nada aquí es inventado, pero nada se ha recorrido aún — contrástalo con el combate.",
	RAID_BOSS_NEKZALI_STEPS = "• Sal corriendo cuando salga {SPELL:1284103} — los tanques cambian en ese mismo lanzamiento.|n• Matad rápido los adds de {SPELL:1297630}.|n• Absorbed {SPELL:1305421} en grupo.|n• {SPELL:1287426} deja una línea sobre alguien — sal de ella.|n• {SPELL:1299673} anuncia la siguiente especial; {SPELL:1298698} golpea a todo el raid.|n• Solo mítico: {SPELL:1293212} te arrastra dentro.",
	RAID_BOSS_NEKZALI_TANK = "Cambio de provocación tras cada {SPELL:1284103}.",
	RAID_BOSS_ENTOMBEDSENT_STEPS = "• Dos gólems: mantenlos bien separados — juntos apenas reciben daño.|n• {SPELL:1284588} es el puzle de acumulaciones; desactívalo sobre una orbe de {SPELL:1284434}.|n• Absorbed {SPELL:1288232} en grupo y quemad los adds grandes de {SPELL:1284251}.|n• Solo mítico: {SPELL:1296878} cambia qué lado es seguro — mira el color.",
	RAID_BOSS_ENTOMBEDSENT_TANK = "Cambio con {SPELL:1284458} y {SPELL:1284487}; ambos piden un defensivo.",
	RAID_BOSS_ENTOMBEDSENT_HEALER = "Disipa {SPELL:1284483} — cuando se pida, no a la vista.",
	RAID_BOSS_LOSTEXPLORERS_STEPS = "• Interrumpe {SPELL:1286921}.|n• El suelo es la pelea: esquiva {SPELL:1291759}, {SPELL:1291933} y {SPELL:1292104}.|n• {SPELL:1290711}: nuestras dos fuentes se contradicen — separarse o juntarse — sigue la indicación de tu líder.|n• Da Disgusting Fish a los Tortollan poseídos para romper la posesión.",
	RAID_BOSS_VASHNIK_STEPS = "• Cuando bebe ({SPELL:1283164}), los adds de veneno se arrastran al centro — matadlos antes de que lleguen.|n• Lleva {SPELL:1281907} lejos del grupo.|n• Ayuda a absorber {SPELL:1282509}.|n• {SPELL:1282114} es la fase de debuffs — mira cuál te tocó antes de moverte.|n• Esquiva {SPELL:1302489}.",
	RAID_BOSS_VASHNIK_TANK = "Defensivo con {SPELL:1280935}.",
	RAID_BOSS_SSZORAK_STEPS = "• El viento es el enemigo: {SPELL:1285732} te empuja — vigila lo que tienes detrás.|n• Esquiva {SPELL:1305959}, sepárate para {SPELL:1285733}.|n• No toques los quistes del suelo.",
	RAID_BOSS_SSZORAK_TANK = "{SPELL:1277025} es un combo — mantén un defensivo durante todo.",
	RAID_BOSS_TWINFANGS_STEPS = "• El debuff de veneno de todos sigue acumulándose; ponte en {SPELL:1290516} para que se lo coman antes de que te aturda.|n• Ayuda a absorber {SPELL:1288484}.|n• Esquiva el frontal de {SPELL:1294293}, mata a los adds de {SPELL:1291404}.",
	RAID_BOSS_TWINFANGS_TANK = "Los debuffs de tanque de los dos jefes no deben mezclarse nunca — quédate con tu jefe, nunca los cruces.",
	RAID_BOSS_COILEDALTAR_STEPS = "• Daos espacio en Guillotine.|n• Romped el escudo de {SPELL:1286918}, esquiva {SPELL:1283832}.|n• Si controlan a alguien ({SPELL:1289900}), liberadle.|n• Tres fases; al final mantened las vidas de ambos jefes igualadas — si uno muere antes, el otro se enfurece.",
	RAID_BOSS_COILEDALTAR_HEALER = "Disipa el veneno: {SPELL:1282281}.",
	RAID_BOSS_ULATEK_STEPS = "• Huye de {SPELL:1301510}, esquiva {SPELL:1302982} y {SPELL:1296301}.|n• Absorbe {SPELL:1300530} y {SPELL:1299757} — pero no mientras lleves {SPELL:1300685}.|n• Cámbiate al add de {SPELL:1298559} en cuanto aparezca; {SPELL:1300751} anuncia más.|n• {SPELL:1286860} y {SPELL:1292188} son las ventanas de daño al raid; {SPELL:1292999} cierra la fase.|n• {SPELL:1286905} en la última fase es el enrage suave — no para.",
	RAID_BOSS_CHIMAERUS_TANK = "• Rending Tear es un sangrado + empuje — oriéntalo lejos del raid y no dejes que te empuje fuera de la plataforma; intercambia el add Colossal Horror con el off-tank.",
	RAID_BOSS_CHIMAERUS_HEALER = "• El daño se dispara durante el interludio (Corrupted Devastation / Ravenous Dive) y cada vez que un add alcanza al jefe — guarda los cooldowns para esas ventanas.",

	-- The Voidspire — Imperator Averzian -----------------------------------
	RAID_BOSS_AVERZIAN_STEPS = "• Un combate de territorio: los adds son inmunes hasta que los golpea {SPELL:1249265} (Umbral Collapse, un soak de grupo) — suelta el soak encima de los adds para hacerlos matables.|n• Interrumpe {SPELL:1255702}.|n• Mata sin demora a los adds Abyssal Voidshaper.",
	RAID_BOSS_AVERZIAN_HEALER = "• El soak de grupo ({SPELL:1249265}) cae sobre todos apilados juntos — sube la vida del raid antes de cada uno.",

	-- The Voidspire — Vorasius ---------------------------------------------
	RAID_BOSS_VORASIUS_STEPS = "• Levanta muros de cristal; úsalos como cobertura contra {SPELL:1243853} — colócate detrás de un muro cuando respire.|n• Kitea a los adds Blistercreep hacia los muros para romperlos y abrir carriles seguros.|n• Su daño aumenta con cada serie de muros — mantén el ritmo, es un soft enrage.",
	RAID_BOSS_VORASIUS_HEALER = "• El daño al raid sube con cada fase de muros (soft enrage) — dosifica tus cooldowns para cubrir las últimas series.",

	-- The Voidspire — Fallen-King Salhadaar --------------------------------
	RAID_BOSS_SALHADAAR_STEPS = "• {SPELL:1243453} genera adds-orbe Concentrated Void — mátalos antes de que lleguen al jefe.|n• A energía máxima lanza {SPELL:1246175}: esquiva los rayos. Durante eso recibe +25% de daño durante ~20s — esa es tu ventana de burn.|n• Mantén los orbes bajo control y guarda el burst para la ventana de Unraveling.",
	RAID_BOSS_SALHADAAR_DPS = "• Reserva los cooldowns para la ventana de {SPELL:1246175} (+25% de daño recibido durante ~20s); de lo contrario, prioriza los orbes Concentrated Void sobre el jefe.",

	-- The Voidspire — Vaelgor & Ezzorak ------------------------------------
	RAID_BOSS_VAELGOR_STEPS = "Sal de {SPELL:1244221}; soakea {SPELL:1245391} antes de que el orbe toque un muro para mantener la sala abierta.|n• Durante el interludio, colócate dentro de {SPELL:1248847} para sobrevivir al daño pulsante.",
	RAID_BOSS_VAELGOR_TANK = "• {SPELL:1262623} es un soak de tanque acumulable — gestiónalo con el otro tanque; mantén a los dos jefes lo bastante cerca para un daño parejo pero con sus frontales apuntando lejos del raid.",
	RAID_BOSS_VAELGOR_HEALER = "• El interludio pulsa fuerte — asegúrate de que todos estén dentro de {SPELL:1248847}, y sube la vida antes de cada ventana de Twilight Bond.",

	-- The Voidspire — Lightblinded Vanguard --------------------------------
	RAID_BOSS_VANGUARD_STEPS = "A energía máxima un paladín lanza un aura que potencia a los otros dos — saca a los jefes de ella: {SPELL:1248449}, {SPELL:1246162}, {SPELL:1248451}.|n• Absorbed {SPELL:1276368} en grupo.|n• Esquivad {SPELL:1248652}; los cuerpo a cuerpo salen de {SPELL:1246765}.|n• Romped {SPELL:1248674}.|n• {SPELL:1246749} y {SPELL:1255738} son las ventanas de daño al raid; los sanadores vigilan los absorbentes de {SPELL:1248721}.",
	RAID_BOSS_VANGUARD_TANK = "• {SPELL:1246736} marca el cambio de tanque — intercambia en los stacks y mantén a los tres paladines agrupados para el cleave pero fuera del aura activa.",

	-- The Voidspire — Crown of the Cosmos ----------------------------------
	RAID_BOSS_CROWN_STEPS = "• El final: tres fases con interludios ({SPELL:1238843}), con tres mini-jefes (Xal'atath con Turalyon, Arator y Alleria) antes del empuje final.|n• Sobrevive a cada interludio y luego quema al objetivo activo en cada fase.|n• Cambiad a los adds de {SPELL:1237837} y romped {SPELL:1246918}.|n• Esquivad {SPELL:1234564} y {SPELL:1243753}; {SPELL:1283236} es daño al raid.|n• Tanques: {SPELL:1233787} y {SPELL:1246461} quieren defensiva.|n• Solo mítico: {SPELL:1261339} trae un add grande.",

	-- March on Quel'Danas — Belo'ren, Child of Al'ar -----------------------
	RAID_BOSS_BELOREN_STEPS = "A 0 de vida no muere — {SPELL:1241313} lo convierte en un huevo en el centro. El huevo es la barra de vida real: quémalo, y luego el ciclo se repite.|n• Activa tus orbes de tu color para crear huecos seguros, y sigue gestionando los lanzamientos asignados a tu color.|n• {SPELL:1242515} te cambia el color — míralo antes de moverte.|n• Matad los adds de {SPELL:1241282}; esquivad {SPELL:1242792} y las líneas de {SPELL:1242260}.|n• Huye de {SPELL:1246709}; {SPELL:1242981} lanza orbes.|n• Tanques: {SPELL:1260763} es una combo.",

	-- March on Quel'Danas — Midnight Falls (L'ura) -------------------------
	RAID_BOSS_LURA_STEPS = "• Fase 1 (Death's Dirge): cinco jugadores reciben símbolos Dark Rune en un orden fijo — el láser giratorio debe golpear a esos jugadores en ese mismo orden, así que cántalo.|n• Fase 2 (Void Cores): rayos (Galvanize) caen sobre cuatro jugadores — apúntalos hacia los Void Cores para detonarlos; un núcleo dañado se abre y te succiona.|n• The Darkwell en el centro es muerte instantánea; Total Eclipse atrae a todos hacia él, y el anillo exterior (Iris of Oblivion) mata a quien salga de la arena. Esquiva las púas de Starsplinter.|n• Hechizos clave: interrumpe {SPELL:1251386}, esquiva {SPELL:1253915} & {SPELL:1279420}, mueve {SPELL:1250898} lejos, y usa un defensivo para el empuje {SPELL:1281194} y el interludio {SPELL:1282047}. (Timeline de EXBoss — confirmar en el juego.)",
	RAID_BOSS_LURA_TANK = "• Heaven's Lance se acumula hasta 5 y luego aplica Impale (+50% de daño durante ~25s) — intercambia con el off-tank cada ciclo antes de que Impale caiga.",
})

merge(ns._mhLocales and ns._mhLocales.ptBR, {
	-- The Dreamrift — Chimaerus, the Undreamt God ---------------------------
	RAID_BOSS_CHIMAERUS_STEPS = "• Mecânica de energia: os adds caminham até Chimaerus — mate-os antes que cheguem. Se um o alcançar, ele ganha um grande bônus de dano, e com energia cheia devora um add para um quase-wipe.|n• Interrompa {SPELL:1249017} — a conjuração do invocador de Haunting Essence é o kick prioritário.|n• Mate rápido o add Colossal Horror; o dano dele só aumenta.|n• Soake/divida-se para Alndust Upheaval (o raide é dividido em dois grupos) e desvie das linhas de Corrupted Devastation durante o interlúdio.|n• No Mítico entram Dissonance (não fique perto de jogadores na fase oposta) e Rift Madness (um debuff que precisa ser soakado/trocado).|n• Desviem do frontal {SPELL:1272726} e do sopro {SPELL:1245452}; absorvam {SPELL:1262289} em grupo.|n• {SPELL:1245404} muda de fase; matem os adds de {SPELL:1251021}.|n• Os curandeiros dissipam {SPELL:1257087}; no Mítico {SPELL:1264780} troca jogadores.",
	RAID_PRERELEASE_NOTE = "Escrito antes da abertura da raid (18 ago), a partir dos módulos do DBM e do diário do próprio jogo. Nada aqui é inventado, mas nada foi ainda percorrido — confirma no combate.",
	RAID_BOSS_NEKZALI_STEPS = "• Corra para fora quando {SPELL:1284103} sair — os tanques trocam nesse mesmo lançamento.|n• Matem rápido os adds de {SPELL:1297630}.|n• Absorvam {SPELL:1305421} em grupo.|n• {SPELL:1287426} deixa uma linha em alguém — saia dela.|n• {SPELL:1299673} anuncia a próxima especial; {SPELL:1298698} atinge o raide inteiro.|n• Só no mítico: {SPELL:1293212} te puxa para dentro.",
	RAID_BOSS_NEKZALI_TANK = "Troca de provocação depois de cada {SPELL:1284103}.",
	RAID_BOSS_ENTOMBEDSENT_STEPS = "• Dois golens: mantenham-nos bem afastados — juntos quase não sofrem dano.|n• {SPELL:1284588} é o quebra-cabeça de acumulações; desarme-o sobre uma orbe de {SPELL:1284434}.|n• Absorvam {SPELL:1288232} em grupo e queimem os adds grandes de {SPELL:1284251}.|n• Só no mítico: {SPELL:1296878} muda qual lado é seguro — olhem a cor.",
	RAID_BOSS_ENTOMBEDSENT_TANK = "Troca em {SPELL:1284458} e {SPELL:1284487}; ambos pedem um defensivo.",
	RAID_BOSS_ENTOMBEDSENT_HEALER = "Dissipa {SPELL:1284483} — quando pedido, não à vista.",
	RAID_BOSS_LOSTEXPLORERS_STEPS = "• Interrompe {SPELL:1286921}.|n• O chão é a luta: desvia de {SPELL:1291759}, {SPELL:1291933} e {SPELL:1292104}.|n• {SPELL:1290711}: as nossas duas fontes contradizem-se — afastar ou juntar — segue a indicação do teu líder.|n• Dá Disgusting Fish aos Tortollans possuídos para quebrar a possessão.",
	RAID_BOSS_VASHNIK_STEPS = "• Quando ele bebe ({SPELL:1283164}), adds de veneno rastejam para o centro — matem antes que cheguem.|n• Leve {SPELL:1281907} para longe do grupo.|n• Ajude a absorver {SPELL:1282509}.|n• {SPELL:1282114} é a fase de debuffs — veja qual você recebeu antes de se mover.|n• Desvie de {SPELL:1302489}.",
	RAID_BOSS_VASHNIK_TANK = "Defensivo em {SPELL:1280935}.",
	RAID_BOSS_SSZORAK_STEPS = "• O vento é o inimigo: {SPELL:1285732} empurra-te — repara no que está atrás de ti.|n• Desvia de {SPELL:1305959}, espalha-te para {SPELL:1285733}.|n• Não toques nos quistos no chão.",
	RAID_BOSS_SSZORAK_TANK = "{SPELL:1277025} é um combo — mantém um defensivo durante tudo.",
	RAID_BOSS_TWINFANGS_STEPS = "• O debuff de veneno de todos continua a acumular; fica em {SPELL:1290516} para que seja devorado antes de te atordoar.|n• Ajuda a absorver {SPELL:1288484}.|n• Desvia do frontal de {SPELL:1294293}, mata os adds de {SPELL:1291404}.",
	RAID_BOSS_TWINFANGS_TANK = "Os debuffs de tanque dos dois chefes nunca se podem misturar — fica com o teu chefe, nunca cruzes.",
	RAID_BOSS_COILEDALTAR_STEPS = "• Deem espaço uns aos outros na Guillotine.|n• Partam o escudo de {SPELL:1286918}, desvia de {SPELL:1283832}.|n• Se alguém for controlado ({SPELL:1289900}), libertem essa pessoa.|n• Três fases; no fim mantenham as vidas dos dois chefes iguais — se um morrer cedo, o outro enfurece.",
	RAID_BOSS_COILEDALTAR_HEALER = "Dissipa o veneno: {SPELL:1282281}.",
	RAID_BOSS_ULATEK_STEPS = "• Fuja de {SPELL:1301510}, desvie de {SPELL:1302982} e {SPELL:1296301}.|n• Absorva {SPELL:1300530} e {SPELL:1299757} — mas não enquanto estiver com {SPELL:1300685}.|n• Troque para o add de {SPELL:1298559} assim que surgir; {SPELL:1300751} anuncia mais.|n• {SPELL:1286860} e {SPELL:1292188} são as janelas de dano no raide; {SPELL:1292999} encerra a fase.|n• {SPELL:1286905} na última fase é o enrage suave — ele não para.",
	RAID_BOSS_CHIMAERUS_TANK = "• Rending Tear é um sangramento + empurrão — vire-o para longe do raide e não seja jogado para fora da plataforma; troque o add Colossal Horror com o off-tank.",
	RAID_BOSS_CHIMAERUS_HEALER = "• O dano dispara durante o interlúdio (Corrupted Devastation / Ravenous Dive) e cada vez que um add alcança o chefe — guarde os cooldowns para essas janelas.",

	-- The Voidspire — Imperator Averzian -----------------------------------
	RAID_BOSS_AVERZIAN_STEPS = "• Uma luta de território: os adds são imunes até serem atingidos por {SPELL:1249265} (Umbral Collapse, um soak de grupo) — solte o soak em cima dos adds para torná-los matáveis.|n• Interrompa {SPELL:1255702}.|n• Mate prontamente os adds Abyssal Voidshaper.",
	RAID_BOSS_AVERZIAN_HEALER = "• O soak de grupo ({SPELL:1249265}) cai sobre todos agrupados juntos — encha a vida do raide antes de cada um.",

	-- The Voidspire — Vorasius ---------------------------------------------
	RAID_BOSS_VORASIUS_STEPS = "• Ele ergue paredes de cristal; use-as como cobertura contra {SPELL:1243853} — fique atrás de uma parede quando ele sopra.|n• Kite os adds Blistercreep nas paredes para quebrá-las e abrir corredores seguros.|n• O dano dele aumenta a cada conjunto de paredes — mantenha o ritmo, é um soft enrage.",
	RAID_BOSS_VORASIUS_HEALER = "• O dano ao raide sobe a cada fase de paredes (soft enrage) — distribua seus cooldowns para cobrir os conjuntos finais.",

	-- The Voidspire — Fallen-King Salhadaar --------------------------------
	RAID_BOSS_SALHADAAR_STEPS = "• {SPELL:1243453} gera adds-orbe Concentrated Void — mate-os antes que cheguem ao chefe.|n• Com energia cheia ele conjura {SPELL:1246175}: desvie dos feixes. Durante isso ele recebe +25% de dano por ~20s — essa é sua janela de burn.|n• Mantenha os orbes sob controle e guarde o burst para a janela de Unraveling.",
	RAID_BOSS_SALHADAAR_DPS = "• Segure os cooldowns para a janela de {SPELL:1246175} (+25% de dano recebido por ~20s); caso contrário, priorize os orbes Concentrated Void sobre o chefe.",

	-- The Voidspire — Vaelgor & Ezzorak ------------------------------------
	RAID_BOSS_VAELGOR_STEPS = "Saia de {SPELL:1244221}; soake {SPELL:1245391} antes que o orbe atinja uma parede para manter a sala aberta.|n• Durante o interlúdio, fique dentro de {SPELL:1248847} para sobreviver ao dano pulsante.",
	RAID_BOSS_VAELGOR_TANK = "• {SPELL:1262623} é um soak de tank acumulável — gerencie-o com o outro tank; mantenha os dois chefes próximos o bastante para dano equilibrado, mas com os frontais apontados para longe do raide.",
	RAID_BOSS_VAELGOR_HEALER = "• O interlúdio pulsa forte — garanta que todos estejam dentro de {SPELL:1248847}, e encha a vida antes de cada janela de Twilight Bond.",

	-- The Voidspire — Lightblinded Vanguard --------------------------------
	RAID_BOSS_VANGUARD_STEPS = "Com energia cheia um paladino conjura uma aura que fortalece os outros dois — arraste os chefes para fora dela: {SPELL:1248449}, {SPELL:1246162}, {SPELL:1248451}.|n• Absorvam {SPELL:1276368} em grupo.|n• Desviem de {SPELL:1248652}; os corpo a corpo saem de {SPELL:1246765}.|n• Quebrem {SPELL:1248674}.|n• {SPELL:1246749} e {SPELL:1255738} são as janelas de dano no raide; os curandeiros olham os absorves de {SPELL:1248721}.",
	RAID_BOSS_VANGUARD_TANK = "• {SPELL:1246736} impõe a troca de tank — troque nos stacks e mantenha os três paladinos agrupados para o cleave, mas fora da aura ativa.",

	-- The Voidspire — Crown of the Cosmos ----------------------------------
	RAID_BOSS_CROWN_STEPS = "• O final: três estágios com interlúdios ({SPELL:1238843}), apresentando três mini-chefes (Xal'atath com Turalyon, Arator e Alleria) antes do avanço final.|n• Sobreviva a cada interlúdio e então queime o alvo ativo em cada estágio.|n• Troquem para os adds de {SPELL:1237837} e quebrem {SPELL:1246918}.|n• Desviem de {SPELL:1234564} e {SPELL:1243753}; {SPELL:1283236} é dano no raide.|n• Tanques: {SPELL:1233787} e {SPELL:1246461} querem defensiva.|n• Só no mítico: {SPELL:1261339} traz um add grande.",

	-- March on Quel'Danas — Belo'ren, Child of Al'ar -----------------------
	RAID_BOSS_BELOREN_STEPS = "Com 0 de vida ele não morre — {SPELL:1241313} o transforma em um ovo no centro. O ovo é a barra de vida real: queime-o, e então o ciclo se repete.|n• Ative seus orbes da sua cor para criar brechas seguras, e continue lidando com as conjurações atribuídas à sua cor.|n• {SPELL:1242515} troca a sua cor — confira antes de se mover.|n• Matem os adds de {SPELL:1241282}; desviem de {SPELL:1242792} e das linhas de {SPELL:1242260}.|n• Fuja de {SPELL:1246709}; {SPELL:1242981} manda orbes para fora.|n• Tanques: {SPELL:1260763} é uma combo.",

	-- March on Quel'Danas — Midnight Falls (L'ura) -------------------------
	RAID_BOSS_LURA_STEPS = "• Fase 1 (Death's Dirge): cinco jogadores recebem símbolos Dark Rune em uma ordem definida — o laser rotativo deve atingir esses jogadores nessa mesma ordem, então anuncie.|n• Fase 2 (Void Cores): feixes (Galvanize) caem sobre quatro jogadores — mire-os nos Void Cores para detoná-los; um núcleo danificado se abre e te puxa para dentro.|n• The Darkwell no centro é morte instantânea; Total Eclipse atrai todos para ele, e o anel externo (Iris of Oblivion) mata quem sair da arena. Desvie das pontas de Starsplinter.|n• Magias-chave: interrompa {SPELL:1251386}, desvie de {SPELL:1253915} & {SPELL:1279420}, mova {SPELL:1250898} para longe, e use um defensivo para o knockback {SPELL:1281194} e o interlúdio {SPELL:1282047}. (Timeline EXBoss — confirmar no jogo.)",
	RAID_BOSS_LURA_TANK = "• Heaven's Lance acumula até 5 e então aplica Impale (+50% de dano por ~25s) — troque com o off-tank a cada ciclo antes de Impale cair.",
})
