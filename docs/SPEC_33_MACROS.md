# Spec 33 — De macro-pagina bestaat al. Niemand vindt hem.

**Van:** ONDERZOEK-sessie, 7 sep 2026
**Voor:** BOUW-sessie
**Raakt:** `Modules/NavSearch.lua`, `Modules/CommandList.lua`, `Modules/TeamMacrosData.lua`
**Aanleiding:** Rob, na twee dagen waarin ik hem macro's uit externe gidsen doorgaf: *"moeten we
die ook niet in onze addon verwerken? met uitleg natuurlijk?"*

---

> **STATUS 10 sep 2026, avond.**
> - ✅ De macro's uit §3 (a, a2, b, c) en §4 (Cursor Traps op alle drie de hunter-specs) zijn gebouwd.
>   Daarbij kwam Mouseover Hunter's Mark, op Robs vraag.
> - ⛔ **Nog open:** §2a (zoekindex uit de data), §2b (`/mh macros`), §2c (verwijzing vanuit de
>   Tools-zaal) en §7 (de data tegen de 12.1-client leggen).
> - De actuele stand staat in `docs/NEXT_SESSION.md`.

## 1. Het ongemakkelijke antwoord

**Dat doen we al, en uitgebreider dan wat ik hem gaf.** GEMETEN:

| Bestand | Omvang | Wat erin zit |
|---|---|---|
| `Modules/TeamMacrosData.lua` | **676 regels** | alle 13 klassen, per spec-index, cursor-/mouseover-/focus-macro's — **elk met `descNl` én `descEn`** |
| `Modules/InterruptMacrosData.lua` | 65 regels | interrupt per klasse per spec, **gegenereerd** in een focus- én een mouseover-variant (`:33-34`) |

Van de vijf hunter-macro's die ik op 7 sep uit een externe gids doorgaf, stonden er **twee al in
voor Beast Mastery** (`smart_misdirection`, `turtle_cancel`, `TeamMacrosData.lua:210-227`) en een
derde onder een andere spec (zie §4b). Onze `Smart Misdirection` is bovendien **beter** dan die
van de gids: focus → **pet** als terugval, wat solo precies goed is, tegen focus → mouseover daar.

🔴 **Het probleem is dus niet dat het ontbreekt. Het is dat de maker van de addon het zelf niet
kon vinden.** Dat is dezelfde bevinding als `SPEC_31` §2, nu van binnenuit in plaats van op
CurseForge. Dit is de vierde keer dit jaar dat MH iets bleek te bevatten waar Rob om vroeg.

---

## 2. 🔴 De vindbaarheidsdefecten, gemeten

### a) Eén zoekregel, met drie woorden die niemand intypt
`Modules/NavSearch.lua:184` is de **enige** verwijzing naar macro's in de zoekindex:

```lua
tab("TAB_MACROS", "macros", "interrupt macro kick")
```

Dus `macro`, `interrupt` en `kick` vinden de pagina. **Niet gevonden** — en dit zijn de woorden
die iemand met een probleem daadwerkelijk typt:

`mouseover` · `focus` · `cursor` · `pet` · `taunt` · `trap` · `cancelaura` · `misdirection` ·
`dispel` · `heal` · `muisaanwijzer`

📌 De inhoud van `TeamMacrosData.lua` levert die woorden gratis: elke entry heeft al een `id`
(`mouseover_taunt`, `cursor_traps`), een `name` en twee beschrijvingen. **De zoekindex zou uit de
data opgebouwd moeten worden in plaats van uit één handgeschreven regel.**

### b) Er is geen `/mh macros`
GEMETEN met grep op `Core.lua`: alleen `macros = true` als tab-vlag (`:165`, `:538`, `:545`,
`:548`), **nergens een commando-routering**. Elke andere zaal heeft er een.

⚠️ Dit is exact hetzelfde patroon als `SPEC_31` §B2 (`/mh discord` en `/mh translate` bestonden
wel maar stonden niet in `ns.MH_COMMANDS`). Voeg het commando toe **en** zet het in
`ns.MH_COMMANDS`, anders is het meteen weer onvindbaar.

### c) De Tools-zaal noemt macro's niet
GEMETEN: geen treffer op `macro` in `Modules/ToolsLaunchpad.lua`. Zeven kaarten, geen ervan wijst
hierheen.

---

## 2b. ✅ De beschrijvingen zijn goed — dat is de lat, niet het probleem

Rob keek op 7 sep zelf naar de pagina en vroeg: *"worden ze goed beschreven wat ze doen?"*
Antwoord: **ja, en dat moet zo blijven.** Wat er nu staat bij de Focus-interruptmacro:

> *"Kicks your focus if it is a living enemy, otherwise your current target. Set the dangerous
> caster as focus once (`/focus`) and keep hitting your own target — this macro never changes or
> clears your focus."*
> *"Copy the text below into Esc > Macros > New. Then drag the macro icon to a spot on your
> action bar."*

Dat doet drie dingen goed en alle drie moeten ze terugkomen in nieuwe entries:
1. **wat hij doet**, in gewone taal;
2. **de val die hij wegneemt** — hier: dat hij je focus niet stilletjes verzet;
3. **hoe je hem gebruikt**, want een macro die je niet weet te plakken is nutteloos.

⛔ Een nieuwe entry zonder punt 2 hoort er niet in. Dat onderscheidt ons van een gids die alleen
de tekst afdrukt.

---

## 3. Wat er ontbreekt — vier macro's, en alle vier lossen ze een spec-eigenaardigheid op

📌 **Dat is het selectiecriterium.** Geen macro's toevoegen omdat ze bestaan, maar omdat ze een
val wegnemen die de speler anders zelf moet ontdekken. Dat is MH's lijn: niet de macro, het
waarom.

### a) 🔴 Beast Mastery — de pet-aanvalsmacro
Method (5 sep 2026) zegt dat een BM-hunter deze onder **elke** aanvalsspell hoort te zetten,
omdat het pet anders niet betrouwbaar meegaat.

```lua
{
id = "pet_attack_command",
name = "Kill Command + Pet Attack",
descNl = "Zorgt dat je pet meteen aanvalt. Zet de drie /use-regels onder élke aanvalsspell; ze dekken samen de aanvalsknop van elk pettype.",
descEn = "Makes your pet attack reliably. Put the three /use lines under every offensive spell; together they cover every pet family's attack.",
macro = [=[#showtooltip Kill Command
/cast Kill Command
/use [@pettarget]Claw
/use [@pettarget]Bite
/use [@pettarget]Smack]=],
},
```
Doel: `HUNTER = { [1] = { ... } }`.

### b) 🔴 Shadow Priest — niet je eigen channel afbreken
Void Torrent is een lange channel; zonder dit breek je hem af door de volgende knop in te
drukken.

```lua
{
id = "nochanneling_madness",
name = "Madness zonder Void Torrent te breken",
descNl = "Je kunt deze knop indrukken terwijl Void Torrent nog loopt: hij vuurt pas als de channel klaar is, in plaats van hem af te breken.",
descEn = "Press this while Void Torrent is still channelling: it fires when the channel ends instead of cancelling it.",
macro = [=[#showtooltip
/cast [nochanneling:void torrent, @mouseover,harm,nodead][nochanneling: Void Torrent] Shadow Word: Madness]=],
},
```
Doel: `PRIEST = { [3] = { ... } }` (Shadow is spec-index 3, zie
`InterruptMacrosData.lua:24`). Dezelfde vorm graag ook voor **Voidform** en **Mind Blast** — de
gids geeft alle drie.

### a2) Beast Mastery — mouseover Barbed Shot
Dots leggen zonder je huidige doel los te laten; in M+ de manier om een losse mob te pakken.

```lua
{
id = "mouseover_barbed",
name = "Mouseover Barbed Shot",
descNl = "Legt Barbed Shot op de vijand onder je muis, zonder je huidige doel los te laten. Valt terug op je doel als je nergens overheen staat.",
descEn = "Puts Barbed Shot on the enemy under your cursor without dropping your current target. Falls back to your target when the cursor is on nothing.",
macro = [=[#showtooltip Barbed Shot
/cast [@mouseover,harm,nodead][] Barbed Shot]=],
},
```
Doel: `HUNTER = { [1] = { ... } }`.

### c) Druide — muisaanwijzer-taunt
`mouseover_taunt` bestaat al voor Demon Hunter (`Torment`, `:86`), Monk (`Provoke`, `:340`) en
Paladin (`Hand of Reckoning`, `:407`). **Guardian heeft er geen.**

```lua
{
id = "mouseover_taunt",
name = "Mouseover Growl",
descNl = "Pak een vijand terug die je maat aanvalt, zonder je eigen doel los te laten.",
descEn = "Taunt whatever is attacking an ally without dropping your current target.",
macro = [=[#showtooltip Growl
/cast [@mouseover,harm,nodead][] Growl]=],
},
```
Doel: `DRUID = { [3] = { ... } }` (Guardian).

⚠️ **Controleer de spec-index per klasse tegen de client-volgorde** voordat je plakt.
`InterruptMacrosData.lua:14-28` heeft die volgorde al per klasse vastgelegd; gebruik die en
verzin er geen tweede.

---

## 4. Een tegenspraak tussen twee van onze eigen bestanden

`Cursor Traps` (`TeamMacrosData.lua:250-256`) staat onder `HUNTER = { [3] = ... }` — **Survival
alleen**.

Maar `Modules/KeybindRoles_Hunter.lua:91` zet `Freezing Trap` neer **zonder `specs`-veld**, wat
in dat bestand "baseline, alle specs" betekent (`:54-57` somt hem letterlijk op onder Baseline).

**Eén van de twee heeft ongelijk, en het is de macro-data.** Een BM-hunter heeft Freezing Trap
en krijgt de macro niet te zien. `cursor_traps` hoort bij `[1]`, `[2]` en `[3]`.

📌 Kijk bij die gelegenheid ook of `cursor_volley` (nu alleen `[2]`) en de andere spec-gebonden
entries kloppen. Deze is gevonden door toevallig twee bestanden naast elkaar te leggen; er
kunnen er meer zijn. **Een linter-regel die macro-spec-scoping tegen `KeybindRoles_*` legt, zou
dit machinaal vinden** — zelfde gedachte als de `id`-regel uit `SPEC_32` §5c.

---

## 5. ⛔ Wat NIET doen

1. **Geen macro's die iets voor de speler binden of aanmaken.** MH's lijn is dat de speler zelf
   plakt; `SPEC_31` en de keybind-koers ([[keybind-scheme-v7-direction]]) zeggen allebei dat de
   addon niets voor je instelt. Een knop "maak deze macro voor mij aan" is bovendien
   taint-gevoelig.
2. **De pagina niet vollen.** Elke toegevoegde macro moet een val wegnemen (§3). Een lijst van
   veertig varianten maakt de vindbaarheid slechter, niet beter.
3. **Geen `/run`-scripts overnemen.** De gids waar deze uit komen heeft er één; die kwam bij het
   ophalen met verminkte tekens binnen en een half overgetypt script doet onvoorspelbare dingen.
   Alleen `/cast`- en `/use`-vormen die we kunnen lezen.
4. **De bestaande `Smart Misdirection` niet vervangen** door de variant uit de gids. De onze valt
   terug op je pet, wat solo beter is. Dit is een geval waar wij het al beter deden.

---

## 6. Klaar als

- De zoekindex vindt de macro-pagina op `mouseover`, `cursor`, `focus`, `pet`, `trap` en `taunt`
  — bij voorkeur opgebouwd **uit** `TeamMacrosData.lua` in plaats van uit een handgeschreven
  regel.
- `/mh macros` bestaat **en** staat in `ns.MH_COMMANDS`.
- De drie macro's uit §3 staan erin, met beide beschrijvingen.
- `cursor_traps` staat op alle drie de hunter-specs.
- Rob vindt de pagina door "mouseover" in de zoekbalk te typen, zonder te weten dat er een
  macro-tab bestaat.

---

## 7. Wat hier niet in staat

Ik heb **niet** de hele 676 regels tegen de 12.1-client gelegd. Gezien wat `SPEC_32` opleverde —
drie klassen, drie hernoemde of vervangen knoppen — is de kans reëel dat er macro's tussen staan
die een spell noemen die niet meer bestaat. Dat is een eigen ronde waard, en `/mhautomap`'s
`scannedIds` is er het gereedschap voor: elke spellnaam in een macro zou in de spellbook van
iemand met die spec moeten voorkomen.
