# Vast toetsenblok — plan (4 okt 2026, Rob + Claude, brainstorm)

Robs idee (4 okt): één vast, strak blok knoppen. Elke plek heeft voor elke klasse en rol altijd dezelfde taak en
toets, zodat je spiergeheugen op elk personage werkt. Moet werken op de Blizzard-balken én op EllesmereUI.
**Nog niets gebouwd.** Dit bestand is de stand van de keuzes.

## Besloten (Rob, 4 okt)

- **3 balken = 36 plekken**, elk 3 rijen × 4 knoppen, naast elkaar. Vaste grootte; lege plekken mogen.
  (Variant C uit de proefvulling; Rob: "ik volg jouw advies".)
- **Hoofdknop op 1.**
- **Muis: MH zet er standaard NIETS op.** We gaan niet uit van een muis met extra knoppen. Robs 6 zijknoppen zijn
  van hem. Wie meer ruimte wil, zet zelf een balk bij.
- **Robs vaste toetsen** (mag later nog schuiven): T = healing potion, F4 = Recuperate, F2 = snelle heal,
  Q = een vaste taak (eerst gedacht: grote damage-cooldown; "samen bekijken").
- **MH doet allebei:** een plaatje van jouw blok + een knop "zet het voor me neer" (met proefrit en terugzetten,
  zoals `/mh apply`). Per toets snel zelf aanpassen blijft.
- **Hulpspreuken** (mount, hearthstone, buffs e.d.) horen niet in het blok; de speler zet ze zelf ergens neer.

## Het blok (eerste schets; balk 4 nog in te vullen)

| | balk A (3×4) | balk B (3×4) | balk C (3×4, extra) |
|---|---|---|---|
| rij 1 | 1 hoofdknop · 2 · 3 rotatie · 4 spender | 5 rotatie · Q vaste taak · E kick · R beweging | trinket · druid-vorm 1-3 (andere klassen: overloop) |
| rij 2 | Shift-1/2 AoE · **Shift-3 cooldown 3** · F1 cooldown 2 | F taunt/hulp · T potion · F2 snelle heal · F4 Recuperate | overloop |
| rij 3 | Z klein def · X def 2 · C groot def · **V CC/dispel** | Shift-Q/Shift-F CC/dispel · Shift-R beweging 2 · Shift-T healthstone | overloop |

Toetsen van balk C: nog niet gekozen.

## Wat de metingen zeggen (GEMETEN, proefvulling uit MH's KeybindRoles-data, 4 okt)

Scratchpad van sessie fcdcd4fe: `keyblock\research.md` (onderzoek), `sim.md`/`sim.json` (met muis), `sim2.md`/`sim2.json`
(zonder muis). Overzichtspagina (met muis, eerste run): https://claude.ai/artifact/YUyNo74kU8Q6GAXexv4mr6

- Alleen 24 plekken: voor **0 van 40** specs genoeg.
- 3 balken met V = CC/dispel en Shift-3 = cooldown 3: alles behalve utility past bij **39 van 40** (40 zonder de
  bekende keuzeknoop-dubbels). Prot Paladin mist alleen Intercession. ±20 utility-spells over alle specs plaats je zelf.
- Gemiddeld 27,4 spells per spec in de data, hoogstens 36 (Marksmanship Hunter).
- Beperkingen: talentkeuzes tellen dubbel (data, geen spellbook); racials niet meegeteld.

## Techniek (GEMETEN in de code, niet in het spel getest)

- EllesmereUI balk 1-8 = dezelfde Blizzard-slots en binding-commando's. `PlaceAction` + `SetBinding` van MH komen dus
  ook op EllesmereUI aan. Max 12 knoppen per balk, rijen vrij.
- Blok op balk 2-8 (balk 1 pagineert bij vormen/stealth). Niet EUI-balk 9/10 (botst met page 2 en Moonkin).
- `/mh apply` zet al spells én toetsen (balk 1-6, undo). Maar de taak zit nu in de **toets**, niet in de **plek**:
  de indeling moet opnieuw. De checks "balk staat uit/te kort" kijken naar Blizzard-knoppen die EUI verbergt.
- Balken op 3 rijen zetten: **nog uitzoeken** of MH dat zelf kan (Edit Mode / EUI), anders uitleg aan de speler.

## Open

1. Toetsen van balk C. 2. Taak van Q. 3. Of MH balken zelf op 3 rijen kan zetten. 4. Welke balken (nummers) standaard.
5. Bouwvolgorde: eerst het plaatje, dan "zet neer".
