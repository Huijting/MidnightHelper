# Reagentia: waar haal ik het? (Forever 1.60.1.71037, 22 nov 2026)

Hoort bij punt 1, optie B (Rob 22 nov via sparring: *"1 b"*). Onderzoek: mh-research. Nageteld door Bouwchat 22-11.
**Rob 22 nov via sparring, letterlijk: *"overnemen, ja"* = uit Zygor mogen plekken en nummers (id's, coördinaten,
volgorde), geen teksten, notities of code. "Zygor b" van eerder die dag vervalt. GEBOUWD 22 nov: 172.**

**Wat de 172 zijn** (GEMETEN, hertelling): 30 Herbalism, 31 Mining, 7 Skinning, 26 te koop bij 17 verkopers (193 paren met
een bekend punt; naam en punt van Wowhead), 78 "valt van monsters" zonder plek. Wat één bron heeft zwijgt.

Per item: `reagent_sources.csv` + `reagent_sources.md` in
`C:\Users\RobHu\AppData\Local\Temp\claude\e1c44003d48d72c2\1d618a73-6d9c-5dbf-b8f1-c063472d06aa\scratchpad`
(524 rijen; niet in de repo: er zit Zygor-bewijs in. De gekozen 172 = `r172_build.py` + `r172_install.py` daarnaast).

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

## De licentie van Zygor (beslist door Rob, 22 nov)

- GEMETEN door de bouwchat: beide Zygor-toc's zeggen `X-License: GPL`, het About-scherm zegt "All Rights Reserved"
  (Core_enUS.lua:840). `Licence.lua` niet gelezen: kan Robs persoonlijke sleutel zijn.
- Robs besluit daarna: *"overnemen, ja"*, grens zoals bovenaan. AllTheThings = MIT, met de tekst erbij.
