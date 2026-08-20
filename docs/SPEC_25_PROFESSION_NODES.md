# Spec 25 — Profession-adviseur op node-niveau

**Van:** ONDERZOEK-sessie, 20 aug 2026
**Vervangt de datakant van:** `SPEC_23_PROFESSION_ADVISOR.md` en `SPEC_24_PROFESSION_ROUTES_AUDIT.md`
(die blijven geldig voor de *volgorde*-adviezen en de audit-bevindingen)
**Bron:** Blizzards eigen DB2-tabellen, build **`12.1.0.69382`** (aangemaakt 18 aug 2026,
bevestigd als de nieuwste live `wow`-build), aangevuld met Wowheads tree-calculator voor de
getallen die DB2 niet bevat, en geijkt tegen Robs eigen client.

---

## 1. Waarom dit een aparte spec is

Spec 24 stelde vast dat `advisorRoutes` **één niveau te grof** is: het adviseert op boom-niveau
("ga naar tak X") terwijl vrijwel alle waarde in de **sub-takken** en de **drempels** zit.

Dit is de datakant daarvan, en het is geen gidsverzameling meer: elf professions,
~250 nodes, met per node de maximale rang en het puntenaantal waarop elk effect valt —
uit de gamedata.

---

## 2. 🔴 Lees dit eerst: er zijn TWEE soorten "punten"

Zonder dit is elke drempel in dit document verkeerd te lezen.

`TraitCond` heeft een veld **`TraitCurrencyID`**, en dat bepaalt de betekenis:

| Type | Wat het is |
|---|---|
| **Type 1** (bv. 3989 bij Jewelcrafting) | échte **knowledge points** |
| **Type 2** (`CurrencyTypesID 0`) | interne **ontgrendel-tokens**, uitgedeeld door de oudertak wanneer die je "learn a sub-specialization of your choice" geeft |

**Gevolg:** een regel op `SpentAmountRequired = 1` betekent meestal **niet** "kost je eerste
knowledge point". Bij Jewelcrafting staat dat bij **31 van de 35 nodes** op een Type 2-token —
de bonus vuurt zodra je de tak *leert*, met **nul** knowledge points erin.

De uitzondering: de vier JC-ertsnodes staan wél op de echte munt.

⚠️ **Deze fout is in dit onderzoek twee keer gemaakt** (één agent las alles als "gratis",
een ander als "kost je eerste punt", beiden zonder de munt te checken). Wie deze data ooit
opnieuw ophaalt: **check `TraitCurrencyID`, niet alleen `SpentAmountRequired`.**

---

## 3. Omvang per profession

| Profession | Nodes | Bijzonderheden |
|---|---|---|
| Alchemy | 22 | roots 30, sub-takken 20 — volstrekt regelmatig |
| Herbalism | 14 | **alles 40**, zonder uitzondering |
| Mining | 12 | `Rich Deposits` en `Seams` zijn **35** — wijkt af van elke andere gathering-node |
| Skinning | 10 | — |
| Blacksmithing | 30 | `The Old Ways` is de enige BS-root met max **40** |
| Leatherworking | 32 | de twee armor-bomen zijn structureel identiek |
| Tailoring | 26 | — |
| Enchanting | 27 | vier **aparte** traitTrees (1152–1155), 650 punten totaal |
| Engineering | 21 | 540 punten totaal (niet de 570 die rondzwerft) |
| Inscription | 35 | `Calm Hands` max **10**, niet 30 |
| Jewelcrafting | 35 | drie niveaus diep; 12 stat-gemnodes van max 15 |

---

## 4. De patronen die overal terugkomen

Dit is het deel dat in de addon hoort, belangrijker dan de losse getallen.

### a) Recepten zitten aan het LEREN van een tak, niet aan het volmaken

Bij vrijwel elke blad-node krijg je het recept zodra de tak opengaat. Twaalf slot-nodes bij
Leatherworking, negen bij Blacksmithing, negen bij Tailoring, twaalf gem-nodes bij
Jewelcrafting — allemaal hetzelfde.

**Dat draait de vraag om.** Niet "hoeveel punten moet ik hierin stoppen", maar
**"wat kost het om deze tak te openen"**. De punten daarna kopen kwaliteit, niet toegang.

### b) Er bestaat een categorie SCHAKELAARS

Nodes die iets aanzetten dat daarvoor letterlijk uit stond. Wie ze overslaat, concludeert dat
het spel kapot is:

- **Engineering `Recycling`** — recyclen ontdekt pas recepten vanaf **10 punten in de root**
- **Tailoring `Sunfire Silk Weaving` / `Arcanoweaving`** — vijanden laten de dure stof pas
  vállen als je deze takken leert
- **Tailoring `Fabric Specialist` @10** — voorwaarde waaronder hoge-kwaliteit stof kán vallen
- **Mining `Over-LODED`** en **Herbalism `Midnight Overload`** — leren geeft de Overload-ability
- **Skinning `Thorough Tanning`** — leren geeft `Sharpen Your Knife`
- **Herbalism `Mulching`** — leren geeft `Magical Mulch`

### c) Drempels volgen de maxRank van de node, niet een vaste ladder

maxRank 10 → kinderen op 1/5/10 · maxRank 25-root → 1/5/15/25 · maxRank 30-root → 5/15/25.
**Extrapoleer nooit** van de ene profession naar de andere; Inscription, Enchanting en
Engineering hebben alle drie een ander schema.

Praktisch gevolg dat geen gids noemt: bij een 30-root heb je **25** punten nodig voor alle drie
de sub-takken. De laatste vijf kopen alleen de eindbonus.

### d) De grootste sprongen staan onderaan een volle tak

BS `The Old Ways` @40 · LW `Learned Leatherworker` @30 (+45 Ingenuity) ·
LW `Mastering Multicraft` @25 (+60 Multicraft) · Enchanting `Excellent Expendables` @15
(+60 Multicraft).

Dat is de **mechanische onderbouwing** van de belangrijkste beginnersregel: punten uitsmeren
levert nul drempels op.

---

## 5. Datamodel — verplicht op ID, niet op naam

Namen botsen. Bewezen gevallen:

- `Lasting Leather` = Leatherworking **107889** én Skinning **106088** — **binnen Midnight**
- `Flawless Fortes`, `Learned Leatherworker`, `Botany`, `Cultivation`, `Mulching`,
  `Bountiful Harvests`, `Trophy Taker`, `Rich Deposits`, `Seams` bestaan óók in TWW met
  andere ID's
- `wowhead.com/profession-traits/blacksmithing` toont 92 traits waarvan er **30** Midnight zijn

Gidsen spellen bovendien inconsistent: `Perfected Products` vs "Perfect Products",
`Flawless Fortes` vs "Flawless Forte", `Bountiful Harvests` vs "Bountiful Harvest".

➡️ **Sla trait-ID op. De naam is er voor de mens, niet voor de lookup.**
Midnight-ID-bereiken: Herbalism 104419–104707 · Mining 105473–105568 · Skinning 106056–106119 ·
BS/Tailoring 104204–104633 · LW 107812–107993 · Alchemy 107101–107284 · Enchanting 107614–107769 ·
Engineering 106711–110352 · Inscription 109656–109660 e.o. · JC 106884–107059.

---

## 6. De data zelf: reproduceren, niet overtypen

**Neem de ~250 nodes NIET met de hand over uit onderzoeksrapporten.** Dat is precies de fout
die Spec 24 bij drie andere partijen aantoonde. Haal ze op:

**Bron 1 — wago.tools (DB2, geen rate limit, geeft het buildnummer):**
```
SkillLineXTraitTree      SkillLineID -> TraitTrees (elke spec is een eigen boom)
TraitNode                Type=1 = benoemde nodes, Type=0 = perk-pips
TraitNodeEntry           NodeEntryType 7 -> maxRank ; type 9 -> de leer-entry
TraitNodeXTraitCond -> TraitCond.SpentAmountRequired  -> de drempel
                    -> TraitCond.TraitCurrencyID      -> §2: type 1 of 2!
TraitNodeGroupXTraitNode ouder-kindrelatie (niet raden)
SpellName                recept-ID -> naam
```
⚠️ DB2 bevat de **structuur en de drempels**, maar niet de **getallen** — teksten staan er met
`$ev1`-placeholders en `TraitDefinitionEffectPoints` heeft geen rijen. Voor "+15 Resourcefulness"
is Wowheads calculator nodig.

**Bron 2 — Wowhead tree-calculator**, `window.g_listviews[…].data` op
`wowhead.com/profession-tree-calc/<beroep>`. Alleen vanuit een echte browsersessie; via proxy
krijg je een bot-shell. Wowhead blokkeerde tijdens dit onderzoek een hele sessie lang (18/18 × 403).

**Bron 3 — de client zelf**, `/mh nodes` (`ns.PrintProfessionNodeProbe`), voor de professions die
de speler heeft. Dit is de ijking: de calculator gaf voor Herbalism **exact** dezelfde 14 nodes
met dezelfde maxima als Robs client. Daarmee is bron 2 bewezen voor professions die niemand
van ons heeft.

---

## 7. 🔴 Bevinding over onze eigen probe

`/mh nodes` slaat een **`desc`** op die niet de tooltip is die de speler ziet:

- getallen ontbreken — *"Increase efficiency while crafting Sin'dorei flasks by gaining."*
- twee nodes hebben een **lege** beschrijving (`Clever Creations`, `Ingenious Libations`)
- de tekst **wijkt af** van Wowheads tooltip voor dezelfde node (Potion Prowess: *"Leverage the
  diametric power…"* versus *"Bottle the essences…"*)

**Bouw het uitlegpaneel hier niet op** — dan lezen spelers halve zinnen. De probe moet de
volledige tooltip vastleggen. Welke van de twee teksten in het spel zichtbaar is, is nog niet
vastgesteld.

---

## 8. ⛔ Niet encoderen

1. **Skill-niveaus per boom** (25/50/60/75). De reeks circuleert, maar **welke boom bij welk
   niveau hoort staat nergens** — het is een gevolgtrekking uit de volgorde van bullets op één
   ongedateerde pagina. DB2 bevat geen skill-eis per tree. Bij vier professions apart
   vastgesteld als "niet gevonden".
2. **Percentages en proc-kansen** die alleen in gidsproza staan.
3. **Effectgetallen uit DB2** — die staan er niet in (§6).
4. **`Imbued Mulch` cooldown** — method.gg zegt 1 uur; de wiki noemt geen cooldown. Onbevestigd,
   en het draagt het advies "~1 Nocturnal Lotus per uur".
5. **Wondrous Synergist 18u → 9u** bij 20 punten in Synthesis Synergy — één ongedateerde bron.

---

## 9. Wat 12.1 hier verandert: niets

Live 12.0.7 en PTR 12.1.0 zijn voor **alle** gecontroleerde bomen identiek — zelfde node-ID's,
zelfde maxima, zelfde drempels. Apart bevestigd voor de armor-crafters (88 nodes), de
gathering-professions (36 nodes) en Engineering. 12.1 voegt recepten toe en geeft de eenmalige
reset bij Theremis; de bomen zijn niet herbouwd.

Daarmee blijven de 12.0-spec-gidsen structureel bruikbaar — hun **getallen** waren al fout, en
dat had niets met de patch te maken.
