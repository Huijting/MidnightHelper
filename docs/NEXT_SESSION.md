# Midnight Helper — waar we staan

## 🔴 DIT BESTAND BIJWERKEN HOORT BIJ DE WIJZIGING, NIET ERNA

Rob, 2 sep 2026: *"dit moet eigenlijk altijd gebeuren als er iets verandert, vind je niet?"*

Ja. En de reden dat het tóch misgaat is dat bijwerken aan het *eind* komt, als het werk al klaar
voelt — dan is het optioneel geworden. **Verandert de status van iets dat hier staat, dan gaat de
regel mee in dezelfde commit als de code.** Niet "straks even".

⚠️ Wat het kost als je het niet doet, twee keer gemeten: op 31 aug somde ik zeven beroepen op als
ongecontroleerd terwijl Rob ze diezelfde ochtend had gemeten, en op 2 sep stond `A Toxic Tour` hier
nog als open vraag terwijl hij al beantwoord was. Beide keren citeerde ik mijn eigen verouderde
aantekening als bewijs. Een aantekening is een claim mét een datum, geen meting.

## 🔴 2 sep (avond) — de gifadviseur toonde 3 van de 6, en dat kwam door onze eigen meting

Rob draaide `/mh valeera save` op de **live** client. Node 110784 heeft **zes** entries; wij hadden
er drie, uit de PTR-meting van 27 juli. De drie nieuwe zitten in het 1305xxx-bereik — Bursting Toad
Toxin (1305904), Frostheart Venom (1305912), Phantasmal Spore Toxin (1305924) — en bestonden op die
PTR-build simpelweg nog niet.

Er gingen **twee** dingen mis en alleen het eerste was zichtbaar:

1. `GetDelvePoisonRows` loopt over `choices`, dus het adviesscherm liet de helft van de opties weg
   die het bestaat om te vergelijken.
2. `GetEquippedDelvePoison` matcht de geslote entry tegen `choices` en geeft `nil` bij geen match.
   Wie één van de ontbrekende drie op had staan, zag **geen enkele "equipped"-markering** — niet te
   onderscheiden van "we kunnen je tree niet lezen".

📌 **De les is niet "we hadden beter moeten meten", want de meting was goed toen hij gedaan werd.**
Een hardcoded lijst van de opties van een keuzenode is een bewering dát de node precies die opties
heeft, en niets hercontroleerde die na de patch. `/mh valeera save` hoort dus bij elke patch die de
companion aanraakt, niet pas als er iets raars opvalt.

### En daarna: vier van de zes hadden geen beschrijving

Robs screenshot van de reparatie liet zes namen zien, waarvan vier zonder tekst. Niets kapot: namen
komen uit de statische spell-data, **beschrijvingen moeten opgehaald worden**, en tot ze binnen zijn
geeft `C_Spell.GetSpellDescription` een lege string. `GetDelvePoisonInfo` weigerde die lege string te
printen — precies goed — maar daarmee werd een onzichtbare laadtoestand een zichtbare leugen: een gif
zonder tekst leest als een gif dat niets doet.

Nu: `ns.RequestDelvePoisonData()` vraagt de teksten op (bij het verversen van de adviseur én bij
`/mh poisons` zelf), en waar er nog geen is staat er wát er mist in plaats van niets.
🔴 **Dit is de derde vorm van dezelfde regel uit `CLAUDE.md`: bouw je iets dat kan zwijgen, bouw dan
een manier om te zien dát het zweeg.** Correct zwijgen en kapot zijn zien er van buiten identiek uit.

### ✅ Het curio-scherm: sterren mét de controle die de gidsen overslaan

`Modules/CurioExplain.lua` (`/mh curios`) bestond al en deed álles wat ik wilde bouwen — het leest
elke keuzenode uit de boom, vraagt de teksten op mét retries, en niets is hardcoded. Het weigerde
alleen bewust te ranken, en dát is wat Rob nu voor de derde keer vroeg.

**De redenering achter die weigering was goed en is bewaard, want ze is precies wat de ster veilig
maakt:** de populaire "beste Season 2 curios"-artikelen noemen Sanctum's Edict en Time Lost Edict —
Brann-curios uit The War Within die **nergens in Valeera's venster staan**. Dat is geen
meningsverschil, dat is een artikel over iets wat de lezer niet kan vinden.

Dus de oplossing was nooit *"niet aanraden"*, maar *"niet aanraden zonder de controle die die
artikelen oversloegen"*. Wat er nu staat:

- een ster bij de twee picks waar de gidsen het over eens zijn (Corrosive Bilespear 1248877,
  Soul-Cracking Dreamcatcher 1248896 — **beide gemeten in Robs eigen client**, 2 sep);
- bij élke render een positieve controle dat de gesterde spell écht in de boom zit;
- een pick die er niet in zit wordt **genoemd aan de voet**, nooit stilletjes weggelaten — want
  "de ster is verdwenen" en "deze node heeft geen aanbeveling" zien er identiek uit;
- een voettekst die in zoveel woorden zegt: dit is waar de gidsen het over eens zijn, **wij hebben
  het niet getest**.

⚠️ De koptekst van het bestand zei in hoofdletters *"EXPLAIN, DO NOT RANK"* en regel 19 zei
*"NOTHING IS HARDCODED"*. Allebei bijgewerkt in dezelfde wijziging — een bestand dat zichzelf
verkeerd beschrijft is de volgende val.

### ✅ Robs screenshot van Valeera's venster maakte het AFGELEIDE punt hieronder GEMETEN

Haar venster noemt vier rijen: **Combat Role** (Tank), **Poisons** (Bursting Toad Toxin),
**Combat Curio** (Corrosive Bilespear), **Utility Curio** (Soul-Cracking Dreamcatcher). Daarmee
staan de slot-namen vast — de geslote pick staat er telkens naast, en die drie spells zitten in
precies die drie nodes:

| node | slot |
|---|---|
| 110784 | Poisons |
| 110786 | Combat Curio |
| 110785 | Utility Curio |

🔴 **En dat maakte een opmerking in `CurioExplain.lua` onwaar die er al maanden stond:** *"the game
does not name these slots in a way we can read, so they are numbered rather than guessed at."*
Nummeren was goed zolang dat gold. Het gold niet meer zodra iemand naar het venster keek — en
niemand had gekeken. Sinds vanavond staat de naam boven elk blok, gekoppeld aan de **nodeID** (nooit
aan de volgorde), en valt een onbekende node terug op het oude genummerde label: een slot zonder
naam is dan naamloos, niet verkeerd benoemd.

⚠️ De labels blijven **Engels**. Nederlands heeft geen client, dus dit is wat een Nederlandse
speler écht ziet. De vijf echte clienttalen vertalen ze wél, maar wij hebben die vensters niet
gelezen — "Kampf-Kuriosität" zou ónze bewoording zijn voor een label dat Blizzard al heeft.
Vastgelegd in `KeepEnglish.lua` mét die reden.

### 🔴 En dezelfde lus zat óók in de tekst: `/mh curios` stuurde je naar `/mh curios`

Robs screenshot toonde: *"Valeera — no ranking for this season. Use /mh curios to see what each of
her options does."* Maar `/mh curios` opende juist de **adviseur** die dat zei. Je werd
teruggestuurd naar het scherm dat je net verteld had niets te weten.

Dit is exact de vorm van de bug die op 2 sep 's middags in `CommandList.lua` gerepareerd is (een
alias die naar een alias wees). **Twee keer dezelfde lus op één dag, één keer in de commandolijst
en één keer in een zin.** Verwacht een derde.

Opgelost: `/mh curio` en `/mh curios` kiezen nu zelf. Heeft de adviseur data — op een
12.0.7-client is dat zo — dan de adviseur; anders de uitlegger, die live uit de tree leest en de
sterren draagt. De adviseur gaat er dus **niet** uit; hij kan alleen nooit seizoen-2-data krijgen.

### ✅ Het scherm dát naast Valeera hoort — `Modules/CurioAdvicePanel.lua`

Rob vroeg dit in drie stukken over weken: een adviesscherm "zoals in serienummer 1", dat zegt "wat
volgens de meerderheid online het beste is", en dat **naast haar venster** verschijnt. De eerste
twee waren de sterren in `/mh curios`; dit is de derde, en de enige die hij kón zien ontbreken —
hij opende haar venster en kreeg een chatregel.

Wat het toont, per keuzeslot: de slotnaam, wat de guides kiezen, en of jij dat al op hebt.
Geankerd aan `DelvesCompanionConfigurationFrame` (TOPLEFT aan haar TOPRIGHT), dus het verschuift mee
als zij verschuift; valt terug op het scherm-midden als haar venster dicht is.

⚠️ **Bewust géén effectteksten.** Naast haar venster ben je aan het kiezen, niet aan het studeren;
drie slots vol tooltips is een muur. `/mh curios` blijft daarvoor.

📌 **En de oude regel klopte, maar trok de verkeerde conclusie.** *"Deze popup heeft niets"* is
nooit hetzelfde geweest als *"wij hebben niets"*. De item-popup kán seizoen 2 niet dragen (trait-
entries, geen items) — maar antwoorden met het ding dát het weet is beter dan weigeren met het ding
dat het niet weet. Alle drie de slots komen uit `GetCompanionChoices()`; het enige wat wij leveren
is de ster, en die wordt tegen diezelfde boom gecontroleerd.

### 🔴 De linter las commentaar als code en liet de build vallen op documentatie

`CurioAdvicePanel.lua` legt de `and`-valstrik uit door de fóute regel boven de goede te citeren —
het nuttigste wat je naast een reparatie kunt schrijven. Check **[12]** maakte daar een HARD failure
van.

📌 Dat is niet alleen een vals alarm maar een verkeerde prikkel: een checker die het documenteren
van zijn eigen onderwerp bestraft, leert mensen de uitleg weg te halen. Commentaar wordt nu
overgeslagen. ⚠️ De skip is een kale `--`-zoekactie, dus een `--` binnen een string eerder op de
regel zou een echte treffer verbergen — een vals negatief op een regelvorm die hier niemand
schrijft, geruild tegen een vals positief dat zojuist een build stopte.

### ✅ `/mh poisons` was de zwakkere kopie van `/mh curios` — opgeruimd

`GetCompanionChoices()` leest álle keuzenodes uit de boom, inclusief de gifnode, **zonder enige
hardcoded lijst**. De statische `DELVE_POISONS_BY_SEASON` die vanavond verouderd bleek, was dus
nooit nodig geweest. Sterker: `CurioExplain.lua` regel 157-166 beschrijft **exact** het probleem dat
ik vanavond opnieuw ontdekte, gemeten op 25 aug — Frostheart Venom (1305912) en Phantasmal Spore
Toxin (1305924) komen leeg terug na één seconde en hebben bij hoveren wél volledige tekst. Daar
lost een retry-lus van 4× ~1s het op; in `/mh poisons` staat nu alleen een "probeer het nog eens".

📌 **Derde keer deze week dat het antwoord al in de code stond.**

✅ **Rob koos: alias.** ~150 regels gif-apparaat zijn weg uit `DelveCuriosAdvisor.lua`
(`GetDelvePoisonInfo`, `GetEquippedDelvePoison`, `GetDelvePoisonRows`, `RequestDelvePoisonData`,
`PrintDelvePoisons`), plus `DELVE_POISONS_BY_SEASON` en elf locale-sleutels in zeven talen.
`/mh poisons` en `/mh poison` staan nu in `MH_UNLISTED_ON_PURPOSE` en openen `/mh curios`.
⚠️ `/mh poisons` stond in de commandolijst onder de **ROUTE**-groep, wat het nooit was.

### ⚠️ Het curio-plan van vanmiddag was op een verkeerde aanname gebouwd

Het plan was `DELVE_CURIOS_BY_SEASON[2]` te vullen met Corrosive Bilespear en Soul-Cracking
Dreamcatcher. **GEMETEN: dat zijn geen items.** Het zijn trait-entries in Valeera's boom, met
spellIDs (1248877 en 1248896) in keuzenodes 110786 en 110785. Die tabel bevat itemIDs en tekent via
`C_Item.GetItemInfo`, dus het scherm had `#1248877` getoond.

**AFGELEID, niet gemeten:** dát deze twee nodes zijn wat men online "curios" noemt. In de hele boom
van 49 nodes zijn er precies drie keuzenodes — de gifnode en deze twee. Sterk signaal, geen bewijs.
Of er in seizoen 2 óók curio-*items* bestaan is van buiten de client niet te zien.

Nog op te lossen: de curio-kant moet dus op de gif-structuur (spell-naam + clienttekst) in plaats van
op het item-pad. En node **110817** staat op `ranksPurchased = 1` met een **lege** entries-lijst —
één gekochte node waarvan de client ons de inhoud niet gaf; onbegrepen, laag geprioriteerd.

### 🔴 En `tools/git_stage.py` maakte in dezelfde commit exact dezelfde fout

Bij het committen van het bovenstaande stageerde het script **de verkeerde bestanden** — een lijst
uit een sessie die al was afgelopen. De oorzaak: het negeerde het pad dat op de commandoregel stond
en viel terug op een **hardcoded sessie-UUID**, met de opmerking erboven dat dat pad *"stabiel is
voor dit project"*. Dat is het niet; een scratchpad-pad is per sessie.

Het faalde niet. Het meldde succes en printte de verouderde lijst — de enige reden dat het opviel,
is dat die namen zichtbaar niet klopten. Opgelost: eerst het argument, dan `CLAUDE_SCRATCHPAD`, dan
de nieuwste op schijf, en het zégt welke het gebruikte.

📌 Dat is dezelfde vorm als de gif-bug die het aan het committen was: **een vastgelegde momentopname
van iets dat beweegt, met niets dat hem hercontroleert.** Twee keer op één avond, in twee bestanden
die niets met elkaar te maken hebben.

## ✅ Gif-advies: een TWEEDE soort markering, bewust los van de ster

Rob koos (2 sep): niet de ster gebruiken, maar een eigen markering `>>` met per gif één regel over
wanneer het nuttig is. Daarmee blijft de ster betekenen wat de voettekst belooft — *"hier zijn de
guides het over eens"* — en staat er los van wat wíj eruit lezen.

⚠️ **Alle zes regels zijn AFGELEID uit de speltekst die er drie regels boven staat.** Geen run, geen
log, geen guide. Dat is precies waarom dit publiceerbaar is en een stil oordeel niet zou zijn: de
lezer kan elke regel zelf tegen de beschrijving houden.

Wat de zes teksten opleverden, nu alle zes gelezen zijn:

| gif | wat het onderscheidt |
|---|---|
| Phantasmal Spore Toxin | **onderbreekt** (+1 sec fear) — de enige met een interrupt |
| Frostheart Venom | -20% melee-, ranged- **én** cast-snelheid, -30% movement |
| Bloodcrypt Toxin | -10% schade en -10% Haste |
| Soulthirst Venom | +10% Leech/Avoidance/Speed voor jezelf |
| Bursting Toad Toxin | AoE natuurschade |
| Forgotten Master | tot +25% schade, **maar alle stacks weg zodra de drager schade krijgt** |

📌 Die laatste voorwaarde is de enige echte in de set en de reden dat het "sterkste damage-gif"
misleidend is. Robs Valeera staat op **Tank**.

⚠️ Waar het paneel de notitie toont: **alleen bij een slot zonder ster**, en dan over wat de speler
nú op heeft. Twee meningen op één regel is hoe een lezer niet meer kan zien welke van wie is. De
voettekst draagt de disclaimer alleen wanneer de markering ook echt op het scherm staat.

⚠️ Eén percent-teken in die notities, geen twee: ze zijn nooit een format-*string* (ze worden
geconcateneerd of als argument doorgegeven), dus `%%` zou letterlijk verschijnen.

## ~~OPEN~~ BEANTWOORD: waarom had de Poisons-slot geen aanbeveling?

Rob, 2 sep, kijkend naar het werkende paneel: *"hebben we geen poisons??"* Nee, en dat is een
**bewuste** keuze uit juli die nu aan haar houdbaarheidsdatum zit.

De reden staat in `DelveCuriosData.lua`: de gif-ID's die we van Wowhead hadden waren **alle drie
fout**, dus de effectbeschrijvingen die erbij hoorden waren net zo onbewezen. Geen aanbeveling doen
was toen precies goed.

✅ **Die blokkade is weg.** We hebben nu zes gemeten gif-ID's en de client geeft zijn eigen teksten.
Wat er nog niet is, is een grond om er één aan te wijzen: de ster betekent *"hier zijn de guides het
over eens"*, en voor gif heb ik dat **niet gecontroleerd**. Er nu zelf een kiezen zou de ster iets
anders laten betekenen dan de voettekst belooft.

Vier van de zes teksten staan al in Robs screenshots: Soulthirst (Leech/Avoidance/Speed +10%),
Forgotten Master (+5% schade, stapelt tot 5, valt weg bij schade), Bloodcrypt (-10% schade en -10%
Haste op de vijand), Bursting Toad (AoE natuurschade). **Frostheart Venom en Phantasmal Spore Toxin
zijn nog ongelezen.** Volgende stap: `/mh curios` toont ze nu; daarna kiezen Rob en ik samen, en dan
moet de voettekst zeggen dat dít onze keuze is en niet die van de guides.

## ✅ De "Nothing slotted"-bug: het was timing, en dat is de gevaarlijkere uitkomst

Na een reload klopte het paneel — mét **onaangeroerde** active-detectie. Het was dus niet fout maar
**te vroeg**: `activeEntry` is leeg tot de trait-config geladen is, en één retry op 1s haalde dat
niet altijd.

⚠️ **Dat is de slechtste soort groen.** "Het werkt nu" na drie ongerelateerde wijzigingen is geen
reparatie maar een toevalstreffer die nog niet gefaald heeft — en een adviespaneel dat af en toe
beweert dat je niets op hebt is erger dan eentje die zwijgt, want de speler gelooft het en kiest
opnieuw.

Nu hangt het niet meer aan het moment van openen: het ververst op `TRAIT_CONFIG_UPDATED`,
`TRAIT_TREE_CHANGED`, op de `OnShow` van haar venster, én op een laddertje van 0,3 / 1 / 3 seconden.
Elk daarvan is genoeg.

⚠️ **En `/mh valeera save` faalde in diezelfde run**: *"probe stopped: no trait tree"*. De probe
hangt aan `DelvesCompanionConfigurationFrame.playerCompanionID` en heeft haar venster dus **open**
nodig. Dat staat nergens in de foutmelding. Niet dringend meer — het paneel beantwoordde de vraag —
maar de melding hoort te zeggen wát je moet doen.

## ~~OPEN~~ OPGELOST: het adviespaneel zei "Nothing slotted yet"

Robs screenshot van 2 sep zet de twee vensters naast elkaar: haar venster toont **Bursting Toad
Toxin, Corrosive Bilespear én Soul-Cracking Dreamcatcher** geslote — ons paneel zegt drie keer
"Nothing slotted yet". Beide lezen dezelfde boom.

`GetCompanionChoices` bepaalt dat uit `node.activeEntry.entryID`. **Dat is niet uitgesloten dat het
werkt:** het oude `GetEquippedDelvePoison` las hetzelfde veld en zette die avond wél een `>` bij
Bursting Toad Toxin in `/mh poisons`. Dus óf het veld gedraagt zich anders per aanroep, óf er zit
iets anders in de weg.

⚠️ **NIET GAAN GOKKEN.** `/mh valeera save` legde `ranksPurchased` en `entries` vast maar **nooit
`activeEntry`** — precies het veld dat nu verdacht is. Een diagnose die het verdachte veld weglaat
stuurt je terug naar raden, en dat is het enige wat hij hoort te voorkomen. De probe schrijft het nu
weg mét het `type()`, zodat een dump kan zeggen óf het nil is, óf een getal in plaats van een tabel,
óf secret.

**Volgende stap:** Rob doet `/mh valeera save` + `/reload` met haar venster open; dan de drie
keuzenodes in het SV-bestand lezen.

## ✅ Het adviespaneel: volgorde, scrollen, en slepen

Robs twee opmerkingen zodra het naast haar frame stond, allebei terecht:

1. **De volgorde klopte niet.** De boom geeft 110784, 110785, 110786 → Poisons, Utility, Combat;
   haar venster leest Poisons, **Combat**, Utility. Twee lijstjes van dezelfde drie dingen in
   verschillende volgorde, naast elkaar, en de lezer mag matchen. Nu via
   `ns.DELVE_CURIO_SLOT_ORDER`; een node zonder bekende positie wordt **achteraan toegevoegd** in
   boomvolgorde, niet weggelaten en niet vooraan geforceerd.
2. **Te klein om te lezen.** Vaste 320px met het kleine lettertype is genoeg voor een blik, niet om
   te lezen. Nu: sleepbaar aan de rechteronderhoek (240×160 tot 620×900), een echte ScrollFrame
   eronder, groter lettertype, en de maat wordt onthouden in `ns.db.curioAdvicePanel`.
   ⚠️ `StartSizing` laat het frame op eigen punten achter, dus na het slepen wordt opnieuw aan
   haar venster geankerd — anders volgt het haar na één keer verslepen nooit meer.

## ✅ 2 sep (avond) — de weekroutine liet je vallen zodra je een quest oppakte — GEMETEN OPGELOST

✅ **Rob in het spel, dezelfde avond: "DIE PIJL DEED HET NET."** Bevestigd op de echte trigger — een
weekly die af was en nog ingeleverd moest worden — en niet op een nagebouwde toestand. Dat is het
enige bewijs dat telt voor deze reparatie, want de bug bestond juist in de overgang tussen twee
toestanden die je niet kunt forceren.

Rob: *"ik heb een quest opgehaald en die moet ik weer inleveren, maar ik krijg nu geen pijl (als ik
de questgiver weer aanklik)."* Gemeten in `ResetRoutine.lua` en het is precies dat.

`GiverState` gaf `"inlog"` zodra een quest in je log stond, en die tak bouwde een stap **zonder
`pin`, zonder `open` en zonder `onClick`**. `ComputeOpenPins` neemt alleen `step.open and step.pin`,
dus de halte verdween uit de route en de regel was dood voor de klik. Hetzelfde gold voor de
trainer-weeklies. In Robs screenshot stonden er **vier** tegelijk zo: Halduron, Aethas, Riftblade
Maella en Blacksmithing.

📌 **De vorm van de fout: het oppakken van een quest liet de addon ermee stoppen — precies op het
moment dat de speler zich eraan gecommitteerd heeft.** De giver was nooit verplaatst; alleen onze
reden om erheen te lopen was veranderd, en die hadden we niet ingevuld.

⚠️ **Maar "in mijn log" is niet "klaar om in te leveren".** Routeren op het eerste zou de zelfverzekerd
verkeerde antwoord zijn waar dit bestand al twee keer voor waarschuwt: je staat dan voor een NPC die
niets voor je heeft, terwijl het werk buiten ligt. Er is dus een aparte staat `"turnin"`, die
`C_QuestLog.ReadyForTurnIn` gebruikt — de client zegt het, wij raden niet.

Nu: **af → echte halte met pijl** (`open`, `pin`, eigen tekst); **opgepakt maar niet af → wel
klikbaar, geen halte**, want wie naar de giver wíl kijken hoort geen nee te krijgen. Bij de
trainer-weeklies is de coördinaatberekening uit de pickup-tak omhoog gehaald zodat inleveren
dezelfde plek gebruikt; dat haalde meteen een duplicaat van de `isService`-tak weg.

Twee nieuwe sleutels (`HOME_ROUTINE_GIVER_TURNIN_FMT`, `HOME_ROUTINE_TRAINER_TURNIN_FMT`) in alle
zeven talen, 0 drift.

## Stand 2 sep 2026 (ochtend)

**Alle vier de wachters draaien nu in de cloud** en pushen zelf, tussen 05:30 en 06:00 Robs tijd —
API, PTR/roadmap, blue post/data, content. Niets hangt meer aan Robs pc. Zie de tabel bovenaan
`CLAUDE.md`. De drie oorzaken die dat blokkeerden (repo niet als bron ingesteld, twee logboeken in
`.gitignore`, en een connector-toestemming waar een onbeheerde run op bleef wachten) staan in de
commits van die ochtend.

📌 En de regel die daaruit volgde en breder geldt dan wachters: **een onbeheerd proces mag nooit op
een goedkeuring blijven wachten.** 4 van de 10 laatste API-runs waren zo stilgevallen. Kan iets niet,
schrijf op wát niet kon en ga door — een halve meting die aankomt is meer waard dan een volledige
die nooit komt.

## ✅ 3.7.3 LIVE en approved op CurseForge — 31 aug 2026 (tag `v3.7.3` op `945e17d`)

De adviseur zweeg voor hele beroepen (12 routestappen in 5 beroepen noemden een node alsof het een
tabblad was), vier talen bleken machinaal vertaald, Valeera heet Valira in het Portugees, vijf
spell-links werkten niet, en de Vaults-keten was drie quests terwijl het er vier zijn.

✅ **Vertalen is AF**: zeven talen, nul drift, alle 43 placeholders lossen op.

### 🔴 Wat morgen als eerste telt

**Wacht op iemand anders:**

1. **`cmd:req` voor het consumables-bord** — wacht op Cisca's reload-test.
2. ✅ **Wago staat er — 2 sep.** Project aangemaakt, versie 3.7.3 handmatig geüpload (Wago's
   "Upload your Addon!" leidt naar *Create Version*, dus een zip is nodig om te beginnen), en
   `## X-Wago-ID: rNky4wKa` staat in de `.toc` onder het CurseForge-ID. `release.yml` gaf
   `WAGO_API_TOKEN` al door aan de packager, dus vanaf de volgende release gaat het vanzelf naar
   CurseForge **én** Wago. Dit was SPEC_31 B7.
   ⚠️ **Nog niet bewezen:** of de automatische upload werkt. Het GitHub-secret `WAGO_API_TOKEN`
   staat er wél in (Rob bevestigd, 2 sep), maar of de packager er daadwerkelijk mee uploadt blijkt
   pas bij de eerste release ná vandaag — kijk dan of Wago de nieuwe versie krijgt zonder handwerk.
   🔴 **DOODLOPEND SPOOR, niet opnieuw onderzoeken: Wago's downloadcijfers zitten achter Patreon.**
   Rob wilde er een teller voor in Home Assistant, naast die voor CurseForge, en heeft daarvoor een
   tweede API-token aangemaakt. Dat token is weer ingetrokken: de statistieken zijn betaald en dat
   is geen plan. Er is dus **geen** Wago-downloadteller, en de reden is een prijskaartje en geen
   ontbrekend eindpunt — zoeken naar de juiste API levert niets op.
   ✅ **Uitgezocht dezelfde ochtend, en het was geen bug maar onze eigen keuze.** `release.yml`
   zei het zelf: GitHub-releases waren bewust uit, *"one new shop at a time"*. Die reden is nu
   vervallen (CF werkt al maanden, Wago staat er), dus aangezet met `GITHUB_API_TOKEN:
   ${{ secrets.GITHUB_TOKEN }}` plus `permissions: contents: write`. **Geen nieuw secret nodig** —
   Actions levert die token zelf.
   ⚠️ Onbewezen tot de eerste release hierna: of het Release-object echt verschijnt.
   📌 Bijvangst die een schrik bespaarde: de packager-README noemt `CF_API_TOKEN` terwijl wij
   `CF_API_KEY` doorgeven. `release.sh` accepteert **allebei** (gemeten in de broncode, niet in de
   README). Onze werkende opzet was dus nooit in gevaar en moet **niet** "gerepareerd" worden.

**Gemeten open op 2 sep** (met positieve controle in dezelfde run):

3. ✅ **B5 — `/mh report` GEBOUWD, 2 sep.** `Modules/SupportReport.lua`, via het bestaande
   `ns.ShowShareCopyDialog` zoals de spec voorschreef — bedrading, geen nieuw scherm. Bevat
   versie, clientbuild, taal (client én MH), klasse/spec/level, groepsgrootte en instantie, plus
   wat de speler achter het commando typt. Beide bestemmingen erin, Discord én GitHub.
   Lint: 173 gerouteerd / 65 vermeld (was 172/64), dus hij staat in de commandolijst én in
   NavSearch. ✅ **Door Rob getest en afgetekend** (`docs/TESTLIJST.md` punt 11) — hij vond binnen
   twintig minuten twee uitvoerfouten die geen controle kón zien omdat de wáárden klopten:
   `MAGE Frost` en `Eastern Kingdoms (open world)` in plaats van de zone. Beide gerepareerd.
   📌 Twee keuzes die Rob mag terugdraaien: **geen personagenaam of realm** in het rapport (het is
   bedoeld om openbaar geplakt te worden, en die twee helpen niet bij reproduceren), en het
   **rapportblok blijft Engels** terwijl de chrome eromheen in zeven talen staat — het is aan de
   maker gericht, zoals een logbestand.
4. ✅ **B10b — beroepen-scène TOEGEVOEGD, 2 sep.** `{ name = "10-professions-advice", tab =
   "profoverview" }` in `Modules/DevShots.lua`. De meting van die ochtend is precies omgedraaid:
   `prof` gaf nul treffers in dat bestand, nu vier.
   📌 **Waarom juist deze scène en niet een willekeurige elfde:** op 31 aug is over ~20 addons
   gemeten dat **geen enkele** vertelt wáár je Knowledge uitgeeft. Het enige dat deze addon doet
   en niemand anders, was dus het enige dat een bezoeker van de CF-pagina niet kon zien.
   ⚠️ `profoverview`, niet `professions` — die oude id landt op Treasures & Books, wat Rob op
   22 juli kreeg toen hij op een Knowledge-regel klikte.
   ⚠️ Deze scène hangt als enige aan het **ingelogde personage**: draai `/mh shots` op iemand met
   Midnight-beroepen en punten te besteden, anders fotografeert hij een eerlijke lege pagina.
5. **De INHOUD van de Engineering-, Jewelcrafting- en Inscription-routes.** Hun *structuur* is
   geverifieerd (0 afwijkingen over alle 11 beroepen), maar of `Recycling` het juiste eerste punt
   is, is nooit tegen gamedata gelegd. ⚠️ Dat verschil is echt en is op 31 aug één keer verward.
   Drie beslissingen liggen bij Rob: de `points`-semantiek (Recycling zegt "mik op 10" maar de stap
   voltooit pas bij 30), JC stap 1 (alle gidsen zeggen ~5, wij eisen een volle root), en of
   Inscriptions vierde boom `Darkmoon Curiosity` erbij moet.

**Niet opnieuw gemeten, overgenomen uit de meting van 31 aug:**

6. ✅ **B6 — GEBOUWD 2 sep, op DRIE plekken en bewust niet op vijf.** De spec noemde vijf doelen;
   de toets die ik erop legde is *heeft de speler de informatie die wij missen?*
   - ✅ `MPLUS_AFFIX_UNMEASURED` — zijn keystone toont de affixen eerder dan wij ze meten.
   - ✅ `HAZARD_SOURCE_NOTE` — hij wordt geraakt door iets dat niet in de lijst staat.
   - ✅ `DELVE_REWARDS_UNMEASURED` — hij ziet zijn eigen kist. ⚠️ Dit is de **tooltip**, dus kort
     en met `/mh report` in plaats van een uitnodiging — precies waarom B5 eerst moest.
   - ❌ `DELVE_CHEST_LEARNED` — een API-beperking. De speler kan ons niets vertellen dat dit
     oplost, dus een vraag daar is zuivere ruis.
   - 🔴 `DELVE_TIP_UNMEASURED` — **dode tekst**: hij staat in zeven talen in de taalbestanden en in
     géén enkel codepad. Geen speler heeft hem ooit gezien; waarschijnlijk overbodig geworden toen
     alle veertien delves tips kregen. **Niet aangevuld — opruimen of aansluiten is een aparte
     keuze.**
   21 toevoegingen (3 sleutels × 7 talen) met een script dat weigert te schrijven bij een ander
   aantal; drift gemarkeerd, lint 0/0.
   📌 De spec waarschuwde dat dit het snelst een zeurpiet wordt. Drie vragen op drie schermen is
   het antwoord daarop, en de toets hierboven is waarom het er drie zijn.

6c. 🔍 **Hermeting van 2 sep, ter herinnering:** het "vertel het ons"-model bestond exact één keer:
   `RITUAL_BOSS_MINDBREAKER_STEPS` (*"If you fight it, tell us what it did on Discord and it goes
   in"*). Dat was tegelijk de positieve controle — mijn zoekvorm vindt een vraag waar er één is.
   De vijf plekken waar de addon toegeeft iets níét te weten dragen er géén: `DELVE_TIP_UNMEASURED`
   (enUS:1456), `DELVE_REWARDS_UNMEASURED` (enUS:1459), `MPLUS_AFFIX_UNMEASURED`
   (`Locales/MythicPlus.lua:32`), `DELVE_CHEST_LEARNED` (enUS:547), `HAZARD_SOURCE_NOTE`
   (enUS:1674).
   ✅ **De blokkade is weg:** de spec zei *"waar het een tooltip is noemt de tekst `/mh report` —
   daarom moet B5 eerst"*, en B5 bestaat sinds 2 sep.
   ⚠️ De spec waarschuwt dat dit het voorstel is dat het snelst een zeurpiet wordt: alleen op
   teksten die iemand bewust léést, nooit op een tooltip die de muis volgt, nooit met een knop die
   terugkomt.
6b. ✅ **B10 — CF-bovenkant HERSCHREVEN, 2 sep.** GEMETEN vóór en na: *"Just hit 90…"* stond op
   regel 9 en staat nu op 3; **Professions 101 stond op regel 117 en staat nu op 15**.
   🔴 En de meting legde bloot dat ik het die ochtend zélf erger had gemaakt: mijn site-blokcitaat
   werd het derde bovenaan en duwde de pitch nog twee regels omlaag — precies het probleem dat de
   spec beschrijft. De links staan er nog, nu ná "Start with these three".
   📌 Het eenmansproject-briefje is samengevoegd met de Discord-regel en naar de voet van het
   eerste scherm verhuisd: eerlijkheid die vertrouwen *sluit* hoort niet vóór de pitch te staan.
   ⏳ Rob moet de omschrijving hiervoor opnieuw plakken (tweede keer op 2 sep).

**Nieuw, 2 sep — en dit is nu het dringendst:**

0. ✅ **World boss — GEMETEN EN OPGELOST, 2 sep.** Rob zag het S1-world-boss-artikel binnen een
   uur na publicatie op de site staan als actueel advies, draaide `/mh worldboss` op live, en dat
   besliste alles in één keer: **Lu'ashal `taskActive = true`, 9904 min resterend**, de andere
   drie idle. De vier bosses roteren gewoon door in Season 2.
   🔴 **"12.1 verving world bosses door Lairs" was FOUT** — dezelfde probe geeft `hasLairs = true`
   én actieve world bosses: Lairs bestaan ernáást. Die claim kwam van Icy Veins en een techsite en
   was op weg naar onze publieke site. Twee secundaire bronnen die elkaar bevestigen zijn geen
   meting.
   Gedaan: de S2-poort is uit `Modules/WorldBoss.lua` gehaald, het artikel staat weer op de site,
   en `SKIP_ARTICLES` in `tools/build_site.py` is weer leeg — het mechanisme blijft.
   🔴 **Correctie op mezelf, dezelfde ochtend.** Hier stond eerst dat die poort "twee weken lang
   een boss verzweeg die er gewoon stond". Rob weerlegde dat vanuit het spel binnen een kwartier:
   Lu'ashal stond er **vóór** de reload al. `GetActiveWorldBoss` probeert eerst de client-scan, dan
   de cache, en pas dán deze functie — de poort zat alleen op die laatste. De echte kosten zijn
   dus smaller: in een week waarin de client niet antwoordt bleef het paneel leeg in plaats van de
   boss te noemen. Nog steeds terecht weggehaald, maar niet wat ik beweerde.
   ⏳ **Rob moet nog bevestigen** dat de boss in-game terug is: `docs/TESTLIJST.md` punt 10.
   📌 Blijvende les die groter is dan dit item: **de sitegenerator kopieert teksten, maar niet de
   voorwaarden waaronder de addon ze toont.** Die poort stond in Lua, de generator leest data.
   Alles wat de addon afhankelijk maakt van seizoen, patch of speler-toestand publiceert de site
   onvoorwaardelijk tenzij iemand het opmerkt. Staat als regel boven `SKIP_ARTICLES`.

**Nieuw, 2 sep (middag) — Valeera-advies bestond al, maar was onvindbaar:**

8. ✅ **`/mh poisons` is nu vermeld.** Rob vroeg onderweg of er ergens Valeera-advies over poisons
   en curios te vinden was. Gemeten: `PrintDelvePoisons` bestaat al (`DelveCuriosAdvisor.lua:1401`,
   een nette spelerprint met de omschrijvingen van de client en een markering op wat ze aan heeft)
   maar stond in `MH_UNLISTED_ON_PURPOSE`. 🔴 De rechtvaardiging daar was circulair: de comment
   noemde `poisons` een alias van `/mh poison` — en `poison` stond zelf óók in die lijst, dus er
   was geen primaire naam. Nu vermeld, met `poison` als echte alias.
9. ✅ **`/mh curio` opent eindelijk de adviseur.** De commandolijst beloofde twee dingen
   (`CMDLIST_CURIOS` = uitlegger, `CMDLIST_CURIO` = adviseur) terwijl `Core.lua` beide naar de
   uitlegger stuurde; het adviseur-blok was dode code. ⏳ Robs keuze open: enkelvoud/meervoud is
   een slechte scheidslijn — samensmelten tot één commando is eerlijker maar groter.
   Zie `docs/TESTLIJST.md` punt 12.
10. ✅ **GEREPAREERD — twee blinde vlekken in de linter, gevonden door één toeval.** De pariteitscontrole zag
    `fill("deDE", { KEY = "..." })` op één regel niet: het contextpatroon zette de taal en
    `KEY_BARE_RE` is verankerd met `^`, dus de sleutel achter de accolade werd nooit gelezen.
    GEMETEN door alleen de opmaak te veranderen: zes vertalingen per taal doken op (deDE 3102 →
    3108). ⚠️ **Dezelfde fout zat in `collect_locale_values`, en dáár is hij gevaarlijk:** die
    voedt [13] markup en [15] must-stay-English, dus een eenregelige fill met een kapotte
    `|cff…|r` gaf een **vals sein-veilig**. Beide gerepareerd; [13]/[15] blijven 0, nu voor het
    eerst gemeten in plaats van ongezien.

## 🐍 Valeera-curio's Season 2 — onderzoek 2 sep, nog niet gebouwd

Rob vroeg onderweg om "zo'n adviesscherm zoals we in seizoen 1 hadden". **Dat scherm bestaat nog**
(`Modules/DelveCuriosAdvisor.lua`: paneel op de Delves-tab én popup bij de reparateur, per rol,
combat + utility, met aparte Nemesis-set). 🔴 **Alleen: `ns.DELVE_CURIOS_BY_SEASON` heeft een `[1]`
en geen `[2]`.** Sinds 18 aug heeft het niets te zeggen.

### De zes S2-curio's — LIJST DRIEDUBBEL BEVESTIGD

| Combat | Utility |
|---|---|
| Corrosive Bilespear | Soul-Cracking Dreamcatcher |
| Essence Trap | Dundun's Favor |
| Ouroboric Curse | Venom Infusion |

Bronnen van drie verschillende soorten, onafhankelijk: warcraft.wiki.gg (scheidt S1 en S2
expliciet), een datamining-blog van juni (PTR, geeft bewust géén advies), en de boost-sites.
✅ **Twee ervan staan in Blizzards eigen hotfixnotities** — Corrosive Bilespear (17 aug,
proc-fix) en Dundun's Favor (18 aug, lootbug). Beide staan al in `docs/PTR_12.1_WATCH.md`; de
17-aug-regel schreef er zelfs bij "raakt onze Codex-tekst niet maar wel het advies", en daar is
toen niets mee gedaan omdat er geen S2-tabel was om bij te werken.

📌 Positieve controle: de wiki zet onze drie S1-items (Porcelain Blade Tip = combat, Mandate of
Sacred Death + Overflowing Voidspire = utility) in precies de bakjes waar ons databestand ze heeft.

### De AANBEVELING — veel dunner dan de lijst

Iedereen zegt hetzelfde: **Corrosive Bilespear + Soul-Cracking Dreamcatcher voor alle drie de
rollen**, alleen de poison verschilt (Bloodcrypt voor tank/heal, Forgotten Master voor dps).

🔴 **Maar er is voor S2 GEEN eerstelijnsbron.** Wowhead schreef wél een "Best Valeera Curio
Loadout" voor Season 1 — waarschijnlijk waar onze S1-data vandaan komt — en **niets voor Season 2**.
Icy Veins evenmin. Alles komt van boost-/carry-sites die elkaar aantoonbaar overschrijven.
⚠️ Dat het advies voor alle drie de rollen identiek is, is verdacht simpel: dat kan betekenen dat
die twee domineren, of dat iedereen één build heeft gekopieerd. Niet vast te stellen.

### De concurrentie doet dit al — en zegt er niets bij

| addon | downloads | bijgewerkt | noemt zijn bron? |
|---|---:|---|---|
| Delve Companion | 516.500 | — | n.v.t. (geen advies) |
| **DelveGuide** | 151.154 | 29 aug | 🔴 nee |
| **Everything Delves** | 25.881 | 1 sep | 🔴 nee |

Everything Delves noemt letterlijk "Corrosive Bilespear for Combat and Soul-Cracking Dreamcatcher
for Utility, across all three companion roles" — een vierde stem, en een addon in plaats van een
verkooppagina, wat de consensus echter maakt.
⚠️ DelveGuide claimt "spec-by-spec curio recommendations for every class and specialization". Er
bestaat geen gepubliceerde S2-bron die zo fijnmazig gaat, en de addon noemt er geen. Niet te
controleren zonder hun data te lezen — dus **niet beweren dat het verzonnen is**, wel vaststellen
dat niemand het kán onderbouwen.

📌 **Dus: een kale "dit is de beste"-tabel maakt ons de vijfde stem die één build napraat.** Wat
niemand doet is zeggen wáár het vandaan komt en hoe zeker het is. Dat is precies deze addons
eigen stelregel, naar buiten gekeerd — en het is de enige hoek hier die van ons is.

### Wat nog moet gebeuren

1. ⏳ **Item-ID's meten, niet overschrijven.** Eén is hard: **Corrosive Bilespear = 249223** (wiki
   + WoWDB, twee bronnen). De rest niet. Rob opent Valeera's paneel in het spel → `/mh valeera
   save` → `/reload`, dan staan ze in `ns.db.companionProbe` en zijn ze GEMETEN uit zijn client.
   ⚠️ De probe stopt als dat venster dicht is — daarom die eerste stap.
2. **Robs keuze:** vullen met de consensus **mét herkomstregel**, of niets tonen tot er een betere
   bron is. Nu toont het scherm niets, en dat is de slechtste van de drie.

**Nieuw, 2 sep:**

7. **Delve-trinkets droppen minder sinds de hotfix van 1 sep.** Onze tips claimen geen droprate,
   dus er wordt niets onwaar — maar de PTR-wachter stelt voor het in het "wat farm ik hier"-advies
   te noemen. Robs keuze.
15. 🔴 **`DELVE_TIP_UNMEASURED` is dode tekst.** Gemeten 2 sep bij B6: hij staat in zeven talen in
    de taalbestanden en in **geen enkel codepad**. Geen speler heeft hem ooit gezien. Vermoedelijk
    overbodig geworden toen alle veertien delves echte tips kregen. **Opruimen of aansluiten** —
    dat is een keuze, geen bug, en daarom hier en niet stilzwijgend weggehaald.
    ✅ **GEMETEN, 2 sep: hij staat inderdaad niet alleen.** Lintcheck **[18]** is gebouwd — de
    spiegelvraag van [1], net zoals [16] de spiegel van [10] is. Uitkomst: **226 enUS-sleutels
    worden nergens in code genoemd**, en na groeperen blijven er **34 eenlingen** over; de rest
    zijn 40 families (`DELVE_CHAT_<slug>_ROUTE` ×46 enz.) die duidelijk uit een slug worden
    opgebouwd. `DELVE_TIP_UNMEASURED` staat in die eenlingenlijst — precies waar hij hoort.
    ⚠️ Het blijft een **kandidatenlijst**: een naam die tijdens het draaien wordt samengesteld
    ziet er identiek uit als een dode. Daarom SOFT en daarom groepeert hij: een familie van 46 is
    machinerie, een eenling is verdacht. De lijst nalopen is werk voor een keer; **34 × 7 talen**
    is de omvang van wat er mogelijk nooit iemand bereikt.
    📌 De eerste versie printte gewoon 226 namen op een rij. Dat is een lijst die niemand leest —
    en hij begroef juist de sleutel waarvoor de check gebouwd was.
    🔴 **En de tweede les is scherper.** Ik had de dynamische prefixen met de hand geraden:
    `CHANGELOG_`, `LANG_LABEL_`, `BINDING_`. `collect_references()` zag ze al bij het tellen van
    de blinde vlek van [1] en gooide de literal weg; hij geeft ze nu terug. De **gemeten** lijst is
    `ACH_KIND_`, `DISPEL_SCHOOL_`, `ENCHANT_STAT_`, `KEYBIND_TAG_`, `PLAN_KIND_`, `PROFACAD_GOAL_`
    — **nul overlap met mijn gok.** Alle zes gemist, alle drie van mij zaten er niet bij. De meting
    haalde 22 kandidaten weg (226 → 204); mijn gok haalde er nul weg.
    📌 Het antwoord lag al in de code, in de functie die het weggooide. Dat is bij deze linter nu
    drie keer gebeurd: [16], de fill-schaduw, en dit.
11. ✅ **Crest-rangen es/pt/it — GEMETEN EN GESLOTEN, 2 sep. Uitkomst: afblijven.** Alle drie de
    clients vertalen de rang wél, dus onze packs hebben het goed. Uit Wowheads gelokaliseerde
    currency-pagina's: esES *"Blasón del alba de héroe"*, ptBR *"Brasão Auroral do Herói"*, itIT
    *"Emblema dell'Alba del Campione"* (currency 3343). Spiegelbeeld van nlNL, precies zoals de
    comment in `KeepEnglish.lua` al voorspelde voor echte clienttalen.
    📌 `itIT.lua` zegt `"Champion"` en dat lijkt een besluit maar is er geen: de packs kopiëren
    het Engels voor elke sleutel zonder eigen vertaling, en de fill vervangt die kopie door
    `"Campione"` juist omdát hij gelijk is aan enUS. Deterministisch nagelopen in `fill()`.
    🔴 De vraag stond stil sinds 28 aug omdat het bestand hem naar **#translations** stuurde — een
    kanaal dat op 30 aug is opgeheven. Hij lag dus nergens. En hij had daar nooit hoeven liggen:
    Blizzards eigen data beantwoordde hem in twintig minuten. **Een vraag die bij de verkeerde
    eigenaar geparkeerd staat, blijft staan.**

### ✅ Robs drie beroepsbeslissingen — genomen én verwerkt op 2 sep

12. ✅ **`points`-semantiek → de VOORWAARDE wint.** 🔴 Bij het uitvoeren bleek Robs "30" een
    symptoom en niet de regel: `ProfessionAcademy.lua:204` vinkt een stap af bij
    `t.active >= t.max` — **tak vól**, met `max` uit de client. Er bestaat geen drempel van 30;
    30 is Recycling's maximum. `points` wordt alleen getóónd en stuurt niets.
    Dus niet een ander getal ingevuld, maar de voorwaarde uitgesproken:
    `PROFACAD_ADVISE_NEXT_POINTS_FMT` zegt nu *"about %d gets it working; this step only ticks off
    once the branch is full"*, in zeven talen, drift gemarkeerd.
    📌 Zo blijft Zygors feit (10 punten = recepten ontdekken) staan zonder te liegen over wanneer
    de stap afvinkt.
13. ✅ **Jewelcrafting stap 1 → `points = 5`**, zoals de gidsen zeggen.
14. ✅ **Inscription → `Darkmoon Curiosity`** toegevoegd als vierde boom, achteraan.
    ⚠️ Achteraan is voorzichtigheid, geen onderzoek: de volgorde van de eerste drie is gemeten,
    waar de vierde thuishoort niet. Wie dat uitzoekt mag hem verplaatsen.
    ✅ Naam geverifieerd met `_probe.py run audit_routes_vs_client` tegen Robs eigen capture:
    client zegt TAB, wij schrijven `tree`, **0 afwijkingen over alle 11 beroepen**. Een verkeerde
    naam was stil overgeslagen — de fout die op 31 aug twaalf stappen onzichtbaar maakte.

✅ **AF op 2 sep — `A Toxic Tour` (98515) is verhaal, geen daily.** Gemeten in Zygor 9.6: zijn eigen
dailies-gids noemt acht daily-ID's en 98515 zit er niet bij. De Codex zei nog "een keten van drie
quests" terwijl `CampaignLeadIn.lua` er al vier had; in zeven talen rechtgezet.

✅ **AF op 2 sep — B3 en B4.** Beide gemeten aanwezig: de milestone-poort in `DiscordNudge.lua:178`
en `CHANGELOG_ASK` in vier bestanden. Dit lijstje noemde ze nog als open — precies de fout die de
sectie bovenaan dit bestand beschrijft.

### 📌 Twee dingen die vandaag als werkwijze zijn vastgelegd

- **Niets aannemen, altijd meten** — óók voor "is dit al af?". Rob vroeg het twee keer en had
  twee keer gelijk. Een doc citeren is geen controle; een lege grep bewijst niets zonder
  positieve controle. Zie de nieuwe sectie in `CLAUDE.md`.
- **Nieuw gereedschap via de voordeur**: `python "<repo>/tools/_probe.py" run <tool> [args]`.
  Elk nieuw scriptpad kost Rob anders een prompt bij élke run.


## 📌 Ouder, maar nog niet af — staat in `docs/NEXT_SESSION_ARCHIVE.md`

De historie is op 2 sep afgesplitst. Deze secties lezen daar nog als OPEN, dus ze staan
hier bij naam — een openstaand punt mag niet verdwijnen door oud te zijn.

✅ **Alle negentien kandidaten zijn diezelfde middag één voor één nagelopen** (Rob: *"waarom niet
nu nalopen, ik ben toch onderweg"*), en elf bleken af. Het oordeel staat per stuk mét reden in
`KNOWN_DONE` in `tools/split_handoff.py`, zodat het na te lezen is in plaats van te geloven.
Onder de opgeloste: de dispel-aankondiging (staat in `docs/CURSEFORGE_3.7.0.md`), `fill()` die
eigennamen terugdraaide (nu `Locales/KeepEnglish.lua` + lintcheck [15]), de Season 1-tiersettabel
(op 29 aug verwijderd, leest nu de tooltip van je gedragen stuk) en de gehardcodeerde S1-ilvl's in
de delve-tooltip (weg uit `Modules/Delves.lua`).
⚠️ Eén blijft er staan die ik **niet** heb kunnen verifiëren: *MORGEN 19 AUG* (quest 96466).
Onverifieerd is niet hetzelfde als open, maar ook niet hetzelfde als af.
📌 Herclassificeren gaat met `python "<repo>/tools/_probe.py" run split_handoff --reindex --write`.

- 🆕 30 aug — waar komen onaangeleerde recepten vandaan? (OPEN)
- 🔵 OPEN 29 aug — de SMC-pin zet TWEE waypoints, plus één die niemand vroeg
- 💡 ROB-VERZOEK 19 AUG — "dit soort info moeten wij ook gaan bieden!!!"
- 🎯 MORGEN 19 AUG — PRIORITEIT: de EU-seizoensstart
- ⚠️ OPEN, en het raakt alle vertaalwerk
- 🌅 MORGENVROEG — twee dingen, en Rob brengt data mee
- 🔴 De grootste openstaande vraag (Rob, 11 aug)
- ⏳ Wacht op Rob

📌 Al het afgeronde werk staat in het archief; daar wordt niets meer aan
toegevoegd. Nieuwe regels horen bovenaan dit bestand.
