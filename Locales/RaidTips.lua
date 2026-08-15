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
	RAID_BOSS_CHIMAERUS_STEPS = "• Energy mechanic: adds walk toward Chimaerus — kill them before they arrive. If one reaches him he gains a big damage buff, and at full energy he devours an add for a near-wipe.|n• Interrupt {SPELL:1249017} — the Haunting Essence caster's cast is the priority kick.|n• Kill the Colossal Horror add fast; its damage keeps climbing.|n• Soak/split for Alndust Upheaval (the raid is divided into two groups) and dodge the Corrupted Devastation lines during the intermission.|n• Mythic adds Dissonance (don't stand near opposite-phase players) and Rift Madness (a debuff that must be soaked/swapped).|n• Key casts: dodge {SPELL:1245452} & {SPELL:1282856}, brace for the knockback {SPELL:1245404}, save a defensive for {SPELL:1268905}, and heavy AoE on {SPELL:1251021}. (EXBoss timeline — confirm in-game.)",
	RAID_PRERELEASE_NOTE = "Written before the raid opened (18 Aug), from DBM’s encounter modules and the game’s own journal. Nothing here is invented, but none of it has been walked yet — verify against the fight.",
	RAID_BOSS_NEKZALI_STEPS = "• Run out when {SPELL:1284103} fires, and keep dodging {SPELL:1294933}.|n• Kill the {SPELL:1297630} adds quickly.|n• Help soak Hungering Pyre when your group calls it.|n• At half health {SPELL:1299673} changes his pattern — the rhythm changes, the rules do not.",
	RAID_BOSS_NEKZALI_TANK = "Taunt-swap after every {SPELL:1284103}.",
	RAID_BOSS_ENTOMBEDSENT_STEPS = "• Two golems: keep them far apart — close together they barely take damage.|n• Your {SPELL:1284590} debuff wants exactly four stacks; then stand on a {SPELL:1284434} droplet to defuse it.|n• Keep moving through {SPELL:1284485} — this fight is positioning, not a race.",
	RAID_BOSS_ENTOMBEDSENT_TANK = "Swap on {SPELL:1284458} and {SPELL:1284487}; both want a defensive.",
	RAID_BOSS_ENTOMBEDSENT_HEALER = "Dispel {SPELL:1284483} — on call, not on sight.",
	RAID_BOSS_LOSTEXPLORERS_STEPS = "• Interrupt {SPELL:1286921}.|n• The floor is the fight: dodge {SPELL:1291759}, {SPELL:1291933} and {SPELL:1295886}.|n• {SPELL:1290711}: our two sources disagree — run out or stack up — so follow your leader’s call.|n• Feed Disgusting Fish to possessed Tortollans to break the possession.",
	RAID_BOSS_VASHNIK_STEPS = "• When he drinks ({SPELL:1283164}), venom adds crawl toward the centre — kill them before they arrive.|n• Carry {SPELL:1281907} away from the group.|n• Help soak {SPELL:1282509}.|n• Dodge {SPELL:1294994} and {SPELL:1302489}.",
	RAID_BOSS_VASHNIK_TANK = "Defensive on {SPELL:1280935}.",
	RAID_BOSS_SSZORAK_STEPS = "• Wind is the enemy: {SPELL:1285732} pushes you — mind what is behind you.|n• Dodge {SPELL:1305959}, spread for {SPELL:1285733}.|n• Do not touch the cysts on the floor.",
	RAID_BOSS_SSZORAK_TANK = "{SPELL:1285430} is a combo — hold a defensive through all of it.",
	RAID_BOSS_TWINFANGS_STEPS = "• Everyone’s venom debuff keeps stacking; stand in {SPELL:1290516} to get it eaten before it stuns you.|n• Help soak {SPELL:1288484}.|n• Dodge the {SPELL:1294293} frontal, kill the {SPELL:1291404} adds.",
	RAID_BOSS_TWINFANGS_TANK = "The two bosses’ tank debuffs must never mix — keep your own boss, never cross.",
	RAID_BOSS_COILEDALTAR_STEPS = "• Give each other room at Guillotine.|n• Break the {SPELL:1286918} shield, dodge {SPELL:1283832}.|n• When someone is mind-controlled ({SPELL:1289900}), free them.|n• Three stages; at the end keep both bosses’ health even — one dying early enrages the other.",
	RAID_BOSS_COILEDALTAR_HEALER = "Dispel poison: {SPELL:1282281}.",
	RAID_BOSS_ULATEK_STEPS = "• Dodge {SPELL:1292403}, stack for {SPELL:1287265}.|n• During {SPELL:1286860} her Venomous Heart is exposed — burn it.|n• Interrupt {SPELL:1290779} on the adds.|n• At the end the platform breaks apart: stand on what remains.|n• She never appeared on the PTR, so expect surprises — this page will be corrected from real pulls.",
	RAID_BOSS_CHIMAERUS_TANK = "• Rending Tear is a bleed + knockback — face him away from the raid and don't get knocked off the platform; trade the Colossal Horror add with the off-tank.",
	RAID_BOSS_CHIMAERUS_HEALER = "• Damage spikes during the intermission (Corrupted Devastation / Ravenous Dive) and each time an add reaches the boss — save cooldowns for those windows.",

	-- The Voidspire — Imperator Averzian -----------------------------------
	RAID_BOSS_AVERZIAN_STEPS = "• A territory fight: adds are immune until hit by {SPELL:1249262} (Umbral Collapse, a group soak) — drop the soak on top of the adds to make them killable.|n• Never let three portals empower each other: that casts {SPELL:1251583}, the wipe.|n• Interrupt {SPELL:1255702}.|n• Kill the Abyssal Voidshaper adds promptly.|n• Key casts: dodge {SPELL:1258880} & {SPELL:1260712}, soak {SPELL:1249265}, and kill the adds ({SPELL:1283069}). (EXBoss timeline — confirm in-game.)",
	RAID_BOSS_AVERZIAN_HEALER = "• The group soak ({SPELL:1249262}) lands on everyone stacked together — top the raid before each one.",

	-- The Voidspire — Vorasius ---------------------------------------------
	RAID_BOSS_VORASIUS_STEPS = "• He raises crystal walls; use them as cover from {SPELL:1256855} — stand behind a wall when he breathes.|n• Kite the Blistercreep adds into the walls to break them and open safe lanes.|n• His damage ramps with every wall set — keep the tempo up, it's a soft enrage.|n• Key casts: dodge {SPELL:1243853}, and spread for the AoE ({SPELL:1254199} / {SPELL:1260046}). (EXBoss timeline — confirm in-game.)",
	RAID_BOSS_VORASIUS_HEALER = "• Raid damage climbs with each wall phase (soft enrage) — pace your cooldowns so the later sets are covered.",

	-- The Voidspire — Fallen-King Salhadaar --------------------------------
	RAID_BOSS_SALHADAAR_STEPS = "• {SPELL:1247738} spawns Concentrated Void orb-adds — kill them before they reach the boss.|n• At full energy he casts {SPELL:1246175}: dodge the beams. During it he takes +25% damage for ~20s — that's your burn window.|n• Keep the orbs under control and save burst for the Unraveling window.|n• Key casts: interrupt {SPELL:1254081}, dodge {SPELL:1253911}, and kill the adds ({SPELL:1243453}). (EXBoss timeline — confirm in-game.)",
	RAID_BOSS_SALHADAAR_DPS = "• Hold cooldowns for the {SPELL:1246175} window (+25% damage taken for ~20s); otherwise prioritise the Concentrated Void orbs over the boss.",

	-- The Voidspire — Vaelgor & Ezzorak ------------------------------------
	RAID_BOSS_VAELGOR_STEPS = "• Two bosses — keep their health close: {SPELL:1270189} means you must split damage evenly, or they gain a big buff (the soft enrage).|n• Run out with {SPELL:1244221}; soak {SPELL:1245391} before the orb hits a wall to keep the room open.|n• During the intermission, stand inside {SPELL:1248847} to survive the pulsing damage.|n• Key casts: run out of the frontals ({SPELL:1277471} / {SPELL:1277472}), kill the adds ({SPELL:1244917} / {SPELL:1277473}); healers watch {SPELL:1249748}. (EXBoss timeline — confirm in-game.)",
	RAID_BOSS_VAELGOR_TANK = "• {SPELL:1262623} is a stacking tank soak — manage it with the other tank; keep the two bosses close enough for even damage but their frontals pointed away from the raid.",
	RAID_BOSS_VAELGOR_HEALER = "• The intermission pulses hard — make sure everyone is inside {SPELL:1248847}, and top up before each Twilight Bond window.",

	-- The Voidspire — Lightblinded Vanguard --------------------------------
	RAID_BOSS_VANGUARD_STEPS = "• Three paladins fought together: {SPELL:1248983} is the dangerous cast to handle.|n• At full energy one paladin casts an aura buffing the other two — drag the bosses out of it: {SPELL:1248449}, {SPELL:1246162}, {SPELL:1248451}.|n• Key casts: dodge {SPELL:1248644}, soak {SPELL:1276368}, spread for {SPELL:1246485}, run out of the frontal {SPELL:1249130}; healers watch {SPELL:1276831}. (EXBoss timeline — confirm in-game.)",
	RAID_BOSS_VANGUARD_TANK = "• {SPELL:1246736} drives the tank swap — trade on the stacks and keep the three paladins grouped for cleave but out of the active aura.",

	-- The Voidspire — Crown of the Cosmos ----------------------------------
	RAID_BOSS_CROWN_STEPS = "• The finale: three stages with intermissions ({SPELL:1238843}), featuring three mini-bosses (Xal'atath with Turalyon, Arator and Alleria) before the final push.|n• Survive each intermission, then burn the active target in each stage.|n• Key casts: dodge {SPELL:1234564} & {SPELL:1235622}, drop {SPELL:1233819} away from the group, kill the adds ({SPELL:1261016} / {SPELL:1261339}), and push through the end enrage ({SPELL:1239582}). (Ability data from the EXBoss timeline — confirm in-game.)",

	-- March on Quel'Danas — Belo'ren, Child of Al'ar -----------------------
	RAID_BOSS_BELOREN_STEPS = "• You're split by color at the start: {SPELL:1241162} and {SPELL:1241163} — you can only interact with mechanics matching your color, so learn which side you're on.|n• At 0 HP he doesn't die — {SPELL:1241313} turns him into an egg in the center. The egg is the real health bar: burst it down, then the cycle repeats.|n• Pop your color-matched orbs to make safe gaps, and keep handling the casts your color is assigned.|n• Key casts: dodge {SPELL:1242792}, soak {SPELL:1241292} / {SPELL:1241339}, move {SPELL:1246709} away, use a defensive for {SPELL:1244344}, and push the enrage {SPELL:1241267}. (EXBoss timeline — confirm in-game.)",

	-- March on Quel'Danas — Midnight Falls (L'ura) -------------------------
	RAID_BOSS_LURA_STEPS = "• Phase 1 (Death's Dirge): five players get Dark Rune symbols in a set order — the rotating laser must hit those players in that same order, so call it out.|n• Phase 2 (Void Cores): beams (Galvanize) land on four players — aim them at the Void Cores to detonate them; a damaged core opens and pulls you in.|n• The Darkwell in the center is instant death; Total Eclipse pulls everyone toward it, and the outer ring (Iris of Oblivion) kills anyone who leaves the arena. Dodge the Starsplinter spikes.|n• Key casts: interrupt {SPELL:1251386}, dodge {SPELL:1253915} & {SPELL:1279420}, move {SPELL:1250898} away, and use a defensive for the knockback {SPELL:1281194} and the intermission {SPELL:1282047}. (EXBoss timeline — confirm in-game.)",
	RAID_BOSS_LURA_TANK = "• Heaven's Lance stacks to 5 and then applies Impale (+50% damage for ~25s) — swap with the off-tank each cycle before Impale lands.",
})

merge(ns._mhLocales and ns._mhLocales.itIT, {
	-- The Dreamrift — Chimaerus, the Undreamt God ---------------------------
	RAID_BOSS_CHIMAERUS_STEPS = "• Meccanica dell'energia: gli add camminano verso Chimaerus — uccidili prima che arrivino. Se uno lo raggiunge ottiene un grosso buff ai danni, e a energia piena divora un add per un quasi-wipe.|n• Interrompi {SPELL:1249017} — il cast del caster di Haunting Essence è il kick prioritario.|n• Uccidi in fretta l'add Colossal Horror; i suoi danni continuano a salire.|n• Soak/dividetevi per Alndust Upheaval (il raid viene diviso in due gruppi) e schiva le linee di Corrupted Devastation durante l'intermission.|n• In Mythic si aggiungono Dissonance (non stare vicino ai giocatori in fase opposta) e Rift Madness (un debuff che va soakato/scambiato).|n• Cast chiave: schiva {SPELL:1245452} & {SPELL:1282856}, preparati al knockback {SPELL:1245404}, tieni una defensive per {SPELL:1268905}, e AoE pesante su {SPELL:1251021}. (Timeline EXBoss — confermare in-game.)",
	RAID_PRERELEASE_NOTE = "Scritto prima dell’apertura del raid (18 ago), dai moduli DBM e dal diario del gioco stesso. Niente qui è inventato, ma niente è stato ancora percorso — verificalo nello scontro.",
	RAID_BOSS_NEKZALI_STEPS = "• Corri via quando parte {SPELL:1284103}, e continua a schivare {SPELL:1294933}.|n• Uccidi in fretta gli add di {SPELL:1297630}.|n• Aiuta a soakare la Hungering Pyre quando il gruppo la chiama.|n• A metà vita {SPELL:1299673} cambia lo schema — cambia il ritmo, non le regole.",
	RAID_BOSS_NEKZALI_TANK = "Cambio con provocazione dopo ogni {SPELL:1284103}.",
	RAID_BOSS_ENTOMBEDSENT_STEPS = "• Due golem: tienili ben distanti — vicini non subiscono quasi danni.|n• Il tuo debuff {SPELL:1284590} vuole esattamente quattro stack; poi mettiti su una goccia di {SPELL:1284434} per disinnescarlo.|n• Continua a muoverti con {SPELL:1284485} — questo scontro è posizionamento, non una corsa.",
	RAID_BOSS_ENTOMBEDSENT_TANK = "Cambio su {SPELL:1284458} e {SPELL:1284487}; entrambi vogliono una difensiva.",
	RAID_BOSS_ENTOMBEDSENT_HEALER = "Dissipa {SPELL:1284483} — a chiamata, non a vista.",
	RAID_BOSS_LOSTEXPLORERS_STEPS = "• Interrompi {SPELL:1286921}.|n• Il pavimento è lo scontro: schiva {SPELL:1291759}, {SPELL:1291933} e {SPELL:1295886}.|n• {SPELL:1290711}: le nostre due fonti si contraddicono — allontanarsi o ammassarsi — segui quindi la chiamata del tuo leader.|n• Dai Disgusting Fish ai Tortollan posseduti per spezzare la possessione.",
	RAID_BOSS_VASHNIK_STEPS = "• Quando beve ({SPELL:1283164}), add di veleno strisciano verso il centro — uccidili prima che arrivino.|n• Porta {SPELL:1281907} lontano dal gruppo.|n• Aiuta a soakare {SPELL:1282509}.|n• Schiva {SPELL:1294994} e {SPELL:1302489}.",
	RAID_BOSS_VASHNIK_TANK = "Difensiva su {SPELL:1280935}.",
	RAID_BOSS_SSZORAK_STEPS = "• Il vento è il nemico: {SPELL:1285732} ti spinge — bada a cosa hai alle spalle.|n• Schiva {SPELL:1305959}, sparpagliatevi per {SPELL:1285733}.|n• Non toccare le cisti sul pavimento.",
	RAID_BOSS_SSZORAK_TANK = "{SPELL:1285430} è una combo — tieni una difensiva per tutta la durata.",
	RAID_BOSS_TWINFANGS_STEPS = "• Il debuff di veleno di tutti continua a salire; mettiti in {SPELL:1290516} perché venga divorato prima che ti stordisca.|n• Aiuta a soakare {SPELL:1288484}.|n• Schiva il frontale di {SPELL:1294293}, uccidi gli add di {SPELL:1291404}.",
	RAID_BOSS_TWINFANGS_TANK = "I debuff da tank dei due boss non devono mai mescolarsi — tieni il tuo boss, mai incrociare.",
	RAID_BOSS_COILEDALTAR_STEPS = "• Datevi spazio sulla Guillotine.|n• Spaccate lo scudo di {SPELL:1286918}, schiva {SPELL:1283832}.|n• Se qualcuno viene controllato ({SPELL:1289900}), liberatelo.|n• Tre fasi; alla fine tenete pari la vita dei due boss — se uno muore troppo presto, l’altro si infuria.",
	RAID_BOSS_COILEDALTAR_HEALER = "Dissipa il veleno: {SPELL:1282281}.",
	RAID_BOSS_ULATEK_STEPS = "• Schiva {SPELL:1292403}, ammassatevi per {SPELL:1287265}.|n• Durante {SPELL:1286860} il suo Venomous Heart è esposto — bruciatelo.|n• Interrompi {SPELL:1290779} sugli add.|n• Alla fine la piattaforma si spezza: resta su ciò che rimane.|n• Non è mai apparsa sul PTR — aspettati sorprese; questa pagina sarà corretta dai pull veri.",
	RAID_BOSS_CHIMAERUS_TANK = "• Rending Tear è un bleed + knockback — orientalo lontano dal raid e non farti buttare giù dalla piattaforma; scambia l'add Colossal Horror con l'off-tank.",
	RAID_BOSS_CHIMAERUS_HEALER = "• I danni piccano durante l'intermission (Corrupted Devastation / Ravenous Dive) e ogni volta che un add raggiunge il boss — tieni i cooldown per quelle finestre.",

	-- The Voidspire — Imperator Averzian -----------------------------------
	RAID_BOSS_AVERZIAN_STEPS = "• Una lotta di territorio: gli add sono immuni finché non vengono colpiti da {SPELL:1249262} (Umbral Collapse, un soak di gruppo) — lascia cadere il soak sopra agli add per renderli uccidibili.|n• Non lasciare mai che tre portali si potenzino a vicenda: questo lancia {SPELL:1251583}, il wipe.|n• Interrompi {SPELL:1255702}.|n• Uccidi prontamente gli add Abyssal Voidshaper.|n• Cast chiave: schiva {SPELL:1258880} & {SPELL:1260712}, soak {SPELL:1249265}, e uccidi gli add ({SPELL:1283069}). (Timeline EXBoss — confermare in-game.)",
	RAID_BOSS_AVERZIAN_HEALER = "• Il soak di gruppo ({SPELL:1249262}) cade su tutti ammassati insieme — porta il raid al massimo prima di ognuno.",

	-- The Voidspire — Vorasius ---------------------------------------------
	RAID_BOSS_VORASIUS_STEPS = "• Erige muri di cristallo; usali come copertura da {SPELL:1256855} — stai dietro un muro quando soffia.|n• Kita gli add Blistercreep nei muri per romperli e aprire corsie sicure.|n• I suoi danni aumentano a ogni set di muri — mantieni il ritmo, è un soft enrage.|n• Cast chiave: schiva {SPELL:1243853}, e spargetevi per l'AoE ({SPELL:1254199} / {SPELL:1260046}). (Timeline EXBoss — confermare in-game.)",
	RAID_BOSS_VORASIUS_HEALER = "• I danni al raid salgono a ogni fase dei muri (soft enrage) — distribuisci i cooldown in modo da coprire i set finali.",

	-- The Voidspire — Fallen-King Salhadaar --------------------------------
	RAID_BOSS_SALHADAAR_STEPS = "• {SPELL:1247738} genera add-orbe Concentrated Void — uccidili prima che raggiungano il boss.|n• A energia piena lancia {SPELL:1246175}: schiva i beam. Durante questo subisce +25% danni per ~20s — è la tua finestra di burn.|n• Tieni gli orbe sotto controllo e conserva il burst per la finestra di Unraveling.|n• Cast chiave: interrompi {SPELL:1254081}, schiva {SPELL:1253911}, e uccidi gli add ({SPELL:1243453}). (Timeline EXBoss — confermare in-game.)",
	RAID_BOSS_SALHADAAR_DPS = "• Trattieni i cooldown per la finestra di {SPELL:1246175} (+25% danni subiti per ~20s); altrimenti dai priorità agli orbe Concentrated Void rispetto al boss.",

	-- The Voidspire — Vaelgor & Ezzorak ------------------------------------
	RAID_BOSS_VAELGOR_STEPS = "• Due boss — tieni la loro vita vicina: {SPELL:1270189} significa che devi distribuire i danni in modo uniforme, o ottengono un grosso buff (il soft enrage).|n• Esci da {SPELL:1244221}; soak {SPELL:1245391} prima che l'orbe colpisca un muro per tenere la stanza aperta.|n• Durante l'intermission, stai dentro {SPELL:1248847} per sopravvivere ai danni pulsanti.|n• Cast chiave: esci dai frontali ({SPELL:1277471} / {SPELL:1277472}), uccidi gli add ({SPELL:1244917} / {SPELL:1277473}); gli healer tengono d'occhio {SPELL:1249748}. (Timeline EXBoss — confermare in-game.)",
	RAID_BOSS_VAELGOR_TANK = "• {SPELL:1262623} è un tank soak che si accumula — gestiscilo con l'altro tank; tieni i due boss abbastanza vicini per danni uniformi ma con i loro frontali puntati lontano dal raid.",
	RAID_BOSS_VAELGOR_HEALER = "• L'intermission pulsa forte — assicurati che tutti siano dentro {SPELL:1248847}, e porta al massimo prima di ogni finestra di Twilight Bond.",

	-- The Voidspire — Lightblinded Vanguard --------------------------------
	RAID_BOSS_VANGUARD_STEPS = "• Tre paladin combattuti insieme: {SPELL:1248983} è il cast pericoloso da gestire.|n• A energia piena un paladin lancia un'aura che potenzia gli altri due — trascina i boss fuori da essa: {SPELL:1248449}, {SPELL:1246162}, {SPELL:1248451}.|n• Cast chiave: schiva {SPELL:1248644}, soak {SPELL:1276368}, spargetevi per {SPELL:1246485}, esci dal frontale {SPELL:1249130}; gli healer tengono d'occhio {SPELL:1276831}. (Timeline EXBoss — confermare in-game.)",
	RAID_BOSS_VANGUARD_TANK = "• {SPELL:1246736} guida il tank swap — scambia sugli stack e tieni i tre paladin raggruppati per il cleave ma fuori dall'aura attiva.",

	-- The Voidspire — Crown of the Cosmos ----------------------------------
	RAID_BOSS_CROWN_STEPS = "• Il finale: tre stage con intermission ({SPELL:1238843}), con tre mini-boss (Xal'atath con Turalyon, Arator e Alleria) prima della spinta finale.|n• Sopravvivi a ogni intermission, poi brucia il bersaglio attivo in ogni stage.|n• Cast chiave: schiva {SPELL:1234564} & {SPELL:1235622}, posa {SPELL:1233819} lontano dal gruppo, uccidi gli add ({SPELL:1261016} / {SPELL:1261339}), e spingi attraverso l'enrage finale ({SPELL:1239582}). (Dati delle abilità dalla timeline EXBoss — confermare in-game.)",

	-- March on Quel'Danas — Belo'ren, Child of Al'ar -----------------------
	RAID_BOSS_BELOREN_STEPS = "• All'inizio vieni diviso per colore: {SPELL:1241162} e {SPELL:1241163} — puoi interagire solo con le meccaniche che corrispondono al tuo colore, quindi impara da che lato sei.|n• A 0 HP non muore — {SPELL:1241313} lo trasforma in un uovo al centro. L'uovo è la vera barra della vita: bruscialo, poi il ciclo si ripete.|n• Attiva gli orbe del tuo colore per creare varchi sicuri, e continua a gestire i cast assegnati al tuo colore.|n• Cast chiave: schiva {SPELL:1242792}, soak {SPELL:1241292} / {SPELL:1241339}, sposta {SPELL:1246709} lontano, usa una defensive per {SPELL:1244344}, e spingi l'enrage {SPELL:1241267}. (Timeline EXBoss — confermare in-game.)",

	-- March on Quel'Danas — Midnight Falls (L'ura) -------------------------
	RAID_BOSS_LURA_STEPS = "• Fase 1 (Death's Dirge): cinque giocatori ricevono i simboli Dark Rune in un ordine prestabilito — il laser rotante deve colpire quei giocatori in quello stesso ordine, quindi annuncialo.|n• Fase 2 (Void Cores): i beam (Galvanize) cadono su quattro giocatori — puntali sui Void Cores per farli detonare; un core danneggiato si apre e ti risucchia.|n• The Darkwell al centro è morte istantanea; Total Eclipse attira tutti verso di esso, e l'anello esterno (Iris of Oblivion) uccide chiunque lasci l'arena. Schiva gli spike di Starsplinter.|n• Cast chiave: interrompi {SPELL:1251386}, schiva {SPELL:1253915} & {SPELL:1279420}, sposta {SPELL:1250898} lontano, e usa una defensive per il knockback {SPELL:1281194} e l'intermission {SPELL:1282047}. (Timeline EXBoss — confermare in-game.)",
	RAID_BOSS_LURA_TANK = "• Heaven's Lance si accumula fino a 5 e poi applica Impale (+50% danni per ~25s) — scambia con l'off-tank a ogni ciclo prima che Impale arrivi.",
})

merge(ns._mhLocales and ns._mhLocales.nlNL, {
	-- The Dreamrift — Chimaerus, the Undreamt God ---------------------------
	RAID_BOSS_CHIMAERUS_STEPS = "• Energiemechanic: adds lopen naar Chimaerus toe — dood ze voordat ze aankomen. Bereikt er één hem, dan krijgt hij een grote damage-buff, en bij volle energie verslindt hij een add voor een bijna-wipe.|n• Interrupt {SPELL:1249017} — de cast van de Haunting Essence-caster is de prioriteitskick.|n• Dood de Colossal Horror-add snel; zijn damage blijft oplopen.|n• Soak/split voor Alndust Upheaval (de raid wordt in twee groepen verdeeld) en ontwijk de Corrupted Devastation-lijnen tijdens de intermission.|n• Mythic voegt Dissonance toe (sta niet bij spelers in de tegenovergestelde fase) en Rift Madness (een debuff die gesoaked/geswapt moet worden).|n• Belangrijke casts: ontwijk {SPELL:1245452} & {SPELL:1282856}, vang de knockback {SPELL:1245404} op, bewaar een defensive voor {SPELL:1268905}, en zware AoE op {SPELL:1251021}. (EXBoss-timeline — in-game bevestigen.)",
	RAID_PRERELEASE_NOTE = "Geschreven vóór de opening van de raid (18 aug), uit DBM’s encounter-modules en het journal van het spel zelf. Niets hier is verzonnen, maar niets is al gelopen — toets het aan het gevecht.",
	RAID_BOSS_NEKZALI_STEPS = "• Ren weg bij {SPELL:1284103}, en blijf {SPELL:1294933} ontwijken.|n• Dood de {SPELL:1297630}-adds snel.|n• Help soaken bij Hungering Pyre als je groep het afroept.|n• Op de helft verandert {SPELL:1299673} zijn patroon — het ritme wisselt, de regels niet.",
	RAID_BOSS_NEKZALI_TANK = "Taunt-swap na elke {SPELL:1284103}.",
	RAID_BOSS_ENTOMBEDSENT_STEPS = "• Twee golems: houd ze ver uit elkaar — dicht bij elkaar nemen ze nauwelijks schade.|n• Je {SPELL:1284590}-debuff wil precies vier stacks; ga daarna op een {SPELL:1284434}-druppel staan om hem onschadelijk te maken.|n• Blijf bewegen bij {SPELL:1284485} — dit gevecht is positie, geen race.",
	RAID_BOSS_ENTOMBEDSENT_TANK = "Swap op {SPELL:1284458} en {SPELL:1284487}; allebei willen een defensive.",
	RAID_BOSS_ENTOMBEDSENT_HEALER = "Dispel {SPELL:1284483} — op afroep, niet meteen.",
	RAID_BOSS_LOSTEXPLORERS_STEPS = "• Interrupt {SPELL:1286921}.|n• De vloer ís het gevecht: ontwijk {SPELL:1291759}, {SPELL:1291933} en {SPELL:1295886}.|n• {SPELL:1290711}: onze twee bronnen spreken elkaar tegen — wegrennen of juist stapelen — volg dus de afroep van je leider.|n• Voer Disgusting Fish aan bezeten Tortollans om de bezetenheid te breken.",
	RAID_BOSS_VASHNIK_STEPS = "• Als hij drinkt ({SPELL:1283164}) kruipen gif-adds naar het midden — dood ze voordat ze aankomen.|n• Neem {SPELL:1281907} weg van de groep.|n• Help soaken bij {SPELL:1282509}.|n• Ontwijk {SPELL:1294994} en {SPELL:1302489}.",
	RAID_BOSS_VASHNIK_TANK = "Defensive op {SPELL:1280935}.",
	RAID_BOSS_SSZORAK_STEPS = "• De wind is de vijand: {SPELL:1285732} duwt je — let op wat er achter je ligt.|n• Ontwijk {SPELL:1305959}, spreid voor {SPELL:1285733}.|n• Blijf van de cysten op de vloer af.",
	RAID_BOSS_SSZORAK_TANK = "{SPELL:1285430} is een combo — houd er een defensive doorheen vast.",
	RAID_BOSS_TWINFANGS_STEPS = "• Ieders gif-debuff blijft stapelen; ga in {SPELL:1290516} staan zodat hij wordt opgegeten vóór hij je stunt.|n• Help soaken bij {SPELL:1288484}.|n• Ontwijk de {SPELL:1294293}-frontal, dood de {SPELL:1291404}-adds.",
	RAID_BOSS_TWINFANGS_TANK = "De tank-debuffs van de twee bosses mogen nooit mengen — houd je eigen boss, wissel nooit kruislings.",
	RAID_BOSS_COILEDALTAR_STEPS = "• Geef elkaar ruimte bij Guillotine.|n• Sla het {SPELL:1286918}-schild kapot, ontwijk {SPELL:1283832}.|n• Wordt iemand mind-controlled ({SPELL:1289900}), bevrijd diegene.|n• Drie fases; houd aan het eind de levens van beide bosses gelijk — sterft er één te vroeg, dan enraget de ander.",
	RAID_BOSS_COILEDALTAR_HEALER = "Dispel poison: {SPELL:1282281}.",
	RAID_BOSS_ULATEK_STEPS = "• Ontwijk {SPELL:1292403}, stapel voor {SPELL:1287265}.|n• Tijdens {SPELL:1286860} ligt haar Venomous Heart open — burn het.|n• Interrupt {SPELL:1290779} op de adds.|n• Aan het eind breekt het platform af: ga staan op wat overblijft.|n• Ze is nooit op de PTR verschenen, dus reken op verrassingen — deze pagina wordt bijgewerkt uit echte pulls.",
	RAID_BOSS_CHIMAERUS_TANK = "• Rending Tear is een bleed + knockback — draai hem weg van de raid en laat je niet van het platform slaan; wissel de Colossal Horror-add met de off-tank.",
	RAID_BOSS_CHIMAERUS_HEALER = "• Schade piekt tijdens de intermission (Corrupted Devastation / Ravenous Dive) en telkens als een add de boss bereikt — bewaar cooldowns voor die vensters.",

	-- The Voidspire — Imperator Averzian -----------------------------------
	RAID_BOSS_AVERZIAN_STEPS = "• Een territoriumgevecht: adds zijn immuun tot ze geraakt worden door {SPELL:1249262} (Umbral Collapse, een groeps-soak) — laat de soak boven op de adds vallen om ze killbaar te maken.|n• Laat nooit drie portals elkaar versterken: dat cast {SPELL:1251583}, de wipe.|n• Interrupt {SPELL:1255702}.|n• Dood de Abyssal Voidshaper-adds prompt.|n• Key casts: ontwijk {SPELL:1258880} & {SPELL:1260712}, soak {SPELL:1249265}, en dood de adds ({SPELL:1283069}). (EXBoss-tijdlijn — bevestig in-game.)",
	RAID_BOSS_AVERZIAN_HEALER = "• De groeps-soak ({SPELL:1249262}) landt op iedereen samengepakt — top de raid vóór elke soak.",

	-- The Voidspire — Vorasius ---------------------------------------------
	RAID_BOSS_VORASIUS_STEPS = "• Hij hijst kristalmuren op; gebruik ze als dekking tegen {SPELL:1256855} — sta achter een muur als hij ademt.|n• Kite de Blistercreep-adds in de muren om ze te breken en veilige banen te openen.|n• Zijn damage loopt op met elke muurset — houd het tempo erin, het is een soft enrage.|n• Key casts: ontwijk {SPELL:1243853}, en spreid voor de AoE ({SPELL:1254199} / {SPELL:1260046}). (EXBoss-tijdlijn — bevestig in-game.)",
	RAID_BOSS_VORASIUS_HEALER = "• Raidschade loopt op met elke muurfase (soft enrage) — verdeel je cooldowns zo dat de latere sets gedekt zijn.",

	-- The Voidspire — Fallen-King Salhadaar --------------------------------
	RAID_BOSS_SALHADAAR_STEPS = "• {SPELL:1247738} spawnt Concentrated Void-orb-adds — dood ze voordat ze de boss bereiken.|n• Bij volle energie cast hij {SPELL:1246175}: ontwijk de beams. Tijdens deze cast neemt hij +25% damage voor ~20s — dat is je burn-venster.|n• Houd de orbs onder controle en bewaar burst voor het Unraveling-venster.|n• Key casts: interrupt {SPELL:1254081}, ontwijk {SPELL:1253911}, en dood de adds ({SPELL:1243453}). (EXBoss-tijdlijn — bevestig in-game.)",
	RAID_BOSS_SALHADAAR_DPS = "• Houd cooldowns vast voor het {SPELL:1246175}-venster (+25% damage taken voor ~20s); prioriteer anders de Concentrated Void-orbs boven de boss.",

	-- The Voidspire — Vaelgor & Ezzorak ------------------------------------
	RAID_BOSS_VAELGOR_STEPS = "• Twee bosses — houd hun health dicht bij elkaar: {SPELL:1270189} betekent dat je damage gelijk moet verdelen, anders krijgen ze een grote buff (de soft enrage).|n• Ren uit {SPELL:1244221}; soak {SPELL:1245391} voordat de orb een muur raakt om de ruimte open te houden.|n• Sta tijdens de intermission in {SPELL:1248847} om de pulserende schade te overleven.|n• Key casts: ren uit de frontals ({SPELL:1277471} / {SPELL:1277472}), dood de adds ({SPELL:1244917} / {SPELL:1277473}); healers letten op {SPELL:1249748}. (EXBoss-tijdlijn — bevestig in-game.)",
	RAID_BOSS_VAELGOR_TANK = "• {SPELL:1262623} is een stapelende tank-soak — beheer 'm met de andere tank; houd de twee bosses dicht genoeg voor gelijke damage maar met hun frontals weg van de raid.",
	RAID_BOSS_VAELGOR_HEALER = "• De intermission pulseert hard — zorg dat iedereen in {SPELL:1248847} staat, en top op vóór elk Twilight Bond-venster.",

	-- The Voidspire — Lightblinded Vanguard --------------------------------
	RAID_BOSS_VANGUARD_STEPS = "• Drie paladins samen bevochten: {SPELL:1248983} is de gevaarlijke cast om af te handelen.|n• Bij volle energie cast één paladin een aura die de andere twee buft — sleep de bosses eruit: {SPELL:1248449}, {SPELL:1246162}, {SPELL:1248451}.|n• Key casts: ontwijk {SPELL:1248644}, soak {SPELL:1276368}, spreid voor {SPELL:1246485}, ren uit de frontal {SPELL:1249130}; healers letten op {SPELL:1276831}. (EXBoss-tijdlijn — bevestig in-game.)",
	RAID_BOSS_VANGUARD_TANK = "• {SPELL:1246736} stuurt de tank-swap — wissel op de stacks en houd de drie paladins gegroepeerd voor cleave maar uit de actieve aura.",

	-- The Voidspire — Crown of the Cosmos ----------------------------------
	RAID_BOSS_CROWN_STEPS = "• De finale: drie stages met intermissions ({SPELL:1238843}), met drie mini-bosses (Xal'atath met Turalyon, Arator en Alleria) vóór de laatste push.|n• Overleef elke intermission en burn daarna het actieve doelwit in elke stage.|n• Belangrijke casts: ontwijk {SPELL:1234564} & {SPELL:1235622}, leg {SPELL:1233819} weg van de groep, dood de adds ({SPELL:1261016} / {SPELL:1261339}) en push door de eind-enrage ({SPELL:1239582}). (Ability-data uit de EXBoss-timeline — in-game bevestigen.)",

	-- March on Quel'Danas — Belo'ren, Child of Al'ar -----------------------
	RAID_BOSS_BELOREN_STEPS = "• Je wordt aan het begin op kleur verdeeld: {SPELL:1241162} en {SPELL:1241163} — je kunt alleen interacteren met mechanics die bij je kleur passen, dus leer aan welke kant je staat.|n• Op 0 HP gaat hij niet dood — {SPELL:1241313} verandert hem in een ei in het midden. Het ei is de echte health-bar: burst 'm down, daarna herhaalt de cyclus.|n• Pop je kleur-bijpassende orbs om veilige gaten te maken, en blijf de casts afhandelen die aan jouw kleur zijn toegewezen.|n• Belangrijke casts: ontwijk {SPELL:1242792}, soak {SPELL:1241292} / {SPELL:1241339}, leg {SPELL:1246709} weg, gebruik een defensive voor {SPELL:1244344}, en push de enrage {SPELL:1241267}. (EXBoss-timeline — in-game bevestigen.)",

	-- March on Quel'Danas — Midnight Falls (L'ura) -------------------------
	RAID_BOSS_LURA_STEPS = "• Fase 1 (Death's Dirge): vijf spelers krijgen Dark Rune-symbolen in een vaste volgorde — de roterende laser moet die spelers in diezelfde volgorde raken, dus call het uit.|n• Fase 2 (Void Cores): beams (Galvanize) landen op vier spelers — richt ze op de Void Cores om ze te laten detoneren; een beschadigde core opent en trekt je naar binnen.|n• The Darkwell in het midden is instant dood; Total Eclipse trekt iedereen ernaartoe, en de buitenring (Iris of Oblivion) doodt iedereen die de arena verlaat. Ontwijk de Starsplinter-spikes.|n• Belangrijke casts: interrupt {SPELL:1251386}, ontwijk {SPELL:1253915} & {SPELL:1279420}, leg {SPELL:1250898} weg, en gebruik een defensive voor de knockback {SPELL:1281194} en de intermission {SPELL:1282047}. (EXBoss-timeline — in-game bevestigen.)",
	RAID_BOSS_LURA_TANK = "• Heaven's Lance stapelt tot 5 en past dan Impale toe (+50% damage voor ~25s) — wissel elke cyclus met de off-tank voordat Impale landt.",
})

merge(ns._mhLocales and ns._mhLocales.deDE, {
	-- The Dreamrift — Chimaerus, the Undreamt God ---------------------------
	RAID_BOSS_CHIMAERUS_STEPS = "• Energiemechanik: Adds laufen auf Chimaerus zu — töte sie, bevor sie ankommen. Erreicht ihn einer, erhält er einen großen Schadensbuff, und bei voller Energie verschlingt er einen Add für einen Beinahe-Wipe.|n• Unterbrich {SPELL:1249017} — der Zauber des Haunting-Essence-Casters ist der Prioritäts-Kick.|n• Töte den Colossal-Horror-Add schnell; sein Schaden steigt stetig.|n• Soake/splitte für Alndust Upheaval (der Schlachtzug wird in zwei Gruppen geteilt) und weiche den Corrupted-Devastation-Linien während des Zwischenspiels aus.|n• Mythic fügt Dissonance hinzu (steh nicht bei Spielern in der Gegenphase) und Rift Madness (ein Debuff, der gesoakt/geswappt werden muss).|n• Wichtige Zauber: weiche {SPELL:1245452} & {SPELL:1282856} aus, mach dich bereit für den Rückstoß {SPELL:1245404}, heb dir eine Defensive für {SPELL:1268905} auf, und schwerer AoE auf {SPELL:1251021}. (EXBoss-Timeline — im Spiel bestätigen.)",
	RAID_PRERELEASE_NOTE = "Geschrieben vor der Öffnung des Raids (18. Aug.), aus DBMs Encounter-Modulen und dem Journal des Spiels selbst. Nichts hier ist erfunden, aber nichts davon wurde schon gelaufen — prüfe es am Kampf.",
	RAID_BOSS_NEKZALI_STEPS = "• Lauf raus, wenn {SPELL:1284103} kommt, und weiche {SPELL:1294933} weiter aus.|n• Töte die {SPELL:1297630}-Adds schnell.|n• Hilf beim Soaken der Hungering Pyre, wenn deine Gruppe es ansagt.|n• Bei halber Gesundheit ändert {SPELL:1299673} sein Muster — der Rhythmus wechselt, die Regeln nicht.",
	RAID_BOSS_NEKZALI_TANK = "Spott-Wechsel nach jedem {SPELL:1284103}.",
	RAID_BOSS_ENTOMBEDSENT_STEPS = "• Zwei Golems: halte sie weit auseinander — nah beieinander nehmen sie kaum Schaden.|n• Dein {SPELL:1284590}-Debuff will genau vier Stacks; stell dich dann auf einen {SPELL:1284434}-Tropfen, um ihn zu entschärfen.|n• Bleib in Bewegung bei {SPELL:1284485} — dieser Kampf ist Positionsspiel, kein Wettrennen.",
	RAID_BOSS_ENTOMBEDSENT_TANK = "Wechsel bei {SPELL:1284458} und {SPELL:1284487}; beide wollen eine Defensive.",
	RAID_BOSS_ENTOMBEDSENT_HEALER = "Entferne {SPELL:1284483} — auf Ansage, nicht sofort.",
	RAID_BOSS_LOSTEXPLORERS_STEPS = "• Unterbrich {SPELL:1286921}.|n• Der Boden ist der Kampf: weiche {SPELL:1291759}, {SPELL:1291933} und {SPELL:1295886} aus.|n• {SPELL:1290711}: unsere zwei Quellen widersprechen sich — rauslaufen oder stapeln — folge also der Ansage deines Leiters.|n• Füttere besessene Tortollan mit Disgusting Fish, um die Besessenheit zu brechen.",
	RAID_BOSS_VASHNIK_STEPS = "• Wenn er trinkt ({SPELL:1283164}), kriechen Gift-Adds zur Mitte — töte sie, bevor sie ankommen.|n• Trag {SPELL:1281907} von der Gruppe weg.|n• Hilf beim Soaken von {SPELL:1282509}.|n• Weiche {SPELL:1294994} und {SPELL:1302489} aus.",
	RAID_BOSS_VASHNIK_TANK = "Defensive bei {SPELL:1280935}.",
	RAID_BOSS_SSZORAK_STEPS = "• Der Wind ist der Feind: {SPELL:1285732} schiebt dich — achte darauf, was hinter dir liegt.|n• Weiche {SPELL:1305959} aus, verteilt euch bei {SPELL:1285733}.|n• Fass die Zysten am Boden nicht an.",
	RAID_BOSS_SSZORAK_TANK = "{SPELL:1285430} ist eine Kombo — halte eine Defensive durchgehend.",
	RAID_BOSS_TWINFANGS_STEPS = "• Der Gift-Debuff aller stapelt weiter; stell dich in {SPELL:1290516}, damit er gefressen wird, bevor er dich betäubt.|n• Hilf beim Soaken von {SPELL:1288484}.|n• Weiche dem {SPELL:1294293}-Frontal aus, töte die {SPELL:1291404}-Adds.",
	RAID_BOSS_TWINFANGS_TANK = "Die Tank-Debuffs der beiden Bosse dürfen sich nie mischen — behalte deinen Boss, nie kreuzen.",
	RAID_BOSS_COILEDALTAR_STEPS = "• Gebt euch Platz bei Guillotine.|n• Schlagt den {SPELL:1286918}-Schild weg, weiche {SPELL:1283832} aus.|n• Wird jemand gedankenkontrolliert ({SPELL:1289900}), befreit die Person.|n• Drei Phasen; haltet am Ende die Leben beider Bosse gleich — stirbt einer zu früh, gerät der andere in Raserei.",
	RAID_BOSS_COILEDALTAR_HEALER = "Gift entfernen: {SPELL:1282281}.",
	RAID_BOSS_ULATEK_STEPS = "• Weiche {SPELL:1292403} aus, stapelt euch für {SPELL:1287265}.|n• Während {SPELL:1286860} liegt ihr Venomous Heart offen — burnt es.|n• Unterbrich {SPELL:1290779} bei den Adds.|n• Am Ende bricht die Plattform auseinander: stell dich auf das, was bleibt.|n• Sie war nie auf dem PTR — rechne mit Überraschungen; diese Seite wird aus echten Pulls korrigiert.",
	RAID_BOSS_CHIMAERUS_TANK = "• Rending Tear ist ein Blutung + Rückstoß — dreh ihn vom Schlachtzug weg und lass dich nicht von der Plattform stoßen; tausche den Colossal-Horror-Add mit dem Off-Tank.",
	RAID_BOSS_CHIMAERUS_HEALER = "• Der Schaden spitzt sich während des Zwischenspiels zu (Corrupted Devastation / Ravenous Dive) und jedes Mal, wenn ein Add den Boss erreicht — heb dir Cooldowns für diese Fenster auf.",

	-- The Voidspire — Imperator Averzian -----------------------------------
	RAID_BOSS_AVERZIAN_STEPS = "• Ein Territoriumskampf: Adds sind immun, bis sie von {SPELL:1249262} (Umbral Collapse, ein Gruppen-Soak) getroffen werden — lass den Soak direkt auf den Adds fallen, um sie tötbar zu machen.|n• Lass niemals drei Portale sich gegenseitig verstärken: das wirkt {SPELL:1251583}, den Wipe.|n• Unterbrich {SPELL:1255702}.|n• Töte die Abyssal-Voidshaper-Adds umgehend.|n• Key casts: weiche {SPELL:1258880} & {SPELL:1260712} aus, soake {SPELL:1249265}, und töte die Adds ({SPELL:1283069}). (EXBoss-Timeline — im Spiel bestätigen.)",
	RAID_BOSS_AVERZIAN_HEALER = "• Der Gruppen-Soak ({SPELL:1249262}) landet auf allen zusammengestellten Spielern — heile den Schlachtzug vor jedem hoch.",

	-- The Voidspire — Vorasius ---------------------------------------------
	RAID_BOSS_VORASIUS_STEPS = "• Er errichtet Kristallwände; nutze sie als Deckung gegen {SPELL:1256855} — steh hinter einer Wand, wenn er atmet.|n• Kite die Blistercreep-Adds in die Wände, um sie zu zerstören und sichere Gassen zu öffnen.|n• Sein Schaden steigt mit jedem Wandsatz — halt das Tempo hoch, es ist ein Soft-Enrage.|n• Key casts: weiche {SPELL:1243853} aus, und verteil dich für den AoE ({SPELL:1254199} / {SPELL:1260046}). (EXBoss-Timeline — im Spiel bestätigen.)",
	RAID_BOSS_VORASIUS_HEALER = "• Der Schlachtzugsschaden steigt mit jeder Wandphase (Soft-Enrage) — teil deine Cooldowns so ein, dass die späteren Sätze abgedeckt sind.",

	-- The Voidspire — Fallen-King Salhadaar --------------------------------
	RAID_BOSS_SALHADAAR_STEPS = "• {SPELL:1247738} spawnt Concentrated-Void-Orb-Adds — töte sie, bevor sie den Boss erreichen.|n• Bei voller Energie wirkt er {SPELL:1246175}: weiche den Strahlen aus. Währenddessen nimmt er ~20s lang +25% Schaden — das ist dein Burn-Fenster.|n• Halt die Orbs unter Kontrolle und heb dir Burst für das Unraveling-Fenster auf.|n• Key casts: unterbrich {SPELL:1254081}, weiche {SPELL:1253911} aus, und töte die Adds ({SPELL:1243453}). (EXBoss-Timeline — im Spiel bestätigen.)",
	RAID_BOSS_SALHADAAR_DPS = "• Halt Cooldowns für das {SPELL:1246175}-Fenster zurück (+25% erlittener Schaden für ~20s); priorisiere ansonsten die Concentrated-Void-Orbs vor dem Boss.",

	-- The Voidspire — Vaelgor & Ezzorak ------------------------------------
	RAID_BOSS_VAELGOR_STEPS = "• Zwei Bosse — halt ihre Gesundheit dicht beieinander: {SPELL:1270189} bedeutet, dass du den Schaden gleichmäßig verteilen musst, sonst erhalten sie einen großen Buff (den Soft-Enrage).|n• Lauf aus {SPELL:1244221} heraus; soake {SPELL:1245391}, bevor der Orb eine Wand trifft, um den Raum offen zu halten.|n• Steh während des Zwischenspiels in {SPELL:1248847}, um den pulsierenden Schaden zu überleben.|n• Key casts: lauf aus den Frontals heraus ({SPELL:1277471} / {SPELL:1277472}), töte die Adds ({SPELL:1244917} / {SPELL:1277473}); Heiler achten auf {SPELL:1249748}. (EXBoss-Timeline — im Spiel bestätigen.)",
	RAID_BOSS_VAELGOR_TANK = "• {SPELL:1262623} ist ein stapelnder Tank-Soak — verwalte ihn mit dem anderen Tank; halt die beiden Bosse nah genug für gleichmäßigen Schaden, aber ihre Frontals vom Schlachtzug weggerichtet.",
	RAID_BOSS_VAELGOR_HEALER = "• Das Zwischenspiel pulsiert hart — sorg dafür, dass alle in {SPELL:1248847} stehen, und heil vor jedem Twilight-Bond-Fenster hoch.",

	-- The Voidspire — Lightblinded Vanguard --------------------------------
	RAID_BOSS_VANGUARD_STEPS = "• Drei gemeinsam bekämpfte Paladine: {SPELL:1248983} ist der gefährliche Zauber, den es zu handhaben gilt.|n• Bei voller Energie wirkt ein Paladin eine Aura, die die anderen beiden bufft — zieh die Bosse heraus: {SPELL:1248449}, {SPELL:1246162}, {SPELL:1248451}.|n• Key casts: weiche {SPELL:1248644} aus, soake {SPELL:1276368}, verteil dich für {SPELL:1246485}, lauf aus dem Frontal {SPELL:1249130} heraus; Heiler achten auf {SPELL:1276831}. (EXBoss-Timeline — im Spiel bestätigen.)",
	RAID_BOSS_VANGUARD_TANK = "• {SPELL:1246736} treibt den Tankwechsel an — wechsle bei den Stacks und halt die drei Paladine für Cleave gruppiert, aber außerhalb der aktiven Aura.",

	-- The Voidspire — Crown of the Cosmos ----------------------------------
	RAID_BOSS_CROWN_STEPS = "• Das Finale: drei Phasen mit Zwischenspielen ({SPELL:1238843}), mit drei Mini-Bossen (Xal'atath mit Turalyon, Arator und Alleria) vor dem letzten Ansturm.|n• Überlebe jedes Zwischenspiel und burne dann das aktive Ziel in jeder Phase.|n• Wichtige Zauber: weiche {SPELL:1234564} & {SPELL:1235622} aus, leg {SPELL:1233819} von der Gruppe weg ab, töte die Adds ({SPELL:1261016} / {SPELL:1261339}) und push durch die End-Enrage ({SPELL:1239582}). (Fähigkeitsdaten aus der EXBoss-Timeline — im Spiel bestätigen.)",

	-- March on Quel'Danas — Belo'ren, Child of Al'ar -----------------------
	RAID_BOSS_BELOREN_STEPS = "• Du wirst zu Beginn nach Farbe aufgeteilt: {SPELL:1241162} und {SPELL:1241163} — du kannst nur mit Mechaniken interagieren, die zu deiner Farbe passen, also merk dir, auf welcher Seite du bist.|n• Bei 0 HP stirbt er nicht — {SPELL:1241313} verwandelt ihn in ein Ei in der Mitte. Das Ei ist die echte Gesundheitsleiste: burne es runter, dann wiederholt sich der Zyklus.|n• Zünde deine farblich passenden Orbs, um sichere Lücken zu schaffen, und handhabe weiter die Zauber, die deiner Farbe zugewiesen sind.|n• Wichtige Zauber: weiche {SPELL:1242792} aus, soak {SPELL:1241292} / {SPELL:1241339}, beweg {SPELL:1246709} weg, nutz eine Defensive für {SPELL:1244344}, und push die Enrage {SPELL:1241267}. (EXBoss-Timeline — im Spiel bestätigen.)",

	-- March on Quel'Danas — Midnight Falls (L'ura) -------------------------
	RAID_BOSS_LURA_STEPS = "• Phase 1 (Death's Dirge): fünf Spieler erhalten Dark-Rune-Symbole in einer festen Reihenfolge — der rotierende Laser muss diese Spieler in genau dieser Reihenfolge treffen, also sag es an.|n• Phase 2 (Void Cores): Strahlen (Galvanize) landen auf vier Spielern — richte sie auf die Void Cores, um sie zu detonieren; ein beschädigter Kern öffnet sich und zieht dich hinein.|n• The Darkwell in der Mitte ist sofortiger Tod; Total Eclipse zieht alle dorthin, und der äußere Ring (Iris of Oblivion) tötet jeden, der die Arena verlässt. Weiche den Starsplinter-Spitzen aus.|n• Wichtige Zauber: unterbrich {SPELL:1251386}, weiche {SPELL:1253915} & {SPELL:1279420} aus, beweg {SPELL:1250898} weg, und nutz eine Defensive für den Rückstoß {SPELL:1281194} und das Zwischenspiel {SPELL:1282047}. (EXBoss-Timeline — im Spiel bestätigen.)",
	RAID_BOSS_LURA_TANK = "• Heaven's Lance stapelt bis 5 und wendet dann Impale an (+50% Schaden für ~25s) — wechsle jeden Zyklus mit dem Off-Tank, bevor Impale landet.",
})

merge(ns._mhLocales and ns._mhLocales.frFR, {
	-- The Dreamrift — Chimaerus, the Undreamt God ---------------------------
	RAID_BOSS_CHIMAERUS_STEPS = "• Mécanique d'énergie : les adds marchent vers Chimaerus — tuez-les avant qu'ils n'arrivent. Si l'un l'atteint, il gagne un gros bonus de dégâts, et à pleine énergie il dévore un add pour un quasi-wipe.|n• Interrompez {SPELL:1249017} — l'incantation du lanceur de Haunting Essence est le kick prioritaire.|n• Tuez vite l'add Colossal Horror ; ses dégâts ne cessent de monter.|n• Soakez/répartissez-vous pour Alndust Upheaval (le raid est divisé en deux groupes) et esquivez les lignes de Corrupted Devastation pendant l'intermède.|n• En Mythique s'ajoutent Dissonance (ne restez pas près des joueurs en phase opposée) et Rift Madness (un debuff à soaker/échanger).|n• Sorts clés : esquivez {SPELL:1245452} & {SPELL:1282856}, préparez-vous au recul {SPELL:1245404}, gardez un défensif pour {SPELL:1268905}, et AoE lourd sur {SPELL:1251021}. (Timeline EXBoss — à confirmer en jeu.)",
	RAID_PRERELEASE_NOTE = "Écrit avant l’ouverture du raid (18 août), à partir des modules DBM et du journal du jeu lui-même. Rien ici n’est inventé, mais rien n’a encore été parcouru — vérifie face au combat.",
	RAID_BOSS_NEKZALI_STEPS = "• Écarte-toi quand {SPELL:1284103} part, et continue d’esquiver {SPELL:1294933}.|n• Tue vite les adds {SPELL:1297630}.|n• Aide à absorber Hungering Pyre quand ton groupe l’annonce.|n• À mi-vie, {SPELL:1299673} change son schéma — le rythme change, pas les règles.",
	RAID_BOSS_NEKZALI_TANK = "Échange de provocation après chaque {SPELL:1284103}.",
	RAID_BOSS_ENTOMBEDSENT_STEPS = "• Deux golems : garde-les loin l’un de l’autre — proches, ils ne prennent presque pas de dégâts.|n• Ton debuff {SPELL:1284590} veut exactement quatre stacks ; ensuite place-toi sur une goutte {SPELL:1284434} pour le désamorcer.|n• Reste en mouvement pendant {SPELL:1284485} — ce combat est du placement, pas une course.",
	RAID_BOSS_ENTOMBEDSENT_TANK = "Échange sur {SPELL:1284458} et {SPELL:1284487} ; les deux demandent un défensif.",
	RAID_BOSS_ENTOMBEDSENT_HEALER = "Dissipe {SPELL:1284483} — à l’annonce, pas à vue.",
	RAID_BOSS_LOSTEXPLORERS_STEPS = "• Interromps {SPELL:1286921}.|n• Le sol est le combat : esquive {SPELL:1291759}, {SPELL:1291933} et {SPELL:1295886}.|n• {SPELL:1290711} : nos deux sources se contredisent — s’écarter ou se regrouper — suis donc l’annonce de ton leader.|n• Donne des Disgusting Fish aux Tortollans possédés pour briser la possession.",
	RAID_BOSS_VASHNIK_STEPS = "• Quand il boit ({SPELL:1283164}), des adds de venin rampent vers le centre — tue-les avant qu’ils n’arrivent.|n• Emporte {SPELL:1281907} loin du groupe.|n• Aide à absorber {SPELL:1282509}.|n• Esquive {SPELL:1294994} et {SPELL:1302489}.",
	RAID_BOSS_VASHNIK_TANK = "Défensif sur {SPELL:1280935}.",
	RAID_BOSS_SSZORAK_STEPS = "• Le vent est l’ennemi : {SPELL:1285732} te pousse — regarde ce qu’il y a derrière toi.|n• Esquive {SPELL:1305959}, dispersez-vous pour {SPELL:1285733}.|n• Ne touche pas aux kystes au sol.",
	RAID_BOSS_SSZORAK_TANK = "{SPELL:1285430} est un combo — garde un défensif pendant toute sa durée.",
	RAID_BOSS_TWINFANGS_STEPS = "• Le debuff de venin de chacun continue de monter ; place-toi dans {SPELL:1290516} pour le faire dévorer avant qu’il ne t’étourdisse.|n• Aide à absorber {SPELL:1288484}.|n• Esquive le frontal {SPELL:1294293}, tue les adds de {SPELL:1291404}.",
	RAID_BOSS_TWINFANGS_TANK = "Les debuffs de tank des deux boss ne doivent jamais se mélanger — garde ton boss, ne croise jamais.",
	RAID_BOSS_COILEDALTAR_STEPS = "• Laissez-vous de la place pour Guillotine.|n• Cassez le bouclier {SPELL:1286918}, esquive {SPELL:1283832}.|n• Si quelqu’un est contrôlé ({SPELL:1289900}), libérez la personne.|n• Trois phases ; à la fin gardez les vies des deux boss égales — l’un qui meurt trop tôt enrage l’autre.",
	RAID_BOSS_COILEDALTAR_HEALER = "Dissipe le poison : {SPELL:1282281}.",
	RAID_BOSS_ULATEK_STEPS = "• Esquive {SPELL:1292403}, regroupez-vous pour {SPELL:1287265}.|n• Pendant {SPELL:1286860}, son Venomous Heart est exposé — brûlez-le.|n• Interromps {SPELL:1290779} sur les adds.|n• À la fin, la plateforme se brise : tiens-toi sur ce qui reste.|n• Elle n’est jamais apparue sur le PTR — attends-toi à des surprises ; cette page sera corrigée à partir de vrais pulls.",
	RAID_BOSS_CHIMAERUS_TANK = "• Rending Tear est un saignement + recul — orientez-le loin du raid et ne vous faites pas projeter hors de la plateforme ; échangez l'add Colossal Horror avec l'off-tank.",
	RAID_BOSS_CHIMAERUS_HEALER = "• Les dégâts montent en flèche pendant l'intermède (Corrupted Devastation / Ravenous Dive) et à chaque fois qu'un add atteint le boss — gardez les cooldowns pour ces fenêtres.",

	-- The Voidspire — Imperator Averzian -----------------------------------
	RAID_BOSS_AVERZIAN_STEPS = "• Un combat de territoire : les adds sont immunisés tant qu'ils ne sont pas touchés par {SPELL:1249262} (Umbral Collapse, un soak de groupe) — posez le soak sur les adds pour les rendre tuables.|n• Ne laissez jamais trois portails se renforcer mutuellement : cela lance {SPELL:1251583}, le wipe.|n• Interrompez {SPELL:1255702}.|n• Tuez rapidement les adds Abyssal Voidshaper.|n• Key casts : esquivez {SPELL:1258880} & {SPELL:1260712}, soakez {SPELL:1249265}, et tuez les adds ({SPELL:1283069}). (Timeline EXBoss — à confirmer en jeu.)",
	RAID_BOSS_AVERZIAN_HEALER = "• Le soak de groupe ({SPELL:1249262}) tombe sur tout le monde regroupé — remontez le raid avant chacun.",

	-- The Voidspire — Vorasius ---------------------------------------------
	RAID_BOSS_VORASIUS_STEPS = "• Il dresse des murs de cristal ; utilisez-les comme abri contre {SPELL:1256855} — restez derrière un mur quand il souffle.|n• Kitez les adds Blistercreep dans les murs pour les briser et ouvrir des couloirs sûrs.|n• Ses dégâts augmentent à chaque série de murs — gardez le rythme, c'est un soft enrage.|n• Key casts : esquivez {SPELL:1243853}, et dispersez-vous pour l'AoE ({SPELL:1254199} / {SPELL:1260046}). (Timeline EXBoss — à confirmer en jeu.)",
	RAID_BOSS_VORASIUS_HEALER = "• Les dégâts au raid montent à chaque phase de murs (soft enrage) — répartissez vos cooldowns pour couvrir les dernières séries.",

	-- The Voidspire — Fallen-King Salhadaar --------------------------------
	RAID_BOSS_SALHADAAR_STEPS = "• {SPELL:1247738} fait apparaître des adds-orbes Concentrated Void — tuez-les avant qu'ils n'atteignent le boss.|n• À pleine énergie il lance {SPELL:1246175} : esquivez les rayons. Pendant ce temps il subit +25% de dégâts pendant ~20s — c'est votre fenêtre de burn.|n• Gardez les orbes sous contrôle et réservez le burst pour la fenêtre d'Unraveling.|n• Key casts : interrompez {SPELL:1254081}, esquivez {SPELL:1253911}, et tuez les adds ({SPELL:1243453}). (Timeline EXBoss — à confirmer en jeu.)",
	RAID_BOSS_SALHADAAR_DPS = "• Gardez les cooldowns pour la fenêtre de {SPELL:1246175} (+25% de dégâts subis pendant ~20s) ; sinon, priorisez les orbes Concentrated Void sur le boss.",

	-- The Voidspire — Vaelgor & Ezzorak ------------------------------------
	RAID_BOSS_VAELGOR_STEPS = "• Deux boss — gardez leurs points de vie proches : {SPELL:1270189} signifie que vous devez répartir les dégâts équitablement, sinon ils gagnent un gros bonus (le soft enrage).|n• Sortez de {SPELL:1244221} ; soakez {SPELL:1245391} avant que l'orbe ne touche un mur pour garder la salle ouverte.|n• Pendant l'intermède, restez dans {SPELL:1248847} pour survivre aux dégâts pulsés.|n• Key casts : sortez des frontaux ({SPELL:1277471} / {SPELL:1277472}), tuez les adds ({SPELL:1244917} / {SPELL:1277473}) ; les soigneurs surveillent {SPELL:1249748}. (Timeline EXBoss — à confirmer en jeu.)",
	RAID_BOSS_VAELGOR_TANK = "• {SPELL:1262623} est un soak de tank cumulatif — gérez-le avec l'autre tank ; gardez les deux boss assez proches pour des dégâts équilibrés mais leurs frontaux pointés loin du raid.",
	RAID_BOSS_VAELGOR_HEALER = "• L'intermède pulse fort — assurez-vous que tout le monde est dans {SPELL:1248847}, et remontez avant chaque fenêtre de Twilight Bond.",

	-- The Voidspire — Lightblinded Vanguard --------------------------------
	RAID_BOSS_VANGUARD_STEPS = "• Trois paladins combattus ensemble : {SPELL:1248983} est l'incantation dangereuse à gérer.|n• À pleine énergie, un paladin lance une aura qui booste les deux autres — sortez les boss de la zone : {SPELL:1248449}, {SPELL:1246162}, {SPELL:1248451}.|n• Key casts : esquivez {SPELL:1248644}, soakez {SPELL:1276368}, dispersez-vous pour {SPELL:1246485}, sortez du frontal {SPELL:1249130} ; les soigneurs surveillent {SPELL:1276831}. (Timeline EXBoss — à confirmer en jeu.)",
	RAID_BOSS_VANGUARD_TANK = "• {SPELL:1246736} impose l'échange de tank — échangez sur les stacks et gardez les trois paladins groupés pour le cleave mais hors de l'aura active.",

	-- The Voidspire — Crown of the Cosmos ----------------------------------
	RAID_BOSS_CROWN_STEPS = "• Le final : trois étapes avec intermèdes ({SPELL:1238843}), mettant en scène trois mini-boss (Xal'atath avec Turalyon, Arator et Alleria) avant la poussée finale.|n• Survivez à chaque intermède, puis burnez la cible active à chaque étape.|n• Sorts clés : esquivez {SPELL:1234564} & {SPELL:1235622}, posez {SPELL:1233819} loin du groupe, tuez les adds ({SPELL:1261016} / {SPELL:1261339}) et poussez à travers l'enrage finale ({SPELL:1239582}). (Données de capacités issues de la timeline EXBoss — à confirmer en jeu.)",

	-- March on Quel'Danas — Belo'ren, Child of Al'ar -----------------------
	RAID_BOSS_BELOREN_STEPS = "• Vous êtes séparés par couleur au départ : {SPELL:1241162} et {SPELL:1241163} — vous ne pouvez interagir qu'avec les mécaniques de votre couleur, donc apprenez de quel côté vous êtes.|n• À 0 PV il ne meurt pas — {SPELL:1241313} le transforme en œuf au centre. L'œuf est la vraie barre de vie : burnez-le, puis le cycle recommence.|n• Activez vos orbes de votre couleur pour créer des espaces sûrs, et continuez à gérer les incantations assignées à votre couleur.|n• Sorts clés : esquivez {SPELL:1242792}, soak {SPELL:1241292} / {SPELL:1241339}, déplacez {SPELL:1246709} loin, utilisez un défensif pour {SPELL:1244344}, et poussez l'enrage {SPELL:1241267}. (Timeline EXBoss — à confirmer en jeu.)",

	-- March on Quel'Danas — Midnight Falls (L'ura) -------------------------
	RAID_BOSS_LURA_STEPS = "• Phase 1 (Death's Dirge) : cinq joueurs reçoivent des symboles Dark Rune dans un ordre défini — le laser rotatif doit toucher ces joueurs dans ce même ordre, donc annoncez-le.|n• Phase 2 (Void Cores) : des rayons (Galvanize) tombent sur quatre joueurs — dirigez-les vers les Void Cores pour les faire détoner ; un noyau endommagé s'ouvre et vous aspire.|n• The Darkwell au centre est une mort instantanée ; Total Eclipse attire tout le monde vers lui, et l'anneau extérieur (Iris of Oblivion) tue quiconque quitte l'arène. Esquivez les pointes de Starsplinter.|n• Sorts clés : interrompez {SPELL:1251386}, esquivez {SPELL:1253915} & {SPELL:1279420}, déplacez {SPELL:1250898} loin, et utilisez un défensif pour le recul {SPELL:1281194} et l'intermède {SPELL:1282047}. (Timeline EXBoss — à confirmer en jeu.)",
	RAID_BOSS_LURA_TANK = "• Heaven's Lance se cumule jusqu'à 5 puis applique Impale (+50% de dégâts pendant ~25s) — échangez avec l'off-tank à chaque cycle avant qu'Impale ne tombe.",
})

merge(ns._mhLocales and ns._mhLocales.esES, {
	-- The Dreamrift — Chimaerus, the Undreamt God ---------------------------
	RAID_BOSS_CHIMAERUS_STEPS = "• Mecánica de energía: los adds caminan hacia Chimaerus — mátalos antes de que lleguen. Si uno lo alcanza, gana un gran bonus de daño, y a energía máxima devora a un add para un casi-wipe.|n• Interrumpe {SPELL:1249017} — el lanzamiento del invocador de Haunting Essence es el kick prioritario.|n• Mata rápido al add Colossal Horror; su daño no para de subir.|n• Soakea/divídete para Alndust Upheaval (el raid se divide en dos grupos) y esquiva las líneas de Corrupted Devastation durante el interludio.|n• En Mítico se añaden Dissonance (no te quedes cerca de jugadores en fase opuesta) y Rift Madness (un debuff que hay que soakear/intercambiar).|n• Hechizos clave: esquiva {SPELL:1245452} & {SPELL:1282856}, prepárate para el empuje {SPELL:1245404}, guarda un defensivo para {SPELL:1268905}, y AoE fuerte sobre {SPELL:1251021}. (Timeline de EXBoss — confirmar en el juego.)",
	RAID_PRERELEASE_NOTE = "Escrito antes de la apertura de la banda (18 ago), a partir de los módulos de DBM y del diario del propio juego. Nada aquí es inventado, pero nada se ha recorrido aún — contrástalo con el combate.",
	RAID_BOSS_NEKZALI_STEPS = "• Sal corriendo cuando salga {SPELL:1284103}, y sigue esquivando {SPELL:1294933}.|n• Mata rápido a los adds de {SPELL:1297630}.|n• Ayuda a absorber Hungering Pyre cuando tu grupo lo pida.|n• A media vida, {SPELL:1299673} cambia su patrón — cambia el ritmo, no las reglas.",
	RAID_BOSS_NEKZALI_TANK = "Cambio de provocación tras cada {SPELL:1284103}.",
	RAID_BOSS_ENTOMBEDSENT_STEPS = "• Dos gólems: mantenlos bien separados — juntos apenas reciben daño.|n• Tu debuff de {SPELL:1284590} quiere exactamente cuatro acumulaciones; luego pisa una gota de {SPELL:1284434} para desactivarlo.|n• Sigue moviéndote con {SPELL:1284485} — esta pelea es de colocación, no una carrera.",
	RAID_BOSS_ENTOMBEDSENT_TANK = "Cambio con {SPELL:1284458} y {SPELL:1284487}; ambos piden un defensivo.",
	RAID_BOSS_ENTOMBEDSENT_HEALER = "Disipa {SPELL:1284483} — cuando se pida, no a la vista.",
	RAID_BOSS_LOSTEXPLORERS_STEPS = "• Interrumpe {SPELL:1286921}.|n• El suelo es la pelea: esquiva {SPELL:1291759}, {SPELL:1291933} y {SPELL:1295886}.|n• {SPELL:1290711}: nuestras dos fuentes se contradicen — separarse o juntarse — sigue la indicación de tu líder.|n• Da Disgusting Fish a los Tortollan poseídos para romper la posesión.",
	RAID_BOSS_VASHNIK_STEPS = "• Cuando bebe ({SPELL:1283164}), los adds de veneno reptan hacia el centro — mátalos antes de que lleguen.|n• Llévate {SPELL:1281907} lejos del grupo.|n• Ayuda a absorber {SPELL:1282509}.|n• Esquiva {SPELL:1294994} y {SPELL:1302489}.",
	RAID_BOSS_VASHNIK_TANK = "Defensivo con {SPELL:1280935}.",
	RAID_BOSS_SSZORAK_STEPS = "• El viento es el enemigo: {SPELL:1285732} te empuja — vigila lo que tienes detrás.|n• Esquiva {SPELL:1305959}, sepárate para {SPELL:1285733}.|n• No toques los quistes del suelo.",
	RAID_BOSS_SSZORAK_TANK = "{SPELL:1285430} es un combo — mantén un defensivo durante todo.",
	RAID_BOSS_TWINFANGS_STEPS = "• El debuff de veneno de todos sigue acumulándose; ponte en {SPELL:1290516} para que se lo coman antes de que te aturda.|n• Ayuda a absorber {SPELL:1288484}.|n• Esquiva el frontal de {SPELL:1294293}, mata a los adds de {SPELL:1291404}.",
	RAID_BOSS_TWINFANGS_TANK = "Los debuffs de tanque de los dos jefes no deben mezclarse nunca — quédate con tu jefe, nunca los cruces.",
	RAID_BOSS_COILEDALTAR_STEPS = "• Daos espacio en Guillotine.|n• Romped el escudo de {SPELL:1286918}, esquiva {SPELL:1283832}.|n• Si controlan a alguien ({SPELL:1289900}), liberadle.|n• Tres fases; al final mantened las vidas de ambos jefes igualadas — si uno muere antes, el otro se enfurece.",
	RAID_BOSS_COILEDALTAR_HEALER = "Disipa el veneno: {SPELL:1282281}.",
	RAID_BOSS_ULATEK_STEPS = "• Esquiva {SPELL:1292403}, agrupaos para {SPELL:1287265}.|n• Durante {SPELL:1286860} su Venomous Heart queda expuesto — quemadlo.|n• Interrumpe {SPELL:1290779} en los adds.|n• Al final la plataforma se rompe: pisa lo que quede.|n• Nunca apareció en el PTR — espera sorpresas; esta página se corregirá con pulls reales.",
	RAID_BOSS_CHIMAERUS_TANK = "• Rending Tear es un sangrado + empuje — oriéntalo lejos del raid y no dejes que te empuje fuera de la plataforma; intercambia el add Colossal Horror con el off-tank.",
	RAID_BOSS_CHIMAERUS_HEALER = "• El daño se dispara durante el interludio (Corrupted Devastation / Ravenous Dive) y cada vez que un add alcanza al jefe — guarda los cooldowns para esas ventanas.",

	-- The Voidspire — Imperator Averzian -----------------------------------
	RAID_BOSS_AVERZIAN_STEPS = "• Un combate de territorio: los adds son inmunes hasta que los golpea {SPELL:1249262} (Umbral Collapse, un soak de grupo) — suelta el soak encima de los adds para hacerlos matables.|n• Nunca dejes que tres portales se potencien entre sí: eso lanza {SPELL:1251583}, el wipe.|n• Interrumpe {SPELL:1255702}.|n• Mata sin demora a los adds Abyssal Voidshaper.|n• Key casts: esquiva {SPELL:1258880} & {SPELL:1260712}, soakea {SPELL:1249265}, y mata a los adds ({SPELL:1283069}). (Timeline de EXBoss — confirmar en el juego.)",
	RAID_BOSS_AVERZIAN_HEALER = "• El soak de grupo ({SPELL:1249262}) cae sobre todos apilados juntos — sube la vida del raid antes de cada uno.",

	-- The Voidspire — Vorasius ---------------------------------------------
	RAID_BOSS_VORASIUS_STEPS = "• Levanta muros de cristal; úsalos como cobertura contra {SPELL:1256855} — colócate detrás de un muro cuando respire.|n• Kitea a los adds Blistercreep hacia los muros para romperlos y abrir carriles seguros.|n• Su daño aumenta con cada serie de muros — mantén el ritmo, es un soft enrage.|n• Key casts: esquiva {SPELL:1243853}, y dispérsate para el AoE ({SPELL:1254199} / {SPELL:1260046}). (Timeline de EXBoss — confirmar en el juego.)",
	RAID_BOSS_VORASIUS_HEALER = "• El daño al raid sube con cada fase de muros (soft enrage) — dosifica tus cooldowns para cubrir las últimas series.",

	-- The Voidspire — Fallen-King Salhadaar --------------------------------
	RAID_BOSS_SALHADAAR_STEPS = "• {SPELL:1247738} genera adds-orbe Concentrated Void — mátalos antes de que lleguen al jefe.|n• A energía máxima lanza {SPELL:1246175}: esquiva los rayos. Durante eso recibe +25% de daño durante ~20s — esa es tu ventana de burn.|n• Mantén los orbes bajo control y guarda el burst para la ventana de Unraveling.|n• Key casts: interrumpe {SPELL:1254081}, esquiva {SPELL:1253911}, y mata a los adds ({SPELL:1243453}). (Timeline de EXBoss — confirmar en el juego.)",
	RAID_BOSS_SALHADAAR_DPS = "• Reserva los cooldowns para la ventana de {SPELL:1246175} (+25% de daño recibido durante ~20s); de lo contrario, prioriza los orbes Concentrated Void sobre el jefe.",

	-- The Voidspire — Vaelgor & Ezzorak ------------------------------------
	RAID_BOSS_VAELGOR_STEPS = "• Dos jefes — mantén su vida pareja: {SPELL:1270189} significa que debes repartir el daño por igual, o ganan un gran bonus (el soft enrage).|n• Sal de {SPELL:1244221}; soakea {SPELL:1245391} antes de que el orbe toque un muro para mantener la sala abierta.|n• Durante el interludio, colócate dentro de {SPELL:1248847} para sobrevivir al daño pulsante.|n• Key casts: sal de los frontales ({SPELL:1277471} / {SPELL:1277472}), mata a los adds ({SPELL:1244917} / {SPELL:1277473}); los sanadores vigilan {SPELL:1249748}. (Timeline de EXBoss — confirmar en el juego.)",
	RAID_BOSS_VAELGOR_TANK = "• {SPELL:1262623} es un soak de tanque acumulable — gestiónalo con el otro tanque; mantén a los dos jefes lo bastante cerca para un daño parejo pero con sus frontales apuntando lejos del raid.",
	RAID_BOSS_VAELGOR_HEALER = "• El interludio pulsa fuerte — asegúrate de que todos estén dentro de {SPELL:1248847}, y sube la vida antes de cada ventana de Twilight Bond.",

	-- The Voidspire — Lightblinded Vanguard --------------------------------
	RAID_BOSS_VANGUARD_STEPS = "• Tres paladines combatidos juntos: {SPELL:1248983} es el lanzamiento peligroso a controlar.|n• A energía máxima un paladín lanza un aura que potencia a los otros dos — saca a los jefes de ella: {SPELL:1248449}, {SPELL:1246162}, {SPELL:1248451}.|n• Key casts: esquiva {SPELL:1248644}, soakea {SPELL:1276368}, dispérsate para {SPELL:1246485}, sal del frontal {SPELL:1249130}; los sanadores vigilan {SPELL:1276831}. (Timeline de EXBoss — confirmar en el juego.)",
	RAID_BOSS_VANGUARD_TANK = "• {SPELL:1246736} marca el cambio de tanque — intercambia en los stacks y mantén a los tres paladines agrupados para el cleave pero fuera del aura activa.",

	-- The Voidspire — Crown of the Cosmos ----------------------------------
	RAID_BOSS_CROWN_STEPS = "• El final: tres fases con interludios ({SPELL:1238843}), con tres mini-jefes (Xal'atath con Turalyon, Arator y Alleria) antes del empuje final.|n• Sobrevive a cada interludio y luego quema al objetivo activo en cada fase.|n• Hechizos clave: esquiva {SPELL:1234564} & {SPELL:1235622}, coloca {SPELL:1233819} lejos del grupo, mata a los adds ({SPELL:1261016} / {SPELL:1261339}) y empuja a través del enrage final ({SPELL:1239582}). (Datos de habilidades de la timeline de EXBoss — confirmar en el juego.)",

	-- March on Quel'Danas — Belo'ren, Child of Al'ar -----------------------
	RAID_BOSS_BELOREN_STEPS = "• Te separan por color al inicio: {SPELL:1241162} y {SPELL:1241163} — solo puedes interactuar con las mecánicas que coincidan con tu color, así que aprende en qué lado estás.|n• A 0 de vida no muere — {SPELL:1241313} lo convierte en un huevo en el centro. El huevo es la barra de vida real: quémalo, y luego el ciclo se repite.|n• Activa tus orbes de tu color para crear huecos seguros, y sigue gestionando los lanzamientos asignados a tu color.|n• Hechizos clave: esquiva {SPELL:1242792}, soak {SPELL:1241292} / {SPELL:1241339}, mueve {SPELL:1246709} lejos, usa un defensivo para {SPELL:1244344}, y empuja el enrage {SPELL:1241267}. (Timeline de EXBoss — confirmar en el juego.)",

	-- March on Quel'Danas — Midnight Falls (L'ura) -------------------------
	RAID_BOSS_LURA_STEPS = "• Fase 1 (Death's Dirge): cinco jugadores reciben símbolos Dark Rune en un orden fijo — el láser giratorio debe golpear a esos jugadores en ese mismo orden, así que cántalo.|n• Fase 2 (Void Cores): rayos (Galvanize) caen sobre cuatro jugadores — apúntalos hacia los Void Cores para detonarlos; un núcleo dañado se abre y te succiona.|n• The Darkwell en el centro es muerte instantánea; Total Eclipse atrae a todos hacia él, y el anillo exterior (Iris of Oblivion) mata a quien salga de la arena. Esquiva las púas de Starsplinter.|n• Hechizos clave: interrumpe {SPELL:1251386}, esquiva {SPELL:1253915} & {SPELL:1279420}, mueve {SPELL:1250898} lejos, y usa un defensivo para el empuje {SPELL:1281194} y el interludio {SPELL:1282047}. (Timeline de EXBoss — confirmar en el juego.)",
	RAID_BOSS_LURA_TANK = "• Heaven's Lance se acumula hasta 5 y luego aplica Impale (+50% de daño durante ~25s) — intercambia con el off-tank cada ciclo antes de que Impale caiga.",
})

merge(ns._mhLocales and ns._mhLocales.ptBR, {
	-- The Dreamrift — Chimaerus, the Undreamt God ---------------------------
	RAID_BOSS_CHIMAERUS_STEPS = "• Mecânica de energia: os adds caminham até Chimaerus — mate-os antes que cheguem. Se um o alcançar, ele ganha um grande bônus de dano, e com energia cheia devora um add para um quase-wipe.|n• Interrompa {SPELL:1249017} — a conjuração do invocador de Haunting Essence é o kick prioritário.|n• Mate rápido o add Colossal Horror; o dano dele só aumenta.|n• Soake/divida-se para Alndust Upheaval (o raide é dividido em dois grupos) e desvie das linhas de Corrupted Devastation durante o interlúdio.|n• No Mítico entram Dissonance (não fique perto de jogadores na fase oposta) e Rift Madness (um debuff que precisa ser soakado/trocado).|n• Magias-chave: desvie de {SPELL:1245452} & {SPELL:1282856}, prepare-se para o knockback {SPELL:1245404}, guarde um defensivo para {SPELL:1268905}, e AoE pesado em {SPELL:1251021}. (Timeline EXBoss — confirmar no jogo.)",
	RAID_PRERELEASE_NOTE = "Escrito antes da abertura da raid (18 ago), a partir dos módulos do DBM e do diário do próprio jogo. Nada aqui é inventado, mas nada foi ainda percorrido — confirma no combate.",
	RAID_BOSS_NEKZALI_STEPS = "• Foge quando {SPELL:1284103} disparar, e continua a desviar de {SPELL:1294933}.|n• Mata depressa os adds de {SPELL:1297630}.|n• Ajuda a absorver a Hungering Pyre quando o teu grupo pedir.|n• A meia vida, {SPELL:1299673} muda o padrão dele — muda o ritmo, não as regras.",
	RAID_BOSS_NEKZALI_TANK = "Troca de provocação depois de cada {SPELL:1284103}.",
	RAID_BOSS_ENTOMBEDSENT_STEPS = "• Dois golens: mantém-nos bem afastados — juntos quase não sofrem dano.|n• O teu debuff de {SPELL:1284590} quer exatamente quatro acumulações; depois pisa uma gota de {SPELL:1284434} para o desarmar.|n• Continua a mexer-te durante {SPELL:1284485} — esta luta é posicionamento, não uma corrida.",
	RAID_BOSS_ENTOMBEDSENT_TANK = "Troca em {SPELL:1284458} e {SPELL:1284487}; ambos pedem um defensivo.",
	RAID_BOSS_ENTOMBEDSENT_HEALER = "Dissipa {SPELL:1284483} — quando pedido, não à vista.",
	RAID_BOSS_LOSTEXPLORERS_STEPS = "• Interrompe {SPELL:1286921}.|n• O chão é a luta: desvia de {SPELL:1291759}, {SPELL:1291933} e {SPELL:1295886}.|n• {SPELL:1290711}: as nossas duas fontes contradizem-se — afastar ou juntar — segue a indicação do teu líder.|n• Dá Disgusting Fish aos Tortollans possuídos para quebrar a possessão.",
	RAID_BOSS_VASHNIK_STEPS = "• Quando ele bebe ({SPELL:1283164}), adds de veneno rastejam para o centro — mata-os antes de chegarem.|n• Leva {SPELL:1281907} para longe do grupo.|n• Ajuda a absorver {SPELL:1282509}.|n• Desvia de {SPELL:1294994} e {SPELL:1302489}.",
	RAID_BOSS_VASHNIK_TANK = "Defensivo em {SPELL:1280935}.",
	RAID_BOSS_SSZORAK_STEPS = "• O vento é o inimigo: {SPELL:1285732} empurra-te — repara no que está atrás de ti.|n• Desvia de {SPELL:1305959}, espalha-te para {SPELL:1285733}.|n• Não toques nos quistos no chão.",
	RAID_BOSS_SSZORAK_TANK = "{SPELL:1285430} é um combo — mantém um defensivo durante tudo.",
	RAID_BOSS_TWINFANGS_STEPS = "• O debuff de veneno de todos continua a acumular; fica em {SPELL:1290516} para que seja devorado antes de te atordoar.|n• Ajuda a absorver {SPELL:1288484}.|n• Desvia do frontal de {SPELL:1294293}, mata os adds de {SPELL:1291404}.",
	RAID_BOSS_TWINFANGS_TANK = "Os debuffs de tanque dos dois chefes nunca se podem misturar — fica com o teu chefe, nunca cruzes.",
	RAID_BOSS_COILEDALTAR_STEPS = "• Deem espaço uns aos outros na Guillotine.|n• Partam o escudo de {SPELL:1286918}, desvia de {SPELL:1283832}.|n• Se alguém for controlado ({SPELL:1289900}), libertem essa pessoa.|n• Três fases; no fim mantenham as vidas dos dois chefes iguais — se um morrer cedo, o outro enfurece.",
	RAID_BOSS_COILEDALTAR_HEALER = "Dissipa o veneno: {SPELL:1282281}.",
	RAID_BOSS_ULATEK_STEPS = "• Desvia de {SPELL:1292403}, juntem-se para {SPELL:1287265}.|n• Durante {SPELL:1286860} o Venomous Heart dela fica exposto — queimem-no.|n• Interrompe {SPELL:1290779} nos adds.|n• No fim a plataforma parte-se: fica em cima do que restar.|n• Ela nunca apareceu no PTR — conta com surpresas; esta página será corrigida com pulls reais.",
	RAID_BOSS_CHIMAERUS_TANK = "• Rending Tear é um sangramento + empurrão — vire-o para longe do raide e não seja jogado para fora da plataforma; troque o add Colossal Horror com o off-tank.",
	RAID_BOSS_CHIMAERUS_HEALER = "• O dano dispara durante o interlúdio (Corrupted Devastation / Ravenous Dive) e cada vez que um add alcança o chefe — guarde os cooldowns para essas janelas.",

	-- The Voidspire — Imperator Averzian -----------------------------------
	RAID_BOSS_AVERZIAN_STEPS = "• Uma luta de território: os adds são imunes até serem atingidos por {SPELL:1249262} (Umbral Collapse, um soak de grupo) — solte o soak em cima dos adds para torná-los matáveis.|n• Nunca deixe três portais se fortalecerem mutuamente: isso conjura {SPELL:1251583}, o wipe.|n• Interrompa {SPELL:1255702}.|n• Mate prontamente os adds Abyssal Voidshaper.|n• Key casts: desvie de {SPELL:1258880} & {SPELL:1260712}, soake {SPELL:1249265}, e mate os adds ({SPELL:1283069}). (Timeline EXBoss — confirmar no jogo.)",
	RAID_BOSS_AVERZIAN_HEALER = "• O soak de grupo ({SPELL:1249262}) cai sobre todos agrupados juntos — encha a vida do raide antes de cada um.",

	-- The Voidspire — Vorasius ---------------------------------------------
	RAID_BOSS_VORASIUS_STEPS = "• Ele ergue paredes de cristal; use-as como cobertura contra {SPELL:1256855} — fique atrás de uma parede quando ele sopra.|n• Kite os adds Blistercreep nas paredes para quebrá-las e abrir corredores seguros.|n• O dano dele aumenta a cada conjunto de paredes — mantenha o ritmo, é um soft enrage.|n• Key casts: desvie de {SPELL:1243853}, e espalhe-se para o AoE ({SPELL:1254199} / {SPELL:1260046}). (Timeline EXBoss — confirmar no jogo.)",
	RAID_BOSS_VORASIUS_HEALER = "• O dano ao raide sobe a cada fase de paredes (soft enrage) — distribua seus cooldowns para cobrir os conjuntos finais.",

	-- The Voidspire — Fallen-King Salhadaar --------------------------------
	RAID_BOSS_SALHADAAR_STEPS = "• {SPELL:1247738} gera adds-orbe Concentrated Void — mate-os antes que cheguem ao chefe.|n• Com energia cheia ele conjura {SPELL:1246175}: desvie dos feixes. Durante isso ele recebe +25% de dano por ~20s — essa é sua janela de burn.|n• Mantenha os orbes sob controle e guarde o burst para a janela de Unraveling.|n• Key casts: interrompa {SPELL:1254081}, desvie de {SPELL:1253911}, e mate os adds ({SPELL:1243453}). (Timeline EXBoss — confirmar no jogo.)",
	RAID_BOSS_SALHADAAR_DPS = "• Segure os cooldowns para a janela de {SPELL:1246175} (+25% de dano recebido por ~20s); caso contrário, priorize os orbes Concentrated Void sobre o chefe.",

	-- The Voidspire — Vaelgor & Ezzorak ------------------------------------
	RAID_BOSS_VAELGOR_STEPS = "• Dois chefes — mantenha a vida deles próxima: {SPELL:1270189} significa que você deve dividir o dano por igual, ou eles ganham um grande bônus (o soft enrage).|n• Saia de {SPELL:1244221}; soake {SPELL:1245391} antes que o orbe atinja uma parede para manter a sala aberta.|n• Durante o interlúdio, fique dentro de {SPELL:1248847} para sobreviver ao dano pulsante.|n• Key casts: saia dos frontais ({SPELL:1277471} / {SPELL:1277472}), mate os adds ({SPELL:1244917} / {SPELL:1277473}); curadores ficam de olho em {SPELL:1249748}. (Timeline EXBoss — confirmar no jogo.)",
	RAID_BOSS_VAELGOR_TANK = "• {SPELL:1262623} é um soak de tank acumulável — gerencie-o com o outro tank; mantenha os dois chefes próximos o bastante para dano equilibrado, mas com os frontais apontados para longe do raide.",
	RAID_BOSS_VAELGOR_HEALER = "• O interlúdio pulsa forte — garanta que todos estejam dentro de {SPELL:1248847}, e encha a vida antes de cada janela de Twilight Bond.",

	-- The Voidspire — Lightblinded Vanguard --------------------------------
	RAID_BOSS_VANGUARD_STEPS = "• Três paladinos combatidos juntos: {SPELL:1248983} é a conjuração perigosa a controlar.|n• Com energia cheia um paladino conjura uma aura que fortalece os outros dois — arraste os chefes para fora dela: {SPELL:1248449}, {SPELL:1246162}, {SPELL:1248451}.|n• Key casts: desvie de {SPELL:1248644}, soake {SPELL:1276368}, espalhe-se para {SPELL:1246485}, saia do frontal {SPELL:1249130}; curadores ficam de olho em {SPELL:1276831}. (Timeline EXBoss — confirmar no jogo.)",
	RAID_BOSS_VANGUARD_TANK = "• {SPELL:1246736} impõe a troca de tank — troque nos stacks e mantenha os três paladinos agrupados para o cleave, mas fora da aura ativa.",

	-- The Voidspire — Crown of the Cosmos ----------------------------------
	RAID_BOSS_CROWN_STEPS = "• O final: três estágios com interlúdios ({SPELL:1238843}), apresentando três mini-chefes (Xal'atath com Turalyon, Arator e Alleria) antes do avanço final.|n• Sobreviva a cada interlúdio e então queime o alvo ativo em cada estágio.|n• Magias-chave: desvie de {SPELL:1234564} & {SPELL:1235622}, posicione {SPELL:1233819} longe do grupo, mate os adds ({SPELL:1261016} / {SPELL:1261339}) e avance pelo enrage final ({SPELL:1239582}). (Dados de habilidades da timeline EXBoss — confirmar no jogo.)",

	-- March on Quel'Danas — Belo'ren, Child of Al'ar -----------------------
	RAID_BOSS_BELOREN_STEPS = "• Você é separado por cor no início: {SPELL:1241162} e {SPELL:1241163} — você só pode interagir com mecânicas que combinem com a sua cor, então aprenda de que lado está.|n• Com 0 de vida ele não morre — {SPELL:1241313} o transforma em um ovo no centro. O ovo é a barra de vida real: queime-o, e então o ciclo se repete.|n• Ative seus orbes da sua cor para criar brechas seguras, e continue lidando com as conjurações atribuídas à sua cor.|n• Magias-chave: desvie de {SPELL:1242792}, soak {SPELL:1241292} / {SPELL:1241339}, mova {SPELL:1246709} para longe, use um defensivo para {SPELL:1244344}, e empurre o enrage {SPELL:1241267}. (Timeline EXBoss — confirmar no jogo.)",

	-- March on Quel'Danas — Midnight Falls (L'ura) -------------------------
	RAID_BOSS_LURA_STEPS = "• Fase 1 (Death's Dirge): cinco jogadores recebem símbolos Dark Rune em uma ordem definida — o laser rotativo deve atingir esses jogadores nessa mesma ordem, então anuncie.|n• Fase 2 (Void Cores): feixes (Galvanize) caem sobre quatro jogadores — mire-os nos Void Cores para detoná-los; um núcleo danificado se abre e te puxa para dentro.|n• The Darkwell no centro é morte instantânea; Total Eclipse atrai todos para ele, e o anel externo (Iris of Oblivion) mata quem sair da arena. Desvie das pontas de Starsplinter.|n• Magias-chave: interrompa {SPELL:1251386}, desvie de {SPELL:1253915} & {SPELL:1279420}, mova {SPELL:1250898} para longe, e use um defensivo para o knockback {SPELL:1281194} e o interlúdio {SPELL:1282047}. (Timeline EXBoss — confirmar no jogo.)",
	RAID_BOSS_LURA_TANK = "• Heaven's Lance acumula até 5 e então aplica Impale (+50% de dano por ~25s) — troque com o off-tank a cada ciclo antes de Impale cair.",
})
