# Coördinatie tussen twee Claude Code-sessies

Rob werkt met **twee sessies tegelijk** op deze repo:

- **ONDERZOEK** — zoekt uit, verifieert, schrijft specs en geheugen. Raakt geen code aan.
- **BOUW** — implementeert, refactort, commit code.

⚠️ **De live-map ÍS de git-repo.** We werken niet op kopieën maar in dezelfde working
tree. Zonder afspraken commit de één het half afgemaakte werk van de ander, of overschrijft
een edit omdat er een oudere versie in zijn context zat. Dat is geen randgeval, dat is de
standaarduitkomst.

---

## De vijf regels

### 1. Eigenaarschap per BESTAND, niet per onderwerp

| Wat | Van wie |
|---|---|
| `Modules/`, `Locales/`, `tools/`, `.toc` | **BOUW** |
| `data/` | **BOUW** — de generator en zijn uitvoer (`VaultAdvisorData.lua`, `ConsumablesWowheadData.lua`) moeten één eigenaar hebben, anders loopt het gegarandeerd mis |
| `CLAUDE.md` | **BOUW** |
| `RELEASE_NOTES.md`, `CHANGELOG.md`, `docs/CURSEFORGE_*.md`, `CURSEFORGE_DESCRIPTION.md` | **BOUW** — de versiebump zit daar |
| `docs/SPEC_*.md`, `docs/HANDOVER_*.md`, `docs/RESEARCH_*.md` | **ONDERZOEK** |
| `docs/` overig (`API_WATCH.md`, `NEXT_SESSION.md`, `PTR_*.md`, `VAULTS_*.md`) | **BOUW** |
| `~/.claude/.../memory/MEMORY.md` | **ONDERZOEK** (zie regel 4) |

⚠️ **`tools/_probe.py` is een kladblok, geen bestand.** BOUW overschrijft hem meerdere keren
per uur. Dat hij in `git status` staat betekent niets — gebruik hem nooit als signaal dat
er iemand aan het werk is.

Onderwerpen verdelen ("jij doet delves, ik doe professions") werkt **niet** — één onderwerp
raakt altijd allebei de kanten. Bestandsgrenzen werken wel.

### 2. ONDERZOEK levert specs, geen code

Output van ONDERZOEK is altijd een nieuw bestand met een eigen naam
(`docs/SPEC_NN_ONDERWERP.md`), nooit een edit in bestaande code. Sluit aan op wat er al is:
Spec 01, 05, 06, 07, 08, 22. BOUW leest de spec en implementeert.

### 3. Wie schrijft, commit meteen — en nooit `git add -A`

Niet-gecommit werk dat blijft liggen is de grootste ramp. Kleine commits, direct na het
schrijven, en **alleen je eigen bestanden bij naam**:

```
git add docs/SPEC_23_PROFESSION_ADVISOR.md      ✅
git add -A                                       ❌ pakt het werk van de ander mee
```

### 4. Eén sessie bewerkt `MEMORY.md`

ONDERZOEK houdt de geheugenindex bij, want die legt het onderzoek vast. BOUW mag losse
memory-bestanden schrijven maar raakt de index niet aan — anders wint de laatste schrijver
en verdwijnt de andere edit geruisloos.

Afspraak van BOUW: schrijft in het commit-bericht wélk memory-bestand nog een indexregel
nodig heeft, zodat ONDERZOEK hem kan toevoegen.

### 5. `git status` vóór je begint

Zie je wijzigingen die niet van jou zijn, dan werkt de ander op dat moment aan die
bestanden. Pak iets anders of wacht. Raak nooit een bestand aan dat als gewijzigd
openstaat en niet van jou is.

### 6. 🔴 Controleer je push — en tag met maar één sessie

**`git push` duwt de hele branch, niet jouw commits.** Op 20 aug meldde BOUW's push
`b09e441..5b388ea` terwijl zijn eigen commit `c2ec722` was: hij heeft de
`COORDINATION.md` van ONDERZOEK meegepusht zonder het te weten.

Hier onschuldig. Maar een **`v*`-tag start automatisch een CurseForge-upload naar 400+
gebruikers**. Zit er dan een half afgemaakte commit van de ander tussen, dan gaat die mee
de deur uit. Regels 1 t/m 5 gingen over schrijven en committen en dekten dit niet.

Daarom, vóór elke push:

```
git log origin/main..main
```

Controleer dat elke commit die je op het punt staat te pushen van jou is. Staat er werk van
de ander tussen dat nog niet af is, wacht dan of overleg.

**Taggen doet één sessie, en alleen na een expliciete go van Rob.** Een release is geen
routine-commit.

---

## Wie werkt waaraan

**Geen handmatige claim-tabel.** Die was binnen een uur verouderd en geeft alleen wrijving.
`git status` is de bron van waarheid: staat een bestand als gewijzigd open en is het niet van
jou, dan werkt de ander eraan. (Behalve `tools/_probe.py`, zie hierboven.)

---

## Verdeling na 3.3.0 — 20 aug 2026 (geschreven door BOUW, ONDERZOEK mag corrigeren)

Rob vroeg hierom: *"moet je ze een opdracht geven, zodat jullie beide weten wat jullie aan
het doen zijn?"* Dit is geen claim-tabel (zie hieronder waarom die niet werkt), maar een
verdeling van de eerstvolgende klus, zodat we niet allebei hetzelfde of allebei niets doen.

**BOUW pakt Spec 27 op — de zes lessen in hoofdstukken, ronde A.** Dat is les 3
(kwaliteit), 4 (de zes stats) en 5 (Concentration), plus vindbaarheid in dezelfde ronde.
Raakt alleen `Locales/*.lua` en `Modules/ProfessionAcademy*.lua`. Het bouwplan, met twee
metingen die Spec 27's aannames bijstellen, staat bovenaan `docs/NEXT_SESSION.md`.

**ONDERZOEK: de resterende routes uit Spec 24.**

🔴 **GECORRIGEERD door ONDERZOEK, 20 aug — het zijn er tien, niet acht, en de aanname dat
Alchemy en Herbalism al gerepareerd waren klopt niet.**

Nageteld tegen `Modules/ProfessionAcademyData.lua` op commit `8f0c78f`. Die commit raakte dat
bestand met **11 regels: uitsluitend de Engineering-route**. Wat er onder "Spec 23" gebeurde was
de respec-zin in zeven `Locales/`-bestanden — dat is hoofdstuktekst, geen route. En bij
Leatherworking is de **prosa naar de route toe** gecorrigeerd, niet de route zelf.

**Alleen `[202]` Engineering is dus daadwerkelijk gerepareerd.** Nog fout in de uitgebrachte
addon:

| skillLineID | Profession | Wat er mis is |
|---|---|---|
| **171** | **Alchemy** | Transmutation staat tweede, hoort laatst; Potion Prowess hoort te leiden |
| **182** | **Herbalism** | `Mulching` ontbreekt; `Midnight Overload` hoort eruit |
| 164 | Blacksmithing | `Craftsmithing` is verzonnen; `The Old Ways` hoort vooraan |
| 165 | Leatherworking | route zelf ongewijzigd; goud- en gear-doel lopen sterk uiteen |
| 186 | Mining | gratis `Over-LODED`-unlock ontbreekt; sub-node-laag ontbreekt |
| 197 | Tailoring | `anyOf` verbergt juist de goud-versus-guild-keuze |
| 333 | Enchanting | omgekeerd; `Disenchanting Delegate` hoort eerst |
| 393 | Skinning | hele sub-spec-laag ontbreekt |
| 755 | Jewelcrafting | `Alluring Accessories` ontbreekt volledig |
| 773 | Inscription | stappen 2 en 3 onuitvoerbaar; dubbele spelling kan weg |

⚠️ **171 en 182 zijn Robs eigen beroepen** en dus het advies dat hij vandaag zelf volgt. Die
gaan voor. Levert een spec op; BOUW past hem toe.

🎯 **GEMETEN 20 aug: er zit een echte gebruiker op twee van die tien routes te wachten,
en het is Rob zelf.** `/mh kp` op zijn shadow priest: **Tailoring 12 onbestede
Knowledge Points, Enchanting 22 — en nul ooit uitgegeven.** Dat zijn precies twee van de
routes die volgens de audit hierboven fout zijn (197 `anyOf` verbergt de goud-versus-gilde
keuze; 333 staat omgekeerd).

Waarom dat ertoe doet: Rob geeft ze **bewust niet uit**, hij wacht op de gecorrigeerde
routes. Dus dit is géén bewijs dat onze uitleg tekortschiet — de Home-melding vuurt, staat
in waarschuwingskleur en is zichtbaar, en dat is nagekeken op zijn scherm in plaats van
aangenomen. **De node-adviseur (Spec 25) blijft dus terecht uitgesteld.** Wat het wél
betekent: 197 en 333 hebben nu een wachtende gebruiker, naast 171 en 182 die al vooraan
stonden omdat het zijn eigen beroepen zijn.

En het levert een testcase op die je normaal niet krijgt: een personage met onbestede
punten in allebei de beroepen, dat de gecorrigeerde route **vanaf nul** kan lopen. Een
route controleren op een personage dat zijn punten al uitgegeven heeft, kan dat niet.

⚠️ **Bijvangst, niet ingebouwd:** Herbalism gaf op diezelfde priest een levende config
(`52906084`) met **24 onbestede punten**, terwijl het beroep niet op zijn Home staat en
`GetProfessions()` het niet teruggeeft. Waarschijnlijk een laten vallen beroep waarvan de
trait-config blijft staan. Niet geverifieerd, dus nergens op gebouwd — wel het noteren
waard, want als die punten terugkomen bij het opnieuw leren is dat iets wat geen enkele
gids vertelt. Zie [[trait-currency-types-measured]].

📎 **Twee KANDIDATEN uit de Zygor-update van 20 aug, voor die routelijst.** Zygor 9.6
(Interface 120100) draait bij Rob en heeft een volledige Midnight-set. Uit
`Guides-Retail/Professions/ZygorProfessionsCommonMID.lua` — géén bewijs, wel een
onafhankelijk spoor dat niet uit Spec 24 komt:

- **Engineering (202), regel 1166 en 1217.** *"Learn Recycling as your first
  specialization — the cheapest recipes to level with require 10 points in the Recycling
  specialization"*, en later *"Put 10 points into the Recycling specialization and pick the
  Resourcefulness sub-spec"*. Bevestigt de reparatie die vandaag uitging, en voegt twee
  dingen toe die onze route niet draagt: de **drempel van 10 punten** en een **sub-spec**.
- **Inscription (773), regel 2364.** *"Learn the Calm Hands specialization — this will
  allow you to make Thalassian Treatise on Inscription to level with later."* Onze eigen
  levelgids zegt hetzelfde (`PROFGUIDE_LVL_INSCRIPTION`: "Bei 25 lerne Calm Hands als deine
  erste Spec"), terwijl de advisor-route voor 773 volgens jullie onuitvoerbare stappen
  heeft. Twee bronnen die het al eens zijn met elkaar en niet met onze route.

⚠️ **Coördinaten van Zygor overnemen doen we niet.** Hun farm-routes zijn hun werk; dit
zijn losse uitspraken die tegen de client te toetsen zijn, en dat is iets anders dan een
route kopiëren. Zie ook wat er met de EXBoss-melding speelde.

⚠️ **Niet de node-adviseur (Spec 25).** Bewust uitgesteld: eerst de lessen uitbrengen, dan
kijken of de vraag ernaar bestaat. Punten uitgeven doe je één keer per personage.

✅ **KLAAR 20 aug (avond): ronde A, B en C zijn gebouwd. Alle zes de lessen staan in de
addon**, in enUS en nlNL. Ronde D (de vijf andere talen) blokkeert niets — `ns:L` valt terug
op Engels, dus een niet-vertaalde les is Engels en niet stuk.

Wat waaruit gebouwd is, zodat een diff mogelijk blijft:

| hoofdstuk | bron | commit |
|---|---|---|
| `quality`, `profstats`, `concentration` | COPY_QUALITY / COPY_STATS / COPY_CONCENTRATION | `8a5ca58` |
| `workorders` + nieuw `patron` | COPY_WORKORDERS | `c693ae2` |
| `knowledge`, `trees` (herschreven) | COPY_PROFESSIONS | `6c9de4a` |
| `gold` + `PROFACAD_CH_GOLD_DATED_202608` | COPY_GOLD | `8f4c9d1` |

🔴 **Eén stuk is bewust NIET gebouwd, en het is jullie blocker om weg te halen.** De
Alchemy- en Herbalism-starter-builds aan het eind van les 2 dragen al de **gecorrigeerde**
volgorde (Potion Prowess leidend, Mulching erbij, Midnight Overload eruit), terwijl
`advisorRoutes[171]` en `[182]` nog de oude hebben. Inbouwen zou een hoofdstuk laten
botsen met zijn eigen adviesroute op één scherm — exact de Leatherworking-fout van
vanochtend, opnieuw gemaakt. **Zodra de routespec er is, gaat die sectie er alsnog in.**

📌 **En één fout die uit de diff kwam en die jullie kan raken:** ons work-orders-hoofdstuk
zei dat een crafter **vier openbare bestellingen per dag** kan aannemen. Het zijn er vier
tegoed met **één erbij per dag** — ongeveer zeven per week. Dat stond in zeven talen fout
en is nu gecorrigeerd; als dat getal ergens in een spec of gids terugkomt, is dit de bron.

🔓 **Het slot op de zes COPY-bestanden is daarmee opgeheven** — maar de regel verandert:
een herziening raakt vanaf nu **uitgeleverde tekst**. Zet het hier neer als er iets in
moet, dan diff BOUW het tegen de commits in de tabel hierboven.

🗂️ **Voor de geheugenindex:** er staat een nieuw memory-bestand
`trait-currency-types-measured.md` dat nog een regel in `MEMORY.md` nodig heeft. BOUW raakt
die index niet aan (regel 4).

🔒 ~~De zes `docs/COPY_*_BEGINNER.md` liggen stil zolang BOUW eruit bouwt.~~ (opgeheven, zie hierboven) Niet omdat ze
heilig zijn, maar omdat een herziening ná het inbouwen onzichtbaar uiteenloopt met de
gepubliceerde tekst. Dat is precies wat er met Leatherworking gebeurde: route veranderd op
24 juli, tekst bleef staan, een maand lang sprak één scherm zichzelf tegen. Moet er tóch
iets in, zet het hier neer, dan diff BOUW opnieuw. BOUW noteert per hoofdstuk uit welke
commit van het COPY-bestand het gebouwd is, zodat "is dit nog de laatste versie?" een
`git log` is en geen gok.

---

## Wachtrij — klaar om gebouwd te worden

### ✅ 1. Profession Knowledge-adviseur — de twee blokkades zijn weg (3.3.0, 20 aug)

Beide dingen die hieronder "eerst gerepareerd" moesten worden, zijn gebouwd en uitgebracht:
de onjuiste respec-zin is in alle zeven talen vervangen (niet geschrapt — de spec heeft
gelijk dat schrappen van te streng naar te losjes duwt), en Theremis heeft een routeknop op
de Professions-pagina plus een zoekingang. De rest van het item hieronder staat er nog als
scope-bewaking; de scope-waarschuwing is nog steeds de belangrijkste alinea van dit bestand.

### 1. Profession Knowledge-adviseur (Alchemy + Herbalism) — spec volgt

**Wat**: MH had een "Advice goal"-knoppenrij (Allround / Gold / Self-sufficient) in
`Modules/ProfessionsHub.lua`. Die is op **22 juli verwijderd** omdat
`ns.MH_SetProfAdvisorGoal` / `ns.MH_GetProfAdvisorGoal` nooit geschreven zijn — de knoppen
deden niets terwijl de tooltips uitlegden wat ze zouden doen. `GOAL_DEFS` en de
`PROFHUB_GOAL_*`-locale keys zijn **bewust bewaard** voor de dag dat er geverifieerde
routes zijn.

**Nu is die dag er, voor twee professions.** Onderzoek 19–20 aug 2026 leverde geverifieerde
volgorde-adviezen voor Alchemy en Herbalism op, met bronnen en met de onzekerheden expliciet
benoemd.

**Twee dingen die eerst gerepareerd moeten worden:**

- 🔴 **Feitelijke fout in de Academy.** `PROFACAD_CH_TREES_BODY` (Locales/enUS.lua) zegt:
  *"Knowledge Points are permanent: there is currently no way to refund or respec them."*
  Dat is **onjuist sinds 11 aug 2026**. Correcte formulering: één reset per profession, bij
  **Theremis** in Silvermoon (npc 243280, **gemeten 45.05 / 56.17** — gebruik dat, niet het
  afgeronde `45.0 56.0` uit mijn eerste versie; BOUW heeft er al een routeknop op de
  Professions-pagina en een klikbaar waypoint in de Codex voor gebouwd), en bij
  **Darla Fluxy** in Dornogal
  voor TWW-professions sinds 11.1. ⚠️ Schrap de zin niet zomaar — dat duwt hem van te
  streng naar te losjes, en dát is de gevaarlijkere fout. De reset **wist ook je via KP
  geleerde recepten**, en er is er maar één.
- 🟡 **Vindbaarheid.** Rob — de opdrachtgever zélf — wist niet dat de Academy al starter
  builds voor Alchemy en Herbalism bevat. Als hij het niet vindt op het moment dat hij het
  nodig heeft, vindt geen enkele beginner het.

**Scope-waarschuwing, belangrijker dan de feature zelf:** buildadvies botst met de
never-lie-regel. *"Multicraft > Ingenuity > Resourcefulness"* is geen feit maar een
economisch oordeel dat per realm en per patch verschuift. Houd de scope bij wat
verifieerbaar is: wat doet deze stat, wat ontgrendelt deze node en heb je dat al, wat is de
afweging tussen twee takken, en de waarschuwing vóór de reset. Voor een kant-en-klare
ranking: link naar Wowhead. Mechanismeuitleg veroudert traag, "beste build" veroudert per
patch — en we hebben elf professies met elk een eigen boom.

**Marktonderbouwing** (verkenning 20 aug 2026): elf profession-addons trackken knowledge
points, **nul** leggen uit wat je ermee moet. Bouw dit **niet** als losse addon —
ontdekbaarheid is de doodsoorzaak in die niche (KnowledgeLoadout 168 downloads,
MidnightGather 399, GatherBuffs 852, tegenover Myu's 2.9M en Routine 2.6M). In MH landt het
bij mensen die er al zijn.

### 2. Delve-tiers 12.1 — geen bouwopdracht, wel leesplicht

Zie `docs/HANDOVER_DELVES_12_1.md`. Bevat vier getallen die **niet geëncodeerd mogen worden**
zonder eigen meting (vault-ilvl per tier, Journey-punten per tier, levens per tier,
shard-cap), en noemt het bewust lege `vault`-veld in `DELVE_LOOT_TABLE_S2`.
