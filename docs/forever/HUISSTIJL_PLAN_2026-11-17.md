# Plan — nieuwe huisstijl A + B (Forever-overzicht), 17 nov 2026

Rob, via Sparring 17-11: *"Dus bouw ze allebei maar."* en *"Die twee ontwerpen … krijgt zometeen na de macro's gelijk
de prio 1."* Mockup: `C:\Users\RobHu\Desktop\mh_ontwerp.png` / `.html`. Eis "Do this now": elke regel met een plek een
eigen knop "Show the way", coördinaten in een kleine subregel, de belangrijkste regel als kaartje met titel.

Regels: niets uit de Forever Leveling Guide (ARR). Alleen spel-fonts (stap 1) of OFL-fonts (later, met OFL.txt).
Resizable + Shift-scroll (lint [25]). Elke stap: lint 0 HARD, luac OK, commit + push, TESTLIJST, NEXT_SESSION.

## Stap 1 — stijlkit (`Modules/ForeverStyle.lua`)
- Thema-tabel A ("sfeervol boek") en B ("strak en modern"): kleuren, fonts, randen. Accent = klassekleur
  (`C_ClassColor`/`RAID_CLASS_COLORS`).
- A: koppen in het serif-font van het spel (`Fonts\MORPHEUS.TTF`), tekst Friz Quadrata; warm bruin vlak met
  goudrand en vignet (eigen WHITE8X8-verlopen, geen texturen van anderen).
- B: leisteen WHITE8X8, `Fonts\ARIALN.TTF`, accentbalk 3 px.
- Bouwstenen: `Card`, `Label` (kleine kopletters), `Chip` (NU / KAN AL / LATER), `Button` (primair/secundair),
  `Timeline` (knooppunten met level + regel). Eén schakelaar `ns.db.foreverStyle = "A" | "B"`.

## Stap 2 — "Do this now" met structuur (zonder het oude venster te breken)
- `Collect()` in ForeverDoNow.lua levert naast de tekstregels ook items: `{ kind, title, what, zone, x, y, go }`.
- Eerst: class-quest (`ns.ForeverClassQuestNow` geeft al de stap met plek), trainer (`ns.ForeverTrainerGo`),
  kampvuur, Legacy. `go` zet de route via de bestaande weg (SetBlizzardUserWaypoint + pijl-schakelaar).
- Het oude venster blijft werken met de tekst; het nieuwe gebruikt de items.

## Stap 3 — het overzichtsvenster (`Modules/ForeverOverview.lua`, `/mh overview`)
- Kop: naam · ras · class (spec) · level. Tabs: Nu / How you play / Class quests / Kamperen / Legacy (de laatste vier
  openen eerst de bestaande vensters).
- Nu: groot kaartje "Doe dit nu" (titel, wat, plek-subregel, knop Show the way), kaartje "Binnenkort" (trainer-spells
  van de komende levels), kaartje "Class quest", en "Jouw pad" (tijdlijn level nu → +6: trainer-spells, class quests,
  eerste talent).
- Elke andere "nu"-regel met een plek eronder als kleine rij met een eigen pijl-knop.

## Stap 4 — schakelaar A/B + vertalingen
- Instelling + `/mh overview style a|b`; uitleg waar de knop staat. Teksten en + nl, daarna de/fr/es/pt/ru.

## Wat Rob ziet per stap
1. Nog niets (alleen de kit). 2. "Do this now" werkt als eerst. 3. `/mh overview` in A. 4. Schakelaar naar B.
