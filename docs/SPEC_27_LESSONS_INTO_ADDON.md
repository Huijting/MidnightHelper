# Spec 27 — De zes lessen in de addon krijgen

**Van:** ONDERZOEK-sessie, 20 aug 2026
**Voor:** BOUW-sessie, ná de lopende release
**Bron-teksten:** `docs/COPY_*_BEGINNER.md` (zes bestanden)
**Voorwaarde:** de drie feitelijke reparaties uit de lopende release zijn gedaan.

---

## 1. Wat dit is

Zes beginnerslessen staan af als tekst en zijn **koud gelezen en goedgekeurd door Rob**. Ze
moeten nu van notitie naar spelscherm. Dit is de omzetklus, niet de schrijfklus.

| Les | Bestand | Bestaat het hoofdstuk al? |
|---|---|---|
| 1. Work orders | `COPY_WORKORDERS_BEGINNER.md` | **ja** — `workorders` |
| 2. Kennispunten | `COPY_PROFESSIONS_BEGINNER.md` | **ja** — `knowledge` + `trees` |
| 3. Kwaliteit | `COPY_QUALITY_BEGINNER.md` | **nee** |
| 4. De zes stats | `COPY_STATS_BEGINNER.md` | **nee** |
| 5. Concentration | `COPY_CONCENTRATION_BEGINNER.md` | **nee** |
| 6. Goud verdienen | `COPY_GOLD_BEGINNER.md` | **nee** |

Drie lessen **vervangen** dus bestaande hoofdstukken, drie zijn **nieuw**. Les 2 raakt er twee
tegelijk (`knowledge` en `trees`) — bepaal eerst of dat één hoofdstuk wordt of twee.

---

## 2. 🔴 Het probleem dat je als eerste moet oplossen: lengte

De bestaande `PROFACAD_CH_*_BODY`-teksten zijn **één tot twee alinea's**. De nieuwe lessen zijn
**800 tot 1500 woorden** met kopjes, tabellen en waarschuwingsblokken.

Ze passen niet zoals ze zijn. Er zijn drie uitwegen en dit is een ontwerpbeslissing, geen
implementatiedetail:

1. **Elke les opsplitsen in meerdere hoofdstukken.** Past bij de bestaande structuur (genummerde
   hoofdstukken met een taak per stuk), maar de reeks wordt dan ~15 hoofdstukken lang.
2. **Eén hoofdstuk per les, met scrollen.** `ProfessionAcademy.lua` heeft al een scrollframe.
   Minste werk, maar een muur tekst is precies wat we wilden vermijden.
3. **Kernversie in het hoofdstuk, de rest achter `advancedKey`.** Dat veld bestaat al en wordt
   door de `trees`-chapter gebruikt. Waarschijnlijk de beste balans.

⚠️ **Beslis dit vóór je begint te vertalen.** Achteraf splitsen betekent alle vertalingen opnieuw
indelen.

---

## 3. De structuur waar het in moet

Bestaand patroon in `Modules/ProfessionAcademyData.lua`:

```lua
{
    key      = "quality",
    titleKey = "PROFACAD_CH_QUALITY_TITLE",
    bodyKey  = "PROFACAD_CH_QUALITY_BODY",
    introKey = "PROFACAD_CH_QUALITY_INTRO",
    taskKey  = "PROFACAD_CH_QUALITY_TASK",
    detect   = "profui",
},
```

Optionele velden die al bestaan: `advancedKey`, `levelingKey`, `skillLineID`.

**Voorgestelde volgorde** (les 3-5 zijn de begripslaag, dus vóór de per-beroep-hoofdstukken):
`knowledge` → `trees` → **`quality`** → **`stats`** → **`concentration`** → `workorders` →
**`gold`** → de bestaande per-beroep-hoofdstukken.

**Detectie:** houd de bestaande conservatieve lijn aan. Alleen `TRADE_SKILL_SHOW` mag automatisch
afvinken; al het andere is een handmatig vinkje. Nooit een valse claim dat iets gedaan is.

---

## 4. Vertalen — en waar het misgaat

Werkwijze uit `CLAUDE.md`: eerst `enUS.lua` **en** `nlNL.lua`, daarna de andere vijf via
`Locales/Translations2026.lua` (fill-only, overschrijft nooit).

⚠️ **Dit is veel tekst.** Zes lessen × vijf talen is de grootste vertaalklus die dit project ooit
gehad heeft. Overweeg om **les 3, 4 en 5 eerst** te doen (die zijn tijdloos en kort) en les 6 pas
daarna.

**Niet vertalen** — geldt onverkort, en deze lessen zitten er vol mee:

- **Spel-labels tussen haakjes**: *Public Order*, *Personal Order*, *Guild Order*, *Patron Order*,
  *Specializations*, *Crafting Details*, *Use Best Quality Reagents*, *Search*, *Concentrate*.
  Die staan zo op de knoppen; vertalen maakt ze onvindbaar.
- **Spelbegrippen**: Knowledge Points, Concentration, Multicraft, Resourcefulness, Ingenuity,
  Finesse, Perception, Deftness, Work Order, Warband.
- **Eigennamen**: Theremis, Mar'nah, Captain Flaresworn, Camberon, Nocturnal Lotus,
  Wondrous Synergist, Silvermoon, The Coiled Isle.
- Het lidwoord vóór een Engelse naam volgt wél de taal ("der Coiled Isle", niet "the Coiled Isle").

**De schrijfregel die de vertaling moet overleven** — les 2 is hierop getest en gerepareerd:
**betekenis eerst, spel-label tussen haakjes erachter.** Nooit omdraaien. Een vertaler die
"Public Order (de openbare bestelling)" maakt, breekt precies wat de test bewees.

---

## 5. Les 6 heeft onderhoud nodig, de rest niet

`COPY_GOLD_BEGINNER.md` is als enige in **twee delen** geschreven:

- **Deel 1** — de manier van denken. Veroudert niet.
- **Deel 2** — wat nu verkoopt. **Veroudert binnen weken** en draagt daarom een datum.

Voer die splitsing door tot in de locale-keys, bijvoorbeeld `PROFACAD_CH_GOLD_BODY` en
`PROFACAD_CH_GOLD_CURRENT`. Dan is bij een hermeting één sleutel te vervangen zonder de rest aan
te raken, in alle zeven talen.

⚠️ **Zet de peildatum in de zichtbare tekst.** Een speler die in november leest dat "de raid net
open is", moet kunnen zien dat dat over augustus ging.

---

## 6. Vindbaarheid — dit is het punt, niet een extraatje

Drie keer op één dag bleek MH al te hebben wat Rob zocht, en hij vond het geen van drieën. Een
zevende hoofdstuk in een tab die niemand opent, lost dat niet op.

**Minimaal mee te leveren:** een regel in **This Week / Home** zodra
`C_Traits.GetTreeCurrencyInfo` **onbestede punten** ziet:

> *"Je hebt N onbestede knowledge points — MH kan uitleggen waar ze heen kunnen."* → klik opent
> het juiste hoofdstuk.

Onbestede punten zijn al leesbaar (`Modules/ProfessionNextStep.lua`), dus dit is een koppeling,
geen nieuwe meting. Zonder deze regel is de kans groot dat de hele cursus onopgemerkt blijft.

**En buiten de addon:** MH is op CurseForge onvindbaar bij zoeken op `professions`,
`knowledge points`, `concentration` en `work orders` — gecontroleerd 20 aug 2026. Die vier
woorden horen in `CURSEFORGE_DESCRIPTION.md`. Nul code, en het is waarschijnlijk de grootste
enkele winst in dit hele traject.

---

## 7. Wat er NIET in deze klus zit

- **De node-adviseur** (Spec 25). Dat is een aparte, grotere klus met een eigen datamodel.
- **De advies-routes voor de andere negen beroepen.** De gamedata ligt er (Spec 24/25), maar de
  goud-versus-guild-splitsing is alleen voor Alchemy en Herbalism uitgewerkt.
- **Nieuwe feiten verzamelen.** Alles staat in de specs; deze klus is omzetten, niet onderzoeken.

---

## 8. Klaar als

- De zes lessen staan als hoofdstukken in het spel, in `enUS` en `nlNL`.
- De vijf overige talen zijn gevuld via `Translations2026.lua`.
- Les 6 heeft een aparte, gedateerde sleutel voor het vergankelijke deel.
- De Home-regel voor onbestede punten werkt.
- Rob heeft ze in het spel gelezen en bevestigd dat ze net zo lopen als op papier.

Dat laatste is geen formaliteit: de teksten zijn getest als document, niet als scherm. Regels
die op papier werken kunnen op een smal paneel alsnog stukvallen.
