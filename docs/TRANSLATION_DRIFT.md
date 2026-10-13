# Vertaal-drift

Gegenereerd door `python tools/check_drift.py --write-report`. **Niet met de hand bijwerken.**

Drift betekent: deze taal heeft een vertaling, maar de Engelse zin waar hij uit komt is daarna veranderd. `ns:L` valt alleen terug op enUS als een key *ontbreekt* — een aanwezige vertaling blijft staan, hoe oud hij ook is. Zo blijft een gecorrigeerde bewering in vijf talen gewoon doorlopen.

Basis: **v3.5.0** — 5187 keys met een vastgelegde herkomst.

| taal | OK | drift | onvertaald | onbekend |
|---|---:|---:|---:|---:|
| deDE | 3851 | 1 | 184 | 1181 |
| frFR | 3869 | 1 | 170 | 1177 |
| esES | 3900 | 2 | 154 | 1161 |
| ptBR | 3889 | 2 | 153 | 1173 |
| itIT | 3798 | 2 | 226 | 1191 |
| nlNL | 3386 | 18 | 550 | 1263 |
| ruRU | 5113 | 2 | 85 | 17 |

**onbekend** = na de basistag vertaald, dus we weten niet uit welke Engelse versie. Dat is niet hetzelfde als verouderd.

De loader ziet **5786** enUS-keys; hiervan zijn er 5217 beoordeeld en 569 overgeslagen (`CHANGELOG_*`, `LANG_LABEL_*` en waarden die precies een spelbegrip zijn). ⚠️ `tools/lint_addon.py` [5] telt hetzelfde anders — die parseert de bestanden zelf en slaat niets over, dus zijn "still English" ligt hoger. Twee getallen die hetzelfde lijken te meten en niet gelijk zijn: gebruik hier het getal van de loader.

🔴 **Wij vertalen dit zelf.** Deze lijst ging vroeger "naar #translations", maar daar is niemand: dat betekende in de praktijk "wordt nooit gerepareerd", en een vertaling die iets onwaars beweert is erger dan een zorgvuldige van ons. Wel eerst lezen — "gedrift" zegt alleen dat het Engels veranderd is, niet dat de vertaling fout is (30 aug: 5 van de 11 waren loos alarm). En elk pack houdt zijn eigen woordenschat: `itIT` schrijft Great Vault, `deDE` Große Schatzkammer.

⚠️ **Wat wij schrijven is niet nagekeken door een moedertaalspreker.** Verschijnt er ooit een vertaler, dan begint die hier: de tier-teksten (`INFO_DRAWER_BODY_TIER`, `TIER_FOOTER`, `TIER_SET_UNKNOWN`) en de Collegiate-tip zijn op 30 aug 2026 door ons geschreven in de/fr/es/pt/it.

## deDE — 1 gedrift

### `RAID_BOSS_NEKZALI_STEPS`

| | |
|---|---|
| enUS **nu** | • \|cffffd100No add may reach the Well in the middle.\|r {SPELL:1295397} adds carry a shield only magic damage breaks; break it, then kill them. Each add that arrives hits the raid and feeds her energy.\|n• {SPELL:1287426}: you are pulled in, then knocked away. Walk to the edge of the room and let a healer dispel you there. A puddle (Latent Cultist) stays where it ends, so keep it out of the way.\|n• {SPELL:1284103}: the tank with the boss runs far away. Never stand between the boss and that tank; the ghosts hit the whole raid harder when they travel less.\|n• Soulcoil Ignition is heavy raid damage. Dodge the circles that fall from the Well (Anguished Echoes); they knock you back, so do not stand near the Well.\|n• At 50% she turns immune. Kill the two Echoes of Jawae one at a time, step out of the Soul Transfer blast, keep killing adds, and group-soak Hungering Pyre.\|n• Phase 2: the raid takes damage nonstop until she dies. {SPELL:1299673} makes the old puddles move around the Well; dodge them. Kill her before she reaches 100 energy.\|n• On Heroic and Mythic: every Well hit adds a {SPELL:1297624} stack, so each next one hurts more. Dead adds leave corpses that rise in the intermission; soak Hungering Pyre on top of them to burn them.\|n• On Mythic: {SPELL:1293212} pulls the raid toward the Well. Teams take turns going in to kill the Drowned Echo and interrupt its cast. In phase 2, stop casting just before each {SPELL:1299673}. |
| deDE **staat nu** | • \|cffffd100Kein Add darf den Brunnen in der Mitte erreichen.\|r {SPELL:1295397}-Adds tragen einen Schild, den nur magischer Schaden bricht; brich ihn, dann töte sie. Jeder Add, der ankommt, trifft den Raid und füllt ihre Energie.\|n• {SPELL:1287426}: Du wirst hineingezogen und dann weggestoßen. Lauf an den Rand des Raums und lass dir den Effekt dort von einem Heiler entfernen. Wo er endet, bleibt eine Pfütze (Latent Cultist) liegen, also halte sie aus dem Weg.\|n• {SPELL:1284103}: Der Tank mit dem Boss läuft weit weg. Steh nie zwischen dem Boss und diesem Tank; die Geister treffen den ganzen Raid härter, je kürzer ihr Weg ist.\|n• Soulcoil Ignition ist schwerer Raidschaden. Weich den Kreisen aus, die aus dem Brunnen fallen (Anguished Echoes); sie stoßen dich zurück, also steh nicht nah am Brunnen.\|n• Bei 50 % wird sie immun. Töte die zwei Echoes of Jawae nacheinander, tritt aus der Explosion von Soul Transfer, töte weiter Adds und soakt Hungering Pyre als Gruppe.\|n• Phase 2: Der Raid nimmt ununterbrochen Schaden, bis sie stirbt. {SPELL:1299673} lässt die alten Pfützen um den Brunnen wandern; weich ihnen aus. Töte sie, bevor sie 100 Energie erreicht.\|n• Auf Heroisch und Mythisch: Jeder Treffer am Brunnen gibt einen Stapel {SPELL:1297624}, also tut jeder weitere mehr weh. Tote Adds hinterlassen Leichen, die im Zwischenspiel aufstehen; soakt Hungering Pyre direkt auf ihnen, um sie zu verbrennen.\|n• Auf Mythisch: {SPELL:1293212} zieht den Raid zum Brunnen. Teams gehen abwechselnd hinein, um das Drowned Echo zu töten und seinen Zauber zu unterbrechen. Hör in Phase 2 kurz vor jedem {SPELL:1299673} auf zu zaubern. |

## frFR — 1 gedrift

### `RAID_BOSS_NEKZALI_STEPS`

| | |
|---|---|
| enUS **nu** | • \|cffffd100No add may reach the Well in the middle.\|r {SPELL:1295397} adds carry a shield only magic damage breaks; break it, then kill them. Each add that arrives hits the raid and feeds her energy.\|n• {SPELL:1287426}: you are pulled in, then knocked away. Walk to the edge of the room and let a healer dispel you there. A puddle (Latent Cultist) stays where it ends, so keep it out of the way.\|n• {SPELL:1284103}: the tank with the boss runs far away. Never stand between the boss and that tank; the ghosts hit the whole raid harder when they travel less.\|n• Soulcoil Ignition is heavy raid damage. Dodge the circles that fall from the Well (Anguished Echoes); they knock you back, so do not stand near the Well.\|n• At 50% she turns immune. Kill the two Echoes of Jawae one at a time, step out of the Soul Transfer blast, keep killing adds, and group-soak Hungering Pyre.\|n• Phase 2: the raid takes damage nonstop until she dies. {SPELL:1299673} makes the old puddles move around the Well; dodge them. Kill her before she reaches 100 energy.\|n• On Heroic and Mythic: every Well hit adds a {SPELL:1297624} stack, so each next one hurts more. Dead adds leave corpses that rise in the intermission; soak Hungering Pyre on top of them to burn them.\|n• On Mythic: {SPELL:1293212} pulls the raid toward the Well. Teams take turns going in to kill the Drowned Echo and interrupt its cast. In phase 2, stop casting just before each {SPELL:1299673}. |
| frFR **staat nu** | • \|cffffd100Aucun add ne doit atteindre le Puits au centre.\|r Les adds {SPELL:1295397} portent un bouclier que seuls les dégâts magiques brisent ; brisez-le, puis tuez-les. Chaque add qui arrive frappe le raid et nourrit son énergie.\|n• {SPELL:1287426} : vous êtes attiré, puis projeté. Marchez jusqu’au bord de la salle et laissez un soigneur vous dissiper là-bas. Une flaque (Latent Cultist) reste là où l’effet se termine, gardez-la donc à l’écart.\|n• {SPELL:1284103} : le tank qui a le boss part loin. Ne vous placez jamais entre le boss et ce tank ; les fantômes frappent tout le raid plus fort quand leur trajet est court.\|n• Soulcoil Ignition, ce sont de lourds dégâts sur le raid. Esquivez les cercles qui tombent du Puits (Anguished Echoes) ; ils vous repoussent, alors ne restez pas près du Puits.\|n• À 50 %, elle devient immunisée. Tuez les deux Echoes of Jawae l’un après l’autre, sortez de l’explosion de Soul Transfer, continuez à tuer les adds et absorbez Hungering Pyre en groupe.\|n• Phase 2 : le raid subit des dégâts sans arrêt jusqu’à sa mort. {SPELL:1299673} fait bouger les anciennes flaques autour du Puits ; esquivez-les. Tuez-la avant qu’elle atteigne 100 d’énergie.\|n• En Héroïque et Mythique : chaque coup sur le Puits ajoute un cumul de {SPELL:1297624}, donc chaque coup suivant fait plus mal. Les adds morts laissent des cadavres qui se relèvent pendant l’intermède ; absorbez Hungering Pyre sur eux pour les brûler.\|n• En Mythique : {SPELL:1293212} attire le raid vers le Puits. Des équipes y entrent à tour de rôle pour tuer le Drowned Echo et interrompre son incantation. En phase 2, arrêtez d’incanter juste avant chaque {SPELL:1299673}. |

## esES — 2 gedrift

### `RAID_BOSS_NEKZALI_STEPS`

| | |
|---|---|
| enUS **nu** | • \|cffffd100No add may reach the Well in the middle.\|r {SPELL:1295397} adds carry a shield only magic damage breaks; break it, then kill them. Each add that arrives hits the raid and feeds her energy.\|n• {SPELL:1287426}: you are pulled in, then knocked away. Walk to the edge of the room and let a healer dispel you there. A puddle (Latent Cultist) stays where it ends, so keep it out of the way.\|n• {SPELL:1284103}: the tank with the boss runs far away. Never stand between the boss and that tank; the ghosts hit the whole raid harder when they travel less.\|n• Soulcoil Ignition is heavy raid damage. Dodge the circles that fall from the Well (Anguished Echoes); they knock you back, so do not stand near the Well.\|n• At 50% she turns immune. Kill the two Echoes of Jawae one at a time, step out of the Soul Transfer blast, keep killing adds, and group-soak Hungering Pyre.\|n• Phase 2: the raid takes damage nonstop until she dies. {SPELL:1299673} makes the old puddles move around the Well; dodge them. Kill her before she reaches 100 energy.\|n• On Heroic and Mythic: every Well hit adds a {SPELL:1297624} stack, so each next one hurts more. Dead adds leave corpses that rise in the intermission; soak Hungering Pyre on top of them to burn them.\|n• On Mythic: {SPELL:1293212} pulls the raid toward the Well. Teams take turns going in to kill the Drowned Echo and interrupt its cast. In phase 2, stop casting just before each {SPELL:1299673}. |
| esES **staat nu** | • \|cffffd100Ningún add debe llegar al Well del centro.\|r Los adds de {SPELL:1295397} llevan un escudo que solo rompe el daño mágico; rómpelo y luego mátalos. Cada add que llega golpea al raid y le da energía a ella.\|n• {SPELL:1287426}: te atrae hacia dentro y luego te lanza lejos. Camina hasta el borde de la sala y deja que un sanador te disipe allí. Donde termina queda un charco (Latent Cultist), así que déjalo fuera del paso.\|n• {SPELL:1284103}: el tanque con el jefe corre lejos. Nunca te pongas entre el jefe y ese tanque; los fantasmas golpean más fuerte a todo el raid cuanto menos recorren.\|n• Soulcoil Ignition es daño fuerte al raid. Esquiva los círculos que caen del Well (Anguished Echoes); te empujan hacia atrás, así que no te quedes cerca del Well.\|n• Al 50% se vuelve inmune. Maten a los dos Echoes of Jawae de uno en uno, sal de la explosión de Soul Transfer, sigan matando adds y absorban Hungering Pyre en grupo.\|n• Fase 2: el raid recibe daño sin parar hasta que muere. {SPELL:1299673} hace que los charcos viejos se muevan alrededor del Well; esquívalos. Mátala antes de que llegue a 100 de energía.\|n• En Heroico y Mítico: cada golpe del Well añade una acumulación de {SPELL:1297624}, así que cada uno siguiente duele más. Los adds muertos dejan cadáveres que se levantan en el interludio; absorban Hungering Pyre encima de ellos para quemarlos.\|n• En Mítico: {SPELL:1293212} atrae al raid hacia el Well. Los equipos entran por turnos para matar al Drowned Echo e interrumpir su lanzamiento. En la fase 2, deja de lanzar justo antes de cada {SPELL:1299673}. |

### `TAB_GUIDE`

| | |
|---|---|
| enUS **nu** | Leveling (10-90) |
| esES **staat nu** | Guías de nivelación |

## ptBR — 2 gedrift

### `RAID_BOSS_NEKZALI_STEPS`

| | |
|---|---|
| enUS **nu** | • \|cffffd100No add may reach the Well in the middle.\|r {SPELL:1295397} adds carry a shield only magic damage breaks; break it, then kill them. Each add that arrives hits the raid and feeds her energy.\|n• {SPELL:1287426}: you are pulled in, then knocked away. Walk to the edge of the room and let a healer dispel you there. A puddle (Latent Cultist) stays where it ends, so keep it out of the way.\|n• {SPELL:1284103}: the tank with the boss runs far away. Never stand between the boss and that tank; the ghosts hit the whole raid harder when they travel less.\|n• Soulcoil Ignition is heavy raid damage. Dodge the circles that fall from the Well (Anguished Echoes); they knock you back, so do not stand near the Well.\|n• At 50% she turns immune. Kill the two Echoes of Jawae one at a time, step out of the Soul Transfer blast, keep killing adds, and group-soak Hungering Pyre.\|n• Phase 2: the raid takes damage nonstop until she dies. {SPELL:1299673} makes the old puddles move around the Well; dodge them. Kill her before she reaches 100 energy.\|n• On Heroic and Mythic: every Well hit adds a {SPELL:1297624} stack, so each next one hurts more. Dead adds leave corpses that rise in the intermission; soak Hungering Pyre on top of them to burn them.\|n• On Mythic: {SPELL:1293212} pulls the raid toward the Well. Teams take turns going in to kill the Drowned Echo and interrupt its cast. In phase 2, stop casting just before each {SPELL:1299673}. |
| ptBR **staat nu** | • \|cffffd100Nenhum add pode chegar ao Well no centro.\|r Os adds de {SPELL:1295397} têm um escudo que só dano mágico quebra; quebre-o e depois mate-os. Cada add que chega atinge o raide e dá energia a ela.\|n• {SPELL:1287426}: você é puxado para dentro e depois arremessado para longe. Vá até a borda da sala e deixe um curandeiro dissipar você lá. Uma poça (Latent Cultist) fica onde o efeito termina, então deixe-a fora do caminho.\|n• {SPELL:1284103}: o tanque com o chefe corre para bem longe. Nunca fique entre o chefe e esse tanque; os fantasmas atingem o raide todo com mais força quando percorrem menos distância.\|n• Soulcoil Ignition é dano pesado no raide. Desvie dos círculos que caem do Well (Anguished Echoes); eles empurram você para trás, então não fique perto do Well.\|n• Aos 50% ela fica imune. Mate os dois Echoes of Jawae um de cada vez, saia da explosão de Soul Transfer, continue matando os adds e soake Hungering Pyre em grupo.\|n• Fase 2: o raide sofre dano sem parar até ela morrer. {SPELL:1299673} faz as poças antigas se moverem ao redor do Well; desvie delas. Mate-a antes que ela chegue a 100 de energia.\|n• No Heroico e no Mítico: cada golpe do Well adiciona um acúmulo de {SPELL:1297624}, então cada golpe seguinte dói mais. Adds mortos deixam corpos que se levantam no interlúdio; soake Hungering Pyre em cima deles para queimá-los.\|n• No Mítico: {SPELL:1293212} puxa o raide em direção ao Well. As equipes se revezam entrando para matar o Drowned Echo e interromper a conjuração dele. Na fase 2, pare de conjurar logo antes de cada {SPELL:1299673}. |

### `TAB_GUIDE`

| | |
|---|---|
| enUS **nu** | Leveling (10-90) |
| ptBR **staat nu** | Guias de nivelamento |

## itIT — 2 gedrift

### `RAID_BOSS_NEKZALI_STEPS`

| | |
|---|---|
| enUS **nu** | • \|cffffd100No add may reach the Well in the middle.\|r {SPELL:1295397} adds carry a shield only magic damage breaks; break it, then kill them. Each add that arrives hits the raid and feeds her energy.\|n• {SPELL:1287426}: you are pulled in, then knocked away. Walk to the edge of the room and let a healer dispel you there. A puddle (Latent Cultist) stays where it ends, so keep it out of the way.\|n• {SPELL:1284103}: the tank with the boss runs far away. Never stand between the boss and that tank; the ghosts hit the whole raid harder when they travel less.\|n• Soulcoil Ignition is heavy raid damage. Dodge the circles that fall from the Well (Anguished Echoes); they knock you back, so do not stand near the Well.\|n• At 50% she turns immune. Kill the two Echoes of Jawae one at a time, step out of the Soul Transfer blast, keep killing adds, and group-soak Hungering Pyre.\|n• Phase 2: the raid takes damage nonstop until she dies. {SPELL:1299673} makes the old puddles move around the Well; dodge them. Kill her before she reaches 100 energy.\|n• On Heroic and Mythic: every Well hit adds a {SPELL:1297624} stack, so each next one hurts more. Dead adds leave corpses that rise in the intermission; soak Hungering Pyre on top of them to burn them.\|n• On Mythic: {SPELL:1293212} pulls the raid toward the Well. Teams take turns going in to kill the Drowned Echo and interrupt its cast. In phase 2, stop casting just before each {SPELL:1299673}. |
| itIT **staat nu** | • \|cffffd100Nessun add deve raggiungere il Well al centro.\|r Gli add di {SPELL:1295397} hanno uno scudo che si rompe solo con danni magici; rompilo, poi uccidili. Ogni add che arriva colpisce il raid e le dà energia.\|n• {SPELL:1287426}: vieni attirato dentro, poi scaraventato via. Cammina fino al bordo della stanza e fatti dissipare lì da un healer. Dove finisce resta una pozza (Latent Cultist), quindi tienila lontana dal passaggio.\|n• {SPELL:1284103}: il tank con il boss corre lontano. Non stare mai tra il boss e quel tank; i fantasmi colpiscono tutto il raid più forte quando percorrono meno strada.\|n• Soulcoil Ignition fa danni pesanti al raid. Schiva i cerchi che cadono dal Well (Anguished Echoes); ti respingono, quindi non stare vicino al Well.\|n• Al 50% diventa immune. Uccidete i due Echoes of Jawae uno alla volta, esci dall’esplosione di Soul Transfer, continuate a uccidere gli add e assorbite in gruppo Hungering Pyre.\|n• Fase 2: il raid subisce danni senza sosta finché lei non muore. {SPELL:1299673} fa muovere le vecchie pozze intorno al Well; schivale. Uccidila prima che arrivi a 100 di energia.\|n• In Eroico e Mitico: ogni colpo del Well aggiunge un accumulo di {SPELL:1297624}, quindi ognuno successivo fa più male. Gli add morti lasciano cadaveri che si rialzano nell’intermezzo; assorbite Hungering Pyre sopra di loro per bruciarli.\|n• In Mitico: {SPELL:1293212} attira il raid verso il Well. Le squadre entrano a turno per uccidere il Drowned Echo e interromperne il cast. In fase 2, smetti di lanciare subito prima di ogni {SPELL:1299673}. |

### `TAB_GUIDE`

| | |
|---|---|
| enUS **nu** | Leveling (10-90) |
| itIT **staat nu** | Leveling Guides |

## nlNL — 18 gedrift

### `CODEX_LABYRINTH_BODY`

| | |
|---|---|
| enUS **nu** | \|cffffcc00A big delve of nine rooms, with the boss Kindo'jan at the end.\|r New in patch 12.1.5. Valeera comes with you, as in every delve.\|n\|n\|cffffff78Getting in\|r\|n• The entrance is in Eversong Woods: {WAY:2395:62.90:72.00:The Labyrinth of Kindo'jan}. There are 11 tiers; you pick one at the door, as in every delve.\|n\|n\|cffffff78The first time\|r\|n• The door is sealed. Click the Amani Tablet on it: it sends you to Kul'amara the Fierce in Atal'Aman (the ? on your map). Kul'amara sends you back to meet Valeera at the door.\|n• Your first run is short: three rooms. Each room has its own task, some with a boss (Jun'ala, Sha'Kuro). After every room you may stop: talk to Kinduru, the spirit bird.\|n• Ending the run takes you to the treasure room. Then go back to Kul'amara for a toy that ends a run wherever you are. Kinduru hints that later runs take you deeper.\|n• On the way you unlock respawn points.\|n\|n\|cffffff78You do not have to finish it\|r\|n• Every 3 rooms give \|cffffffff2 Heavy Trunks, 1 Bountiful Coffer and Great Vault credit\|r, and you may stop there. Crests from Heavy Trunks count double.\|n• 3 rooms on a tier unlock the next tier.\|n• \|cffffffffIt opens normal delves too:\|r 3 rooms on Labyrinth tier 1 to 8 unlock the next Delve tier for this season: Labyrinth tier 7 gives Delve tier 8. In the test-realm game data, tiers 9, 10 and 11 unlock the same Delve tier, not the next; that may still change at launch.\|n\|n\|cffffff78Kindo'jan\|r\|n• From tier 8 he gives Great Vault credit once a week per character.\|n• Three of his attacks are known: \|cffffffffCrushing Blow\|r (step out of the impact; an Amani Juggernaut appears), \|cffffffffHash'ey's Command\|r (4 Amani Headhunters appear) and \|cffffffffDisgraceful Display\|r, which stacks: at 3 stacks the loa find you unworthy. The game has no journal page for him.\|n\|n\|cffffff78Help along the way\|r\|n• Four \|cffffffffLoa-Spirit Conduits\|r: click one for a strong boon for the whole group.\|n• Bountiful Coffers from tier 8 hold a \|cffffffffHeroic Soul Fragment\|r; three make a random Hero-track piece.\|n• A weekly questline of six steps, one new step each week, ends in two Myth-track armour pieces of your choice.\|n\|n\|cffffcc00Not known yet:\|r whether the coffers need a Restored Coffer Key, and how room credit and Kindo'jan's credit add up. Look at the Great Vault window rather than at a guide. |
| nlNL **staat nu** | \|cffffcc00Een grote delve van negen kamers, met aan het eind de baas Kindo'jan.\|r Nieuw in patch 12.1.5. Valeera gaat mee, zoals in elke delve.\|n\|n\|cffffff78Erin komen\|r\|n• De ingang ligt in Eversong Woods: {WAY:2395:62.90:72.00:The Labyrinth of Kindo'jan}. Er zijn 11 tiers; je kiest er één bij de deur, zoals bij elke delve.\|n\|n\|cffffff78De eerste keer\|r\|n• De deur is dicht. Klik op de Amani Tablet op de deur: die stuurt je naar Kul'amara the Fierce in Atal'Aman (het ? op je kaart). Kul'amara stuurt je terug naar Valeera bij de deur.\|n• Je eerste run is kort: drie kamers. Elke kamer heeft een eigen opdracht, soms met een baas (Jun'ala, Sha'Kuro). Na elke kamer mag je stoppen: praat met Kinduru, de geestvogel.\|n• Stoppen brengt je naar de schatkamer. Ga daarna terug naar Kul'amara voor een toy waarmee je een run overal kunt beëindigen. Kinduru laat doorschemeren dat je later dieper komt.\|n• Onderweg speel je respawn-punten vrij.\|n\|n\|cffffff78Je hoeft hem niet af te maken\|r\|n• Elke 3 kamers geven \|cffffffff2 Heavy Trunks, 1 Bountiful Coffer en Great Vault-credit\|r, en daarna mag je stoppen. Crests uit Heavy Trunks tellen dubbel.\|n• 3 kamers op een tier spelen de volgende tier vrij.\|n• \|cffffffffHij opent ook gewone delves:\|r 3 kamers op Labyrinth-tier 1 tot en met 8 spelen de volgende Delve-tier vrij voor dit seizoen: Labyrinth-tier 7 geeft Delve-tier 8. In de spelgegevens van de testserver geven tier 9, 10 en 11 dezelfde Delve-tier, niet de volgende; dat kan bij de release nog veranderen.\|n\|n\|cffffff78Kindo'jan\|r\|n• Vanaf tier 8 geeft hij één keer per week per character Great Vault-credit.\|n• Drie aanvallen zijn bekend: \|cffffffffCrushing Blow\|r (stap uit de inslag; er verschijnt een Amani Juggernaut), \|cffffffffHash'ey's Command\|r (4 Amani Headhunters verschijnen) en \|cffffffffDisgraceful Display\|r, dat stapelt: bij 3 stacks vinden de loa je onwaardig. Het spel heeft nog geen journal-pagina voor hem.\|n\|n\|cffffff78Hulp onderweg\|r\|n• Vier \|cffffffffLoa-Spirit Conduits\|r: klik er één voor een sterke boon voor de hele groep.\|n• Bountiful Coffers vanaf tier 8 bevatten een \|cffffffffHeroic Soul Fragment\|r; drie daarvan geven een willekeurig Hero-track-stuk.\|n• Een wekelijkse questlijn van zes stappen, elke week één nieuwe, eindigt in twee Myth-track-armor-stukken naar keuze.\|n\|n\|cffffcc00Nog niet bekend:\|r of de coffers een Restored Coffer Key vragen, en hoe kamer-credit en Kindo'jan-credit optellen. Kijk in het Great Vault-venster, niet in een gids. |

### `CODEX_PREY_BODY`

| | |
|---|---|
| enUS **nu** | • \|cffffffffA Prey hunt is a tracked kill, not a dungeon.\|r You pick up the hunt from Astalor Bloodsworn in Astalor's Sanctum, Silvermoon (the entrance is in Murder Row), follow it, and finish with a fight against one named target. No group finder. There is a weekly limit, though: only your first two hunts on each difficulty each week give a gear chest.\|n• \|cffffffffIt counts for the Great Vault.\|r Prey feeds the same world row as delves and ritual sites, so it is a real way to fill that reward slot rather than a side attraction.\|n• \|cffffffffThere are three difficulty modes.\|r Start on the lowest. A harder mode gives better gear and a better Great Vault choice. On Normal other players can help you; on Nightmare you fight alone.\|n• \|cffffffffWar Mode hunts are counted separately.\|r If you do not play with War Mode on, you are not missing anything the rest of the system needs.\|n• \|cffffffffThe whole target list is a long-term goal, not a weekly chore.\|r Working through it ends in a title. Doing one hunt when you feel like it is a perfectly good way to play it.\|n• \|cffffffffIt also opens a portal, and that is the part nobody tells you.\|r Get into the Prey line and a portal links Astalor's Sanctum in Silvermoon directly with The Coiled Isle, which saves the long flight every single trip. Midnight Helper only offers it in route guidance once your own character can actually use it, so if you do not see it yet, keep going with Prey.\|n• \|cffffffffStart here\|r: {WAY:2393:56.74:67.30:Astalor Bloodsworn} in Astalor's Sanctum, Silvermoon; the entrance is in Murder Row. Click that to set a waypoint. He is downstairs, inside the building. The portal stands beside him, and its pin in the City Guide walks you to the door first.\|n• \|cffffffffAnd the way back\|r, which is the half nobody writes down: {WAY:2512:58.12:48.48:Portal to Silvermoon} on The Coiled Isle. Standing on the isle with no idea where the return portal is happens to everyone once.\|n• \|cffffffffTo see where you stand\|r, type \|cffffffff/mh prey\|r, or open the Adventure Guide with Shift-J. Both read your own progress from the game rather than from a list we wrote down. |
| nlNL **staat nu** | • \|cffffffffEen Prey-hunt is een gevolgde jacht, geen dungeon.\|r Je pakt hem op bij Astalor Bloodsworn in Astalor's Sanctum, Silvermoon (de ingang ligt in Murder Row), volgt hem, en sluit af met een gevecht tegen één doelwit met een naam. Geen group finder. Wel een weeklimiet: alleen je eerste twee hunts per moeilijkheid per week geven een gear-kist.\|n• \|cffffffffHet telt mee voor de Great Vault.\|r Prey vult dezelfde world-rij als delves en ritual sites, dus het is een echte manier om die beloning te vullen en geen bijzaak.\|n• \|cffffffffEr zijn drie moeilijkheidsmodi.\|r Begin op de laagste. Een zwaardere modus geeft betere gear en een betere Great Vault-keuze. Op Normal mogen andere spelers je helpen; op Nightmare vecht je alleen.\|n• \|cffffffffWar Mode-hunts tellen apart.\|r Speel je zonder War Mode, dan mis je niets wat de rest van het systeem nodig heeft.\|n• \|cffffffffDe volledige doelenlijst is een langetermijndoel, geen weektaak.\|r Hem afwerken levert een titel op. Eén jacht doen wanneer je er zin in hebt is een prima manier om het te spelen.\|n• \|cffffffffHet opent ook een portaal, en dat vertelt niemand je.\|r Kom je de Prey-lijn in, dan verbindt een portaal Astalor's Sanctum in Silvermoon rechtstreeks met The Coiled Isle — dat scheelt elke keer de lange vlucht. Midnight Helper biedt hem pas aan in de routebegeleiding als jouw character hem echt kan gebruiken; zie je hem nog niet, ga dan verder met Prey.\|n• \|cffffffffHier begint het\|r: {WAY:2393:56.74:67.30:Astalor Bloodsworn} in Astalor's Sanctum, Silvermoon; de ingang ligt in Murder Row. Klik erop voor een waypoint. Hij staat beneden, binnen in het gebouw. Het portaal staat naast hem, en de pin ervoor in de City Guide brengt je eerst naar de deur.\|n• \|cffffffffEn de weg terug\|r, de helft die niemand opschrijft: {WAY:2512:58.12:48.48:Portaal naar Silvermoon} op The Coiled Isle. Op het eiland staan zonder te weten waar het portaal terug is, overkomt iedereen één keer.\|n• \|cffffffffWil je weten hoe je ervoor staat\|r, typ dan \|cffffffff/mh prey\|r, of open de Adventure Guide met Shift-J. Allebei lezen je voortgang uit de game, niet uit een lijstje van ons. |

### `LVL8090_HANDOFF_2`

| | |
|---|---|
| enUS **nu** | Prey Hunts start at Astalor Bloodsworn in Astalor's Sanctum, Silvermoon (entrance in Murder Row). They count toward the Great Vault, and after a Nightmare hunt you can spend a Nebulous Voidcore on bonus loot. |
| nlNL **staat nu** | Prey Hunts starten bij Astalor Bloodsworn in Astalor's Sanctum, Silvermoon (ingang in Murder Row). Ze tellen mee voor de Great Vault, en na een Nightmare-hunt kun je een Nebulous Voidcore uitgeven aan een bonus roll. |

### `LVL8090_INTRO`

| | |
|---|---|
| enUS **nu** | Class-agnostic tips: first level 10 to 80 for every class, then Midnight from 80 to 90. For talents and rotations, use Icy Veins or Wowhead. |
| nlNL **staat nu** | Klasse-onafhankelijke tips: eerst level 10 naar 80 voor elke class, dan Midnight van 80 naar 90. Voor talenten en rotatie gebruik je Icy Veins of Wowhead. |

### `LVL8090_SEC_CONS_TITLE`

| | |
|---|---|
| enUS **nu** | 5. Consumables while leveling |
| nlNL **staat nu** | 5. Consumables tijdens het levelen |

### `LVL8090_SEC_GEAR_TITLE`

| | |
|---|---|
| enUS **nu** | 6. Gear on the way up |
| nlNL **staat nu** | 6. Gear onderweg |

### `LVL8090_SEC_HANDOFF_TITLE`

| | |
|---|---|
| enUS **nu** | 7. The handoff at 90 |
| nlNL **staat nu** | 7. De handoff op 90 |

### `LVL8090_SEC_PATH_TITLE`

| | |
|---|---|
| enUS **nu** | 2. Fastest path 80 to 90 |
| nlNL **staat nu** | 2. Snelste pad 80 naar 90 |

### `LVL8090_SEC_UNLOCKS_TITLE`

| | |
|---|---|
| enUS **nu** | 4. Unlocks per level (80 to 90) |
| nlNL **staat nu** | 4. Unlocks per level (80 naar 90) |

### `LVL8090_SEC_XP_TITLE`

| | |
|---|---|
| enUS **nu** | 3. XP boosts and account perks |
| nlNL **staat nu** | 3. XP-boosts en account-perks |

### `LVL8090_TITLE`

| | |
|---|---|
| enUS **nu** | Leveling (10 to 90) |
| nlNL **staat nu** | Leveling (10 naar 90) |

### `LVL8090_UNLOCK_2`

| | |
|---|---|
| enUS **nu** | Timewalking Campaigns (Chromie Time) cover level 10-70; at 70 you get the sped-up TWW catch-up. |
| nlNL **staat nu** | Timewalking Campaigns (Chromie Time) dekken level 10-70; op 70 krijg je de versnelde TWW-catch-up. |

### `LVL8090_XP_1`

| | |
|---|---|
| enUS **nu** | Five Warband Mentors: Midnight — each character you take to 90 gives +5% account-wide leveling XP, up to +25% at five level-90s. |
| nlNL **staat nu** | Five Warband Mentors: Midnight — elke char die je naar 90 brengt geeft +5% account-brede level-XP, tot +25% bij vijf level-90's. |

### `LVL8090_XP_3`

| | |
|---|---|
| enUS **nu** | War Mode gives extra XP and better quest rewards in the open world, but players of the other faction can attack you there. |
| nlNL **staat nu** | War Mode geeft extra XP en betere questbeloningen in de open wereld, maar spelers van de andere faction mogen je daar aanvallen. |

### `LVL8090_XP_5`

| | |
|---|---|
| enUS **nu** | Heirlooms stop growing at level 70, so from 80 to 90 they do nothing (the 10-80 section says what they do before that). |
| nlNL **staat nu** | Heirlooms groeien maar tot level 70, dus van 80 naar 90 doen ze niets (het blok 10-80 zegt wat ze daarvóór doen). |

### `RAID_BOSS_NEKZALI_STEPS`

| | |
|---|---|
| enUS **nu** | • \|cffffd100No add may reach the Well in the middle.\|r {SPELL:1295397} adds carry a shield only magic damage breaks; break it, then kill them. Each add that arrives hits the raid and feeds her energy.\|n• {SPELL:1287426}: you are pulled in, then knocked away. Walk to the edge of the room and let a healer dispel you there. A puddle (Latent Cultist) stays where it ends, so keep it out of the way.\|n• {SPELL:1284103}: the tank with the boss runs far away. Never stand between the boss and that tank; the ghosts hit the whole raid harder when they travel less.\|n• Soulcoil Ignition is heavy raid damage. Dodge the circles that fall from the Well (Anguished Echoes); they knock you back, so do not stand near the Well.\|n• At 50% she turns immune. Kill the two Echoes of Jawae one at a time, step out of the Soul Transfer blast, keep killing adds, and group-soak Hungering Pyre.\|n• Phase 2: the raid takes damage nonstop until she dies. {SPELL:1299673} makes the old puddles move around the Well; dodge them. Kill her before she reaches 100 energy.\|n• On Heroic and Mythic: every Well hit adds a {SPELL:1297624} stack, so each next one hurts more. Dead adds leave corpses that rise in the intermission; soak Hungering Pyre on top of them to burn them.\|n• On Mythic: {SPELL:1293212} pulls the raid toward the Well. Teams take turns going in to kill the Drowned Echo and interrupt its cast. In phase 2, stop casting just before each {SPELL:1299673}. |
| nlNL **staat nu** | • \|cffffd100Geen enkele add mag de Well in het midden bereiken.\|r {SPELL:1295397}-adds hebben een schild dat alleen magic damage breekt; breek het en maak ze dan dood. Elke add die aankomt raakt de raid en geeft haar energie.\|n• {SPELL:1287426}: je wordt naar binnen getrokken en dan weggeslagen. Loop naar de rand van de ruimte en laat een healer je daar dispellen. Waar het eindigt blijft een plas (Latent Cultist) liggen, dus houd die uit de weg.\|n• {SPELL:1284103}: de tank met de baas rent ver weg. Sta nooit tussen de baas en die tank; de geesten raken de hele raid harder als ze minder ver hoeven te reizen.\|n• Soulcoil Ignition is zware raid-schade. Ontwijk de cirkels die uit de Well vallen (Anguished Echoes); ze duwen je terug, dus sta niet bij de Well.\|n• Op 50% wordt ze immuun. Dood de twee Echoes of Jawae één voor één, stap uit de Soul Transfer-klap, blijf adds doodmaken en soak Hungering Pyre met de groep.\|n• Fase 2: de raid krijgt non-stop schade tot ze dood is. {SPELL:1299673} laat de oude plassen rond de Well bewegen; ontwijk ze. Dood haar voordat ze 100 energie haalt.\|n• Op Heroic en Mythic: elke klap van de Well geeft een {SPELL:1297624}-stack, dus elke volgende doet meer pijn. Dode adds laten lijken achter die in de intermission opstaan; soak Hungering Pyre boven op de lijken om ze te verbranden.\|n• Op Mythic: {SPELL:1293212} trekt de raid naar de Well. Teams gaan om de beurt naar binnen om de Drowned Echo te doden en zijn cast te interrupten. Stop in fase 2 met casten vlak voor elke {SPELL:1299673}. |

### `SEARCH_CHAT_TAB_GUIDE`

| | |
|---|---|
| enUS **nu** | Opened tab: Leveling (10 to 90) |
| nlNL **staat nu** | Tab geopend: Leveling (10 naar 90) |

### `SMC_PIN_PORTAL_ISLE`

| | |
|---|---|
| enUS **nu** | Straight to The Coiled Isle, next to Astalor in Astalor's Sanctum (entrance in Murder Row). It only appears once you are into the Prey line — see the Prey guide in the Codex. The way back stands at 58.12, 48.48 on the isle. |
| nlNL **staat nu** | Rechtstreeks naar The Coiled Isle, naast Astalor in Astalor's Sanctum (ingang in Murder Row). Hij verschijnt pas als je in de Prey-lijn zit — zie de Prey-gids in de Codex. De weg terug staat op 58.12, 48.48 op het eiland. |

## ruRU — 2 gedrift

### `RAID_BOSS_NEKZALI_STEPS`

| | |
|---|---|
| enUS **nu** | • \|cffffd100No add may reach the Well in the middle.\|r {SPELL:1295397} adds carry a shield only magic damage breaks; break it, then kill them. Each add that arrives hits the raid and feeds her energy.\|n• {SPELL:1287426}: you are pulled in, then knocked away. Walk to the edge of the room and let a healer dispel you there. A puddle (Latent Cultist) stays where it ends, so keep it out of the way.\|n• {SPELL:1284103}: the tank with the boss runs far away. Never stand between the boss and that tank; the ghosts hit the whole raid harder when they travel less.\|n• Soulcoil Ignition is heavy raid damage. Dodge the circles that fall from the Well (Anguished Echoes); they knock you back, so do not stand near the Well.\|n• At 50% she turns immune. Kill the two Echoes of Jawae one at a time, step out of the Soul Transfer blast, keep killing adds, and group-soak Hungering Pyre.\|n• Phase 2: the raid takes damage nonstop until she dies. {SPELL:1299673} makes the old puddles move around the Well; dodge them. Kill her before she reaches 100 energy.\|n• On Heroic and Mythic: every Well hit adds a {SPELL:1297624} stack, so each next one hurts more. Dead adds leave corpses that rise in the intermission; soak Hungering Pyre on top of them to burn them.\|n• On Mythic: {SPELL:1293212} pulls the raid toward the Well. Teams take turns going in to kill the Drowned Echo and interrupt its cast. In phase 2, stop casting just before each {SPELL:1299673}. |
| ruRU **staat nu** | • \|cffffd100Ни один адд не должен дойти до Колодца в центре.\|r У аддов {SPELL:1295397} щит, который ломает только магический урон; сломайте его, затем убейте их. Каждый дошедший адд бьет рейд и дает ей энергию.\|n• {SPELL:1287426}: вас затягивает, затем отбрасывает. Идите к краю зала, и пусть лекарь развеет эффект там. Лужа (Latent Cultist) остается там, где эффект закончился, так что оставляйте ее в стороне.\|n• {SPELL:1284103}: танк с боссом убегает подальше. Никогда не стойте между боссом и этим танком; призраки бьют весь рейд сильнее, когда пролетают меньше.\|n• Soulcoil Ignition – сильный урон по рейду. Уклоняйтесь от кругов, падающих из Колодца (Anguished Echoes); они отбрасывают, поэтому не стойте у Колодца.\|n• На 50% она становится неуязвимой. Убейте двух Echoes of Jawae по одному, выйдите из взрыва Soul Transfer, продолжайте убивать аддов и примите Hungering Pyre всей группой.\|n• Фаза 2: рейд получает урон без остановки, пока она не умрет. {SPELL:1299673} заставляет старые лужи двигаться вокруг Колодца; уклоняйтесь от них. Убейте ее до 100 энергии.\|n• В героическом и эпохальном режимах: каждый удар Колодца добавляет стак {SPELL:1297624}, так что следующий бьет сильнее. Убитые адды оставляют трупы, которые встают в перерыве; принимайте Hungering Pyre на них, чтобы их сжечь.\|n• В эпохальном режиме: {SPELL:1293212} тянет рейд к Колодцу. Команды по очереди заходят, чтобы убить Drowned Echo и прервать его каст. В фазе 2 прекращайте каст прямо перед каждым {SPELL:1299673}. |

### `TAB_GUIDE`

| | |
|---|---|
| enUS **nu** | Leveling (10-90) |
| ruRU **staat nu** | Прокачка (10-90) |

