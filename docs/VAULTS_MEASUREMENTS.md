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

## 2. De ingang van de Vaults

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
Vaults of Atal'Utek"*), **Spirit Loupe**. Wat ze opleveren is nog niet gemeten — Rob had
de Corroded Key en gaat 'm laten zien.

⏭️ Nog open: pagina 2 en 3 van de handelaar, en wat die drie items doen.

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
