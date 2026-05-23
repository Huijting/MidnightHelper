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
	CONS_NOTE_02 = "Current Midnight Season 1 augment rune.",
	CONS_NOTE_03 = "Haste is the default healer throughput flask; sim your character for close secondary stats.",
	CONS_NOTE_04 = "Highest verified Midnight health potion.",
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
	CONS_NOTE_02 = "Huidige Midnight Season 1 augment rune.",
	CONS_NOTE_03 = "Haste is de standaard healer-flacon; sim je character voor secundaire stats.",
	CONS_NOTE_04 = "Hoogste geverifieerde Midnight health potion.",
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
	CONS_NOTE_02 = "Aktuelle Midnight Season 1 Augmentierungsrune.",
	CONS_NOTE_03 = "Tempo ist die Standard-Heiler-Flasche; simuliere deinen Charakter für Sekundärwerte.",
	CONS_NOTE_04 = "Höchster verifizierter Midnight-Heiltrank.",
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
	CONS_NOTE_02 = "Runa de aumento Midnight temporada 1 actual.",
	CONS_NOTE_03 = "Celeridad es el frasco de sanador por defecto; simula tu personaje para stats secundarias.",
	CONS_NOTE_04 = "Poción de salud Midnight más alta verificada.",
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

local FR = {
	CONS_NOTE_01 = "Le crit est la flasque DPS par défaut ; simule ton personnage pour les stats secondaires.",
	CONS_NOTE_02 = "Rune d'augmentation Midnight saison 1 actuelle.",
	CONS_NOTE_03 = "La hâte est la flasque soigneur par défaut ; simule ton personnage pour les stats secondaires.",
	CONS_NOTE_04 = "Potion de soin Midnight la plus élevée vérifiée.",
	CONS_NOTE_05 = "La maîtrise est la flasque DPS par défaut ; simule ton personnage pour les stats secondaires.",
	CONS_NOTE_06 = "Le festin en stat principale est le choix de groupe sûr pour les specs Intelligence.",
	CONS_NOTE_07 = "Le festin en stat principale est le choix de groupe sûr.",
	CONS_NOTE_08 = "Nourriture perso en stat principale si pas de festin.",
	CONS_NOTE_09 = "Festin en stat secondaire fort pour tank ; festin principal en alternative sûre.",
	CONS_NOTE_10 = "Huile de phénix thalassienne sauf si Arme langue-de-feu convient mieux à ton build.",
	CONS_NOTE_11 = "Huile de phénix thalassienne sauf si Furie des vents / Langue-de-feu sont requis.",
	CONS_NOTE_12 = "Buff d'arme temporaire par défaut sauf imbue spécifique à ta classe/spec.",
	CONS_NOTE_13 = "Flasque tank listée ; passe en Polyvalence pour plus de défense.",
	CONS_NOTE_14 = "Potion listée comme choix burst/throughput en PvE.",
	CONS_NOTE_15 = "Potion tank par défaut avec throughput et risque maîtrisé.",
}

merge(ns._mhLocales.enUS or {}, EN)
merge(ns._mhLocales.nlNL or {}, NL)
merge(ns._mhLocales.deDE or {}, DE)
merge(ns._mhLocales.frFR or {}, FR)
merge(ns._mhLocales.esES or {}, ES)
