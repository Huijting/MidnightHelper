# -*- coding: utf-8 -*-
"""Scratch script — rewritten per task, always run as tools/_probe.py.

Right now, the big one: Season 2 raid tips (15 keys) into Locales/RaidTips.lua,
and the four delve-coach bodies rewritten with bosses and clickable {WAY:} links.

Mechanics of note:
- RaidTips.lua holds seven merge blocks; the script detects each block's language
  from its `merge(ns._mhLocales and ns._mhLocales.XXXX` header instead of assuming
  an order — the per-language-anchor lesson from the Er'inye bullet.
- Spell references are {SPELL:id}: the client renders name, language and tooltip,
  and a wrong id shows as a broken link instead of a silently wrong word.
- Where DBM and the wiki disagree (Blink Nova run-vs-stack) the text says so.
"""
import io
import os
import re
import sys

for _s in (sys.stdout, sys.stderr):
    try:
        _s.reconfigure(encoding="utf-8", errors="replace")
    except (AttributeError, ValueError):
        pass

BASE = r'E:\World of Warcraft\_retail_\Interface\AddOns\MidnightHelper\Locales'
LANGS = ['enUS', 'nlNL', 'deDE', 'frFR', 'esES', 'ptBR', 'itIT']

R = {}  # raid keys -> lang -> text

R['RAID_PRERELEASE_NOTE'] = {
    'enUS': 'Written before the raid opened (18 Aug), from DBM’s encounter modules and the game’s own journal. Nothing here is invented, but none of it has been walked yet — verify against the fight.',
    'nlNL': 'Geschreven vóór de opening van de raid (18 aug), uit DBM’s encounter-modules en het journal van het spel zelf. Niets hier is verzonnen, maar niets is al gelopen — toets het aan het gevecht.',
    'deDE': 'Geschrieben vor der Öffnung des Raids (18. Aug.), aus DBMs Encounter-Modulen und dem Journal des Spiels selbst. Nichts hier ist erfunden, aber nichts davon wurde schon gelaufen — prüfe es am Kampf.',
    'frFR': 'Écrit avant l’ouverture du raid (18 août), à partir des modules DBM et du journal du jeu lui-même. Rien ici n’est inventé, mais rien n’a encore été parcouru — vérifie face au combat.',
    'esES': 'Escrito antes de la apertura de la banda (18 ago), a partir de los módulos de DBM y del diario del propio juego. Nada aquí es inventado, pero nada se ha recorrido aún — contrástalo con el combate.',
    'ptBR': 'Escrito antes da abertura da raid (18 ago), a partir dos módulos do DBM e do diário do próprio jogo. Nada aqui é inventado, mas nada foi ainda percorrido — confirma no combate.',
    'itIT': 'Scritto prima dell’apertura del raid (18 ago), dai moduli DBM e dal diario del gioco stesso. Niente qui è inventato, ma niente è stato ancora percorso — verificalo nello scontro.',
}

R['RAID_BOSS_NEKZALI_STEPS'] = {
    'enUS': '• Run out when {SPELL:1284103} fires, and keep dodging {SPELL:1294933}.|n• Kill the {SPELL:1297630} adds quickly.|n• Help soak Hungering Pyre when your group calls it.|n• At half health {SPELL:1299673} changes his pattern — the rhythm changes, the rules do not.',
    'nlNL': '• Ren weg bij {SPELL:1284103}, en blijf {SPELL:1294933} ontwijken.|n• Dood de {SPELL:1297630}-adds snel.|n• Help soaken bij Hungering Pyre als je groep het afroept.|n• Op de helft verandert {SPELL:1299673} zijn patroon — het ritme wisselt, de regels niet.',
    'deDE': '• Lauf raus, wenn {SPELL:1284103} kommt, und weiche {SPELL:1294933} weiter aus.|n• Töte die {SPELL:1297630}-Adds schnell.|n• Hilf beim Soaken der Hungering Pyre, wenn deine Gruppe es ansagt.|n• Bei halber Gesundheit ändert {SPELL:1299673} sein Muster — der Rhythmus wechselt, die Regeln nicht.',
    'frFR': '• Écarte-toi quand {SPELL:1284103} part, et continue d’esquiver {SPELL:1294933}.|n• Tue vite les adds {SPELL:1297630}.|n• Aide à absorber Hungering Pyre quand ton groupe l’annonce.|n• À mi-vie, {SPELL:1299673} change son schéma — le rythme change, pas les règles.',
    'esES': '• Sal corriendo cuando salga {SPELL:1284103}, y sigue esquivando {SPELL:1294933}.|n• Mata rápido a los adds de {SPELL:1297630}.|n• Ayuda a absorber Hungering Pyre cuando tu grupo lo pida.|n• A media vida, {SPELL:1299673} cambia su patrón — cambia el ritmo, no las reglas.',
    'ptBR': '• Foge quando {SPELL:1284103} disparar, e continua a desviar de {SPELL:1294933}.|n• Mata depressa os adds de {SPELL:1297630}.|n• Ajuda a absorver a Hungering Pyre quando o teu grupo pedir.|n• A meia vida, {SPELL:1299673} muda o padrão dele — muda o ritmo, não as regras.',
    'itIT': '• Corri via quando parte {SPELL:1284103}, e continua a schivare {SPELL:1294933}.|n• Uccidi in fretta gli add di {SPELL:1297630}.|n• Aiuta a soakare la Hungering Pyre quando il gruppo la chiama.|n• A metà vita {SPELL:1299673} cambia lo schema — cambia il ritmo, non le regole.',
}

R['RAID_BOSS_NEKZALI_TANK'] = {
    'enUS': 'Taunt-swap after every {SPELL:1284103}.',
    'nlNL': 'Taunt-swap na elke {SPELL:1284103}.',
    'deDE': 'Spott-Wechsel nach jedem {SPELL:1284103}.',
    'frFR': 'Échange de provocation après chaque {SPELL:1284103}.',
    'esES': 'Cambio de provocación tras cada {SPELL:1284103}.',
    'ptBR': 'Troca de provocação depois de cada {SPELL:1284103}.',
    'itIT': 'Cambio con provocazione dopo ogni {SPELL:1284103}.',
}

R['RAID_BOSS_ENTOMBEDSENT_STEPS'] = {
    'enUS': '• Two golems: keep them far apart — close together they barely take damage.|n• Your {SPELL:1284590} debuff wants exactly four stacks; then stand on a {SPELL:1284434} droplet to defuse it.|n• Keep moving through {SPELL:1284485} — this fight is positioning, not a race.',
    'nlNL': '• Twee golems: houd ze ver uit elkaar — dicht bij elkaar nemen ze nauwelijks schade.|n• Je {SPELL:1284590}-debuff wil precies vier stacks; ga daarna op een {SPELL:1284434}-druppel staan om hem onschadelijk te maken.|n• Blijf bewegen bij {SPELL:1284485} — dit gevecht is positie, geen race.',
    'deDE': '• Zwei Golems: halte sie weit auseinander — nah beieinander nehmen sie kaum Schaden.|n• Dein {SPELL:1284590}-Debuff will genau vier Stacks; stell dich dann auf einen {SPELL:1284434}-Tropfen, um ihn zu entschärfen.|n• Bleib in Bewegung bei {SPELL:1284485} — dieser Kampf ist Positionsspiel, kein Wettrennen.',
    'frFR': '• Deux golems : garde-les loin l’un de l’autre — proches, ils ne prennent presque pas de dégâts.|n• Ton debuff {SPELL:1284590} veut exactement quatre stacks ; ensuite place-toi sur une goutte {SPELL:1284434} pour le désamorcer.|n• Reste en mouvement pendant {SPELL:1284485} — ce combat est du placement, pas une course.',
    'esES': '• Dos gólems: mantenlos bien separados — juntos apenas reciben daño.|n• Tu debuff de {SPELL:1284590} quiere exactamente cuatro acumulaciones; luego pisa una gota de {SPELL:1284434} para desactivarlo.|n• Sigue moviéndote con {SPELL:1284485} — esta pelea es de colocación, no una carrera.',
    'ptBR': '• Dois golens: mantém-nos bem afastados — juntos quase não sofrem dano.|n• O teu debuff de {SPELL:1284590} quer exatamente quatro acumulações; depois pisa uma gota de {SPELL:1284434} para o desarmar.|n• Continua a mexer-te durante {SPELL:1284485} — esta luta é posicionamento, não uma corrida.',
    'itIT': '• Due golem: tienili ben distanti — vicini non subiscono quasi danni.|n• Il tuo debuff {SPELL:1284590} vuole esattamente quattro stack; poi mettiti su una goccia di {SPELL:1284434} per disinnescarlo.|n• Continua a muoverti con {SPELL:1284485} — questo scontro è posizionamento, non una corsa.',
}

R['RAID_BOSS_ENTOMBEDSENT_TANK'] = {
    'enUS': 'Swap on {SPELL:1284458} and {SPELL:1284487}; both want a defensive.',
    'nlNL': 'Swap op {SPELL:1284458} en {SPELL:1284487}; allebei willen een defensive.',
    'deDE': 'Wechsel bei {SPELL:1284458} und {SPELL:1284487}; beide wollen eine Defensive.',
    'frFR': 'Échange sur {SPELL:1284458} et {SPELL:1284487} ; les deux demandent un défensif.',
    'esES': 'Cambio con {SPELL:1284458} y {SPELL:1284487}; ambos piden un defensivo.',
    'ptBR': 'Troca em {SPELL:1284458} e {SPELL:1284487}; ambos pedem um defensivo.',
    'itIT': 'Cambio su {SPELL:1284458} e {SPELL:1284487}; entrambi vogliono una difensiva.',
}

R['RAID_BOSS_ENTOMBEDSENT_HEALER'] = {
    'enUS': 'Dispel {SPELL:1284483} — on call, not on sight.',
    'nlNL': 'Dispel {SPELL:1284483} — op afroep, niet meteen.',
    'deDE': 'Entferne {SPELL:1284483} — auf Ansage, nicht sofort.',
    'frFR': 'Dissipe {SPELL:1284483} — à l’annonce, pas à vue.',
    'esES': 'Disipa {SPELL:1284483} — cuando se pida, no a la vista.',
    'ptBR': 'Dissipa {SPELL:1284483} — quando pedido, não à vista.',
    'itIT': 'Dissipa {SPELL:1284483} — a chiamata, non a vista.',
}

R['RAID_BOSS_LOSTEXPLORERS_STEPS'] = {
    'enUS': '• Interrupt {SPELL:1286921}.|n• The floor is the fight: dodge {SPELL:1291759}, {SPELL:1291933} and {SPELL:1295886}.|n• {SPELL:1290711}: our two sources disagree — run out or stack up — so follow your leader’s call.|n• Feed Disgusting Fish to possessed Tortollans to break the possession.',
    'nlNL': '• Interrupt {SPELL:1286921}.|n• De vloer ís het gevecht: ontwijk {SPELL:1291759}, {SPELL:1291933} en {SPELL:1295886}.|n• {SPELL:1290711}: onze twee bronnen spreken elkaar tegen — wegrennen of juist stapelen — volg dus de afroep van je leider.|n• Voer Disgusting Fish aan bezeten Tortollans om de bezetenheid te breken.',
    'deDE': '• Unterbrich {SPELL:1286921}.|n• Der Boden ist der Kampf: weiche {SPELL:1291759}, {SPELL:1291933} und {SPELL:1295886} aus.|n• {SPELL:1290711}: unsere zwei Quellen widersprechen sich — rauslaufen oder stapeln — folge also der Ansage deines Leiters.|n• Füttere besessene Tortollan mit Disgusting Fish, um die Besessenheit zu brechen.',
    'frFR': '• Interromps {SPELL:1286921}.|n• Le sol est le combat : esquive {SPELL:1291759}, {SPELL:1291933} et {SPELL:1295886}.|n• {SPELL:1290711} : nos deux sources se contredisent — s’écarter ou se regrouper — suis donc l’annonce de ton leader.|n• Donne des Disgusting Fish aux Tortollans possédés pour briser la possession.',
    'esES': '• Interrumpe {SPELL:1286921}.|n• El suelo es la pelea: esquiva {SPELL:1291759}, {SPELL:1291933} y {SPELL:1295886}.|n• {SPELL:1290711}: nuestras dos fuentes se contradicen — separarse o juntarse — sigue la indicación de tu líder.|n• Da Disgusting Fish a los Tortollan poseídos para romper la posesión.',
    'ptBR': '• Interrompe {SPELL:1286921}.|n• O chão é a luta: desvia de {SPELL:1291759}, {SPELL:1291933} e {SPELL:1295886}.|n• {SPELL:1290711}: as nossas duas fontes contradizem-se — afastar ou juntar — segue a indicação do teu líder.|n• Dá Disgusting Fish aos Tortollans possuídos para quebrar a possessão.',
    'itIT': '• Interrompi {SPELL:1286921}.|n• Il pavimento è lo scontro: schiva {SPELL:1291759}, {SPELL:1291933} e {SPELL:1295886}.|n• {SPELL:1290711}: le nostre due fonti si contraddicono — allontanarsi o ammassarsi — segui quindi la chiamata del tuo leader.|n• Dai Disgusting Fish ai Tortollan posseduti per spezzare la possessione.',
}

R['RAID_BOSS_VASHNIK_STEPS'] = {
    'enUS': '• When he drinks ({SPELL:1283164}), venom adds crawl toward the centre — kill them before they arrive.|n• Carry {SPELL:1281907} away from the group.|n• Help soak {SPELL:1282509}.|n• Dodge {SPELL:1294994} and {SPELL:1302489}.',
    'nlNL': '• Als hij drinkt ({SPELL:1283164}) kruipen gif-adds naar het midden — dood ze voordat ze aankomen.|n• Neem {SPELL:1281907} weg van de groep.|n• Help soaken bij {SPELL:1282509}.|n• Ontwijk {SPELL:1294994} en {SPELL:1302489}.',
    'deDE': '• Wenn er trinkt ({SPELL:1283164}), kriechen Gift-Adds zur Mitte — töte sie, bevor sie ankommen.|n• Trag {SPELL:1281907} von der Gruppe weg.|n• Hilf beim Soaken von {SPELL:1282509}.|n• Weiche {SPELL:1294994} und {SPELL:1302489} aus.',
    'frFR': '• Quand il boit ({SPELL:1283164}), des adds de venin rampent vers le centre — tue-les avant qu’ils n’arrivent.|n• Emporte {SPELL:1281907} loin du groupe.|n• Aide à absorber {SPELL:1282509}.|n• Esquive {SPELL:1294994} et {SPELL:1302489}.',
    'esES': '• Cuando bebe ({SPELL:1283164}), los adds de veneno reptan hacia el centro — mátalos antes de que lleguen.|n• Llévate {SPELL:1281907} lejos del grupo.|n• Ayuda a absorber {SPELL:1282509}.|n• Esquiva {SPELL:1294994} y {SPELL:1302489}.',
    'ptBR': '• Quando ele bebe ({SPELL:1283164}), adds de veneno rastejam para o centro — mata-os antes de chegarem.|n• Leva {SPELL:1281907} para longe do grupo.|n• Ajuda a absorver {SPELL:1282509}.|n• Desvia de {SPELL:1294994} e {SPELL:1302489}.',
    'itIT': '• Quando beve ({SPELL:1283164}), add di veleno strisciano verso il centro — uccidili prima che arrivino.|n• Porta {SPELL:1281907} lontano dal gruppo.|n• Aiuta a soakare {SPELL:1282509}.|n• Schiva {SPELL:1294994} e {SPELL:1302489}.',
}

R['RAID_BOSS_VASHNIK_TANK'] = {
    'enUS': 'Defensive on {SPELL:1280935}.',
    'nlNL': 'Defensive op {SPELL:1280935}.',
    'deDE': 'Defensive bei {SPELL:1280935}.',
    'frFR': 'Défensif sur {SPELL:1280935}.',
    'esES': 'Defensivo con {SPELL:1280935}.',
    'ptBR': 'Defensivo em {SPELL:1280935}.',
    'itIT': 'Difensiva su {SPELL:1280935}.',
}

R['RAID_BOSS_SSZORAK_STEPS'] = {
    'enUS': '• Wind is the enemy: {SPELL:1285732} pushes you — mind what is behind you.|n• Dodge {SPELL:1305959}, spread for {SPELL:1285733}.|n• Do not touch the cysts on the floor.',
    'nlNL': '• De wind is de vijand: {SPELL:1285732} duwt je — let op wat er achter je ligt.|n• Ontwijk {SPELL:1305959}, spreid voor {SPELL:1285733}.|n• Blijf van de cysten op de vloer af.',
    'deDE': '• Der Wind ist der Feind: {SPELL:1285732} schiebt dich — achte darauf, was hinter dir liegt.|n• Weiche {SPELL:1305959} aus, verteilt euch bei {SPELL:1285733}.|n• Fass die Zysten am Boden nicht an.',
    'frFR': '• Le vent est l’ennemi : {SPELL:1285732} te pousse — regarde ce qu’il y a derrière toi.|n• Esquive {SPELL:1305959}, dispersez-vous pour {SPELL:1285733}.|n• Ne touche pas aux kystes au sol.',
    'esES': '• El viento es el enemigo: {SPELL:1285732} te empuja — vigila lo que tienes detrás.|n• Esquiva {SPELL:1305959}, sepárate para {SPELL:1285733}.|n• No toques los quistes del suelo.',
    'ptBR': '• O vento é o inimigo: {SPELL:1285732} empurra-te — repara no que está atrás de ti.|n• Desvia de {SPELL:1305959}, espalha-te para {SPELL:1285733}.|n• Não toques nos quistos no chão.',
    'itIT': '• Il vento è il nemico: {SPELL:1285732} ti spinge — bada a cosa hai alle spalle.|n• Schiva {SPELL:1305959}, sparpagliatevi per {SPELL:1285733}.|n• Non toccare le cisti sul pavimento.',
}

R['RAID_BOSS_SSZORAK_TANK'] = {
    'enUS': '{SPELL:1285430} is a combo — hold a defensive through all of it.',
    'nlNL': '{SPELL:1285430} is een combo — houd er een defensive doorheen vast.',
    'deDE': '{SPELL:1285430} ist eine Kombo — halte eine Defensive durchgehend.',
    'frFR': '{SPELL:1285430} est un combo — garde un défensif pendant toute sa durée.',
    'esES': '{SPELL:1285430} es un combo — mantén un defensivo durante todo.',
    'ptBR': '{SPELL:1285430} é um combo — mantém um defensivo durante tudo.',
    'itIT': '{SPELL:1285430} è una combo — tieni una difensiva per tutta la durata.',
}

R['RAID_BOSS_TWINFANGS_STEPS'] = {
    'enUS': '• Everyone’s venom debuff keeps stacking; stand in {SPELL:1290516} to get it eaten before it stuns you.|n• Help soak {SPELL:1288484}.|n• Dodge the {SPELL:1294293} frontal, kill the {SPELL:1291404} adds.',
    'nlNL': '• Ieders gif-debuff blijft stapelen; ga in {SPELL:1290516} staan zodat hij wordt opgegeten vóór hij je stunt.|n• Help soaken bij {SPELL:1288484}.|n• Ontwijk de {SPELL:1294293}-frontal, dood de {SPELL:1291404}-adds.',
    'deDE': '• Der Gift-Debuff aller stapelt weiter; stell dich in {SPELL:1290516}, damit er gefressen wird, bevor er dich betäubt.|n• Hilf beim Soaken von {SPELL:1288484}.|n• Weiche dem {SPELL:1294293}-Frontal aus, töte die {SPELL:1291404}-Adds.',
    'frFR': '• Le debuff de venin de chacun continue de monter ; place-toi dans {SPELL:1290516} pour le faire dévorer avant qu’il ne t’étourdisse.|n• Aide à absorber {SPELL:1288484}.|n• Esquive le frontal {SPELL:1294293}, tue les adds de {SPELL:1291404}.',
    'esES': '• El debuff de veneno de todos sigue acumulándose; ponte en {SPELL:1290516} para que se lo coman antes de que te aturda.|n• Ayuda a absorber {SPELL:1288484}.|n• Esquiva el frontal de {SPELL:1294293}, mata a los adds de {SPELL:1291404}.',
    'ptBR': '• O debuff de veneno de todos continua a acumular; fica em {SPELL:1290516} para que seja devorado antes de te atordoar.|n• Ajuda a absorver {SPELL:1288484}.|n• Desvia do frontal de {SPELL:1294293}, mata os adds de {SPELL:1291404}.',
    'itIT': '• Il debuff di veleno di tutti continua a salire; mettiti in {SPELL:1290516} perché venga divorato prima che ti stordisca.|n• Aiuta a soakare {SPELL:1288484}.|n• Schiva il frontale di {SPELL:1294293}, uccidi gli add di {SPELL:1291404}.',
}

R['RAID_BOSS_TWINFANGS_TANK'] = {
    'enUS': 'The two bosses’ tank debuffs must never mix — keep your own boss, never cross.',
    'nlNL': 'De tank-debuffs van de twee bosses mogen nooit mengen — houd je eigen boss, wissel nooit kruislings.',
    'deDE': 'Die Tank-Debuffs der beiden Bosse dürfen sich nie mischen — behalte deinen Boss, nie kreuzen.',
    'frFR': 'Les debuffs de tank des deux boss ne doivent jamais se mélanger — garde ton boss, ne croise jamais.',
    'esES': 'Los debuffs de tanque de los dos jefes no deben mezclarse nunca — quédate con tu jefe, nunca los cruces.',
    'ptBR': 'Os debuffs de tanque dos dois chefes nunca se podem misturar — fica com o teu chefe, nunca cruzes.',
    'itIT': 'I debuff da tank dei due boss non devono mai mescolarsi — tieni il tuo boss, mai incrociare.',
}

R['RAID_BOSS_COILEDALTAR_STEPS'] = {
    'enUS': '• Give each other room at Guillotine.|n• Break the {SPELL:1286918} shield, dodge {SPELL:1283832}.|n• When someone is mind-controlled ({SPELL:1289900}), free them.|n• Three stages; at the end keep both bosses’ health even — one dying early enrages the other.',
    'nlNL': '• Geef elkaar ruimte bij Guillotine.|n• Sla het {SPELL:1286918}-schild kapot, ontwijk {SPELL:1283832}.|n• Wordt iemand mind-controlled ({SPELL:1289900}), bevrijd diegene.|n• Drie fases; houd aan het eind de levens van beide bosses gelijk — sterft er één te vroeg, dan enraget de ander.',
    'deDE': '• Gebt euch Platz bei Guillotine.|n• Schlagt den {SPELL:1286918}-Schild weg, weiche {SPELL:1283832} aus.|n• Wird jemand gedankenkontrolliert ({SPELL:1289900}), befreit die Person.|n• Drei Phasen; haltet am Ende die Leben beider Bosse gleich — stirbt einer zu früh, gerät der andere in Raserei.',
    'frFR': '• Laissez-vous de la place pour Guillotine.|n• Cassez le bouclier {SPELL:1286918}, esquive {SPELL:1283832}.|n• Si quelqu’un est contrôlé ({SPELL:1289900}), libérez la personne.|n• Trois phases ; à la fin gardez les vies des deux boss égales — l’un qui meurt trop tôt enrage l’autre.',
    'esES': '• Daos espacio en Guillotine.|n• Romped el escudo de {SPELL:1286918}, esquiva {SPELL:1283832}.|n• Si controlan a alguien ({SPELL:1289900}), liberadle.|n• Tres fases; al final mantened las vidas de ambos jefes igualadas — si uno muere antes, el otro se enfurece.',
    'ptBR': '• Deem espaço uns aos outros na Guillotine.|n• Partam o escudo de {SPELL:1286918}, desvia de {SPELL:1283832}.|n• Se alguém for controlado ({SPELL:1289900}), libertem essa pessoa.|n• Três fases; no fim mantenham as vidas dos dois chefes iguais — se um morrer cedo, o outro enfurece.',
    'itIT': '• Datevi spazio sulla Guillotine.|n• Spaccate lo scudo di {SPELL:1286918}, schiva {SPELL:1283832}.|n• Se qualcuno viene controllato ({SPELL:1289900}), liberatelo.|n• Tre fasi; alla fine tenete pari la vita dei due boss — se uno muore troppo presto, l’altro si infuria.',
}

R['RAID_BOSS_COILEDALTAR_HEALER'] = {
    'enUS': 'Dispel poison: {SPELL:1282281}.',
    'nlNL': 'Dispel poison: {SPELL:1282281}.',
    'deDE': 'Gift entfernen: {SPELL:1282281}.',
    'frFR': 'Dissipe le poison : {SPELL:1282281}.',
    'esES': 'Disipa el veneno: {SPELL:1282281}.',
    'ptBR': 'Dissipa o veneno: {SPELL:1282281}.',
    'itIT': 'Dissipa il veleno: {SPELL:1282281}.',
}

R['RAID_BOSS_ULATEK_STEPS'] = {
    'enUS': '• Dodge {SPELL:1292403}, stack for {SPELL:1287265}.|n• During {SPELL:1286860} her Venomous Heart is exposed — burn it.|n• Interrupt {SPELL:1290779} on the adds.|n• At the end the platform breaks apart: stand on what remains.|n• She never appeared on the PTR, so expect surprises — this page will be corrected from real pulls.',
    'nlNL': '• Ontwijk {SPELL:1292403}, stapel voor {SPELL:1287265}.|n• Tijdens {SPELL:1286860} ligt haar Venomous Heart open — burn het.|n• Interrupt {SPELL:1290779} op de adds.|n• Aan het eind breekt het platform af: ga staan op wat overblijft.|n• Ze is nooit op de PTR verschenen, dus reken op verrassingen — deze pagina wordt bijgewerkt uit echte pulls.',
    'deDE': '• Weiche {SPELL:1292403} aus, stapelt euch für {SPELL:1287265}.|n• Während {SPELL:1286860} liegt ihr Venomous Heart offen — burnt es.|n• Unterbrich {SPELL:1290779} bei den Adds.|n• Am Ende bricht die Plattform auseinander: stell dich auf das, was bleibt.|n• Sie war nie auf dem PTR — rechne mit Überraschungen; diese Seite wird aus echten Pulls korrigiert.',
    'frFR': '• Esquive {SPELL:1292403}, regroupez-vous pour {SPELL:1287265}.|n• Pendant {SPELL:1286860}, son Venomous Heart est exposé — brûlez-le.|n• Interromps {SPELL:1290779} sur les adds.|n• À la fin, la plateforme se brise : tiens-toi sur ce qui reste.|n• Elle n’est jamais apparue sur le PTR — attends-toi à des surprises ; cette page sera corrigée à partir de vrais pulls.',
    'esES': '• Esquiva {SPELL:1292403}, agrupaos para {SPELL:1287265}.|n• Durante {SPELL:1286860} su Venomous Heart queda expuesto — quemadlo.|n• Interrumpe {SPELL:1290779} en los adds.|n• Al final la plataforma se rompe: pisa lo que quede.|n• Nunca apareció en el PTR — espera sorpresas; esta página se corregirá con pulls reales.',
    'ptBR': '• Desvia de {SPELL:1292403}, juntem-se para {SPELL:1287265}.|n• Durante {SPELL:1286860} o Venomous Heart dela fica exposto — queimem-no.|n• Interrompe {SPELL:1290779} nos adds.|n• No fim a plataforma parte-se: fica em cima do que restar.|n• Ela nunca apareceu no PTR — conta com surpresas; esta página será corrigida com pulls reais.',
    'itIT': '• Schiva {SPELL:1292403}, ammassatevi per {SPELL:1287265}.|n• Durante {SPELL:1286860} il suo Venomous Heart è esposto — bruciatelo.|n• Interrompi {SPELL:1290779} sugli add.|n• Alla fine la piattaforma si spezza: resta su ciò che rimane.|n• Non è mai apparsa sul PTR — aspettati sorprese; questa pagina sarà corretta dai pull veri.',
}

D = {}  # delve keys -> lang -> replacement text

D['DELVE_TIP_GNARLDOR_OVERVIEW'] = {
    'enUS': '• New in 12.1, on the Coiled Isle — entrance at {WAY:2512:64.3:77.7:Gnarldor Isle}. Scrollmaster Ruma at the entrance starts a short quest chain.|n• Three story variants, two bosses (per Method and Icy Veins — not yet measured on your client). Two variants end at Gralka Snake-Eater: she eats snakes for damage stacks and leaves venom puddles — drag her off them, sidestep the waves of her Purging Breath.|n• The third ends at Osseous Amalgamation: interrupt his bone shield, run from Bonestorm, dodge the bone spikes.|n• Click the Tortollan Scrolls you pass — buffs, some with a catch.',
    'nlNL': '• Nieuw in 12.1, op de Coiled Isle — ingang op {WAY:2512:64.3:77.7:Gnarldor Isle}. Scrollmaster Ruma bij de ingang start een korte questketen.|n• Drie verhaalvarianten, twee bosses (volgens Method en Icy Veins — nog niet op jouw client gemeten). Twee varianten eindigen bij Gralka Snake-Eater: ze eet slangen voor damage-stacks en laat gifplassen achter — trek haar eruit, en stap opzij voor de golven van haar Purging Breath.|n• De derde eindigt bij Osseous Amalgamation: interrupt zijn botschild, ren weg bij Bonestorm, ontwijk de botstekels.|n• Klik de Tortollan Scrolls die je passeert — buffs, soms met een addertje.',
    'deDE': '• Neu in 12.1, auf der Coiled Isle — Eingang bei {WAY:2512:64.3:77.7:Gnarldor Isle}. Scrollmaster Ruma am Eingang startet eine kurze Questkette.|n• Drei Story-Varianten, zwei Bosse (laut Method und Icy Veins — noch nicht auf deinem Client gemessen). Zwei Varianten enden bei Gralka Snake-Eater: sie frisst Schlangen für Schadens-Stacks und hinterlässt Giftpfützen — zieh sie heraus und tritt den Wellen ihres Purging Breath aus dem Weg.|n• Die dritte endet bei Osseous Amalgamation: unterbrich seinen Knochenschild, lauf vor Bonestorm weg, weiche den Knochenstacheln aus.|n• Klick die Tortollan Scrolls am Weg — Buffs, manche mit Haken.',
    'frFR': '• Nouveau en 12.1, sur la Coiled Isle — entrée en {WAY:2512:64.3:77.7:Gnarldor Isle}. Scrollmaster Ruma à l’entrée lance une courte chaîne de quêtes.|n• Trois variantes, deux boss (selon Method et Icy Veins — pas encore mesuré sur ton client). Deux variantes finissent sur Gralka Snake-Eater : elle mange des serpents pour des stacks de dégâts et laisse des flaques de venin — sors-la de là et écarte-toi des vagues de son Purging Breath.|n• La troisième finit sur Osseous Amalgamation : interromps son bouclier d’os, fuis le Bonestorm, esquive les piques.|n• Clique les Tortollan Scrolls sur ton chemin — des buffs, parfois avec un piège.',
    'esES': '• Nuevo en 12.1, en la Coiled Isle — entrada en {WAY:2512:64.3:77.7:Gnarldor Isle}. Scrollmaster Ruma en la entrada inicia una breve cadena de misiones.|n• Tres variantes, dos jefes (según Method e Icy Veins — aún no medido en tu cliente). Dos variantes acaban en Gralka Snake-Eater: come serpientes para acumular daño y deja charcos de veneno — sácala de ellos y apártate de las olas de su Purging Breath.|n• La tercera acaba en Osseous Amalgamation: interrumpe su escudo de hueso, huye del Bonestorm, esquiva las púas.|n• Pulsa los Tortollan Scrolls que encuentres — buffs, algunos con trampa.',
    'ptBR': '• Novo na 12.1, na Coiled Isle — entrada em {WAY:2512:64.3:77.7:Gnarldor Isle}. O Scrollmaster Ruma na entrada inicia uma pequena cadeia de missões.|n• Três variantes, dois chefes (segundo a Method e a Icy Veins — ainda não medido no teu cliente). Duas variantes acabam em Gralka Snake-Eater: ela come cobras para acumular dano e deixa poças de veneno — tira-a de lá e desvia das ondas do Purging Breath dela.|n• A terceira acaba em Osseous Amalgamation: interrompe o escudo de ossos, foge do Bonestorm, desvia dos espigões.|n• Clica nos Tortollan Scrolls pelo caminho — buffs, alguns com rasteira.',
    'itIT': '• Nuovo nella 12.1, sulla Coiled Isle — ingresso a {WAY:2512:64.3:77.7:Gnarldor Isle}. Scrollmaster Ruma all’ingresso avvia una breve catena di missioni.|n• Tre varianti, due boss (secondo Method e Icy Veins — non ancora misurato sul tuo client). Due varianti finiscono con Gralka Snake-Eater: mangia serpenti per stack di danno e lascia pozze di veleno — trascinala fuori e scansa le onde del suo Purging Breath.|n• La terza finisce con Osseous Amalgamation: interrompi il suo scudo d’ossa, scappa dal Bonestorm, schiva gli aculei.|n• Clicca i Tortollan Scrolls che incontri — buff, alcuni con fregatura.',
}

D['DELVE_TIP_GNARLDOR_ROUTE'] = {
    'enUS': '• Three Sturdy Chests — click to set a waypoint: {WAY:2635:60.44:68.12:Sturdy Chest 1} · {WAY:2635:52.41:40.84:Sturdy Chest 2} · {WAY:2635:28.67:41.69:Sturdy Chest 3}.|n• You arrive at about 77, 46; the exit portal stands right there — sweep the chests and you end where you began.',
    'nlNL': '• Drie Sturdy Chests — klik voor een waypoint: {WAY:2635:60.44:68.12:Sturdy Chest 1} · {WAY:2635:52.41:40.84:Sturdy Chest 2} · {WAY:2635:28.67:41.69:Sturdy Chest 3}.|n• Je komt binnen rond 77, 46; de uitgang staat daar ook — loop de kisten langs en je eindigt waar je begon.',
    'deDE': '• Drei Sturdy Chests — klick für einen Wegpunkt: {WAY:2635:60.44:68.12:Sturdy Chest 1} · {WAY:2635:52.41:40.84:Sturdy Chest 2} · {WAY:2635:28.67:41.69:Sturdy Chest 3}.|n• Du kommst bei etwa 77, 46 an; das Ausgangsportal steht genau dort — lauf die Truhen ab und du endest, wo du begonnen hast.',
    'frFR': '• Trois Sturdy Chests — clique pour poser un point de repère : {WAY:2635:60.44:68.12:Sturdy Chest 1} · {WAY:2635:52.41:40.84:Sturdy Chest 2} · {WAY:2635:28.67:41.69:Sturdy Chest 3}.|n• Tu arrives vers 77, 46 ; le portail de sortie est juste là — fais le tour des coffres et tu finis où tu as commencé.',
    'esES': '• Tres Sturdy Chests — pulsa para fijar un punto: {WAY:2635:60.44:68.12:Sturdy Chest 1} · {WAY:2635:52.41:40.84:Sturdy Chest 2} · {WAY:2635:28.67:41.69:Sturdy Chest 3}.|n• Llegas hacia 77, 46; el portal de salida está justo ahí — recorre los cofres y acabas donde empezaste.',
    'ptBR': '• Três Sturdy Chests — clica para marcar um ponto: {WAY:2635:60.44:68.12:Sturdy Chest 1} · {WAY:2635:52.41:40.84:Sturdy Chest 2} · {WAY:2635:28.67:41.69:Sturdy Chest 3}.|n• Chegas por volta de 77, 46; o portal de saída está mesmo aí — percorre as arcas e acabas onde começaste.',
    'itIT': '• Tre Sturdy Chests — clicca per impostare un waypoint: {WAY:2635:60.44:68.12:Sturdy Chest 1} · {WAY:2635:52.41:40.84:Sturdy Chest 2} · {WAY:2635:28.67:41.69:Sturdy Chest 3}.|n• Arrivi verso 77, 46; il portale d’uscita è proprio lì — fai il giro dei forzieri e finisci dove hai iniziato.',
}

D['DELVE_TIP_RINGOFGLORY_OVERVIEW'] = {
    'enUS': '• New in 12.1, on the Coiled Isle — entrance at {WAY:2512:71.1:56.4:The Ring of Glory}. An arena delve: one variant is a gauntlet of duels, one a ghostly ball game, one an animal rescue.|n• The first two end at Drakta (per Method and Icy Veins — not yet measured on your client): dodge his Soul Cleave circle, drag him out of the zone it leaves, and when Death Grip pulls the furthest player in, break line of sight behind a pillar. The rescue ends at Gnok, who rises again undead halfway.|n• Floor traps everywhere — watch your step.|n• Interrupt the Spiritcallers’ self-heal and kill the War Drum the Warsingers plant.',
    'nlNL': '• Nieuw in 12.1, op de Coiled Isle — ingang op {WAY:2512:71.1:56.4:The Ring of Glory}. Een arena-delve: één variant is een reeks duels, één een spookachtig balspel, één een dierenredding.|n• De eerste twee eindigen bij Drakta (volgens Method en Icy Veins — nog niet op jouw client gemeten): ontwijk zijn Soul Cleave-cirkel, trek hem uit de zone die achterblijft, en als Death Grip de verste speler naar binnen trekt, breek zicht achter een pilaar. De redding eindigt bij Gnok, die halverwege ondood terugkomt.|n• Overal vloervallen — kijk waar je loopt.|n• Interrupt de self-heal van de Spiritcallers en sloop de War Drum die de Warsingers neerzetten.',
    'deDE': '• Neu in 12.1, auf der Coiled Isle — Eingang bei {WAY:2512:71.1:56.4:The Ring of Glory}. Ein Arena-Delve: eine Variante ist eine Duellreihe, eine ein geisterhaftes Ballspiel, eine eine Tierrettung.|n• Die ersten zwei enden bei Drakta (laut Method und Icy Veins — noch nicht auf deinem Client gemessen): weiche seinem Soul-Cleave-Kreis aus, zieh ihn aus der Zone, die er hinterlässt, und wenn Death Grip den entferntesten Spieler heranzieht, brich die Sichtlinie hinter einer Säule. Die Rettung endet bei Gnok, der auf halbem Weg untot wiederkehrt.|n• Überall Bodenfallen — schau, wohin du trittst.|n• Unterbrich die Selbstheilung der Spiritcaller und zerstör die War Drum der Warsinger.',
    'frFR': '• Nouveau en 12.1, sur la Coiled Isle — entrée en {WAY:2512:71.1:56.4:The Ring of Glory}. Un delve-arène : une variante est une série de duels, une un jeu de balle fantomatique, une un sauvetage d’animaux.|n• Les deux premières finissent sur Drakta (selon Method et Icy Veins — pas encore mesuré sur ton client) : esquive le cercle de son Soul Cleave, sors-le de la zone qu’il laisse, et quand Death Grip attire le joueur le plus éloigné, casse la ligne de vue derrière un pilier. Le sauvetage finit sur Gnok, qui revient mort-vivant à mi-chemin.|n• Des pièges au sol partout — regarde où tu marches.|n• Interromps l’auto-soin des Spiritcallers et détruis le War Drum des Warsingers.',
    'esES': '• Nuevo en 12.1, en la Coiled Isle — entrada en {WAY:2512:71.1:56.4:The Ring of Glory}. Un delve-arena: una variante es una serie de duelos, otra un juego de pelota fantasmal, otra un rescate de animales.|n• Las dos primeras acaban en Drakta (según Method e Icy Veins — aún no medido en tu cliente): esquiva el círculo de su Soul Cleave, sácalo de la zona que deja, y cuando Death Grip atraiga al jugador más lejano, corta la línea de visión tras un pilar. El rescate acaba en Gnok, que vuelve no-muerto a mitad de camino.|n• Trampas en el suelo por todas partes — mira dónde pisas.|n• Interrumpe la autocuración de los Spiritcallers y destruye el War Drum de los Warsingers.',
    'ptBR': '• Novo na 12.1, na Coiled Isle — entrada em {WAY:2512:71.1:56.4:The Ring of Glory}. Um delve-arena: uma variante é uma série de duelos, outra um jogo de bola fantasmagórico, outra um resgate de animais.|n• As duas primeiras acabam em Drakta (segundo a Method e a Icy Veins — ainda não medido no teu cliente): desvia do círculo do Soul Cleave, tira-o da zona que fica, e quando o Death Grip puxar o jogador mais distante, corta a linha de visão atrás de um pilar. O resgate acaba em Gnok, que volta morto-vivo a meio.|n• Armadilhas no chão por todo o lado — vê onde pisas.|n• Interrompe a autocura dos Spiritcallers e destrói o War Drum dos Warsingers.',
    'itIT': '• Nuovo nella 12.1, sulla Coiled Isle — ingresso a {WAY:2512:71.1:56.4:The Ring of Glory}. Un delve-arena: una variante è una serie di duelli, una un gioco di palla spettrale, una un salvataggio di animali.|n• Le prime due finiscono con Drakta (secondo Method e Icy Veins — non ancora misurato sul tuo client): schiva il cerchio del suo Soul Cleave, trascinalo fuori dalla zona che lascia, e quando Death Grip attira il giocatore più lontano, spezza la linea di vista dietro un pilastro. Il salvataggio finisce con Gnok, che torna non-morto a metà strada.|n• Trappole a terra ovunque — guarda dove metti i piedi.|n• Interrompi l’autocura degli Spiritcaller e distruggi il War Drum dei Warsinger.',
}

D['DELVE_TIP_RINGOFGLORY_ROUTE'] = {
    'enUS': '• Three Sturdy Chests — click to set a waypoint: {WAY:2633:44.16:22.60:Sturdy Chest 1} · {WAY:2633:25.19:73.74:Sturdy Chest 2} · {WAY:2633:48.56:94.84:Sturdy Chest 3}.|n• The exit is at {WAY:2633:80.10:53.69:Exit}.',
    'nlNL': '• Drie Sturdy Chests — klik voor een waypoint: {WAY:2633:44.16:22.60:Sturdy Chest 1} · {WAY:2633:25.19:73.74:Sturdy Chest 2} · {WAY:2633:48.56:94.84:Sturdy Chest 3}.|n• De uitgang staat op {WAY:2633:80.10:53.69:Uitgang}.',
    'deDE': '• Drei Sturdy Chests — klick für einen Wegpunkt: {WAY:2633:44.16:22.60:Sturdy Chest 1} · {WAY:2633:25.19:73.74:Sturdy Chest 2} · {WAY:2633:48.56:94.84:Sturdy Chest 3}.|n• Der Ausgang liegt bei {WAY:2633:80.10:53.69:Ausgang}.',
    'frFR': '• Trois Sturdy Chests — clique pour poser un point de repère : {WAY:2633:44.16:22.60:Sturdy Chest 1} · {WAY:2633:25.19:73.74:Sturdy Chest 2} · {WAY:2633:48.56:94.84:Sturdy Chest 3}.|n• La sortie est en {WAY:2633:80.10:53.69:Sortie}.',
    'esES': '• Tres Sturdy Chests — pulsa para fijar un punto: {WAY:2633:44.16:22.60:Sturdy Chest 1} · {WAY:2633:25.19:73.74:Sturdy Chest 2} · {WAY:2633:48.56:94.84:Sturdy Chest 3}.|n• La salida está en {WAY:2633:80.10:53.69:Salida}.',
    'ptBR': '• Três Sturdy Chests — clica para marcar um ponto: {WAY:2633:44.16:22.60:Sturdy Chest 1} · {WAY:2633:25.19:73.74:Sturdy Chest 2} · {WAY:2633:48.56:94.84:Sturdy Chest 3}.|n• A saída está em {WAY:2633:80.10:53.69:Saída}.',
    'itIT': '• Tre Sturdy Chests — clicca per impostare un waypoint: {WAY:2633:44.16:22.60:Sturdy Chest 1} · {WAY:2633:25.19:73.74:Sturdy Chest 2} · {WAY:2633:48.56:94.84:Sturdy Chest 3}.|n• L’uscita è a {WAY:2633:80.10:53.69:Uscita}.',
}

for table in list(R.values()) + list(D.values()):
    for code in LANGS:
        assert code in table, code
        assert '"' not in table[code], (code, table[code][:60])

RAID_ORDER = ['RAID_PRERELEASE_NOTE',
              'RAID_BOSS_NEKZALI_STEPS', 'RAID_BOSS_NEKZALI_TANK',
              'RAID_BOSS_ENTOMBEDSENT_STEPS', 'RAID_BOSS_ENTOMBEDSENT_TANK', 'RAID_BOSS_ENTOMBEDSENT_HEALER',
              'RAID_BOSS_LOSTEXPLORERS_STEPS',
              'RAID_BOSS_VASHNIK_STEPS', 'RAID_BOSS_VASHNIK_TANK',
              'RAID_BOSS_SSZORAK_STEPS', 'RAID_BOSS_SSZORAK_TANK',
              'RAID_BOSS_TWINFANGS_STEPS', 'RAID_BOSS_TWINFANGS_TANK',
              'RAID_BOSS_COILEDALTAR_STEPS', 'RAID_BOSS_COILEDALTAR_HEALER',
              'RAID_BOSS_ULATEK_STEPS']

# ---------------------------------------------------------------------------
# 1. RaidTips.lua — insert per merge block, language detected from the header
# ---------------------------------------------------------------------------
RT = os.path.join(BASE, 'RaidTips.lua')
t = io.open(RT, encoding='utf-8', newline='').read()
if 'RAID_BOSS_NEKZALI_STEPS' in t:
    print('RaidTips.lua: staat er al')
else:
    eol = '\r\n' if '\r\n' in t else '\n'
    out = []
    lang = None
    inserted = {}
    lang_re = re.compile(r'merge\(ns\._mhLocales and ns\._mhLocales\.(\w+)')
    for line in t.split(eol):
        m = lang_re.search(line)
        if m:
            lang = m.group(1)
        out.append(line)
        # Anchor: the Chimaerus steps line, present in every language block.
        if 'RAID_BOSS_CHIMAERUS_STEPS' in line and lang in LANGS and lang not in inserted:
            indent = line[:len(line) - len(line.lstrip())]
            for key in RAID_ORDER:
                out.append('%s%s = "%s",' % (indent, key, R[key][lang]))
            inserted[lang] = True
    if len(inserted) != 7:
        print('RaidTips.lua: %d van 7 blokken (%s) — NIETS geschreven'
              % (len(inserted), ','.join(sorted(inserted))))
        sys.exit(1)
    io.open(RT + '.tmp', 'w', encoding='utf-8', newline='').write(eol.join(out))
    os.replace(RT + '.tmp', RT)
    print('RaidTips.lua: 7 blokken x %d keys' % len(RAID_ORDER))

# ---------------------------------------------------------------------------
# 2. Delve bodies — replace existing single-line values per pack
# ---------------------------------------------------------------------------
TARGETS = [
    (os.path.join(BASE, 'enUS.lua'), ['enUS']),
    (os.path.join(BASE, 'nlNL.lua'), ['nlNL']),
    (os.path.join(BASE, 'Translations2026.lua'), ['deDE', 'frFR', 'esES', 'ptBR', 'itIT']),
]

for path, codes in TARGETS:
    name = os.path.basename(path)
    t = io.open(path, encoding='utf-8', newline='').read()
    eol = '\r\n' if '\r\n' in t else '\n'
    lines = t.split(eol)
    counts = {k: 0 for k in D}
    changed = 0
    for i, line in enumerate(lines):
        for key in D:
            if line.lstrip().startswith(key + ' = "'):
                idx = counts[key]
                counts[key] += 1
                if idx >= len(codes):
                    continue
                code = codes[idx]
                indent = line[:len(line) - len(line.lstrip())]
                lines[i] = '%s%s = "%s",' % (indent, key, D[key][code])
                changed += 1
    expect = len(codes) * len(D)
    if changed != expect:
        print('%s: %d van %d vervangen — NIETS geschreven' % (name, changed, expect))
        sys.exit(1)
    io.open(path + '.tmp', 'w', encoding='utf-8', newline='').write(eol.join(lines))
    os.replace(path + '.tmp', path)
    print('%s: %d vervangen' % (name, changed))
