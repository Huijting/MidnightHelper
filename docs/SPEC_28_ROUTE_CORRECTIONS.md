# Spec 28 — De tien gecorrigeerde advisor-routes

**Van:** ONDERZOEK-sessie, 20 aug 2026
**Voor:** BOUW-sessie
**Vervangt:** de routetabellen in `Modules/ProfessionAcademyData.lua` → `advisorRoutes`
**Onderbouwing:** `SPEC_24` (audit) en `SPEC_25` (gamedata, build `12.1.0.69382`)

**Deblokkeert:** de starter-build-sectie van les 2. Zodra 171 en 182 hieronder staan, dragen
route en hoofdstuktekst dezelfde volgorde en kan BOUW dat stuk alsnog bouwen.

---

## 0. Volgorde van werken

1. **`[171]` Alchemy en `[182]` Herbalism** — Robs eigen beroepen, en de blocker voor les 2.
2. **`[197]` Tailoring en `[333]` Enchanting** — zijn shadow priest heeft daar 12 en 22
   onbestede punten liggen te wachten. Dat is meteen de testcase: een personage dat een
   gecorrigeerde route vanaf nul kan lopen.
3. De overige zes.

---

## 1. ⚠️ Eerst een schemabeperking, want die raakt vier routes

Het huidige schema kent alleen `{ tree = "X" }` en `{ anyOf = {...} }`. Drie dingen die uit het
onderzoek kwamen passen daar niet in:

- **"Open deze tak, maar stop er geen punten in."** Mining's `Over-LODED` geeft bij het leren al
  waarde; punten erin zijn een gok op mote-prijzen.
- **Een drempel.** "40 punten in Botany" is een ander advies dan "Botany".
- **Doelen.** Bij Tailoring, Leatherworking, Enchanting en Skinning lopen goud en zelf/guild
  wezenlijk uiteen — de huidige `anyOf` verbérgt juist die keuze.

**Voorstel, achterwaarts compatibel** (uit `SPEC_23` §3, hier uitgebreid):

```lua
[197] = {
    { tree = "Nimble Needlework", points = 20 },
    goals = {
        gold = { { tree = "Sunfire Silk Weaving" }, { tree = "Fiber Arts" } },
        self = { { tree = "Sin'dorei Finery" } },
    },
},
```

Ontbreekt `goals`, dan gedraagt de route zich exact zoals nu. Ontbreekt `points`, dan toont de
UI niets extra's. Zo hoeven de routes die geen doelsplitsing nodig hebben niet aangeraakt te
worden.

⚠️ **`points` is een hint, geen waarheid.** Zet er in de UI bij dat de tooltip in het spel het
exacte getal toont — de bronnen spraken elkaar hierover bij élke profession tegen.

## 2. 🔴 En bouw op trait-ID, niet op naam

`Lasting Leather` bestaat **twee keer binnen Midnight**: Leatherworking **107889** én Skinning
**106088**. Nu gaat het goed omdat `Profession.lua` via
`C_ProfSpecs.GetSpecTabIDsForSkillLine` per skill line zoekt — maar dat is toeval dat je niet
ziet. Zet er een commentaarregel bij, en overweeg `traitID` als optioneel veld naast `tree`.

---

## 3. De routes

### `[171]` Alchemy — PRIORITEIT

**Nu:** `anyOf{Fluent in Flasks, Potion Prowess}` → `Transmutation Authority`
**Fout:** Transmutation staat tweede en hoort **laatst**; Potion Prowess hoort te leiden.

```lua
[171] = {
    { tree = "Potion Prowess" },
    { tree = "Path of Light" },
    { tree = "Prolific Potioneer - Light" },
    { tree = "Alchemical Mastery" },
    { tree = "Reuse" },
    { tree = "Fluent in Flasks", points = 15 },
    { tree = "Sin'dorei Specialist" },
    { tree = "Haranir Secrets" },
    { tree = "Transmutation Authority" },
},
```

**Waarom:** Potion Prowess vol = `Voidlight Potion Cauldron`, en dat dient goud én guild tegelijk.
`Prolific Potioneer - Light` is de Multicraft-node; Light omdat dat de potion is die in S2
verkoopt. `Reuse` geeft kruiden terug — sterk met Herbalism ernaast. 15 punten in
`Fluent in Flasks` verdubbelt de duur van je eigen flasks.

📌 **`Haranir Secrets` is geen bijzaak.** Zijn tooltip noemt letterlijk
*"and Cauldron of Sin'dorei Flasks"* — zonder punten daar haal je de flask-ketel niet op maximale
rang. Alle gidsen parafraseren die node als "phials only" en laten die halve zin weg.

### `[182]` Herbalism — PRIORITEIT

**Nu:** `Botany` → `Bountiful Harvests` → `Midnight Overload`
**Fout:** `Mulching` ontbreekt; `Midnight Overload` hoort eruit.

```lua
[182] = {
    { tree = "Botany", skipIfClass = "DRUID", points = 40 },
    { tree = "Mulching", points = 20 },
    { tree = "Bountiful Harvests" },
},
```

**Waarom:** Botany op 40 = plukken vanaf je mount, de grootste tijdwinst van het beroep.
`Mulching` op 20 geeft `Imbued Mulch` — een gegarandeerde zeldzame vondst, en dat is Nocturnal
Lotus, het kruid dat in alle vier de flasks en beide ketels zit.

**`Midnight Overload` schrappen:** werkt alleen bij de elementale nodes, kost veel punten, en die
kom je te weinig tegen. Alleen zinvol bij gericht mote-farmen.

### `[197]` Tailoring

**Nu:** `Nimble Needlework` → `anyOf{Sin'dorei Finery, Fiber Arts}` → `Fabric Specialist`
**Fout:** die `anyOf` verbergt de keuze waar alles om draait. `Fabric Specialist` staat in onze
tekst als "losse punten", maar bevat een Multicraft-node die op **álle** recepten werkt.

```lua
[197] = {
    { tree = "Nimble Needlework", points = 20 },
    goals = {
        gold = { { tree = "Sunfire Silk Weaving" }, { tree = "Fiber Arts" },
                 { tree = "Creative Efficiency" }, { tree = "Fabric Specialist" } },
        self = { { tree = "Sin'dorei Finery" }, { tree = "Fiber Arts" } },
    },
},
```

📌 **20 in `Nimble Needlework` is niet willekeurig:** de weef-takken zetten aan dat vijanden de
dure stof überhaupt **laten vallen**. Zonder die takken zie je hem nooit.

### `[333]` Enchanting

**Nu:** `Spellbound Shatterer` → `Elevating Equipment` → `Disenchanting Delegate`
**Fout:** omgekeerd. Disenchanten negeert **alle** craft-stats en leest alleen ruwe Skill — onze
eerste ~50 punten doen daar dus niets.

```lua
[333] = {
    { tree = "Disenchanting Delegate" },
    { anyOf = { "Shard Supplier", "Crystal Collector" } },
    { tree = "Elevating Equipment" },
    { tree = "Spellbound Shatterer" },
},
```

**Waarom die volgorde:** `Disenchanting Delegate` betaalt vanaf het eerste punt lineair uit, kent
geen AH-concurrentie, en levert de grondstoffen voor de rest van het beroep. `Shard Supplier` als
je blauwe gear sloopt, `Crystal Collector` bij epics — de verkeerde kiezen is hier de duurste
vergissing.

⚠️ **De bron van onze fout, voor het commentaar:** Wowheads gids heeft een standaardtabel die
zegt dat disenchanten Multicraft/Resourcefulness/Ingenuity gebruikt, terwijl de proza eronder het
tegenovergestelde zegt. Alle 28 perk-regels in de gamedata noemen uitsluitend Skill.

### `[164]` Blacksmithing

**Nu:** `anyOf{Armorsmithing, Weaponsmithing}` → `The Old Ways` → `Craftsmithing`

```lua
[164] = {
    { tree = "The Old Ways" },
    { anyOf = { "Armorsmithing", "Weaponsmithing" } },
},
```

🔴 **`Craftsmithing` moet eruit.** Het commentaar erboven schrijft die stap toe aan
wow-professions' beginnersbuild; die pagina noemt Craftsmithing daar **niet**. Dat is in juli
bijgeschreven met een bronvermelding die hem niet dekt. Craftsmithing maakt gereedschap voor
ándere crafters en doet niets voor je eigen uitrusting.

`The Old Ways` naar voren: twee onafhankelijke bronnen zetten hem eerst, en hij raakt **elke**
Blacksmithing-craft. Wie onze volgorde volgde stond weken materialen te verbranden zonder de tak
die ze teruggeeft.

### `[165]` Leatherworking

De route bleef ongewijzigd toen de prosa werd rechtgetrokken. Hij is niet fout voor een
gear-speler, maar hij is **incompleet**: goud en gear lopen hier sterker uiteen dan bij welk
ander beroep ook.

```lua
[165] = {
    goals = {
        self = { { anyOf = { "Lasting Leather", "Safeguarding Scales" } },
                 { tree = "Learned Leatherworker" } },
        gold = { { tree = "Flawless Fortes" }, { tree = "Commanding Commodities" },
                 { tree = "Learned Leatherworker" }, { tree = "Mastering Multicraft" } },
    },
},
```

⚠️ **`Mastering Multicraft` werkt alleen op commodities**, niet op wapenrusting. Wie leren armor
maakt heeft er niets aan — dat is precies andersom dan bij Blacksmithing's `Prolific Worker`.

### `[186]` Mining

**Nu:** `Meticulous Mining` → `Plentiful Ores`. Niet fout, wel incompleet.

```lua
[186] = {
    { tree = "Over-LODED", points = 0 },
    { tree = "Meticulous Mining", points = 40 },
    { tree = "Plentiful Ores" },
},
```

📌 **`Over-LODED` met nul punten is geen tikfout.** Alleen het ontgrendelen van die tak geeft al
de Overload-ability en cooldown-reductie; punten erin zijn een gok op mote-prijzen.
**Als het schema `points = 0` niet aankan, laat de node dan weg en zet het in de hoofdstuktekst**
— maar laat het niet stilzwijgend als "investeer hier" lezen.

`Meticulous Mining` op 40 = mijnen vanaf je mount.

### `[393]` Skinning

**Nu:** `Thorough Tanning` → `Gainful Gathering` → `Talented Tracker`
**Fout:** de hele sub-spec-laag ontbreekt, en `Talented Tracker` op plek 3 is fout voor een
goudspeler.

```lua
[393] = {
    { tree = "Thorough Tanning" },
    { tree = "Gainful Gathering" },
    goals = {
        self = { { anyOf = { "Lasting Leather", "Superb Scales" } } },
        gold = { { tree = "Talented Tracker" }, { tree = "Majestic Materials" } },
    },
},
```

De volgorde tussen de eerste twee maakt niet uit — beide geven hun kernvaardigheid bij het leren.
⚠️ Hier staat `Lasting Leather` als **Skinning**-trait 106088, niet de Leatherworking-naamgenoot.

### `[755]` Jewelcrafting

**Nu:** `Thoughtful Throughput` → `Glamorous Gems` → `Proficient Processor`
**Fout:** `Alluring Accessories` ontbreekt volledig — precies de boom voor jezelf en je gilde.

```lua
[755] = {
    { tree = "Thoughtful Throughput" },
    { anyOf = { "Glamorous Gems", "Alluring Accessories" } },
    { tree = "Proficient Processor" },
},
```

📌 **Gems zijn niet meer de automatische goudmijn.** In Midnight bestaat geen voorwerp meer dat
sockets toevoegt (alleen de Great Vault), dus de vraag naar geslepen gems is structureel lager
dan in de vorige uitbreiding. Stap 2 is dus een echte keuze, geen default.

### `[773]` Inscription

**Nu:** `Calm Hands` → `anyOf{Perfected Products, Perfect Products}` → `Blueprints`
**Fout:** stap 2 en 3 staan omgedraaid en de volgorde is **niet uitvoerbaar** — `Blueprints` gaat
op skill 50 open, `Perfected Products` pas op 60.

```lua
[773] = {
    { tree = "Calm Hands", points = 10 },
    { tree = "Blueprints" },
    { tree = "Perfected Products" },
},
```

✅ **De dubbele spelling kan weg.** Gamedata: trait **109660 = `Perfected Products`**. De
sub-takken heten wél "Perfect ..." (`Perfect Vantus Runes`, 109656), en één gids heeft de -ed van
de stam laten vallen. `wow-professions` had gelijk.

📌 **`Calm Hands` heeft max-rank 10**, niet 30 zoals de gidsen schrijven. Bij het eerste punt
komt het Treatise-recept er gratis bij; op 10 geeft je Treatise een extra kennispunt per week.
Dat is de belangrijkste drempel van het hele beroep, want hij versnelt al je latere punten.

---

## 4. Twee onafhankelijke sporen die dit bevestigen

Uit de Zygor-update van 20 aug — **kandidaten, geen bewijs**, maar ze komen niet uit Spec 24:

- **Engineering:** *"Put 10 points into the Recycling specialization and pick the Resourcefulness
  sub-spec"*. Bevestigt de reparatie die al uitging, en voegt twee dingen toe die onze route niet
  draagt: de **drempel van 10** en een **sub-spec**. Overweeg
  `{ tree = "Recycling", points = 10 }` gevolgd door de Resourcefulness-node.
- **Inscription:** *"Learn the Calm Hands specialization"* als eerste. Onze eigen levelgids
  (`PROFGUIDE_LVL_INSCRIPTION`) zegt hetzelfde. **Twee bronnen die het met elkaar eens zijn en
  niet met onze route** — dat is precies wat de correctie hierboven doet.

---

## 5. Klaar als

- De tien routes staan in `advisorRoutes`, met per gewijzigde route een commentaarregel die zegt
  wat er fout was en waartegen het gecontroleerd is.
- De starter-build-sectie van les 2 is alsnog gebouwd, en route en tekst zeggen hetzelfde.
- Rob heeft op zijn shadow priest een gecorrigeerde route vanaf nul gelopen (Tailoring 12 punten,
  Enchanting 22) en bevestigd dat het advies klopt met wat hij op zijn scherm ziet.

⚠️ **Bouw geen exacte puntenaantallen in als harde waarheid.** Bij élke profession spraken de
bronnen elkaar tegen, soms met een factor 2. De `points`-waarden hierboven zijn de best
onderbouwde, en de UI hoort er "lees de tooltip" bij te zetten.
