# Ras-feiten — "Your race" in How you play (WoW Forever)

Register voor het blok "Your race: <ras>" (tab Start, `ForeverHowToPlay.lua` RACE_INFO, sleutels `FRACE_*`).
Opdracht: Rob via Sparring 25-11, *"misschien is dat een goed idee om dat uit te leggen. Niet alleen bij de Druid
natuurlijk, maar bij alle Taurens … ook andere specs … als extra info vermelden bij de klas"*; op het voorstel:
*"ja , ik zag bv ook dat deze druid ook Cultivation heeft :)"*.

Bronnen van de tekst: mh-research + een onafhankelijke tweede check (Sparring, 25 nov; DB2 1.60.1.71091/71139,
Wowhead Forever-tooltips, Kaivax dev notes 2360696 24 sep t/m 2 nov, hotfix-thread 2403040 t/m 23 nov).

Status: **GEMETEN** = door de bouwchat zelf nagemeten in DB2 1.60.1.71091 (26 nov). **BRON** = uit het onderzoek /
de tweede check, niet door de bouwchat nagemeten. **WEGGELATEN** = bewust niet in de tekst.

## Wat de bouwchat zelf mat (26 nov)

| Feit | Waar | Status |
|---|---|---|
| Alle spell-id's in de tekst bestaan, met deze namen (Will to Survive 1259718 … Skysight 1259686, Eureka! 1259812/13/17/21/23, Command 20575/20576) | DB2 SpellName 71091 | GEMETEN |
| Expansive Mind 20591, Touch of the Grave 1260189, Underwater Breathing 5227 (zelfde naam als de andere id's) | SpellName | GEMETEN |
| Ras-id's: 1 Human, 2 Orc, 3 Dwarf, 4 Night Elf, 5 Undead, 6 Tauren, 7 Gnome, 8 Troll, 95 High Order Skyborne (Alliance), 96 Windshaper Skyborne (Horde) | ChrRaces | GEMETEN |
| Plainsrunning 1259918: periodiek (1 s), waarden 2 / 5 / 60 (= 2% per 5 s, tot 60%) | SpellEffect | GEMETEN |
| Travel Form: 783 zelf heeft geen snelheids-aura; de passive 5419 "Travel Form (Passive)" heeft aura 31 = +40% | SpellEffect | GEMETEN (lost de twijfel tussen onderzoek en tweede check op: beide klopten) |
| Aspect of the Cheetah 5118 aura 31 = +30% | SpellEffect | GEMETEN |
| "Charged" (Windshaper) heeft 3 id's met verschillende Duitse namen (Geladen / Aufgeladen) → beschreven, niet als spellnaam | SpellName enUS + deDE | GEMETEN |
| "Attuned" 1259691: alle Attuned-id's heten in het Duits "Eingestimmt" → als token | SpellName deDE | GEMETEN |
| Purification Potion 13462 | ItemSparse | GEMETEN |
| Alleen Mage en Druid hebben een decurse (475/412113, 2782) | onderzoek | BRON |

## Per ras (tekst = BRON, getallen uit tooltips en dev notes)

| Ras | Regels | Status |
|---|---|---|
| Human | Will to Survive (stun breken, 3 min), Perception (20 s, 3 min), Ruthless +1% crit, The Human Spirit +10% Spirit; klasse: stun / mana / Perception | BRON |
| Dwarf | Stoneform (gif, ziekte, bloeding, 8 s, -10% fysiek, 3 min), Find Treasure, Artisan's Precision +1% hit, Big Game Hunter +5% Beasts | BRON |
| Night Elf | Shadowmeld (10 s cd, in gevecht 2 min), Elune's Light +10% crit 15 s, Quickness, Wisp Spirit; Druid: Shadowmeld in Cat Form, maar geen Ravage/Pounce eruit (hotfix 6 nov) | BRON |
| Gnome | Escape Artist (2 min, 3 s immuun), Eureka! (8 s, -10% kosten +10% schade, geen DoT, wel channel, niet in Stealth, 2 min), Expansive Mind +5%, Engineering Specialization | BRON |
| Orc | Blood Fury (+10% AP/SP 15 s, 2 min), Shatter Curse (curses + banes, -5% magie 8 s, 3 min), Hardiness -20% stuns, Command +5% (alleen Hunter/Warlock) | BRON |
| Undead | Will of the Forsaken (niet immuun daarna, niet tegen Scatter Shot, 2 min), Cannibalize (5 yd, 7%/2 s, 10 s), Touch of the Grave (5%, 1× per 15 s; 30% casters / 20%), Underwater Breathing ×4 | BRON |
| Tauren | War Stomp (0,5 s, 5 doelen, 8 yd, 2 s, 90 s), Plainsrunning, Endurance +5%, Cultivation (10 yd, 3 s, 15 min, level ≥ skill/5) | BRON (+ Plainsrunning-getallen GEMETEN) |
| Troll | Berserking (+10% 15 s, 3 min), Rapid Regeneration (50% in 6 s, 3 min), Regeneration (+20%, 20% in gevecht), Beast Slaying | BRON |
| Skyborne | Walk on Air (10 s, 90 s), Wind Blessed +2% haste, Elemental Insight +5%; High Order: Read Leyline (+50%, Attuned +100% 1 uur, niet met Innervate); Windshaper: Skysight (+15% "korte tijd", Charged +30% 1 uur) | BRON |
| Plainsrunning in Bear/Cat Form | "players tested it" | BRON (spelers), zo in de tekst |

## Weggelaten

| Wat | Waarom |
|---|---|
| "Shadowmeld is not Stealth" | niet gemeten (Sparring) |
| Plainsrunning "and Prowl" | betwist tussen onderzoek en tweede check |
| Skysight "30 sec" / "15 sec" | tooltip en dev notes verschillen → "for a short time" |
| Command-regel voor andere classes dan Hunter/Warlock | geen pet |

## Gecorrigeerd vóór de commit

- FRACE_PRI_OWN zei eerst "Priest spells **at the trainer**" (de opdracht). De bestaande sectie "Your race's own
  spells" zegt in alle 8 talen "from a quest, not from the trainer" (gevonden door mh-writer, 26 nov). Nu: "two Priest
  spells of its own, from a quest" — de sectie wint, zij is eerder nagekeken.

## Vertalingen (mh-writer, 26 nov) — woorden om na te kijken

Zelf vertaald, niet door een moedertaalspreker. Token-check: 68 sleutels × 8 talen, 0 fouten. Twijfel (geen clientwoord
gevonden in het pack): Banes = de Omen / fr Plaies / es Terrores / pt Ruínas / ru бичи / it Flagelli (afgeleid uit de
Bane-spellnamen); Elemental Convergence en Ley Line per taal zelf gekozen (pt "Meridiano" en ru "силовая линия" uit de
spellnaam Read Leyline); haste/hit (de Tempo/Trefferchance, fr hâte/toucher, es celeridad/golpe, pt aceleração, ru
скорость/меткость). itIT: geen Forever-client, alles zelf vertaald (o.a. Movimento Furtivo, Fusione d'Ombra).
esMX: geen eigen regels toegevoegd (geen esMX-woord gezien; check_drift volgt esMX niet).

## Elke ronde nalopen

Patch notes / hotfixes over racials (cooldowns, procentjes, Skyborne). Een verandering → regel hier bijwerken, tekst
aanpassen, opnieuw meten.
