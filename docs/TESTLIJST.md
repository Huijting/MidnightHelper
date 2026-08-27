# Testlijst — wat wacht er op Rob

**Lopende lijst.** Rob, 27 aug 2026: *"we gaan later alles proberen, onthoud dit en dan maken
we straks een lijstje wat ik in een keer kan testen"*. Alles wat gebouwd maar niet in het spel
gezien is, komt hier te staan tot hij het afvinkt.

⚠️ **Bouwen is niet testen.** Een module die laadt zonder foutmelding heeft alleen bewezen dat
hij laadt. Zet niets hieronder op ✅ omdat het "zou moeten werken".

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

**Wat je test: dat alles nog steeds bijwerkt.** Dit is een optimalisatie, dus het risico is
niet dat er iets stukgaat maar dat iets *stopt met verversen*. Open en sluit deze, kijk of de
inhoud klopt:

- Great Vault-advies
- delve-curio's
- wereldbaas
- de weekchecklist en de account-checklist
- het consumables-bord

⚠️ **Andy waarschuwt zelf voor één ding:** de twee checklists verversen niet meer terwijl hun
venster dicht is. Heropen je hetzelfde tabblad, dan kunnen ze een paar seconden achterlopen tot
de volgende quest- of currency-gebeurtenis. Dat is bekend en bedoeld — geen bug.

### 8. PR #2 — vensters die zichzelf openden zonder te vragen

Twee stukken. Het tweede heb je **iemand anders** voor nodig.

**a) Het bossvenster.** De aan/uit-knop werd alleen gelezen op de dungeon-route, dus het venster
ging in **rituals en raids** gewoon open terwijl jij hem uit had staan. Nu per soort instelbaar.

1. Zet in de instellingen het bossvenster uit.
2. Ga een **ritual** in. Blijft hij dicht?
3. Zet hem weer aan en kijk of hij in een dungeon nog wel komt.

📌 De dungeon-knop uitzetten schakelt nog steeds alle drie uit — dat is wat de omschrijving
belooft en dat hoort zo te blijven.

**b) Het consumables-bord.** Een groepsgenoot kan een verzoek sturen om het bord te tonen, en
jouw client opende het zonder naar jouw eigen instelling te kijken. Er is nu een opt-out onder
*Alerts & popups*.

Nodig: **je zus of Cisca in de groep.** Zet bij jou de opt-out aan, laat de ander het bord
oproepen, en kijk of hij bij jou dichtblijft.

### 9. 🔴 Vier talen beloven nu iets wat niet klopt

Andy hernoemde het label `SET_CONSREADY_TOGGLE_TITLE` omdat de tekst "bij binnenkomst in de
dungeon" zei terwijl de melding óók in rituals en delves komt. Het Engels is nu *"Show
consumable check on entry"*.

**Frans, Spaans, Portugees en Italiaans zeggen nog steeds "dungeon".** Duits en Nederlands zijn
goed. Dit is geen achterstand maar een onjuistheid, en hij staat in `docs/TRANSLATION_DRIFT.md`
bij de andere zeven.

Niets voor Rob om te testen — genoteerd zodat het niet als bugmelding terugkomt.
