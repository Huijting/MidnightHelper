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
