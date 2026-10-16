# Client names for the Codex / M+ / Vyranoth game terms (MH 4.8.0)

Measured 16 Oct 2026.
- **wago** = Blizzard DB2 on wago.tools, build **12.1.5.70391** (live). Read from the CSV export, one locale at a time, filtered on the ID. Spot check on 12.1.7.70424 (PTR): Achievement 63690 + 63610, KeystoneAffix 165, UiMap 2613 and CriteriaTree 231287 + 231290 are identical.
- **Wowhead** = the nether.wowhead.com tooltip API, locales en/de/fr/es/pt/it/ru. Positive check: Creature 241303 matched wago exactly in all 7 languages. Wowhead "es" is **esES**: it gave "Kul'amara la Fiera", the esES form, not the esMX form "Kul'amara, la Feroz". Wowhead has no esMX.
- A name in [brackets] on Wowhead means Wowhead has no localized name yet. That is written as NOT FOUND, not as the English name.
- Currency and item names are singular in the data. "Timewarped Badges", "Undercoins" and "Heavy Trunks" have no plural form in DB2.

## Labyrinth (CODEX_LABYRINTH_BODY)

| English | entity (type + id) | deDE | frFR | esES | esMX | ptBR | itIT | ruRU | MEASURED/DERIVED |
|---|---|---|---|---|---|---|---|---|---|
| The Labyrinth of Kindo'jan | Map 3043 (= AreaTable 16913, UiMap 2647) | Das Labyrinth von Kindo'jan | Le labyrinthe de Kindo’jan | El laberinto de Kindo'jan | El Laberinto de Kindo'Jan | O Labirinto de Kindo'jan | Labirinto di Kindo'jan | Лабиринт Киндо'джана | MEASURED (wago) |
| Kindo'jan (boss) | SpellName 1314916 + 1318593 "Kindo'jan"; also Achievement 63715 "Let Me Solo Him: Kindo'jan". NPC 266500 is not in Creature DB2 | Kindo'jan | Kindo’jan | Kindo'jan | Kindo'Jan | Kindo'jan | Kindo'jan | Киндо'джан | MEASURED (wago, spell and achievement name). Not measured on the NPC itself. Wowhead NPC 266500 is localized only for es ("Kindo'jan") |
| Valeera Sanguinar | Creature 248982 (229128 and 274915 identical) | Valeera Sanguinar | Valeera Sanguinar | Valeera Sanguinar | Valeera Sanguinar | Valira Sanguinar | Valeera Sanguinar | Валира Сангвинар | MEASURED (wago) |
| Eversong Woods | UiMap 2395 | Immersangwald | Bois des Chants éternels | Bosque Canción Eterna | Bosque Canción Eterna | Floresta do Canto Eterno | Boschi di Cantoeterno | Леса Вечной Песни | MEASURED (wago) |
| Amani Tablet (object) | GameObject 701639 (Wowhead); spell "Read Amani Tablet" SpellName 1298382 (= 1303897) | NOT FOUND (spell: "Schrifttafel der Amani lesen") | NOT FOUND (spell: "Lire la tablette amani") | NOT FOUND (spell: "Leer tablilla Amani") | NOT FOUND (spell: "Leer tablilla amani") | Tabuleta Amani | NOT FOUND (spell: "Lettura della Tavoletta degli Amani") | NOT FOUND (spell: "Чтение аманийской скрижали") | ptBR MEASURED (Wowhead object). Others: the object name is NOT FOUND. Only the spell text was measured (wago), and a noun taken from it would be DERIVED |
| Kul'amara the Fierce | Creature 241303 (258691 identical) | Kul'amara die Grimmige | Kul'amara la Féroce | Kul'amara la Fiera | Kul'amara, la Feroz | Kul'amara, a Feroz | Kul'amara l'Implacabile | Кул'амара Яростная | MEASURED (wago + Wowhead) |
| Atal'Aman | AreaTable 16194 (16556 identical) | Atal'Aman | Atal’Aman | Atal'Aman | Atal'Aman | Atal'Aman | Atal'aman | Атал'Аман | MEASURED (wago) |
| Jun'ala | NPC 264183 (Wowhead) | NOT FOUND | NOT FOUND | Jun'ala | NOT FOUND | Jun'ala | NOT FOUND | NOT FOUND | esES + ptBR MEASURED (Wowhead). Not in Creature DB2 |
| Sha'Kuro | NPC 262930 / 264495 (Wowhead) | NOT FOUND | NOT FOUND | Sha'Kuro | NOT FOUND | Sha'Kuro | NOT FOUND | NOT FOUND | esES + ptBR MEASURED (Wowhead). Not in Creature DB2 |
| Kinduru (spirit bird) | Creature 257344 "Kinduru <Loa Speaker>" (Labyrinth NPC IDs 273203 etc. on Wowhead) | Kinduru | Kinduru | Kinduru | Kinduru | Kinduru | Kinduru | Киндуру | MEASURED (wago 257344). Whether 257344 is the bird itself is DERIVED; the name is the same everywhere |
| Heavy Trunk(s) | ItemSparse 257386; Wowhead objects 584517/584519 identical | Schwere Truhe | Malle lourde | Baúl pesado | Baúl pesado | Baú Pesado | Baule Pesante | Тяжелый ларь | MEASURED (wago + Wowhead). Watch out: the older item 222922 is "Schwere Kiste" in deDE |
| Bountiful Coffer | ItemSparse 254250 | Großzügiger Kasten | Coffre abondant | Arca pródiga | Arca abundante | Cofre Abundante | Scrigno Fruttuoso | Богатый сундук | MEASURED (wago) |
| Great Vault | GlobalStrings 52150 DELVES_GREAT_VAULT_LABEL | Große Schatzkammer | La grande chambre forte | Gran cámara | Gran bóveda | Grande Cofre | Gran Banca | Великое хранилище | MEASURED (wago) |
| Crushing Blow | SpellName 1299117 (1270646 and 1299144 identical) | Schmetterschlag | Coup écrasant | Golpe aplastante | Golpe aplastante | Golpe Triturante | Colpo Devastante | Сокрушающий удар | MEASURED (wago). Which of the 3 IDs is Kindo'jan's was not checked, but all 3 are identical |
| Amani Juggernaut | NPC 267520 (Wowhead) | NOT FOUND | NOT FOUND | Gigante Amani | NOT FOUND | NOT FOUND | NOT FOUND | NOT FOUND | esES MEASURED (Wowhead) |
| Hash'ey's Command | SpellName 1298647 (1298656 identical) | Befehlsgewalt des Hash'ey | Ordres d’hash’ey | Mandato de hash'ey | Orden de los hash'ey | Comando dos Hash'ey | Ordine dell'Hash'ey | Приказ хаш'эй | MEASURED (wago) |
| Amani Headhunter(s) | NPC 267443 (Wowhead) | NOT FOUND | NOT FOUND | Rebanacabezas Amani | NOT FOUND | NOT FOUND | NOT FOUND | NOT FOUND | esES MEASURED (Wowhead) |
| Disgraceful Display | SpellName 1303494 | Beschämende Zurschaustellung | Démonstration affligeante | Espectáculo vergonzoso | Exhibición desgraciada | Atuação Vergonhosa | Spettacolo Vergognoso | Недостойное поведение | MEASURED (wago) |
| Loa-Spiritual Conduits | RenownRewards 2048 (Labyrinth Journey rank 6) | Spirituelle Leitungen der Loa | Conduits spirituels des Loas | Conductos espirituales loa | Conductos espirituales de los loa | Conduítes Espirituais dos Loas | Condotti Spirituali dei Loa | Мистические проводники лоа | MEASURED (wago) |
| Heroic Soul Fragment | ItemSparse 285801 (285807 identical) | Heroisches Seelenfragment | Fragment d’âme héroïque | Trozo de alma heroico | Fragmento de alma heroica | Fragmento de Alma Heroico | Frammento dell'Anima Eroico | Героический фрагмент души | MEASURED (wago) |
| Hero (track) | ItemNameDescription 14085 "Upgrade Level: Hero 1/6" | Held | héros ou héroïne | héroe | Héroe | Herói | Eroe | герой | MEASURED (wago; the word taken from the tooltip line) |
| Wah'du | NPC 264886 (Wowhead) | NOT FOUND | NOT FOUND | Wah'du | NOT FOUND | NOT FOUND | NOT FOUND | NOT FOUND | esES MEASURED (Wowhead). Not in Creature DB2 |
| Mythical Soul Fragment | ItemSparse 285065 | Mythisches Seelenfragment | Fragment d’âme mythique | Trozo de alma mítico | Fragmento de alma mítica | Fragmento de Alma Mítico | Frammento dell'Anima Mitico | Эпохальный фрагмент души | MEASURED (wago) |
| Undercoin(s) | CurrencyTypes 2803 | Lorenmünze | Sous-pièce | Inframoneda | Inframoneda | Fundobrão | Sottomoneta | Подземная монета | MEASURED (wago, singular) |
| Myth (track, "Myth 2/6") | ItemNameDescription 14092 "Upgrade Level: Myth 2/4" | Mythos | mythique | mito | Mito | Mito | Mito | легендарный герой | MEASURED (wago; the word taken from the tooltip line) |
| Akil'zon's Roost | AreaTable 17031 (inside map 3043) | Akil'zons Nest | Perchoir d’Akil’zon | Nidal de Akil'zon | Percha de Akil'zon | Poleiro de Akil'zon | Nido di Akil'zon | Гнездовье Акил'зон | MEASURED (wago) |
| Mislaid Treasure(s) (object) | GameObject 705955-705959 (Wowhead, en only); PerksActivity 1001; Achievement 63727/63728 description | NOT FOUND: DB2 disagrees with itself ("verlegte Schätze" in PerksActivity 1001, "verlorene Schätze" in Achievement 63727) | trésor(s) fourvoyé(s) | tesoro(s) extraviado(s) | tesoro(s) extraviado(s) | Tesouro(s) Mal Guardado(s) | Tesoro Smarrito / Tesori Smarriti | потерянное сокровище / потерянных сокровищ | DERIVED: from sentences measured on wago (PerksActivity 1001 + Achievement 63727). The object name itself is NOT FOUND (Wowhead shows only [brackets]) |
| Treasures Upon Treasures | Achievement 63727 | Schätze über Schätze | Des montagnes de trésors | Montones de tesoros | Incontables tesoros | Tesouros e mais tesouros | Tesori su tesori | Сокровища, сокровища и еще раз сокровища | MEASURED (wago) |
| A Few More Can't Hurt | Achievement 63728 | Ein paar mehr können nicht schaden | On n’en a jamais trop | Unas pocas más no me harán daño | Un poco más no hará daño | Mais umazinha não dói | Un altro po' non guastano | Еще немного не повредит | MEASURED (wago) |
| Restored Coffer Key | ItemSparse 263188 | Restaurierter Kastenschlüssel | Clé de coffret réparée | Llave de arca restaurada | Llave de arca restaurada | Chave de Cofre Restaurada | Chiave dello Scrigno Ripristinata | Отреставрированный ключ от сундука | MEASURED (wago) |

## Keystone Myth (CODEX_KEYSTONE_MYTH_BODY)

| English | entity (type + id) | deDE | frFR | esES | esMX | ptBR | itIT | ruRU | MEASURED/DERIVED |
|---|---|---|---|---|---|---|---|---|---|
| Midnight Keystone Myth: Season 2 | Achievement 63690 | Schlüsselsteinmythos von Midnight: Saison 2 | Saga mythique de Midnight : saison 2 | Mito de la piedra angular de Midnight: temporada 2 | Mito de piedra angular de Midnight: Temporada 2 | Mito da Pedra-chave de Midnight: Série 2 | Mito delle Chiavi di Midnight: Stagione 2 | Эпохальный герой ключей Midnight: 2-й сезон | MEASURED (wago) |
| the Venomous Contender (title, male / female) | CharTitles 1334 (Name_lang / Name1_lang) | %s der toxische Streiter / %s die toxische Streiterin | %s le combattant venimeux / %s la combattante venimeuse | %s, el Contendiente Venenoso / %s, la Contendiente Venenosa | %s, el contrincante venenoso / %s, la contrincante venenosa | %s, o Competidor Peçonhento / %s, a Competidora Peçonhenta | %s, il Contendente Venefico / %s, la Contendente Venefica | Ядовитый претендент %s / Ядовитая претендентка %s | MEASURED (wago) |
| Timelost Saddle | ItemSparse 279396 | Zeitverlorener Sattel | Selle perdue dans le temps | Silla de montar perdida en el tiempo | Silla de montar cronoperdida | Sela Perdida no Tempo | Sella Senza Tempo | Затерянное во времени седло | MEASURED (wago) |
| Mythic+ Rating | GlobalStrings 43914 DUNGEON_SCORE | Wertung für Mythisch+ | Cote mythique + | Índice de mítica+ | Puntaje mítico+ | Classificação Mítica+ | Punteggio Mitica+ | Счет в режиме "Эпохальный+" | MEASURED (wago) |
| Altar of Fangs | MapChallengeMode 588 (= JournalInstance 1322, Map 2993) | Altar der Fänge | Autel des crochets | Altar de los Colmillos | Altar de Colmillos | Altar das Presas | Altare delle Zanne | Алтарь Клыков | MEASURED (wago) |
| Murder Row | MapChallengeMode 587 (Map 2813; JournalInstance 1304) | Mördergasse | Allée du meurtre | Frontal de la Muerte | El Frontal de la Muerte | Travessa do Assassino | Traversa degli Intrighi | Закоулок душегубов | MEASURED (wago). frFR JournalInstance 1304 = "L’Allée du meurtre" |
| Ruby Life Pools | MapChallengeMode 399 (= JournalInstance 1202, Map 2521) | Rubinlebensbecken | Bassins de l’Essence rubis | Estanques de Vida Rubí | Estanques de Vida Rubí | Poços da Vida Rubi | Pozze della Vita di Rubino | Рубиновые Омуты Жизни | MEASURED (wago) |
| Temple of Sethraliss | MapChallengeMode 250 (= JournalInstance 1030; Map 1877) | Der Tempel von Sethraliss | Temple de Sephraliss | Templo de Sethraliss | Templo de Sethraliss | Templo de Sethraliss | Tempio di Sethraliss | Храм Сетралисс | MEASURED (wago). deDE Map 1877 = "Tempel von Sethraliss" (no "Der"). frFR really is "Sephraliss" |
| The Blinding Vale | MapChallengeMode 584 (= JournalInstance 1309; Map 2859) | Das blendende Tal | Le val Aveuglant | El Valle Cegador | El Valle Enceguecedor | O Vale Ofuscante | Valle Accecante | Слепящая долина | MEASURED (wago). esES Map 2859 = "Valle Cegador" (no "El") |
| Voidscar Arena | MapChallengeMode 585 (= JournalInstance 1313, Map 2923) | Arena der Leerennarbe | Arène de la Cicatrice du Vide | Arena Lacravacua | Arena Rajavacío | Arena da Chaga do Caos | Arena Sfregiavuoto | Арена Шрама Бездны | MEASURED (wago) |

## Atal'Utek, The Honored Dead and the rares (CODEX_ATALUTEK_DEAD_BODY)

| English | entity (type + id) | deDE | frFR | esES | esMX | ptBR | itIT | ruRU | MEASURED/DERIVED |
|---|---|---|---|---|---|---|---|---|---|
| The Honored Dead | Achievement 63610 | Die geehrten Toten | Les morts honorés | Homenaje a los difuntos | Homenaje a los difuntos | Os mortos honrados | Morti da onorare | Последние почести | MEASURED (wago) |
| Vaults of Atal'Utek ("the Vaults") | UiMap 2509 | Kammern von Atal'Utek | Caveaux d’Atal’Utek | Cámaras de Atal'Utek | Bóvedas de Atal'Utek | Câmaras de Atal'Utek | Segrete di Atal'utek | Хранилища Атал'Утека | MEASURED (wago) |
| To a sister. | CriteriaTree 231292 (ach 63610) | An eine Schwester. | À une sœur. | A una hermana | A una hermana. | A uma irmã. | A una sorella. | Сестре | MEASURED (wago) |
| To a shield-bearer. | CriteriaTree 231295 | An einen Schildträger. | À une porte-bouclier. | A un portaescudos | A un portaescudos. | A um escudeiro. | A un portascudo. | Щитоносцу | MEASURED (wago) |
| To a father. | CriteriaTree 231291 | An einen Vater. | À un père. | A un padre | A un padre. | A um pai. | A un padre. | Отцу | MEASURED (wago) |
| To a stranger. | CriteriaTree 231294 | An einen Fremden. | À un étranger. | A un forastero | A un forastero. | A um estranho. | A uno sconosciuto. | Незнакомцу | MEASURED (wago) |
| To a captain. | CriteriaTree 231288 | An einen Kapitän. | À un capitaine. | A un capitán | A un capitán. | A um capitão. | A un capitano. | Капитану | MEASURED (wago) |
| To a dream. | CriteriaTree 231287 | An einen Traum. | À un rêve. | A un dueño | A un sueño. | A um sonho. | A un sogno. | Мечте | MEASURED (wago). esES really says "dueño" ("owner"), the same in 12.1.7. It looks like a Blizzard typo, but it is what the client shows |
| To sons. | CriteriaTree 231289 | An Söhne. | À des fils. | A los hijos | A los hijos. | Aos filhos. | Ai figli. | Сыновьям | MEASURED (wago) |
| To a lover. | CriteriaTree 231285 | An eine geliebte Person. | À un amour. | A un amante | A un amante. | A um amante. | A un amante. | Любви | MEASURED (wago) |
| To comrades. | CriteriaTree 231293 | An Kameraden. | À des camarades. | A los camaradas | A los compañeros. | A companheiros. | Ai compagni. | Товарищам | MEASURED (wago) |
| To parents. | CriteriaTree 231286 | An die Eltern. | À des parents. | A los padres | A los padres. | Aos pais. | Ai genitori. | Родителям | MEASURED (wago) |
| To a daughter. | CriteriaTree 231284 | An eine Tochter. | À une fille. | A una hija | A una hija. | A uma filha. | A una figlia. | Дочери | MEASURED (wago) |
| To failure. | CriteriaTree 231290 | An das Versagen. | À un échec. | Al fallo | Al fracaso. | Ao fracasso. | Al fallimento. | Позору | MEASURED (wago) |
| The Underbelly (map) | UiMap 2613 (AreaTable 16990) | Die Schattenseite | Entrailles | Los Bajos Fondos | Bajos Fondos | Os Esgotos | Sotterranei | Клоака | MEASURED (wago). esES AreaTable 16990 = "Bajos Fondos" (no "Los") |
| Szarith the Fanged | CriteriaTree 225298 (ach 62601); Wowhead NPC 263456 | Szarith der Bezahnte | Szarith les Crochets | Szarith el Colmilludo | Szarith, el Colmillo | Szarith Presa Afiada | Szarith lo Zannuto | Сзарит Клыкастый | MEASURED (wago criteria; Wowhead NPC identical for de/fr/es/pt/it/ru) |
| Soft Underbelly | Achievement 62601 | Bedrohliche Schattenseite | Entrailles vulnérables | Punto flaco | Reptando los fondos | Ventre exposto | Sotterranei tranquilli | Уязвимость Клоаки | MEASURED (wago) |
| Temple Strike | AreaPOI 8775-8785 prefix (8782 below) + UiWidgetStringSource 23332 | Tempelvorstoß | Assaut du temple | Ataque al Templo | Ataque al templo | Ofensiva no Templo | Attacco al Tempio | Храмовый удар | MEASURED (wago; the prefix before the ":") |
| Temple Strike: The Underbelly | AreaPOI 8782 | Tempelvorstoß: Die Schattenseite | Assaut du temple : Entrailles | Ataque al Templo: Los Bajos Fondos | Ataque al templo: Los Bajos Fondos | Ofensiva no Templo: Os Esgotos | Attacco al Tempio: Sotterranei | Храмовый удар: Клоака | MEASURED (wago) |
| Congealed Malice | CriteriaTree 231186 (ach 63601); Wowhead NPC 263014 | Geronnene Bosheit | Malice figée | Malicia coagulada | Malicia coagulada | Malícia Coagulada | Malizia Coagulata | Сгустившаяся злоба | MEASURED (wago criteria; Wowhead NPC identical) |
| Khu'tulak | Wowhead NPC 263015 (nameplate); CriteriaTree 231187 | Khu'tulak | Khu'tulak (nameplate, U+0027) / Khu’tulak (achievement criterion, U+2019) | Khu'tulak | Khu'tulak | Khu'tulak | Khu'tulak | Ху'тулак | MEASURED (Wowhead NPC + wago criteria; esMX from the criterion only) |
| Susarikk | CriteriaTree 231188; Wowhead NPC 263016 | Susarikk | Susarikk | Susarikk | Susarikk | Susarikk | Susarikk | Сусарикк | MEASURED (wago + Wowhead) |
| Oppose the Foes | Achievement 63601 | Den Feinden entgegen | Les adversaires face à l’adversité | Oposición ancestral | Repele a los rivales | Oposição inimiga | Ormai sono superati | Бой врагам | MEASURED (wago) |
| Temple Incursion | AreaPOI 8770/8777/8786 prefix + UiWidgetStringSource 23338 | Tempelübergriff | Incursion du temple | Incursión en el Templo | Incursión al templo | Incursão do Templo | Incursione del Tempio | Храмовое вторжение | MEASURED (wago; the prefix of AreaPOI 8770. In the widget sentence esES/frFR write it in lowercase) |

## Mythic+ (MPLUS_AFFIX_LINDORMI)

| English | entity (type + id) | deDE | frFR | esES | esMX | ptBR | itIT | ruRU | MEASURED/DERIVED |
|---|---|---|---|---|---|---|---|---|---|
| Lindormi's Guidance | KeystoneAffix 165 (= SpellName 1278156, 1284818) | Lindormis Rat | Soutien de Lindormi | Guía de Lindormi | Guía de Lindormi | Orientação de Lindormi | Guida di Lindormi | Наставление Линдорми | MEASURED (wago) |
| Temporal Sands | none found | NOT FOUND | NOT FOUND | NOT FOUND | NOT FOUND | NOT FOUND | NOT FOUND | NOT FOUND | NOT FOUND. Searched for "Temporal Sand" in SpellName, Spell (Description + AuraDescription), ItemSparse, GlobalStrings, UiWidgetStringSource, KeystoneAffix, CurrencyTypes and Creature, on 12.1.5 and 12.1.7, and in Wowhead search. All empty. The search did work: "Lindormi highlights" in Spell.Description found 4 rows. DERIVED: the weakening aura on the highlighted enemies is itself called "Lindormi's Guidance" (SpellName 1278156, aura text "Health reduced by $s1%. Damage done reduced by $s2%."). The MH text probably names something that does not exist under that name |

## Vyranoth (MOUNTPROG_VYRANOTH_HOWTO)

| English | entity (type + id) | deDE | frFR | esES | esMX | ptBR | itIT | ruRU | MEASURED/DERIVED |
|---|---|---|---|---|---|---|---|---|---|
| Turbulent Timeways (event) | HolidayNames 430 | Turbulente Zeitwege | Voies temporelles turbulentes | Líneas temporales turbulentas | Portales del tiempo turbulentos | Percursos Temporais Turbulentos | Flussi Temporali Turbolenti | Бурные потоки времени | MEASURED (wago) |
| Master of the Turbulent Timeways V (the mount achievement) | Achievement 61463 | Meister der turbulenten Zeitwege V | Maîtrise des Voies temporelles turbulentes V | Maestro de Líneas Temporales Turbulentas V | Maestro de los portales del tiempo turbulentos V | Mestre dos Percursos Temporais Turbulentos V | Maestria dei Flussi Temporali Turbolenti V | Укротитель бурных потоков времени V | MEASURED (wago) |
| Spawn of Vyranoth | Mount 2806 (= ItemSparse 258884) | Brut von Vyranoth | Rejeton de Vyranoth | Engendro de Vyranoth | Engendro de Vyranoth | Cria de Vyranoth | Prole di Vyranoth | Порождение Виранот | MEASURED (wago) |
| Timewarped Badge(s) | CurrencyTypes 1166 | Zeitverzerrtes Abzeichen | Insigne distordu dans le temps | Distintivo del tiempo | Divisa cronoanómala | Insígnia Transtemporal | Distintivo Fuoritempo | Искаженный временем знак | MEASURED (wago, singular) |
| Timewalking | GlobalStrings 25846 PLAYER_DIFFICULTY_TIMEWALKER | Zeitwanderung | Marcheurs du temps | Paseo en el tiempo | Cronoviaje | Caminhada Temporal | Viaggio nel Tempo | Путешествие во времени | MEASURED (wago) |
| Timewalking Dungeon Event | HolidayNames 237 (239 identical) | Bonusereignis: Zeitwanderungsdungeons | Évènement Donjon des Marcheurs du temps | Evento de mazmorra de Paseo en el tiempo | Evento de calabozo de cronoviaje | Evento das Masmorras de Caminhada Temporal | Evento bonus: Viaggi nel Tempo | Путешествие во времени по подземельям | MEASURED (wago) |

## Points to watch (all MEASURED, unless marked otherwise)

- **frFR apostrophes are not consistent.** Map, area, spell and achievement strings use ’ (U+2019): Kindo’jan, Atal’Aman, Atal’Utek, Akil’zon, hash’ey, and Khu’tulak in the criterion. Creature names use ' (U+0027): Kul'amara, the Khu'tulak nameplate on Wowhead, and the Kinduru title "Disciple d'Akil'zon". The ’ in the frFR column is copied byte for byte from wago.
- **esMX writes "Kindo'Jan"** (capital J) in Map 3043, SpellName 1314916 and Achievement 63715. But the description of Achievement 63727 in esMX says "Laberinto de Kindo'jan" (small j).
- **Map and Journal/M+ names differ in 4 places:** Murder Row frFR, Temple of Sethraliss deDE, The Blinding Vale esES, The Underbelly esES (see the rows). For dungeons, the table gives the MapChallengeMode name (what the Mythic+ UI shows).
- **CriteriaTree memorial labels:** in enUS they end with a period, in lowercase ("To comrades.", "To failure."). MH writes "To Comrades" / "To Failure". In esES and ruRU the period is missing.
- **Heavy Trunk deDE:** the Midnight item and all the objects say "Schwere Truhe". Only the older item 222922 says "Schwere Kiste".
- NOT FOUND (no DB2 row, Wowhead [brackets]): Wah'du, Jun'ala, Sha'Kuro, Amani Juggernaut, Amani Headhunter (each only partly, see the rows), the object names Amani Tablet and Mislaid Treasure, and Temporal Sands. No esMX source exists for Wowhead-only names. An empty Wowhead tooltip proves nothing about the client.
