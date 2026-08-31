# Testlijst — wat wacht er op Rob

**Lopende lijst.** Rob, 27 aug 2026: *"we gaan later alles proberen, onthoud dit en dan maken
we straks een lijstje wat ik in een keer kan testen"*. Alles wat gebouwd maar niet in het spel
gezien is, komt hier te staan tot hij het afvinkt.

⚠️ **Bouwen is niet testen.** Een module die laadt zonder foutmelding heeft alleen bewezen dat
hij laadt. Zet niets hieronder op ✅ omdat het "zou moeten werken".

## 🆕 31 aug — de Vaults-keten is vier quests en zegt nu wat je eerst nodig hebt (ONGETEST)

Home → het blok **"New: the Vaults of Atal'Utek"**. Alleen zichtbaar zolang je de keten níét
begonnen bent.

- [ ] Onder de gewone regel staat nu een grijze regel: *"First: level 90 and the Curse of
      Ula'tek campaign, up to Lor'themar's Judgement…"*. 🔴 Dit blok kón altijd al verschijnen
      bij iemand die er niet in kán — `GetTitleForQuestID` noemt een quest ook als je er niet
      voor in aanmerking komt. Het zei "hier is content" en verder niets.
- [ ] Twee beloningsregels: *"Opens the Vaults of Atal'Utek"* en *"Opens the Altar of
      Corrosion…"*. XP en goud staan er bewust NIET bij.
- [ ] ⚠️ Ben je de keten al begonnen of af? Dan hoort de grijze eis-regel **weg** te zijn en
      zie je alleen de voortgang. Dat is de bedoeling — je bent aantoonbaar door de poort.
- [ ] 🔴 **Wat ik niet kan controleren en jij wel:** de keten telt nu **vier** quests, met
      `98515 A Toxic Tour` tussen *One Coin Too Many* en *The Altar of Corrosion*. Klopt die
      volgorde met wat jij in je questlog ziet? Zygor zet die quest bij de **dailies**, de
      questline-data zet hem als **verhaalstap**. Beide bronnen zijn echt; alleen jouw client
      beslist.

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

## 🆕 31 aug — één ronde op Earthshammy, om herstelde data te bewijzen (ONGETEST)

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

### 9. 🔴 Vier talen beloven nu iets wat niet klopt

Andy hernoemde het label `SET_CONSREADY_TOGGLE_TITLE` omdat de tekst "bij binnenkomst in de
dungeon" zei terwijl de melding óók in rituals en delves komt. Het Engels is nu *"Show
consumable check on entry"*.

**Frans, Spaans, Portugees en Italiaans zeggen nog steeds "dungeon".** Duits en Nederlands zijn
goed. Dit is geen achterstand maar een onjuistheid, en hij staat in `docs/TRANSLATION_DRIFT.md`
bij de andere zeven.

Niets voor Rob om te testen — genoteerd zodat het niet als bugmelding terugkomt.
