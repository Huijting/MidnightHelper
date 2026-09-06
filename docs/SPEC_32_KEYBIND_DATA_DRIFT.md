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

### 🔴 Losse vondst: toets `1` is leeg

In de 27 geplaatste spells zit **geen `1`**. De volgorde is `Shift+1` Swipe, `2` Mangle,
`3` Thrash, `4` Maul, `5` Moonfire — terwijl `Mangle` in de data op `main_rotation` **priority 1**
staat en dus de eerste builder-toets hoort te krijgen.

⚠️ **Dit is een waarneming, geen diagnose.** Er zijn twee onschuldige verklaringen (slot 1
gereserveerd voor Assisted Combat, of de allocator begint bewust op 2) en één vervelende (een
off-by-one in de builder-toewijzing). `0 did not fit`, dus er is niets weggevallen. **Uitzoeken
vóór je aan de tabel begint** — als de allocator een slot overslaat, verschuift het toevoegen van
Lunar Beam alleen maar meer.

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

## 6. Klaar als

- `Raze` en `Lunar Beam` staan in `Modules/KeybindRoles_Druid.lua`, met een `id` uit de client.
- `/mhautomap` op Robs Guardian meldt die twee **niet** meer onder `unclassified`.
- Wat er nog wél onder `unclassified` staat is opgeschreven, mét per naam of het een omissie is
  of bewust weggelaten.
- `tools/keybind_sheet/` is opnieuw gedraaid.
- De commit zegt eerlijk dat alleen Guardian gecontroleerd is.
- **Los daarvan, en alleen als er tijd over is:** de twee dode entries uit §2 weg.

---

## 7. Wat hier niet in staat, en waarom

Ik heb **niet** onderzocht of de andere twaalf `KeybindRoles_*`-bestanden hetzelfde gat hebben.
De laatste aanraking van vier ervan is `90fb048` (7 aug, één Mage-regel) en van Druid `11936c6`
(15 jul). Dat is een aanwijzing, geen bewijs — en §3 zegt waarom een echte controle alleen
personage voor personage kan.

Ook niet onderzocht: of Robs Guardian-talenten `Lunar Beam` en `Raze` daadwerkelijk bevatten.
Als hij de importstring uit de Method-gids gebruikt, dan wel; dat is de logische eerste
controle en het kost één `/mhautomap`.
