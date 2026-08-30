# Vertaal-drift

Gegenereerd door `python tools/check_drift.py --write-report`. **Niet met de hand bijwerken.**

Drift betekent: deze taal heeft een vertaling, maar de Engelse zin waar hij uit komt is daarna veranderd. `ns:L` valt alleen terug op enUS als een key *ontbreekt* — een aanwezige vertaling blijft staan, hoe oud hij ook is. Zo blijft een gecorrigeerde bewering in vijf talen gewoon doorlopen.

Basis: **v3.5.0** — 2996 keys met een vastgelegde herkomst.

| taal | OK | drift | onvertaald | onbekend |
|---|---:|---:|---:|---:|
| deDE | 2942 | 0 | 175 | 33 |
| frFR | 2961 | 0 | 162 | 27 |
| esES | 2961 | 0 | 162 | 27 |
| ptBR | 2962 | 0 | 161 | 27 |
| itIT | 2878 | 0 | 245 | 27 |
| nlNL | 2570 | 0 | 484 | 96 |

**onbekend** = na de basistag vertaald, dus we weten niet uit welke Engelse versie. Dat is niet hetzelfde als verouderd.

De loader ziet **3508** enUS-keys; hiervan zijn er 3150 beoordeeld en 358 overgeslagen (`CHANGELOG_*`, `LANG_LABEL_*` en waarden die precies een spelbegrip zijn). ⚠️ `tools/lint_addon.py` [5] telt hetzelfde anders — die parseert de bestanden zelf en slaat niets over, dus zijn "still English" ligt hoger. Twee getallen die hetzelfde lijken te meten en niet gelijk zijn: gebruik hier het getal van de loader.

🔴 **Wij vertalen dit zelf.** Deze lijst ging vroeger "naar #translations", maar daar is niemand: dat betekende in de praktijk "wordt nooit gerepareerd", en een vertaling die iets onwaars beweert is erger dan een zorgvuldige van ons. Wel eerst lezen — "gedrift" zegt alleen dat het Engels veranderd is, niet dat de vertaling fout is (30 aug: 5 van de 11 waren loos alarm). En elk pack houdt zijn eigen woordenschat: `itIT` schrijft Great Vault, `deDE` Große Schatzkammer.

⚠️ **Wat wij schrijven is niet nagekeken door een moedertaalspreker.** Verschijnt er ooit een vertaler, dan begint die hier: de tier-teksten (`INFO_DRAWER_BODY_TIER`, `TIER_FOOTER`, `TIER_SET_UNKNOWN`) en de Collegiate-tip zijn op 30 aug 2026 door ons geschreven in de/fr/es/pt/it.

