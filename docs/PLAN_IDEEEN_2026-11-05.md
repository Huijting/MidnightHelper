# Plan — drie ideeën van de plank (5 nov 2026)

> ✅ **Later die dag, Rob: *"ik volg jouw advies"*.** Gebouwd: de gedeelde stap 1 en idee B, met mijn adviezen als keuze
> (knop op Home + zoekbalk, 3 knoppen 10/20/40, "quick"-stappen zonder minuten erbij). Zie `docs/NEXT_SESSION.md`.
> C en A staan nog open.

Rob, 5 nov: *"1 tot en met 3"* → optie 1 = de drie ideeën van 26 okt uitwerken, **alleen een plan, nog niet bouwen**.
Inventaris: mh-sweep (Haiku) las de code; de hoofdpunten heb ik zelf nagelezen (SeasonStats.lua heel,
DelveHistory.lua:580-615, ResetRoutine.lua:1-80, RitualLog.lua:135-175). Niets in het spel gezien.

## Wat MH nu al bewaart (GEMETEN in de code)

| bron | wat | voor wie | sinds |
|---|---|---|---|
| `ns.db.seasonStats` (SeasonStats.lua) | 5 tellers: keys gedaan, keys op tijd, bazen, doden, mounts | hele account | eerste login met die code; het bestand zegt zelf "groundwork for a season retrospective" (regel 4) |
| `ns.db.seasonStatsArchive` | het blok van Seizoen 1 | hele account | wisselt alleen als het seizoen echt begint |
| `ns.db.delveLog[guid]` (DelveHistory.lua:600-612) | per run: tier, tijd, doden, sleutel, baas, bountiful, datum; max 20 per delve | per character | eerste run met MH |
| idem, `lifetime` | totaal aantal runs, totale tijd, snelste, record per Tier | per character | blijft, ook na 20 runs |
| RitualLog.lua | zelfde vorm voor rituals | per character | idem |
| `ns.db.labSplits` | beste tijd per kamer per Tier | hele account | 26 okt |
| `ns.db.charCurrencies[guid]` (AltOverview) | goud, crests, vault, beroepen — **alleen de stand van nu**, geen geschiedenis | per character | elke login overschreven |

**Wat er NIET is (GEMETEN, met positieve controle):** het verhaal (story) per delve-run, Valeera's rol per run, Valeera-XP
per run, speeltijd (0× TIME_PLAYED in Modules/). Runs ouder dan de laatste 20 per delve zijn weg (de totalen blijven).
Niet nagekeken: of rares/schatten een teller hebben, en achievements.

---

## Idee A — "Jouw Seizoen 2" (zoals Spotify Wrapped)

Een venster met grote kaartjes: *"Je deed 143 delves. Je snelste: Twilight Crypts T8 in 9:12. Je ging 37 keer dood."*

**Eerlijk-regel:** elk kaartje zegt sinds wanneer we tellen ("since 22 Jul"). Wat we niet tellen, staat er niet.
Een 0 die eigenlijk "weten we niet" is, mag nooit verschijnen (SeasonStats.lua:32 zegt dat al).

**Stap 1 — nu beginnen met tellen (klein, onzichtbaar).** Hoe eerder, hoe voller het overzicht aan het eind:
- `BumpSeasonStat("delves")`, `("rituals")`, `("labyrinth")` bij elke gelogde run.
- Het verhaal per delve-run bewaren (veld `story`); hebben B en C ook nodig.
- Rares gedood en schatten gevonden tellen, als dat te meten is (eerst nakijken).
- Stap 1 heeft geen scherm nodig. `/mh season stats` toont het al.

**Stap 2 — het venster.** 6 tot 8 kaartjes, uit data die er al is:
1. Delves: totaal + je meest gespeelde delve (lifetime, per character, opgeteld over je alts).
2. Je snelste run per Tier (bestByTier).
3. Labyrinth: je beste kamers (labSplits).
4. Keys gedaan / op tijd (seasonStats).
5. Bazen verslagen, doden ("1 dood per 4 bazen").
6. Mounts erbij dit seizoen.
7. Je alts: wie speelde het meest (aantal runs per character).
- Openen: knop op de Home-tab + `/mh wrapped`. Ook vindbaar in de zoekbalk.

**Stap 3 (later, optioneel) — op de site.** Via `/mh export` naar een pagina op midnighthelper.com. Dat is werk voor de
site-chat. Pas als stap 2 bevalt.

**Te kiezen door Rob:**
- a) Nu alleen stap 1 (tellen), het venster pas vlak voor het einde van het seizoen. *Mijn advies*: dan is er echt iets te laten zien.
- b) Stap 1 + 2 nu, met de tekst "so far".
- Wanneer eindigt Seizoen 2? **Weet ik niet** (niet gemeten). Dat bepaalt wanneer het venster zin heeft.

---

## Idee B — knop "Ik heb 20 minuten"

Je drukt op de knop en MH zegt: *"Dit past in 20 minuten: 1) haal je Vault op (2 min), 2) Twilight Crypts T8 (gemiddeld 14 min)."*

**Het probleem:** MH kent **geen enkele tijd per taak** (GEMETEN: alleen reistijd, `PLAN_ESTIMATE_FMT`). Tijden
verzinnen mag niet.

**De oplossing: jouw eigen tijden.** MH weet hoe lang JIJ over elke delve en elke ritual doet. Het bewaart
`duration` per run, per Tier. Dat is gemeten, en van jou. Dus:
- **Delves/rituals:** je gemiddelde van de laatste runs op die Tier. Heb je hem nog nooit gedaan, dan staat er
  "no time yet" in plaats van een gok.
- **Dingen zonder tijd** (vault ophalen, wekelijkse quest oppakken): uit de Reset Routine (ResetRoutine.lua, live
  status per stap). Die krijgen het label "quick". Of we ze mogen tonen zonder minuten, kiest Rob.
- **Wat al af is deze week**, toont hij niet: dat staat al in de Reset Routine en de weekchecklist.
- Een kleine reistijd erbij met de bestaande reisplanner ("About 3 min to get there"). Die rekent al.

**Te kiezen door Rob:**
- Waar komt de knop? Op de Home-tab naast de Reset Routine. *Mijn advies*: ook in de zoekbalk ("20 min").
- Kiest de speler zelf de tijd: 10 / 20 / 40 min? *Mijn advies*: ja, 3 knoppen.
- Wat telt mee: alleen delves en rituals met een gemeten tijd, of ook de "quick"-stappen zonder minuten?

**Risico (AFGELEID):** een nieuwe speler heeft nog geen runs, dus dan is de lijst kort. Dan zegt MH dat ook: "do a few
delves first, then I know your times".

---

## Idee C — Valeera's dagboek

Een kort dagboek in de stem van Valeera, één regel per run:
*"4 Nov — Twilight Crypts, Tier 8. Fourteen minutes, nobody died. Darza never saw us coming."*

**Wat er al is:** per run de delve, Tier, tijd, doden, baas, bountiful en datum (max 20 per delve).
**Wat ontbreekt:** het verhaal en Valeera's rol per run. Die moeten we eerst bewaren (dezelfde stap 1 als bij A).

**Eerlijk-regel:** het dagboek **verzint niets**. Elke zin komt uit een vaste lijst sjablonen, en elk stukje uit een
gemeten veld. "Nobody died" alleen als deaths = 0. Een record alleen als `record = true`. Geen gebeurtenissen die
MH niet ziet.

**Bouw (als Rob het wil):**
1. Velden `story` en `valeeraRole` per run (zie A, stap 1).
2. ±30 sjablonen in het Engels: per situatie 3 varianten (snel, record, doden, eerste keer op een Tier, bountiful,
   Labyrinth). Toon: kort, droog, een beetje Valeera.
3. Vertalen in 7 talen. **Dat is het grootste werk:** grappige zinnen vertalen is lastig. Ik schrijf ze zelf, niet
   door een moedertaalspreker nagekeken. Spelnamen = de naam die de client toont (de vaste regel).
4. Plek: een knop "Diary" in de Delve Log-tab, of in het Valeera-venster.
5. Schakelaar om het uit te zetten (spelers kiezen).

**Te kiezen door Rob:**
- Toon: grappig of zakelijk?
- Alleen Engels eerst (zoals de changelog), of meteen 8 talen?
- Plek: Delve Log of het Valeera-venster?

---

## Mijn advies voor de volgorde

1. **Eerst de gedeelde stap 1** (story, rol en tellers per run bewaren). Klein, onzichtbaar, en A, B en C hebben het
   alle drie nodig. Elke dag dat het niet loopt, is data die we kwijt zijn.
2. Dan **B** (20 minuten): nuttig voor iedereen, elke week, en de data is er al.
3. Dan **C** (dagboek): leuk, maar veel vertaalwerk.
4. **A** (Wrapped) als laatste, vlak voor het einde van het seizoen. Dan is er het meeste te laten zien.
