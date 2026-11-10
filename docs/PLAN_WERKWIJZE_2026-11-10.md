# Het hele plan — één werkwijze voor addon, Forever en site (10 nov 2026)

> **Status: PLAN. Alleen deel 1 is af. De rest is niet gebouwd en door Rob nog niet gelezen.**
> Rob, 10 nov: *"het moet één grote overkoepelende organisatie worden"* en *"werk het hele plan maar uit"*.
> Gemaakt in een cloud-sessie. Die ziet de addon-repo en de site-repo, maar niet Robs pc en niet de helpers in
> `AddOns/.claude/agents/`. Waar dat telt, staat het erbij.
> Alles over de site-kant staat in de privé site-repo (`drafts/WERKWIJZE_2026-11-10.md`), niet hier.

## Het doel

Rob, 10 nov: *"we gaan mensen helpen. Zowel beginnende mensen die nog nooit het spel gezien hebben, als
doorgewinterde mensen die een soort van oh ja momentje moeten krijgen."*

En voor onszelf: de AI doet het werk, Rob kijkt alleen nog naar wat alleen een mens kan zien.

## De kringloop

```
luisteren → idee → toets → bewijzen → bouwen → testen zonder spel → Rob kijkt in het spel → site en CurseForge zeggen hetzelfde
    ↑                                                                                                    |
    └────────────────────────────────────  spelers reageren  ←───────────────────────────────────────────┘
```

| stap in de kringloop | wie doet het | welk deel van dit plan |
|---|---|---|
| luisteren | de wachters, de ochtendronde | deel 3 |
| idee + toets | ideeën-wachter stelt voor, Rob beslist | deel 1 (af) en deel 3 |
| bewijzen | controles op data en namen | deel 2 |
| bouwen | de bouwchat | deel 6 (recepten) |
| testen zonder spel | nep-spel en zelftest | deel 4 |
| Rob kijkt | Rob, bij grote dingen Cisca | deel 4 (wat overblijft) |
| site en CurseForge | site-chat, het prikbord | deel 5 |

---

## Deel 1 — de toets en de ideeënlijst ✅ AF

- De toets: zes vragen (voor wie, welk moment, welke bron, kunnen we het waar maken, past het in wat er is, hoe
  vindt de speler het). Een "nee" bij de eerste twee en het idee valt af. Rob: *"het klopt"*; de zesde vraag: ja (10 nov).
- De vaste vorm van een idee, en de ene lijst: `docs/IDEEEN.md` (open / ja / af / nee met reden).
- Waarom de zesde vraag: drie van de vijf wensen uit de vragenlijst waren al gebouwd, maar spelers vonden ze niet
  (GEMETEN 10 nov, zie `IDEEEN.md`).

De toets:

| # | vraag | goed antwoord |
|---|---|---|
| 1 | **Voor wie?** | De nieuweling ("wat moet ik nu doen, en waarom?") of de veteraan ("oh ja, vergeten"). Liefst allebei. |
| 2 | **Op welk moment?** | Een moment dat we kunnen aanwijzen: bij inloggen, voor een baas, na de reset, bij een verkoper. |
| 3 | **Waar komt het vandaan?** | Een echte bron: een speler, de vragenlijst, een patch, een forumvraag. "Leek me leuk" mag, maar staat er dan eerlijk bij. |
| 4 | **Kunnen we het waar maken?** | De data is te meten (Blizzard-tabellen, het spel zelf). Wat we niet kunnen meten, bouwen we niet. |
| 5 | **Past het in wat er al is?** | Het bouwt op een bestaand onderdeel. Een nieuw venster alleen als het echt niet anders kan. |
| 6 | **Hoe vindt de speler dit?** | Hij komt het tegen op het moment dat hij het nodig heeft. Niet alleen via een commando dat hij moet kennen. |

De vaste vorm:

```
### <korte naam>
- Voor wie:      nieuweling / veteraan / allebei
- Moment:        wanneer ziet de speler dit?
- Spel:          Midnight / Forever / allebei
- Bron:          waar komt het vandaan? (met datum)
- Bouwt op:      welk onderdeel bestaat al?
- Data:          GEMETEN / nog te meten / niet te meten
- Vindbaar:      waar komt de speler het tegen?
- Werk:          klein / middel / groot
- Site:          raakt het de site? ja / nee
- Rob zegt:      ja / nee (reden) / later
```

---

## Deel 2 — de controles ("bewijzen")

**Wat het Rob oplevert:** fouten die nu pas bij zijn `/reload` opvallen, vallen al op voordat hij iets ziet.

**Wat er al is (GEMETEN):** `tools/lint_addon.py` met minstens 6 controles, de syntax-controle, en GitHub draait
die bij elke push (`.github/workflows/addon-lint.yml`, `lua-syntax-check.yml`, `package-test.yml`).
Wat er nog niet is: iets dat kijkt of een naam of nummer in het spel echt bestaat.

| # | controle | welke fout vangt hij | bron | werk |
|---|---|---|---|---|
| C1 | **Bestaat het event / de functie?** Elke naam in onze code tegen Blizzards eigen lijst. De addon heeft 550 `RegisterEvent`-regels (GEMETEN). | Een event dat niet bestaat. Dat gaf op 8 aug een fout bij de reload. | Blizzards API-lijst op GitHub. GEMETEN: bereikbaar vanuit de cloud, build 12.1.5.70783, events staan er met hun naam in. | middel |
| C2 | **Bestaat het nummer?** Elk spell-, quest-, achievement-, item- en kaartnummer tegen Blizzards tabellen. | Een nummer dat verdwenen of veranderd is na een patch. | wago.tools, via `tools/gamedata.py`. Werkt op Robs pc (volgens `CLAUDE.md`); GEMETEN: **vanuit deze cloud geblokkeerd**. | middel |
| C3 | **Klopt de release-tekst?** Elk knoplabel en commando in `RELEASE_NOTES.md` moet in Locales of in de code staan. | Een knop in de release-tekst die niet bestaat (3 nov, gemeld door de site-chat). | onze eigen bestanden | klein |
| C4 | **Klopt de naam per taal?** Spelnamen in de/fr/es/pt/it/ru zijn de naam die dát spel toont. | Een zelfbedachte vertaling van een spelnaam. | wago.tools per taal | middel |
| C5 | **Staat elk nieuw onderdeel ergens waar je het vindt?** Elk nieuw venster heeft een commando in de lijst en een plek in de zoekbalk. | Een onderdeel dat niemand vindt. | onze eigen bestanden. Deels bestaat dit al (`check_command_list`). | klein |

**Wanneer ze draaien:**

- Bij elke push, op GitHub: C1, C3, C5 (hebben alleen GitHub of onze eigen bestanden nodig).
- Elke nacht, als vijfde wachter: C1 en C2 tegen de nieuwste build, ook de PTR. Hij meldt alleen, zoals de andere vier.
- C2 en C4 hebben wago.tools nodig. Of dat op GitHub of in een cloud-wachter kan, is NIET GEMETEN; in deze
  cloud-sessie is het geblokkeerd. Robs keuze: wago toelaten in de cloud-omgeving, of deze twee alleen lokaal draaien.

**Wat Rob ervan ziet:** één regel. *"Alles bestaat"* of *"3 dingen bestaan niet meer: …"*.

**Eerlijk over de grens:** deze controles zeggen dat iets **bestaat**. Niet dat het **werkt**, niet dat het in een
gevecht gelezen mag worden, en niet wie wat leert of wat iets kost (dat zijn serverfeiten).

---

## Deel 3 — luisteren en de ideeën-wachter

**Wat het Rob oplevert:** één keer per week hooguit drie ideeën, al getoetst, waar hij alleen ja, nee of later op
hoeft te zeggen.

**Wat er al is (volgens `CLAUDE.md`):** vier cloud-wachters (API, PTR, blue posts, content), elke ochtend. Plus de
ochtendronde: CurseForge- en GitHub-reacties, andere addons, HandyNotes, de mail van de site.

**De ideeën-wachter, wat nieuw is:**

- **Hoe vaak:** één keer per week. Vaker geeft ruis.
- **Waar hij leest:** de vier wachter-bestanden van die week, `docs/SURVEY_RESULTS.md`, CurseForge-reacties, en
  vragen van beginners op de forums.
- **Wat hij schrijft:** hooguit drie ideeën, in de vaste vorm, in de bak "Open" van `docs/IDEEEN.md`. Niets anders.
- **Drie harde regels voor hem:**
  1. Lees eerst "Af" en "Nee". Wat daar staat, stel je niet voor.
  2. **Meet eerst in de code of het al bestaat.** Dit is de les van 10 nov: drie van de vijf wensen bestonden al.
  3. Elk idee heeft een bron met een datum. Geen bron, geen idee.
- **Wat hij niet kan:** de mail lezen (de cloud-wachters hebben geen Gmail, volgens `CLAUDE.md`). De vragenlijst
  blijft dus werk van de ochtendronde.
- **Werk:** klein. Het is een opdracht, geen programma.

**Wat WoW niet toelaat:** meten wat spelers in de addon doen. Een addon kan niets terugsturen. Onze oren zijn dus
de vragenlijst, de reacties en de forums. Dat blijft een klein, scheef plaatje (31 antwoorden).

---

## Deel 4 — testen zonder het spel

**Wat het Rob oplevert:** hij test niet meer of iets **start**, alleen nog of het **goed voelt**.

**Wat er al is (GEMETEN):** drie kleine proeven die de addon buiten het spel draaien: `tools/locale_probe.lua`,
`tools/run_knowledge_fixtures.lua`, `tools/test_seasonstats.lua`. Het idee is dus bewezen, in het klein.

**4a. Het nep-spel**, in drie lagen. Elke laag is bruikbaar zonder de volgende.

| laag | wat hij doet | welke fout vangt hij | werk |
|---|---|---|---|
| 1 | Laadt alle 312 module-bestanden in de volgorde van de `.toc`, voor beide spellen, met nagemaakte spelfuncties. | Een crash bij het inloggen. Een bestand dat een ander nodig heeft dat later laadt. | middel |
| 2 | Opent elk venster en draait elk `/mh`-commando één keer. | Een crash bij het openen. Een ontbrekende tekst. | groot |
| 3 | Speelt situaties na: "een nieuw character van level 12", "een healer in een delve". | Een advies dat niet past bij de situatie. | groot, groeit mee |

- De nagemaakte spelfuncties komen uit dezelfde Blizzard-lijst als C1. Zo roept het nep-spel alleen functies aan
  die echt bestaan.
- **De grens:** het nep-spel geeft antwoorden die wíj erin stoppen. Het bewijst dat de code niet crasht. Het
  bewijst niet dat het spel hetzelfde antwoord geeft.

**4b. De zelftest in het spel (`/mh selftest`).** De addon loopt zichzelf na en schrijft het resultaat weg. Rob doet
één `/reload` en de AI leest het hele rapport.

- Wat erin komt: bestaat elk nummer in dít spel, heeft elk venster zijn tekst, antwoordt elke functie die we
  gebruiken. Per regel: goed, fout of "mocht ik niet lezen".
- Dit sluit aan op de bestaande regel dat elk onderdeel dat kan zwijgen een `/mh`-diagnose krijgt.
- GEMETEN: `selftest` komt nu nergens in de code voor. Werk: middel.

**4c. Wat alleen Rob kan blijven doen.** Dit lost geen controle op:

- hoe het eruitziet en of het prettig is,
- gedrag in een gevecht (geheime waarden, vergrendelde knoppen),
- botsingen met andere addons,
- of een beginner het begrijpt. Daar is Cisca voor.

---

## Deel 5 — samenwerken: bouwchat, site-chat, wachters, helpers

**Wat het Rob oplevert:** hij hoeft geen berichten meer door te geven, en de site zegt nooit iets anders dan de addon.

**De kaart: wie doet wat**

| wie | doet | raakt aan | zegt het tegen |
|---|---|---|---|
| Rob | beslist, test in het spel, zet releases en de site live | — | iedereen |
| Cisca | test grote dingen als beginner | — | Rob |
| bouwchat | bouwt de addon (Midnight en Forever) | alleen de addon-repo | het prikbord |
| site-chat | bouwt de site | alleen de site-repo | zijn vragenbestand |
| 4 wachters + de vijfde | lezen en melden, repareren nooit | elk één bestand | de ochtendronde |
| ideeën-wachter | stelt voor | alleen `docs/IDEEEN.md` | Rob |
| helpers (research, writer, sweep) | zoeken uit, schrijven, tellen | wat de opdracht noemt | de chat die ze roept |

Eén regel houdt dit bij elkaar: **elk bestand heeft één schrijver.**

**Het prikbord** (Rob: ja; de site-chat: ja):

- `docs/SITE_SEIN.md` in de addon-repo. De bouwchat schrijft, de site-chat leest bij elke start.
- Per regel: datum, tag en commit, **status**, mag het op de site, wat de speler ziet, knoplabels als sleutel, commando's.
- De site-chat schrijft zijn vragen in zijn eigen repo. De bouwchat leest die bij elke start.

**Drie vaste woorden voor "is het uit?"**, overal hetzelfde:

1. *alleen op main*: gebouwd, niet uit.
2. *getagd*: de release loopt.
3. *staat op CurseForge*: spelers hebben het.

Alleen bij 3 mag de site het als "nieuw" melden.

**Werk:** klein. Het zijn afspraken en twee bestanden. De bouwchat en de site-chat moeten het elk in hun
ochtendritueel zetten.

---

## Deel 6 — vaste recepten

**Wat het Rob oplevert:** dingen die elke week terugkomen gaan elke keer hetzelfde, zonder dat iemand een stap vergeet.

| recept | wat het doet | staat nu |
|---|---|---|
| **goedemorgen** | de hele ochtendronde, met één kort verslag aan het eind | als stappen tekst in `CLAUDE.md` |
| **nieuwe tekst** | Engels, Nederlands, de andere talen, drift-controle, vertaalproef | verspreid in `CLAUDE.md` |
| **release** | versie, changelog, release-tekst, controles C1–C5, het prikbord | `docs/RELEASE_CHECKLIST.md` |
| **nieuw onderdeel** | sjabloon met een `/mh`-diagnose, een commando in de lijst, een plek in de zoekbalk | een regel in `CLAUDE.md` |
| **idee toetsen** | één idee door de toets, eerst meten of het al bestaat | nieuw |
| **afsluiten** | overdrachtsbriefje bijwerken, splitsen als het te lang is | een regel in `CLAUDE.md` |

- Een recept is een opdracht die de AI op commando uitvoert. Het leeft op Robs pc, naast de helpers. Die map kan
  deze sessie niet zien; wat er al staat is NIET GEMETEN.
- Werk: klein per recept. Het meeste bestaat al als tekst en hoeft alleen een vaste vorm.

---

## Deel 7 — regels worden controles

`CLAUDE.md` is 521 regels; het teken 🔴 staat op 26 regels (GEMETEN). Veel daarvan is een les uit een fout.
Een les die de AI moet onthouden, kan vergeten worden. Het bewijs staat in de repo zelf: `tools/bash_guard.py`
zegt in zijn eigen kop dat een regel vijf keer gevraagd en vijf keer vergeten werd, en dat daarom een script hem
nu afdwingt.

Kandidaten om van tekst een controle te maken:

| les in `CLAUDE.md` | wordt |
|---|---|
| "na elke Engelse correctie: drift-controle" | draait vanzelf bij elke commit die `enUS.lua` raakt |
| "werk het overdrachtsbriefje bij in dezelfde commit" | waarschuwing als code verandert en het briefje niet |
| "splits het briefje boven 1500 regels" | waarschuwing bij 1400 |
| "release-tekst gelijk aan de CurseForge-kopie" | controle bij de release |
| "een leeg zoekresultaat bewijst niets" | het zoek-gereedschap vraagt zelf om een tegencontrole |

Daarna kan `CLAUDE.md` korter: de werkwijze en de kaart bovenaan, de geschiedenis naar een eigen bestand.
Werk: klein per regel. Dit kan stukje bij beetje.

---

## De volgorde van bouwen

| # | wat | werk | wat Rob moet doen |
|---|---|---|---|
| 1 | Toets en ideeënlijst | ✅ af | ja/nee/later per idee, als het uitkomt |
| 2 | Het prikbord en de drie vaste woorden (deel 5) | klein | ja zeggen; beide chats inlichten |
| 3 | Controles C1, C3, C5 (deel 2) | middel | niets |
| 4 | Controle C2 en C4 | middel | kiezen: wago in de cloud toelaten, of alleen lokaal |
| 5 | De vijfde wachter en de ideeën-wachter (deel 2 en 3) | klein | twee routines aanzetten |
| 6 | De recepten (deel 6) | klein per stuk | niets |
| 7 | `/mh selftest` (deel 4b) | middel | één keer `/reload` en zeggen wat hij zag |
| 8 | Het nep-spel, laag 1 (deel 4a) | middel | niets |
| 9 | Het nep-spel, laag 2 en 3 | groot | niets |
| 10 | Regels worden controles (deel 7) | doorlopend | niets |

Waarom zo: 2 kost bijna niets en lost drie van de vier klachten van de site-chat op. 3 tot 5 vangen de fouten
die nu het vaakst bij Rob terechtkomen. Het nep-spel is het grootste werk en komt daarom laat; de zelftest levert
eerder iets op.

"Werk" is overal mijn inschatting (AFGELEID), geen meting.

## Wat dit systeem niet doet

- Het vervangt Robs oog niet. Het haalt alleen weg wat een machine kan zien.
- Het bedenkt geen doel. Het toetst ideeën aan het doel dat Rob heeft gegeven.
- Het helpt niet als het zelf niet klopt. Elke controle krijgt daarom een proef die bewijst dat hij een bekende
  fout ook echt vindt.

## Robs antwoord op het plan (10 nov, avond)

- Het plan klopt. De volgorde is goed. De zesde toetsvraag: ja.
- wago.tools in de cloud: *"wat mij betreft wel"*.
