# Spec 26 — Work Orders (Crafting Orders)

**Van:** ONDERZOEK-sessie, 20 aug 2026
**Aanleiding:** Rob, letterlijk: *"ook daar word ik gek van, en snap er nog minder van"*.
**Bron:** twee onderzoeken, met als hardste bron de **client-strings (`GlobalStrings`) uit
wago.tools, live build `12.1.0.69382`** (18 aug 2026) — dat is letterlijk wat het spel op het
scherm zet — aangevuld met Wowhead-gidsen (12.1.0-getagd), Icy Veins (S2-update 6 aug) en
`CurrencyTypes`/`Profession - Public Order Capacity` uit dezelfde build.

---

## 1. Het concept, en waarom onze uitleg het mist

Onze huidige tekst begint meteen bij de vier soorten. Dat is de invulling, niet het idee.
De speler snapte het pas bij deze formulering:

> **De veiling verkoopt spullen. De order-tafel verkoopt iemands vakmanschap.**

De reden dat het systeem bestaat: de beste gecrafte uitrusting is **soulbound** — die kan niet
vooraf gemaakt en op de veiling gelegd worden, dus moet iemand hem **speciaal voor jou** maken.
Jij levert de materialen, de crafter levert zijn specialisatie, jij betaalt voor het werk.

**Zet dat vooraan.** Zonder dat blijven de vier soorten losse feiten.

---

## 2. 🔴 Drie fouten in `PROFACAD_CH_WORKORDERS_BODY`

| # | Onze tekst | Werkelijkheid |
|---|---|---|
| 1 | *"bij Captain Flaresworn"* | **Fout.** Flaresworn staat er wél (Bazaar, 45.01/55.18) maar is `<Requisitions Officer>`: intro-quest, weekquests, gratis materiaalzakjes. De **crafting-order-klerk is `Mar'nah`** (npc 243279), tafel op ± `45.0 / 55.6`, gouden hamer op de minimap. |
| 2 | *"maximaal 4 public orders per dag"* | **Misleidend.** Het is een **voorraad van 4 claims die met 1 per 24 uur bijvult** — dus ±7 per week, niet 28. Geverifieerd in client-data: `Profession - Public Order Capacity` → `MaxQty = 4`, `RechargingAmountPerCycle = 1`, `RechargingCycleDurationMS = 86400000`. ⚠️ Icy Veins (6 aug 2026) schrijft "4 per day" en zit fout. |
| 3 | *"je kunt een minimumkwaliteit vragen"* (in de koop-alinea, die over Public/Personal gaat) | **Fout voor Public.** Kwaliteit is alleen instelbaar bij **Patron, Guild en Personal**. Wowhead 12.1.0: *"If you place a Public work order, you get what you get — any quality will count for completion!"* |

---

## 3. 🔴 Wat er ontbreekt en de speler laat vastlopen

**Dit is nummer één van "waarom zie ik niks":**

> `PROFESSIONS_ORDERS_MUST_BE_NEAR_TABLE` = *"You must be near a Crafting Table for your
> profession to access Crafting Orders."*

**Bestellen** doe je bij de klerk. **Zelf orders maken** doe je bij de **crafting table van je
eigen beroep**. Sta je daar niet vlakbij, dan bestáát dat tabblad niet. Dat geldt óók voor
Patron Orders — jarenlang de best-gestemde comment op Wowhead.

**Nummer twee: vier verschillende redenen waarom een order geblokkeerd is**, en de client heeft
er aparte teksten voor:

- `PROFESSIONS_CRAFTER_CANT_CLAIM_UNLEARNED` — je kent het recept niet
- `PROFESSIONS_CRAFTER_CANT_CLAIM_REAGENT_SLOT` — *"You have not unlocked the necessary Optional
  Reagent Slots"* → **je specialisatie is nog niet ver genoeg**; dit koppelt direct aan Spec 25
- minimumkwaliteit te hoog
- `PROFESSIONS_ORDER_FAILED_NO_CLAIMS` — claims op

**Nummer drie: het wordt soulbound.** `PROFESSIONS_ORDER_UNUSABLE_WARNING` waarschuwt bij het
bestellen. ➡️ **bestel op het personage dat het gaat dragen.**

---

## 4. Patron Orders — het KP-systeem, en de val erin

- **Alleen voor crafting-professies.** Alchemy wel, Herbalism niet. Gathering heeft *Side
  Gathers*: 5× +1 per week, en daarná pas `Thalassian Phoenix Tail` (+3) → **8 KP/week**.
- Ontgrendeld via de intro-quest van Flaresworn (Alchemy: quest 93724), **character level 80**.
- Nieuwe batch **elke ~3-4 dagen**; elke order heeft een **eigen** afloopdatum en een
  **willekeurige minimumkwaliteit**.
- Beloning: `Glimmer of … Knowledge` = **+2 KP**, `Flicker` = **+1 KP** (item-tooltips uit de
  client — doorslaggevend; Wowheads eigen KP-gids zegt ten onrechte "+1 or +3").

### 🔴 De timing-val — dit kost punten zonder dat er iets misgaat op het scherm

Het inhaalsysteem is een **bodem naar het plafond toe**, geen bonus erbovenop. De dagelijkse
+1 Flicker-orders verschijnen **alleen zolang je onder het weekplafond zit**.

Wie maandag meteen alle +2 Glimmers doet, zit op het plafond en krijgt de rest van de week
**geen** +1's meer. Wie de dikke orders laat staan tot vlak vóór hun deadline, blijft ze
dagelijks krijgen — en eindigt hoger.

➡️ Dit is precies het soort onzichtbare mechaniek waar MH voor bestaat. Spelers vinden het
terecht slecht ontworpen, maar zo werkt het.

**Realistische weekopbrengst Alchemy:** ~12–16 uit Patron Orders + 4 (treasures) + 1–3
(trainer-weekly) + 1 (Treatise) ≈ **19 KP**. ⚠️ De "16–24" uit eerder onderzoek is **niet hard
te maken**: Wowhead zegt 15, Method 16–24, wow-professions ~12, spelersmetingen 12+.

---

## 5. Materialen — de duurste fout in het systeem

| Ordertype | Wie levert | Kwaliteitseis | Limiet |
|---|---|---|---|
| **Public** | **altijd de besteller, 100%** | nee | voorraad 4, +1/24u |
| **Personal** | alles / deels / **niets** | ja | geen |
| **Guild** | alles / deels / **niets** | ja | geen (en **cross-realm**) |
| **Patron** | alles / deels / **niets** | **altijd** | weekplafond |

Wowhead zet er zelf een uitroepteken bij: *"Always double-check whether you'll be crafting with
provided materials or your own!"* De client waarschuwt met
`CRAFTING_ORDERS_OWN_REAGENTS_CONFIRMATION`.

Twee vaste regels erbij:
- **Soulbound reagentia levert de crafter nóóit** — in S2 is dat `Spark of Tides` (2 per stuk,
  4 voor tweehandwapens). Die moet de besteller meesturen.
- `CRAFTING_ORDER_FAILED_ACCOUNT_ITEMS` — **materiaal uit de Warband bank werkt niet** in orders.

---

## 6. Overige mechaniek die in de tekst hoort

- **30 minuten** na *Start Order*, anders terug in de wachtrij. Bevestigd.
- **Bijna verlopen orders kosten geen claim** (`PROFESSIONS_ORDER_ABOUT_TO_EXPIRE`).
- **Eén order tegelijk** actief.
- **Public orders zijn realm-gebonden**; guild orders niet.
- **De public-lijst laadt pas na op Search drukken** (praktijktip, ongedateerde bron).
- **Commissie is verplicht** (`PROFESSIONS_ORDER_MUST_TIP`), looptijd **12–48 uur**, en de
  **Gavel-knop** toont vergelijkbare orders = het markttarief.
- De crafter **ziet zijn opbrengst vóór accepteren**; er gaat een `CRAFTING_ORDER_CONSORTIUM_CUT`
  vanaf.
- **Vergeten *Complete Order*** kost niets — de Consortium stuurt het item mét commissie op.
- **Recrafting kan alleen via Personal orders**, en `CRAFTING_ORDER_RECRAFT_WARNING1` waarschuwt
  dat de **kwaliteit omláág kan**.
- **Concentration**: max 1000 per beroep, ±250/dag bij (client-tekst; Wowhead zegt 240 — schrijf
  "ongeveer 250"). Nooit verplicht, maar vaak de enige manier om een minimumkwaliteit te halen.
  De **besteller** krijgt het betere item, de **crafter** betaalt uit een balk die dagen nodig
  heeft.

---

## 7. ⛔ Niet encoderen

1. **Het percentage van de Consortium Cut.** De enige beschrijving is een Blizzard-post uit
   Dragonflight (2022). Geen 12.x-bron bevestigt het. Toon de knop, noem geen getal.
2. **`Crafter's Mark`** — dat is **Shadowlands (9.x)**. In Midnight regel je item level met
   Sparks en crests. **Moet nergens in de tekst staan.**
3. **Een hard aantal Patron Orders per week.** Alleen "a handful every few days" is gepubliceerd.
4. **Het weekplafond aan KP** waar het inhaalsysteem tegenaan loopt — staat niet in de
   currency-data (`MaxEarnablePerWeek = 0`) en is nergens gepubliceerd.
5. **"3 patron orders per dag / 21 per week"** — dat cijfer komt uit een TWW-opiniestuk dat een
   Reddit-comment citeert. Niet geldig voor 12.1.
6. **Wie Multicraft-procs op een order houdt** — alleen community-consensus (besteller krijgt
   de extra's, crafter houdt Resourcefulness). Geen blue post.

✅ **Wél hard, uit `CurrencyTypes` in de client:** Artisan's Moxie (ID 3256–3266) heeft
`MaxQty = 0` en `MaxEarnablePerWeek = 0` → **geen cap, geen weeklimiet**. En Moxie is in Midnight
**per beroep**, niet gedeeld.

---

## 8. Nog een plek met de achterhaalde respec-zin

`docs/PROFESSIES_EN_WORK_ORDERS_UITLEG.md` bevat nog *"permanent — niet terug te vragen."*
Dat is de **derde** vindplaats, naast `PROFACAD_CH_TREES_BODY` (Spec 23 §2) en de eerder
gemelde. Zelfde correctie, zelfde waarschuwing: **niet simpelweg schrappen** — één reset per
beroep bij Theremis, en die ontleert je KP-recepten.

---

## 9. Bestanden

- `Locales/*.lua` (7×) — `PROFACAD_CH_WORKORDERS_BODY`
- `docs/PROFESSIES_EN_WORK_ORDERS_UITLEG.md` — §8
- `Modules/ProfessionAcademyData.lua` — hoofdstuk `workorders` (structuur ongewijzigd)

---

## 10. Methodenotitie voor volgende keer

**`GlobalStrings` uit wago.tools is voor UI-gedrag de hardste bron die er is** — harder dan
elke gids, want het is letterlijk de tekst die het spel toont. Elke keer dat de gidsen elkaar
tegenspraken over een limiet of een voorwaarde, gaf een client-string het antwoord in één regel.
Gebruik dit standaard bij vragen van de vorm "waarom kan ik dit niet" of "hoeveel mag ik".
