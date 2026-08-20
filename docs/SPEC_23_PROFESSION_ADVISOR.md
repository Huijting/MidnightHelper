# Spec 23 — Profession Knowledge-adviseur (Alchemy + Herbalism)

**Van:** ONDERZOEK-sessie, 20 aug 2026
**Voor:** BOUW-sessie
**Aanleiding:** Rob (de opdrachtgever zélf) wist niet waar hij zijn knowledge points moest
inzetten na een reset, en vond de bestaande MH-inhoud niet.
**Status:** klaar om te bouwen. Zie §6 — dit is de belangrijkste paragraaf.

---

## 1. Waarom nu

Drie dingen vielen samen:

1. **Patch 12.1 gaf iedereen één gratis reset** (NPC Theremis, Silvermoon, npc 243280,
   gemeten 45.05 / 56.17). Eén per profession, en hij **wist ook je via KP geleerde
   recepten**. Dat is precies het moment waarop een speler wil weten wat de juiste keuze is.
2. **MH beweert het tegenovergestelde.** `PROFACAD_CH_TREES_BODY` zegt dat resetten
   onmogelijk is. Zie §2.
3. **Geen enkele addon vult dit gat.** Verkenning 20 aug 2026: elf profession-addons
   trackken knowledge points, **nul** leggen uit wat je ermee moet doen. Het dichtstbijzijnde
   is KnowledgeLoadout — een lége planner waarin de speler zelf een volgorde intikt, met
   **168 downloads**.

---

## 2. Deel A — de feitelijke fout (doe dit sowieso, ook als de rest niet doorgaat)

`Locales/enUS.lua`, `PROFACAD_CH_TREES_BODY`, opent nu met:

> "Knowledge Points are permanent: there is currently no way to refund or respec them.
> That sounds scary, but with a small plan you can't really go wrong."

**Onjuist sinds 11 aug 2026.** Blizzard, blue post 1 juli 2026: *"a one-time profession
knowledge reset (once per profession) to reset all spent Knowledge Points and allow players
to re-assign them freely."* Voor TWW-professions bestond dit al sinds patch 11.1 (NPC Darla
Fluxy, Dornogal).

⚠️ **Schrap de zin niet zomaar.** Dat duwt de tekst van te streng naar te losjes, en dát is
de gevaarlijkere fout: een beginner die denkt vrij te kunnen experimenteren en zijn enige
reset verbrandt, is slechter af dan iemand die voorzichtig blijft.

Voorgestelde strekking (formulering aan BOUW):

> Knowledge Points liggen vast zodra je ze uitgeeft — met één uitzondering. Sinds patch
> 12.1 kun je **één keer per profession** alles terugdraaien bij Theremis in Silvermoon.
> Eén keer. Daarna is het permanent. En let op: die reset wist ook de recepten die je via
> knowledge points geleerd had.
>
> Goed nieuws voor de zenuwen: je kunt geen punten *verspillen*. Blijf je punten verzamelen,
> dan kun je uiteindelijk elke tak invullen. Alleen de **volgorde** kun je fout doen.

Die laatste alinea is belangrijk: hij haalt de angst weg zonder onwaar te zijn.

---

## 3. Deel B — goal-bewuste routes

`ProfessionAcademyData.advisorRoutes` is nu één platte lijst per `skillLineID`. De
"Advice goal"-knoppen (Allround / Gold / Self-sufficient) zijn op **22 juli verwijderd**
omdat er per profession maar één route bestond; `GOAL_DEFS` en de `PROFHUB_GOAL_*`-keys
zijn bewust bewaard.

**Voorgesteld schema — achterwaarts compatibel.** Laat de platte lijst betekenen "allround"
en sta een optionele goal-tabel toe. Dan hoeven de negen andere professions niet aangeraakt
te worden:

```lua
[171] = {
    -- platte lijst blijft de allround/fallback-route
    { tree = "Potion Prowess" },
    ...
    goals = {
        gold = { ... },
        self = { ... },
    },
},
```

Ontbreekt `goals`, dan toont de knoppenrij alleen Allround (of blijft verborgen). Zo is de
feature vanaf dag één eerlijk over waar hij wél en niet iets te zeggen heeft.

**Extra veld per stap:** `whyKey` — een locale key met één zin waaróm die stap daar staat.
Dat is de hele bestaansreden van deze feature; zonder dat zijn we weer een tracker.

---

## 4. De twee geverifieerde routes

Onderzoek 19–20 aug 2026, drie bronfamilies (Wowhead, Icy Veins, Method), boost-/SEO-sites
geweerd. Onzekerheden staan in §5.

### Alchemy (`skillLineID` 171) — huidige route is fout

Nu: `anyOf { Fluent in Flasks, Potion Prowess }` → `Transmutation Authority`.
Transmutation hoort **laatst**, niet tweede.

| # | Stap | Waarom (kern van `whyKey`) |
|---|---|---|
| 0 | *Craft elk bekend recept één keer* | +1 KP en 10 Moxie per nieuw recept. Gratis punten die er gewoon liggen — pak ze vóór je verdeelt. |
| 1 | **Potion Prowess**, hoofdwiel vol | Dient goud én guild tegelijk. Vol wiel = **Voidlight Potion Cauldron**, de ketel die je hele raid van potions voorziet. |
| 2 | **Path of Light** → *Prolific Potioneer – Light* | Multicraft: regelmatig gratis extra potions uit dezelfde materialen. Light en niet Void, want *Light's Potential* is in S2 de standaard-DPS-potion. |
| 3 | **Alchemical Mastery** → subtak **Reuse** | Resourcefulness: je krijgt kruiden terug. Sterk in combinatie met Herbalism. |
| 4 | **Fluent in Flasks**, 15 punten | Jouw eigen flasks en phials duren **twee keer zo lang**. Persoonlijk voordeel, geen omweg. |
| 5 | Fluent in Flasks vol → Sin'dorei Specialist → **Transmutation Authority** | Flask-ketel voor de guild; transmutes als laatste. |

**Goal-verschil:** klein. Voor *potions* lopen goud en guild samen (verkoopwaar én raid-ketel).
Ze lopen uiteen bij *flasks*: belangrijk voor guild/jezelf, zwakkere goudmarkt in S2.
→ `gold`: stap 5 naar achteren. `self`: stap 4–5 naar voren.

### Herbalism (`skillLineID` 182) — huidige route mist een stap en bevat een afrader

Nu: `Botany (skipIfClass DRUID)` → `Bountiful Harvests` → `Midnight Overload`.
Botany-first klopt. **Mulching ontbreekt** en **Midnight Overload hoort er niet in.**

| # | Stap | Waarom |
|---|---|---|
| 1 | **Botany**, ~40 punten (`skipIfClass = "DRUID"` behouden) | Plukken vanaf je mount — de grootste tijdwinst van het beroep. Geeft ook +1 Finesse per punt (= meer kruiden per node). |
| 2 | **Mulching** (sub van Botany), 20 punten | **Imbued Mulch**: gegarandeerde zeldzame proc, ~1 Nocturnal Lotus per uur. Lotus zit in de meeste flasks/cauldrons en is het duurste kruid. |
| 3 | **Bountiful Harvests** | +1 Skill per punt tijdens plukken → vaker goud- i.p.v. zilverkwaliteit. |
| 4 | ~~Midnight Overload~~ | **Verwijderen uit de route.** Werkt alleen bij elementale nodes, kost veel punten, kom je te weinig tegen. Alleen zinvol bij gericht mote-farmen. |

**Let op — bestaande MH-tekst spreekt dit tegen.** `PROFACAD_CH_HERBALISM_BODY` zegt nu
"~40 in Bountiful Harvests" direct na Botany en noemt Mulching niet. Werk die tekst bij.

**Twee stat-feiten voor de uitleg** (dit is wat niemand uitlegt):
Finesse = meer kruiden per node (volume/goud). Perception = kans op zeldzame vondst
(Nocturnal Lotus). Deftness = sneller plukken — minst belangrijk, want je bent per uur meer
tijd kwijt met zoeken en vliegen dan met de pluk-animatie.

**Midnight-kruiden hebben maar twee kwaliteitsrangen**, niet drie. Jaag niet op een derde.

---

## 5. ⛔ Wat NIET geëncodeerd mag worden

1. **Exacte puntenaantallen per node.** De bronnen spreken elkaar tegen (Wowhead noemt er
   geen; Method en Icy Veins geven verschillende getallen voor dezelfde node). De "40" voor
   mounted gathering en de "15" voor de flask-duur komen elk uit **één** guide. Toon ze
   hooguit als "ongeveer", en zet er de instructie bij: **lees de in-game tooltip, die toont
   X / Y**. Bij één reset is een verkeerd getal duurder dan geen getal.
2. **Een stat-ranking** ("Multicraft > Ingenuity > Resourcefulness"). Economisch oordeel,
   geen feit; verschuift per realm en per patch.
3. **Goud-per-uur cijfers.** Niemand publiceert die betrouwbaar en ze hangen van de realm af.
4. **Of Light's Potential achter een spec-node zit.** Method zegt ja, Icy Veins impliceert
   nee. Onopgelost — laat het weg.

---

## 6. 🔴 Scope-waarschuwing — lees dit vóór je begint

Buildadvies botst met de never-lie-regel. Houd de scope bij wat verifieerbaar is:

- **wat doet deze stat** (feit)
- **wat ontgrendelt deze node, en heb je dat al** (feit, uit `C_Traits` leesbaar)
- **wat is de afweging tussen twee takken** (mechanisme-uitleg, geen ranking)
- **de waarschuwing vóór de reset** (feit — en waarschijnlijk de waardevolste regel die MH
  hier kan tonen)
- voor wie tóch een kant-en-klare ranking wil: **link naar Wowhead**

Mechanisme-uitleg veroudert traag. "Beste build" veroudert per patch, en we hebben elf
professies met elk een eigen boom.

**Als de uitleg-scope bij het bouwen te dun blijkt om nuttig te zijn: meld dat vóór je hem
afbouwt.** Dan halen we hem uit de wachtrij in plaats van iets te leveren dat over zes weken
niet meer klopt. Dat is een beter einde dan een tweede rectificatie.

---

## 7. Deel C — vindbaarheid

Rob wist niet dat de Academy al starter builds voor zijn twee professions bevatte. Vindt de
bouwer het niet op het moment dat hij het nodig heeft, dan vindt geen enkele beginner het.

Suggesties (BOUW kiest):
- Een regel in **This Week / Home** zodra `C_Traits.GetTreeCurrencyInfo` **onbestede punten**
  ziet: *"Je hebt N onbestede knowledge points — MH kan uitleggen waar ze heen kunnen."*
  Onbestede punten zijn al leesbaar (`ProfessionNextStep.lua`), dus dit is een koppeling,
  geen nieuwe meting.
- Een verwijzing vanuit het profession-venster zelf, waar de speler op dat moment is.

---

## 8. Wat dit NIET is

- **Geen aparte addon.** Ontdekbaarheid is de doodsoorzaak in deze niche: KnowledgeLoadout
  168 downloads, MidnightGather 399, GatherBuffs 852 — tegenover Myu's 2.9M en Routine 2.6M.
- **Geen KP-tracker.** Myu's en Routine dekken "waar vind ik punten" volledig en zijn allebei
  deze week bijgewerkt. Positionering: *"Zij vertellen je waar de punten liggen. Wij
  vertellen je wat je ermee doet."*
- **Geen negen andere professions.** Twee geverifieerde routes zijn beter dan elf gegokte —
  dat is precies waarom de knoppen in juli zijn weggehaald.
