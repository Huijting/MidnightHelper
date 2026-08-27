# Spec 30 — Testmodus voor de dispel-helper, en een projectregel

**Van:** ONDERZOEK-sessie, 21 aug 2026
**Voor:** BOUW-sessie
**Aanleiding:** Rob: *"kan je niet een test optie inbouwen om te zien hoe die moet werken ipv elke
keer een mob zoeken die het moet laten zien of de knop goed oplicht en ingedrukt wordt?"*

---

## 1. Het probleem, preciezer dan "het is omslachtig"

Een mob zoeken test **twee dingen tegelijk** en zegt niet welke van de twee stuk is:

1. **de beslissing** — herkent MH deze debuff als iets wat jij kunt dispellen?
2. **de vertoning** — licht de knop op, klinkt het geluid, is hij klikbaar?

Gebeurt er niets, dan weet je niet of de beslissing "nee" zei of de vertoning het liet afweten.
En bij deze module is *niets doen* vaak het **juiste** antwoord, dus stilte bewijst niets.

⚠️ **En er is een geval dat je met mobs zoeken principieel niet kunt testen.** In 12.1 kan
`dispelName` een **secret value** zijn. De code doet dan bewust niets
(`DispelHelper.lua:291-293`, *"unreadable: not 'no school', just unknown"*). Je kunt geen mob
opzoeken die gegarandeerd een onleesbare waarde geeft — dus dat pad is nu **onbereikbaar voor
handmatige tests**, terwijl het precies het pad is dat 12.1 riskant maakt.

Dat alleen al rechtvaardigt de testmodus.

---

## 2. Wat er gebouwd moet worden

De bestaande scheiding is al goed: `ns.GetDispelAlertFor(aura)` is een pure beslissing,
`AccessibleAlerts` bezit het frame, het geluid en de cooldowns. **Test die twee apart, in dezelfde
scheiding.**

### `/mh dispeltest decide`

Voert een handvol **verzonnen aura-tabellen** aan `ns.GetDispelAlertFor` en print per stuk wat hij
besluit en waaróm. Raakt geen UI aan.

Minimale gevallen:

| Geval | Verwacht |
|---|---|
| Magic-debuff, jij kunt Magic dispellen | tekst |
| Curse-debuff, jij kunt geen Curse | nil |
| `dispelName = nil` | nil |
| **`dispelName` is een secret value** | nil, en **niet** behandeld als "geen school" |
| alarm uitgezet | nil |

Print bij elk geval de reden, niet alleen het resultaat. *"nil — school niet in jouw lijst"* is
bruikbaar; een lege regel niet.

### `/mh dispeltest show`

Duwt één **nep-alarm** door het echte vertoningspad: hetzelfde frame, hetzelfde geluid, dezelfde
cooldown-logica. Zo zie je wat een speler ziet, zonder een mob.

⚠️ **De cooldown mag NIET omzeild worden.** Als de test een eigen pad neemt dat de gap negeert,
test je iets anders dan wat er in het spel gebeurt — en dan is een dubbel-alarm-bug precies wat je
niet vindt.

### 🔴 `/mh dispeltest combat` — het geval dat er het meest toe doet

Uit `CLAUDE.md`:

> Een frame dat een secure button parent wordt zélf protected en kan **in combat** niet meer
> verplaatst, getoond of verborgen worden.

Het gedrag buiten combat is dus **niet** het gedrag erin. Een testmodus die alleen buiten combat
werkt, test uitgerekend het geval dat niet stukgaat.

Voorstel: een variant die het nep-alarm **uitgesteld** afvuurt (bijvoorbeeld 5 seconden), zodat je
op een oefenpop kunt gaan slaan en het alarm je in combat treft. Meld in de chat wanneer hij
afgaat, zodat je weet dat het gebeurd is ook als je niets ziet.

### Overweeg: `/mh dispeltest` zonder argument

Draait alle drie achter elkaar en print een samenvatting. Dat is wat je wil als je na een reload
even wil weten of alles nog leeft.

---

## 3. ⛔ Randvoorwaarden

1. **Geen testcode in het echte pad.** Geen `if testMode then` verspreid door
   `AccessibleAlerts`. De testmodus roept dezelfde functies aan als het spel; hij verbouwt ze niet.
2. **De nep-aura moet dezelfde vorm hebben** als wat `AccessibleAlerts` echt langsstuurt. Wijkt de
   testdata af, dan test je je testdata.
3. **Niets dat de speler per ongeluk aan kan laten staan.** Eenmalig afvuren, geen modus die blijft
   hangen.
4. **Het secret-geval moet een échte secret value zijn** als de client die kan maken. Kan dat niet,
   zeg dat dan in de uitvoer — een nagebootste secret die zich anders gedraagt is erger dan geen
   test.

---

## 4. De grotere vraag: waarom niet altijd?

Robs tweede vraag: *"waarom zouden wij voor onze dingen die we maken niet altijd een test functie
voor ons zelf maken?"*

**Omdat het geld kost en niet altijd loont** — maar bij deze addon loont het vaker dan gemiddeld,
en er is een aanwijsbare reden.

### De vier gevallen waarin een testmodus zichzelf terugverdient

1. **De trigger is niet op afroep.** Een specifieke debuff, een specifieke boss, een zeldzame
   spawn. Elke test kost dan zoekwerk in plaats van seconden.
2. **Het gedrag verschilt per context.** In combat versus erbuiten, in een groep versus alleen,
   met TomTom versus zonder. Eén handmatige test dekt dan maar één context.
3. **Falen is stil.** Er gebeurt niets — en niets is óók het juiste antwoord in veel gevallen.
4. **De toestand is niet te reproduceren.** Secret values, groepssamenstelling, iemands
   Journey-rank.

### Waarom dat hier vaker geldt dan bij een gemiddelde addon

MH staat vol met *"zwijg als je het niet zeker weet"* — `issecretvalue`-guards in 36 bestanden,
`ns.Aura` met zijn drie toestanden waarvan `nil` **onleesbaar** betekent en niet **afwezig**, en de
regel dat een lege API-uitkomst niets bewijst.

Dat is goed ontwerp. Maar het maakt **stilte de normale uitkomst**, en daarmee is aan de buitenkant
niet te zien of de code correct zweeg of gewoon kapot is. Precies wat `silence-is-not-absence`
zegt, nu als testprobleem.

Er is al een precedent dat werkt: `/mh arrow` bestaat omdat *"standing down on purpose and being
genuinely broken look identical from outside"*. Dat is exact deze redenering, en die knop heeft
zich al terugbetaald.

### Voorstel voor een projectregel

Toe te voegen aan `CLAUDE.md` — **dat bestand is van BOUW**, dus dit is een voorstel, geen wijziging:

> **Bouw je iets dat kan zwijgen, bouw dan een manier om te zien dát het zweeg.**
> Elke module waarvan de normale uitkomst "niets doen" is, krijgt een `/mh <ding>`-diagnose die de
> beslissing print, en waar er een zichtbaar element is een manier om dat element te tonen zonder
> op de echte trigger te wachten. Verplicht als de trigger niet op afroep is, als het gedrag in
> combat anders is, of als de toestand niet te reproduceren is.

📌 **Niet met terugwerkende kracht op alles.** Dat wordt een project op zich. Wel: bij **nieuwe**
modules meteen, en bij een bestaande module zodra je hem toch aanraakt.

---

## 5. Wat dit Rob oplevert

Uit het geheugen: *"stop before the fourth reload"* — Rob 18 aug, *"te veel tijd gekost"*.

Elke reload-ronde die nu opgaat aan "een mob zoeken en kijken of er iets gebeurt" is een ronde die
een testcommando in seconden doet. En het secret-pad, dat je nu **helemaal niet** kunt testen,
wordt voor het eerst bereikbaar.

---

## 6. Klaar als

- `/mh dispeltest decide` print per geval de beslissing én de reden, inclusief het secret-geval.
- `/mh dispeltest show` toont een echt alarm via het echte pad, met de echte cooldown.
- Er is een manier om een alarm **in combat** te laten afgaan.
- `Modules/AccessibleAlerts.lua` bevat geen `if testMode`-takken.
- Rob heeft één keer alle drie gedraaid zonder een mob te zoeken.
