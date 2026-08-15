--[[
	Midnight Helper — Mythic+ Season 1 tip bodies (all 6 locales).

	Drives the Dungeon Coach "Mythic+" sub-tab. Sources: Wowhead Season 1 M+
	overview (affixes/system) + method.gg ability-trackers (must-kicks).
	See docs/RAID_MPLUS_DATA.md. never-lie: spell-IDs only where datamined;
	per-dungeon kicks stay descriptive with a "confirm in-game" caveat.

	{SPELL:id} renders a localized link; |n is a line break; • is a bullet.
	WoW proper names (affixes, abilities, dungeons, mobs) stay in English in
	every locale; only the connecting prose follows each locale's convention.
]]

local _, ns = ...

local function merge(target, patch)
	if not target or not patch then
		return
	end
	for k, v in pairs(patch) do
		target[k] = v
	end
end

merge(ns._mhLocales and ns._mhLocales.enUS, {
	MPLUS_VIEW = "Mythic+",
	MPLUS_HEADER = "Mythic+ — Season 1",
	MPLUS_HEADER_S2 = "Mythic+ — Season 2",
	MPLUS_INTRO = "How keys work this season: the affixes, the 8-dungeon pool and the casts you must interrupt. Written against the Wowhead overview and method.gg — confirm in-game.",

	MPLUS_AFFIX_HEADER = "What turns on at each key level",
	MPLUS_AFFIX_UNMEASURED = "Season 2 changed the keystone affixes, and Midnight Helper has not measured the new ones yet. The list that used to stand here was Season 1’s, and showing it under a Season 2 heading would be worse than showing nothing. The dungeon pool below is current.",
	MPLUS_AFFIX_LINDORMI = "Lindormi's Guidance — marks and weakens certain enemies (Temporal Sands), and removes the death penalty. A leg-up while you learn the dungeons.",
	MPLUS_AFFIX_BARGAIN = "Xal'atath's Bargain — one of four weekly \"kiss-curse\" variants is active (see below). Runs from +5 to +11.",
	MPLUS_AFFIX_LINDOFF = "Lindormi's Guidance falls off — no more death-penalty grace from here up.",
	MPLUS_AFFIX_TYRFORT = "Tyrannical OR Fortified (alternates weekly). Tyrannical: bosses have more health and hit harder. Fortified: trash has more health and hits harder.",
	MPLUS_AFFIX_BOTH = "Tyrannical AND Fortified are both active, every week, from here up.",
	MPLUS_AFFIX_GUILE = "Xal'atath's Guile replaces the Bargain — every death now also subtracts 15 seconds from the timer (and that time doesn't come back).",

	MPLUS_BARGAIN_HEADER = "Xal'atath's Bargain — this week is one of these four",
	MPLUS_BARGAIN_ASCENDANT = "Ascendant — orbs cast {SPELL:461904}; stop them (interrupt / CC / purge) for a party speed & haste buff, or the mobs get buffed instead.",
	MPLUS_BARGAIN_VOIDBOUND = "Voidbound — a Void Emissary empowers mobs with {SPELL:462508}; kill it for more cooldown rate & versatility, or nearby mobs grow stronger.",
	MPLUS_BARGAIN_PULSAR = "Pulsar — soak {SPELL:1216815} before it expires for a mastery & leech buff; fail and the mobs gain damage and damage reduction.",
	MPLUS_BARGAIN_DEVOUR = "Devour — {SPELL:440313} puts a shield + slow on all five of you; clear it with healing or any dispel for a {SPELL:465136} buff, or the mobs heal up.",

	MPLUS_POOL_HEADER = "This season's 8 dungeons",
	MPLUS_POOL_NOTE = "Normal & Follower run all the launch dungeons; Heroic, Mythic 0 and Mythic+ use this pool. Open any dungeon in the Dungeon Coach tab for per-boss steps.",

	MPLUS_SYSTEM_HEADER = "Good to know",
	MPLUS_SYSTEM = "• Keys start at +2 (not +4 like before).|n• Resilient Keystones: time all 8 dungeons at +12 and your key never drops below +12 on a depletion (and it scales up from there).|n• Dungeon Waystones are mid-run checkpoints — dead players respawn at the latest one you've unlocked.|n• Loot and crests scale with key level: Champion-tier crests at low keys up to Myth Crest at +10 and above, plus a Great Vault dungeon slot for completing eight.",

	MPLUS_KICK_HEADER = "Must-interrupt casts (per dungeon)",
	MPLUS_KICK_NOTE = "The big ones to watch — names confirmed from guides, confirm in-game. More dungeons are added as we verify their cast lists.",
	MPLUS_KICK_MAISARA = "Maisara Caverns (the pool's toughest): kick Hex (Ritual Hexxer), Reanimation (Reanimated Warrior — every cast, or it's a wipe) and Shrink (Umbral Shadowbinder). On Rak'tul, interrupt every Malignant Soul on the bridge.",
	MPLUS_KICK_MAGISTERS = "Magisters' Terrace: the bosses have nothing to interrupt — it's all trash. Kick priority {SPELL:468966} (Arcane Magister — it sheeps a player) > {SPELL:1254294} (Blazing Pyromancer) > {SPELL:1264693} (Void Terror).",
	MPLUS_KICK_NEXUSPOINT = "Nexus-Point Xenas: kick {SPELL:1250553} on Chief Corewright Kasreth, and on trash {SPELL:1258681} (Grand Nullifier) > {SPELL:1271094} (Nexus Adept) > {SPELL:1263892} (Lightwrought). On Lothraxion's {SPELL:1257595}, interrupt the shade WITHOUT horns — kicking the wrong one hurts the group.",
	MPLUS_KICK_WINDRUNNER = "Windrunner Spire: kick Chain Lightning (Phantasmal Mystic — also stops its haste buff), Spirit Bolt (Restless Steward), Poison Blades (Ardent Cutthroat) and Fungal Bolt (Bloated Lasher). (Spell IDs not datamined yet — confirm in-game.)",
	MPLUS_KICK_PITOFSARON = "Pit of Saron: kick priority is {SPELL:1271074} (Dreadpulse Lich) > {SPELL:473657} (Gloombound Shadebringer) > {SPELL:1278893} (Krick). On Garfrost, break line of sight to {SPELL:1262029} behind an Ore Chunk.",
	MPLUS_KICK_ALGETHAR = "Algeth'ar Academy: interrupt {SPELL:396640} (Ancient Branch) — every cast, or it's a wipe.",
	MPLUS_KICK_TRIUMVIRATE = "Seat of the Triumvirate: priority kick is {SPELL:248831} (Shadewing).",
	MPLUS_KICK_SKYREACH = "Skyreach: priority kick is {SPELL:1255377} (Driving Gale-Caller).",
	MPLUS_KICK_NONE = "%s: no verified must-kick notes yet - watch what the group interrupts.",
})

merge(ns._mhLocales and ns._mhLocales.itIT, {
	MPLUS_VIEW = "Mythic+",
	MPLUS_HEADER = "Mythic+ — Season 1",
	MPLUS_HEADER_S2 = "Mythic+ — Season 2",
	MPLUS_INTRO = "Come funzionano le key questa stagione: gli affix, il pool di 8 dungeon e i cast che devi interrompere. Scritto sulla base della panoramica di Wowhead e method.gg — confermare in-game.",

	MPLUS_AFFIX_HEADER = "Cosa si attiva a ogni livello di key",
	MPLUS_AFFIX_UNMEASURED = "La Stagione 2 ha cambiato gli affissi delle keystone e Midnight Helper non ha ancora misurato quelli nuovi. L’elenco che stava qui era della Stagione 1, e mostrarlo sotto un titolo di Stagione 2 sarebbe peggio che non mostrare nulla. Il pool di dungeon qui sotto è aggiornato.",
	MPLUS_AFFIX_LINDORMI = "Lindormi's Guidance — segna e indebolisce certi nemici (Temporal Sands), e rimuove la penalità di morte. Un aiuto mentre impari i dungeon.",
	MPLUS_AFFIX_BARGAIN = "Xal'atath's Bargain — è attiva una delle quattro varianti settimanali \"bacio-maledizione\" (vedi sotto). Va da +5 a +11.",
	MPLUS_AFFIX_LINDOFF = "Lindormi's Guidance decade — da qui in su niente più clemenza sulla penalità di morte.",
	MPLUS_AFFIX_TYRFORT = "Tyrannical OPPURE Fortified (si alternano ogni settimana). Tyrannical: i boss hanno più vita e colpiscono più forte. Fortified: il trash ha più vita e colpisce più forte.",
	MPLUS_AFFIX_BOTH = "Tyrannical E Fortified sono entrambi attivi, ogni settimana, da qui in su.",
	MPLUS_AFFIX_GUILE = "Xal'atath's Guile sostituisce il Bargain — ogni morte ora sottrae anche 15 secondi dal timer (e quel tempo non torna).",

	MPLUS_BARGAIN_HEADER = "Xal'atath's Bargain — questa settimana è una di queste quattro",
	MPLUS_BARGAIN_ASCENDANT = "Ascendant — gli orbe lanciano {SPELL:461904}; fermali (interrupt / CC / purge) per un buff di velocità & haste al gruppo, altrimenti vengono potenziati i mob.",
	MPLUS_BARGAIN_VOIDBOUND = "Voidbound — un Void Emissary potenzia i mob con {SPELL:462508}; uccidilo per più cooldown rate & versatility, altrimenti i mob vicini diventano più forti.",
	MPLUS_BARGAIN_PULSAR = "Pulsar — soak {SPELL:1216815} prima che scada per un buff di mastery & leech; se fallisci i mob ottengono danni e damage reduction.",
	MPLUS_BARGAIN_DEVOUR = "Devour — {SPELL:440313} mette uno shield + slow su tutti e cinque; rimuovilo con healing o un qualsiasi dispel per un buff {SPELL:465136}, altrimenti i mob si curano.",

	MPLUS_POOL_HEADER = "Gli 8 dungeon di questa stagione",
	MPLUS_POOL_NOTE = "Normal & Follower usano tutti i dungeon di lancio; Heroic, Mythic 0 e Mythic+ usano questo pool. Apri un dungeon nella scheda Dungeon Coach per i passaggi boss per boss.",

	MPLUS_SYSTEM_HEADER = "Utile da sapere",
	MPLUS_SYSTEM = "• Le key partono da +2 (non da +4 come prima).|n• Resilient Keystones: completa nei tempi tutti gli 8 dungeon a +12 e la tua key non scende mai sotto +12 a un depletion (e da lì in poi scala verso l'alto).|n• Le Dungeon Waystones sono checkpoint a metà run — i giocatori morti rinascono all'ultima che hai sbloccato.|n• Loot e crest scalano con il livello di key: crest di tier Champion alle key basse fino a Myth Crest a +10 e oltre, più uno slot dungeon della Great Vault per averne completati otto.",

	MPLUS_KICK_HEADER = "Cast da interrompere obbligatoriamente (per dungeon)",
	MPLUS_KICK_NOTE = "I grossi da tenere d'occhio — nomi confermati dalle guide, confermare in-game. Aggiungiamo altri dungeon man mano che verifichiamo le loro liste di cast.",
	MPLUS_KICK_MAISARA = "Maisara Caverns (il più tosto del pool): kicka Hex (Ritual Hexxer), Reanimation (Reanimated Warrior — ogni cast, o è un wipe) e Shrink (Umbral Shadowbinder). Su Rak'tul, interrompi ogni Malignant Soul sul ponte.",
	MPLUS_KICK_MAGISTERS = "Magisters' Terrace: i boss non hanno nulla da interrompere — è tutto trash. Priorità di kick {SPELL:468966} (Arcane Magister — trasforma un giocatore in pecora) > {SPELL:1254294} (Blazing Pyromancer) > {SPELL:1264693} (Void Terror).",
	MPLUS_KICK_NEXUSPOINT = "Nexus-Point Xenas: kicka {SPELL:1250553} su Chief Corewright Kasreth, e sul trash {SPELL:1258681} (Grand Nullifier) > {SPELL:1271094} (Nexus Adept) > {SPELL:1263892} (Lightwrought). Sul {SPELL:1257595} di Lothraxion, interrompi l'ombra SENZA corna — kickare quella sbagliata danneggia il gruppo.",
	MPLUS_KICK_WINDRUNNER = "Windrunner Spire: kicka Chain Lightning (Phantasmal Mystic — ferma anche il suo buff di haste), Spirit Bolt (Restless Steward), Poison Blades (Ardent Cutthroat) e Fungal Bolt (Bloated Lasher). (Spell ID non ancora da datamining — confermare in-game.)",
	MPLUS_KICK_PITOFSARON = "Pit of Saron: la priorità di kick è {SPELL:1271074} (Dreadpulse Lich) > {SPELL:473657} (Gloombound Shadebringer) > {SPELL:1278893} (Krick). Su Garfrost, spezza la linea di vista verso {SPELL:1262029} dietro un Ore Chunk.",
	MPLUS_KICK_ALGETHAR = "Algeth'ar Academy: interrompi {SPELL:396640} (Ancient Branch) — ogni cast, o è un wipe.",
	MPLUS_KICK_TRIUMVIRATE = "Seat of the Triumvirate: il kick prioritario è {SPELL:248831} (Shadewing).",
	MPLUS_KICK_SKYREACH = "Skyreach: il kick prioritario è {SPELL:1255377} (Driving Gale-Caller).",
})

merge(ns._mhLocales and ns._mhLocales.nlNL, {
	MPLUS_VIEW = "Mythic+",
	MPLUS_HEADER = "Mythic+ — Seizoen 1",
	MPLUS_HEADER_S2 = "Mythic+ — Seizoen 2",
	MPLUS_INTRO = "Hoe keys dit seizoen werken: de affixes, de pool van 8 dungeons en de casts die je moet interrupten. Geschreven aan de hand van het Wowhead-overzicht en method.gg — in-game bevestigen.",

	MPLUS_AFFIX_HEADER = "Wat er bij elk keyniveau aangaat",
	MPLUS_AFFIX_UNMEASURED = "Season 2 heeft de keystone-affixen veranderd en Midnight Helper heeft de nieuwe nog niet gemeten. Het lijstje dat hier stond was dat van Season 1, en dat tonen onder een Season 2-kop is erger dan niets tonen. De dungeonpool hieronder klopt wel.",
	MPLUS_AFFIX_LINDORMI = "Lindormi's Guidance — markeert en verzwakt bepaalde vijanden (Temporal Sands), en verwijdert de doodstraf. Een steuntje in de rug terwijl je de dungeons leert.",
	MPLUS_AFFIX_BARGAIN = "Xal'atath's Bargain — een van de vier wekelijkse \"kus-vloek\"-varianten is actief (zie hieronder). Loopt van +5 tot +11.",
	MPLUS_AFFIX_LINDOFF = "Lindormi's Guidance valt weg — vanaf hier geen genade meer van de doodstraf.",
	MPLUS_AFFIX_TYRFORT = "Tyrannical OF Fortified (wisselt wekelijks). Tyrannical: bosses hebben meer health en slaan harder. Fortified: trash heeft meer health en slaat harder.",
	MPLUS_AFFIX_BOTH = "Tyrannical EN Fortified zijn allebei actief, elke week, vanaf hier omhoog.",
	MPLUS_AFFIX_GUILE = "Xal'atath's Guile vervangt de Bargain — elke dood trekt nu ook 15 seconds van de timer af (en die tijd komt niet terug).",

	MPLUS_BARGAIN_HEADER = "Xal'atath's Bargain — deze week is een van deze vier",
	MPLUS_BARGAIN_ASCENDANT = "Ascendant — orbs casten {SPELL:461904}; stop ze (interrupt / CC / purge) voor een party speed- & haste-buff, anders worden de mobs juist gebuft.",
	MPLUS_BARGAIN_VOIDBOUND = "Voidbound — een Void Emissary versterkt mobs met {SPELL:462508}; dood hem voor meer cooldown rate & versatility, anders worden nabije mobs sterker.",
	MPLUS_BARGAIN_PULSAR = "Pulsar — soak {SPELL:1216815} voordat hij afloopt voor een mastery- & leech-buff; faal je, dan krijgen de mobs damage en damage reduction.",
	MPLUS_BARGAIN_DEVOUR = "Devour — {SPELL:440313} legt een shield + slow op jullie alle vijf; clear het met healing of een willekeurige dispel voor een {SPELL:465136}-buff, anders healen de mobs op.",

	MPLUS_POOL_HEADER = "De 8 dungeons van dit seizoen",
	MPLUS_POOL_NOTE = "Normal & Follower draaien alle launch-dungeons; Heroic, Mythic 0 en Mythic+ gebruiken deze pool. Open een dungeon in de Dungeon Coach-tab voor stappen per boss.",

	MPLUS_SYSTEM_HEADER = "Goed om te weten",
	MPLUS_SYSTEM = "• Keys starten op +2 (niet op +4 zoals vroeger).|n• Resilient Keystones: time alle 8 dungeons op +12 en je key zakt bij een depletion nooit onder +12 (en schaalt vandaaruit verder op).|n• Dungeon Waystones zijn checkpoints midden in de run — dode spelers respawnen bij de laatste die je hebt ontgrendeld.|n• Loot en crests schalen met keyniveau: Champion-tier crests bij lage keys tot Myth Crest bij +10 en hoger, plus een Great Vault dungeon-slot voor het voltooien van acht.",

	MPLUS_KICK_HEADER = "Verplicht te interrupten casts (per dungeon)",
	MPLUS_KICK_NOTE = "De grote om op te letten — namen bevestigd uit guides, in-game bevestigen. Meer dungeons worden toegevoegd zodra we hun castlijsten verifiëren.",
	MPLUS_KICK_MAISARA = "Maisara Caverns (de zwaarste van de pool): kick Hex (Ritual Hexxer), Reanimation (Reanimated Warrior — elke cast, anders is het een wipe) en Shrink (Umbral Shadowbinder). Op Rak'tul interrupt elke Malignant Soul op de brug.",
	MPLUS_KICK_MAGISTERS = "Magisters' Terrace: de bosses hebben niets om te interrupten — het is allemaal trash. Kickprioriteit {SPELL:468966} (Arcane Magister — verschaapt een speler) > {SPELL:1254294} (Blazing Pyromancer) > {SPELL:1264693} (Void Terror).",
	MPLUS_KICK_NEXUSPOINT = "Nexus-Point Xenas: kick {SPELL:1250553} op Chief Corewright Kasreth, en op trash {SPELL:1258681} (Grand Nullifier) > {SPELL:1271094} (Nexus Adept) > {SPELL:1263892} (Lightwrought). Bij Lothraxion's {SPELL:1257595} interrupt de shade ZONDER horens — de verkeerde kicken schaadt de groep.",
	MPLUS_KICK_WINDRUNNER = "Windrunner Spire: kick Chain Lightning (Phantasmal Mystic — stopt ook zijn haste-buff), Spirit Bolt (Restless Steward), Poison Blades (Ardent Cutthroat) en Fungal Bolt (Bloated Lasher). (Spell-ID's nog niet gedatamined — in-game bevestigen.)",
	MPLUS_KICK_PITOFSARON = "Pit of Saron: kickprioriteit is {SPELL:1271074} (Dreadpulse Lich) > {SPELL:473657} (Gloombound Shadebringer) > {SPELL:1278893} (Krick). Op Garfrost, breek line of sight naar {SPELL:1262029} achter een Ore Chunk.",
	MPLUS_KICK_ALGETHAR = "Algeth'ar Academy: interrupt {SPELL:396640} (Ancient Branch) — elke cast, anders is het een wipe.",
	MPLUS_KICK_TRIUMVIRATE = "Seat of the Triumvirate: prioriteitskick is {SPELL:248831} (Shadewing).",
	MPLUS_KICK_SKYREACH = "Skyreach: prioriteitskick is {SPELL:1255377} (Driving Gale-Caller).",
	MPLUS_KICK_NONE = "%s: nog geen geverifieerde kick-notities - let op wat de groep interrupt.",
})

merge(ns._mhLocales and ns._mhLocales.deDE, {
	MPLUS_VIEW = "Mythic+",
	MPLUS_HEADER = "Mythic+ — Saison 1",
	MPLUS_HEADER_S2 = "Mythic+ — Saison 2",
	MPLUS_INTRO = "Wie Keys diese Saison funktionieren: die Affixe, der Pool aus 8 Dungeons und die Zauber, die du unterbrechen musst. Geschrieben anhand der Wowhead-Übersicht und method.gg — im Spiel bestätigen.",

	MPLUS_AFFIX_HEADER = "Was bei jeder Keystufe aktiv wird",
	MPLUS_AFFIX_UNMEASURED = "Season 2 hat die Keystone-Affixe geändert, und Midnight Helper hat die neuen noch nicht gemessen. Die Liste, die hier stand, war die von Season 1 — sie unter einer Season-2-Überschrift zu zeigen wäre schlimmer, als nichts zu zeigen. Der Dungeon-Pool unten ist aktuell.",
	MPLUS_AFFIX_LINDORMI = "Lindormi's Guidance — markiert und schwächt bestimmte Gegner (Temporal Sands) und entfernt die Todesstrafe. Eine Starthilfe, während du die Dungeons lernst.",
	MPLUS_AFFIX_BARGAIN = "Xal'atath's Bargain — eine von vier wöchentlichen \"Kuss-Fluch\"-Varianten ist aktiv (siehe unten). Läuft von +5 bis +11.",
	MPLUS_AFFIX_LINDOFF = "Lindormi's Guidance fällt weg — ab hier keine Gnade mehr bei der Todesstrafe.",
	MPLUS_AFFIX_TYRFORT = "Tyrannical ODER Fortified (wechselt wöchentlich). Tyrannical: Bosse haben mehr Gesundheit und schlagen härter. Fortified: Trash hat mehr Gesundheit und schlägt härter.",
	MPLUS_AFFIX_BOTH = "Tyrannical UND Fortified sind beide aktiv, jede Woche, ab hier aufwärts.",
	MPLUS_AFFIX_GUILE = "Xal'atath's Guile ersetzt den Bargain — jeder Tod zieht nun zusätzlich 15 seconds von der Zeit ab (und diese Zeit kommt nicht zurück).",

	MPLUS_BARGAIN_HEADER = "Xal'atath's Bargain — diese Woche ist eine dieser vier",
	MPLUS_BARGAIN_ASCENDANT = "Ascendant — Orbs wirken {SPELL:461904}; stopp sie (Unterbrechen / CC / Bannen) für einen Gruppen-Tempo- & Hast-Buff, sonst werden stattdessen die Mobs gebufft.",
	MPLUS_BARGAIN_VOIDBOUND = "Voidbound — ein Void Emissary verstärkt Mobs mit {SPELL:462508}; töte ihn für mehr Abklingzeitrate & Vielseitigkeit, sonst werden nahe Mobs stärker.",
	MPLUS_BARGAIN_PULSAR = "Pulsar — soake {SPELL:1216815}, bevor er ausläuft, für einen Meisterschafts- & Lebensraub-Buff; scheiterst du, erhalten die Mobs Schaden und Schadensreduktion.",
	MPLUS_BARGAIN_DEVOUR = "Devour — {SPELL:440313} legt euch allen fünf einen Schild + Verlangsamung auf; entferne es mit Heilung oder einem beliebigen Dispel für einen {SPELL:465136}-Buff, sonst heilen sich die Mobs hoch.",

	MPLUS_POOL_HEADER = "Die 8 Dungeons dieser Saison",
	MPLUS_POOL_NOTE = "Normal & Follower nutzen alle Launch-Dungeons; Heroisch, Mythisch 0 und Mythic+ nutzen diesen Pool. Öffne einen Dungeon im Dungeon-Coach-Tab für Schritte je Boss.",

	MPLUS_SYSTEM_HEADER = "Gut zu wissen",
	MPLUS_SYSTEM = "• Keys starten bei +2 (nicht bei +4 wie früher).|n• Resilient Keystones: time alle 8 Dungeons auf +12, und dein Key fällt bei einer Abwertung nie unter +12 (und skaliert von dort aus weiter hoch).|n• Dungeon Waystones sind Checkpoints mitten im Run — tote Spieler respawnen am letzten, den du freigeschaltet hast.|n• Beute und Wappen skalieren mit der Keystufe: Champion-Stufe-Wappen bei niedrigen Keys bis hoch zu Myth Crest bei +10 und höher, plus ein Great Vault Dungeon-Slot für das Abschließen von acht.",

	MPLUS_KICK_HEADER = "Pflicht-Unterbrechungen (je Dungeon)",
	MPLUS_KICK_NOTE = "Die großen, auf die man achten muss — Namen aus Guides bestätigt, im Spiel bestätigen. Weitere Dungeons werden hinzugefügt, sobald wir ihre Zauberlisten verifizieren.",
	MPLUS_KICK_MAISARA = "Maisara Caverns (der härteste im Pool): kicke Hex (Ritual Hexxer), Reanimation (Reanimated Warrior — jeder Zauber, sonst ist es ein Wipe) und Shrink (Umbral Shadowbinder). Bei Rak'tul unterbrich jeden Malignant Soul auf der Brücke.",
	MPLUS_KICK_MAGISTERS = "Magisters' Terrace: die Bosse haben nichts zu unterbrechen — es ist alles Trash. Kick-Priorität {SPELL:468966} (Arcane Magister — verwandelt einen Spieler in ein Schaf) > {SPELL:1254294} (Blazing Pyromancer) > {SPELL:1264693} (Void Terror).",
	MPLUS_KICK_NEXUSPOINT = "Nexus-Point Xenas: kicke {SPELL:1250553} bei Chief Corewright Kasreth, und bei Trash {SPELL:1258681} (Grand Nullifier) > {SPELL:1271094} (Nexus Adept) > {SPELL:1263892} (Lightwrought). Bei Lothraxions {SPELL:1257595} unterbrich die Schattengestalt OHNE Hörner — die falsche zu kicken schadet der Gruppe.",
	MPLUS_KICK_WINDRUNNER = "Windrunner Spire: kicke Chain Lightning (Phantasmal Mystic — stoppt auch seinen Hast-Buff), Spirit Bolt (Restless Steward), Poison Blades (Ardent Cutthroat) und Fungal Bolt (Bloated Lasher). (Spell-IDs noch nicht datamined — im Spiel bestätigen.)",
	MPLUS_KICK_PITOFSARON = "Pit of Saron: Kick-Priorität ist {SPELL:1271074} (Dreadpulse Lich) > {SPELL:473657} (Gloombound Shadebringer) > {SPELL:1278893} (Krick). Bei Garfrost unterbrich die Sichtlinie zu {SPELL:1262029} hinter einem Ore Chunk.",
	MPLUS_KICK_ALGETHAR = "Algeth'ar Academy: unterbrich {SPELL:396640} (Ancient Branch) — jeder Zauber, sonst ist es ein Wipe.",
	MPLUS_KICK_TRIUMVIRATE = "Seat of the Triumvirate: Prioritäts-Kick ist {SPELL:248831} (Shadewing).",
	MPLUS_KICK_SKYREACH = "Skyreach: Prioritäts-Kick ist {SPELL:1255377} (Driving Gale-Caller).",
})

merge(ns._mhLocales and ns._mhLocales.frFR, {
	MPLUS_VIEW = "Mythic+",
	MPLUS_HEADER = "Mythic+ — Saison 1",
	MPLUS_HEADER_S2 = "Mythic+ — Saison 2",
	MPLUS_INTRO = "Comment fonctionnent les clés cette saison : les affixes, le pool de 8 donjons et les incantations que vous devez interrompre. Rédigé d'après l'aperçu de Wowhead et method.gg — à confirmer en jeu.",

	MPLUS_AFFIX_HEADER = "Ce qui s'active à chaque niveau de clé",
	MPLUS_AFFIX_UNMEASURED = "La Saison 2 a changé les affixes de clé, et Midnight Helper n’a pas encore mesuré les nouveaux. La liste qui figurait ici était celle de la Saison 1, et l’afficher sous un titre Saison 2 serait pire que de ne rien afficher. Le pool de donjons ci-dessous est à jour.",
	MPLUS_AFFIX_LINDORMI = "Lindormi's Guidance — marque et affaiblit certains ennemis (Temporal Sands), et supprime la pénalité de mort. Un coup de pouce pendant que vous apprenez les donjons.",
	MPLUS_AFFIX_BARGAIN = "Xal'atath's Bargain — l'une des quatre variantes hebdomadaires \"baiser-malédiction\" est active (voir ci-dessous). Va de +5 à +11.",
	MPLUS_AFFIX_LINDOFF = "Lindormi's Guidance disparaît — plus aucune grâce sur la pénalité de mort à partir d'ici.",
	MPLUS_AFFIX_TYRFORT = "Tyrannical OU Fortified (alterne chaque semaine). Tyrannical : les boss ont plus de points de vie et frappent plus fort. Fortified : les packs ont plus de points de vie et frappent plus fort.",
	MPLUS_AFFIX_BOTH = "Tyrannical ET Fortified sont tous deux actifs, chaque semaine, à partir d'ici.",
	MPLUS_AFFIX_GUILE = "Xal'atath's Guile remplace le Bargain — chaque mort retire désormais aussi 15 seconds du chrono (et ce temps ne revient pas).",

	MPLUS_BARGAIN_HEADER = "Xal'atath's Bargain — cette semaine c'est l'une de ces quatre",
	MPLUS_BARGAIN_ASCENDANT = "Ascendant — les orbes lancent {SPELL:461904} ; arrêtez-les (interruption / CC / dissipation) pour un bonus de vitesse & de hâte de groupe, sinon ce sont les mobs qui sont boostés.",
	MPLUS_BARGAIN_VOIDBOUND = "Voidbound — un Void Emissary renforce les mobs avec {SPELL:462508} ; tuez-le pour plus de taux de récupération & de polyvalence, sinon les mobs proches deviennent plus forts.",
	MPLUS_BARGAIN_PULSAR = "Pulsar — soakez {SPELL:1216815} avant qu'il n'expire pour un bonus de maîtrise & de vol de vie ; échouez et les mobs gagnent des dégâts et de la réduction de dégâts.",
	MPLUS_BARGAIN_DEVOUR = "Devour — {SPELL:440313} pose un bouclier + ralentissement sur vous cinq ; nettoyez-le avec des soins ou n'importe quelle dissipation pour un bonus {SPELL:465136}, sinon les mobs se soignent.",

	MPLUS_POOL_HEADER = "Les 8 donjons de cette saison",
	MPLUS_POOL_NOTE = "Normal & Suiveur utilisent tous les donjons de lancement ; Héroïque, Mythique 0 et Mythic+ utilisent ce pool. Ouvrez un donjon dans l'onglet Dungeon Coach pour les étapes par boss.",

	MPLUS_SYSTEM_HEADER = "Bon à savoir",
	MPLUS_SYSTEM = "• Les clés commencent à +2 (et non +4 comme avant).|n• Resilient Keystones : chronométrez les 8 donjons en +12 et votre clé ne descend jamais sous +12 lors d'une déplétion (et elle monte à partir de là).|n• Les Dungeon Waystones sont des points de contrôle en milieu de run — les joueurs morts réapparaissent au dernier que vous avez débloqué.|n• Le butin et les écussons évoluent avec le niveau de clé : écussons de palier Champion aux clés basses jusqu'à Myth Crest en +10 et au-delà, plus un emplacement de donjon de Great Vault pour en avoir terminé huit.",

	MPLUS_KICK_HEADER = "Incantations à interrompre obligatoirement (par donjon)",
	MPLUS_KICK_NOTE = "Les grosses à surveiller — noms confirmés d'après les guides, à confirmer en jeu. D'autres donjons seront ajoutés à mesure que nous vérifions leurs listes d'incantations.",
	MPLUS_KICK_MAISARA = "Maisara Caverns (le plus dur du pool) : kickez Hex (Ritual Hexxer), Reanimation (Reanimated Warrior — chaque incantation, sinon c'est un wipe) et Shrink (Umbral Shadowbinder). Sur Rak'tul, interrompez chaque Malignant Soul sur le pont.",
	MPLUS_KICK_MAGISTERS = "Magisters' Terrace : les boss n'ont rien à interrompre — c'est tout du trash. Priorité de kick {SPELL:468966} (Arcane Magister — il transforme un joueur en mouton) > {SPELL:1254294} (Blazing Pyromancer) > {SPELL:1264693} (Void Terror).",
	MPLUS_KICK_NEXUSPOINT = "Nexus-Point Xenas : kickez {SPELL:1250553} sur Chief Corewright Kasreth, et sur le trash {SPELL:1258681} (Grand Nullifier) > {SPELL:1271094} (Nexus Adept) > {SPELL:1263892} (Lightwrought). Sur le {SPELL:1257595} de Lothraxion, interrompez l'ombre SANS cornes — kicker la mauvaise nuit au groupe.",
	MPLUS_KICK_WINDRUNNER = "Windrunner Spire : kickez Chain Lightning (Phantasmal Mystic — arrête aussi son buff de hâte), Spirit Bolt (Restless Steward), Poison Blades (Ardent Cutthroat) et Fungal Bolt (Bloated Lasher). (Spell IDs pas encore dataminés — à confirmer en jeu.)",
	MPLUS_KICK_PITOFSARON = "Pit of Saron : la priorité de kick est {SPELL:1271074} (Dreadpulse Lich) > {SPELL:473657} (Gloombound Shadebringer) > {SPELL:1278893} (Krick). Sur Garfrost, brisez la ligne de vue vers {SPELL:1262029} derrière un Ore Chunk.",
	MPLUS_KICK_ALGETHAR = "Algeth'ar Academy : interrompez {SPELL:396640} (Ancient Branch) — chaque incantation, sinon c'est un wipe.",
	MPLUS_KICK_TRIUMVIRATE = "Seat of the Triumvirate : le kick prioritaire est {SPELL:248831} (Shadewing).",
	MPLUS_KICK_SKYREACH = "Skyreach : le kick prioritaire est {SPELL:1255377} (Driving Gale-Caller).",
})

merge(ns._mhLocales and ns._mhLocales.esES, {
	MPLUS_VIEW = "Mythic+",
	MPLUS_HEADER = "Mythic+ — Temporada 1",
	MPLUS_HEADER_S2 = "Mythic+ — Temporada 2",
	MPLUS_INTRO = "Cómo funcionan las llaves esta temporada: los afijos, el pool de 8 mazmorras y los lanzamientos que debes interrumpir. Escrito a partir del resumen de Wowhead y method.gg — confirmar en el juego.",

	MPLUS_AFFIX_HEADER = "Qué se activa en cada nivel de llave",
	MPLUS_AFFIX_UNMEASURED = "La Temporada 2 cambió los afijos de las llaves y Midnight Helper todavía no ha medido los nuevos. La lista que había aquí era la de la Temporada 1, y mostrarla bajo un título de Temporada 2 sería peor que no mostrar nada. El grupo de mazmorras de abajo sí está al día.",
	MPLUS_AFFIX_LINDORMI = "Lindormi's Guidance — marca y debilita a ciertos enemigos (Temporal Sands), y elimina la penalización por muerte. Una ayuda mientras aprendes las mazmorras.",
	MPLUS_AFFIX_BARGAIN = "Xal'atath's Bargain — una de las cuatro variantes semanales de \"beso-maldición\" está activa (ver abajo). Va de +5 a +11.",
	MPLUS_AFFIX_LINDOFF = "Lindormi's Guidance desaparece — a partir de aquí no hay más indulgencia con la penalización por muerte.",
	MPLUS_AFFIX_TYRFORT = "Tyrannical O Fortified (se alternan cada semana). Tyrannical: los jefes tienen más vida y pegan más fuerte. Fortified: el trash tiene más vida y pega más fuerte.",
	MPLUS_AFFIX_BOTH = "Tyrannical Y Fortified están ambos activos, cada semana, de aquí en adelante.",
	MPLUS_AFFIX_GUILE = "Xal'atath's Guile reemplaza al Bargain — cada muerte ahora también resta 15 seconds del cronómetro (y ese tiempo no vuelve).",

	MPLUS_BARGAIN_HEADER = "Xal'atath's Bargain — esta semana es una de estas cuatro",
	MPLUS_BARGAIN_ASCENDANT = "Ascendant — los orbes lanzan {SPELL:461904}; deténlos (interrupción / CC / disipación) para un buff de velocidad y celeridad de grupo, o si no son los mobs los que se potencian.",
	MPLUS_BARGAIN_VOIDBOUND = "Voidbound — un Void Emissary potencia a los mobs con {SPELL:462508}; mátalo para más tasa de enfriamiento y versatilidad, o los mobs cercanos se vuelven más fuertes.",
	MPLUS_BARGAIN_PULSAR = "Pulsar — soakea {SPELL:1216815} antes de que expire para un buff de maestría y robo de vida; falla y los mobs ganan daño y reducción de daño.",
	MPLUS_BARGAIN_DEVOUR = "Devour — {SPELL:440313} pone un escudo + ralentización sobre los cinco; límpialo con sanación o cualquier disipación para un buff de {SPELL:465136}, o los mobs se curan.",

	MPLUS_POOL_HEADER = "Las 8 mazmorras de esta temporada",
	MPLUS_POOL_NOTE = "Normal y Seguidor usan todas las mazmorras de lanzamiento; Heroico, Mítico 0 y Mythic+ usan este pool. Abre cualquier mazmorra en la pestaña Dungeon Coach para los pasos por jefe.",

	MPLUS_SYSTEM_HEADER = "Bueno saberlo",
	MPLUS_SYSTEM = "• Las llaves empiezan en +2 (no en +4 como antes).|n• Resilient Keystones: cronometra las 8 mazmorras en +12 y tu llave nunca baja de +12 en una degradación (y escala hacia arriba desde ahí).|n• Las Dungeon Waystones son puntos de control a mitad de run — los jugadores muertos reaparecen en el último que hayas desbloqueado.|n• El botín y los blasones escalan con el nivel de llave: blasones de nivel Champion en llaves bajas hasta Myth Crest en +10 y superiores, más una ranura de mazmorra de Great Vault por completar ocho.",

	MPLUS_KICK_HEADER = "Lanzamientos de interrupción obligatoria (por mazmorra)",
	MPLUS_KICK_NOTE = "Los grandes a vigilar — nombres confirmados de las guías, confirmar en el juego. Se añaden más mazmorras a medida que verificamos sus listas de lanzamientos.",
	MPLUS_KICK_MAISARA = "Maisara Caverns (la más dura del pool): kickea Hex (Ritual Hexxer), Reanimation (Reanimated Warrior — cada lanzamiento, o es un wipe) y Shrink (Umbral Shadowbinder). En Rak'tul, interrumpe cada Malignant Soul en el puente.",
	MPLUS_KICK_MAGISTERS = "Magisters' Terrace: los jefes no tienen nada que interrumpir — es todo trash. Prioridad de kick {SPELL:468966} (Arcane Magister — convierte a un jugador en oveja) > {SPELL:1254294} (Blazing Pyromancer) > {SPELL:1264693} (Void Terror).",
	MPLUS_KICK_NEXUSPOINT = "Nexus-Point Xenas: kickea {SPELL:1250553} en Chief Corewright Kasreth, y en el trash {SPELL:1258681} (Grand Nullifier) > {SPELL:1271094} (Nexus Adept) > {SPELL:1263892} (Lightwrought). En el {SPELL:1257595} de Lothraxion, interrumpe la sombra SIN cuernos — kickear la equivocada perjudica al grupo.",
	MPLUS_KICK_WINDRUNNER = "Windrunner Spire: kickea Chain Lightning (Phantasmal Mystic — también detiene su buff de celeridad), Spirit Bolt (Restless Steward), Poison Blades (Ardent Cutthroat) y Fungal Bolt (Bloated Lasher). (Los Spell IDs aún no están datamineados — confirmar en el juego.)",
	MPLUS_KICK_PITOFSARON = "Pit of Saron: la prioridad de kick es {SPELL:1271074} (Dreadpulse Lich) > {SPELL:473657} (Gloombound Shadebringer) > {SPELL:1278893} (Krick). En Garfrost, rompe la línea de visión hacia {SPELL:1262029} detrás de un Ore Chunk.",
	MPLUS_KICK_ALGETHAR = "Algeth'ar Academy: interrumpe {SPELL:396640} (Ancient Branch) — cada lanzamiento, o es un wipe.",
	MPLUS_KICK_TRIUMVIRATE = "Seat of the Triumvirate: el kick prioritario es {SPELL:248831} (Shadewing).",
	MPLUS_KICK_SKYREACH = "Skyreach: el kick prioritario es {SPELL:1255377} (Driving Gale-Caller).",
})

merge(ns._mhLocales and ns._mhLocales.ptBR, {
	MPLUS_VIEW = "Mythic+",
	MPLUS_HEADER = "Mythic+ — Temporada 1",
	MPLUS_HEADER_S2 = "Mythic+ — Temporada 2",
	MPLUS_INTRO = "Como as chaves funcionam nesta temporada: os afixos, o pool de 8 masmorras e as conjurações que você precisa interromper. Escrito com base na visão geral do Wowhead e no method.gg — confirmar no jogo.",

	MPLUS_AFFIX_HEADER = "O que entra em ação em cada nível de chave",
	MPLUS_AFFIX_UNMEASURED = "A Temporada 2 mudou os afixos das keystones e o Midnight Helper ainda não mediu os novos. A lista que estava aqui era a da Temporada 1, e mostrá-la sob um título de Temporada 2 seria pior do que não mostrar nada. O grupo de masmorras abaixo está atualizado.",
	MPLUS_AFFIX_LINDORMI = "Lindormi's Guidance — marca e enfraquece certos inimigos (Temporal Sands), e remove a penalidade de morte. Uma ajuda enquanto você aprende as masmorras.",
	MPLUS_AFFIX_BARGAIN = "Xal'atath's Bargain — uma das quatro variantes semanais de \"beijo-maldição\" está ativa (veja abaixo). Vai de +5 a +11.",
	MPLUS_AFFIX_LINDOFF = "Lindormi's Guidance cai — daqui para cima não há mais clemência na penalidade de morte.",
	MPLUS_AFFIX_TYRFORT = "Tyrannical OU Fortified (alterna semanalmente). Tyrannical: os chefes têm mais vida e batem mais forte. Fortified: o trash tem mais vida e bate mais forte.",
	MPLUS_AFFIX_BOTH = "Tyrannical E Fortified estão ambos ativos, toda semana, daqui para cima.",
	MPLUS_AFFIX_GUILE = "Xal'atath's Guile substitui o Bargain — cada morte agora também subtrai 15 seconds do cronômetro (e esse tempo não volta).",

	MPLUS_BARGAIN_HEADER = "Xal'atath's Bargain — esta semana é uma destas quatro",
	MPLUS_BARGAIN_ASCENDANT = "Ascendant — os orbes conjuram {SPELL:461904}; pare-os (interrupção / CC / dissipação) para um buff de velocidade e presteza do grupo, ou são os mobs que recebem o buff.",
	MPLUS_BARGAIN_VOIDBOUND = "Voidbound — um Void Emissary fortalece os mobs com {SPELL:462508}; mate-o para mais taxa de recarga e versatilidade, ou os mobs próximos ficam mais fortes.",
	MPLUS_BARGAIN_PULSAR = "Pulsar — soake {SPELL:1216815} antes que expire para um buff de maestria e roubo de vida; falhe e os mobs ganham dano e redução de dano.",
	MPLUS_BARGAIN_DEVOUR = "Devour — {SPELL:440313} coloca um escudo + lentidão sobre os cinco; limpe-o com cura ou qualquer dissipação para um buff de {SPELL:465136}, ou os mobs se curam.",

	MPLUS_POOL_HEADER = "As 8 masmorras desta temporada",
	MPLUS_POOL_NOTE = "Normal e Seguidor usam todas as masmorras de lançamento; Heroico, Mítico 0 e Mythic+ usam este pool. Abra qualquer masmorra na aba Dungeon Coach para os passos por chefe.",

	MPLUS_SYSTEM_HEADER = "Bom saber",
	MPLUS_SYSTEM = "• As chaves começam em +2 (não em +4 como antes).|n• Resilient Keystones: cronometre todas as 8 masmorras em +12 e sua chave nunca cai abaixo de +12 em uma depleção (e escala para cima a partir daí).|n• As Dungeon Waystones são checkpoints no meio do run — jogadores mortos renascem no último que você desbloqueou.|n• O loot e os brasões escalam com o nível de chave: brasões de nível Champion em chaves baixas até Myth Crest em +10 e acima, mais um slot de masmorra do Great Vault por completar oito.",

	MPLUS_KICK_HEADER = "Conjurações de interrupção obrigatória (por masmorra)",
	MPLUS_KICK_NOTE = "As grandes para ficar de olho — nomes confirmados pelos guias, confirmar no jogo. Mais masmorras são adicionadas conforme verificamos suas listas de conjurações.",
	MPLUS_KICK_MAISARA = "Maisara Caverns (a mais difícil do pool): kicke Hex (Ritual Hexxer), Reanimation (Reanimated Warrior — cada conjuração, ou é um wipe) e Shrink (Umbral Shadowbinder). No Rak'tul, interrompa cada Malignant Soul na ponte.",
	MPLUS_KICK_MAGISTERS = "Magisters' Terrace: os chefes não têm nada para interromper — é tudo trash. Prioridade de kick {SPELL:468966} (Arcane Magister — transforma um jogador em ovelha) > {SPELL:1254294} (Blazing Pyromancer) > {SPELL:1264693} (Void Terror).",
	MPLUS_KICK_NEXUSPOINT = "Nexus-Point Xenas: kicke {SPELL:1250553} no Chief Corewright Kasreth, e no trash {SPELL:1258681} (Grand Nullifier) > {SPELL:1271094} (Nexus Adept) > {SPELL:1263892} (Lightwrought). No {SPELL:1257595} do Lothraxion, interrompa a sombra SEM chifres — kickar a errada prejudica o grupo.",
	MPLUS_KICK_WINDRUNNER = "Windrunner Spire: kicke Chain Lightning (Phantasmal Mystic — também interrompe seu buff de presteza), Spirit Bolt (Restless Steward), Poison Blades (Ardent Cutthroat) e Fungal Bolt (Bloated Lasher). (Spell IDs ainda não dataminados — confirmar no jogo.)",
	MPLUS_KICK_PITOFSARON = "Pit of Saron: a prioridade de kick é {SPELL:1271074} (Dreadpulse Lich) > {SPELL:473657} (Gloombound Shadebringer) > {SPELL:1278893} (Krick). No Garfrost, quebre a linha de visão para {SPELL:1262029} atrás de um Ore Chunk.",
	MPLUS_KICK_ALGETHAR = "Algeth'ar Academy: interrompa {SPELL:396640} (Ancient Branch) — cada conjuração, ou é um wipe.",
	MPLUS_KICK_TRIUMVIRATE = "Seat of the Triumvirate: o kick prioritário é {SPELL:248831} (Shadewing).",
	MPLUS_KICK_SKYREACH = "Skyreach: o kick prioritário é {SPELL:1255377} (Driving Gale-Caller).",
})

--------------------------------------------------------------------------------
-- Beginnersmodus + woordenboek (Rob 15 jun, voor zijn zus): rustige, gewone-taal
-- laag. Apart merge-blok per taal zodat het naast de expert-tekst leeft.
--------------------------------------------------------------------------------

merge(ns._mhLocales and ns._mhLocales.enUS, {
	MPLUS_BEGINNER_BTN_ON = "Beginner mode is ON — click here for the full version",
	MPLUS_BEGINNER_BTN_OFF = "Beginner mode is OFF — click here for the simple version",
	MPLUS_BEGINNER_INTRO = "A \"key\" (keystone) is just a dungeon on a harder setting with a timer. You do NOT have to start there. There's no rush and nothing wrong with going slow — almost everyone learns a dungeon first and pushes later.",
	MPLUS_BEGINNER_START = "Start here: run the dungeon on Follower or Normal first. No timer, dying doesn't fail anything, and you go at your own pace. When it feels easy, try Heroic, then Mythic 0 (still no timer), and only then a +2 key.",
	MPLUS_GLOSSARY_HEADER = "Words you'll hear (in plain language)",
	MPLUS_GLOSS_KEY = "Key / Keystone — a dungeon on a harder setting with a timer. A higher number means harder.",
	MPLUS_GLOSS_AFFIX = "Affix — an extra rule that makes the dungeon harder. New ones switch on at certain key levels.",
	MPLUS_GLOSS_PULL = "Pull — walking up to enemies to start the fight. The tank usually decides when.",
	MPLUS_GLOSS_KICK = "Kick / Interrupt — your interrupt button stops an enemy mid-cast. Use it on the casts marked important.",
	MPLUS_GLOSS_SOAK = "Soak — stand in a marked circle on purpose to absorb something so it doesn't hurt the group.",
	MPLUS_GLOSS_TANK = "Tank — holds the enemies and faces them away from everyone. Stand behind them.",
	MPLUS_GLOSS_HEALER = "Healer — keeps everyone alive. Stay close enough that they can reach you.",
	MPLUS_GLOSS_DPS = "DPS — deals damage. Most players are DPS; your job is damage plus dodging stuff on the floor.",
	MPLUS_GLOSS_AGGRO = "Aggro / Threat — who an enemy is attacking. If it's chasing you, run to the tank.",
	MPLUS_GLOSS_CC = "CC (crowd control) — stun, freeze or sleep an enemy so it can't act for a moment.",
	MPLUS_GLOSS_DISPEL = "Dispel — remove a harmful effect from a player (or a helpful one from an enemy).",
	MPLUS_GLOSS_WIPE = "Wipe — the whole group dies and you try again. It happens to everyone; just reset and go again.",
	MPLUS_GLOSS_ILVL = "Item level (ilvl) — a number on gear showing how strong it is. Higher is usually better.",
	MPLUS_GLOSS_BIS = "BiS (best in slot) — the best possible item for a gear slot. \"That trinket is BiS\" means nothing beats it there.",
	MPLUS_GLOSS_PROC = "Proc — a bonus effect that triggers at random from a spell or item. Free value when it lights up, so use it.",
	MPLUS_GLOSS_UPTIME = "Uptime — how much of the fight an effect or buff is active. Higher uptime on your key buffs is better.",
	MPLUS_GLOSS_VAULT = "Vault slot — a reward choice in the Great Vault. Finish activities during the week to unlock more slots to pick from.",

	MPLUS_WEEK_HEADER = "This week, just for you",
	MPLUS_WEEK_BODY = "• Open the group finder and pick a dungeon on Follower or Normal.|n• There's no timer and you cannot \"fail\" — take all the time you need.|n• You can leave at any point; nothing is lost.|n• Dying is normal and costs nothing here — just walk back and carry on.|n• Want the steps for each boss? Open the Dungeon Coach tab.",
	MPLUS_WEEK_AVOID = "If you want the calmest first run, save Maisara Caverns for later — it's the toughest of the eight. Any of the others is gentler to start with.",
	MPLUS_WEEK_BONUS_FMT = "Bonus this week: %s is the dungeon of the week — extra reputation when you run it.",

	-- Toegankelijke meldingen (idee 2): UI-labels + runtime-teksten.
	ALERT_HELP_HEADER = "Extra help during dungeons",
	ALERT_HELP = "Turn this on for ONE big, calm warning (with a sound) when YOU get a dangerous effect on yourself — a trap or a heavy debuff — so you know to react. One at a time, never a wall of warnings.",
	ALERT_DEBUFF_FMT = "%s — react!",
	ALERT_DEBUFF_DEVOURING_RIFT = "Devouring Rift on you — heal it off or dispel!",
	ALERT_BTN_ON = "Helper alerts are ON — click to turn off",
	ALERT_BTN_OFF = "Helper alerts are OFF — click to turn on",
	ALERT_TEST_BTN = "Show me a test alert",
	ALERT_INTERRUPT_FMT = "Interrupt!|n%s",
	ALERT_TEST = "Test — this is what a warning looks like",
	ALERT_ENABLED_MSG = "Helper alerts on — I'll flash one big warning when you get a dangerous debuff to react to.",
	ALERT_DISABLED_MSG = "Helper alerts off.",
})

merge(ns._mhLocales and ns._mhLocales.itIT, {
	MPLUS_BEGINNER_BTN_ON = "La modalità principiante è ATTIVA — clicca qui per la versione completa",
	MPLUS_BEGINNER_BTN_OFF = "La modalità principiante è DISATTIVA — clicca qui per la versione semplice",
	MPLUS_BEGINNER_INTRO = "Una \"key\" (keystone) è semplicemente un dungeon a un'impostazione più difficile con un timer. NON devi per forza iniziare da lì. Non c'è fretta e non c'è nulla di male nel fare con calma — quasi tutti imparano prima un dungeon e fanno push più avanti.",
	MPLUS_BEGINNER_START = "Inizia da qui: fai prima il dungeon in Follower o Normal. Niente timer, morire non fa fallire nulla, e vai al tuo ritmo. Quando lo senti facile, prova Heroic, poi Mythic 0 (sempre senza timer), e solo dopo una +2 key.",
	MPLUS_GLOSSARY_HEADER = "Parole che sentirai (in parole semplici)",
	MPLUS_GLOSS_KEY = "Key / Keystone — un dungeon a un'impostazione più difficile con un timer. Un numero più alto significa più difficile.",
	MPLUS_GLOSS_AFFIX = "Affix — una regola in più che rende il dungeon più difficile. Ne arrivano di nuove a certi livelli di key.",
	MPLUS_GLOSS_PULL = "Pull — avvicinarsi ai nemici per iniziare il combattimento. Di solito decide il tank quando.",
	MPLUS_GLOSS_KICK = "Kick / Interrupt — il tuo pulsante di interrupt ferma un nemico a metà cast. Usalo sui cast segnati come importanti.",
	MPLUS_GLOSS_SOAK = "Soak — mettersi apposta in un cerchio segnato per assorbire qualcosa, così non fa male al gruppo.",
	MPLUS_GLOSS_TANK = "Tank — tiene i nemici e li gira lontano da tutti. Stai dietro di lui.",
	MPLUS_GLOSS_HEALER = "Healer — tiene tutti in vita. Resta abbastanza vicino perché possa raggiungerti.",
	MPLUS_GLOSS_DPS = "DPS — infligge danni. La maggior parte dei giocatori è DPS; il tuo compito è fare danni e schivare le cose a terra.",
	MPLUS_GLOSS_AGGRO = "Aggro / Threat — chi sta attaccando un nemico. Se ti insegue, corri dal tank.",
	MPLUS_GLOSS_CC = "CC (crowd control) — stordire, congelare o addormentare un nemico così non può agire per un momento.",
	MPLUS_GLOSS_DISPEL = "Dispel — rimuovere un effetto dannoso da un giocatore (o uno benefico da un nemico).",
	MPLUS_GLOSS_WIPE = "Wipe — tutto il gruppo muore e si riprova. Capita a tutti; basta ripartire e riprovare.",
	MPLUS_GLOSS_ILVL = "Livello oggetto (ilvl) — un numero sull'equipaggiamento che indica quanto è forte. Più alto di solito è meglio.",
	MPLUS_GLOSS_BIS = "BiS (best in slot) — il miglior oggetto possibile per uno slot di equipaggiamento. \"Quel gingillo è BiS\" significa che lì niente lo batte.",
	MPLUS_GLOSS_PROC = "Proc — un effetto bonus che si attiva a caso da una magia o un oggetto. Valore gratis quando si accende, quindi usalo.",
	MPLUS_GLOSS_UPTIME = "Uptime — quanta parte del combattimento un effetto o buff è attivo. Più uptime sui tuoi buff chiave è meglio.",
	MPLUS_GLOSS_VAULT = "Slot del forziere — una scelta di ricompensa nel Grande Forziere. Fai attività durante la settimana per sbloccare più slot.",

	MPLUS_WEEK_HEADER = "Questa settimana, solo per te",
	MPLUS_WEEK_BODY = "• Apri il cerca gruppo e scegli un dungeon in Follower o Normal.|n• Non c'è timer e non puoi \"fallire\" — prenditi tutto il tempo che ti serve.|n• Puoi uscire in qualsiasi momento; non si perde nulla.|n• Morire è normale e qui non costa niente — torna indietro a piedi e continua.|n• Vuoi i passaggi per ogni boss? Apri la scheda Dungeon Coach.",
	MPLUS_WEEK_AVOID = "Se vuoi la prima run più tranquilla, lascia Maisara Caverns per dopo — è il più tosto degli otto. Qualsiasi altro è più dolce per iniziare.",
	MPLUS_WEEK_BONUS_FMT = "Bonus di questa settimana: %s è il dungeon della settimana — reputazione extra quando lo fai.",

	ALERT_HELP_HEADER = "Aiuto extra durante i dungeon",
	ALERT_HELP = "Attiva questo per UN solo avviso grande e tranquillo (con un suono) quando SEI TU a ricevere un effetto pericoloso — una trappola o un debuff pesante — così sai che devi reagire. Uno alla volta, mai un muro di avvisi.",
	ALERT_DEBUFF_FMT = "%s — reagisci!",
	ALERT_DEBUFF_DEVOURING_RIFT = "Devouring Rift su di te — curatelo via o fai dispel!",
	ALERT_BTN_ON = "Gli avvisi Helper sono ATTIVI — clicca per disattivare",
	ALERT_BTN_OFF = "Gli avvisi Helper sono DISATTIVI — clicca per attivare",
	ALERT_TEST_BTN = "Mostrami un avviso di prova",
	ALERT_INTERRUPT_FMT = "Interrupt!|n%s",
	ALERT_TEST = "Prova — ecco come appare un avviso",
	ALERT_ENABLED_MSG = "Avvisi Helper attivi — farò lampeggiare un grande avviso quando ricevi un debuff pericoloso a cui reagire.",
	ALERT_DISABLED_MSG = "Avvisi Helper disattivati.",
})

merge(ns._mhLocales and ns._mhLocales.nlNL, {
	MPLUS_BEGINNER_BTN_ON = "Beginnersmodus staat AAN — klik hier voor de volledige versie",
	MPLUS_BEGINNER_BTN_OFF = "Beginnersmodus staat UIT — klik hier voor de eenvoudige versie",
	MPLUS_BEGINNER_INTRO = "Een \"key\" (keystone) is gewoon een dungeon op een zwaardere stand met een klok erbij. Je hoeft daar niet te beginnen. Er is geen haast en het is helemaal prima om rustig te doen — bijna iedereen leert eerst een dungeon kennen en gaat later pas omhoog.",
	MPLUS_BEGINNER_START = "Begin hier: doe de dungeon eerst op Follower of Normal. Geen klok, doodgaan maakt niets stuk, en je gaat op je eigen tempo. Als het makkelijk voelt, probeer dan Heroic, daarna Mythic 0 (nog steeds geen klok), en pas daarna een +2 key.",
	MPLUS_GLOSSARY_HEADER = "Woorden die je gaat horen (in gewone taal)",
	MPLUS_GLOSS_KEY = "Key / Keystone — een dungeon op een zwaardere stand met een klok. Een hoger getal betekent zwaarder.",
	MPLUS_GLOSS_AFFIX = "Affix — een extra regel die de dungeon zwaarder maakt. Nieuwe komen erbij op bepaalde key-niveaus.",
	MPLUS_GLOSS_PULL = "Pull — naar vijanden toe lopen om het gevecht te starten. Meestal bepaalt de tank wanneer.",
	MPLUS_GLOSS_KICK = "Kick / Interrupt — met je interrupt-knop stop je een vijand midden in een spreuk. Gebruik hem bij de spreuken die belangrijk zijn.",
	MPLUS_GLOSS_SOAK = "Soak — ga met opzet in een gemarkeerde cirkel staan om iets op te vangen, zodat de groep er geen last van heeft.",
	MPLUS_GLOSS_TANK = "Tank — houdt de vijanden vast en draait ze van iedereen weg. Ga achter de tank staan.",
	MPLUS_GLOSS_HEALER = "Healer — houdt iedereen in leven. Blijf dichtbij genoeg zodat ze je kunnen bereiken.",
	MPLUS_GLOSS_DPS = "DPS — doet schade. De meeste spelers zijn DPS; jouw taak is schade doen en dingen op de grond ontwijken.",
	MPLUS_GLOSS_AGGRO = "Aggro / Threat — wie een vijand aanvalt. Word jij achtervolgd, ren dan naar de tank.",
	MPLUS_GLOSS_CC = "CC (crowd control) — een vijand stunnen, bevriezen of in slaap brengen, zodat hij even niets kan doen.",
	MPLUS_GLOSS_DISPEL = "Dispel — een schadelijk effect van een speler weghalen (of een gunstig effect van een vijand).",
	MPLUS_GLOSS_WIPE = "Wipe — de hele groep gaat dood en je probeert het opnieuw. Het overkomt iedereen; gewoon herstarten en weer gaan.",
	MPLUS_GLOSS_ILVL = "Item level (ilvl) — een getal op gear dat aangeeft hoe sterk het is. Hoger is meestal beter.",
	MPLUS_GLOSS_BIS = "BiS (best in slot) — het best mogelijke voorwerp voor een uitrustingsplek. \"Die trinket is BiS\" betekent dat niets het daar verslaat.",
	MPLUS_GLOSS_PROC = "Proc — een bonuseffect dat willekeurig afgaat door een spreuk of voorwerp. Gratis waarde als het oplicht, dus gebruik het.",
	MPLUS_GLOSS_UPTIME = "Uptime — hoeveel van het gevecht een effect of buff actief is. Meer uptime op je belangrijke buffs is beter.",
	MPLUS_GLOSS_VAULT = "Vault-slot — een beloningskeuze in de Grote Kluis (Great Vault). Doe activiteiten door de week om meer slots te ontgrendelen.",

	MPLUS_WEEK_HEADER = "Deze week, speciaal voor jou",
	MPLUS_WEEK_BODY = "• Open de groepzoeker en kies een dungeon op Follower of Normal.|n• Er is geen klok en je kunt niet \"falen\" — neem alle tijd die je nodig hebt.|n• Je mag op elk moment weggaan; er gaat niets verloren.|n• Doodgaan is normaal en kost hier niets — loop gewoon terug en ga door.|n• Wil je de stappen voor elke boss? Open het tabblad Dungeon Coach.",
	MPLUS_WEEK_AVOID = "Wil je een zo rustig mogelijke eerste keer, bewaar Maisara Caverns dan voor later — dat is de zwaarste van de acht. Elk van de andere is wat zachter om mee te beginnen.",
	MPLUS_WEEK_BONUS_FMT = "Bonus deze week: %s is de dungeon van de week — extra reputatie als je hem doet.",

	ALERT_HELP_HEADER = "Extra hulp tijdens dungeons",
	ALERT_HELP = "Zet dit aan voor ÉÉN grote, rustige waarschuwing (met een geluidje) als JIJ zelf een gevaarlijk effect op je krijgt — een val of een zware debuff — zodat je weet dat je moet reageren. Steeds maar één tegelijk, nooit een muur vol waarschuwingen.",
	ALERT_DEBUFF_FMT = "%s — reageer!",
	ALERT_DEBUFF_DEVOURING_RIFT = "Devouring Rift op jou — heal het weg of dispel het!",
	ALERT_BTN_ON = "Helper-meldingen staan AAN — klik om uit te zetten",
	ALERT_BTN_OFF = "Helper-meldingen staan UIT — klik om aan te zetten",
	ALERT_TEST_BTN = "Laat me een testmelding zien",
	ALERT_INTERRUPT_FMT = "Interrupt!|n%s",
	ALERT_TEST = "Test — zo ziet een waarschuwing eruit",
	ALERT_ENABLED_MSG = "Helper-meldingen aan — ik laat één grote waarschuwing zien als je een gevaarlijke debuff krijgt waar je op moet reageren.",
	ALERT_DISABLED_MSG = "Helper-meldingen uit.",
})

merge(ns._mhLocales and ns._mhLocales.deDE, {
	MPLUS_BEGINNER_BTN_ON = "Anfängermodus ist AN — hier klicken für die vollständige Version",
	MPLUS_BEGINNER_BTN_OFF = "Anfängermodus ist AUS — hier klicken für die einfache Version",
	MPLUS_BEGINNER_INTRO = "Ein \"key\" (Keystone) ist einfach ein Dungeon auf einer schwereren Stufe mit einer Uhr. Du musst dort nicht anfangen. Es gibt keine Eile, und es ist völlig in Ordnung, langsam zu machen — fast alle lernen erst einen Dungeon kennen und steigern sich später.",
	MPLUS_BEGINNER_START = "Fang hier an: Mach den Dungeon zuerst auf Follower oder Normal. Keine Uhr, Sterben macht nichts kaputt, und du gehst in deinem eigenen Tempo. Wenn es sich leicht anfühlt, probier Heroic, dann Mythic 0 (immer noch keine Uhr), und erst danach einen +2 key.",
	MPLUS_GLOSSARY_HEADER = "Wörter, die du hören wirst (in einfacher Sprache)",
	MPLUS_GLOSS_KEY = "Key / Keystone — ein Dungeon auf einer schwereren Stufe mit einer Uhr. Eine höhere Zahl bedeutet schwerer.",
	MPLUS_GLOSS_AFFIX = "Affix — eine zusätzliche Regel, die den Dungeon schwerer macht. Neue kommen auf bestimmten Key-Stufen dazu.",
	MPLUS_GLOSS_PULL = "Pull — zu den Gegnern hingehen, um den Kampf zu starten. Meistens entscheidet der Tank, wann.",
	MPLUS_GLOSS_KICK = "Kick / Interrupt — mit deiner Unterbrechen-Taste stoppst du einen Gegner mitten im Zauber. Nutz sie bei den Zaubern, die wichtig sind.",
	MPLUS_GLOSS_SOAK = "Soak — stell dich mit Absicht in einen markierten Kreis, um etwas aufzufangen, damit es der Gruppe nicht schadet.",
	MPLUS_GLOSS_TANK = "Tank — hält die Gegner fest und dreht sie von allen weg. Stell dich hinter den Tank.",
	MPLUS_GLOSS_HEALER = "Healer — hält alle am Leben. Bleib nah genug, damit er dich erreichen kann.",
	MPLUS_GLOSS_DPS = "DPS — macht Schaden. Die meisten Spieler sind DPS; deine Aufgabe ist Schaden machen und Sachen am Boden ausweichen.",
	MPLUS_GLOSS_AGGRO = "Aggro / Threat — wen ein Gegner angreift. Wenn er dich verfolgt, lauf zum Tank.",
	MPLUS_GLOSS_CC = "CC (crowd control) — einen Gegner betäuben, einfrieren oder einschläfern, damit er einen Moment nichts tun kann.",
	MPLUS_GLOSS_DISPEL = "Dispel — einen schädlichen Effekt von einem Spieler entfernen (oder einen hilfreichen von einem Gegner).",
	MPLUS_GLOSS_WIPE = "Wipe — die ganze Gruppe stirbt und ihr versucht es noch mal. Das passiert jedem; einfach neu anfangen und weiter geht's.",
	MPLUS_GLOSS_ILVL = "Gegenstandsstufe (ilvl) — eine Zahl auf Ausrüstung, die zeigt, wie stark sie ist. Höher ist meist besser.",
	MPLUS_GLOSS_BIS = "BiS (best in slot) — der bestmögliche Gegenstand für einen Ausrüstungsplatz. \"Das Schmuckstück ist BiS\" heißt, nichts ist dort besser.",
	MPLUS_GLOSS_PROC = "Proc — ein Bonuseffekt, der zufällig von einem Zauber oder Gegenstand auslöst. Gratis-Wert, wenn er aufleuchtet, also nutze ihn.",
	MPLUS_GLOSS_UPTIME = "Uptime — wie viel vom Kampf ein Effekt oder Buff aktiv ist. Mehr Uptime auf deinen wichtigen Buffs ist besser.",
	MPLUS_GLOSS_VAULT = "Vault-Slot — eine Belohnungswahl in der Großen Schatzkammer. Erledige unter der Woche Aktivitäten, um mehr Slots freizuschalten.",

	MPLUS_WEEK_HEADER = "Diese Woche, nur für dich",
	MPLUS_WEEK_BODY = "• Öffne die Gruppensuche und wähl einen Dungeon auf Follower oder Normal.|n• Es gibt keine Uhr und du kannst nicht \"versagen\" — nimm dir alle Zeit, die du brauchst.|n• Du kannst jederzeit gehen; nichts geht verloren.|n• Sterben ist normal und kostet hier nichts — lauf einfach zurück und mach weiter.|n• Willst du die Schritte für jeden Boss? Öffne den Tab Dungeon Coach.",
	MPLUS_WEEK_AVOID = "Wenn du einen möglichst ruhigen ersten Lauf willst, heb dir Maisara Caverns für später auf — er ist der schwerste der acht. Jeder der anderen ist sanfter für den Anfang.",
	MPLUS_WEEK_BONUS_FMT = "Bonus diese Woche: %s ist der Dungeon der Woche — extra Ruf, wenn du ihn machst.",

	ALERT_HELP_HEADER = "Extra Hilfe in Dungeons",
	ALERT_HELP = "Schalte das ein für EINE große, ruhige Warnung (mit einem Ton), wenn DU selbst einen gefährlichen Effekt bekommst — eine Falle oder einen schweren Debuff — damit du weißt, dass du reagieren musst. Immer nur eine auf einmal, nie eine ganze Wand voller Warnungen.",
	ALERT_DEBUFF_FMT = "%s — reagier!",
	ALERT_DEBUFF_DEVOURING_RIFT = "Devouring Rift auf dir — heil ihn weg oder dispel ihn!",
	ALERT_BTN_ON = "Helper-Warnungen sind AN — zum Ausschalten klicken",
	ALERT_BTN_OFF = "Helper-Warnungen sind AUS — zum Einschalten klicken",
	ALERT_TEST_BTN = "Zeig mir eine Testwarnung",
	ALERT_INTERRUPT_FMT = "Interrupt!|n%s",
	ALERT_TEST = "Test — so sieht eine Warnung aus",
	ALERT_ENABLED_MSG = "Helper-Warnungen an — ich zeige eine große Warnung, wenn du einen gefährlichen Debuff bekommst, auf den du reagieren musst.",
	ALERT_DISABLED_MSG = "Helper-Warnungen aus.",
})

merge(ns._mhLocales and ns._mhLocales.frFR, {
	MPLUS_BEGINNER_BTN_ON = "Le mode débutant est ACTIVÉ — clique ici pour la version complète",
	MPLUS_BEGINNER_BTN_OFF = "Le mode débutant est DÉSACTIVÉ — clique ici pour la version simple",
	MPLUS_BEGINNER_INTRO = "Une \"key\" (keystone), c'est juste un donjon dans un réglage plus difficile avec un chrono. Tu n'es pas obligé(e) de commencer là. Rien ne presse et ce n'est pas grave d'y aller doucement — presque tout le monde apprend d'abord un donjon et monte plus tard.",
	MPLUS_BEGINNER_START = "Commence ici : fais le donjon d'abord en Follower ou en Normal. Pas de chrono, mourir ne casse rien, et tu vas à ton rythme. Quand ça te semble facile, essaie Heroic, puis Mythic 0 (toujours sans chrono), et seulement après une +2 key.",
	MPLUS_GLOSSARY_HEADER = "Des mots que tu vas entendre (en mots simples)",
	MPLUS_GLOSS_KEY = "Key / Keystone — un donjon dans un réglage plus difficile avec un chrono. Un chiffre plus élevé veut dire plus dur.",
	MPLUS_GLOSS_AFFIX = "Affix — une règle en plus qui rend le donjon plus difficile. De nouvelles arrivent à certains niveaux de key.",
	MPLUS_GLOSS_PULL = "Pull — aller vers les ennemis pour lancer le combat. C'est en général le tank qui décide quand.",
	MPLUS_GLOSS_KICK = "Kick / Interrupt — ton bouton d'interruption arrête un ennemi au milieu d'un sort. Utilise-le sur les sorts marqués comme importants.",
	MPLUS_GLOSS_SOAK = "Soak — se placer exprès dans un cercle marqué pour absorber quelque chose, pour que ça ne fasse pas mal au groupe.",
	MPLUS_GLOSS_TANK = "Tank — garde les ennemis et les tourne loin de tout le monde. Place-toi derrière lui.",
	MPLUS_GLOSS_HEALER = "Healer — garde tout le monde en vie. Reste assez près pour qu'il puisse t'atteindre.",
	MPLUS_GLOSS_DPS = "DPS — fait des dégâts. La plupart des joueurs sont DPS ; ton rôle, c'est faire des dégâts et éviter les choses au sol.",
	MPLUS_GLOSS_AGGRO = "Aggro / Threat — qui un ennemi attaque. S'il te court après, cours vers le tank.",
	MPLUS_GLOSS_CC = "CC (crowd control) — étourdir, geler ou endormir un ennemi pour qu'il ne puisse rien faire un moment.",
	MPLUS_GLOSS_DISPEL = "Dispel — retirer un effet néfaste sur un joueur (ou un effet utile sur un ennemi).",
	MPLUS_GLOSS_WIPE = "Wipe — tout le groupe meurt et vous recommencez. Ça arrive à tout le monde ; on relance et on repart.",
	MPLUS_GLOSS_ILVL = "Niveau d'objet (ilvl) — un nombre sur l'équipement indiquant sa puissance. Plus haut, c'est généralement mieux.",
	MPLUS_GLOSS_BIS = "BiS (best in slot) — le meilleur objet possible pour un emplacement d'équipement. \"Ce bijou est BiS\" veut dire que rien n'est mieux à cet endroit.",
	MPLUS_GLOSS_PROC = "Proc — un effet bonus qui se déclenche au hasard d'un sort ou d'un objet. Valeur gratuite quand il s'active, alors utilise-le.",
	MPLUS_GLOSS_UPTIME = "Uptime — la part du combat où un effet ou buff est actif. Plus d'uptime sur tes buffs clés, c'est mieux.",
	MPLUS_GLOSS_VAULT = "Emplacement de coffre — un choix de récompense dans la Grande chambre forte. Fais des activités dans la semaine pour débloquer plus d'emplacements.",

	MPLUS_WEEK_HEADER = "Cette semaine, rien que pour toi",
	MPLUS_WEEK_BODY = "• Ouvre l'outil de groupe et choisis un donjon en Follower ou en Normal.|n• Il n'y a pas de chrono et tu ne peux pas \"échouer\" — prends tout le temps qu'il te faut.|n• Tu peux partir à tout moment ; rien n'est perdu.|n• Mourir est normal et ne coûte rien ici — reviens à pied et continue.|n• Tu veux les étapes pour chaque boss ? Ouvre l'onglet Dungeon Coach.",
	MPLUS_WEEK_AVOID = "Si tu veux le premier passage le plus tranquille, garde Maisara Caverns pour plus tard — c'est le plus dur des huit. N'importe lequel des autres est plus doux pour commencer.",
	MPLUS_WEEK_BONUS_FMT = "Bonus cette semaine : %s est le donjon de la semaine — réputation en plus quand tu le fais.",

	ALERT_HELP_HEADER = "De l'aide en plus pendant les donjons",
	ALERT_HELP = "Active ça pour UNE seule grande alerte, toute calme (avec un son), quand TOI tu reçois un effet dangereux sur toi — un piège ou un gros debuff — pour que tu saches qu'il faut réagir. Une à la fois, jamais un mur d'alertes.",
	ALERT_DEBUFF_FMT = "%s — réagis !",
	ALERT_DEBUFF_DEVOURING_RIFT = "Devouring Rift sur toi — heal-le ou dispel-le !",
	ALERT_BTN_ON = "Les alertes Helper sont ACTIVÉES — clique pour désactiver",
	ALERT_BTN_OFF = "Les alertes Helper sont DÉSACTIVÉES — clique pour activer",
	ALERT_TEST_BTN = "Montre-moi une alerte de test",
	ALERT_INTERRUPT_FMT = "Interrupt!|n%s",
	ALERT_TEST = "Test — voilà à quoi ressemble une alerte",
	ALERT_ENABLED_MSG = "Alertes Helper activées — je ferai apparaître une grande alerte quand tu reçois un debuff dangereux auquel réagir.",
	ALERT_DISABLED_MSG = "Alertes Helper désactivées.",
})

merge(ns._mhLocales and ns._mhLocales.esES, {
	MPLUS_BEGINNER_BTN_ON = "El modo principiante está ACTIVADO — haz clic aquí para la versión completa",
	MPLUS_BEGINNER_BTN_OFF = "El modo principiante está DESACTIVADO — haz clic aquí para la versión sencilla",
	MPLUS_BEGINNER_INTRO = "Una \"key\" (keystone) es solo una mazmorra en un ajuste más difícil con un reloj. No tienes que empezar ahí. No hay prisa y no pasa nada por ir despacio — casi todo el mundo aprende primero una mazmorra y sube más adelante.",
	MPLUS_BEGINNER_START = "Empieza aquí: haz la mazmorra primero en Follower o Normal. Sin reloj, morir no estropea nada, y vas a tu propio ritmo. Cuando te resulte fácil, prueba Heroic, luego Mythic 0 (todavía sin reloj), y solo después una +2 key.",
	MPLUS_GLOSSARY_HEADER = "Palabras que vas a oír (en lenguaje sencillo)",
	MPLUS_GLOSS_KEY = "Key / Keystone — una mazmorra en un ajuste más difícil con un reloj. Un número más alto significa más difícil.",
	MPLUS_GLOSS_AFFIX = "Affix — una regla extra que hace la mazmorra más difícil. Aparecen nuevas en ciertos niveles de key.",
	MPLUS_GLOSS_PULL = "Pull — acercarse a los enemigos para empezar la pelea. Normalmente el tank decide cuándo.",
	MPLUS_GLOSS_KICK = "Kick / Interrupt — tu botón de interrupción para a un enemigo en mitad de un hechizo. Úsalo en los hechizos marcados como importantes.",
	MPLUS_GLOSS_SOAK = "Soak — ponerte a propósito en un círculo marcado para absorber algo, así no le hace daño al grupo.",
	MPLUS_GLOSS_TANK = "Tank — sujeta a los enemigos y los gira lejos de todos. Ponte detrás del tank.",
	MPLUS_GLOSS_HEALER = "Healer — mantiene a todos con vida. Quédate lo bastante cerca para que pueda alcanzarte.",
	MPLUS_GLOSS_DPS = "DPS — hace daño. La mayoría de los jugadores son DPS; tu trabajo es hacer daño y esquivar cosas en el suelo.",
	MPLUS_GLOSS_AGGRO = "Aggro / Threat — a quién está atacando un enemigo. Si te persigue a ti, corre hacia el tank.",
	MPLUS_GLOSS_CC = "CC (crowd control) — aturdir, congelar o dormir a un enemigo para que no pueda actuar un momento.",
	MPLUS_GLOSS_DISPEL = "Dispel — quitar un efecto dañino de un jugador (o uno beneficioso de un enemigo).",
	MPLUS_GLOSS_WIPE = "Wipe — todo el grupo muere y lo volvéis a intentar. Le pasa a todo el mundo; reinicias y vuelves a empezar.",
	MPLUS_GLOSS_ILVL = "Nivel de objeto (ilvl) — un número en el equipo que indica su poder. Más alto suele ser mejor.",
	MPLUS_GLOSS_BIS = "BiS (best in slot) — el mejor objeto posible para una ranura de equipo. \"Ese abalorio es BiS\" significa que nada lo supera ahí.",
	MPLUS_GLOSS_PROC = "Proc — un efecto extra que se activa al azar de un hechizo u objeto. Valor gratis cuando se enciende, así que úsalo.",
	MPLUS_GLOSS_UPTIME = "Uptime — cuánto del combate está activo un efecto o mejora. Más uptime en tus mejoras clave es mejor.",
	MPLUS_GLOSS_VAULT = "Ranura de cámara — una opción de recompensa en la Gran Cámara. Haz actividades durante la semana para desbloquear más ranuras.",

	MPLUS_WEEK_HEADER = "Esta semana, solo para ti",
	MPLUS_WEEK_BODY = "• Abre el buscador de grupos y elige una mazmorra en Follower o Normal.|n• No hay reloj y no puedes \"fallar\" — tómate todo el tiempo que necesites.|n• Puedes salir en cualquier momento; no se pierde nada.|n• Morir es normal y aquí no cuesta nada — solo vuelve andando y sigue.|n• ¿Quieres los pasos de cada jefe? Abre la pestaña Dungeon Coach.",
	MPLUS_WEEK_AVOID = "Si quieres la primera vez más tranquila, deja Maisara Caverns para más adelante — es la más difícil de las ocho. Cualquiera de las otras es más suave para empezar.",
	MPLUS_WEEK_BONUS_FMT = "Bonus esta semana: %s es la mazmorra de la semana — reputación extra cuando la haces.",

	ALERT_HELP_HEADER = "Ayuda extra durante las mazmorras",
	ALERT_HELP = "Activa esto para UN solo aviso grande y tranquilo (con un sonido) cuando TÚ recibes un efecto peligroso sobre ti — una trampa o un debuff fuerte — para que sepas que tienes que reaccionar. Solo uno cada vez, nunca un montón de avisos.",
	ALERT_DEBUFF_FMT = "%s — ¡reacciona!",
	ALERT_DEBUFF_DEVOURING_RIFT = "Devouring Rift sobre ti — ¡heal para quitarlo o haz dispel!",
	ALERT_BTN_ON = "Los avisos de Helper están ACTIVADOS — haz clic para desactivar",
	ALERT_BTN_OFF = "Los avisos de Helper están DESACTIVADOS — haz clic para activar",
	ALERT_TEST_BTN = "Muéstrame un aviso de prueba",
	ALERT_INTERRUPT_FMT = "Interrupt!|n%s",
	ALERT_TEST = "Prueba — así se ve un aviso",
	ALERT_ENABLED_MSG = "Avisos de Helper activados — mostraré un aviso grande cuando recibas un debuff peligroso al que reaccionar.",
	ALERT_DISABLED_MSG = "Avisos de Helper desactivados.",
})

merge(ns._mhLocales and ns._mhLocales.ptBR, {
	MPLUS_BEGINNER_BTN_ON = "O modo iniciante está LIGADO — clique aqui para a versão completa",
	MPLUS_BEGINNER_BTN_OFF = "O modo iniciante está DESLIGADO — clique aqui para a versão simples",
	MPLUS_BEGINNER_INTRO = "Uma \"key\" (keystone) é só uma masmorra num modo mais difícil com um relógio. Você não precisa começar por aí. Não tem pressa e não tem problema nenhum em ir devagar — quase todo mundo aprende a masmorra primeiro e sobe depois.",
	MPLUS_BEGINNER_START = "Comece por aqui: faça a masmorra primeiro no Follower ou no Normal. Sem relógio, morrer não estraga nada, e você vai no seu próprio ritmo. Quando ficar fácil, tente o Heroic, depois o Mythic 0 (ainda sem relógio), e só então uma +2 key.",
	MPLUS_GLOSSARY_HEADER = "Palavras que você vai ouvir (em linguagem simples)",
	MPLUS_GLOSS_KEY = "Key / Keystone — uma masmorra num modo mais difícil com um relógio. Um número maior quer dizer mais difícil.",
	MPLUS_GLOSS_AFFIX = "Affix — uma regra a mais que deixa a masmorra mais difícil. Novas surgem em certos níveis de key.",
	MPLUS_GLOSS_PULL = "Pull — chegar perto dos inimigos para começar a luta. Geralmente o tank decide a hora.",
	MPLUS_GLOSS_KICK = "Kick / Interrupt — seu botão de interrupção para um inimigo no meio de uma magia. Use nas magias marcadas como importantes.",
	MPLUS_GLOSS_SOAK = "Soak — ficar de propósito num círculo marcado para absorver algo, para não machucar o grupo.",
	MPLUS_GLOSS_TANK = "Tank — segura os inimigos e os vira para longe de todos. Fique atrás do tank.",
	MPLUS_GLOSS_HEALER = "Healer — mantém todo mundo vivo. Fique perto o bastante para ele te alcançar.",
	MPLUS_GLOSS_DPS = "DPS — causa dano. A maioria dos jogadores é DPS; seu trabalho é causar dano e desviar das coisas no chão.",
	MPLUS_GLOSS_AGGRO = "Aggro / Threat — quem um inimigo está atacando. Se ele estiver te perseguindo, corra para o tank.",
	MPLUS_GLOSS_CC = "CC (crowd control) — atordoar, congelar ou fazer um inimigo dormir para que ele não possa agir por um momento.",
	MPLUS_GLOSS_DISPEL = "Dispel — remover um efeito ruim de um jogador (ou um efeito bom de um inimigo).",
	MPLUS_GLOSS_WIPE = "Wipe — o grupo todo morre e vocês tentam de novo. Acontece com todo mundo; é só recomeçar e seguir em frente.",
	MPLUS_GLOSS_ILVL = "Nível de item (ilvl) — um número no equipamento que mostra o quão forte ele é. Mais alto costuma ser melhor.",
	MPLUS_GLOSS_BIS = "BiS (best in slot) — o melhor item possível para um espaço de equipamento. \"Esse berloque é BiS\" significa que nada o supera ali.",
	MPLUS_GLOSS_PROC = "Proc — um efeito bônus que dispara aleatoriamente de uma magia ou item. Valor grátis quando acende, então use.",
	MPLUS_GLOSS_UPTIME = "Uptime — quanto do combate um efeito ou bônus fica ativo. Mais uptime nos seus bônus principais é melhor.",
	MPLUS_GLOSS_VAULT = "Espaço do cofre — uma escolha de recompensa no Grande Cofre. Faça atividades durante a semana para desbloquear mais espaços.",

	MPLUS_WEEK_HEADER = "Esta semana, só para você",
	MPLUS_WEEK_BODY = "• Abra o localizador de grupos e escolha uma masmorra no Follower ou no Normal.|n• Não tem relógio e você não pode \"falhar\" — leve todo o tempo que precisar.|n• Você pode sair a qualquer momento; nada se perde.|n• Morrer é normal e aqui não custa nada — é só voltar andando e seguir.|n• Quer os passos de cada chefe? Abra a aba Dungeon Coach.",
	MPLUS_WEEK_AVOID = "Se você quer a primeira vez mais tranquila, deixe a Maisara Caverns para depois — é a mais difícil das oito. Qualquer uma das outras é mais leve para começar.",
	MPLUS_WEEK_BONUS_FMT = "Bônus desta semana: %s é a masmorra da semana — reputação extra quando você a faz.",

	ALERT_HELP_HEADER = "Ajuda extra durante as masmorras",
	ALERT_HELP = "Ligue isto para UM aviso só, grande e calmo (com um som), quando VOCÊ mesmo recebe um efeito perigoso em você — uma armadilha ou um debuff pesado — para você saber que precisa reagir. Um de cada vez, nunca uma parede de avisos.",
	ALERT_DEBUFF_FMT = "%s — reaja!",
	ALERT_DEBUFF_DEVOURING_RIFT = "Devouring Rift em você — dê heal para tirar ou faça dispel!",
	ALERT_BTN_ON = "Os avisos do Helper estão LIGADOS — clique para desligar",
	ALERT_BTN_OFF = "Os avisos do Helper estão DESLIGADOS — clique para ligar",
	ALERT_TEST_BTN = "Me mostre um aviso de teste",
	ALERT_INTERRUPT_FMT = "Interrupt!|n%s",
	ALERT_TEST = "Teste — é assim que um aviso aparece",
	ALERT_ENABLED_MSG = "Avisos do Helper ligados — vou mostrar um aviso grande quando você receber um debuff perigoso para reagir.",
	ALERT_DISABLED_MSG = "Avisos do Helper desligados.",
})
