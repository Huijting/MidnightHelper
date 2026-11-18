local _, ns = ...
--[[ Mexican-Spanish overlay for the Forever class-quest texts, 17 Nov 2026 (mh-writer). Only runs on an esMX client,
	after ForeverClassQuests_esES.lua, and overwrites just the lines whose game words (items, NPCs, monsters, places,
	spells, "calabozo" for dungeon …) the esMX client shows differently, measured in Blizzard data (wago DB2 esMX,
	Wowhead Forever esMX). Not reviewed by a native speaker. ]]
if not ns.IS_FOREVER or GetLocale() ~= "esMX" then
	return
end
local es = ns._mhLocales and ns._mhLocales.esES
if not es then
	return
end
for k, v in pairs({
	-- Measured: ItemSparse/SpellName/GlobalStrings esMX (1.60.1.70938) and Wowhead Forever tooltips with locale=esMX (=
	-- locale 11). There is no AreaTable.esMX.csv, so place names stay as esES. A name Wowhead shows [bracketed] in esMX
	-- is not measured: the esES name stays in the line.
	-- Warlock
	FCQ_OBJ_WL_POWERSVOID = "toma Poderes del Vacío de los Libros robados de aquí",
	FCQ_OBJ_WL_FAMILIARHEAD = "derrota a Familiares viles para conseguir 6 Cabeza de familiar vil",
	FCQ_OBJ_WL_VERGA = "toma la Tablilla de Vergua del Alijo del Filo Ardiente en la cueva (entrada en 55.0, 9.8)",
	-- not measured: Perrine's Chest
	FCQ_OBJ_WL_GRIMOIRE = "toma el Grimorio Egalin del Perrine's Chest",
	FCQ_OBJ_WL_BIND_FEL = "usa el Libro del conciliábulo de tus bolsas en el círculo de invocación y luego derrota al Manáfago invocado",
	-- not measured esMX: Legashi Satyr, Jaedenar Legionnaire, Felguard Sentry (esES names kept)
	FCQ_OBJ_WL_ESS_AZSHARA = "derrota a Sátiros Legashi para conseguir la Esencia vil impecable (Azshara)",
	FCQ_OBJ_WL_ESS_JAEDENAR = "derrota a Legionarios Jaedenar para conseguir la Esencia vil impecable (Jaedenar)",
	FCQ_OBJ_WL_ESS_PORTAL = "derrota a Argos guardia maldito para conseguir la Esencia vil impecable (Portal oscuro)",
	FCQ_OBJ_WL_KROSHIUS = "usa aquí el Fuego vil de tus bolsas para despertar a Kroshius y luego derrótalo para conseguir el Núcleo infernal de Kroshius",
	-- not measured esMX: Shadethicket, Fallen Sky Lake (esES words kept)
	FCQ_OBJ_WL_SCARF = "derrota a enemigos Sombramatorral alrededor del Lago Cielo Estrellado hasta que caiga una Bufanda desgastada (más o menos 1 de cada 20)",
	FCQ_OBJ_WL_CORMA = "derrota a Comar Villardo para conseguir el Corazón de Comar",
	FCQ_OBJ_WL_RODS = "derrota a Guardahuesos Faucedraco y Depositarios de sombras Faucedraco para conseguir 3 Vara de mediación",
	FCQ_OBJ_WL_IRONORE = "trae 25 Mena de hierro negro",
	FCQ_OBJ_WL_DRAGONSCALE = "trae 35 Dragontina negra",
	FCQ_OBJ_WL_ARCANITE = "trae 3 Barra de arcanita",
	FCQ_OBJ_WL_STARDUST = "compra Polvo estelar xorothiano a Ur'dan",
	FCQ_OBJ_WL_IMPJAR = "en el calabozo Scholomance (necesitas un grupo), usa el Diablillo en un tarro en el laboratorio de alquimia",
	-- not measured esMX: Xorothian Dreadsteed (esES name kept)
	FCQ_OBJ_WL_RITUAL = "en el calabozo La Masacre, ala oeste (necesitas un grupo), usa los objetos de Gorzeeki Ojovago para el ritual y luego derrota al Corcel de la Muerte Xorothiano",
	-- Warrior
	FCQ_OBJ_WR_ULAG = "haz clic en la piedra con calavera (Mausoleum Trigger) junto al mausoleo y luego derrota a Ulag el Cuchilla",
	FCQ_OBJ_WR_CHARM_CRESTING = "derrota a Exiliados acuosos para conseguir 8 Talismán blasonado",
	-- not measured esMX: Cyclonian (esES name kept)
	FCQ_OBJ_WR_CYCLONIAN = "sigue a Bath'rah: invoca aquí a Ciclonio; derrótalo para conseguir el Corazón de espirálico (un élite de nivel 40: lleva ayuda)",
	FCQ_OBJ_WR_FEATHER_AMBER = "en el calabozo Templo Sumergido (necesitas un grupo), consigue 2 Pluma vudú ámbar",
	FCQ_OBJ_WR_FEATHER_BLUE = "en el Templo Sumergido, consigue 2 Pluma vudú azul",
	FCQ_OBJ_WR_FEATHER_GREEN = "en el Templo Sumergido, consigue 2 Pluma vudú verde",
	-- Hunter (Taming Rod = "Fusta de doma" on esMX; trinket = "Abalorio")
	FCQ_CHAIN_HU_CHARM = "Las misiones de El talismán del cazador (objetos como recompensa)",
	FCQ_OBJ_HU_WEBWOOD = "usa la Fusta de doma de tus bolsas en un Rondador Tejemadera y quédate cerca hasta que esté domado",
	FCQ_OBJ_HU_NIGHTSABER = "usa la Fusta de doma de tus bolsas en un Acechador sable de la noche y quédate cerca hasta que esté domado",
	FCQ_OBJ_HU_SCREECHER = "usa la Fusta de doma de tus bolsas en un Estridador estrígido y quédate cerca hasta que esté domado",
	FCQ_OBJ_HU_CRAGBOAR = "usa la Fusta de doma de tus bolsas en un Jabalí del risco grande y quédate cerca hasta que esté domado",
	FCQ_OBJ_HU_SNOWLEOPARD = "usa la Fusta de doma de tus bolsas en un Leopardo de las nieves y quédate cerca hasta que esté domado",
	FCQ_OBJ_HU_ICECLAW = "usa la Fusta de doma de tus bolsas en un Oso zarpahelada y quédate cerca hasta que esté domado",
	FCQ_OBJ_HU_ROCKHIDE = "usa la Fusta de doma de tus bolsas en un Jabalí Pielroca y quédate cerca hasta que esté domado",
	FCQ_OBJ_HU_GRAYWOLF = "usa la Fusta de doma de tus bolsas en un Lobo grisáceo del bosque y quédate cerca hasta que esté domado",
	FCQ_OBJ_HU_FORESTBEAR = "usa la Fusta de doma de tus bolsas en un Oso del bosque joven y quédate cerca hasta que esté domado",
	FCQ_OBJ_HU_DIREBOAR = "usa la Fusta de doma de tus bolsas en un Jabalí jaspeado temible y quédate cerca hasta que esté domado",
	FCQ_OBJ_HU_SURFCRAWLER = "usa la Fusta de doma de tus bolsas en un Reptador de espuma y quédate cerca hasta que esté domado",
	FCQ_OBJ_HU_SCORPID = "usa la Fusta de doma de tus bolsas en un Escórpido acorazado y quédate cerca hasta que esté domado",
	FCQ_OBJ_HU_PLAINSTRIDER = "usa la Fusta de doma de tus bolsas en un Zancudo de llanura adulto y quédate cerca hasta que esté domado",
	FCQ_OBJ_HU_STALKER = "usa la Fusta de doma de tus bolsas en un Acechador de pradera y quédate cerca hasta que esté domado",
	FCQ_OBJ_HU_SWOOP = "usa la Fusta de doma de tus bolsas en un Aguilón y quédate cerca hasta que esté domado",
	-- not measured esMX: Windsong Crawler (esES name kept)
	FCQ_OBJ_HU_WINDSONG = "usa la Fusta de doma de tus bolsas en un Reptador Canzalvaje (un cangrejo, cerca del agua) y quédate cerca hasta que esté domado",
	FCQ_OBJ_HU_GALESTRIDER = "usa la Fusta de doma de tus bolsas en un Zancavientos enfurruñado (un pájaro grande que camina) y quédate cerca hasta que esté domado",
	FCQ_OBJ_HU_VULDREN = "usa la Fusta de doma de tus bolsas en un vuldren alfa (un zorro con alas) y quédate cerca hasta que esté domado",
	-- not measured esMX: Mosshoof Courser (esES name kept)
	FCQ_OBJ_HU_ANTLERS = "derrota a Maledictores Pezuñamusgo para conseguir 2 Cornamenta perfecta de trotador",
	-- not measured esMX: Wavethrasher (esES name kept; the esMX item says "descarnador marino")
	FCQ_OBJ_HU_SCALES = "derrota a Vándalos marinos en el agua para conseguir 6 Escamas de descarnador marino",
	FCQ_OBJ_HU_MORPHAZ = "en el calabozo Templo Sumergido (necesitas un grupo), derrota a Morphaz para conseguir el Diente de Morphaz",
	-- Rogue
	FCQ_CHAIN_RO_BLADE = "Hoja de astucia (una daga)",
	FCQ_CHAIN_RO_TOOLS = "Herramientas de ladrón (para Forzar cerraduras)",
	FCQ_OBJ_RO_FLARE = "dispara dos veces la Pistola de bengalas y luego escribe /salute hacia el Capataz Fizzule",
	FCQ_OBJ_RO_LOOKOUTS = "derrota a 2 Oteadores de Ventura y Cía.",
	FCQ_OBJ_RO_GALLYWIX = "derrota al Gran supervisor Puzik Gallywix (élite) para conseguir su cabeza",
	-- not measured: Goblin Lockpicks
	FCQ_OBJ_RO_VEENIX = "busca a Veenix: toma las Goblin Lockpicks, usa Robar en un Maderero de Ventura y Cía. para conseguir un Pedido de Ventura y Cía. y entrégalo a cambio de la Carga destructora",
	-- not measured esMX: Forest Ooze (esES name kept)
	FCQ_OBJ_RO_FRAGMENTS = "consigue 10 Trozo codificado de Mocos del bosque",
	FCQ_OBJ_RO_AZUREKEY = "en el calabozo Templo Sumergido (necesitas un grupo), consigue la Llave azur de Morphaz",
	FCQ_WAIT_RO_LETTER = "espera una carta de C en tu buzón (de un cuarto de hora a dos horas) y luego vuelve al Punto de entrega",
	-- Shaman
	FCQ_OBJ_SH_HOOVES = "derrota a Acechadores viles dentro y alrededor de la cueva para conseguir 2 Pezuña de acechador vil",
	FCQ_OBJ_SH_SALVE = "derrota a Chamanes Erizapúas para conseguir 2 Ungüento de ritual",
	FCQ_OBJ_SH_SIGNET = "derrota a Conversos Al'Aketh para conseguir un Sello de Akir",
	FCQ_OBJ_SH_POUCH_H = "en la cueva (entrada en 52.8, 28.8), derrota a Cultores Filo Ardiente para conseguir una Faltriquera de componentes",
	FCQ_OBJ_SH_POUCH_A = "derrota a Videntes Rompecantos para conseguir una Faltriquera de componentes (hay muchos troggs: lleva ayuda)",
	FCQ_OBJ_SH_FALADIEL = "derrota al Sacerdocielo Faladiel para conseguir el Corazón de Faladiel",
	-- not measured: Eternal Flame
	FCQ_OBJ_SH_RITUAL = "espera a que Olariaan Fuegoveloz encienda la Eternal Flame y luego usa la Antorcha de la Llama eterna de tus bolsas (no se mueve de su sitio)",
	FCQ_OBJ_SH_BRACERS = "bebe aquí la Sapta de agua de tus bolsas y luego derrota a la Manifestación de agua menor corrupta para conseguir los Brazales de manifestación corrupta",
	FCQ_OBJ_SH_ELEM_AIR = "trae 1 Aire elemental (cae de enemigos, o cómpralo en la Casa de subastas)",
	FCQ_OBJ_SH_ELEM_FIRE = "trae 1 Fuego elemental (cae de enemigos, o cómpralo en la Casa de subastas)",
	FCQ_OBJ_SH_ELEM_EARTH = "trae 1 Tierra elemental (cae de enemigos, o cómpralo en la Casa de subastas)",
	FCQ_OBJ_SH_ELEM_WATER = "trae 1 Agua elemental (cae de enemigos, o cómpralo en la Casa de subastas)",
	FCQ_OBJ_SH_SPIDEREYE = "derrota a arañas para conseguir 8 Ojo de araña tirosangre",
	-- Priest (Lesser Heal = "Sanación inferior" on esMX)
	FCQ_CHAIN_PR_CENARION = "Las misiones de Ogtinc (objetos como recompensa)",
	FCQ_OBJ_PR_ROBERTS = "sana a Guardia Roberts con Sanación inferior (Rango 2) y luego lánzale Palabra de poder: entereza",
	FCQ_OBJ_PR_DOLF = "sana a Montaraz Dolf con Sanación inferior (Rango 2) y luego lánzale Palabra de poder: entereza",
	FCQ_OBJ_PR_SHAYA = "sana a Centinela Shaya con Sanación inferior (Rango 2) y luego lánzale Palabra de poder: entereza",
	FCQ_OBJ_PR_KORJA = "sana a Bruta Kor'ja con Sanación inferior (Rango 2) y luego lánzale Palabra de poder: entereza",
	FCQ_OBJ_PR_KEL = "sana a Guardia de la Muerte Kel con Sanación inferior (Rango 2) y luego lánzale Palabra de poder: entereza",
	FCQ_OBJ_PR_GLANDS = "derrota a Maledictores Pezuñamusgo para conseguir 4 Glándula de trotador sano",
	FCQ_OBJ_PR_MORPHAZ = "en el calabozo Templo Sumergido (necesitas un grupo), derrota a Morphaz para conseguir la Sangre de Morphaz",
	-- Paladin
	FCQ_OBJ_PA_RESURRECT = "usa el Símbolo de la vida de tus bolsas en el cuerpo de aquí",
	FCQ_OBJ_PA_DEFIAS_SCRIPT = "derrota a Zahoríes bribones de Defias para conseguir la Misiva Defias",
	FCQ_OBJ_PA_DARKIRON_SCRIPT = "derrota a Espías Hierro Negro para conseguir la Misiva Hierro Negro",
	-- not measured: the quest Bailor's Ore Shipment
	FCQ_OBJ_PA_ORE = "necesitas el Envío de mena refinada de Jordan: haz aquí la misión Bailor's Ore Shipment",
	FCQ_OBJ_PA_LUMBER = "en el calabozo Las Minas de la Muerte (necesitas un grupo), derrota a Talladores de madera goblin para conseguir Madera de roble de Piedrablanca",
	FCQ_OBJ_PA_HAMMER = "en el calabozo Castillo de Colmillo Oscuro (necesitas un grupo), toma el Martillo de herrería de Jordan en el establo",
	FCQ_OBJ_PA_SCOURGESTONES = "derrota a no-muertos para conseguir 20 Piedra de la Plaga del esbirro",
	-- not measured: Supply Crates
	FCQ_OBJ_PA_HOLYWATER = "en el calabozo Stratholme (necesitas un grupo), abre Supply Crates para conseguir 5 Agua bendita de Stratholme",
	FCQ_OBJ_PA_ARCANITE = "trae 6 Barra de arcanita y 150 de oro",
	-- not measured esMX: Tendris Warpwood (esES name kept)
	FCQ_OBJ_PA_HORSEFEED = "trae aquí 20 Galleta enriquecida con maná (intendente de El Alba Argenta, desde Amistoso) y 50 de oro: esta misión da el Alimento para caballos enriquecido con maná. Luego derrota a Tendris Madeguerra en La Masacre, ala oeste (necesitas un grupo)",
	FCQ_OBJ_PA_BLACKDIAMOND = "trae un Diamante negro prístino (cae pocas veces en calabozos de nivel alto, o cómpralo en la Casa de subastas)",
	FCQ_OBJ_PA_SATCHEL = "abre la bolsa que tienes en tus bolsas: dentro están el Cristal de adivinación y la barda",
	-- not measured: Great Ossuary; not measured esMX: Rattlegore, Death Knight Darkreaver (esES names kept)
	FCQ_OBJ_PA_SCRYER = "en el calabozo Scholomance (necesitas un grupo), usa el Cristal de adivinación en el sótano del Great Ossuary después de Traquesangre y luego derrota a los espíritus y al Caballero de la Muerte Atracoscuro",
	FCQ_OBJ_PA_HEAL_DEATHGUARDS = "sana a 5 Guardias de la muerte heridos con Luz Sagrada (también te hace daño a ti: vigila tu salud)",
	FCQ_OBJ_PA_TOUR_HILDA = "habla con Hilda, la Ultrajadora (va caminando por la zona)",
	-- not measured: Lumber Piles
	FCQ_OBJ_PA_STURDY_LUMBER = "recoge 12 Leña robusta de los Lumber Piles de la cripta",
	FCQ_OBJ_PA_DRUDGES = "derrota a 8 Esclavos mancillados",
	FCQ_OBJ_PA_ATTACK_PLANS = "derrota a Frailes Escarlata y Zelotes Escarlata para conseguir los Planes de ataque de la Cruzada Escarlata",
	FCQ_OBJ_PA_SILVER_INGOT = "en el calabozo Castillo de Colmillo Oscuro (necesitas un grupo), consigue el Lingote de plata encantado",
	FCQ_OBJ_PA_OLD_FIREEYE = "derrota al Viejo Ojofuego con el Filo de lunaplata (un huargen élite de nivel 25 que ronda cerca de La Muralla de Cringrís: lleva ayuda)",
	-- Mage
	FCQ_CHAIN_MA_WINDBOUGH = "Varita ramaviento (una varita)",
	FCQ_CHAIN_MA_ROBE_H = "Togas de fuego de hechizo inferior (una toga)",
	FCQ_CHAIN_MA_GARMENT_H = "Prendas de encaje Abisal (una toga o una túnica)",
	-- not measured: A Lesson in Literacy. Off hand = "mano izquierda" on esMX (see esMX.lua, MBUFF_TXT_WEAPONITEM_OH).
	FCQ_CHAIN_MA_SPELLBOOK = "A Lesson in Literacy (el Libro de hechizos personal, para tu mano izquierda)",
	FCQ_CHAIN_MA_WATER = "Crear agua (Rango 7)",
	FCQ_OBJ_MA_BOUGH = "recoge del suelo una Rama infundida con el viento junto al santuario del viento (no brilla)",
	FCQ_OBJ_MA_CANTATION = "toma el Canto de manifestación: el pergamino que está justo detrás del instructor",
	-- not measured: The Blue Recluse
	FCQ_OBJ_MA_COFFERS_A = "en The Blue Recluse (la taberna, mejor en el sótano) usa el Canto de manifestación, golpea a un Engendro de falla hasta que se quede aturdido, usa en él el Cofre de arcas de contención y haz clic en el Arca de contención llena del suelo. Necesitas 3; el Canto funciona una vez cada 5 minutos",
	FCQ_OBJ_MA_COFFERS_H = "en el puente delante de la tienda del alquimista usa el Canto de manifestación, golpea a un Engendro de falla hasta que se quede aturdido, usa en él el Cofre de arcas de contención y haz clic en el Arca de contención llena del suelo. Necesitas 3; el Canto funciona una vez cada 5 minutos",
	FCQ_OBJ_MA_MANAGEMS = "derrota a magos de Dalaran alrededor de Molino Ámbar para conseguir 6 Gema de maná de Dalaran",
	-- not measured esMX: Carrion Recluse (esES name kept)
	FCQ_OBJ_MA_SILK = "derrota a arañas en el Cementerio del Cerro del Cuervo para conseguir 8 Seda prístina de araña (los Ermitaños carroñeros son los que más la sueltan)",
	FCQ_WAIT_MA_BOOK = "primero lleva cualquier libro de la biblioteca al bibliotecario (los libros están en mesas y estanterías por el mundo). Después de tu primer libro, el bibliotecario te ofrece Acceso de investigación",
	FCQ_OBJ_MA_STICKS = "derrota a Trols Secacorteza para conseguir 10 Palo totémico Secacorteza",
	-- 18 Nov 2026: esMX client says Sanación inferior for spell 2052 (DB2 70959, measured; esES Curación inferior).
	FTRAVEL_NOTE_TB = "¿Buscas un zepelín? Cima del Trueno no tiene. Si conoces el punto de vuelo de Orgrimmar, vuela allí con el maestro de vuelo y toma el zepelín; la primera vez tienes que ir a pie, por Los Baldíos. Este cortacielos va a la Isla Zephras.",
	-- Boss guide (18 Nov 2026): esMX says "calabozo" where esES says "mazmorra" (CLAUDE.md, esMX overlay).
	FDG_NONE = "MH aún no tiene guía de jefes para este calabozo.",
	FDG_HINT = "Dentro de un calabozo se abre en ese calabozo. Pon a un jefe como objetivo: MH lo marca. /mh bosses lo abre.",
	FDG_DROWN_2_D1 = "Dos sacerdotisas escamasalada lo sanan.",
	FDGP_ARMORY = "Arsenal",
	FDG_SM_7_D3 = "El cofre detrás de él guarda la llave Escarlata: la necesitas para las puertas del Arsenal y la Catedral.",
	FDG_BRD_6_D1 = "Un elemental de fuego en el Yunquenegro, sobre una plataforma encima de la lava; una misión de la Alianza y otra de la Horda piden su muerte.",
	FDG_DIRE_16_D1 = "Un raro: no siempre está; cerca de las rampas junto al Magister Kalendris.",
	FDGP_SERVICE_GATE = "Entrada de Servicio",
	FDG_STRAT_17_D1 = "Su Llave de la ciudad abre la Entrada de Servicio: con ella, en las siguientes partidas puedes saltarte el lado de la Entrada Principal.",
	FDG_STRAT_17_D2 = "Si vienes de la Entrada Principal, lo encuentras junto a la capilla al inicio del lado no-muerto; abre la Entrada de Servicio y él corre a un sitio justo antes de la Plaza Degolladero.",
	FDG_THANES_L2 = "tanque (pechera de malla, armadura extra)",
	FDG_BFD_L3 = "tanque (pechera de malla, armadura extra)",
	FDG_WC_L3 = "portador de malla de Fuerza (+10 de Fuerza)",
	FDG_EXCAV_L3 = "portador de malla: tanque o cuerpo a cuerpo (+12 de Aguante, +golpe)",
	FDG_BRD_8_D1 = "Opcional: abre las doce arcas de reliquias de la Cámara Negra con llaves que caen dentro del calabozo.",
	FDG_BRD_12_D1 = "Espera en El Taller; los gólems que están cerca de él cobran vida y lo ayudan.",
	FDG_BRS_L3 = "sanador con cuero (+20 de sanación, +18 de Intelecto; pieza de conjunto de calabozo)",
	FDG_BMAW_1_D1 = "Un oso grande en una cueva cerca del inicio del calabozo.",
	FDG_BRS_6_D1 = "Opcional: necesitas la misión de Warosh. Antes en el calabozo, despoja la Cabeza de Omokk y una Pica férrea, combínalas y ponlas en el montón de cabezas de ogro.",
	FDG_SCHOLO_1_D2 = "Opcional: solo viene cuando pones la Sangre inocente en el brasero del porche; la suelta la Administradora de sangre de Kirtonos, un demonio al principio del calabozo.",
	FDG_RFD_2_D1 = "Opcional: habla con el prisionero Belnistrasz y acepta su misión; Faucepeste aparece al final, mientras proteges a Belnistrasz en el ídolo jabaespín.",
	FDG_RFD_2_T = "Mantén a todos los enemigos lejos de Belnistrasz; contra Faucepeste, los lanzadores de hechizos y el sanador se quedan a distancia: su hedor impide lanzar hechizos cerca de él.",
	FDG_ST_5_D1 = "Aparece con Segasueños en la gran sala central cuando Jammal'an ha muerto.",
	FDG_ST_5_T = "Sepáralo de Segasueños si puedes; tanquéalo contra una pared, de espaldas al grupo.",
	FDG_ST_6_D1 = "Aparece con Hazzas en la sala que hay delante de la Sombra de Eranikus cuando Segasueños y Sastrón han muerto.",
	FDG_ST_7_D1 = "Aparece con Morphaz en la sala que hay delante de la Sombra de Eranikus cuando Segasueños y Sastrón han muerto.",
	FDG_BRD_2_T = "Encárgate de él, y del Maestro de canes Grebmar, antes del Círculo de la Ley.",
	FDG_BRD_5_D1 = "Está arrodillado ante el monumento del Santuario de Thaurissan, donde terminas la misión de la Llave de Forjatiniebla.",
	FDG_BRD_9_D3 = "Suelta Ferrovil: colócalo en el monumento del Santuario de Thaurissan para terminar la misión de la Llave de Forjatiniebla.",
	FDG_BRD_18_D1 = "Empieza cuando hablas con Condena'rel en la Tumba del Invocador; luego los siete espíritus enanos luchan contra ti por turnos.",
	FDG_BRD_L1 = "cuerpo a cuerpo (abalorio, +12 de poder de ataque, probabilidad de un ataque extra)",
	FDG_DIRE_9_D2 = "Recorrido de tributo: repara la trampa rota de su camino con Aceite de Escarcha y un Trasto de torio, y se queda congelado en ella.",
	FDG_DIRE_10_D3 = "Recorrido de tributo: ponte un Disfraz de ogro Gordok y habla con él; se marcha.",
	FDG_DIRE_L1 = "lanzador de hechizos/sanador (maza de mano derecha, +68 de poder con hechizos)",
	FDG_DIRE_L7 = "lanzador de hechizos (espada de mano derecha, +72 de poder con hechizos)",
	FDG_BRS_1_D3 = "Suelta una de las tres gemas para el Sello de ascensión, la llave de Cumbre de Roca Negra superior.",
	FDG_BRS_8_D2 = "Poco después de que muera, entra corriendo Gizrul el Esclavista.",
	FDG_BRS_11_D1 = "La puerta de Cumbre de Roca Negra superior solo se abre si alguien del grupo lleva el Sello de ascensión, de una cadena de misiones que empieza en Cumbre de Roca Negra inferior.",
	FDG_BRS_12_D1 = "Opcional: toca la Llama paternal al fondo de la sala de los huevos para iniciar oleadas de dragonantes; él llega el último.",
	FDG_BRS_15_D2 = "Luego entra Rend montado en su dragón Gyth, que lanza fuego y ácido delante de él.",
	FDG_BRS_15_D3 = "Cuando Gyth tiene poca salud, Rend salta y lucha solo: gira y golpea a todos los que tiene delante.",
	FDG_BRS_15_T = "Trae un segundo tanque para Rend; mata primero a Gyth, y los de cuerpo a cuerpo salen de su giro.",
	FDG_BRS_L5 = "cuerpo a cuerpo (espada de mano derecha, +1% de crítico)",
	FDG_SCHOLO_1_D1 = "La puerta del portal está cerrada: un jugador necesita la Llave esqueleto (cadena de misiones La llave de Scholomance), o trae un pícaro con Ganzúa 280 o una Carga de seforio potente.",
	FDG_SCHOLO_2_D3 = "Suelta la Bolsa de los horrores de Krastinov para una misión de Eva Sarkhoff.",
	FDG_SCHOLO_5_D1 = "Está en la Sala de la Visión con Marduk; la misión Gambito del Alba trata de él.",
	FDG_SCHOLO_6_D3 = "Para una misión, usa primero el Libro de Memorias del Alma sobre él: lo vuelve mortal.",
	FDG_SCHOLO_7_D1 = "Opcional: solo para las misiones del conjunto de calabozo 2; invócalo en la sala de Ras Murmuhielo con el brasero de esas misiones.",
	FDG_STRAT_7_D1 = "Guarda su caja fuerte en el Bastión Escarlata; contiene el Medallón de fe para una misión de Aurius.",
	FDG_DAL_2_D1 = "Opcional: aparece cuando usas el Tomo de Dalaran sobre una runa morada en las cloacas, pasado el primer jefe.",
	FDG_DAL_2_D2 = "El tomo se hace con el Tomo oscuro de la mesa de Arugal en el Castillo de Colmillo Oscuro, en un cristal azul de Molino Ámbar.",
	FDG_GNOMER_1_D1 = "Opcional: solo aparece en un evento: habla con la Maestra Destructora Emi Plomocorto en la cueva cerca de la entrada.",
	FDG_SM_L12 = "sanador (maza de mano derecha, +94 de sanación)",
	FDG_DROWN_5_D2 = "Solo aparece cuando todas las Ofrendas eternas de esa sala han muerto.",
	FDG_DROWN_8_D1 = "Un raro: no siempre está; de camino al Elemental primitivo.",
	FDG_KROL_L1 = "lanzador de hechizos/sanador (daga de mano derecha, +52 de poder con hechizos)",
	FDG_ULDA_1_T = "Interrumpe sus rayos; quien tenga el Medallón de Gni'kiv recoge también el bastón.",
	FDG_ULDA_2_D3 = "El cofre de su sala guarda el Medallón de Gni'kiv: la otra mitad de la llave hacia Hierraya.",
	FDG_ULDA_6_D1 = "Un lanzador de fuego con Geólogos de Forjatiniebla como ayudantes.",
	FDG_ULDA_L1 = "lanzador de hechizos/sanador (maza de mano derecha, +54 de poder con hechizos)",
	FDG_ZF_8_T = "Lucha contra ellos solo si alguien necesita la Vara divinomática; mata primero a su sanador.",
	FDG_ZF_L1 = "sanador/lanzador de hechizos (abalorio, maná cada 5 s)",
	FDG_MARA_L1 = "cualquiera (abalorio: quita un veneno, +12 de resistencia a la Naturaleza)",
	FDG_MARA_L3 = "cuerpo a cuerpo con dos armas (arma de puño de mano izquierda, veneno al golpear)",
	FDG_ALCAZ_3_D1 = "En el piso inferior; dos Capellanes de Alcaz luchan con ella.",
	FDG_RFC_L1 = "sanador (maza de mano derecha, +33 de sanación)",
	FDG_RFC_L3 = "cuerpo a cuerpo (espada de mano derecha)",
	FDG_THANES_L3 = "cuerpo a cuerpo de Fuerza (hacha de mano derecha)",
	FDG_LORD_L2 = "lanzador de hechizos/sanador (maza de mano derecha, +24 de poder con hechizos)",
	FDG_SFK_L3 = "sanador/lanzador de hechizos (abalorio, maná cada 5 s)",
	FDG_STOCKS_L1 = "lanzador de hechizos/sanador (espada de mano derecha, +34 de poder con hechizos)",
	FDG_STOCKS_L2 = "cuerpo a cuerpo de Fuerza (hacha de mano derecha)",
	-- esMX client says Forzar cerradura for Pick Lock 1804 (DB2 70959, measured; esES Ganzúa).
	FOV_Q_OPENABLES_DESC = "Un botón que aparece cuando tus bolsas tienen una caja, una bolsita o una almeja que puedes abrir. Un clic abre una. Las cajas cerradas con llave se quedan fuera (primero Forzar cerradura de un pícaro o una llave). Oculto en combate. Lo mismo que /mh open on|off.",
	FCQ_PRE_WL_POTION = "primero compra Pociones enigmáticas a Gorzeeki Ojovago (unas 6 de oro por 3): las necesitas para atravesar Jaedenar. Lleva también 150 de oro para el Polvo estelar xorothiano de después",
	-- esMX: Tarro de J'eevee 18663, Glifos xorothianos 18670 (DB2 70959, measured).
	FCQ_PRE_WL_RITUAL = "primero compra el Tarro de J'eevee, una Magnetita negra y los Glifos xorothianos a Gorzeeki Ojovago (unos 250 de oro en total): el ritual de La Masacre necesita los tres. No hace falta si te acompaña un brujo que ya los tiene y hace el ritual",
	FCQ_PRE_PR_HEAL2 = "primero aprende el segundo rango de Sanación inferior con tu instructor (desde el nivel 4): la misión pide ese rango",
	FCQ_OBJ_MA_BRAMBLE = "acaba con los elementales y luego usa un Palo totémico Secacorteza de tus bolsas en la piedra del centro del Círculo de Vínculo Exterior. Espera unos diez segundos y haz clic en la Zarza electrificada",
	FCQ_OBJ_MA_PLUCKY = "selecciona a Johnson el \"Desplumado\" (un pollito), escribe /beckon y luego habla con él y pídele la frase",
	-- not measured: the wing name "Library"
	FCQ_OBJ_MA_RITUALS = "en el calabozo Monasterio Escarlata, Biblioteca (necesitas un grupo), toma el libro Rituales de Poder de la estantería de la izquierda en el último pasillo largo",
	FCQ_OBJ_MA_POWERSOURCE = "en el calabozo Uldaman (necesitas un grupo; esta puerta trasera es la más cercana), derrota a la Centinela obsidiana para conseguir la Fuente de poder obsidiana",
	-- not measured: Shallow Grave
	FCQ_OBJ_MA_PAPYRUS = "en el calabozo Zul'Farrak (necesitas un grupo), consigue 8 Papiro farraki de las Shallow Graves y de los zombis que salen de ellas",
	FCQ_OBJ_MA_SHARD = "en el calabozo Templo Sumergido (necesitas un grupo), consigue el Fragmento arcano de Morphaz",
	-- not measured esMX: Hydrospawn (esES name kept)
	FCQ_OBJ_MA_HYDROSPAWN = "en el calabozo La Masacre, ala este (necesitas un grupo), derrota a Hidromilecio para conseguir la Esencia de Hidromilecio",
	-- not measured: Scalebeard; not measured esMX: Warlord Krellian (esES name kept)
	FCQ_OBJ_MA_SHELL = "derrota a Scalebeard (una tortuga) en su cueva para conseguir la Concha centelleante. Si tu misión se llama Señor de la Guerra Krellian: está en el Templo de Zin-Malor (41.0, 53.1)",
	-- not measured esMX: Polymorph Clone (esES name kept)
	FCQ_OBJ_MA_CLONES = "guarda la Concha centelleante en tus bolsas, lanza Polimorfia a un naga Látigo de Ira, espera unos segundos y derrota a los Clones polimórficos que aparecen. Repite hasta tener 50 (no en un grupo de banda)",
	-- 17 Nov 2026: the overview (/mh overview, ForeverOverview.lua): FOV_*, FDUNG_IN_ENEMY_FMT
	-- LEGACY_BUTTON is "Legado" on esMX ("Banda antigua" on esES; LEGACY_VERIFIED ch. 10). Camping (1308027) is
	-- "Campamento" on esMX ("Acampando" on esES); tab and camp words as in ForeverHowToPlay_esMX.lua ("Campamento",
	-- "elemento de campamento").
	FOV_TAB_CAMP = "Campamento",
	-- GlobalStrings LEGACY_BUTTON esMX (LEGACY_VERIFIED r.341); esES says "Banda antigua"
	FOV_TAB_LEGACY = "Legado",
	FOV_TIP_TAB_CAMP = "Campamento: lo que MH puede leer ahora de tus buffs de campamento, y cómo funciona el campamento.",
	FOV_LABEL_CAMP_HOW = "CÓMO FUNCIONA EL CAMPAMENTO",
	FOV_TIP_CAMP_BENEFITS = "El buff de campamento: 1 hora, una línea por cada elemento de campamento junto a la hoguera.",
	FOV_TIP_CAMP_COOLDOWN = "Todos los elementos de campamento comparten una espera de 1 hora.",
	FOV_TIP_LEG_AVAIL = "Puntos que este personaje aún puede gastar. Pulsa el botón Legado en la barra de menú.",
	-- 17 Nov 2026 (late): overview front door, Now list, trainer page
	-- Tab names on esMX: "Campamento" and "Legado" (see above).
	CMDLIST_OVERVIEW = "WoW Forever: abre o cierra el resumen de Midnight Helper: qué hacer ahora, cómo jugar, misiones de clase, Campamento y Legado. /mh, Alt+M y el botón del minimapa también lo abren.",
	-- 17 Nov 2026, product plan steps 4-5 (Find, Your class, Keys & macros)
	-- Tab name "Campamento" on esMX ("Acampando" on esES, see above).
	FOV_TIP_TAB_CLASS = "Cómo se juega tu clase, todas tus misiones de clase y Campamento. Cambia arriba en la página.",
	-- 17 Nov 2026, product plan steps 6-9 (Professions, Dungeons & group, Characters, gear page)
	-- dungeon = "calabozo" on esMX (esMX.lua header); AddOns = "Accesorios" on esMX (as esMX.lua SET_LAUNCH_HINT).
	FOV_TIP_Q_ALLSETTINGS = "Abre Midnight Helper en la configuración del juego (Opciones → Accesorios).",
	FOV_TAB_DUNG = "Calabozos y grupo",
	FOV_TIP_TAB_DUNG = "Qué calabozos van con tu nivel y el camino hasta su entrada, tus bandas bloqueadas y ayuda para tu grupo.",
	FOV_LABEL_DUNG = "CALABOZOS",
	FOV_TIP_CARD_DUNG = "Cada calabozo con sus niveles y la zona de su entrada, de menor a mayor. Camino pone la flecha en la entrada.",
	FOV_TIP_DUNG_ONLYMINE = "Activado: solo los calabozos que van con tu nivel ahora y los que están uno o dos niveles por encima. Desactivado: todos los calabozos.",
	FOV_DUNG_ST_LOW = "Demasiado bajo para ti",
	FOV_TIP_DUNG_ST_FIT = "Tu nivel está dentro del rango de este calabozo.",
	FOV_TIP_DUNG_ST_LOW = "Estás por encima de los niveles de este calabozo: aquí ya queda poca XP.",
	FOV_DUNG_NONE_FMT = "Aún no hay ningún calabozo para el nivel %d. Los primeros empiezan en el nivel %d. Desactiva \"Solo para mi nivel\" para verlos todos.",
	FOV_GROUP_XP_RULE = "En un calabozo, nadie del grupo recibe XP por un enemigo si alguien del grupo está más de 12 niveles por encima de él.",
	-- 18 Nov 2026: search bar, "calabozo" instead of esES "mazmorra".
	FOV_SEARCH_HINT = "Buscar todo: instructor, banco, misión de clase, calabozo, macro…",
	FOV_SEARCH_TIP = "Escribe una palabra: un instructor, una profesión, una tienda, el banco o la posada, una misión de clase, un calabozo, una macro, un ajuste o un comando /mh. Haz clic en una línea o pulsa Intro para ir allí. Empieza con @ para buscar en un solo tipo: @find, @quest, @dungeon, @macro, @setting, @tool, @command.",
	-- 18 Nov 2026: reputation & currency page, rares, scroll hint
	-- Only the lines whose game words esMX shows differently, measured in Forever 1.60.1.70959 esMX (ItemSparse,
	-- ItemSet, AreaTable, CurrencyTypes, SkillLine, SpellName, GlobalStrings: Honorable/Venerado, MAP_LEGEND_RARE
	-- "Rara", MAP_LEGEND_RAREELITE "Raro de élite") and Wowhead Forever tooltips esMX. Not measured, kept English as
	-- in esES: Artisan's Tier, Nightclaw Mantle, Outrunners, "Hail the Dragonslayer", "Brawl at the Maul".
	FOV_TIP_SUB_REP = "Tus monedas (Honor, Puntos de rango, Favor del mercader, Real de Minahonda deslustrado, Vales de la Luna Negra) y los grupos que importan: tu rango, cuánto llevas, la siguiente recompensa y cómo llegar a ella.",
	FREP_NOTE = "Las recompensas y el \"cómo\" vienen de guías de jugadores (noviembre de 2026) y no están comprobados en el juego, salvo la Vaina de semilla estimulante. Los rangos, los puntos y las monedas se leen del juego.",
	FREP_HOW_HYJAL = "5 misiones en Monte Hyjal a nivel 59-60. Aún no se sabe cómo llegar a Venerado.",
	FREP_R_HYJAL_7 = "Vaina de semilla estimulante (nivel 60): lleva 2 piezas de Artisan's Tier en vez de 1",
	FREP_R_BARKSKIN_8 = "Defensor de los piel de corteza",
	FREP_HOW_ARGENT = "Lleva la Comisión de El Alba Argenta, mata no-muertos y entrega piedras de la Plaga (20, 10 o 1 por entrega).",
	FREP_R_ARGENT_5 = "Galletas enriquecidas con maná en el intendente",
	FREP_R_ARGENT_7 = "encantamientos de hombros (con Muestras de valor de El Alba Argenta)",
	FREP_HOW_TIMBERMAW = "Mata furbolgs Muertobosque y Nevada; entrega 5 plumas o 5 cuentas, o 5 cuernos Legashi o 5 faltriqueras Faucenegra.",
	FREP_R_TIMBERMAW_8 = "Defensor de los Fauces de Madera (la mitad del tiempo de reutilización en Forever)",
	FREP_HOW_THORIUM = "Entrega mena de hierro negro, escamas y cuero del Núcleo en La Garganta de Fuego y Profundidades de Roca Negra (nivel 50-60).",
	FREP_HOW_CENARION = "Textos Crepusculares codificados y entregas en Silithus (nivel 55-60).",
	FREP_R_CENARION_5 = "patrones de sastrería y diseños de herrería",
	FREP_HOW_NIGHTCLAW = "Entrega orejas de cultistas en Isla Zephras.",
	FREP_R_NIGHTCLAW_7 = "Ardilla Ventarrosombra (una mascota)",
	FREP_HOW_MERCHANT = "Libranzas del artesano (cada una una vez al día), la misión de la Etiqueta de envío (2000 puntos) y cajas llenas a partir de Amistoso.",
	FREP_R_MERCHANT_5 = "recetas por Favor del mercader",
	FOV_FIND_SEC_RARE = "Criaturas raras",
	FRARE_SUB = "Criaturas raras con un motivo para ir: una mascota, una misión, una receta o buen botín. Solo las que tu bando puede atacar, la más cercana primero. No se marca nada: el juego no nos dice a quién has matado.",
	FRARE_SUB_ZONE = "Cada criatura rara de esta zona que pudimos situar, la más cercana primero, con su nivel. De la mayoría no sabemos qué bando puede atacarlas: a una que sale en verde (amistosa) no la puedes combatir.",
	FRARE_HINT = "Puede que una criatura rara no esté cuando llegues (alguien fue más rápido) - vuelve más tarde. Raro de élite: lleva a un amigo.",
	FRARE_EMPTY = "MH no conoce ninguna criatura rara así para tu bando.",
	FRARE_ARROW_FMT = "flecha de criatura rara puesta en %s (%s, %s).",
	FRARE_WHY_SET = "Una de las tres criaturas raras de Los Baldíos para el conjunto La bendición de Kalimdor (Humar, Velocrín, Takk).",
	FRARE_WHY_MAUL = "Encima de La Marra, en La Masacre: suelta un abalorio de +15 a resistencia que inicia \"Brawl at the Maul\".",
	FRARE_WHY_5797 = "Va con otros tres Outrunners - lleva un grupo. Suelta un Pergamino rúnico que inicia una misión.",
	FRARE_WHY_1844 = "Suelta Diseño: guardia de Escarcha (Herrería 300, Maestro forjador de espadas).",
	FRARE_WHY_2447 = "Puede soltar la Marca del Vuelo Rojo, un abalorio con un escudo de fuego.",
	FRARE_WHY_8206 = "Puede soltar Vientos de Tanaris, un abalorio que ralentiza a los enemigos.",
	FRARE_WHY_10644 = "Suelta el Silbato de lobo: llama a un lobo que te ayuda.",
}) do
	es[k] = v
end
