# Reagentia: waar haal ik het? (Forever 1.60.1.71037, 22 nov 2026)

Hoort bij punt 1, optie B (Rob 22 nov via sparring: *"1 b"*). Onderzoek: mh-research. Nageteld door Bouwchat 22-11.
**Nog niet gebouwd: wacht op Robs keuze over Zygor (hieronder).**

Per item: `reagent_sources.csv` + `reagent_sources.md` in
`C:\Users\RobHu\AppData\Local\Temp\claude\e1c44003d48d72c2\1d618a73-6d9c-5dbf-b8f1-c063472d06aa\scratchpad`
(524 rijen; bewust niet in de repo zolang de licentiekeuze open is; scripts `rs_*.py` staan ernaast).

## Uitslag (GEMETEN door de bouwchat: hertelling van de csv)

| | antwoord | waarvan client of 2+ bronnen |
|---|--:|--:|
| met Zygor | 230 van 524 | 172 |
| zonder Zygor | 229 van 524 | 87 |

De rest zwijgt (gemaakt, onbekend, gevist, ontgoocheld enz.). "Twee bronnen" = meestal AllTheThings + Zygor; die dragen
vooral Classic-kennis Forever in (AFGELEID, mh-research). Niets hiervan is in het spel gezien, behalve "te koop,
onbeperkt" uit Robs eigen Auctionator-cache.

## Wat de bouw moet weten

- **De pijl mag NIET de categorie "Trade Supplies" gebruiken:** die verkopers hebben niet allemaal hetzelfde (mh-research,
  Wowhead Forever: o.a. Crystal Vial, Fine Thread, Bleach). Dus een verkoperlijst per item en de verkoper bij naam.
  Bekend: 17 van 53 verkopers voor minstens één item, 10 volledig. Dus nooit "de dichtstbijzijnde" beloven. Aanvullen
  kan door te leren bij MERCHANT_SHOW, zoals bij repareren.
- AllTheThings = MIT (GEMETEN door de bouwchat: LICENSE op GitHub). Data eruit meesturen = de MIT-tekst mee.
- Beroepsnamen: SkillLine, niet de spreuk (esES: Botánica, niet Herboristería).
- ruRU `FVEND_CAT_TRADE` = "Хозяйственные товары" (retail-woord); Wowhead Forever toont op 21 van 21 verkopers
  "Хозяйственные припасы". deDE wisselt (5 van 21 "Handwerksbedarf"). In een client nameten.
- Item 23567 "DEPRECATED ITEM" staat in MH's reagentialijst (mh-research).

## Open: de licentie van Zygor

- GEMETEN door de bouwchat: beide Zygor-toc's (Forever 1.6, retail 9.6) zeggen `X-License: GPL`. Een GPL-tekst vond ik
  niet in de Forever-map (gezocht op "General Public License" en licentie-bestandsnamen). `Licence.lua` niet gelezen:
  kan Robs persoonlijke sleutel zijn.
- Polestar is om GPLv3 "alleen het idee". Voor Zygor geldt tot nu toe "alleen feiten: id's, plekken, volgorde"
  (sparring 21 nov). Die twee regels lopen uiteen.
- Onze eigen notities spreken elkaar tegen: ForeverTravel.lua en ForeverCitySpots.lua noemen Zygor All Rights Reserved,
  docs van 6 okt en 18 nov zeggen GPL.
- Raakt: deze reagentia; de dungeon-quests van 21 nov (id's, gevers, volgorde en coördinaten uit Zygor; alleen op main,
  niet in 5.7.0); en mogelijk ouder werk dat al uit is. Welke bestanden echt Zygor-waarden dragen is NIET gemeten: een
  vermelding van Zygor is vaak juist "niet gebruikt" of "alleen vergeleken".
