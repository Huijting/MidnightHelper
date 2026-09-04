# Testlijst — wat wacht er op Rob

**Lopende lijst.** Rob, 27 aug 2026: *"we gaan later alles proberen, onthoud dit en dan maken
we straks een lijstje wat ik in een keer kan testen"*. Alles wat gebouwd maar niet in het spel
gezien is, komt hier te staan tot hij het afvinkt.

⚠️ **Bouwen is niet testen.** Een module die laadt zonder foutmelding heeft alleen bewezen dat
hij laadt. Zet niets hieronder op ✅ omdat het "zou moeten werken".

## 🆕 4 sep — Dundun, de Shrine of Abundance (ONGETEST, op LIVE)

De enige zin die niemand anders geeft: deze delve is Bountiful, dus Dundun zit erin, en zijn
aanbod kan een **tweede** Restored Coffer Key kosten.

- [ ] 🔴 **`/mh dundun` buiten een delve.** Verwacht een tabel met `in a delve: could not read` of
      `false`, en een **verdict `quiet`** met de reden erbij. Dit is de belangrijkste test: zwijgen
      is hier de normale uitkomst, en het moet te zíén zijn dát hij zweeg en waarom.
- [ ] **`/mh dundun` in een gewone (niet-Bountiful) delve.** Verwacht `Bountiful: false` en
      `verdict: quiet — this delve is not Bountiful`.
- [x] ✅ **`/mh dundun` in een BOUNTIFUL delve — GEMETEN 4 sep, The Darkway tier 11.**
      `Bountiful: true` van binnenuit, op naam/zone/zone+map. De zorg dat de kaart-POI binnen
      onleesbaar zou zijn was ongegrond; het waren twee bugs in `DundunShrine.lua` zelf.
- [ ] **Loop een Bountiful delve in en wacht 2 seconden.** Er hoort vanzelf een blok van drie of
      vier regels in de chat te komen: dat hij er is, dat hij zich als een boom vermomt, de
      sleutelwaarschuwing met **jouw** aantal keys, en de macro-tip.
      📌 Heb je minder dan 2 keys, dan hoort die regel **oranje** te zijn en anders te klinken.
- [ ] **Klopt het aantal keys** dat hij noemt met wat je Currency-tab zegt?
- [ ] Werkt de macro (`/cleartarget` + `/target Dundun`) als hij er is?

⚠️ **Wat ik NIET weet en wat de tekst daarom niet belooft:** of de eerste vondst van de week een
tweede Coffer geeft (jouw eigen meting) of een keuze-trunk (de wiki). De regel zegt daarom "kan
kosten", nooit "kost". Zie je in het spel welke van de twee het is, dan kan die zin scherper.
⚠️ Ook niet gemeten: dat rank 3 de drempel is. Dat komt van webbronnen. Zit je onder rank 3 en zegt
MH tóch iets, dan klopt de drempel niet.

## ✅ 4 sep — RONDE 2 GEDAAN: vier echte bugs, en drie ervan zaten in mijn eigen diagnose

Rob testte de routes vanuit The Den (de grot in Harandar) en vanuit SMC. Alles hieronder is
GEMETEN op zijn scherm, niet afgeleid.

**Wat er kapot was, in volgorde van vinden:**

1. 🔧 **Sub-kaarten vielen door naar regiogroep 0** — en 0 is precies de waarde die "ander
   continent" betekent. In de grot verdween de route; buiten kwam hij terug. `GetRegionGroupID` en
   `GetBaseZoneName` klimmen nu naar de ouderkaart (max 6 stappen, guarded). Meer ID's toevoegen
   was de verkeerde reflex: Blizzard maakt sub-kaarten sneller dan wij ze meten.
2. 🔧 **Het DOEL werd niet door de hub-slice gehaald, de speler wel.** Canvas 2576 draagt
   Silvermoon, Voidstorm én Harandar naast elkaar; kaal geeft `GetRegionGroupID(2576)` altijd 1
   (Silvermoon-default). Een delve in de Harandar-sliver las dus als "andere regio" terwijl Rob
   ernaast stond. `ns.GetTargetRegionGroupID` slicet nu beide kanten. De doel-x zat al ín beide
   aanroepen — hij werd nooit doorgegeven.
3. 🔧 **"Ben ik er al?" was drie keer verschillend beantwoord.** `ReportTravelHintForWaypoint`
   vergeleek kale kaart-ID's, dus 2576-met-doel-2413 las als twee plekken, en MH bood een portaal
   aan naar de zone waar Rob stond. Eén helper nu: `ns.SameTravelRegion`. ⚠️ Eerlijk: de twee
   reispopup-checks hebben de vergelijking nog inline (ze hergebruiken hub en x verderop) — ze
   rekenen wél met dezelfde functies eronder.
4. 🔧 **De reisplanner nam de EERSTE passende portaalrij, niet de dichtstbijzijnde.** `/mh portals`
   toont zes rijen "Portal to Silvermoon" en vijf "Portal to Harandar"; op 2576 delen er meerdere
   een mapID. Rob stond naast een portaal en kreeg "Use: Portal to Silvermoon (882yd)" met een pijl
   naar eentje een kilometer verderop. Nu wint de kleinste afstand in kaart-eenheden.
5. 🔴 **De portaal-poort vroeg het CHARACTER; de Prey-unlock is WARBAND-WIDE.** Rob: *"die is
   account wijd"*. Op een alt die de Season 2 Prey-questlijn niet zelf deed verborg MH het Coiled
   Isle-portaal en bood een tragere vlucht aan. `PortalUsable` vraagt nu eerst
   `IsQuestFlaggedCompletedOnAccount`. 📌 Drie plekken in deze addon wisten dit al —
   `WorldBoss.lua:240` heeft dezelfde helper sinds de Omnium-Folio-altbug in juni, en
   `CampaignLeadIn.lua:156` bewaart Blizzards eigen "ACCOUNT COMPLETION"-zin sinds 31 aug.

**Wat er nu klopt (GEMETEN in SMC op 54.95, 62.81):** het Coiled Isle-portaal op afstand 0.048,
de andere twee op 0.181 en 0.190 — de dichtstbijzijnde wint, en de zone-kolom leest het `zone`-veld.

⚠️ **De les die drie keer terugkwam: een diagnose ontsnapt niet aan de bug die hij diagnosticeert.**
De regiogroep-regel in `/mh arrow` riep de KALE functie aan en beschuldigde daarmee de routing van
een fout die van hemzelf was. De zonekolom in `/mh portals` leidde de zone af uit de x en overreed
daarmee het expliciete `zone`-veld — voor een coördinaat die binnen een gebouw ligt en dus niet in
de sliver van zijn eigen voordeur hoeft te vallen. Rob wees dat laatste aan met één vraag:
*"hadden wij niet juist de coordinaten op de ingang gezet ipv precies op de portal?"*

**Nog te testen in deze hoek:**
- [ ] Vanuit The Den naar The Grudge Pit: er hoort **geen** portaal-omleiding meer te komen.
- [ ] Vanuit The Den naar een delve in Eversong: daar mag wél een reisadvies komen.
- [ ] Op een alt die de Prey-lijn niet deed: `/mh portals` hoort `quest 96004 completed (warband)`
      te tonen in plaats van het portaal te verbergen.
- [ ] ⚠️ Nog onverklaard: de suggestie *"head for Tranquillien"* vanuit de grot. Komt die terug,
      dan is dat een aparte fout in de hub-keuze.

## 🆕 3 sep — de routes vanuit Harandar (ONGETEST)

Je stond in Harandar, klikte Twilight Crypts, en kreeg vier regels die elkaar tegenspraken.

- [ ] **Zelfde klik, opnieuw.** Ga in Harandar staan en route naar **Twilight Crypts**. Verwacht:
      **géén** *"Head for Portal to Harandar first"* meer, en **géén** *"…is not on this continent"*
      over een flight master waar je naast staat.
- [ ] 🆕 **De onmogelijke vlucht hoort nu wég te zijn.** *"Fly from The Den to Torntusk Overlook"*
      mag niet meer verschijnen: Zygors taxi-graaf zegt dat Harandar een gesloten eiland is
      (component 35) en Torntusk Overlook op Eastern Kingdoms zit (component 1).
      ⚠️ **Vanuit Silvermoon hóórt er wél een vlucht te komen** — *Sanctum of Light* zit in dezelfde
      component als Torntusk Overlook. Krijg je daar géén vliegadvies, dan is de poort te streng en
      wil ik het horen.
      📌 Onze dekking is 129 van 649 punten, dus voor veel zones weten we het niet en zwijgt de
      poort bewust. Onbekend blokkeert niets.
- [ ] 🆕 **En de tegenproef op mijn eigen correctie:** vanuit Silvermoon hoort *"The Den is not on
      this continent"* er wél te mogen staan als de route je daar nog heen stuurt — die zin was
      dáár waar. Ik had hem eerst onvoorwaardelijk gesmoord; nu zwijgt hij alleen als de tussenstap
      op je eigen kaart ligt.
- [ ] 🔴 **De meting die het laatste stuk hard maakt:** typ **`/mh arrow`** terwijl je in Harandar
      staat. Die print welke map de client teruggeeft en welk continent hij eraan hangt. Mijn
      diagnose zegt dat je soms als map **2576** en soms als **2413** wordt gezien binnen één
      seconde — dat is nu afgeleid uit jouw chat, niet gemeten.
- [ ] **The Den.** Onze coördinaat stond 17 kaarteenheden ernaast (een aflezing van de verkeerde
      verdieping). Route er eens heen: de pijl hoort nu naar de grot te wijzen, niet ernaast.
- [ ] 📌 **Voor Cisca of een Alliance-alt, niet voor jou:** *The Royal Exchange* stond bij ons op
      "beide facties" en is **Horde-only**, *Silverglade Refuge* andersom. Een Alliance-speler werd
      dus naar een flight master gestuurd die hij niet mag gebruiken. Nu gecorrigeerd — maar
      niemand hier kan dat op een Alliance-character controleren.

## 🔴 4 sep — RONDE 1 GEDAAN, en hij legde een veel groter gat bloot

Rob liep de level-68-lijst af. Wat werkt, werkt. Wat niet werkt is groter dan de lijst.

- [x] ✅ **Stap 1-3 werken.** De kop zegt *"This week's routine happens in Silvermoon — it opens
      up at level 80"*, de teller staat op *3 of 3 · 8 more open up as you level*, en de lijst is
      in tweeën met "Later, as you level:" eronder. Geen *"Everything is done"*.
- [x] ✅ **Stap 5 werkt** — Silvermoon-tabblad met de rode regel bovenaan.
- [x] 🔧 **GEREPAREERD tijdens de ronde:** "Get ready for Season 2" telde 1 → ✓ → ✓ → **4**.
      Dezelfde raw-index-fout als de routinelijst, in het blok ernaast, en hij overleefde de fix
      van 3 sep omdat toen maar één van de twee is bekeken. **Beide sites** nummeren nu alleen wat
      nog open staat. ⚠️ De tweede site (`now`-lijst) telde afgevinkte regels óók mee, dus het
      eerste openstaande item zou nummer 4 hebben gekregen zodra er eentje open stond.
- [~] ⛔ **Punt 6 (Halduron Brightwing) INGETROKKEN — de test was onmogelijk.** Rob: *"kan ik
      überhaupt wel daar naar toe al om te gaan kijken"*. Nee: Halduron staat bij de vault in
      Silvermoon en Silvermoon opent op 80. Ik vroeg om een meting op een plek waar hij niet mag
      komen. Zijn `minLevel` blijft dus onbekend tot iemand daar op een lage character komt.

### 🔴 Het gat dat ronde 1 blootlegde — GEMETEN, en het raakt een geshipte belofte

Rob: *"Ook dingen als rares en delves geven allemaal een route?!?"*

| | aantal |
|---|---|
| modules die een route kunnen zetten | **29** |
| modules die de level-gate kennen | **2** (`ResetRoutine`, `UI`) |

Wat op 3 sep gebouwd is dekt **This Week** en het **Silvermoon-tabblad**. Rares, delves, treasures,
achievements, events en professies zetten allemaal ongefilterd een route.

⚠️ **En `CHANGELOG_260_3` belooft al dat we dit doen** — *"never points you at endgame content you
cannot do yet"*. Die zin staat in een uitgebrachte versie en is aantoonbaar onwaar. Dat moet hoe dan
ook opgelost worden: repareren of intrekken.

✅ **Goedkoper dan het lijkt: er is één deur.** `ns.AddSmartTomTomWay` wordt overal gebruikt
(Rares 9×, Achievements 16×, Delves 8×, RitualSites 4×) en er zijn vrijwel geen directe
`SetUserWaypoint`-omwegen (alleen `Delves.lua` 4×). Eén functie dekt dus bijna alles.

**Voorgelegd aan Rob, nog niet gekozen:** (A) waarschuwen bij de klik maar de route wel zetten,
(B) route weigeren met de reden op de knop zoals de Silvermoon-pins, (C) niets nu en de
changelog-belofte intrekken. Aanbeveling was A — bij een rare is de coördinaat nog steeds nuttig,
maar een route naar een zone waar je niet komt is verkeerd advies.

## 🆕 3 sep — This Week op je level-68 Paladin (ONGETEST)

🔴 **Dit kun jij testen en ik niet**, want op max level vuurt de nieuwe filter nooit. Log in op de
**level 68** en open This Week.

- [ ] **"Next up" mag geen endgame meer aanbevelen.** 🔴 **Bijgesteld na Robs vraag van 15:xx** —
      eerst stond hier dat de **profession-weekly** de nieuwe kop zou worden. Dat was fout: die
      quest is skill-gated, maar de **trainer staat in Silvermoon**, net als élke andere stop in
      deze routine. Op een 69 hoort er nu **helemaal geen kop** te staan, maar de regel *"De
      weekroutine speelt zich af in Silvermoon — die gaat open op level 80."*
      ⚠️ Staat er *"Everything on this week's list is done"*? Dán is het mis — dat is precies de
      leugen die deze regel moet voorkomen.
- [ ] **De teller.** Stond op *"3 of 8"*. Hoort nu veel lager te zijn — op een 69 blijft er
      vrijwel niets over dat je kunt doen — met daaronder *"Er komen er nog N bij naarmate je
      levelt."*
- [x] ✅ **Kan je 69 in Silvermoon komen? — BEANTWOORD, online.** Blizzards eigen aankondiging plus
      twee gidsen: **Eversong Woods gaat open op level 80**, Midnight loopt 80→90 met Silvermoon als
      hub. Derde bron naast onze eigen tabtitel *"Leveling (80-90)"*. De grens van 80 staat.
      ⚠️ Wat nog steeds niet gemeten is: of het spel je fysiek tegenhoudt bij het portaal. Voor onze
      filter maakt dat niet uit — wij bevelen het toch niet aan — maar het is geen bewezen feit.
      📌 De regel *"Cuzoth — Item Upgrades (other continent — travel back)"* die je zag is **geen
      bug**: dat is een pin uit het Silvermoon-tabblad waar je zelf op klikte. Een stadsgids
      raadplegen is iets anders dan advies krijgen.
- [ ] **De lijst is in tweeën.** Bovenaan genummerd 1, 2, 3… **zonder gaten** (hij sprong eerst van
      7 naar 10). Daaronder een grijze kop *"Later, als je verder levelt:"* met de rest, met
      streepjes in plaats van nummers. Alles blijft klikbaar.
- [ ] **De "Start route"-knop.** Die stuurde je door de endgame Bazaar-hub. Nu hoort hij alleen
      langs stops te gaan die je op level 68 echt kunt doen — en zegt hij *"Nothing open to route
      to"* als er niets overblijft, wat een geldige uitkomst is.
- [ ] 🔴 **De meting die alleen jij kunt doen:** loop naar **Halduron Brightwing** bij de vault en
      kijk of hij je op level 68 **iets aanbiedt**. Wij weten alleen dat een level 80 zijn
      level-variant kreeg (`95468`); 68 is nooit getest. Biedt hij iets aan → hij hoort geen
      level-eis te krijgen. Biedt hij niets aan → dan weten we eindelijk zijn echte `minLevel`.
- [ ] **Niets veranderd op level 90?** Log daarna op een max-level character in: kop, teller, lijst
      en route horen er **exact hetzelfde** uit te zien als vanmorgen. Dit mag alleen onder max
      level iets doen.

- [ ] 🔴 **De Hearthstone-knop mag niet meer verschijnen als je HS ergens anders heen gaat.** Rob
      werd naar Silvermoon gestuurd terwijl zijn HS op **Pinewood Post** stond, en kreeg hem tóch
      aangeboden. Nu wordt gecontroleerd waar hij landt.
      **Wat je nu hoort te zien:** géén Hearthstone-knop in de reis-popup zolang je HS niet op het
      doel staat. Staat er ook geen portaal in de buurt, dan verschijnt de popup **helemaal niet**
      — dat is een geldige uitkomst, geen bug.
      ⚠️ **De tegenproef:** zet je HS op een herberg in Silvermoon en laat je opnieuw daarheen
      routeren. Dan hoort hij er wél te staan. Doet hij dat niet, dan is de naamvergelijking te
      streng en wil ik het horen — `GetBindLocation` geeft een herbergnaam, geen zonenaam.
      📌 `/mh portals` zegt nu onderaan waar jouw Hearthstone heen gaat en waarom hij wel of niet
      wordt aangeboden.

- [ ] 🆕 **De routeknop hoort weg te zijn.** Onder de lijst stond nog *"Set TomTom route along the
      open stops (vault, hub, station)"* — die drie liggen allemaal in Silvermoon. De stops waren al
      gefilterd, de knop niet, dus zijn eigen label noemde precies wat je niet kunt bereiken. Nu
      verschijnt hij alleen als er echt iets te routeren valt.
- [ ] 🆕 **Silvermoon-tabblad: de kaart blijft, de pijl niet.** Klik weer op *Cuzoth — Item
      Upgrades*. Verwacht **geen pijl en geen "travel back"-regel** meer.
      🔴 **En nu bovenaan het tabblad zelf**, in rood, vóór je iets aanklikt: *"Silvermoon gaat open
      op level 80. Alles hieronder is een kaart voor later — de pins werken nog, maar erop klikken
      zet nog geen route."* De chatregel blijft er ook, maar die is niet meer waar het antwoord
      hoort te staan.
      ⚠️ De pins zelf horen gewoon zichtbaar en klikbaar te blijven — opzoeken wáár Cuzoth staat is
      naslag, en dat halen we niet weg. Alleen de route stopt.
      📌 *"Nearest flight point"* is bewust **niet** gegate: die leest waar je staat en werkt overal.

📌 Zie je iets raars: `/mh resetdebug`. Die print nu per stap `hero=yes / NO (out of reach)`, plus je
level, de cap en de tally — dat is precies de toestand die ik hier niet kan bereiken.

## 🆕 3 sep — de nieuwe spell-ID's uit DBM moeten in het spel een náám worden (ONGETEST)

Vandaag zijn er tips herschreven met ID's die uit DBM komen in plaats van uit datamining: alle 28
raid-regels, Rotmire, en Taz'Rah + Nalorakk. Statisch is alles gecontroleerd, maar `{SPELL:id}`
wordt pas in de client een naam. **Een ID dat 12.1 niet kent, rendert als een kaal nummer of als
niets** — en dat is precies wat geen enkele controle hier kan zien.

Eén blik per boss is genoeg; je hoeft er niet heen te reizen.

- [x] ✅ **Voidscar Arena → Taz'Rah.** Vier nieuwe ID's: Black Hole, Umbral Rupture, Nether Dash en
      (bij Tank) Void Blast. Alle vier horen een spelnaam te tonen.
      ⚠️ Bullet 3 noemt de **Ethereal Shades** bewust zónder spell-link — dat is geen fout.
- [x] ✅ **Den of Nalorakk.** Nieuw: **Echoing Maul** in bullet 2.
- [x] ✅ **Murder Row → Zaen Bladesorrow.** Bullet 1 en 4 wijzen nu naar andere spells: **Murder in a
      Row** en **Fire Bomb**. De tekst is niet veranderd, alleen waar de link heen gaat.
- [x] ✅ **Murder Row → Kystia Manaheart.** Bullet 3 en de Tank-regel noemen nu **Fel Spray** (de
      kegel zelf) in plaats van de brandende grond die hij achterlaat.
- [x] ✅ **Sporefall → Rotmire** (ritual). Vijf ID's, allemaal nieuw.
      📌 Bullet 1 zei tot vandaag dat `1221637` *"de wipe"* was; het is een **knockback**. Als je
      hem ooit doet: klopt dat nu met wat er gebeurt?
- [x] ✅ **Een raid-boss naar keuze** — alle 28 regels zijn aangeraakt.
- [ ] 🆕 **Zeven raid-bosses hebben er 's avonds rol-regels bij gekregen** (Averzian, Vorasius,
      Salhadaar, Nek'zali, Vashnik, Sszorak, Ula'tek). Codex → Raids. **Ula'tek is de interessantste:
      die had alléén een stappenregel en heeft nu tank, healer én dps.**
      ✅ **GETEST 4 sep — The Venomous Abyss volledig, alle links tonen namen, geen kale nummers.**
      Ula'tek heeft nu tank, healer én dps, met *Grasping Fangs* in de healer-regel.
      🔴 **DE OPDRACHT DIE HIER STOND WAS FOUT EN KOSTTE ROB EEN ZOEKTOCHT.** Er stonden vier namen
      in om op te letten — *Shadowclaw Slam* (Vorasius), *Entropic Unraveling* (Salhadaar),
      *Restless Amani* (Nek'zali), *Grasping Fangs* (Ula'tek) — en **alleen de laatste bestaat**.
      Onze data heeft daar alleen ID's: `NEKZALI_DPS` gebruikt `1297630`, dat in de client
      **Vessel of Awakening** heet; `VORASIUS_TANK` gebruikt `1241836`, `SALHADAAR_TANK` `1246175`.
      De drie andere namen zijn nergens gemeten.
      📌 Dat is de nooit-liegen-regel, toegepast op een TESTINSTRUCTIE in plaats van op de addon.
      **Noem geen spreuknaam die je niet gemeten hebt.** Wij bewaren ID's; de naam komt uit de
      client van de speler. Beschrijf dus de regel en laat de naam aan het spel — of meet hem eerst.
      ⚠️ **En zeg in welke raid iets staat.** Averzian, Vorasius en Salhadaar zitten in **March on
      Quel'Danas**, niet in The Venomous Abyss. Rob klapte de Abyss open; die drie stonden een raid
      hoger. Dat leest als "ontbreekt" terwijl het "verkeerd doorverwezen" is.
- [ ] **Nog te doen: March on Quel'Danas** — Averzian, Vorasius en Salhadaar, dezelfde vraag
      (toont elke link een naam of een kaal nummer?).
      ⚠️ *Blackening Wounds*, *Dig In* en *Venomous Heart* staan er **bewust zonder link** — die kent
      DBM niet, en een verzonnen nummer is erger dan geen nummer.
      🔴 **En lees ze als een gids, niet als ervaring.** Deze regels komen uit Zygor; niemand hier
      heeft deze gevechten gedaan. Zie je er ooit een die niet klopt met wat er in de pull gebeurt,
      dan is dat precies wat we willen horen.

🔴 **Wat dit NIET test.** Dat een ID een naam krijgt bewijst dat het bestaat, niet dat onze zin
eromheen klopt. De werkwoorden komen uit DBM's audio-cues; dat is sterk, maar niemand van ons heeft
deze gevechten gedaan.

## 🆕 1 sep — Spec 31 B3 en B4 (ONGETEST)

- [ ] **B4 — de regel onderaan het changelog-venster.** Open het met `/mh changelog` (of wacht
      op de volgende versiewissel). Boven de twee vinkjes hoort te staan: *"Something in this
      list wrong, or missing for your class? One person writes this addon…"*, in grijs.
      ⚠️ Loopt hij over de vinkjes heen of valt hij buiten het venster? Dat is dezelfde
      layoutfout als bij Professions → Overview: alles groeit naar beneden en niets begrenst het.
- [ ] **B3 — de Discord-kaart mag pas verschijnen als MH iets voor je gedaan heeft.**
      Op Robs eigen account staat er allang een milestone, dus hij hoort er gewoon te zijn.
      🔴 **De echte test kan Rob niet doen**: een vers account zonder milestones. Wat hij wél
      kan zien is dat de kaart NIET verdwenen is — verdwijnt hij, dan leest de check zijn
      milestones niet en is de voorwaarde te streng.
      📌 Wij kozen eerst "door minstens één update heen"; dat bleek onmeetbaar met wat we
      opslaan (`lastSeenVersion` wordt al op dag één gezet). Zie het commentaar in
      `DiscordNudge.lua` voor waarom een installatiedatum een leeftijdsgok zou zijn.

## ⛔ 31 aug — de Vaults-keten (INGETROKKEN 3 sep, niet testbaar)

🔴 **INGETROKKEN 3 sep — Rob kan dit niet testen, en dat was op 31 aug al gemeten.** Zijn eigen
vraag: *"dit kon toch niet als je op 1 character het al gedaan hebt??"* Klopt, en het is erger dan
per character: `/mh campaign` op **Warlockie, level 82** gaf `done=true` voor alle vier de
ketenquests, en een level-82 character kán geen level-90 quest hebben afgerond. **De keten is
account-wide.** Er bestaat dus geen character waarop dit blok nog verschijnt — een alt helpt niet.

Die meting stond al in `CampaignLeadIn.lua` (bij `gateKey`), compleet met de opmerking dat de regel
*"permanently unverifiable by the person who signs it off"* is. En tóch stond hij hier nog als
afvinkbare testregel. ⚠️ Dat is precies de val waar dit project een regel over heeft: een
aantekening is een claim mét een datum, en deze was drie dagen onwaar.

- [x] ~~De grijze eis-regel, de twee beloningsregels, en of het blok verdwijnt zodra je begint.~~
      **Niet te bereiken.** Wat Rob wél kan: `/mh campaign` print de zin uit én zegt erbij wie hem
      zou zien. Zo is de tekst te lezen zonder de toestand te kunnen halen — dat is waarvoor die
      diagnose gebouwd is.
- [x] ~~Telt de keten vier quests, met `98515 A Toxic Tour` ertussen?~~ **BESLECHT 2 sep**, niet in
      het spel maar in Zygor 9.6's eigen dailies-checklijst: die noemt acht ID's en 98515 zit er
      niet bij. Het is een **verhaalstap**, geen daily. De Codex sprak zichzelf tegen ("drie
      quests") en is in 7 talen gerepareerd.
      ✅ **HERBEVESTIGD 3 sep** op een nieuwere Zygor-build, mét een correctie: de **volgorde** was
      fout. 98515 wordt als **tweede** aangenomen (samen met 97640) en als **laatste** ingeleverd,
      ná 98428. Keten staat nu als `98388 → 97640 → 98428 → 98515`.
- [ ] 🆕 **Dit kun je onderweg zien:** loop je de Vaults-keten ooit, kijk dan of dat klopt — vier
      objectives van A Toxic Tour lopen op de achtergrond mee terwijl je de andere quests doet, en
      je levert hem als laatste in bij Warleader Abdumati.

## ✅ AF 31 aug — beide Engelse vragen beslecht in de gamedata, jij hoeft niets te testen

Ik zei dat hier een run voor nodig was. **Dat was fout** — het stond allebei in Blizzards eigen
DB2, alleen niet op de plek waar de eerste agent keek.

- ✅ **`rifle` is een GEWEER.** `CriteriaTree` 212485 is een echt scenario-doel: *"Galvanic Rifle
  acquired"*, onder `Ethereals02` = Shadowguard Point. De ability is `Spell` 1246359
  **Galvanic Blast**, en Blizzards eigen tooltip zegt *"Destroys mana containers"* — **"mana
  containers" is dus Blizzards term, niet de onze**. Ons *"until boss opens"* is het doel
  *"Arcane Barrier destroyed"* (`CriteriaTree` 212750).
  ⚠️ Waaróm beide vertalers hem niet vonden: het is **geen voorwerp**. Ze zochten in `Item` en
  `ItemSparse`; het is een action-bar-override-spell. Net als `Improvised Arcane Device` en
  `Evasive Elixir`, die ook spells blijken te zijn.
  → Engels herschreven, en de 6 vertalingen van die 2 keys staan nu als gedrift.
- ✅ **Deatholme, met één `h`.** *"Ruins of Deatholme"* bestaat wél: `AreaTable` **16056**, een
  direct kind van het vernieuwde **Eversong Woods** (15968). Onze zone was dus goed en alleen
  de spelling fout — in 14 regels hersteld. Blizzards eigen interne token is
  `12EversongDeathholme` **mét** dubbele h, wat vermoedelijk onze bron is.
  📌 Ingang gemeten: `AreaPOI` 8437 → **Eversong Woods 45.5, 86.0**. Methode gecontroleerd op
  Shadowguard Point, dat exact onze opgeslagen `37.18, 49.16` reproduceert.

## ❓ 31 aug — twee vragen over ons EIGEN Engels die alleen in het spel te beslechten zijn

Geen bug in de vertaling: twee dingen in de **enUS**-bron blijken onhoudbaar, gevonden doordat
vier taalexperts los van elkaar over dezelfde regels struikelden.

- [ ] **Shadowguard Point → Stolen Mana: krijg je daar een geweer?**
      Onze regel is *"Stolen Mana: rifle destabilizes mana containers"*. De Spaanse vertaler las
      `rifle` als **werkwoord** (doorzoeken), de Portugese als **zelfstandig naamwoord** (een
      wapen dat je krijgt) — onafhankelijk van elkaar, tegengesteld. De grammatica wijst naar
      het naamwoord (`rifle` stuurt een enkelvoudig werkwoord aan), maar **geen van beiden vond
      een voorwerp met die naam in DB2**. Spaans heeft het woord daarom wéggelaten.
      🔴 Twee moedertaalsprekers die één zin tegengesteld lezen = de zin is stuk. Kijk bij je
      volgende Stolen Mana-run of je een voorwerp in je actiebalk krijgt, dan herschrijven we
      het Engels en vertaalt de rest mee.

- [ ] **"Ruins of Deathholme" bestaat niet.** Die string staat in 12.1 `AreaTable` in geen enkele
      taal. Het dichtstbijzijnde echte gebied is **Deatholme** (één `h`, id 3500) en dat ligt in
      **Ghostlands**, niet in zuidwest Eversong. Klopt onze plaatsbepaling van The Shadow Enclave
      wel? Portugees liet het Engels staan in plaats van een gok vast te leggen.

## ✅ AF 31 aug — Earthshammy-ronde gedaan en geverifieerd

Rob draaide hem diezelfde middag. `tools/_probe.py` leest **Herbalism 40, captured on
Earthshammy** — de vangst is dus hersteld én draagt nu een eigennaam. De andere tien staan op
`|before the fix|`, wat klopt: die zijn vastgelegd vóór de reload met de nieuwe code.

📌 Eén vraag blijft open en lost zichzelf op: Alchemy staat op 20 zonder eigenaar. Zodra iemand
daar een keer het venster opent, staat er een naam bij.

<details><summary>De oorspronkelijke instructies</summary>

Rob draaide `/mh profids` over meer personages dan gevraagd en legde daarmee een ontwerpfout
bloot: de vangst overschreef per beroep, dus een alt met Herbalism op nul wiste Earthshammy's
**Botany 40/40** uit het bestand. Drie van zijn alts hebben Herbalism; de laatste won gewoon.

De fix (`ab11f2b`) laat een vangst vastleggen **van wie** hij komt en vervangt alleen bij
hetzelfde personage of méér rangen. Wat er al kapot is, repareert dat niet.

**Log in op Earthshammy, open Herbalism (en Alchemy als die er staat), `/reload`, dan:**

```
/mh profids
```

- [ ] Herbalism staat weer op **40** — controleer met `python tools/_probe.py`
- [ ] De regel noemt nu rangen én blijft staan als je 'm daarna op een alt draait:
      verwacht `|cffff9900(kept Earthshammy's 40 instead)|r`
- [ ] ⚠️ **Open vraag die alleen deze ronde kan beantwoorden:** Alchemy sprong van 0 naar 20.
      Dat is óf Rob die punten uitgaf, óf een tweede Alchemy-personage dat erover heen ging.
      De oude dump legde geen eigenaar vast, dus dit is niet uit het bestand te halen.

</details>

## 🔴 30 aug — beroepen-adviseur zweeg voor een heel beroep. Fix ligt klaar, ONGETEST.

Rob zat vast: Disenchanting Delegate op 30/30, 235 Knowledge in de hand, en géén groene
adviesregel onder "Enchanting". Oorzaak: stap 2 van de route noemde `Shard Supplier` /
`Crystal Collector` als `anyOf` — maar dat zijn **nodes**, en `anyOf` wordt opgezocht tussen de
vier **tree**-tabbladen. Geen match → `return nil` → geen advies, ook niet voor stap 3 en 4.

**Na een `/reload`, met je Enchanting op 30/30:**

### 🆕 30 aug, laat — overlappende tekst onderaan Professions → Overview (ONGETEST)

Rob's screenshot: de reset-alinea (*"Changed your mind? Theremis in Silvermoon…"*) en de
legenda-regel eronder (*"Treasures & Books: … Course (101): … Weekly KP: …"*) tekenden over
elkaar heen, allebei onleesbaar.

**Oorzaak:** de legenda hing aan `BOTTOMLEFT` van het paneel terwijl alles erboven naar beneden
groeit en niets dat begrenst. Dat ging alleen goed zolang de tekst kort was. Mijn adviesregel
groeide die middag van één naar drie regels (hij noemt nu drie takken in plaats van er stil één
te kiezen) en dat was genoeg om de speling op te eten. **De bug zat er altijd al; ik heb alleen
de marge opgemaakt die hem verborg.**

**Te controleren na `/reload`:** Toolbox → Professions → Overview, helemaal naar beneden. De
legenda hoort nu **onder** de "Route to Theremis"-knop te staan, met ruimte ertussen, en niets
mag meer over elkaar lopen.

⚠️ Bewuste keuze: er is hier geen scrollframe, dus bij een héél lange pagina kan die legenda nu
onder de onderrand vallen en onzichtbaar worden. Dat is de betere storing — het is de minst
belangrijke tekst op de pagina, en onzichtbaar is beter dan dwars door de tekst die je nodig
hebt. Zie je hem helemaal niet meer, meld het dan; dan is een scrollframe de echte oplossing.

### 🆕 30 aug, laat — de drie enchant-families in de addon (ONGETEST)

Na een `/reload`, Toolbox → Professions → **Course (101)** → hoofdstuk **Enchanting**:

1. **Onderaan het hoofdstuk staat een nieuw blok** "The three families, and why the choice
   matters" met de stat-tabel per familie. Staat het er niet, dan wordt `familiesKey` niet
   gerenderd.
2. **De adviesregel noemt nu drie namen.** Met je tree-route af hoort er te staan: *"je volgende
   punten gaan in ÉÉN hiervan — Zul'Aman Zeal, Azerothian Arms, Silvermoon's Spellpower"*, elk
   met `(0/20)`. ⚠️ Stond er eerst alleen `Silvermoon's Spellpower`; dát was de stille keuze.
3. **`/mh profadvice`** — step 2 van de node-route moet nu drie namen tonen in plaats van één.
4. ⚠️ **Zie je bij een van de drie `NOT FOUND`?** Dan bestaat die node-naam niet zoals wij hem
   schrijven. `Zul'Aman Zeal` en `Azerothian Arms` komen uit de DB2 van de agents, níét uit jouw
   client — alleen `Silvermoon's Spellpower` is ooit door jou bevestigd.
5. **Nog steeds waar:** de addon controleert niet of je een node kúnt kopen. Staat er een naam
   die in het spel op slot zit, dan is dat deze bekende beperking en geen nieuwe bug.

✅ **Ronde 1 al bevestigd op Robs scherm:** de adviesregel was terug en `/mh profadvice` gaf
`step 2 [node] Shard Supplier 0/30 | Crystal Collector 0/30` → `verdict: advise Shard Supplier`.
Geen `NOT FOUND`, dus de namen bestaan echt in 12.1. Zijn tooltips brachten daarna twee dingen
aan het licht die we níét wisten, en die zijn hierna verwerkt — **dat deel is nog ongetest:**

1. **Er staan nu DRIE opties, geen twee.** De adviesregel hoort te luiden: *"je volgende punten
   gaan in ÉÉN hiervan — Dust Deliverer (0/30), Shard Supplier (0/30), Crystal Collector
   (0/30)"*. `Dust Deliverer` ontbrak volledig in onze data.
2. **Hij mag niet meer vóór je kiezen.** Er stond *"advise Shard Supplier"* alsof dat hét
   antwoord was, terwijl de drie op verschillende gear werken (Uncommon / Rare / Epic). Zie je
   nog één naam met "next points into", dan werkt de keuzeregel niet.
3. **`/mh profadvice`** moet bij step 2 nu drie namen tonen.
4. **Tailoring mag niet veranderd zijn** — die regel (Nimble Needlework, aim 20) stond goed en
   de fix raakt alleen routes met node-stappen.
5. **Zet een punt en kijk opnieuw.** De regel hoort mee te lopen (`1/30`), en zodra de node vol
   is hoort het advies door te schuiven naar **Elevating Equipment**. Dat stuk was vóór vandaag
   helemaal onbereikbaar.

📌 Welke van de drie is **Robs keuze, niet de onze** — we hebben nooit gevraagd wat hij sloopt.
Blizzards eigen tooltips: Dust Deliverer = Uncommon, Shard Supplier = Rare, Crystal Collector =
Epic; elk +1 Skill per punt op díé kwaliteit, +5 bij het leren.

## 📍 STAND 28 aug (avond) — alles met een dwingende reden is af

Afgevinkt vandaag: de rechtsklik-dispel én de purge, de range-fade, de eigen rij,
`/mh dispeltest` (alle drie de takken), de gele balk, `/mh stats probe` (alle drie de
beslissingen), `/mh curios`, de Catalyst-meting, `/mh setline`, en Andy's PR #2b.

**Twee dingen staan nog open, allebei "als je er toch bent" en geen van beide een klus:**

1. **PR #1 — de vijf vensters die stil kunnen stoppen met verversen** (punt 7 hieronder).
   ⚠️ Dit is het enige punt met een echt risico erin: het faalt **stilzwijgend**. Een scherm
   met verouderde cijfers ziet er precies zo uit als een dat klopt. Doe het een keer terloops:
   getal onthouden, venster dicht, iets laten veranderen, weer open.
2. **Een professie-route helemaal lopen** (punt 6) — Enchanting 22 punten op de shadow priest.

Alles daarboven en daaronder met een ✅ is in het spel bevestigd, niet beredeneerd.

---

## ✅ AF 28 aug — de rechtsklik-dispel werkt

Rob bevestigde het in het spel. Oorzaak: de knop kreeg het spell-**ID** mee; hij moest de
**naam** hebben, zoals HexBreak doet. Zie `docs/NEXT_SESSION.md` bovenaan voor waarom dat een
bewuste uitzondering op onze ID-regel is, en wat de vier uur eromheen kostte.

✅ **En de purge op de rechterhelft ook** — Rob bevestigde Dispel Magic (528) met de
rechtermuisknop op de doelwit-helft, direct erna. De naam-fix repareerde dus **beide** knoppen,
niet alleen de dispel.

✅ **Range-fade en de eigen rij ook af (28 aug, in het spel bevestigd).** Wegloplopen vervaagt
een naam; heen en weer switchen tussen Holy en Shadow laat de vijfde rij komen en gaan. Rob:
*"het werkt perfect"*. Niets meer open aan deze feature — de tekst voor CurseForge staat
bovenaan `docs/NEXT_SESSION.md`.

<details><summary>De oorspronkelijke opdracht (voor herhaling)</summary>

### één schone rechtsklik (2 seconden, beslist de rest)

**Rechtsklik op een RODE naam in het party-paneel. Verder niets indrukken** — geen shift, geen
ctrl, geen alt, en niet tegelijk je eigen dispel-toets. Kijk of de dispel afgaat.

| Wat je ziet | Wat we daarna doen |
|---|---|
| de dispel gaat af | klaar — het hele HexBreak-onderzoek hieronder vervalt |
| er gebeurt niets | ik zet `*spell2` erbij (één regel), dan casten-op-naam, dan de dubbele klik |

📌 **Doe dit vóór al het andere op deze lijst.** Er liggen drie mogelijke reparaties klaar op
basis van hoe HexBreak het doet. Werkt de klik gewoon, dan zijn alle drie overbodig.

🔴 **Waarom het nog niet beslist is, en dat is mijn fout.** Ik las in de castlijst van
`/mh glow` een regel `Dispel Magic (528)` en concludeerde dat de klik op de rechterhelft
landde. Die lijst legt **élke** spreuk vast die je cast, ongeacht waar hij vandaan komt — in een
bossfight druk je van alles in. Die meter kan dat verschil niet zien; hij bewijst dus niets.

⚠️ **Verzin geen vierde verklaring vóór deze klik.** Drie hypotheses zijn al gesneuveld op
gemeten getallen (overlappende helften, combat die de layout bevriest, de gloed die de rij
afdekt). Geometrie, lagen en knop-attributen zijn allemaal ✅ gemeten en goed.

</details>

---

## 🟣 `/mh stats` — meegegaan in 3.6.0 (28 aug)

✅ **Niet meer "ongecommit".** De kop hierboven zei tot 28 aug dat deze feature alleen in Robs
spelmap stond; dat is achterhaald. `Modules/StatCoach.lua` én `Modules/DispelTest.lua` zitten
allebei in de tag `v3.6.0` en staan dus bij iedereen op de schijf. Ongetest blijft het wél —
uitgebracht is niet hetzelfde als gezien.

### 0a. `/mh stats` — leest het als jip-en-janneke?

Een venster met je hoofdstat, je vier secondaries in **jouw** volgorde, en je eigen live
percentages. De kop zegt met opzet dat hoger item level bijna altijd wint en stats pas de
doorslag geven bij twee stukken die dicht bij elkaar liggen — anders gaat een beginner hogere
ilvl weigeren om een kleurtje na te jagen.

### 0b. ✅ AF 28 aug — `/mh stats probe`, alle drie beslist

Gedraaid op Robs Frost Mage (Iceicebaby, ilvl 295) en naast toets C gelegd:

| probe | characterscherm |
|---|---|
| `GetCritChance` 17,065 · `GetSpellCritChance(2)` 17,065 | Critical Strike **17%** |
| `GetHaste` 21,177 | Haste **21%** |
| `GetMasteryEffect` 46,843 | Mastery **47%** |
| `GetCombatRatingBonus(vers)` 6,444 | Versatility **6%** |
| `primaryStat = 4` | **Intellect** bovenaan |

1. **Mastery-API:** `GetSpecializationMasterySpells` OK, `C_SpecializationInfo.GetMasterySpells`
   MISSING — nu op een tweede class bevestigd (27 aug Elemental Shaman, 28 aug Frost Mage).
   De verliezer was al verwijderd; dit is de tweede meting die dat bevestigt.
2. **`primaryStat` is echt de 6e return**, en `PRIMARY_BY_STAT` mapt 4 → Intellect
   (`StatCoach.lua:94-98`). ⚠️ Bevestigd voor Intellect; 1/Strength en 2/Agility zijn nog
   nooit gezien — een melee-alt zou dat afmaken, maar de mapping is Blizzards eigen
   `LE_UNIT_STAT_*`, dus dit is geen open risico.
3. **De crit-vraag is dood.** Beide functies gaven hetzelfde getal, en dat getal staat op zijn
   scherm. Er was geen caster/niet-caster-splitsing om omheen te bouwen.

<details><summary>De oorspronkelijke opdracht (voor herhaling)</summary>

### `/mh stats probe` — drie dingen die niemand buiten het spel kan weten

De probe print elke API die hij probeert, of hij antwoordde, en wat hij zei. Plak de uitvoer
hierheen; er zijn drie dingen te beslissen:

1. **Welke mastery-API bestaat.** Er staan er twee in als kandidaat
   (`C_SpecializationInfo.GetMasterySpells` en `GetSpecializationMasterySpells`). De verliezer
   moet daarna weg — niet laten staan "voor de zekerheid". Op 8 aug ging op precies die manier
   een niet-bestaande event-naam mee.
2. **Of `primaryStat` echt de 6e waarde van `GetSpecializationInfo` is.** Staat als
   `primaryStat=1` in de uitvoer. Klopt het niet, dan vervalt alleen de hoofdstat-regel.
3. **De vier percentages tegen je characterscherm (toets C).** Vooral crit: casters lezen een
   andere functie dan de rest, en dat is de regel die niet te bewijzen was. De probe print ze
   allebei, dus één blik volstaat.

</details>

### 0c. ✅ AF 28 aug — `/mh curios`, de opgegeten letters zijn terug

Een echte bug in `CurioExplain.lua`: het kleurcode-patroon `|c%x+` is gulzig en a–f zijn
hex-cijfers, dus het at de eerste letters van het gemarkeerde woord op — buiten het spel
bewezen: `Blood Shield` werd `lood Shield`, `deflect` werd `lect`. Gerepareerd naar exact
acht cijfers (`CurioExplain.lua:134`).

Rob plakte 28 aug de volledige uitvoer van Valeera's twaalf keuzes. **Geen enkel afgeknot
woord** — "Haste reduced", "Leech, Avoidance, and Speed", "Horrifying", "Corrosive Bilespear",
alles heel. Twee dingen tegelijk bevestigd: het patroon knipt goed, en de beschrijvingen komen
inderdaad live uit de client (de tekst bevat Blizzards eigen "stacking up to 1 times", dat
zouden wij nooit zo schrijven).

---

## ✅ Bevestigd 27 aug (avond)

Alles staand in een ritual site op Robs Elemental Shaman, één reload:

- **Bossvenster blijft uit in rituals** — Andy's PR #2a doet wat hij belooft.
- **BUFF ALLY weg.** Een ritual zet je in een instance-groep, dus `IsInGroup()` zei terecht
  "ja" terwijl er niemand stond. We tellen nu of er iemand ín een party-slot zit.
- **Valeera-venster weg.** Rituals zijn scenario's; na een delve hield elk ritual het venster
  open. De instance wordt nu vastgepind bij de start.
- **Geen zwevende pijl meer.** Verborgen binnen, en hij komt terug als je naar buiten loopt —
  de route wordt níét losgelaten.
- **De A-toets is Rob nooit kwijt geweest.** De focus-bug zat er wel (vier plekken,
  gerepareerd), maar heeft hem niet geraakt: het waren dialogen die hij zelden opent.

---

## 🔴 Eerst: één reload, dan alles achter elkaar

Deze twee kunnen staand in Silvermoon, geen dungeon nodig.

### 1. ✅ AF 28 aug — `/mh dispeltest`, alle drie de takken

Rob draaide ze allemaal. `decide`: **5 passed, 0 failed**, inclusief de SECRET-regel die
netjes zegt dat een secret value niet na te bouwen is en dus niet getest wórdt. `show`: de
gele balk kwam ("Testitis - you can dispel this"). `combat`: eerst **`in combat = false`** —
hij vuurde terwijl Rob stilstond, dus die run testte hetzelfde als `show`. Tweede poging,
slaand op iets: **`in combat = true, fired = true`**.

📌 Die eerste combat-run is het bewaren waard: het commando meldde eerlijk dát het buiten
gevecht landde, in plaats van "fired = true" te printen en de indruk te wekken dat de zware
helft getest was. Dat is precies waarvoor `InCombatLockdown()` in die regel staat.

<details><summary>De oorspronkelijke opdracht (voor herhaling)</summary>

| commando | wat je hoort te zien |
|---|---|
| `/mh dispeltest decide` | een rijtje PASS-regels met per geval een reden erbij |
| `/mh dispeltest show` | de grote gele balk bovenin, met geluid |
| `/mh dispeltest combat` | melding "firing in 5s", dan ga je een oefenpop slaan |

Let op bij `decide`: staat het dispel-alarm **uit**, dan zegt hij dat en is de uitkomst
waardeloos. Eerst aanzetten.

Bij `combat` is de chatregel het bewijs, niet de balk — hij meldt of hij in combat was en of
hij is afgegaan. Een alarm dat je gemist hebt en een alarm dat nooit kwam zien er hetzelfde
uit.

</details>

### 2. ✅ AF 28 aug — de gele balk op jezelf, ná de wijzigingen

Meegekomen met de test hierboven: `dispeltest show` en `combat` vuren door **dezelfde deur**
als het echte alarm (`ns.FireAccessibleAlert`), en die balk kwam allebei de keren op Robs
scherm. De vraag was of hij ná de wijzigingen aan `AccessibleAlerts.lua` nog komt — ja, en in
gevecht ook.

📌 Dat de test dezelfde deur gebruikt is geen detail: een test met een eigen `if testMode`-tak
slaagt juist op de build waar de echte weg stuk is.

### 3. ✅ AF 28 aug — de Catalyst zegt het zélf, en dat is sterker dan onze bron

Rob kreeg geen borststuk in het slot en probeerde een **cloak**. Dat bleek genoeg, want het
antwoord staat in de kop van het venster, in Blizzards eigen woorden:

> *"Transform an item into a set item. Only Head, Shoulder, Chest, Hand, and Legs provide
> bonus… **Secondary stats are inherited.**"*

Het voorbeeld bevestigde het: het resultaat droeg **+37 Haste / +63 Versatility**, hetzelfde
als wat erin ging. `TIER_GUIDE_BODY` stond op een blue post en een tooltip; die claim rust nu
op de client.

📌 **Drie dingen die er gratis bij kwamen:**
- **Costs: 1 charge, en Rob heeft er 0** — en het voorbeeld rendert tóch. De aanname dat deze
  meting geen charge kost is daarmee niet alleen waar maar ook verklaard.
- **Een cloak mag erín**, hij geeft alleen geen setbonus. Onze zin "cloaks zijn nooit deel van
  een set" klopt over de bónus; het spel weigert het stuk niet.
- Het venster somt de vijf bonusslots zelf op — dezelfde vijf als `ns.TIER_SLOTS`.

✅ **En het item level gaat óók mee — gemeten, niet aangenomen.** Ik had dit eerst als
onbewezen weggezet omdat het ilvl van het ingelegde stuk niet op de screenshot stond. Rob wees
erop dat het er wél stond: hij legde de cloak in die hij **aan had**, dus de "Equipped"-tooltip
naast het voorbeeld ís de invoer. Invoer **305** → uitvoer **305**, en de twee tooltips lopen
regel voor regel gelijk (Armor 65, Stamina 1.572, Intellect 81, Haste 37, Versatility 63).
Beide helften van de zin in `TIER_GUIDE_BODY` staan nu op de client.

📌 **Ook uit de patch notes** (news.blizzard.com, Curse of Ula'tek): *"Class set armor now
inherits the secondary and tertiary stats as well as certain special cantrip effects."* Dat is
**meer** dan onze tekst belooft — tertiair en cantrips staan er nog niet in.

<details><summary>De oorspronkelijke opdracht (voor herhaling)</summary>

### De catalyst-tekst kloppend maken — en de meting is gratis

De tier-uitleg zegt nu dat het nieuwe stuk je secundaire stats overneemt. **Twee primaire
bronnen zeggen dat** (blue post 18 juni + de tooltip van Venomblight Manaflux), maar we hebben
het zelf nooit gezien.

⚠️ Dit hoeft **geen** charge te kosten. De Catalyst-UI toont een voorbeeld vóór je bevestigt.

1. Pak een **borststuk** dat NIET Mastery + Haste heeft — bijvoorbeeld Crit + Versatility.
   Schrijf de stats op, inclusief een eventuele Leech/Speed/Avoidance en socket.
2. Leg het in het Catalyst-slot in Silvermoon (Bazaar). **Niet bevestigen.**
3. Ga met je muis over het voorbeeld.

| Wat je ziet | Wat het betekent |
|---|---|
| Mastery + Haste | de stats liggen vast — onze tekst is fout en moet terug |
| Crit + Versatility (wat jij erin legde) | de stats gaan mee — bevestigd |

🔴 **Kijk apart naar het tertiair en de socket.** Die konden vroeger al meekomen, dus "mijn
Leech bleef staan" bewijst **niets** over de secondaries. Dat is precies het soort halve
conclusie waar deze week over ging.

</details>

---

## 🔵 In een dungeon: Maisara Caverns, eerste baas

### 2b. ✅ AF (27 aug): de gloed vult nu de hele regel

Bevestigd op Robs scherm, staand in Silvermoon: vier volledig rode regels met DISPEL erin.
Het glow-test-commando blijft bestaan — draai het na elke wijziging aan `PartyTargets.lua`,
want dit is drie keer stuk geweest zonder dat iemand het zag tot er een baas aan te pas kwam.

⚠️ **Wat hiermee NIET bewezen is:** of het spel dat aura-vakje ooit tóónt. Dat blijft de
dungeon-test hieronder.

<details><summary>De oorspronkelijke opdracht (voor herhaling)</summary>

### `/mh glow test` — staand in Silvermoon

Zet `/mh partytargets` aan en typ `/mh glow test`. Zes seconden lang worden de rijen
geschilderd alsof er iets te dispellen valt.

**Waarom dit vóór de dungeon komt.** Alle drie de mislukte pogingen van 26 aug gingen over
**waar** de kunst tekende — icoon-formaat, daarna aan een vakje van nul bij nul, daarna ónder
de achtergrond van het paneel. Geen van de drie ging over of de gloed vuurt. Dat deel kost dus
geen dungeon en geen baas die toevallig iets moet casten.

Vult het rood hier de hele regel met DISPEL erin, dan doet het dat in een dungeon ook. Doet het
dat hier niet, dan hoef je niet te gaan.

⚠️ **Wat het NIET test:** of het spel dat vakje ooit tóónt. Dat is Blizzards beslissing op een
filter dat wij nooit lezen — precies het enige deel dat we niet in de hand hebben. Een schone
uitkomst hier plus stilte in een dungeon betekent dus nog steeds "er kwam niks langs".

</details>

### 3. ✅ AF — de rode gloed op een groepsregel

🔴 **Deze sectie stond tot 31 aug op "ongetest" en dat was fout.** De gloed die de hele regel
vult is 27 aug bevestigd (punt 2b), en de STAND van 28 aug hierboven vinkt de rechtsklik-dispel
én de purge af. Rob wees me erop toen ik het als openstaand opsomde; hij had gelijk.

⚠️ **De les zit in de vórm van de fout, niet in deze twee regels.** Dit bestand heeft een
statusregel bovenaan die alles eronder overschrijft, en ik las de detailsectie zonder die
statusregel. Een kop die "ongetest" zegt is dus geen bewijs — zoek de nieuwste STAND-regel.
Wie hierna secties toevoegt: werk de oude kop bij in plaats van er een nieuwe onder te zetten.

<details><summary>De oorspronkelijke testinstructies (bewaard, niet meer nodig)</summary>

**Ga naar Murojin, de eerste baas.** Onze eigen tips zetten de dispel daar
(`DGN_TIP_MC_MUROJIN_HEALER`: disease, zware groepsschade). Bij de laatste baas kwam 26 aug
niets langs — dat was géén bewijs tegen de reparatie.

Neem een **Holy Priest** (Purify pakt Magic én Disease). Niet je mage: Remove Curse doet alleen
curses en die komen hier niet voor.

Drie dingen apart bekijken, want ze kunnen los van elkaar stuk zijn:

1. **Vult het rood de hele regel?** Op 26 aug zag je alleen een dun streepje. Oorzaak was frame
   level — het vakje tekende ónder de achtergrond van ons paneel. Nu gelijkgetrokken met
   HexBreak.
2. **Staat het woord DISPEL erin?**
3. **Werkt de rechtermuisknop nog?** Een tussenversie brak álle klikken op het paneel. Dat is
   teruggedraaid, maar niet in het spel bevestigd.

Werkt er iets niet: `/mh glow` en de uitvoer hierheen plakken.

### 4. ✅ AF 28 aug — rechtsklik-dispel op de Priest

Eerst bewezen op Robs **mage** (25 aug: Remove Curse 475, Spellsteal 30449), daarna op de
priest bevestigd — zie "AF 28 aug" hierboven: de dispel én Dispel Magic (528) op de
doelwit-helft werkten allebei na de naam-fix.

</details>

---

## ⚪ Als je toch bij een beroep bent

### 6. Een gecorrigeerde route vanaf nul lopen (Spec 28, §5)

De tien routes zijn 20 aug herschreven en gedeeltelijk op je scherm bevestigd (Enchanting
leidt nu met `Disenchanting Delegate`, Tailoring toont de drempel van 20 met de
tooltip-waarschuwing). Wat nooit gedaan is: er één **helemaal** volgen en kijken of het advies
blijft kloppen terwijl je punten uitgeeft.

Je shadow priest heeft **Enchanting 22** onbestede punten — dat is de bruikbare testcase.

⚠️ **Tailoring werkt daar niet voor:** je skill staat onder 25, dus alle specialisaties zitten
op slot en je kunt er niets uitgeven. Dat is geen bug meer (gerepareerd 21 aug), maar het maakt
Tailoring wel ongeschikt als test.

---

## 🟠 Andy's twee PR's — GEMERGED 27 aug, nu in je client

Beide zaten sinds 7 augustus open en zijn vandaag binnengehaald. Ze raken **zeventien**
bestanden, en dat is meteen het risico: als er iets raars gebeurt met een venster, is dit de
eerste verdachte.

### 7. PR #1 — vensters die dicht stonden bleven rekenen

Vier onderdelen deden werk terwijl hun scherm dicht was. Andy meet dat de addon van 0,060 naar
0,003 ms per beeldje gaat als je stilstaat met alles gesloten.

**Wat je test: dat alles nog steeds bijwerkt.** Dit is een optimalisatie, dus je zoekt niet
naar iets dat stuk is maar naar iets dat **stopt met verversen**. Dat is een stil soort falen:
een scherm dat verouderde cijfers toont ziet er precies zo uit als een scherm dat klopt.

**De scherpste test — doe dit met minstens één van de vijf:**

1. Open het venster en onthoud een getal.
2. Sluit het.
3. Doe iets waardoor dat getal moet veranderen: een currency oppikken, een quest inleveren,
   een delve afmaken.
4. Open het weer. Staat het bij?

Langs deze vijf:

- Great Vault-advies
- delve-curio's
- wereldbaas
- de weekchecklist en de account-checklist
- het consumables-bord

⚠️ **Andy's eigen voorbehoud, dus géén bug:** de twee checklists verversen niet meer terwijl hun
venster dicht is. Heropen je hetzelfde tabblad, dan kunnen ze een paar seconden achterlopen tot
de volgende quest- of currency-gebeurtenis.

### 8. PR #2 — vensters die zichzelf openden zonder te vragen

Twee stukken. Het tweede heb je **iemand anders** voor nodig.

**a) Het bossvenster.** De aan/uit-knop werd alleen gelezen op de dungeon-route, dus het venster
ging in **rituals en raids** gewoon open terwijl jij hem uit had staan.

Ga naar **Settings → Midnight Helper**. Waar één schakelaar stond, staan er nu drie. Robs
client is Engels, dus dit zijn de labels zoals ze op zijn scherm staan:

| Schakelaar | Waarvoor |
|---|---|
| `Open automatically` | dungeons |
| `Open automatically for rituals` | rituals |
| `Open automatically for raids` | raids |

1. Zet **`Open automatically for rituals`** uit.
2. Ga een **ritual site** in. Blijft het bossvenster dicht? Dát is de bug die hier gerepareerd
   is — vóór deze PR ging hij daar open ook al stond hij uit.
3. Zet hem weer aan en kijk of hij dan wél komt.

⚠️ **Niet melden als bug:** de allereerste keer dat je de **dungeon**-schakelaar aanraakt,
neemt hij de andere twee mee. Dat is met opzet — je oude instelling gold voor álles, dus die
wordt eerst voor alle drie overgenomen (`DungeonBossWindow.lua:1195-1207`). Daarna staan ze los
van elkaar en gebeurt het niet meer.

**b) ✅ AF 28 aug — het consumables-bord respecteert nu jouw eigen schakelaar.**

Met Carola in de groep, en in de **strengere volgorde** dan hier oorspronkelijk stond:

| Robs `Allow group consumable check` | Carola typt | Robs scherm |
|---|---|---|
| **AAN** | `/mh readyall` | bord **komt** |
| **UIT** | `/mh readyall` | bord **blijft dicht** ✅ |

📌 **Die volgorde was Robs keuze en hij is beter dan mijn opdracht.** Ik schreef "zet hem uit
en kijk of er niets gebeurt". Hij deed eerst AAN — en daarmee staat vast dát het verzoek
aankomt en het bord kán openen. Zonder die positieve controle vooraf is "er gebeurde niets"
niet te onderscheiden van een kapotte functie. Dezelfde les als bij `/mh setline` diezelfde dag.

⚠️ **Praktisch, voor een volgende keer:** in een **party** bestaan geen assistenten, alleen een
leider. Rob moest Carola dus eerst de leiding geven (`/leader <naam>`) — en die kun je zelf
niet terugpakken, de ander moet hem teruggeven. Beide helften van dit commando zitten in
`v3.6.0`, dus de tester heeft genoeg aan de CurseForge-versie.

Ook hernoemd: **`Show consumable check on entry`**. Stond eerst "on dungeon entry", terwijl die
melding ook in rituals en delves komt — de tooltip eronder zei dat al.

### 9. ✅ OPGELOST — gemeten 31 aug, en niet doordat we het repareerden

`lua tools/locale_probe.lua SET_CONSREADY_TOGGLE_TITLE` geeft nu voor fr/es/pt/it
`nil -> shows English`. De foute "dungeon"-regels zijn dus weg uit die vier packs; ze vallen
terug op het Engels, wat klopt. Duits en Nederlands hebben een eigen goede vertaling.

📌 Waarschijnlijk meegenomen in een van de drift-rondes van 30/31 aug zonder dat iemand het
apart afvinkte. **Dat is precies waarom dit gemeten is en niet aangenomen** — deze regel had
anders nog maanden als openstaande fout in de lijst gestaan.

<details><summary>De oorspronkelijke melding</summary>

Andy hernoemde het label `SET_CONSREADY_TOGGLE_TITLE` omdat de tekst "bij binnenkomst in de
dungeon" zei terwijl de melding óók in rituals en delves komt. Het Engels is nu *"Show
consumable check on entry"*.

**Frans, Spaans, Portugees en Italiaans zeggen nog steeds "dungeon".** Duits en Nederlands zijn
goed. Dit is geen achterstand maar een onjuistheid, en hij staat in `docs/TRANSLATION_DRIFT.md`
bij de andere zeven.

Niets voor Rob om te testen — genoteerd zodat het niet als bugmelding terugkomt.

</details>

### 10. World boss weer zichtbaar in Season 2 — na `/reload`

**Wat je moet zien:** op **This Week** (home) en bovenaan **Delves & Vault** staat weer een world
boss, en deze week hoort dat **Lu'ashal** te zijn, in Eversong Woods, met routeknop.

**Waarom dit er staat:** de addon verzweeg de world boss sinds 18 aug. Een poort in
`Modules/WorldBoss.lua` zette hem uit zodra Season 2 zichtbaar werd, uit voorzorg — het vermoeden
was dat 12.1 world bosses had vervangen door Lairs.

✅ Dat vermoeden is op 2 sep weerlegd met `/mh worldboss` op Robs eigen client: **Lu'ashal
`taskActive = true`, 9904 minuten resterend**, de andere drie idle. De vier bosses roteren gewoon
door, en Lairs bestaan ernáást (`hasLairs = true`, `tieredEntranceType.Lairs = "4"`). Poort eruit.

⚠️ **Wat de moeite van een tweede blik waard is:** de rekenkundige terugval is teruggezet, en die
klopte deze week precies (18 maart + 24 weken → index 1 → Lu'ashal). Dat is corroboratie, geen
bewijs dat hij volgende week ook klopt. Kijk op **9 sep** of er **Cragpine** staat; klopt dat, dan
doet de rotatie het over een seizoensgrens heen.

📌 Zie je vandaag niets? Dan is dat geen kleinigheid maar dezelfde bug opnieuw — stuur dan weer de
uitvoer van `/mh worldboss`.

### 11. ✅ AFGETEKEND — `/mh report` werkt, 2 sep

Rob testte het binnen twintig minuten na uitbrengen en vond twee dingen die geen enkele controle
had kunnen zien, omdat de *waarden* klopten en alleen de **uitvoer** niet deugde:
`MAGE Frost` (het ruwe klassetoken, en in omgekeerde volgorde) en `Eastern Kingdoms (open world)`
— `GetInstanceInfo` geeft buiten de continent, niet de zone. Allebei gerepareerd; de tweede ronde
gaf `Frost Mage, level 90 . solo . Silvermoon City, The Bazaar`.

📌 De `issecretvalue`-guards zijn dus óók bevestigd: taal, spec, zone én subzone kwamen allemaal
door zonder een `?` of `somewhere`.

<details><summary>De oorspronkelijke testopdracht</summary>

**Wat je moet zien:** `/mh report` opent het bestaande kopieervenster met een blok dat begint met
`Midnight Helper report`, en daaronder je versie, clientbuild, taal, klasse/spec/level, groep en
waar je staat. In de chat komt één regel eronder.

**Probeer ook:** `/mh report de vault zei 3 slots maar ik had er 4` — die zin hoort in het blok te
staan onder *"What I saw:"*, in plaats van de standaardtekst.

⚠️ **Waar ik het meest benieuwd naar ben:** de regel `locale ... client / ... in MH` en de plek
waar je staat. Die twee lees ik uit het spel en dat is precies waar 12.x waarden geheim kan maken.
Staat er `somewhere` of een `?` waar iets hoorde te staan, dan wil ik dat weten — dat is dan geen
schoonheidsfoutje maar een `issecretvalue`-guard die aanslaat.

📌 **Wat er bewust NIET in staat:** je personagenaam en realm. Die identificeren jou, ze helpen
niet bij het reproduceren, en dit blok is bedoeld om ergens openbaar geplakt te worden. Klasse,
spec, groep en locatie zijn genoeg. Als jij vindt dat je naam er wél in moet, zeg het — het is
jouw addon — maar dit is de veiligere kant om op te beginnen.

📌 Het blok zelf is **Engels**, ook op een Duitse client, terwijl de venstertitel en de chatregel
wél vertaald zijn. Dat is een keuze: het rapport is aan de maker gericht, zoals een logbestand.
Vind je dat verkeerd voelen, dan draaien we het om.

</details>

### 13. De drie beroepsbeslissingen — `/mh profadvice`, na `/reload`

**Waar te kijken:** Professions → Overview, of `/mh profadvice`.

- **Jewelcrafting** — de eerste stap (*Thoughtful Throughput*) hoort nu een getal te noemen:
  *"about 5 gets it working"*. Stond er eerst geen.
- **Inscription** — na *Perfected Products* hoort er een vierde stap te komen:
  **Darkmoon Curiosity**. ✅ De naam is al tegen jouw eigen client-capture gecontroleerd (0
  afwijkingen), dus als hij er níét staat is er iets ánders mis dan de naam.
- **Engineering / alle routes met een getal** — de adviesregel zegt er nu bij *"this step only
  ticks off once the branch is full"*.

🔴 **Wat ik onderweg vond en wat je moet weten:** jouw "de stap voltooit pas bij 30" was een
symptoom. Er is geen drempel van 30 — de code vinkt af bij **tak vol**, en 30 is toevallig
Recycling's maximum. Ik heb dus geen ander getal ingevuld maar de voorwaarde opgeschreven, want
een verzonnen 30 was net zo fout geweest als de 10.

📌 Zie je bij Inscription vier stappen maar staat *Darkmoon Curiosity* op een rare plek in de
volgorde: dat klopt met wat we weten. De eerste drie zijn gemeten, waar de vierde hoort niet — ik
heb hem achteraan gezet omdat dat niets kapotmaakt aan wat al klopte.

### 14. `/mh shots` — er is een tiende scène bij

**Wat je moet doen:** log in op een personage **met Midnight-beroepen** (Iceicebaby of Umbrion —
Tailoring/Enchanting), dan `/mh shots`, dan **`/reload`** (zonder reload worden de
SavedVariables niet weggeschreven en snijdt `tools\Crop-Shots.bat` verkeerd), dan die bat.

**Wat er nieuw is:** `10-professions-advice` — de Overview met de adviesregel erop.

🔴 **Waarom deze scène er toe doet en de andere negen niet vervangt:** op 31 augustus is over
zo'n twintig addons gemeten dat **geen enkele** je vertelt wáár je je Knowledge uitgeeft. Ze
tellen punten, ze simuleren crafts, ze maken boodschappenlijstjes. Het enige dat deze addon doet
en niemand anders, stond dus niet op je CurseForge-pagina.

⚠️ **Deze scène hangt als enige aan het ingelogde personage.** Draai je hem op je Warlock die de
beroepen weer heeft laten vallen, dan krijg je een eerlijke lege pagina — geen bug, wel een
waardeloze screenshot.

### 12. Valeera: `/mh poisons` en het verschil tussen `/mh curio` en `/mh curios`

**Wat je moet zien, na `/reload`:**

- `/mh poisons` — Valeera's poisons met per stuk de omschrijving die de client geeft, en een
  groene `>` bij degene die ze aan heeft. **Dit bestond al maanden maar stond nergens vermeld**,
  dus geen speler kon het vinden. Staat nu in `/mh` en in de zoekbalk.
- `/mh curios` — de **uitlegger**: wat elke curio doet.
- `/mh curio` (enkelvoud) — de **adviseur-popup**. ⚠️ Die deed het tot nu toe niet: beide namen
  gingen naar de uitlegger, terwijl de commandolijst ze als twee dingen aanbood. De adviseur was
  alleen via de Tools-lade en de zoekbalk te bereiken.

🔴 **De vraag die ik aan jou teruggeef:** enkelvoud tegenover meervoud is een beroerde scheiding
tussen twee functies — niemand onthoudt dat `/mh curio` iets anders doet dan `/mh curios`. Ik heb
nu alleen hersteld wat de lijst al beloofde. Wil je liever dat ze samensmelten (één commando dat
de adviseur opent, met de uitleg erin), zeg het dan — dat is een grotere maar eerlijkere ingreep.

✅ **AFGEHANDELD op de avond van 2 sep.** Rob koos samensmelten, en daarna nog een ronde: `/mh
poisons` is nu een **alias van `/mh curios`** (het gif is gewoon één van de drie keuzeslots), en
`/mh curio`/`/mh curios` kiezen zelf tussen adviseur en uitlegger. Alles hierboven is dus
achterhaald behalve als geschiedenis. Getest en goedgekeurd door Rob dezelfde avond.

---

### 15. ☑️ AFGEVINKT OP ROBS GEZAG 3 sep — het consumables-bord haalt nu zélf op

⚠️ **Dit is NIET in het spel gezien.** Rob, 3 sep: *"de cisca consumable test mag je van mij
afvinken, ik meld me als het later toch niet goed blijkt te zijn."* Dat is zijn keuze en die telt —
maar de status is *"aanvaard zonder proef"*, niet *"werkt"*. Komt hier ooit een melding over
`(bag unknown)` die blijft staan, begin dan hier en niet bij iets nieuws.

De testinstructie hieronder blijft staan, want zij is de enige manier om het alsnog te bewijzen.

**Waarom dit er is:** iedereen stuurde zijn tas-tellingen alleen **uit zichzelf** rond, bij een
roster-wijziging of een zone-wissel. Zat je op dat moment in een laadscherm, dan miste je dat
bericht **voorgoed** — er was geen enkel bericht dat er ooit opnieuw om vroeg. Nu vraagt het bord
erom zodra het opengaat.

⚠️ **Cisca hoeft niets te typen en ziet niets.** Geen venster, geen geluid, geen chatregel. Haar
client krijgt een verborgen berichtje en stuurt dezelfde tellingen terug die hij nu al ongevraagd
rondstuurt. Merkt zij er iets van, dan is dát de bug.

**De schoonste proef is de kapotte situatie, en die heb jij zelf in de hand:**

1. Jullie zitten samen in een groep, allebei op deze versie.
2. **Jij** doet `/reload`. (Dat wist jouw ontvangen gegevens; ze worden niet bewaard.)
3. Wacht rustig tien seconden — niet zonewisselen, niet uitnodigen. Er gebeurt nu niets dat
   Cisca's client aan het praten krijgt. **Precies dit was de kapotte toestand.**
4. Open het bord: `/mh board`.

**Wat je moet zien:** Cisca's regel vult zich met echte tas-iconen (flask, rune, potions, food,
hearthstone) in plaats van *"(bag unknown)"*. Dat mag een fractie later gebeuren — het verzoek gaat
uit, haar antwoord komt terug, en het bord hertekent **terwijl het openstaat**.

🔴 **Let juist op dat laatste**, want dat was een tweede bug die ik bij het bouwen vond: een
antwoord dat binnenkwam terwijl het bord openstond werd wél opgeslagen maar **niet getekend** — je
zag het pas als je het bord sloot en opnieuw opende. Moet je nog steeds sluiten-en-openen, dan
werkt dat stuk niet.

**Tegenproef (bewijst dat het niet toevallig was):** doe stap 2 t/m 4 nog eens, maar open het bord
**niet**. Vraag Cisca iets uit haar tassen te gooien of bij te kopen. Zolang jouw bord dicht blijft
verandert er niets — het verzoek gaat pas bij het openen.

⚠️ **Niet in de war laten brengen:** ontvangen regels verlopen sowieso na tien minuten
(`STALE = 600`). Duurt jullie sessie langer, open het bord dan opnieuw in plaats van te concluderen
dat er iets stukging.
