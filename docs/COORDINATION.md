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

## 📌 REGEL 7 — dit bestand bijwerken hoort bij "klaar"

**Rob, 22 aug 2026:** *"denk aan de samenwerking MD, die moet standaard als we klaar zijn
geschreven/bijgewerkt worden."*

Niet als een sessie er zin in heeft, maar als vast onderdeel van afronden. De reden is
vandaag drie keer bewezen: dit bestand stond twee keer een klus aan te prijzen die al af
was, en één keer een aanname die de andere sessie moest komen corrigeren. Wie het hier niet
leest, begint aan werk dat niet meer bestaat.

Wat "bijwerken" minimaal betekent: wat er af is verhuist naar geschiedenis, wat er open
staat komt bovenaan, en een aanname die onderweg onjuist bleek wordt **doorgestreept in
plaats van stil verwijderd** — de correctie is vaak nuttiger dan de oorspronkelijke regel.

---

## 🧭 23 aug (avond) — reisadvies: twee implementaties, en een stokje dat viel

Rob stond náást het Coiled-Isle-portaal, klikte een waypoint voor een delve óp dat eiland,
en kreeg "vlieg van Sanctum of Light naar Tokka's Landing" met een pijl 8 km de zee op.

Er ontbrak niets in de data: het portaal staat in `MIDNIGHT_PORTALS` met de juiste
bestemming, zijn quest-poort stond groen (`/mh portals` bevestigde het), en de delve staat
in ons eigen rooster op map 2512. **`BuildTravelPlan` probeert portalen vóór vliegen — het
waypoint-pad vroeg het alleen nooit** en sprong regelrecht naar `GetNearestFlightPoint`.
Twee implementaties van één vraag, en de kortste leverde het slechtste antwoord.

Daarna bleek de pijl een tweede, apart gat te hebben. `RouteFirstToFlightPoint` raadpleegde
de planner wél en trok zich netjes terug zodra de eerste stap op je huidige kaart staat —
*"let the plan lead"*. Maar er leidde niemand: het bestemmings-waypoint was al eerder gezet
en niet-verleggen liet het staan. Nu verlegt die stand-down hem zelf via
`AddSmartTomTomWay`.

📌 **Patroon om te onthouden, want dit is de derde keer deze week:** als tekst en pijl (of
tekst en data) elkaar tegenspreken, zoek niet naar ontbrekende gegevens maar naar **twee
plekken die dezelfde vraag beantwoorden**. Zo ging het ook bij de cursustekst
(`ComposeChapterBody`) en bij de Leatherworking-route.

~~⚠️ **Open gebleven en bewust niet half gebouwd:** wat de pijl doet nadat je door een
portaal bent. Je komt aan met een verbruikte pijl — hetzelfde gat als in
`route-arrow-no-resume` (22 jul). Eigen klus.~~

✅ **Toch dezelfde avond af, en kleiner dan gedacht** (`b0138e7`). Het mechanisme bestond al:
`StartLegWatcher()` gaf na een vlucht het stokje door aan de eindbestemming. Het stond alleen
in de vlucht-tak ingebakken. Uitgetild, en de portaal-tak armeert hem nu ook.
⚠️ Zijn `pendingLeg` krijgt **geen** `toName` — dat veld is de aankomsttest van een vlucht, en
invullen zou de portaal-etappe laten wachten op een aankomst die nooit komt.
Dit blijft los staan van `route-arrow-no-resume`: dat gaat over een eigenaar-slot zonder
geheugen, niet over een etappe die zijn opvolger niet aanwijst.

---

## ✅ 23 aug (avond) — de vertaalronde is binnen, en de repo was even op slot

**44 commits op `main`** (`9ad71f3..9da3cbc`), `luac` schoon, linter 0 hard / 0 soft.
Dekking sprong ver voorbij de klus die hieronder gepland stond:

| | 22 aug | nu |
|---|---|---|
| deDE | 76,5% | **90,9%** |
| frFR | 74,1% | **91,0%** |
| esES / ptBR | 73,2% | **91,0%** |
| itIT | 71,1% | **89,5%** |
| nlNL | 94,0% | 94,0% |

De professie-cursus zelf: **194 van de 212 klaar in alle zes de packs**, nog 400 tekens —
was 20.201.

### 🔴 Die laatste 400 tekens bestonden niet — en dat is een les over het meetinstrument

Alle 18 sleutels nagelopen: **geen enkele was onvertaald.** Onze eigen addonnaam, twee
strings zonder woorden erin (`"%s x%d"`), `"Gold"` (dát is Duits — deDE gebruikt het 6×),
zeven professienamen die nlNL Engels houdt volgens dezelfde regel die zijn eigen zinnen
volgen (*"Leather gebruikt Leatherworking"*), en `"Open in browser"`, dat toevallig identiek
Nederlands is.

De resolver kan een **bewuste** Engelse kopie niet onderscheiden van een **ontbrekende**
vertaling. Dat is de tweede manier waarop dit gereedschap misleidt, en de spiegel van de
eerste (aanwezigheid ≠ vertaald, 22 aug). Een waarschuwing in de voettekst stond er al en
hield het niet tegen — dus staan de uitspraken nu ín `tools/translation_todo.py` als een
`SETTLED`-tabel **mét reden per sleutel**. Zonder die reden is het een stomme negeerlijst en
moet de volgende lezer het hele onderzoek overdoen. 400 tekens → 17.

⚠️ **En pas op met zelfgebouwde tellers.** Ik schreef vanavond twee keer een eigen sonde om
de dekking te meten; **allebei fout**, en de eerste in de geruststellende richting (hij las
de fill-bestanden zonder onderscheid naar taal, dus een Duitse fill telde ook voor Italiaans).
Hij was het oneens met de linter — 107 tegen 311 voor deDE — en dát verschil was het
signaal. `locale_probe.lua` is het enige instrument dat telt.

### 📊 Wat die 89–91% wél betekent

Niet wat het lijkt. Van de ~306 resterende sleutels per pack zijn er **311 `CHANGELOG_*`**,
Engels met opzet. Meet je in plaats daarvan **zinnen** (≥4 echte woorden), dan blijven er in
de vijf packs **nul** over. De allerlaatste was `WAY_PORTAL_HINT` — diezelfde avond
geschreven voor Robs portaal-melding, en vóór de tag vertaald. Wat verder Engels blijft zijn
stat-namen, `DPS`, `Flask`, `Bountiful` en format-strings.

---

## 🚀 23 aug (avond) — 3.5.0 staat klaar om te taggen

71 commits boven `v3.4.0`. `luac` schoon, linter 0 hard / 0 soft, `RELEASE_NOTES.md` en
`docs/CURSEFORGE_3.5.0.md` byte-identiek (46 regels / 3855 tekens / 2 bullets — ruim binnen
wat 3.3.0 al bewees, en de lengteregel is en blijft dood).

De belofte uit 3.4.0 — *"de andere talen volgen binnen enkele dagen"* — is ingelost en die
zin is uit `CURSEFORGE_DESCRIPTION.md` verwijderd.

⚠️ **Bewust laten staan, geen defect:** `PROFHUB_TAB_TREASURES` is in nlNL Engels terwijl
zijn twee buurtabs Nederlands zijn. `PROFHUB_OVERVIEW_HINT` noemt die tab óók in het Engels,
dus de twee spreken elkaar niet tegen. Het veranderen raakt uitgeleverde tekst voor smaak.
Staat als enige echte open vraag in de `--prefix`-uitvoer.

🔒 **Nieuw, alleen voor ontwikkelaars:** `tools/bash_guard.py` weigert shell-commando's met
`&&`, `||`, `;`, pijpen, heredocs of `python -c` — vormen die geen enkele toestemmingsregel
kan matchen, en de reden dat 86% van de Bash-aanroepen tóch een prompt gaf. Rob vroeg er
vijf keer om; een zesde belofte was niet de oplossing. Geregistreerd in
`AddOns/.claude/settings.json`, dat **boven** deze repo ligt en dus niet in git zit — na een
herstart van Claude Code actief.

🔴 **LES: draai `git am` nooit op de live map vanuit een omgeving die niet kan opruimen.**
De cowork-sessie deed dat, de `am` faalde (die VM heeft geen git-identiteit), en de brug
daar mag geen bestanden verwijderen — dus bleven `.git/index.lock`, `HEAD.lock`,
`packed-refs.lock` en `rebase-apply/` staan en zat git volledig op slot. Robs game bleef
gewoon draaien, want de Lua was geldig, maar er kon niets meer geschreven worden.

Opruimen vanaf een omgeving die wél mag verwijderen: **eerst controleren dat er geen
git-proces draait** (`tasklist`), dan de locks weg, dan `git am --abort`. ⚠️ Struikelt de
abort over "Entry ... not uptodate", dan staat er een niet-gecommitte bewerking in de weg —
`git checkout -- <bestand>` en opnieuw.

📌 **Twee dingen die deze ronde opleverde en die blijven gelden:**
- **wago.tools is vanaf de cowork-omgeving geblokkeerd** (egress-allowlist, niet
  robots.txt). Die bron werkt alleen vanaf Robs eigen machine. Wie daar een naam moet
  opzoeken: vraag het hier, of gebruik de Blizzard API met token.
- **De duplicaatcontrole in de linter snapt nu fill-only merges.** Een fill-sleutel bovenop
  een pack dat daar nog een letterlijke Engelse kopie heeft is het systeem dat wérkt; twee
  echte eigenaren blijft een botsing, en een fill die nooit kan winnen heet nu een *dead
  fill*. Die aanpassing komt van de cowork-sessie en is nagekeken — hij dempt niets.

⚠️ **Nog open, en het is Robs beslissing:** `PROFHUB_GOAL_ALLROUND` staat in `deDE.lua` als
`"Allround"`, wat eerder Engels dan Duits is. `"Ausgewogen"` is waarschijnlijk beter, maar
het is uitgeleverde tekst.

---

## ~~🌍 KLUS VOOR 23 aug — de professie-cursus áf maken~~ *(gedaan, zie hierboven)*

**Start met dit commando. Geen geplakte lijst — die is verouderd zodra iemand één string
aanraakt.**

```
python tools/translation_todo.py --prefix PROFACAD_,PROFGUIDE_,PROFHUB_,PROFNEXT_,PGUIDE_ --text
```

**Stand nu: 153 van de 212 klaar in alle zes de packs, 20.201 tekens te gaan** over alle
talen samen. Dat is ongeveer een zevende van de klus van 22 aug.

⚠️ **Waarom deze 59 zijn blijven liggen, en het is geen slordigheid van wie 22 aug deed.**
Die opdracht was *"alles wat sinds v3.3.0 nieuw is"*, en deze strings zijn **ouder** dan die
tag — ze vielen dus buiten de scope, terwijl de tool netjes "klaar" meldde. Daarom heeft
`translation_todo.py` er sinds vanavond een tweede vraag bij: `--since` beantwoordt *"wat is
er nieuw sinds een release"*, `--prefix` beantwoordt *"wat is er nog Engels in dit
gebied"*. De tweede heeft die blinde vlek niet.

**Grootste stukken eerst:** `PROFACAD_CH_ENCHANTING_ADVANCED` (565 tekens) springt eruit;
daarna is het vooral de rij intro-zinnetjes boven de beroepshoofdstukken (Alchemy, Mining,
Herbalism, Inscription, Blacksmithing, Leatherworking — elk 150-300 tekens) en verder
knoplabels van tien tot dertig tekens.

**Zelfde afspraken als 22 aug:** alles gaat in `Locales/Translations2026.lua` (fill-only);
blijf van `enUS.lua` en `nlNL.lua` af; controleren door te **draaien**
(`lua tools/locale_probe.lua KEY`), niet door te tellen.

🔴 **En gebruik de bron die 22 aug vier fouten ving:**
`wago.tools/db2/<Tabel>/csv?build=<build>&locale=<code>` voor elke "hoe heet dit in taal X".
Wowhead is een kandidaat, Blizzards eigen DB2 beslist. Concreet uit die ronde: de zes
profession-stats en de Patron-tab hebben **wél** een vertaalde naam in de client — Engels
laten staan is daar de fout, niet de veilige keuze.

📌 **Als dit af is** kan de zin *"other languages follow within a few days"* van de
CurseForge-pagina af (`CURSEFORGE_DESCRIPTION.md`, onder de talentabel).

---

## ✅ STAND 22 aug (avond) — 3.4.0 is uit en de vertalingen zijn binnen

**Uitgebracht:** `v3.4.0` (tag op `f953036`), met de professie-cursus, de tien gecorrigeerde
routes, het cursusvenster, de inhoudsopgave, `/mh fp` en de vliegmeester-pins.
⚠️ **De vertalingen zitten NIET in 3.4.0** — die kwamen erna en gaan mee met de volgende.

**Vertalingen:** de tien commits zijn toegepast en gepusht (`5e0ab71..ff03d0b`), alleen
`Translations2026.lua` geraakt, `luac` schoon, en de resolver geeft 390 van de 392 OK. De
twee overblijvers zijn nlNL's bewuste Engelse kopieën van "Professions 101" en een kale
opmaakstring.

🔴 **Daarna vier fouten gevonden en gerepareerd**, met een agent tegen Blizzards eigen DB2 in
plaats van tegen Wowhead. **Die methode is de winst: `wago.tools/db2/<Tabel>/csv?build=<build>&locale=<code>`**
— kale CSV, gepind op buildnummer, geen rate limit. Gebruik dit voortaan voor elke
"hoe heet dit in taal X"-vraag.

| wat | waar | was | is |
|---|---|---|---|
| Deftness | itIT | Destrezza (bestaat niet in de client) | Velocità |
| Crafting Details | fr/es/pt | Engels gelaten | Détails de la fabrication / Detalles de fabricación / Detalhes da criação |
| Patron-tab | fr/es/pt | Engels gelaten | Client / Cliente / Cliente |
| Recipe Difficulty | fr/pt | Engels gelaten | Difficulté / Dificuldade da receita |

✅ **Twee dingen beslecht in het voordeel van de vertaler**: ptBR `Resourcefulness` verschilt
écht tussen paneel (`Desenvoltura`) en tooltip (`Devolução de recursos`), en ons hoofdstuk
verwijst naar het paneel — dus goed. En `Reuse` is aantoonbaar onvertaald in alle vijf de
clients (`TraitDefinition` 136970/136986), een slordigheid van Blizzard en terecht zo
gelaten.

**Twee tools repareerden hun eigen blinde vlek.** `translation_todo.py` telde of een sleutel
*bestond* in plaats van te vragen wat de speler ziet; hij draait nu `locale_probe`. En de
linter had `Coiled Isle` in zijn KEEP-lijst, terwijl Blizzard zones juist wél localiseert —
één verkeerde regel, geen kapotte controle.

**Ook nieuw sinds de release:** de Valeera-popup (verschijnt in een delve, verdwijnt erbuiten,
meet zelf wat een bountiful run oplevert) en de spec-bewuste regel bij Azta'rec die zegt
*waarom* Valeera op Healer moet — die verschilt per specialisatie en is Robs verzoek van
19 aug.

### 🔴 Openstaand, en twee ervan zijn ROBS beslissing

- **`CLAUDE.md`'s eigennamen-regel klopt niet meer.** Hij zegt dat Blizzard-eigennamen en de
  zes profession-stats Engels blijven; de client localiseert ze wél. De juiste toets is niet
  *"is het een eigennaam"* maar *"laat Blizzard het Engels"*. **Niet aanpassen zonder Rob.**
- **De oudere strings in de vijf packs** dragen nog `Wissenspunkte`, `puntos de Conocimiento`
  enzovoort naast de nieuwe termen. Eén zoek-en-vervang, maar het raakt uitgeleverde tekst.
  **Niet zonder Rob.** ⚠️ Op 22 aug per ongeluk twee Franse strings hierin geraakt door een
  te brede vervanging; teruggedraaid.
- **De vertaalmelding praat onzin** tegen wie al een pakket heeft (`OpenTranslateHelp()` in
  `TranslateNudge.lua` print `TRANSLATE_HELP_LANG` onvoorwaardelijk, dus enUS krijgt "jouw
  taal heeft zijn eerste pakket nodig"). En het staat in de chat.
- **`points = 0`** (`PROFACAD_ADVISE_NEXT_OPEN_FMT`, Mining's `Over-LODED`) is nog nooit
  door iemand gerenderd gezien.
- **`Oddball Ingredient`** — nieuw delve-item met draaglimiet sinds 21 aug, nul treffers in
  de repo.

---

## 🌍 AFGEROND — de vertaalklus van 22 aug *(zie de stand hierboven)*

**3.4.0 is uit** (tag `v3.4.0`, 21 aug). Wat er nu ligt is één grote, goed afgebakende klus:
**56 teksten × 5 talen ≈ 148.000 tekens.**

⚠️ **Eigenaarschap tijdelijk aangepast, want dit is het enige zinnige.** `Locales/` staat in
de tabel als BOUW, maar deze klus zit vrijwel volledig in **`Locales/Translations2026.lua`**
— het fill-only bestand voor de vijf niet-Nederlandse packs. **Dat ene bestand is voor deze
klus van ONDERZOEK.** BOUW blijft van `enUS.lua` en `nlNL.lua` af tijdens de klus, en raakt
`Translations2026.lua` niet aan. Zo hoeft niemand te wachten en botst er niets.

**Begin met `python tools/translation_todo.py --text`.** Dat leest enUS en de vijf packs
zoals ze nu zijn en print per sleutel de Engelse tekst, de grootte, en of hij ontbreekt of
STALE is. Een geplakte lijst zou verouderen; dit kan niet met de addon van mening verschillen.

🔴 **STALE gaat vóór missing, en dat verschil is belangrijk.** Een sleutel die in een pack
ONTBREEKT valt terug op Engels en is dus niet stuk. Een sleutel die er WÉL in staat toont
wat dat pack zegt — dus bij een tekst die wij herschreven blijft de oude versie staan. Op
21 aug zijn zeven van die verouderde vertalingen uit vijf packs **verwijderd** (o.a. de
work-orders-tekst die "vier per dag" zei, en de Alchemy/Herbalism-hoofdstukken die de
gecorrigeerde routes tegenspraken). Die moeten dus **opnieuw en vertaald** terugkomen —
niet de oude tekst herstellen.

De schrijfregels staan onderaan de uitvoer van dat script, inclusief wat níet vertaald mag
worden. Twee die hier het meest misgaan: de zes profession-stats en `Concentration` blijven
Engels, en het lidwoord volgt de taal maar de naam niet ("der Coiled Isle", niet "der The
Coiled Isle"). **Controleren door het te draaien:** `lua5.1 tools/locale_probe.lua KEY`.

📌 **Twee kleinere dingen die er ook liggen** (BOUW, tenzij het beter uitkomt):
- De **vertaalmelding praat onzin** tegen wie al een pakket heeft. `OpenTranslateHelp()` in
  `TranslateNudge.lua` print `TRANSLATE_HELP_LANG` onvoorwaardelijk, dus Rob kreeg "Jouw taal
  (enUS) heeft zijn eerste pakket nodig" — enUS is de brontaal. En het staat in de chat,
  precies waar `FlightMapHint.lua` al over opschreef dat niemand het leest.
- De **`points = 0`-tekst** (`PROFACAD_ADVISE_NEXT_OPEN_FMT`, Mining's `Over-LODED`) heeft
  nog nooit iemand gerenderd zien worden. Geen bug bekend, alleen ongetest.

---

## ✅ AFGEROND 20 aug (avond) — Spec 27 én Spec 28 zijn gebouwd

**Alles hieronder in deze sectie is GESCHIEDENIS.** Het staat er nog omdat de redenering
klopte en de tellingen nagekeken zijn, maar de klussen zelf zijn af:

- **Spec 28: alle tien de routes staan in `advisorRoutes`** (`c0cb6b1`), elk met een
  commentaarregel over wat er fout was en waartegen het gecontroleerd is. Nieuw in het
  schema: `points` (een hint, met "lees de tooltip" in de UI), `points = 0` (open de tak,
  investeer niet — afgerond zodra ontgrendeld), en `goals`, dat **beide** takken toont in
  plaats van er één te kiezen. Die laatste wijkt bewust af van het voorstel: de klacht was
  dat `anyOf` de keuze verbérgt, en kiezen vóór de speler vervangt een muntworp door een gok.
- **De starter-build-sectie van les 2 is gebouwd** — de Alchemy- en Herbalism-hoofdstukken
  dragen nu dezelfde volgorde als de routes, dus de blocker is weg.
- **Beide Zygor-kandidaten zijn toegepast**: Engineering heeft `points = 10`, Inscription
  leidt met `Calm Hands` op 10. De Resourcefulness-sub-spec is bewust NIET geraden — dat is
  een node en we hebben er geen geverifieerde naam voor.
- **Geverifieerd op Robs scherm**: Enchanting leidt nu met `Disenchanting Delegate`,
  Tailoring toont de drempel van 20 mét de tooltip-waarschuwing.

🔴 **En de verificatie legde een defect van ONSZELF bloot — dat is de eerste klus van 21
aug.** Rob heeft 12 onbestede punten op Tailoring en kan er **geen enkele** van uitgeven:
zijn skill staat onder 25 en alle vier de specialisaties zitten op slot. Onze This
Week-melding zegt ondertussen *"spend it"*. Volledig uitgeschreven bovenaan
`docs/NEXT_SESSION.md`, inclusief wat diezelfde tooltip juist bevestigde. **Eerst meten** —
de vergrendelde staat lezen we nergens uit, en `active - 1` maakt "op slot" en "open maar
onaangeraakt" allebei tot 0.

⚠️ Dit corrigeert ook de aanname twee alinea's verderop dat Rob zijn punten puur bewust liet
liggen. Bij Tailoring is dat niet de reden — het kán niet.

---

**ONDERZOEK: de resterende routes uit Spec 24.** *(afgehandeld, zie hierboven)*

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
