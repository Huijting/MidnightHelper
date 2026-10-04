--[[
	Consumables category notes (CONS_NOTE_*) — merged into locale packs at load.
]]

local _, ns = ...

ns._mhLocales = ns._mhLocales or {}

local function merge(into, keys)
	if type(into) ~= "table" or type(keys) ~= "table" then
		return
	end
	for k, v in pairs(keys) do
		into[k] = v
	end
end

local EN = {
	CONS_NOTE_01 = "The listed flask is the guide default for this spec. The four secondary-stat flasks are close, so sim your character if your stats differ.",
	CONS_NOTE_02 = "Current Midnight augment rune.",
	CONS_NOTE_03 = "Haste is the default healer throughput flask; sim your character for close secondary stats.",
	CONS_NOTE_04 = "Season 2's Concentrated Silvermoon Health Potion. The older Silvermoon Health Potion still counts — brewing the new one consumes 25 of it.",
	CONS_NOTE_05 = "The listed flask is the guide default for this spec. The four secondary-stat flasks are close, so sim your character if your stats differ.",
	CONS_NOTE_06 = "Primary-stat feast is the safe group default for Intellect specs.",
	CONS_NOTE_07 = "Primary-stat feast is the safe group default.",
	CONS_NOTE_08 = "Primary-stat personal food is the safe default when no feast is available.",
	CONS_NOTE_09 = "Secondary-stat feast is a strong tank choice; primary-stat feast is a safe alternative.",
	CONS_NOTE_10 = "Use Thalassian Phoenix Oil unless Flametongue Weapon is preferred by your current build.",
	CONS_NOTE_11 = "Enhancement can't use weapon oils: Windfury and Flametongue Weapon overwrite them. Save your gold.",
	CONS_NOTE_12 = "Use as the default temporary weapon buff unless your class/spec-specific weapon imbue overrides it.",
	CONS_NOTE_13 = "Use the listed flask as the default tank choice; swap to Versatility when you want a safer defensive fallback.",
	CONS_NOTE_14 = "Use the listed potion as the default burst/throughput choice for PvE.",
	CONS_NOTE_15 = "Use this as the default tank potion when you want throughput with manageable risk.",
	CONS_NOTE_16 = "Two flasks, and the guide gives an axis rather than a winner — which is better depends on your hero talent, your content, or which secondary you are short of. Check a class guide before committing gold.",
}

local NL = {
	CONS_NOTE_01 = "De genoemde flacon is de gidskeuze voor deze spec. De vier secondary-stat-flacons liggen dicht bij elkaar, dus sim je character als je stats afwijken.",
	CONS_NOTE_02 = "Huidige Midnight augment rune.",
	CONS_NOTE_03 = "Haste is de standaard healer-flacon; sim je character voor secundaire stats.",
	CONS_NOTE_04 = "De Concentrated Silvermoon Health Potion van Season 2. De oude Silvermoon Health Potion telt ook nog — het recept verbruikt er 25 van.",
	CONS_NOTE_05 = "De genoemde flacon is de gidskeuze voor deze spec. De vier secondary-stat-flacons liggen dicht bij elkaar, dus sim je character als je stats afwijken.",
	CONS_NOTE_06 = "Primary-stat feast is de veilige groepsdefault voor Intellect-specs.",
	CONS_NOTE_07 = "Primary-stat feast is de veilige groepsdefault.",
	CONS_NOTE_08 = "Personal food met primary stat als er geen feast is.",
	CONS_NOTE_09 = "Secondary-stat feast is sterk voor tanks; primary-stat feast is een veilig alternatief.",
	CONS_NOTE_10 = "Gebruik Thalassian Phoenix Oil tenzij Flametongue Weapon beter past bij je build.",
	CONS_NOTE_11 = "Enhancement kan geen weapon oil gebruiken: Windfury en Flametongue Weapon overschrijven hem. Bespaar je goud.",
	CONS_NOTE_12 = "Standaard tijdelijke weapon buff, tenzij je class/spec een andere imbue gebruikt.",
	CONS_NOTE_13 = "Gebruik de genoemde tank-flacon; wissel naar Versatility voor meer defensief.",
	CONS_NOTE_14 = "Gebruik de genoemde potion als burst/throughput-keuze voor PvE.",
	CONS_NOTE_15 = "Standaard tank-potion met throughput en beperkt risico.",
	CONS_NOTE_16 = "Twee flasks, en de gids geeft een afweging in plaats van een winnaar — welke beter is hangt af van je hero-talent, je content, of welke secondary je tekortkomt. Kijk in een class-guide voor je goud uitgeeft.",
}

local DE = {
	CONS_NOTE_01 = "Die genannte Flasche ist die Standardwahl des Guides für diese Spec. Die vier Sekundärwert-Flaschen liegen nah beieinander, also simuliere deinen Charakter, wenn deine Werte abweichen.",
	CONS_NOTE_02 = "Aktuelle Midnight-Augmentierungsrune.",
	CONS_NOTE_03 = "Tempo ist die Standard-Heiler-Flasche; simuliere deinen Charakter für Sekundärwerte.",
	CONS_NOTE_04 = "Der Concentrated Silvermoon Health Potion aus Season 2. Der alte Silvermoon Health Potion zählt weiterhin — das Rezept verbraucht 25 davon.",
	CONS_NOTE_05 = "Die genannte Flasche ist die Standardwahl des Guides für diese Spec. Die vier Sekundärwert-Flaschen liegen nah beieinander, also simuliere deinen Charakter, wenn deine Werte abweichen.",
	CONS_NOTE_06 = "Festmahl mit Hauptstat ist die sichere Gruppenwahl für Intelligenz-Specs.",
	CONS_NOTE_07 = "Festmahl mit Hauptstat ist die sichere Gruppenwahl.",
	CONS_NOTE_08 = "Persönliches Essen mit Hauptstat, wenn kein Festmahl verfügbar ist.",
	CONS_NOTE_09 = "Festmahl mit Sekundärstat ist stark für Tanks; Hauptstat-Festmahl ist eine sichere Alternative.",
	CONS_NOTE_10 = "Thalassian Phoenix Oil, außer Flametongue Weapon passt besser zu deinem Build.",
	CONS_NOTE_11 = "Verstärkung kann keine Waffenöle nutzen: Windfury und Flametongue Weapon überschreiben sie. Spar dir das Gold.",
	CONS_NOTE_12 = "Standard-Waffenbuff, außer deine Spec nutzt eine andere Waffenimbue.",
	CONS_NOTE_13 = "Nutze die genannte Tank-Flasche; wechsle zu Vielseitigkeit für mehr Defensive.",
	CONS_NOTE_14 = "Genannter Trank als Burst/Throughput-Wahl für PvE.",
	CONS_NOTE_15 = "Standard-Tanktrank mit Throughput und überschaubarem Risiko.",
	CONS_NOTE_16 = "Zwei Flasks, und der Guide nennt eine Abwägung statt eines Siegers — welcher besser ist, hängt von deinem Heldentalent, deinem Content oder der fehlenden Sekundärwertung ab. Schau in einen Klassenguide, bevor du Gold ausgibst.",
}

-- FR was merged below but never defined (vertaler-vondst 3 Oct 2026), so French players saw every
-- CONS_NOTE in English. Added 4 Oct 2026 — our own translation, same shape as DE (item and spell
-- names stay English, "tu" like the other French strings); not checked by a native speaker.
local FR = {
	CONS_NOTE_01 = "Le flacon indiqué est le choix par défaut du guide pour cette spé. Les quatre flacons de caractéristique secondaire sont proches : simule ton personnage si tes stats diffèrent.",
	CONS_NOTE_02 = "Rune d'augmentation actuelle de Midnight.",
	CONS_NOTE_03 = "La Hâte est le flacon de soigneur par défaut ; simule ton personnage si tes stats secondaires sont proches.",
	CONS_NOTE_04 = "La Concentrated Silvermoon Health Potion de la Saison 2. L'ancienne Silvermoon Health Potion compte toujours — la recette en consomme 25.",
	CONS_NOTE_05 = "Le flacon indiqué est le choix par défaut du guide pour cette spé. Les quatre flacons de caractéristique secondaire sont proches : simule ton personnage si tes stats diffèrent.",
	CONS_NOTE_06 = "Le festin à caractéristique principale est le choix de groupe sûr pour les spés Intelligence.",
	CONS_NOTE_07 = "Le festin à caractéristique principale est le choix de groupe sûr.",
	CONS_NOTE_08 = "Nourriture personnelle à caractéristique principale quand il n'y a pas de festin.",
	CONS_NOTE_09 = "Le festin à caractéristique secondaire est un bon choix pour les tanks ; le festin à caractéristique principale reste une alternative sûre.",
	CONS_NOTE_10 = "Utilise Thalassian Phoenix Oil, sauf si Flametongue Weapon convient mieux à ton build.",
	CONS_NOTE_11 = "Amélioration ne peut pas utiliser d'huiles d'arme : Windfury et Flametongue Weapon les remplacent. Garde ton or.",
	CONS_NOTE_12 = "Bonus d'arme temporaire par défaut, sauf si ta classe ou ta spé utilise son propre enchantement d'arme.",
	CONS_NOTE_13 = "Utilise le flacon de tank indiqué ; passe à Polyvalence pour plus de sécurité défensive.",
	CONS_NOTE_14 = "Utilise la potion indiquée comme choix de burst/dégâts par défaut en JcE.",
	CONS_NOTE_15 = "Potion de tank par défaut, avec des dégâts et un risque maîtrisé.",
	CONS_NOTE_16 = "Deux flacons, et le guide donne un critère plutôt qu'un gagnant — le meilleur dépend de ton talent de héros, de ton contenu ou de la caractéristique secondaire qui te manque. Consulte un guide de classe avant de dépenser ton or.",
}

local ES = {
	CONS_NOTE_01 = "El frasco indicado es la opción por defecto de la guía para esta especialización. Los cuatro frascos de stat secundaria están muy parejos, así que simula tu personaje si tus stats son distintas.",
	CONS_NOTE_02 = "Runa de aumento Midnight actual.",
	CONS_NOTE_03 = "Celeridad es el frasco de sanador por defecto; simula tu personaje para stats secundarias.",
	CONS_NOTE_04 = "La Concentrated Silvermoon Health Potion de la Season 2. La antigua Silvermoon Health Potion sigue contando — la receta consume 25.",
	CONS_NOTE_05 = "El frasco indicado es la opción por defecto de la guía para esta especialización. Los cuatro frascos de stat secundaria están muy parejos, así que simula tu personaje si tus stats son distintas.",
	CONS_NOTE_06 = "Festín de stat principal: opción segura de grupo para specs de Intelecto.",
	CONS_NOTE_07 = "Festín de stat principal: opción segura de grupo.",
	CONS_NOTE_08 = "Comida personal con stat principal si no hay festín.",
	CONS_NOTE_09 = "Festín de stat secundaria fuerte para tanques; festín principal como alternativa segura.",
	CONS_NOTE_10 = "Aceite de fénix thalassiano salvo que Lengua de fuego encaje mejor en tu build.",
	CONS_NOTE_11 = "Mejora no puede usar aceites de arma: Furia del viento y Lengua de fuego los sobrescriben. Ahórrate el oro.",
	CONS_NOTE_12 = "Buff temporal de arma por defecto salvo imbue específica de tu clase/spec.",
	CONS_NOTE_13 = "Frasco tank listado; cambia a Versatilidad para más defensivo.",
	CONS_NOTE_14 = "Poción listada como burst/throughput en PvE.",
	CONS_NOTE_15 = "Poción tank por defecto con throughput y riesgo controlado.",
	CONS_NOTE_16 = "Dos flasks, y la guía da un criterio en vez de un ganador — cuál es mejor depende de tu talento de héroe, tu contenido o la secundaria que te falte. Consulta una guía de clase antes de gastar oro.",
}

local PT = {
	CONS_NOTE_01 = "O frasco listado é a escolha padrão do guia para esta spec. Os quatro frascos de atributo secundário ficam bem próximos, então simule seu personagem se seus atributos forem diferentes.",
	CONS_NOTE_02 = "Runa de augmento Midnight atual.",
	CONS_NOTE_03 = "Aceleração é o frasco de curador padrão; simule para atributos secundários.",
	CONS_NOTE_04 = "A Concentrated Silvermoon Health Potion da Season 2. A antiga Silvermoon Health Potion ainda conta — a receita consome 25 delas.",
	CONS_NOTE_05 = "O frasco listado é a escolha padrão do guia para esta spec. Os quatro frascos de atributo secundário ficam bem próximos, então simule seu personagem se seus atributos forem diferentes.",
	CONS_NOTE_06 = "Banquete de atributo principal: opção segura de grupo para specs de Intelecto.",
	CONS_NOTE_07 = "Banquete de atributo principal: opção segura de grupo.",
	CONS_NOTE_08 = "Comida pessoal com atributo principal se não houver banquete.",
	CONS_NOTE_09 = "Banquete de atributo secundário forte para tanks; principal como alternativa segura.",
	CONS_NOTE_10 = "Óleo de fênix thalassiano salvo se Língua de Fogo encaixar melhor na build.",
	CONS_NOTE_11 = "Aperfeiçoamento não pode usar óleos de arma: Fúria dos Ventos e Língua de Fogo os sobrescrevem. Economize seu ouro.",
	CONS_NOTE_12 = "Buff temporário de arma padrão salvo imbue específica da classe/spec.",
	CONS_NOTE_13 = "Frasco tank listado; troque para Versatilidade para mais defensivo.",
	CONS_NOTE_14 = "Poção listada como burst/throughput em PvE.",
	CONS_NOTE_15 = "Poção tank padrão com throughput e risco controlado.",
	CONS_NOTE_16 = "Dois flasks, e o guia dá um critério em vez de um vencedor — qual é melhor depende do teu talento de herói, do teu conteúdo ou da secundária que te falta. Vê um guia de classe antes de gastar ouro.",
}

local IT = {
	CONS_NOTE_01 = "La fiala indicata è la scelta predefinita della guida per questa spec. Le quattro fiale con caratteristica secondaria sono molto vicine, quindi simula il tuo personaggio se le tue stat sono diverse.",
	CONS_NOTE_02 = "Runa di aumento attuale di Midnight.",
	CONS_NOTE_03 = "Celerità è la fiala di throughput predefinita per i guaritori; simula il tuo personaggio per le secondarie più vicine.",
	CONS_NOTE_04 = "La Concentrated Silvermoon Health Potion della Season 2. La vecchia Silvermoon Health Potion conta ancora — la ricetta ne consuma 25.",
	CONS_NOTE_05 = "La fiala indicata è la scelta predefinita della guida per questa spec. Le quattro fiale con caratteristica secondaria sono molto vicine, quindi simula il tuo personaggio se le tue stat sono diverse.",
	CONS_NOTE_06 = "Il banchetto con caratteristica primaria è la scelta di gruppo sicura per le spec con Intelletto.",
	CONS_NOTE_07 = "Il banchetto con caratteristica primaria è la scelta di gruppo sicura.",
	CONS_NOTE_08 = "Il cibo personale con caratteristica primaria è la scelta sicura quando non c'è un banchetto.",
	CONS_NOTE_09 = "Il banchetto con caratteristica secondaria è un'ottima scelta per i tank; quello con primaria è un'alternativa sicura.",
	CONS_NOTE_10 = "Usa Thalassian Phoenix Oil a meno che la tua build attuale non preferisca Flametongue Weapon.",
	CONS_NOTE_11 = "Potenziamento non può usare oli per armi: Windfury e Flametongue Weapon li sovrascrivono. Risparmia l'oro.",
	CONS_NOTE_12 = "Usa come buff temporaneo all'arma predefinito, a meno che l'imbue specifico della tua classe/spec non lo sostituisca.",
	CONS_NOTE_13 = "Usa la fiala indicata come scelta tank predefinita; passa a Versatilità quando vuoi un ripiego difensivo più sicuro.",
	CONS_NOTE_14 = "Usa la pozione indicata come scelta di burst/throughput predefinita per il PvE.",
	CONS_NOTE_15 = "Usala come pozione tank predefinita quando vuoi throughput con un rischio gestibile.",
	CONS_NOTE_16 = "Due flask, e la guida dà un criterio invece di un vincitore — quale sia meglio dipende dal tuo talento eroe, dal tuo contenuto o dalla secondaria che ti manca. Consulta una guida di classe prima di spendere oro.",
}

merge(ns._mhLocales.enUS or {}, EN)
merge(ns._mhLocales.nlNL or {}, NL)
merge(ns._mhLocales.deDE or {}, DE)
merge(ns._mhLocales.frFR or {}, FR)
merge(ns._mhLocales.esES or {}, ES)
merge(ns._mhLocales.ptBR or {}, PT)
merge(ns._mhLocales.itIT or {}, IT)
