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
	-- 17 Nov 2026: the overview (/mh overview, ForeverOverview.lua): FOV_*, FDUNG_IN_ENEMY_FMT, SET_FOVSTYLE_*
	-- LEGACY_BUTTON is "Legado" on esMX ("Banda antigua" on esES; LEGACY_VERIFIED ch. 10). Camping (1308027) is
	-- "Campamento" on esMX ("Acampando" on esES); tab and camp words as in ForeverHowToPlay_esMX.lua ("Campamento",
	-- "elemento de campamento").
	FOV_TAB_CAMP = "Campamento",
	FOV_TIP_TAB_CAMP = "Campamento: lo que MH puede leer ahora de tus buffs de campamento, y cómo funciona el campamento.",
	FOV_LABEL_CAMP_HOW = "CÓMO FUNCIONA EL CAMPAMENTO",
	FOV_TIP_CAMP_BENEFITS = "El buff de campamento: 1 hora, una línea por cada elemento de campamento junto a la hoguera.",
	FOV_TIP_CAMP_COOLDOWN = "Todos los elementos de campamento comparten una espera de 1 hora.",
	FOV_TIP_LEG_AVAIL = "Puntos que este personaje aún puede gastar. Pulsa el botón Legado en la barra de menú.",
}) do
	es[k] = v
end
