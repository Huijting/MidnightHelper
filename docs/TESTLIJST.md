# Testlijst — wat wacht er op Rob

**Lopende lijst.** Rob, 27 aug 2026: *"we gaan later alles proberen, onthoud dit en dan maken
we straks een lijstje wat ik in een keer kan testen"*. Alles wat gebouwd maar niet in het spel
gezien is, komt hier te staan tot hij het afvinkt.

⚠️ **Bouwen is niet testen.** Een module die laadt zonder foutmelding heeft alleen bewezen dat
hij laadt. Zet niets hieronder op ✅ omdat het "zou moeten werken".

---

## ✅ AF 28 aug — de rechtsklik-dispel werkt

Rob bevestigde het in het spel. Oorzaak: de knop kreeg het spell-**ID** mee; hij moest de
**naam** hebben, zoals HexBreak doet. Zie `docs/NEXT_SESSION.md` bovenaan voor waarom dat een
bewuste uitzondering op onze ID-regel is, en wat de vier uur eromheen kostte.

✅ **En de purge op de rechterhelft ook** — Rob bevestigde Dispel Magic (528) met de
rechtermuisknop op de doelwit-helft, direct erna. De naam-fix repareerde dus **beide** knoppen,
niet alleen de dispel. Niets meer open aan deze feature.

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

### 0b. `/mh stats probe` — drie dingen die niemand buiten het spel kan weten

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

📌 **Ook meegekomen:** een echte bug in `CurioExplain.lua`. Het kleurcode-patroon `|c%x+` is
gulzig en a–f zijn hex-cijfers, dus het at de eerste letters van het gemarkeerde woord op —
buiten het spel bewezen: `Blood Shield` werd `lood Shield`, `deflect` werd `lect`. Gerepareerd
naar exact acht cijfers. Kijk bij `/mh curios` of de gemarkeerde woorden nu compleet zijn.

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

### 1. `/mh dispeltest` — de nieuwe testmodus (27 aug, ongetest)

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

### 2. De gele balk op jezelf

Die zag je 26 aug spontaan: *"Cries of the Fallen - you can dispel this"*. Werkt al, staat hier
alleen zodat we weten dat hij nog steeds komt na de wijzigingen aan `AccessibleAlerts.lua`.

### 3. De catalyst-tekst kloppend maken — en de meting is gratis

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

### 3. De rode gloed op een groepsregel (gerepareerd 26 aug, ongetest)

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

### 4. Rechtsklik-dispel op de Priest (ongetest)

Op 25 aug bewezen op Robs **mage** (Remove Curse 475, Spellsteal 30449). Op de priest heeft
`/mh glow` alleen gemeld dat de knop Purify (527) draagt — dat is de knop, niet de dispel.

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

**b) Het consumables-bord.** Een groepsgenoot kan een verzoek sturen om het bord te tonen, en
jouw client opende het zonder naar jouw eigen instelling te kijken.

Nieuwe schakelaar: **`Allow group consumable check`**.

Nodig: **je zus of Cisca in de groep.** Zet die schakelaar **uit**, laat de ander de
groeps-consumablecheck oproepen, en kijk of het bord bij jou dicht blijft.

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
