# Spec 32 — De keybind-coach kent twee kernknoppen van Guardian niet

**Van:** ONDERZOEK-sessie, 6 sep 2026
**Voor:** BOUW-sessie
**Raakt:** `Modules/KeybindRoles_Druid.lua` (en waarschijnlijk de andere twaalf)
**Aanleiding:** Rob speelt zijn Guardian-druide weer en vroeg om de beste keybinds. Bij het
opzoeken bleek de data een gat te hebben.

---

## 1. Het defect, gemeten

`Raze` en `Lunar Beam` staan **niet** in `Modules/KeybindRoles_Druid.lua`, en ook niet in
`Modules/KeybindingData.lua`. GEMETEN met grep op beide bestanden: nul treffers.

Waarom dat erg is, volgens drie gidsen die het onderling eens zijn
([Method 3 sep](https://www.method.gg/guides/guardian-druid/playstyle-and-rotation),
[Icy Veins 10 aug](https://www.icy-veins.com/wow/guardian-druid-pve-tank-rotation-cooldowns-abilities),
[Maxroll 11 aug](https://maxroll.gg/wow/class-guides/guardian-druid-mythic-plus-guide)):

- **Lunar Beam** is in de Elune's Chosen-build — de build die álle drie aanraden — de
  **eerste regel van de prioriteitslijst**.
- **Raze** is de belangrijkste rage-spender.

De classifier koppelt op **naam** (`KeybindAutoMap.lua:135`, `BuildIdIndex` op `:186`). Een
spell die niet in de tabel staat wordt dus niet geclassificeerd, krijgt geen anker en geen
toets. Een terugkerende Guardian moet daardoor precies zijn twee belangrijkste knoppen zelf
uitzoeken — terwijl de coach zijn 1-2-3 keurig invult.

---

## 1b. 📊 GEMETEN op Robs Guardian, 6 sep 2026

`/mhautomap` + `/reload`, daarna `ns.db.autoMapDump` uit
`WTF/Account/JOEYWHATEVER/SavedVariables/MidnightHelper.lua` gelezen.

```
DRUID — Guardian: 27 placed, 0 did not fit, 16 unclassified.
```

**Alle ID's hieronder komen uit Robs eigen spellbook** (`dump.scannedIds`), niet van het web —
precies zoals §4 voorschrijft.

### Echt ontbrekend — toevoegen

| Spell | ID | Waarom het een toets verdient |
|---|---|---|
| 🔴 **Lunar Beam** | **204066** | regel 1 van de prioriteitslijst in de aanbevolen build |
| 🔴 **Heart of the Wild** | **1261867** | staat in Icy Veins' ST **én** AoE-lijst (*"Cast Heart of the Wild in Cat Form"*) |
| **Ursol's Vortex** | **102793** | CC/utility. 📌 Staat in het commentaar van dit bestand op regel 32, maar is nooit als entry toegevoegd |
| **Mark of the Wild** | **1126** | de klassenbuff |
| **Revive** | **50769** | out-of-combat rez |

⚠️ **`Raze` staat NIET in Robs spellbook** — hij heeft het talent niet. De omissie uit §1 blijft
dus staan als datagat, maar er is **geen ID uit de client** en die mag niet van het web komen.
Voeg hem toe zodra iemand hem getalenteerd heeft, of laat hem staan tot dan.

### ✅ Bevestigd géén defect

| Waarneming | Uitkomst |
|---|---|
| `Rage of the Sleeper` en `Renewal` | **NOT KNOWN in de spellbook** — daarmee is §2 geen redenering meer maar een meting. Ze matchen nooit |
| `Regrowth` (8936) staat als unclassified | **Met opzet.** De entry bestaat wél, maar op `specs = { 105 }` als `click_cast` (`:146`). Voor Guardian dus bewust geen toets |
| `Rake`, `Shred`, `Ferocious Bite`, `Wrath` | Feral/Balance-spells die een Guardian kent maar niet gebruikt |
| `Auto Attack`, `Revive Battle Pets`, `Teleport: Moonglade`, `Anomaly Detection Mark I`, `Find High-Value Beasts`, `Mechanism Bypass` | ruis: beroepen, speeltjes, Warband |

### 🔴→✅ INGETROKKEN: "toets 1 is leeg"

Een eerdere versie van deze spec meldde als mogelijke bug dat er geen `1` bij de 27 geplaatste
spells zat, met een off-by-one in de allocator als verdachte. **Dat was onterecht en is
teruggetrokken.**

`1` wordt **met opzet vrijgehouden** voor Blizzards Assisted Combat-knop
(`Modules/KeybindSchema.lua:490-491`, `:667`), gedetecteerd via
`C_ActionBar.IsAssistedCombatAction(slot)` (`:508-516`). En alléén de kale toets — vandaar dat
`Shift+1` (Swipe) wél gevuld is:

> `KeybindSchema.lua:845` — *"Only the BARE key is reserved. Rob asked for 'alleen de 1 knop'"*

Rob bevestigde het los daarvan zelf: *"1 is altijd voor single button assist"*. Het gedrag is
dus correct én het is precies wat hij gevraagd heeft. **Niets doen.**

📌 De les is de bekende: de uitvoer zag er fout uit omdat ik het ontwerp niet kende. Eén grep op
`reserved` in `KeybindSchema.lua` had de hele verdenking voorkomen. Zie
[[read-the-working-example-whole]].

### ⚠️ En "unclassified" betekent niet "de speler heeft geen toets"

Rob, 6 sep: *"lunar beam heb ik in een macro zitten, vandaar dat jij hem niet ziet"*.

Dat verandert niets aan het datagat — Lunar Beam hoort in de tabel, en zonder die entry kan de
coach er niets over zeggen. Maar het corrigeert wél de schade-inschatting uit §1: **hij zat niet
zonder knop.**

🔴 **En het legt iets structureels bloot.** De coach leest de spellbook en de actiebalken; wat
er ín een macro staat leest hij niet. Een speler die zijn halve rotatie in macro's heeft, krijgt
dus advies over knoppen die hij allang gebonden heeft. Dat is geen bug in deze spec, maar het is
wel de reden om de toon van de coach te controleren: **"deze staat nog nergens" is een bewering
die we niet kunnen waarmaken; "wij hebben hier geen plek voor" wel.** Apart uitzoeken waard.

---

## 1c. 🔴 Shadow Priest — een ECHTE regressie, en het bewijs voor de ID-migratie

`/mhautomap` + `/reload` op Robs shadow priest, 6 sep, **met Methods eigen Voidweaver
Delves-build geïmporteerd**:

```
PRIEST — Shadow: 19 placed, 0 did not fit, 17 unclassified.
```

### De regressie

```lua
-- KeybindRoles_Priest.lua:140
["Void Eruption"] = { role = "cooldown_bar", priority = 1, specs = { 258 } },
-- F1: burst-CD (castbare knop = Void Eruption 228260; "Voidform" 194249 is de
-- resulterende buff, dus naam-match faalde)
```

**Die aantekening van 7 aug heeft het omgedraaid.** GEMETEN, twee kanten:

1. Robs spellbook kent **`Voidform` = 228260** en kent **geen** `Void Eruption`.
2. Warcraft Wiki: *"Void Eruption was renamed to Voidform in Patch 12.0.0 to reduce confusion
   between the ability name and active effect."*

Het **ID in het commentaar klopt** (228260). Alleen de naam is hernoemd, en de lookup gaat op
naam. De entry matcht dus nooit meer.

🔴 **En het faalt stil.** Het slot bleef niet leeg: `Power Infusion` staat op `cooldown_bar`
**priority 2** en is stilletjes naar `F1` gepromoveerd. Het scherm ziet er dus correct uit
terwijl de grootste burst-knop van de spec nergens staat. Zie [[silence-is-not-absence]].

📌 **Dit is het argument voor §5a, en het is geen theorie meer.** Had die entry
`id = 228260` gedragen — een getal dat al in het commentaar op dezelfde regel stond — dan had
de hernoeming niets gebroken. De priester-entries hebben geen `id`, net als de druide.

**Fix:** `["Void Eruption"]` → `["Voidform"]`, mét `id = 228260`. En controleer meteen of
`Void Volley` (`:137`) hetzelfde probleem heeft.

### Verder ontbrekend — ID's uit Robs client

| Spell | ID | Opmerking |
|---|---|---|
| 🔴 **Tentacle Slam** | **1227280** | de AoE-motor: Method gebruikt hem om Vampiric Touch op 6-12 doelen te krijgen |
| **Vampiric Embrace** | **15286** | groepsheal-CD |
| **Shadowform** | **232698** | de stance zelf |
| **Dispel Magic** | **528** | ⚠️ we hebben wél `Mass Dispel` op X, maar de gewone dispel niet |
| **Purify Disease** | **213634** | idem |
| **Power Word: Fortitude** | **21562** | klassenbuff |
| **Shackle Horror** | **9484** | 📌 staat in het commentaar op `:25`, nooit als entry toegevoegd — zelfde patroon als Ursol's Vortex bij de druide |
| **Cantrips** | **255661** | onbekend wat dit in 12.1 doet; **niet blind toevoegen** |

### ✅ Wat GEEN gat is

`Void Volley`, `Void Blast`, `Halo` en `Void Eruption` staan als NOT KNOWN. Dat is **correct**:
Voidform verleent Void Volley pas tijdens Voidform (*"Voidform now grants 3 uses of Void
Volley"*, 12.1), en Halo hoort bij Archon terwijl Rob Voidweaver speelt.

⚠️ Een eerdere versie van deze meting concludeerde dat Rob "de build niet geïmporteerd had".
**Dat was fout** — hij had Methods Delves-build wél staan. De les: een spell die door een andere
spell verleend wordt, staat buiten gevecht niet in je spellbook, en dat lijkt op een ontbrekend
talent.

`Flash Heal`, `Resurrection`, `Mind Soothe`, `Mind Vision`, `Dominate Mind`: off-spec en
out-of-combat; ruis is `Auto Attack`, `Shoot`, `Revive Battle Pets`.

---

## 2. ⛔ Wat GEEN defect is — niet repareren wat niet stuk is

In hetzelfde bestand staan twee spells die **in 12.0.0 (20 jan 2026) uit het spel zijn
gehaald**:

| Regel | Entry | Status |
|---|---|---|
| `KeybindRoles_Druid.lua:116` | `Rage of the Sleeper` | verwijderd in 12.0.0 |
| `KeybindRoles_Druid.lua:175` | `Renewal` (`role = "heal_quick", priority = 1`) | verwijderd in 12.0.0 |

⚠️ **Die zijn inert, niet schadelijk.** De pijplijn loopt over de **live spellbook** heen
(`KeybindAutoMap.lua:146-178`) en zoekt élke gevonden spell op in de tabel — niet andersom. Een
tabelregel voor een spell die niet meer bestaat matcht dus nooit en kost niets.

📌 Dat geldt óók voor het griezelig uitziende geval: `Renewal` claimt `heal_quick` **priority 1**,
dus het F2-anker, en `Frenzied Regeneration` staat op priority 2. Omdat Renewal nooit in de
spellbook verschijnt, valt F2 gewoon aan Frenzied Regeneration toe. **Dit ziet eruit als een bug
en is er geen.** Opruimen mag, maar het is onderhoud, geen reparatie — en het hoort niet vóór §1.

🔴 De asymmetrie is het echte inzicht: **een spell die verdwijnt kost niets, een spell die
erbij komt kost een toets.** De audit van 15 jul (`dabc29d`, *"add ~13 verified missing core
abilities"*) was additief en heeft de dode regels laten staan — terecht dus. Maar sindsdien is
er niets meer bijgekomen, en Midnight heeft wél nieuwe knoppen gebracht.

---

## 3. 🎯 Het opsporingsgereedschap bestaat al

Niet zelf een audit verzinnen. `/mhautomap` (`Modules/KeybindAutoMap.lua:401`) print precies
het getal dat we nodig hebben (`:486-487`):

```
<class> — <spec>: N placed, M did not fit, K unclassified.
```

**`unclassified` is de lijst van dit defect.** Hij wordt opgebouwd op `:244`/`:267`, gesorteerd
op `:287` en volledig weggeschreven naar SavedVariables (`:422`), dus de namen zijn na een
`/reload` uit te lezen met `tools/_probe.py` — zie [[savedvariables-diagnostics]].

**Werkwijze per spec:**
1. Log in op het personage, sta in de spec die je wilt controleren.
2. `/mhautomap` → lees het getal achter `unclassified`.
3. `/reload`, dan de namenlijst uit SavedVariables halen.
4. Elke naam is óf een echte omissie, óf iets dat bewust geen toets hoort te krijgen. **Beide
   uitkomsten opschrijven**, anders wordt dezelfde naam over een maand opnieuw onderzocht.

⚠️ **Dit kan alleen op een personage dat Rob heeft.** 40 specs controleren gaat niet; doe
Guardian nu, en de rest zodra hij die spec toch speelt. Zeg dat eerlijk in de commit in plaats
van te suggereren dat de klasse is doorgelicht.

---

## 4. 🔴 Haal de spell-ID's NIET van het web

`Lunar Beam` en `Raze` hebben ID's nodig als je ze migreert (zie §5). Neem die **uit Robs eigen
spellbook**, niet van Wowhead.

Reden, uit ons eigen verleden: bij de Valeera-poisons waren de Wowhead-ID's **fout** en dat
kostte een meetronde op de PTR — zie [[valeera-s2-poisons]]. `/mhautomap` leest de ID's uit de
client en schrijft ze mee weg; dat is dezelfde run waarin je de namen toch al ophaalt.

Voor de rol-toewijzing zelf is er wél een bron, en die is eenduidig (drie gidsen, geen
tegenspraak):

| Spell | Voorstel | Waarom |
|---|---|---|
| `Lunar Beam` | `category = "cooldown"` óf `main_rotation` met hoge prioriteit | eerste regel van de prioriteitslijst in de aanbevolen build; hij hoort op een anker, niet op de overloop |
| `Raze` | `category = "spender"` | zelfde rol als `Maul`, die al op spender priority 3 staat |

⚠️ **Beide zijn talenten, geen baseline.** Ze verschijnen dus alleen in de spellbook als de
speler ze genomen heeft. Dat is precies waarom de spellbook-gedreven pijplijn het goede
antwoord geeft en een vaste lijst dat niet zou doen.

📌 En let op de spec-scoping: `Lunar Beam` hoort bij Guardian (104). Controleer of Balance (102)
hem óók kan hebben voordat je `specs = { 104 }` schrijft — dat is precies het soort aanname dat
we hier proberen te vermijden.

---

## 5. Twee dingen die aan dezelfde wijziging vastzitten

### a) De ID-migratie is nog niet gedaan voor Druid
`BuildIdIndex` (`KeybindAutoMap.lua:186-192`) matcht bij voorkeur op `r.id` en valt terug op
naam. Het commentaar op `:184-188` is expliciet: *"de live spellbook geeft gelokaliseerde NAMEN,
dus op een niet-Engelse game-client matcht alleen het ID (Paladin is de pilot)"*.

Geen enkele Druid-entry heeft een `id`. **Op een Duitse of Franse client krijgt een druïde dus
vermoedelijk helemaal niets geplaatst.** ⚠️ Dat is AFGELEID uit de code, **niet gemeten** — en
het is met [[locale-packs-gated-by-client]] ook niet door Rob te meten, want zijn client is
Engels. Als je de twee nieuwe entries toevoegt: geef ze meteen een `id`, dan groeit de migratie
mee in plaats van achter te lopen.

### b) Het cheat-sheet moet opnieuw gegenereerd
Uit [[keybind-cheatsheet]]: `tools/keybind_sheet/` bouwt het per-spec overzicht uit de v6-
allocator en **moet opnieuw draaien na elke wijziging in `KeybindRoles_*`**. Anders staat er een
sheet online die de twee nieuwe knoppen niet toont — precies het probleem dat deze spec oplost,
één laag verderop.

---

## 5c. 🔴 De prioriteit is omgedraaid sinds §1c

De ID-migratie uit §5a stond hier als "meeliften". **Dat klopt niet meer.** De Voidform-regressie
is er de eerste gemeten schade van: een hernoeming brak een lookup terwijl het juiste ID al op
dezelfde regel in het commentaar stond.

Blizzard hernoemt elke uitbreiding spells. Zolang de tabellen op naam matchen, breekt elke
hernoeming stil — en stil, want een lagere prioriteit schuift ongemerkt in het vrijgekomen slot.

**Voorstel:** doe de migratie voor de entries die je toch aanraakt (Druid 5, Priest 8), en
overweeg daarna een linter-regel: *elke entry met een spell-ID in het commentaar moet dat ID als
`id`-veld dragen.* Dat is machinaal te controleren en had dit geval gevangen.

---

## 6. Klaar als

- `Raze` en `Lunar Beam` staan in `Modules/KeybindRoles_Druid.lua`, met een `id` uit de client.
- `/mhautomap` op Robs Guardian meldt die twee **niet** meer onder `unclassified`.
- Wat er nog wél onder `unclassified` staat is opgeschreven, mét per naam of het een omissie is
  of bewust weggelaten.
- `tools/keybind_sheet/` is opnieuw gedraaid.
- De commit zegt eerlijk dat alleen Guardian gecontroleerd is.
- **Los daarvan, en alleen als er tijd over is:** de twee dode entries uit §2 weg.

---

## 6b. ✅ UITGEVOERD 6 sep 2026 — vijf entries, mét id

`Modules/KeybindRoles_Druid.lua`:

| Spell | id | Waar het heen ging | Toets op de sheet |
|---|---|---|---|
| Lunar Beam | 204066 | `cooldown` p1, `specs = { 104 }` | **F3** |
| Heart of the Wild | 1261867 | `cooldown` p3, `specs = { 104 }` | Shift+F3 |
| Ursol's Vortex | 102793 | `dispel_cc` p7, baseline | Ctrl-laag op V |
| Mark of the Wild | 1126 | `utility` p7, baseline | overloop |
| Revive | 50769 | `utility` p8, baseline | overloop |

📌 **De ID's zijn geverifieerd tegen `ns.db.autoMapDump.scannedIds` in Robs eigen
SavedVariables, mét positieve controle** (Mangle 33917 / Ironfur 192081 / Thrash 77758 in
dezelfde uitlezing). Eerste poging faalde: ik parste `[id] = "Naam"` terwijl het bestand
`["Naam"] = id` schrijft, en de controle ving dat — zie [[silence-is-not-absence]].

⚠️ **Revive staat NIET op `heal_ooc`/F3.** Die rol is de out-of-combat **self**-heal (Paladin
Lay on Hands, Monk Vivify, Evoker Living Flame); een rez is dat niet. Guardian houdt dus geen
self-heal op F3 — daar staat nu Lunar Beam.

📌 **F3 voor Lunar Beam is geen fout.** `KeybindSchema.lua:173` geeft de cooldown-categorie
`slots = { "F1", "F3", "F2" }` en basistoetsen gaan vóór Shift-lagen. F1 is bezet door het
`cooldown_bar`-anker (Berserk), dus priority 1 pakt de beste vrije basistoets. Incarnation
(p2) zakt daardoor naar Shift+F1 — dat ziet er omgekeerd uit en is het niet. Het schema
noemt deze ruil op `:163-171` zelf al: *"on a healer F3 is an out-of-combat heal, on most
others it is a cooldown."*

### Wat er ná deze wijziging nog onder `unmatched` staat, en waarom

Uit de dump, elf namen. **Geen enkele is een omissie** — hier opgeschreven zodat niemand ze
over een maand opnieuw onderzoekt:

| Naam | Waarom geen entry |
|---|---|
| `Ferocious Bite`, `Rake`, `Shred`, `Wrath` | Feral/Balance-spells; een Guardian kent ze maar gebruikt ze niet. Entries bestaan, op andere specs |
| `Regrowth` | entry bestaat op `specs = { 105 }` als `click_cast` — voor een tank bewust geen toets |
| `Auto Attack` | geen keybind-materiaal |
| `Teleport: Moonglade` | reis-spell, out-of-combat |
| `Revive Battle Pets` | pet battles |
| `Anomaly Detection Mark I`, `Find High-Value Beasts`, `Mechanism Bypass` | Warband-/beroepen-speelgoed |

⚠️ En twee die de addon wél matcht maar níét uit `KeybindRoles_Druid.lua` haalt, dus die
zoekt niemand daar: `Recuperate` (1231411, globale F4-slot) en `War Stomp` (20549, Tauren-
racial). Beide staan in de globale tabel en zijn bewust geen Druid-entry.

---

## 7. Wat hier niet in staat, en waarom

Ik heb **niet** onderzocht of de andere twaalf `KeybindRoles_*`-bestanden hetzelfde gat hebben.
De laatste aanraking van vier ervan is `90fb048` (7 aug, één Mage-regel) en van Druid `11936c6`
(15 jul). Dat is een aanwijzing, geen bewijs — en §3 zegt waarom een echte controle alleen
personage voor personage kan.

Ook niet onderzocht: of Robs Guardian-talenten `Lunar Beam` en `Raze` daadwerkelijk bevatten.
Als hij de importstring uit de Method-gids gebruikt, dan wel; dat is de logische eerste
controle en het kost één `/mhautomap`.
