# De vier Discoveries van de Altar of Corrosion

Onderzocht 15 aug 2026 door twee onafhankelijke agenten. **Alles hier is kandidaat, niets
is gemeten op Robs client.** Dit bestand bestaat om te scheiden wat verscheepbaar is van
wat er alleen maar overtuigend uitziet.

De sterkste bewijsklasse hieronder is Wowheads **XML-endpoint** (`item=NNNNNN&xml`), dat
Blizzard-afgeleide data teruggeeft in plaats van proza van een gidsschrijver. De HTML-
pagina's renderen niet voor automatisch ophalen — wie die fetcht krijgt een stub, en dat
is een val: je krijgt geen foutmelding, je krijgt niets.

---

## ✅ Het patroon — MULTI-SOURCE, alle vier gelijk

**sleutelitem → object openen → questitem → quest bij Er'inye → keuze uit twee passives.**

Er'inye = **NPC 262880**, `<Venom Scholar>`, Amani Foothold. Elke quest geeft 17g 8s en
6.850 XP. De vier quest-ids zijn met `/mh atal` in één ronde te verifiëren.

| Sleutel | Object | Questitem | Quest | Node |
|---|---|---|---|---|
| **Corroded Key** 280004 | Venom-Worn Coffer (671498) | Mummified Lynx's Paw 278536 | **97669** The Luck of the Bound Spirit | Run of the Vaults |
| **Excising Knife** 280003 | Eye of Szarith (649651) | Eye of Szarith 278534 | **97668** The Watchful Gaze of Szarith | Broodmaster |
| **Spirit Loupe** 280006 | Feather of Tok'jara | Feather of Tok'jara 278523 | **97662** The Winds of Tok'jara | Spectral Winds |
| **Dispelling Charm** 280005 | Jin'tal's Reliquary (671508) | Lost Med'jai Amulet 278517 | **97661** The Protection of the Med'jai | Spiritual Protection |

### De keuzes — MULTI-SOURCE, twee onafhankelijke sites met dezelfde getallen

- **Run of the Vaults** — *Glideways*: extra Spiritwing Feathers die je omhoog tillen ·
  *Swift Steps*: extra Spiritwing Gusts om ver te springen
- **Broodmaster** (spell 1305084) — *Egg Specialist*: +100% schade op eggs ·
  *Egg Evasion*: −75% schade van egg bursts
- **Spectral Winds** (1305075) — *Spirit Walk*: langere Spirit Walk van Amani Windcallers ·
  *Spectral Shipping*: Windcallers vliegen je naar meer plekken
- **Spiritual Protection** (1305071) — *Surge Seniority*: spookbondgenoten bij Curse Surges ·
  *Spiritual Succession*: buiten de Vaults sta je meteen weer op na de dood

⚠️ Dit lost de schijnbare tegenspraak van 14 aug op. "Glideways / Swift Steps" en "Run of
the Vaults" waren niet twee beweringen over hetzelfde: de node héét Run of the Vaults en
biedt die twee keuzes. Eén bron gaf de node, de andere de keuzes.

---

## ⚠️ Wat NIET verscheept wordt, en waarom

**Waar de sleutels vandaan komen — helemaal niets.** Drie agenten lazen dezelfde Wowhead-
database en gaven drie onverenigbare antwoorden:

| | Spirit Loupe | Dispelling Charm |
|---|---|---|
| agent 1 | Khu'tulak, 43,15% van 1402 kills | Spirit of Jin'tal, 67,24% |
| agent 2 | Khu'tulak, **56,42%** (XML-payload geciteerd) | Spirit of Jin'tal, **64,19%** |
| agent 3 | **geen enkele pagina noemt een bron-NPC**; "Khu'tulak" komt alleen van boostmatch | idem |

Agent 2 citeerde de payload letterlijk (`"sourcemore":[{"n":"Khu'tulak"...`), agent 3 zegt
dat die er niet is. Dat kan niet allebei. Dus: **geen bron, geen percentage, niets.**

⚠️ Dit is het nuttigste resultaat van de hele ronde. Drie zorgvuldige lezers, één bron,
drie antwoorden — dat is precies waarom "meerdere bronnen" geen vervanging is voor de
client. Wat de sleutels droppen is in-game in één sessie te zien.

**Khu'tulaks locatie.** Agent 1 haalde zeven crowdsourced spawnpunten op (`52.2 / 22.8`,
alle zeven binnen een blok van ~2), agent 2 leest op dezelfde pagina *"The location of
this NPC is unknown"* en concludeert dat de Ancient Foes **event-gespawnd** zijn op de
plek van de voltooide Temple Incursion. Beide plausibel, en ze sluiten elkaar uit.

**Congealed Malice (263014) en Susarikk (263016).** Nergens coördinaten. Beide hebben
**nul** getrackte kills tegenover 1402 voor Khu'tulak — vrijwel zeker nog niet live
geweest. "Locatie onbekend" is hier het juiste antwoord, geen tijdelijk gebrek.

**Guardian of the Sacrifice.** method.gg geeft hem `52.34 / 60.03` — byte-identiek aan
Champion of the Scale, terwijl hun eigen tekst ze in verschillende kamers zet. Copy-paste.

**Hoeveel spawnpunten de Venom-Worn Coffer heeft.** Wowheads object-data zegt **16**,
method.gg lijst er **5**. De vijf zijn dus een greep, geen lijst. Ze zo verschepen zou
"ik heb alle vijf gehad en niks gevonden" opleveren.

---

## 🔶 Losse feiten, één bron, wel bruikbaar

**De corrode-prijsladder — ⚠️ TERUGGETROKKEN 15 aug.** Hier stond 1.000 → 1.500 → 2.000
→ … → 20.000 (14 punten, 95.500 munten), met de opmerking dat het Robs meting bevestigde.

Een tweede onderzoeksronde rekende die ladder ná: **de veertien genoemde waarden tellen op
tot 98.000, niet tot de 95.500 die diezelfde pagina's noemen**, en er circuleert een derde
getal van 115.000. Drie onderling strijdige cijfers uit één bronnenfamilie, en alle drie
alleen van boost-sites. De betrouwbare bronnen (method.gg, Icy Veins, Wowhead) bevestigen
uitsluitend dát de prijs oploopt, nooit met hoeveel.

Wat blijft staan is Robs eigen meting: hij zag **1.500 en daarna 2.000** in één bezoek.
Dat de prijs klimt is dus gemeten. De ladder is dat niet.

⚠️ Les: dat een reeks getallen Robs twee waarnemingen bevatte maakte hem geloofwaardig,
en ik heb hem daarom overgenomen zonder de som te controleren. Twee punten die kloppen
bewijzen een lijn niet.

**Wat er wél toe doet en wel bevestigd is:** de eerste vier boomnodes (*Corrosive Spirit
I–IV*) kosten niets en geven **+25/50/75/100% Corrosive Coin**. De boom betaalt zichzelf
terug, dus vroeg uitgeven is goedkoper dan sparen. En **op munten zit geen cap** terwijl
Corrosive Souls gerantsoeneerd zijn — dat is de scheefheid die het tempo van de zone
bepaalt.

**Zes gratis punten:** vier uit de Discoveries (één per stuk) plus twee uit Zul'jarra's
Forces Renown, rang **8** en **14**. Alles daarboven is puur muntgestuurd, zonder tijdslot.

**Coördinaten met twee onafhankelijke bronnen binnen ~0,3:**
Feather of Tok'jara `#2509 48.46 25.80` · Jin'tal's Reliquary `#2638 36.73 24.73`
(ingang Profaned Mausoleum `#2509 54.83 48.11`).

**De Excising Knife blijft tegengesproken** — `#2613 68.52 15.86` (method) vs `69.0 / 75.7`
(nerdschalk). Agent 2's argument voor de eerste is goed en toch geen bron: nerdschalks
eigen tekst zegt *"northernmost circular room"*, en in WoW loopt Y naar het **zuiden**, dus
15.86 past bij hun woorden en 75.7 spreekt ze tegen. Inferentie, geen meting.

**🐛 Blizzard-bug om te melden:** de criteria van *Soft Underbelly* (62601) **resetten als
de Strike eindigt**, dus mogelijk moeten alle vijf binnen één Strike-venster. Blizzard-forum,
geen blauwe reactie. Dit ondermijnt het advies "Szarith kun je altijd doen".

---

## Bronkwaliteit — wie telt en wie niet

**Wel:** Wowhead (DB/XML, niet de HTML), warcraft.wiki.gg, method.gg, Icy Veins.

**Niet als bevestiging:** boostmatch, boostroom, expcarry, wowboost, overgear, seramate,
conquestcapped. Overgear en seramate geven Wowheads gids bijna woordelijk terug — dat is
afgeleid, geen tweede bron. Eén aantoonbare corruptie: boostmatch schrijft Blizzards
*"Vault of Restless Bones"* als *"Vault of Restless Brothers"*.

⚠️ En boostmatch verwart quest **95954 "An Ancient Foe"** (een level-90 groepsquest tegen
High Priest Jin'tal in de Vault of Restless Bones) met de drie Ancient-Foe-wereldbosses.
Die fout mag hier niet binnenkomen.
