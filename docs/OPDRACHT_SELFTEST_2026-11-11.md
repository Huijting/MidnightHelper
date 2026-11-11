# Opdracht 7 — `/mh selftest` (plan deel 4b, stap 7)

Van de sparring-chat («MidnightHelper werkwijze sparring»), 11 nov 2026, met Robs ja daar: *"zet die opdracht voor stap 7
maar klaar"* (doorgegeven; de bouwchat vraagt Rob zelf vóór fase 0 begint). Klaargezet voor de bouwchat van 12 nov; op 11 nov
is niets gebouwd. De tekst hieronder is die van de sparring-chat.

**Doel:** de addon loopt zichzelf na in het spel en schrijft het resultaat weg. Rob doet één `/reload`, de AI leest het hele
rapport uit de SavedVariables. Rob test dan niet meer of iets start, alleen nog of het goed voelt.

GEMETEN door de sparring-chat op 11 nov: "selftest" komt in geen enkel .lua-bestand voor (tegencontrole: dezelfde
zoekactie vond het wel in `tools/event_check.py` en `release_text_check.py`, als `--selftest` van die scripts).
`DialogPopup.lua:274` heeft al een tabel `SCALABLE_WINDOWS`; of die als vensterlijst kan dienen is niet gemeten.

## Fase 0 — eerst meten en voorstellen, niets bouwen

1. Welke lijsten met spelnummers gebruikt `tools/data_check.py` (C2)? Kan de zelftest dezelfde bron gebruiken, zodat er
   niet twee lijsten ontstaan?
2. Welke client-functies zeggen betrouwbaar "bestaat" voor spell, quest, achievement, item en kaart, in Midnight en in
   Forever? Welke geven eerst nil omdat de data nog laadt (items)? Kandidaten uit andere addons zijn geen bewijs; de
   client beslist.
3. Is `SCALABLE_WINDOWS` (of `RegisterMidnightDialogPopup`) een bruikbare vensterlijst, of dekt hij maar een deel van de
   vensters? Tel: hoeveel vensters heeft de addon, hoeveel staan erin.
4. Leg Rob één kort voorstel voor: wat zit in de eerste versie, wat later. Wacht op zijn ja.

## Fase 1 — de kleinste versie die al iets oplevert (voorstel sparring-chat; Rob beslist na fase 0)

- `/mh selftest` loopt elk spelnummer uit onze data na in DIT spel. Per regel: goed / bestaat niet / mocht ik niet lezen /
  nog niet geladen.
- Resultaat naar `ns.db.selftest` (alleen de laatste run; het SV-bestand is al 30 MB), plus één regel op het scherm:
  "Alles bestaat" of "3 dingen bestaan niet: ...".
- Werkt in Midnight en Forever.

## Fase 2 — daarna

Per venster "heeft zijn tekst", en de vensterlijst die controle C5 nodig heeft. Rob moet nog ja/nee/later zeggen op de
vensterlijst (`docs/REGIE.md`, lijst 4, punt 4).

## Harde regels

- Bewijs dat de test kan falen: een bekend fout nummer moet als "bestaat niet" uit de test komen, in dezelfde run. Een leeg
  rapport zonder die proef bewijst niets.
- "Nog niet geladen" en "mocht ik niet lezen" zijn geen "bestaat niet". nil = onleesbaar, niet afwezig.
- Door dezelfde deur als het spel: geen testMode-takken in het echte pad. Verzin geen secret value.
- Niet in een gevecht draaien; zeg dat op het scherm als de speler het toch probeert.
- De zelftest zegt dat iets bestaat, niet dat het werkt. Zet die grens in de uitleg bij het commando.
- Nieuw onderdeel dus: een regel in `IDEEEN.md`, `SITE_SEIN.md`, `TESTLIJST.md` (wat Rob moet zien en waar), het
  commando in de lijst en de zoekbalk, en de handoff in dezelfde commit.
- Niet pushen, taggen of releasen zonder Robs ja. (Kanttekening bouwchat: pushen naar main mag volgens Robs vaste afspraak
  van 8 okt; taggen en releasen niet.)

**Klaar is:** Rob typt `/mh selftest`, doet `/reload`, en de bouwchat leest het rapport en vertelt hem in drie zinnen wat
eruit kwam.
