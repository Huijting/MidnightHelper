--[[
	Story-varianten per delve -- namen en omschrijvingen.

	GEGENEREERD uit Blizzards eigen DB2-tabel GossipUIDisplayInfoCondition
	(wago.tools, build 12.1.0), niet met de hand overgetypt. Bijwerken door
	tools/_probe.py opnieuw te draaien tegen een verse CSV.

	De DETECTIE staat hier bewust NIET in. Welke variant vandaag draait vraagt
	de addon aan de client (zie DelveBossShowcase); dit bestand levert alleen de
	tekst erbij. Die scheiding is de les van 25 aug 2026: onze handgeschreven
	lijst kende 3 van de 12 varianten die de client die dag aanbood.

	LET OP -- twee dingen die in de ruwe tabel zitten en hier bewust niet:
	  * groep 88 en 89 bevatten een leeg sjabloon met de naam "Name". Zonder
	    filter zou een speler "Story vandaag: Name" te zien krijgen.
	  * Crocolisk Reintroduction staat bij VIER delves met identieke tekst. Het
	    is dus geen delve-eigen variant; de platte naam->tekst tabel hieronder
	    dekt dat vanzelf.
]]

local _, ns = ...

--- Kleine letters, want de client levert de naam in wisselend hoofdlettergebruik.
ns.DELVE_STORY_TIP = {
	["academic antitoxin"] = "DELVE_STORY_ACADEMIC_ANTITOXIN", -- collegiate_calamity
	["academy under siege"] = "DELVE_STORY_ACADEMY_UNDER_SIEGE", -- collegiate_calamity
	["adopt-a-thon"] = "DELVE_STORY_ADOPT_A_THON", -- ring_of_glory
	["alnmoth munchies"] = "DELVE_STORY_ALNMOTH_MUNCHIES", -- gulf_of_memory
	["arena champion"] = "DELVE_STORY_ARENA_CHAMPION", -- grudge_pit
	["basilisk blitz"] = "DELVE_STORY_BASILISK_BLITZ", -- shadowguard_point
	["bombing run"] = "DELVE_STORY_BOMBING_RUN", -- parhelion_plaza
	["captured wildlife"] = "DELVE_STORY_CAPTURED_WILDLIFE", -- shadowguard_point
	["caustic crush"] = "DELVE_STORY_CAUSTIC_CRUSH", -- parhelion_plaza
	["core of the problem"] = "DELVE_STORY_CORE_OF_THE_PROBLEM", -- sunkiller_sanctum
	["crocolisk reintroduction"] = "DELVE_STORY_CROCOLISK_REINTRODUCTION", -- atal_aman, parhelion_plaza, sunkiller_sanctum, twilight_crypts
	["dastardly rotstalk"] = "DELVE_STORY_DASTARDLY_ROTSTALK", -- grudge_pit
	["descent of the haranir"] = "DELVE_STORY_DESCENT_OF_THE_HARANIR", -- gulf_of_memory
	["domination and despair"] = "DELVE_STORY_DOMINATION_AND_DESPAIR", -- torments_rise
	["eggsplosive growth"] = "DELVE_STORY_EGGSPLOSIVE_GROWTH", -- the_darkway
	["faculty of fear"] = "DELVE_STORY_FACULTY_OF_FEAR", -- collegiate_calamity
	["focusers under pressure"] = "DELVE_STORY_FOCUSERS_UNDER_PRESSURE", -- the_darkway
	["fungal pharmacon"] = "DELVE_STORY_FUNGAL_PHARMACON", -- grudge_pit
	["game day"] = "DELVE_STORY_GAME_DAY", -- ring_of_glory
	["holding the line"] = "DELVE_STORY_HOLDING_THE_LINE", -- parhelion_plaza
	["infiltrate and ameliorate"] = "DELVE_STORY_INFILTRATE_AND_AMELIORATE", -- shadow_enclave
	["invasive glow"] = "DELVE_STORY_INVASIVE_GLOW", -- collegiate_calamity
	["leyline technician"] = "DELVE_STORY_LEYLINE_TECHNICIAN", -- the_darkway
	["lightbloom invasion"] = "DELVE_STORY_LIGHTBLOOM_INVASION", -- grudge_pit
	["loosed loa"] = "DELVE_STORY_LOOSED_LOA", -- twilight_crypts
	["march of the arcane brigade"] = "DELVE_STORY_MARCH_OF_THE_ARCANE_BRIGADE", -- parhelion_plaza
	["minchi's osseous adventure"] = "DELVE_STORY_MINCHI_S_OSSEOUS_ADVENTURE", -- gnarldor_isle
	["mirror shine"] = "DELVE_STORY_MIRROR_SHINE", -- shadow_enclave
	["not what i expected"] = "DELVE_STORY_NOT_WHAT_I_EXPECTED", -- sunkiller_sanctum
	["ogre powered"] = "DELVE_STORY_OGRE_POWERED", -- the_darkway
	["olds and ends"] = "DELVE_STORY_OLDS_AND_ENDS", -- gnarldor_isle
	["open night"] = "DELVE_STORY_OPEN_NIGHT", -- ring_of_glory
	["party crasher"] = "DELVE_STORY_PARTY_CRASHER", -- twilight_crypts
	["results: calamitous"] = "DELVE_STORY_RESULTS_CALAMITOUS", -- shadowguard_point
	["ritual interrupted"] = "DELVE_STORY_RITUAL_INTERRUPTED", -- atal_aman
	["shadowy supplies"] = "DELVE_STORY_SHADOWY_SUPPLIES", -- shadow_enclave
	["speaking their language"] = "DELVE_STORY_SPEAKING_THEIR_LANGUAGE", -- gnarldor_isle
	["sporasaur special"] = "DELVE_STORY_SPORASAUR_SPECIAL", -- gulf_of_memory
	["stolen mana"] = "DELVE_STORY_STOLEN_MANA", -- shadowguard_point
	["teleporter tantrums"] = "DELVE_STORY_TELEPORTER_TANTRUMS", -- sunkiller_sanctum
	["the gravitational effect"] = "DELVE_STORY_THE_GRAVITATIONAL_EFFECT", -- sunkiller_sanctum
	["toadly unbecoming"] = "DELVE_STORY_TOADLY_UNBECOMING", -- atal_aman
	["totem annihilation"] = "DELVE_STORY_TOTEM_ANNIHILATION", -- atal_aman
	["traitor's due"] = "DELVE_STORY_TRAITOR_S_DUE", -- shadow_enclave
	["trapped!"] = "DELVE_STORY_TRAPPED", -- twilight_crypts
	["venom's heart"] = "DELVE_STORY_VENOM_S_HEART", -- venomfall_deeps
	["venomous vapors"] = "DELVE_STORY_VENOMOUS_VAPORS", -- atal_aman
	["why'd it have to be snakes?"] = "DELVE_STORY_WHY_D_IT_HAVE_TO_BE_SNAKES", -- twilight_crypts

	-- Namen die de map-tooltip gebruikt en de gossip-tabel niet.
	["an elementary antidote"] = "DELVE_STORY_ACADEMIC_ANTITOXIN", -- = Academic Antitoxin
}

--[[
	26 okt 2026 (Rob: "leef je uit"): de namen hierboven zijn Engels, maar een Duitse of Franse client geeft de
	story-naam in zijn eigen taal. Dan vond DELVE_STORY_TIP niets, en de baaskaart herkende het verhaal niet.
	Daarom dezelfde 48 namen per clienttaal, GEMETEN in dezelfde DB2-tabel (GossipUIDisplayInfoCondition, wago
	12.1.5.70575 met hotfixes = PTR 70493; rapport side-session-notes delve_names_round4_2026-10-26.md, tabel 1c,
	per teken teruggelezen). Volgorde per rij: deDE, frFR, esES, esMX, ptBR, itIT, ruRU.
	"\194\160" = de vaste spatie die de Franse client voor "!" zet.
]]
ns.DELVE_STORY_NAMES_LOCAL = {
	ACADEMIC_ANTITOXIN = { "Akademisches Gegengift", "Antitoxine académique", "Antitoxina académica", "Antitoxina académica", "Antitoxina Acadêmica", "Antitossina accademica", "Академическое противоядие" },
	ACADEMY_UNDER_SIEGE = { "Belagerte Akademie", "Académie assiégée", "Academia asediada", "Asedio a la academia", "Academia sob cerco", "L'Assedio dell'Accademia", "Академия в осаде" },
	ADOPT_A_THON = { "Adoptionsmarathon", "Adoptathon", "¡No compres, adopta!", "Maratón de adopciones", "Adotatona", "Adottathon", "Ваш питомец у нас" },
	ALNMOTH_MUNCHIES = { "Heißhunger der Alnmotten", "Alnidés affamés", "Bocaditos para polillas de Aln", "Delicias para polillas de Aln", "Larica de Mariposa-de-aln", "Delizie per Falenaln", "Закуска для мотыльков Альн" },
	ARENA_CHAMPION = { "Arenachampion", "Championnat d’arène", "Campeón de la arena", "Campeón de la arena", "Campeão da Arena", "Campione dell'Arena", "Чемпион арены" },
	BASILISK_BLITZ = { "Basiliskblitz", "Bombardement de basilics", "Bombardeo basilístico", "Ataque de basilisco", "Debandada dos Basiliscos", "Blitz del Basilisco", "Василиск-блиц" },
	BOMBING_RUN = { "Bomberangriff", "Mission de bombardement", "Bombardeo", "Bombardeo", "Passagem de bombardeio", "Bombardamento a Tappeto", "Заход на цель" },
	CAPTURED_WILDLIFE = { "Gefangene Tiere", "Faune capturée", "Fauna cautiva", "Fauna capturada", "Fauna Capturada", "Fauna Catturata", "Пойманные звери" },
	CAUSTIC_CRUSH = { "Ätzendes Zerschmettern", "Écrasement caustique", "Choque cáustico", "Aplastamiento cáustico", "Esmagamento Cáustico", "Schiacciamento Caustico", "Гниль и разрушение" },
	CORE_OF_THE_PROBLEM = { "Der Kern des Problems", "Le cœur du problème", "El núcleo del problema", "El núcleo del problema", "Núcleo do problema", "Il nucleo del problema", "Сердечник проблемы" },
	CROCOLISK_REINTRODUCTION = { "Krokiliskenauswilderung", "Réintroduction des crocilisques", "Reintroducción del crocolisco", "Reintroducción de crocoliscos", "Reintrodução de Crocoliscos", "Reinserimento dei crocolischi", "Возвращение кроколисков",
		"Krokoliskenauswilderung" }, -- de spelt it both ways (rows 112 and 83/96)
	DASTARDLY_ROTSTALK = { "Durchtriebener Faulstrunk", "Stipe-putride", "Acecho putrefacto despiadado", "Vil Tallodumbre", "Putricaule da Discórdia", "Micostelo Ignobile", "Гнусная Гнилоножка" },
	DESCENT_OF_THE_HARANIR = { "Abstieg der Haranir", "Descente des Haranir", "Descenso de los haranir", "Descenso de los haranir", "Descenso dos Haranir", "Discesa degli Haranir", "В глубины за харанирами" },
	DOMINATION_AND_DESPAIR = { "Herrschaft und Hoffnungslosigkeit", "Domination et désespoir", "Dominación y desesperación", "Dominación y desesperación", "Dominação e desespero", "Dominio e disperazione", "Покровительство и отчаяние" },
	EGGSPLOSIVE_GROWTH = { "Eggsplosives Wachstum", "Croissance œuphorique", "Crecimiento ovoexplosivo", "Eclosión explosiva", "Crescimento explosovo", "Crescita esplosuova", "Змеиный омлет" },
	FACULTY_OF_FEAR = { "Fakultät der Furcht", "Aptitude à la peur", "Facultad del miedo", "Profesorado falsificado", "Faculdade do medo", "Facoltà della Paura", "Факультет страха" },
	FOCUSERS_UNDER_PRESSURE = { "Fokussierer unter Druck", "Focalisateurs sous pression", "Concentradores bajo presión", "Enfocadores bajo presión", "Focalizadores sob pressão", "Concentrazione Sotto Pressione", "Фокусировщики на пределе" },
	FUNGAL_PHARMACON = { "Pilzgebräu", "Pharmakon fongique", "Fármaco fúngico", "Fármaco fúngico", "Fármaco Fúngico", "Farmacon Fungino", "Грибное лекарство" },
	GAME_DAY = { "Spieltag", "Sur un coup de tête", "Día de juegos", "Día de partido", "Dia de Jogo", "Il grande giorno", "Ключевой матч" },
	HOLDING_THE_LINE = { "Die Stellung halten", "Tenir le front", "Ni un paso atrás", "Última defensa", "A defesa da linha", "Tenere la Posizione", "Держать строй" },
	INFILTRATE_AND_AMELIORATE = { "Infiltrieren und ameliorieren", "Infiltration et amélioration", "Infiltración y recuperación", "Infiltrar y aliviar", "Infiltrar e Aprimorar", "Infiltramento e miglioramento", "Проникнуть и обезвредить" },
	INVASIVE_GLOW = { "Invasives Leuchten", "Luminescence envahissante", "Resplandor invasivo", "Destello invasor", "Brilho invasor", "Bagliore Invasivo", "Проникающее сияние" },
	LEYLINE_TECHNICIAN = { "Leylinientechniker", "Spécialiste de lignes telluriques", "Técnico de líneas Ley", "Tecnicatura en líneas ley", "Manutenção de Meridianos", "Tecnico della Linea di Faglia", "Техник силовых линий" },
	LIGHTBLOOM_INVASION = { "Lichtblüteninvasion", "Invasion du luméclat", "Invasión de la flor de Luz", "Invasión de floraluz", "Invasão de Floraluz", "Invasione della Fioritura di Luce", "Светоцветное нашествие" },
	LOOSED_LOA = { "Gelöste Loa", "Loa libre", "Loa a la fuga", "Loa liberado", "Loa solto", "Loa Scatenato", "Освобожденные лоа" },
	MARCH_OF_THE_ARCANE_BRIGADE = { "Marsch der arkanen Brigade", "La marche de la brigade des arcanes", "La marcha de la brigada Arcana", "Marcha de la Brigada Arcana", "Marcha da Brigada Arcana", "Marcia della Brigata Arcana", "Марш чародейской дружины" },
	MINCHI_S_OSSEOUS_ADVENTURE = { "Minchis Knochenabenteuer", "L’aventure osseuse de Minchi", "La aventura ósea de Minchi", "La aventura ósea de Minchi", "A Ossosseia de Minchi", "Avventura ossea di Minzhi", "Костяное приключение Минчи" },
	MIRROR_SHINE = { "Spiegelglanz", "Luisance de miroir", "Brillo de espejo", "Brillo espejado", "Luzir de Espelho", "Splendore dello Specchio", "Зеркальный блеск" },
	NOT_WHAT_I_EXPECTED = { "Nicht, was ich erwartet hatte", "Ce n’est pas ce à quoi je m’attendais", "No es lo que esperaba", "No era lo que esperaba", "Nada do que eu esperava", "Non come mi aspettavo", "Неожиданные последствия" },
	OGRE_POWERED = { "Ogerbetrieben", "Puissance ogre", "Energía de ogro", "Potenciamiento ogro", "Potência Ôgrica", "Potenza da Ogre", "Огр-мотор" },
	OLDS_AND_ENDS = { "Alterlei Kleinkram", "Antiquités et fins", "Lo que viene de atrás", "Antigüedades varias", "Antigos e Perdidos", "Resti vecchi", "Древности и ценности" },
	OPEN_NIGHT = { "Nacht der offenen Tür", "Arène ouverte", "Noche abierta", "Noche abierta", "Noite Aberta", "Serata aperta", "Ночь открытых дверей" },
	PARTY_CRASHER = { "Ungeladene Gäste", "Trouble-fête", "Aguafiestas", "Aguafiestas", "Penetras na festa", "Guastafeste", "Незваный гость" },
	RESULTS_CALAMITOUS = { "Resultat: Katastrophal", "Résultats catastrophiques", "Resultados calamitosos", "Resultados: Calamitosos", "Resultados: Calamitosos", "Risultati: Funesti", "Опасность: критическая" },
	RITUAL_INTERRUPTED = { "Ritual unterbrochen", "Rituel interrompu", "Ritual interrumpido", "Ritual interrumpido", "Ritual interrompido", "Rituale interrotto", "Прерванный ритуал" },
	SHADOWY_SUPPLIES = { "Schattenhafte Vorräte", "Fournitures mystérieuses", "Suministros sombríos", "Suministros sombríos", "Suprimentos Sombrios", "Scorte Tenebrose", "Сумеречные склады" },
	SPEAKING_THEIR_LANGUAGE = { "Ihre Sprache sprechen", "La langue des leurs", "Hablar su idioma", "Hablar su idioma", "Falando a Língua Deles", "Parlare la loro lingua", "На понятном языке" },
	SPORASAUR_SPECIAL = { "Sporasaurus Spezial", "Opération sporosaure", "Especial de esporasaurio", "Especial de esporasaurio", "Especial de Esporossauro", "Specialità da Sporasauri", "Спасение от спорозавров" },
	STOLEN_MANA = { "Gestohlenes Mana", "Mana volé", "Maná robado", "Maná robado", "Mana Roubado", "Mana Rubato", "Украденная мана" },
	TELEPORTER_TANTRUMS = { "Teleportertrauma", "Tests de téléportation", "Teletransportadores traviesos", "Traspiés de teletransportación", "Teleportadores descontrolados", "Teletrasporto turbolento", "Темпераментные телепорты" },
	THE_GRAVITATIONAL_EFFECT = { "Der Gravitationseffekt", "L’effet gravitationnel", "El efecto gravitatorio", "El efecto gravitacional", "O efeito gravitacional", "Effetto Gravitazionale", "Гравитационный эффект" },
	TOADLY_UNBECOMING = { "Krötal unwürdig", "Métamorphose indigne", "Sapos impropios", "Deshacer de los sapos", "Sapolutamente indecente", "Rospamente Sconveniente", "С жабами поведешься" },
	TOTEM_ANNIHILATION = { "Totemvernichtung", "Annihilation de totem", "Aniquilación de tótems", "Aniquilación de tótems", "Aniquilação de totem", "Annientamento dei Totem", "Аннигиляция тотемов" },
	TRAITOR_S_DUE = { "Die Schuld eines Verräters", "La rançon de la trahison", "Recompensa de una traición", "Castigo merecido", "Fim dos Traidores", "Prezzo del Traditore", "Месть предателю" },
	TRAPPED = { "Gefangen!", "Victimes d’un piège\194\160!", "¡Atrapado!", "¡Atrapados!", "Preso!", "In Trappola!", "В ловушке!" },
	VENOMOUS_VAPORS = { "Giftige Dämpfe", "Vapeurs venimeuses", "Vapores venenosos", "Vapores venenosos", "Vapores Peçonhentos", "Vapori Velenosi", "Ядовитые испарения" },
	VENOM_S_HEART = { "Herz des Giftes", "Cœur du venin", "Corazón venenoso", "Corazón del veneno", "Coração da peçonha", "Veleno fermacuori", "Ядовитое сердце" },
	WHY_D_IT_HAVE_TO_BE_SNAKES = { "Warum ausgerechnet Schlangen?", "Fallait que ce soit des serpents\194\160!", "¿Por qué serpientes?", "¿Por qué tenían que ser serpientes?", "Por que Tinha que Ser Cobras?", "Ma perché proprio i serpenti?", "Только не змеи!" },
}

--- Kleine letters zoals de aanroepers ze maken (WoW's lower() raakt alleen A-Z; zelfde bewerking = zelfde sleutel).
local function StoryLow(name)
	return (name:lower():gsub("^%s+", ""):gsub("%s+$", ""))
end

-- Sleutel → Engelse naam (kleine letters). De gossip-naam wint van de tooltip-naam ("an elementary antidote").
ns.DELVE_STORY_EN = {}
for en, key in pairs(ns.DELVE_STORY_TIP) do
	if en ~= "an elementary antidote" then
		ns.DELVE_STORY_EN[key] = en
	end
end
-- Elke clientnaam → dezelfde sleutel, zodat DELVE_STORY_TIP[naam:lower()] in elke taal werkt.
ns.DELVE_STORY_LOCAL_BY_KEY = {}
for suffix, names in pairs(ns.DELVE_STORY_NAMES_LOCAL) do
	local key = "DELVE_STORY_" .. suffix
	ns.DELVE_STORY_LOCAL_BY_KEY[key] = names
	for _, n in ipairs(names) do
		local low = StoryLow(n)
		if ns.DELVE_STORY_TIP[low] == nil then
			ns.DELVE_STORY_TIP[low] = key
		end
	end
end

--- De Engelse naam (kleine letters) van een story die de client in welke taal dan ook gaf; nil als onbekend.
function ns.DelveStoryEnglishName(name)
	if type(name) ~= "string" then
		return nil
	end
	local ok, low = pcall(StoryLow, name)
	local key = ok and ns.DELVE_STORY_TIP[low]
	return key and ns.DELVE_STORY_EN[key] or nil
end

--- Alle clientnamen van een story, gezocht op de Engelse naam (bv. "ritual interrupted"); nil als onbekend.
function ns.DelveStoryLocalNames(englishName)
	if type(englishName) ~= "string" then
		return nil
	end
	local key = ns.DELVE_STORY_TIP[StoryLow(englishName)]
	return key and ns.DELVE_STORY_LOCAL_BY_KEY[key] or nil
end
