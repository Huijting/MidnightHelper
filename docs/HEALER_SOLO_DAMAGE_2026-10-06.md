# Healers: zo vecht je alleen (onderzoek 6 okt 2026)

Vraag van Rob (Resto Druid, open wereld): *"ze verwachten dat je af en toe meevecht … hoe weet ik welke knop ik moet gebruiken?"*
Doel: per healer-spec een kaartje "Zo vecht je alleen" met 3-5 stappen, en de toets van de speler erachter.

Alleen onderzoek. Er is geen code, locale of data aangeraakt.

## Hoe je dit leest

- **GEMETEN (G)** = zelf gezien in een genoemde bron met datum of buildnummer.
- **AFGELEID (A)** = mijn redenering. Niet in het spel getest.
- **Basis** = de spec heeft de spreuk zonder talentpunt: geen TraitDefinition-rij, wel SkillLineAbility of SpecializationSpells (G).
- **Talent, gratis** = talentknoop met een "granted"-voorwaarde voor deze spec (TraitCond GrantedRanks=1) (G). Dat dit "gratis" betekent is A.
- **Talent, starter** = de knoop zit in Blizzards standaardindeling voor deze spec (TraitTreeLoadout / TraitTreeLoadoutEntry) (G). Dat dit de "Starter Build" uit het spel is, is A.
- **Talent, keuze** = talent dat niet gratis is en niet in de standaardindeling zit (G). Op het kaartje staat dan "als je hem hebt".
- **MH-toets** = de plek in het standaardblok, uit `data/keyblock_specs.json` (bestand van 6 okt 12:34) (G).
- **In KeybindRoles** = ja/nee, gelezen in `Modules/KeybindRoles_<Klasse>.lua` (G; de bestanden heb ik helemaal gelezen).
- Alle spell-ID's en namen komen uit **wago.tools DB2, build 12.1.0.69933** (SpellName, via het browservenster) (G).

## De hardste bron: Blizzards eigen Single-Button Assistant

In de DB2-tabellen `AssistedCombat` en `AssistedCombatStep` (build 12.1.0.69933) staat de schade-volgorde die Blizzards **Single-Button Assistant** (spell 1229376) per spec gebruikt (G).
Alle 7 healer-specs krijgen die knop via SpecializationSpells (G). Het is precies het antwoord op Robs vraag, gemaakt door Blizzard zelf.

| spec | AssistedCombatID | volgorde in de DB2 (OrderIndex 0 → hoog) (G) |
|---|---|---|
| Resto Druid 105 | 52 | Mark of the Wild · Rip · Ferocious Bite · Thrash · Swipe · Rake · Shred · Sunfire · Moonfire · Starsurge 197626 · Starfire 197628 · Wrath · Moonfire |
| Holy Paladin 65 | 51 | Consecration · Judgment 275773 · Hammer of Wrath (4×, elk met een voorwaarde) · 216331 Avenging Crusader · Holy Shock · Consecration · Judgment |
| Disc Priest 256 | 44 | PW: Fortitude · Shadow Word: Pain · Mind Blast · Penance · Smite · Shadow Word: Death · Holy Nova · Smite · Penance |
| Holy Priest 257 | 36 | PW: Fortitude · Shadow Word: Pain · Holy Nova · Holy Word: Chastise · Shadow Word: Pain · Holy Nova · Smite · Smite |
| Resto Shaman 264 | 25 | Skyfury · Water Shield · Earthliving Weapon · Tidecaller's Guard · Chain Lightning · Flame Shock 470411 · Lava Burst (2×) · Lightning Bolt · Lava Burst |
| Mistweaver 270 | 46 | Touch of Death · Crackling Jade Lightning · Jadefire Stomp (2×) · Rising Sun Kick (2×) · Blackout Kick · Spinning Crane Kick (2×) · Tiger Palm · Crackling Jade Lightning · Rising Sun Kick |
| Preservation 1468 | 45 | Blessing of the Bronze · Fire Breath · Living Flame (2×) |

Elke stap heeft voorwaarden in `AssistedCombatRule`. De nummers daar hebben geen naam in de DB2. Wat ik eruit lees is dus **A**, bijvoorbeeld:
- Type 15 + debuff-ID = "doel heeft dit nog niet": Moonfire kijkt naar 164812, Sunfire naar 164815, Flame Shock naar 188389, SW: Pain naar 589.
- Type 9 / 16 + 768 = "wel / niet in Cat Form". Alle Druid-katspreuken hebben "wel Cat Form", alle castspreuken "niet Cat Form".
- Type 8 + 20 = "doel onder 20%". Dat staat bij Shadow Word: Death en bij één Hammer of Wrath-stap.
- Type 11/12 met (N, 10) = "minstens / minder dan N vijanden binnen 10 meter". Dat staat bij Chain Lightning (3), Starfire (3) en Holy Nova (5).

⚠️ De eerste stap is vaak een buff buiten gevecht (Mark of the Wild, Fortitude, Skyfury, Blessing of the Bronze). Die hoort niet op een vechtkaartje.

---

## 1. Restoration Druid (105)

**Kaartje:** Sunfire → Moonfire → Starsurge (als je hem hebt) → Wrath tot hij dood is. Drie of meer vijanden: Starfire in plaats van Wrath. Loop je? Moonfire.

| stap | spreuk | spell-ID (G) | basis/talent (G) | MH-toets (G) | in KeybindRoles (G) |
|---|---|---|---|---|---|
| 1 | Sunfire | 93402 | talent, starter | Shift-X | ja (specs 102, 105) |
| 2 | Moonfire | 8921 | basis (SkillLine 798) | Shift-C | ja |
| 3 | Starsurge | **197626** | talent, **keuze** (niet in de starter) | Shift-4 | ja, maar met **id 78674** (de Balance-versie) |
| 4 | Wrath | 5176 | basis (SkillLine 798) | 5 | ja |
| 5 (3+ vijanden) | Starfire | **197628** | talent, starter | — | **nee** (de entry is 102-only, id 194153) |

**Waarom, in gewone taal:** Sunfire en Moonfire blijven schade doen terwijl jij iets anders doet. Wrath is de knop die je daarna blijft indrukken.
(Dat het schade over tijd is: G, Icy Veins Resto DPS-gids 19 mei 2026, 12.0.5. Sunfire raakt volgens die gids ook vijanden in de buurt: G, oudere bron.)

**Bronnen:**
- Icy Veins Resto Druid rotatiepagina, 12.1, bijgewerkt 10 aug 2026 (G). Eén doel: Starsurge zodra hij klaar is, dan Wrath; Moonfire tijdens het lopen. Groep: Starfire; tijdens het lopen Sunfire.
- Icy Veins Easy Mode, 12.1, 10 aug 2026 (G): *"During downtime, use Moonfire, Sunfire and Wrath"*.
- Method, 13 sep 2026 (G): eerst de DoTs (Sunfire en Moonfire), daarna kat-spreuken.
- Blizzard SBA, DB2 (G).

**Tip:** geen. Moonkin Form zit wel in de starter (G), maar wat die vorm in 12.1 voor een Resto doet, heb ik niet gemeten. Cat Form is volgens Icy Veins "more advanced", dus geen beginnerstip.

---

## 2. Holy Paladin (65)

**Kaartje:** Judgment → Holy Shock op de vijand → bij 3 Holy Power: Shield of the Righteous → herhaal. Consecration alleen als je die knop nog hebt.

| stap | spreuk | spell-ID (G) | basis/talent (G) | MH-toets (G) | in KeybindRoles (G) |
|---|---|---|---|---|---|
| 1 | Judgment | **275773** (Holy-versie, vervangt 20271) | basis (SpecializationSpells 65) | 5 | ja, maar met **id 20271** |
| 2 | Holy Shock | 20473 | talent, starter; vervangt Crusader Strike (TraitDefinition 107539) | 1 | ja |
| 3 | Shield of the Righteous (Holy) | 415091 | basis (SpecializationSpells 65, vervangt 53600) | Ctrl-1 | ja |
| 4 | Consecration | 26573 | basis, **maar** Righteous Judgment (414113) vervangt hem en zit in de starter | Ctrl-2 | ja |

**Waarom:** Judgment en Holy Shock geven je Holy Power. Shield of the Righteous geeft die uit als schade wanneer niemand heling nodig heeft.
(G: Icy Veins rotatie 10 aug, *"When no healing is needed, spend Holy Power on Shield of the Righteous"*; Method Holy Paladin 12.1, dezelfde raad. Dat het om precies 3 Holy Power gaat: A, uit Icy Veins Easy Mode, die het over "spending at 3" heeft.)

**Bronnen:**
- Icy Veins rotatie, 12.1, 10 aug 2026 (G).
- Icy Veins Holy Paladin Guide, bijgewerkt **1 okt 2026** (G): *"Even Crusader Strike has been removed"*. Dat klopt met de DB2: Holy Shock vervangt hem.
- Method Holy Paladin, playstyle 12.1 (G): Judgment "will also proc Consecration".
- Blizzard SBA, DB2 (G).

**Tip:** Shield of the Righteous geeft ook een beetje mana terug (G: Method *"restore 1.5% of your mana"*; Icy Veins "small amounts of mana").

⚠️ **Consecration (A):** TraitDefinition 120887 laat Righteous Judgment de knop Consecration vervangen, en dat talent zit in de starter. Met de starter is Consecration dus waarschijnlijk geen eigen knop meer: Judgment legt hem dan zelf neer (Method). Niet in het spel getest.

---

## 3. Discipline Priest (256)

**Kaartje:** Shadow Word: Pain (als hij er nog niet op staat) → Mind Blast → Penance → Smite tot hij dood is.

| stap | spreuk | spell-ID (G) | basis/talent (G) | MH-toets (G) | in KeybindRoles (G) |
|---|---|---|---|---|---|
| 1 | Shadow Word: Pain | 589 | basis (SkillLine 804) | 5 | ja |
| 2 | Mind Blast | 8092 | talent, **gratis** voor Disc | 4 | ja |
| 3 | Penance | 47540 | basis (SpecializationSpells 256) | 1 | ja |
| 4 | Smite | 585 | basis (SkillLine 804) | Ctrl-2 | ja |
| extra (doel onder 20%) | Shadow Word: Death | 32379 | talent, keuze (alleen Shadow heeft hem in de starter) | Ctrl-3 | ja |

**Waarom:** Pain blijft schade doen. Mind Blast en Penance zijn je harde klappen. Smite druk je als de rest nog niet klaar is.

**Bronnen:**
- Icy Veins Disc Easy Mode, 12.1, **18 aug 2026** (G). Daar staat de Combat Assistant-lijst *"Shadow Word: Pain → Mind Blast → Penance → Smite"*, en die is gelijk aan de DB2.
- Blizzard SBA, DB2 (G).

**Tip (A):** zet eerst Power Word: Shield (17, MH-toets 2) op jezelf. Volgens Icy Veins geeft dat schild Atonement, en Atonement-doelen worden geheeld door jouw schade. Dan heelt je eigen schade jou ook. De twee stukken zijn G; de combinatie "solo op jezelf" is A.

---

## 4. Holy Priest (257)

**Kaartje:** Holy Word: Chastise (als je hem hebt) → Holy Fire (zonder dat talent: Shadow Word: Pain) → Smite tot hij dood is. Groepje vijanden: Holy Nova.

| stap | spreuk | spell-ID (G) | basis/talent (G) | MH-toets (G) | in KeybindRoles (G) |
|---|---|---|---|---|---|
| 1 | Holy Word: Chastise | 88625 | talent, **keuze**: zit **niet** in de starter van 257 | F | ja |
| 2 | Holy Fire | 14914 | talent, starter; vervangt SW: Pain (TraitDefinition 139056) | 4 | ja |
| 2 (zonder Holy Fire) | Shadow Word: Pain | 589 | basis | Ctrl-2 | ja |
| 3 | Smite | 585 | basis | 5 | ja |
| 4 (groepje) | Holy Nova | 132157 | talent, **gratis** voor Holy | Shift-4 | ja |

**Waarom:** Chastise en Holy Fire zijn je sterkste klappen. Smite is je goedkope vuller (G: Icy Veins *"costs very little Mana"*).

**Bronnen:**
- Icy Veins Holy Priest Easy Mode, 12.1, **25 aug 2026** (G). Schade in dungeons: Chastise → Holy Fire → Holy Nova bij 3 of meer → Smite bij 1-2.
- Blizzard SBA, DB2 (G). De DB2 zet Holy Nova pas bij 5 vijanden (A, uit voorwaarde 12 met waarde 5).

**Tip:** Icy Veins (25 aug) zegt dat je Delves beter als **Shadow** doet dan als Holy, vanwege de schade (G). Of dat ook geldt voor questen in de open wereld is A.

---

## 5. Restoration Shaman (264)

**Kaartje:** Flame Shock (als hij er nog niet op staat) → Lava Burst zodra hij klaar is → Lightning Bolt tot hij dood is. Drie of meer vijanden: Chain Lightning (als je hem hebt).

| stap | spreuk | spell-ID (G) | basis/talent (G) | MH-toets (G) | in KeybindRoles (G) |
|---|---|---|---|---|---|
| 1 | Flame Shock | 470411 | basis (SkillLine 924) | Ctrl-3 | ja |
| 2 | Lava Burst | 51505 | talent, **gratis** voor Resto en in de starter | 5 | ja |
| 3 | Lightning Bolt | 188196 | basis (SkillLine 924) | Ctrl-1 | ja |
| 4 (3+ vijanden) | Chain Lightning | 188443 | talent, **keuze**: niet in de Resto-starter | Shift-C | ja |

**Waarom:** Flame Shock blijft branden en kan Lava Burst opnieuw klaarzetten. Lava Burst is je harde klap. Lightning Bolt druk je daartussen.
(G: Icy Veins Resto DPS, 10 aug 2026, *"Lava Surge gives each of your Flame Shock ticks a chance to reset … Lava Burst"*.)

**Bronnen:**
- Icy Veins Easy Mode en DPS-gids, 12.1, 10 aug 2026 (G). Ook hun Combat Assistant-zin is gelijk aan de DB2.
- Blizzard SBA, DB2 (G).

**Tip:** schade kost een Resto Shaman bijna geen mana (G: Icy Veins DPS-gids, *"damage dealing (which barely uses any Mana by itself)"*). Meevechten is dus geen verspilling.

---

## 6. Mistweaver Monk (270)

**Kaartje:** Rising Sun Kick zodra hij klaar is → Tiger Palm 3× → Blackout Kick → herhaal. Vier of meer vijanden: Spinning Crane Kick. Doel te ver weg: Crackling Jade Lightning. Licht Touch of Death op: druk hem.

| stap | spreuk | spell-ID (G) | basis/talent (G) | MH-toets (G) | in KeybindRoles (G) |
|---|---|---|---|---|---|
| 1 | Rising Sun Kick | 107428 | talent, **gratis** voor MW | 4 | ja |
| 1 (met starter) | → wordt **Rushing Wind Kick** | 467307 | talent, starter; vervangt RSK (TraitDefinition 133028) | Ctrl-1 in het standaardblok (A: in het spel neemt hij 4 over) | ja |
| 2 | Tiger Palm | 100780 | basis (SkillLine 829) | 5 | ja |
| 3 | Blackout Kick | 100784 | basis | Ctrl-2 | ja |
| 4 (4+ vijanden) | Spinning Crane Kick | 101546 | basis | Shift-2 | ja |
| 5 (te ver weg) | Crackling Jade Lightning | 117952 | basis (SkillLine 829, geen talent) | — | **nee** (de entry is 268/269-only) |
| extra | Touch of Death | 322109 | basis | Shift-C | ja |

**Waarom:** Rising Sun Kick is je sterkste klap. Tiger Palm laadt Blackout Kick op, en Blackout Kick kan Rising Sun Kick opnieuw klaarzetten.
(G: Icy Veins MW DPS-gids 12.1, 10 aug 2026: *"Teachings of the Monastery … 15% chance to reset … Rising Sun Kick"*.)

**Bronnen:**
- Icy Veins MW DPS-gids, 12.1, 10 aug 2026 (G). Eén doel: RSK, dan Blackout Kick bij 3-4 stacks, anders Tiger Palm. Vier doelen: Spinning Crane Kick. Crackling Jade Lightning *"is your ranged DPS ability"*.
- Icy Veins rotatiepagina, 12 aug 2026 (G): *"DPS if no one is in danger (Tiger Palm into Blackout Kick)"*.
- Method MW, 12.1 (G): *"Fill in any remaining time with Blackout Kick and Tiger Palm"*.
- Blizzard SBA, DB2 (G).

**Tip:** geen. Icy Veins (18 aug) waarschuwt dat de Combat Assistant voor MW *"may end up doing more harm than good"* (G).

---

## 7. Preservation Evoker (1468)

**Kaartje:** Fire Breath (knop vasthouden en loslaten) → Disintegrate als je Essence over hebt → Living Flame tot hij dood is.

| stap | spreuk | spell-ID (G) | basis/talent (G) | MH-toets (G) | in KeybindRoles (G) |
|---|---|---|---|---|---|
| 1 | Fire Breath | 357208 | basis (SkillLine 2810) | Ctrl-3 | ja |
| 2 | Disintegrate | 356995 | basis (SkillLine 2810) | Shift-4 | ja |
| 3 | Living Flame | 361469 | basis (SkillLine 2810) | 5 | ja |

**Waarom:** Fire Breath is je grote klap. Living Flame is je vaste knop daarna.
Dat Fire Breath een "vasthouden"-spreuk (empower) is, is A: MH zelf noemt hem "empower-builder", en Icy Veins beschrijft empower bij Dream Breath.

**Bronnen:**
- Icy Veins Pres Easy Mode, 12.1, 10 aug 2026 (G): *"you can deal damage through Living Flame, Fire Breath, and Disintegrate"*. De Combat Assistant gebruikt alleen Fire Breath en Living Flame, en dat is gelijk aan de DB2.
- Blizzard SBA, DB2 (G).

**Tip:** geen.
Azure Strike (362969, basis, MH Ctrl-1, in KeybindRoles) laat ik weg. Hij staat niet in Blizzards lijst en ik vond geen 12.1-bron die zegt wanneer een Pres hem gebruikt.

---

## Wat nog NIET in MH's data staat (G)

Voor de kaartjes:
1. **Starfire 197628 voor Resto Druid (105).** De entry `Starfire` is `specs = { 102 }` met id 194153. Hij staat ook niet in het standaardblok van 105.
2. **Crackling Jade Lightning 117952 voor Mistweaver (270).** De entry is `specs = { 268, 269 }`. Volgens de DB2 is hij basis voor Monk, en Blizzards SBA gebruikt hem voor MW.

Wel aanwezig, maar met een **ander ID** dan de healer echt heeft. MH zoekt eerst op ID en daarna op naam; op een niet-Engelse client kan het daardoor misgaan (A):
3. **Starsurge:** MH heeft 78674 (Balance). Resto heeft 197626 (G, TraitDefinition 108283 is alleen zichtbaar voor 103/104/105).
4. **Judgment voor Holy:** MH heeft 20271. Holy krijgt 275773 (G, SpecializationSpells "overrides 20271"). Het commentaar in `KeybindRoles_Paladin.lua` noemt 275773 zelf al.

Niet nodig voor de kaartjes, maar wel in Blizzards lijst en niet in KeybindRoles:
- Water Shield 52127, Earthliving Weapon 382021, Tidecaller's Guard 457481 (Resto Shaman).
- Jadefire Stomp 388193 (MW, talent, keuze).
- Righteous Judgment 414113 (Holy Paladin).
- Hammer of Wrath 24275 voor Holy (MH: `specs = { 70 }`). Zie hieronder bij "niet gemeten".

De zoektocht had een positieve controle in dezelfde ronde: Skyfury, Mark of the Wild, PW: Fortitude en Blessing of the Bronze werden wel gevonden.

## Wat ik NIET kon meten

- **Niets is in het spel getest.** Dat de knoppen echt in iemands spellbook staan, ziet alleen de client. `/mh binds` of de automap-dump op een healer beslist het.
- **De voorwaarden in AssistedCombatRule hebben geen naam.** Mijn uitleg van type 8, 9, 11, 12, 15 en 16 is A.
- **Dat TraitTreeLoadout Blizzards "Starter Build" is,** is A. Wel G: er bestaat per spec zo'n indeling, en Holy Fire, Sunfire en Starfire zitten er wel in (positieve controle).
- **Hammer of Wrath voor Holy.** De SBA noemt hem vier keer met een voorwaarde (Veneration, Avenging Wrath, Avenging Crusader, doel onder 20%). Zijn talentdefinitie 107484 hangt aan **geen enkele** talentknoop (G). Of een Holy Paladin hem in 12.1 als knop heeft, weet ik niet.
- **Consecration naast Righteous Judgment.** Dat hij dan geen knop meer is, is A (zie Holy Paladin).
- **Tegenstrijdigheid:** Icy Veins Holy Paladin Easy Mode (10 aug) zegt dat de Combat Assistant *"will not cast Holy Shock"*. De DB2 heeft Holy Shock wél als stap (stap-ID 20294, veel hoger dan de rest, dus waarschijnlijk later toegevoegd: A). Niet in het spel nagekeken.
- **Manakosten, schadegetallen en afstanden** (of Shield of the Righteous alleen dichtbij werkt): niet gemeten, dus niet op de kaartjes gezet.
- **Moonkin Form voor Resto:** wat hij in 12.1 doet, niet gemeten.
- **Build 12.1.5.70077** (genoemd in MH-commentaar) heb ik niet bekeken. Alles hier komt uit 12.1.0.69933, zoals gevraagd.
- **Bronnen die ik niet vond:** geen Icy Veins DPS-gids voor Preservation (CRAWL_NOT_FOUND). Een lege zoekactie bewijst niet dat hij niet bestaat. Wowhead heb ik alleen gezien voor Holy Paladin (Season 2-pagina), en die ging niet over solo-schade.
- **Datums:** Icy Veins voor Holy Paladin, Resto Shaman, Pres en Resto Druid is van 10 aug 2026 (12.1, vóór 18 aug). Na 18 aug: Disc (18 aug), MW (18 aug), Holy Priest (25 aug), Method Resto Druid (13 sep) en Icy Veins Holy Paladin Guide (1 okt). Overal is de DB2 de echte meting.

## Idee voor de bouwchat (A, Rob kiest)

MH's `EventProbe.lua` vraagt al naar `C_AssistedCombat.GetRotationSpells()`. Volgens het commentaar daar is de API gemeten op de 12.1 PTR.
Geeft die functie in het spel dezelfde lijst als de DB2 hierboven, dan kan het kaartje "Zo vecht je alleen" zich per personage vullen uit de client, inclusief de talenten die de speler echt heeft. Dan klopt het ook voor wie Starsurge of Chastise niet heeft genomen.
Dat is niet getest; het is een voorstel, geen meting.
