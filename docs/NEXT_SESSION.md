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

## ✅ 5 sep — `GetItemCooldown` afgedekt vóór 12.1.5 live gaat

De API-wachter vond het enige punt uit de hele 12.1.5-reeks dat op live een **echte Lua-fout**
geeft: `GetItemCooldown` zit in `Blizzard_DeprecatedItemScript` en wij riepen hem **drie keer kaal**
aan — `Delves.lua` 2× (hearthstone-cooldown in de reis-popup) en `DelveItemsPopup.lua:275`. Geen
guard, geen `pcall`, geen terugval.

⚠️ En `DelveItemsPopup` hád al een complete `C_Container`-terugval, direct ónder die regel — die
zou dus nooit bereikt zijn, want de fout valt erboven. **Een fallback achter de crash is geen
fallback.** Nu wel bereikbaar.

`ns.GetItemCooldownSafe(itemID)` probeert **`C_Item.GetItemCooldown` eerst**, dan de kale global,
allebei in een `pcall`, en geeft `nil` als geen van beide bestaat — wat elke caller als "onbekend"
moet lezen, nooit als "geen cooldown". Zelfde vorm als de zeven andere ItemScript-globals die al
afgedekt waren. Op 12.1.0 verandert er niets.

🔴 **NIET GEMETEN: bestaat `C_Item.GetItemCooldown`?** De migratie is letterlijk geciteerd uit
Blizzards eigen bron, maar niemand heeft hem in een client gezien. `C_Item` staat nu in de
`WATCH_TABLES` van `/mh ptr`, dus één run op de 12.1.5-PTR settelt het — en zegt tegelijk of de
kale global daar al weg is.

✅ **En één vermoeden ingetrokken:** `SocketInventoryItem` zit **niet** in
`Blizzard_DeprecatedItemSocketInfo` (de nu gepubliceerde lijst telt dertien functies en hij staat er
niet bij). Dat bevestigt wat we 4 sep op de PTR maten; het "verdacht op grond van de naam" mag weg.

## ✅ 5 sep — de level-waarschuwing is er, optie A, en opvallend

Rob koos **A** (waarschuwen, route wél zetten) met één aanvulling: *"maar opvallend waarschuwen!!"*
en *"een soort overal MH check, van hé je bent nog niet hoog genoeg om daarheen te gaan"*.

`Modules/ZoneLevelGate.lua` haakt in op **`ns.AddSmartTomTomWay`** — de deur waar vrijwel elke
route doorheen gaat, dus één plek in plaats van 29. De route wordt gewoon gezet; er komt een
**toast van 20 seconden** bij plus een chatregel om terug te vinden.

📌 **De drempel komt uit `ns.GetTargetRegionGroupID`**, dezelfde functie die 4 sep gerepareerd is —
inclusief de x-slice op canvas 2576. Geen tweede kaarttabel die van de eerste kan afdrijven.

**Wat online gemeten is (Rob vroeg erom):**
| | level |
|---|---|
| Midnight intro-questlijn | **78** (twee onafhankelijke bronnen) |
| Eversong Woods | 80-82 |
| Zul'Aman · Harandar | 82-88 |
| Voidstorm | 88-90 |
| eindlevel | 90 |

⚠️ **De drempel is per REGIO en bewust de laagste van die regio** (Quel'Thalas 80, Harandar 82,
Voidstorm 88). Een per-zone tabel zou map-ID's vereisen die we NIET rond hebben —
`GetBaseZoneName(2395)` antwoordt nog altijd "Zul'Aman" voor wat op Eversong lijkt, open sinds
augustus.

🔴 **NIET GEMETEN: houdt het spel je fysiek tegen?** Dat staat sinds 3 sep als open vraag in
`TESTLIJST.md`. Daarom zegt de tekst *"dit gebied is afgestemd op level X en jij bent Y"* en nooit
*"je kunt daar niet heen"* — dat laatste kan de speler ter plekke weerleggen door binnen te lopen.

⚠️ **Throttled per doelzone (120 s)**, want een bulk-route publiceert een dozijn waypoints tegelijk
en een dozijn identieke toasts leert je ze weg te klikken zonder te lezen.

📌 **INTREKKING van mijn eigen advies van 4 sep.** Ik noemde `CHANGELOG_260_3` "aantoonbaar onwaar"
en zei dat hij hoe dan ook opgelost moest. Bij herlezing gaat die zin over **Home / Next up** ("Home
now leads with 'Next up' … **it** never points you at endgame content"), en dáár klopt hij sinds
3 sep. Ik las er een addon-brede belofte in die er niet staat. Bovendien is het een changelog-regel
van 2.6.0 — een historisch verslag, geen lopende garantie. **Niet aanpassen.**

`/mh zonegate` toont per regio wat deze character zou krijgen, ook op max level waar hij nooit
vuurt.

### ✅ 5 sep, na Robs test op zijn 69: geluid + een schakelaar voor optie B

Twee dingen kwamen terug uit de test, en allebei zijn ze gebouwd:

1. **Geluid** (`7ea1388`). *"Kan de toast ook een duidelijk geluid spelen??"* — `SOUNDKIT.READY_CHECK`,
   dezelfde die `ShardCapAlert` gebruikt. Hergebruikt in plaats van een nieuwe keuze: die is gemeten
   hoorbaar op het Master-kanaal bij laag SFX-volume, en "Midnight Helper wil je iets zeggen" één
   geluid houden is meer waard dan een eigen deuntje per functie.
2. **Schakelaar voor optie B.** *"Maak die schakelaar maar en zet hem standaard op uit zodat mensen
   bewust kiezen om hem wel te krijgen."* → `SET_ZONEGATE_BLOCK_TITLE`, Instellingen → Route-pijl,
   **standaard uit**. Uit = wat iedereen nu al heeft (waarschuwen én routeren), dus een update
   verandert niets onder iemands handen. Aan = de route wordt geweigerd.

⚠️ **Twee dingen die de bouw stuurden, en die bij een volgende wijziging blijven gelden:**
* **De 120-seconden-throttle geldt NIET bij weigeren.** Een klik die geen route zet én niets zegt is
  van buiten precies hetzelfde als kapot — de fout die CLAUDE.md van 3 sep beschrijft. Weigeren is
  het geval dat altíjd moet spreken.
* **Bij weigeren keert `AddSmartTomTomWay` terug vóór `ns.lastTarget`.** Een route die we afwijzen
  mag geen doelwit achterlaten voor de pijl, de reisassistent of een latere refresh.

📌 **De waarschuwing zelf is niet uit te zetten.** Die is er juist gekomen omdat ze ontbrak; alleen
wat erna gebeurt is een keuze.

⚠️ **Nog te doen:** `ZONEGATE_BLOCKED`, `SET_ZONEGATE_BLOCK_TITLE`, `_DESC` en
`LEVELBAR_BELOW_ENTRY_FMT` staan alleen in enUS + nlNL. Samen met de drie oudere
`ZONEGATE_*`-sleutels wachten ze op de/fr/es/pt/it via `Translations2026.lua`. Tot dan valt `ns:L`
terug op Engels — zichtbaar, niet kapot.

### 🔴 5 sep, tweede testronde: één echte bug, één open meting, één nieuwe balk

**1. De eigen waypoints zetten geen route.** Rob: *"bij de omnium folio enz geen tomtom added a
waypoint"*. De level-waarschuwing kwám wél, dus de functie liep — wat níét gebeurde was het
waypoint. Diezelfde sessie zette `ns.AddSmartTomTomWay` wél een pijl naar The Darkway, in
diezelfde stad.

📌 **Niet het tweede routepad gaan repareren, maar weghalen.** `CurrencyGuide`, `OmniumFolio` en
`TierSet` gaan nu door `ns.AddSmartTomTomWay`, met hun oude `SlashCmdList["TOMTOM_WAY"]`-pad als
terugval voor als `Delves.lua` ontbreekt. Dat is precies de conclusie die de vorige commit al
opschreef en toen niet doortrok: drie privé-kopieën van de routering die elk apart alles moesten
leren, en er is er minstens één die iets nooit geleerd heeft.
⚠️ `DelveTipMarkup:668` gebruikt hetzelfde slash-pad, maar alleen als terugval wanneer
`AddSmartTomTomWay` er niet is — daar hoeft niets aan.

**2. Geen geluid, en drie mogelijke oorzaken die er identiek uitzien.** `SOUNDKIT.READY_CHECK`
bestaat niet op deze client / `PlaySound` weigert / het speelt en is onhoorbaar. **NIET GOKKEN** —
`/mh zonegate test` print nu wat elke stap teruggaf (`willPlay`, `handle`) en vuurt daarna de echte
toast door dezelfde deur, met de throttle geleegd. Antwoord verwacht van Rob.

**3. De rode balk boven in het venster.** Robs idee: *"wanneer iemand onder lvl 78 is standaard een
soort rode balk boven aan de addon."* Gebouwd in `UI.lua` (`ns.mhLevelBar`), tussen de
favorietenrij en de inhoud, ververst op `PLAYER_ENTERING_WORLD` en `PLAYER_LEVEL_UP`.

⚠️ **78 is bewust een ánder getal dan de 80 van de Silvermoon-banner.** 80 is Blizzards eigen
aankondiging (waar Eversong/Silvermoon op afgestemd zijn); 78 is waar de intro-questlijn opengaat,
uit twee gidsen plus Robs eigen lezing. Twee claims van verschillende sterkte, dus twee getallen —
`ns.MidnightEntryLevel` naast `REGION_MIN_LEVEL`.

📌 **En de balk claimt iets over ONS, niet over het spel:** "Midnight Helper is gemaakt voor 78 en
hoger." Of het spel een level-70 fysiek tegenhoudt is nog steeds ongemeten, en deze zin hangt daar
niet van af. Er wordt niets verborgen of uitgezet.

### ✅ GEMETEN 5 sep — de ontbrekende TomTom-pijl was géén bug, en ik zei twee keer het tegendeel

Rob, vanuit **The Azure Span** (Dragon Isles), klikte de Catalyst aan en meldde *"geen tomtom
pijlen !!"*. `/mh arrow` gaf het antwoord in vier regels:

```
jij:  map 2024 (continent 2444)
doel: map 2393 (continent 0)      een ligt in de ander: nee
TomTom actief: ja   zijn pijl zichtbaar: nee
wij sturen: ja      onze pijl getekend: ja      zichtbaar: ja
```

**TomTom weigert een pijl naar een ander continent**; onze eigen pijl neemt het dan over, precies
zoals bedoeld, en Rob bevestigde met een screenshot dat die er stond. Continent `0` is trouwens
gewoon Eastern Kingdoms' instance-id, geen leesfout.

🔴 **Twee keer op rij een verkeerde diagnose, met dezelfde vorm.** Eerst *"echte bug, gevonden"*
over Omnium Folio/TierSet — het ontbreken van de pijl had niets met die knoppen te maken. Daarna
*"volgens de meting hoort er een reispopup te zijn"* — de diagnoseregel zegt alleen dat regiogroep
0 de popup niet ONDERDRUKT; hij heeft nog steeds een portaal- of Hearthstone-knop nodig om iets te
tónen, en die zijn er hier geen van beide. **Een regel die zegt "dit blokkeert het niet" is geen
regel die zegt "dit gebeurt".**
📌 Beide keren stond het bewijs al in Robs eerdere screens: *"is not on this continent"* verscheen
vanochtend al bij The Darkway, mét een werkende route.

⚠️ **De verhuizing naar `ns.AddSmartTomTomWay` blijft goed** (één routepad in plaats van drie, en
ze krijgen de reishulp mee) — maar hij heeft niets gerepareerd, en zo hoort hij ook beschreven te
worden.

### 🔴 OPEN — hoe kom je überhaupt IN Midnight als je er niet bent?

`MIDNIGHT_PORTALS` bevat **uitsluitend** portalen ín Midnight (2393/2405/2413/2576). Sta je op de
Dragon Isles, dan is er dus geen enkel antwoord: geen popup, geen knop, en een chatregel *"head for
Sanctum of Light first"* die niet vertelt hóé. Dat is correct gedrag van code die de weg niet kent
— en het is precies de situatie van elke levelende speler, dus van iedereen die de nieuwe rode balk
te zien krijgt.

📌 **Rob stelde deze vraag al op 3 sep, vanaf dezelfde plek**: *"kan die daar al heen dan, en hoe
dan?"* (zie `ResetRoutine.lua:304`). Toen is de weekly-kop gerepareerd, niet de reisvraag.

#### ✅ 5 sep — uitgezocht, en het is géén portaal maar een quest

Rob: *"zoek maar uit waar de portals zijn via Zygor denk ik, en anders moet er online wel een list
zijn toch?"* Beide gedaan. Wat er nu vaststaat, met de bron erbij:

| wat | waar | bron | hard? |
|---|---|---|---|
| Start van de campagne | **Stormwind 53.26, 54.32** (A) · **Orgrimmar 53.43, 77.32** (H) | `ZygorLevelingCommonMID.lua:8-44` | ✅ GEMETEN in bestand |
| De NPC | Image of Lady Liadrin (241677), quest **Midnight ##91281** → **A Voice from the Light ##88719** | idem | ✅ |
| Hoe je er kómt | item **Light's Summon ##239151** — "Travel to Quel'Danas" | `:46-47` | ✅ |
| Intro overslaan | gossip 138201, alleen met achievement **42045** | `:23, :42` | ✅ |
| Silvermoon → hoofdstad | SMC **53.33, 66.24** (portaalkamer rechts van Wayfarer's Rest) | method.gg | ✅ extern |
| Hoofdstad → Silvermoon | *"in the capital's portal room"* — **coördinaat ONBEKEND** | idem, zonder cijfers | 🔴 NIET GEMETEN |

🔴 **DE BELANGRIJKSTE VONDST: de weg naar binnen is geen portaal.** Het is een questlijn die
automatisch start in je hoofdstad, met een summon-item. Voor precies de speler waar de rode balk op
mikt — onder 78, ergens in oude content — is *"loop naar Lady Liadrin in Stormwind"* het juiste
antwoord, en een portaal-coördinaat zou dat niet eens zijn.
📌 Dat betekent ook dat `MIDNIGHT_PORTALS` waarschijnlijk de verkeerde tabel is voor dit probleem:
de eerste stap is een quest-gever, geen portaal.

#### ✅ 5 sep, een uur later: Rob heeft het gemeten, en het beantwoordt óók de vraag van 3 sep

Drie metingen van zijn eigen client, op een **level-70** Horde-paladin:

| meting | uitkomst |
|---|---|
| `/mh coord` bij het portaal | **map 85 (Orgrimmar) 56.25, 88.57 → Silvermoon** |
| Image of Lady Liadrin | **map 85, 53.37, 77.35**, npc **241677** — bevestigt Zygors 53.43/77.32 |
| Biedt zij de campagne aan op 70? | **NEE** — alleen een filmpje, geen quest |
| Kon hij door het portaal? | 🔴 **JA. Hij liep Silvermoon binnen op level 70.** |

🔴 **DAARMEE IS DE VRAAG VAN 3 SEP BEANTWOORD: het spel houdt je NIET tegen.** Die stond als
"NIET GEMETEN" in `ZoneLevelGate.lua`, in `TESTLIJST.md` en in twee van mijn eigen antwoorden.
De voorzichtige formulering — *"dit gebied is afgestemd op level X en jij bent Y"* en nooit *"je
kunt daar niet heen"* — blijkt dus niet alleen netjes maar ook **waar**. Was het andersom
geschreven, dan had Rob het vanmiddag met één portaalsprong onderuit gehaald.
⚠️ **Nooit terugdraaien.** De comment in `ZoneLevelGate.lua` legt uit waarom.

📌 **Twee verschillende poorten, en dat verschil moet zo blijven.** De GROND is open voor iedereen
die er kan komen; de CAMPAGNE is gelevelgated (op 70 geen quest). Laat een toekomstig "de intro
vraagt 78" nooit weglekken in een zin over een zone binnenlopen.

✅ **Portaal toegevoegd** aan `MIDNIGHT_PORTALS` (`Delves.lua`), het eerste item in die tabel dat
niet zélf al in Midnight ligt. Vanuit Orgrimmar krijgt een speler nu wél reishulp naar elk
Midnight-doel — als hub-portaal ook naar Harandar en Voidstorm.

⚠️ **Nog te meten: de Stormwind-kant.** Rob is Horde, dus die coördinaat heeft niemand. Geen entry
tot iemand hem meet; het paar "netjes" maken door de Alliance-kant te raden is precies de fout waar
dit bestand vol commentaar over staat.

#### ✅ 5 sep, direct erna: de reisplanner kende het hub-portaal niet, de popup wél

Rob stond in Orgrimmar, klikte een delve in **Eversong Woods** aan. De popup had gelijk (*"Use:
Portal to Silvermoon (105yd)"*) — **de pijl stuurde hem 354 m naar de flight master van
Orgrimmar**. Vanuit Orgrimmar kun je niet naar Eversong vliegen.

📌 **Twee antwoorden op één vraag op één scherm, en de verkeerde tekende de pijl.** Oorzaak: de
popup in `Delves.lua` accepteert al een portaal naar de **hub** als er geen portaal recht naar het
doel gaat (`hubPortal`); `BuildTravelPlan` deed dat niet — die eist `p.toID == outermost`, en niets
gaat naar Eversong. Plan leeg → `RouteFirstToFlightPoint` zag geen eerste stap om voor te wijken →
vlieg-heuristiek won.

✅ **Gerepareerd in `TravelPlan.lua`**: als geen portaal rechtstreeks naar het doel gaat, telt een
portaal op je huidige kaart naar **Silvermoon (2393)** ook als stap — maar alleen als het doel écht
in Midnight ligt, gevraagd aan `ns.GetTargetRegionGroupID` (regio 0 = onbekend = geen portaal).
Dezelfde functie die de levelwaarschuwing en de reisonderdrukking al gebruiken, geen tweede idee
van waar Midnight ligt.

⚠️ **Dit is dezelfde vorm als de fout van vanmiddag**: twee implementaties van één vraag, waarvan de
kortste het slechtere antwoord uitstuurt. Staat als waarschuwing al in `DelveTipMarkup.lua:274`.

#### ✅ 5 sep — de bovengrens uit de waarschuwing gehaald, op Robs vraag

Rob las zijn eigen toast: *"waarom tot lvl 88, terwijl je die ook kunt doen als je lvl 90 bent? En
82 is advies denk ik en geen harde eis toch?"* Twee keer raak.

🔴 **"80-88" is de LEVEL-band** — het bereik waarin de zone meeschaalt terwijl je omhoog gaat — en
op 90 speel je er nog elke week. Een zin die op 88 eindigt leest als een houdbaarheidsdatum op
content die er geen heeft. **`REGION_BAND` is verwijderd, niet gecorrigeerd:** alleen de ondergrens
was ooit dragend (de beslissing gebruikte altijd al `REGION_MIN_LEVEL`), de band was decoratie op de
tekst en precies de helft die verkeerd te lezen was.

✅ **En het "geen harde eis" staat er nu ronduit**, want dat is sinds vanmiddag gemeten in plaats
van vermoed: *"Niets houdt je tegen om er in te lopen — maar de vijanden daar zijn ver boven je."*
Dat verving *"Kijken kan gewoon"*, dat het alleen suggereerde.

⚠️ `ZONEGATE_BODY_FMT` wisselde van `%s / %s / %d` naar `%s / %d / %d` — bij een vertaling naar
de/fr/es/pt/it moet dat middelste veld een **getal** blijven, geen bereik.

#### ✅ 5 sep — de portaalknop-test klopt, maar mijn verklaring ervoor was fout

Rob, bij stap 5: *"welke waarschuwing bedoel je?"* Terechte vraag: hij krijgt géén nieuwe
waarschuwing van de portaalknop, en dat is precies goed.

🔴 **Maar de reden die ik op 5 sep in de commit `e707298` opschreef klopt niet.** Daar stond dat
`Delves:3682` (de portaalknop) *"deliberately excluded via `_mhTravelLegBusy`"* was. Nagemeten:
die vlag wordt **uitsluitend** in `DelveTipMarkup` gezet. De knop roept `TomTom:AddWaypoint`
**rechtstreeks** aan en komt dus nooit bij de bewaakte deur — hij hoeft er niet van uitgezonderd te
worden, hij bereikt hem niet. Zelfde uitkomst, verkeerd mechanisme.
📌 En een verkeerd mechanisme is waar een latere wijziging over struikelt: wie `_mhTravelLegBusy`
ooit opruimt zou denken dat hij hiermee de portaalknop raakt. De juiste reden staat nu bij de knop
zelf (`Delves.lua`, boven `portalBtn:SetScript("OnClick", …)`).

⚠️ **Voor de test betekent dit:** de toast die Rob zag hoort bij de **delve** waarop hij klikte,
niet bij de knop. Wil je het zuiver zien, wacht dan >2 minuten (de throttle) na die klik en druk
dán pas op de portaalknop — er hoort niets te komen.

### ✅ 5 sep — Dornogal, en Robs ontwerpvraag beantwoord zonder één nieuwe coördinaat

Rob liep *"even eigenwijs"* met zijn 70 naar **Dornogal** en vroeg een delve-route. Zelfde
doodlopende antwoord als in The Azure Span: *"head for Sanctum of Light"*. En hij stelde meteen de
goede vraag: *"kunnen we dit soort problemen niet afhandelen zonder allerlei testen te doen voor
coords ed, of wordt de addon dan wel heel erg belast?"*

**Nee, dat kost niets, en meer coördinaten was ook het verkeerde antwoord.** Twee reparaties, allebei
zonder nieuwe data:

1. 🔴 **De vlieg-terugval vroeg nooit of je er wel héén kunt vliegen.** Sanctum of Light is een echte
   flight point en volstrekt onbruikbaar vanuit Dornogal of de Dragon Isles. `ns.IsCrossContinentTarget`
   bestond al en was al gemeten; de terugval riep hem simpelweg niet aan. Nu wel — en dit is de
   werkelijke oorzaak van *beide* meldingen van vandaag.
2. ✅ **"Ga naar je hoofdstad" is het enige antwoord dat géén kaartdata nodig heeft.** Elke weg naar
   Midnight loopt via een hoofdstad, iedereen kan zijn eigen hoofdstad al bereiken, en zodra je er
   staat neemt `MIDNIGHT_PORTALS` het over. De stap is dus een **naam**, geen plek: geen rij per
   expansie-hub, niets te hermeten als Blizzard een portaal verplaatst.

📌 **De naam komt uit `C_Map.GetMapInfo`**, dus hij klopt in alle zeven talen zonder eigen vertaling.
Faliekant misgaan kan niet: lukt de lookup niet, dan komt er **geen** stap — zwijgen is wat dit
bestand sowieso verkiest boven een geraden hop.

⚠️ **Alleen 84 en 85 staan in `FactionCapitalMap()`.** 85 (Orgrimmar) is gemeten uit Robs eigen
`/mh coord`; 84 (Stormwind City) is het bekende partner-id en **niet** los gemeten — daarom leest de
aanroeper de naam terug en laat de stap vallen als die leeg is. Een fout id kost dan een ontbrekende
hint, nooit een verkeerde bestemming. Neutrale pandaren krijgen niets.

### 🔴 OPEN — The Den: de pijl raakt van slag zolang je binnen bent

Rob, 5 sep, opnieuw: *"The Den is nog een drama, alleen als ik eruit vlieg gaat de pijl weer terug
komen, en als ik in The Den een delve in SMC wil doen raakt ie weer van slag."*

📌 **Hypothese, NIET gemeten:** The Den is een sub-area op **verdieping 2 van Harandar**
(`FlightPointsData.lua:977` — `fpath The Den |goto Harandar/2 70.74,53.23`). `MHResolveWaypointMap`
in `Core.lua:646` klimt al omhoog wanneer het **DOEL** op zo'n sub-map ligt, maar er is niets dat
hetzelfde doet wanneer **DE SPELER** erop staat: `currentMap` wordt dan de sub-area, en daar hangen
regiodetectie, reispopup-onderdrukking en de pijl allemaal vanaf.

⚠️ **Eén `/mh arrow` vanuit The Den settelt dit.** De keten-regels laten meteen zien welk mapID
`currentMap` is en of hij als "ander continent" gelezen wordt — precies zoals de Azure
Span-meting vandaag de TomTom-vraag in vier regels afdeed. Niet gaan bouwen vóór die regel er is.

## 🗄️ AFGEHANDELD 5 sep — MH stuurt lage levels naar dingen die ze niet kunnen doen

Rob, 4 sep laat, expliciet gevraagd om te onthouden: *"ik kan met lagere levels in mh toch routes
krijgen voor dingen die ik nog helemaal niet kan doen — dit onthouden, doe er nu niks mee."*

**Dus: niet bouwen tot hij het zegt.** Wat er ligt is een keuze, geen taak.

📊 **GEMETEN 4 sep:** 29 modules kunnen een route zetten, **2** kennen de level-gate
(`ResetRoutine`, `UI`). Wat op 3 sep gebouwd is dekt This Week en het Silvermoon-tabblad; rares,
delves, treasures, achievements, events en professies routeren ongefilterd.

✅ **Goedkoper dan het lijkt:** `ns.AddSmartTomTomWay` is de gedeelde deur (Rares 9×, Achievements
16×, Delves 8×, RitualSites 4×), met vrijwel geen directe `SetUserWaypoint`-omwegen. Eén functie,
geen 29 bestanden.

⚠️ **En het raakt een GESHIPTE belofte:** `CHANGELOG_260_3` zegt dat MH *"never points you at endgame
content you cannot do yet"*. Dat staat in een uitgebrachte versie en is aantoonbaar onwaar. Dat
moet hoe dan ook opgelost — repareren of intrekken — ook als de rest wacht.

**De keuze die aan Rob voorligt (nog niet gemaakt):**
- **A** — waarschuwen bij de klik, route wél zetten. Aanbevolen: bij een rare is de coördinaat nog
  steeds nuttig, maar een route naar een zone waar je niet komt is verkeerd advies.
- **B** — route weigeren met de reden op de knop, zoals de Silvermoon-pins nu.
- **C** — niets doen en alleen de changelog-belofte intrekken (tien minuten).

## ⏭️ DUNDUN-WAARSCHUWING — stap 1 is af (4 sep), de rest staat open

Rob, 3 sep laat: *"zet maar op de lijst voor morgen."*

1. ✅ **AF, 4 sep.** De lijst is gevonden en het antwoord was een correctie: Dundun is geen
   modifier maar de Shrine of Abundance in Bountiful delves. Zie de sectie hieronder.
2. ✅ **GEBOUWD 4 sep** — `Modules/DundunShrine.lua`. Geen affixen nodig: (a) Bountiful komt uit
   `ns.IsDelveBountiful`, (b) rank uit `ns.GetDelverJourneyStatus` (drempel 3), (c) sleutels uit
   currency `3028`. `ns.GetDundunStatus()` levert één oordeel mét reden, zodat de chatregel en de
   diagnose niet uit elkaar kunnen lopen.
3. ✅ **GEBOUWD** — de chatregels haken aan `DelveCoach`'s `inDelve and not wasInDelve`, met 2
   seconden vertraging omdat de kaart-POI op de entree-tick nog niet altijd rond is.
4. ✅ **GEBOUWD** — de macro-tip staat in dezelfde regelgroep.

⚠️ **Stap 3 niet zonder stap 2.** Een sleutelwaarschuwing in een delve zonder Dundun is precies het
soort zelfverzekerde onzin waar 3 sep over ging. Daarom zwijgt hij bij `bountiful ~= true` én bij
een leesbare rank onder 3, en zegt hij bij een ONleesbare rank de voorwaarde hardop in plaats van
te doen alsof hij hem gecontroleerd heeft.

✅ **HET RISICO IS WEG — GEMETEN 4 sep in The Darkway (tier 11, Bountiful, live 12.1).**
`ns.IsDelveBountiful` antwoordt van **binnen** de delve `true`, op naam, op zone én op zone+map. De
kaart-POI blijft dus leesbaar; die zorg was ongegrond.

🔴 **Wat er wél mis was, waren twee fouten van mij, en ze kostten Rob vier runs in een delve.**
1. `ActiveDelveName` deed `return entry.name or entry.title`, dus als de roster-entry bestond maar
   geen van beide velden had, gaf hij `nil` **en sloeg de fallback over** die daar juist voor was
   toegevoegd. In diezelfde run zei `IsKnownDelveName("The Darkway")` gewoon `true`.
2. De roster is gesleuteld op id's (`the_darkway`), de zone is een weergavenaam (`The Darkway`);
   die rauw vergelijken gaf "nee" terwijl het item er stond.
📌 Eén keer de roster printen had beide getoond. Zelfde les als het werkende voorbeeld hélemaal
lezen, maar dan toegepast op een lijst die we zélf bezitten.

📌 **Nevenmetingen, zodat niemand ze opnieuw hoeft af te leiden:** `HasActiveDelve` = true is een
schoon in-delve-signaal · `GetActiveDelveTier` geeft binnen alleen nullen (entrance-side) ·
`GetDelvesAffixSpellsForSeason(2)` is **leeg**, dus dat is níét de route naar een modifierlijst ·
spell **430253** (Bountiful, uit het entree-scherm) is **geen speler-aura** ·
`GetTieredEntranceOptionalAffixTraitTreeID` en de entrance-strings geven binnen niets.

✅ **Shards zitten er nu in.** Het entree-scherm zegt dat 100 Coffer Key Shards bij binnenkomst
automatisch een Restored Coffer Key worden. "Je hebt 0 keys" was dus waar én nutteloos toen Rob er
84 had — de regel oordeelt op keys plus shards en zegt hoeveel shards er nog nodig zijn.

❓ **Nog te vertalen:** de zeven `DUNDUN_*`-keys staan in enUS en nlNL. de/fr/es/pt/it vallen nu
terug op Engels (dat is geen fout, wel onaf) — hoort via `Locales/Translations2026.lua`.

❓ **Nog onbeslist, en het raakt de tekst van de waarschuwing.** De wiki zegt dat de eerste vondst
van de wéék een *Abundantly Bountiful Heavy Trunk* met keuze-opties geeft (Undercoin / Voidlight
Marl / Valeera-XP / housing decor); Robs eigen meting en masterofwarcraft.net zeggen dat de eerste
vondst de **tweede koffer** geeft en dat latere vondsten de keuze geven. Wat de as is — eerste ooit
of eerste per week — is niet vastgesteld. De zin mag dus nog niet beweren wélke van de twee je krijgt.

## 🔑 4 sep — de aura-regel op 12.1.5 is GEMETEN: opsommen mag niet, gericht vragen wel

Zeven runs op **12.1.5.69594**, de beslissende gevangen door `/mh ptr watch` (sweep 8, 10:26:18, in
gevecht met Dame Bloodshed, speler in leven). **In één en dezelfde tick**, op `player` én `target`:

| aanroep | uitkomst |
|---|---|
| `GetUnitAuraInstanceIDs` | 🔴 REFUSED |
| `GetAuraDataByIndex` | 🔴 REFUSED |
| `GetAuraSlots(… "HARMFUL\|DISPELLABLE" …)` | 🔴 REFUSED |
| `GetAuraSlots(… "HARMFUL" …)` | 🔴 REFUSED |
| `GetAuraDispelTypeColor` | 🔴 REFUSED |
| **`GetUnitAuraBySpellID`** | ✅ **ok** |
| **`GetPlayerAuraBySpellID`** | ✅ **ok — gaf een table** |

Elke weigering luidt: *"Auras cannot be accessed when secret while tainted by 'MidnightHelper'"*.
Geen secret value meer dus, maar een **harde fout**.

🔴 **`ns.AllyHasRemovableAura` (`DispelHelper.lua:379`) overleeft dit NIET.** Die was juist zo
geschreven dat hij geen aura-data leest — alleen of er een dispelbaar slot is. Dat helpt niet; ook
`GetAuraSlots` weigert. De geshipte dispel-helper is geblokkeerd in precies de toestand waarvoor hij
bedoeld is.

✅ **Maar de regel is coherent en gunstig voor ons.** Alles wat **opsomt** wordt geweigerd; de twee
aanroepen die vragen naar een **spell-ID die je al kent** komen door. Blizzard blokkeert ontdekken,
niet verifiëren. En deze addon bestáát uit lijsten: een dispel-helper kan vragen *"zit een van deze
twaalf bekende debuffs van deze encounter erop"* in plaats van *"wat staat er op mijn maat"*. Meer
werk in de data, minder in de code — en de data hebben we grotendeels al.

⚠️ **De toestand is CONTEXTUEEL, niet permanent.** Vijf eerdere runs lazen alles gewoon, inclusief
een Polymorph op een ándere unit met `dispelName`, `spellId` en caster-GUID alle drie leesbaar. Wat
de omschakeling aanzet is **niet vastgesteld**; gevecht met deze elite is de enige waarneming. De
sweep legt combat/dood/targetnaam vast, dus de volgende waarneming versmalt het.

❓ **NIET gemeten:** of de velden **binnenin** die table leesbaar zijn of secret. Een table vol
secrets ziet er van hieraf identiek uit. Dat is de volgende vraag, en een kleinere.

📌 Weegt mee: `Auras.lua:128` noteert dat dezelfde `GetPlayerAuraBySpellID` op **live 12.1** in
gevecht zeven van acht buffs als `nil` gaf — het kalme verkeerde antwoord. Hier gaf hij een table.
Mogelijk beter in 12.1.5; één meting is geen patroon.

✅ **Geen crashrisico.** Alle 14 aura-aanroepen in 6 bestanden zitten in een `pcall` — gemeten met
positieve controle. Het faalt dus stil, en dat is precies waarom `/mh ptr watch` moest bestaan.

## 🔴 4 sep — de CAST-muur is hermeten op 12.1.5 en is ONVERANDERD dicht

De aantekening van 18 aug zei "bouw hier niets meer op; hermeet bij 12.2". Hermeten op **12.1.5
build 69594**, gevangen door `/mh ptr watch` op het `UNIT_SPELLCAST_START`-event zelf (peilen mist
de helft van de casts; langer peilen mist alleen vaker). Doelwit `Lightbloom Monstrosity`,
`UnitCastingInfo` gaf **11 slots**:

```
[1] SECRET  [2] SECRET  [3] SECRET  [4] SECRET  [5] SECRET
[6] boolean false   [7] SECRET  [8] SECRET  [9] SECRET
[10] "CastBar-803752C3BCEB3D2A"   [11] number 0
```

Negen van de elf secret. Naam, tekst, icoon, begin- en eindtijd, castID en spell-ID: allemaal dicht.
Alleen `castBarID` (slot 10) is leesbaar, en die bewijst enkel **dát** er gecast wordt.

🔴 **NIEUW en beslissend: `notInterruptible` (slot 8) is óók secret.** We kunnen dus niet eens
vaststellen of een cast te onderbreken is. Dat sluit interrupt-assistentie af op een niveau onder
"welke spell is het" — de vraag "valt hier iets mee te doen" is zelf niet te beantwoorden.

⚠️ **NIET geclaimd:** er kwamen twee verschillende castBarID's langs (via `nameplate1` en via
`target`), wat mooi zou passen bij Blizzards mededeling dat castbar-ID's per unit-token uniek zijn.
Er zaten vijf seconden tussen, dus het kunnen twee casts zijn geweest. Geen bewijs.

📌 **Wat de schakelaar omzet:** alle drie de aura-vangsten (10:26, 10:37, 10:40) hebben
`inCombat = true`; één ervan had geen target en weigerde toch. De cast van de mob kwam binnen op
`inCombat = false`, vijf seconden vóór de weigering. **Het gevecht zet het om — niet de
tegenstander, niet het hebben van een target.** Drie waarnemingen, geen bewijs van het mechanisme.

📌 `C_UnitAuras.GetAuraDispelTypeColor` neemt **`(auraInstance, curve)`** — gemeten uit de
foutmelding van een verkeerde aanroep, niet uit documentatie. Buiten de secret-toestand is dat het
"engine rekent, wij lezen niet"-patroon; erbinnen weigert ook deze.

## ✅ 4 sep — wat 12.1.5 wél heeft beslecht

Alles hieronder is GEMETEN op **12.1.5 build 69594, interface 120105**, met MH 3.7.3, via
`/mh ptr` (`Modules/PtrProbe.lua` → `ns.db.ptrProbe`). Elke meting draagt sindsdien zijn eigen
client, omdat er die ochtend twee `/dump`-uitkomsten binnenkwamen en niemand kon zeggen uit wélke
van de twee geïnstalleerde PTR's ze kwamen.

- ✅ **`SocketInventoryItem` bestaat** — de gem-knop in `GearEnchantCheck.lua` overleeft 12.1.5.
  🔴 En de redenering van de API-wachter was fout, niet alleen de conclusie: **alle tien
  `Blizzard_Deprecated*`-addons zijn écht verdwenen**, `ItemSocketInfo` incluis, en de functie is
  tóch aanwezig. "Addon weg, dus functie weg" gaat niet op. `Blizzard_DeprecatedChatInfo` — waar
  onze `SendChatMessage`-fallback op leunt — staat er nog wel.
- ✅ **De tegenspraak in Blizzards eigen bron is beslecht.** `StringContains` = **absent**,
  `string.contains` = **function**. De blue post beweert dat er aliassen behouden zijn "to prevent
  addon breakage"; voor deze ene naam is dat onwaar en had de wiki-tabel gelijk. De andere veertien
  verplaatste globals zijn er allemaal nog. Raakt ons niet (0 treffers).
- 🔴 **INTREKKING: `UIModeUtil.IsModeActive` is NIET verwijderd.** Dat beweerde ik 4 sep 's ochtends
  na het lezen van Zygors crash (`PetBattle.lua:27`); de client zegt dat de functie er is, met vier
  buren. Wat er wél weg is, is **`IsFrameLockActive`** — de andere naam op diezelfde regel, en die
  staat **niet** in Blizzards verwijderlijst. ⚠️ Dat verklaart hun crash nog steeds niet, want hun
  `and`-guard hoort een ontbrekende functie juist op te vangen. Oorzaak blijft open; het is hun bug.
  Wij gebruiken geen van beide namen (0 treffers, positieve controle in dezelfde run).
- ✅ **Op de speler is elk aura-veld leesbaar** — `spellId` 1459, `name`, `dispelName "Magic"`,
  `sourceUnit`, `expirationTime`, `icon`. Niets secret. Maar eigen auras waren nooit de vraag.
- 📌 `C_UnitAuras` heeft **39 functies**, waaronder `GetAuraDispelTypeColor`, `GetUnitAuraBySpellID`,
  `AuraIsPrivate` en `IsAuraFilteredOutByInstanceID`. Nieuw en aanwezig: `C_Weather`, `C_Intl`,
  `CreateFrameWithOptions`, `GetScriptBucketThrottleLimits`. Afwezig: `TimedSignalMap`, `C_TableUtil`.
- 🔧 **`tools/copy_to_ptr.bat` voedde alleen `_ptr_`** (12.1.0.69587) terwijl de nieuwe build in
  **`_xptr_`** zit (12.1.5.69594) — alles wat voor 12.1.5 bedoeld was landde stil op de verkeerde
  client. Doet nu elke geïnstalleerde PTR, slaat over wat er niet is, en blijft één vaste
  commandoregel zonder argumenten.

## 📌 3 sep (avond) — wat "Dundun" is, en het gat dat het blootlegt

Rob, in The Gulf of Memory: *"in het begin zei die, zoek de verborgen DunDun, wat is dat en waar
vonden we dat"*. Uiteindelijk **GEMETEN op zijn eigen entree-scherm** (Twilight Crypts, Tier 11):

> **Dundun** — *"Dundun will hide within this Delve. Finding him will provide additional rewards at
> the end of this Delve."* Spell ID **1299072**

🔴 **CORRECTIE 4 sep: hij is GEEN delve-modifier.** Deze regel stond hier een dag als feit en klopte
niet. De Warcraft Wiki heeft een categorie `Delve affixes` met 17 leden (Aquatic Hex, Artillery Fire,
Explosive Spores, Goblin Problems, Grasping Shadows, Haunted, Mole Machine, Nemesis Strongbox,
Nerubian Webs, Reactive/Smothering/Suffocating…, Strange Creatures, Web Spreaders, Zekvir's
Influence) — **Dundun staat er niet bij**, en die lijst is bovendien nog grotendeels The War Within.
Hij is de **Shrine of Abundance**: een NPC (wiki-NPC-ID **266751**) vermomd als een **nepboom**.

Dat hij op het entree-scherm verschijnt maakt hem geen affix. 📌 De les is dezelfde als die van
gisteren, één laag dieper: ik zocht eerst op de délve in plaats van op de modifier, corrigeerde dat,
en nam vervolgens klakkeloos aan dat het ding dat ik zocht wél een modifier wás.

⚠️ En hij zit **niet in élke delve**: alleen in **Bountiful** delves, elke tier, en pas na
**Delver's Journey rank 3 ("Treasure Hunter")**. Dat maakt het bouwwerk veel kleiner — zie hieronder.

✅ **HET SPELL-ID IS BESLECHT — 4 sep, GEMETEN op Robs eigen entree-scherm** (The Darkway, Tier 11):
de tooltip van de Dundun-eigenschap zegt letterlijk **`Spell ID: 1299672 (CDPulse)`**. Wowhead had
gelijk; de **1299072** die hier stond was mijn overtypfout van een screenshot. Verschil van één
cijfer, en precies daarom stond het als onbevestigd genoteerd in plaats van als feit.
📌 We gebruiken het nergens — de waarschuwing hangt op Bountiful + rank 3 + sleutelvoorraad — maar
een getal dat in een aantekening staat moet kloppen, want de volgende lezer neemt het over.

### ✅ Rob heeft de hele keten gemeten — en mijn gok was fout

Ik had geraden dat de vondst een **Shard of Dundun** oplevert, op grond van de naam en die weekcap
van 8. **Dat is het niet.** Zijn vijf screenshots, van begin tot eind:

1. Dundun **vermomt zich als een decorstuk** — een prop die er net iets te vreemd uitziet
2. Aanspreken geeft gossip: *"Would you like to revel in abundance?"* → **"Make my delve Abundantly Bountiful!"**
3. Melding: *"Additional Bountiful Rewards Will Manifest Upon Delve Completion"*
4. De prop verandert in een gouden wezen
5. Aan het eind staat er **een tweede Bountiful Coffer**

🔴 **EN DE PRIJS STAAT NERGENS: die tweede koffer kost een tweede Restored Coffer Key.** Robs eigen
tooltip: `Bountiful Coffer / Locked / Restored Coffer Key 2 / 1`. Hij had er één. Dundun's aanbod is
dus **geen gratis loot maar een ruil**, en wie het aanneemt met één sleutel op zak houdt een kist
over die niet open kan.

📌 Hij is met het blote oog niet te vinden — hij staat er als prop. De macro die Rob via YouTube
vond, en die het probleem oplost:
```
/cleartarget
/target dundun
/ping [@target] assist
```

⚠️ **De "Shard of Dundun" is dus vermoedelijk iets ANDERS dat toevallig naar dezelfde NPC heet** —
`Profession.lua` telt hem als beroepen-weekly (item `258901`, cap 8) en `AltOverview.lua` filtert
erop. Niet uitgezocht hoe die twee zich verhouden; wat nu vaststaat is alleen dat de delve-modifier
een **koffer** geeft, geen shard. Nergens in de addon staat waar die shards vandaan komen — dat blijft
een teller zonder oorzaak.

⚠️ **En de handvatten verschillen tussen addons**: wij hangen het aan **item 258901**, Broker_MidnightEvents
en Plumber gebruiken **currency 3376**. Beide noemen cap 8. Niet uitgezocht welke de juiste is; de
opmerking boven `Config.lua:25` waarschuwt precies voor dit soort id-verwarring.

### Het echte gat: wij lezen delve-modifiers helemaal niet

GEMETEN met positieve controle (`grep C_DelvesUI` over `Modules/` geeft ~80 treffers, dus het patroon
werkt): we roepen `GetActiveDelveTier`, `GetDelveEntranceTiers`, `GetTieredEntranceType`,
`GetDelvesFactionForSeason` en de hele companion-traits-familie aan — **maar nergens iets dat de
modifiers van de huidige delve uitleest**. `Knowledge.lua:383` probeert wel
`GetTieredEntranceOptionalAffixTraitTreeID` in een sweep, puur als bestaanscontrole.

📌 Dit is precies waar deze addon voor bestaat: DBM vertelt je wélke spell, Zygor wat je moet doen,
maar niemand zegt *"deze delve heeft Dundun, ga hem zoeken"* — en vooral niemand zegt **wat het
kost**. Wij tellen de Restored Coffer Keys al (`3028`, `Delves.lua`), dus we kunnen als enige de zin
schrijven die er werkelijk toe doet:

> *"Deze delve heeft Dundun. Vind hem voor een extra Bountiful Coffer — je hebt er dan **twee**
> sleutels voor nodig en je hebt er **één**."*

Voorstel voor een volgende sessie, in deze volgorde:
1. **De modifiers van de actieve delve uitlezen** — dat doen we nu nergens; `GetTieredEntranceOptionalAffixTraitTreeID`
   is de kandidaat en staat al in de sweep.
2. **De sleutelwaarschuwing**, want die is het hele punt en niemand anders geeft hem.
3. **De macro aanbieden** als kant-en-klare regel — sluit aan op het al gebankte
   *"handige chat-regels / snelacties"*-idee.
⚠️ Bouw 2 niet zonder 1: een sleutelwaarschuwing voor een delve die Dundun helemaal niet heeft, is
precies het soort zelfverzekerde onzin waar deze dag over ging.

## 🔴 3 sep (avond) — de routes: drie agenten, vier fouten, en één die geen datafout is

Rob stond **in Harandar**, klikte een route naar Twilight Crypts, en kreeg in één handeling:

```
TomTom: Added a waypoint (Twilight Crypts …) in Zul'Aman
MH:     Fly from Har'alnor to Torntusk Overlook.
TomTom: Added a waypoint (Flight master: Har'alnor …) in Harandar
MH:     Flight master: Har'alnor is not on this continent. Head for Portal to Harandar first.
```

Zijn pijl las tegelijk **"Har'alnor — 1km 180m"**. Drie agenten erop; ze corrigeerden elkaar op een
belangrijk punt.

⚠️ **EERST EEN CORRECTIE OP MIJN EIGEN TUSSENRAPPORT.** Ik gaf door dat het regiomodel de SMC-omweg
verklaarde. **GEMETEN: onwaar.** Harandar (2413) én Har'alnor zitten allebei in regiogroep 2; geen
enkele opzoeking geeft daar een verkeerde waarde. Ik had één agent geciteerd voordat de tweede hem
weersprak — precies wat ik zelf een uur eerder had aangekondigd niet te doen.

### ✅ Gerepareerd

**1. De portaalzoeker vroeg nooit waar je staat.** `TravelPlan.lua` matchte alleen `p.toID ==
outermost` en nam de eerste treffer; de eerste rij naar Harandar ligt in **Silvermoon**. Vandaar
"neem het portaal naar Harandar" terwijl je in Harandar staat. Nu ook `p.mapID == here`.
📌 Streng met opzet: een portaal op een dérde kaart is geen stap maar een stap die zelf een plan
nodig heeft, en die bouwt deze planner niet. Het bestand zei het al twee regels verderop: *"Silence
beats a guessed hop."*

**2. `ns.lastTarget` deed twee banen tegelijk.** Het is waar de pijl naar wijst — dus het moet de
tussenstap worden, anders is de leg niet te routeren — én het is wat `AnnounceUnreachable` als
*de bestemming* behandelt. Toen de leg het overschreef, vroeg die functie "hoe reis ik naar
Har'alnor" over een punt dat juist gekozen was omdat het het dichtstbij is. Legs dragen nu
`leg = true` (`_mhTravelLegBusy` bestond al) en zijn uitgesloten van het onbereikbaar-verdict.
⚠️ Een **label**, geen onderdrukking: de leg houdt de pijl. Een leg is per constructie nooit
onbereikbaar — het is een vliegpunt op je eigen kaart of een portaal waar je naartoe kunt lopen.

**3. Drie foute rijen in `FlightPointsData.lua`**, alle drie tegen Zygors LibTaxi gemeten:
- **The Den** droeg x=70.74, een **verdieping-2-aflezing op de verdieping-0-kaart**. Op 2413 is het
  54.10 (zelfde y). ✅ Zelf nagerekend in plaats van op rapport aangenomen: de andere vier
  Harandar-punten komen exact overeen met LibTaxi, dus deze rij is de uitbijter.
  ⚠️ En het bereikte de speler wél, wat de header van dat bestand ontkent.
- **The Royal Exchange** stond op `"B"` en is **Horde-only** → Alliance werd naar een onbruikbare
  flight master gestuurd. **Silverglade Refuge** stond op `"B"` en is **Alliance-only** → spiegelbeeld.
  Precies de fout die die factieletter hoort te voorkomen.

### ✅ Punt 4 dezelfde avond gebouwd — en Robs `/mh arrow` corrigeerde twee dingen

**`/mh arrow` in Harandar (GEMETEN):** `jij: map 2413 (continent 2694)` en `doel: map 2413
(continent 2694)`, zelfde ouderketen, *"een ligt in de ander: ja"*. 🔴 **Mijn 2576-hypothese is dus
niet bevestigd** — beide uitlezingen gaven 2413. ⚠️ En uit die meting is *niet* af te leiden of de
melding wegbleef door mijn leg-label of doordat de kaart deze keer consistent was; die twee zien er
van buiten identiek uit.

🔴 **En zijn tweede screenshot ontkrachtte mijn eigen fix van een uur eerder.** Hij haardsteende naar
Silvermoon en kreeg *"The Den is not on this continent. Head for Portal to Harandar first."* Daar was
die zin **waar en nuttig** — en ik had hem net onvoorwaardelijk het zwijgen opgelegd. Mijn
rechtvaardiging (*"een leg is per constructie nooit onbereikbaar"*) geldt op het **moment dat de leg
gemaakt wordt** en geen seconde langer. De guard test nu of de leg nog op je huidige kaart ligt.
📌 Dezelfde les als het Vaults-blok van vanochtend: een feit dat één keer gemeten is, is geen feit
dat waar blíjft.

**`Modules/FlightNetworkData.lua`** (gegenereerd door `tools/build_flight_network.py`) draagt nu
verbonden-componentnummers uit Zygors taxi-graaf. GEMETEN: 804 knopen, **38 componenten**;
Har'alnor / Har'athir / The Den = **35**, Torntusk Overlook / Sanctum of Light / Tokka's Landing =
**1**. Dus `FlightPathExists("The Den", "Torntusk Overlook")` = **false**, bewijsbaar.

📌 **Componenten, niet Zygors root-sleutels.** "Zelfde root = verbonden" was de verleidelijke
aanname; niets belet een root twee losse clusters te bevatten. De graaf wordt globaal doorlopen en de
componenten worden echt uitgerekend. Twee ingebouwde controles laten de generator falen als
Har'alnor niet aan The Den grenst, óf als Har'alnor en Torntusk Overlook in dezelfde component
belanden — dan zou de tabel juist de instructie zegenen waarvoor hij gebouwd is.

📌 **En het levert een beter antwoord op**: vanuit Silvermoon zit *Sanctum of Light* in component 1,
net als Torntusk Overlook. Er ís dus een vlucht — de hele Harandar-omweg was nergens voor nodig.

⚠️ **Dekking is 129 van onze 649 punten.** Daarom is de poort zo geschreven dat alleen een harde
`false` iets tegenhoudt; `nil` betekent *onbekend* en laat de hint gewoon door. Zou `nil` blokkeren,
dan verdween het vliegadvies vrijwel overal en dat is van buiten niet te onderscheiden van kapot.
⚠️ De poort zit op **beide** helften — de chatregel én de leg. Ze verschillend gaten geven is precies
hoe Rob vier tegenstrijdige regels in één handeling kreeg.

### 🔴 Wat NIET gerepareerd is, en niet te repareren valt met een rij-correctie

**Dat vliegadvies bestaat niet.** GEMETEN in Zygors `flightcost`: Harandars netwerk is een **gesloten
eiland van vijf punten met nul uitgaande verbindingen**; Torntusk Overlook hangt aan Eastern Kingdoms.
Er is geen taxipad Har'alnor → Torntusk Overlook.

📌 **En onze tabel kán dat niet weten**: 155 platte per-kaart-lijsten, **zonder één verbinding**. Wie
"dichtstbijzijnde hier" aan "dichtstbijzijnde daar" plakt blijft onmogelijke vluchten produceren.
Rob: *"kijken we daarna wel naar 4"* — de kandidaat is Zygors `flightcost`-graaf importeren.

⚠️ Verder open uit de audit, niet aangeraakt: **Founder's Point** (2352, 8 Alliance-huisvestingspunten)
ontbreekt volledig terwijl de Horde-tegenhanger compleet is; `FLIGHT_POINTS` heeft geen `[2576]`
terwijl zes andere tabellen die map wél hebben; en `GetBaseZoneName(2395)` noemt Eversong "Zul'Aman".

⚠️ **Nog steeds afgeleid, niet gemeten:** dat de client hem als 2576 én 2413 door elkaar teruggeeft.
De twee chatregels zijn onder geen enkele waarde allebei waar, wat het sterk maakt — maar `/mh arrow`
in Harandar zou het beslechten en dat is nog niet gedraaid.

## ✅ 3 sep (avond) — Zygor is nu een tweede bron, maar NIET in `tip_audit`

Rob: *"ja doe zygor als tweede bron voor raid tips."* Gebouwd als `tools/zygor_tips.py`
(`_probe.py run zygor_tips`), en de meting die vooraf ging heeft het ontwerp bepaald.

🔴 **Zygor draagt géén spell-ID's.** Grep op vier van onze raid-ID's (`1300530`, `1284483`,
`1301510`, `1292188`) in `ZygorDungeonCommonMID.lua` geeft **nul**, terwijl datzelfde bestand
**619** `|grouprole`-tips heeft. Positieve controle geslaagd, dus die nul is echt. Zygor kan dus
geen enkel nummer bevestigen of ontkennen — precies de taak van `tip_audit`. Hem daar toevoegen
had een bron opgeleverd die het met niets eens is.

📌 **Wat hij wél heeft is wat DBM níét heeft.** DBM geeft ID's en een alarmsoort (`watchfeet`,
`justrun`, `breaklos`) — dat zegt wat voor **soort** ding iets is. Zygor geeft zinnen voor een
speler: *"Split into two groups for phase 2 to soak Spectral Coils."* Dat is de laag waarvoor deze
addon bestaat, en we hadden hem nooit gelezen.

### ✅ De harde bevinding: 13 rollen waar Zygor advies schrijft en wij niets leveren

Dit is een **structurele** vergelijking (onze `TIPS`-tabel tegen Zygors `_TANK_`/`_HEALER_`/
`_DAMAGE_`-secties) en vereist geen enkele tekstinterpretatie:

| boss | rol |
|---|---|
| Imperator Averzian | TANK, DPS |
| Vorasius | TANK |
| Fallen-King Salhadaar | TANK, HEALER |
| Nek'zali the Soulcoiler | HEALER, DPS |
| Vashnik the Malignant | HEALER, DPS |
| Sszorak | DPS |
| **Ula'tek** | **TANK, HEALER, DPS** |

Ula'tek heeft bij ons alléén een `steps`-regel en bij Zygor alle drie de rollen — de eindboss van de
huidige tier is onze dunste.

⚠️ **De tekst ernaast is om te LEZEN, geen verdict.** Bewust geen automatische "wij missen X": onze
tips schrijven abilities als `{SPELL:id}` en Zygor als naam, dus een zin die in onze bron ontbreekt
kan op het scherm van de speler wél staan. Een checker die dat niet kan zien zou vrijwel elke ability
als ontbrekend melden en er vrijwel altijd naast zitten.

### 📌 Twee koppelingen, en de tweede bevestigde iets

Namen matchen exact (`RaidCoachData.lua` spelt ze zoals de client, geverifieerd met Robs `/mh ej
save`). Daarnaast draagt Zygor `kill <Naam>##<npcID>` en wij `seedCreatureId`: **3 vergeleken, 3
gelijk, 0 verschil.** Imperator Averzian is 240435 in beide bestanden — een onafhankelijke
bevestiging van onze creature-ID's die we niet hadden.

⚠️ Zygor heeft geen stap voor 12 van onze bosses (o.a. Entombed Sentinels, The Lost Explorers, The
Twin Fangs, The Coiled Altar) — hij splitst sommige encounters anders op dan de journal. Geen
bevinding, wel de reden dat de dekking geen 100% is.

### ⚠️ En het gereedschap had zelf twee bugs in vijf minuten, de tweede door de eerste te repareren

Het waard om te onthouden, want het is het patroon van de hele dag: v1 gebruikte `\s*` en `\s` dekt
nieuwe regels, dus het patroon matchte ook de **raid**-entries en zette vijf instances in de lijst
"bosses waar Zygor niets voor heeft". v2 eiste `encounterID` direct achter de naam en liet daarmee
**élke Season 1-boss vallen** — die dragen `seedCreatureId` ertussen. **Een patroon aanscherpen is
niet gratis.** v3 staat andere velden toe maar verbiedt een nieuwe regel.

### ✅ En daarna gevuld — Rob: *"ja doe die 13 gaten maar"*

91 nieuwe regels (13 keys × 7 talen). `zygor_tips` meldt nu **0 gaten**.

📌 **Twee bronnen per regel waar het kon:** het WAT uit Zygors `|grouprole`-tips, het WELKE SPELL uit
DBM. Een `{SPELL:}`-link staat er alleen waar DBM dezelfde ability kent — `1241836` Shadowclaw Slam,
`1246175` Entropic Unraveling, `1297630` Restless Amani, `1301118` Grasping Fangs. **Blackening
Wounds, Dig In en Venomous Heart kennen DBM noch enige ID-bron**, dus die staan als gewone Engelse
naam zónder link, in plaats van een nummer dat er compleet uitziet.

🔴 **En de linter ving meteen een fout in mijn eigen aura-parser van vanmiddag.** `1301118` kwam
binnen als `1 new / HARD`. Oorzaak: DBM schrijft `AddAuraSoundOption(1301118, true, -36292, …)` en
die parent is **negatief** — een encounter-journal-sectie die DBM leent voor de optienaam, geen
andere cast. Mijn parser eiste cijfers, gaf op, en het ID viel terug op WEAK. Een negatieve parent
telt nu als **self**: de AURA-OF-val heeft aan de andere kant een écht spell-ID nodig. Derde
positieve controle toegevoegd zodat het niet stil terug kan komen.
📌 Dit is de check die precies deed waarvoor hij bestaat: hij hield een nieuw geschreven regel tegen,
en de fout zat niet in de regel maar in het gereedschap dat hem beoordeelde.

⚠️ **En één stijlfout van mezelf:** ik schreef *"Tank: …"* in de nieuwe raid-tankregels, want zo doet
`DungeonTips` het. `RaidTips` doet dat níét — daar komt de rol uit **kleur** (`DungeonBossWindow.lua:961`)
of een **rol-icoon** (`DungeonGuide.lua:277`). 28 regels teruggedraaid. Volg de buren in het bestand
dat je bewerkt, niet die je het laatst gelezen hebt.

🔴 **WAT DIT NIET IS.** Niemand hier heeft deze gevechten gedaan — Rob zei het met zoveel woorden
over Ula'tek. De tekst is een getrouwe weergave van een gids die spelers volgen, geen ervaring. Dat
is een **zwakkere basis dan de DBM-gedekte spell-ID's ernaast**, en het staat als zodanig in
`RaidCoachData.lua` boven de tabel. Komt er ooit een melding dat een van deze regels niet klopt:
waarschijnlijk, niet verrassend.

## ✅ 3 sep (avond) — Zygor 9.6 opnieuw gelezen: onze conclusie klopte, onze volgorde niet

Rob vroeg de addon-updates na te lopen; Zygor had die middag een nieuwe build gezet (gidsbestanden
gestempeld 18:59) en meldde iets over Ula'tek.

**1. `A Toxic Tour` — classificatie bevestigd, met beter bewijs dan we hadden.** `98515` staat nu
**zes keer** in `ZygorDailiesCommonMID.lua`, waar het op 2 sep nul keer stond. Dat lijkt een
ommekeer en is het niet: de échte dailies beginnen in dat bestand pas bij `label
"Begin_Daily_Quests"`, en die lijst noemt acht ID's — `96644, 96640, 96643, 98420, 98419, 96641,
96642, 96639`. 98515 zit er niet bij. Het staat in de **intro-keten** die de gids ervóór doorloopt.
📌 Precies de val van 2 sep, één laag dieper: *"het staat in het dailies-bestand"* was toen waar en
betekende niets, en is nu opnieuw waar en betekent nog steeds niets.

🔴 **2. Maar de SPEELVOLGORDE klopte niet, en dat is nu gerepareerd.** Zygors gids:
98388 inleveren → **97640 én 98515 samen aannemen** → 97640 inleveren, 98428 aannemen → 98428
inleveren → dan pas 98515 inleveren, na vier `stickystart`-objectives. Dus 98515 wordt **als tweede
opgepakt en als laatste ingeleverd**; wij zetten hem op plek 3. Een speler die de keten juist volgt
zag stap 4 groen worden terwijl stap 3 open bleef — een checklist die er kapot uitziet juist wanneer
je hem goed doet. Chain is nu `98388 → 97640 → 98428 → 98515`.
⚠️ Zygors eigen `QuestDBData.lua` draagt **beide** volgordes in verschillende rijen en kan het dus
niet alleen beslechten. De gids is de speelvolgorde en is eenduidig. Spreekt een bron zichzelf tegen,
neem dan het deel dat beschrijft hoe je het dóét.

**3. Ula'tek: Zygor bevestigt onze bewuste WEAK.** Zijn raid-gids (`kill Ula'tek##268956`, patch
120100) zegt *"Split into two groups for phase 2 to soak Spectral Coils"*. Onze regel zegt soak
`1300530` maar niet met `1300685` erop, en DBM's commentaar bij `1300685` zegt *"can't soak Spectral
Coils"*. **Twee onafhankelijke bronnen, hetzelfde antwoord** — dat ene twijfelgeval in de baseline is
extern bevestigd.

⚠️ **OPEN, en bewust niet gebouwd:** dezelfde gids zegt *"Run opposite of the wing that is pulled
back for Caustic Waves"* (= `1292188`, dat wij alleen *"a raid-damage window"* noemen) en *"Grab the
eggs on the pull and keep them away from anything green"*, wat wij helemaal niet noemen. Rob kent
deze fight niet (*"ik weet niets meer van die fight sorry"*), dus niemand hier kan het verifiëren.
Raid-strategie in 7 talen uitrollen op gezag van één gids is precies wat deze dag drie keer heeft
afgestraft. Ligt klaar zodra er iemand is die het gedaan heeft.

📌 **En de grotere vondst: Zygor heeft per-rol strategie voor élke raid-boss en wij gebruiken die
niet.** `tip_audit` kijkt alleen naar DBM, en DBM geeft ID's en cues maar niet wat een speler moet
DOEN. Zygor geeft precies dat, lokaal en machinaal leesbaar — dezelfde eis waaraan MythicDungeonTools
voldeed. Kandidaat voor een tweede bron in de audit.

## 🔴 3 sep — de Home-kop beval endgame aan op een level 68, en het was één operator

Rob, op een level-68 Paladin: *"onze MH laat dingen zien die we nog helemaal niet kunnen doen
(toch??)"*. Ja. Vier agenten erop gezet — één die alleen mat, twee die het oneens moesten zijn, één
die de andere ~50 addons afliep — en alle vier kwamen op dezelfde eerste prioriteit uit.

**De oorzaak, gemeten:** `ResetRoutine.lua:911` koos de kop met `s.open and s.heroEligible ~= false`
— hero-waardig **tenzij** een stap nee zegt. Van de elf stap-constructors in dat bestand zei er
**twee** nee (Ritual Sites, Void Assaults). De rest was hero-waardig op elk level. Zo werd Halduron
Brightwing de kop op level 68, mét een "Take me there"-knop.

### 📌 De scheidslijn waar alles om draait

> **Aanwezigheid is een kaart. De kop en elke routeknop zijn een aanbeveling.**

Een endgame-weekly in de lijst *tónen* leert een levelende speler hoe de week eruitziet — precies
waar deze addon voor bestaat. Hem *aanbevelen* kost die speler een echte vlucht naar een NPC zonder
uitroepteken, waar hij niet kan zien of de addon fout zit of hijzelf.

⚠️ **Daarom is verbergen afgewezen**, hoewel dat de eerste ingeving was. Een level 68 die This Week
opent en een leeg paneel ziet concludeert niet "netjes gefilterd" maar "kapot" — en een verborgen
regel is niet te onderscheiden van een bug die niemand op max level ooit kan reproduceren. Dat is
letterlijk de regel uit `CLAUDE.md` waar `/mh arrow` voor bestaat, en we hebben er vanmorgen nog een
levend voorbeeld van gevonden (het Vaults-blok dat Rob op geen enkel character kan bereiken).

### ✅ Wat er gebouwd is

1. **`heroEligible` faalt nu dicht.** `== true` in plaats van `~= false`, en elke open stap zegt
   zelf wat hij weet. Een stap die niemand annoteert verliest voortaan de kop in plaats van hem
   stilzwijgend op te eisen — de volgende weekly kan deze bug dus niet herhalen dóór vergeetachtigheid.
2. **`CanActAt(minLevel)`** — en het addertje zit in `nil`. Dat betekent **niet** "op elk level goed"
   maar "niemand heeft het gemeten". Halduron draagt `minLevel = nil` met opzet (een level-80 warlock
   kreeg zijn level-variant `95468` op 11 jun) — maar **level 68 is nooit getest**, en twee van zijn
   drie quests zijn max-level dungeon-weeklies. Op max level is een ongemeten eis onschadelijk;
   daaronder kost hij de aanbeveling en behoudt hij de regel.
3. **De teller telt wat je kunt doen.** Hij sloot alleen `dim` uit, waardoor Robs "3 of 8" de Ritual-
   en Void-stappen meetelde — de twee die hetzelfde bestand tien regels eerder als endgame markeert.
   De kennis was er, en werd toegepast op de kop maar niet op het getal eronder.
   📌 `done` blijft álles tellen wat af is, ook wat dit character vandaag niet kon starten: een
   account-wide weekly die af is, ís af, en aftrekken zou het getal op een alt laten dalen.
4. **De "Start route"-knop deed het ook.** `ComputeOpenPins` testte alleen `open and pin`, dus die
   stuurde een level 68 dwars door de endgame Bazaar-hub en noemde de stops in chat. Alleen de kop
   repareren had de dúúrdere versie van dezelfde fout laten staan.
5. **Twee groepen in de lijst** — het actievoerbare deel genummerd 1..n (de nummering liep eerst
   1,2,3,4,5,6,7,10,11 omdat hij de rauwe array-index gebruikte), daaronder *"Later, als je verder
   levelt:"* met de rest, klikbaar maar ongenummerd. Een nummer leest als een plek in de rij.
6. **`/mh resetdebug` zegt nu waaróm** een stap is overgeslagen (`hero=NO (out of reach)`), plus cap,
   level en de tally. Verplicht, want de filter vuurt nooit op Robs eigen max-level characters.

### ⚠️ Wat hier NIET mee opgelost is

- **`CHANGELOG_260_3` (`enUS.lua:1890`) belooft al sinds 2.6.0:** *"While you are levelling it never
  points you at endgame content you cannot do yet."* Die zin was onwaar en is nu grotendeels waar
  gemaakt — maar hij is nooit ingetrokken toen hij het níét was. Rob beslist of hij blijft staan.
- 🔴 **Halduron op level 68 is nog steeds ongemeten.** Wij weten alleen dat een level 80 zijn
  level-variant kreeg. Of een 68 daar iets krijgt kan alleen Rob vaststellen door erheen te lopen.
  Zolang dat niet gemeten is, is `minLevel = nil` het eerlijkste dat we hebben — het kost hem nu de
  kop, niet zijn regel.
- **`ns.GetDelveCapLevel()` valt terug op een hardgecodeerde `80`** (`DelveWeeklyTrackers.lua:248`),
  drie niveaus diep ná twee API's. ⚠️ Een agent meldde dit als *"dus elk character van 80-89 telt als
  max level"* — **dat klopt niet zoals het er stond**: die val-terug vuurt alleen als beide API's
  falen. Het is een verouderde valstrik die stil de verkeerde kant op faalt, geen bewezen actieve bug.
  Niet aangeraakt; het waard om bij te werken naar 90 of te laten falen in plaats van te gokken.
- **Een ingeklapt blok** wilden beide agenten liever dan een kopregel. Bewust niet gedaan: dat vraagt
  de collapse-machinerie erbij en vandaag is er al één layout-bug geweest die precies daar zat.

### 🔴 En de eerste gate was nog niet goed: ik keek naar de quest, niet naar de bestemming

Robs volgende test, inmiddels level 69 in de Azure Span op de Dragon Isles: de kop koos de
**Herbalism-weekly**, en de vlieghint zei *"Take Sanctum of Light"*. Zijn vraag: *"kan die daar al
heen dan, en hoe dan??"*

Ik had die stap `heroEligible = true` gegeven met de redenering dat profession-weeklies **skill**-gated
zijn en niet level-gated. Dat klopt, en het is gemeten. **Maar de beschikbaarheid van de QUEST is een
andere vraag dan de bereikbaarheid van de TRAINER**, en ik heb de verkeerde gecontroleerd.

📌 **GEMETEN, en dit feit beslecht het hele "This Week"-ontwerp:** élke stop in `ResetRoutine.lua`
ligt op map **2393, Silvermoon City** — `VAULT_MAP`, `STATION_MAP`, `GIVERS_MAP`, `HUB_MAP` en alle
`TRAINER_PINS`. De weekroutine is geen lijst die toevallig wat endgame bevat; **hij ís Midnight-
endgame, in zijn geheel, in één stad.** Midnight loopt van 80 tot 90 (`TAB_GUIDE = "Leveling (80-90)"`).

`MidnightFloorMet()` gate nu de vault- en trainer-stappen. ⚠️ **80 is een content-feit, geen API-feit**
— er bestaat geen aanroep die de ondergrens van een expansie geeft, alleen de bovengrens — dus het
staat één keer opgeschreven naast het bewijs in plaats van als los getal door het bestand.

⚠️ **En "all done" zou hier een leugen zijn geworden**, precies de faalvorm waar ik Rob 's ochtends
voor waarschuwde: niets is actievoerbaar, dus de kop viel door naar de felicitatie.
`HOME_HERO_NONE_YET_FMT` zegt nu wát er aan de hand is en op welk level het opengaat.

✅ **De grens is diezelfde avond bevestigd, en niet door ons.** Rob: *"er staat vast ergens online
vanaf wanneer je daar naartoe kan?!?"* Ja: Blizzards eigen aankondiging en twee gidsen zeggen dat
**Eversong Woods opengaat op level 80** en dat Midnight van 80 tot 90 loopt met Silvermoon als hub.
Dat is een derde bron naast onze eigen `TAB_GUIDE = "Leveling (80-90)"` en Robs scherm. `MIDNIGHT_FLOOR_LEVEL = 80` staat.

⚠️ **Nog steeds niet gemeten, en het is een andere vraag:** of het spel een level 69 fysiek
tegenhoudt bij het portaal. 80 is de grens waarop de *content* begint; of de *deur* dichtzit is iets
wat alleen iemand die er doorheen loopt kan zeggen. Voor onze gate maakt het niet uit — wij bevelen
het hoe dan ook niet aan — maar schrijf het niet op als bewezen.

🔴 **En dat "geen bug"-antwoord van mij was te snel — Rob had gelijk.** Zijn screenshot toonde
*"Cuzoth — Item Upgrades (other continent — travel back) head for Portal to Silvermoon"*. Ik zei: dat
is een pin uit het Silvermoon-tabblad (`UI.lua:811`) waar hij zelf op klikte, dus werkt het. Zijn
weerwoord: *"eigenlijk zou dit soort adviezen niet moeten kunnen, tenslotte kan ik nog niet naar dat
gebied want ik ben <80. toch"*

Ja. Dat hij erop klikte **verklaart waarom de regel verschijnt en rechtvaardigt niet dat we een pijl
zetten** naar een gebied waar hij niet in kan. Precies dezelfde fout als de weekly-kop, één scherm
verderop: ik keek naar wat hij vroeg in plaats van naar wat hij kan.

`SetSMCWaypoint` staat nu achter `ns.MidnightFloorMet()`. 📌 **De kaart blijft** — opzoeken waar
Cuzoth staat is naslag, en een stadsgids die onder 80 leeg wordt is precies het verbergen dat we 's
ochtends hebben afgewezen. Wat stopt is de **route**: geen waypoint, geen pijl, geen reisplan, plus
een regel die zegt waarom. ⚠️ *Nearest flight point* en *world_tab* zijn bewust niet gegate: de
eerste leest waar je staat en werkt overal, de tweede opent alleen een tabblad.

⚠️ **En de routeknop stond er ook nog.** Robs screenshot toonde onder de lijst nog *"Set TomTom route
along the open stops (vault, hub, station)"* — die drie liggen allemaal in Silvermoon en stonden op
dat moment allemaal in de *"Later"*-groep. De **pins** waren gefilterd, de **knop** niet, dus zijn
eigen label adverteerde exact wat onbereikbaar was. `ns.CountOpenResetPins()` gate hem nu.
📌 Het patroon van de hele dag in één zin: **een filter is pas af als élke plek die eruit put hem
kent.** Vier keer nu — de hero, de teller, de route-pins, en de knop erboven.

### 🔴 En meteen daarna: de Hearthstone werd aangeboden zonder te kijken waar hij heen gaat

Robs eerste test van de nieuwe kop koos de profession-weekly — dat werkte. Maar de reis-popup bood
hem een **Hearthstone naar Silvermoon City** aan, terwijl die van hem op **Pinewood Post** staat.

`Delves.lua`, op **twee** identieke plekken:

```lua
local isHSVisible = (hsStartTime == 0 and not isHub and not isNearPortal)
```

Drie voorwaarden — niet op cooldown, niet in een hub, geen portaal dichtbij — en **nergens** de
vraag waar die steen landt. Er is nooit iemand geweest die het vroeg.

📌 **Derde keer op één dag dezelfde vorm**: een zelfverzekerde aanbeveling gebouwd op iets dat we
nooit gemeten hebben (de tip-ID's, de level-68-kop, en nu dit). Deze is de ergste van de drie, want
een verkeerde pijl loop je terug — een verbruikte Hearthstone-cooldown niet.

`HearthstoneGoesTo(targetZoneName)` staat nu naast `PortalUsable`, en beide aanroepplekken hebben de
gate (het commentaar dáár waarschuwt al dat een gate op één van twee identieke lussen het halve
antwoord geeft).

⚠️ **Bewust conservatief, en de ruil is echt.** `GetBindLocation` geeft een **herbergnaam**
("Pinewood Post"), het doel een **zonenaam** ("Silvermoon City"). Wie in een herberg bínnen de
doelzone gebonden is onder een andere naam, krijgt nu geen Hearthstone aangeboden terwijl die wél
had gewerkt. Een gemiste sluiproute kost een vlucht; een verkeerde kost de cooldown én het
vertrouwen. Robs tegenproef op de testlijst is precies deze: bind in Silvermoon en kijk of hij
terugkomt.
🔴 En hij faalt **dicht**: geen `GetBindLocation`, of een leeg antwoord, betekent *we weten het niet*
— en dat is exact de toestand die deze bug maakte, dus die mag niet doorlaten.
📌 `/mh portals` print nu ook je Hearthstone-bestemming en waarom hij wel of niet wordt aangeboden.
Zonder popup is "terecht stil" niet te onderscheiden van "kapot", en dit onderdrukt vaker dan het
toont.

### 📎 Wat de andere addons doen (gemeten, geen consensus geforceerd)

Het splitst per soort UI, niet per smaak. **Inhoudslijsten tonen het in rood mét de eis** — Zygor
zet *"Required level: 90"* in rood en verbergt zo'n gids nóóit; de HandyNotes-familie zet "toon
ontoegankelijk" zelfs **standaard aan**. **Score- en rostersystemen zwijgen** (RaiderIO, DBM
Keystones). Eén addon verbergt een weekly-regel, en die is mogelijk van dezelfde schrijver als wij —
dus geen onafhankelijke stem, en te weinig om een conventie op te bouwen.
📌 Eén gewoonte is het overnemen waard en nu nog niet gedaan: **rood = nog niet, grijs = voorbij.**
Wij gebruiken grijs voor allebei.

## 🔴 3 sep — 31 van onze 105 raid-spell-ID's houden geen stand tegen DBM

Rob liep een encounter op de Coiled Isle en snapte niets van onze aanwijzingen. Ula'tek met de hand
nagekeken: van onze vier ID's dreef er één een echte DBM-waarschuwing, één stond alleen in een
aura-geluidsoptie (de DoT van een ándere cast, terwijl wij zeggen *"dodge"*), één stond alleen in
een `--TODO`-commentaar, en één bestaat in geen enkele geïnstalleerde addon.

Rob koos DBM als maatstaf en zijn argument is het juiste: **DBM's ID's worden elke week in echte
pulls uitgeoefend door mensen die het meteen horen als een waarschuwing op het verkeerde ding
afgaat.** De onze komen uit datamining, in dit geval van vóór de boss bestond — onze eigen tiptekst
zegt dat zelfs, in de laatste bullet, ná vier regels die als feit lezen.

`tools/raid_tip_audit.py` (via `_probe.py run raid_tip_audit`). **GEMETEN over alle raids:**

| | |
|---|---:|
| spell-ID's in onze raid-tips | 105 |
| **ABSENT** — staat in géén DBM-mod | **21** |
| **WEAK** — staat er wel, maar DBM waarschuwt er nooit op | **10** |
| tipregels met minstens één van beide | **15 van 28** |

Ergste regels: `BELOREN_STEPS` (5), `VANGUARD_STEPS` (4), `ULATEK_STEPS` en `AVERZIAN_STEPS` en
`CROWN_STEPS` (3). Volledig schoon: Twin Fangs, Coiled Altar, Lost Explorers (op één na), Vashnik,
Lura, en beide Vaelgor-rolregels.

### 🔴 En de checker zelf was twee keer fout, in tegengestelde richtingen

Het waard om te bewaren, want beide versies zagen er overtuigend uit:

- **v1** accepteerde elke `mod:Iets(id` als waarschuwing. `AddAuraSoundOption(1292403, …)` matchte,
  dus precies het ID dat met de hand fout bleek kreeg een vinkje. **Te ruim.**
- **v2** eiste dat het ID het *eerste* argument was van een zelf opgesomde lijst constructors.
  Allebei die aannames zijn onwaar: DBM schrijft `NewCDCountTimer(20.5, 1284483, …)` mét de duur
  vooraan, en `NewCountAnnounce` staat in geen enkele lijst die ik zou verzinnen. **Te streng** —
  24 WEAK-meldingen waarvan er met de hand meteen drie onterecht bleken.
- **v3** classificeert per **regel**: staat `mod:New` op de regel die het ID draagt, dan handelt DBM
  erop; staat er `AddAuraSoundOption`/`RegisterAltSpellName`, of alleen een commentaar, dan kent hij
  het nummer slechts. Geen namenlijst, geen aanname over argumentvolgorde.

📌 De positieve controle draagt nu ook `1305959` en `1284483` — juist de twee waar v2 op stukliep.
Een controle die alleen makkelijke gevallen bevat, bevestigt de bug die je erin hebt zitten.

⚠️ **Nog steeds geen bewijs.** DBM waarschuwt alleen op wat het wíl bewaken, dus ABSENT is een sterk
signaal en geen verdict. Wat het wél bewijst: dat ID is nooit tegen de mod gelegd van het team dat
deze boss elke week doodt.

### ✅ Lint-check [19] staat erin, mét een baseline in plaats van een muur

31 ID's falen vandaag. Een check die daar allemaal op stukloopt wordt binnen een week uitgezet en
vangt daarna niets; een die zwijgt is even nutteloos. Dus: de gemeten achterstand staat in
`tools/raid_tip_baseline.json` en is **SOFT**; alles wat er **niet** in staat is nieuw en **HARD**.
Hij kan de bestaande rommel niet repareren, maar wel voorkomen dat het volgende ID zo geschreven
wordt als `1290779` — en het bestand hoort te krimpen.

⚠️ Verwijder je een regel uit de baseline zonder de tip te repareren, dan valt de build om. Dat is
de bedoeling.
✅ Repareer je een tip, dan meldt [19] zelf dat de baseline-regel weg mag.

📌 **Bewezen dat de HARD-tak vuurt**, niet aangenomen: één baseline-regel tijdelijk weggehaald
(`1290779`, het ID waar dit mee begon) → `1 new`, `HARD issues: 1`, exit-code 1, daarna hersteld.
Een check die niemand ooit heeft zien falen, is een check waarvan niemand weet dat hij werkt.

### ✅ The Venomous Abyss is herschreven uit DBM — 31 → 23, 15 → 10 regels

Robs eigen raid eerst. Zes gevlagde regels daar, nu **nul**. Het werkwoord komt telkens uit DBM's
eigen audio-cue in plaats van uit onze interpretatie: `justrun` = rennen, `helpsoak` = soaken,
`watchstep` = ontwijken, `bigmob` = switchen. Waar DBM geen mening heeft, zegt de regel niets.

| regel | wat er mis was |
|---|---|
| **Ula'tek** | 4 ID's → 12. `1292403` was de DoT van een ándere cast (wij: "dodge"), `1287265` stond in een `--TODO`, `1290779` bestond nergens. DBM waarschuwt op twaalf dingen; wij noemden er nul bij naam. |
| **Nek'zali** | `1294933` werd nooit gewaarschuwd. Vervangen door de echte set, inclusief `1305421` (group soak) die wij als losse Engelse naam in de tekst hadden staan. |
| **Entombed Sentinels** | `1284590` → `1284588` (Vitriolic Stasis, DBM's "MATHPUZZLE"). `1284485` is door DBM zélf uitgezet als *"Possibly unused"* — geschrapt, vervangen door `1288232` (group soak) en `1284251` (big adds). |
| **Lost Explorers** | `1295886` → `1292104` Mushroom Toss. 📌 En DBM **beslecht onze eigen open vraag**: onze tekst zei *"onze twee bronnen zijn het oneens — run out of stack up"*; DBM's cue is `justrun`. |
| **Vashnik** | `1294994` is een sub-ability die DBM bewust níét bewaakt; de ouder is `1282114`. Wij zeiden "dodge" tegen een debuff-fase. |
| **Sszorak (tank)** | `1285430` bestond nergens; de tank-combo is `1277025`. Onze zin klopte al — alleen het ID niet. |

⚠️ Eén bewuste WEAK toegevoegd: `1300685` (Soul Constrictor) bij Ula'tek. DBM waarschuwt er niet op,
maar documenteert in een commentaar *"can't soak Spectral Coils"* — precies wat onze regel zegt.
Staat als zodanig in de baseline; het is geen slordigheid maar een keuze.

🔴 **En het herschrijfscript loog over zijn eigen garantie.** `rewrite_abyss.py` zei in zijn
docstring dat het "weigert een gedeeltelijk resultaat te schrijven" en schreef het bestand vóór de
telling: 17 van 21 toegepast, daarna exit 1. Er ging niets stuk, maar de garantie was decoratief.
De vervolgscripts zoeken eerst alle vervangingen en raken het bestand pas daarna aan.

### ✅ De oudere raids: **0 ABSENT** — en het patroon dat alles verklaarde

Pas toen alle 28 regels naast elkaar lagen viel het op: **elke gevlagde tip eindigde op een staart**
`"• Key casts: … (EXBoss timeline — confirm in-game.)"`. Dat is een **tweede bron**, aangeniet aan
een handgeschreven bullet-lijst, en daar zat vrijwel elk fout ID in. De staart zei het zelf —
*"confirm in-game"* — en dat is nooit gebeurd.

Dus geen prose herschreven op gevoel, maar weggehaald wat we niet kunnen onderbouwen: elke bullet
met een ID waar DBM niet op waarschuwt, plus de geïmporteerde staart. **56 regels, 84 bullets weg**,
in zeven talen tegelijk — een lijst-operatie, geen vertaalklus, dus er is in geen enkele taal een
zin verzonnen.

| | vóór | na |
|---|---:|---:|
| spell-ID's die nergens in DBM staan | 21 | **0** |
| ID's die DBM kent maar nooit waarschuwt | 10 | **1** |
| tipregels met minstens één | 15 | **1** |

Die ene is Ula'teks Soul Constrictor, de bewuste keuze uit de vorige sectie.

⚠️ **DAT KOSTTE OOK GOED ADVIES, en dat is een keuze geweest.** Vanguards staart droeg
`1276368` (Execution Sentence, DBM's GROUP SOAKS) en `1246485` naast drie ID's die nergens bestaan;
de bullet schrappen gooit alle vijf weg. Chimaerus ging van 6 ID's naar 1, Crown van 7 naar 1,
Beloren van 9 naar 1. De prose-bullets overleefden en de teksten lezen nog steeds als advies, maar
ze zijn **dunner**. Verkeerd advies weghalen weegt zwaarder dan goed advies bewaren — en de helft
die goed was hoort terug als een geschreven bullet, niet als restant van een tijdlijn.

### ✅ En teruggevuld uit DBM — alle 28 tipregels staan nu op DBM

De vier dunste regels zijn opnieuw gevuld uit DBM's eigen waarschuwingslijsten: **Chimaerus 1 → 8
ID's, Vanguard 3 → 10, Crown 1 → 9, Beloren 1 → 8.** Execution Sentence (`1276368`) is terug als
geschreven bullet in plaats van als tijdlijn-restant.

📌 **Aangevuld, niet herschreven.** De overgebleven bullets waren met de hand geschreven en
beschrijven het gevecht in woorden — dat is de goede helft. Aanvullen laat die ongemoeid en houdt
de diff precies gelijk aan wat nieuw is, waardoor een fout hier geen tekst kan beschadigen die al
klopte.

**Eindstand van de dag: 105 spell-ID's over 28 tipregels, 0 ABSENT, 1 bewuste WEAK.**
Begonnen bij 31 twijfelgevallen over 15 regels.

⚠️ **Wat dit NIET is.** Dat elk ID nu door een DBM-waarschuwing gedekt wordt, zegt dat het bestaat
en dat DBM erop reageert — **niet** dat onze zin eromheen klopt. De werkwoorden komen uit DBM's
audio-cues (`justrun`, `helpsoak`, `watchstep`, `bigmob`, `colorchange`), wat sterk is maar geen
vervanging voor iemand die de boss echt doet. Rob komt naar eigen zeggen niet snel in een raid; de
eerste die dit in een pull leest, leest het ongetest.

## 🔴 3 sep — de audit uitgebreid naar dungeons, delves en rituals: 410 ID's, 160 tipregels

Rob: *"kunnen we de dungeons en Delves ook met DBM data checken en dicht timmeren?"* Ja — en de
raid-map bleek maar een derde van het geheel. `tools/tip_audit.py` (hernoemd van
`raid_tip_audit`) dekt nu `RaidTips`, `DungeonTips`, `DelveTips` en `RitualTips`.

| | ID's | twijfel | regels |
|---|---:|---:|---:|
| raids | 105 | 1 | 1 |
| **dungeons** | 240 | **23** | **19** |
| delves | 44 | 40 → zie hieronder | 11 |
| **rituals** | 21 | **9** | **4** |

### 🔴 Twee keer bijna een crisis verzonnen uit andermans TODO-lijst

**Eén: delves gebruiken geen nummers.** `DelveTips.lua` schrijft `{SPELL:@shadow_bolt}`. Mijn
numerieke patroon vond nul van de 154 placeholders, en de eerste uitvoer had **geen delve-regel** —
een heel contenttype ontbrak en zag er precies uit als een contenttype zonder problemen. Gevangen
doordat de telling zei dat er 154 te vinden waren. De tokens lossen op via
`Modules/DelveSpellIds.lua` en zijn dus wél te controleren.

**Twee: DBM is voor delves geen maatstaf.** Na het oplossen meldde de tool **40 van 44 delve-ID's
ABSENT** — dat leest als "onze delve-tips zijn vrijwel helemaal fout". Eén mod met de hand
opengeslagen zei het tegendeel: `DBM-Delves-Midnight/Encounters/Antenorian.lua` is een **stub** met
alleen `SetEncounterID` en `RegisterCombat`, en `--mod:SetCreatureID(0)--TODO` er nog in. Hydrangea
en Gladius Slaurna idem.

**GEMETEN dekking**, nu vast onderdeel van het rapport:

| DBM-pakket | mods mét waarschuwingen |
|---|---|
| DBM-Raids-Midnight | 17 / 17 |
| DBM-Party-Midnight | 31 / 36 |
| DBM-Lairs-Midnight | 2 / 2 |
| **DBM-Delves-Midnight** | **4 / 30** |

📌 Dus ABSENT op een delve-ID betekent **DBM heeft geen mening**, niet dat wij fout zitten. Zonder
die controle had ik een ramp gerapporteerd die in werkelijkheid iemand anders' TODO-lijst was.

### ✅ Robs tweede vraag gaf het antwoord: een onafhankelijke tegenmeting

*"er zijn toch ook speciale delve addons en sites?"* Geen enkele geïnstalleerd (geen Delve
Companion, DelveGuide of Everything Delves), maar **GTFO** wel — een spell-ID-database van
grondeffecten, 7815 ID's.

⚠️ *"Onze delve-ID's staan niet in GTFO"* bewijst op zichzelf niets: GTFO catalogiseert alleen waar
je uit moet lopen, en wij noemen ook interrupts, buffs en fasewissels. Dus **vergelijkend** gemeten,
met de raids als ijkpunt omdat die inmiddels volledig DBM-gedekt zijn:

| content | in GTFO | totaal | overlap |
|---|---:|---:|---:|
| raids | 13 | 105 | 12,4% |
| dungeons | 55 | 240 | 22,9% |
| **delves** | 7 | 44 | **15,9%** |
| rituals | 2 | 21 | 9,5% |

**Delves zitten midden in het normale bereik — hóger dan de raid-ID's.** Er is dus geen enkele
aanwijzing dat de delve-ID's kapot zijn, en zeven ervan zijn nu onafhankelijk bevestigd.

### ✅ Robs tweede tegenvraag repareerde de checker zélf

*"er zijn toch ook sites en addons op cf voor alles"* — ja, en het landde precies op de zwakste
plek. **MythicDungeonTools** staat geïnstalleerd en heeft per-dungeon spell-tabellen voor Midnight:
een **tweede lokale maatstaf**.

⚠️ De eis is *lokaal en machinaal leesbaar*, niet gezag in het algemeen. Een website kan een linter
niet elke run opnieuw controleren, en de gidsen waar dit project al op verbrand is waren juist
zelfverzekerd fout. Een addon op schijf kun je morgen opnieuw parsen.

🔴 **En het legde een echte fout in mijn eigen classifier bloot.** Commentaar strippen was twee keer
goed en één keer fout: het houdt een `--TODO` tegen, maar DBM legt in commentaar óók **beslissingen
over echte spells** vast — en die lazen als ABSENT:

| onze ID | wat DBM's commentaar zegt |
|---|---|
| `1296219` | *"isn't in journal but has encounter event… Possibly not needed"* |
| `1251813` | *"has a private aura but it doesn't need an alert"* |
| `1214352` | *"ENCOUNTER_WARNING intercept is used instead"* |

Alle drie echte spells, alle drie ook in MythicDungeonTools, en ik had Rob op pad gestuurd om drie
correcte regels te "repareren". Er is nu een derde verdict: **`noted`**.

**dungeons 23 → 19 · rituals 9 → 7 · delves 40 → 33**, puur door beter te kijken.

📌 **Eindstand van de dag: 407 ID's over 160 tipregels — raids 1 (bewust), dungeons 0, rituals 0,
delves 33 (geen maatstaf).** De 410 in de kop hierboven is de meting op het moment van uitbreiden,
niet de stand nu. ⚠️ De dungeon-nul komt maar voor een klein deel uit herschrijven: 13 van de 19
waren nooit fout, zie *"de laatste 14"* verderop.

### ✅ Rotmire herschreven — 6 van 8 ID's klopten met niets

Zijn regel eindigde op *"(Datamined — confirm in-game at launch.)"*: dezelfde vorm als de
EXBoss-staart bij de raids, vóór de launch gedumpt en daarna nooit gecontroleerd. DBM-Lairs dekt
2/2, dus hier bewijst ABSENT wél iets.

📌 En één correctie die de speler direct raakt: onze tekst noemde `1221637` **"de wipe"**. DBM's cue
is `carefly` — het is een **knockback**. Wie op de rand stond en dat las, verwachtte het verkeerde.

Nu uit DBM: knockback (1221637), adds (1221622), raid-damage (1221787), pool op jou (1222088) en
de tank-klap (1221781).

### ✅ Taz'Rah en Nalorakk herschreven — de ID's zaten er telkens náást

Rob: *"ja doe Taz'Rah en Nalorakk ook nog."* Vijf gevlagde ID's over drie regels, nu **nul**.

📌 **Het patroon is hier anders dan bij de raids, en interessanter: onze zínnen klopten.** Bij
Taz'Rah beschreven alle drie de bullets een mechaniek die DBM ook kent — alleen droeg elke bullet
het verkeerde nummer. "Sleurt iedereen naar zich toe" is echt, dat is `1300259` Black Hole (DBM-cue
`watchorb`) en niet `1222274`. "Ontwijk dit" is echt, dat is `1296963` Umbral Rupture (`watchstep`).
De tank-defensive is echt, dat is `1297017` Void Blast. Wie de tekst las kreeg goed advies; wie op
de spell-link klikte kreeg iets anders te zien dan de zin beschreef.

| onze regel | oud ID | wat DBM waarschuwt |
|---|---|---|
| Taz'Rah, "trekt je naar binnen" | `1222274` | `1300259` Black Hole — ORBS, `watchorb` |
| Taz'Rah, "ontwijk" | `1225011` WEAK | `1296963` Umbral Rupture — POOLS, `watchstep` |
| Taz'Rah, tank | `1222085` | `1297017` Void Blast — TANKBUSTER, `defensive` |
| Taz'Rah, "na elke teleport" | `1262901` | *niets* — zie hieronder |
| Nalorakk, "duwt iedereen weg" | `1255385` | *geen knockback op deze boss* |

⚠️ **Eén bullet heeft nu géén ID, met opzet.** De Ethereal Shades na de teleport staan nergens in
DBM — geen teleport, geen adds op deze boss. De zin staat er nog als prose, want hij kan waar zijn
en hij staat op eigen benen; een nummer dat niemand kan bevestigen maakt hem niet beter, alleen
klikbaar naar het verkeerde.

🔴 **En Nalorakks knockback is er waarschijnlijk een van de buurman.** DBM kent op Nalorakk geen
enkele pushback; de dichtstbijzijnde die het wél heeft is `1235656` op de **Sentinel of Winter**, een
andere encounter in dezelfde dungeon. Zo komt een mechaniek van de boss ernaast in de verkeerde tip
terecht — het waard om op te letten bij de resterende regels. Vervangen door `1242860` Echoing Maul
(SPREAD DEBUFFS), dat DBM wél bewaakt en dat wij nooit noemden. Ook `1222098` Nether Dash (LINES,
`lineyou`) is erbij gekomen bij Taz'Rah, om dezelfde reden.

⚠️ Het herschrijfscript adresseerde op **locale-blok**, niet op vertaalde tekst: `esES` en `ptBR`
hebben een byte-identieke TANK-regel, en een marker-tabel had ze stilzwijgend tot één sleutel
samengevouwen — één taal zou onaangeraakt zijn gebleven en niets had dat gemeld. 21 regels, 7 talen,
0 drift.

### 🔴 `tools/tip_audit.py` slikte elk argument dat je verzon

Bij het bijwerken van de baseline draaide ik `--write-baseline`. Het printte een compleet, schoon
rapport en **schreef niets** — die vlag bestond niet en de tool negeerde hem. `--help` gaf exact
hetzelfde rapport. Dat is dezelfde vorm als de onjuiste regel in `CLAUDE.md` van vanochtend: **een
instructie die fout is, is erger dan een die ontbreekt, want hij laat je ophouden met kijken.**
Gevangen doordat `git status` het bestand niet als gewijzigd toonde, niet doordat de uitvoer iets
verried. De tool weigert nu argumenten en zegt waar de baseline dan wél vandaan komt (met de hand,
uit check `[19]`).

📌 Zelfde ochtend, derde keer: `Glob` met een absoluut `path` gaf **nul** treffers op `tools/*.py` in
een map waar `_probe.py` aantoonbaar draait. Positieve controle ving het; zonder die controle had ik
geconcludeerd dat het bestand niet bestond.

### 🔴 De laatste 14 dungeon-ID's: **allemaal goed**, en de classifier was voor de dérde keer fout

Rob: *"ga door met die laatste 14."* Elke mod met de hand opengeslagen, en dat was maar goed ook,
want de uitkomst is het omgekeerde van wat de lijst beweerde: **dertien van de veertien waren
correct.** Ze staan alle dertien in

```lua
mod:AddAuraSoundOption(1246753, true, 1246753, 1, 2, "watchfeet", 8)  -- Lightsap
```

— **aan by default, mét een benoemde stem-cue**. In 12.x is een private aura onleesbaar, dus dit is
niet DBM die weigert te waarschuwen: het is de **enige manier waaróp DBM kan waarschuwen**. Ons
verdict luidde *"only mentioned, never warned on"* en zei daarmee het tegenovergestelde van de
waarheid over dertien regels.

📌 **De echte scheidslijn zit ín de aanroep, niet in de aanroep zelf.** Argument 1 is de aura,
argument 3 is de **cast waar hij bij hoort**:

| | |
|---|---|
| `AddAuraSoundOption(1246753, true, **1246753**, …, "watchfeet")` | het ding zelf |
| `AddAuraSoundOption(1292403, true, **1292188**, …, "dotyou")` | de DoT van een **ándere** cast |

Die tweede is Ula'teks `1292403` — het ID waar deze hele audit mee begon, waar onze tekst *"dodge"*
bij zei terwijl DBM's cue `dotyou` is. Dus: **parent == id is de ability; parent ≠ id betekent dat
we een bijwerking citeren en hem als de cast presenteren.** Dat is machinaal te controleren, en
"staat het in AddAuraSoundOption" was dat nooit. Nieuwe verdicts: `aura` (geen bevinding) en
`AURA-OF` (wél).

⚠️ **Wat het gereedschap nog steeds niet kan** — en dat staat nu ook onderaan het rapport: het kan
niet zien of ons **werkwoord** bij DBM's cue past. Daarvoor wordt de cue voortaan uitgeprint.

### ✅ Vier ID's die alleen mét de hand te vinden waren — en onze zinnen klopten al

| regel | oud | nieuw | waarom |
|---|---|---|---|
| Zaen STEPS + HEALER | `474545` | `1218347` | DBM: `NewSpecialWarningCount(1218347, …, "breaklos")` + CD-timer. Onze tekst zegt al *"break line of sight, hide behind the crates"* — dat ís de cue, letterlijk. `474545` is een aura zónder cue. |
| Zaen STEPS | `1214352` | `1214357` | DBM gebruikt overal `1214357` voor Fire Bomb (`bombyou`); onze `1214352` is de aura-variant, en DBM's regel dáárvoor staat uitgecommentarieerd. |
| Kystia STEPS + TANK | `1253813` | `1253811` | DBM: `RegisterAltSpellName(1253811, FRONTAL)` + `specWarnFelSpray(…, "frontal")`. `1253813` is de grond die het achterlaat. Beide regels praten over de **kegel**, en de tank-regel zegt *"keep the cone pointed away"* — iets wat je richt, dus de cast. |

🔴 **Die laatste kan het gereedschap nóóit vinden**: `1253813` parseert als een keurige
zelf-verwijzende aura en is dus per geen enkele machineregel een bevinding. Alleen *"cone"* naast de
cue *"watchfeet"* leggen brengt je er.

📌 **Nul vertaalwerk**, met opzet: alle vier zijn zuivere nummerwissels omdat de zinnen al klopten.
30 wissels over 28 regels in 7 talen, geen woord aangeraakt.
⚠️ En het script ving een aanname: `DGN_TIP_MR_ZAEN_HEALER` linkt `474545` **alleen in enUS en
itIT** — de andere vijf schrijven *"het schot"* als gewone tekst. Verwacht 7, gevonden 2, niets
geschreven tot ik het per sleutel had gemeten (9 / 7 / 14 = 30).

### ⚠️ Twee eigen fouten in dezelfde ronde, allebei van de stille soort

1. **De cue kwam leeg terug.** Twee regex-pogingen faalden identiek: een gulzige filler eet de
   argumenten tot vlak vóór het aanhalingsteken, de **optionele** cue-groep matcht dan leeg, de
   match slaagt en er wordt niet teruggekrabbeld. Het rapport printte `cue "no cue"` voor ID's die
   er één hebben — wat de lezer uitnodigt te concluderen dat DBM niets zei. Nu wordt de
   argumentenlijst gesplitst, mét een **derde positieve controle** die faalt als `1246753` niet als
   `watchfeet` en `1292403` niet als `dotyou`/parent `1292188` parseert.
2. **De linter kende het nieuwe verdict niet.** `bad = [... if v in ("ABSENT", "WEAK")]` — `AURA-OF`
   stond er niet bij, dus de énige bevinding waarvoor het verdict gebouwd was verdween uit de
   lint-uitvoer terwijl het rapport hem nog printte. **Een nieuw verdict waar de consument niets van
   weet, maakt de check stiller in plaats van strenger.**
   ✅ Bewezen dat de HARD-tak nu vuurt: Ula'teks regel tijdelijk uit de baseline → `1 new`,
   `HARD RAID_BOSS_ULATEK_STEPS 1300685 AURA-OF`, exit 1, daarna hersteld.

### Wat er wél te doen staat

**Dungeons, rituals en raids staan op nul echte bevindingen.** `tools/tip_baseline.json` is van 53
via 48 naar **34** gekrompen: 33 delve-regels (geen maatstaf — zie `_delve_caveat`) plus Ula'teks
`1300685`, de bewuste keuze, nu correct als `AURA-OF` met cue `debuffyou`.

⚠️ Er is dus **geen open lijst meer** tegen DBM. Wat overblijft is precies wat DBM niet kan
beantwoorden: de delves, waar 26 van de 30 mods stubs zijn. Daar is geen gereedschap voor — alleen
iemand die ze speelt.

## ✅ 3 sep — de pijl stuurde je door een muur; nu eerst naar de deur

Rob stond op 94 yard van het Coiled-Isle-portaal met de pijl er dwars doorheen: *"onze pijl stuurt
ons naar de plek op de kaart maar niet naar de ingang van het gebouw."* Een kaartcoördinaat is geen
route — binnen een stad zijn juist de laatste dertig meter het probleem, en dat is precies wat één
waypoint niet kan oplossen.

`Modules/TwoStepRoute.lua`: een pin mag nu een `entrance = { x, y }` dragen. De pijl gaat eerst
daarheen, met een label *"Ingang — X staat binnen"* en een chatregel die het echte coördinaat noemt,
en schakelt **vanzelf** door zodra je binnen 22 yard van de deur bent.

📌 **En de deur stond al in het bestand, weggeschreven als fout.** De opmerking boven de portal-pin
zegt dat de Codex mensen naar 55.00 / 63.40 stuurde en noemt dat *"bijna vier punten mis"*. Robs
eigen aflezing van de ingang vandaag: **54.99 / 63.30** — op een tiende na hetzelfde punt, twee
onafhankelijke metingen vijf weken uit elkaar. Dat coördinaat was nooit fout; het was de **deur**.
Op 19 aug hebben we het *vervangen* door de bestemming in plaats van het ernaast te zetten.
⚠️ Een coördinaat corrigeren is niet hetzelfde als begrijpen waar het naar wees.

⚠️ Nog open: de pin **`astalor`** (`UI.lua`) staat óók op 55.00 / 63.40 — de deur dus, niet bij
Astalor, die volgens diezelfde opmerking op 56.74 / 67.30 binnen staat. Niet aangeraakt; het is
dezelfde deur-versus-binnen-vraag en verdient dezelfde behandeling, maar of Astalor werkelijk binnen
staat is niet ópnieuw gemeten.

⚠️ Ontwerpkeuzes die het waard zijn te kennen: de ticker draait alleen zolang er een tweestapsroute
loopt (1×/s, stopt bij aankomst, na 5 minuten, of zodra een andere route de pijl claimt), en
`ns.SetSMCWaypointDirect` bestaat zodat stap twee niet opnieuw in stap één kan vallen — met de
originele pin zou hij `entrance` weer zien en je terug naar buiten sturen.

## ✅ 3 sep — de cache-busterregel staat in alle vier de cloud-routines

De ochtendronde van 3 sep vond een methodefout die zwaarder weegt dan wat hij die dag opleverde:
**Exa serveerde een week oude kopie van news.blizzard.com**, met een titel die er volstrekt normaal
uitzag. De meting staat in `CLAUDE.md`, bovenaan bij de wachterstabel.

De API-wachter schreef de les in zijn eigen logboek — een bestand dat geen enkele routine als
instructie leest. Morgen had niemand hem gehad. Hij staat nu in de **prompts** van alle vier.

⚠️ **Verificatie was hier het echte werk, niet het schrijven.** Vier prompts van 5-7K tekens gaan
als één string door een API-aanroep; HTTP 200 bewijst alleen dát de aanroep geaccepteerd is, niet
dat de tekst heel is aangekomen. Eén weggevallen regel in een wachter-prompt is onzichtbaar tot die
wachter stilletjes een stap overslaat. Daarom: prompts eerst naar schijf, blok met een script
ingevoegd op een anker dat er al stond, daarna teruggelezen en **byte-voor-byte vergeleken**. Alle
vier identiek (7532 / 5748 / 5624 / 6918 tekens), alle vier `enabled`, crons ongemoeid.

📌 Bijvangst: er bestaat een **vijfde** routine, *"Midnight Helper — API-wachter"*
(`trig_017Y76mMzXq6oopFJPFpV9dX`), de oude die op 2 sep vervangen is. GEMETEN: `enabled = false`,
laatst gevuurd 2 sep, status `ABANDONED`. Hij draait dus niet mee, en verklaart **niet** waarom er
vanochtend twee verschillende API-rapporten waren — dat vermoeden van mij was fout. Waar de tweede
vandaan kwam is nog onbekend; niet dringend, want origin had de betere.

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

1. ✅ **`cmd:req` GEBOUWD op de avond van 2 sep — de test is overgeslagen, met reden.**
   Rob: *"het is niet meer voorgekomen dat ik de andere niet meer zie, dus dat heeft niet veel zin
   meer om te testen."* Klopt, maar niet omdat het over is: **een symptoom dat wegblijft zegt
   alleen dat de timing niet ongelukkig viel.** De code bewijst het gat wél, en dat is sterker dan
   de test ooit had kunnen zijn — uitzenden gebeurt alleen op `GROUP_ROSTER_UPDATE` en
   `PLAYER_ENTERING_WORLD`, en er bestond **geen enkel bericht dat om data vroeg**. Met
   `STALE = 600` verdwijnt bovendien elke ontvangen rij na tien minuten zonder dat iets hem ophaalt.
   ⚠️ Cisca hoefde dus nooit iets anders te typen dan `/reload`; `cmd:req` is een protocolbericht,
   geen commando.

   🔴 **En bij het bouwen bleek de helft van de reparatie al nodig zonder cmd:req:** de
   ontvangst zette de rij in `received` en **hertekende het bord niet**. Een antwoord dat binnenkwam
   terwijl het bord openstond was pas zichtbaar bij de volgende keer openen — hetzelfde symptoom als
   de bug zelf. `ns.RefreshConsumableBoard` bestond al, deed precies het juiste, en werd daar nooit
   aangeroepen. Derde keer deze week dat het antwoord al in de code lag.

   📌 Wat het voor de ander betekent (Robs vraag): **niets zichtbaars.** Geen venster, geen geluid,
   geen chatregel. Hun client krijgt een verborgen berichtje en stuurt dezelfde tellingen terug die
   hij nu al ongevraagd rondstuurt. Geen nieuw gegeven, dus geen nieuwe privacyvraag; spelers zonder
   MH negeren het prefix volledig.
   ⚠️ Bewust **niet** achter `IsAutoPopupEnabled("consumables")`, anders dan `cmd:show`: die
   instelling betekent "open geen venster bij mij", en dit opent niets. Hem hier toepassen zou
   iemand die alleen de popup uitzette stil uit andermans bord laten verdwijnen.
   ⚠️ Antwoorden worden **uitgesteld** in plaats van weggegooid als de 3s-throttle in de weg zit —
   anders verliest een verzoek stilzwijgend zijn antwoord, precies de vorm van de bug die dit
   repareert. Verzoekkant throttlet zelf op 5s.
   **Nog niet in het spel bevestigd** — het vraagt twee mensen in een groep.
   Volledige analyse: `docs/NEXT_SESSION_ARCHIVE.md` regel 456 e.v.
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

## ✅ Valeera-curio's Season 2 — GEBOUWD op de avond van 2 sep

⚠️ **Alles hieronder is het ONDERZOEK van die middag en blijft staan omdat de redenering klopt.
Twee conclusies erin zijn 's avonds door meting in Robs client omvergegooid; die staan hier.**

🔴 **"Corrosive Bilespear = 249223" IS FOUT.** Het is geen item. Het is een trait-entry in
Valeera's boom: **spellID 1248877, entryID 137797, node 110786**. Hetzelfde geldt voor
Soul-Cracking Dreamcatcher (**1248896**, entry 137817, node 110785). Punt 1 hieronder vroeg om
"item-ID's meten"; het antwoord op die meting was dat het geen items zijn. Had `DELVE_CURIOS_BY_
SEASON[2]` die ID's gekregen, dan had het scherm `#1248877` getoond — die tabel tekent via
`C_Item.GetItemInfo`.

✅ **De lijst van zes klopt exact.** Vierde en hardste bevestiging: de drie keuzenodes uit Robs
eigen client geven precies de zes namen uit de tabel hieronder, in twee bakjes van drie —
Combat = node 110786, Utility = node 110785. Het onderzoek van die middag had het goed.

✅ **Punt 2 is beslist:** vullen mét herkomstregel. Uitgevoerd als een **ster** op de twee
consensus-picks, die bij élke render tegen de boom van de speler wordt gecontroleerd, plus een
voettekst die zegt dat wij het niet getest hebben. De gif-slot kreeg een **aparte** markering
(`>>`) omdat we voor gif níét weten wat de guides zeggen — zie de sectie bovenaan.

📌 De alinea hieronder over "de vijfde stem die één build napraat" is precies waarom het zo
gebouwd is: de ster zegt wát de bron is, en de controle tegen de boom is wat geen van de vier
andere stemmen doet.

### Het onderzoek van 2 sep (middag) — ongewijzigd bewaard

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

### ~~Wat nog moet gebeuren~~ — beide punten afgehandeld op de avond van 2 sep

1. ✅ **Gemeten, en de meting weersprak de vraag.** Er zijn geen item-ID's: het zijn trait-entries
   met spellIDs (zie de correctie bovenaan deze sectie). **249223 stond hier als "hard, twee
   bronnen" en is onjuist** — een goed voorbeeld van twee bronnen die elkaar bevestigen en samen
   naast de client zitten.
   ⚠️ De probe stopt inderdaad als haar venster dicht is; dat gebeurde Rob die avond ook
   (*"probe stopped: no trait tree"*) en de foutmelding zegt niet dát je het venster moet openen.
   Nog te verbeteren.
2. ✅ **Beslist: vullen mét herkomst.** Een ster op de twee consensus-picks, gecontroleerd tegen de
   boom van de speler, plus een voettekst die zegt dat wij niets getest hebben. Voor gif een
   aparte markering, omdat daar geen guide-consensus van bekend is.

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
