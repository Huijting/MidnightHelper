# "Zo speel je"-kaarten — het SYSTEEM over alle 40 specs

Onderzoek 3 okt 2026. Strikt read-only: niets gewijzigd, geen git. Spec 66 (Prot Paladin) is
NIET inhoudelijk beoordeeld — die ligt bij de andere onderzoeker. Waar 66 hieronder staat, is dat
alleen als getal in een systeemtelling.

Elke bewering is gemarkeerd **GEMETEN** (bestand:regel, vandaag gelezen) of **AFGELEID**.

⚠️ Eén afwijking van mijn eigen opdracht-regel ("niets onder `docs/` lezen"): de opdracht noemde
`docs/CONTENT_WATCH.md` expliciet bij punt 5, en de vraag gaat letterlijk over dat bestand. Ik heb
alleen dat ene bestand gelezen (regel 1340-1464 plus een datumlijst). Verder niets uit `docs/`.

---

## 1. Waar de functie woont

| wat | bestand:regel | status |
|---|---|---|
| kaartdata (40 specs) | `Modules/PlayCards.lua:30-191` | GEMETEN |
| teksten | `Locales/enUS.lua`, keys `PLAYCARD_<specID>_<DEEL>` | GEMETEN (437 `PLAYCARD_*`/`SURVIVAL_*` keys) |
| venster + 4 tabs | `Modules/PlayCardWindow.lua:706-867` (`Redraw`) | GEMETEN |
| tabbladen-lijst | `Modules/PlayCardWindow.lua:754-759` | GEMETEN |
| slash-commando | `Core.lua:3147` — `/mh play`, `/mh howtoplay`, `/mh playcards` | GEMETEN |
| diagnose | `Core.lua:3153` → `ns.PrintPlayCardCheck` (`PlayCards.lua:280`) | GEMETEN |
| gouden knop in de zoekbalk | `PlayCardWindow.lua:1018` (`ns.CreatePlayCardButton`) | GEMETEN |
| ook open vanuit de Academy | `Modules/RoleAcademy.lua:652,671-672` | GEMETEN |

**De vier tabs (GEMETEN, `PlayCardWindow.lua:754-759`, labels uit `enUS.lua`):**

| tab-id | label op Robs scherm | tekenfunctie | databron |
|---|---|---|---|
| `play` | **Your buttons** | `Redraw` 785-862 | `ns.GetPlayCard` → `PlayCards.lua` + `enUS.lua` |
| `alive` | **Stay alive** | `DrawStayAlive` 666-700 | `ns.GetSurvivalPlan` → `SurvivalPlan.lua` + `KeybindRoles_*.lua` |
| `cons` | **Consumables** | `DrawConsumables` 604-662 | `ns.MH_GetConsumablesWowheadForSpec` → `ConsumablesWowheadData.lua` |
| `dispel` | **Dispel** | `DrawDispel` 492-602 | `HealerCooldowns.lua` + `ENEMY_DISPELS` + `SEASON_DISPELS` |

De gekozen tab wordt per account onthouden in `ns.db.ui.playCardTab` (GEMETEN,
`PlayCardWindow.lua:256-267`). Opent Rob het venster, dan staat hij waar hij het laatst stond —
dus "een korte genummerde lijst knoppen" kan **tab 1 óf tab 2** zijn. Beide nummeren hun regels
(`PlayCardWindow.lua:820` resp. `682`).

Vaste vorm van tab 1, van boven naar onder (GEMETEN, `PlayCardWindow.lua:729-861`):
spec-icoontjes van je eigen klasse → tabs → (bij <max level) blauwe regel "written for level 90" →
**idea** (één witte zin) → kopje "Your buttons, most important first:" → **genummerde stappen met
icoon + je echte toets** → "More enemies:" → "Biggest mistake:" (rood) → twee hero-bullets (•) →
grijze bronregel met datums.

---

## 2. De vorm, gemeten over alle 40 specs

GEMETEN (`PlayCards.lua:30-191` + `enUS.lua`), script-telling, 0 ontbrekende/overtollige keys:

- **Specs met een kaart: 40 van 40.** Inclusief de vierde DH-spec **Devourer (1480)**
  (`PlayCards.lua:187`). Positieve controle: 1480 komt 15× voor in
  `KeybindRoles_DemonHunter.lua`, dus het is geen tikfout.
- **Genummerde regels: min 4, max 5, gemiddeld 4,40** (24 specs met 4, 16 met 5).
- **"More enemies": 39 van 40.** Enige uitzondering: **Retribution Paladin (70)**,
  `aoe = false` (`PlayCards.lua:32`).
- **"Biggest mistake": 40 van 40. Hero-bullets: 40 van 40, altijd exact 2.**
- **Tekens per kaart (alle delen samen): min 666, max 1004, gemiddeld 857.**
  Kortste: **70 Retribution Paladin (666)**. Langste: **581 Vengeance DH (1004)**.
- **Tekens per genummerde regel: min 26, max 126, gemiddeld 81.**
- **Knoppen die de genummerde regels écht noemen: min 4, max 11, gemiddeld 7,2.**
  Dus 4-5 regels, maar elke regel bundelt gemiddeld ~1,6 spreuken.
  - Dunste kaarten: **253 Beast Mastery Hunter (4 knoppen in 4 regels)**,
    **255 Survival Hunter (5)**, **266 Demonology Warlock (5)**.
  - Dikste: **577 Havoc DH (11)**, daarna 70/104/258/268/581 (9).
- Bovenop de stappen noemt "More enemies" nog 0-4 extra knoppen en idea/mistake/hero 0-4.
  Over de hele kaart: **min 5, max 14, gemiddeld 9,8 verschillende spell-id's.**
- **Twee stappen zonder spell-id** (en dus zonder icoon, bewust — `PlayCardWindow.lua:821-822`):
  `PLAYCARD_102_S3` (Balance Druid, "Press Eclipse…") en `PLAYCARD_1468_S4`
  (Preservation Evoker, "Merithra's Blessing…"). GEMETEN; de header zegt waarom: een spreuk zonder
  bevestigd 12.1-id wordt als platte tekst geschreven (`PlayCards.lua:21`).

**Antwoord op Robs vraag "ontbreken er knoppen?" (AFGELEID uit het bovenstaande):**
nee, niet in de zin van "de kaart vergat iets". De kaart is een top-4/5 **beslissingsregels**, niet
een spreukenlijst — hij noemt gemiddeld al bijna 10 spreuken. Wél ontbreekt per ontwerp alles wat
geen schade doet; dat staat op tab 2, 3 en 4. Zie punt 7 voor het enige echte systeemgat.

---

## 3. "Kort" is een REGEL, geen toeval — met citaat

GEMETEN, `Modules/PlayCards.lua:4` (Robs eigen opdracht, 19 sep 2026):

> "Ik wil dat mh dat soort uitleg ook gaat geven, en ja voor alle specs, maar wel in eli10 formaat"

GEMETEN, `Modules/PlayCards.lua:12` (de ontwerpregel):

> "The shape is fixed on purpose, because the whole point is that it stays short"

Daaronder staat het schema letterlijk vast (`PlayCards.lua:13-17`): `IDEA` één zin, `S1..S5` de
knoppen, belangrijkste eerst, **één regel elk**, `AOE` optioneel, `MISTAKE` het ene ding dat
beginners fout doen, `HERO1/2` alleen als een heldenboom de stappen verandert.

Twee bevestigingen dat kort ook later leidend bleef:
- `PlayCardWindow.lua:750-751`: Rob miste op zijn Elemental Shaman "de defense dingen" — "He chose
  a second tab **so the window stays as short as it was**." GEMETEN.
- `PlayCardWindow.lua:19`: breedte van 460 naar 500 "four tabs did not fit" — de enige keer dat de
  vorm meegaf, en dan nog aan de breedte, niet aan de lengte. GEMETEN.

Conclusie: **max 5 stappen is een bewuste bovengrens** (GEMETEN), en de `steps`-waarde per spec
(4 of 5) is een per-spec keuze in de datatabel, geen gevolg van hoeveel tekst er was.

---

## 4. Dekking per tab

| tab | specs met gevulde inhoud | gaten |
|---|---|---|
| Your buttons | **40 / 40** | geen. 0 ontbrekende keys, 0 placeholders |
| Stay alive | **40 / 40** (geen enkele spec met 0 rijen) | geen lege tab; wel lege STAPPEN, zie onder |
| Consumables | **40 / 40** | geen. Alle 13 klassen, alle spec-indices (Druid 1-4, rest 1-3) |
| Dispel | **40 / 40** (de tab is nooit leeg) | 9 specs zien "niets" in de bovenste twee blokken |

GEMETEN per tab:

**Your buttons** — `PlayCards.lua` heeft 40 ingangen; voor elke spec bestaan alle verwachte keys
(IDEA, S1..Sn, AOE waar `aoe=true`, MISTAKE, HERO1, HERO2) in `enUS.lua`. Script-uitkomst:
`key problems: none`. Geen placeholder-tekst. De fallbacks `PLAYCARD_NONE` ("This spec's card
isn't written yet") en `PLAYCARD_ALIVE_NONE` bestaan nog wel in `enUS.lua`, maar zijn voor geen
enkele spec bereikbaar. GEMETEN.

**Stay alive** — 136 ingangen in de 13 `KeybindRoles_*.lua` dragen een `survival`-tag (GEMETEN).
Per spec bereiken 4 tot 12 tags de kaart, gemiddeld 7,75. Dunst: **257 Holy Priest (4)** en
**256 Disc Priest / 577 Havoc DH (5)**. Dikst: **104 Guardian Druid** en **66 Prot Paladin (12)**.
⚠️ Dit is het aantal **tags dat op die spec van toepassing is**, niet het aantal rijen op het
scherm: `LiveName` (`SurvivalPlan.lua:181-268`) laat spreuken vallen die je niet kent, passieven
en dubbelingen. Het echte aantal rijen is dus ≤ dit getal — AFGELEID, alleen in-game te meten
(`/mh survival` print per spreuk waarom hij wel/niet staat, `SurvivalPlan.lua:283`).

De zes stappen (`SurvivalPlan.lua:113-120`) en hoeveel specs ze **leeg** laten (GEMETEN):

| stap | enUS-tekst | specs zonder rij |
|---|---|---|
| keepup | "keep this up, before the pull and all fight long" | **32 van 40** |
| small | "a small one: press it often, just before a big hit" | 4 (262/263/264 Shaman, 270 Mistweaver) |
| big | "a big one: save it for when your health drops fast" | 0 |
| heal | "to heal yourself" | 5 (62/63/64 Mage, 102 Balance, 577 Havoc) |
| escape | "to get away" | 0 |
| interrupt | "when it is casting something" | 5 (105, 256, 257, 270, 1468) |

Die 32 lege `keepup` is géén gat maar precies de reparatie van 17 sep — zie punt 6. De 8 specs die
hem wél hebben zijn allemaal actieve-mitigatie- of barrière-specs: 62/63/64 (Mage-barriers),
66, 73 (Shield Block + Ignore Pain), 104 (Ironfur), 268 (Purifying Brew), 581 (Demon Spikes).
GEMETEN op `KeybindRoles_Mage.lua:148,169,191`, `_Warrior.lua:89,137`, `_Druid.lua:163`,
`_Monk.lua:99`, `_DemonHunter.lua:129`.

**Consumables** — 13 klassen in `ConsumablesWowheadData.lua`, elk met al zijn spec-indices
(Druid 4, de rest 3) = 40/40. GEMETEN. Zeven categorieën per spec
(`PlayCardWindow.lua:354-362`): flask, combat potion, healing potion, weapon oil, augment rune,
food, feast. Weapon oil kan per spec weggelaten worden (`omitWeaponOil`, regel 622).
⚠️ Kleine slordigheid: de header zegt "Midnight **S1**" (`ConsumablesWowheadData.lua:2`) terwijl
`patchedSince` (regel 13) S2-werk van 19 aug en 14 sep noemt. Alleen de commentaartekst is oud.
GEMETEN.

**Dispel** — drie blokken plus drie uitlegregels (`PlayCardWindow.lua:534-600`).
- Vriendelijke dispels: 7 healer-specs (`HealerCooldowns.lua:243-251`) + 8 klassen voor
  niet-healers (`HealerCooldowns.lua:268-283`: DRUID, SHAMAN, MAGE, MONK, PALADIN, PRIEST,
  WARLOCK, EVOKER). GEMETEN.
- Vijandelijke purges: 6 klassen (`PlayCardWindow.lua:430-437`: PRIEST, MAGE, SHAMAN, HUNTER,
  DRUID, DEMONHUNTER). GEMETEN.
- Seizoensblok: **6 vaste regels voor alle 40 specs** (`PlayCardWindow.lua:444-451`), uit de
  geïnstalleerde DBM-mods, alleen waar DBM het TYPE noemt. Twee untyped DBM-regels (Glacial
  Torment 1235548, Icebound Flames 1286922) zijn bewust weggelaten, regel 443. GEMETEN.
- **9 specs zien tweemaal "niets"**: 71/72/73 (Warrior), 250/251/252 (DK), 259/260/261 (Rogue).
  Die klassen hebben geen dispel en geen purge. GEMETEN; dat is juist, geen gat — de tab zegt het
  met een grijze regel (`PLAYCARD_DISPEL_NONE_FRIENDS` / `_NONE_ENEMIES`).
- AFGELEID aandachtspunt: de 6 seizoensregels zijn identiek voor iedere spec; alleen het groene
  "jij kan dit"-vinkje verschilt. Voor die 9 specs is de hele tab dus statisch en gelijk aan die
  van elke andere Warrior/DK/Rogue.

---

## 5. Versheid

Bronregel op het scherm: `PLAYCARD_SOURCE_FMT` = "From the guides: %s. A patch can change this."
De reden staat in de header (`PlayCards.lua:23-24`): "A rotation changes with a patch; the date is
how a player (and we) can tell a card might be stale." GEMETEN.

GEMETEN per spec (oudste genoemde brondatum; alles 2026):

| oudste bron | specs |
|---|---|
| **10 aug** | 63 Fire Mage, 64 Frost Mage, 71 Arms, 72 Fury, 250 Blood DK, 262 Elemental, 264 Resto Shaman, 266 Demonology |
| 11 aug | 73 Prot Warrior, 258 Shadow, 268 Brewmaster, 269 Windwalker, 581 Vengeance |
| 12 aug | 66, 103, 104, 105, 259, 260, 265, 270 |
| 13-19 aug | 62, 102, 253, 261, 267, 1468, 1473, 1480 |
| 23 aug - 14 sep | de overige 11 |
| **nieuwste** | 251 Frost DK (14 sep), 252 Unholy DK (8 sep) |

- **29 van de 40 kaarten hebben minstens één bron van vóór 18 aug 2026** (start Season 2).
- Harder getal: **20 van de 40 kaarten hebben hun *nieuwste* bron vóór 1 sep 2026.**
  De vier oudste op die maat: **64 Frost Mage, 72 Fury Warrior, 264 Resto Shaman,
  266 Demonology Warlock — alle vier niets nieuwer dan 11 aug 2026.** Dat zijn de kaarten die het
  langst niet tegen een verse gids zijn gelegd. GEMETEN.
- Vier kaarten dragen een "rechecked 25 Sep: still right"-commentaar (70, 66, 262 en 262's regel).
  Dat staat alleen in de code, niet op het scherm. GEMETEN (`PlayCards.lua:33,37,45`).

**Automatische versheid-controle: die bestaat en werkt. GEMETEN** in
`docs/CONTENT_WATCH.md`.
- De wekelijkse "🃏 **Kaarten:**"-check is ingevoerd op **25 sep 2026** en draaide voor het eerst
  op **maandag 28 sep 2026** (regel 1372-1373).
- Uitkomst van die run (regel 1379-1410): **33 van de 40 specs gecontroleerd**, alle 33 "niets
  gedrift". Eén kleine afwijking: **1480 Devourer DH** (onze bron 17 aug, Icy Veins zelf 18 aug;
  tekst komt overeen, geen actiepunt). Eén open vraag: **255 Survival Hunter** — Icy Veins' eigen
  pagina toont nu "Jul 16, 2026" en patchlabel **12.0.7**, dus de bron is zelf niet 12.1; als open
  vraag gemeld, niet als kaartfout. **7 specs niet gecontroleerd (budget)**: 103, 104, 259, 260,
  261, 1467, 1473 — allemaal kaarten waarvan de bron alleen Method+Wowhead noemt.
- De wachter liep **vandaag 3 okt 2026** (twee ingangen, regel 1637 en 1647), maar de kaarten-check
  is maandag-only; sinds 28 sep is er geen maandag geweest. **Volgende kaarten-check: maandag
  5 okt 2026.** GEMETEN.
- AFGELEID: de versheid-controle is dus 5 dagen oud en in opzet goed, maar hij heeft **nog nooit
  alle 40 specs in één run gehaald** — 7 specs staan nu al een week op "niet bekeken", en die 7
  overlappen precies met de specs die alleen Method/Wowhead als bron hebben.

---

## 6. De zwakte van 17 sep — GEREPAREERD

**GEMETEN: het staat nu goed.** Bewijs, in deze volgorde:

1. De fout is letterlijk vastgelegd, `SurvivalPlan.lua:76-83`:
   > "🔴 17 SEP 2026 — THE DERIVATION BELOW WAS WRONG FOR ALL THIRTEEN CLASSES … Rob's Ret Paladin
   > card said 'keep this up, put it on BEFORE you pull' for Divine Shield and listed Blessing of
   > Sacrifice (ally-only) for when his own health drops."
   Oorzaak: `defensive_1` betekent "toets Z", niet "de kleine die je aanhoudt"; `priority` is
   toetsvolgorde en bij gelijkspel besliste het alfabet.
2. Het nieuwe veld bestaat en is het **enige** pad: `survival`, met `survivalOrder`, `survivalNote`,
   `survivalId`, `survivalSpecs` (`SurvivalPlan.lua:84-95`). "An untagged spell is simply not on the
   card. That is the point: every row is a judgement made per spell, with its source in the audit."
3. **Alle dertien klassen staan in `TAGGED`** (`SurvivalPlan.lua:96-110`). GEMETEN, letterlijk
   geteld: PALADIN, WARRIOR, DEATHKNIGHT, HUNTER, ROGUE, DEMONHUNTER, DRUID, MONK, SHAMAN, EVOKER,
   MAGE, WARLOCK, PRIEST.
4. `ns.GetSurvivalPlan` neemt daardoor altijd de tagged-tak (`SurvivalPlan.lua:464-467`). De oude
   afgeleide `PLAN`-tabel (`SurvivalPlan.lua:122-131`, inclusief de stap `hurts`) is **dode code**
   voor elke echte spelersklasse. GEMETEN. (Opruimkandidaat, geen bug.)
5. Het gedrag dat Rob zag is weg: `keepup` ("keep this up, before the pull and all fight long")
   bereikt nog maar **8 van de 40 specs**, en uitsluitend echte actieve-mitigatie- of
   barrière-knoppen (lijst in punt 4). Een noodknop als Divine Shield of Ice Block zit nu onder
   `big` ("save it for when your health drops fast"). GEMETEN, bv. `KeybindRoles_Mage.lua:91`
   (Ice Block → `survival = "big"`).
6. Ally-only spreuken zijn er bij naam uitgehaald, met reden: `KeybindRoles_Paladin.lua:41,72`
   ("Blessing of Sacrifice … NOT on the card: ally only"), `KeybindRoles_Priest.lua:64,112`
   (Power Word: Barrier), `KeybindRoles_DeathKnight.lua:43,77` (Anti-Magic Zone, "TWIJFEL"),
   `KeybindRoles_Shaman.lua:37-38`, `KeybindRoles_Evoker.lua:55`. GEMETEN.
7. Tweede reparatie, 27 sep: de kaart zet geen toets uit óns schema meer bij een spreuk, maar de
   toets waar hij **nu echt op staat** (`PlayCardWindow.lua:688-689`, Robs woorden: "niet waar we
   ze zouden moeten zetten volgens ons systeem"). GEMETEN.

**Wat er nog niet gemeten ís:** of de 136 tags per spreuk *spelinhoudelijk* juist zijn. Dat is
40 specs × audit en valt buiten deze ronde. Alle tags verwijzen naar
`docs/audit_2026-09-17/*` (niet gelezen — docs-regel). AFGELEID: de mechaniek is goed, de
inhoud is eenmalig nagekeken op 17 sep en sindsdien niet opnieuw.

---

## 7. Advies: het ene systeemgat, en twee losse vondsten

### 7a. Het gat: "wat druk ik voor mijn GROEP?" heeft geen tab — ONTWERPKEUZE met een rafelrand

De vier tabs delen de knoppen zo op (GEMETEN):

| soort knop | waar in het venster |
|---|---|
| schade / rotatie | tab 1 |
| eigen defensives, zelfheal, ontsnappen, **interrupt** | tab 2 |
| flasks, potions, food | tab 3 |
| dispels en purges | tab 4 |
| **groeps-/raid-cooldowns, ally-knoppen, taunts, CC** | **nergens** |

Bewijs dat dit bewust is, niet vergeten: elke klasse-header noemt zijn groeps-cooldowns bij naam
als "left OFF the card on purpose" (`KeybindRoles_Shaman.lua:37-38` Spirit Link / Healing Tide;
`KeybindRoles_Evoker.lua:55` Rewind / Dream Flight / Stasis; `KeybindRoles_Priest.lua:64`
Power Word: Barrier; `KeybindRoles_Paladin.lua:41` Blessing of Sacrifice). En CC is expliciet
geweigerd: `SurvivalPlan.lua:55-58` — "The same category holds Polymorph and Remove Curse, so
including it would put crowd control under 'stay alive' for every class. Four right rows beat seven
with two wrong ones." GEMETEN.

De regel is zelfs consistent: een groeps-cooldown komt er wél op als hij **jou óók** beschermt —
Rallying Cry (`KeybindRoles_Warrior.lua:69`, `survivalNote = "SURVIVAL_NOTE_GROUP"`), Darkness
(`KeybindRoles_DemonHunter.lua:107`), Blessing of Protection (`KeybindRoles_Paladin.lua:71`).
GEMETEN.

**Waarom het tóch een gat is, en geen keuze:** MH **heeft** die data al voor alle 40 specs, en het
venster laat er niets van zien.
- `ns.HEALER_COOLDOWNS` — 30 ingangen, 7 healer-specs (`HealerCooldowns.lua:99`)
- `ns.TANK_COOLDOWNS` — 6 tank-specs, waarvan 2 met `kind = "raid"` (`TankToolkit.lua:100,111`)
- `ns.DPS_COOLDOWNS` — 27 specs (`DpsToolkit.lua:36`)
- **Vereniging van die drie: 40 van 40 specs, geen enkele spec niet gedekt.** GEMETEN.
- `PlayCardWindow.lua` verwijst naar **geen** van die tien functies/tabellen. GEMETEN
  (tien keer gezocht, tien keer `False`).
- Ze worden alleen getekend in de Academy (`RoleAcademy.lua:498, 586, 715`). GEMETEN.

AFGELEID oordeel: dit is een **ontwerpkeuze die één stap te ver is doorgevoerd**. Tab 2 gaat over
jou, en groeps-cooldowns daar weglaten is juist. Maar `/mh play` is sinds 4.1.0 de opvallende gouden
voordeur (`PlayCardWindow.lua:1015-1017`) en Rob opende de Academy-versie juist niet omdat die "te
verstopt" was (`PlayCardWindow.lua:4`). Wie via de voordeur binnenkomt kan dus nergens vinden wat
hij voor zijn groep moet drukken, terwijl het antwoord al in de addon staat. Dat is dezelfde vorm
als de regel uit CLAUDE.md "zet de uitleg in dezelfde kamer als de knop".

Concreet voorstel (Robs keuze, niet de mijne): een vijfde tab **"For your group"** die
`GetHealerCooldowns` / `GetTankCooldowns` / `GetDpsCooldowns` tekent met dezelfde rij-opmaak, en
daarin ook de nu bij naam uitgesloten ally-knoppen (Blessing of Sacrifice, Power Word: Barrier,
Anti-Magic Zone, Spirit Link). Die horen niet op "Stay alive", maar ze horen wél ergens.

### 7b. Echte inconsistentie buiten de kaart: interrupt-macro's voor specs zonder interrupt

GEMETEN, twee MH-bestanden die elkaar tegenspreken:

| spec | `InterruptMacrosData.lua` | `KeybindRoles_*` (17 sep, met bron) |
|---|---|---|
| 105 Resto Druid | `DRUID[4] = "Skull Bash"` (regel 17) | Skull Bash = `specs = {103,104}` (`_Druid.lua:184`) |
| 1468 Pres Evoker | `EVOKER[2] = "Quell"` (regel 19) | "Preservation lost Quell in 12.0" (`_Evoker.lua:56,68-69`) |
| 270 Mistweaver | `MONK[3] = "Spear Hand Strike"` (regel 22) | "MW heeft geen kick", `specs = {268,269}` (`_Monk.lua:62,173`) |

Positieve controle dat mijn patroon werkt: dezelfde tabel geeft voor Priest terecht
`[1] = false, [2] = false` (Disc/Holy hebben geen kick) en dat klopt met
`_Priest.lua:34,181` (`Silence`, `specs = {258}`). GEMETEN.

Gevolg: de **Stay alive**-tab laat voor 105, 270 en 1468 terecht géén interrupt zien (klopt), maar
de interrupt-macro-pagina biedt die drie specs wél een macro voor een spreuk die ze niet hebben.
De kaarten zijn hier dus het juiste bestand en `InterruptMacrosData.lua` is achterhaald. Dit is
een **fout**, niet een keuze — één bestand, drie regels. Buiten de play-cards, wel in dezelfde
vraag ("mis ik een knop?").

### 7c. Wat ik NIET als gat beschouw (met bewijs)

- **Geen interrupt op tab 1.** Dat is de tabsplitsing, en 35 van de 40 specs hebben hun interrupt
  op tab 2. De 5 zonder zijn alle vijf correct: Disc/Holy Priest hebben geen kick, Mistweaver niet,
  Pres Evoker niet meer, Resto Druid niet. GEMETEN.
- **Geen `small` voor de drie Shamans.** De Shaman-header somt de kaart per stap op en laat `small`
  bewust leeg; wat eruit ging staat erbij met bron (`KeybindRoles_Shaman.lua:30-43`). GEMETEN dat
  het gedocumenteerd is; AFGELEID dat het spelinhoudelijk klopt.
- **Geen `heal` voor de drie Mages, Balance en Havoc.** Geen tekst die het tegenspreekt gevonden;
  AFGELEID plausibel, niet in de client nagemeten.
- **4 stappen voor Ret zonder "More enemies".** Bewuste `aoe = false`; Ret's AoE zit ín stap 2
  ("2 or more enemies: Divine Storm", `enUS.lua:911`). GEMETEN.

---

## Samenvatting voor de bouwchat

| # | bevinding | GEMETEN/AFGELEID | actie? |
|---|---|---|---|
| 1 | 40/40 specs hebben alle 4 tabs gevuld; 0 ontbrekende locale-keys | GEMETEN | nee |
| 2 | 4-5 genummerde regels is een vastgelegde regel ("eli10", "stays short") | GEMETEN | nee |
| 3 | de regels noemen 4-11 knoppen (gem. 7,2); hele kaart gem. 9,8 spell-id's | GEMETEN | nee |
| 4 | 17-sep-fout gerepareerd: `survival`-tag is het enige pad, alle 13 klassen TAGGED | GEMETEN | nee |
| 5 | oude `PLAN`-tabel in `SurvivalPlan.lua:122-131` is dode code | GEMETEN | opruimen (laag) |
| 6 | 20 van 40 kaarten hebben geen bron nieuwer dan 31 aug; 4 niets na 11 aug | GEMETEN | Rob kiest |
| 7 | versheid-wachter bestaat, liep 28 sep, haalde 33/40; 7 specs nooit bekeken | GEMETEN | volgende maandag 5 okt |
| 8 | groeps-/ally-cooldowns staan in geen enkele tab, maar de data dekt 40/40 specs | GEMETEN | 5e tab voorstellen |
| 9 | `InterruptMacrosData.lua` geeft 3 specs een interrupt die ze niet hebben | GEMETEN | fout, repareren |
| 10 | `ConsumablesWowheadData.lua:2` zegt "S1" terwijl de data S2 is | GEMETEN | cosmetisch |
