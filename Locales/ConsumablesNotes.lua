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
	CONS_NOTE_01 = "Critical Strike is the default throughput flask; sim your character for close secondary stats.",
	CONS_NOTE_02 = "Current Midnight augment rune.",
	CONS_NOTE_03 = "Haste is the default healer throughput flask; sim your character for close secondary stats.",
	CONS_NOTE_04 = "Season 2's Concentrated Silvermoon Health Potion. The older Silvermoon Health Potion still counts — brewing the new one consumes 25 of it.",
	CONS_NOTE_05 = "Mastery is the default throughput flask; sim your character for close secondary stats.",
	CONS_NOTE_06 = "Primary-stat feast is the safe group default for Intellect specs.",
	CONS_NOTE_07 = "Primary-stat feast is the safe group default.",
	CONS_NOTE_08 = "Primary-stat personal food is the safe default when no feast is available.",
	CONS_NOTE_09 = "Secondary-stat feast is a strong tank choice; primary-stat feast is a safe alternative.",
	CONS_NOTE_10 = "Use Thalassian Phoenix Oil unless Flametongue Weapon is preferred by your current build.",
	CONS_NOTE_11 = "Use Thalassian Phoenix Oil unless Windfury/Flametongue weapon imbues are required by your build.",
	CONS_NOTE_12 = "Use as the default temporary weapon buff unless your class/spec-specific weapon imbue overrides it.",
	CONS_NOTE_13 = "Use the listed flask as the default tank choice; swap to Versatility when you want a safer defensive fallback.",
	CONS_NOTE_14 = "Use the listed potion as the default burst/throughput choice for PvE.",
	CONS_NOTE_15 = "Use this as the default tank potion when you want throughput with manageable risk.",
}

local NL = {
	CONS_NOTE_01 = "Critical Strike is de standaard DPS-flacon; sim je character voor de beste secundaire stats.",
	CONS_NOTE_02 = "Huidige Midnight augment rune.",
	CONS_NOTE_03 = "Haste is de standaard healer-flacon; sim je character voor secundaire stats.",
	CONS_NOTE_04 = "De Concentrated Silvermoon Health Potion van Season 2. De oude Silvermoon Health Potion telt ook nog — het recept verbruikt er 25 van.",
	CONS_NOTE_05 = "Mastery is de standaard DPS-flacon; sim je character voor secundaire stats.",
	CONS_NOTE_06 = "Primary-stat feast is de veilige groepsdefault voor Intellect-specs.",
	CONS_NOTE_07 = "Primary-stat feast is de veilige groepsdefault.",
	CONS_NOTE_08 = "Personal food met primary stat als er geen feast is.",
	CONS_NOTE_09 = "Secondary-stat feast is sterk voor tanks; primary-stat feast is een veilig alternatief.",
	CONS_NOTE_10 = "Gebruik Thalassian Phoenix Oil tenzij Flametongue Weapon beter past bij je build.",
	CONS_NOTE_11 = "Gebruik Thalassian Phoenix Oil tenzij Windfury/Flametongue vereist is voor je build.",
	CONS_NOTE_12 = "Standaard tijdelijke weapon buff, tenzij je class/spec een andere imbue gebruikt.",
	CONS_NOTE_13 = "Gebruik de genoemde tank-flacon; wissel naar Versatility voor meer defensief.",
	CONS_NOTE_14 = "Gebruik de genoemde potion als burst/throughput-keuze voor PvE.",
	CONS_NOTE_15 = "Standaard tank-potion met throughput en beperkt risico.",
}

local DE = {
	CONS_NOTE_01 = "Kritischer Trefferwert ist die Standard-DPS-Flasche; simuliere deinen Charakter für die besten Sekundärwerte.",
	CONS_NOTE_02 = "Aktuelle Midnight-Augmentierungsrune.",
	CONS_NOTE_03 = "Tempo ist die Standard-Heiler-Flasche; simuliere deinen Charakter für Sekundärwerte.",
	CONS_NOTE_04 = "Der Concentrated Silvermoon Health Potion aus Season 2. Der alte Silvermoon Health Potion zählt weiterhin — das Rezept verbraucht 25 davon.",
	CONS_NOTE_05 = "Meisterschaft ist die Standard-DPS-Flasche; simuliere deinen Charakter für Sekundärwerte.",
	CONS_NOTE_06 = "Festmahl mit Hauptstat ist die sichere Gruppenwahl für Intelligenz-Specs.",
	CONS_NOTE_07 = "Festmahl mit Hauptstat ist die sichere Gruppenwahl.",
	CONS_NOTE_08 = "Persönliches Essen mit Hauptstat, wenn kein Festmahl verfügbar ist.",
	CONS_NOTE_09 = "Festmahl mit Sekundärstat ist stark für Tanks; Hauptstat-Festmahl ist eine sichere Alternative.",
	CONS_NOTE_10 = "Thalassian Phoenix Oil, außer Flametongue Weapon passt besser zu deinem Build.",
	CONS_NOTE_11 = "Thalassian Phoenix Oil, außer Windfury/Flametongue sind für deinen Build nötig.",
	CONS_NOTE_12 = "Standard-Waffenbuff, außer deine Spec nutzt eine andere Waffenimbue.",
	CONS_NOTE_13 = "Nutze die genannte Tank-Flasche; wechsle zu Vielseitigkeit für mehr Defensive.",
	CONS_NOTE_14 = "Genannter Trank als Burst/Throughput-Wahl für PvE.",
	CONS_NOTE_15 = "Standard-Tanktrank mit Throughput und überschaubarem Risiko.",
}

local ES = {
	CONS_NOTE_01 = "Golpe crítico es el frasco DPS por defecto; simula tu personaje para stats secundarias.",
	CONS_NOTE_02 = "Runa de aumento Midnight actual.",
	CONS_NOTE_03 = "Celeridad es el frasco de sanador por defecto; simula tu personaje para stats secundarias.",
	CONS_NOTE_04 = "La Concentrated Silvermoon Health Potion de la Season 2. La antigua Silvermoon Health Potion sigue contando — la receta consume 25.",
	CONS_NOTE_05 = "Maestría es el frasco DPS por defecto; simula tu personaje para stats secundarias.",
	CONS_NOTE_06 = "Festín de stat principal: opción segura de grupo para specs de Intelecto.",
	CONS_NOTE_07 = "Festín de stat principal: opción segura de grupo.",
	CONS_NOTE_08 = "Comida personal con stat principal si no hay festín.",
	CONS_NOTE_09 = "Festín de stat secundaria fuerte para tanques; festín principal como alternativa segura.",
	CONS_NOTE_10 = "Aceite de fénix thalassiano salvo que Lengua de fuego encaje mejor en tu build.",
	CONS_NOTE_11 = "Aceite de fénix thalassiano salvo que Furia del viento / Lengua de fuego sean obligatorios.",
	CONS_NOTE_12 = "Buff temporal de arma por defecto salvo imbue específica de tu clase/spec.",
	CONS_NOTE_13 = "Frasco tank listado; cambia a Versatilidad para más defensivo.",
	CONS_NOTE_14 = "Poción listada como burst/throughput en PvE.",
	CONS_NOTE_15 = "Poción tank por defecto con throughput y riesgo controlado.",
}

local PT = {
	CONS_NOTE_01 = "Crítico é o frasco DPS padrão; simule seu personagem para atributos secundários.",
	CONS_NOTE_02 = "Runa de augmento Midnight atual.",
	CONS_NOTE_03 = "Aceleração é o frasco de curador padrão; simule para atributos secundários.",
	CONS_NOTE_04 = "A Concentrated Silvermoon Health Potion da Season 2. A antiga Silvermoon Health Potion ainda conta — a receita consome 25 delas.",
	CONS_NOTE_05 = "Maestria é o frasco DPS padrão; simule para atributos secundários.",
	CONS_NOTE_06 = "Banquete de atributo principal: opção segura de grupo para specs de Intelecto.",
	CONS_NOTE_07 = "Banquete de atributo principal: opção segura de grupo.",
	CONS_NOTE_08 = "Comida pessoal com atributo principal se não houver banquete.",
	CONS_NOTE_09 = "Banquete de atributo secundário forte para tanks; principal como alternativa segura.",
	CONS_NOTE_10 = "Óleo de fênix thalassiano salvo se Língua de Fogo encaixar melhor na build.",
	CONS_NOTE_11 = "Óleo de fênix thalassiano salvo se Fúria dos Ventos / Língua de Fogo forem obrigatórios.",
	CONS_NOTE_12 = "Buff temporário de arma padrão salvo imbue específica da classe/spec.",
	CONS_NOTE_13 = "Frasco tank listado; troque para Versatilidade para mais defensivo.",
	CONS_NOTE_14 = "Poção listada como burst/throughput em PvE.",
	CONS_NOTE_15 = "Poção tank padrão com throughput e risco controlado.",
}

local IT = {
	CONS_NOTE_01 = "Colpo Critico è la fiala di throughput predefinita; simula il tuo personaggio per le caratteristiche secondarie più vicine.",
	CONS_NOTE_02 = "Runa di aumento attuale di Midnight.",
	CONS_NOTE_03 = "Celerità è la fiala di throughput predefinita per i guaritori; simula il tuo personaggio per le secondarie più vicine.",
	CONS_NOTE_04 = "La Concentrated Silvermoon Health Potion della Season 2. La vecchia Silvermoon Health Potion conta ancora — la ricetta ne consuma 25.",
	CONS_NOTE_05 = "Maestria è la fiala di throughput predefinita; simula il tuo personaggio per le secondarie più vicine.",
	CONS_NOTE_06 = "Il banchetto con caratteristica primaria è la scelta di gruppo sicura per le spec con Intelletto.",
	CONS_NOTE_07 = "Il banchetto con caratteristica primaria è la scelta di gruppo sicura.",
	CONS_NOTE_08 = "Il cibo personale con caratteristica primaria è la scelta sicura quando non c'è un banchetto.",
	CONS_NOTE_09 = "Il banchetto con caratteristica secondaria è un'ottima scelta per i tank; quello con primaria è un'alternativa sicura.",
	CONS_NOTE_10 = "Usa Thalassian Phoenix Oil a meno che la tua build attuale non preferisca Flametongue Weapon.",
	CONS_NOTE_11 = "Usa Thalassian Phoenix Oil a meno che la tua build non richieda gli imbue Windfury/Flametongue.",
	CONS_NOTE_12 = "Usa come buff temporaneo all'arma predefinito, a meno che l'imbue specifico della tua classe/spec non lo sostituisca.",
	CONS_NOTE_13 = "Usa la fiala indicata come scelta tank predefinita; passa a Versatilità quando vuoi un ripiego difensivo più sicuro.",
	CONS_NOTE_14 = "Usa la pozione indicata come scelta di burst/throughput predefinita per il PvE.",
	CONS_NOTE_15 = "Usala come pozione tank predefinita quando vuoi throughput con un rischio gestibile.",
}

merge(ns._mhLocales.enUS or {}, EN)
merge(ns._mhLocales.nlNL or {}, NL)
merge(ns._mhLocales.deDE or {}, DE)
merge(ns._mhLocales.frFR or {}, FR)
merge(ns._mhLocales.esES or {}, ES)
merge(ns._mhLocales.ptBR or {}, PT)
merge(ns._mhLocales.itIT or {}, IT)
