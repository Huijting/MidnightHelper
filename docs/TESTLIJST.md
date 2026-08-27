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

## ⚪ Wacht op iets anders

### 5. Andy's twee pull requests — nog NIET binnengehaald

Staan open op GitHub, dus ze zitten **niet** in Robs client. Pas testbaar na mergen.

- **#1 "Stop hidden panels from processing events"** — vier onderdelen bleven rekenen met hun
  venster dicht. Testen: Vault, delve-curio's, wereldbaas, checklist, consumables-bord. Hij
  waarschuwt zelf dat de twee checklists even kunnen achterlopen bij heropenen.
- **#2 "Settings for windows that open by themselves"** — het bossvenster negeerde je
  uit-standje in rituals en raids; het consumables-bord ging open als een groepsgenoot dat
  wilde. Testen: allebei uitzetten en kijken of ze dan écht dichtblijven.
