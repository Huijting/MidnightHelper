# Spec 24 — Audit van alle profession-routes

**Van:** ONDERZOEK-sessie, 20 aug 2026
**Voor:** BOUW-sessie
**Aanvulling op:** `SPEC_23_PROFESSION_ADVISOR.md` (Alchemy + Herbalism)
**Methode:** acht parallelle onderzoeken, elk met dezelfde bronregels (geen boost-/SEO-sites,
12.x streng gescheiden van 11.x, URL + datum per bewering, tegenspraken expliciet melden).

---

## De uitkomst in één regel

**Alle elf routes in `advisorRoutes` zijn fout of ernstig incompleet.** Negen zijn in deze
ronde nagekeken, twee in Spec 23. Er is er geen enkele die blijft staan zoals hij is.

---

## 1. Per profession

| # | Profession | Oordeel | De kern |
|---|---|---|---|
| 164 | **Blacksmithing** | fout + **verzonnen bron** | `Craftsmithing` staat als stap 3 met een broncommentaar dat naar wow-professions verwijst. Die pagina noemt Craftsmithing **niet** in de Standard build. `The Old Ways` hoort vooraan (twee bronnen), niet als tweede blok. |
| 165 | **Leatherworking** | fout + **spreekt zichzelf tegen** | `advisorRoutes` zegt armor-tak eerst; `PROFACAD_CH_LEATHERWORKING_BODY` zegt letterlijk *"Learned Leatherworker first"*. Op 24 juli is de route omgedraaid en de tekst niet. Beide zijn zichtbaar voor dezelfde speler. |
| 186 | **Mining** | incompleet | Volgorde klopt, maar de **gratis ontgrendeling van `Over-LODED`** ontbreekt (kost nul punten, verkort de Overload-cooldown fors) en de sub-node-laag binnen `Plentiful Ores` ontbreekt. |
| 197 | **Tailoring** | fout | `PROFGUIDE_LVL_TAILORING` adviseert **"5 points into Nimble Needlework"** — dat getal staat in geen enkele bron; het is ~20 in de root. De `anyOf` tussen `Sin'dorei Finery` en `Fiber Arts` verbergt juist de keuze waar alles om draait (guild vs goud). `Fabric Specialist` staat omschreven als "losse punten", maar bevat een multicraft-node voor álle recepten. |
| 202 | **Engineering** | **ernstigste fout** | `Recycling` stond laatst omdat we het voor een efficiency-tak aanzagen. Het is de **recepten-motor**: in Midnight ontdek je het merendeel van je recepten door te recyclen, en dat staat **uit** tot je er punten in stopt. Onze route zet de speler dus in een dood spoor en laat hem concluderen dat recyclen kapot is. |
| 333 | **Enchanting** | omgekeerd | `Disenchanting Delegate` stond laatst, hoort eerst. Disenchanten negeert **alle** craft-stats en kijkt alleen naar ruwe Skill — dus onze eerste ~50 punten (`Spellbound Shatterer`) doen nul voor de helft van de profession die zonder AH-concurrentie geld oplevert. |
| 755 | **Jewelcrafting** | incompleet | `Alluring Accessories` (ringen, kettingen, beroepsgereedschap) ontbrak volledig — precies de boom voor jezelf en de guild. Bovendien: **gems zijn niet meer de automatische goudmijn**, want in Midnight bestaat geen socket-toevoegend voorwerp meer (alleen de Great Vault). Stap 2 is dus een echte keuze, geen default. |
| 773 | **Inscription** | volgorde onuitvoerbaar | Wij adviseren `Perfected Products` vóór `Blueprints`, maar Blueprints gaat op skill 50 open en Perfected Products pas op 60. **Spellingkwestie opgelost:** het is `Perfected Products` (Wowhead trait 109660); de sub-takken heten wél "Perfect ..." en één gids liet de -ed weg. De dubbele `anyOf`-spelling kan eruit. |
| 393 | **Skinning** | fout, zelfde patroon als Herbalism | De hele sub-spec-laag ontbreekt (`Trophy Taker`, `Majestic Materials`, `Lasting Leather`/`Superb Scales`). `Talented Tracker` op plek 3 is fout voor een goudspeler — dáár zitten de duurste materialen. En `ProfessionGuidedData.lua:142` adviseert **twee messen wisselen** (Finesse-mes / Perception-mes); geen enkele bron dekt dat. |

Alchemy (171) en Herbalism (182): zie Spec 23.

---

## 2. Wat er structureel mis is — belangrijker dan de negen losse fouten

### a) Ons datamodel zit één niveau te grof

`advisorRoutes` adviseert op **boom**-niveau (`{ tree = "..." }`). Vrijwel alle waarde zit een
niveau dieper: in **sub-specs** en in **drempels**. "Ga naar Bountiful Harvests" helpt niet;
"20 punten in Mulching geeft je een gegarandeerde Nocturnal Lotus per uur" wel.

Elk van de negen rapporten kwam hier onafhankelijk op uit. Zonder een sub-node-laag blijft de
adviseur een inhoudsopgave.

### b) Eén beginnersfout komt bij ALLE elf professions terug

**Punten uitsmeren over meerdere bomen.** Alles wat ertoe doet zit achter een drempel; vier
halfvolle bomen leveren nul drempels op. Vier bronnen zeggen dit letterlijk, in verschillende
bewoordingen, voor verschillende professions.

📌 **Dit is de waardevolste zin die MH hier kan tonen**, en hij geldt overal. Toon hem één keer
prominent in plaats van elf keer verstopt.

### c) Twee verzinsels staan al sinds 24 juli in de code

- Blacksmithing stap 3 (`Craftsmithing`) met een bronvermelding die hem niet dekt.
- Tailoring `"5 points into Nimble Needlework"` — een getal zonder bron.

Beide zien eruit als degelijk onderbouwd advies. Dat is precies waarom ze gevaarlijk zijn.

### d) De bronnen zelf zijn een mijnenveld

- **Wowhead spreekt zichzelf tegen bij Enchanting**: een standaardtabel zegt dat disenchanten
  Multicraft/Resourcefulness/Ingenuity gebruikt, de proza eronder zegt het tegenovergestelde.
  Onze foute route komt vrijwel zeker uit die tabel.
- **Naamsbotsingen met TWW**: `Flawless Fortes` en `Learned Leatherworker` bestaan in béide
  uitbreidingen. Onze code is hier veilig (`C_ProfSpecs.GetSpecTabIDsForSkillLine` is op de
  Midnight skill line gescoped), maar bronnen zijn dat niet.
- **wow-professions.com heeft geen publicatiedatums.** Het is inhoudelijk de beste bron voor
  builds, en tegelijk niet op actualiteit te controleren.
- **Bijna geen enkele spec-gids is herzien ná 11 aug 2026.** Dat is minder erg dan het lijkt:
  12.1 heeft de bomen niet herbouwd, alleen recepten toegevoegd. Maar het betekent wel dat
  niemand de Season 2-economie in de builds verwerkt heeft.

### e) 🔴 Naamsbotsing BINNEN Midnight — `Lasting Leather` bestaat twee keer

Een verdiepende controle op de trait-database vond dit:

- **trait 107889 `Lasting Leather`** = Leatherworking (*"Improve at making leather armor…"*)
- **trait 106088 `Lasting Leather`** = **Skinning** (*"…gaining +1 Skill while skinning leathery
  creatures…"*)

Onze routes matchen op **naam**. Beide professions krijgen in de gecorrigeerde routes een stap
met exact deze naam. Dat is nu veilig — `Profession.lua` gebruikt
`C_ProfSpecs.GetSpecTabIDsForSkillLine(midnightSkillLineID)` en is dus per skill line gescoped —
maar het is een verborgen valstrik voor elke toekomstige lookup die dat níét doet.
**Zet er een commentaarregel bij zodat niemand dit per ongeluk versimpelt.**

### f) Correctie op mijn eigen Leatherworking-rij hierboven

De verdiepende controle ontkracht de veronderstelde tegenspraak over unlock-niveaus:

- De reeks **25/50/60/75 per boom is nergens gesteld** — het is een gevolgtrekking uit de
  volgorde van opsommingstekens op één ongedateerde pagina. Behandel de toewijzing
  boom→skillniveau als **niet gevonden**.
- Wat wél bevestigd is: **onder skill 25 kun je überhaupt geen punten uitgeven** (warcraft.wiki),
  en method.gg zegt expliciet dat `Learned Leatherworker` al op skill 25 kiesbaar is — dus het
  advies "Learned Leatherworker eerst" is **niet** dood advies, zoals ik hierboven suggereerde.
- De 5-vs-10-tegenspraak is opgelost en is geen tegenspraak: **5 punten in de root opent de
  eerste sub-spec, 10 punten extra de tweede.** Beide getallen zijn correct, op verschillende
  momenten.
- **Embellishments zijn NIET aan `Flawless Fortes` toe te schrijven** door enige bron. Niet
  aannemen.

---

## 3. ⛔ Wat NIET geëncodeerd mag worden

1. **Exacte puntenaantallen.** Bij élke profession spraken de bronnen elkaar tegen, vaak met
   een factor 2 (Blacksmithing root: 30 vs 15. Tailoring: 20 vs 30. Mining: 40 vs 50).
   Toon ze hooguit als "ongeveer", altijd met: **lees de in-game tooltip, die toont X / Y**.
2. **Stat-rankings.** Economisch oordeel, geen feit.
3. **Skinning: villen vanaf een mount.** Bestaat niet — expliciet gezocht en niet gevonden.
   Als onze tekst iets in die richting suggereert, moet het eruit.
4. **Leatherworking "drums"** in `PROFACAD_CH_LEATHERWORKING_BODY` — niet te bevestigen in
   een 12.x-bron.
5. **Skinning "twee messen wisselen"** (`ProfessionGuidedData.lua:142`) — niet gedekt.

---

## 4. Voorgestelde volgorde van werken

1. **De zelftegenspraak bij Leatherworking** (route vs hoofdstuktekst). Een addon die zichzelf
   op één scherm tegenspreekt, ondermijnt alles wat hij verder zegt.
2. **De twee verzinsels** (Blacksmithing `Craftsmithing`, Tailoring `5 points`).
3. **Engineering `Recycling` naar voren** — dit is de enige fout die de speler actief in een
   dood spoor duwt.
4. **Enchanting omdraaien.**
5. De rest van de routes.
6. **Daarna pas** de sub-node-laag (§2a). Dat is de grote klus en hij verdient een eigen spec.

---

## 5. Bestanden

- `Modules/ProfessionAcademyData.lua` — `advisorRoutes` (alle elf), `chapters`
- `Modules/ProfessionGuidedData.lua` — regel ~34 (Blacksmithing/Craftsmithing), ~109
  (Tailoring), ~140-142 (Skinning)
- `Locales/*.lua` (zeven bestanden) — `PROFACAD_CH_*_BODY`, `PROFGUIDE_LVL_*`

⚠️ Een onderzoeker heeft tijdens deze ronde eigenhandig `advisorRoutes[755]` aangepast. Dat is
**teruggedraaid** — `Modules/` is van BOUW (zie `COORDINATION.md`, regel 1). De inhoud van die
wijziging staat hierboven in de Jewelcrafting-rij; er is niets verloren.
