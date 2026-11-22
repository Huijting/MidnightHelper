# Polestar: is het vrije deel los te krijgen, en wat dekt het? (22 nov 2026) — onderzoek; na Robs ja gebruikt voor de recepten (commit 7ea56b68 van hun bron)

Rob 22 nov via sparring, letterlijk: *"overnemen, ja"* (2. mag het vrije deel van Polestar uitgezocht worden).
Uitzoeken mag; overnemen is een nieuwe ja. ▶ Die kwam (22 nov via sparring, letterlijk: *"alles advies"* = A):
alleen recorded.json, alleen trusted, tweede bron of controle, met naam, bron, licentie en bewerking in het databestand.

## Licentie (GEMETEN in github.com/fitzforge/polestar, branch next)

- `data/codex/recorded.json` staat los in de bron (7.776.928 bytes). THIRD_PARTY.md:84-85 noemt het opnames van
  spelers, "CC BY 4.0"; de LICENSE-DATA.txt in de addon zegt hetzelfde. CC BY = gebruiken mag, met naamsvermelding.
- De code en het programma = GPL-3.0. forever-db: 12 van de 15 tabellen GPL; de 3 CC BY-tabellen zijn eigen teksten en
  stappen (1 leeg). De rest van de Codex is gemengd (GPL, Questie "behandel als ARR", websites): niet bruikbaar.
- `data/recorded/quests.json` zegt alleen "Facts only": geen licentie, dus niet.
- EG Link (CC BY 4.0) is een eigen bron (github.com/JIVESCORP/eg-link-output-wowf): alleen quest-feiten, hier niet geteld.
- Dus: alleen recorded.json, rechtstreeks uit de bron, nooit uit de gebouwde addonbestanden (daarin is alles gemengd).

## Inhoud (GEMETEN; 12.469 getelde sessies van 388 spelers; "trusted" is hun eigen keurmerk)

| deel | met een trusted feit | paren |
|---|--:|--:|
| verkoper → item | 943 van 1030 verkopers | 13.301 |
| monster → buit | 2858 van 3610 | 19.525 |
| ding in de wereld → buit | 675 van 801 | 1.512 |
| questbeloningen | 1038 van 1211 quests | |
| instaplevel dungeons | 27 | |

Er zit GEEN plek, naam, prijs of trainerlijst in: alleen id's, stemmen en soms een kans.

## Wat het MH zou geven (GEMETEN telling, alleen trusted)

- Recepten: 549 van de 992 met één bron krijgen een tweede, in Forever geziene bron (vooral verkocht). 153 van de 805
  worden in Forever bevestigd. Trainers: niets.
- Alle 13 kampverkopers (Barrens + Redridge) staan erin: de meting die Rob daar zou doen is dan grotendeels overbodig
  (AFGELEID: of hun lijsten compleet zijn is niet gemeten).
- Reagentia: 22 van de stille krijgen een tweede bron; 158 van de 172 komen erin voor.
- Controle op onze eigen data: 186 van onze 193 verkoper-itemparen staan er ook in.
- Punten: van 277 van de 1030 verkopers heeft MH al een plek; de rest zou tekst zonder pijl zijn, of een tweede bron nodig hebben.

## Niet gecontroleerd

- Of de opnames eerlijk en compleet zijn, en hoe "trusted" precies rekent (minstens 3 spelers volgens hun meta).
- Niets in het spel gezien. Geen juridisch advies.

## De keuze (Rob koos A)

- **A (advies):** recorded.json als bron, met naamsvermelding, alleen trusted en alleen als tweede bron of controle.
- **B:** alleen nakijken, geen waarden eruit.
- **C:** niet gebruiken.
