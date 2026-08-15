# Vaults of Atal'Utek — what is still unmeasured

Written 14 aug 2026, na de bouw van het Codex-artikel, de Honored Dead-hunt, het
lead-in-blok en de Underbelly-regel. Alles wat daarin staat is gemeten. Dit bestand is
de andere helft: wat er **niet** in staat, waarom, en met welk commando het te meten is.

Eén ronde door de Vaults met deze lijst ernaast sluit vrijwel alles af.

⚠️ **Lees dit als een boodschappenlijst, niet als een to-do voor een sessie.** Een
cloud-sessie kan geen van deze dingen zelf meten. Wat een sessie hier wél mag doen is de
uitkomst verwerken zodra Rob hem plakt.

---

## ✅ 1. GEMETEN 14 aug — de criteria-ids kloppen. Dit punt is dicht.

`/mh atal` in de Vaults, op Robs client:

- **63610 "The Honored Dead"** — alle twaalf criteria bevestigd, **116407 t/m 116418**,
  mét de namen die het spel eraan geeft. Twee stonden al op done (*To a father* 116414,
  *To a stranger* 116417). HandyNotes had ze dus gewoon goed.
- **63601 heet "Oppose the Foes"** — de drie rare elites, criteria 116325/116326/116327.
  **Khu'tulak stond op done**, dus die heeft Rob al gedood; zijn locatie is dus te vangen
  met `/mh capture` als hij hem weer tegenkomt.
- **62601 heet "Soft Underbelly"** — vijf criteria: Szarith the Fanged (113661), Priest of
  the First Rattle (113558), Champion of the Scale (113557), Guardian of the Sacrifice
  (113556), Vserix the Sneaky (113662).

De twee achievement-**namen** waren nieuw en staan nu in het Codex-artikel, in alle zeven
talen. De namen blijven Engels: het spel toont ze in de taal van de speler, dus een
verzonnen vertaling zou niet matchen met wat hij op zijn scherm ziet.

⚠️ Dat de ids klopten is een uitkomst, geen regel. HandyNotes' *coördinaten* waren al
vertrouwd; hun *quest-band* bleek op 13 aug niet de vlag die het spel afvuurt. Dat deze
criteria wél kloppen zegt niets over de volgende lijst die er vandaan komt.

## ~~1. De criteria-ids van The Honored Dead — begin hier~~ (afgehandeld, zie boven)

**Waarom eerst:** `Modules/AchievementsData.lua` verscheept de twaalf gedenktekens met
criteria `116407..116418`. Die komen van HandyNotes_Midnight 150. Voor coördinaten is dat
de bron die deze repo vertrouwt; voor **ids** is het sinds 13 aug expliciet de bron die
deze repo níét vertrouwt — hun Coiled Isle-questband bleek niet de vlag te zijn die het
spel afvuurt.

Als ze fout zijn, faalt het stil: de kaart blijft op 0/12 staan terwijl je op het
gedenkteken staat.

    /mh atal

Het nieuwe **Achievements**-blok in die uitvoer vraagt jouw client om elk criterium van
63610, 63601 en 62601, en zegt er per regel bij of wij hem verschepen. Groen op alle
twaalf betekent dat de hunt klopt. Staat er rood, plak de uitvoer — dan vervang ik de
ids.

Alternatief met meer detail per criterium: `/mh ach id 63610`.

## ✅ 2. GEMETEN 14 aug — het zijn er DRIE, geen één

`/mh atal` leest nu `C_Map.GetMapLinksForMap`. De client geeft **zes** links:

**Coiled Isle (2512) → Vaults (2509)** — de ingangen:
`45.37 / 64.93` · `43.28 / 44.19` · `31.88 / 64.90`

**Vaults (2509) → Coiled Isle (2512)** — de uitgangen:
`30.73 / 82.19` · `63.67 / 89.70` · `71.05 / 43.65`

Die laatste drie zijn precies wat Rob op zijn kaart telde: **twee onder, één rechts**.
Hij zag een vierde pijl; die is dus géén map-link en nog onverklaard.

⚠️ **CORRECTIE 15 aug — en de fout was van ons.** Hier stond dat Zygors `47.24 / 60.79`
"er ~4 naast zat" en dat elke gids ten onrechte één ingang beschrijft. Zygor schrijft dat
als `|goto Vaults of Atal'Utek/0 47.24,60.79`: dat is **kaart 2509, binnen de Vaults** —
de questhub waar je 98388 oppakt. Het was nooit een uitspraak over het eiland. Wij hebben
het op 12 aug overgenomen als "de ingang, op de Coiled Isle" en elke vergelijking daarna
erfde die fout.

Wat blijft staan: de drie links zijn gemeten, en één vast coördinaat zou nog steeds de
verkeerde **vorm** zijn geweest. Wat niet blijft staan: niemand zat er 4 naast, en geen
gids is hier weerlegd. Twee kaarten met elkaar vergelijken en het verschil andermans fout
noemen is precies het soort zelfverzekerde misser waar dit bestand tegen bestaat.

`CampaignLeadIn.lua` heeft nu `startCandidates` met alle drie en kiest de dichtstbijzijnde
als je op 2512 staat. De routeknop is dus niet langer verborgen.

⚠️ **Geen link naar 2613.** De Underbelly staat in de lijst met nul links, terwijl we
zijn ingang op `47.30 / 11.20` hebben staan. Die overgang is dus iets anders dan een
map-link. Niet verder onderzocht.

## ~~2. De ingang van de Vaults~~ (afgehandeld, zie boven)

**Waarom:** het lead-in-blok op de Home-tab laat nu bewust géén routeknop zien voor
iemand die de keten nog niet heeft opgepakt, omdat we niet weten waar je binnengaat.
Zygor zegt ~47.24 / 60.79 op de Coiled Isle. Dat getal gaat hier niet in — op 12 aug
stond de Crafting Orders-pin uit dezelfde soort bron 13m naast Robs eigen meting, en
13m is precies genoeg om iemand náást een ingang te zetten.

Ga voor de ingang staan:

    /mh capture

Daarna kan `CampaignLeadIn.lua` `startMapID/startX/startY` krijgen en verschijnt de knop.

## ✅ 3. GEMETEN 14 aug — twee bestemmingen, en een prijs die meeloopt

Rob stond bij Er'inye en fotografeerde alles. **Gemeten: 2509, 51.10 / 62.76.**

**Twee plekken, beide bij hem:**

1. **Corrode Spirit** — bij Er'inye zelf. Dit is wat de Altar-boom voedt.
   ⚠️ **De prijs loopt op per aankoop.** Robs eigen twee screenshots: **1500**, daarna
   **2000**. Zygor noteerde **1000**, vermoedelijk de eerste. Stappen van 500 dus, maar
   dat zijn drie punten — het artikel zegt "hij loopt op, lees het venster" en noemt geen
   formule.
2. **Skull of Er'inye** — een échte handelaar, naast hem. *"You feel tempted to deposit
   Corrosive Coins into its empty sockets in exchange for items of venomous wonder."*
   Drie pagina's. Gezien op pagina 1: Egg of Ula'tek 500 · Corrosive Writhling 5000 ·
   Volatile Venomfang 5000 · vier Venom-Cursed Ensembles à 10000 · Caustic Venomfang
   10000 · Recipe: Liquid Luster 2500 + 150 · Arsenal: Venom-Cursed Arms 25000.

**En drie sleutel-items die je aan Er'inye kunt tonen** (aparte gespreksopties):
**Excising Knife**, **Corroded Key** (item **280004**, *"This unlocks something in the
Vaults of Atal'Utek"*), **Spirit Loupe**.

**Gemeten: het gesprek is een hint, geen unlock.** Rob toonde de Corroded Key en kreeg
alleen: *"Holdin' dis, I feel adrift. I see venom all around, pourin' down on me."* met
als enige vervolgoptie "Let's talk about something else." Er gebeurt dus niets bij
Er'inye — hij beschrijft blind wat hij vóélt, en dat is de **plek waar het item hoort**.
Dat is de mechaniek: item tonen → raadsel → zelf zoeken.

## 3b. De vier Discoveries — KANDIDAAT, niet gemeten

⚠️ **Alles hieronder komt van method.gg (14 aug), niet van de client.** Reden om het
serieus te nemen: hun Er'inye staat op **2509 51.08 / 62.80** en Robs eigen `/mh capture`
gaf **51.10 / 62.76** — dat is dezelfde bron, de client. En hun Corroded-Key-locatie
("tussen twee venom-watervallen bij de Amani Foothold") is exact wat Er'inye Rob influisterde
zonder dat wij de gids toen gelezen hadden. Twee onafhankelijke bevestigingen.
Reden om het tóch niet te geloven: dit weekend gaven vijf externe lijsten een fout getal.

Het patroon is bij alle vier hetzelfde: **sleutel-item → object openen → dat geeft een
quest-item → quest bij Er'inye inleveren → keuze uit twee passieve nodes.**

| Sleutel | Object + `/way` | Levert | Quest | Keuze |
|---|---|---|---|---|
| **Corroded Key** | Venom-Worn Coffer, tussen twee venom-watervallen bij de Amani Foothold (meerdere spawns) | Mummified Lynx's Paw | The Luck of the Bound Spirit | Glideways / Swift Steps |
| **Spirit Loupe** | The Seal of Wrath, `/way #2509 48.46 25.80` | Feather of Tok'jara | The Winds of Tok'jara | Spirit Walk / Spectral Shipping |
| **Excising Knife** | venom-poel achterin The Underbelly, `/way #2613 68.52 15.86` | Eye of Szarith | The Watchful Gaze of Szarith | Egg Specialist / Egg Evasion |
| **Dispelling Charm** | Jin'tal's Reliquary, `/way #2638 36.73 24.73` (Profaned Mausoleum) | Lost Med'jai Amulet | The Protection of the Med'jai | Surge Seniority / Spiritual Succession |

De sleutels vallen uit Temple Strikes, Temple Incursions en Ancient Foes in de Vaults.
De **Dispelling Charm** en zone **2638** waren bij ons nog helemaal onbekend.

⚠️ **Eén tegenspraak, dus minstens één van de twee is fout.** nerdschalk zet de Excising
Knife op **69.0 / 75.7** in de Underbelly, method.gg op **68.52 / 15.86**. Zelfde X, heel
andere Y. Neem geen van beide over zonder `/mh capture` ter plekke.

⏭️ Nog open: pagina 2 en 3 van de handelaar; de coffer-coördinaat; en of de tabel klopt.
Elke regel is met één `/mh capture` bij het object af te vinken.

## ~~3. Wat Corrosive Coins kopen, en waar~~ (afgehandeld, zie boven)

**Waarom:** dit is voor een nieuwe speler de belangrijkste vraag na "waar loop ik heen",
en we hebben er geen enkel antwoord op. Het Codex-artikel noemt daarom alleen wát de
currency is, niet waar hij heen gaat.

Loop naar de vendor die ze aanneemt, open hem, en:

    /mh capture

en plak een screenshot van de vendorlijst. Prijzen en item-ids uit de client zijn genoeg
voor een echte regel in het artikel.

## 4. Wat de Altar of Corrosion-boom uitgeeft

**Waarom:** nooit gemeten. De tooltip zei "Spirit Corrosion" en de teller stond op 0 —
te weinig om iets te beweren, dus het artikel stuurt de lezer nu naar de tooltips in dat
venster zelf.

Sta bij het altaar, met het venster open:

    /mh atal

Het gossip-blok leest de opties uit die het spel aanbiedt. Als de tekst een prijs noemt,
is dat meteen de meting.

## 5. De twaalf gifts in de Corrosive Codex

**Waarom:** de namen die we hebben (Ophidian Maw, Insidious Venom, …) komen van een
screenshot, niet van de client. Ze staan daarom nergens in de addon.

Open de Codex met genoeg **Corrosive Souls** (item 273000) in je tassen en maak een
screenshot van het volledige raster, of laat `/mh atal` draaien terwijl het venster
open staat — als het een gossip-venster is, leest de probe de opties uit.

## 6. De drie rare elites op 2509

Congealed Malice, Khu'tulak, Susarikk — achievement 63601. HandyNotes parkeert alle drie
op 10.00/10.00, wat een placeholder is. Ze staan dus **niet** in de Rares-tab, en het
Codex-artikel zegt met zoveel woorden dat niemand hun locatie kent.

Zie je er één staan:

    /mh capture

En als je er één doodmaakt, met `/mh questdiff` aan ervoor en erna, hebben we ook de
quest-id die "gedaan" betekent.

## 7. De Underbelly-nodes (achievement 62601)

Er zijn er vijf; HandyNotes heeft er drie als placeholder. Van de twee bekende hebben we
de coördinaten niet in de repo staan — alleen Szarith the Fanged (38.40 / 17.69) staat
er nu, met een **honest zero** als quest-id omdat HandyNotes' 96030 in de band zit die
op deze eilandengroep aantoonbaar niet vuurt.

Twee metingen maken hier een echte hunt van, net als The Honored Dead:

    /mh capture     (bij elke node)
    /mh questdiff   (voor en na een kill, voor Szarith's echte quest-id)

## 8. Feeds The Honored Dead een zone-meta?

De hunt staat nu als `[Lore]` gemarkeerd, wat betekent `feedsMeta = false`. Dat is de
voorzichtige keuze, niet een meting. Als 63610 wél meetelt voor Light Up the Night of een
Coiled Isle-meta, hoort er `feedsMeta = true` bij.

Te zien in het achievementvenster: staat 63610 onder een meta als criterium?

---

## ✅ GEMETEN 14 aug — Venom-Cursed Fragments zijn een gear-systeem

Stond op geen enkele lijst, kwam uit Robs eigen tassen.

**Venom-Cursed Fragment**, item **279382**, soulbound, verkoopt voor 100 goud.
*"Use: Combine two fragments to create a Champion Venom-Cursed item for your
specialization. (5 sec cooldown)"*

Rob had er drie, voegde er twee samen en kreeg **Effigy of Ula'tek's Faithful**
(item **274483**): trinket, **ilvl 292**, Upgrade Level **Champion 1/6**, Unique-Equipped,
+121 Int/Agi/Str, met een proc voor 336 random secondary + 168 random tertiary, 12 sec.

Twee dingen die dit interessant maken voor MH:

1. **Het is spec-gericht catch-up gear.** "for your specialization" betekent dat het
   nooit een miss is — precies het soort ding waar een beginner niet van weet dat het
   bestaat. Kandidaat voor de loot-/gear-uitleg, niet voor een tracker.
2. **Onze eigen upgrade-checker werkte.** De tooltip toonde *"MH Upgrade: +20 ilvl for
   your spec"* op de trinket. Dat is een bevestiging in het wild, niet uit een test.

⏭️ Open: waar de fragments vandaan komen (Rob wist het zelf niet — *"ik kreeg ergens dit"*),
of het altijd een trinket is of per keer iets anders, en of er een cap op zit.

## ❌ Onze Delves-lijst kan de nieuwe delves niet tonen

Robs Delves-paneel toont elf delves, allemaal van basis-Midnight, geen enkele op de
Coiled Isle. Dat is **geen client-feit maar een feit over ons**:
`Modules/Delves.lua:55` bevat een **hardcoded roster van elf**, en de POI-scan draait op
die namen. Een delve die 12.1 heeft toegevoegd kan daar dus nooit in verschijnen, hoe
live hij ook is.

De watchers noemen er drie — **The Ring of Glory**, **Gnarldor Isle**, **Venomfall Deeps**
(de nieuwe Nemesis-delve, boss **Azta'rec**) — maar dat komt van datamining in juni, en dat
is precies de soort bron waar deze repo niet uit verscheept.

`/mh atal` heeft er daarom twee nieuwe blokken bij (14 aug): **Map links** en
**Points of interest**, over 2512 / 2509 / 2613. Die vragen de client wat er op het
eiland staat, met de atlas-naam erbij — dat is waar het icoon uit getekend wordt, dus
daar is een delve-POI aan te herkennen zonder dat wij vooraf beslissen hoe die eruitziet.

### ❌ De eerste twee POI-metingen stelden de verkeerde vraag

**Ronde 1 (drie kaarten):** één POI, een world quest. Geen delve.
**Ronde 2 (negen Midnight-zones):** 21 POI's — portals, Great Vault, Trading Post,
Soridormi, ritual sites, drie Special Assignments. **Nog steeds geen enkele delve.**

Dat leest als een antwoord. Het is er geen, en de meting bewijst dat zelf: **onze eigen
elf delves stonden er ook niet in.** Zul'Aman (2395) geeft twee portals en géén Atal'Aman.
Voidstorm (2405) geeft twee portals terwijl wij daar drie delves verschepen.

`C_AreaPoiInfo.GetAreaPOIForMap` **geeft dus überhaupt geen delves terug.** Elke "geen
delve gevonden" hierboven was een uitspraak over de API, niet over de wereld.

⚠️ Dit was alleen te vangen omdat de sweep per ongeluk **elf bekende positieve controles**
meedroeg. Zonder die elf had een lege lijst er als nieuws uitgezien — en had ik in ronde 1
bijna geconcludeerd dat de nieuwe delves niet op het eiland staan.

### ✅ De juiste call stond al in onze eigen code

`Modules/Delves.lua:1139` gebruikt **`C_AreaPoiInfo.GetDelvesForMap`** voor de
bountiful-status. Die is **op de kaart gesleuteld, niet op een naam** — dus anders dan
onze roster kan hij een delve teruggeven waarvan niemand hem heeft verteld. Precies de vraag.

`/mh atal` heeft nu een derde blok, **Delves the client lists per map**, over dezelfde
negen zones, met per regel of wij hem verschepen. Staat er iets met
**`<- NOT IN OUR ROSTER`**, dan heeft de client ons een 12.1-delve gegeven met naam,
coördinaat en atlas — en hoeven we niks uit een datamine over te nemen.

### ✅ GEMETEN 14 aug — twee nieuwe delves, uit de client

`GetDelvesForMap` gaf 16 delves over de negen zones. Veertien waren van ons. Twee niet:

| Delve | Map | Coördinaat | poiID |
|---|---|---|---|
| **Gnarldor Isle** | 2512 | `64.54 / 77.58` | 8761 |
| **The Ring of Glory** | 2512 | `71.35 / 56.54` | 8764 |

Allebei atlas `delves-regular`, allebei **op de Coiled Isle**. Mijn redenering dat
"Gnarldor Isle niet klinkt als een plek op dit eiland" was dus fout — en het maakte niet
uit, omdat de sweep toen al over alle negen zones liep in plaats van over mijn vermoeden.

Ze staan nu in `Modules/Delves.lua`, met de **echte poiID** in kolom 1. De namen stonden
sinds juni in de watchers uit een datamine en zijn daar bewust nooit uit overgenomen; nu
komen naam, kaart én coördinaat van Robs eigen client.

**En Venomfall Deeps staat er niet.** Dat is deze keer wél iets waard: dezelfde call gaf
op 2512 exact die twee, dus dit is afwezigheid **met een positieve controle** in plaats
van afwezigheid uit stilte. Klopt met Blizzards eigen indeling — Nemesis en Bountiful
zitten achter Season 2 (18 aug).

⏭️ Na 18 aug `/mh atal` opnieuw. Verschijnt Venomfall Deeps, dan op dezelfde manier erbij.

⚠️ Eén ding gevonden en **niet** gerepareerd: kolom 1 van de elf oude delves (93372,
93419, …) matcht nooit met de poi-ids die `GetDelvesForMap` teruggeeft (8425, 8437, …).
Die vallen dus elke keer door naar het name-pad. Werkt, maar het snelpad is dood. Elf
ongeverifieerde vervangingen op een werkende fallback is een aparte, risicovollere
verandering — wel opgeschreven, want de mismatch is onzichtbaar en ziet eruit als opzet.

## ⏭️ Vier pijlen op de Vaults-kaart

Rob telt er vier: twee onderaan, één rechts, en nog één. Ze zien eruit als
map-transitions, en eruitzien als iets is niet iets zijn. Het **Map links**-blok in
`/mh atal` vraagt het de client. Klopt het aantal met wat hij telt, dan zijn het
ingangen; klopt het niet, dan zijn de pijlen iets anders en weten we dát.

---

## Wat er al staat, zodat niemand het opnieuw meet

| | |
|---|---|
| Vaults of Atal'Utek | uiMapID **2509**, kind van 2512 |
| De Underbelly | uiMapID **2613**, kind van 2509 |
| Questketen | **98388 → 97640 → 98428**, alle drie met echte titels uit de client |
| Corrosive Coin | currency **3448** |
| Corrosive Soul | **item 273000**, geen currency |
| Ingang Underbelly | **47.30, 11.20** op 2509 |
| Szarith the Fanged | **38.40, 17.69** op 2613 |
| Twaalf gedenktekens | coördinaten in `Modules/AchievementsData.lua` |

Verwerkt in: `Modules/MidnightCodexData.lua` (artikel `vaults_atalutek`),
`Locales/Codex.lua`, `Modules/AchievementsData.lua`, `Modules/Rares.lua`,
`Modules/CampaignLeadIn.lua`.
